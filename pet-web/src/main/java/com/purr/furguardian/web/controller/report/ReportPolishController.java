package com.purr.furguardian.web.controller.report;

import com.purr.furguardian.ai.service.ReportPolishService;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.service.ReportService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/report")
@Tag(name = "周报LLM润色")
public class ReportPolishController {

    private final ReportPolishService reportPolishService;
    private final ReportService reportService;

    public ReportPolishController(ReportPolishService reportPolishService,
                                  ReportService reportService) {
        this.reportPolishService = reportPolishService;
        this.reportService = reportService;
    }

    @PostMapping("/{id}/polish")
    @Operation(summary = "生成/重新生成周报 AI 小结",
               description = "将规则引擎的结构化结论转写为 Markdown 小结；force=true 时强制重新生成")
    public Result<WeeklyReportDO> polish(
            @PathVariable Long id,
            @RequestParam(defaultValue = "false") boolean force) {
        WeeklyReportDO report = reportPolishService.polishReport(
                UserContext.getUserId(), id, force);
        return Result.ok(report);
    }

    @GetMapping("/{id}/summary")
    @Operation(summary = "获取周报润色摘要")
    public Result<String> summary(@PathVariable Long id) {
        WeeklyReportDO report = reportService.getReport(UserContext.getUserId(), id);
        return Result.ok(report.getLlmSummary());
    }
}
