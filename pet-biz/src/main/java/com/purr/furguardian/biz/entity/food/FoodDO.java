package com.purr.furguardian.biz.entity.food;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("foods")
public class FoodDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String name;
    private String brand;
    private String foodType;
    private String productType;
    private String lifeStage;
    private String speciesScope;
    private BigDecimal labeledMeKcal;
    private String ingredients;
    private String reviewStatus;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getFoodType() { return foodType; }
    public void setFoodType(String foodType) { this.foodType = foodType; }
    public String getProductType() { return productType; }
    public void setProductType(String productType) { this.productType = productType; }
    public String getLifeStage() { return lifeStage; }
    public void setLifeStage(String lifeStage) { this.lifeStage = lifeStage; }
    public String getSpeciesScope() { return speciesScope; }
    public void setSpeciesScope(String speciesScope) { this.speciesScope = speciesScope; }
    public BigDecimal getLabeledMeKcal() { return labeledMeKcal; }
    public void setLabeledMeKcal(BigDecimal labeledMeKcal) { this.labeledMeKcal = labeledMeKcal; }
    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }
    public String getReviewStatus() { return reviewStatus; }
    public void setReviewStatus(String reviewStatus) { this.reviewStatus = reviewStatus; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
