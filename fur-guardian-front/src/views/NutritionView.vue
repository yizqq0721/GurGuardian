<template>
  <div class="fg-page">
    <PageHeader :title="`营养方案`" :breadcrumb="pet ? `${pet.name} · 营养方案` : '营养方案'"
                :back="{ to: '/pets', label: '我的宠物' }"
                description="按个体数据算出每日热量与克数，并对照国标逐项判定该粮是否达标。">
      <template #actions>
        <el-button v-if="foodId" :loading="calculating" @click="calculate">重新计算</el-button>
      </template>
    </PageHeader>

    <!-- 1. 上下文条 -->
    <section class="context-bar">
      <span class="pet-avatar">
        <component :is="pet?.species === 'cat' ? Cat : Dog" :size="22" class="fg-icon" />
      </span>
      <div class="ctx-pet">
        <p class="ctx-name">{{ pet?.name || '未选择宠物' }}</p>
        <p class="fg-muted ctx-meta">{{ petMeta }}</p>
      </div>

      <div class="ctx-divider" />

      <div class="ctx-food">
        <p class="fg-label">当前主粮</p>
        <el-select
          v-model="foodId"
          class="food-select"
          placeholder="从食品库选择主粮"
          filterable
          @change="calculate"
        >
          <el-option
            v-for="f in foods"
            :key="f.id"
            :value="f.id"
            :label="`${f.brand ? f.brand + ' ' : ''}${f.name}`"
          >
            <span class="opt">
              <span>{{ f.brand ? f.brand + ' ' : '' }}{{ f.name }}</span>
              <span class="opt-me fg-num fg-muted">{{ f.labeledMeKcal ?? '—' }} kcal/kg</span>
            </span>
          </el-option>
        </el-select>
      </div>
      <router-link to="/foods/new" class="fg-muted add-food">没收录？去录入</router-link>
    </section>

    <template v-if="plan">
      <div class="fg-split">
        <div class="main-col">
          <!-- 2. Hero 指标：发丝分隔，不做四张等大卡片 -->
          <section class="fg-card hero">
            <div class="fg-metric-row">
              <StatTile
                label="MER 每日维持能量"
                :value="fmt(plan.merKcal)"
                unit="kcal/日"
                :caption="`RER ${fmt(plan.rerKcal)} kcal × ${merCoefficient}`"
              />
              <StatTile
                label="每日主粮"
                :value="fmt(plan.mainFoodGrams)"
                unit="g"
                hero
                :caption="`≈ ${fmt(plan.gramsPerMeal)} g/餐 × ${plan.mealsPerDay} 餐`"
              />
              <StatTile
                label="零食额度"
                :value="fmt(plan.snackBudgetKcal)"
                unit="kcal"
                caption="占 MER 10% 硬上限"
              />
            </div>
          </section>

          <!-- 3. 计算过程 -->
          <section class="fg-card">
            <h2 class="fg-section-title">我们怎么算的</h2>
            <StepTimeline :steps="calcSteps" />
          </section>

          <!-- 4. 营养达标 -->
          <section class="fg-card">
            <h2 class="fg-section-title">营养达标判定</h2>
            <NutrientTable :rows="plan.validations" />
            <p class="footnote">国标是及格线，不等于最适合你家宠物。</p>
          </section>
        </div>

        <!-- 5. 侧栏 -->
        <aside class="aside-col">
          <section class="fg-card">
            <h2 class="fg-section-title">能量密度</h2>
            <p class="density">
              <span class="fg-num">{{ plan.energyDensityKcalPer100g }}</span>
              <span class="fg-unit">kcal/100g</span>
            </p>
            <p class="fg-muted density-note">
              {{ plan.energyEstimated ? '该粮未标注代谢能，下方数值由修正 Atwater 公式估算。' : '取自包装标注的代谢能。' }}
            </p>
            <span class="fg-chip" :class="plan.energyEstimated ? 'fg-chip--warn' : 'fg-chip--ok'">
              {{ plan.energyEstimated ? 'Atwater 估算' : '标注值' }}
            </span>
          </section>

          <section v-if="weightAdvice || plan.warnings?.length" class="fg-card">
            <h2 class="fg-section-title">需要注意</h2>
            <div class="callouts">
              <p v-if="weightAdvice" class="fg-callout" :class="{ 'fg-callout--danger': plan.overweight || plan.underweight }">
                {{ weightAdvice }}
              </p>
              <p v-for="(w, i) in plan.warnings" :key="i" class="fg-callout">{{ w }}</p>
            </div>
          </section>

          <DisclaimerBar />
        </aside>
      </div>
    </template>

    <EmptyState v-else variant="foods" description="选择主粮后生成个体化营养方案" />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Cat, Dog } from 'lucide-vue-next'
import { foodApi } from '@/api/food'
import { nutritionApi } from '@/api/nutrition'
import { petApi } from '@/api/pet'
import { usePetStore } from '@/stores/pet'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import EmptyState from '@/components/EmptyState.vue'
import NutrientTable from '@/components/NutrientTable.vue'
import PageHeader from '@/components/PageHeader.vue'
import StatTile from '@/components/StatTile.vue'
import StepTimeline, { type TimelineStep } from '@/components/StepTimeline.vue'
import { ageText } from '@/utils/format'
import type { Food, NutritionPlan, WeightLog } from '@/types'

const route = useRoute()
const petStore = usePetStore()
const petId = Number(route.params.id)

const foods = ref<Food[]>([])
const foodId = ref<number>()
const plan = ref<NutritionPlan | null>(null)
const calculating = ref(false)
const latestWeight = ref<WeightLog | null>(null)

const pet = computed(() => petStore.pets.find((p) => p.id === petId))

const petMeta = computed(() => {
  if (!pet.value) return ''
  const bits = [pet.value.breed, ageText(pet.value.birthday)]
  if (pet.value.neutered) bits.push('已绝育')
  if (latestWeight.value) bits.push(`${latestWeight.value.weightKg} kg`)
  if (pet.value.bcs) bits.push(`BCS ${pet.value.bcs}/9`)
  return bits.filter(Boolean).join(' · ')
})

const weightAdvice = computed(() => plan.value?.weightAdvice || null)

const merCoefficient = computed(() => {
  if (!plan.value || !plan.value.rerKcal) return '—'
  return (plan.value.merKcal / plan.value.rerKcal).toFixed(2)
})

const calcSteps = computed<TimelineStep[]>(() => parseProcess(plan.value?.calculationProcess || ''))

function fmt(n?: number) {
  return n == null ? '—' : String(Math.round(n))
}

/** 后端把计算过程拼成多行文本，这里按行还原成时间线，公式原样保留、结果右对齐 */
function parseProcess(text: string): TimelineStep[] {
  const lines = text
    .split('\n')
    .map((l) => l.trim())
    .filter(Boolean)

  return lines.map((line) => {
    const eq = line.indexOf('=')
    const formula = eq >= 0 ? line.slice(eq + 1).trim() : ''
    const label = eq >= 0 ? line.slice(0, eq).trim() : line
    const result = formula.match(/([\d.,]+\s*(?:kcal[^=]*|g[^=]*|%)?)$/)?.[1]?.trim()
    return {
      label: label.replace(/[:：]$/, ''),
      formula: formula || undefined,
      result: result && result !== formula ? result : undefined,
    }
  })
}

onMounted(async () => {
  const [page, history] = await Promise.all([
    foodApi.list({ page: 1, size: 100 }),
    petApi.weightHistory(petId).catch(() => [] as WeightLog[]),
  ])
  foods.value = page.records.filter(
    (f) => !f.productType || f.productType === 'COMPLETE' || f.productType === 'COMPLEMENTARY',
  )
  latestWeight.value = history[0] ?? null
  if (!petStore.pets.length) await petStore.fetchPets(true)
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
/* 上下文条 */
.context-bar {
  display: flex;
  align-items: center;
  gap: var(--fg-s4);
  padding: var(--fg-s4) var(--fg-s5);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  margin-bottom: var(--fg-s5);
}

.pet-avatar {
  width: 40px;
  height: 40px;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  border: var(--fg-line-w) solid var(--fg-line);
  background: var(--fg-paper);
  color: var(--fg-accent);
}

.ctx-pet {
  min-width: 0;
}

.ctx-name {
  margin: 0;
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h3);
  font-weight: 600;
  letter-spacing: -0.01em;
}

.ctx-meta {
  margin: 0;
  font-size: var(--fg-text-label);
}

.ctx-divider {
  width: var(--fg-line-w);
  align-self: stretch;
  background: var(--fg-line);
}

.ctx-food {
  flex: 1;
  min-width: 0;
}

.ctx-food .fg-label {
  margin: 0 0 var(--fg-s1);
}

.food-select {
  width: 100%;
  max-width: 380px;
}

.food-select :deep(.el-select__wrapper) {
  border-color: transparent;
  padding-left: 0;
  box-shadow: none !important;
}

.food-select :deep(.el-select__wrapper:hover) {
  border-color: var(--fg-line);
  padding-left: var(--fg-s2);
}

.opt {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s5);
}

.opt-me {
  font-size: var(--fg-text-label);
}

.add-food {
  flex: none;
  font-size: var(--fg-text-label);
}

.add-food:hover {
  text-decoration: underline;
}

/* 正文 */
.main-col {
  min-width: 0;
}

.aside-col {
  min-width: 0;
  position: sticky;
  top: calc(var(--fg-topbar-h) + var(--fg-s5));
}

.hero {
  margin-bottom: var(--fg-s5);
}

.aside-col .fg-card + .fg-card {
  margin-top: var(--fg-s5);
}

.aside-col .fg-card:last-of-type {
  margin-bottom: var(--fg-s4);
}

.callouts > * + * {
  margin-top: var(--fg-s4);
}

.density {
  margin: 0;
  display: flex;
  align-items: baseline;
}

.density .fg-num {
  font-size: 32px;
  font-weight: 600;
}

.density-note {
  margin: var(--fg-s2) 0 var(--fg-s3);
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

.footnote {
  margin: var(--fg-s4) 0 0;
  padding-top: var(--fg-s3);
  border-top: var(--fg-line-w) solid var(--fg-line);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

@media (max-width: 1024px) {
  .context-bar {
    flex-wrap: wrap;
  }
  .ctx-divider {
    display: none;
  }
}
</style>
