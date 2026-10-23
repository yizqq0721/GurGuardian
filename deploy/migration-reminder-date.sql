-- 2026-10-21 提醒支持计划日期
-- 背景：疫苗、驱虫等事件改为「用户指定日期」，不再走周期重复。
-- 影响：仅新增可空列，旧版后端的查询不包含该列，可前后兼容。
-- 回滚：ALTER TABLE reminders DROP COLUMN remind_date;
-- 备份：mysqldump -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian reminders > E:/华为云比赛/backups/reminders-20261021.sql
-- 执行：mysql -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian < deploy/migration-reminder-date.sql

SET @has_col := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'reminders'
    AND COLUMN_NAME = 'remind_date'
);

SET @ddl := IF(
  @has_col = 0,
  'ALTER TABLE reminders ADD COLUMN remind_date DATE NULL COMMENT ''计划日期(疫苗/驱虫等一次性事件)'' AFTER relative_min',
  'SELECT ''remind_date already exists'' AS msg'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
