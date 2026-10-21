package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.purr.furguardian.biz.entity.pet.UserDO;
import com.purr.furguardian.biz.mapper.pet.UserMapper;
import com.purr.furguardian.biz.service.UserProfileService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class UserProfileServiceImpl implements UserProfileService {

    private static final int MAX_NICKNAME = 50;
    private static final int MAX_LOCATION = 64;

    private final UserMapper userMapper;

    public UserProfileServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public UserProfile get(Long userId) {
        UserDO user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "用户不存在");
        }
        return toProfile(user);
    }

    @Override
    public UserProfile update(Long userId, String nickname, String location) {
        String nicknameValue = normalize(nickname);
        String locationValue = normalize(location);
        if (nicknameValue != null && nicknameValue.length() > MAX_NICKNAME) {
            throw new BizException(ErrorCode.BAD_REQUEST, "昵称最长 50 个字符");
        }
        if (locationValue != null && locationValue.length() > MAX_LOCATION) {
            throw new BizException(ErrorCode.BAD_REQUEST, "常用城市最长 64 个字符");
        }

        // updateById 会忽略 null，这里用 set 显式支持清空常用城市
        int updated = userMapper.update(null, new LambdaUpdateWrapper<UserDO>()
                .eq(UserDO::getId, userId)
                .set(UserDO::getNickname, nicknameValue)
                .set(UserDO::getLocation, locationValue)
                .set(UserDO::getUpdatedAt, LocalDateTime.now()));
        if (updated == 0) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "用户不存在");
        }
        return get(userId);
    }

    @Override
    public String locationOf(Long userId) {
        UserDO user = userMapper.selectById(userId);
        return user == null ? null : normalize(user.getLocation());
    }

    private static String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static UserProfile toProfile(UserDO user) {
        return new UserProfile(user.getId(), user.getUsername(), user.getNickname(), user.getLocation());
    }
}
