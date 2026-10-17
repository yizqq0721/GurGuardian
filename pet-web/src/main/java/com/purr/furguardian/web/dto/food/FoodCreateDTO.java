package com.purr.furguardian.web.dto.food;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

import java.math.BigDecimal;

public class FoodCreateDTO {

    @NotBlank(message = "食品名称不能为空")
    @Schema(description = "食品名称", example = "皇家贵宾成犬粮")
    private String name;

    @Schema(description = "品牌", example = "Royal Canin")
    private String brand;

    @Schema(description = "类型: DRY/WET/FREEZE_DRIED/SNACK/CANNED", example = "DRY")
    private String foodType = "DRY";

    @Schema(description = "产品性质: COMPLETE/COMPLEMENTARY/SNACK", example = "COMPLETE")
    private String productType = "COMPLETE";

    @Schema(description = "适用生命阶段: ALL/BABY/ADULT/SENIOR", example = "ADULT")
    private String lifeStage = "ADULT";

    @Schema(description = "适用物种: DOG/CAT/BOTH", example = "DOG")
    private String speciesScope = "DOG";

    @Schema(description = "标注代谢能(kcal/kg)", example = "3650")
    private BigDecimal labeledMeKcal;

    @Schema(description = "原料组成", example = "鸡肉, 大米, 玉米蛋白粉")
    private String ingredients;

    private FoodNutrientDTO nutrients;

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
    public FoodNutrientDTO getNutrients() { return nutrients; }
    public void setNutrients(FoodNutrientDTO nutrients) { this.nutrients = nutrients; }
}
