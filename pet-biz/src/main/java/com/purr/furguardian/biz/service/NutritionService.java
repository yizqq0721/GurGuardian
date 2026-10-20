package com.purr.furguardian.biz.service;

import com.purr.furguardian.nutrition.model.NutritionResult;

public interface NutritionService {

    NutritionResult calculatePlan(Long userId, Long petId, Long foodId);

    /** 只计算不入库，供 AI 食谱等只读场景复用 */
    NutritionResult previewPlan(Long userId, Long petId, Long foodId);
}
