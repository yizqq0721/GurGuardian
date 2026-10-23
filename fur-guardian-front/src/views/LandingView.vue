<template>
  <div class="landing">
    <!-- 顶栏：仅文字导航 -->
    <header class="site-head">
      <div class="head-inner">
        <span class="wordmark">
          <PawPrint :size="20" class="wordmark-icon" />
          <span>FurGuardian</span>
        </span>
        <div class="head-actions">
          <router-link to="/auth" class="head-login">登录</router-link>
          <el-button type="primary" @click="goAuth">免费开始</el-button>
        </div>
      </div>
    </header>

    <!-- 1. Hero：左文案 / 右真实产品片段 -->
    <section class="hero">
      <div class="hero-inner">
        <div class="hero-text">
          <p class="fg-label kicker">宠物营养计算 · 国标判定 · 体重追踪</p>
          <h1 class="fg-display hero-title">把「经验喂养」<br />变成「数据喂养」</h1>
          <p class="fg-lead hero-sub">
            按宠物个体数据算出每日热量与克数，再对照国标逐项判定该粮是否达标。
          </p>
          <div class="hero-actions">
            <el-button type="primary" size="large" @click="goAuth">免费开始</el-button>
            <el-button size="large" @click="scrollToCalc">试试热量计算器</el-button>
          </div>
          <p class="hero-note fg-mono">注册后即可建档，4 步生成个体化方案</p>
        </div>

        <!-- 紧凑计算器：左栏，底边与右侧示例卡对齐 -->
        <section ref="calcSection" class="hero-calc" aria-label="每日热量尝鲜计算器">
          <div class="fg-card calc-card">
            <div class="calc-head">
              <h2 class="fg-section-title calc-title">
                <Calculator :size="18" class="fg-icon" />
                每日热量尝鲜计算器
              </h2>
              <p class="calc-hint fg-label">纯前端即时计算 · 与后端同公式</p>
            </div>

            <div class="calc-fields">
              <div class="field">
                <span class="fg-label field-label">物种</span>
                <div class="seg-group" role="radiogroup" aria-label="物种">
                  <button
                    v-for="s in SPECIES_BUTTONS"
                    :key="s.value"
                    type="button"
                    role="radio"
                    :aria-checked="form.species === s.value"
                    class="seg-btn"
                    :class="{ 'is-active': form.species === s.value }"
                    @click="form.species = s.value"
                  >
                    <component :is="s.icon" :size="18" class="fg-icon" />
                    <span>{{ s.label }}</span>
                  </button>
                </div>
              </div>

              <label class="field">
                <span class="fg-label field-label">体重 (kg)</span>
                <el-input-number
                  v-model="form.weight"
                  class="num"
                  size="large"
                  :min="0.5"
                  :max="80"
                  :step="0.5"
                  :precision="1"
                  :controls="false"
                />
              </label>

              <label class="field">
                <span class="fg-label field-label">年龄（月）</span>
                <el-input-number
                  v-model="form.ageMonths"
                  class="num"
                  size="large"
                  :min="1"
                  :max="240"
                  :controls="false"
                />
              </label>

              <div class="field">
                <span class="fg-label field-label">已绝育</span>
                <el-switch v-model="form.neutered" />
              </div>

              <label class="field">
                <span class="fg-label field-label">活动量</span>
                <el-select v-model="form.activityLevel" class="sel" size="large">
                  <el-option
                    v-for="opt in ACTIVITY_OPTIONS"
                    :key="opt.value"
                    :value="opt.value"
                    :label="opt.label"
                  />
                </el-select>
              </label>

              <label class="field">
                <span class="fg-label field-label">主粮能量密度 (kcal/kg)</span>
                <el-input-number
                  v-model="density"
                  class="num"
                  size="large"
                  :min="500"
                  :max="6000"
                  :step="50"
                  :controls="false"
                />
              </label>
            </div>

            <div v-if="result" class="calc-result">
              <div class="fg-divider" />
              <div class="calc-metrics">
                <StatTile
                  label="RER 静息能量需求"
                  :value="fmt(result.rer)"
                  unit="kcal/日"
                  :caption="`70 × ${weightText}^0.75`"
                />
                <StatTile
                  label="MER 每日维持能量"
                  :value="fmt(result.mer)"
                  unit="kcal/日"
                  :caption="`× ${result.factor.toFixed(2)}`"
                />
                <StatTile
                  label="每日主粮"
                  :value="fmt(grams)"
                  unit="g/日"
                  :caption="`${density} kcal/kg`"
                />
                <StatTile
                  label="零食额度"
                  :value="fmt(snackBudget(result.mer))"
                  unit="kcal"
                  caption="占 MER 10% 硬上限"
                />
              </div>
              <div class="calc-formula">
                <p class="fg-mono">{{ rerFormula }}</p>
                <p class="fg-mono">{{ merFormula }}</p>
                <p class="fg-mono">{{ gramsFormula }}</p>
                <p class="fg-mono">{{ snackFormula }}</p>
              </div>
            </div>
          </div>
        </section>

        <aside class="hero-panel" aria-label="营养方案示例片段">
          <div class="panel-head">
            <p class="fg-label">营养方案 · 示例数据</p>
            <p class="panel-meta">玩具贵宾 · 5.1 kg · BCS 5/9 · 已绝育</p>
          </div>

          <div class="panel-metrics">
            <StatTile label="MER 每日维持能量" value="337" unit="kcal/日" caption="RER 234 kcal × 1.44" />
            <StatTile label="每日主粮" value="79" unit="g/日" caption="≈ 39 g/餐 × 2 餐" />
            <StatTile label="零食额度" value="34" unit="kcal" caption="占 MER 10% 硬上限" />
          </div>

          <div class="panel-spark">
            <div class="spark-head">
              <p class="fg-label">体重趋势 · 近 8 周</p>
              <span class="fg-chip fg-chip--warn">连续上升，已提示下调配比</span>
            </div>
            <svg
              class="spark"
              viewBox="0 0 200 40"
              fill="none"
              stroke="currentColor"
              stroke-width="1"
              aria-hidden="true"
            >
              <line x1="0" y1="34" x2="200" y2="34" stroke="var(--fg-line)" />
              <polyline
                points="6,30.5 32.9,30.5 59.7,25.3 86.6,21.8 113.4,20 140.3,14.7 167.1,13 194,9.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <circle cx="194" cy="9.5" r="2" fill="currentColor" stroke="none" />
            </svg>
            <p class="spark-note">
              <span class="fg-num">5.00 kg → 5.12 kg</span>
              <span class="fg-num">+2.4%</span>
              <span class="fg-muted">已写入本周周报</span>
            </p>
          </div>

          <div class="panel-foot">
            <SourceChip label="GB/T 31216-2014" />
            <span class="panel-density fg-num">3650 kcal/kg</span>
          </div>
        </aside>
      </div>
    </section>

    <!-- 2. 信任条：纯文字，上下发丝线 -->
    <div class="trust">
      <p class="trust-inner">
        <span>GB/T 31216-2014</span>
        <span class="trust-dot" aria-hidden="true">·</span>
        <span>GB/T 31217-2014</span>
        <span class="trust-dot" aria-hidden="true">·</span>
        <span>WSAVA</span>
        <span class="trust-dot" aria-hidden="true">·</span>
        <span>NRC</span>
      </p>
    </div>

    <!-- 3. 三步引导：从建档到拿到方案 -->
    <section class="fg-page block">
      <h2 class="fg-h2 block-title">三步做出第一份喂养方案</h2>
      <p class="block-lead">
        不用先弄懂营养学。跟着下面三步走，建档、计算、判定都由系统完成，你只需要照着结果喂。
      </p>
      <ol class="prob-list">
        <li class="prob">
          <span class="prob-idx fg-mono">01</span>
          <div class="prob-body">
            <h3 class="prob-title">先建一份宠物档案</h3>
            <p class="prob-line">
              <span class="fg-label prob-tag">开始</span>
              告诉系统它多重、几个月大、是否绝育、平时活动多少——这就是计算所需的全部信息。
            </p>
            <p class="prob-line">
              <span class="fg-label prob-tag">得到</span>
              一份随体重更新的每日热量与克数方案，换粮、绝育、体重变化后都可重新生成。
            </p>
          </div>
          <div class="prob-vis">
            <div class="vis-row">
              <span class="fg-label">宠物档案</span>
              <span class="fg-num fg-is-accent">犬 · 5.1 kg</span>
            </div>
            <div class="vis-row">
              <span class="fg-label">活动量</span>
              <span class="fg-num">低（偶尔散步）</span>
            </div>
          </div>
        </li>

        <li class="prob">
          <span class="prob-idx fg-mono">02</span>
          <div class="prob-body">
            <h3 class="prob-title">按方案喂，不再猜粮袋</h3>
            <p class="prob-line">
              <span class="fg-label prob-tag">开始</span>
              打开营养方案，按每日克数与零食额度分餐；临时加了罐头或冻干，顺手记一笔。
            </p>
            <p class="prob-line">
              <span class="fg-label prob-tag">得到</span>
              主粮与零食分开计算，零食超过总热量 10% 时当场提示，不必事后回想。
            </p>
          </div>
          <div class="prob-vis">
            <div class="vis-row">
              <span class="fg-label">粮袋区间</span>
              <span class="fg-num vis-cold">90–125 g/日</span>
            </div>
            <div class="vis-row">
              <span class="fg-label">个体计算</span>
              <span class="fg-num fg-is-accent">79 g/日</span>
            </div>
          </div>
        </li>

        <li class="prob">
          <span class="prob-idx fg-mono">03</span>
          <div class="prob-body">
            <h3 class="prob-title">喂之前，对照国标复核一次</h3>
            <p class="prob-line">
              <span class="fg-label prob-tag">开始</span>
              添加主粮时填入包装上的营养表，系统会自动换算到干物质基准。
            </p>
            <p class="prob-line">
              <span class="fg-label prob-tag">得到</span>
              每项营养是否达标一眼可见，不达标的项目会给出可执行的换粮或补充方向。
            </p>
          </div>
          <div class="prob-vis">
            <div class="vis-row">
              <span class="fg-label">标注粗蛋白</span>
              <span class="fg-num vis-cold">25%</span>
            </div>
            <div class="vis-row">
              <span class="fg-label">干物质基准</span>
              <span class="fg-num fg-is-accent">87%</span>
            </div>
            <span class="fg-chip fg-chip--ok">高于国标 22%</span>
          </div>
        </li>
      </ol>
    </section>

    <!-- 4. 把方案用起来：日常功能引导 -->
    <section class="fg-page block">
      <h2 class="fg-h2 block-title">建档只是起点，接下来这样用</h2>
      <p class="block-lead">
        一份计算方案要变成习惯，靠的是每天记一点、每周看一眼、到点有人提醒。下面三件事都能在站内完成。
      </p>
      <ol class="promise-list">
        <li class="promise">
          <span class="promise-idx fg-num">1</span>
          <div class="promise-body">
            <h3 class="fg-h3 promise-title">
              <LineChart :size="20" class="fg-icon" />
              每天两分钟，记录喂食与体重
            </h3>
            <p class="promise-text">
              喂了多少、体重几斤、今天喝没喝水，随手记下即可。趋势图会替你看方向：
              体重是在稳、在降，还是该把零食收一收。
            </p>
          </div>
        </li>
        <li class="promise">
          <span class="promise-idx fg-num">2</span>
          <div class="promise-body">
            <h3 class="fg-h3 promise-title">
              <Sparkles :size="20" class="fg-icon" />
              每周一，打开就能读到 AI 小结
            </h3>
            <p class="promise-text">
              周报会自动汇总上周的体重、喂食与达标情况，写成一段能读懂的话。
              进入周报页即可看到结论，不满意还能一键重新生成。
            </p>
          </div>
        </li>
        <li class="promise">
          <span class="promise-idx fg-num">3</span>
          <div class="promise-body">
            <h3 class="fg-h3 promise-title">
              <BellRing :size="20" class="fg-icon" />
              该做的事，到点提醒你
            </h3>
            <p class="promise-text">
              喂食、散步、疫苗、驱虫都可以设成提醒。到期时网页内会弹出通知，
              也可以在设置里绑定邮箱，让提醒直接发到收件箱。
            </p>
          </div>
        </li>
      </ol>

      <div class="block-cta">
        <div class="cta-text">
          <h3 class="cta-title">从第一份档案开始</h3>
          <p class="cta-desc">免费注册，4 步生成个体化喂养方案，之后每周自动收到 AI 小结。</p>
        </div>
        <el-button type="primary" size="large" @click="goAuth">免费开始建档</el-button>
      </div>
    </section>

    <footer class="site-foot">
      <div class="foot-inner">
        <div class="foot-brand">
          <PawPrint :size="16" class="wordmark-icon" />
          <span>FurGuardian</span>
          <span class="fg-muted foot-tag">养宠智能助手</span>
        </div>
        <DisclaimerBar />
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { BellRing, Calculator, Cat, Dog, LineChart, PawPrint, Sparkles } from 'lucide-vue-next'
import { calcDailyGrams, calcMer, snackBudget } from '@/utils/calculator'
import { ACTIVITY_OPTIONS } from '@/utils/constants'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import SourceChip from '@/components/SourceChip.vue'
import StatTile from '@/components/StatTile.vue'
import type { ActivityLevel, Species } from '@/types'

const router = useRouter()

const SPECIES_BUTTONS = [
  { value: 'dog' as Species, label: '犬', icon: Dog },
  { value: 'cat' as Species, label: '猫', icon: Cat },
]

const form = reactive({
  species: 'dog' as Species,
  weight: 5,
  ageMonths: 24,
  neutered: true,
  activityLevel: 'LOW' as ActivityLevel,
})

/** 示例能量密度：与营养方案页同一口径（皇家贵宾成犬粮 3650 kcal/kg） */
const density = ref(3650)

const result = computed(() =>
  calcMer(form.weight, {
    species: form.species,
    ageMonths: form.ageMonths,
    neutered: form.neutered,
    activityLevel: form.activityLevel,
    physiology: 'NORMAL',
  }),
)

const grams = computed(() => calcDailyGrams(result.value.mer, density.value))

const weightText = computed(() => fx(form.weight))

const rerFormula = computed(() => `RER = 70 × ${weightText.value}^0.75 = ${fx(result.value.rer)} kcal`)
const merFormula = computed(
  () => `MER = ${fx(result.value.rer)} × ${fx(result.value.factor, 2)} = ${fx(result.value.mer)} kcal`,
)
const gramsFormula = computed(
  () => `主粮 = ${fx(result.value.mer)} ÷ ${fx(density.value / 1000, 2)} = ${fx(grams.value)} g/日`,
)
const snackFormula = computed(
  () => `零食 = ${fx(result.value.mer)} × 10% = ${fx(snackBudget(result.value.mer))} kcal`,
)

/** 输入清空时保留占位，避免 NaN 直接落到页面上 */
function fx(n: number, digits = 1) {
  return Number.isFinite(n) ? n.toFixed(digits) : '—'
}

function fmt(n?: number) {
  return n == null || !Number.isFinite(n) ? '—' : String(Math.round(n))
}

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
  background: transparent;
}

/* ---------- 顶栏 ---------- */
.site-head {
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  background-color: var(--fg-surface);
  background-image:
    linear-gradient(90deg, rgba(253, 251, 246, 0.78), rgba(250, 248, 242, 0.68)),
    url('/backgrounds/topbar-bg.png');
  background-position: center bottom;
  background-size: cover;
  background-repeat: no-repeat;
}

.head-inner {
  max-width: var(--fg-content-w);
  height: var(--fg-topbar-h);
  margin: 0 auto;
  padding: 0 var(--fg-s5);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s5);
}

.wordmark {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  font-family: var(--fg-font-serif);
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.01em;
  color: var(--fg-ink);
}

.wordmark-icon {
  color: var(--fg-accent);
}

.head-actions {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s4);
}

.head-login {
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
}

.head-login:hover {
  color: var(--fg-accent);
}

/* ---------- Hero ---------- */
.hero {
  padding: var(--fg-s8) 0 var(--fg-s7);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.hero-inner {
  max-width: var(--fg-content-w);
  margin: 0 auto;
  padding: 0 var(--fg-s5);
  display: grid;
  /* 左栏两行：文案 + 计算器；右栏示例卡跨两行，底边与计算器对齐 */
  grid-template-columns: minmax(0, 1fr) minmax(0, 380px);
  grid-template-areas:
    'text panel'
    'calc panel';
  column-gap: var(--fg-s8);
  row-gap: var(--fg-s6);
  align-items: stretch;
}

.hero-text {
  grid-area: text;
  align-self: start;
}

.hero-calc {
  grid-area: calc;
  align-self: end;
  min-width: 0;
}

.kicker {
  margin: 0 0 var(--fg-s4);
}

.hero-title {
  margin: 0;
  font-size: 52px;
  line-height: 1.2;
}

.hero-sub {
  margin: var(--fg-s5) 0 var(--fg-s6);
  max-width: 46ch;
}

.hero-actions {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.hero-note {
  margin: var(--fg-s5) 0 0;
}

/* 产品片段面板：白底 + 发丝边框，内部用分隔线而不是嵌套卡片 */
.hero-panel {
  grid-area: panel;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: var(--fg-s4);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  padding: var(--fg-s5);
}

.panel-head {
  padding-bottom: var(--fg-s4);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.panel-meta {
  margin: var(--fg-s2) 0 0;
  font-family: var(--fg-font-mono);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.panel-metrics > * + * {
  margin-top: var(--fg-s4);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.panel-spark {
  margin-top: var(--fg-s4);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.spark-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s3);
}

.spark {
  display: block;
  width: 100%;
  height: 40px;
  margin-top: var(--fg-s3);
  color: var(--fg-accent);
}

.spark-note {
  margin: var(--fg-s2) 0 0;
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s3);
  font-size: var(--fg-text-label);
  color: var(--fg-ink);
}

.panel-foot {
  margin-top: var(--fg-s4);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s4);
}

.panel-density {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

/* ---------- 信任条 ---------- */
.trust {
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.trust-inner {
  max-width: var(--fg-content-w);
  margin: 0 auto;
  padding: var(--fg-s4) var(--fg-s5);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: var(--fg-s3);
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
}

.trust-dot {
  color: var(--fg-line-strong);
}

/* ---------- 通用区块（.fg-page 负责容器宽度与左右内边距） ---------- */
.block {
  margin-top: var(--fg-s5);
}

.block-title {
  margin: 0 0 var(--fg-s6);
}

.block-lead {
  margin: calc(var(--fg-s5) * -1 + var(--fg-s3)) 0 var(--fg-s5);
  max-width: 62ch;
  line-height: 1.8;
  color: var(--fg-ink-muted);
}

/* 区块末尾的引导 CTA */
.block-cta {
  margin-top: var(--fg-s6);
  padding: var(--fg-s5);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s5);
  background: var(--fg-accent-soft);
  border: var(--fg-line-w) solid var(--fg-accent);
  border-radius: var(--fg-radius);
}

.cta-title {
  margin: 0 0 var(--fg-s2);
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h3);
  font-weight: 600;
}

.cta-desc {
  margin: 0;
  max-width: 48ch;
  font-size: var(--fg-text-label);
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.block-cta :deep(.el-button) {
  flex: none;
  margin-left: 0;
}

/* 问题 → 解法：整行 + 发丝分隔，不做卡片 */
.prob-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.prob {
  display: grid;
  grid-template-columns: 48px minmax(0, 1fr) minmax(0, 240px);
  gap: var(--fg-s6);
  align-items: start;
  padding: var(--fg-s6) 0;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.prob:last-child {
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.prob-idx {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  padding-top: var(--fg-s1);
}

.prob-title {
  margin: 0 0 var(--fg-s3);
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h3);
  font-weight: 600;
  letter-spacing: -0.01em;
}

.prob-line {
  margin: 0;
  max-width: 62ch;
  line-height: 1.8;
}

.prob-line + .prob-line {
  margin-top: var(--fg-s2);
}

.prob-tag {
  display: inline-block;
  min-width: 32px;
  margin-right: var(--fg-s3);
}

.prob-vis {
  padding-left: var(--fg-s5);
  border-left: var(--fg-line-w) solid var(--fg-line);
  display: grid;
  gap: var(--fg-s2);
  justify-items: start;
}

.vis-row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s4);
  width: 100%;
  font-size: var(--fg-text-label);
}

.vis-cold {
  color: var(--fg-ink-muted);
  text-decoration: line-through;
  text-decoration-color: var(--fg-line-strong);
}

/* 三条不能省 */
.promise-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.promise {
  display: grid;
  grid-template-columns: 48px minmax(0, 1fr);
  gap: var(--fg-s6);
  padding: var(--fg-s5) 0;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.promise:last-child {
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.promise-idx {
  font-size: var(--fg-text-h2);
  line-height: 1.3;
  color: var(--fg-line-strong);
  font-weight: 600;
}

.promise-title {
  margin: 0 0 var(--fg-s2);
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
}

.promise-text {
  margin: 0;
  max-width: 68ch;
  line-height: 1.8;
  color: var(--fg-ink-muted);
}

/* ---------- 计算器（Hero 左栏紧凑版） ---------- */
.calc-card {
  padding: var(--fg-s5);
}

.calc-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--fg-s1) var(--fg-s3);
}

.calc-title {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0;
  font-size: 18px;
}

.calc-hint {
  margin: 0;
}

.calc-fields {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: var(--fg-s3) var(--fg-s4);
  margin-top: var(--fg-s4);
}

/* 标签顶部对齐、控件底部对齐，避免长标签把输入框顶歪 */
.field {
  display: grid;
  grid-template-rows: auto minmax(0, 1fr);
  gap: var(--fg-s2);
  min-width: 0;
}

.field > :last-child {
  align-self: end;
}

.field-label {
  margin: 0;
}

.seg-group {
  display: inline-flex;
  gap: var(--fg-s2);
}

.seg-btn {
  appearance: none;
  height: 40px;
  padding: 0 var(--fg-s4);
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  color: var(--fg-ink);
  font-family: inherit;
  font-size: var(--fg-text-body);
  font-weight: 500;
  cursor: pointer;
  transition: background var(--fg-motion), border-color var(--fg-motion), color var(--fg-motion);
}

.seg-btn:hover {
  border-color: var(--fg-line-strong);
  color: var(--fg-accent);
}

.seg-btn.is-active {
  background: var(--fg-accent-soft);
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.num,
.sel {
  width: 100%;
}

.calc-result {
  margin-top: var(--fg-s4);
}

.calc-result .fg-divider {
  margin: var(--fg-s4) 0;
}

/* 指标行内自带发丝分隔，不再依赖全局 .fg-metric-row 的移动端堆叠 */
.calc-metrics {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: 1fr;
}

.calc-metrics > * {
  padding-right: var(--fg-s4);
}

.calc-metrics > * + * {
  padding-left: var(--fg-s4);
  border-left: var(--fg-line-w) solid var(--fg-line);
}

.calc-card :deep(.fg-value) {
  font-size: 28px;
}

.calc-card :deep(.fg-unit) {
  font-size: var(--fg-text-label);
}

.calc-formula {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s1) var(--fg-s5);
  margin-top: var(--fg-s4);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
  font-size: 11px;
  color: var(--fg-ink-muted);
}

.calc-formula p {
  margin: 0;
  overflow-wrap: anywhere;
}

.calc-card :deep(.el-input__wrapper),
.calc-card :deep(.el-select__wrapper) {
  height: 40px;
}

.calc-card :deep(.el-input-number .el-input__inner) {
  font-family: var(--fg-font-num);
  font-variant-numeric: tabular-nums;
}

.calc-card :deep(.el-switch) {
  align-self: center;
}

/* ---------- 页脚 ---------- */
.site-foot {
  border-top: var(--fg-line-w) solid var(--fg-line);
  background: var(--fg-surface);
}

.foot-inner {
  max-width: var(--fg-content-w);
  margin: 0 auto;
  padding: var(--fg-s6) var(--fg-s5) var(--fg-s6);
}

.foot-brand {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-body);
  font-weight: 600;
  color: var(--fg-ink);
}

.foot-tag {
  font-family: var(--fg-font-sans);
  font-weight: 400;
  font-size: var(--fg-text-label);
}

.site-foot .fg-disclaimer {
  margin-top: var(--fg-s3);
  padding-top: var(--fg-s3);
}

/* ---------- 响应式 ---------- */
@media (max-width: 1024px) {
  .hero-inner {
    grid-template-columns: minmax(0, 1fr);
    grid-template-areas:
      'text'
      'calc'
      'panel';
    row-gap: var(--fg-s6);
  }
  .hero-title {
    font-size: var(--fg-text-display);
  }
  .prob {
    grid-template-columns: 48px minmax(0, 1fr);
  }
  .prob-vis {
    grid-column: 2;
    padding-left: 0;
    border-left: none;
    margin-top: var(--fg-s4);
  }
}

@media (max-width: 768px) {
  .hero {
    padding-top: var(--fg-s6);
  }
  .hero-title {
    font-size: 32px;
  }
  .calc-card {
    padding: var(--fg-s5);
  }
}

/* ============================================================
   响应式新增：<768px 手机端
   桌面端（>=768px）不应用以下任何规则
   ============================================================ */
@media (max-width: 767.98px) {
  /* 顶栏 */
  .head-inner {
    padding: 0 var(--fg-s4);
    gap: var(--fg-s3);
  }

  .wordmark {
    font-size: 16px;
  }

  .head-actions {
    gap: var(--fg-s3);
  }

  .head-login {
    display: inline-flex;
    align-items: center;
    min-height: 44px;
  }

  /* Hero：单列、按钮铺满 */
  .hero {
    padding: 24px 0 40px;
  }

  .hero-inner {
    padding: 0 var(--fg-s4);
    gap: var(--fg-s5);
  }

  .hero-title {
    font-size: 30px;
  }

  .hero-sub {
    margin: var(--fg-s4) 0 var(--fg-s5);
  }

  .hero-actions {
    flex-direction: column;
    align-items: stretch;
    gap: var(--fg-s3);
  }

  .hero-actions :deep(.el-button) {
    width: 100%;
    margin-left: 0;
  }

  .hero-note {
    margin-top: var(--fg-s4);
  }

  .hero-panel {
    padding: var(--fg-s4);
  }

  .spark-head,
  .spark-note,
  .panel-foot {
    flex-wrap: wrap;
    row-gap: var(--fg-s2);
  }

  /* 信任条 */
  .trust-inner {
    padding: var(--fg-s3) var(--fg-s4);
    gap: var(--fg-s2);
  }

  /* 内容区块 */
  .block {
    margin-top: var(--fg-s5);
  }

  .block-title {
    margin-bottom: var(--fg-s5);
  }

  .block-lead {
    margin: calc(var(--fg-s4) * -1 + var(--fg-s2)) 0 var(--fg-s4);
    line-height: 1.7;
  }

  .block-cta {
    flex-direction: column;
    align-items: stretch;
    padding: var(--fg-s4);
    gap: var(--fg-s4);
  }

  .block-cta :deep(.el-button) {
    width: 100%;
  }

  /* 问题 → 解法：单列，数字保留在左侧 */
  .prob {
    grid-template-columns: 24px minmax(0, 1fr);
    gap: var(--fg-s3);
    padding: var(--fg-s5) 0;
  }

  .prob-idx {
    padding-top: 2px;
  }

  .prob-title {
    font-size: var(--fg-text-h3);
    margin-bottom: var(--fg-s2);
  }

  .prob-line {
    line-height: 1.7;
  }

  .prob-tag {
    margin-right: var(--fg-s2);
  }

  .prob-vis {
    margin-top: var(--fg-s3);
    padding-left: 0;
    border-left: none;
  }

  /* 三条不能省 */
  .promise {
    grid-template-columns: 28px minmax(0, 1fr);
    gap: var(--fg-s3);
    padding: var(--fg-s4) 0;
  }

  .promise-idx {
    font-size: var(--fg-text-h3);
  }

  .promise-title {
    align-items: flex-start;
  }

  .promise-text {
    line-height: 1.7;
  }

  /* 计算器：两列字段，结果 2×2，公式在手机端收起 */
  .calc-card {
    padding: var(--fg-s4);
  }

  .calc-title {
    font-size: 16px;
  }

  .calc-fields {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: var(--fg-s3);
    margin-top: var(--fg-s3);
  }

  .seg-group {
    display: flex;
    width: 100%;
  }

  .seg-btn {
    flex: 1;
    height: 44px;
    padding: 0 var(--fg-s2);
    gap: var(--fg-s1);
    justify-content: center;
  }

  .calc-card :deep(.el-input__wrapper),
  .calc-card :deep(.el-select__wrapper) {
    height: 44px;
  }

  /* 半列宽下让「低（偶尔散步）」这类活动量文案完整显示 */
  .calc-card :deep(.el-select__wrapper) {
    padding-inline: 10px;
    font-size: 12px;
  }

  .calc-card :deep(.fg-value) {
    font-size: 24px;
  }

  .calc-result .fg-divider {
    margin: var(--fg-s3) 0;
  }

  .calc-metrics {
    grid-auto-flow: row;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 0;
  }

  .calc-metrics > * {
    padding-right: 0;
    padding-left: 0;
    border-left: 0;
  }

  .calc-metrics > *:nth-child(even) {
    padding-left: var(--fg-s4);
    border-left: var(--fg-line-w) solid var(--fg-line);
  }

  .calc-metrics > *:nth-child(odd) {
    padding-right: var(--fg-s4);
  }

  .calc-metrics > *:nth-child(n + 3) {
    padding-top: var(--fg-s4);
    border-top: var(--fg-line-w) solid var(--fg-line);
  }

  .calc-formula {
    display: none;
  }

  /* 页脚 */
  .foot-inner {
    padding: var(--fg-s5) var(--fg-s4);
  }

  .foot-brand {
    flex-wrap: wrap;
    row-gap: var(--fg-s1);
  }
}
</style>
