package com.purr.furguardian.job;

import com.purr.furguardian.ai.service.ReportPolishService;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.service.ReportService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;

@Component
public class WeeklyReportJob {

    private static final Logger log = LoggerFactory.getLogger(WeeklyReportJob.class);

    private final PetMapper petMapper;
    private final ReportService reportService;
    private final ReportPolishService reportPolishService;

    public WeeklyReportJob(PetMapper petMapper,
                           ReportService reportService,
                           ReportPolishService reportPolishService) {
        this.petMapper = petMapper;
        this.reportService = reportService;
        this.reportPolishService = reportPolishService;
    }

    @Scheduled(cron = "0 0 8 ? * MON")
    public void generateWeeklyReports() {
        log.info("开始执行周报生成任务...");
        LocalDate lastWeekStart = LocalDate.now().minusWeeks(1)
                .with(java.time.DayOfWeek.MONDAY);

        List<PetDO> allPets = petMapper.selectList(null);
        int success = 0;
        int fail = 0;

        for (PetDO pet : allPets) {
            try {
                WeeklyReportDO report = reportService.generateWeeklyReport(
                        pet.getUserId(), pet.getId(), lastWeekStart);

                reportPolishService.polishReport(pet.getUserId(), report.getId());
                success++;
                log.info("周报生成成功: petId={}, userId={}", pet.getId(), pet.getUserId());
            } catch (Exception e) {
                fail++;
                log.error("周报生成失败: petId={}, error={}", pet.getId(), e.getMessage());
            }
        }

        log.info("周报生成任务完成: 成功{}条, 失败{}条", success, fail);
    }
}
