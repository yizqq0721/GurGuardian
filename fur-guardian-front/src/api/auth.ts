import request from './request'
import type { LoginResp } from '@/types'

export const authApi = {
  register(data: { username: string; password: string; nickname?: string }) {
    return request.post<number>('/api/auth/register', data)
  },
  login(data: { username: string; password: string }) {
    return request.post<LoginResp>('/api/auth/login', data)
  },
  logout() {
    return request.post<null>('/api/auth/logout')
  },
}
