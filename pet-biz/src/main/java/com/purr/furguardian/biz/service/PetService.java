package com.purr.furguardian.biz.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface PetService {

    Long createPet(Long userId, PetDO pet);

    void updatePet(Long userId, Long petId, PetDO pet);

    void deletePet(Long userId, Long petId);

    PetDO getPet(Long userId, Long petId);

    List<PetDO> listPets(Long userId);

    void addWeightLog(Long userId, Long petId, BigDecimal weightKg, Integer bcs, LocalDate recordedAt);

    List<PetWeightLogDO> getWeightHistory(Long userId, Long petId);
}
