package com.purr.furguardian.ai.agent;

import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.service.KnowledgeChatService;
import dev.langchain4j.model.chat.ChatModel;
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
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

/**
 * 工具型 Agent：模型自己决定查哪些数据，再基于工具返回的事实作答。
 * 一次调用最多三轮工具往返；单次调用、重试和回退都从请求的绝对截止时间里扣预算，
 * 保证整条链路在调用方给的时间内结束，而不是每段各等一次超时。
 */
@Service
public class PetAgentService {

    private static final Logger log = LoggerFactory.getLogger(PetAgentService.class);
    /** 单次 Agent 调用上限；留出重试和回退的余量。 */
    private static final long INVOKE_TIMEOUT_MS = 20_000;
    /** 单次模型 HTTP 调用上限；三轮工具往返也受 INVOKE_TIMEOUT_MS 约束。 */
    private static final Duration MODEL_TIMEOUT = Duration.ofSeconds(12);
    /** 留给组装响应和网络传输的时间，预算里先扣掉。 */
    private static final long RESPONSE_RESERVE_MS = 5_000;
    /** 剩余预算不足这个数时不再重试，直接回退。 */
    private static final long RETRY_MIN_MS = 10_000;
    private static final int HISTORY_LIMIT = 8;
    private static final int HISTORY_CHAR_LIMIT = 1500;

    static final String SYSTEM_PROMPT = """
            你是 FurGuardian 养宠助手，可以调用工具读取当前用户的宠物真实数据。
            规则：
            1. 只要问题涉及这只宠物的喂养、体重、提醒、健康观察，必须先调用工具拿最新数据再回答；
               历史对话只用来理解指代和上下文，不能代替本次工具返回的数据。
            2. 回答「最近照顾得怎么样」这类综合问题时，至少查询体重、喂食、提醒三项。
            3. 回答里的每个数字、日期、名称都必须来自工具返回；工具没返回的就直说缺数据，严禁编造。
               没有打卡记录只能说「没有记录、无法判断」，不能说没喂、漏喂或饿着；引用喂食均值时必须保留「有记录日均」这个限定。
            4. 中文口语化，先给结论再给依据，200字以内，引用具体日期和数字。
            5. 不使用「诊断」「处方」「治疗」「确诊」等医疗术语；发现异常只建议继续观察或咨询兽医。
            6. 用户要求新增提醒时，只能调用 proposeReminder 生成待确认计划，然后说明「已生成计划，请在下方确认」。
               如果用户是在修改【待确认计划】，同样调用 proposeReminder 生成修改后的计划，说明「已更新计划，请在下方确认」，
               新计划生成后旧计划会自动失效。绝不能声称已经创建、已经设置好或已经修改，真正保存只能由用户点击确认完成。
            7. 所有相对日期（今天、明天、下周三等）都以用户消息里的【今天】为基准换算，
               换算结果写进 proposeReminder 的 date 参数；不要凭训练数据猜日期。
            8. 工具返回【工具失败】时，对应维度只能说明「这项数据暂时查不到」，
               不得给出该维度的任何数字，也不得用历史对话或常识补齐；其余维度照常回答。
            9. 修改【待确认计划】时，只有用户明确说出要改的字段才能生成新计划；
               缺少关键信息（改哪一项、日期、时间、周期）时先用一句话追问，不要调用 proposeReminder，
               也不要把旧计划原样再提一遍。用户没有要求修改时，不要主动改动这条计划。
            """;

    public record ToolCallView(String name, String label, String summary) {}

    public record SourceDoc(Long docId, String title, String sourceName) {}

    public record PendingAction(String token, String type, Long petId, String title,
                                String reminderType, String remindDate, String remindTime,
                                String repeatRule, String repeatDays, String summary) {}

    public record AgentResult(String content, List<SourceDoc> docs, List<ToolCallView> toolCalls,
                              PendingAction pending, List<String> failedTools) {}

    interface PetAssistant {
        @SystemMessage(SYSTEM_PROMPT)
        String chat(@UserMessage String message);
    }

    private final PetAssistant assistant;
    private final AgentPlanStore planStore;
    private final Executor executor;

    public PetAgentService(PetAgentTools tools,
                           AgentPlanStore planStore,
                           @Qualifier("llmExecutor") Executor executor,
                           @Value("${langchain4j.community.dashscope.chat-model.api-key}") String apiKey,
                           @Value("${langchain4j.community.dashscope.chat-model.model-name}") String modelName) {
        this.planStore = planStore;
        this.executor = executor;
        // 单独建一个兼容端点模型，不影响 LlmService 走的原生 DashScope 通道
        ChatModel chatModel = OpenAiChatModel.builder()
                .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                .apiKey(apiKey)
                .modelName(modelName)
                .temperature(0.2)
                .timeout(MODEL_TIMEOUT)
                // 不在这里重试：重试交给预算内的强提示重试，避免一次请求叠加两次 12 秒
                .maxRetries(0)
                .build();
        this.assistant = AiServices.builder(PetAssistant.class)
                .chatModel(chatModel)
                .tools(tools)
                .maxToolCallingRoundTrips(3)
                .build();
    }

    /** 返回 null 表示预算耗尽、超时或失败，由调用方在剩余预算内回退到检索问答。 */
    public AgentResult answer(Long userId, PetDO pet, String question, Long sessionId, String pendingToken,
                              List<KnowledgeChatService.ChatMessage> history, long deadlineMillis) {
        long started = System.currentTimeMillis();
        AgentPlanStore.ActivePlan active = planStore.resolve(userId, sessionId, pendingToken).orElse(null);
        String message = buildUserMessage(pet, question, history, active);
        try {
            long timeout = Math.min(INVOKE_TIMEOUT_MS, budgetLeft(deadlineMillis));
            if (timeout <= 0) {
                log.warn("agent skipped, no budget left petId={}", pet.getId());
                return null;
            }
            AgentContext.Snapshot snapshot = invoke(userId, pet.getId(), message, timeout);
            // 追问场景模型容易直接吃历史，不查最新数据；带强提示再来一次
            if (snapshot.calls().isEmpty() && needsTools(question)
                    && budgetLeft(deadlineMillis) >= RETRY_MIN_MS) {
                log.info("agent answered without tools, retrying with nudge, petId={}", pet.getId());
                snapshot = invoke(userId, pet.getId(), message
                                + "\n\n【系统提示】必须先调用工具核对最新数据再回答，不能只依赖历史对话。",
                        Math.min(INVOKE_TIMEOUT_MS, budgetLeft(deadlineMillis)));
            }
            if (snapshot.content() == null || snapshot.content().isBlank()) {
                log.warn("agent returned empty answer, petId={}", pet.getId());
                return null;
            }
            List<SourceDoc> docs = snapshot.docs().stream()
                    .map(d -> new SourceDoc(d.docId(), d.title(), d.sourceName()))
                    .toList();
            List<ToolCallView> calls = snapshot.calls().stream()
                    .map(c -> new ToolCallView(c.name(), c.label(), c.summary()))
                    .toList();
            // 计划存在服务端，前端只拿 token；确认时用的永远是这份数据
            String token = snapshot.pending() == null ? null : planStore.save(userId, sessionId, snapshot.pending());
            // 修改场景：新计划一生成，同一会话里的旧计划立即失效，避免两个 token 指向同一件事
            if (token != null && active != null && !active.token().equals(token)) {
                planStore.supersede(userId, active.token());
            }
            log.info("agent run petId={} tools=[{}] pending={} revised={} failed={} answerChars={} ms={} question=\"{}\"",
                    pet.getId(),
                    snapshot.calls().stream().map(AgentContext.ToolCall::name).toList(),
                    token != null, active != null && token != null, snapshot.failed(), snapshot.content().length(),
                    System.currentTimeMillis() - started, excerpt(question));
            return new AgentResult(snapshot.content().trim(), docs, calls,
                    toPending(snapshot.pending(), token), snapshot.failed());
        } catch (Exception e) {
            log.warn("agent fallback petId={} reason={} ms={} question=\"{}\"",
                    pet.getId(), e.toString(), System.currentTimeMillis() - started, excerpt(question));
            return null;
        }
    }

    private AgentContext.Snapshot invoke(Long userId, Long petId, String message, long timeoutMs) throws Exception {
        FutureTask<AgentContext.Snapshot> task = new FutureTask<>(() -> {
            AgentContext.open(userId, petId);
            try {
                return AgentContext.snapshot(assistant.chat(message));
            } finally {
                AgentContext.close();
            }
        });
        executor.execute(task);
        try {
            return task.get(timeoutMs, TimeUnit.MILLISECONDS);
        } catch (TimeoutException e) {
            // 中断只保证不再等结果；底层 HTTP 请求由模型自身的 12 秒超时兜底
            task.cancel(true);
            throw e;
        }
    }

    /** 截止时间减去响应预留，得到还能给模型用多久。 */
    private long budgetLeft(long deadlineMillis) {
        return deadlineMillis - System.currentTimeMillis() - RESPONSE_RESERVE_MS;
    }

    private PendingAction toPending(AgentContext.PendingAction pending, String token) {
        if (pending == null) {
            return null;
        }
        return new PendingAction(token, pending.type(), pending.petId(), pending.title(),
                pending.reminderType(), pending.remindDate(), pending.remindTime(),
                pending.repeatRule(), pending.repeatDays(), pending.summary());
    }

    private String excerpt(String question) {
        String text = question == null ? "" : question.replaceAll("\\s+", " ").trim();
        return text.length() <= 40 ? text : text.substring(0, 40) + "…";
    }

    /** 只在问题确实指向宠物自身数据时才强制重试，避免纯科普问题多跑一轮。 */
    private boolean needsTools(String question) {
        if (question == null) {
            return false;
        }
        String text = question.toLowerCase();
        return List.of("体重", "胖", "瘦", "bcs", "喂食", "吃了", "打卡",
                        "提醒", "疫苗", "驱虫", "照顾", "漏")
                .stream().anyMatch(text::contains);
    }

    private String buildUserMessage(PetDO pet, String question,
                                    List<KnowledgeChatService.ChatMessage> history,
                                    AgentPlanStore.ActivePlan active) {
        StringBuilder text = new StringBuilder();
        String context = historyText(history);
        if (!context.isBlank()) {
            text.append("【最近对话】\n").append(context).append("\n\n");
        }
        LocalDate today = LocalDate.now();
        text.append("【今天】").append(today).append(" ").append(weekdayText(today)).append("\n");
        text.append("【当前宠物】").append(pet.getName()).append("（").append(speciesText(pet.getSpecies()));
        if (pet.getBreed() != null && !pet.getBreed().isBlank()) {
            text.append("·").append(pet.getBreed());
        }
        text.append("）\n");
        if (active != null) {
            text.append(pendingText(active.plan()));
        }
        text.append("【问题】").append(question == null ? "" : question.trim());
        return text.toString();
    }

    /** 把会话里还没确认的计划交给模型，让「改成晚上八点」这类追问有可修改的对象。 */
    private String pendingText(AgentContext.PendingAction plan) {
        StringBuilder text = new StringBuilder("【待确认计划，尚未保存】\n");
        text.append(plan.summary()).append("\n");
        text.append("类型：").append(plan.reminderType()).append("；标题：").append(plan.title()).append("\n");
        text.append("日期：").append(plan.remindDate() == null ? "周期提醒，无固定日期" : plan.remindDate())
                .append("；时间：").append(plan.remindTime())
                .append("；周期：").append(plan.repeatRule());
        if (plan.repeatDays() != null && !plan.repeatDays().isBlank()) {
            text.append("（星期 ").append(plan.repeatDays()).append("，1=周一…7=周日）");
        }
        return text.append("\n\n").toString();
    }

    /** 从最近往回取，避免长会话把 prompt 撑爆；顺序还原成从旧到新。 */
    private String historyText(List<KnowledgeChatService.ChatMessage> history) {
        if (history == null || history.isEmpty()) {
            return "";
        }
        List<String> lines = new ArrayList<>();
        int chars = 0;
        for (int i = history.size() - 1; i >= 0 && lines.size() < HISTORY_LIMIT; i--) {
            KnowledgeChatService.ChatMessage message = history.get(i);
            String content = message.content() == null ? "" : message.content().replaceAll("\\s+", " ").trim();
            if (content.isEmpty()) {
                continue;
            }
            if (content.length() > 200) {
                content = content.substring(0, 200) + "…";
            }
            String line = ("user".equals(message.role()) ? "用户：" : "助手：") + content;
            if (chars + line.length() > HISTORY_CHAR_LIMIT) {
                break;
            }
            lines.add(line);
            chars += line.length();
        }
        Collections.reverse(lines);
        return String.join("\n", lines);
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

    private String weekdayText(LocalDate date) {
        return "周" + "一二三四五六日".charAt(date.getDayOfWeek().getValue() - 1);
    }
}
