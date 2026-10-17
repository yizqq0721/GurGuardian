package com.purr.furguardian.knowledge.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.mapper.knowledge.KnowledgeDocMapper;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingSearchRequest;
import dev.langchain4j.store.embedding.EmbeddingSearchResult;
import dev.langchain4j.store.embedding.EmbeddingStore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class KnowledgeRetrievalService {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeRetrievalService.class);

    private final KnowledgeDocMapper knowledgeDocMapper;
    private final EmbeddingModel embeddingModel;
    private final EmbeddingStore<TextSegment> embeddingStore;

    public KnowledgeRetrievalService(KnowledgeDocMapper knowledgeDocMapper,
                                     EmbeddingModel embeddingModel,
                                     EmbeddingStore<TextSegment> embeddingStore) {
        this.knowledgeDocMapper = knowledgeDocMapper;
        this.embeddingModel = embeddingModel;
        this.embeddingStore = embeddingStore;
    }

    public List<KnowledgeDocDO> search(String query, String species, String lifeStage, int topN) {
        try {
            List<Long> candidateIds = getFilteredDocIds(species, lifeStage, topN * 3);

            Embedding queryEmbedding = embeddingModel.embed(query).content();

            EmbeddingSearchRequest request = EmbeddingSearchRequest.builder()
                    .queryEmbedding(queryEmbedding)
                    .maxResults(topN * 2)
                    .minScore(0.3)
                    .build();

            EmbeddingSearchResult<TextSegment> result = embeddingStore.search(request);

            Set<Long> candidateSet = Set.copyOf(candidateIds);
            List<KnowledgeDocDO> docs = new ArrayList<>();
            for (var match : result.matches()) {
                if (docs.size() >= topN) break;
                String docIdStr = match.embedded().metadata().getString("docId");
                if (docIdStr != null) {
                    try {
                        Long docId = Long.parseLong(docIdStr);
                        if (!candidateIds.isEmpty() && !candidateSet.contains(docId)) {
                            continue;
                        }
                        KnowledgeDocDO doc = knowledgeDocMapper.selectById(docId);
                        if (doc != null && "approved".equals(doc.getReviewStatus())) {
                            docs.add(doc);
                        }
                    } catch (NumberFormatException e) {
                        log.warn("Invalid docId in embedding metadata: {}", docIdStr);
                    }
                }
            }

            if (docs.isEmpty()) {
                return fallbackSqlSearch(query, species, lifeStage, topN);
            }
            return docs;
        } catch (Exception e) {
            log.warn("向量检索失败，降级为SQL检索: {}", e.getMessage());
            return fallbackSqlSearch(query, species, lifeStage, topN);
        }
    }

    public List<KnowledgeDocDO> fallbackSqlSearch(String query, String species, String lifeStage, int topN) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = buildFilteredWrapper(species, lifeStage);
        wrapper.last("LIMIT " + topN);
        return knowledgeDocMapper.selectList(wrapper);
    }

    public List<KnowledgeDocDO> selectTipCandidates(String species, String lifeStage,
                                                     List<Long> recentDocIds, int limit) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = buildFilteredWrapper(species, lifeStage);

        if (recentDocIds != null && !recentDocIds.isEmpty()) {
            wrapper.notIn(KnowledgeDocDO::getId, recentDocIds);
        }

        wrapper.last("LIMIT " + limit);
        return knowledgeDocMapper.selectList(wrapper);
    }

    public List<KnowledgeDocDO> getCuratedPool(String species, int limit) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeDocDO::getReviewStatus, "approved")
               .ne(KnowledgeDocDO::getSeverity, "emergency");

        if (species != null && !species.isEmpty()) {
            wrapper.and(w -> w.like(KnowledgeDocDO::getSpecies, species)
                              .or()
                              .isNull(KnowledgeDocDO::getSpecies)
                              .or()
                              .eq(KnowledgeDocDO::getSpecies, ""));
        }

        wrapper.last("LIMIT " + limit);
        return knowledgeDocMapper.selectList(wrapper);
    }

    private List<Long> getFilteredDocIds(String species, String lifeStage, int limit) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = buildFilteredWrapper(species, lifeStage);
        wrapper.select(KnowledgeDocDO::getId);
        wrapper.last("LIMIT " + limit);
        return knowledgeDocMapper.selectList(wrapper).stream()
                .map(KnowledgeDocDO::getId)
                .collect(Collectors.toList());
    }

    private LambdaQueryWrapper<KnowledgeDocDO> buildFilteredWrapper(String species, String lifeStage) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeDocDO::getReviewStatus, "approved")
               .ne(KnowledgeDocDO::getSeverity, "emergency");

        if (species != null && !species.isEmpty()) {
            wrapper.and(w -> w.like(KnowledgeDocDO::getSpecies, species)
                              .or()
                              .isNull(KnowledgeDocDO::getSpecies)
                              .or()
                              .eq(KnowledgeDocDO::getSpecies, ""));
        }

        if (lifeStage != null && !lifeStage.isEmpty()) {
            wrapper.and(w -> w.like(KnowledgeDocDO::getLifeStage, lifeStage)
                              .or()
                              .isNull(KnowledgeDocDO::getLifeStage)
                              .or()
                              .eq(KnowledgeDocDO::getLifeStage, ""));
        }

        return wrapper;
    }
}
