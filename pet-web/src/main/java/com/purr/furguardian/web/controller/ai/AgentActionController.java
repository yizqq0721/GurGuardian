package com.purr.furguardian.web.controller.ai;

import com.purr.furguardian.ai.agent.AgentActionService;
import com.purr.furguardian.ai.agent.AgentPlanStore;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai/actions")
@Tag(name = "AI写操作")
public class AgentActionController {

    private final AgentActionService actionService;

    public AgentActionController(AgentActionService actionService) {
        this.actionService = actionService;
    }

    @PostMapping("/{token}/confirm")
    @Operation(summary = "确认执行 Agent 计划",
               description = "凭服务端下发的 token 落库，落库字段来自服务端保存的计划；同一 token 重复确认只创建一次")
    public Result<ConfirmedView> confirm(@PathVariable String token) {
        AgentPlanStore.Confirmed confirmed =
                actionService.confirmReminder(UserContext.getUserId(), token);
        return Result.ok(new ConfirmedView(confirmed.reminderId(), confirmed.summary(),
                confirmed.repeated()));
    }

    @Schema(description = "确认结果")
    public static class ConfirmedView {
        @Schema(description = "创建出来的提醒ID", example = "27")
        private Long reminderId;
        @Schema(description = "计划摘要", example = "10月28日 09:00 · 驱虫·每月驱虫")
        private String summary;
        @Schema(description = "是否为重复确认（true 表示之前已经创建过，本次没有新建）", example = "false")
        private boolean repeated;

        public ConfirmedView() {}
        public ConfirmedView(Long reminderId, String summary, boolean repeated) {
            this.reminderId = reminderId;
            this.summary = summary;
            this.repeated = repeated;
        }

        public Long getReminderId() { return reminderId; }
        public void setReminderId(Long reminderId) { this.reminderId = reminderId; }
        public String getSummary() { return summary; }
        public void setSummary(String summary) { this.summary = summary; }
        public boolean getRepeated() { return repeated; }
        public void setRepeated(boolean repeated) { this.repeated = repeated; }
    }
}
