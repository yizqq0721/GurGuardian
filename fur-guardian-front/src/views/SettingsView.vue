<template>
  <div class="fg-page">
    <div class="fg-card settings-card">
      <h2 class="fg-section-title">设置</h2>

      <el-descriptions :column="1" border>
        <el-descriptions-item label="昵称">{{ userStore.nickname || '未设置' }}</el-descriptions-item>
        <el-descriptions-item label="用户 ID">{{ userStore.userInfo?.userId ?? '-' }}</el-descriptions-item>
        <el-descriptions-item label="宠物数量">{{ petStore.pets.length }} 只</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">通知</el-divider>
      <div class="setting-row">
        <div>
          <div>浏览器通知</div>
          <div class="fg-muted">授权后，到点的提醒可通过浏览器通知推送</div>
        </div>
        <el-button size="small" :disabled="notificationGranted" @click="requestNotification">
          {{ notificationGranted ? '已授权' : '开启通知' }}
        </el-button>
      </div>

      <el-divider content-position="left">关于</el-divider>
      <p class="fg-muted about-text">
        FurGuardian 是日常营养管理与健康趋势追踪工具，不是兽医诊疗系统。所有营养数值由确定性算法产出，
        AI 生成内容仅供参考，不构成医疗建议。
      </p>

      <el-divider />
      <el-button type="danger" plain @click="logout">退出登录</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { usePetStore } from '@/stores/pet'

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
.settings-card {
  max-width: 640px;
  margin: 0 auto;
}

.setting-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.about-text {
  line-height: 1.8;
}
</style>
