import request from './request'
import type { MailSettings, UserProfile } from '@/types'

export const userApi = {
  profile(silent = false) {
    return request.get<UserProfile>('/api/user/profile', { silent })
  },
  update(data: { nickname?: string; location?: string }) {
    return request.put<UserProfile>('/api/user/profile', data)
  },
  mailSettings() {
    return request.get<MailSettings>('/api/user/mail-settings')
  },
  updateMailSettings(data: MailSettings) {
    return request.put<MailSettings>('/api/user/mail-settings', data)
  },
}
