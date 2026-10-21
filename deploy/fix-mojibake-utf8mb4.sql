-- ============================================================
-- FurGuardian 双重编码（乱码）数据修复脚本
--
-- 症状： pets.name / knowledge_docs.title / users.nickname 等显示成
--       "æ¼”ç¤ºç”¨æˆ·" 这类西欧字母乱码。
--
-- 成因： 2026-10-17 23:04 那次种子数据导入用了 latin1 客户端字符集。
--       MySQL 的 latin1 实际就是 Windows-1252，于是 UTF-8 的 3 字节中文
--       被逐字节当成 3 个西欧字母存了下来（双重编码）。
--       应用侧 JDBC 是 `characterEncoding=UTF-8`，读写正常
--       （对照：foods id=4「张艺鑫」、tips.content 均为正确中文），
--       所以只需要修历史数据，不需要改连接配置。
--
-- 原理： CONVERT(CAST(CONVERT(v USING latin1) AS BINARY) USING utf8mb4)
--       第一步把误读的码点压回原始字节，第二步按 UTF-8 重新解码。
--
-- 安全： 每条 UPDATE 的 WHERE 带两道锁
--       1) fixed <> v        —— 只改真正会变的内容
--       2) 正向校验：把 fixed 的 UTF-8 字节再按 latin1 读一遍必须还原出 v，
--          证明这行确实只是「UTF-8 被 latin1 误读」一次。
--          正确中文（如「张艺鑫」）过不了这道校验，因此不会被误伤；
--          含 cp1252 之外字符（如顿号「、」）的行同样过不了，单独处理。
--
-- 用法： 先备份，再执行
--   mysqldump -h 127.0.0.1 -P 3307 -u fur -p --default-character-set=utf8mb4 \
--     --single-transaction --databases fur_guardian > backup-before-mojibake-fix.sql
--   mysql -h 127.0.0.1 -P 3307 -u fur -p --default-character-set=utf8mb4 \
--     fur_guardian < deploy/fix-mojibake-utf8mb4.sql
--
-- 执行后若 knowledge_docs 已有 embedding_id，需要清掉并重建 Redis 向量索引，
-- 让 KnowledgeEmbeddingJob 用正确文本重新入库（本次 80 条 embedding_id 全空，无需处理）。
-- ============================================================

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------- 1. 用户昵称 ----------
UPDATE users SET nickname = CONVERT(CAST(CONVERT(nickname USING latin1) AS BINARY) USING utf8mb4)
WHERE nickname IS NOT NULL
  AND CONVERT(CAST(CONVERT(nickname USING latin1) AS BINARY) USING utf8mb4) <> nickname
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(nickname USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = nickname;

-- ---------- 2. 宠物 ----------
UPDATE pets SET name = CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4)
WHERE CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) <> name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = name;

UPDATE pets SET breed = CONVERT(CAST(CONVERT(breed USING latin1) AS BINARY) USING utf8mb4)
WHERE breed IS NOT NULL
  AND CONVERT(CAST(CONVERT(breed USING latin1) AS BINARY) USING utf8mb4) <> breed
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(breed USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = breed;

-- ---------- 3. 提醒标题 ----------
UPDATE reminders SET title = CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4)
WHERE CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) <> title
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = title;

-- ---------- 4. 食品库 ----------
UPDATE foods SET name = CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4)
WHERE CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) <> name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = name;

UPDATE foods SET brand = CONVERT(CAST(CONVERT(brand USING latin1) AS BINARY) USING utf8mb4)
WHERE brand IS NOT NULL
  AND CONVERT(CAST(CONVERT(brand USING latin1) AS BINARY) USING utf8mb4) <> brand
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(brand USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = brand;

-- ---------- 5. 知识库 ----------
UPDATE knowledge_docs SET title = CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4)
WHERE CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) <> title
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = title;

UPDATE knowledge_docs SET content = CONVERT(CAST(CONVERT(content USING latin1) AS BINARY) USING utf8mb4)
WHERE CONVERT(CAST(CONVERT(content USING latin1) AS BINARY) USING utf8mb4) <> content
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(content USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = content;

UPDATE knowledge_docs SET topics = CONVERT(CAST(CONVERT(topics USING latin1) AS BINARY) USING utf8mb4)
WHERE topics IS NOT NULL
  AND CONVERT(CAST(CONVERT(topics USING latin1) AS BINARY) USING utf8mb4) <> topics
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(topics USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = topics;

UPDATE knowledge_docs SET breed_tags = CONVERT(CAST(CONVERT(breed_tags USING latin1) AS BINARY) USING utf8mb4)
WHERE breed_tags IS NOT NULL
  AND CONVERT(CAST(CONVERT(breed_tags USING latin1) AS BINARY) USING utf8mb4) <> breed_tags
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(breed_tags USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = breed_tags;

UPDATE knowledge_docs SET source_name = CONVERT(CAST(CONVERT(source_name USING latin1) AS BINARY) USING utf8mb4)
WHERE source_name IS NOT NULL
  AND CONVERT(CAST(CONVERT(source_name USING latin1) AS BINARY) USING utf8mb4) <> source_name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(source_name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = source_name;

-- ---------- 6. Tips 来源（含顿号，需占位符绕开 cp1252） ----------
-- tips.source_name 里混了顿号「、」(U+3001)，它不在 cp1252 里，直接转 latin1 会掉成 '?'。
-- 先把顿号换成 CHAR(1 USING utf8mb4) 占位（必须显式带 USING，否则 CHAR() 返回 binary
-- 会把 REPLACE 的结果变成二进制串，后面的 CONVERT 语义就错了），转完再换回来。
-- 注意：不要用 `source_name NOT LIKE CONCAT('%', CHAR(1 USING utf8mb4), '%')` 做前置检查，
-- 含 0x01 的字符串会被截断成 '%'，导致条件恒真/恒假；占位符安全性改成事先用
-- `HEX(source_name) LIKE '%01%'` 单独确认（当前库为 0 行）。
UPDATE tips SET source_name = REPLACE(
    CONVERT(CAST(CONVERT(REPLACE(source_name, '、', CHAR(1 USING utf8mb4)) USING latin1) AS BINARY) USING utf8mb4),
    CHAR(1 USING utf8mb4), '、')
WHERE source_name IS NOT NULL
  AND CONVERT(CAST(CONVERT(REPLACE(source_name, '、', CHAR(1 USING utf8mb4)) USING latin1) AS BINARY) USING utf8mb4)
      <> REPLACE(source_name, '、', CHAR(1 USING utf8mb4))
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(REPLACE(source_name, '、', CHAR(1 USING utf8mb4)) USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1)
      = REPLACE(source_name, '、', CHAR(1 USING utf8mb4));

COMMIT;

-- ---------- 7. 校验：以下每条都应返回 0 ----------
-- 不用 HEX 正则判断乱码：× ÷ · 这类合法的 Latin-1 字符也会被 'C3..' 命中，误报。
-- 直接用「还能被可逆还原」作为判据——只有真正的双重编码行才满足。
SELECT 'users.nickname' AS col, COUNT(*) AS remain FROM users WHERE nickname IS NOT NULL
  AND CONVERT(CAST(CONVERT(nickname USING latin1) AS BINARY) USING utf8mb4) <> nickname
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(nickname USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = nickname
UNION ALL SELECT 'pets.name', COUNT(*) FROM pets
  WHERE CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) <> name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = name
UNION ALL SELECT 'pets.breed', COUNT(*) FROM pets WHERE breed IS NOT NULL
  AND CONVERT(CAST(CONVERT(breed USING latin1) AS BINARY) USING utf8mb4) <> breed
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(breed USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = breed
UNION ALL SELECT 'reminders.title', COUNT(*) FROM reminders
  WHERE CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) <> title
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = title
UNION ALL SELECT 'foods.name', COUNT(*) FROM foods
  WHERE CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) <> name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = name
UNION ALL SELECT 'foods.brand', COUNT(*) FROM foods WHERE brand IS NOT NULL
  AND CONVERT(CAST(CONVERT(brand USING latin1) AS BINARY) USING utf8mb4) <> brand
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(brand USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = brand
UNION ALL SELECT 'kd.title', COUNT(*) FROM knowledge_docs
  WHERE CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) <> title
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(title USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = title
UNION ALL SELECT 'kd.content', COUNT(*) FROM knowledge_docs
  WHERE CONVERT(CAST(CONVERT(content USING latin1) AS BINARY) USING utf8mb4) <> content
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(content USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = content
UNION ALL SELECT 'kd.topics', COUNT(*) FROM knowledge_docs WHERE topics IS NOT NULL
  AND CONVERT(CAST(CONVERT(topics USING latin1) AS BINARY) USING utf8mb4) <> topics
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(topics USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = topics
UNION ALL SELECT 'kd.breed_tags', COUNT(*) FROM knowledge_docs WHERE breed_tags IS NOT NULL
  AND CONVERT(CAST(CONVERT(breed_tags USING latin1) AS BINARY) USING utf8mb4) <> breed_tags
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(breed_tags USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = breed_tags
UNION ALL SELECT 'kd.source_name', COUNT(*) FROM knowledge_docs WHERE source_name IS NOT NULL
  AND CONVERT(CAST(CONVERT(source_name USING latin1) AS BINARY) USING utf8mb4) <> source_name
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(source_name USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1) = source_name
UNION ALL SELECT 'tips.source_name', COUNT(*) FROM tips WHERE source_name IS NOT NULL
  AND CONVERT(CAST(CONVERT(REPLACE(source_name, '、', CHAR(1 USING utf8mb4)) USING latin1) AS BINARY) USING utf8mb4)
      <> REPLACE(source_name, '、', CHAR(1 USING utf8mb4))
  AND CONVERT(CAST(CONVERT(CAST(CONVERT(REPLACE(source_name, '、', CHAR(1 USING utf8mb4)) USING latin1) AS BINARY) USING utf8mb4) AS BINARY) USING latin1)
      = REPLACE(source_name, '、', CHAR(1 USING utf8mb4));

-- ---------- 8. 抽查 ----------
SELECT id, username, nickname FROM users;
SELECT id, name, breed FROM pets ORDER BY id;
SELECT id, name FROM foods ORDER BY id LIMIT 5;
SELECT id, title, LEFT(content, 40) AS content FROM knowledge_docs ORDER BY id LIMIT 5;
SELECT id, title FROM reminders ORDER BY id;
SELECT id, source_name FROM tips ORDER BY id LIMIT 2;
