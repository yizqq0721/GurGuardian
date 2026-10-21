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
            <el-button size="small" :disabled="notificationGranted" @click="requestNotification">
              {{ notificationGranted ? '已授权' : '开启通知' }}
            </el-button>
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
import PageHeader from '@/components/PageHeader.vue'
import SeverityDot from '@/components/SeverityDot.vue'

const router = useRouter()
const userStore = useUserStore()
const petStore = usePetStore()

const notificationGranted = ref(false)

onMounted(() => {
  petStore.fetchPets()
  notificationGranted.value = 'Notification' in window && Notification.permission === 'granted'
})

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

  .about-text {
    line-height: 1.75;
  }
}
</style>
