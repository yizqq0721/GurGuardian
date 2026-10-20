package com.purr.furguardian.biz.mapper.pet;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.purr.furguardian.biz.entity.pet.PetDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PetMapper extends BaseMapper<PetDO> {
}
