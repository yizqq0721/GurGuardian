package com.purr.furguardian.biz.entity.report;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("feeding_plans")
public class FeedingPlanDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long petId;
    private Long userId;
    private Long foodId;
    private LocalDate effectiveDate;
    private BigDecimal rerKcal;
    private BigDecimal merKcal;
    private BigDecimal mainFoodGrams;
    private BigDecimal snackBudgetKcal;
    private Integer mealsPerDay;
    private String calculationLog;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getFoodId() { return foodId; }
    public void setFoodId(Long foodId) { this.foodId = foodId; }
    public LocalDate getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(LocalDate effectiveDate) { this.effectiveDate = effectiveDate; }
    public BigDecimal getRerKcal() { return rerKcal; }
    public void setRerKcal(BigDecimal rerKcal) { this.rerKcal = rerKcal; }
    public BigDecimal getMerKcal() { return merKcal; }
    public void setMerKcal(BigDecimal merKcal) { this.merKcal = merKcal; }
    public BigDecimal getMainFoodGrams() { return mainFoodGrams; }
    public void setMainFoodGrams(BigDecimal mainFoodGrams) { this.mainFoodGrams = mainFoodGrams; }
    public BigDecimal getSnackBudgetKcal() { return snackBudgetKcal; }
    public void setSnackBudgetKcal(BigDecimal snackBudgetKcal) { this.snackBudgetKcal = snackBudgetKcal; }
    public Integer getMealsPerDay() { return mealsPerDay; }
    public void setMealsPerDay(Integer mealsPerDay) { this.mealsPerDay = mealsPerDay; }
    public String getCalculationLog() { return calculationLog; }
    public void setCalculationLog(String calculationLog) { this.calculationLog = calculationLog; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
