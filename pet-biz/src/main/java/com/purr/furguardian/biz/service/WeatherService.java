package com.purr.furguardian.biz.service;

public interface WeatherService {

    record WeatherToday(String location, String text, String textNight, int high, int low,
                        String windDirection, String windScale, String humidity,
                        double precip, String level, String advice) {}

    /**
     * @param location 心知支持的地点，城市名（如“杭州”）或 “纬度:经度”
     */
    WeatherToday today(String location);
}
