import request from './request'
import type { AiQueryResp, KnowledgeDoc } from '@/types'

export const aiApi = {
  query(data: { query: string; petId?: number }) {
    return request.post<AiQueryResp>('/api/ai/query', data)
  },
  search(params: { query: string; species?: string; lifeStage?: string; topN?: number }) {
    return request.get<KnowledgeDoc[]>('/api/ai/search', { params })
  },
}
