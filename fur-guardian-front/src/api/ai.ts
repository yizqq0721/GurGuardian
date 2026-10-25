import request from './request'
import type { AiQueryResp, ConfirmedAction, KnowledgeDoc, WeeklyReviewResp } from '@/types'

export const aiApi = {
  query(data: { query: string; petId?: number; sessionId?: number; pendingToken?: string }) {
    // 后端对整次问答有 40 秒预算，这里必须比它宽，否则用户先看到「网络异常」而不是降级回答
    return request.post<AiQueryResp>('/api/ai/query', data, { timeout: 60000 })
  },
  /** 双 Agent 复盘要顺序跑两次模型，后端预算 45 秒 */
  weeklyReview(data: { petId?: number }) {
    return request.post<WeeklyReviewResp>('/api/ai/weekly-review', data, { timeout: 60000 })
  },
  search(params: { query: string; species?: string; lifeStage?: string; topN?: number }) {
    return request.get<KnowledgeDoc[]>('/api/ai/search', { params })
  },
  /** 计划只存在服务端，确认时只回传 token；重复调用不会重复创建 */
  confirmAction(token: string) {
    return request.post<ConfirmedAction>(`/api/ai/actions/${token}/confirm`)
  },
}
