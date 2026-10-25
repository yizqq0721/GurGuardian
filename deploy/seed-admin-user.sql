-- 演示管理员账号：admin / admin（BCrypt strength 10）
-- 幂等：账号已存在时重置密码、昵称与启用状态
-- 登录后台后请尽快在数据库中更换密码
INSERT INTO users (username, password, nickname, status, created_at, updated_at)
VALUES ('admin', '$2a$10$Z/Xg5fCBKSx9OP4RzxZo9eYsNhMm1HuIGPJthq5rHKBQJvymL99Ru', '管理员', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
    password = '$2a$10$Z/Xg5fCBKSx9OP4RzxZo9eYsNhMm1HuIGPJthq5rHKBQJvymL99Ru',
    nickname = '管理员',
    status = 1,
    updated_at = NOW();
