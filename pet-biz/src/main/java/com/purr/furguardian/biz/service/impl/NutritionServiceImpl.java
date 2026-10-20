package com.purr.furguardian.biz.service.impl;

import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.food.FoodNutrientDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.report.FeedingPlanDO;
import com.purr.furguardian.biz.mapper.food.FoodMapper;
import com.purr.furguardian.biz.mapper.food.FoodNutrientMapper;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.report.FeedingPlanMapper;
import com.purr.furguardian.biz.service.FoodService;
import com.purr.furguardian.biz.service.NutritionService;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.nutrition.engine.NutritionCalculator;
import com.purr.furguardian.nutrition.model.*;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class NutritionServiceImpl implements NutritionService {

    private final PetService petService;
    private final FoodService foodService;
    private final NutritionCalculator calculator;
    private final FeedingPlanMapper planMapper;

    public NutritionServiceImpl(PetService petService, FoodService foodService,
                                FeedingPlanMapper planMapper) {
        this.petService = petService;
        this.foodService = foodService;
        this.calculator = new NutritionCalculator();
        this.planMapper = planMapper;
    }

    @Override
    public NutritionResult calculatePlan(Long userId, Long petId, Long foodId) {
        NutritionResult result = previewPlan(userId, petId, foodId);

        FeedingPlanDO plan = new FeedingPlanDO();
        plan.setPetId(petId);
        plan.setUserId(userId);
        plan.setFoodId(foodId);
        plan.setEffectiveDate(LocalDate.now());
        plan.setRerKcal(BigDecimal.valueOf(result.getRerKcal()));
        plan.setMerKcal(BigDecimal.valueOf(result.getMerKcal()));
        plan.setMainFoodGrams(BigDecimal.valueOf(result.getMainFoodGrams()));
        plan.setSnackBudgetKcal(BigDecimal.valueOf(result.getSnackBudgetKcal()));
        plan.setMealsPerDay(result.getMealsPerDay());
        plan.setCalculationLog(result.getCalculationProcess());
        plan.setCreatedAt(LocalDateTime.now());
        planMapper.insert(plan);

        return result;
    }

    @Override
    public NutritionResult previewPlan(Long userId, Long petId, Long foodId) {
        PetDO petDO = petService.getPet(userId, petId);
        FoodDO foodDO = foodService.getFood(foodId);
        FoodNutrientDO nutrientDO = foodService.getNutrients(foodId);

        validateSpecies(petDO, foodDO);

        PetProfile profile = toPetProfile(petDO);
        FoodLabel label = toFoodLabel(foodDO, nutrientDO);

        return calculator.calculate(profile, label);
    }

    /** 猫只能吃 CAT/BOTH，犬只能吃 DOG/BOTH；零食不能当主粮计算 */
    private void validateSpecies(PetDO pet, FoodDO food) {
        if ("SNACK".equalsIgnoreCase(food.getProductType())) {
            throw new BizException(ErrorCode.BAD_REQUEST, "零食不能作为主粮计算，请选择全价粮或补充粮");
        }
        String scope = food.getSpeciesScope();
        if (scope != null && !scope.isBlank() && !"BOTH".equalsIgnoreCase(scope)) {
            String expected = "dog".equalsIgnoreCase(pet.getSpecies()) ? "DOG" : "CAT";
            if (!expected.equalsIgnoreCase(scope)) {
                throw new BizException(ErrorCode.BAD_REQUEST,
                        "该食品适用物种与当前宠物不一致，请重新选择主粮");
            }
        }
    }

    private PetProfile toPetProfile(PetDO petDO) {
        PetProfile profile = new PetProfile();
        profile.setSpecies("dog".equals(petDO.getSpecies()) ? Species.DOG : Species.CAT);
        profile.setBreed(petDO.getBreed());
        profile.setNeutered(petDO.getNeutered() == 1);
        if (petDO.getBirthday() != null) {
            long months = java.time.temporal.ChronoUnit.MONTHS.between(petDO.getBirthday(), LocalDate.now());
            profile.setAgeInMonths((int) months);
        } else {
            profile.setAgeInMonths(36);
        }
        profile.setWeightKg(latestWeight(petDO.getUserId(), petDO.getId()));
        profile.setActivityLevel(ActivityLevel.valueOf(petDO.getActivityLevel()));
        profile.setBcs(petDO.getBcs() != null ? petDO.getBcs() : 5);
        profile.setPhysiologyStatus(PhysiologyStatus.valueOf(
                petDO.getPhysiology() != null ? petDO.getPhysiology() : "NORMAL"));
        return profile;
    }

    private FoodLabel toFoodLabel(FoodDO foodDO, FoodNutrientDO nutrientDO) {
        FoodLabel label = new FoodLabel();
        label.setName(foodDO.getName());
        if ("SNACK".equals(foodDO.getProductType())) {
            label.setProductType(FoodLabel.ProductType.SNACK);
        } else if ("COMPLEMENTARY".equals(foodDO.getProductType())) {
            label.setProductType(FoodLabel.ProductType.COMPLEMENTARY_FEED);
        } else {
            label.setProductType(FoodLabel.ProductType.COMPLETE_FEED);
        }
        if (foodDO.getLabeledMeKcal() != null) {
            label.setLabeledMeKcalPerKg(foodDO.getLabeledMeKcal().doubleValue());
        }
        if (nutrientDO != null) {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            ga.setMoistureMax(toDouble(nutrientDO.getMoistureMax()));
            ga.setCrudeProteinMin(toDouble(nutrientDO.getCrudeProteinMin()));
            ga.setCrudeFatMin(toDouble(nutrientDO.getCrudeFatMin()));
            ga.setCrudeFatMax(toDouble(nutrientDO.getCrudeFatMax()));
            ga.setCrudeFiberMax(toDouble(nutrientDO.getCrudeFiberMax()));
            ga.setAshMax(toDouble(nutrientDO.getAshMax()));
            ga.setCalciumMin(toDouble(nutrientDO.getCalciumMin()));
            ga.setPhosphorusMin(toDouble(nutrientDO.getPhosphorusMin()));
            ga.setTaurineMin(toDouble(nutrientDO.getTaurineMin()));
            ga.setLysineMin(toDouble(nutrientDO.getLysineMin()));
            label.setGuaranteedAnalysis(ga);
        }
        return label;
    }

    /** 体重取最近一次记录；没有记录时才退回默认值，避免计划与主页体重不一致 */
    private double latestWeight(Long userId, Long petId) {
        var logs = petService.getWeightHistory(userId, petId);
        if (logs.isEmpty()) return 5.0;
        BigDecimal weight = logs.get(logs.size() - 1).getWeightKg();
        return weight != null && weight.doubleValue() > 0 ? weight.doubleValue() : 5.0;
    }

    private Double toDouble(BigDecimal value) {
        return value != null ? value.doubleValue() : null;
    }
}
