package com.purr.furguardian.web.controller.food;

import com.purr.furguardian.ai.model.NutritionRecipe;
import com.purr.furguardian.ai.service.NutritionRecipeService;
import com.purr.furguardian.biz.service.NutritionService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.nutrition.model.NutritionResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/nutrition")
@Tag(name = "营养方案")
public class NutritionController {

    private final NutritionService nutritionService;
    private final NutritionRecipeService recipeService;

    public NutritionController(NutritionService nutritionService,
                               NutritionRecipeService recipeService) {
        this.nutritionService = nutritionService;
        this.recipeService = recipeService;
    }

    @GetMapping("/calculate")
    @Operation(summary = "计算营养方案", description = "根据宠物档案和食品计算每日喂养方案")
    public Result<NutritionResult> calculate(
            @RequestParam Long petId,
            @RequestParam Long foodId) {
        NutritionResult result = nutritionService.calculatePlan(UserContext.getUserId(), petId, foodId);
        return Result.ok(result);
    }

    @GetMapping("/recipe")
    @Operation(summary = "AI每日食谱建议", description = "结合计算结果、零食库与知识库生成每日食谱")
    public Result<NutritionRecipe> recipe(
            @RequestParam Long petId,
            @RequestParam Long foodId) {
        return Result.ok(recipeService.generate(UserContext.getUserId(), petId, foodId));
    }
}
