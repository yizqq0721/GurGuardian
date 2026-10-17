package com.purr.furguardian.ai.service;

import com.purr.furguardian.biz.dto.report.ReportConclusion;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.biz.service.ReportService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import tools.jackson.databind.ObjectMapper;

@Service
public class ReportPolishService {

    private static final Logger log = LoggerFactory.getLogger(ReportPolishService.class);

    private final ReportService reportService;
    private final PetService petService;
    private final LlmService llmService;
    private final PromptTemplates promptTemplates;
    private final ObjectMapper objectMapper;

    public ReportPolishService(ReportService reportService,
                               PetService petService,
                               LlmService llmService,
                               PromptTemplates promptTemplates,
                               ObjectMapper objectMapper) {
        this.reportService = reportService;
        this.petService = petService;
        this.llmService = llmService;
        this.promptTemplates = promptTemplates;
        this.objectMapper = objectMapper;
    }

    public WeeklyReportDO polishReport(Long userId, Long reportId) {
        WeeklyReportDO report = reportService.getReport(userId, reportId);

        if ("polished".equals(report.getStatus())) {
            return report;
        }

        PetDO pet = petService.getPet(userId, report.getPetId());
        ReportConclusion conclusions = reportService.getRuleConclusions(userId, reportId);

        String petInfo = buildPetInfo(pet, report);
        String conclusionsJson;
        try {
            conclusionsJson = objectMapper.writeValueAsString(conclusions);
        } catch (Exception e) {
            conclusionsJson = "{}";
        }

        String llmSummary = llmService.chatWithTimeout(
                promptTemplates.getReportPolishSystemPrompt(),
                promptTemplates.buildReportPolishUserPrompt(petInfo, conclusionsJson));

        if (llmSummary == null) {
            llmSummary = buildFallbackSummary(conclusions);
        }

        report.setLlmSummary(llmSummary);
        report.setStatus("polished");
        reportService.updateReport(report);

        return report;
    }

    private String buildPetInfo(PetDO pet, WeeklyReportDO report) {
        StringBuilder sb = new StringBuilder();
        sb.append("宠物: ").append(pet.getName());
        sb.append(", 物种: ").append(pet.getSpecies());
        if (pet.getBreed() != null) sb.append(", 品种: ").append(pet.getBreed());
        if (report.getWeightStartKg() != null) {
            sb.append(", 本周体重: ").append(report.getWeightStartKg()).append("kg");
        }
        if (report.getWeightEndKg() != null) {
            sb.append(" → ").append(report.getWeightEndKg()).append("kg");
        }
        if (report.getWeightChangePct() != null) {
            sb.append(" (环比 ").append(report.getWeightChangePct()).append("%)");
        }
        if (report.getBcsStart() != null) {
            sb.append(", BCS: ").append(report.getBcsStart());
        }
        if (report.getBcsEnd() != null) {
            sb.append(" → ").append(report.getBcsEnd());
        }
        return sb.toString();
    }

    private String buildFallbackSummary(ReportConclusion conclusions) {
        StringBuilder sb = new StringBuilder();
        sb.append("本周周报摘要：\n\n");

        long triggeredCount = conclusions.getRules().stream()
                .filter(ReportConclusion.RuleResult::isTriggered)
                .count();

        if (triggeredCount == 0) {
            sb.append("本周各项指标正常，请继续保持当前的喂养和护理方式。\n");
        } else {
            sb.append(String.format("本周共触发%d条规则建议：\n\n", triggeredCount));
            for (ReportConclusion.RuleResult rule : conclusions.getRules()) {
                if (rule.isTriggered()) {
                    sb.append("• ").append(rule.getRuleName()).append("：");
                    sb.append(rule.getSuggestion()).append("\n");
                }
            }
        }

        sb.append("\n本周报由系统自动生成，仅供参考，不构成医疗建议。如有异常请及时咨询兽医。");
        return sb.toString();
    }
}
