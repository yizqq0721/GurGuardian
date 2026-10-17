<template>
  <div class="fg-page">
    <div class="page-head">
      <h2 class="fg-section-title">周度健康报告</h2>
      <el-button type="primary" :disabled="!petStore.currentPet" @click="generateDialog = true">
        生成本周周报
      </el-button>
    </div>

    <el-empty v-if="!petStore.currentPet" description="请先创建宠物档案" />
    <el-empty v-else-if="!loading && reports.length === 0" description="暂无周报，点击右上角生成" />

    <div v-loading="loading" class="report-list">
      <div
        v-for="r in reports"
        :key="r.id"
        class="report-item fg-card"
        @click="router.push(`/reports/${r.id}`)"
      >
        <div class="report-week">
          <div class="week-range">{{ r.weekStart }} ~ {{ r.weekEnd }}</div>
          <el-tag size="small" :type="r.status === 'generated' ? 'success' : 'info'" effect="plain">
            {{ r.status === 'generated' ? '已生成' : r.status }}
          </el-tag>
        </div>
        <div class="report-metrics">
          <div class="metric">
            <span class="fg-muted">体重</span>
            <span>{{ r.weightStartKg ?? '-' }} → {{ r.weightEndKg ?? '-' }} kg</span>
          </div>
          <div class="metric">
            <span class="fg-muted">周环比</span>
            <span :class="changeClass(r.weightChangePct)">{{ changeText(r.weightChangePct) }}</span>
          </div>
          <div class="metric">
            <span class="fg-muted">BCS</span>
            <span>{{ r.bcsStart ?? '-' }} → {{ r.bcsEnd ?? '-' }}</span>
          </div>
          <div class="metric">
            <span class="fg-muted">喂养合规度</span>
            <span>{{ r.feedingCompliance != null ? (r.feedingCompliance * 100).toFixed(0) + '%' : '-' }}</span>
          </div>
        </div>
      </div>
    </div>

    <el-dialog v-model="generateDialog" title="生成周报" width="420px">
      <el-form label-position="top">
        <el-form-item label="选择周起始日（周一）">
          <el-date-picker
            v-model="weekStart"
            type="date"
            value-format="YYYY-MM-DD"
            :disabled-date="(d: Date) => d.getTime() > Date.now() || d.getDay() !== 1"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="generateDialog = false">取消</el-button>
        <el-button type="primary" :loading="generating" @click="generate">生成</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { reportApi } from '@/api/report'
import { usePetStore } from '@/stores/pet'
import type { WeeklyReport } from '@/types'

const router = useRouter()
const petStore = usePetStore()

const loading = ref(false)
const reports = ref<WeeklyReport[]>([])
const generateDialog = ref(false)
const generating = ref(false)
const weekStart = ref(dayjs().startOf('week').add(1, 'day').format('YYYY-MM-DD'))

const petId = computed(() => petStore.currentPet?.id)

onMounted(async () => {
  await petStore.fetchPets()
  fetchReports()
})

watch(petId, fetchReports)

async function fetchReports() {
  if (!petId.value) return
  loading.value = true
  try {
    reports.value = await reportApi.list(petId.value)
  } catch {
    reports.value = []
  } finally {
    loading.value = false
  }
}

async function generate() {
  if (!petId.value || !weekStart.value) return
  generating.value = true
  try {
    const report = await reportApi.generate(petId.value, weekStart.value)
    ElMessage.success('周报已生成')
    generateDialog.value = false
    router.push(`/reports/${report.id}`)
  } finally {
    generating.value = false
  }
}

function changeText(pct?: number) {
  if (pct == null) return '-'
  return `${pct > 0 ? '+' : ''}${pct.toFixed(1)}%`
}

function changeClass(pct?: number) {
  if (pct == null) return ''
  if (pct > 3) return 'trend-up'
  if (pct < -3) return 'trend-down'
  return ''
}
</script>

<style scoped>
.page-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.report-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-height: 100px;
}

.report-item {
  cursor: pointer;
  transition: box-shadow 0.15s;
}

.report-item:hover {
  box-shadow: 0 4px 16px rgba(232, 133, 61, 0.15);
}

.report-week {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
}

.week-range {
  font-weight: 600;
  font-size: 16px;
}

.report-metrics {
  display: flex;
  gap: 32px;
  flex-wrap: wrap;
}

.metric {
  display: flex;
  flex-direction: column;
  gap: 2px;
  font-size: 14px;
}

.trend-up {
  color: #f56c6c;
  font-weight: 600;
}

.trend-down {
  color: #5b9bd5;
  font-weight: 600;
}
</style>
