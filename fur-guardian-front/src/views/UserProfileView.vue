<template>
  <div class="fg-page">
    <PageHeader
      title="用户信息"
      description="常用城市决定遛弯提醒里展示的当日天气，改完记得保存。"
      breadcrumb="账号 / 用户信息"
    />

    <div v-loading="loading" class="fg-card profile-card">
      <el-form label-position="top" class="profile-form" @submit.prevent>
        <section class="block">
          <h2 class="fg-section-title">账号</h2>
          <div class="readonly-grid">
            <div class="meta-item">
              <span class="meta-label">登录账号</span>
              <span class="meta-value">{{ form.username || '—' }}</span>
            </div>
            <div class="meta-item">
              <span class="meta-label">用户 ID</span>
              <span class="meta-value fg-num">{{ form.userId ?? '—' }}</span>
            </div>
          </div>
        </section>

        <section class="block">
          <h2 class="fg-section-title">资料</h2>
          <el-form-item label="昵称">
            <el-input
              v-model="form.nickname"
              maxlength="50"
              show-word-limit
              placeholder="例如：豆豆爸"
            />
          </el-form-item>
          <el-form-item label="常用城市">
            <el-input
              v-model="form.location"
              maxlength="64"
              clearable
              placeholder="例如：杭州、北京、上海"
            />
            <p class="field-hint">
              填城市名即可，遛弯提醒的天气会按这里查询；留空则不会显示当日天气。
            </p>
          </el-form-item>
          <p v-if="form.location.trim()" class="city-preview">
            <MapPin :size="15" class="fg-icon" />
            天气将按「{{ form.location.trim() }}」查询
          </p>
        </section>
      </el-form>

      <div class="form-actions">
        <router-link class="profile-back" to="/settings">返回设置</router-link>
        <el-button type="primary" :loading="saving" @click="save">保存修改</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { MapPin } from 'lucide-vue-next'
import PageHeader from '@/components/PageHeader.vue'
import { userApi } from '@/api/user'
import { useUserStore } from '@/stores/user'
import type { UserProfile } from '@/types'

const userStore = useUserStore()

const loading = ref(true)
const saving = ref(false)
const form = reactive({
  userId: undefined as number | undefined,
  username: '',
  nickname: '',
  location: '',
})

onMounted(async () => {
  try {
    fill(await userApi.profile())
  } catch {
    // 拦截器已提示，保留空表单
  } finally {
    loading.value = false
  }
})

function fill(profile: UserProfile) {
  form.userId = profile.userId
  form.username = profile.username
  form.nickname = profile.nickname || ''
  form.location = profile.location || ''
}

async function save() {
  saving.value = true
  try {
    const profile = await userApi.update({
      nickname: form.nickname,
      location: form.location,
    })
    fill(profile)
    userStore.applyProfile(profile)
    ElMessage.success('用户信息已保存')
  } catch {
    // 拦截器已提示
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.profile-card {
  max-width: 720px;
}

.block + .block {
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.readonly-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s4);
}

.meta-item {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
  min-width: 0;
}

.meta-label {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
}

.meta-value {
  font-size: var(--fg-text-lead);
  color: var(--fg-ink);
  overflow-wrap: anywhere;
}

.profile-form :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
  padding-bottom: var(--fg-s2);
}

.profile-form :deep(.el-form-item) {
  margin-bottom: var(--fg-s4);
}

.field-hint {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
  color: var(--fg-ink-muted);
}

.city-preview {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0;
  padding: var(--fg-s2) var(--fg-s3);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
  font-size: var(--fg-text-label);
}

.form-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s3);
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.profile-back {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.profile-back:hover {
  color: var(--fg-ink);
}

@media (max-width: 767.98px) {
  .profile-card {
    max-width: none;
  }

  .readonly-grid {
    grid-template-columns: 1fr;
    gap: var(--fg-s3);
  }
}
</style>
