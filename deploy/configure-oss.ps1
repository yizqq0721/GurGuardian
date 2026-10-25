param(
    [string]$Endpoint = 'oss-cn-beijing.aliyuncs.com',
    [string]$Bucket = 'fur-guardian',
    [string]$PublicBaseUrl = '',
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

function Invoke-Ssh([string]$RemoteCommand) {
    & ssh -i $SshKey -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new $SshHost $RemoteCommand
    if ($LASTEXITCODE -ne 0) { throw "ssh command failed (exit $LASTEXITCODE)." }
}

if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) { throw 'ssh is not available in PATH.' }
if (-not (Test-Path -LiteralPath $SshKey)) { throw "SSH key not found: $SshKey" }

$Endpoint = $Endpoint.Trim()
$Bucket = $Bucket.Trim()
$PublicBaseUrl = $PublicBaseUrl.Trim()
Assert-Value 'Endpoint' $Endpoint
Assert-Value 'Bucket' $Bucket
if ($PublicBaseUrl -ne '') { Assert-Value 'PublicBaseUrl' $PublicBaseUrl }

$ak = $null
$sk = $null
$yaml = $null
try {
    $ak = (Read-Secret 'Aliyun AccessKey ID (LTAI...)').Trim()
    $sk = (Read-Secret 'Aliyun AccessKey Secret').Trim()
    Assert-Value 'AccessKey ID' $ak
    Assert-Value 'AccessKey Secret' $sk
    if ($ak.StartsWith('your-')) { throw 'That looks like a placeholder, not a real AccessKey ID.' }

    $yaml = @"
aliyun:
  oss:
    endpoint: $(Quote-Yaml $Endpoint)
    bucket: $(Quote-Yaml $Bucket)
    access-key-id: $(Quote-Yaml $ak)
    access-key-secret: $(Quote-Yaml $sk)
    public-base-url: $(Quote-Yaml $PublicBaseUrl)
"@

    Write-Host '==> Uploading OSS config (existing file is backed up)'
    $writeCmd = 'f=/opt/furguardian/app/application-oss.yml; if [ -f "$f" ]; then cp -p "$f" "$f.bak-$(date +%Y%m%d-%H%M%S)"; fi; umask 077; cat > "$f.new"; test -s "$f.new"'
    $yaml | & ssh -i $SshKey -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new $SshHost $writeCmd
    if ($LASTEXITCODE -ne 0) { throw "Uploading the OSS config failed (exit $LASTEXITCODE)." }

    $apply = @'
set -euo pipefail
APP=/opt/furguardian/app
F=$APP/application-oss.yml
if ! grep -q '^aliyun:' "$F.new" || ! grep -q 'access-key-id:' "$F.new"; then
  echo "CONFIG_INVALID"
  exit 2
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

LOGIN=$(curl -s -X POST http://127.0.0.1:8080/api/auth/login -H 'Content-Type: application/json' -d '{"username":"demo","password":"123456"}')
TOKEN=$(printf '%s' "$LOGIN" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("data") or {}).get("token") or "")')
if [ -z "$TOKEN" ]; then
  echo "DEMO_LOGIN_FAILED"
  exit 4
fi

printf '%s' 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==' | base64 -d > /tmp/fg-avatar-smoke.png
RESP=$(curl -s -H "Authorization: Bearer $TOKEN" -F 'file=@/tmp/fg-avatar-smoke.png;type=image/png' http://127.0.0.1:8080/api/upload/avatar)
rm -f /tmp/fg-avatar-smoke.png
URL=$(printf '%s' "$RESP" | python3 -c 'import sys,json;d=json.load(sys.stdin);print((d.get("data") or {}).get("url") or "")')
if [ -z "$URL" ]; then
  echo "UPLOAD_FAILED"
  printf '%s\n' "$RESP" | head -c 600
  echo
  journalctl -u furguardian -n 60 --no-pager | grep -E 'OssStorageService|OssConfig' | tail -n 5 || true
  exit 5
fi
echo "UPLOAD_URL=$URL"
PUBLIC=$(curl -s -o /dev/null -w '%{http_code}' "$URL" || true)
echo "PUBLIC_GET=$PUBLIC"
if [ "$PUBLIC" != "200" ]; then
  echo "PUBLIC_READ_FAILED"
  exit 6
fi
echo "OSS_OK"
'@

    Write-Host '==> Applying config and restarting backend'
    $output = $apply | & ssh -i $SshKey -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new $SshHost 'bash -s'
    $exit = $LASTEXITCODE
    $output | ForEach-Object { Write-Host "    $_" }
    if ($exit -ne 0) {
        if ("$output" -match 'PUBLIC_READ_FAILED') {
            throw 'Upload succeeded but the object is not publicly readable. Set the bucket ACL to public-read or configure a public CDN domain.'
        }
        throw "Applying the OSS config failed (exit $exit)."
    }

    $url = $output | Where-Object { $_ -like 'UPLOAD_URL=*' } | Select-Object -Last 1
    if ($url) { $url = $url.Substring('UPLOAD_URL='.Length) }
    Write-Host ''
    Write-Host 'OSS avatar upload is configured and verified.'
    Write-Host "Test object URL: $url"
    Write-Host 'Note: the test created one small object under pet-avatar/. It can be deleted in the OSS console.'
}
finally {
    $ak = $null
    $sk = $null
    $yaml = $null
}
