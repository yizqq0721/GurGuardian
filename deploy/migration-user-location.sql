-- 2026-10-21 用户常用城市（遛弯天气按城市查询）
-- 影响：仅新增可空列，旧版后端不查询该列，可前后兼容。
-- 回滚：ALTER TABLE users DROP COLUMN location;
-- 备份：mysqldump -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian users > E:/华为云比赛/backups/users-20261021.sql
-- 执行：mysql -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian < deploy/migration-user-location.sql

SET @has_col := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'users'
    AND COLUMN_NAME = 'location'
);

SET @ddl := IF(
  @has_col = 0,
  'ALTER TABLE users ADD COLUMN location VARCHAR(64) NULL COMMENT ''常用城市(天气查询)'' AFTER avatar',
  'SELECT ''location already exists'' AS msg'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
