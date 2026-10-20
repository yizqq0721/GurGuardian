import request from './request'
import type { Tip } from '@/types'

export const tipApi = {
  today(petId: number, mock = false) {
    return request.get<Tip>('/api/tip/today', { params: { petId, mock } })
  },
  history(petId: number, limit = 10) {
    return request.get<Tip[]>('/api/tip/history', { params: { petId, limit } })
  },
  feedback(tipId: number, feedback: 'like' | 'dislike') {
    return request.post<void>(`/api/tip/${tipId}/feedback`, { feedback })
  },
  checkRedline(text: string) {
    return request.post<boolean>('/api/tip/check-redline', null, { params: { text } })
  },
  streamUrl(petId: number, mock = false, refresh = false) {
    return `/api/tip/stream?petId=${petId}&mock=${mock}&refresh=${refresh}`
  },
}
