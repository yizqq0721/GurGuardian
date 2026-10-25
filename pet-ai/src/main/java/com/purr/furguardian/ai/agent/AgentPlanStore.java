package com.purr.furguardian.ai.agent;

import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.util.Comparator;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;

/**
 * Agent 写操作计划的服务端副本（进程内，10 分钟有效）。
 * 前端只拿到 token 和展示文案，确认时落库用的是这里存的字段，客户端改不了计划内容；
 * 同一个 token 只会真正写一次，重复确认返回第一次的结果。
 * 计划同时绑定会话：同一会话里的后续追问可以读到它，用于「改成晚上八点」这类修订。
 */
@Component
public class AgentPlanStore {

    private static final Duration TTL = Duration.ofMinutes(10);

    public record Confirmed(Long reminderId, String summary, boolean repeated) {}

    public record ActivePlan(String token, AgentContext.PendingAction plan) {}

    static final class Entry {
        final Long userId;
        final Long sessionId;
        final AgentContext.PendingAction plan;
        final Instant createdAt = Instant.now();
        Long reminderId;

        Entry(Long userId, Long sessionId, AgentContext.PendingAction plan) {
            this.userId = userId;
            this.sessionId = sessionId;
            this.plan = plan;
        }

        boolean expired() {
            return createdAt.plus(TTL).isBefore(Instant.now());
        }

        boolean pending(Long userId) {
            return this.userId.equals(userId) && reminderId == null && !expired();
        }
    }

    private final Map<String, Entry> plans = new ConcurrentHashMap<>();

    public String save(Long userId, Long sessionId, AgentContext.PendingAction plan) {
        prune();
        String token = UUID.randomUUID().toString().replace("-", "");
        plans.put(token, new Entry(userId, sessionId, plan));
        return token;
    }

    /** 会话里最近的待确认计划；token 优先，找不到再按会话兜底。 */
    public Optional<ActivePlan> resolve(Long userId, Long sessionId, String token) {
        prune();
        Entry byToken = token == null ? null : plans.get(token);
        if (byToken != null && byToken.pending(userId)) {
            return Optional.of(new ActivePlan(token, byToken.plan));
        }
        if (sessionId == null) {
            return Optional.empty();
        }
        return plans.entrySet().stream()
                .filter(e -> e.getValue().pending(userId) && sessionId.equals(e.getValue().sessionId))
                .max(Comparator.comparing(e -> e.getValue().createdAt))
                .map(e -> new ActivePlan(e.getKey(), e.getValue().plan));
    }

    /** 生成修改后的新计划时调用：旧 token 立即失效，之后再确认会返回 404。 */
    public void supersede(Long userId, String token) {
        if (token == null) {
            return;
        }
        Entry entry = plans.get(token);
        if (entry != null && entry.userId.equals(userId)) {
            plans.remove(token);
        }
    }

    public Confirmed confirm(String token, Long userId,
                             Function<AgentContext.PendingAction, Long> creator) {
        Entry entry = require(token, userId);
        synchronized (entry) {
            if (entry.reminderId != null) {
                return new Confirmed(entry.reminderId, entry.plan.summary(), true);
            }
            Long reminderId = creator.apply(entry.plan);
            entry.reminderId = reminderId;
            return new Confirmed(reminderId, entry.plan.summary(), false);
        }
    }

    private Entry require(String token, Long userId) {
        Entry entry = token == null ? null : plans.get(token);
        if (entry == null || !entry.userId.equals(userId)) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "提醒计划不存在或已失效，请重新提问生成");
        }
        if (entry.expired()) {
            plans.remove(token);
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "提醒计划已过期，请重新提问生成");
        }
        return entry;
    }

    private void prune() {
        plans.entrySet().removeIf(e -> e.getValue().expired());
    }
}
