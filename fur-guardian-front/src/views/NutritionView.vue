<template>
  <div class="fg-page">
    <div class="fg-card picker-card">
      <h2 class="fg-section-title">🥣 营养方案</h2>
      <div class="picker-row">
        <span>选择主粮：</span>
        <el-select
          v-model="foodId"
          placeholder="从食品库选择主粮"
          style="width: 320px"
          filterable
          @change="calculate"
        >
          <el-option
            v-for="f in foods"
            :key="f.id"
            :value="f.id"
            :label="`${f.brand ? f.brand + ' ' : ''}${f.name}`"
          />
        </el-select>
        <el-button text type="primary" @click="router.push('/foods/new')">没收录？去录入</el-button>
      </div>
    </div>

    <template v-if="plan">
      <!-- 热量卡片 -->
      <div class="stat-grid">
        <div class="fg-card stat-card">
          <div class="stat-label">RER 静息能量</div>
          <div class="stat-value">{{ plan.rerKcal.toFixed(0) }} <small>kcal/日</small></div>
        </div>
        <div class="fg-card stat-card">
          <div class="stat-label">MER 维持能量</div>
          <div class="stat-value">{{ plan.merKcal.toFixed(0) }} <small>kcal/日</small></div>
        </div>
        <div class="fg-card stat-card highlight">
          <div class="stat-label">每日主粮</div>
          <div class="stat-value">{{ plan.mainFoodGrams.toFixed(0) }} <small>克/日</small></div>
          <div class="fg-muted">
            分 {{ plan.mealsPerDay }} 餐 · 每餐约 {{ plan.gramsPerMeal.toFixed(0) }} 克
          </div>
        </div>
        <div class="fg-card stat-card">
          <div class="stat-label">零食额度（10% 上限）</div>
          <div class="stat-value">{{ plan.snackBudgetKcal.toFixed(0) }} <small>kcal</small></div>
          <div class="fg-muted">≈ {{ plan.snackBudgetGrams.toFixed(0) }} 克该粮</div>
        </div>
      </div>

      <!-- 计算过程 -->
      <div class="fg-card">
        <h3 class="fg-section-title">🧮 计算过程（可解释）</h3>
        <pre class="process">{{ plan.calculationProcess }}</pre>
        <el-alert
          v-if="plan.energyEstimated"
          type="warning"
          :closable="false"
          title="该粮未标注代谢能，能量密度为修正 Atwater 公式估算值"
        />
        <el-alert
          v-if="plan.weightAdvice"
          :type="plan.overweight ? 'warning' : 'info'"
          :closable="false"
          :title="plan.weightAdvice"
          style="margin-top: 8px"
        />
      </div>

      <!-- 缺口分析 -->
      <div class="fg-card">
        <h3 class="fg-section-title">🔬 营养达标分析（对照国标）</h3>
        <el-table :data="plan.validations" size="large">
          <el-table-column prop="nutrient" label="营养素" width="140" />
          <el-table-column label="该粮标注值" width="140">
            <template #default="{ row }">{{ row.actualValue }}{{ row.unit }}</template>
          </el-table-column>
          <el-table-column label="国标要求">
            <template #default="{ row }">
              <span v-if="row.requiredMin != null">≥ {{ row.requiredMin }}{{ row.unit }}</span>
              <span v-else-if="row.requiredMax != null">≤ {{ row.requiredMax }}{{ row.unit }}</span>
              <span v-else class="fg-muted">无要求</span>
            </template>
          </el-table-column>
          <el-table-column label="判定" width="120">
            <template #default="{ row }">
              <el-tag :type="row.passed ? 'success' : 'danger'">
                {{ row.passed ? '达标' : '不达标' }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
        <p class="fg-muted" style="margin-bottom: 0">
          提示：国标是「及格线」而非「最优值」，符合国标 ≠ 最适合你家宠物。
        </p>
      </div>

      <!-- 告警 -->
      <div v-if="plan.warnings?.length" class="fg-card">
        <h3 class="fg-section-title">⚠️ 注意事项</h3>
        <el-alert
          v-for="(w, i) in plan.warnings"
          :key="i"
          type="warning"
          :closable="false"
          :title="w"
          style="margin-bottom: 8px"
        />
      </div>
    </template>

    <el-empty v-else-if="!calculating" description="选择主粮后生成个体化营养方案" />
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { foodApi } from '@/api/food'
import { nutritionApi } from '@/api/nutrition'
import type { Food, NutritionPlan } from '@/types'

const route = useRoute()
const router = useRouter()
const petId = Number(route.params.id)

const foods = ref<Food[]>([])
const foodId = ref<number>()
const plan = ref<NutritionPlan | null>(null)
const calculating = ref(false)

onMounted(async () => {
  const page = await foodApi.list({ page: 1, size: 100 })
  foods.value = page.records.filter(
    (f) => !f.productType || f.productType === 'COMPLETE' || f.productType === 'COMPLEMENTARY',
  )
})

async function calculate() {
  if (!foodId.value) return
  calculating.value = true
  try {
    plan.value = await nutritionApi.calculate(petId, foodId.value)
  } catch {
    ElMessage.error('计算失败，请确认宠物档案完整')
    plan.value = null
  } finally {
    calculating.value = false
  }
}
</script>

<style scoped>
.picker-card {
  margin-bottom: 16px;
}

.picker-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.stat-card.highlight {
  border-color: var(--fg-primary);
  background: linear-gradient(160deg, #fff7ec, #fff);
}

.stat-label {
  font-size: 13px;
  color: var(--fg-ink-light);
}

.stat-value {
  font-size: 30px;
  font-weight: 700;
  color: var(--fg-primary-deep);
  margin: 6px 0;
}

.stat-value small {
  font-size: 13px;
  font-weight: 400;
  color: var(--fg-ink-light);
}

.fg-card + .fg-card {
  margin-bottom: 16px;
}

.process {
  background: #fdf3e7;
  border-radius: 10px;
  padding: 14px 18px;
  font-size: 13px;
  line-height: 1.9;
  white-space: pre-wrap;
  word-break: break-all;
  margin: 0 0 8px;
}
</style>
