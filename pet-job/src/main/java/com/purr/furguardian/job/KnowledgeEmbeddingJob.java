package com.purr.furguardian.job;

import com.purr.furguardian.knowledge.service.EmbeddingIngestionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class KnowledgeEmbeddingJob {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeEmbeddingJob.class);
    private static final String PLACEHOLDER_API_KEY = "your-dashscope-api-key";

    private final EmbeddingIngestionService embeddingIngestionService;
    private final String embeddingApiKey;

    public KnowledgeEmbeddingJob(EmbeddingIngestionService embeddingIngestionService,
                                 @Value("${langchain4j.community.dashscope.embedding-model.api-key:}") String embeddingApiKey) {
        this.embeddingIngestionService = embeddingIngestionService;
        this.embeddingApiKey = embeddingApiKey;
    }

    @Scheduled(cron = "${fur-guardian.job.embedding-ingest-cron:0 0 3 * * ?}")
    public void ingestKnowledgeEmbeddings() {
        if (embeddingApiKey.isBlank() || PLACEHOLDER_API_KEY.equals(embeddingApiKey)) {
            log.warn("跳过知识向量入库: embedding-model.api-key 仍是占位符，请在 application-local.yml 配置 DashScope Key");
            return;
        }

        log.info("开始执行知识向量入库任务...");
        int ingested = embeddingIngestionService.ingestAllUnembedded();
        log.info("知识向量入库任务完成: 本次新增{}条", ingested);
    }
}
