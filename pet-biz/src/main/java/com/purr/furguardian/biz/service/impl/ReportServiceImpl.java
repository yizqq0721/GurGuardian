package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.dto.report.ReportConclusion;
import com.purr.furguardian.biz.dto.report.ReportConclusion.RuleResult;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.entity.report.FeedingPlanDO;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.pet.PetWeightLogMapper;
import com.purr.furguardian.biz.mapper.report.FeedingPlanMapper;
import com.purr.furguardian.biz.mapper.report.WeeklyReportMapper;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.biz.service.ReportService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;
import tools.jackson.databind.ObjectMapper;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReportServiceImpl implements ReportService {

    private final PetService petService;
    private final PetWeightLogMapper weightLogMapper;
    private final FeedingPlanMapper planMapper;
    private final WeeklyReportMapper reportMapper;
    private final ObjectMapper objectMapper;

    public ReportServiceImpl(PetService petService, PetWeightLogMapper weightLogMapper,
                             FeedingPlanMapper planMapper, WeeklyReportMapper reportMapper,
                             ObjectMapper objectMapper) {
        this.petService = petService;
        this.weightLogMapper = weightLogMapper;
        this.planMapper = planMapper;
        this.reportMapper = reportMapper;
        this.objectMapper = objectMapper;
    }

    @Override
    public WeeklyReportDO generateWeeklyReport(Long userId, Long petId, LocalDate weekStart) {
        PetDO pet = petService.getPet(userId, petId);
        LocalDate weekEnd = weekStart.plusDays(6);

        List<PetWeightLogDO> weekWeights = getWeightsInRange(userId, petId, weekStart, weekEnd);
        List<PetWeightLogDO> prevWeekWeights = getWeightsInRange(userId, petId, weekStart.minusWeeks(1), weekStart.minusDays(1));

        BigDecimal weightStart = prevWeekWeights.isEmpty() ?
                (weekWeights.isEmpty() ? null : weekWeights.get(0).getWeightKg()) :
                prevWeekWeights.get(0).getWeightKg();
        BigDecimal weightEnd = weekWeights.isEmpty() ? null : weekWeights.get(weekWeights.size() - 1).getWeightKg();

        BigDecimal weightChangePct = null;
        if (weightStart != null && weightEnd != null && weightStart.compareTo(BigDecimal.ZERO) > 0) {
            weightChangePct = weightEnd.subtract(weightStart)
                    .divide(weightStart, 4, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100))
                    .setScale(2, RoundingMode.HALF_UP);
        }

        Integer bcsStart = prevWeekWeights.isEmpty() ?
                (weekWeights.isEmpty() ? null : weekWeights.get(0).getBcs()) :
                prevWeekWeights.get(0).getBcs();
        Integer bcsEnd = weekWeights.isEmpty() ? null : weekWeights.get(weekWeights.size() - 1).getBcs();

        ReportConclusion conclusions = evaluateRules(pet, weightChangePct, bcsStart, bcsEnd, weekStart);

        WeeklyReportDO report = new WeeklyReportDO();
        report.setPetId(petId);
        report.setUserId(userId);
        report.setWeekStart(weekStart);
        report.setWeekEnd(weekEnd);
        report.setWeightStartKg(weightStart);
        report.setWeightEndKg(weightEnd);
        report.setWeightChangePct(weightChangePct);
        report.setBcsStart(bcsStart);
        report.setBcsEnd(bcsEnd);
        report.setSnackOverLimit(0);
        try {
            report.setRuleConclusions(objectMapper.writeValueAsString(conclusions));
        } catch (Exception e) {
            report.setRuleConclusions("{}");
        }
        report.setStatus("generated");
        report.setCreatedAt(LocalDateTime.now());
        report.setUpdatedAt(LocalDateTime.now());
        reportMapper.insert(report);

        return report;
    }

    @Override
    public WeeklyReportDO getReport(Long userId, Long reportId) {
        LambdaQueryWrapper<WeeklyReportDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeeklyReportDO::getId, reportId).eq(WeeklyReportDO::getUserId, userId);
        WeeklyReportDO report = reportMapper.selectOne(wrapper);
        if (report == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "周报不存在");
        }
        return report;
    }

    @Override
    public void updateReport(WeeklyReportDO report) {
        report.setUpdatedAt(LocalDateTime.now());
        reportMapper.updateById(report);
    }

    @Override
    public List<WeeklyReportDO> listReports(Long userId, Long petId) {
        LambdaQueryWrapper<WeeklyReportDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeeklyReportDO::getUserId, userId)
                .eq(WeeklyReportDO::getPetId, petId)
                .orderByDesc(WeeklyReportDO::getWeekStart);
        return reportMapper.selectList(wrapper);
    }

    @Override
    public ReportConclusion getRuleConclusions(Long userId, Long reportId) {
        WeeklyReportDO report = getReport(userId, reportId);
        try {
            if (report.getRuleConclusions() != null && !report.getRuleConclusions().isEmpty()) {
                return objectMapper.readValue(report.getRuleConclusions(), ReportConclusion.class);
            }
        } catch (Exception e) {
            // ignore parse error
        }
        return new ReportConclusion();
    }

    private ReportConclusion evaluateRules(PetDO pet, BigDecimal weightChangePct,
                                           Integer bcsStart, Integer bcsEnd, LocalDate weekStart) {
        ReportConclusion conclusion = new ReportConclusion();
        List<RuleResult> rules = new ArrayList<>();

        // Rule 1: 连续2周体重上升>3% → 建议下调日粮10%
        boolean weightRising = weightChangePct != null && weightChangePct.compareTo(BigDecimal.valueOf(3)) > 0;
        rules.add(new RuleResult(
                "WEIGHT_RISING_3PCT",
                "体重连续上升超3%",
                weightRising,
                weightRising ? "warning" : "info",
                weightRising ? "建议下调日粮10%，3周后复评" : null,
                weightRising ? String.format("本周体重环比变化: %.2f%%", weightChangePct.doubleValue()) : null
        ));

        // Rule 2: 体重下降>5%且非减重计划 → 建议就医排查
        boolean weightDrop = weightChangePct != null && weightChangePct.compareTo(BigDecimal.valueOf(-5)) < 0;
        boolean isWeightLossPlan = bcsStart != null && bcsStart >= 6;
        boolean dangerousDrop = weightDrop && !isWeightLossPlan;
        rules.add(new RuleResult(
                "WEIGHT_DROP_5PCT",
                "体重下降超5%(非减重计划)",
                dangerousDrop,
                dangerousDrop ? "danger" : "info",
                dangerousDrop ? "建议尽快就医排查" : null,
                dangerousDrop ? String.format("本周体重环比变化: %.2f%%", weightChangePct.doubleValue()) : null
        ));

        // Rule 3: BCS变化预警
        boolean bcsWorsen = bcsStart != null && bcsEnd != null && bcsEnd - bcsStart >= 2;
        boolean bcsImprove = bcsStart != null && bcsEnd != null && bcsStart - bcsEnd >= 2;
        rules.add(new RuleResult(
                "BCS_CHANGE",
                "体况评分显著变化",
                bcsWorsen || bcsImprove,
                bcsWorsen ? "warning" : "info",
                bcsWorsen ? "体况恶化，建议调整饮食并咨询兽医" : (bcsImprove ? "体况改善，继续保持" : null),
                (bcsWorsen || bcsImprove) ? String.format("BCS: %d → %d", bcsStart, bcsEnd) : null
        ));

        // Rule 4: 老年宠物(≥7岁) → 提示体检频率
        long ageMonths = 0;
        if (pet.getBirthday() != null) {
            ageMonths = ChronoUnit.MONTHS.between(pet.getBirthday(), weekStart);
        }
        boolean isSenior = ageMonths >= 84;
        rules.add(new RuleResult(
                "SENIOR_CHECKUP",
                "老年宠物体检提醒",
                isSenior,
                "info",
                isSenior ? "建议体检频率提高到半年一次" : null,
                isSenior ? String.format("宠物年龄约%d个月(≥7岁)", ageMonths) : null
        ));

        conclusion.setRules(rules);

        long triggeredCount = rules.stream().filter(RuleResult::isTriggered).count();
        conclusion.setSummary(String.format("本周共触发%d条规则建议", triggeredCount));

        return conclusion;
    }

    private List<PetWeightLogDO> getWeightsInRange(Long userId, Long petId, LocalDate start, LocalDate end) {
        LambdaQueryWrapper<PetWeightLogDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PetWeightLogDO::getUserId, userId)
                .eq(PetWeightLogDO::getPetId, petId)
                .ge(PetWeightLogDO::getRecordedAt, start)
                .le(PetWeightLogDO::getRecordedAt, end)
                .orderByAsc(PetWeightLogDO::getRecordedAt);
        return weightLogMapper.selectList(wrapper);
    }
}
