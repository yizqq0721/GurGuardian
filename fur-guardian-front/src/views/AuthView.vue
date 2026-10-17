<template>
  <div class="auth-page">
    <div class="auth-card fg-card">
      <div class="auth-brand">
        <span class="paw">🐾</span>
        <h2>FurGuardian</h2>
        <p class="fg-muted">把「经验喂养」变成「数据喂养」</p>
      </div>

      <el-tabs v-model="mode" stretch>
        <el-tab-pane label="登录" name="login">
          <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" label-position="top">
            <el-form-item label="账号" prop="username">
              <el-input v-model="loginForm.username" placeholder="演示账号：demo" />
            </el-form-item>
            <el-form-item label="密码" prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                show-password
                placeholder="演示密码：demo123"
                @keyup.enter="handleLogin"
              />
            </el-form-item>
            <el-button type="primary" class="full-btn" :loading="loading" @click="handleLogin">
              登录
            </el-button>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="注册" name="register">
          <el-form ref="regFormRef" :model="regForm" :rules="regRules" label-position="top">
            <el-form-item label="账号" prop="username">
              <el-input v-model="regForm.username" placeholder="3-50 个字符" />
            </el-form-item>
            <el-form-item label="昵称" prop="nickname">
              <el-input v-model="regForm.nickname" placeholder="选填" />
            </el-form-item>
            <el-form-item label="密码" prop="password">
              <el-input v-model="regForm.password" type="password" show-password placeholder="6-50 个字符" />
            </el-form-item>
            <el-button type="primary" class="full-btn" :loading="loading" @click="handleRegister">
              注册并登录
            </el-button>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { authApi } from '@/api/auth'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const mode = ref<'login' | 'register'>('login')
const loading = ref(false)

const loginFormRef = ref<FormInstance>()
const loginForm = reactive({ username: '', password: '' })
const loginRules: FormRules = {
  username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

const regFormRef = ref<FormInstance>()
const regForm = reactive({ username: '', password: '', nickname: '' })
const regRules: FormRules = {
  username: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    { min: 3, max: 50, message: '账号长度 3-50 个字符', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 50, message: '密码长度 6-50 个字符', trigger: 'blur' },
  ],
}

function redirectAfterLogin() {
  const redirect = (route.query.redirect as string) || '/pets'
  router.push(redirect)
}

async function handleLogin() {
  await loginFormRef.value?.validate()
  loading.value = true
  try {
    await userStore.login(loginForm.username, loginForm.password)
    ElMessage.success('登录成功')
    redirectAfterLogin()
  } finally {
    loading.value = false
  }
}

async function handleRegister() {
  await regFormRef.value?.validate()
  loading.value = true
  try {
    await authApi.register({
      username: regForm.username,
      password: regForm.password,
      nickname: regForm.nickname || undefined,
    })
    await userStore.login(regForm.username, regForm.password)
    ElMessage.success('注册成功，已自动登录')
    router.push('/onboarding')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(160deg, #fff3e4 0%, #fdf8f3 70%);
  padding: 24px;
}

.auth-card {
  width: 400px;
  padding: 32px 36px;
}

.auth-brand {
  text-align: center;
  margin-bottom: 16px;
}

.auth-brand .paw {
  font-size: 36px;
}

.auth-brand h2 {
  margin: 4px 0;
}

.full-btn {
  width: 100%;
  margin-top: 4px;
}
</style>
