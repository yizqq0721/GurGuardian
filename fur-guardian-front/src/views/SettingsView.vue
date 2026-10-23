<template>
  <div class="fg-page">
    <PageHeader
      title="设置"
      description="账号信息与通知授权，仅影响本浏览器的提醒体验。"
      breadcrumb="账号 / 设置"
    />

    <div class="settings">
      <!-- 账号 -->
      <section class="set-section">
        <h2 class="fg-section-title">
          <UserIcon :size="20" class="fg-icon" />
          账号
        </h2>

        <div class="fg-kv">
          <span class="row-label">昵称</span>
          <span class="row-value">{{ userStore.nickname || '未设置' }}</span>
        </div>
        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">当前位置</span>
            <span class="row-desc">顶部天气与遛弯建议按该位置查询</span>
          </span>
          <span class="row-control">
            <span class="row-value">{{ userStore.location || '未定位' }}</span>
            <el-button size="small" @click="router.push('/profile')">定位</el-button>
          </span>
        </div>
        <div class="fg-kv">
          <span class="row-label">用户 ID</span>
          <span class="row-value fg-num">{{ userStore.userInfo?.userId ?? '-' }}</span>
        </div>
        <div class="fg-kv">
          <span class="row-label">宠物数量</span>
          <span class="row-value">
            <span class="fg-num">{{ petStore.pets.length }}</span>
            <span class="fg-unit">只</span>
          </span>
        </div>
      </section>

      <!-- 通知 -->
      <section class="set-section">
        <h2 class="fg-section-title">
          <Bell :size="20" class="fg-icon" />
          通知
        </h2>

        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">浏览器通知</span>
            <span class="row-desc">授权后，到点的提醒可通过浏览器通知推送</span>
          </span>
          <span class="row-control">
            <SeverityDot :level="notificationGranted ? 'success' : 'info'" />
            <el-button
              size="small"
              :type="notificationGranted ? 'default' : 'primary'"
              :disabled="notificationGranted"
              @click="requestNotification"
            >
              {{ notificationGranted ? '已授权' : '开启通知' }}
            </el-button>
          </span>
        </div>

        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">站内提醒</span>
            <span class="row-desc">打开页面时，到点的待办会在右下角弹出通知</span>
          </span>
          <span class="row-control">
            <el-switch v-model="inAppNotify" @change="onInAppNotifyChange" />
          </span>
        </div>

        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">测试通知</span>
            <span class="row-desc">确认当前浏览器能否正常收到提醒</span>
          </span>
          <span class="row-control">
            <el-button size="small" @click="sendTest">发送测试</el-button>
          </span>
        </div>

        <h3 class="sub-title">邮件提醒</h3>
        <p class="sub-lead">
          到点后把待办发到邮箱，适合不常打开网页的日子。需要服务端配置 SMTP 后才会真正发信。
        </p>

        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">接收邮箱</span>
            <span class="row-desc">留空保存会清除邮箱并关闭邮件提醒</span>
          </span>
          <span class="row-control email-control">
            <el-input
              v-model="email"
              type="email"
              size="small"
              placeholder="you@example.com"
              class="email-input"
            />
            <el-button size="small" type="primary" :loading="savingMail" @click="saveEmail">
              保存
            </el-button>
          </span>
        </div>

        <div class="fg-kv">
          <span class="row-text">
            <span class="row-label">邮件提醒</span>
            <span class="row-desc">按提醒时间发送，已打卡的待办不会重复发送</span>
          </span>
          <span class="row-control">
            <el-switch
              v-model="emailEnabled"
              :disabled="!email || savingMail"
              @change="toggleEmail"
            />
          </span>
        </div>
      </section>

      <!-- 关于 -->
      <section class="set-section">
        <h2 class="fg-section-title">
          <InfoIcon :size="20" class="fg-icon" />
          关于
        </h2>
        <p class="about-text">
          FurGuardian 是日常营养管理与健康趋势追踪工具，不是兽医诊疗系统。所有营养数值由确定性算法产出，
          AI 生成内容仅供参考，不构成医疗建议。
        </p>
      </section>

      <!-- 退出登录 -->
      <section class="set-section">
        <div class="fg-kv">
          <span class="row-text">
            <span class="row-head">
              <LogOut :size="20" class="fg-icon" />
              <span class="row-label">退出登录</span>
            </span>
            <span class="row-desc">退出后需要重新登录才能查看宠物档案</span>
          </span>
          <span class="row-control">
            <el-button type="danger" plain @click="logout">退出登录</el-button>
          </span>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Bell, Info as InfoIcon, LogOut, User as UserIcon } from 'lucide-vue-next'
import { useUserStore } from '@/stores/user'
import { usePetStore } from '@/stores/pet'
import { userApi } from '@/api/user'
import PageHeader from '@/components/PageHeader.vue'
import SeverityDot from '@/components/SeverityDot.vue'
import {
  isInAppNotifyEnabled,
  sendTestNotification,
  setInAppNotifyEnabled,
} from '@/composables/useReminderNotify'

const router = useRouter()
const userStore = useUserStore()
const petStore = usePetStore()

const notificationGranted = ref(false)
const inAppNotify = ref(isInAppNotifyEnabled())
const email = ref('')
const emailEnabled = ref(false)
const savingMail = ref(false)

onMounted(() => {
  petStore.fetchPets()
  notificationGranted.value = 'Notification' in window && Notification.permission === 'granted'
  void loadMailSettings()
})

function onInAppNotifyChange(value: boolean) {
  setInAppNotifyEnabled(value)
  ElMessage.success(value ? '站内提醒已开启' : '站内提醒已关闭')
}

function sendTest() {
  sendTestNotification()
  ElMessage.success('测试通知已发送')
}

async function loadMailSettings() {
  try {
    const settings = await userApi.mailSettings()
    email.value = settings.email
    emailEnabled.value = settings.enabled
  } catch {
    // 加载失败时保留空设置，用户仍可重新填写保存
  }
}

async function saveEmail() {
  savingMail.value = true
  try {
    const value = email.value.trim()
    const settings = await userApi.updateMailSettings({
      email: value,
      enabled: value ? emailEnabled.value : false,
    })
    email.value = settings.email
    emailEnabled.value = settings.enabled
    ElMessage.success(value ? '邮箱已保存' : '邮箱已清除，邮件提醒已关闭')
  } catch {
    // 错误提示由请求拦截器统一处理
  } finally {
    savingMail.value = false
  }
}

async function toggleEmail(value: boolean) {
  if (value && !email.value.trim()) {
    emailEnabled.value = false
    ElMessage.warning('请先填写邮箱并保存')
    return
  }
  savingMail.value = true
  try {
    const settings = await userApi.updateMailSettings({
      email: email.value.trim(),
      enabled: value,
    })
    emailEnabled.value = settings.enabled
    ElMessage.success(value ? '邮件提醒已开启' : '邮件提醒已关闭')
  } catch {
    emailEnabled.value = !value
  } finally {
    savingMail.value = false
  }
}

async function requestNotification() {
  if (!('Notification' in window)) {
    ElMessage.warning('当前浏览器不支持通知')
    return
  }
  const result = await Notification.requestPermission()
  notificationGranted.value = result === 'granted'
  if (result === 'granted') {
    ElMessage.success('通知已开启')
  } else if (result === 'denied') {
    ElMessage.warning('通知被拒绝，可在浏览器站点设置中重新开启')
  }
}

async function logout() {
  await ElMessageBox.confirm('确定退出登录吗？', '提示', { type: 'warning' })
  await userStore.logout()
  petStore.reset()
  router.push('/auth')
}
</script>

<style scoped>
.settings {
  max-width: 720px;
}

.set-section + .set-section {
  margin-top: var(--fg-s6);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.set-section .fg-section-title svg {
  color: var(--fg-ink-muted);
}

.fg-kv {
  align-items: center;
}

.row-text {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
  min-width: 0;
}

.row-head {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
}

.row-label {
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
}

.row-value {
  display: inline-flex;
  align-items: baseline;
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
}

.row-desc {
  font-size: var(--fg-text-label);
  line-height: 1.6;
  color: var(--fg-ink-muted);
}

.row-control {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s3);
  flex: none;
}

.sub-title {
  margin: var(--fg-s5) 0 var(--fg-s1);
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-lead);
  font-weight: 600;
}

.sub-lead {
  margin: 0 0 var(--fg-s2);
  font-size: var(--fg-text-label);
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.email-control {
  min-width: 0;
}

.email-input {
  width: 220px;
}

.about-text {
  margin: 0;
  max-width: 68ch;
  font-size: var(--fg-text-body);
  line-height: 1.8;
  color: var(--el-text-color-regular);
}

@media (max-width: 640px) {
  .fg-kv {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--fg-s3);
  }
}

/* ===== 响应式新增：移动端（<768px）===== */
@media (max-width: 767.98px) {
  .settings {
    max-width: none;
  }

  .set-section + .set-section {
    margin-top: var(--fg-s5);
    padding-top: var(--fg-s4);
  }

  .row-value {
    flex-wrap: wrap;
    overflow-wrap: anywhere;
  }

  .fg-kv {
    flex-wrap: wrap;
  }

  .row-control {
    width: 100%;
    flex-wrap: wrap;
    justify-content: flex-start;
  }

  .email-control,
  .email-input {
    width: 100%;
  }

  .about-text {
    line-height: 1.75;
  }
}
</style>
