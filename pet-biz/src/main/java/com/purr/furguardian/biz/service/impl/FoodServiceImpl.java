package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.food.FoodNutrientDO;
import com.purr.furguardian.biz.mapper.food.FoodMapper;
import com.purr.furguardian.biz.mapper.food.FoodNutrientMapper;
import com.purr.furguardian.biz.service.FoodService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;

@Service
public class FoodServiceImpl implements FoodService {

    private final FoodMapper foodMapper;
    private final FoodNutrientMapper nutrientMapper;

    public FoodServiceImpl(FoodMapper foodMapper, FoodNutrientMapper nutrientMapper) {
        this.foodMapper = foodMapper;
        this.nutrientMapper = nutrientMapper;
    }

    @Override
    public Long createFood(Long userId, FoodDO food, FoodNutrientDO nutrients) {
        food.setId(null);
        food.setUserId(userId);
        food.setCreatedAt(LocalDateTime.now());
        food.setUpdatedAt(LocalDateTime.now());
        foodMapper.insert(food);

        if (nutrients != null) {
            nutrients.setId(null);
            nutrients.setFoodId(food.getId());
            nutrients.setCreatedAt(LocalDateTime.now());
            nutrientMapper.insert(nutrients);
        }
        return food.getId();
    }

    @Override
    public void updateFood(Long userId, Long foodId, FoodDO food, FoodNutrientDO nutrients) {
        FoodDO existing = getFood(foodId);
        if (existing.getUserId() != null && !existing.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.FORBIDDEN, "无权修改公共食品");
        }
        food.setId(foodId);
        food.setUpdatedAt(LocalDateTime.now());
        foodMapper.updateById(food);

        if (nutrients != null) {
            LambdaQueryWrapper<FoodNutrientDO> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(FoodNutrientDO::getFoodId, foodId);
            FoodNutrientDO existingNutrient = nutrientMapper.selectOne(wrapper);
            if (existingNutrient != null) {
                nutrients.setId(existingNutrient.getId());
                nutrientMapper.updateById(nutrients);
            } else {
                nutrients.setId(null);
                nutrients.setFoodId(foodId);
                nutrients.setCreatedAt(LocalDateTime.now());
                nutrientMapper.insert(nutrients);
            }
        }
    }

    @Override
    public void deleteFood(Long userId, Long foodId) {
        FoodDO existing = getFood(foodId);
        if (existing.getUserId() != null && !existing.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.FORBIDDEN, "无权删除公共食品");
        }
        foodMapper.deleteById(foodId);
        LambdaQueryWrapper<FoodNutrientDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(FoodNutrientDO::getFoodId, foodId);
        nutrientMapper.delete(wrapper);
    }

    @Override
    public FoodDO getFood(Long foodId) {
        FoodDO food = foodMapper.selectById(foodId);
        if (food == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "食品不存在");
        }
        return food;
    }

    @Override
    public Page<FoodDO> listFoods(Long userId, int page, int size, String keyword) {
        LambdaQueryWrapper<FoodDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.and(w -> w.isNull(FoodDO::getUserId).or().eq(FoodDO::getUserId, userId));
        wrapper.eq(FoodDO::getReviewStatus, "approved");
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(FoodDO::getName, keyword).or().like(FoodDO::getBrand, keyword));
        }
        wrapper.orderByDesc(FoodDO::getCreatedAt);
        return foodMapper.selectPage(new Page<>(page, size), wrapper);
    }

    @Override
    public FoodNutrientDO getNutrients(Long foodId) {
        LambdaQueryWrapper<FoodNutrientDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(FoodNutrientDO::getFoodId, foodId);
        return nutrientMapper.selectOne(wrapper);
    }
}
