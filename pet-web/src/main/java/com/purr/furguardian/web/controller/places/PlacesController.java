package com.purr.furguardian.web.controller.places;

import com.purr.furguardian.biz.service.PlacesService;
import com.purr.furguardian.biz.service.PlacesService.NearbyPlace;
import com.purr.furguardian.biz.service.PlacesService.WalkRoute;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.result.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/places")
@Tag(name = "周边资源")
public class PlacesController {

    private static final int MIN_RADIUS = 500;
    private static final int MAX_RADIUS = 5000;

    private final PlacesService placesService;

    public PlacesController(PlacesService placesService) {
        this.placesService = placesService;
    }

    @GetMapping("/nearby")
    @Operation(summary = "周边宠物医疗/公园",
               description = "坐标用 GCJ-02（高德坐标系）；category 支持 medical / park，radius 单位米（500~5000）")
    public Result<List<NearbyPlace>> nearby(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "medical") String category,
            @RequestParam(defaultValue = "3000") int radius) {
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
            throw new BizException(ErrorCode.BAD_REQUEST, "坐标超出合法范围");
        }
        return Result.ok(placesService.nearby(lat, lng, category,
                Math.max(MIN_RADIUS, Math.min(radius, MAX_RADIUS))));
    }

    @GetMapping("/walk")
    @Operation(summary = "步行路线",
               description = "坐标用 GCJ-02；返回折线点串与总距离/步行时长")
    public Result<WalkRoute> walk(
            @RequestParam double fromLat,
            @RequestParam double fromLng,
            @RequestParam double toLat,
            @RequestParam double toLng) {
        return Result.ok(placesService.walkRoute(fromLat, fromLng, toLat, toLng));
    }
}