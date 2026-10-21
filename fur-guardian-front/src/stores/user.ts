import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { authApi } from '@/api/auth'
import { userApi } from '@/api/user'
import type { LoginResp, UserProfile } from '@/types'

const TOKEN_KEY = 'fg_token'
const USER_KEY = 'fg_user'

interface StoredUser {
  userId: number
  nickname: string
  location?: string
}

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem(TOKEN_KEY) || '')
  const userInfo = ref<StoredUser | null>(
    JSON.parse(localStorage.getItem(USER_KEY) || 'null'),
  )

  const isLoggedIn = computed(() => !!token.value)
  const nickname = computed(() => userInfo.value?.nickname || '')
  const location = computed(() => userInfo.value?.location || '')

  async function login(username: string, password: string) {
    const res = await authApi.login({ username, password })
    applyLogin(res)
  }

  function applyLogin(res: LoginResp) {
    token.value = res.token
    userInfo.value = { userId: res.userId, nickname: res.nickname }
    localStorage.setItem(TOKEN_KEY, res.token)
    persistUser()
  }

  function applyProfile(profile: UserProfile) {
    userInfo.value = {
      userId: profile.userId,
      nickname: profile.nickname || '',
      location: profile.location || '',
    }
    persistUser()
  }

  /** 刷新资料（昵称、常用城市）；失败时保留本地缓存 */
  async function fetchProfile(silent = false) {
    const profile = await userApi.profile(silent)
    applyProfile(profile)
  }

  function persistUser() {
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

  return {
    token,
    userInfo,
    isLoggedIn,
    nickname,
    location,
    login,
    applyLogin,
    applyProfile,
    fetchProfile,
    logout,
  }
})
