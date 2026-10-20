package com.purr.furguardian.biz.entity.food;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("food_nutrients")
public class FoodNutrientDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long foodId;
    private BigDecimal moistureMax;
    private BigDecimal crudeProteinMin;
    private BigDecimal crudeFatMin;
    private BigDecimal crudeFatMax;
    private BigDecimal crudeFiberMax;
    private BigDecimal ashMax;
    private BigDecimal calciumMin;
    private BigDecimal phosphorusMin;
    private BigDecimal chlorideMin;
    private BigDecimal taurineMin;
    private BigDecimal lysineMin;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getFoodId() { return foodId; }
    public void setFoodId(Long foodId) { this.foodId = foodId; }
    public BigDecimal getMoistureMax() { return moistureMax; }
    public void setMoistureMax(BigDecimal moistureMax) { this.moistureMax = moistureMax; }
    public BigDecimal getCrudeProteinMin() { return crudeProteinMin; }
    public void setCrudeProteinMin(BigDecimal crudeProteinMin) { this.crudeProteinMin = crudeProteinMin; }
    public BigDecimal getCrudeFatMin() { return crudeFatMin; }
    public void setCrudeFatMin(BigDecimal crudeFatMin) { this.crudeFatMin = crudeFatMin; }
    public BigDecimal getCrudeFatMax() { return crudeFatMax; }
    public void setCrudeFatMax(BigDecimal crudeFatMax) { this.crudeFatMax = crudeFatMax; }
    public BigDecimal getCrudeFiberMax() { return crudeFiberMax; }
    public void setCrudeFiberMax(BigDecimal crudeFiberMax) { this.crudeFiberMax = crudeFiberMax; }
    public BigDecimal getAshMax() { return ashMax; }
    public void setAshMax(BigDecimal ashMax) { this.ashMax = ashMax; }
    public BigDecimal getCalciumMin() { return calciumMin; }
    public void setCalciumMin(BigDecimal calciumMin) { this.calciumMin = calciumMin; }
    public BigDecimal getPhosphorusMin() { return phosphorusMin; }
    public void setPhosphorusMin(BigDecimal phosphorusMin) { this.phosphorusMin = phosphorusMin; }
    public BigDecimal getChlorideMin() { return chlorideMin; }
    public void setChlorideMin(BigDecimal chlorideMin) { this.chlorideMin = chlorideMin; }
    public BigDecimal getTaurineMin() { return taurineMin; }
    public void setTaurineMin(BigDecimal taurineMin) { this.taurineMin = taurineMin; }
    public BigDecimal getLysineMin() { return lysineMin; }
    public void setLysineMin(BigDecimal lysineMin) { this.lysineMin = lysineMin; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
