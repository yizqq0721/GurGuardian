package com.purr.furguardian.web.dto.ai;

import io.swagger.v3.oas.annotations.media.Schema;

public class AiQueryDTO {

    @Schema(example = "我家猫最近掉毛很厉害怎么办", description = "用户提问内容")
    private String query;

    @Schema(example = "1", description = "宠物ID")
    private Long petId;

    public String getQuery() { return query; }
    public void setQuery(String query) { this.query = query; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
}
