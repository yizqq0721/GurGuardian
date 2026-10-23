package com.purr.furguardian.biz.entity.feeding;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("feeding_logs")
public class FeedingLogDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long petId;
    private Long userId;
    private Long foodId;
    private LocalDate fedDate;
    private Integer mealIndex;
    private BigDecimal grams;
    private BigDecimal kcal;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getFoodId() { return foodId; }
    public void setFoodId(Long foodId) { this.foodId = foodId; }
    public LocalDate getFedDate() { return fedDate; }
    public void setFedDate(LocalDate fedDate) { this.fedDate = fedDate; }
    public Integer getMealIndex() { return mealIndex; }
    public void setMealIndex(Integer mealIndex) { this.mealIndex = mealIndex; }
    public BigDecimal getGrams() { return grams; }
    public void setGrams(BigDecimal grams) { this.grams = grams; }
    public BigDecimal getKcal() { return kcal; }
    public void setKcal(BigDecimal kcal) { this.kcal = kcal; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
