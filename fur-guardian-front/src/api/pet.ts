import request from './request'
import type { Pet, PetForm, WeightLog } from '@/types'

export const petApi = {
  create(data: PetForm) {
    return request.post<number>('/api/pet', data)
  },
  list() {
    return request.get<Pet[]>('/api/pet/list')
  },
  detail(id: number) {
    return request.get<Pet>(`/api/pet/${id}`)
  },
  update(id: number, data: PetForm) {
    return request.put<void>(`/api/pet/${id}`, data)
  },
  remove(id: number) {
    return request.delete<void>(`/api/pet/${id}`)
  },
  addWeight(id: number, data: { weightKg?: number; bcs?: number; recordedAt?: string }) {
    return request.post<void>(`/api/pet/${id}/weight`, data)
  },
  weightHistory(id: number) {
    return request.get<WeightLog[]>(`/api/pet/${id}/weight-history`)
  },
}
