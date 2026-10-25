param(
    [string]$DbUser = 'fur',
    [string]$DbHost = '127.0.0.1',
    [int]$DbPort = 3307,
    [string]$DbName = 'fur_guardian'
)

$ErrorActionPreference = 'Stop'

$mysqlBin = 'C:\Program Files\MySQL\MySQL Server 9.7\bin'
$mysql = Join-Path $mysqlBin 'mysql.exe'
$dump = Join-Path $mysqlBin 'mysqldump.exe'
$repo = Split-Path $PSScriptRoot -Parent
$sql = Join-Path $PSScriptRoot 'seed-admin-user.sql'
$backupDir = Join-Path (Split-Path $repo -Parent) 'backups'
$backup = Join-Path $backupDir ('users-before-admin-{0}.sql' -f (Get-Date -Format 'yyyyMMdd-HHmmss'))

if (-not (Test-Path -LiteralPath $mysql)) { throw "mysql.exe not found: $mysql" }
if (-not (Test-Path -LiteralPath $dump)) { throw "mysqldump.exe not found: $dump" }
if (-not (Test-Path -LiteralPath $sql)) { throw "missing SQL: $sql" }
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$secure = Read-Host -AsSecureString "MySQL password for $DbUser@$DbHost`:$DbPort"
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
$plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

$env:MYSQL_PWD = $plain
try {
    Write-Host "==> Checking connection to $DbHost`:$DbPort"
    & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT 1;" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "login failed for '$DbUser'@$DbHost`:$DbPort" }

    Write-Host '==> Backing up users'
    $dumpArgs = @(
        '--default-character-set=utf8mb4',
        '--single-transaction',
        '--no-tablespaces',
        "--result-file=$backup",
        '-h', $DbHost,
        '-P', "$DbPort",
        '-u', $DbUser,
        $DbName,
        'users'
    )
    & $dump @dumpArgs
    if ($LASTEXITCODE -ne 0) { throw "mysqldump failed with exit code $LASTEXITCODE" }
    $backupItem = Get-Item -LiteralPath $backup -ErrorAction Stop
    if ($backupItem.Length -eq 0) { throw 'backup file is empty' }
    Write-Host ("    backup: {0} ({1:N0} bytes)" -f $backupItem.FullName, $backupItem.Length)

    Write-Host '==> Creating admin user'
    $proc = Start-Process -FilePath $mysql -ArgumentList @(
        '--default-character-set=utf8mb4',
        '-h', $DbHost,
        '-P', "$DbPort",
        '-u', $DbUser,
        $DbName
    ) -RedirectStandardInput $sql -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ne 0) { throw "admin seed failed (exit $($proc.ExitCode))" }

    $check = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT CONCAT(username, '|', status) FROM users WHERE username = 'admin';"
    if ($LASTEXITCODE -ne 0) { throw 'verification query failed' }
    if ("$check".Trim() -ne 'admin|1') { throw "unexpected admin row: $check" }

    Write-Host '==> OK: admin / admin is ready (status=1).'
    Write-Host "Backup kept at: $backup"
}
finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    $plain = $null
}
