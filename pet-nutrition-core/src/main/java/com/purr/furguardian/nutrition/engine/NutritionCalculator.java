package com.purr.furguardian.nutrition.engine;

import com.purr.furguardian.nutrition.model.*;
import com.purr.furguardian.nutrition.standard.CatNutritionStandard;
import com.purr.furguardian.nutrition.standard.DogNutritionStandard;
import com.purr.furguardian.nutrition.standard.NutritionStandard;

import java.util.ArrayList;
import java.util.List;

public class NutritionCalculator {

    private final NutritionStandard dogStandard = new DogNutritionStandard();
    private final NutritionStandard catStandard = new CatNutritionStandard();

    public NutritionResult calculate(PetProfile pet, FoodLabel mainFood) {
        StringBuilder process = new StringBuilder();
        List<String> warnings = new ArrayList<>();

        double bw = pet.getWeightKg();
        double calcWeight = bw;
        Double idealWeight = null;
        boolean overweight = false;
        boolean underweight = false;
        String weightAdvice = null;

        if (pet.getBcs() >= 6) {
            idealWeight = calcIdealWeight(bw, pet.getBcs());
            calcWeight = idealWeight;
            overweight = true;
            if (pet.getBcs() >= 8) {
                weightAdvice = "肥胖状态，建议兽医监督减重，猫减重速率不得超过1%/周，犬不超过1.5%/周";
            } else {
                weightAdvice = "超重状态，使用理想体重计算，目标减重速率0.5-1%体重/周";
            }
            process.append(String.format("BCS=%d(超重)，使用理想体重%.1fkg替代当前体重%.1fkg\n", pet.getBcs(), idealWeight, bw));
        } else if (pet.getBcs() <= 3) {
            underweight = true;
            weightAdvice = "偏瘦状态，建议排查寄生虫/疾病，热量上调10-20%";
            process.append(String.format("BCS=%d(偏瘦)，使用当前体重%.1fkg，热量上调\n", pet.getBcs(), bw));
        } else {
            process.append(String.format("BCS=%d(正常)，使用当前体重%.1fkg\n", pet.getBcs(), bw));
        }

        double rer = calculateRer(calcWeight);
        process.append(String.format("RER = 70 × %.2f^0.75 = %.0f kcal/天\n", calcWeight, rer));

        double k = determineMerCoefficient(pet);
        double mer = rer * k;

        if (pet.getBcs() <= 3) {
            mer *= 1.15;
            process.append(String.format("MER = RER × %.2f × 1.15(偏瘦上调) = %.0f kcal/天\n", k, mer));
        } else {
            process.append(String.format("MER = RER × %.2f = %.0f kcal/天\n", k, mer));
        }

        double snackBudgetKcal = mer * 0.10;
        process.append(String.format("零食上限 = 10%% × MER = %.0f kcal\n", snackBudgetKcal));

        double energyDensity;
        boolean energyEstimated = false;
        if (mainFood.getLabeledMeKcalPerKg() != null && mainFood.getLabeledMeKcalPerKg() > 0) {
            energyDensity = mainFood.getLabeledMeKcalPerKg() / 10.0;
            process.append(String.format("使用标签标注代谢能: %.0f kcal/100g\n", energyDensity));
        } else {
            energyDensity = EnergyEstimator.estimate(mainFood.getGuaranteedAnalysis(), pet.getSpecies() == Species.DOG);
            energyEstimated = true;
            process.append(String.format("能量密度(估算): %.1f kcal/100g\n", energyDensity));
        }

        double mainFoodKcal = mer - snackBudgetKcal;
        double mainFoodGrams = mainFoodKcal / (energyDensity / 100.0);
        process.append(String.format("主粮热量 = MER - 零食上限 = %.0f - %.0f = %.0f kcal\n", mer, snackBudgetKcal, mainFoodKcal));
        process.append(String.format("主粮克数 = %.0f ÷ (%.1f/100) = %.0f g/天\n", mainFoodKcal, energyDensity, mainFoodGrams));

        int mealsPerDay = pet.getLifeStage() == LifeStage.BABY ? 3 : 2;
        double gramsPerMeal = mainFoodGrams / mealsPerDay;
        process.append(String.format("分%d餐，每餐约%.0fg", mealsPerDay, gramsPerMeal));

        List<NutritionValidation> validations = validateFood(mainFood, pet);

        NutritionResult result = new NutritionResult();
        result.setRerKcal(round1(rer));
        result.setMerKcal(round1(mer));
        result.setMainFoodGrams(round1(mainFoodGrams));
        result.setSnackBudgetKcal(round1(snackBudgetKcal));
        result.setSnackBudgetGrams(0);
        result.setMealsPerDay(mealsPerDay);
        result.setGramsPerMeal(round1(gramsPerMeal));
        result.setEnergyDensityKcalPer100g(round1(energyDensity));
        result.setEnergyEstimated(energyEstimated);
        result.setCalculationProcess(process.toString());
        result.setIdealWeightUsed(idealWeight);
        result.setOverweight(overweight);
        result.setUnderweight(underweight);
        result.setWeightAdvice(weightAdvice);
        result.setValidations(validations);
        result.setWarnings(warnings);

        return result;
    }

    public double calculateRer(double weightKg) {
        return 70.0 * Math.pow(weightKg, 0.75);
    }

    public double calcIdealWeight(double currentWeight, int bcs) {
        return currentWeight / (1.0 + 0.1 * (bcs - 5));
    }

    public double determineMerCoefficient(PetProfile pet) {
        double k0;
        if (pet.getSpecies() == Species.DOG) {
            k0 = determineDogK0(pet);
        } else {
            k0 = determineCatK0(pet);
        }
        double f = activityFactor(pet.getActivityLevel(), pet.getSpecies());
        return k0 * f;
    }

    private double determineDogK0(PetProfile pet) {
        if (pet.getPhysiologyStatus() == PhysiologyStatus.LACTATING) return 3.0;
        if (pet.getPhysiologyStatus() == PhysiologyStatus.PREGNANT) return 2.4;
        if (pet.getLifeStage() == LifeStage.BABY) {
            return pet.getAgeInMonths() < 4 ? 3.0 : 2.0;
        }
        if (pet.getLifeStage() == LifeStage.SENIOR) return 1.4;
        return pet.isNeutered() ? 1.6 : 1.8;
    }

    private double determineCatK0(PetProfile pet) {
        if (pet.getPhysiologyStatus() == PhysiologyStatus.LACTATING) return 2.25;
        if (pet.getPhysiologyStatus() == PhysiologyStatus.PREGNANT) return 1.8;
        if (pet.getLifeStage() == LifeStage.BABY) return 2.5;
        if (pet.getLifeStage() == LifeStage.SENIOR) return 1.3;
        return pet.isNeutered() ? 1.2 : 1.4;
    }

    private double activityFactor(ActivityLevel level, Species species) {
        if (level == ActivityLevel.WORKING && species == Species.DOG) return 1.6;
        return switch (level) {
            case SEDENTARY -> 0.8;
            case LOW -> 0.9;
            case MODERATE -> 1.0;
            case HIGH -> 1.15;
            case WORKING -> 1.3;
        };
    }

    private List<NutritionValidation> validateFood(FoodLabel food, PetProfile pet) {
        List<NutritionValidation> validations = new ArrayList<>();
        GuaranteedAnalysis ga = food.getGuaranteedAnalysis();
        if (ga == null) return validations;

        NutritionStandard standard = pet.getSpecies() == Species.DOG ? dogStandard : catStandard;
        LifeStage stage = pet.getLifeStage();
        double moisture = ga.getMoistureMax() != null ? ga.getMoistureMax() : 10.0;

        if (ga.getCrudeProteinMin() != null) {
            double proteinDm = DmConverter.toDryMatterPercent(ga.getCrudeProteinMin(), moisture);
            double required = standard.proteinMinDm(stage);
            validations.add(new NutritionValidation("粗蛋白质", round1(proteinDm), required, proteinDm >= required, "%DM"));
        }

        if (ga.getCrudeFatMin() != null) {
            double fatDm = DmConverter.toDryMatterPercent(ga.getCrudeFatMin(), moisture);
            double required = standard.fatMinDm(stage);
            validations.add(new NutritionValidation("粗脂肪", round1(fatDm), required, fatDm >= required, "%DM"));
        }

        if (ga.getCalciumMin() != null) {
            double calciumDm = DmConverter.toDryMatterPercent(ga.getCalciumMin(), moisture);
            double required = standard.calciumMinDm(stage);
            validations.add(new NutritionValidation("钙", round2(calciumDm), required, calciumDm >= required, "%DM"));
        }

        if (ga.getPhosphorusMin() != null) {
            double phosphorusDm = DmConverter.toDryMatterPercent(ga.getPhosphorusMin(), moisture);
            double required = standard.phosphorusMinDm(stage);
            validations.add(new NutritionValidation("总磷", round2(phosphorusDm), required, phosphorusDm >= required, "%DM"));
        }

        if (pet.getSpecies() == Species.CAT && ga.getTaurineMin() != null) {
            double taurineDm = DmConverter.toDryMatterPercent(ga.getTaurineMin(), moisture);
            double required = standard.taurineMinDm(stage);
            validations.add(new NutritionValidation("牛磺酸", round2(taurineDm), required, taurineDm >= required, "%DM"));
        }

        if (pet.getSpecies() == Species.DOG && ga.getLysineMin() != null) {
            double lysineDm = DmConverter.toDryMatterPercent(ga.getLysineMin(), moisture);
            double required = standard.lysineMinDm(stage);
            validations.add(new NutritionValidation("赖氨酸", round2(lysineDm), required, lysineDm >= required, "%DM"));
        }

        return validations;
    }

    private double round1(double value) {
        return Math.round(value * 10.0) / 10.0;
    }

    private double round2(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
