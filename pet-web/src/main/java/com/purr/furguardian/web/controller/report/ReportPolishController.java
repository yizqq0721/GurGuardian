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
    @Operation(summary = "LLM润色周报",
               description = "将规则引擎的结构化结论润色为自然语言")
    public Result<WeeklyReportDO> polish(@PathVariable Long id) {
        WeeklyReportDO report = reportPolishService.polishReport(
                UserContext.getUserId(), id);
        return Result.ok(report);
    }

    @GetMapping("/{id}/summary")
    @Operation(summary = "获取周报润色摘要")
    public Result<String> summary(@PathVariable Long id) {
        WeeklyReportDO report = reportService.getReport(UserContext.getUserId(), id);
        return Result.ok(report.getLlmSummary());
    }
}
