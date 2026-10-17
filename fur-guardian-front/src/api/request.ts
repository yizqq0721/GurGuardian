import axios, { AxiosError, type AxiosRequestConfig } from 'axios'
import { ElMessage } from 'element-plus'
import type { Result } from '@/types'

const request = axios.create({
  baseURL: '/',
  timeout: 30000,
})

request.interceptors.request.use((config) => {
  const token = localStorage.getItem('fg_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  (response) => {
    // SSE / 流式响应直接放行
    if (response.config.responseType === 'text' || response.config.responseType === 'stream') {
      return response
    }
    const res = response.data as Result
    if (res && typeof res.code === 'number') {
      if (res.code === 200) {
        return res.data as never
      }
      if (res.code === 401) {
        handleUnauthorized()
        return Promise.reject(new Error(res.message || '未登录'))
      }
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message))
    }
    return response.data
  },
  (error: AxiosError<Result>) => {
    const status = error.response?.status
    if (status === 401) {
      handleUnauthorized()
    } else {
      const msg = error.response?.data?.message || (status === 500 ? '服务繁忙，请稍后再试' : '网络异常，请稍后再试')
      ElMessage.error(msg)
    }
    return Promise.reject(error)
  },
)

function handleUnauthorized() {
  localStorage.removeItem('fg_token')
  localStorage.removeItem('fg_user')
  if (window.location.pathname !== '/auth') {
    ElMessage.warning('登录已过期，请重新登录')
    window.location.href = '/auth'
  }
}

export default request as {
  get<T = unknown>(url: string, config?: AxiosRequestConfig): Promise<T>
  post<T = unknown>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T>
  put<T = unknown>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T>
  delete<T = unknown>(url: string, config?: AxiosRequestConfig): Promise<T>
}
