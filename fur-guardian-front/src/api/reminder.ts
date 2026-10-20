import request from './request'
import type { Reminder, ReminderForm, ReminderLog } from '@/types'

export const reminderApi = {
  create(data: ReminderForm) {
    return request.post<number>('/api/reminder', data)
  },
  list(petId?: number) {
    return request.get<Reminder[]>('/api/reminder/list', { params: petId ? { petId } : {} })
  },
  update(id: number, data: ReminderForm) {
    return request.put<void>(`/api/reminder/${id}`, data)
  },
  remove(id: number) {
    return request.delete<void>(`/api/reminder/${id}`)
  },
  checkin(id: number, data: { doneDate?: string; note?: string }) {
    return request.post<void>(`/api/reminder/${id}/checkin`, data)
  },
  logs(params: { petId: number; startDate?: string; endDate?: string }) {
    return request.get<ReminderLog[]>('/api/reminder/logs', { params })
  },
}
