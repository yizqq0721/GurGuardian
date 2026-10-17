package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.dto.report.ReportConclusion;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;

import java.time.LocalDate;
import java.util.List;

public interface ReportService {

    WeeklyReportDO generateWeeklyReport(Long userId, Long petId, LocalDate weekStart);

    WeeklyReportDO getReport(Long userId, Long reportId);

    void updateReport(WeeklyReportDO report);

    List<WeeklyReportDO> listReports(Long userId, Long petId);

    ReportConclusion getRuleConclusions(Long userId, Long reportId);
}
