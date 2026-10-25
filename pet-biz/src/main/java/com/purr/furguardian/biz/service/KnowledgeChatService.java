package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeChatSessionDO;
import com.purr.furguardian.common.result.CursorPage;

import java.time.LocalDateTime;
import java.util.List;

public interface KnowledgeChatService {

    /** 回答引用的知识条目快照：正文可能被改被删，标题和来源要留在会话里。 */
    record ChatSource(Long docId, String title, String sourceName, String sourceType, String severity) {}

    record ChatMessage(Long id, String role, String content, List<ChatSource> sources,
                       Boolean isRedLine, Boolean isFallback, Integer feedback,
                       LocalDateTime createdAt) {}

    /** 被标为「没用」的回答，只留摘要给统计面板展示。 */
    record FeedbackSample(Long messageId, Long sessionId, String snippet, LocalDateTime createdAt) {}

    /** 反馈读数：total 只算可评价的 AI 回答（红线回答没有评分入口）。 */
    record FeedbackStats(long total, long useful, long useless, long unrated,
                         int usefulRate, List<FeedbackSample> recentUseless) {}

    /**
     * 一轮问答。回答由 /api/ai/query 生成，这里只负责把它和问题一起存进会话；
     * sourceDocIds 由服务端回查 knowledge_docs 补全，不采信前端传来的来源文本。
     */
    record Exchange(String question, String answer, List<Long> sourceDocIds,
                    boolean redLine, boolean fallback) {}

    CursorPage<KnowledgeChatSessionDO> listSessions(Long userId, LocalDateTime cursor, int limit);

    KnowledgeChatSessionDO createSession(Long userId, String title, Long petId);

    void renameSession(Long userId, Long sessionId, String title);

    void deleteSession(Long userId, Long sessionId);

    CursorPage<ChatMessage> listMessages(Long userId, Long sessionId, LocalDateTime cursor, int limit);

    void appendExchange(Long userId, Long sessionId, Exchange exchange);

    /** 对一条 AI 回答打分：1=有用，0=没用；只能改自己的回答。 */
    void rateMessage(Long userId, Long messageId, boolean useful);

    /** 当前用户的回答反馈读数，用于展示有用率和最近差评。 */
    FeedbackStats feedbackStats(Long userId);
}
