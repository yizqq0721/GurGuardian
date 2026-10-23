package com.purr.furguardian.biz.service.impl;

import com.purr.furguardian.biz.service.PlacesService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class PlacesServiceImpl implements PlacesService {

    // 高德 POI 分类码：090700 动物医疗（含宠物诊所 090701、兽医站 090702）；110101 公园
    private static final Map<String, String> CATEGORY_TYPES = Map.of(
            "medical", "090700",
            "park", "110101"
    );

    private static final int POI_PAGE_SIZE = 25;

    private final ObjectMapper objectMapper;
    private final String webKey;
    private final RestClient restClient;

    public PlacesServiceImpl(ObjectMapper objectMapper, @Value("${fg.amap.web-key:}") String webKey) {
        this.objectMapper = objectMapper;
        this.webKey = webKey == null ? "" : webKey.trim();
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(Duration.ofSeconds(5));
        factory.setReadTimeout(Duration.ofSeconds(10));
        this.restClient = RestClient.builder()
                .baseUrl("https://restapi.amap.com")
                .requestFactory(factory)
                .build();
    }

    @Override
    public List<NearbyPlace> nearby(double lat, double lng, String category, int radiusMeters) {
        String types = CATEGORY_TYPES.get(category);
        if (types == null) {
            throw new BizException(ErrorCode.BAD_REQUEST, "category 仅支持 medical / park");
        }
        JsonNode root = amapGet("/v3/place/around",
                "location", lng + "," + lat,
                "types", types,
                "radius", String.valueOf(radiusMeters),
                "offset", String.valueOf(POI_PAGE_SIZE),
                "page", "1",
                "sortrule", "distance",
                "extensions", "base");

        List<NearbyPlace> places = new ArrayList<>();
        for (JsonNode poi : root.path("pois")) {
            double[] lngLat = parseLngLat(poi.path("location").asText(""));
            if (lngLat == null) {
                continue;
            }
            places.add(new NearbyPlace(
                    poi.path("id").asText(""),
                    poi.path("name").asText(""),
                    poi.path("type").asText(""),
                    blankToNull(poi.path("address").asText("")),
                    blankToNull(poi.path("tel").asText("")),
                    lngLat[1], lngLat[0],
                    parseInt(poi.path("distance").asText("0"))));
        }
        return places;
    }

    @Override
    public WalkRoute walkRoute(double fromLat, double fromLng, double toLat, double toLng) {
        JsonNode root = amapGet("/v3/direction/walking",
                "origin", fromLng + "," + fromLat,
                "destination", toLng + "," + toLat);

        // 步行接口返回 route.paths 数组（通常仅一条），distance/duration 在路径层，折线在 steps 里
        JsonNode paths = root.path("route").path("paths");
        JsonNode path = paths.isArray() && !paths.isEmpty() ? paths.get(0) : null;
        if (path == null) {
            throw new BizException(ErrorCode.BAD_REQUEST, "两地之间未找到可步行的路线");
        }
        List<double[]> polyline = new ArrayList<>();
        for (JsonNode step : path.path("steps")) {
            appendPolyline(polyline, step.path("polyline").asText(""));
        }
        if (polyline.isEmpty()) {
            throw new BizException(ErrorCode.BAD_REQUEST, "两地之间未找到可步行的路线");
        }
        return new WalkRoute(
                parseInt(path.path("distance").asText("0")),
                parseInt(path.path("duration").asText("0")),
                polyline);
    }

    @Override
    public GeoAddress regeo(double lat, double lng) {
        JsonNode root = amapGet("/v3/geocode/regeo",
                "location", lng + "," + lat,
                "extensions", "base",
                "radius", "1000");

        JsonNode component = root.path("regeocode").path("addressComponent");
        String province = blankToNull(component.path("province").asText(""));
        String city = blankToNull(component.path("city").asText(""));
        String district = blankToNull(component.path("district").asText(""));
        String base = city != null ? city : province;
        String label;
        if (district == null) {
            label = base;
        } else if (base == null || district.equals(base)) {
            label = district;
        } else {
            label = base + district;
        }
        if (label == null) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "未能解析当前位置的区县，请稍后重试");
        }
        return new GeoAddress(province, city, district, label);
    }

    private JsonNode amapGet(String path, String... queryPairs) {        String body = restClient.get()
                .uri(uriBuilder -> {
                    uriBuilder.path(path).queryParam("key", requireKey());
                    for (int i = 0; i < queryPairs.length; i += 2) {
                        uriBuilder.queryParam(queryPairs[i], queryPairs[i + 1]);
                    }
                    return uriBuilder.build();
                })
                .retrieve()
                .body(String.class);

        JsonNode root = objectMapper.readTree(body);
        if (!"1".equals(root.path("status").asText())) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, amapError(root));
        }
        return root;
    }

    private String requireKey() {
        if (webKey.isEmpty()) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "服务端未配置高德 Web 服务 Key（fg.amap.web-key）");
        }
        return webKey;
    }

    private String amapError(JsonNode root) {
        String info = root.path("info").asText("");
        return switch (root.path("infocode").asText("")) {
            case "10001" -> "高德 Key 无效，请确认申请的是「Web 服务」类型";
            case "10003" -> "高德 Key 今日调用量已用完";
            case "10004" -> "高德接口调用过于频繁，请稍后再试";
            case "10009" -> "高德 Key 与请求接口类型不匹配";
            default -> "高德接口返回异常：" + info;
        };
    }

    private void appendPolyline(List<double[]> line, String polyline) {
        for (String pair : polyline.split(";")) {
            double[] lngLat = parseLngLat(pair);
            if (lngLat == null) {
                continue;
            }
            // 相邻路段的衔接点会重复出现一次，去掉避免折线拐点处过密
            if (!line.isEmpty()) {
                double[] last = line.get(line.size() - 1);
                if (last[0] == lngLat[0] && last[1] == lngLat[1]) {
                    continue;
                }
            }
            line.add(lngLat);
        }
    }

    /** 解析 "lng,lat" 文本，格式不对返回 null。 */
    private static double[] parseLngLat(String text) {
        int comma = text.indexOf(',');
        if (comma <= 0) {
            return null;
        }
        try {
            return new double[]{
                    Double.parseDouble(text.substring(0, comma)),
                    Double.parseDouble(text.substring(comma + 1))
            };
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static int parseInt(String text) {
        try {
            return (int) Double.parseDouble(text);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /** 高德空字段会返回空串或字面量 "[]"，统一归一成 null。 */
    private static String blankToNull(String text) {
        return text == null || text.isEmpty() || "[]".equals(text) ? null : text;
    }
}