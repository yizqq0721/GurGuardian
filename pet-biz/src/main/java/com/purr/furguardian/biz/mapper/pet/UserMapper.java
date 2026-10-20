package com.purr.furguardian.biz.mapper.pet;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.purr.furguardian.biz.entity.pet.UserDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<UserDO> {
}
