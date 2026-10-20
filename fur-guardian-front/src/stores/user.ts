import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { authApi } from '@/api/auth'
import type { LoginResp } from '@/types'

const TOKEN_KEY = 'fg_token'
const USER_KEY = 'fg_user'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem(TOKEN_KEY) || '')
  const userInfo = ref<{ userId: number; nickname: string } | null>(
    JSON.parse(localStorage.getItem(USER_KEY) || 'null'),
  )

  const isLoggedIn = computed(() => !!token.value)
  const nickname = computed(() => userInfo.value?.nickname || '')

  async function login(username: string, password: string) {
    const res = await authApi.login({ username, password })
    applyLogin(res)
  }

  function applyLogin(res: LoginResp) {
    token.value = res.token
    userInfo.value = { userId: res.userId, nickname: res.nickname }
    localStorage.setItem(TOKEN_KEY, res.token)
    localStorage.setItem(USER_KEY, JSON.stringify(userInfo.value))
  }

  async function logout() {
    try {
      await authApi.logout()
    } finally {
      token.value = ''
      userInfo.value = null
      localStorage.removeItem(TOKEN_KEY)
      localStorage.removeItem(USER_KEY)
    }
  }

  return { token, userInfo, isLoggedIn, nickname, login, applyLogin, logout }
})
