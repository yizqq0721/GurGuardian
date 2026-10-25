param(
    [string]$DbUser = 'fur',
    [string]$DbHost = '127.0.0.1',
    [int]$DbPort = 3307,
    [string]$DbName = 'fur_guardian',
    [string]$MysqlBin = 'C:\Program Files\MySQL\MySQL Server 9.7\bin'
)

$ErrorActionPreference = 'Stop'

$mysql = Join-Path $MysqlBin 'mysql.exe'
$dump = Join-Path $MysqlBin 'mysqldump.exe'
$repo = Split-Path $PSScriptRoot -Parent
$backupDir = Join-Path (Split-Path $repo -Parent) 'backups'
$backup = Join-Path $backupDir ('tips-weekly-{0}.sql' -f (Get-Date -Format 'yyyyMMdd-HHmmss'))

if (-not (Test-Path -LiteralPath $mysql)) { throw "mysql.exe not found: $mysql (use -MysqlBin)" }
if (-not (Test-Path -LiteralPath $dump)) { throw "mysqldump.exe not found: $dump (use -MysqlBin)" }
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

    $indexQuery = @"
SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = '$DbName'
  AND ((TABLE_NAME = 'tips' AND INDEX_NAME IN ('idx_pet_date', 'uk_pet_tip_date'))
    OR (TABLE_NAME = 'weekly_reports' AND INDEX_NAME IN ('idx_pet_week', 'uk_pet_week')))
GROUP BY TABLE_NAME, INDEX_NAME, NON_UNIQUE
ORDER BY TABLE_NAME, INDEX_NAME;
"@
    $indexRows = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e $indexQuery
    if ($LASTEXITCODE -ne 0) { throw 'index inspection query failed' }

    $hasTipUk = @($indexRows | Where-Object { $_ -match "^tips\s+uk_pet_tip_date\s+0$" }).Count -gt 0
    $hasWeekUk = @($indexRows | Where-Object { $_ -match "^weekly_reports\s+uk_pet_week\s+0$" }).Count -gt 0
    if ($hasTipUk -and $hasWeekUk) {
        Write-Host '==> Unique keys already present; skipping backup and schema changes, verifying data.'
        $dupes = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT (SELECT COUNT(*) FROM (SELECT pet_id, tip_date FROM tips GROUP BY pet_id, tip_date HAVING COUNT(*) > 1) t) + (SELECT COUNT(*) FROM (SELECT pet_id, week_start FROM weekly_reports GROUP BY pet_id, week_start HAVING COUNT(*) > 1) w);"
        if ($LASTEXITCODE -ne 0) { throw 'duplicate verification query failed' }
        if ([int]$dupes -ne 0) { throw "duplicates still present: $dupes" }
        Write-Host '==> OK: unique keys exist and no duplicate rows.'
        return
    }

    Write-Host '==> Current indexes:'
    $indexRows | ForEach-Object { Write-Host "    $_" }

    Write-Host '==> Backing up tips + weekly_reports'
    $dumpArgs = @(
        '--default-character-set=utf8mb4',
        '--single-transaction',
        '--no-tablespaces',
        "--result-file=$backup",
        '-h', $DbHost,
        '-P', "$DbPort",
        '-u', $DbUser,
        $DbName,
        'tips',
        'weekly_reports'
    )
    & $dump @dumpArgs
    if ($LASTEXITCODE -ne 0) { throw "mysqldump failed with exit code $LASTEXITCODE" }
    $backupItem = Get-Item -LiteralPath $backup -ErrorAction Stop
    if ($backupItem.Length -eq 0) { throw 'backup file is empty' }
    Write-Host ("    backup: {0} ({1:N0} bytes)" -f $backupItem.FullName, $backupItem.Length)

    $statements = @"
DELETE t1 FROM tips t1
JOIN tips t2
  ON t1.pet_id = t2.pet_id
 AND t1.tip_date = t2.tip_date
 AND t1.id < t2.id;

DELETE t1 FROM weekly_reports t1
JOIN weekly_reports t2
  ON t1.pet_id = t2.pet_id
 AND t1.week_start = t2.week_start
 AND t1.id < t2.id;
"@
    Write-Host '==> Deduplicating tips + weekly_reports (keeping the newest row per group)'
    & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -e $statements
    if ($LASTEXITCODE -ne 0) { throw 'dedupe statements failed' }

    $tipIdx = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='$DbName' AND TABLE_NAME='tips' AND INDEX_NAME='idx_pet_date';"
    if ([int]$tipIdx -gt 0) {
        Write-Host '==> tips: dropping idx_pet_date, adding uk_pet_tip_date'
        & $mysql -h $DbHost -P $DbPort -u $DbUser $DbName -e "ALTER TABLE tips DROP INDEX idx_pet_date, ADD UNIQUE KEY uk_pet_tip_date (pet_id, tip_date);"
        if ($LASTEXITCODE -ne 0) { throw 'tips index change failed' }
    } elseif (-not $hasTipUk) {
        Write-Host '==> tips: adding uk_pet_tip_date'
        & $mysql -h $DbHost -P $DbPort -u $DbUser $DbName -e "ALTER TABLE tips ADD UNIQUE KEY uk_pet_tip_date (pet_id, tip_date);"
        if ($LASTEXITCODE -ne 0) { throw 'tips unique key add failed' }
    }

    $weekIdx = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='$DbName' AND TABLE_NAME='weekly_reports' AND INDEX_NAME='idx_pet_week';"
    if ([int]$weekIdx -gt 0) {
        Write-Host '==> weekly_reports: dropping idx_pet_week, adding uk_pet_week'
        & $mysql -h $DbHost -P $DbPort -u $DbUser $DbName -e "ALTER TABLE weekly_reports DROP INDEX idx_pet_week, ADD UNIQUE KEY uk_pet_week (pet_id, week_start);"
        if ($LASTEXITCODE -ne 0) { throw 'weekly_reports index change failed' }
    } elseif (-not $hasWeekUk) {
        Write-Host '==> weekly_reports: adding uk_pet_week'
        & $mysql -h $DbHost -P $DbPort -u $DbUser $DbName -e "ALTER TABLE weekly_reports ADD UNIQUE KEY uk_pet_week (pet_id, week_start);"
        if ($LASTEXITCODE -ne 0) { throw 'weekly_reports unique key add failed' }
    }

    $check = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT COUNT(*) FROM (SELECT TABLE_NAME, INDEX_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='$DbName' AND ((TABLE_NAME='tips' AND INDEX_NAME='uk_pet_tip_date') OR (TABLE_NAME='weekly_reports' AND INDEX_NAME='uk_pet_week')) GROUP BY TABLE_NAME, INDEX_NAME) k;"
    if ($LASTEXITCODE -ne 0) { throw 'index verification query failed' }
    if ([int]$check -ne 2) { throw "expected 2 unique keys, found $check" }

    $dupes = & $mysql --default-character-set=utf8mb4 -h $DbHost -P $DbPort -u $DbUser $DbName -N -e "SELECT (SELECT COUNT(*) FROM (SELECT pet_id, tip_date FROM tips GROUP BY pet_id, tip_date HAVING COUNT(*) > 1) t) + (SELECT COUNT(*) FROM (SELECT pet_id, week_start FROM weekly_reports GROUP BY pet_id, week_start HAVING COUNT(*) > 1) w);"
    if ($LASTEXITCODE -ne 0) { throw 'duplicate verification query failed' }
    if ([int]$dupes -ne 0) { throw "duplicates still present: $dupes" }

    Write-Host '==> OK: tips.uk_pet_tip_date and weekly_reports.uk_pet_week exist; no duplicates.'
    Write-Host "Backup kept at: $backup"
} finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    $plain = $null
}
