<template>
  <div v-loading="loading" class="fg-page">
    <template v-if="pet">
      <router-link to="/pets" class="fg-back">
        <ArrowLeft :size="16" class="fg-icon" />
        <span>返回我的宠物</span>
      </router-link>

      <!-- 宠物抬头：发丝下边框分组，不做卡片 -->
      <header class="pet-head">
        <span class="avatar">
          <img v-if="avatarUrl" :src="avatarUrl" :alt="`${pet.name} 头像`" />
          <span v-else class="avatar-initial">{{ pet.name.slice(0, 1) }}</span>
        </span>

        <div class="head-text">
          <h1 class="fg-h2 pet-name">{{ pet.name }}</h1>
          <p class="head-meta fg-muted">{{ petMeta }}</p>
        </div>

        <span class="fg-chip bcs-badge" :class="bcsChipClass(pet.bcs)">
          <template v-if="pet.bcs">BCS {{ pet.bcs }} <span class="chip-of">/ 9</span> · {{ bcsGroup(pet.bcs).label }}</template>
          <template v-else>BCS 未评估</template>
        </span>

        <div class="head-actions">
          <el-button @click="router.push(`/pets/${pet.id}/profile`)">编辑档案</el-button>
          <el-button type="primary" @click="router.push(`/pets/${pet.id}/nutrition`)">营养方案</el-button>
        </div>
      </header>

      <div class="fg-split">
        <div class="main-col">
          <!-- 今日任务 -->
          <section class="fg-card">
            <h2 class="fg-section-title">
              <ListChecks :size="20" class="fg-icon" />
              今日任务
            </h2>

            <EmptyState v-if="todayReminders.length === 0" variant="default" description="今天没有待办提醒">
              <el-button class="to-reminders" @click="router.push('/reminders')">去设置提醒</el-button>
            </EmptyState>

            <ul v-else class="task-list">
              <li
                v-for="r in todayReminders"
                :key="r.id"
                class="task-row"
                :class="{ 'is-done': checkedIds.has(r.id) }"
              >
                <el-checkbox
                  :model-value="checkedIds.has(r.id)"
                  :disabled="checkedIds.has(r.id)"
                  @change="checkin(r)"
                >
                  <span class="task-title">{{ r.title }}</span>
                </el-checkbox>

                <span class="fg-chip time-chip">
                  <Clock v-if="r.remindTime" :size="12" class="fg-icon" />
                  {{ timeText(r) }}
                </span>
              </li>
            </ul>
          </section>

          <!-- 体重趋势 -->
          <section class="fg-card">
            <h2 class="fg-section-title">
              <Scale :size="20" class="fg-icon" />
              体重趋势
            </h2>

            <div class="weight-head">
              <StatTile
                label="当前体重"
                :value="latestWeight ? latestWeight.weightKg : '—'"
                unit="kg"
                :caption="latestWeight ? `记录于 ${latestWeight.recordedAt}` : '尚无体重记录'"
              />
              <el-button class="record-btn" @click="weightDialog = true">
                <Plus :size="20" class="fg-icon" />
                记录体重
              </el-button>
            </div>

            <div class="divider" />

            <WeightChart v-if="weightLogs.length > 1" :logs="weightLogs" />
            <p v-else class="fg-muted chart-empty">再记录几次体重即可看到趋势曲线</p>
          </section>
        </div>

        <!-- 今日 Tip -->
        <aside class="aside-col">
          <section class="fg-card">
            <h2 class="fg-section-title">
              <Lightbulb :size="20" class="fg-icon" />
              今日 Tip
            </h2>
            <TipCard :pet-id="pet.id" />
          </section>
        </aside>
      </div>
    </template>

    <el-dialog v-model="weightDialog" title="记录体重" width="560px">
      <el-form label-position="top">
        <el-form-item label="体重 (kg)">
          <el-input-number v-model="weightForm.weightKg" :min="0.5" :max="80" :step="0.1" :precision="1" />
        </el-form-item>
        <el-form-item label="体况评分 BCS">
          <BcsScale v-model="weightForm.bcs" />
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
import { ArrowLeft, Clock, Lightbulb, ListChecks, Plus, Scale } from 'lucide-vue-next'
import { petApi } from '@/api/pet'
import { reminderApi } from '@/api/reminder'
import BcsScale from '@/components/BcsScale.vue'
import EmptyState from '@/components/EmptyState.vue'
import StatTile from '@/components/StatTile.vue'
import TipCard from '@/components/TipCard.vue'
import WeightChart from '@/components/WeightChart.vue'
import { ageText } from '@/utils/format'
import { petAvatarUrl } from '@/utils/petAvatar'
import { isReminderDueOn } from '@/utils/reminder'
import { bcsGroup } from '@/utils/constants'
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

const todayReminders = computed(() =>
  reminders.value
    .filter((r) => isReminderDueOn(r, dayjs().format('YYYY-MM-DD')))
    .slice(0, 6),
)
const latestWeight = computed(() => weightLogs.value[weightLogs.value.length - 1])
const avatarUrl = computed(() => petAvatarUrl(pet.value?.avatar))

const petMeta = computed(() => {
  if (!pet.value) return ''
  const bits = [
    pet.value.breed || '品种未填写',
    ageText(pet.value.birthday),
    pet.value.neutered ? '已绝育' : '未绝育',
  ]
  if (latestWeight.value) bits.push(`${latestWeight.value.weightKg} kg`)
  return bits.join(' · ')
})

function timeText(r: Reminder) {
  if (r.remindTime) return r.remindTime.slice(0, 5)
  return r.relativeMin != null ? `饭后 ${r.relativeMin} 分钟` : '全天'
}

function bcsChipClass(bcs?: number) {
  if (!bcs) return ''
  return bcs === 4 || bcs === 5 ? 'fg-chip--ok' : 'fg-chip--warn'
}

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
/* ---------- 宠物抬头 ---------- */
.pet-head {
  display: flex;
  align-items: center;
  gap: var(--fg-s4);
  padding-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  margin-bottom: var(--fg-s6);
}

.avatar {
  width: 56px;
  height: 56px;
  flex: none;
  border-radius: 50%;
  overflow: hidden;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: var(--fg-accent-soft);
  border: var(--fg-line-w) solid var(--fg-line);
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.avatar-initial {
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h3);
  font-weight: 600;
  color: var(--fg-accent);
  line-height: 1;
}

.head-text {
  flex: 1;
  min-width: 0;
}

.pet-name {
  margin: 0;
  font-size: var(--fg-text-h2);
}

.head-meta {
  margin: var(--fg-s1) 0 0;
  font-size: var(--fg-text-body);
}

.bcs-badge {
  height: 24px;
  flex: none;
}

.chip-of {
  opacity: 0.7;
}

.head-actions {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  flex: none;
}

/* ---------- 主栏 ---------- */
.main-col,
.aside-col {
  min-width: 0;
}

.aside-col {
  position: sticky;
  top: calc(var(--fg-topbar-h) + var(--fg-s5));
}

.task-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.task-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s4);
  min-height: 48px;
  padding: var(--fg-s2) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.task-row:last-child {
  border-bottom: none;
}

.task-title {
  font-size: var(--fg-text-body);
  transition: color var(--fg-motion);
}

.time-chip {
  flex: none;
}

/* 完成态：标题删除线并置灰，勾选框保留 accent 作为唯一强调 */
.task-row.is-done .task-title,
.task-row.is-done :deep(.el-checkbox__label) {
  text-decoration: line-through;
  color: var(--fg-ink-muted);
}

.task-row :deep(.el-checkbox__label) {
  font-size: var(--fg-text-body);
  font-weight: 400;
  color: var(--fg-ink);
  padding-left: var(--fg-s2);
}

/* EP 勾选框：方角 2px，禁用但已完成时仍用 accent 而非灰底 */
.task-row :deep(.el-checkbox__inner) {
  border-radius: 2px;
}

.task-row :deep(.el-checkbox__input.is-disabled.is-checked .el-checkbox__inner) {
  background-color: var(--fg-accent);
  border-color: var(--fg-accent);
}

.task-row :deep(.el-checkbox__input.is-disabled.is-checked .el-checkbox__inner::after) {
  border-color: var(--fg-surface);
}

/* ---------- 体重卡 ---------- */
.weight-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: var(--fg-s5);
}

.record-btn {
  flex: none;
}

.divider {
  border-top: var(--fg-line-w) solid var(--fg-line);
  margin: var(--fg-s5) 0;
}

.chart-empty {
  margin: 0;
  font-size: var(--fg-text-label);
}

.to-reminders {
  margin-top: var(--fg-s4);
}

@media (max-width: 1024px) {
  .pet-head {
    flex-wrap: wrap;
  }
  .head-actions {
    margin-left: auto;
  }
}

/* ============================================================
   响应式新增：<768px 手机端（桌面端不受影响）
   ============================================================ */
@media (max-width: 767.98px) {
  .pet-head {
    flex-wrap: wrap;
    align-items: flex-start;
    gap: var(--fg-s3);
    padding-bottom: var(--fg-s4);
    margin-bottom: var(--fg-s5);
  }

  .avatar {
    width: 48px;
    height: 48px;
  }

  .pet-name {
    font-size: 24px;
  }

  .head-meta {
    font-size: 13px;
    line-height: 1.5;
  }

  .bcs-badge {
    height: 22px;
  }

  /* 操作按钮独占一行并等宽 */
  .head-actions {
    width: 100%;
    margin-left: 0;
    gap: var(--fg-s2);
  }

  .head-actions :deep(.el-button) {
    flex: 1;
    min-width: 0;
  }

  .head-actions :deep(.el-button + .el-button) {
    margin-left: 0;
  }

  .task-row {
    min-height: 52px;
    gap: var(--fg-s3);
  }

  .weight-head {
    flex-direction: column;
    align-items: stretch;
    gap: var(--fg-s3);
  }

  .record-btn {
    width: 100%;
  }

  .divider {
    margin: var(--fg-s4) 0;
  }

  /* 单列后取消侧栏吸顶 */
  .aside-col {
    position: static;
  }
}
</style>
