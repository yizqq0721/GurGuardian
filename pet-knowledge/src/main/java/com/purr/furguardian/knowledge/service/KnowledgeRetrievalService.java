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
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class KnowledgeRetrievalService {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeRetrievalService.class);
    private static final Pattern TOKEN_PATTERN = Pattern.compile("[\\u4e00-\\u9fa5]{2,}|[A-Za-z0-9]{2,}");
    private static final int MAX_KEYWORDS = 12;

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
            List<Long> candidateIds = getFilteredDocIds(species, lifeStage);

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

        List<String> keywords = extractKeywords(query);
        if (!keywords.isEmpty()) {
            wrapper.and(w -> {
                for (int i = 0; i < keywords.size(); i++) {
                    if (i > 0) {
                        w.or();
                    }
                    String keyword = keywords.get(i);
                    w.like(KnowledgeDocDO::getTitle, keyword)
                     .or().like(KnowledgeDocDO::getContent, keyword)
                     .or().like(KnowledgeDocDO::getTopics, keyword);
                }
            });
        }

        wrapper.last("LIMIT " + topN);
        return knowledgeDocMapper.selectList(wrapper);
    }

    /**
     * 项目没有分词器，中文长串按双字滑窗切。降级路径优先保召回，噪声词由 OR 匹配容忍。
     */
    private List<String> extractKeywords(String query) {
        if (query == null || query.isBlank()) {
            return List.of();
        }

        Set<String> keywords = new LinkedHashSet<>();
        Matcher matcher = TOKEN_PATTERN.matcher(query);
        while (matcher.find() && keywords.size() < MAX_KEYWORDS) {
            String token = matcher.group();
            if (token.charAt(0) < 128 || token.length() <= 2) {
                keywords.add(token);
                continue;
            }
            for (int i = 0; i + 2 <= token.length() && keywords.size() < MAX_KEYWORDS; i++) {
                keywords.add(token.substring(i, i + 2));
            }
        }
        return List.copyOf(keywords);
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

    // 不能加 LIMIT：候选集是向量结果的白名单，按主键截断会把语义命中但 id 靠后的条目全部丢弃
    private List<Long> getFilteredDocIds(String species, String lifeStage) {
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = buildFilteredWrapper(species, lifeStage);
        wrapper.select(KnowledgeDocDO::getId);
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
