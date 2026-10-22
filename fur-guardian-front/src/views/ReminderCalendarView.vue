<template>
  <div class="fg-page">
    <PageHeader
      title="待办日历"
      breadcrumb="提醒管理 · 日历"
      description="按月查看疫苗、驱虫这类按日期提醒的事项，提前安排好护理。"
      :back="{ to: '/reminders', label: '提醒管理' }"
    />

    <EmptyState
      v-if="!petStore.pets.length"
      variant="pets"
      description="请先创建宠物档案，再安排护理日历"
    >
      <el-button type="primary" @click="router.push('/onboarding')">去创建</el-button>
    </EmptyState>

    <template v-else>
      <section class="toolbar">
        <span class="fg-label">查看宠物</span>
        <el-radio-group v-model="filterPetId" size="small" @change="fetchReminders">
          <el-radio-button :value="undefined">全部</el-radio-button>
          <el-radio-button v-for="p in petStore.pets" :key="p.id" :value="p.id">{{ p.name }}</el-radio-button>
        </el-radio-group>
      </section>

      <p v-if="loadError" class="fg-callout fg-callout--danger">
        日历加载失败，请检查网络后重试。
        <button class="link-btn" type="button" @click="fetchReminders">重新加载</button>
      </p>

      <div v-else v-loading="loading">
        <ReminderCalendar :reminders="reminders" :pet-names="petNames" />
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { reminderApi } from '@/api/reminder'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import ReminderCalendar from '@/components/ReminderCalendar.vue'
import { usePetStore } from '@/stores/pet'
import type { Reminder } from '@/types'

const route = useRoute()
const router = useRouter()
const petStore = usePetStore()

const reminders = ref<Reminder[]>([])
const loading = ref(false)
const loadError = ref(false)

const petFromQuery = Number(route.query.pet)
const filterPetId = ref<number | undefined>(
  Number.isInteger(petFromQuery) && petFromQuery > 0 ? petFromQuery : undefined,
)

const petNames = computed(() => {
  const map: Record<number, string> = {}
  petStore.pets.forEach((p) => {
    map[p.id] = p.name
  })
  return map
})

onMounted(async () => {
  await petStore.fetchPets()
  await fetchReminders()
})

async function fetchReminders() {
  loading.value = true
  loadError.value = false
  try {
    reminders.value = await reminderApi.list(filterPetId.value)
  } catch {
    loadError.value = true
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.toolbar {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  flex-wrap: wrap;
  padding: var(--fg-s3) 0 var(--fg-s4);
  margin-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.link-btn {
  border: none;
  background: none;
  padding: 0;
  margin-left: var(--fg-s2);
  font: inherit;
  color: var(--fg-danger);
  text-decoration: underline;
  cursor: pointer;
}

@media (max-width: 767.98px) {
  .toolbar {
    gap: var(--fg-s2);
    padding: var(--fg-s3) 0;
    margin-bottom: var(--fg-s4);
  }

  .toolbar :deep(.el-radio-group) {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    gap: var(--fg-s1);
  }

  .toolbar :deep(.el-radio-button) {
    flex: 1 1 auto;
  }

  .toolbar :deep(.el-radio-button__inner) {
    width: 100%;
    padding: 0 var(--fg-s3);
  }
}
</style>
