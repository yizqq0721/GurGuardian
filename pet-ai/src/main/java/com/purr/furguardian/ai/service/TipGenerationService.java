package com.purr.furguardian.ai.service;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.tip.TipDO;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.biz.service.TipService;
import com.purr.furguardian.knowledge.service.KnowledgeRetrievalService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
public class TipGenerationService {

    private static final Logger log = LoggerFactory.getLogger(TipGenerationService.class);
    private static final String TIP_CACHE_PREFIX = "tip:cache:";
    private static final long CACHE_TTL_HOURS = 12;

    private final PetService petService;
    private final TipService tipService;
    private final KnowledgeRetrievalService retrievalService;
    private final LlmService llmService;
    private final PromptTemplates promptTemplates;
    private final RedLineMatcher redLineMatcher;
    private final StringRedisTemplate redisTemplate;

    public TipGenerationService(PetService petService,
                                TipService tipService,
                                KnowledgeRetrievalService retrievalService,
                                LlmService llmService,
                                PromptTemplates promptTemplates,
                                RedLineMatcher redLineMatcher,
                                StringRedisTemplate redisTemplate) {
        this.petService = petService;
        this.tipService = tipService;
        this.retrievalService = retrievalService;
        this.llmService = llmService;
        this.promptTemplates = promptTemplates;
        this.redLineMatcher = redLineMatcher;
        this.redisTemplate = redisTemplate;
    }

    public SseEmitter generateTipStream(Long userId, Long petId, boolean mockMode) {
        SseEmitter emitter = new SseEmitter(60000L);

        CompletableFuture.runAsync(() -> {
            try {
                PetDO pet = petService.getPet(userId, petId);
                LocalDate today = LocalDate.now();

                TipDO cachedTip = tipService.getTodayTip(userId, petId, today);
                if (cachedTip != null) {
                    sendSseEvent(emitter, cachedTip.getContent(),
                            cachedTip.getSourceName(), cachedTip.getIsMock() == 1);
                    emitter.complete();
                    return;
                }

                String cacheKey = buildCacheKey(petId, today);
                String cachedContent = redisTemplate.opsForValue().get(cacheKey);
                if (cachedContent != null && !cachedContent.isEmpty()) {
                    sendSseEvent(emitter, cachedContent, "知识库精选", false);
                    emitter.complete();
                    return;
                }

                String species = pet.getSpecies();
                String lifeStage = determineLifeStage(pet);

                List<KnowledgeDocDO> candidates;
                if (mockMode) {
                    candidates = retrievalService.getCuratedPool(species, 3);
                } else {
                    String query = buildSearchQuery(pet);
                    candidates = retrievalService.search(query, species, lifeStage, 3);
                    if (candidates.isEmpty()) {
                        candidates = retrievalService.getCuratedPool(species, 3);
                    }
                }

                if (candidates.isEmpty()) {
                    sendSseEvent(emitter, "暂无适合的知识建议，请稍后再试。", null, false);
                    emitter.complete();
                    return;
                }

                String knowledgeRefs = formatKnowledgeRefs(candidates);
                String petSummary = buildPetSummary(pet);

                String tipContent;
                String sourceName;
                boolean isMock = false;

                if (mockMode) {
                    tipContent = buildFallbackTip(candidates, pet);
                    sourceName = candidates.get(0).getSourceName();
                    isMock = true;
                } else {
                    tipContent = llmService.chatWithTimeout(
                            promptTemplates.getTipSystemPrompt(),
                            promptTemplates.buildTipUserPrompt(petSummary, knowledgeRefs));

                    if (tipContent == null) {
                        tipContent = buildFallbackTip(candidates, pet);
                        sourceName = candidates.get(0).getSourceName();
                        isMock = true;
                    } else {
                        sourceName = candidates.stream()
                                .map(KnowledgeDocDO::getSourceName)
                                .collect(Collectors.joining("、"));
                    }
                }

                TipDO tip = new TipDO();
                tip.setPetId(petId);
                tip.setUserId(userId);
                tip.setTipDate(today);
                tip.setContent(tipContent);
                tip.setSourceDocId(candidates.get(0).getId());
                tip.setSourceName(sourceName);
                tip.setIsMock(isMock ? 1 : 0);
                tip.setCreatedAt(LocalDateTime.now());
                tipService.saveTip(tip);

                if (!isMock) {
                    redisTemplate.opsForValue().set(cacheKey, tipContent,
                            java.time.Duration.ofHours(CACHE_TTL_HOURS));
                }

                sendSseEvent(emitter, tipContent, sourceName, isMock);
                emitter.complete();

            } catch (Exception e) {
                log.error("Tip生成失败: userId={}, petId={}", userId, petId, e);
                try {
                    emitter.send(SseEmitter.event()
                            .name("error")
                            .data("生成建议时出现异常，请稍后重试"));
                } catch (IOException ignored) {
                }
                emitter.completeWithError(e);
            }
        }, CompletableFuture.completedFuture(null).defaultExecutor());

        return emitter;
    }

    public TipDO generateTipDirect(Long userId, Long petId, boolean mockMode) {
        PetDO pet = petService.getPet(userId, petId);
        LocalDate today = LocalDate.now();

        TipDO cachedTip = tipService.getTodayTip(userId, petId, today);
        if (cachedTip != null) {
            return cachedTip;
        }

        String species = pet.getSpecies();
        String lifeStage = determineLifeStage(pet);

        List<KnowledgeDocDO> candidates;
        if (mockMode) {
            candidates = retrievalService.getCuratedPool(species, 3);
        } else {
            String query = buildSearchQuery(pet);
            candidates = retrievalService.search(query, species, lifeStage, 3);
            if (candidates.isEmpty()) {
                candidates = retrievalService.getCuratedPool(species, 3);
            }
        }

        String tipContent;
        String sourceName;
        boolean isMock = false;

        if (candidates.isEmpty()) {
            tipContent = "暂无适合的知识建议，请稍后再试。";
            sourceName = null;
        } else if (mockMode) {
            tipContent = buildFallbackTip(candidates, pet);
            sourceName = candidates.get(0).getSourceName();
            isMock = true;
        } else {
            String knowledgeRefs = formatKnowledgeRefs(candidates);
            String petSummary = buildPetSummary(pet);
            tipContent = llmService.chatWithTimeout(
                    promptTemplates.getTipSystemPrompt(),
                    promptTemplates.buildTipUserPrompt(petSummary, knowledgeRefs));

            if (tipContent == null) {
                tipContent = buildFallbackTip(candidates, pet);
                sourceName = candidates.get(0).getSourceName();
                isMock = true;
            } else {
                sourceName = candidates.stream()
                        .map(KnowledgeDocDO::getSourceName)
                        .collect(Collectors.joining("、"));
            }
        }

        TipDO tip = new TipDO();
        tip.setPetId(petId);
        tip.setUserId(userId);
        tip.setTipDate(today);
        tip.setContent(tipContent);
        tip.setSourceDocId(candidates.isEmpty() ? null : candidates.get(0).getId());
        tip.setSourceName(sourceName);
        tip.setIsMock(isMock ? 1 : 0);
        tip.setCreatedAt(LocalDateTime.now());
        tipService.saveTip(tip);

        return tip;
    }

    private void sendSseEvent(SseEmitter emitter, String content, String source, boolean isMock)
            throws IOException {
        emitter.send(SseEmitter.event()
                .name("tip")
                .data("{\"content\":\"" + escapeJson(content) + "\"," +
                        "\"source\":\"" + escapeJson(source != null ? source : "") + "\"," +
                        "\"mock\":" + isMock + "}"));
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "");
    }

    private String buildSearchQuery(PetDO pet) {
        StringBuilder sb = new StringBuilder();
        sb.append(pet.getSpecies()).append(" ");
        if (pet.getBreed() != null) sb.append(pet.getBreed()).append(" ");
        sb.append(determineLifeStage(pet)).append(" ");
        sb.append("养宠建议 日常护理 营养");
        return sb.toString();
    }

    private String buildPetSummary(PetDO pet) {
        StringBuilder sb = new StringBuilder();
        sb.append("物种:").append(pet.getSpecies());
        if (pet.getBreed() != null) sb.append(", 品种:").append(pet.getBreed());
        sb.append(", 生命阶段:").append(determineLifeStage(pet));
        if (pet.getNeutered() != null && pet.getNeutered() == 1) sb.append(", 已绝育");
        if (pet.getBcs() != null) sb.append(", BCS:").append(pet.getBcs());
        return sb.toString();
    }

    private String determineLifeStage(PetDO pet) {
        if (pet.getBirthday() == null) return "adult";
        long months = java.time.temporal.ChronoUnit.MONTHS.between(pet.getBirthday(), LocalDate.now());
        if (months < 12) return "young";
        if (months >= 84) return "senior";
        return "adult";
    }

    private String formatKnowledgeRefs(List<KnowledgeDocDO> docs) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < docs.size(); i++) {
            KnowledgeDocDO doc = docs.get(i);
            sb.append(String.format("[%d] %s\n%s\n来源: %s\n\n",
                    i + 1, doc.getTitle(), doc.getContent(), doc.getSourceName()));
        }
        return sb.toString();
    }

    private String buildFallbackTip(List<KnowledgeDocDO> docs, PetDO pet) {
        KnowledgeDocDO primary = docs.get(0);
        return String.format("🐾 今日建议\n\n%s\n\n参考：%s\n\n" +
                        "以上建议仅供参考，不构成医疗建议。",
                primary.getContent(), primary.getSourceName());
    }

    private String buildCacheKey(Long petId, LocalDate date) {
        return TIP_CACHE_PREFIX + petId + ":" + date.format(DateTimeFormatter.ISO_LOCAL_DATE);
    }
}
