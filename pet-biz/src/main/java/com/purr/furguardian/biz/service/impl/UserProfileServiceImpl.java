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
        LambdaUpdateWrapper<UserDO> wrapper = new LambdaUpdateWrapper<UserDO>()
                .eq(UserDO::getId, userId)
                .set(UserDO::getUpdatedAt, LocalDateTime.now());

        // 字段为 null 表示本次不修改；传空串才表示清空
        if (nickname != null) {
            String nicknameValue = normalize(nickname);
            if (nicknameValue != null && nicknameValue.length() > MAX_NICKNAME) {
                throw new BizException(ErrorCode.BAD_REQUEST, "昵称最长 50 个字符");
            }
            wrapper.set(UserDO::getNickname, nicknameValue);
        }
        if (location != null) {
            String locationValue = normalize(location);
            if (locationValue != null && locationValue.length() > MAX_LOCATION) {
                throw new BizException(ErrorCode.BAD_REQUEST, "当前位置最长 64 个字符");
            }
            wrapper.set(UserDO::getLocation, locationValue);
        }

        int updated = userMapper.update(null, wrapper);
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
