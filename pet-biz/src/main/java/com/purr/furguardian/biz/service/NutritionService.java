package com.purr.furguardian.biz.service;

import com.purr.furguardian.nutrition.model.NutritionResult;

public interface NutritionService {

    NutritionResult calculatePlan(Long userId, Long petId, Long foodId);
}
