<template>
  <div class="fg-page" v-loading="loading">
    <template v-if="report">
      <div class="fg-card" style="margin-bottom: 16px">
        <div class="report-head">
          <div>
            <h2 style="margin: 0 0 4px">{{ report.weekStart }} ~ {{ report.weekEnd }} 周报</h2>
            <span class="fg-muted">{{ petStore.currentPet?.name ?? `宠物 #${report.petId}` }}</span>
          </div>
          <el-button type="primary" plain :loading="polishing" @click="polish">
            {{ report.llmSummary ? '重新润色' : 'AI 润色总结' }}
          </el-button>
        </div>

        <div class="metrics-grid">
          <div class="metric-cell">
            <span class="fg-muted">体重变化</span>
            <span class="metric-value">
              {{ report.weightStartKg ?? '-' }} → {{ report.weightEndKg ?? '-' }} kg
              <small v-if="report.weightChangePct != null" :class="report.weightChangePct > 0 ? 'up' : 'down'">
                ({{ report.weightChangePct > 0 ? '+' : '' }}{{ report.weightChangePct.toFixed(1) }}%)
              </small>
            </span>
          </div>
          <div class="metric-cell">
            <span class="fg-muted">BCS 变化</span>
            <span class="metric-value">{{ report.bcsStart ?? '-' }} → {{ report.bcsEnd ?? '-' }}</span>
          </div>
          <div class="metric-cell">
            <span class="fg-muted">喂养合规度</span>
            <span class="metric-value">
              {{ report.feedingCompliance != null ? (report.feedingCompliance * 100).toFixed(0) + '%' : '-' }}
            </span>
          </div>
          <div class="metric-cell">
            <span class="fg-muted">零食超标次数</span>
            <span class="metric-value" :class="{ up: (report.snackOverLimit ?? 0) > 0 }">
              {{ report.snackOverLimit ?? 0 }} 次
            </span>
          </div>
        </div>
      </div>

      <!-- 规则引擎结论 -->
      <div class="fg-card" style="margin-bottom: 16px">
        <h3 class="fg-section-title">📐 规则引擎判定（确定性结论）</h3>
        <el-empty v-if="!conclusion" description="暂无规则结论" :image-size="60" />
        <template v-else>
          <div v-for="rule in conclusion.rules" :key="rule.ruleId" class="rule-item">
            <div class="rule-head">
              <el-tag
                size="small"
                :type="!rule.triggered ? 'info' : rule.severity === 'danger' ? 'danger' : rule.severity === 'warn' ? 'warning' : 'success'"
              >
                {{ rule.triggered ? '已触发' : '未触发' }}
              </el-tag>
              <span class="rule-name">{{ rule.ruleName }}</span>
            </div>
            <p v-if="rule.triggered" class="rule-detail">{{ rule.detail }}</p>
            <p v-if="rule.triggered && rule.suggestion" class="rule-suggestion">💡 {{ rule.suggestion }}</p>
          </div>
          <el-divider v-if="conclusion.summary" />
          <p v-if="conclusion.summary" class="fg-muted" style="margin: 0">{{ conclusion.summary }}</p>
        </template>
      </div>

      <!-- LLM 润色 -->
      <div v-if="llmSummary" class="fg-card" style="margin-bottom: 16px">
        <h3 class="fg-section-title">✨ AI 润色总结</h3>
        <p class="llm-text">{{ llmSummary }}</p>
        <DisclaimerBar />
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { reportApi } from '@/api/report'
import { usePetStore } from '@/stores/pet'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import type { ReportConclusion, WeeklyReport } from '@/types'

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
</script>

<style scoped>
.report-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.metrics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 16px;
}

.metric-cell {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.metric-value {
  font-size: 20px;
  font-weight: 700;
}

.metric-value .up,
.up {
  color: #f56c6c;
}

.metric-value .down {
  color: #5b9bd5;
}

.metric-value small {
  font-size: 13px;
  font-weight: 500;
}

.rule-item {
  padding: 12px 0;
  border-bottom: 1px solid var(--fg-border);
}

.rule-item:last-of-type {
  border-bottom: none;
}

.rule-head {
  display: flex;
  align-items: center;
  gap: 10px;
}

.rule-name {
  font-weight: 600;
}

.rule-detail {
  margin: 8px 0 0;
  font-size: 13px;
  color: var(--fg-ink-light);
}

.rule-suggestion {
  margin: 6px 0 0;
  font-size: 14px;
  color: var(--fg-primary-deep);
}

.llm-text {
  line-height: 1.9;
  margin: 0;
  white-space: pre-wrap;
}
</style>
