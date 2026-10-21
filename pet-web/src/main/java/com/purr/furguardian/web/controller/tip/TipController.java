package com.purr.furguardian.web.controller.tip;

import com.purr.furguardian.ai.service.RedLineMatcher;
import com.purr.furguardian.ai.service.TipGenerationService;
import com.purr.furguardian.biz.entity.tip.TipDO;
import com.purr.furguardian.biz.service.TipService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.tip.TipFeedbackDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/tip")
@Tag(name = "每日Tip")
public class TipController {

    private final TipGenerationService tipGenerationService;
    private final TipService tipService;
    private final RedLineMatcher redLineMatcher;

    public TipController(TipGenerationService tipGenerationService,
                         TipService tipService,
                         RedLineMatcher redLineMatcher) {
        this.tipGenerationService = tipGenerationService;
        this.tipService = tipService;
        this.redLineMatcher = redLineMatcher;
    }

    @GetMapping(value = "/stream", produces = "text/event-stream")
    @Operation(summary = "SSE流式获取今日Tip",
               description = "流式返回今日养宠建议，支持mock模式")
    public SseEmitter streamTip(@RequestParam Long petId,
                                @RequestParam(defaultValue = "false") boolean mock,
                                @RequestParam(defaultValue = "false") boolean refresh) {
        return tipGenerationService.generateTipStream(
                UserContext.getUserId(), petId, mock, refresh);
    }

    @GetMapping("/today")
    @Operation(summary = "获取今日Tip(非流式)")
    public Result<TipDO> todayTip(@RequestParam Long petId,
                                  @RequestParam(defaultValue = "false") boolean mock) {
        TipDO tip = tipGenerationService.generateTipDirect(
                UserContext.getUserId(), petId, mock);
        return Result.ok(tip);
    }

    @GetMapping("/history")
    @Operation(summary = "Tip历史列表")
    public Result<List<TipDO>> history(@RequestParam Long petId,
                                       @RequestParam(defaultValue = "10") int limit) {
        return Result.ok(tipService.listTips(
                UserContext.getUserId(), petId, limit));
    }

    @PostMapping("/{tipId}/feedback")
    @Operation(summary = "Tip反馈(点赞/点踩)")
    public Result<Void> feedback(@PathVariable Long tipId,
                                 @RequestBody TipFeedbackDTO dto) {
        tipService.updateFeedback(UserContext.getUserId(), tipId, dto.getFeedback());
        return Result.ok();
    }

    @PostMapping("/check-redline")
    @Operation(summary = "红线症状检测",
               description = "检测用户描述是否包含红线症状关键词")
    public Result<Boolean> checkRedLine(@RequestParam String text) {
        boolean matched = redLineMatcher.matchRedLine(text);
        return Result.ok(matched);
    }
}
