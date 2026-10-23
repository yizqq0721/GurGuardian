import axios, { AxiosError, type AxiosRequestConfig } from 'axios'
import { ElMessage } from 'element-plus'
import { setFlashMessage } from '@/utils/flash'
import type { Result } from '@/types'

declare module 'axios' {
  export interface AxiosRequestConfig {
    /** 静默请求：失败时不弹全局错误提示（401 仍会跳登录） */
    silent?: boolean
  }
}

const AUTH_URLS = ['/api/auth/login', '/api/auth/register']

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
        const message = res.message || '账号或密码错误'
        if (isAuthRequest(response.config)) {
          showMessage(message)
        } else {
          handleUnauthorized(res.message)
        }
        return Promise.reject(new Error(message))
      }
      if (!response.config.silent) {
        ElMessage.error(res.message || '请求失败')
      }
      return Promise.reject(new Error(res.message))
    }
    return response.data
  },
  (error: AxiosError<Result>) => {
    const status = error.response?.status
    const serverMessage = error.response?.data?.message
    if (status === 401) {
      if (isAuthRequest(error.config)) {
        showMessage(serverMessage || '账号或密码错误')
      } else {
        handleUnauthorized(serverMessage)
      }
    } else if (!error.config?.silent) {
      const msg = serverMessage || (status === 500 ? '服务繁忙，请稍后再试' : '网络异常，请稍后再试')
      ElMessage.error(msg)
    }
    return Promise.reject(error)
  },
)

function isAuthRequest(config?: { url?: string }) {
  const url = config?.url || ''
  return AUTH_URLS.some((path) => url.includes(path))
}

function showMessage(message: string, type: 'warning' | 'error' = 'error') {
  ElMessage({ message, type, grouping: true })
}

let redirectingToAuth = false

function handleUnauthorized(message?: string) {
  localStorage.removeItem('fg_token')
  localStorage.removeItem('fg_user')

  const msg = message || '登录已过期，请重新登录'
  if (window.location.pathname === '/auth') {
    showMessage(msg)
    return
  }
  if (redirectingToAuth) return
  redirectingToAuth = true
  setFlashMessage(msg)
  const redirect = `${window.location.pathname}${window.location.search}`
  window.location.href = `/auth?redirect=${encodeURIComponent(redirect)}`
}

export default request as {
  get<T = unknown>(url: string, config?: AxiosRequestConfig): Promise<T>
  post<T = unknown>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T>
  put<T = unknown>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T>
  delete<T = unknown>(url: string, config?: AxiosRequestConfig): Promise<T>
}
