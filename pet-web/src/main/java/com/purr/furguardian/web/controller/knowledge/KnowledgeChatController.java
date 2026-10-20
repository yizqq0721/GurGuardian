package com.purr.furguardian.web.controller.knowledge;

import com.purr.furguardian.biz.entity.knowledge.KnowledgeChatSessionDO;
import com.purr.furguardian.biz.service.KnowledgeChatService;
import com.purr.furguardian.biz.service.KnowledgeChatService.ChatMessage;
import com.purr.furguardian.biz.service.KnowledgeChatService.Exchange;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.CursorPage;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.knowledge.ChatCreateDTO;
import com.purr.furguardian.web.dto.knowledge.ChatExchangeDTO;
import com.purr.furguardian.web.dto.knowledge.ChatRenameDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/knowledge")
@Tag(name = "知识库问答会话")
public class KnowledgeChatController {

    private final KnowledgeChatService chatService;

    public KnowledgeChatController(KnowledgeChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/chats")
    @Operation(summary = "会话列表",
               description = "按 updated_at 倒序游标翻页，cursor 传上一页返回的 nextCursor，首次请求留空")
    public Result<CursorPage<KnowledgeChatSessionDO>> chats(
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime cursor,
            @RequestParam(defaultValue = "20") int limit) {
        return Result.ok(chatService.listSessions(UserContext.getUserId(), cursor, limit));
    }

    @PostMapping("/chats")
    @Operation(summary = "新建会话", description = "标题可空，前端一般直接拿首问前 20 字当标题")
    public Result<KnowledgeChatSessionDO> create(@RequestBody(required = false) ChatCreateDTO dto) {
        ChatCreateDTO body = dto == null ? new ChatCreateDTO() : dto;
        return Result.ok(chatService.createSession(
                UserContext.getUserId(), body.getTitle(), body.getPetId()));
    }

    @PutMapping("/chats/{id}")
    @Operation(summary = "重命名会话", description = "只改标题，不影响左栏排序")
    public Result<Void> rename(@PathVariable Long id, @RequestBody @Valid ChatRenameDTO dto) {
        chatService.renameSession(UserContext.getUserId(), id, dto.getTitle());
        return Result.ok();
    }

    @DeleteMapping("/chats/{id}")
    @Operation(summary = "删除会话", description = "会话和它下面的消息一起删除")
    public Result<Void> delete(@PathVariable Long id) {
        chatService.deleteSession(UserContext.getUserId(), id);
        return Result.ok();
    }

    @GetMapping("/chats/{id}/messages")
    @Operation(summary = "会话消息",
               description = "首次返回最近 limit 条（正序，最早在前）；向上翻页时 cursor 传当前最早一条的时间")
    public Result<CursorPage<ChatMessage>> messages(
            @PathVariable Long id,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime cursor,
            @RequestParam(defaultValue = "10") int limit) {
        return Result.ok(chatService.listMessages(UserContext.getUserId(), id, cursor, limit));
    }

    @PostMapping("/chats/{id}/messages")
    @Operation(summary = "落库一轮问答",
               description = "问题与 /api/ai/query 的回答一起提交，服务端拆成两条消息并刷新会话排序时间")
    public Result<Void> append(@PathVariable Long id, @RequestBody @Valid ChatExchangeDTO dto) {
        chatService.appendExchange(UserContext.getUserId(), id, new Exchange(
                dto.getQuestion(), dto.getAnswer(), dto.getSourceDocIds(),
                dto.getIsRedLine(), dto.getIsFallback()));
        return Result.ok();
    }
}
