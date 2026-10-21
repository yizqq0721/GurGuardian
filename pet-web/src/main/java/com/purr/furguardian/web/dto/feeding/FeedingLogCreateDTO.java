package com.purr.furguardian.web.dto.feeding;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FeedingLogCreateDTO {

    @NotNull(message = "宠物ID不能为空")
    @Schema(description = "宠物ID", example = "1")
    private Long petId;

    @NotNull(message = "食品ID不能为空")
    @Schema(description = "食品库中的食品ID", example = "12")
    private Long foodId;

    @NotNull(message = "克数不能为空")
    @DecimalMin(value = "0.1", message = "克数需大于 0")
    @DecimalMax(value = "5000", message = "单餐克数不能超过 5000g")
    @Digits(integer = 4, fraction = 1, message = "克数最多保留 1 位小数")
    @Schema(description = "实际喂食克数", example = "60.0")
    private BigDecimal grams;

    @Schema(description = "喂食日期，默认今天", example = "2026-10-21")
    private LocalDate fedDate;

    @Min(value = 1, message = "餐次从 1 开始")
    @Max(value = 6, message = "餐次最多 6 餐")
    @Schema(description = "第几餐", example = "1")
    private Integer mealIndex;

    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getFoodId() { return foodId; }
    public void setFoodId(Long foodId) { this.foodId = foodId; }
    public BigDecimal getGrams() { return grams; }
    public void setGrams(BigDecimal grams) { this.grams = grams; }
    public LocalDate getFedDate() { return fedDate; }
    public void setFedDate(LocalDate fedDate) { this.fedDate = fedDate; }
    public Integer getMealIndex() { return mealIndex; }
    public void setMealIndex(Integer mealIndex) { this.mealIndex = mealIndex; }
}
