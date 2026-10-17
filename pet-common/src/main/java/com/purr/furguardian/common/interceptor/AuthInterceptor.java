package com.purr.furguardian.common.interceptor;

import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.web.servlet.HandlerInterceptor;
import tools.jackson.databind.ObjectMapper;

import java.nio.charset.StandardCharsets;

public class AuthInterceptor implements HandlerInterceptor {

    private static final String AUTH_HEADER = "Authorization";
    private static final String TOKEN_PREFIX = "login:token:";

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;

    public AuthInterceptor(StringRedisTemplate redisTemplate, ObjectMapper objectMapper) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String header = request.getHeader(AUTH_HEADER);
        if (header == null || !header.startsWith("Bearer ")) {
            writeUnauthorized(response);
            return false;
        }

        String token = header.substring(7);
        String userId = redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
        if (userId == null) {
            writeUnauthorized(response);
            return false;
        }

        UserContext.setUserId(Long.parseLong(userId));
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        UserContext.clear();
    }

    private void writeUnauthorized(HttpServletResponse response) throws Exception {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        Result<Void> result = Result.fail(ErrorCode.UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}
