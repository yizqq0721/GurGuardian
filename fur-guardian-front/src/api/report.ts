import request from './request'
import type { ReportConclusion, WeeklyReport } from '@/types'

export const reportApi = {
  generate(petId: number, weekStart: string) {
    return request.post<WeeklyReport>('/api/report/generate', null, { params: { petId, weekStart } })
  },
  list(petId: number) {
    return request.get<WeeklyReport[]>('/api/report/list', { params: { petId } })
  },
  detail(id: number) {
    return request.get<WeeklyReport>(`/api/report/${id}`)
  },
  conclusions(id: number) {
    return request.get<ReportConclusion>(`/api/report/${id}/conclusions`)
  },
  polish(id: number, force = false) {
    return request.post<WeeklyReport>(`/api/report/${id}/polish`, null, { params: { force } })
  },
  summary(id: number) {
    return request.get<string>(`/api/report/${id}/summary`)
  },
}
