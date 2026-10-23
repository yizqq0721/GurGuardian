package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.feeding.FeedingLogDO;
import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.mapper.feeding.FeedingLogMapper;
import com.purr.furguardian.biz.service.FeedingLogService;
import com.purr.furguardian.biz.service.FoodService;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class FeedingLogServiceImpl implements FeedingLogService {

    private final FeedingLogMapper logMapper;
    private final PetService petService;
    private final FoodService foodService;

    public FeedingLogServiceImpl(FeedingLogMapper logMapper, PetService petService, FoodService foodService) {
        this.logMapper = logMapper;
        this.petService = petService;
        this.foodService = foodService;
    }

    @Override
    public Long createLog(Long userId, FeedingLogDO log) {
        PetDO pet = petService.getPet(userId, log.getPetId());

        FoodDO food = foodService.getFood(log.getFoodId());
        if (food.getUserId() != null && !food.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.FORBIDDEN, "无权使用该食品");
        }
        validateSpecies(pet, food);

        LocalDate fedDate = log.getFedDate() != null ? log.getFedDate() : LocalDate.now();
        if (fedDate.isAfter(LocalDate.now())) {
            throw new BizException(ErrorCode.BAD_REQUEST, "喂食日期不能晚于今天");
        }

        log.setId(null);
        log.setUserId(userId);
        log.setFedDate(fedDate);
        if (log.getMealIndex() == null) {
            log.setMealIndex(1);
        }
        // 食品标注代谢能是 kcal/kg，按实际克数折算这一餐的热量
        if (food.getLabeledMeKcal() != null) {
            log.setKcal(log.getGrams()
                    .multiply(food.getLabeledMeKcal())
                    .divide(BigDecimal.valueOf(1000), 2, RoundingMode.HALF_UP));
        } else {
            log.setKcal(null);
        }
        log.setCreatedAt(LocalDateTime.now());
        logMapper.insert(log);
        return log.getId();
    }

    /** 与营养方案保持同一口径：猫只吃 CAT/BOTH，犬只吃 DOG/BOTH，未标注的放行 */
    private void validateSpecies(PetDO pet, FoodDO food) {
        String scope = food.getSpeciesScope();
        if (scope == null || scope.isBlank() || "BOTH".equalsIgnoreCase(scope)) {
            return;
        }
        String expected = "dog".equalsIgnoreCase(pet.getSpecies()) ? "DOG" : "CAT";
        if (!expected.equalsIgnoreCase(scope)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "该食品适用物种与当前宠物不一致，请重新选择");
        }
    }

    @Override
    public List<FeedingLogDO> listLogs(Long userId, Long petId, LocalDate startDate, LocalDate endDate) {
        LambdaQueryWrapper<FeedingLogDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(FeedingLogDO::getUserId, userId)
                .eq(petId != null, FeedingLogDO::getPetId, petId)
                .ge(startDate != null, FeedingLogDO::getFedDate, startDate)
                .le(endDate != null, FeedingLogDO::getFedDate, endDate)
                .orderByDesc(FeedingLogDO::getFedDate)
                .orderByDesc(FeedingLogDO::getId);
        return logMapper.selectList(wrapper);
    }
}
