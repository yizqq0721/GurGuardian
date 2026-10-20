package com.purr.furguardian.knowledge.service;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.mapper.knowledge.KnowledgeDocMapper;
import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class EmbeddingIngestionService {

    private static final Logger log = LoggerFactory.getLogger(EmbeddingIngestionService.class);

    private final KnowledgeDocMapper knowledgeDocMapper;
    private final EmbeddingModel embeddingModel;
    private final EmbeddingStore<TextSegment> embeddingStore;

    public EmbeddingIngestionService(KnowledgeDocMapper knowledgeDocMapper,
                                     EmbeddingModel embeddingModel,
                                     EmbeddingStore<TextSegment> embeddingStore) {
        this.knowledgeDocMapper = knowledgeDocMapper;
        this.embeddingModel = embeddingModel;
        this.embeddingStore = embeddingStore;
    }

    public boolean ingestSingle(KnowledgeDocDO doc) {
        try {
            Map<String, String> metaMap = new HashMap<>();
            metaMap.put("docId", String.valueOf(doc.getId()));
            if (doc.getSpecies() != null) metaMap.put("species", doc.getSpecies());
            if (doc.getLifeStage() != null) metaMap.put("lifeStage", doc.getLifeStage());
            if (doc.getSeverity() != null) metaMap.put("severity", doc.getSeverity());

            TextSegment segment = TextSegment.from(
                    doc.getTitle() + "\n" + doc.getContent(),
                    Metadata.from(metaMap));

            Embedding embedding = embeddingModel.embed(segment).content();
            String embeddingId = embeddingStore.add(embedding, segment);

            doc.setEmbeddingId(embeddingId);
            knowledgeDocMapper.updateById(doc);

            log.info("知识条目入库成功: id={}, title={}", doc.getId(), doc.getTitle());
            return true;
        } catch (Exception e) {
            log.error("知识条目入库失败: id={}, error={}", doc.getId(), e.getMessage());
            return false;
        }
    }

    public int ingestBatch(List<Long> docIds) {
        int success = 0;
        for (Long docId : docIds) {
            KnowledgeDocDO doc = knowledgeDocMapper.selectById(docId);
            if (doc != null && doc.getEmbeddingId() == null && ingestSingle(doc)) {
                success++;
            }
        }
        log.info("批量入库完成: 总计{}条, 成功{}条", docIds.size(), success);
        return success;
    }

    public int ingestAllUnembedded() {
        List<KnowledgeDocDO> docs = knowledgeDocMapper.selectList(null);
        List<Long> unembeddedIds = docs.stream()
                .filter(d -> d.getEmbeddingId() == null)
                .map(KnowledgeDocDO::getId)
                .toList();

        if (unembeddedIds.isEmpty()) {
            log.info("没有待入库的知识条目");
            return 0;
        }

        return ingestBatch(unembeddedIds);
    }
}
