package com.purr.furguardian.ai.service;

import com.purr.furguardian.ai.model.NutritionRecipe;
import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.food.FoodNutrientDO;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.service.FoodService;
import com.purr.furguardian.biz.service.NutritionService;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.knowledge.service.KnowledgeRetrievalService;
import com.purr.furguardian.nutrition.model.NutritionResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/** 把计算结果、零食库和知识库组合成 AI 每日食谱建议 */
@Service
public class NutritionRecipeService {

    private static final Logger log = LoggerFactory.getLogger(NutritionRecipeService.class);
    private static final int MAX_SNACKS = 6;
    private static final int MAX_KNOWLEDGE_REFS = 6;

    private final PetService petService;
    private final FoodService foodService;
    private final NutritionService nutritionService;
    private final KnowledgeRetrievalService retrievalService;
    private final LlmService llmService;
    private final PromptTemplates promptTemplates;

    public NutritionRecipeService(PetService petService,
                                  FoodService foodService,
                                  NutritionService nutritionService,
                                  KnowledgeRetrievalService retrievalService,
                                  LlmService llmService,
                                  PromptTemplates promptTemplates) {
        this.petService = petService;
        this.foodService = foodService;
        this.nutritionService = nutritionService;
        this.retrievalService = retrievalService;
        this.llmService = llmService;
        this.promptTemplates = promptTemplates;
    }

    public NutritionRecipe generate(Long userId, Long petId, Long foodId) {
        PetDO pet = petService.getPet(userId, petId);
        FoodDO mainFood = foodService.getFood(foodId);
        NutritionResult plan = nutritionService.previewPlan(userId, petId, foodId);

        List<FoodDO> snacks = loadCompatibleSnacks(userId, pet);
        List<KnowledgeDocDO> docs = loadKnowledge(pet);

        NutritionRecipe recipe = new NutritionRecipe();
        recipe.setSnacks(snacks.stream()
                .map(f -> new NutritionRecipe.SnackRef(
                        f.getId(), f.getName(), f.getBrand(),
                        f.getLabeledMeKcal() != null ? f.getLabeledMeKcal().doubleValue() : null,
                        maxDailyGrams(f, plan.getSnackBudgetKcal())))
                .collect(Collectors.toList()));
        recipe.setSources(docs.stream()
                .map(d -> new NutritionRecipe.SourceRef(d.getId(), d.getTitle(), d.getSourceName()))
                .collect(Collectors.toList()));

        String snackText = formatSnacks(snacks, plan);
        String knowledgeRefs = formatKnowledgeRefs(docs);
        boolean organKnowledgeAvailable = docs.stream().anyMatch(this::isOrganDoc);
        String calculation = formatCalculation(plan);
        String mainFoodInfo = formatMainFood(mainFood, foodService.getNutrients(foodId));
        String petInfo = formatPet(pet);

        String content = llmService.chatWithTimeout(
                promptTemplates.getNutritionRecipeSystemPrompt(),
                promptTemplates.buildNutritionRecipeUserPrompt(
                        petInfo, calculation, mainFoodInfo, snackText,
                        knowledgeRefs, organKnowledgeAvailable),
                Duration.ofSeconds(40));

        if (content == null || content.isBlank()) {
            log.warn("AI食谱生成失败，使用确定性兜底: userId={}, petId={}, foodId={}", userId, petId, foodId);
            content = buildFallback(pet, mainFood, plan, snacks, organKnowledgeAvailable);
            recipe.setIsFallback(true);
        }

        recipe.setContent(content);
        return recipe;
    }

    private List<FoodDO> loadCompatibleSnacks(Long userId, PetDO pet) {
        String scope = "dog".equalsIgnoreCase(pet.getSpecies()) ? "DOG" : "CAT";
        return foodService.listFoods(userId, 1, 100, null).getRecords().stream()
                .filter(f -> "SNACK".equalsIgnoreCase(f.getProductType()))
                .filter(f -> f.getSpeciesScope() == null || f.getSpeciesScope().isBlank()
                        || "BOTH".equalsIgnoreCase(f.getSpeciesScope())
                        || scope.equalsIgnoreCase(f.getSpeciesScope()))
                .limit(MAX_SNACKS)
                .collect(Collectors.toList());
    }

    private List<KnowledgeDocDO> loadKnowledge(PetDO pet) {
        String species = pet.getSpecies();
        String lifeStage = determineLifeStage(pet);
        String query = "dog".equalsIgnoreCase(species)
                ? "犬 零食 喂食 营养 肝脏 心脏 蛋白质 加餐"
                : "猫 零食 喂食 营养 肝脏 心脏 牛磺酸 加餐";
        List<KnowledgeDocDO> docs = new ArrayList<>(retrievalService.search(
                query, species, lifeStage, 4));

        // 向量检索偶尔漏掉内脏/牛磺酸条目，补一次关键词检索，避免食谱引用不到相关依据
        String organQuery = "dog".equalsIgnoreCase(species)
                ? "犬 肝脏 心脏 内脏 维生素A 加餐"
                : "猫 肝脏 心脏 内脏 牛磺酸 维生素A 加餐";
        for (KnowledgeDocDO doc : retrievalService.fallbackSqlSearch(
                organQuery, species, lifeStage, 3)) {
            if (!isOrganDoc(doc)) {
                continue;
            }
            boolean exists = docs.stream().anyMatch(d -> d.getId().equals(doc.getId()));
            if (!exists) {
                docs.add(doc);
            }
            if (docs.size() >= MAX_KNOWLEDGE_REFS) {
                break;
            }
        }

        if (docs.isEmpty()) {
            docs = retrievalService.getCuratedPool(species, 4);
        }
        return docs.size() > MAX_KNOWLEDGE_REFS
                ? docs.subList(0, MAX_KNOWLEDGE_REFS)
                : docs;
    }

    private String formatPet(PetDO pet) {
        StringBuilder sb = new StringBuilder();
        sb.append("物种:").append("dog".equalsIgnoreCase(pet.getSpecies()) ? "犬" : "猫");
        sb.append(", 名字:").append(pet.getName());
        if (pet.getBreed() != null) sb.append(", 品种:").append(pet.getBreed());
        sb.append(", 生命阶段:").append(determineLifeStage(pet));
        if (pet.getNeutered() != null && pet.getNeutered() == 1) sb.append(", 已绝育");
        if (pet.getBcs() != null) sb.append(", BCS:").append(pet.getBcs());
        return sb.toString();
    }

    private String formatCalculation(NutritionResult plan) {
        return """
                - 每日维持能量 MER: %.0f kcal
                - 每日主粮: %.0f g（分 %d 餐，每餐约 %.0f g）
                - 零食额度: 不超过 %.0f kcal/天（占 MER 10%%）
                - 主粮能量密度: %.0f kcal/100g
                """.formatted(
                plan.getMerKcal(), plan.getMainFoodGrams(), plan.getMealsPerDay(),
                plan.getGramsPerMeal(), plan.getSnackBudgetKcal(),
                plan.getEnergyDensityKcalPer100g());
    }

    private String formatMainFood(FoodDO food, FoodNutrientDO nutrients) {
        StringBuilder sb = new StringBuilder();
        sb.append(food.getBrand() != null ? food.getBrand() + " " : "").append(food.getName());
        if (food.getLabeledMeKcal() != null) {
            sb.append("，标注代谢能 ").append(food.getLabeledMeKcal()).append(" kcal/kg");
        }
        if (nutrients != null) {
            sb.append("；保证值：");
            if (nutrients.getCrudeProteinMin() != null) {
                sb.append("粗蛋白≥").append(nutrients.getCrudeProteinMin()).append("% ");
            }
            if (nutrients.getCrudeFatMin() != null) {
                sb.append("粗脂肪≥").append(nutrients.getCrudeFatMin()).append("% ");
            }
            if (nutrients.getMoistureMax() != null) {
                sb.append("水分≤").append(nutrients.getMoistureMax()).append("% ");
            }
        }
        if (food.getIngredients() != null && !food.getIngredients().isBlank()) {
            sb.append("；原料：").append(food.getIngredients());
        }
        return sb.toString();
    }

    private String formatSnacks(List<FoodDO> snacks, NutritionResult plan) {
        if (snacks.isEmpty()) {
            return "食品库暂无适用于该物种的零食。可以把零食额度留空，或先录入合适的零食。";
        }
        return snacks.stream()
                .map(f -> {
                    StringBuilder sb = new StringBuilder("- ");
                    sb.append(f.getBrand() != null ? f.getBrand() + " " : "").append(f.getName());
                    Double grams = maxDailyGrams(f, plan.getSnackBudgetKcal());
                    if (grams != null) {
                        sb.append("：标注 ").append(f.getLabeledMeKcal()).append(" kcal/kg")
                          .append("，若零食额度全部给这一种，每日上限约 ").append(grams).append(" g");
                    } else {
                        sb.append("：未标注代谢能，只能按包装建议少量喂");
                    }
                    return sb.toString();
                })
                .collect(Collectors.joining("\n"));
    }

    private String formatKnowledgeRefs(List<KnowledgeDocDO> docs) {
        if (docs.isEmpty()) {
            return "（知识库暂无可用参考）";
        }
        List<String> refs = new ArrayList<>();
        for (KnowledgeDocDO doc : docs) {
            String content = doc.getContent() == null ? "" : doc.getContent();
            if (content.length() > 500) content = content.substring(0, 500) + "…";
            refs.add(String.format("[%s] %s\n%s\n来源: %s",
                    doc.getId(), doc.getTitle(), content, doc.getSourceName()));
        }
        return String.join("\n\n", refs);
    }

    private Double maxDailyGrams(FoodDO snack, double snackBudgetKcal) {
        BigDecimal kcalPerKg = snack.getLabeledMeKcal();
        if (kcalPerKg == null || kcalPerKg.doubleValue() <= 0 || snackBudgetKcal <= 0) {
            return null;
        }
        double grams = snackBudgetKcal / (kcalPerKg.doubleValue() / 1000.0);
        return Math.round(grams * 10.0) / 10.0;
    }

    /** 知识库是否包含内脏/牛磺酸相关条目，决定 AI 能否给出内脏加餐建议 */
    private boolean isOrganDoc(KnowledgeDocDO doc) {
        String text = (doc.getTitle() == null ? "" : doc.getTitle())
                + (doc.getContent() == null ? "" : doc.getContent());
        return text.contains("动物心脏") || text.contains("动物肝脏")
                || text.contains("猪肝") || text.contains("鸡心") || text.contains("猪心")
                || text.contains("内脏") || text.contains("牛磺酸");
    }

    private String buildFallback(PetDO pet, FoodDO mainFood, NutritionResult plan,
                                 List<FoodDO> snacks, boolean organKnowledgeAvailable) {
        StringBuilder sb = new StringBuilder();
        sb.append("### 主粮怎么喂\n");
        sb.append("- 每天 ").append(Math.round(plan.getMainFoodGrams())).append(" g，分 ")
          .append(plan.getMealsPerDay()).append(" 餐，每餐约 ")
          .append(Math.round(plan.getGramsPerMeal())).append(" g。\n");
        sb.append("- 主粮热量已预留零食额度，正常喂食即可，不要额外加量。\n\n");

        sb.append("### 零食怎么选\n");
        if (snacks.isEmpty()) {
            sb.append("- 食品库暂无适用零食，建议先录入合适的零食，或把零食额度留空。\n\n");
        } else {
            sb.append("- 零食合计不超过 ").append(Math.round(plan.getSnackBudgetKcal()))
              .append(" kcal/天。可选：");
            sb.append(snacks.stream()
                    .map(f -> {
                        String name = (f.getBrand() != null ? f.getBrand() + " " : "") + f.getName();
                        Double grams = maxDailyGrams(f, plan.getSnackBudgetKcal());
                        return grams != null ? name + "（单种上限约 " + grams + " g）" : name;
                    })
                    .collect(Collectors.joining("、")));
            sb.append("。\n\n");
        }

        sb.append("### 可以补充的食材\n");
        if (organKnowledgeAvailable) {
            sb.append("- 知识库提到动物心脏、肝脏可作为部分营养素来源，但没有给出可直接照搬的喂量。")
              .append("如需添加，请先咨询兽医或宠物营养师，少量、煮熟、不调味，并注意肝脏维生素A过量风险。\n\n");
        } else {
            sb.append("- 知识库暂未收录猪肝、鸡心等内脏的具体营养数据，本次不建议自行添加内脏加餐。")
              .append("如要补充，请先查阅可靠数据并咨询兽医。\n\n");
        }

        sb.append("### 注意\n");
        sb.append("- 零食热量已计入每日总热量，不能额外再加主粮；零食变化时请相应减少。\n");
        sb.append("- 严禁巧克力、葡萄/葡萄干、洋葱/大蒜和木糖醇。\n");
        sb.append("- 以上建议仅供参考，不构成医疗建议。");
        return sb.toString();
    }

    private String determineLifeStage(PetDO pet) {
        if (pet.getBirthday() == null) return "adult";
        long months = ChronoUnit.MONTHS.between(pet.getBirthday(), LocalDate.now());
        if (months < 12) return "young";
        if (months >= 84) return "senior";
        return "adult";
    }
}
