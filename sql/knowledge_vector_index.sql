-- ============================================================
-- Redis 8 Query Engine 向量索引创建脚本
-- 配合 LangChain4j RedisEmbeddingStore 使用
-- 执行方式: docker exec -it pet-redis redis-cli -a <password> < FT.CREATE ...
-- 或在 redis-cli 中直接执行
-- ============================================================

-- 创建向量索引 (LangChain4j RedisEmbeddingStore 自动管理，此处为手动创建参考)
-- 索引名需与 application.yml 中 langchain4j.community.redis.index-name 一致
-- 维度 1024 对应 text-embedding-v3 模型输出维度

-- FT.CREATE fur-guardian-embeddings ON JSON PREFIX 1 embed: SCHEMA $.vector AS vector VECTOR FLAT 6 TYPE FLOAT32 DIM 1024 DISTANCE_METRIC COSINE $.metadata AS metadata TEXT

-- 验证索引是否创建成功
-- FT._LIST
-- FT.INFO fur-guardian-embeddings

-- ============================================================
-- 注意: LangChain4j RedisEmbeddingStore 在首次 add() 时会自动创建索引
-- 如果自动创建失败，可手动执行上述 FT.CREATE 命令
-- ============================================================
