import request from './request'
import type { NutritionPlan } from '@/types'

export const nutritionApi = {
  calculate(petId: number, foodId: number) {
    return request.get<NutritionPlan>('/api/nutrition/calculate', { params: { petId, foodId } })
  },
}
