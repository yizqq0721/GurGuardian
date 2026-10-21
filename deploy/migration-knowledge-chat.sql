-- ============================================================
-- FurGuardian 知识库问答（会话历史）建表脚本
--
-- 用途： sql/schema.sql 里的 14/15 两张新表。
--       docker-entrypoint-initdb.d 只在 pet-mysql-data 卷为空时执行，
--       已有数据的库不会自动拿到新表，所以要对手工跑一次这个脚本。
--       全新部署（down -v 之后重新初始化）不需要执行。
--
-- 安全： 只有 CREATE TABLE IF NOT EXISTS，不碰任何已有表和行；
--       重复执行是空操作，可以直接对生产库跑。
--
-- 日期： 2026-10-19
-- ============================================================

SET NAMES utf8mb4;

USE fur_guardian;

-- 会话：updated_at 决定左栏排序，新消息必须由 Service 显式刷新它。
-- DATETIME(3) 是游标翻页的前提，精度到秒会让同一秒内的消息整段被跳过。
CREATE TABLE IF NOT EXISTS knowledge_chat_sessions (
    id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id        BIGINT       NOT NULL COMMENT '所属用户',
    title          VARCHAR(100) NOT NULL COMMENT '会话标题(首问前20字, 可重命名)',
    pet_id         BIGINT       DEFAULT NULL COMMENT '提问时选中的宠物(仅用于回溯上下文)',
    message_count  INT          NOT NULL DEFAULT 0 COMMENT '消息条数(冗余, 免聚合查询)',
    source_count   INT          NOT NULL DEFAULT 0 COMMENT '引用来源条数(冗余去重前累加)',
    created_at     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    KEY idx_user_updated (user_id, updated_at),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='知识库问答会话';

CREATE TABLE IF NOT EXISTS knowledge_chat_messages (
    id            BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
    session_id    BIGINT      NOT NULL COMMENT '会话ID',
    user_id       BIGINT      NOT NULL COMMENT '所属用户(冗余, 便于鉴权直查)',
    role          VARCHAR(10) NOT NULL COMMENT 'user/ai',
    content       TEXT        NOT NULL COMMENT '消息正文',
    sources_json  JSON        DEFAULT NULL COMMENT '引用来源快照 [{docId,title,sourceName}]',
    is_red_line   TINYINT(1)  NOT NULL DEFAULT 0 COMMENT '是否红线症状回答',
    is_fallback   TINYINT(1)  NOT NULL DEFAULT 0 COMMENT '是否LLM降级回答',
    created_at    DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    KEY idx_session_created (session_id, created_at),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='知识库问答消息';

-- 验收：应该返回两行，且 message_count / source_count 全为 0
SELECT table_name, table_comment
FROM information_schema.tables
WHERE table_schema = 'fur_guardian'
  AND table_name IN ('knowledge_chat_sessions', 'knowledge_chat_messages');
