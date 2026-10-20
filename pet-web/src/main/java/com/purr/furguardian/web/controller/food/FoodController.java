package com.purr.furguardian.web.controller.food;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.food.FoodNutrientDO;
import com.purr.furguardian.biz.service.FoodService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.food.FoodCreateDTO;
import com.purr.furguardian.web.dto.food.FoodNutrientDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/food")
@Tag(name = "食品库")
public class FoodController {

    private final FoodService foodService;

    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    @PostMapping
    @Operation(summary = "录入食品")
    public Result<Long> create(@RequestBody @Valid FoodCreateDTO dto) {
        FoodDO food = toEntity(dto);
        FoodNutrientDO nutrients = toNutrientEntity(dto.getNutrients());
        Long id = foodService.createFood(UserContext.getUserId(), food, nutrients);
        return Result.ok(id);
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新食品")
    public Result<Void> update(@PathVariable Long id, @RequestBody @Valid FoodCreateDTO dto) {
        FoodDO food = toEntity(dto);
        FoodNutrientDO nutrients = toNutrientEntity(dto.getNutrients());
        foodService.updateFood(UserContext.getUserId(), id, food, nutrients);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除食品")
    public Result<Void> delete(@PathVariable Long id) {
        foodService.deleteFood(UserContext.getUserId(), id);
        return Result.ok();
    }

    @GetMapping("/{id}")
    @Operation(summary = "食品详情")
    public Result<FoodDO> detail(@PathVariable Long id) {
        return Result.ok(foodService.getFood(id));
    }

    @GetMapping("/{id}/nutrients")
    @Operation(summary = "食品营养成分")
    public Result<FoodNutrientDO> nutrients(@PathVariable Long id) {
        return Result.ok(foodService.getNutrients(id));
    }

    @GetMapping("/list")
    @Operation(summary = "食品列表")
    public Result<Page<FoodDO>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword) {
        return Result.ok(foodService.listFoods(UserContext.getUserId(), page, size, keyword));
    }

    private FoodDO toEntity(FoodCreateDTO dto) {
        FoodDO food = new FoodDO();
        food.setName(dto.getName());
        food.setBrand(dto.getBrand());
        food.setFoodType(dto.getFoodType());
        food.setProductType(dto.getProductType());
        food.setLifeStage(dto.getLifeStage());
        food.setSpeciesScope(dto.getSpeciesScope());
        food.setLabeledMeKcal(dto.getLabeledMeKcal());
        food.setIngredients(dto.getIngredients());
        food.setReviewStatus("approved");
        return food;
    }

    private FoodNutrientDO toNutrientEntity(FoodNutrientDTO dto) {
        if (dto == null) return null;
        FoodNutrientDO entity = new FoodNutrientDO();
        entity.setMoistureMax(dto.getMoistureMax());
        entity.setCrudeProteinMin(dto.getCrudeProteinMin());
        entity.setCrudeFatMin(dto.getCrudeFatMin());
        entity.setCrudeFiberMax(dto.getCrudeFiberMax());
        entity.setAshMax(dto.getAshMax());
        entity.setCalciumMin(dto.getCalciumMin());
        entity.setPhosphorusMin(dto.getPhosphorusMin());
        entity.setTaurineMin(dto.getTaurineMin());
        entity.setLysineMin(dto.getLysineMin());
        return entity;
    }
}
