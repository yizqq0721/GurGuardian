import request from './request'
import type { UserProfile } from '@/types'

export const userApi = {
  profile(silent = false) {
    return request.get<UserProfile>('/api/user/profile', { silent })
  },
  update(data: { nickname?: string; location?: string }) {
    return request.put<UserProfile>('/api/user/profile', data)
  },
}
