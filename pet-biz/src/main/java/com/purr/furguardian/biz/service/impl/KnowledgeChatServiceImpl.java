package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeChatMessageDO;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeChatSessionDO;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.mapper.knowledge.KnowledgeChatMessageMapper;
import com.purr.furguardian.biz.mapper.knowledge.KnowledgeChatSessionMapper;
import com.purr.furguardian.biz.mapper.knowledge.KnowledgeDocMapper;
import com.purr.furguardian.biz.service.KnowledgeChatService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.CursorPage;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class KnowledgeChatServiceImpl implements KnowledgeChatService {

    private static final int MAX_PAGE_SIZE = 50;
    private static final int TITLE_MAX_LEN = 100;
    /** 游标对外是字符串，前端原样回传即可，不用关心它的格式。 */
    private static final DateTimeFormatter CURSOR_FMT = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    private final KnowledgeChatSessionMapper sessionMapper;
    private final KnowledgeChatMessageMapper messageMapper;
    private final KnowledgeDocMapper knowledgeDocMapper;
    private final ObjectMapper objectMapper;

    public KnowledgeChatServiceImpl(KnowledgeChatSessionMapper sessionMapper,
                                    KnowledgeChatMessageMapper messageMapper,
                                    KnowledgeDocMapper knowledgeDocMapper,
                                    ObjectMapper objectMapper) {
        this.sessionMapper = sessionMapper;
        this.messageMapper = messageMapper;
        this.knowledgeDocMapper = knowledgeDocMapper;
        this.objectMapper = objectMapper;
    }

    @Override
    public CursorPage<KnowledgeChatSessionDO> listSessions(Long userId, LocalDateTime cursor, int limit) {
        LambdaQueryWrapper<KnowledgeChatSessionDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeChatSessionDO::getUserId, userId);
        if (cursor != null) {
            wrapper.lt(KnowledgeChatSessionDO::getUpdatedAt, cursor);
        }
        int size = pageSize(limit);
        wrapper.orderByDesc(KnowledgeChatSessionDO::getUpdatedAt)
               .last("LIMIT " + (size + 1));
        // 会话列表按「最近更新」倒序展示，不反转
        return page(sessionMapper.selectList(wrapper), size, KnowledgeChatSessionDO::getUpdatedAt, false);
    }

    @Override
    public KnowledgeChatSessionDO createSession(Long userId, String title, Long petId) {
        LocalDateTime now = LocalDateTime.now().truncatedTo(ChronoUnit.MILLIS);
        KnowledgeChatSessionDO session = new KnowledgeChatSessionDO();
        session.setUserId(userId);
        session.setTitle(normalizeTitle(title));
        session.setPetId(petId);
        session.setMessageCount(0);
        session.setSourceCount(0);
        session.setCreatedAt(now);
        session.setUpdatedAt(now);
        sessionMapper.insert(session);
        return session;
    }

    @Override
    public void renameSession(Long userId, Long sessionId, String title) {
        KnowledgeChatSessionDO session = requireOwned(userId, sessionId);
        session.setTitle(normalizeTitle(title));
        // updated_at 按加载时的旧值写回，重命名不会把会话顶到列表最前面
        sessionMapper.updateById(session);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSession(Long userId, Long sessionId) {
        requireOwned(userId, sessionId);
        // 消息不跟着删的话，详情接口还能查到别人以为已经删掉的内容
        LambdaQueryWrapper<KnowledgeChatMessageDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeChatMessageDO::getSessionId, sessionId);
        messageMapper.delete(wrapper);
        sessionMapper.deleteById(sessionId);
    }

    @Override
    public CursorPage<ChatMessage> listMessages(Long userId, Long sessionId, LocalDateTime cursor, int limit) {
        requireOwned(userId, sessionId);
        LambdaQueryWrapper<KnowledgeChatMessageDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeChatMessageDO::getSessionId, sessionId);
        if (cursor != null) {
            wrapper.lt(KnowledgeChatMessageDO::getCreatedAt, cursor);
        }
        int size = pageSize(limit);
        wrapper.orderByDesc(KnowledgeChatMessageDO::getCreatedAt)
               .last("LIMIT " + (size + 1));
        return page(messageMapper.selectList(wrapper), size,
                KnowledgeChatMessageDO::getCreatedAt, true).map(this::toMessage);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void appendExchange(Long userId, Long sessionId, Exchange exchange) {
        KnowledgeChatSessionDO session = requireOwned(userId, sessionId);
        List<ChatSource> sources = resolveSources(exchange.sourceDocIds());
        LocalDateTime askedAt = LocalDateTime.now().truncatedTo(ChronoUnit.MILLIS);
        // 回答比问题晚 1ms：两条落在同一毫秒的话，游标 "created_at < cursor" 会把它们一起跳过
        LocalDateTime answeredAt = askedAt.plus(1, ChronoUnit.MILLIS);

        messageMapper.insert(newMessage(sessionId, userId, "user", exchange.question(), null, false, false, askedAt));
        messageMapper.insert(newMessage(sessionId, userId, "ai", exchange.answer(),
                writeSources(sources), exchange.redLine(), exchange.fallback(), answeredAt));

        session.setMessageCount(intOrZero(session.getMessageCount()) + 2);
        session.setSourceCount(intOrZero(session.getSourceCount()) + sources.size());
        session.setUpdatedAt(answeredAt);
        sessionMapper.updateById(session);
    }

    private KnowledgeChatSessionDO requireOwned(Long userId, Long sessionId) {
        LambdaQueryWrapper<KnowledgeChatSessionDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(KnowledgeChatSessionDO::getId, sessionId)
               .eq(KnowledgeChatSessionDO::getUserId, userId);
        KnowledgeChatSessionDO session = sessionMapper.selectOne(wrapper);
        if (session == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND);
        }
        return session;
    }

    /** 倒序取回来的行：先算游标（游标是本页第 1 页最后一行，即最早的一条），再反转成正序渲染。 */
    private <T> CursorPage<T> page(List<T> rows, int size,
                                   Function<T, LocalDateTime> cursorOf, boolean oldestFirst) {
        boolean hasMore = rows.size() > size;
        List<T> kept = new ArrayList<>(hasMore ? rows.subList(0, size) : rows);
        String nextCursor = kept.isEmpty()
                ? null
                : cursorOf.apply(kept.get(kept.size() - 1)).format(CURSOR_FMT);
        if (oldestFirst) {
            Collections.reverse(kept);
        }
        return new CursorPage<>(kept, nextCursor, hasMore);
    }

    /** 只认 docId：标题、来源、严重度都回 knowledge_docs 取，前端传什么都不信。 */
    private List<ChatSource> resolveSources(List<Long> docIds) {
        if (docIds == null || docIds.isEmpty()) {
            return List.of();
        }
        List<Long> ids = docIds.stream().filter(Objects::nonNull).distinct().toList();
        if (ids.isEmpty()) {
            return List.of();
        }
        LambdaQueryWrapper<KnowledgeDocDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(KnowledgeDocDO::getId, ids);
        Map<Long, KnowledgeDocDO> byId = knowledgeDocMapper.selectList(wrapper).stream()
                .collect(Collectors.toMap(KnowledgeDocDO::getId, Function.identity()));
        // 按调用方给定的顺序返回，回答正文里的 [1][2] 角标才对得上
        return ids.stream()
                .map(byId::get)
                .filter(Objects::nonNull)
                .map(doc -> new ChatSource(doc.getId(), doc.getTitle(), doc.getSourceName(),
                        doc.getSourceType(), doc.getSeverity()))
                .toList();
    }

    private KnowledgeChatMessageDO newMessage(Long sessionId, Long userId, String role, String content,
                                              String sourcesJson, boolean redLine, boolean fallback,
                                              LocalDateTime createdAt) {
        KnowledgeChatMessageDO message = new KnowledgeChatMessageDO();
        message.setSessionId(sessionId);
        message.setUserId(userId);
        message.setRole(role);
        message.setContent(content);
        message.setSourcesJson(sourcesJson);
        message.setIsRedLine(redLine ? 1 : 0);
        message.setIsFallback(fallback ? 1 : 0);
        message.setCreatedAt(createdAt);
        return message;
    }

    private ChatMessage toMessage(KnowledgeChatMessageDO row) {
        return new ChatMessage(row.getId(), row.getRole(), row.getContent(), readSources(row.getSourcesJson()),
                row.getIsRedLine() != null && row.getIsRedLine() == 1,
                row.getIsFallback() != null && row.getIsFallback() == 1,
                row.getCreatedAt());
    }

    private String writeSources(List<ChatSource> sources) {
        if (sources.isEmpty()) {
            return null;
        }
        return objectMapper.writeValueAsString(sources);
    }

    private List<ChatSource> readSources(String json) {
        if (json == null || json.isBlank()) {
            return List.of();
        }
        try {
            return List.of(objectMapper.readValue(json, ChatSource[].class));
        } catch (Exception e) {
            return List.of();
        }
    }

    private String normalizeTitle(String title) {
        String trimmed = title == null ? "" : title.trim();
        if (trimmed.isEmpty()) {
            return "新对话";
        }
        return trimmed.length() > TITLE_MAX_LEN ? trimmed.substring(0, TITLE_MAX_LEN) : trimmed;
    }

    private int pageSize(int limit) {
        return Math.min(Math.max(limit, 1), MAX_PAGE_SIZE);
    }

    private int intOrZero(Integer value) {
        return value == null ? 0 : value;
    }
}
