<template>
  <div class="landing">
    <section class="hero">
      <div class="hero-text">
        <h1>把「经验喂养」<br />变成「数据喂养」</h1>
        <p class="hero-sub">
          FurGuardian 基于宠物个体数据与科学营养标准，帮你把「喂多少、什么时候喂、喂得对不对」这件事做对。
        </p>
        <div class="hero-actions">
          <el-button type="primary" size="large" @click="goAuth">免费开始</el-button>
          <el-button size="large" @click="scrollToCalc">试试热量计算器</el-button>
        </div>
      </div>
      <div class="hero-badge">
        <span class="paw">🐾</span>
      </div>
    </section>

    <section class="features fg-page">
      <div class="feature-card fg-card">
        <h3>📏 个体化喂食量</h3>
        <p>按体重、年龄、绝育、活动量计算 RER → MER，反推每日克数，不再看粮袋上那张粗表。</p>
      </div>
      <div class="feature-card fg-card">
        <h3>🔬 干物质基准对比</h3>
        <p>干粮湿粮统一换算到干物质基准再对照国标，营养表终于能看懂了。</p>
      </div>
      <div class="feature-card fg-card">
        <h3>🍬 零食 10% 硬上限</h3>
        <p>零食纳入每日总热量，超出额度自动告警，主粮算得准，零食不再随手给。</p>
      </div>
      <div class="feature-card fg-card">
        <h3>📈 体重趋势追踪</h3>
        <p>每周 BCS + 体重曲线，连续上升自动建议下调配比，周报一眼看懂。</p>
      </div>
    </section>

    <section ref="calcSection" class="calc-section fg-page">
      <div class="fg-card">
        <h2 class="fg-section-title">⚡ 每日热量尝鲜计算器</h2>
        <p class="fg-muted">纯前端即时计算，与后端营养引擎同一套公式（RER = 70 × 体重^0.75，MER = RER × 系数）。</p>
        <el-form :inline="true" class="calc-form">
          <el-form-item label="物种">
            <el-radio-group v-model="form.species">
              <el-radio-button value="dog">🐶 犬</el-radio-button>
              <el-radio-button value="cat">🐱 猫</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="体重 (kg)">
            <el-input-number v-model="form.weight" :min="0.5" :max="80" :step="0.5" :precision="1" />
          </el-form-item>
          <el-form-item label="年龄（月）">
            <el-input-number v-model="form.ageMonths" :min="1" :max="240" />
          </el-form-item>
          <el-form-item label="已绝育">
            <el-switch v-model="form.neutered" />
          </el-form-item>
          <el-form-item label="活动量">
            <el-select v-model="form.activityLevel" style="width: 180px">
              <el-option
                v-for="opt in ACTIVITY_OPTIONS"
                :key="opt.value"
                :value="opt.value"
                :label="opt.label"
              />
            </el-select>
          </el-form-item>
        </el-form>

        <div v-if="result" class="calc-result">
          <div class="result-item">
            <span class="result-label">RER 静息能量需求</span>
            <span class="result-value">{{ result.rer.toFixed(0) }} kcal/日</span>
          </div>
          <div class="result-arrow">× {{ result.factor }}（{{ result.factorNote }}）</div>
          <div class="result-item highlight">
            <span class="result-label">MER 每日维持能量需求</span>
            <span class="result-value">{{ result.mer.toFixed(0) }} kcal/日</span>
          </div>
          <div class="result-item">
            <span class="result-label">零食热量上限（10%）</span>
            <span class="result-value">{{ snackBudget(result.mer).toFixed(0) }} kcal/日</span>
          </div>
          <p class="fg-muted calc-note">
            计算过程：RER = 70 × {{ form.weight }}^0.75 = {{ result.rer.toFixed(1) }} kcal
            → MER = {{ result.rer.toFixed(1) }} × {{ result.factor }} = {{ result.mer.toFixed(1) }} kcal
          </p>
        </div>
      </div>
    </section>

    <footer class="landing-footer">
      <DisclaimerBar />
    </footer>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { calcMer, snackBudget } from '@/utils/calculator'
import { ACTIVITY_OPTIONS } from '@/utils/constants'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import type { ActivityLevel, Species } from '@/types'

const router = useRouter()

const form = reactive({
  species: 'dog' as Species,
  weight: 5,
  ageMonths: 24,
  neutered: true,
  activityLevel: 'LOW' as ActivityLevel,
})

const result = computed(() =>
  calcMer(form.weight, {
    species: form.species,
    ageMonths: form.ageMonths,
    neutered: form.neutered,
    activityLevel: form.activityLevel,
    physiology: 'NORMAL',
  }),
)

const calcSection = ref<HTMLElement>()

function scrollToCalc() {
  calcSection.value?.scrollIntoView({ behavior: 'smooth' })
}

function goAuth() {
  router.push('/auth')
}
</script>

<style scoped>
.landing {
  min-height: 100vh;
}

.hero {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 60px;
  padding: 100px 24px 80px;
  background: linear-gradient(160deg, #fff3e4 0%, #fdf8f3 70%);
}

.hero-text h1 {
  font-size: 44px;
  line-height: 1.25;
  margin: 0 0 16px;
  color: var(--fg-ink);
}

.hero-sub {
  font-size: 16px;
  color: var(--fg-ink-light);
  max-width: 460px;
  line-height: 1.8;
  margin: 0 0 28px;
}

.hero-actions {
  display: flex;
  gap: 12px;
}

.hero-badge {
  font-size: 120px;
  user-select: none;
}

.features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 16px;
  padding-top: 40px;
}

.feature-card h3 {
  margin: 0 0 8px;
  font-size: 16px;
}

.feature-card p {
  margin: 0;
  font-size: 13px;
  color: var(--fg-ink-light);
  line-height: 1.7;
}

.calc-section {
  padding-top: 24px;
  padding-bottom: 40px;
}

.calc-form {
  margin-top: 12px;
}

.calc-result {
  margin-top: 16px;
  padding: 20px;
  background: #fdf3e7;
  border-radius: 12px;
}

.result-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
}

.result-item.highlight .result-value {
  font-size: 24px;
  color: var(--fg-primary-deep);
}

.result-label {
  color: var(--fg-ink-light);
  font-size: 14px;
}

.result-value {
  font-size: 18px;
  font-weight: 700;
}

.result-arrow {
  color: var(--fg-ink-light);
  font-size: 13px;
  padding-left: 12px;
}

.calc-note {
  margin: 12px 0 0;
}

.landing-footer {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px 32px;
}
</style>
