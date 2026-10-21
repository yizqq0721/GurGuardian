package com.purr.furguardian.biz.service.impl;

import com.purr.furguardian.biz.service.WeatherService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class WeatherServiceImpl implements WeatherService {

    private static final Logger log = LoggerFactory.getLogger(WeatherServiceImpl.class);
    private static final Duration CACHE_TTL = Duration.ofMinutes(10);
    private static final int MAX_CACHE_ENTRIES = 500;

    private final ObjectMapper objectMapper;
    private final RestClient restClient;
    private final String key;
    private final Map<String, Cached> cache = new ConcurrentHashMap<>();

    private record Cached(WeatherToday data, Instant expiresAt) {}

    public WeatherServiceImpl(ObjectMapper objectMapper,
                              @Value("${fg.weather.key:}") String key,
                              @Value("${fg.weather.base-url:https://api.seniverse.com}") String baseUrl) {
        this.objectMapper = objectMapper;
        this.key = key == null ? "" : key.trim();
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(Duration.ofSeconds(4));
        factory.setReadTimeout(Duration.ofSeconds(6));
        this.restClient = RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(factory)
                .build();
    }

    @Override
    public WeatherToday today(String location) {
        if (key.isEmpty()) {
            return null;
        }
        String normalized = location == null ? "" : location.trim();
        if (normalized.isEmpty()) {
            return null;
        }
        String cacheKey = LocalDate.now() + ":" + normalized;
        Cached cached = cache.get(cacheKey);
        if (cached != null && cached.expiresAt().isAfter(Instant.now())) {
            return cached.data();
        }
        WeatherToday data = fetch(normalized);
        if (data == null) {
            return cached == null ? null : cached.data();
        }
        if (cache.size() >= MAX_CACHE_ENTRIES) {
            cache.clear();
        }
        cache.put(cacheKey, new Cached(data, Instant.now().plus(CACHE_TTL)));
        return data;
    }

    private WeatherToday fetch(String location) {
        try {
            String body = restClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/v3/weather/daily.json")
                            .queryParam("key", key)
                            .queryParam("location", location)
                            .queryParam("language", "zh-Hans")
                            .queryParam("unit", "c")
                            .queryParam("start", "0")
                            .queryParam("days", "1")
                            .build())
                    .retrieve()
                    .body(String.class);
            return parse(body);
        } catch (RestClientResponseException e) {
            // 不打印请求 URL，避免把 key 带进日志
            log.warn("心知天气返回异常状态：{}", e.getStatusCode().value());
        } catch (Exception e) {
            log.warn("心知天气请求失败：{}", e.getClass().getSimpleName());
        }
        return null;
    }

    /** 解析 daily.json 的第一条；结构不完整时返回 null。 */
    WeatherToday parse(String body) {
        if (body == null || body.isBlank()) {
            return null;
        }
        JsonNode root;
        try {
            root = objectMapper.readTree(body);
        } catch (Exception notJson) {
            return null;
        }
        JsonNode results = root.path("results");
        if (!results.isArray() || results.isEmpty()) {
            return null;
        }
        JsonNode result = results.get(0);
        JsonNode daily = result.path("daily");
        if (!daily.isArray() || daily.isEmpty()) {
            return null;
        }
        JsonNode day = daily.get(0);
        String text = day.path("text_day").asText("");
        String textNight = day.path("text_night").asText("");
        int high = parseInt(day.path("high").asText("0"));
        int low = parseInt(day.path("low").asText("0"));
        int windScale = parseInt(day.path("wind_scale").asText("0"));
        double precip = parseDouble(day.path("precip").asText("0"));
        WalkAdvice verdict = judge(text, textNight, high, low, windScale, precip);
        return new WeatherToday(
                result.path("location").path("name").asText(""),
                text,
                textNight,
                high,
                low,
                day.path("wind_direction").asText(""),
                day.path("wind_scale").asText(""),
                day.path("humidity").asText(""),
                precip,
                verdict.level(),
                verdict.advice());
    }

    record WalkAdvice(String level, String advice) {}

    /** 以「能否遛弯」为口径分级，雨雪、极端温度和明显风力都会降级。 */
    static WalkAdvice judge(String textDay, String textNight, int high, int low, int windScale, double precip) {
        String all = textDay + " " + textNight;
        if (all.contains("雷") || all.contains("暴雨") || all.contains("暴雪")
                || all.contains("台风") || all.contains("冰雹") || all.contains("沙尘暴")) {
            return new WalkAdvice("AVOID", "强降水或雷暴，建议改为室内活动");
        }
        if (all.contains("雪")) {
            return new WalkAdvice("AVOID", "有降雪，路面湿滑，不建议久遛");
        }
        if (all.contains("雨") || precip > 0) {
            return new WalkAdvice("CAUTION", "有雨，带伞并缩短遛弯时间");
        }
        if (high >= 32) {
            return new WalkAdvice("CAUTION", "高温，避开正午并注意补水");
        }
        if (low <= 0) {
            return new WalkAdvice("CAUTION", "寒冷，出门注意保暖");
        }
        if (windScale >= 5) {
            return new WalkAdvice("CAUTION", "风大，选择避风路线");
        }
        if (all.contains("雾") || all.contains("霾") || all.contains("沙")) {
            return new WalkAdvice("CAUTION", "能见度差，缩短户外时间");
        }
        return new WalkAdvice("GOOD", "天气适宜，适合遛弯");
    }

    private static int parseInt(String text) {
        try {
            return (int) Double.parseDouble(text);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private static double parseDouble(String text) {
        try {
            return Double.parseDouble(text);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
