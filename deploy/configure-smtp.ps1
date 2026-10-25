param(
    [string]$SmtpHost = 'smtp.qq.com',
    [int]$Port = 465,
    [string]$AppUrl = 'https://47.98.17.243',
    [string]$TestTo = '',
    [switch]$SkipJobCheck,
    [string]$SshHost = 'root@47.98.17.243',
    [string]$SshKey = (Join-Path $HOME '.ssh\fg_ecs')
)

$ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Read-Secret([string]$Prompt) {
    $secure = Read-Host -AsSecureString $Prompt
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

function Quote-Yaml([string]$Value) {
    return "'" + ($Value -replace "'", "''") + "'"
}

function Assert-Value([string]$Name, [string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) { throw "$Name is required." }
    if ($Value -match '[\r\n]') { throw "$Name must not contain line breaks." }
    if ($Value -match '[^\x20-\x7E]') { throw "$Name must be ASCII." }
}

if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) { throw 'ssh is not available in PATH.' }
if (-not (Test-Path -LiteralPath $SshKey)) { throw "SSH key not found: $SshKey" }
if ($Port -lt 1 -or $Port -gt 65535) { throw "Invalid port: $Port" }
Assert-Value 'SmtpHost' $SmtpHost
Assert-Value 'AppUrl' $AppUrl

$emailPattern = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
$username = (Read-Host 'SMTP account (full email address)').Trim()
if ($username -notmatch $emailPattern) { throw 'Invalid email address.' }
if ([string]::IsNullOrWhiteSpace($TestTo)) { $TestTo = $username } else { $TestTo = $TestTo.Trim() }
if ($TestTo -notmatch $emailPattern) { throw 'Invalid -TestTo address.' }

$password = $null
$yaml = $null
try {
    $password = (Read-Secret 'SMTP authorization code (not the email password)').Trim()
    Assert-Value 'SMTP authorization code' $password

    $props = if ($Port -eq 465) {
@'
          auth: true
          ssl:
            enable: true
'@
    } elseif ($Port -eq 587) {
@'
          auth: true
          starttls:
            enable: true
'@
    } else {
        '          auth: true'
    }

    $yaml = @"
spring:
  mail:
    host: $(Quote-Yaml $SmtpHost)
    port: $Port
    username: $(Quote-Yaml $username)
    password: $(Quote-Yaml $password)
    default-encoding: 'UTF-8'
    properties:
      mail:
        smtp:
$props
furguardian:
  mail:
    app-url: $(Quote-Yaml $AppUrl)
"@

    Write-Host '==> Uploading SMTP config (existing file is backed up)'
    $writeCmd = 'f=/opt/furguardian/app/application-smtp.yml; if [ -f "$f" ]; then cp -p "$f" "$f.bak-$(date +%Y%m%d-%H%M%S)"; fi; umask 077; cat > "$f.new"; test -s "$f.new"'
    $yaml | & ssh -i $SshKey -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new $SshHost $writeCmd
    if ($LASTEXITCODE -ne 0) { throw "Uploading the SMTP config failed (exit $LASTEXITCODE)." }

    $apply = @'
set -euo pipefail
APP=/opt/furguardian/app
F=$APP/application-smtp.yml
if ! grep -q '^spring:' "$F.new" || ! grep -q 'app-url:' "$F.new"; then
  echo "CONFIG_INVALID"
  exit 2
fi

if ! python3 - "$F.new" <<'PY'
import ssl, smtplib, sys, yaml
path = sys.argv[1]
test_to = '__TEST_TO__'
cfg = yaml.safe_load(open(path, encoding='utf-8'))
m = cfg['spring']['mail']
host = str(m['host'])
port = int(m['port'])
user = str(m['username'])
pwd = str(m['password'])
props = (((m.get('properties') or {}).get('mail') or {}).get('smtp') or {})
use_ssl = bool((props.get('ssl') or {}).get('enable'))
use_starttls = bool((props.get('starttls') or {}).get('enable'))
try:
    if use_ssl:
        server = smtplib.SMTP_SSL(host, port, timeout=25, context=ssl.create_default_context())
    else:
        server = smtplib.SMTP(host, port, timeout=25)
        server.ehlo()
        if use_starttls:
            server.starttls(context=ssl.create_default_context())
            server.ehlo()
    server.login(user, pwd)
    body = ("FurGuardian SMTP configuration test.\r\n\r\n"
            "If you received this email, the SMTP settings work. "
            "Reminder emails will now be sent to users who enable email reminders.\r\n")
    msg = ("From: %s\r\nTo: %s\r\nSubject: FurGuardian SMTP config test\r\n"
           "MIME-Version: 1.0\r\nContent-Type: text/plain; charset=UTF-8\r\n"
           "Content-Transfer-Encoding: 8bit\r\n\r\n%s") % (user, test_to, body)
    server.sendmail(user, [test_to], msg.encode('utf-8'))
    server.quit()
    print("SMTP_TEST_OK to=" + test_to)
except Exception as e:
    print("SMTP_TEST_FAILED " + type(e).__name__ + ": " + str(e)[:400])
    sys.exit(10)
PY
then
  rm -f "$F.new"
  echo "SMTP_TEST_FAILED_NOT_APPLIED"
  exit 10
fi

chmod 600 "$F.new"
mv -f "$F.new" "$F"

mkdir -p /etc/systemd/system/furguardian.service.d
DROPIN=/etc/systemd/system/furguardian.service.d/fg-extra-config.conf
if [ -f "$DROPIN" ]; then
  cp -p "$DROPIN" "$DROPIN.bak-$(date +%Y%m%d-%H%M%S)"
fi
cat > "$DROPIN" <<'EOF'
[Service]
Environment=SPRING_CONFIG_ADDITIONAL_LOCATION=optional:file:/opt/furguardian/app/application-oss.yml,optional:file:/opt/furguardian/app/application-smtp.yml
EOF
chmod 644 "$DROPIN"
systemctl daemon-reload
START=$(date '+%Y-%m-%d %H:%M:%S')
systemctl restart furguardian

HEALTHY=0
for i in $(seq 1 60); do
  CODE=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080/api/pets || true)
  if [ "$CODE" = "401" ] || [ "$CODE" = "200" ]; then HEALTHY=1; break; fi
  sleep 2
done
if [ "$HEALTHY" -ne 1 ]; then
  echo "BACKEND_NOT_HEALTHY"
  journalctl -u furguardian -n 40 --no-pager
  exit 3
fi

echo "SMTP_CONFIG_APPLIED"
if [ "__SKIP_JOB_CHECK__" = "0" ]; then
  echo "WAIT_FOR_SCAN: waiting for the next 5-minute scan (max ~5m20s)"
  now=$(date +%s)
  sleep $(( (300 - now % 300) + 20 ))
  J=$(journalctl -u furguardian --since "$START" --no-pager || true)
  MISSING=$(printf '%s' "$J" | grep -c 'spring.mail' || true)
  FAILED=$(printf '%s' "$J" | grep -c 'ReminderEmailJob.*error=' || true)
  TOTAL=$(printf '%s' "$J" | grep -c 'ReminderEmailJob.*userId=' || true)
  SENT=$(( TOTAL - FAILED ))
  echo "JOB_SCAN_CHECK missing_config=$MISSING failed=$FAILED sent=$SENT"
  if [ "$MISSING" -gt 0 ]; then
    echo "APP_MAIL_CONFIG_MISSING: the running app still sees no spring.mail config"
    exit 11
  fi
  if [ "$FAILED" -gt 0 ]; then
    printf '%s\n' "$J" | grep 'ReminderEmailJob.*error=' | tail -n 3
  fi
fi
echo "SMTP_OK"
'@

    $apply = $apply.Replace('__TEST_TO__', $TestTo)
    $apply = $apply.Replace('__SKIP_JOB_CHECK__', $(if ($SkipJobCheck) { '1' } else { '0' }))

    Write-Host '==> Testing SMTP credentials from the server'
    Write-Host '    (one test email will be sent to the configured address)'
    $output = $apply | & ssh -i $SshKey -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new $SshHost 'bash -s'
    $exit = $LASTEXITCODE
    $output | ForEach-Object { Write-Host "    $_" }
    if ($exit -ne 0) {
        if ($exit -eq 10) {
            throw 'SMTP test failed; the config was NOT applied and the temporary file was removed.'
        }
        throw "Applying the SMTP config failed (exit $exit)."
    }

    Write-Host ''
    Write-Host 'SMTP reminder email is configured.'
    Write-Host "From account: $username"
    Write-Host "A test email was sent to: $TestTo (check the inbox and spam folder)."
    if (-not $SkipJobCheck) {
        Write-Host 'The app-side scan check passed: the running backend no longer reports a missing spring.mail config.'
    }
}
finally {
    $password = $null
    $yaml = $null
}
