package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.pet.PetWeightLogMapper;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PetServiceImpl implements PetService {

    private final PetMapper petMapper;
    private final PetWeightLogMapper weightLogMapper;

    public PetServiceImpl(PetMapper petMapper, PetWeightLogMapper weightLogMapper) {
        this.petMapper = petMapper;
        this.weightLogMapper = weightLogMapper;
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
        PetDO existing = getPet(userId, petId);
        pet.setId(petId);
        pet.setUserId(userId);
        pet.setUpdatedAt(LocalDateTime.now());
        petMapper.updateById(pet);
    }

    @Override
    public void deletePet(Long userId, Long petId) {
        getPet(userId, petId);
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
