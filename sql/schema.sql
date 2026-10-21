-- ============================================================
-- FurGuardian 全量建表 SQL
-- 数据库: MySQL 8.0+  字符集: utf8mb4  排序规则: utf8mb4_general_ci
-- 设计: 后端1 (数据与算法线)
-- 日期: 2026-10-17
-- ============================================================

-- Windows 上的 mysql 客户端默认字符集常是 latin1(=cp1252)，直接 < 导入会把
-- UTF-8 中文逐字节误读成西欧字母，存进库就成了双重编码乱码。写在文件里最保险。
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS fur_guardian
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

USE fur_guardian;

-- -----------------------------------------------------------
-- 1. 用户表
-- -----------------------------------------------------------
CREATE TABLE users (
    id           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    username     VARCHAR(50)  NOT NULL COMMENT '登录账号',
    password     VARCHAR(100) NOT NULL COMMENT 'BCrypt密文',
    nickname     VARCHAR(50)  DEFAULT NULL COMMENT '展示名',
    avatar       VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    location     VARCHAR(64)  DEFAULT NULL COMMENT '常用城市(天气查询)',
    status       TINYINT      NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB COMMENT='用户表';

-- -----------------------------------------------------------
-- 2. 宠物表
-- -----------------------------------------------------------
CREATE TABLE pets (
    id              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id         BIGINT       NOT NULL COMMENT '所属用户',
    name            VARCHAR(50)  NOT NULL COMMENT '宠物昵称',
    species         VARCHAR(10)  NOT NULL COMMENT 'dog/cat',
    breed           VARCHAR(100) DEFAULT NULL COMMENT '品种',
    sex             VARCHAR(10)  NOT NULL COMMENT 'male/female',
    neutered        TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '是否绝育 0否 1是',
    birthday        DATE         DEFAULT NULL COMMENT '出生日期(精确到月)',
    activity_level  VARCHAR(20)  NOT NULL DEFAULT 'MODERATE' COMMENT 'SEDENTARY/LOW/MODERATE/HIGH/WORKING',
    bcs             TINYINT      DEFAULT 5 COMMENT '体况评分1-9',
    physiology      VARCHAR(20)  NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL/PREGNANT/LACTATING',
    avatar          VARCHAR(255) DEFAULT NULL COMMENT '宠物头像',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='宠物表';

-- -----------------------------------------------------------
-- 3. 体重时序记录
-- -----------------------------------------------------------
CREATE TABLE pet_weight_logs (
    id           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id       BIGINT        NOT NULL COMMENT '宠物ID',
    user_id      BIGINT        NOT NULL COMMENT '所属用户(数据隔离)',
    weight_kg    DECIMAL(5,1)  NOT NULL COMMENT '体重(kg)',
    bcs          TINYINT       DEFAULT NULL COMMENT '当时体况评分',
    recorded_at  DATE          NOT NULL COMMENT '记录日期',
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_date (pet_id, recorded_at),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='体重时序记录';

-- -----------------------------------------------------------
-- 4. 宠物档案扩展(过敏源、慢性病标签)
-- -----------------------------------------------------------
CREATE TABLE pet_profiles_ext (
    id              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id          BIGINT       NOT NULL COMMENT '宠物ID',
    user_id         BIGINT       NOT NULL COMMENT '所属用户',
    ideal_weight_kg DECIMAL(5,1) DEFAULT NULL COMMENT '理想体重(kg)',
    allergies       JSON         DEFAULT NULL COMMENT '过敏源列表',
    chronic_diseases JSON        DEFAULT NULL COMMENT '慢性病标签',
    dietary_notes   VARCHAR(500) DEFAULT NULL COMMENT '饮食备注',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_pet_id (pet_id),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='宠物档案扩展';

-- -----------------------------------------------------------
-- 5. 食品库
-- -----------------------------------------------------------
CREATE TABLE foods (
    id              BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id         BIGINT        DEFAULT NULL COMMENT '所属用户(NULL=公共已审核)',
    name            VARCHAR(100)  NOT NULL COMMENT '食品名称',
    brand           VARCHAR(100)  DEFAULT NULL COMMENT '品牌',
    food_type       VARCHAR(20)   NOT NULL DEFAULT 'DRY' COMMENT 'DRY/WET/FREEZE_DRIED/SNACK/CANNED/SUPPLEMENT',
    product_type    VARCHAR(20)   NOT NULL DEFAULT 'COMPLETE' COMMENT 'COMPLETE/COMPLEMENTARY/SNACK',
    life_stage      VARCHAR(20)   DEFAULT 'ADULT' COMMENT 'ALL/BABY/ADULT/SENIOR',
    species_scope   VARCHAR(20)   DEFAULT 'BOTH' COMMENT 'DOG/CAT/BOTH',
    labeled_me_kcal DECIMAL(8,2)  DEFAULT NULL COMMENT '标注代谢能(kcal/kg)',
    ingredients     TEXT          DEFAULT NULL COMMENT '原料组成(降序文本)',
    review_status   VARCHAR(20)   NOT NULL DEFAULT 'approved' COMMENT 'draft/approved/deprecated',
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_food_type (food_type)
) ENGINE=InnoDB COMMENT='食品库';

-- -----------------------------------------------------------
-- 6. 食品营养成分(保证分析值)
-- -----------------------------------------------------------
CREATE TABLE food_nutrients (
    id               BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    food_id          BIGINT        NOT NULL COMMENT '食品ID',
    moisture_max     DECIMAL(5,2)  DEFAULT NULL COMMENT '水分≤(%)',
    crude_protein_min DECIMAL(5,2) DEFAULT NULL COMMENT '粗蛋白质≥(%)',
    crude_fat_min    DECIMAL(5,2)  DEFAULT NULL COMMENT '粗脂肪≥(%)',
    crude_fat_max    DECIMAL(5,2)  DEFAULT NULL COMMENT '粗脂肪≤(低脂声称双限)',
    crude_fiber_max  DECIMAL(5,2)  DEFAULT NULL COMMENT '粗纤维≤(%)',
    ash_max          DECIMAL(5,2)  DEFAULT NULL COMMENT '粗灰分≤(%)',
    calcium_min      DECIMAL(5,3)  DEFAULT NULL COMMENT '钙≥(%)',
    phosphorus_min   DECIMAL(5,3)  DEFAULT NULL COMMENT '总磷≥(%)',
    chloride_min     DECIMAL(5,3)  DEFAULT NULL COMMENT '氯化物≥(%)',
    taurine_min      DECIMAL(5,3)  DEFAULT NULL COMMENT '牛磺酸≥(%,猫)',
    lysine_min       DECIMAL(5,3)  DEFAULT NULL COMMENT '赖氨酸≥(%,犬)',
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_food_id (food_id)
) ENGINE=InnoDB COMMENT='食品营养成分';

-- -----------------------------------------------------------
-- 7. 喂养方案
-- -----------------------------------------------------------
CREATE TABLE feeding_plans (
    id                BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id            BIGINT        NOT NULL COMMENT '宠物ID',
    user_id           BIGINT        NOT NULL COMMENT '所属用户',
    food_id           BIGINT        NOT NULL COMMENT '主粮ID',
    effective_date    DATE          NOT NULL COMMENT '生效日期',
    rer_kcal          DECIMAL(8,2)  NOT NULL COMMENT 'RER(kcal)',
    mer_kcal          DECIMAL(8,2)  NOT NULL COMMENT 'MER(kcal)',
    main_food_grams   DECIMAL(8,2)  NOT NULL COMMENT '主粮克数/天',
    snack_budget_kcal DECIMAL(8,2)  NOT NULL COMMENT '零食热量预算(kcal)',
    meals_per_day     TINYINT       NOT NULL DEFAULT 2 COMMENT '每日餐数',
    calculation_log   TEXT          NOT NULL COMMENT '计算过程(可解释性)',
    created_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_effective (pet_id, effective_date),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='喂养方案';

-- -----------------------------------------------------------
-- 8. 实际喂食记录
-- -----------------------------------------------------------
CREATE TABLE feeding_logs (
    id           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id       BIGINT        NOT NULL COMMENT '宠物ID',
    user_id      BIGINT        NOT NULL COMMENT '所属用户',
    food_id      BIGINT        NOT NULL COMMENT '食品ID',
    fed_date     DATE          NOT NULL COMMENT '喂食日期',
    meal_index   TINYINT       NOT NULL DEFAULT 1 COMMENT '第几餐',
    grams        DECIMAL(6,1)  NOT NULL COMMENT '实际克数',
    kcal         DECIMAL(8,2)  DEFAULT NULL COMMENT '实际热量(kcal)',
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_date (pet_id, fed_date),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='实际喂食记录';

-- -----------------------------------------------------------
-- 9. 提醒规则
-- -----------------------------------------------------------
CREATE TABLE reminders (
    id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id        BIGINT       NOT NULL COMMENT '宠物ID',
    user_id       BIGINT       NOT NULL COMMENT '所属用户',
    title         VARCHAR(100) NOT NULL COMMENT '提醒标题',
    reminder_type VARCHAR(30)  NOT NULL COMMENT 'FEED/WALK/WATER/GROOMING/DEWORM/VACCINE/BATH/CUSTOM',
    remind_time   TIME         DEFAULT NULL COMMENT '提醒时间(绝对)',
    relative_min  INT          DEFAULT NULL COMMENT '相对时间(分钟,如饭后30min)',
    remind_date   DATE         DEFAULT NULL COMMENT '计划日期(疫苗/驱虫等一次性事件)',
    repeat_rule   VARCHAR(50)  DEFAULT 'DAILY' COMMENT 'DAILY/WEEKLY/MONTHLY/YEARLY/ONCE',
    repeat_days   VARCHAR(20)  DEFAULT NULL COMMENT '重复日: 1,3,5 或 MON,WED,FRI',
    enabled       TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否启用',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_id (pet_id),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='提醒规则';

-- -----------------------------------------------------------
-- 10. 打卡记录
-- -----------------------------------------------------------
CREATE TABLE reminder_logs (
    id           BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    reminder_id  BIGINT   NOT NULL COMMENT '提醒规则ID',
    pet_id       BIGINT   NOT NULL COMMENT '宠物ID',
    user_id      BIGINT   NOT NULL COMMENT '所属用户',
    done_date    DATE     NOT NULL COMMENT '打卡日期',
    done_time    TIME     DEFAULT NULL COMMENT '实际完成时间',
    note         VARCHAR(255) DEFAULT NULL COMMENT '备注',
    created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    -- 一项提醒每天只能有一条打卡记录，接口幂等由此兜底
    UNIQUE KEY uk_reminder_date (reminder_id, done_date),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='打卡记录';

-- -----------------------------------------------------------
-- 11. 每日Tip
-- -----------------------------------------------------------
CREATE TABLE tips (
    id              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id          BIGINT       NOT NULL COMMENT '宠物ID',
    user_id         BIGINT       NOT NULL COMMENT '所属用户',
    tip_date        DATE         NOT NULL COMMENT 'Tip日期',
    content         TEXT         NOT NULL COMMENT 'Tip内容',
    source_doc_id   BIGINT       DEFAULT NULL COMMENT '来源知识条目ID',
    source_name     VARCHAR(200) DEFAULT NULL COMMENT '来源名称(可溯源)',
    feedback        TINYINT      DEFAULT NULL COMMENT '1点赞 0点踩 NULL未反馈',
    is_mock         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '是否降级兜底数据',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_date (pet_id, tip_date),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='每日Tip';

-- -----------------------------------------------------------
-- 12. 周报
-- -----------------------------------------------------------
CREATE TABLE weekly_reports (
    id                  BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    pet_id              BIGINT        NOT NULL COMMENT '宠物ID',
    user_id             BIGINT        NOT NULL COMMENT '所属用户',
    week_start          DATE          NOT NULL COMMENT '周起始日(周一)',
    week_end            DATE          NOT NULL COMMENT '周结束日(周日)',
    weight_start_kg     DECIMAL(5,1)  DEFAULT NULL COMMENT '周初体重',
    weight_end_kg       DECIMAL(5,1)  DEFAULT NULL COMMENT '周末体重',
    weight_change_pct   DECIMAL(5,2)  DEFAULT NULL COMMENT '体重环比(%)',
    bcs_start           TINYINT       DEFAULT NULL COMMENT '周初BCS',
    bcs_end             TINYINT       DEFAULT NULL COMMENT '周末BCS',
    feeding_compliance   DECIMAL(5,2) DEFAULT NULL COMMENT '喂养合规度(%)',
    snack_over_limit    TINYINT(1)    DEFAULT 0 COMMENT '零食是否超标',
    rule_conclusions    JSON          DEFAULT NULL COMMENT '规则引擎结构化结论(供后端2润色)',
    llm_summary         TEXT          DEFAULT NULL COMMENT 'LLM润色后的自然语言周报',
    status              VARCHAR(20)   NOT NULL DEFAULT 'draft' COMMENT 'draft/generated/polished',
    created_at          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_pet_week (pet_id, week_start),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='周报';

-- -----------------------------------------------------------
-- 13. 知识库文档(后端2建, 后端1评审)
-- -----------------------------------------------------------
CREATE TABLE knowledge_docs (
    id              BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    title           VARCHAR(200)  NOT NULL COMMENT '标题',
    content         TEXT          NOT NULL COMMENT '正文内容',
    species         VARCHAR(20)   DEFAULT NULL COMMENT '适用物种: dog/cat/both',
    life_stage      VARCHAR(50)   DEFAULT NULL COMMENT '适用生命阶段: baby,adult,senior(逗号分隔)',
    breed_tags      VARCHAR(200)  DEFAULT NULL COMMENT '品种标签(逗号分隔)',
    topics          VARCHAR(200)  NOT NULL COMMENT '主题标签(逗号分隔): 营养,护理,症状...',
    severity        VARCHAR(20)   NOT NULL DEFAULT 'informational' COMMENT 'informational/caution/emergency',
    source_name     VARCHAR(200)  DEFAULT NULL COMMENT '来源名称',
    source_type     VARCHAR(30)   DEFAULT NULL COMMENT 'standard/book/article/official',
    source_url      VARCHAR(500)  DEFAULT NULL COMMENT '来源URL',
    review_status   VARCHAR(20)   NOT NULL DEFAULT 'draft' COMMENT 'draft/approved/deprecated',
    embedding_id    VARCHAR(100)  DEFAULT NULL COMMENT 'Redis向量索引中的doc_id',
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_species_stage (species, life_stage),
    KEY idx_severity (severity),
    KEY idx_review_status (review_status),
    KEY idx_topics (topics(100))
) ENGINE=InnoDB COMMENT='知识库文档';

-- -----------------------------------------------------------
-- 14. 知识库问答会话
-- -----------------------------------------------------------
-- created_at/updated_at 用 DATETIME(3)：翻页游标取的是上一行的 created_at，
-- 精度只到秒的话，同一秒内的消息会被 "created_at < cursor" 整段跳过。
CREATE TABLE knowledge_chat_sessions (
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

-- -----------------------------------------------------------
-- 15. 知识库问答消息
-- -----------------------------------------------------------
CREATE TABLE knowledge_chat_messages (
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
