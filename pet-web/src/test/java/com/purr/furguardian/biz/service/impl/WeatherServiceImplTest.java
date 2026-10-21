package com.purr.furguardian.biz.service.impl;

import org.junit.jupiter.api.Test;
import tools.jackson.databind.ObjectMapper;

import static org.junit.jupiter.api.Assertions.*;

class WeatherServiceImplTest {

    private final WeatherServiceImpl service =
            new WeatherServiceImpl(new ObjectMapper(), "test-key", "https://api.seniverse.com");

    @Test
    void parsesDailyForecastAndRainAdvice() {
        String body = """
                {"results":[{"location":{"id":"WX4FBXXFKE4F","name":"北京"},
                "daily":[{"date":"2026-10-21","text_day":"小雨","code_day":"13",
                "text_night":"阴","code_night":"9","high":"22","low":"15","precip":"0.60",
                "wind_direction":"东北","wind_direction_degree":"45","wind_speed":"12.0",
                "wind_scale":"2","humidity":"78"}],"last_update":"2026-10-21T08:00:00+08:00"}]}
                """;

        WeatherServiceImpl.WalkAdvice advice = WeatherServiceImpl.judge("小雨", "阴", 22, 15, 2, 0.6);
        assertEquals("CAUTION", advice.level());
        assertTrue(advice.advice().contains("雨"));

        var weather = service.parse(body);
        assertNotNull(weather);
        assertEquals("北京", weather.location());
        assertEquals("小雨", weather.text());
        assertEquals(22, weather.high());
        assertEquals(15, weather.low());
        assertEquals("2", weather.windScale());
        assertEquals(0.6, weather.precip());
        assertEquals("CAUTION", weather.level());
    }

    @Test
    void gradesWalkSuitability() {
        assertEquals("GOOD", WeatherServiceImpl.judge("晴", "多云", 24, 16, 2, 0).level());
        assertEquals("AVOID", WeatherServiceImpl.judge("雷阵雨", "小雨", 28, 22, 4, 2).level());
        assertEquals("AVOID", WeatherServiceImpl.judge("中雪", "小雪", 2, -3, 3, 0).level());
        assertEquals("CAUTION", WeatherServiceImpl.judge("晴", "晴", 35, 26, 2, 0).level());
        assertEquals("CAUTION", WeatherServiceImpl.judge("晴", "晴", 4, -2, 2, 0).level());
        assertEquals("CAUTION", WeatherServiceImpl.judge("多云", "多云", 20, 12, 6, 0).level());
        assertEquals("CAUTION", WeatherServiceImpl.judge("霾", "霾", 20, 12, 2, 0).level());
    }

    @Test
    void withoutKeyReturnsNull() {
        WeatherServiceImpl unconfigured =
                new WeatherServiceImpl(new ObjectMapper(), " ", "https://api.seniverse.com");
        assertNull(unconfigured.today("39.9:116.4"));
    }

    @Test
    void blankLocationReturnsNull() {
        assertNull(service.today(" "));
        assertNull(service.today(null));
    }

    @Test
    void malformedPayloadReturnsNull() {
        assertNull(service.parse("{\"status\":\"failed\"}"));
        assertNull(service.parse("not-json"));
        assertNull(service.parse(""));
    }
}
