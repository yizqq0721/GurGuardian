package com.purr.furguardian.web.dto.knowledge;

import io.swagger.v3.oas.annotations.media.Schema;

public class ChatCreateDTO {

    @Schema(example = "幼犬一天喂几顿", description = "会话标题，留空则由服务端取「新对话」")
    private String title;

    @Schema(example = "1", description = "提问时选中的宠物ID")
    private Long petId;

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
}
