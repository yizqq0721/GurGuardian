package com.purr.furguardian.web.dto.knowledge;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public class ChatRenameDTO {

    @NotBlank(message = "标题不能为空")
    @Schema(example = "幼犬喂养咨询", description = "新标题")
    private String title;

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
}
