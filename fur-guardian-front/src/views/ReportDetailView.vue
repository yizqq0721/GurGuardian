<template>
  <div class="fg-page" v-loading="loading">
    <template v-if="report">
      <article class="letter">
        <!-- 头部：kicker + 衬线 H1 + meta -->
        <header class="letter-head">
          <div class="head-main">
            <p class="kicker">第 {{ weekNo }} 周 · {{ kickerRange }}</p>
            <h1 class="fg-h1 letter-title">{{ petName }}的本周小结</h1>
            <p class="meta">{{ metaLine }}</p>
          </div>
          <el-button type="primary" plain :loading="polishing" class="polish-btn" @click="polish">
            <PenLine :size="20" class="fg-icon btn-icon" />
            {{ report.llmSummary ? '重新润色' : 'AI 润色总结' }}
          </el-button>
        </header>

        <!-- AI 润色总结：正文开场段 -->
        <section class="summary-block">
          <h2 class="fg-label block-label">本周小结</h2>
          <p v-if="llmSummary" class="fg-lead summary-text">{{ llmSummary }}</p>
          <p v-else class="fg-muted">本周报尚未进行 AI 润色，点击上方「AI 润色总结」生成措辞；规则结论不受影响。</p>
        </section>

        <!-- 四项指标：发丝分隔 -->
        <section class="fg-card metrics-card">
          <div class="fg-metric-row report-metrics">
            <StatTile
              label="体重"
              :value="weightValue"
              unit="kg"
              :delta="report.weightChangePct ?? undefined"
              delta-unit="%"
              delta-direction="neutral"
              :caption="weightCaption"
            />
            <StatTile label="BCS" :value="bcsValue" unit="/9" />
            <StatTile label="打卡率" :value="complianceValue" unit="%" caption="喂养合规度" />
            <StatTile label="零食超标" :value="snackValue" unit="次" :caption="snackCaption" />
          </div>
        </section>

        <!-- 体重曲线 -->
        <section class="section-block">
          <h2 class="fg-section-title">
            <Activity :size="20" class="fg-icon" />本周体重
          </h2>
          <div class="fg-card chart-card">
            <WeightChart v-if="weightLogs.length > 1" :logs="weightLogs" :height="220" />
            <p v-else class="fg-muted">本周仅有单点体重记录，暂不绘制曲线。</p>
          </div>
        </section>

        <!-- 触发的规则 -->
        <section class="section-block">
          <h2 class="fg-section-title">
            <ListChecks :size="20" class="fg-icon" />触发的规则
          </h2>

          <el-empty v-if="!conclusion" description="暂无规则结论" :image-size="60" />

          <template v-else>
            <p class="rules-count fg-muted">
              共 {{ conclusion.rules.length }} 项判定，
              <span :class="{ 'is-warn': triggeredRules.length > 0 }">{{ triggeredRules.length }} 项触发</span>
            </p>

            <!-- 已触发：主导 -->
            <ul class="rule-list">
              <li v-for="rule in triggeredRules" :key="rule.ruleId" class="rule-item">
                <SeverityDot :level="rule.severity" class="rule-dot" />
                <div class="rule-body">
                  <p class="rule-name">{{ rule.ruleName }}</p>
                  <p v-if="rule.suggestion" class="rule-suggestion">{{ rule.suggestion }}</p>
                  <p v-if="rule.detail" class="fg-mono rule-detail">{{ rule.detail }}</p>
                </div>
              </li>
            </ul>

            <!-- 未触发：保留原页可见数据，弱化呈现 -->
            <template v-if="otherRules.length">
              <p class="fg-label sub-label">未触发的规则</p>
              <ul class="rule-list rule-list--muted">
                <li v-for="rule in otherRules" :key="rule.ruleId" class="rule-item">
                  <SeverityDot level="info" class="rule-dot" />
                  <div class="rule-body">
                    <p class="rule-name rule-name--muted">{{ rule.ruleName }}</p>
                    <p v-if="rule.detail" class="fg-mono rule-detail">{{ rule.detail }}</p>
                  </div>
                </li>
              </ul>
            </template>

            <!-- 聚合结论：仅当真实越过阈值时才用告警色 -->
            <p
              v-if="conclusion.summary"
              class="aggregate"
              :class="{
                'fg-callout fg-callout--danger': hasDanger,
                'fg-callout': !hasDanger && hasWarn,
              }"
            >
              {{ conclusion.summary }}
            </p>
          </template>
        </section>

        <!-- 披露 + 免责 -->
        <p class="disclosure">以上结论由规则引擎生成，AI 仅负责措辞。</p>
        <DisclaimerBar />
      </article>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { Activity, ListChecks, PenLine } from 'lucide-vue-next'
import { reportApi } from '@/api/report'
import { usePetStore } from '@/stores/pet'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import SeverityDot from '@/components/SeverityDot.vue'
import StatTile from '@/components/StatTile.vue'
import WeightChart from '@/components/WeightChart.vue'
import type { ReportConclusion, WeeklyReport, WeightLog } from '@/types'

const route = useRoute()
const petStore = usePetStore()
const reportId = Number(route.params.id)

const loading = ref(false)
const polishing = ref(false)
const report = ref<WeeklyReport | null>(null)
const conclusion = ref<ReportConclusion | null>(null)
const llmSummary = ref('')

onMounted(async () => {
  loading.value = true
  try {
    await petStore.fetchPets()
    const [r, c] = await Promise.all([
      reportApi.detail(reportId),
      reportApi.conclusions(reportId).catch(() => null),
    ])
    report.value = r
    if (c) {
      conclusion.value = c
    } else if (r.ruleConclusions) {
      // 兜底：解析 detail 里的 JSON 字符串
      try {
        conclusion.value = JSON.parse(r.ruleConclusions)
      } catch {
        conclusion.value = null
      }
    }
    llmSummary.value = r.llmSummary || ''
  } finally {
    loading.value = false
  }
})

async function polish() {
  polishing.value = true
  try {
    await reportApi.polish(reportId)
    llmSummary.value = await reportApi.summary(reportId)
    ElMessage.success('润色完成')
  } catch {
    ElMessage.warning('润色服务暂不可用，规则结论不受影响')
  } finally {
    polishing.value = false
  }
}

const petName = computed(() => petStore.currentPet?.name ?? `宠物 #${report.value?.petId ?? ''}`)

const weekNo = computed(() => {
  const s = report.value?.weekStart
  if (!s) return '—'
  const d = dayjs(s)
  if (!d.isValid()) return '—'
  const doy = d.diff(d.startOf('year'), 'day') + 1
  return Math.ceil(doy / 7)
})

const kickerRange = computed(() => {
  const r = report.value
  if (!r) return ''
  return `${dayjs(r.weekStart).format('M月D日')} – ${dayjs(r.weekEnd).format('M月D日')}`
})

const metaLine = computed(() => {
  const pet = petStore.currentPet
  const bits: string[] = []
  if (pet?.breed) bits.push(pet.breed)
  bits.push(`周期 ${dayjs(report.value!.weekStart).format('YYYY-MM-DD')} 至 ${dayjs(report.value!.weekEnd).format('YYYY-MM-DD')}`)
  if (report.value?.createdAt) bits.push(`生成于 ${dayjs(report.value.createdAt).format('YYYY-MM-DD')}`)
  return bits.filter(Boolean).join(' · ')
})

const weightValue = computed(() => {
  const r = report.value!
  return `${r.weightStartKg ?? '—'} → ${r.weightEndKg ?? '—'}`
})

const weightCaption = computed(() => {
  const r = report.value!
  if (r.weightStartKg == null || r.weightEndKg == null) return '本周体重'
  const d = r.weightEndKg - r.weightStartKg
  const sign = d > 0 ? '+' : d < 0 ? '−' : ''
  return `较上周 ${sign}${Math.abs(d).toFixed(1)} kg`
})

const bcsValue = computed(() => {
  const r = report.value!
  return `${r.bcsStart ?? '—'} → ${r.bcsEnd ?? '—'}`
})

const complianceValue = computed(() => {
  const v = report.value?.feedingCompliance
  return v == null ? '—' : (v * 100).toFixed(0)
})

const snackValue = computed(() => report.value?.snackOverLimit ?? 0)
const snackCaption = computed(() =>
  (report.value?.snackOverLimit ?? 0) > 0 ? '本周超额度次数' : '本周未超零食额度',
)

const weightLogs = computed<WeightLog[]>(() => {
  const r = report.value
  if (!r || r.weightStartKg == null || r.weightEndKg == null) return []
  return [
    { id: 1, petId: r.petId, weightKg: r.weightStartKg, recordedAt: r.weekStart },
    { id: 2, petId: r.petId, weightKg: r.weightEndKg, recordedAt: r.weekEnd },
  ]
})

const triggeredRules = computed(() => (conclusion.value?.rules ?? []).filter((x) => x.triggered))
const otherRules = computed(() => (conclusion.value?.rules ?? []).filter((x) => !x.triggered))
const hasDanger = computed(() => triggeredRules.value.some((x) => x.severity === 'danger'))
const hasWarn = computed(() => triggeredRules.value.some((x) => x.severity === 'warn'))
</script>

<style scoped>
.letter {
  max-width: 800px;
  margin: 0 auto;
}

/* 头部 */
.letter-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: var(--fg-s5);
  padding-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.kicker {
  margin: 0 0 var(--fg-s2);
  font-family: var(--fg-font-mono);
  font-size: var(--fg-text-label);
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.02em;
  color: var(--fg-ink-muted);
}

.letter-title {
  font-size: 36px;
  margin: 0;
}

.meta {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
}

.polish-btn {
  flex: none;
}

.btn-icon {
  margin-right: var(--fg-s1);
}

/* 小结段 */
.summary-block {
  padding: var(--fg-s5) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.block-label {
  margin: 0 0 var(--fg-s3);
}

.summary-text {
  margin: 0;
  line-height: 1.8;
}

/* 指标 */
.metrics-card {
  margin-top: var(--fg-s5);
}

.report-metrics :deep(.fg-value) {
  font-size: 24px;
}

.report-metrics :deep(.fg-unit) {
  font-size: var(--fg-text-label);
}

/* 区块 */
.section-block {
  margin-top: var(--fg-s6);
}

.chart-card {
  padding: var(--fg-s4);
}

/* 规则列表 */
.rules-count {
  margin: 0 0 var(--fg-s4);
  font-size: var(--fg-text-label);
}

.rules-count .is-warn {
  color: var(--fg-warning);
  font-weight: 600;
}

.rule-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.rule-item {
  display: flex;
  gap: var(--fg-s3);
  padding: var(--fg-s4) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.rule-list:last-of-type .rule-item:last-child {
  border-bottom: none;
}

.rule-dot {
  margin-top: 6px;
}

.rule-body {
  min-width: 0;
}

.rule-name {
  margin: 0;
  font-weight: 600;
  font-size: var(--fg-text-body);
}

.rule-name--muted {
  color: var(--fg-ink-muted);
  font-weight: 500;
}

.rule-suggestion {
  margin: var(--fg-s1) 0 0;
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: #3a3e44;
}

.rule-detail {
  margin: var(--fg-s2) 0 0;
  line-height: 1.6;
}

.sub-label {
  margin: var(--fg-s5) 0 var(--fg-s2);
}

.rule-list--muted .rule-item {
  padding: var(--fg-s3) 0;
}

.aggregate {
  margin: var(--fg-s5) 0 0;
  color: var(--fg-ink);
  font-size: var(--fg-text-body);
  line-height: 1.7;
}

.aggregate:not(.fg-callout) {
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

/* 披露 */
.disclosure {
  margin: var(--fg-s6) 0 var(--fg-s2);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  line-height: 1.6;
}

@media (max-width: 768px) {
  .letter-head {
    flex-direction: column;
    align-items: flex-start;
  }
  .letter-title {
    font-size: 28px;
  }
}
</style>
