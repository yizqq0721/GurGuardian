<template>
  <div class="fg-page">
    <PageHeader
      title="周度健康报告"
      :breadcrumb="petStore.currentPet ? `${petStore.currentPet.name} · 周报` : '周度健康报告'"
      description="按周汇总体重、体况与规则触发情况，逐周留档可回溯。"
    >
      <template #actions>
        <el-button type="primary" :disabled="!petStore.currentPet" @click="generateDialog = true">
          <Plus :size="20" class="fg-icon btn-icon" />
          生成本周周报
        </el-button>
      </template>
    </PageHeader>

    <!-- 无宠物档案 -->
    <EmptyState
      v-if="!petStore.currentPet"
      variant="pets"
      description="请先创建宠物档案，再生成周报"
    />

    <!-- 无周报 -->
    <EmptyState
      v-else-if="!loading && reports.length === 0"
      description="暂无周报，点击右上角生成"
    />

    <!-- 周报表格 -->
    <section v-else v-loading="loading" class="fg-card table-card">
      <!-- 响应式新增：移动端卡片列表（<768px 显示，替代宽表格） -->
      <div class="report-cards">
        <article
          v-for="row in reports"
          :key="row.id"
          class="report-card"
          role="button"
          tabindex="0"
          @click="openReport(row)"
          @keydown.enter="openReport(row)"
        >
          <header class="report-card-head">
            <div class="report-card-week">
              <span class="week-no fg-num">第 {{ weekNo(row.weekStart) }} 周</span>
              <span class="fg-mono week-range">{{ rangeText(row.weekStart, row.weekEnd) }}</span>
            </div>
            <span class="fg-chip" :class="statusChip(row.status).cls">
              {{ statusChip(row.status).text }}
            </span>
          </header>

          <dl class="report-card-metrics">
            <div class="metric">
              <dt>体重变化</dt>
              <dd class="fg-num" :class="{ 'is-warn': isSignificant(row.weightChangePct) }">
                {{ signedPct(row.weightChangePct) }}
              </dd>
              <span class="fg-mono metric-sub">{{ weightRangeText(row) }}</span>
            </div>
            <div class="metric">
              <dt>BCS 变化</dt>
              <dd class="fg-num">
                {{ dash(row.bcsStart) }} → {{ dash(row.bcsEnd) }}<span class="fg-unit">/9</span>
              </dd>
            </div>
            <div class="metric">
              <dt>触发规则数</dt>
              <dd class="fg-num">{{ ruleCountText(row) }}</dd>
            </div>
            <div class="metric">
              <dt>喂养合规度</dt>
              <dd class="fg-num">{{ complianceText(row.feedingCompliance) }}</dd>
            </div>
          </dl>

          <footer class="report-card-foot">
            <span class="view-link">查看详情</span>
            <ChevronRight :size="16" class="fg-icon" />
          </footer>
        </article>
      </div>

      <el-table
        :data="reports"
        row-key="id"
        class="report-table"
        @row-click="openReport"
      >
        <el-table-column label="周次" min-width="150">
          <template #default="{ row }">
            <div class="week-cell">
              <span class="week-no fg-num">第 {{ weekNo(row.weekStart) }} 周</span>
              <span class="fg-mono week-range">{{ rangeText(row.weekStart, row.weekEnd) }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="体重变化" min-width="150" align="right">
          <template #default="{ row }">
            <span class="fg-num weight-change" :class="{ 'is-warn': isSignificant(row.weightChangePct) }">
              {{ signedPct(row.weightChangePct) }}
            </span>
            <span class="fg-mono weight-range">{{ weightRangeText(row) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="BCS 变化" min-width="110" align="right">
          <template #default="{ row }">
            <span class="fg-num bcs-cell">
              {{ dash(row.bcsStart) }} → {{ dash(row.bcsEnd) }}
              <span class="fg-unit bcs-unit">/9</span>
            </span>
          </template>
        </el-table-column>

        <el-table-column label="触发规则数" min-width="110" align="right">
          <template #default="{ row }">
            <span class="fg-num">{{ ruleCountText(row) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="喂养合规度" min-width="110" align="right">
          <template #default="{ row }">
            <span class="fg-num">{{ complianceText(row.feedingCompliance) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="状态" min-width="100">
          <template #default="{ row }">
            <span class="fg-chip" :class="statusChip(row.status).cls">
              {{ statusChip(row.status).text }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="查看" min-width="72" align="right">
          <template #default="{ row }">
            <el-button text class="view-btn" @click.stop="router.push(`/reports/${row.id}`)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </section>

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
import { ChevronRight, Plus } from 'lucide-vue-next'
import { reportApi } from '@/api/report'
import { usePetStore } from '@/stores/pet'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import type { ReportConclusion, WeeklyReport } from '@/types'

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

function openReport(row: WeeklyReport) {
  router.push(`/reports/${row.id}`)
}

function dash(v?: number) {
  return v == null ? '—' : String(v)
}

/** 周次：由周报真实起始日推当年第几周（不引入 dayjs 插件） */
function weekNo(start?: string) {
  if (!start) return '—'
  const d = dayjs(start)
  if (!d.isValid()) return '—'
  const doy = d.diff(d.startOf('year'), 'day') + 1
  return Math.ceil(doy / 7)
}

function rangeText(start?: string, end?: string) {
  if (!start || !end) return '—'
  return `${dayjs(start).format('MM-DD')} ~ ${dayjs(end).format('MM-DD')}`
}

/** 体重变化：带符号的百分比，量级真正越过既有阈值（|pct| > 3）才用警告色 */
function signedPct(pct?: number) {
  if (pct == null) return '—'
  const sign = pct > 0 ? '+' : pct < 0 ? '−' : ''
  return `${sign}${Math.abs(pct).toFixed(1)}%`
}

function isSignificant(pct?: number) {
  return pct != null && Math.abs(pct) > 3
}

function weightRangeText(r: WeeklyReport) {
  if (r.weightStartKg == null && r.weightEndKg == null) return '—'
  return `${r.weightStartKg ?? '—'} → ${r.weightEndKg ?? '—'} kg`
}

function complianceText(v?: number) {
  return v == null ? '—' : `${(v * 100).toFixed(0)}%`
}

/** 触发规则数：从周报自带的 ruleConclusions 派生，无新接口 */
function ruleCountText(r: WeeklyReport) {
  const n = triggeredCount(r)
  return n == null ? '—' : `${n} 条`
}

function triggeredCount(r: WeeklyReport): number | null {
  if (!r.ruleConclusions) return null
  try {
    const c = JSON.parse(r.ruleConclusions) as ReportConclusion
    if (!Array.isArray(c.rules)) return null
    return c.rules.filter((x) => x.triggered).length
  } catch {
    return null
  }
}

function statusChip(status: string): { text: string; cls: string } {
  switch (status) {
    case 'generated':
      return { text: '已生成', cls: 'fg-chip--ok' }
    case 'polished':
      return { text: '已润色', cls: 'fg-chip--ok' }
    case 'generating':
      return { text: '生成中', cls: '' }
    default:
      return { text: status || '—', cls: '' }
  }
}
</script>

<style scoped>
.btn-icon {
  margin-right: var(--fg-s1);
}

.table-card {
  padding: var(--fg-s2) var(--fg-s5) var(--fg-s4);
}

/* 响应式新增：移动端卡片列表默认隐藏，仅 <768px 显示 */
.report-cards {
  display: none;
}

.report-table {
  --el-table-row-hover-bg-color: var(--fg-accent-soft);
}

.report-table :deep(.el-table__row) {
  cursor: pointer;
}

.week-cell {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
}

.week-no {
  font-weight: 600;
  color: var(--fg-ink);
}

.week-range {
  line-height: 1.3;
}

.weight-change {
  display: block;
  font-weight: 600;
  color: var(--fg-ink);
}

.weight-change.is-warn {
  color: var(--fg-warning);
}

.weight-range {
  display: block;
  line-height: 1.4;
}

.bcs-unit {
  font-size: var(--fg-text-label);
}

.view-btn {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s1);
  color: var(--fg-accent);
}

/* ===== 响应式新增：移动端（<768px）===== */
@media (max-width: 767.98px) {
  .table-card {
    padding: 0;
    background: transparent;
    border: none;
  }

  .table-card :deep(.el-table) {
    display: none;
  }

  .report-cards {
    display: flex;
    flex-direction: column;
    gap: var(--fg-s3);
  }

  .report-card {
    padding: var(--fg-s4);
    background: var(--fg-surface);
    border: var(--fg-line-w) solid var(--fg-line);
    border-radius: var(--fg-radius);
    cursor: pointer;
    transition: border-color var(--fg-motion);
  }

  .report-card:hover,
  .report-card:focus-visible {
    border-color: var(--fg-line-strong);
  }

  .report-card:focus-visible {
    outline: 2px solid var(--fg-accent);
    outline-offset: 2px;
  }

  .report-card-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: var(--fg-s3);
  }

  .report-card-week {
    display: flex;
    flex-direction: column;
    gap: var(--fg-s1);
    min-width: 0;
  }

  .report-card-metrics {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: var(--fg-s3);
    margin: var(--fg-s3) 0 0;
    padding-top: var(--fg-s3);
    border-top: var(--fg-line-w) solid var(--fg-line);
  }

  .metric {
    min-width: 0;
  }

  .metric dt {
    font-size: var(--fg-text-label);
    color: var(--fg-ink-muted);
  }

  .metric dd {
    margin: 2px 0 0;
    font-size: var(--fg-text-lead);
    font-weight: 600;
    color: var(--fg-ink);
    font-variant-numeric: tabular-nums;
    overflow-wrap: anywhere;
  }

  .metric dd.is-warn {
    color: var(--fg-warning);
  }

  .metric-sub {
    display: block;
    margin-top: 2px;
    font-size: 11px;
    line-height: 1.4;
    color: var(--fg-ink-muted);
  }

  .report-card-foot {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: var(--fg-s1);
    margin-top: var(--fg-s3);
    padding-top: var(--fg-s3);
    border-top: var(--fg-line-w) solid var(--fg-line);
    color: var(--fg-accent);
    font-size: var(--fg-text-label);
  }
}
</style>
