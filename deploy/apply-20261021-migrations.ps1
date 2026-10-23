param(
    [string]$DbUser = 'root',
    [string]$DbHost = '127.0.0.1',
    [int]$DbPort = 3307,
    [string]$DbName = 'fur_guardian'
)

$ErrorActionPreference = 'Stop'

$mysqlBin = 'C:\Program Files\MySQL\MySQL Server 9.7\bin'
$mysql = Join-Path $mysqlBin 'mysql.exe'
$dump = Join-Path $mysqlBin 'mysqldump.exe'
$repo = $PSScriptRoot
$backupDir = Join-Path (Split-Path $repo -Parent) 'backups'
$backup = Join-Path $backupDir ('users-reminders-{0}.sql' -f (Get-Date -Format 'yyyyMMdd-HHmmss'))

if (-not (Test-Path -LiteralPath $mysql)) { throw "mysql.exe not found: $mysql" }
if (-not (Test-Path -LiteralPath $dump)) { throw "mysqldump.exe not found: $dump" }
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$secure = Read-Host -AsSecureString "MySQL password for $DbUser@$DbHost`:$DbPort"
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
$plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

$env:MYSQL_PWD = $plain
try {
    Write-Host "==> Backing up users + reminders"
    cmd /c "`"$dump`" --default-character-set=utf8mb4 --single-transaction --no-tablespaces -h $DbHost -P $DbPort -u $DbUser $DbName users reminders > `"$backup`""
    if ($LASTEXITCODE -ne 0) { throw "mysqldump failed with exit code $LASTEXITCODE" }
    $backupItem = Get-Item -LiteralPath $backup -ErrorAction Stop
    if ($backupItem.Length -eq 0) { throw 'backup file is empty' }
    Write-Host ("    backup: {0} ({1:N0} bytes)" -f $backupItem.FullName, $backupItem.Length)

    foreach ($name in @('migration-reminder-date.sql', 'migration-user-location.sql')) {
        $file = Join-Path (Join-Path $repo 'deploy') $name
        if (-not (Test-Path -LiteralPath $file)) { throw "missing migration: $file" }
        Write-Host "==> Applying $name"
        cmd /c "`"$mysql`" --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName < `"$file`""
        if ($LASTEXITCODE -ne 0) { throw "migration failed: $name (exit $LASTEXITCODE)" }
    }

    $check = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='$DbName' AND ((TABLE_NAME='reminders' AND COLUMN_NAME='remind_date') OR (TABLE_NAME='users' AND COLUMN_NAME='location'));"
    if ($LASTEXITCODE -ne 0) { throw 'column verification query failed' }
    if ([int]$check -ne 2) { throw "expected 2 new columns, found $check" }

    Write-Host '==> OK: reminders.remind_date and users.location both exist.'
    Write-Host "Backup kept at: $backup"

    Write-Host '==> Restarting backend on port 8080'
    $listeners = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
    if ($listeners) {
        $listeners | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object {
            Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue
        }
        Start-Sleep -Seconds 2
    }

    $java = (Get-Command java -ErrorAction Stop).Source
    $jar = Join-Path $repo 'pet-web\target\pet-web-0.0.1-SNAPSHOT.jar'
    if (-not (Test-Path -LiteralPath $jar)) { throw "new backend jar not found: $jar" }
    $configDir = (Join-Path $repo 'pet-web\src\main\resources') -replace '\\', '/'
    $logDir = Join-Path $repo 'logs'
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    Start-Process -FilePath $java `
        -ArgumentList @('-jar', $jar, "--spring.config.additional-location=file:$configDir/") `
        -WorkingDirectory $repo `
        -RedirectStandardOutput (Join-Path $logDir 'backend-8080.log') `
        -RedirectStandardError (Join-Path $logDir 'backend-8080.err.log') `
        -WindowStyle Hidden

    $up = $false
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Seconds 1
        if (Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue) {
            $up = $true
            break
        }
    }
    if (-not $up) { throw 'backend did not start; check logs\backend-8080.err.log' }
    Write-Host '==> Backend is up on http://127.0.0.1:8080'
    Write-Host 'Now open http://127.0.0.1:5173/profile to set your city.'
} finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    $plain = $null
}
