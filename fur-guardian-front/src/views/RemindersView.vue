<template>
  <div class="fg-page">
    <div class="page-head">
      <h2 class="fg-section-title">提醒管理</h2>
      <el-button type="primary" :disabled="!petStore.currentPet" @click="openCreate">+ 新建提醒</el-button>
    </div>

    <el-empty v-if="!petStore.currentPet" description="请先创建宠物档案">
      <el-button type="primary" @click="router.push('/onboarding')">去创建</el-button>
    </el-empty>

    <template v-else>
      <div class="fg-card" style="margin-bottom: 16px">
        <div class="filter-row">
          <span class="fg-muted">查看宠物：</span>
          <el-radio-group v-model="filterPetId" size="small" @change="onFilterChange">
            <el-radio-button :value="undefined">全部</el-radio-button>
            <el-radio-button v-for="p in petStore.pets" :key="p.id" :value="p.id">{{ p.name }}</el-radio-button>
          </el-radio-group>
          <el-checkbox v-model="onlyToday" size="small" style="margin-left: auto">只看今日待办</el-checkbox>
        </div>
      </div>

      <div class="fg-card">
        <el-table v-loading="loading" :data="filteredReminders">
          <el-table-column label="提醒" min-width="160">
            <template #default="{ row }">
              <span style="font-weight: 600">{{ row.title }}</span>
              <el-tag size="small" effect="plain" style="margin-left: 8px">
                {{ REMINDER_TYPE_LABEL[row.reminderType] || row.reminderType }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="宠物" width="100">
            <template #default="{ row }">{{ petName(row.petId) }}</template>
          </el-table-column>
          <el-table-column label="时间" width="150">
            <template #default="{ row }">
              <span v-if="row.remindTime">{{ row.remindTime }}</span>
              <span v-else-if="row.relativeMin != null">饭后 {{ row.relativeMin }} 分钟</span>
              <span v-else class="fg-muted">未设置</span>
            </template>
          </el-table-column>
          <el-table-column label="重复" width="160">
            <template #default="{ row }">
              {{ REPEAT_RULE_LABEL[row.repeatRule] || '每天' }}
              <span v-if="row.repeatDays" class="fg-muted">（{{ repeatDaysText(row.repeatDays) }}）</span>
            </template>
          </el-table-column>
          <el-table-column label="今日" width="90">
            <template #default="{ row }">
              <el-tag v-if="checkedIds.has(row.id)" type="success" size="small">已完成</el-tag>
              <el-button v-else size="small" type="primary" plain @click="checkin(row)">打卡</el-button>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="130" fixed="right">
            <template #default="{ row }">
              <el-button size="small" text type="primary" @click="openEdit(row)">编辑</el-button>
              <el-button size="small" text type="danger" @click="remove(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="fg-card" style="margin-top: 16px">
        <h3 class="fg-section-title">🔥 近 7 天打卡</h3>
        <div class="streak-row">
          <div v-for="d in weekDays" :key="d.date" class="streak-cell" :class="{ filled: d.count > 0 }">
            <span class="streak-count">{{ d.count || '' }}</span>
            <span class="streak-label">{{ d.label }}</span>
          </div>
        </div>
      </div>
    </template>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑提醒' : '新建提醒'" width="520px">
      <el-form label-position="top">
        <el-form-item label="提醒标题" required>
          <el-input v-model="form.title" placeholder="例如：早餐 / 晚间遛弯" maxlength="30" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="关联宠物" required>
              <el-select v-model="form.petId" style="width: 100%">
                <el-option v-for="p in petStore.pets" :key="p.id" :value="p.id" :label="p.name" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="类型" required>
              <el-select v-model="form.reminderType" style="width: 100%">
                <el-option v-for="o in REMINDER_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="提醒方式">
          <el-radio-group v-model="timeMode">
            <el-radio-button value="fixed">固定时间</el-radio-button>
            <el-radio-button value="relative">相对时间（饭后）</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="timeMode === 'fixed'" label="提醒时间">
          <el-time-picker v-model="form.remindTime" format="HH:mm" value-format="HH:mm" style="width: 160px" />
        </el-form-item>
        <el-form-item v-else label="饭后多少分钟">
          <el-input-number v-model="form.relativeMin" :min="5" :max="240" :step="5" />
          <span class="fg-muted" style="margin-left: 12px">如「饭后 30 分钟」遛狗，防胃扭转</span>
        </el-form-item>

        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="重复规则">
              <el-select v-model="form.repeatRule" style="width: 100%">
                <el-option v-for="o in REPEAT_RULE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col v-if="form.repeatRule === 'WEEKLY'" :span="12">
            <el-form-item label="重复日">
              <el-checkbox-group v-model="weekdayChecks">
                <el-checkbox v-for="(label, i) in ['一','二','三','四','五','六','日']" :key="i" :value="String(i + 1)">
                  {{ label }}
                </el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'
import { reminderApi } from '@/api/reminder'
import { usePetStore } from '@/stores/pet'
import { REMINDER_TYPE_LABEL, REMINDER_TYPE_OPTIONS, REPEAT_RULE_LABEL, REPEAT_RULE_OPTIONS } from '@/utils/constants'
import type { Reminder, ReminderLog, ReminderType, RepeatRule } from '@/types'

const router = useRouter()
const petStore = usePetStore()

const loading = ref(false)
const saving = ref(false)
const reminders = ref<Reminder[]>([])
const logs = ref<ReminderLog[]>([])
const optimisticChecked = ref<Set<number>>(new Set())
const filterPetId = ref<number | undefined>(undefined)
const onlyToday = ref(false)

const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const timeMode = ref<'fixed' | 'relative'>('fixed')
const weekdayChecks = ref<string[]>([])

const form = reactive({
  petId: 0,
  title: '',
  reminderType: 'FEED' as ReminderType,
  remindTime: '08:00',
  relativeMin: 30,
  repeatRule: 'DAILY' as RepeatRule,
})

const checkedIds = computed(() => {
  const today = dayjs().format('YYYY-MM-DD')
  const set = new Set(logs.value.filter((l) => l.doneDate === today).map((l) => l.reminderId))
  optimisticChecked.value.forEach((id) => set.add(id))
  return set
})

const filteredReminders = computed(() => {
  if (!onlyToday.value) return reminders.value
  return reminders.value.filter((r) => !checkedIds.value.has(r.id))
})

const weekDays = computed(() => {
  return Array.from({ length: 7 }, (_, i) => {
    const d = dayjs().subtract(6 - i, 'day')
    const date = d.format('YYYY-MM-DD')
    return {
      date,
      label: i === 6 ? '今天' : d.format('MM-DD'),
      count: logs.value.filter((l) => l.doneDate === date).length,
    }
  })
})

onMounted(async () => {
  await petStore.fetchPets()
  if (petStore.currentPet) form.petId = petStore.currentPet.id
  await Promise.all([fetchReminders(), fetchLogs()])
})

async function fetchReminders() {
  loading.value = true
  try {
    reminders.value = await reminderApi.list(filterPetId.value)
  } finally {
    loading.value = false
  }
}

async function fetchLogs() {
  const petIds = filterPetId.value != null
    ? [filterPetId.value]
    : petStore.pets.map((p) => p.id)
  if (!petIds.length) {
    logs.value = []
    return
  }
  const startDate = dayjs().subtract(6, 'day').format('YYYY-MM-DD')
  const endDate = dayjs().format('YYYY-MM-DD')
  const results = await Promise.all(
    petIds.map((id) => reminderApi.logs({ petId: id, startDate, endDate }).catch(() => [] as ReminderLog[])),
  )
  logs.value = results.flat()
}

function onFilterChange() {
  fetchReminders()
  fetchLogs()
}

function petName(id: number) {
  return petStore.pets.find((p) => p.id === id)?.name ?? `#${id}`
}

function repeatDaysText(days: string) {
  const map: Record<string, string> = { '1': '一', '2': '二', '3': '三', '4': '四', '5': '五', '6': '六', '7': '日' }
  return days
    .split(',')
    .map((d) => map[d.trim()] ?? d)
    .join('、')
}

function openCreate() {
  editingId.value = null
  timeMode.value = 'fixed'
  weekdayChecks.value = []
  Object.assign(form, {
    petId: petStore.currentPet?.id ?? 0,
    title: '',
    reminderType: 'FEED',
    remindTime: '08:00',
    relativeMin: 30,
    repeatRule: 'DAILY',
  })
  dialogVisible.value = true
}

function openEdit(row: Reminder) {
  editingId.value = row.id
  timeMode.value = row.relativeMin != null ? 'relative' : 'fixed'
  weekdayChecks.value = row.repeatDays ? row.repeatDays.split(',') : []
  Object.assign(form, {
    petId: row.petId,
    title: row.title,
    reminderType: row.reminderType,
    remindTime: row.remindTime || '08:00',
    relativeMin: row.relativeMin ?? 30,
    repeatRule: row.repeatRule || 'DAILY',
  })
  dialogVisible.value = true
}

async function save() {
  if (!form.title.trim()) {
    ElMessage.warning('请填写提醒标题')
    return
  }
  saving.value = true
  try {
    const payload = {
      petId: form.petId,
      title: form.title.trim(),
      reminderType: form.reminderType,
      remindTime: timeMode.value === 'fixed' ? form.remindTime : undefined,
      relativeMin: timeMode.value === 'relative' ? form.relativeMin : undefined,
      repeatRule: form.repeatRule,
      repeatDays: form.repeatRule === 'WEEKLY' && weekdayChecks.value.length
        ? weekdayChecks.value.join(',')
        : undefined,
    }
    if (editingId.value) {
      await reminderApi.update(editingId.value, payload)
    } else {
      await reminderApi.create(payload)
    }
    ElMessage.success('已保存')
    dialogVisible.value = false
    fetchReminders()
  } finally {
    saving.value = false
  }
}

async function checkin(row: Reminder) {
  await reminderApi.checkin(row.id, { doneDate: dayjs().format('YYYY-MM-DD') })
  optimisticChecked.value = new Set(optimisticChecked.value).add(row.id)
  ElMessage.success(`已完成「${row.title}」`)
  fetchLogs()
}

async function remove(row: Reminder) {
  await ElMessageBox.confirm(`确定删除提醒「${row.title}」吗？`, '删除确认', { type: 'warning' })
  await reminderApi.remove(row.id)
  ElMessage.success('已删除')
  fetchReminders()
}
</script>

<style scoped>
.page-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.filter-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.streak-row {
  display: flex;
  gap: 8px;
}

.streak-cell {
  flex: 1;
  max-width: 90px;
  border: 1px solid var(--fg-border);
  border-radius: 10px;
  padding: 12px 0;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.streak-cell.filled {
  background: #fdf3e7;
  border-color: var(--fg-primary);
}

.streak-count {
  font-weight: 700;
  font-size: 18px;
  color: var(--fg-primary-deep);
  min-height: 24px;
}

.streak-label {
  font-size: 12px;
  color: var(--fg-ink-light);
}
</style>
