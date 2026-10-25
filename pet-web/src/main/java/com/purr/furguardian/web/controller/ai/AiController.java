package com.purr.furguardian.web.controller.ai;

import com.purr.furguardian.ai.agent.PetAgentService;
import com.purr.furguardian.ai.agent.WeeklyReviewService;
import com.purr.furguardian.ai.service.LlmService;
import com.purr.furguardian.ai.service.RedLineMatcher;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.service.KnowledgeChatService;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.knowledge.service.KnowledgeRetrievalService;
import com.purr.furguardian.web.dto.ai.AiQueryDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ai")
@Tag(name = "AI问答")
public class AiController {

    private static final Logger log = LoggerFactory.getLogger(AiController.class);
    /** 一次问答的绝对预算：前端等了 60 秒，这里保证 40 秒内一定给出结果或明确降级。 */
    private static final long AI_BUDGET_MS = 40_000;
    /** 低于这个余量就不再启动 RAG，直接返回明确的超时提示。 */
    private static final long MIN_RAG_BUDGET_MS = 5_000;
    /** 双 Agent 复盘要跑两次模型，给比普通问答稍宽的绝对预算。 */
    private static final long WEEKLY_BUDGET_MS = 45_000;

    private final KnowledgeRetrievalService retrievalService;
    private final LlmService llmService;
    private final PetService petService;
    private final RedLineMatcher redLineMatcher;
    private final PetAgentService petAgentService;
    private final WeeklyReviewService weeklyReviewService;
    private final KnowledgeChatService knowledgeChatService;

    public AiController(KnowledgeRetrievalService retrievalService,
                        LlmService llmService,
                        PetService petService,
                        RedLineMatcher redLineMatcher,
                        PetAgentService petAgentService,
                        WeeklyReviewService weeklyReviewService,
                        KnowledgeChatService knowledgeChatService) {
        this.retrievalService = retrievalService;
        this.llmService = llmService;
        this.petService = petService;
        this.redLineMatcher = redLineMatcher;
        this.petAgentService = petAgentService;
        this.weeklyReviewService = weeklyReviewService;
        this.knowledgeChatService = knowledgeChatService;
    }

    @PostMapping("/query")
    @Operation(summary = "AI知识问答",
               description = "基于知识库的AI问答，先检索再生成")
    public Result<AiResponse> query(@RequestBody AiQueryDTO dto) {
        Long userId = UserContext.getUserId();
        long deadline = System.currentTimeMillis() + AI_BUDGET_MS;

        if (redLineMatcher.matchRedLine(dto.getQuery())) {
            return Result.ok(new AiResponse(
                    redLineMatcher.getRedLineResponse(),
                    List.of(), true));
        }

        PetDO pet = petService.getPet(userId, dto.getPetId());

        PetAgentService.AgentResult agentResult = petAgentService.answer(
                userId, pet, dto.getQuery(), dto.getSessionId(), dto.getPendingToken(),
                loadHistory(userId, dto.getSessionId()), deadline);
        if (agentResult != null) {
            return Result.ok(new AiResponse(
                    agentResult.content(),
                    agentResult.docs().stream()
                            .map(d -> new SourceRef(d.docId(), d.title(), d.sourceName()))
                            .toList(),
                    false,
                    agentResult.toolCalls().stream()
                            .map(c -> new AiToolCall(c.name(), c.label(), c.summary()))
                            .toList(),
                    toPendingView(agentResult.pending()),
                    agentResult.failedTools()));
        }

        if (deadline - System.currentTimeMillis() < MIN_RAG_BUDGET_MS) {
            log.warn("ai query out of budget before RAG, petId={} question=\"{}\"", pet.getId(), dto.getQuery());
            return Result.ok(new AiResponse(
                    "这次回答没能在我这边的时间里完成，请稍后重试；如果反复出现，可以把问题问得更具体一些。",
                    List.of(), true));
        }

        String species = pet.getSpecies();
        String lifeStage = determineLifeStage(pet);

        List<KnowledgeDocDO> docs = retrievalService.search(
                dto.getQuery(), species, lifeStage, 5);

        if (docs.isEmpty()) {
            log.info("ai query no docs, petId={} question=\"{}\"", pet.getId(), dto.getQuery());
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

        String answer = llmService.chatWithTimeout(systemPrompt, userPrompt,
                Duration.ofMillis(deadline - System.currentTimeMillis()));

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

    @PostMapping("/weekly-review")
    @Operation(summary = "本周照护复盘",
               description = "照护分析 Agent 先查真实记录并识别缺口，行动计划 Agent 基于分析结果提建议")
    public Result<WeeklyReviewView> weeklyReview(@RequestBody AiQueryDTO dto) {
        Long userId = UserContext.getUserId();
        PetDO pet = petService.getPet(userId, dto.getPetId());
        long deadline = System.currentTimeMillis() + WEEKLY_BUDGET_MS;
        WeeklyReviewService.Review review = weeklyReviewService.run(userId, pet, deadline);
        return Result.ok(toReviewView(review));
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

    /** 会话不存在或不属于当前用户时按「无历史」处理，不能因为会话 id 失效就答不了。 */
    private List<KnowledgeChatService.ChatMessage> loadHistory(Long userId, Long sessionId) {
        if (sessionId == null) {
            return List.of();
        }
        try {
            return knowledgeChatService.listMessages(userId, sessionId, null, 8).getRecords();
        } catch (BizException e) {
            return List.of();
        }
    }

    private String determineLifeStage(PetDO pet) {
        if (pet.getBirthday() == null) return "adult";
        long months = java.time.temporal.ChronoUnit.MONTHS.between(
                pet.getBirthday(), LocalDate.now());
        if (months < 12) return "young";
        if (months >= 84) return "senior";
        return "adult";
    }

    private AiPendingAction toPendingView(PetAgentService.PendingAction pending) {
        if (pending == null) {
            return null;
        }
        return new AiPendingAction(pending.token(), pending.type(), pending.petId(), pending.title(),
                pending.reminderType(), pending.remindDate(), pending.remindTime(),
                pending.repeatRule(), pending.repeatDays(), pending.summary());
    }

    private WeeklyReviewView toReviewView(WeeklyReviewService.Review review) {
        return new WeeklyReviewView(
                toStepView(review.analysis()),
                review.plan() == null ? null : toStepView(review.plan()),
                review.sources().stream()
                        .map(d -> new SourceRef(d.docId(), d.title(), d.sourceName()))
                        .toList(),
                toPendingView(review.pending()),
                review.degraded(),
                review.ms());
    }

    private WeeklyStepView toStepView(WeeklyReviewService.Step step) {
        return new WeeklyStepView(step.role(), step.label(), step.status(), step.content(),
                step.facts(), step.missing(),
                step.toolCalls().stream()
                        .map(c -> new AiToolCall(c.name(), c.label(), c.summary()))
                        .toList(),
                step.failedTools(), step.ms());
    }

    @Schema(description = "AI问答响应")
    public static class AiResponse {
        @Schema(description = "回答内容", example = "根据WSAVA指南，成猫每日粗蛋白需求...")
        private String content;
        @Schema(description = "参考来源列表")
        private List<SourceRef> sources;
        @Schema(description = "是否为降级兜底响应", example = "false")
        private boolean isFallback;
        @Schema(description = "Agent 本次实际调用的工具，按调用顺序")
        private List<AiToolCall> toolCalls;
        @Schema(description = "待用户确认的写操作计划；为空表示本次没有写操作")
        private AiPendingAction pendingAction;
        @Schema(description = "本次查询失败的工具（展示名），非空表示有维度缺数据")
        private List<String> failedTools;

        public AiResponse() {}
        public AiResponse(String content, List<SourceRef> sources, boolean isFallback) {
            this(content, sources, isFallback, List.of(), null, List.of());
        }
        public AiResponse(String content, List<SourceRef> sources, boolean isFallback,
                          List<AiToolCall> toolCalls) {
            this(content, sources, isFallback, toolCalls, null, List.of());
        }
        public AiResponse(String content, List<SourceRef> sources, boolean isFallback,
                          List<AiToolCall> toolCalls, AiPendingAction pendingAction,
                          List<String> failedTools) {
            this.content = content;
            this.sources = sources;
            this.isFallback = isFallback;
            this.toolCalls = toolCalls;
            this.pendingAction = pendingAction;
            this.failedTools = failedTools;
        }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public List<SourceRef> getSources() { return sources; }
        public void setSources(List<SourceRef> sources) { this.sources = sources; }
        public boolean getIsFallback() { return isFallback; }
        public void setIsFallback(boolean fallback) { isFallback = fallback; }
        public List<AiToolCall> getToolCalls() { return toolCalls; }
        public void setToolCalls(List<AiToolCall> toolCalls) { this.toolCalls = toolCalls; }
        public AiPendingAction getPendingAction() { return pendingAction; }
        public void setPendingAction(AiPendingAction pendingAction) { this.pendingAction = pendingAction; }
        public List<String> getFailedTools() { return failedTools; }
        public void setFailedTools(List<String> failedTools) { this.failedTools = failedTools; }
    }

    @Schema(description = "待确认的提醒计划（Agent 尚未落库）")
    public static class AiPendingAction {
        @Schema(description = "确认用的服务端计划令牌，前端原样回传")
        private String token;
        @Schema(description = "动作类型", example = "reminder.create")
        private String type;
        @Schema(description = "目标宠物ID", example = "1")
        private Long petId;
        @Schema(description = "提醒标题", example = "狂犬疫苗加强针")
        private String title;
        @Schema(description = "提醒类型", example = "VACCINE")
        private String reminderType;
        @Schema(description = "计划日期 yyyy-MM-dd，周期提醒为空", example = "2026-11-01")
        private String remindDate;
        @Schema(description = "提醒时间 HH:mm", example = "09:00")
        private String remindTime;
        @Schema(description = "重复规则", example = "ONCE")
        private String repeatRule;
        @Schema(description = "每周重复的星期，1=周一", example = "1,3,5")
        private String repeatDays;
        @Schema(description = "给用户看的一句话摘要", example = "11月1日 09:00 · 疫苗·狂犬疫苗加强针")
        private String summary;

        public AiPendingAction() {}
        public AiPendingAction(String token, String type, Long petId, String title, String reminderType,
                               String remindDate, String remindTime, String repeatRule,
                               String repeatDays, String summary) {
            this.token = token;
            this.type = type;
            this.petId = petId;
            this.title = title;
            this.reminderType = reminderType;
            this.remindDate = remindDate;
            this.remindTime = remindTime;
            this.repeatRule = repeatRule;
            this.repeatDays = repeatDays;
            this.summary = summary;
        }

        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public Long getPetId() { return petId; }
        public void setPetId(Long petId) { this.petId = petId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getReminderType() { return reminderType; }
        public void setReminderType(String reminderType) { this.reminderType = reminderType; }
        public String getRemindDate() { return remindDate; }
        public void setRemindDate(String remindDate) { this.remindDate = remindDate; }
        public String getRemindTime() { return remindTime; }
        public void setRemindTime(String remindTime) { this.remindTime = remindTime; }
        public String getRepeatRule() { return repeatRule; }
        public void setRepeatRule(String repeatRule) { this.repeatRule = repeatRule; }
        public String getRepeatDays() { return repeatDays; }
        public void setRepeatDays(String repeatDays) { this.repeatDays = repeatDays; }
        public String getSummary() { return summary; }
        public void setSummary(String summary) { this.summary = summary; }
    }

    @Schema(description = "Agent 调用过的工具")
    public static class AiToolCall {
        @Schema(description = "工具名", example = "weightTrend")
        private String name;
        @Schema(description = "展示名称", example = "体重趋势")
        private String label;
        @Schema(description = "一句话结果摘要", example = "近7天 3.8→3.6kg（-0.2）")
        private String summary;

        public AiToolCall() {}
        public AiToolCall(String name, String label, String summary) {
            this.name = name;
            this.label = label;
            this.summary = summary;
        }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getLabel() { return label; }
        public void setLabel(String label) { this.label = label; }
        public String getSummary() { return summary; }
        public void setSummary(String summary) { this.summary = summary; }
    }

    @Schema(description = "知识来源引用")
    public static class SourceRef {
        @Schema(description = "知识条目ID", example = "1")
        private Long docId;
        @Schema(description = "条目标题", example = "成猫牛磺酸最低需求")
        private String title;
        @Schema(description = "来源名称", example = "WSAVA Global Nutrition Guidelines")
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

    @Schema(description = "双 Agent 复盘响应")
    public static class WeeklyReviewView {
        @Schema(description = "照护分析 Agent 的结果")
        private WeeklyStepView analysis;
        @Schema(description = "行动计划 Agent 的结果；为空表示这一步失败")
        private WeeklyStepView plan;
        @Schema(description = "行动计划引用的知识来源")
        private List<SourceRef> sources;
        @Schema(description = "待用户确认的写操作计划")
        private AiPendingAction pendingAction;
        @Schema(description = "分析阶段就失败、本次没有可用结论时为 true")
        private boolean degraded;
        @Schema(description = "整次复盘耗时（毫秒）", example = "12345")
        private long ms;

        public WeeklyReviewView() {}
        public WeeklyReviewView(WeeklyStepView analysis, WeeklyStepView plan, List<SourceRef> sources,
                                AiPendingAction pendingAction, boolean degraded, long ms) {
            this.analysis = analysis;
            this.plan = plan;
            this.sources = sources;
            this.pendingAction = pendingAction;
            this.degraded = degraded;
            this.ms = ms;
        }

        public WeeklyStepView getAnalysis() { return analysis; }
        public void setAnalysis(WeeklyStepView analysis) { this.analysis = analysis; }
        public WeeklyStepView getPlan() { return plan; }
        public void setPlan(WeeklyStepView plan) { this.plan = plan; }
        public List<SourceRef> getSources() { return sources; }
        public void setSources(List<SourceRef> sources) { this.sources = sources; }
        public AiPendingAction getPendingAction() { return pendingAction; }
        public void setPendingAction(AiPendingAction pendingAction) { this.pendingAction = pendingAction; }
        public boolean getDegraded() { return degraded; }
        public void setDegraded(boolean degraded) { this.degraded = degraded; }
        public long getMs() { return ms; }
        public void setMs(long ms) { this.ms = ms; }
    }

    @Schema(description = "双 Agent 复盘中的单个角色结果")
    public static class WeeklyStepView {
        @Schema(description = "角色标识", example = "analysis")
        private String role;
        @Schema(description = "角色展示名", example = "照护分析")
        private String label;
        @Schema(description = "OK / PARTIAL（有维度缺数据）/ FAILED", example = "OK")
        private String status;
        @Schema(description = "该角色的文字结论")
        private String content;
        @Schema(description = "来自工具的真实事实摘要")
        private List<String> facts;
        @Schema(description = "没有取到的数据维度")
        private List<String> missing;
        @Schema(description = "该角色实际调用的工具")
        private List<AiToolCall> toolCalls;
        @Schema(description = "查询失败的工具展示名")
        private List<String> failedTools;
        @Schema(description = "该角色耗时（毫秒）", example = "4200")
        private long ms;

        public WeeklyStepView() {}
        public WeeklyStepView(String role, String label, String status, String content,
                              List<String> facts, List<String> missing,
                              List<AiToolCall> toolCalls, List<String> failedTools, long ms) {
            this.role = role;
            this.label = label;
            this.status = status;
            this.content = content;
            this.facts = facts;
            this.missing = missing;
            this.toolCalls = toolCalls;
            this.failedTools = failedTools;
            this.ms = ms;
        }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }
        public String getLabel() { return label; }
        public void setLabel(String label) { this.label = label; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public List<String> getFacts() { return facts; }
        public void setFacts(List<String> facts) { this.facts = facts; }
        public List<String> getMissing() { return missing; }
        public void setMissing(List<String> missing) { this.missing = missing; }
        public List<AiToolCall> getToolCalls() { return toolCalls; }
        public void setToolCalls(List<AiToolCall> toolCalls) { this.toolCalls = toolCalls; }
        public List<String> getFailedTools() { return failedTools; }
        public void setFailedTools(List<String> failedTools) { this.failedTools = failedTools; }
        public long getMs() { return ms; }
        public void setMs(long ms) { this.ms = ms; }
    }
}
