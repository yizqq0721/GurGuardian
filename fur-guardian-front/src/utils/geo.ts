/* ============================================================
   坐标系换算：浏览器 navigator.geolocation 返回 WGS-84，
   高德地图/高德 Web 服务全部使用 GCJ-02（火星坐标），
   不换算会在高德底图上偏移 100~700 米。
   算法为国家测绘局标准公开算法。
   ============================================================ */

const PI = Math.PI
const AXIS = 6378245.0
const ECCENTRICITY = 0.00669342162296594323

function outOfChina(lng: number, lat: number) {
  return lng < 72.004 || lng > 137.8347 || lat < 0.8293 || lat > 55.8271
}

function transformLat(x: number, y: number) {
  let ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(Math.abs(x))
  ret += ((20.0 * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0) / 3.0
  ret += ((20.0 * Math.sin(y * PI) + 40.0 * Math.sin((y / 3.0) * PI)) * 2.0) / 3.0
  ret += ((160.0 * Math.sin((y / 12.0) * PI) + 320 * Math.sin((y * PI) / 30.0)) * 2.0) / 3.0
  return ret
}

function transformLng(x: number, y: number) {
  let ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x))
  ret += ((20.0 * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0) / 3.0
  ret += ((20.0 * Math.sin(x * PI) + 40.0 * Math.sin((x / 3.0) * PI)) * 2.0) / 3.0
  ret += ((150.0 * Math.sin((x / 12.0) * PI) + 300.0 * Math.sin((x / 30.0) * PI)) * 2.0) / 3.0
  return ret
}

/** WGS-84 → GCJ-02；境外坐标原样返回（高德在境外不偏移）。返回 [lng, lat]。 */
export function wgs84ToGcj02(lng: number, lat: number): [number, number] {
  if (outOfChina(lng, lat)) {
    return [lng, lat]
  }
  let dLat = transformLat(lng - 105.0, lat - 35.0)
  let dLng = transformLng(lng - 105.0, lat - 35.0)
  const radLat = (lat / 180.0) * PI
  let magic = Math.sin(radLat)
  magic = 1 - ECCENTRICITY * magic * magic
  const sqrtMagic = Math.sqrt(magic)
  dLat = (dLat * 180.0) / (((AXIS * (1 - ECCENTRICITY)) / (magic * sqrtMagic)) * PI)
  dLng = (dLng * 180.0) / ((AXIS / sqrtMagic) * Math.cos(radLat) * PI)
  return [lng + dLng, lat + dLat]
}

const GEO_KEY = 'fg_last_geo'

export interface GeoPoint {
  lat: number
  lng: number
  at: number
}

/** 复用最近一次定位，避免每次进页面都弹权限；坐标是 GCJ-02。 */
export function readSavedGeo(): GeoPoint | null {
  try {
    const raw = localStorage.getItem(GEO_KEY)
    if (!raw) return null
    const point = JSON.parse(raw) as GeoPoint
    if (typeof point.lat !== 'number' || typeof point.lng !== 'number') return null
    if (point.lat < -90 || point.lat > 90 || point.lng < -180 || point.lng > 180) return null
    return point
  } catch {
    return null
  }
}

export function saveGeo(lat: number, lng: number) {
  localStorage.setItem(GEO_KEY, JSON.stringify({ lat, lng, at: Date.now() }))
}

/** 定位失败时抛出 unsupported / denied / unavailable，调用方据此决定提示文案。 */
export function requestGeo(): Promise<GeoPoint> {
  return new Promise((resolve, reject) => {
    if (!('geolocation' in navigator)) {
      reject(new Error('unsupported'))
      return
    }
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const [lng, lat] = wgs84ToGcj02(pos.coords.longitude, pos.coords.latitude)
        saveGeo(lat, lng)
        resolve({ lat, lng, at: Date.now() })
      },
      (err) => {
        reject(new Error(err.code === err.PERMISSION_DENIED ? 'denied' : 'unavailable'))
      },
      { enableHighAccuracy: false, timeout: 8000, maximumAge: 600000 },
    )
  })
}