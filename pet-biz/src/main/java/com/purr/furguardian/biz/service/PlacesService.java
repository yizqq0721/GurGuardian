package com.purr.furguardian.biz.service;

import java.util.List;

/**
 * 周边资源查询（高德开放平台 Web 服务）。
 * 所有入参出参坐标均为 GCJ-02（高德坐标系），WGS-84 → GCJ-02 的换算由前端完成。
 */
public interface PlacesService {

    /** 高德 POI 精简后的周边地点。 */
    record NearbyPlace(String id, String name, String type, String address, String tel,
                       double lat, double lng, int distanceMeters) {}

    /** 步行路线；polyline 为 [[lng, lat], ...]，可直接喂给前端地图画线。 */
    record WalkRoute(int distanceMeters, int durationSeconds, List<double[]> polyline) {}

    /** category: medical=宠物医疗（含宠物诊所/兽医站），park=公园。 */
    List<NearbyPlace> nearby(double lat, double lng, String category, int radiusMeters);

    WalkRoute walkRoute(double fromLat, double fromLng, double toLat, double toLng);
}