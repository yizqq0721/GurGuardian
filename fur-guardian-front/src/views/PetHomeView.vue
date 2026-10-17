<template>
  <div class="fg-page" v-loading="loading">
    <template v-if="pet">
      <div class="home-head fg-card">
        <div class="head-left">
          <span class="pet-emoji">{{ pet.species === 'dog' ? '🐶' : '🐱' }}</span>
          <div>
            <h2 style="margin: 0">{{ pet.name }}</h2>
            <span class="fg-muted">{{ pet.breed || '品种未填写' }}</span>
          </div>
        </div>
        <div class="head-actions">
          <el-button @click="router.push(`/pets/${pet.id}/profile`)">档案</el-button>
          <el-button type="primary" @click="router.push(`/pets/${pet.id}/nutrition`)">营养方案</el-button>
        </div>
      </div>

      <div class="home-grid">
        <!-- 今日任务 -->
        <div class="fg-card">
          <h3 class="fg-section-title">📋 今日任务</h3>
          <el-empty v-if="todayReminders.length === 0" description="今天没有待办提醒" :image-size="60">
            <el-button size="small" @click="router.push('/reminders')">去设置提醒</el-button>
          </el-empty>
          <div v-for="r in todayReminders" :key="r.id" class="task-row">
            <el-checkbox
              :model-value="checkedIds.has(r.id)"
              :disabled="checkedIds.has(r.id)"
              @change="checkin(r)"
            >
              <span :class="{ done: checkedIds.has(r.id) }">{{ r.title }}</span>
            </el-checkbox>
            <span class="fg-muted">{{ r.remindTime || `饭后 ${r.relativeMin} 分钟` }}</span>
          </div>
        </div>

        <!-- 今日 Tip -->
        <div class="fg-card">
          <h3 class="fg-section-title">💡 今日 Tip</h3>
          <TipCard v-if="pet" :pet-id="pet.id" />
        </div>

        <!-- 体重速览 -->
        <div class="fg-card">
          <h3 class="fg-section-title">⚖️ 体重速览</h3>
          <div v-if="latestWeight" class="weight-now">
            <span class="weight-num">{{ latestWeight.weightKg }}</span>
            <span class="fg-muted">kg · 记录于 {{ latestWeight.recordedAt }}</span>
          </div>
          <WeightChart v-if="weightLogs.length > 1" :logs="weightLogs" />
          <p v-else class="fg-muted">再记录几次体重即可看到趋势曲线</p>
          <el-button size="small" type="primary" plain @click="weightDialog = true">记录体重</el-button>
        </div>
      </div>
    </template>

    <el-dialog v-model="weightDialog" title="记录体重" width="420px">
      <el-form label-position="top">
        <el-form-item label="体重 (kg)">
          <el-input-number v-model="weightForm.weightKg" :min="0.5" :max="80" :step="0.1" :precision="1" />
        </el-form-item>
        <el-form-item label="体况评分 BCS">
          <BcsPicker v-model="weightForm.bcs" />
        </el-form-item>
        <el-form-item label="记录日期">
          <el-date-picker
            v-model="weightForm.recordedAt"
            type="date"
            value-format="YYYY-MM-DD"
            :disabled-date="(d: Date) => d.getTime() > Date.now()"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="weightDialog = false">取消</el-button>
        <el-button type="primary" :loading="savingWeight" @click="saveWeight">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { petApi } from '@/api/pet'
import { reminderApi } from '@/api/reminder'
import TipCard from '@/components/TipCard.vue'
import BcsPicker from '@/components/BcsPicker.vue'
import WeightChart from '@/components/WeightChart.vue'
import type { Pet, Reminder, WeightLog } from '@/types'

const route = useRoute()
const router = useRouter()
const petId = Number(route.params.id)

const loading = ref(false)
const pet = ref<Pet | null>(null)
const reminders = ref<Reminder[]>([])
const checkedIds = ref(new Set<number>())
const weightLogs = ref<WeightLog[]>([])

const weightDialog = ref(false)
const savingWeight = ref(false)
const weightForm = reactive({
  weightKg: undefined as number | undefined,
  bcs: 5,
  recordedAt: dayjs().format('YYYY-MM-DD'),
})

const todayReminders = computed(() => reminders.value.slice(0, 6))
const latestWeight = computed(() => weightLogs.value[weightLogs.value.length - 1])

onMounted(async () => {
  loading.value = true
  try {
    const [p, r, w, logs] = await Promise.all([
      petApi.detail(petId),
      reminderApi.list(petId).catch(() => [] as Reminder[]),
      petApi.weightHistory(petId).catch(() => [] as WeightLog[]),
      reminderApi
        .logs({ petId, startDate: dayjs().format('YYYY-MM-DD'), endDate: dayjs().format('YYYY-MM-DD') })
        .catch(() => []),
    ])
    pet.value = p
    reminders.value = r
    weightLogs.value = w
    logs.forEach((l) => checkedIds.value.add(l.reminderId))
    weightForm.weightKg = latestWeight.value?.weightKg
    weightForm.bcs = latestWeight.value?.bcs ?? p.bcs ?? 5
  } finally {
    loading.value = false
  }
})

async function checkin(r: Reminder) {
  await reminderApi.checkin(r.id, { doneDate: dayjs().format('YYYY-MM-DD') })
  checkedIds.value.add(r.id)
  ElMessage.success(`已完成「${r.title}」`)
}

async function saveWeight() {
  if (!weightForm.weightKg) {
    ElMessage.warning('请填写体重')
    return
  }
  savingWeight.value = true
  try {
    await petApi.addWeight(petId, {
      weightKg: weightForm.weightKg,
      bcs: weightForm.bcs,
      recordedAt: weightForm.recordedAt,
    })
    weightLogs.value = await petApi.weightHistory(petId)
    weightDialog.value = false
    ElMessage.success('体重已记录')
  } finally {
    savingWeight.value = false
  }
}
</script>

<style scoped>
.home-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.head-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.pet-emoji {
  font-size: 40px;
}

.home-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.home-grid > :last-child {
  grid-column: 1 / -1;
}

.task-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid var(--fg-border);
}

.task-row:last-child {
  border-bottom: none;
}

.task-row .done {
  text-decoration: line-through;
  color: var(--fg-ink-light);
}

.weight-now {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-bottom: 12px;
}

.weight-num {
  font-size: 32px;
  font-weight: 700;
  color: var(--fg-primary-deep);
}
</style>
