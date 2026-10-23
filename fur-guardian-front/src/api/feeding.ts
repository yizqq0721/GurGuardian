import request from './request'
import type { FeedingLog } from '@/types'

export const feedingApi = {
  create(data: { petId: number; foodId: number; grams: number; fedDate?: string; mealIndex?: number }) {
    return request.post<number>('/api/feeding', data)
  },
  list(params: { petId?: number; startDate?: string; endDate?: string }) {
    return request.get<FeedingLog[]>('/api/feeding/list', { params })
  },
}
