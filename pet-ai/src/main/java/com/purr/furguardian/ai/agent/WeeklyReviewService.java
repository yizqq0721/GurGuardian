package com.purr.furguardian.ai.agent;

import com.purr.furguardian.biz.entity.pet.PetDO;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.chat.request.DefaultChatRequestParameters;
import dev.langchain4j.model.chat.request.ToolChoice;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.function.Function;

/**
 * 周度照护复盘：照护分析 Agent → 行动计划 Agent，固定顺序执行。
 * 两个角色有独立的 AiServices、提示词和工具集；分析 Agent 只读数据，
 * 计划 Agent 没有数据查询工具，只能使用前者交来的结论，交接是被工具范围强制保证的。
 */
@Service
public class WeeklyReviewService {

    private static final Logger log = LoggerFactory.getLogger(WeeklyReviewService.class);

    static final String QUESTION = "这周照顾得怎么样，接下来要做什么？";

    private static final Duration MODEL_TIMEOUT = Duration.ofSeconds(12);
    private static final long ANALYSIS_TIMEOUT_MS = 20_000;
    private static final long PLAN_TOOL_TIMEOUT_MS = 12_000;
    private static final long PLAN_TIMEOUT_MS = 18_000;
    private static final long RESPONSE_RESERVE_MS = 5_000;
    /** 分析没有调用任何工具时，剩余预算够才补一次强提示。 */
    private static final long NUDGE_MIN_MS = 10_000;

    static final String ANALYSIS_PROMPT = """
            你是 FurGuardian 的照护分析 Agent，只负责查清事实和记录缺口，不给行动建议。
            规则：
            1. 必须先调用工具读取当前宠物的档案、体重、喂食打卡和提醒，历史对话或常识不能代替本次工具结果。
            2. 先写事实：每个数字、日期、名称都必须来自工具返回，并保留「近7天」「有记录日均」这类限定。
               不要自己做减法或推算变化，天数、次数、变化量直接引用工具给出的数字。
               档案里的 BCS 与体重记录里的 BCS 来自不同来源，禁止写成「从…升到…」「下降了」之类比较，
               只能分别陈述「档案 BCS x/9；最近一次记录 BCS y/9」。
            3. 再写记录缺口：只写体重、喂食这类数据本身的缺失，只能写工具明确返回的缺失，
               工具给出记录的日期就是有记录。这一段必须以「记录缺口：」开头，没有缺口就写「记录缺口：无」。
               提醒有没有打卡不属于记录缺口，统一放到「需关注」里写。
               喂食未打卡只能写「没有记录、无法判断」，严禁写成没喂、漏喂、饿着；
               工具显示每天都有记录时，禁止再写「今天没有记录」「今天没有喂食」。
               今天有提醒没打卡只能写「未完成」，不能据此说今天缺少记录；未记录天数直接用工具给出的数字。
               过期只指日期早于今天且未完成的事项。
            4. 最后写需要关注的现象：记录是否连续、体重有无变化、今天有没有未完成事项、有没有已过期事项。
               只描述现象，不下诊断、不给建议。
            5. 你没有创建提醒和检索知识库的工具，也不要提出行动方案。
            6. 中文口语化，不要用中英混杂的词汇，200 字以内，不用医疗术语。
            """;

    static final String PLAN_PROMPT = """
            你是 FurGuardian 的行动计划 Agent。「照护分析结果」由另一个 Agent 基于真实记录生成，
            你只能基于它和知识库检索结果提建议，不能重新猜测宠物数据。
            规则：
            1. 输出顺序：先用一句话概括分析结论，再逐条写 2-3 条可执行建议，最后才写收尾句。
               每条建议单独一行，都要对应分析里的事实或缺口，说清楚让用户做什么。
            2. 记录缺口只能建议「补记录、继续观察、下次就诊时咨询兽医」，不能推断实际漏喂、漏做或患病。
               只有分析里明确写出的缺口才能建议补记；分析说每天都有记录的维度，不要建议补记或补打卡。
               今天提醒没打卡不是记录缺口，只能建议执行提醒。
               不要给出喂食克数、热量或减重比例这类具体调整，具体方案交给营养计算器。
            3. 建议涉及营养、体重、驱虫、疫苗、护理知识时，先调用 searchKnowledge，并在对应建议后保留来源名称；
               没有检索结果时不要写「来源：…」，也不要凭印象引用机构名。
            4. 分析指出记录缺口时，用 proposeReminder 生成一条补记提醒；调用成功后，建议照常写完，
               最后再加一句「已生成计划，请在下方确认」。
               没有调用 proposeReminder 就不要提计划，更不能用这句话代替建议本身。
            5. 不重复罗列分析里的数字，引用时保持原口径。
               档案 BCS 与体重记录里的 BCS 来源不同，不要写成「从 x/9 升到 y/9」或「下降了」，
               只能分别陈述，或直接让用户按体重趋势观察。
            6. 中文口语化，250 字以内，不用医疗术语。
            """;

    /** 工具阶段只允许一次工具调用，配合 tool_choice=required，保证计划不是纯文本空谈。 */
    static final String PLAN_TOOL_PROMPT = """
            你是 FurGuardian 的行动计划 Agent 的工具步骤，只负责调用一次工具，不写建议。
            规则：
            1. 只能调用一个工具，调用后立即结束，不要输出任何正文。
            2. 「照护分析结果」里只要出现数据缺失——「记录缺口」段写了内容、或事实里出现「缺 X 月 X 日」
               「只测了 N 天」「有 N 天记录」这类明确缺口——就调用 proposeReminder 生成一条补记提醒：
               标题写清要补什么，时间取用户方便记录的时段，重复规则与缺口匹配。
               分析里完全没有数据缺失、只是今天提醒没完成，才改用 searchKnowledge。
            3. 没有记录缺口、但需要营养或护理依据时，调用 searchKnowledge，检索最能支撑本周建议的主题。
            4. 不要编造宠物数据，只传工具参数。
            """;

    public record Step(String role, String label, String status, String content,
                       List<String> facts, List<String> missing,
                       List<PetAgentService.ToolCallView> toolCalls,
                       List<String> failedTools, long ms) {}

    public record Review(Step analysis, Step plan,
                         List<PetAgentService.SourceDoc> sources,
                         PetAgentService.PendingAction pending,
                         boolean degraded, long ms) {}

    interface AnalysisAssistant {
        @SystemMessage(ANALYSIS_PROMPT)
        String chat(@UserMessage String message);
    }

    interface PlanAssistant {
        @SystemMessage(PLAN_PROMPT)
        String chat(@UserMessage String message);
    }

    interface PlanToolAssistant {
        @SystemMessage(PLAN_TOOL_PROMPT)
        String chat(@UserMessage String message);
    }

    private final AnalysisAssistant analyst;
    private final PlanAssistant planner;
    private final PlanToolAssistant proposer;
    private final AgentPlanStore planStore;
    private final Executor executor;

    public WeeklyReviewService(AnalysisToolSet analysisTools,
                               PlanToolSet planTools,
                               AgentPlanStore planStore,
                               @Qualifier("llmExecutor") Executor executor,
                               @Value("${langchain4j.community.dashscope.chat-model.api-key}") String apiKey,
                               @Value("${langchain4j.community.dashscope.chat-model.model-name}") String modelName) {
        this.planStore = planStore;
        this.executor = executor;
        ChatModel chatModel = OpenAiChatModel.builder()
                .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                .apiKey(apiKey)
                .modelName(modelName)
                .temperature(0.2)
                .timeout(MODEL_TIMEOUT)
                .maxRetries(0)
                .build();
        // 工具步骤用 REQUIRED：模型必须真的调一次工具，不能再只写建议和来源
        ChatModel toolModel = OpenAiChatModel.builder()
                .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                .apiKey(apiKey)
                .modelName(modelName)
                .temperature(0.1)
                .timeout(MODEL_TIMEOUT)
                .maxRetries(0)
                .defaultRequestParameters(DefaultChatRequestParameters.builder()
                        .toolChoice(ToolChoice.REQUIRED)
                        .build())
                .build();
        // 两个角色共用模型，但工具集和提示词互相独立
        this.analyst = AiServices.builder(AnalysisAssistant.class)
                .chatModel(chatModel)
                .tools(analysisTools)
                .maxToolCallingRoundTrips(3)
                .build();
        this.planner = AiServices.builder(PlanAssistant.class)
                .chatModel(chatModel)
                .tools(planTools)
                .maxToolCallingRoundTrips(2)
                .build();
        this.proposer = AiServices.builder(PlanToolAssistant.class)
                .chatModel(toolModel)
                .tools(planTools)
                .maxToolCallingRoundTrips(1)
                .build();
    }

    public Review run(Long userId, PetDO pet, long deadlineMillis) {
        long started = System.currentTimeMillis();
        String base = baseMessage(pet);
        String analysisInput = base + "\n【问题】" + QUESTION;

        long analysisStarted = System.currentTimeMillis();
        AgentContext.Snapshot analysis = runStage(analyst::chat, userId, pet.getId(),
                analysisInput, deadlineMillis, ANALYSIS_TIMEOUT_MS);
        if (analysis != null && analysis.calls().isEmpty() && budgetLeft(deadlineMillis) >= NUDGE_MIN_MS) {
            log.info("weekly analysis without tools, retrying with nudge, petId={}", pet.getId());
            analysis = runStage(analyst::chat, userId, pet.getId(),
                    analysisInput + "\n\n【系统提示】必须先调用工具核对本周真实记录，不能只凭常识作答。",
                    deadlineMillis, ANALYSIS_TIMEOUT_MS);
        }
        long analysisMs = System.currentTimeMillis() - analysisStarted;

        if (analysis == null || analysis.content() == null || analysis.content().isBlank()) {
            log.warn("weekly analysis failed petId={} ms={}", pet.getId(), analysisMs);
            return new Review(
                    new Step("analysis", "照护分析", "FAILED",
                            "这次照护分析没能完成，请稍后重试。", List.of(), List.of(),
                            List.of(), List.of(), analysisMs),
                    null, List.of(), null, true,
                    System.currentTimeMillis() - started);
        }

        Step analysisStep = new Step("analysis", "照护分析", status(analysis),
                analysis.content().trim(),
                analysis.calls().stream()
                        .map(c -> c.label() + "：" + c.summary())
                        .toList(),
                List.copyOf(analysis.failed()),
                toViews(analysis),
                analysis.failed(),
                analysisMs);

        long planStarted = System.currentTimeMillis();
        String planMessage = planInput(base, analysisStep);
        // 工具步骤被 REQUIRED 约束，必须真的调一次工具；失败时退回一次自由计划，别让整段陪葬
        AgentContext.Snapshot proposal = runStage(proposer::chat, userId, pet.getId(),
                planMessage, deadlineMillis, PLAN_TOOL_TIMEOUT_MS);
        AgentContext.Snapshot plan = proposal == null
                ? runStage(planner::chat, userId, pet.getId(),
                        planMessage, deadlineMillis, PLAN_TIMEOUT_MS)
                : runStage(planner::chat, userId, pet.getId(),
                        planWriteInput(planMessage, proposal), deadlineMillis, PLAN_TIMEOUT_MS);
        AgentContext.Snapshot combined = merge(proposal, plan);
        long planMs = System.currentTimeMillis() - planStarted;

        Step planStep;
        List<PetAgentService.SourceDoc> sources = List.of();
        PetAgentService.PendingAction pending = null;
        if (combined == null) {
            planStep = new Step("plan", "行动计划", "FAILED",
                    "行动计划这次没能生成，上面的照护分析仍然有效。", List.of(), List.of(),
                    List.of(), List.of(), planMs);
        } else {
            boolean written = plan != null && plan.content() != null && !plan.content().isBlank();
            String content = written ? combined.content()
                    : combined.pending() != null
                    ? "已根据本周记录缺口生成补记提醒，请在下方确认。"
                    : "行动计划这次没能生成，上面的照护分析仍然有效。";
            planStep = new Step("plan", "行动计划", written ? status(combined) : "PARTIAL",
                    sanitizePlan(content, combined.pending() != null, !combined.docs().isEmpty()),
                    List.of(), List.copyOf(combined.failed()),
                    toViews(combined), combined.failed(), planMs);
            sources = combined.docs().stream()
                    .map(d -> new PetAgentService.SourceDoc(d.docId(), d.title(), d.sourceName()))
                    .toList();
            if (combined.pending() != null) {
                String token = planStore.save(userId, null, combined.pending());
                pending = toPending(combined.pending(), token);
            }
        }

        log.info("weekly review petId={} analysisTools={} planTools={} pending={} degradedPlan={} analysisMs={} planMs={}",
                pet.getId(),
                analysis.calls().stream().map(AgentContext.ToolCall::name).toList(),
                combined == null ? List.of() : combined.calls().stream().map(AgentContext.ToolCall::name).toList(),
                pending != null, "FAILED".equals(planStep.status()),
                analysisMs, planMs);
        return new Review(analysisStep, planStep, sources, pending, false,
                System.currentTimeMillis() - started);
    }

    private AgentContext.Snapshot runStage(Function<String, String> call, Long userId, Long petId,
                                           String message, long deadlineMillis, long stageTimeoutMs) {
        long timeout = Math.min(stageTimeoutMs, budgetLeft(deadlineMillis));
        if (timeout <= 0) {
            log.warn("weekly stage skipped, no budget left petId={}", petId);
            return null;
        }
        FutureTask<AgentContext.Snapshot> task = new FutureTask<>(() -> {
            AgentContext.open(userId, petId);
            try {
                return AgentContext.snapshot(call.apply(message));
            } catch (Exception e) {
                // REQUIRED 工具模式在第二次请求时会主动抛错；已执行的工具调用、提案和来源仍然有效
                log.warn("weekly stage interrupted petId={} reason={}", petId, e.toString());
                return AgentContext.snapshot("");
            } finally {
                AgentContext.close();
            }
        });
        executor.execute(task);
        try {
            return task.get(timeout, TimeUnit.MILLISECONDS);
        } catch (TimeoutException e) {
            task.cancel(true);
            log.warn("weekly stage timeout petId={} timeoutMs={}", petId, timeout);
            return null;
        } catch (Exception e) {
            log.warn("weekly stage failed petId={} reason={}", petId, e.toString());
            return null;
        }
    }

    /** 把分析 Agent 的结论显式交给计划 Agent；计划 Agent 没有数据工具，只能依赖这段输入。 */
    private String planInput(String base, Step analysis) {
        StringBuilder text = new StringBuilder(base);
        text.append("【照护分析结果】\n事实：\n");
        if (analysis.facts().isEmpty()) {
            text.append("- 分析 Agent 没有取到任何事实\n");
        } else {
            for (String fact : analysis.facts()) {
                text.append("- ").append(fact).append('\n');
            }
        }
        text.append("数据缺口：\n");
        if (analysis.missing().isEmpty()) {
            text.append("- 无\n");
        } else {
            for (String missing : analysis.missing()) {
                text.append("- ").append(missing).append("没有取到\n");
            }
        }
        text.append("分析发现：\n").append(analysis.content()).append("\n\n");
        text.append("【问题】").append(QUESTION);
        return text.toString();
    }

    /** 工具步骤跑完后把真实调用结果交回计划 Agent，来源名只允许从这里来。 */
    private String planWriteInput(String planMessage, AgentContext.Snapshot proposal) {
        StringBuilder text = new StringBuilder(planMessage).append("\n【工具步骤结果】\n");
        if (proposal.calls().isEmpty()) {
            text.append("- 没有调用任何工具\n");
        } else {
            for (AgentContext.ToolCall call : proposal.calls()) {
                text.append("- ").append(call.label()).append("：").append(call.summary()).append('\n');
            }
        }
        if (!proposal.docs().isEmpty()) {
            text.append("可引用的知识来源（只能用这些名字）：\n");
            for (AgentContext.DocRef doc : proposal.docs()) {
                text.append("- ").append(doc.title()).append("（").append(doc.sourceName()).append("）\n");
            }
        }
        if (proposal.pending() != null) {
            text.append("待确认计划已经生成：").append(proposal.pending().summary()).append('\n');
            text.append("不要再调用 proposeReminder，直接写建议，最后写「已生成计划，请在下方确认」。\n");
        } else {
            text.append("没有生成待确认计划，回答里不要提计划，也不要写「已生成计划」。\n");
        }
        text.append("现在只输出概括和 2-3 条建议；上面没有知识来源时，不要写任何「来源：…」。");
        return text.toString();
    }

    private AgentContext.Snapshot merge(AgentContext.Snapshot first, AgentContext.Snapshot second) {
        if (first == null) {
            return second;
        }
        if (second == null) {
            return first;
        }
        List<AgentContext.ToolCall> calls = new ArrayList<>(first.calls());
        calls.addAll(second.calls());
        List<AgentContext.DocRef> docs = new ArrayList<>(first.docs());
        for (AgentContext.DocRef doc : second.docs()) {
            if (docs.stream().noneMatch(d -> d.docId().equals(doc.docId()))) {
                docs.add(doc);
            }
        }
        List<String> failed = new ArrayList<>(first.failed());
        for (String dimension : second.failed()) {
            if (!failed.contains(dimension)) {
                failed.add(dimension);
            }
        }
        AgentContext.PendingAction pending = second.pending() != null ? second.pending() : first.pending();
        return new AgentContext.Snapshot(second.content(), List.copyOf(calls), List.copyOf(docs),
                pending, List.copyOf(failed));
    }

    private List<PetAgentService.ToolCallView> toViews(AgentContext.Snapshot snapshot) {
        return snapshot.calls().stream()
                .map(c -> new PetAgentService.ToolCallView(c.name(), c.label(), c.summary()))
                .toList();
    }

    private String status(AgentContext.Snapshot snapshot) {
        return snapshot.failed().isEmpty() ? "OK" : "PARTIAL";
    }

    /**
     * 计划 Agent 偶尔会在没调用 proposeReminder 的情况下写「已生成计划」，
     * 或在没有检索结果时编一个来源。前端只按 pending / sources 渲染，这类话术会直接骗到用户，所以按行裁掉。
     */
    private String sanitizePlan(String content, boolean hasPending, boolean hasDocs) {
        if (content == null) {
            return "";
        }
        String cleaned = content;
        if (!hasPending && (cleaned.contains("已生成计划") || cleaned.contains("下方确认"))) {
            StringBuilder kept = new StringBuilder();
            for (String line : cleaned.split("\n")) {
                if (line.contains("已生成计划") || line.contains("下方确认")) {
                    continue;
                }
                kept.append(line).append('\n');
            }
            cleaned = kept.toString().trim();
            log.info("weekly plan claimed a pending action without calling tools, claim stripped");
        }
        if (!hasDocs && cleaned.contains("来源")) {
            cleaned = cleaned
                    .replaceAll("[（(]\\s*来源\\s*[：:][^）)]*[）)]", "")
                    .replaceAll("[—\\-]{1,2}\\s*来源\\s*[：:][^。\\n]*[。]?", "")
                    .replaceAll("\\s*来源\\s*[：:][^。\\n]*[。]?", "")
                    .trim();
            log.info("weekly plan cited a source without retrieval, citation stripped");
        }
        cleaned = cleaned.trim();
        if (cleaned.isEmpty()) {
            return "这次没有生成可确认的提醒计划，行动建议见上方的照护分析，可以稍后再试。";
        }
        return cleaned;
    }

    private PetAgentService.PendingAction toPending(AgentContext.PendingAction pending, String token) {
        return new PetAgentService.PendingAction(token, pending.type(), pending.petId(), pending.title(),
                pending.reminderType(), pending.remindDate(), pending.remindTime(),
                pending.repeatRule(), pending.repeatDays(), pending.summary());
    }

    private long budgetLeft(long deadlineMillis) {
        return deadlineMillis - System.currentTimeMillis() - RESPONSE_RESERVE_MS;
    }

    private String baseMessage(PetDO pet) {
        LocalDate today = LocalDate.now();
        return "【今天】" + today + " 周"
                + "一二三四五六日".charAt(today.getDayOfWeek().getValue() - 1) + "\n"
                + "【当前宠物】" + pet.getName() + "（" + speciesText(pet.getSpecies()) + "）\n";
    }

    private String speciesText(String species) {
        if (species == null) {
            return "宠物";
        }
        return switch (species.toLowerCase()) {
            case "cat" -> "猫";
            case "dog" -> "犬";
            default -> species;
        };
    }
}
