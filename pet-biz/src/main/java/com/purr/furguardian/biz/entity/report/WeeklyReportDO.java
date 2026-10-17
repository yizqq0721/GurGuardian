package com.purr.furguardian.biz.entity.report;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("weekly_reports")
public class WeeklyReportDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long petId;
    private Long userId;
    private LocalDate weekStart;
    private LocalDate weekEnd;
    private BigDecimal weightStartKg;
    private BigDecimal weightEndKg;
    private BigDecimal weightChangePct;
    private Integer bcsStart;
    private Integer bcsEnd;
    private BigDecimal feedingCompliance;
    private Integer snackOverLimit;
    private String ruleConclusions;
    private String llmSummary;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDate getWeekStart() { return weekStart; }
    public void setWeekStart(LocalDate weekStart) { this.weekStart = weekStart; }
    public LocalDate getWeekEnd() { return weekEnd; }
    public void setWeekEnd(LocalDate weekEnd) { this.weekEnd = weekEnd; }
    public BigDecimal getWeightStartKg() { return weightStartKg; }
    public void setWeightStartKg(BigDecimal weightStartKg) { this.weightStartKg = weightStartKg; }
    public BigDecimal getWeightEndKg() { return weightEndKg; }
    public void setWeightEndKg(BigDecimal weightEndKg) { this.weightEndKg = weightEndKg; }
    public BigDecimal getWeightChangePct() { return weightChangePct; }
    public void setWeightChangePct(BigDecimal weightChangePct) { this.weightChangePct = weightChangePct; }
    public Integer getBcsStart() { return bcsStart; }
    public void setBcsStart(Integer bcsStart) { this.bcsStart = bcsStart; }
    public Integer getBcsEnd() { return bcsEnd; }
    public void setBcsEnd(Integer bcsEnd) { this.bcsEnd = bcsEnd; }
    public BigDecimal getFeedingCompliance() { return feedingCompliance; }
    public void setFeedingCompliance(BigDecimal feedingCompliance) { this.feedingCompliance = feedingCompliance; }
    public Integer getSnackOverLimit() { return snackOverLimit; }
    public void setSnackOverLimit(Integer snackOverLimit) { this.snackOverLimit = snackOverLimit; }
    public String getRuleConclusions() { return ruleConclusions; }
    public void setRuleConclusions(String ruleConclusions) { this.ruleConclusions = ruleConclusions; }
    public String getLlmSummary() { return llmSummary; }
    public void setLlmSummary(String llmSummary) { this.llmSummary = llmSummary; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
