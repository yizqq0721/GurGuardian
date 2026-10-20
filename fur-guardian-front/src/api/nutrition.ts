import request from './request'
import type { NutritionPlan, NutritionRecipe } from '@/types'

export const nutritionApi = {
  calculate(petId: number, foodId: number) {
    return request.get<NutritionPlan>('/api/nutrition/calculate', { params: { petId, foodId } })
  },
  recipe(petId: number, foodId: number) {
    return request.get<NutritionRecipe>('/api/nutrition/recipe', {
      params: { petId, foodId },
      timeout: 60000,
    })
  },
}
