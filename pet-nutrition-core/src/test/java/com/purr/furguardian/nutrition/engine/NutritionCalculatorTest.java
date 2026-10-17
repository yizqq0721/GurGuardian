package com.purr.furguardian.nutrition.engine;

import com.purr.furguardian.nutrition.model.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("营养计算引擎 - 7项核心单测")
class NutritionCalculatorTest {

    private NutritionCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new NutritionCalculator();
    }

    @Nested
    @DisplayName("1. Atwater公式基准用例")
    class AtwaterTests {

        @Test
        @DisplayName("修正Atwater: 典型干粮(蛋白26%/脂肪14%/纤维5%/灰分8%/水分10%)")
        void modifiedAtwater_typicalDryFood() {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            ga.setCrudeProteinMin(26.0);
            ga.setCrudeFatMin(14.0);
            ga.setCrudeFiberMax(5.0);
            ga.setAshMax(8.0);
            ga.setMoistureMax(10.0);

            double me = EnergyEstimator.estimateModifiedAtwater(ga);
            assertEquals(339.5, me, 0.5);
        }

        @Test
        @DisplayName("高纤维粮自动切换AAFCO法(纤维DM>8%)")
        void highFiber_switchToAafco() {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            ga.setCrudeProteinMin(20.0);
            ga.setCrudeFatMin(8.0);
            ga.setCrudeFiberMax(15.0);
            ga.setAshMax(8.0);
            ga.setMoistureMax(10.0);

            double meAafco = EnergyEstimator.estimateAafco(ga, true);
            assertTrue(meAafco > 0);
            assertTrue(meAafco < 400);
        }

        @Test
        @DisplayName("标签标注代谢能时优先使用标注值")
        void labeledMe_priority() {
            PetProfile pet = adultNeuteredDog(5.0);
            FoodLabel food = dryFood();
            food.setLabeledMeKcalPerKg(3800.0);

            NutritionResult result = calculator.calculate(pet, food);
            assertFalse(result.isEnergyEstimated());
            assertEquals(380.0, result.getEnergyDensityKcalPer100g(), 0.1);
        }
    }

    @Nested
    @DisplayName("2. RER数值表(1/5/10/25/40kg)")
    class RerTests {

        @Test
        @DisplayName("RER(1kg) = 70 kcal")
        void rer_1kg() {
            assertEquals(70.0, calculator.calculateRer(1.0), 0.5);
        }

        @Test
        @DisplayName("RER(5kg) ≈ 234 kcal")
        void rer_5kg() {
            assertEquals(234.0, calculator.calculateRer(5.0), 1.0);
        }

        @Test
        @DisplayName("RER(10kg) ≈ 393 kcal")
        void rer_10kg() {
            assertEquals(393.0, calculator.calculateRer(10.0), 1.0);
        }

        @Test
        @DisplayName("RER(25kg) ≈ 783 kcal")
        void rer_25kg() {
            assertEquals(783.0, calculator.calculateRer(25.0), 1.0);
        }

        @Test
        @DisplayName("RER(40kg) ≈ 1113 kcal")
        void rer_40kg() {
            assertEquals(1113.0, calculator.calculateRer(40.0), 1.0);
        }
    }

    @Nested
    @DisplayName("3. BCS理想体重换算")
    class BcsTests {

        @Test
        @DisplayName("BCS=6, 当前4kg → 理想体重3.6kg")
        void bcs6_idealWeight() {
            double ideal = calculator.calcIdealWeight(4.0, 6);
            assertEquals(3.636, ideal, 0.01);
        }

        @Test
        @DisplayName("BCS=7, 当前10kg → 理想体重8.33kg")
        void bcs7_idealWeight() {
            double ideal = calculator.calcIdealWeight(10.0, 7);
            assertEquals(8.333, ideal, 0.01);
        }

        @Test
        @DisplayName("BCS=5(正常) → 使用当前体重")
        void bcs5_normalWeight() {
            PetProfile pet = adultNeuteredDog(10.0);
            pet.setBcs(5);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            assertNull(result.getIdealWeightUsed());
            assertFalse(result.isOverweight());
        }

        @Test
        @DisplayName("BCS=8(肥胖) → 使用理想体重且输出警告")
        void bcs8_obesityWarning() {
            PetProfile pet = adultNeuteredDog(12.0);
            pet.setBcs(8);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            assertTrue(result.isOverweight());
            assertNotNull(result.getIdealWeightUsed());
            assertNotNull(result.getWeightAdvice());
            assertTrue(result.getWeightAdvice().contains("兽医"));
        }
    }

    @Nested
    @DisplayName("4. 零食10%上限拦截")
    class SnackLimitTests {

        @Test
        @DisplayName("零食预算 = MER × 10%")
        void snackBudget_is10PercentOfMer() {
            PetProfile pet = adultNeuteredDog(5.0);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            double expectedBudget = result.getMerKcal() * 0.10;
            assertEquals(expectedBudget, result.getSnackBudgetKcal(), 1.0);
        }

        @Test
        @DisplayName("主粮热量 = MER - 零食预算")
        void mainFoodKcal_isMerMinusSnack() {
            PetProfile pet = adultNeuteredDog(5.0);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            double mainFoodKcal = result.getMerKcal() - result.getSnackBudgetKcal();
            double mainFoodGrams = mainFoodKcal / (result.getEnergyDensityKcalPer100g() / 100.0);
            assertEquals(mainFoodGrams, result.getMainFoodGrams(), 1.0);
        }
    }

    @Nested
    @DisplayName("5. 国标校验(成犬粗蛋白≥18%DM)")
    class StandardValidationTests {

        @Test
        @DisplayName("成犬粮蛋白26%DM ≥ 18% → 通过")
        void adultDog_proteinPass() {
            PetProfile pet = adultNeuteredDog(10.0);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            List<NutritionValidation> validations = result.getValidations();
            assertFalse(validations.isEmpty());

            NutritionValidation proteinVal = validations.stream()
                    .filter(v -> "粗蛋白质".equals(v.getNutrient()))
                    .findFirst().orElseThrow();
            assertTrue(proteinVal.isPassed());
            assertTrue(proteinVal.getActualValue() >= 18.0);
        }

        @Test
        @DisplayName("幼犬粮蛋白19%as-fed → DM=21.1% < 22% → 不通过")
        void puppy_proteinFail() {
            PetProfile pet = new PetProfile();
            pet.setSpecies(Species.DOG);
            pet.setAgeInMonths(3);
            pet.setWeightKg(3.0);
            pet.setNeutered(false);
            pet.setBcs(5);
            pet.setActivityLevel(ActivityLevel.MODERATE);

            FoodLabel food = dryFood();
            food.getGuaranteedAnalysis().setCrudeProteinMin(19.0);

            NutritionResult result = calculator.calculate(pet, food);
            NutritionValidation proteinVal = result.getValidations().stream()
                    .filter(v -> "粗蛋白质".equals(v.getNutrient()))
                    .findFirst().orElseThrow();
            assertFalse(proteinVal.isPassed());
        }
    }

    @Nested
    @DisplayName("6. 禁忌食材拦截")
    class ForbiddenTests {

        @Test
        @DisplayName("含洋葱 → 命中禁忌")
        void onion_forbidden() {
            assertTrue(ForbiddenIngredients.containsForbidden("原料: 鸡肉, 洋葱粉, 玉米"));
        }

        @Test
        @DisplayName("含葡萄 → 命中禁忌")
        void grape_forbidden() {
            assertTrue(ForbiddenIngredients.containsForbidden("葡萄干, 鸡肉"));
        }

        @Test
        @DisplayName("含巧克力 → 命中禁忌")
        void chocolate_forbidden() {
            assertTrue(ForbiddenIngredients.containsForbidden("chocolate flavor"));
        }

        @Test
        @DisplayName("正常食材 → 不命中")
        void normalIngredients_notForbidden() {
            assertFalse(ForbiddenIngredients.containsForbidden("鸡肉, 大米, 南瓜, 胡萝卜"));
        }

        @Test
        @DisplayName("返回具体禁忌物名称")
        void findForbidden_returnsName() {
            assertEquals("木糖醇", ForbiddenIngredients.findForbidden("含木糖醇零食"));
        }
    }

    @Nested
    @DisplayName("7. 保证值缺失兜底")
    class FallbackTests {

        @Test
        @DisplayName("未标水分 → 默认10%(干粮)")
        void missingMoisture_default10() {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            ga.setCrudeProteinMin(26.0);
            ga.setCrudeFatMin(14.0);

            double me = EnergyEstimator.estimateModifiedAtwater(ga);
            assertTrue(me > 0);
        }

        @Test
        @DisplayName("未标灰分 → 默认8%")
        void missingAsh_default8() {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            ga.setMoistureMax(10.0);
            ga.setCrudeProteinMin(26.0);
            ga.setCrudeFatMin(14.0);
            ga.setCrudeFiberMax(5.0);

            double me = EnergyEstimator.estimateModifiedAtwater(ga);
            assertTrue(me > 300);
        }

        @Test
        @DisplayName("完全空保证值 → 不抛异常，使用默认值计算")
        void emptyGuaranteedAnalysis_noException() {
            GuaranteedAnalysis ga = new GuaranteedAnalysis();
            assertDoesNotThrow(() -> EnergyEstimator.estimate(ga, true));
        }

        @Test
        @DisplayName("未标代谢能 → 标记为估算值")
        void missingME_markedAsEstimated() {
            PetProfile pet = adultNeuteredDog(5.0);
            FoodLabel food = dryFood();
            food.setLabeledMeKcalPerKg(null);

            NutritionResult result = calculator.calculate(pet, food);
            assertTrue(result.isEnergyEstimated());
        }
    }

    @Nested
    @DisplayName("综合场景验证")
    class IntegrationTests {

        @Test
        @DisplayName("示例A: 贵宾犬5kg绝育低活动 → RER=234, MER≈337")
        void exampleA_toyPoodle() {
            PetProfile pet = adultNeuteredDog(5.0);
            pet.setActivityLevel(ActivityLevel.LOW);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            assertEquals(234.0, result.getRerKcal(), 1.0);
            assertTrue(result.getMerKcal() >= 300 && result.getMerKcal() <= 400);
            assertTrue(result.getMainFoodGrams() > 0);
            assertNotNull(result.getCalculationProcess());
        }

        @Test
        @DisplayName("猫超重BCS=6 → 使用理想体重计算")
        void exampleB_overweightCat() {
            PetProfile pet = new PetProfile();
            pet.setSpecies(Species.CAT);
            pet.setAgeInMonths(24);
            pet.setWeightKg(4.0);
            pet.setNeutered(true);
            pet.setBcs(6);
            pet.setActivityLevel(ActivityLevel.SEDENTARY);

            FoodLabel food = dryFood();
            NutritionResult result = calculator.calculate(pet, food);

            assertTrue(result.isOverweight());
            assertNotNull(result.getIdealWeightUsed());
            assertTrue(result.getIdealWeightUsed() < 4.0);
        }

        @Test
        @DisplayName("幼犬(3月龄) → 3餐/天")
        void puppy_threeMeals() {
            PetProfile pet = new PetProfile();
            pet.setSpecies(Species.DOG);
            pet.setAgeInMonths(3);
            pet.setWeightKg(3.0);
            pet.setNeutered(false);
            pet.setBcs(5);
            pet.setActivityLevel(ActivityLevel.MODERATE);

            FoodLabel food = dryFood();
            NutritionResult result = calculator.calculate(pet, food);
            assertEquals(3, result.getMealsPerDay());
        }

        @Test
        @DisplayName("成犬 → 2餐/天")
        void adultDog_twoMeals() {
            PetProfile pet = adultNeuteredDog(10.0);
            FoodLabel food = dryFood();

            NutritionResult result = calculator.calculate(pet, food);
            assertEquals(2, result.getMealsPerDay());
        }
    }

    private PetProfile adultNeuteredDog(double weight) {
        PetProfile pet = new PetProfile();
        pet.setSpecies(Species.DOG);
        pet.setAgeInMonths(36);
        pet.setWeightKg(weight);
        pet.setNeutered(true);
        pet.setBcs(5);
        pet.setActivityLevel(ActivityLevel.MODERATE);
        return pet;
    }

    private FoodLabel dryFood() {
        FoodLabel food = new FoodLabel();
        food.setName("测试干粮");
        food.setProductType(FoodLabel.ProductType.COMPLETE_FEED);
        GuaranteedAnalysis ga = new GuaranteedAnalysis();
        ga.setCrudeProteinMin(26.0);
        ga.setCrudeFatMin(14.0);
        ga.setCrudeFiberMax(5.0);
        ga.setAshMax(8.0);
        ga.setMoistureMax(10.0);
        ga.setCalciumMin(1.0);
        ga.setPhosphorusMin(0.8);
        food.setGuaranteedAnalysis(ga);
        return food;
    }
}
