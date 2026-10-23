package com.purr.furguardian.biz.service.impl;

import com.purr.furguardian.biz.service.MailSettingsService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.regex.Pattern;

@Service
public class MailSettingsServiceImpl implements MailSettingsService {

    private static final String KEY_PREFIX = "fg:mail:settings:";
    private static final int MAX_EMAIL_LENGTH = 128;
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final StringRedisTemplate redisTemplate;

    public MailSettingsServiceImpl(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    @Override
    public MailSettings get(Long userId) {
        Map<Object, Object> entries = redisTemplate.opsForHash().entries(key(userId));
        String email = normalize((String) entries.get("email"));
        boolean enabled = "1".equals(entries.get("enabled")) && email != null;
        return new MailSettings(email == null ? "" : email, enabled);
    }

    @Override
    public MailSettings save(Long userId, String email, boolean enabled) {
        String value = normalize(email);
        if (value != null) {
            if (value.length() > MAX_EMAIL_LENGTH) {
                throw new BizException(ErrorCode.BAD_REQUEST, "邮箱地址过长");
            }
            if (!EMAIL_PATTERN.matcher(value).matches()) {
                throw new BizException(ErrorCode.BAD_REQUEST, "邮箱格式不正确");
            }
        }
        if (enabled && value == null) {
            throw new BizException(ErrorCode.BAD_REQUEST, "请先填写邮箱地址");
        }

        String key = key(userId);
        if (value == null) {
            redisTemplate.delete(key);
            return new MailSettings("", false);
        }
        redisTemplate.opsForHash().putAll(key, Map.of(
                "email", value,
                "enabled", enabled ? "1" : "0"));
        return new MailSettings(value, enabled);
    }

    private static String key(Long userId) {
        return KEY_PREFIX + userId;
    }

    private static String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
