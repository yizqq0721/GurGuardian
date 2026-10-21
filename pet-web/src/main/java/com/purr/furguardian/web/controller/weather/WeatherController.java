package com.purr.furguardian.web.controller.weather;

import com.purr.furguardian.biz.service.UserProfileService;
import com.purr.furguardian.biz.service.WeatherService;
import com.purr.furguardian.biz.service.WeatherService.WeatherToday;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.result.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Locale;

@RestController
@RequestMapping("/api/weather")
@Tag(name = "天气")
public class WeatherController {

    private final WeatherService weatherService;
    private final UserProfileService userProfileService;

    public WeatherController(WeatherService weatherService, UserProfileService userProfileService) {
        this.weatherService = weatherService;
        this.userProfileService = userProfileService;
    }

    @GetMapping("/today")
    @Operation(summary = "今日天气与遛弯建议",
               description = "优先按用户资料的常用城市查询；未设置时使用 GCJ-02 坐标；"
                       + "服务端未配置心知 Key 或上游不可用时 data 为 null")
    public Result<WeatherToday> today(@RequestParam(required = false) Double lat,
                                      @RequestParam(required = false) Double lng) {
        String savedLocation = userProfileService.locationOf(UserContext.getUserId());
        if (savedLocation != null && !savedLocation.isBlank()) {
            return Result.ok(weatherService.today(savedLocation));
        }
        if (lat == null || lng == null) {
            return Result.ok(null);
        }
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
            throw new BizException(ErrorCode.BAD_REQUEST, "坐标超出合法范围");
        }
        return Result.ok(weatherService.today(String.format(Locale.ROOT, "%.4f:%.4f", lat, lng)));
    }
}
