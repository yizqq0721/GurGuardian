<template>
  <div class="auth-page">
    <div class="auth-inner">
      <!-- 左：表单 -->
      <section class="form-col">
        <router-link to="/" class="brand">
          <PawPrint :size="20" class="brand-icon" />
          <span>FurGuardian</span>
        </router-link>

        <h1 class="fg-h1 form-title">{{ mode === 'login' ? '登录' : '注册' }}</h1>
        <p class="form-sub">
          {{
            mode === 'login'
              ? '进入你的宠物营养工作台，继续上次的方案。'
              : '创建一个账号，4 步生成个体化喂食方案。'
          }}
        </p>

        <el-form
          v-show="mode === 'login'"
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          label-position="top"
          class="auth-form"
        >
          <el-form-item label="账号" prop="username">
            <el-input v-model="loginForm.username" size="large" placeholder="请输入账号" autocomplete="username" />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              size="large"
              show-password
              placeholder="请输入密码"
              autocomplete="current-password"
              @keyup.enter="handleLogin"
            />
          </el-form-item>
          <p class="demo-hint fg-mono">演示账号 demo · 密码 demo123</p>
          <el-button type="primary" size="large" class="full-btn" :loading="loading" @click="handleLogin">
            登录
          </el-button>
        </el-form>

        <el-form
          v-show="mode === 'register'"
          ref="regFormRef"
          :model="regForm"
          :rules="regRules"
          label-position="top"
          class="auth-form"
        >
          <el-form-item label="账号" prop="username">
            <el-input v-model="regForm.username" size="large" placeholder="3-50 个字符" autocomplete="username" />
          </el-form-item>
          <el-form-item label="昵称" prop="nickname">
            <el-input v-model="regForm.nickname" size="large" placeholder="选填" />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="regForm.password"
              type="password"
              size="large"
              show-password
              placeholder="6-50 个字符"
              autocomplete="new-password"
            />
          </el-form-item>
          <el-button type="primary" size="large" class="full-btn" :loading="loading" @click="handleRegister">
            注册并登录
          </el-button>
        </el-form>

        <p class="toggle-line">
          <span class="fg-muted">{{ mode === 'login' ? '还没有账号？' : '已有账号？' }}</span>
          <button type="button" class="toggle-btn" @click="toggleMode">
            {{ mode === 'login' ? '注册' : '登录' }}
          </button>
        </p>
      </section>

      <!-- 右：产品预览片段 -->
      <aside class="preview-col" aria-label="营养方案示例">
        <div class="preview-panel">
          <p class="fg-label preview-kicker">方案预览 · 示例数据</p>
          <p class="preview-meta fg-mono">玩具贵宾 · 5.1 kg · BCS 5/9 · 已绝育</p>

          <div class="preview-metrics">
            <StatTile label="RER 静息能量需求" value="234" unit="kcal/日" caption="70 × 5.1^0.75" />
            <StatTile label="MER 每日维持能量" value="337" unit="kcal/日" caption="× 1.44 系数" />
            <StatTile label="每日主粮" value="79" unit="g/日" caption="≈ 39 g/餐 × 2 餐" />
          </div>

          <div class="preview-foot">
            <SourceChip label="GB/T 31216-2014" />
            <span class="preview-note">逐项判定该粮是否达标</span>
          </div>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { PawPrint } from 'lucide-vue-next'
import { authApi } from '@/api/auth'
import { useUserStore } from '@/stores/user'
import SourceChip from '@/components/SourceChip.vue'
import StatTile from '@/components/StatTile.vue'

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

function toggleMode() {
  mode.value = mode.value === 'login' ? 'register' : 'login'
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
  background: var(--fg-paper);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--fg-s8) var(--fg-s5);
}

.auth-inner {
  width: 100%;
  max-width: var(--fg-content-w);
  display: grid;
  grid-template-columns: 480px minmax(0, 1fr);
  gap: var(--fg-s8);
  align-items: center;
}

/* ---------- 表单列 ---------- */
.form-col {
  width: 100%;
  max-width: 480px;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  font-family: var(--fg-font-serif);
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.01em;
  color: var(--fg-ink);
}

.brand:hover {
  color: var(--fg-ink);
}

.brand-icon {
  color: var(--fg-accent);
}

.form-title {
  margin: var(--fg-s7) 0 var(--fg-s2);
  font-size: 32px;
}

.form-sub {
  margin: 0 0 var(--fg-s6);
  font-size: 13px;
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.auth-form :deep(.el-form-item) {
  margin-bottom: var(--fg-s5);
}

.auth-form :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
  font-weight: 500;
  padding-bottom: var(--fg-s1);
  line-height: 1.6;
}

/* 字段 40px 高、发丝边框、8px 圆角（focus 环由 tokens.css 提供） */
.auth-form :deep(.el-input__wrapper) {
  height: 40px;
  padding: 0 var(--fg-s3);
}

.auth-form :deep(.el-form-item__error) {
  font-size: var(--fg-text-label);
  color: var(--fg-danger);
  padding-top: var(--fg-s1);
}

.demo-hint {
  margin: var(--fg-s2) 0 var(--fg-s4);
}

.full-btn {
  width: 100%;
  height: 40px;
  margin-top: var(--fg-s1);
}

.toggle-line {
  margin: var(--fg-s5) 0 0;
  font-size: var(--fg-text-body);
  display: flex;
  align-items: center;
  gap: var(--fg-s1);
}

.toggle-btn {
  appearance: none;
  border: none;
  background: none;
  padding: 0;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-body);
  font-weight: 500;
  color: var(--fg-accent);
  transition: color var(--fg-motion);
}

.toggle-btn:hover {
  color: var(--fg-accent-hover);
  text-decoration: underline;
}

/* ---------- 预览列 ---------- */
.preview-panel {
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  padding: var(--fg-s6);
  max-width: 420px;
  margin-left: auto;
}

.preview-kicker {
  margin: 0;
}

.preview-meta {
  margin: var(--fg-s2) 0 var(--fg-s5);
}

.preview-metrics > * + * {
  margin-top: var(--fg-s4);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.preview-panel :deep(.fg-value) {
  font-size: 32px;
}

.preview-foot {
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s4);
}

.preview-note {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

@media (max-width: 1024px) {
  .auth-inner {
    grid-template-columns: minmax(0, 1fr);
    gap: var(--fg-s7);
    max-width: 480px;
  }
  .preview-panel {
    margin-left: 0;
    max-width: none;
  }
}

/* ============================================================
   响应式新增：<768px 手机端（桌面端不受影响）
   ============================================================ */
@media (max-width: 767.98px) {
  .auth-page {
    align-items: flex-start;
    padding: 24px var(--fg-s4) 40px;
  }

  .auth-inner {
    gap: var(--fg-s6);
    max-width: none;
  }

  .form-col {
    max-width: none;
  }

  .brand {
    font-size: 17px;
  }

  .form-title {
    margin: var(--fg-s5) 0 var(--fg-s2);
    font-size: 28px;
  }

  .form-sub {
    margin-bottom: var(--fg-s5);
  }

  /* 输入框与主按钮 44px 触摸高度 */
  .auth-form :deep(.el-input__wrapper) {
    height: 44px;
  }

  .auth-form :deep(.el-form-item) {
    margin-bottom: var(--fg-s4);
  }

  .demo-hint {
    font-size: var(--fg-text-label);
    line-height: 1.6;
    overflow-wrap: anywhere;
  }

  .full-btn {
    height: 44px;
  }

  .toggle-line {
    margin-top: var(--fg-s3);
  }

  .toggle-btn {
    min-height: 44px;
    display: inline-flex;
    align-items: center;
    padding: 0 var(--fg-s1);
  }

  /* 预览面板 */
  .preview-panel {
    padding: var(--fg-s4);
  }

  .preview-foot {
    flex-wrap: wrap;
    row-gap: var(--fg-s2);
  }
}
</style>
