import request from './request'
import type { WeatherToday } from '@/types'

export const weatherApi = {
  /**
   * 有定位坐标时按坐标查询，否则后端按用户当前位置查询；
   * 未配置 Key、位置为空或无效、上游不可用时返回 null
   */
  today(coords?: { lat: number; lng: number }) {
    return request.get<WeatherToday | null>('/api/weather/today', {
      params: coords,
      silent: true,
    })
  },
}
