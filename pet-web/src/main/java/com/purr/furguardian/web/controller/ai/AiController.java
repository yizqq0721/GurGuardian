package com.purr.furguardian.web.controller.ai;

import com.purr.furguardian.ai.service.LlmService;
import com.purr.furguardian.ai.service.RedLineMatcher;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.knowledge.service.KnowledgeRetrievalService;
import com.purr.furguardian.web.dto.ai.AiQueryDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ai")
@Tag(name = "AI问答")
public class AiController {

    private final KnowledgeRetrievalService retrievalService;
    private final LlmService llmService;
    private final PetService petService;
    private final RedLineMatcher redLineMatcher;

    public AiController(KnowledgeRetrievalService retrievalService,
                        LlmService llmService,
                        PetService petService,
                        RedLineMatcher redLineMatcher) {
        this.retrievalService = retrievalService;
        this.llmService = llmService;
        this.petService = petService;
        this.redLineMatcher = redLineMatcher;
    }

    @PostMapping("/query")
    @Operation(summary = "AI知识问答",
               description = "基于知识库的AI问答，先检索再生成")
    public Result<AiResponse> query(@RequestBody AiQueryDTO dto) {
        Long userId = UserContext.getUserId();

        if (redLineMatcher.matchRedLine(dto.getQuery())) {
            return Result.ok(new AiResponse(
                    redLineMatcher.getRedLineResponse(),
                    List.of(), true));
        }

        PetDO pet = petService.getPet(userId, dto.getPetId());
        String species = pet.getSpecies();
        String lifeStage = determineLifeStage(pet);

        List<KnowledgeDocDO> docs = retrievalService.search(
                dto.getQuery(), species, lifeStage, 5);

        if (docs.isEmpty()) {
            return Result.ok(new AiResponse(
                    "抱歉，暂时没有找到与您问题相关的知识。建议咨询专业兽医获取更准确的建议。\n\n以上建议仅供参考，不构成医疗建议。",
                    List.of(), false));
        }

        String refs = docs.stream()
                .map(d -> String.format("[%s] %s\n%s\n来源: %s",
                        d.getId(), d.getTitle(), d.getContent(), d.getSourceName()))
                .collect(Collectors.joining("\n\n"));

        String systemPrompt = """
                你是FurGuardian养宠科普助手。基于下方【参考资料】回答用户问题。
                规则：
                1. 只使用参考资料中的信息，不补充资料中没有的内容
                2. 口语化、易懂，200字以内
                3. 结尾标注参考来源
                4. 禁止使用"诊断""处方""治疗""确诊"等医疗术语
                5. 末尾附加免责声明
                """;

        String userPrompt = """
                【参考资料】
                %s

                【宠物信息】%s %s
                【用户问题】%s
                """.formatted(refs, pet.getSpecies(), pet.getBreed(), dto.getQuery());

        String answer = llmService.chatWithTimeout(systemPrompt, userPrompt);

        if (answer == null) {
            String fallback = docs.stream()
                    .limit(2)
                    .map(d -> "• " + d.getTitle() + "：" + d.getContent())
                    .collect(Collectors.joining("\n\n"));
            return Result.ok(new AiResponse(
                    "以下是相关知识条目，供您参考：\n\n" + fallback +
                            "\n\n以上建议仅供参考，不构成医疗建议。",
                    docs.stream().map(d -> new SourceRef(d.getId(), d.getTitle(), d.getSourceName()))
                            .collect(Collectors.toList()),
                    true));
        }

        List<SourceRef> sources = docs.stream()
                .map(d -> new SourceRef(d.getId(), d.getTitle(), d.getSourceName()))
                .collect(Collectors.toList());

        return Result.ok(new AiResponse(answer, sources, false));
    }

    @GetMapping("/search")
    @Operation(summary = "知识库检索", description = "仅检索不生成，返回相关知识条目")
    public Result<List<KnowledgeDocDO>> search(
            @RequestParam String query,
            @RequestParam(required = false) String species,
            @RequestParam(required = false) String lifeStage,
            @RequestParam(defaultValue = "5") int topN) {
        return Result.ok(retrievalService.search(query, species, lifeStage, topN));
    }

    private String determineLifeStage(PetDO pet) {
        if (pet.getBirthday() == null) return "adult";
        long months = java.time.temporal.ChronoUnit.MONTHS.between(
                pet.getBirthday(), LocalDate.now());
        if (months < 12) return "young";
        if (months >= 84) return "senior";
        return "adult";
    }

    public static class AiResponse {
        private String content;
        private List<SourceRef> sources;
        private boolean isFallback;

        public AiResponse() {}
        public AiResponse(String content, List<SourceRef> sources, boolean isFallback) {
            this.content = content;
            this.sources = sources;
            this.isFallback = isFallback;
        }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public List<SourceRef> getSources() { return sources; }
        public void setSources(List<SourceRef> sources) { this.sources = sources; }
        public boolean getIsFallback() { return isFallback; }
        public void setIsFallback(boolean fallback) { isFallback = fallback; }
    }

    public static class SourceRef {
        private Long docId;
        private String title;
        private String sourceName;

        public SourceRef() {}
        public SourceRef(Long docId, String title, String sourceName) {
            this.docId = docId;
            this.title = title;
            this.sourceName = sourceName;
        }

        public Long getDocId() { return docId; }
        public void setDocId(Long docId) { this.docId = docId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getSourceName() { return sourceName; }
        public void setSourceName(String sourceName) { this.sourceName = sourceName; }
    }
}
