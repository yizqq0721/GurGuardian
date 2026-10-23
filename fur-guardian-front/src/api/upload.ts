import request from './request'

export interface AvatarUploadResult {
  url: string
}

export const uploadApi = {
  avatar(file: File) {
    const data = new FormData()
    data.append('file', file)
    return request.post<AvatarUploadResult>('/api/upload/avatar', data)
  },
}
