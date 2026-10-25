package com.purr.furguardian.web.dto.knowledge;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

public class ChatFeedbackDTO {

    @NotNull(message = "请选择是否有用")
    @Schema(description = "true=有用，false=没用", example = "true")
    private Boolean useful;

    public Boolean getUseful() { return useful; }
    public void setUseful(Boolean useful) { this.useful = useful; }
}
