package com.purr.furguardian.web.dto.pet;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;

import java.math.BigDecimal;
import java.time.LocalDate;

public class WeightLogDTO {

    @NotNull(message = "体重不能为空")
    @DecimalMin(value = "0.1", message = "体重需大于 0.1kg")
    @DecimalMax(value = "500", message = "体重不能超过 500kg")
    @Digits(integer = 3, fraction = 2, message = "体重最多保留两位小数")
    @Schema(description = "体重(kg)", example = "5.0")
    private BigDecimal weightKg;

    @Min(value = 1, message = "体况评分范围为 1-9")
    @Max(value = 9, message = "体况评分范围为 1-9")
    @Schema(description = "体况评分1-9", example = "5")
    private Integer bcs;

    @PastOrPresent(message = "记录日期不能晚于今天")
    @Schema(description = "记录日期", example = "2026-10-17")
    private LocalDate recordedAt;

    public BigDecimal getWeightKg() { return weightKg; }
    public void setWeightKg(BigDecimal weightKg) { this.weightKg = weightKg; }
    public Integer getBcs() { return bcs; }
    public void setBcs(Integer bcs) { this.bcs = bcs; }
    public LocalDate getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDate recordedAt) { this.recordedAt = recordedAt; }
}
