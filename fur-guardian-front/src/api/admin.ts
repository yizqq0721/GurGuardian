import request from './request'
import type { AdminUser, AdminUserDetail, PageResult } from '@/types'

export const adminApi = {
  listUsers(params: { page?: number; size?: number; keyword?: string }) {
    return request.get<PageResult<AdminUser>>('/api/admin/users', { params })
  },
  getUser(id: number) {
    return request.get<AdminUserDetail>(`/api/admin/users/${id}`)
  },
  updateStatus(id: number, status: number) {
    return request.put<void>(`/api/admin/users/${id}/status`, { status })
  },
}
