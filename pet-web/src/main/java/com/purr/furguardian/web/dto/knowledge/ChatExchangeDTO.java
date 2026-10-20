package com.purr.furguardian.web.dto.knowledge;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

import java.util.List;

public class ChatExchangeDTO {

    @NotBlank(message = "问题不能为空")
    @Schema(description = "用户提问原文")
    private String question;

    @NotBlank(message = "回答不能为空")
    @Schema(description = "/api/ai/query 返回的回答原文")
    private String answer;

    @Schema(description = "回答引用的知识条目ID，按正文里 [1][2] 的顺序；来源文本由服务端回查补全")
    private List<Long> sourceDocIds;

    @Schema(description = "是否为红线症状回答", example = "false")
    private boolean isRedLine;

    @Schema(description = "是否为LLM降级的兜底回答", example = "false")
    private boolean isFallback;

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public List<Long> getSourceDocIds() { return sourceDocIds; }
    public void setSourceDocIds(List<Long> sourceDocIds) { this.sourceDocIds = sourceDocIds; }
    public boolean getIsRedLine() { return isRedLine; }
    public void setIsRedLine(boolean redLine) { isRedLine = redLine; }
    public boolean getIsFallback() { return isFallback; }
    public void setIsFallback(boolean fallback) { isFallback = fallback; }
}
