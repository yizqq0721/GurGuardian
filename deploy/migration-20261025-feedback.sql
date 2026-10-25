-- 2026-10-25 知识库问答：AI 回答反馈
-- 背景：比赛要求「真实用户反馈」，问答页补上「有用 / 没用」按钮。
-- 影响：仅新增可空列，旧版后端不读该列，可前后兼容。
-- 回滚：ALTER TABLE knowledge_chat_messages DROP COLUMN feedback;
-- 备份：mysqldump -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian knowledge_chat_messages > E:/华为云比赛/backups/knowledge_chat_messages-20261025.sql
-- 执行：mysql -h 127.0.0.1 -P 3307 -u <user> -p fur_guardian < deploy/migration-20261025-feedback.sql

SET @has_col := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'knowledge_chat_messages'
    AND COLUMN_NAME = 'feedback'
);

SET @ddl := IF(
  @has_col = 0,
  'ALTER TABLE knowledge_chat_messages ADD COLUMN feedback TINYINT NULL COMMENT ''用户反馈 1=有用 0=没用 NULL=未评价'' AFTER is_fallback',
  'SELECT ''feedback already exists'' AS msg'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
