import request from './request'
import type { WeatherToday } from '@/types'

export const weatherApi = {
  /**
   * 后端按用户资料的常用城市查询；
   * 未配置 Key、城市为空或无效、上游不可用时返回 null
   */
  today() {
    return request.get<WeatherToday | null>('/api/weather/today', { silent: true })
  },
}
