-- 2026-10-23 稳定性修复：为「每日 Tip」「周报」补唯一键
-- 说明：先删除历史重复数据（每个分组保留 id 最大的一条），再替换普通索引。
-- 执行时机：应用低峰期；执行前建议先备份 tips、weekly_reports 两张表。
-- 本脚本不会由应用自动执行。

-- 1. 每日 Tip：同一宠物同一天只保留一条
DELETE t1 FROM tips t1
JOIN tips t2
  ON t1.pet_id = t2.pet_id
 AND t1.tip_date = t2.tip_date
 AND t1.id < t2.id;

ALTER TABLE tips
    DROP INDEX idx_pet_date,
    ADD UNIQUE KEY uk_pet_tip_date (pet_id, tip_date);

-- 2. 周报：同一宠物同一周只保留一条
DELETE t1 FROM weekly_reports t1
JOIN weekly_reports t2
  ON t1.pet_id = t2.pet_id
 AND t1.week_start = t2.week_start
 AND t1.id < t2.id;

ALTER TABLE weekly_reports
    DROP INDEX idx_pet_week,
    ADD UNIQUE KEY uk_pet_week (pet_id, week_start);
