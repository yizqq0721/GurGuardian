package com.purr.furguardian.web.controller.food;

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

    public NutritionController(NutritionService nutritionService) {
        this.nutritionService = nutritionService;
    }

    @GetMapping("/calculate")
    @Operation(summary = "计算营养方案", description = "根据宠物档案和食品计算每日喂养方案")
    public Result<NutritionResult> calculate(
            @RequestParam Long petId,
            @RequestParam Long foodId) {
        NutritionResult result = nutritionService.calculatePlan(UserContext.getUserId(), petId, foodId);
        return Result.ok(result);
    }
}
