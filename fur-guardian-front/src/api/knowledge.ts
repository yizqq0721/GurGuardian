import request from './request'
import type { ChatMessage, ChatSession, CursorPage } from '@/types'

export interface ExchangePayload {
  question: string
  answer: string
  sourceDocIds: number[]
  isRedLine: boolean
  isFallback: boolean
}

/** 游标翻页：cursor 传上一页返回的 nextCursor，首次请求留空 */
type CursorParams = { cursor?: string | null; limit?: number }

export const chatApi = {
  sessions(params: CursorParams = {}) {
    return request.get<CursorPage<ChatSession>>('/api/knowledge/chats', { params })
  },
  create(data: { title?: string; petId?: number }) {
    return request.post<ChatSession>('/api/knowledge/chats', data)
  },
  rename(id: number, title: string) {
    return request.put<void>(`/api/knowledge/chats/${id}`, { title })
  },
  remove(id: number) {
    return request.delete<void>(`/api/knowledge/chats/${id}`)
  },
  messages(id: number, params: CursorParams = {}) {
    return request.get<CursorPage<ChatMessage>>(`/api/knowledge/chats/${id}/messages`, { params })
  },
  append(id: number, data: ExchangePayload) {
    return request.post<void>(`/api/knowledge/chats/${id}/messages`, data)
  },
}
