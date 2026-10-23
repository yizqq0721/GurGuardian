package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.purr.furguardian.biz.entity.feeding.FeedingLogDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetProfileExtDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;
import com.purr.furguardian.biz.entity.report.FeedingPlanDO;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.entity.tip.TipDO;
import com.purr.furguardian.biz.mapper.feeding.FeedingLogMapper;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.pet.PetProfileExtMapper;
import com.purr.furguardian.biz.mapper.pet.PetWeightLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.mapper.report.FeedingPlanMapper;
import com.purr.furguardian.biz.mapper.report.WeeklyReportMapper;
import com.purr.furguardian.biz.mapper.tip.TipMapper;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PetServiceImpl implements PetService {

    private final PetMapper petMapper;
    private final PetWeightLogMapper weightLogMapper;
    private final PetProfileExtMapper profileExtMapper;
    private final ReminderMapper reminderMapper;
    private final ReminderLogMapper reminderLogMapper;
    private final FeedingLogMapper feedingLogMapper;
    private final FeedingPlanMapper feedingPlanMapper;
    private final WeeklyReportMapper reportMapper;
    private final TipMapper tipMapper;

    public PetServiceImpl(PetMapper petMapper,
                          PetWeightLogMapper weightLogMapper,
                          PetProfileExtMapper profileExtMapper,
                          ReminderMapper reminderMapper,
                          ReminderLogMapper reminderLogMapper,
                          FeedingLogMapper feedingLogMapper,
                          FeedingPlanMapper feedingPlanMapper,
                          WeeklyReportMapper reportMapper,
                          TipMapper tipMapper) {
        this.petMapper = petMapper;
        this.weightLogMapper = weightLogMapper;
        this.profileExtMapper = profileExtMapper;
        this.reminderMapper = reminderMapper;
        this.reminderLogMapper = reminderLogMapper;
        this.feedingLogMapper = feedingLogMapper;
        this.feedingPlanMapper = feedingPlanMapper;
        this.reportMapper = reportMapper;
        this.tipMapper = tipMapper;
    }

    @Override
    public Long createPet(Long userId, PetDO pet) {
        pet.setId(null);
        pet.setUserId(userId);
        pet.setCreatedAt(LocalDateTime.now());
        pet.setUpdatedAt(LocalDateTime.now());
        petMapper.insert(pet);
        return pet.getId();
    }

    @Override
    public void updatePet(Long userId, Long petId, PetDO pet) {
        getPet(userId, petId);
        // 显式 set 所有字段：updateById 会忽略 null，breed/avatar/birthday 无法清空
        LambdaUpdateWrapper<PetDO> update = new LambdaUpdateWrapper<>();
        update.eq(PetDO::getId, petId)
                .eq(PetDO::getUserId, userId)
                .set(PetDO::getName, pet.getName())
                .set(PetDO::getSpecies, pet.getSpecies())
                .set(PetDO::getBreed, pet.getBreed())
                .set(PetDO::getAvatar, pet.getAvatar())
                .set(PetDO::getSex, pet.getSex())
                .set(PetDO::getNeutered, pet.getNeutered())
                .set(PetDO::getBirthday, pet.getBirthday())
                .set(PetDO::getActivityLevel, pet.getActivityLevel())
                .set(PetDO::getBcs, pet.getBcs())
                .set(PetDO::getPhysiology, pet.getPhysiology())
                .set(PetDO::getUpdatedAt, LocalDateTime.now());
        petMapper.update(null, update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePet(Long userId, Long petId) {
        getPet(userId, petId);
        // 没有外键级联，删宠物前先清干净挂在它名下的数据，避免孤儿记录
        reminderLogMapper.delete(new LambdaQueryWrapper<ReminderLogDO>()
                .eq(ReminderLogDO::getPetId, petId));
        reminderMapper.delete(new LambdaQueryWrapper<ReminderDO>()
                .eq(ReminderDO::getPetId, petId));
        feedingLogMapper.delete(new LambdaQueryWrapper<FeedingLogDO>()
                .eq(FeedingLogDO::getPetId, petId));
        feedingPlanMapper.delete(new LambdaQueryWrapper<FeedingPlanDO>()
                .eq(FeedingPlanDO::getPetId, petId));
        reportMapper.delete(new LambdaQueryWrapper<WeeklyReportDO>()
                .eq(WeeklyReportDO::getPetId, petId));
        tipMapper.delete(new LambdaQueryWrapper<TipDO>()
                .eq(TipDO::getPetId, petId));
        profileExtMapper.delete(new LambdaQueryWrapper<PetProfileExtDO>()
                .eq(PetProfileExtDO::getPetId, petId));
        weightLogMapper.delete(new LambdaQueryWrapper<PetWeightLogDO>()
                .eq(PetWeightLogDO::getPetId, petId));
        petMapper.deleteById(petId);
    }

    @Override
    public PetDO getPet(Long userId, Long petId) {
        LambdaQueryWrapper<PetDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PetDO::getId, petId).eq(PetDO::getUserId, userId);
        PetDO pet = petMapper.selectOne(wrapper);
        if (pet == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "宠物不存在");
        }
        return pet;
    }

    @Override
    public List<PetDO> listPets(Long userId) {
        LambdaQueryWrapper<PetDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PetDO::getUserId, userId).orderByDesc(PetDO::getCreatedAt);
        return petMapper.selectList(wrapper);
    }

    @Override
    public void addWeightLog(Long userId, Long petId, BigDecimal weightKg, Integer bcs, LocalDate recordedAt) {
        getPet(userId, petId);
        PetWeightLogDO log = new PetWeightLogDO();
        log.setPetId(petId);
        log.setUserId(userId);
        log.setWeightKg(weightKg);
        log.setBcs(bcs);
        log.setRecordedAt(recordedAt != null ? recordedAt : LocalDate.now());
        log.setCreatedAt(LocalDateTime.now());
        weightLogMapper.insert(log);
    }

    @Override
    public List<PetWeightLogDO> getWeightHistory(Long userId, Long petId) {
        getPet(userId, petId);
        LambdaQueryWrapper<PetWeightLogDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PetWeightLogDO::getPetId, petId)
                .eq(PetWeightLogDO::getUserId, userId)
                .orderByAsc(PetWeightLogDO::getRecordedAt);
        return weightLogMapper.selectList(wrapper);
    }
}
