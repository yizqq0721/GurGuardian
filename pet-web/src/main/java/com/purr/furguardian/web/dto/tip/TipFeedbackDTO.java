package com.purr.furguardian.web.dto.tip;

import io.swagger.v3.oas.annotations.media.Schema;

public class TipFeedbackDTO {

    @Schema(example = "like", description = "反馈类型: like / dislike")
    private String feedback;

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
}
