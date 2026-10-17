package com.purr.furguardian.biz.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.food.FoodNutrientDO;

public interface FoodService {

    Long createFood(Long userId, FoodDO food, FoodNutrientDO nutrients);

    void updateFood(Long userId, Long foodId, FoodDO food, FoodNutrientDO nutrients);

    void deleteFood(Long userId, Long foodId);

    FoodDO getFood(Long foodId);

    Page<FoodDO> listFoods(Long userId, int page, int size, String keyword);

    FoodNutrientDO getNutrients(Long foodId);
}
