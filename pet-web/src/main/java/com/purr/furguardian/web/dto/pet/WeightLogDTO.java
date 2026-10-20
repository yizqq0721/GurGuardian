package com.purr.furguardian.web.dto.pet;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.LocalDate;

public class WeightLogDTO {

    @Schema(description = "体重(kg)", example = "5.0")
    private BigDecimal weightKg;

    @Schema(description = "体况评分1-9", example = "5")
    private Integer bcs;

    @Schema(description = "记录日期", example = "2026-10-17")
    private LocalDate recordedAt;

    public BigDecimal getWeightKg() { return weightKg; }
    public void setWeightKg(BigDecimal weightKg) { this.weightKg = weightKg; }
    public Integer getBcs() { return bcs; }
    public void setBcs(Integer bcs) { this.bcs = bcs; }
    public LocalDate getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDate recordedAt) { this.recordedAt = recordedAt; }
}
