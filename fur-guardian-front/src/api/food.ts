import request from './request'
import type { Food, FoodForm, FoodNutrients, PageResult } from '@/types'

export const foodApi = {
  create(data: FoodForm) {
    return request.post<number>('/api/food', data)
  },
  list(params: { page?: number; size?: number; keyword?: string }) {
    return request.get<PageResult<Food>>('/api/food/list', { params })
  },
  detail(id: number) {
    return request.get<Food>(`/api/food/${id}`)
  },
  update(id: number, data: FoodForm) {
    return request.put<void>(`/api/food/${id}`, data)
  },
  remove(id: number) {
    return request.delete<void>(`/api/food/${id}`)
  },
  nutrients(id: number) {
    return request.get<FoodNutrients>(`/api/food/${id}/nutrients`)
  },
}
