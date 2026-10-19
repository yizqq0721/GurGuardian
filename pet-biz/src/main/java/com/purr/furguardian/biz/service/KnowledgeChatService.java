package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeChatSessionDO;
import com.purr.furguardian.common.result.CursorPage;

import java.time.LocalDateTime;
import java.util.List;

public interface KnowledgeChatService {

    /** 回答引用的知识条目快照：正文可能被改被删，标题和来源要留在会话里。 */
    record ChatSource(Long docId, String title, String sourceName, String sourceType, String severity) {}

    record ChatMessage(Long id, String role, String content, List<ChatSource> sources,
                       Boolean isRedLine, Boolean isFallback, LocalDateTime createdAt) {}

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
}
