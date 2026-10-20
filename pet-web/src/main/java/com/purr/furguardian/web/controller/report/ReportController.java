package com.purr.furguardian.web.controller.report;

import com.purr.furguardian.biz.dto.report.ReportConclusion;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.service.ReportService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/report")
@Tag(name = "周报管理")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @PostMapping("/generate")
    @Operation(summary = "生成周报", description = "规则引擎生成结构化结论，供后端2 LLM润色")
    public Result<WeeklyReportDO> generate(
            @RequestParam Long petId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate weekStart) {
        WeeklyReportDO report = reportService.generateWeeklyReport(UserContext.getUserId(), petId, weekStart);
        return Result.ok(report);
    }

    @GetMapping("/{id}")
    @Operation(summary = "周报详情")
    public Result<WeeklyReportDO> detail(@PathVariable Long id) {
        return Result.ok(reportService.getReport(UserContext.getUserId(), id));
    }

    @GetMapping("/{id}/conclusions")
    @Operation(summary = "规则引擎结论", description = "获取结构化规则结论(供LLM润色)")
    public Result<ReportConclusion> conclusions(@PathVariable Long id) {
        return Result.ok(reportService.getRuleConclusions(UserContext.getUserId(), id));
    }

    @GetMapping("/list")
    @Operation(summary = "周报列表")
    public Result<List<WeeklyReportDO>> list(@RequestParam Long petId) {
        return Result.ok(reportService.listReports(UserContext.getUserId(), petId));
    }
}
