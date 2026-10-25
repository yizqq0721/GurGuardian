package com.purr.furguardian.web.dto.ai;

import io.swagger.v3.oas.annotations.media.Schema;

public class AiQueryDTO {

    @Schema(example = "我家猫最近掉毛很厉害怎么办", description = "用户提问内容")
    private String query;

    @Schema(example = "1", description = "宠物ID")
    private Long petId;

    @Schema(example = "12", description = "会话ID，传入后会带上最近几轮对话作为上下文")
    private Long sessionId;

    @Schema(description = "当前待确认计划的 token；用户修改计划时回传，便于新计划替换旧计划")
    private String pendingToken;

    public String getQuery() { return query; }
    public void setQuery(String query) { this.query = query; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }
    public String getPendingToken() { return pendingToken; }
    public void setPendingToken(String pendingToken) { this.pendingToken = pendingToken; }
}
