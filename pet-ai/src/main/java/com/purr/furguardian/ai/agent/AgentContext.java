package com.purr.furguardian.ai.agent;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

/**
 * 一次 agent 调用的线程上下文。userId/petId 只在这里出现，
 * 工具方法一律不收 id 参数，避免模型把别的宠物的 id 传进来。
 */
final class AgentContext {

    private static final Logger log = LoggerFactory.getLogger(AgentContext.class);

    record ToolCall(String name, String label, String summary) {}

    record DocRef(Long docId, String title, String sourceName) {}

    /** 写操作一律先提案：工具只把计划放进上下文，真正落库要等用户在界面上确认。 */
    record PendingAction(String type, Long petId, String title, String reminderType,
                         String remindDate, String remindTime, String repeatRule,
                         String repeatDays, String summary) {}

    record Snapshot(String content, List<ToolCall> calls, List<DocRef> docs,
                    PendingAction pending, List<String> failed) {}

    static final class State {
        final Long userId;
        final Long petId;
        final List<ToolCall> calls = new ArrayList<>();
        final List<DocRef> docs = new ArrayList<>();
        final List<String> failed = new ArrayList<>();
        PendingAction pending;

        State(Long userId, Long petId) {
            this.userId = userId;
            this.petId = petId;
        }
    }

    private static final ThreadLocal<State> STATE = new ThreadLocal<>();

    private AgentContext() {}

    static void open(Long userId, Long petId) {
        STATE.set(new State(userId, petId));
    }

    static void close() {
        STATE.remove();
    }

    static State current() {
        State state = STATE.get();
        if (state == null) {
            throw new IllegalStateException("agent context is not open");
        }
        return state;
    }

    static void record(String name, String label, String summary) {
        current().calls.add(new ToolCall(name, label, summary));
    }

    static void recordDocs(List<KnowledgeDocDO> docs) {
        State state = current();
        for (KnowledgeDocDO doc : docs) {
            boolean seen = state.docs.stream().anyMatch(d -> d.docId().equals(doc.getId()));
            if (!seen) {
                state.docs.add(new DocRef(doc.getId(), doc.getTitle(), doc.getSourceName()));
            }
        }
    }

    static void propose(PendingAction action) {
        current().pending = action;
    }

    /**
     * 工具失败要在上下文里留痕，不能让异常文本悄悄回给模型：
     * 记一条「查询失败」轨迹、标记维度缺失，并把带有明确禁令的结果交给模型。
     */
    static String guard(String name, String label, String dimension, Supplier<String> body) {
        try {
            return body.get();
        } catch (Exception e) {
            State state = current();
            state.calls.add(new ToolCall(name, label, "查询失败"));
            if (!state.failed.contains(label)) {
                state.failed.add(label);
            }
            log.warn("agent tool failed name={} petId={}: {}", name, state.petId, e.toString());
            return "【工具失败】" + label + "查询异常（" + e.getClass().getSimpleName()
                    + "），本次没有取到" + dimension + "数据。回答时必须说明这项数据暂时查不到，"
                    + "不得给出" + dimension + "的任何数字，也不得用历史对话或常识补齐；其它维度照常回答。";
        }
    }

    static Snapshot snapshot(String content) {
        State state = current();
        return new Snapshot(content, List.copyOf(state.calls), List.copyOf(state.docs),
                state.pending, List.copyOf(state.failed));
    }
}
