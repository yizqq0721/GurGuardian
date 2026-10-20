-- ============================================================
-- FurGuardian 演示种子数据
-- 账号: demo / demo123
-- 宠物: 一犬(贵宾犬) + 一猫(英短) + 各8周体重记录
-- ============================================================

-- 防止 Windows mysql 客户端按 latin1 读文件导致中文双重编码
SET NAMES utf8mb4;

USE fur_guardian;

-- 演示用户 (BCrypt encoded "demo123")
INSERT INTO users (username, password, nickname, status) VALUES
('demo', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '演示用户', 1);

SET @user_id = LAST_INSERT_ID();

-- 犬: 玩具贵宾, 成年3岁, 已绝育
INSERT INTO pets (user_id, name, species, breed, sex, neutered, birthday, activity_level, bcs, physiology) VALUES
(@user_id, '豆豆', 'dog', '玩具贵宾', 'male', 1, '2023-10-01', 'LOW', 5, 'NORMAL');

SET @dog_id = LAST_INSERT_ID();

-- 猫: 英国短毛猫, 成年2岁, 已绝育
INSERT INTO pets (user_id, name, species, breed, sex, neutered, birthday, activity_level, bcs, physiology) VALUES
(@user_id, '咪咪', 'cat', '英国短毛猫', 'female', 1, '2024-04-15', 'SEDENTARY', 5, 'NORMAL');

SET @cat_id = LAST_INSERT_ID();

-- 犬档案扩展
INSERT INTO pet_profiles_ext (pet_id, user_id, ideal_weight_kg, allergies, chronic_diseases) VALUES
(@dog_id, @user_id, 5.0, '["鸡肉"]', '[]');

-- 猫档案扩展
INSERT INTO pet_profiles_ext (pet_id, user_id, ideal_weight_kg, allergies, chronic_diseases) VALUES
(@cat_id, @user_id, 4.0, '[]', '[]');

-- 犬8周体重记录
INSERT INTO pet_weight_logs (pet_id, user_id, weight_kg, bcs, recorded_at) VALUES
(@dog_id, @user_id, 4.6, 5, DATE_SUB(CURDATE(), INTERVAL 8 WEEK)),
(@dog_id, @user_id, 4.7, 5, DATE_SUB(CURDATE(), INTERVAL 7 WEEK)),
(@dog_id, @user_id, 4.8, 5, DATE_SUB(CURDATE(), INTERVAL 6 WEEK)),
(@dog_id, @user_id, 4.7, 5, DATE_SUB(CURDATE(), INTERVAL 5 WEEK)),
(@dog_id, @user_id, 4.9, 5, DATE_SUB(CURDATE(), INTERVAL 4 WEEK)),
(@dog_id, @user_id, 5.0, 5, DATE_SUB(CURDATE(), INTERVAL 3 WEEK)),
(@dog_id, @user_id, 5.0, 5, DATE_SUB(CURDATE(), INTERVAL 2 WEEK)),
(@dog_id, @user_id, 5.1, 5, DATE_SUB(CURDATE(), INTERVAL 1 WEEK));

-- 猫8周体重记录
INSERT INTO pet_weight_logs (pet_id, user_id, weight_kg, bcs, recorded_at) VALUES
(@cat_id, @user_id, 3.8, 5, DATE_SUB(CURDATE(), INTERVAL 8 WEEK)),
(@cat_id, @user_id, 3.9, 5, DATE_SUB(CURDATE(), INTERVAL 7 WEEK)),
(@cat_id, @user_id, 4.0, 5, DATE_SUB(CURDATE(), INTERVAL 6 WEEK)),
(@cat_id, @user_id, 4.0, 5, DATE_SUB(CURDATE(), INTERVAL 5 WEEK)),
(@cat_id, @user_id, 4.1, 6, DATE_SUB(CURDATE(), INTERVAL 4 WEEK)),
(@cat_id, @user_id, 4.1, 6, DATE_SUB(CURDATE(), INTERVAL 3 WEEK)),
(@cat_id, @user_id, 4.2, 6, DATE_SUB(CURDATE(), INTERVAL 2 WEEK)),
(@cat_id, @user_id, 4.2, 6, DATE_SUB(CURDATE(), INTERVAL 1 WEEK));

-- 公共食品: 典型犬粮
INSERT INTO foods (user_id, name, brand, food_type, product_type, life_stage, species_scope, labeled_me_kcal, review_status) VALUES
(NULL, '皇家贵宾成犬粮', 'Royal Canin', 'DRY', 'COMPLETE', 'ADULT', 'DOG', 3650.00, 'approved'),
(NULL, '渴望六种鱼猫粮', 'Orijen', 'DRY', 'COMPLETE', 'ADULT', 'CAT', 3740.00, 'approved'),
(NULL, '麦富迪鸡肉冻干', 'McFudi', 'FREEZE_DRIED', 'SNACK', 'ALL', 'BOTH', 3800.00, 'approved');

SET @dog_food_id = (SELECT id FROM foods WHERE name = '皇家贵宾成犬粮' LIMIT 1);
SET @cat_food_id = (SELECT id FROM foods WHERE name = '渴望六种鱼猫粮' LIMIT 1);
SET @snack_food_id = (SELECT id FROM foods WHERE name = '麦富迪鸡肉冻干' LIMIT 1);

-- 犬粮营养成分
INSERT INTO food_nutrients (food_id, moisture_max, crude_protein_min, crude_fat_min, crude_fiber_max, ash_max, calcium_min, phosphorus_min) VALUES
(@dog_food_id, 10.00, 24.00, 13.00, 5.00, 8.00, 1.00, 0.80);

-- 猫粮营养成分
INSERT INTO food_nutrients (food_id, moisture_max, crude_protein_min, crude_fat_min, crude_fiber_max, ash_max, calcium_min, phosphorus_min, taurine_min) VALUES
(@cat_food_id, 10.00, 40.00, 18.00, 3.00, 8.00, 1.20, 1.00, 0.15);

-- 零食营养成分(仅标水分)
INSERT INTO food_nutrients (food_id, moisture_max) VALUES
(@snack_food_id, 8.00);

-- 犬提醒规则
INSERT INTO reminders (pet_id, user_id, title, reminder_type, remind_time, repeat_rule, enabled) VALUES
(@dog_id, @user_id, '早餐', 'FEED', '08:00', 'DAILY', 1),
(@dog_id, @user_id, '晚餐', 'FEED', '18:00', 'DAILY', 1),
(@dog_id, @user_id, '遛弯', 'WALK', '08:30', 'DAILY', 1),
(@dog_id, @user_id, '换水', 'WATER', '09:00', 'DAILY', 1);

-- 猫提醒规则
INSERT INTO reminders (pet_id, user_id, title, reminder_type, remind_time, repeat_rule, enabled) VALUES
(@cat_id, @user_id, '早餐', 'FEED', '07:30', 'DAILY', 1),
(@cat_id, @user_id, '晚餐', 'FEED', '18:30', 'DAILY', 1),
(@cat_id, @user_id, '铲屎', 'CUSTOM', '20:00', 'DAILY', 1);
