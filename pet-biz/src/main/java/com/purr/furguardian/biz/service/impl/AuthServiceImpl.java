package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.pet.UserDO;
import com.purr.furguardian.biz.mapper.pet.UserMapper;
import com.purr.furguardian.biz.service.AuthService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.util.PasswordUtil;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class AuthServiceImpl implements AuthService {

    private static final String TOKEN_PREFIX = "login:token:";
    private static final long TOKEN_TTL_DAYS = 7;

    private final UserMapper userMapper;
    private final StringRedisTemplate redisTemplate;

    public AuthServiceImpl(UserMapper userMapper, StringRedisTemplate redisTemplate) {
        this.userMapper = userMapper;
        this.redisTemplate = redisTemplate;
    }

    @Override
    public Long register(String username, String password, String nickname) {
        LambdaQueryWrapper<UserDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserDO::getUsername, username);
        if (userMapper.selectCount(wrapper) > 0) {
            throw new BizException(ErrorCode.NAME_DUPLICATE, "用户名已存在");
        }

        UserDO user = new UserDO();
        user.setUsername(username);
        user.setPassword(PasswordUtil.encode(password));
        user.setNickname(nickname != null ? nickname : username);
        user.setStatus(1);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        userMapper.insert(user);
        return user.getId();
    }

    @Override
    public String login(String username, String password) {
        LambdaQueryWrapper<UserDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserDO::getUsername, username);
        UserDO user = userMapper.selectOne(wrapper);
        if (user == null) {
            throw new BizException(ErrorCode.UNAUTHORIZED, "用户名或密码错误");
        }
        if (user.getStatus() != 1) {
            throw new BizException(ErrorCode.FORBIDDEN, "账号已被禁用");
        }
        if (!PasswordUtil.matches(password, user.getPassword())) {
            throw new BizException(ErrorCode.UNAUTHORIZED, "用户名或密码错误");
        }

        String token = UUID.randomUUID().toString().replace("-", "");
        redisTemplate.opsForValue().set(TOKEN_PREFIX + token, String.valueOf(user.getId()), TOKEN_TTL_DAYS, TimeUnit.DAYS);
        return token;
    }

    @Override
    public void logout(String token) {
        if (token != null) {
            redisTemplate.delete(TOKEN_PREFIX + token);
        }
    }

    @Override
    public Long getUserIdByUsername(String username) {
        LambdaQueryWrapper<UserDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserDO::getUsername, username);
        UserDO user = userMapper.selectOne(wrapper);
        return user != null ? user.getId() : null;
    }

    @Override
    public String getNicknameByUsername(String username) {
        LambdaQueryWrapper<UserDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserDO::getUsername, username);
        UserDO user = userMapper.selectOne(wrapper);
        return user != null ? user.getNickname() : null;
    }
}
