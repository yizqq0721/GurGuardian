<template>
  <div class="fg-page">
    <PageHeader title="我的宠物" breadcrumb="宠物档案" :description="caption">
      <template #actions>
        <el-button type="primary" @click="router.push('/onboarding')">
          <Plus :size="20" class="fg-icon" />
          添加宠物
        </el-button>
      </template>
    </PageHeader>

    <section v-if="loading" class="carousel" aria-busy="true" aria-label="宠物档案加载中">
      <div class="stage">
        <div class="viewport">
          <div class="track" style="--active: 1">
            <div v-for="n in 3" :key="n" class="pet-card is-skeleton" :class="{ active: n === 2 }">
              <div class="head">
                <div class="photo sk" />
                <div class="facts">
                  <div>
                    <div class="sk sk-line" style="width: 42%" />
                    <div class="sk sk-line" style="width: 64%" />
                  </div>
                  <div class="sk sk-stats" />
                </div>
              </div>
              <div class="panels">
                <div class="panel">
                  <div class="panel-hd">
                    <div class="sk sk-line" style="width: 38%" />
                  </div>
                  <div class="panel-body">
                    <div class="sk sk-block" />
                  </div>
                </div>
                <div class="panel">
                  <div class="panel-hd">
                    <div class="sk sk-line" style="width: 38%" />
                  </div>
                  <div class="panel-body">
                    <div class="sk sk-block" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <div v-else-if="error" class="fg-callout fg-callout--danger">
      <p class="callout-text">{{ error }}</p>
      <el-button @click="load">
        <RotateCcw :size="20" class="fg-icon" />
        重试
      </el-button>
    </div>

    <EmptyState v-else-if="!pets.length" variant="pets" description="还没有宠物档案">
      <el-button type="primary" class="first-btn" @click="router.push('/onboarding')">
        添加第一只宠物
      </el-button>
    </EmptyState>

    <section
      v-else
      ref="carouselEl"
      class="carousel"
      role="region"
      aria-roledescription="carousel"
      :aria-label="`我的宠物，共 ${pets.length} 只`"
    >
      <p class="sr-only" aria-live="polite">当前宠物：{{ activePet?.name }}</p>

      <div class="stage">
        <div class="viewport">
          <div
            ref="trackEl"
            class="track"
            :class="{ 'is-dragging': dragging }"
            :style="trackStyle"
            tabindex="0"
            @keydown="onKeydown"
            @pointerdown="onPointerDown"
            @pointermove="onPointerMove"
            @pointerup="onPointerUp"
            @pointerleave="onPointerLeave"
            @pointercancel="onPointerUp"
          >
            <article
              v-for="(pet, i) in pets"
              :key="pet.id"
              class="pet-card"
              :class="{ active: i === activeIndex, before: i < activeIndex }"
              :aria-current="i === activeIndex ? 'true' : 'false'"
              @click="onCardClick(i)"
            >
              <div class="head">
                <div class="photo">
                  <img
                    v-if="petAvatarUrl(pet.avatar)"
                    :src="petAvatarUrl(pet.avatar)"
                    :alt="`${pet.name} 的照片`"
                    draggable="false"
                  />
                  <span v-else class="initial" aria-hidden="true">{{ initial(pet.name) }}</span>
                </div>

                <div class="facts">
                  <div class="facts-hd">
                    <h2 class="name">{{ pet.name }}</h2>
                    <el-button text class="flat-btn" @click.stop="goPet(pet.id)">进入主页</el-button>
                  </div>
                  <p class="meta">{{ metaText(pet) }}</p>

                  <dl class="stats">
                    <div class="stat">
                      <dt class="fg-label">体重</dt>
                      <dd class="stat-v">
                        <span class="fg-num">{{ weightOf(pet.id) ?? '—' }}</span>
                        <span v-if="weightOf(pet.id) != null" class="fg-unit">kg</span>
                      </dd>
                    </div>
                    <div class="stat">
                      <dt class="fg-label">体况 BCS</dt>
                      <dd class="stat-v">
                        <span class="fg-num" :class="bcsClass(pet.bcs)">{{ pet.bcs ?? '—' }}</span>
                        <span v-if="pet.bcs" class="fg-unit">/ 9</span>
                      </dd>
                    </div>
                    <div class="stat">
                      <dt class="fg-label">最近更新</dt>
                      <dd class="stat-v">
                        <span class="fg-num">{{ lastRecordText(pet) }}</span>
                      </dd>
                    </div>
                  </dl>
                </div>
              </div>

              <div class="panels">
                <section class="panel">
                  <header class="panel-hd">
                    <h3 class="panel-tt">营养方案</h3>
                    <el-button text class="flat-btn" @click.stop="goNutrition(pet.id)">
                      查看方案
                    </el-button>
                  </header>

                  <div class="panel-body">
                    <template v-if="planOf(pet.id)?.status === 'ready'">
                      <p class="food-line">
                        <UtensilsCrossed :size="14" class="fg-icon" />
                        <span class="food-name">{{ planOf(pet.id)?.foodName }}</span>
                        <span v-if="planOf(pet.id)?.plan?.energyEstimated" class="est-tag">
                          能量估算
                        </span>
                      </p>
                      <dl class="cells">
                        <div class="cell">
                          <dt class="fg-label">每日喂量</dt>
                          <dd class="cell-v">
                            <span class="fg-num">
                              {{ round(planOf(pet.id)?.plan?.mainFoodGrams) }}
                            </span>
                            <span class="fg-unit">g</span>
                          </dd>
                        </div>
                        <div class="cell">
                          <dt class="fg-label">分餐</dt>
                          <dd class="cell-v">
                            <span class="fg-num">
                              {{ round(planOf(pet.id)?.plan?.gramsPerMeal) }}
                            </span>
                            <span class="fg-unit">
                              g × {{ planOf(pet.id)?.plan?.mealsPerDay ?? '—' }} 餐
                            </span>
                          </dd>
                        </div>
                        <div class="cell">
                          <dt class="fg-label">目标能量</dt>
                          <dd class="cell-v">
                            <span class="fg-num">{{ round(planOf(pet.id)?.plan?.merKcal) }}</span>
                            <span class="fg-unit">kcal</span>
                          </dd>
                        </div>
                        <div class="cell">
                          <dt class="fg-label">零食上限</dt>
                          <dd class="cell-v">
                            <span class="fg-num">
                              {{ round(planOf(pet.id)?.plan?.snackBudgetGrams) }}
                            </span>
                            <span class="fg-unit">g</span>
                          </dd>
                        </div>
                      </dl>
                      <div
                        v-if="planOf(pet.id)?.plan?.warnings?.length"
                        class="warn-list"
                        :class="{ 'is-open': openWarnings.has(pet.id) }"
                      >
                        <p v-for="(w, i) in shownWarnings(pet.id)" :key="i" class="warn-line">
                          <TriangleAlert :size="14" class="fg-icon" />
                          <span class="warn-text">{{ w }}</span>
                        </p>
                      </div>
                      <el-button
                        v-if="hiddenWarnings(pet.id)"
                        text
                        class="flat-btn warn-more"
                        @click.stop="toggleWarnings(pet.id)"
                      >
                        {{ openWarnings.has(pet.id) ? '收起' : `展开其余 ${hiddenWarnings(pet.id)} 条` }}
                      </el-button>
                    </template>
                    <p v-else-if="planOf(pet.id)?.status === 'loading'" class="panel-note">
                      方案计算中…
                    </p>
                    <p v-else class="panel-note">
                      食品库里没有可匹配这只宠物的全价主食，先到营养方案页选粮。
                    </p>
                  </div>
                </section>

                <section class="panel">
                  <header class="panel-hd">
                    <h3 class="panel-tt">每日提醒</h3>
                    <el-button text class="flat-btn" @click.stop="goReminders(pet.id)">
                      提醒管理
                    </el-button>
                  </header>

                  <div class="panel-body">
                    <ul
                      v-if="shownReminders(pet.id).length"
                      class="rem-list"
                      :class="{ 'is-open': openReminders.has(pet.id) }"
                    >
                      <li
                        v-for="r in shownReminders(pet.id)"
                        :key="r.id"
                        class="rem"
                        :class="{ 'is-done': isDone(pet.id, r.id) }"
                      >
                        <span class="rem-time fg-num">{{ timeOf(r) }}</span>
                        <span class="rem-title">{{ r.title }}</span>
                        <span class="rem-rule">{{ repeatLabel(r) }}</span>
                        <button
                          class="rem-check"
                          :class="{ 'is-done': isDone(pet.id, r.id) }"
                          :disabled="isDone(pet.id, r.id) || checkingId.has(r.id)"
                          :aria-label="isDone(pet.id, r.id) ? `今日已完成：${r.title}` : `打卡：${r.title}`"
                          :aria-pressed="isDone(pet.id, r.id)"
                          @click.stop="checkIn(pet.id, r)"
                        >
                          <Check :size="14" />
                        </button>
                      </li>
                    </ul>
                    <p v-else class="panel-note">还没有设置提醒，去提醒页添加。</p>
                    <el-button
                      v-if="hiddenReminders(pet.id)"
                      text
                      class="flat-btn rem-more"
                      @click.stop="toggleReminders(pet.id)"
                    >
                      {{ openReminders.has(pet.id) ? '收起' : `展开其余 ${hiddenReminders(pet.id)} 项` }}
                    </el-button>
                  </div>
                </section>
              </div>
            </article>
          </div>
        </div>

        <button
          v-if="showNav"
          class="nav nav-prev"
          :disabled="activeIndex === 0"
          aria-label="上一只宠物"
          @click="step(-1)"
        >
          <ChevronLeft :size="20" class="fg-icon" />
        </button>
        <button
          v-if="showNav"
          class="nav nav-next"
          :disabled="activeIndex === pets.length - 1"
          aria-label="下一只宠物"
          @click="step(1)"
        >
          <ChevronRight :size="20" class="fg-icon" />
        </button>
      </div>

      <div v-if="pets.length > 1" class="pager">
        <div v-if="pets.length > 5" class="counter fg-mono">
          {{ activeIndex + 1 }} / {{ pets.length }}
        </div>
        <div v-else class="dots" role="tablist" aria-label="选择宠物">
          <button
            v-for="(pet, i) in pets"
            :key="pet.id"
            class="dot"
            :class="{ on: i === activeIndex }"
            role="tab"
            :aria-selected="i === activeIndex"
            :aria-label="pet.name"
            @click="go(i)"
          />
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import {
  Check,
  ChevronLeft,
  ChevronRight,
  Plus,
  RotateCcw,
  TriangleAlert,
  UtensilsCrossed,
} from 'lucide-vue-next'
import { foodApi } from '@/api/food'
import { nutritionApi } from '@/api/nutrition'
import { petApi } from '@/api/pet'
import { reminderApi } from '@/api/reminder'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import { usePetStore } from '@/stores/pet'
import { REPEAT_RULE_LABEL } from '@/utils/constants'
import { ageText, dateText, fromNow } from '@/utils/format'
import { petAvatarUrl } from '@/utils/petAvatar'
import type { Food, NutritionPlan, Pet, Reminder } from '@/types'

const router = useRouter()
const petStore = usePetStore()

const loading = ref(false)
const error = ref('')
const activeIndex = ref(0)
const carouselEl = ref<HTMLElement>()
const trackEl = ref<HTMLElement>()

/** 卡片上没有体重字段，取每只宠物最近一次体重记录，一次挂载内缓存住 */
const latestWeight = ref<Record<number, { kg?: number; at?: string }>>({})

interface PlanCell {
  status: 'loading' | 'ready' | 'empty'
  plan?: NutritionPlan
  foodName?: string
}

const planMap = ref<Record<number, PlanCell>>({})
const reminderMap = ref<Record<number, Reminder[]>>({})
/** petId → 今日已打卡的提醒 id，卡片上的勾选态全部由它驱动 */
const doneMap = ref<Record<number, Set<number>>>({})
const checkingId = ref<Set<number>>(new Set())

const pets = computed(() => petStore.pets)
const activePet = computed(() => pets.value[activeIndex.value])
const showNav = computed(() => pets.value.length > 1)

const caption = computed(() => {
  if (!pets.value.length) return '还没有宠物档案'
  const stamps = pets.value
    .map((p) => p.updatedAt || p.createdAt)
    .filter((v): v is string => !!v)
    .sort()
  return `共 ${pets.value.length} 只 · 最近更新 ${dateText(stamps[stamps.length - 1], 'M月D日')}`
})

const trackStyle = computed<Record<string, string | number>>(() => ({
  '--active': activeIndex.value,
  '--drag': `${dragX.value}px`,
}))

onMounted(load)

/* 顶栏切换器只写 store 不跳路由，这里把 store 的选中项映射回轮播索引 */
watch(
  () => petStore.currentPetId,
  (id) => {
    const at = pets.value.findIndex((p) => p.id === id)
    if (at > -1 && at !== activeIndex.value) activeIndex.value = at
  },
)

async function load() {
  loading.value = true
  error.value = ''
  try {
    await petStore.fetchPets(true)
    const at = pets.value.findIndex((p) => p.id === petStore.currentPetId)
    activeIndex.value = at > -1 ? at : 0
    void loadWeights()
    void loadReminders()
    void loadTodayDone()
    void loadPlans()
  } catch {
    error.value = '宠物列表加载失败，请检查网络后重试'
  } finally {
    loading.value = false
  }
}

async function loadWeights() {
  const missing = pets.value.filter((p) => latestWeight.value[p.id] === undefined)
  if (!missing.length) return
  const entries = await Promise.all(
    missing.map(async (p) => {
      try {
        /* 后端按 recordedAt 升序返回，末尾才是最近一次 */
        const logs = await petApi.weightHistory(p.id)
        const last = logs[logs.length - 1]
        return [p.id, { kg: last?.weightKg, at: last?.recordedAt }] as const
      } catch {
        return [p.id, {}] as const
      }
    }),
  )
  latestWeight.value = { ...latestWeight.value, ...Object.fromEntries(entries) }
}

async function loadReminders() {
  const entries = await Promise.all(
    pets.value.map(async (p) => {
      try {
        return [p.id, await reminderApi.list(p.id)] as const
      } catch {
        return [p.id, [] as Reminder[]] as const
      }
    }),
  )
  reminderMap.value = { ...reminderMap.value, ...Object.fromEntries(entries) }
}

async function loadTodayDone() {
  const today = dayjs().format('YYYY-MM-DD')
  const entries = await Promise.all(
    pets.value.map(async (p) => {
      try {
        const logs = await reminderApi.logs({ petId: p.id, startDate: today, endDate: today })
        return [p.id, new Set(logs.map((l) => l.reminderId))] as const
      } catch {
        return [p.id, new Set<number>()] as const
      }
    }),
  )
  doneMap.value = { ...doneMap.value, ...Object.fromEntries(entries) }
}

/** /api/nutrition/calculate 必须带 foodId，而 feeding_plans 表后端没有读写接口，
 *  所以按「物种 + 全价干粮」挑一款默认主食，卡片上会把用的是哪款写清楚 */
async function loadPlans() {
  pets.value.forEach((p) => {
    if (!planMap.value[p.id]) planMap.value[p.id] = { status: 'loading' }
  })
  let foods: Food[] = []
  try {
    foods = (await foodApi.list({ page: 1, size: 100 })).records
  } catch {
    pets.value.forEach((p) => {
      planMap.value[p.id] = { status: 'empty' }
    })
    return
  }
  await Promise.all(
    pets.value.map(async (p) => {
      const food = pickStaple(foods, p)
      if (!food) {
        planMap.value[p.id] = { status: 'empty' }
        return
      }
      try {
        planMap.value[p.id] = {
          status: 'ready',
          plan: await nutritionApi.calculate(p.id, food.id),
          foodName: food.name,
        }
      } catch {
        planMap.value[p.id] = { status: 'empty' }
      }
    }),
  )
}

function pickStaple(foods: Food[], pet: Pet) {
  const scope = pet.species === 'cat' ? 'CAT' : 'DOG'
  const matched = foods.filter(
    (f) => !f.speciesScope || f.speciesScope === 'BOTH' || f.speciesScope === scope,
  )
  const complete = matched.filter(
    (f) => !f.productType || f.productType === 'COMPLETE' || f.productType === 'COMPLEMENTARY',
  )
  return complete.find((f) => f.foodType === 'DRY') ?? complete[0] ?? matched[0]
}

function planOf(id: number) {
  return planMap.value[id]
}

function round(v?: number) {
  return v == null ? '—' : String(Math.round(v))
}

function sortReminders(list: Reminder[]) {
  return [...list].sort((a, b) => (a.remindTime ?? '99:99').localeCompare(b.remindTime ?? '99:99'))
}

const REM_LIMIT = 3
const openReminders = ref(new Set<number>())

function shownReminders(id: number) {
  const all = sortReminders(reminderMap.value[id] ?? [])
  return openReminders.value.has(id) ? all : all.slice(0, REM_LIMIT)
}

function hiddenReminders(id: number) {
  return Math.max(0, (reminderMap.value[id] ?? []).length - REM_LIMIT)
}

function toggleReminders(id: number) {
  const next = new Set(openReminders.value)
  if (next.has(id)) next.delete(id)
  else next.add(id)
  openReminders.value = next
}

function isDone(petId: number, reminderId: number) {
  return doneMap.value[petId]?.has(reminderId) ?? false
}

/** 打卡只进不退：成功后本地直接标记，失败提示由 request 拦截器统一弹出 */
async function checkIn(petId: number, row: Reminder) {
  if (isDone(petId, row.id) || checkingId.value.has(row.id)) return
  checkingId.value = new Set(checkingId.value).add(row.id)
  try {
    await reminderApi.checkin(row.id, { doneDate: dayjs().format('YYYY-MM-DD') })
    const next = new Set(doneMap.value[petId])
    next.add(row.id)
    doneMap.value = { ...doneMap.value, [petId]: next }
    ElMessage.success(`已完成「${row.title}」`)
  } catch {
    /* 拦截器已经提示过，这里只保留未打卡状态 */
  } finally {
    const settled = new Set(checkingId.value)
    settled.delete(row.id)
    checkingId.value = settled
  }
}

const WARN_LIMIT = 1
const openWarnings = ref(new Set<number>())

function shownWarnings(id: number) {
  const all = planMap.value[id]?.plan?.warnings ?? []
  return openWarnings.value.has(id) ? all : all.slice(0, WARN_LIMIT)
}

function hiddenWarnings(id: number) {
  return Math.max(0, (planMap.value[id]?.plan?.warnings ?? []).length - WARN_LIMIT)
}

function toggleWarnings(id: number) {
  const next = new Set(openWarnings.value)
  if (next.has(id)) next.delete(id)
  else next.add(id)
  openWarnings.value = next
}

function timeOf(r: Reminder) {
  /* 后端返回 HH:mm:ss，卡片只到分 */
  if (r.remindTime) return r.remindTime.slice(0, 5)
  return r.relativeMin != null ? '餐后' : '—'
}

function repeatLabel(r: Reminder) {
  return REPEAT_RULE_LABEL[r.repeatRule || ''] || '每天'
}

function weightOf(id: number) {
  return latestWeight.value[id]?.kg
}

function lastRecordText(pet: Pet) {
  const stamp = latestWeight.value[pet.id]?.at || pet.updatedAt || pet.createdAt
  const rel = fromNow(stamp)
  /* fromNow 超过 7 天退回 YYYY-MM-DD，卡片里太长，换成同义的短写法 */
  return /^\d{4}-\d{2}-\d{2}$/.test(rel) ? dateText(stamp, 'M月D日') : rel
}

function initial(name: string) {
  return name.slice(0, 1)
}

function metaText(pet: Pet) {
  const bits = [pet.breed || '品种未填写', ageText(pet.birthday)]
  if (pet.neutered) bits.push('已绝育')
  return bits.join(' · ')
}

function bcsClass(bcs?: number) {
  if (!bcs) return ''
  return bcs === 4 || bcs === 5 ? 'bcs-ok' : 'bcs-warn'
}

function go(next: number) {
  const clamped = Math.min(Math.max(next, 0), pets.value.length - 1)
  if (clamped === activeIndex.value) return
  activeIndex.value = clamped
  petStore.setCurrentPet(pets.value[clamped].id)
}

function step(delta: number) {
  go(activeIndex.value + delta)
}

function onCardClick(i: number) {
  if (dragMoved) return
  if (i !== activeIndex.value) go(i)
}

function onKeydown(e: KeyboardEvent) {
  const keys = ['ArrowLeft', 'ArrowRight', 'Home', 'End', 'Enter']
  if (!keys.includes(e.key)) return
  e.preventDefault()
  if (e.key === 'ArrowLeft') step(-1)
  else if (e.key === 'ArrowRight') step(1)
  else if (e.key === 'Home') go(0)
  else if (e.key === 'End') go(pets.value.length - 1)
  else goPet(pets.value[activeIndex.value].id)
}

function goPet(id: number) {
  petStore.setCurrentPet(id)
  router.push(`/pets/${id}`)
}

function goNutrition(id: number) {
  petStore.setCurrentPet(id)
  router.push(`/pets/${id}/nutrition`)
}

function goReminders(id: number) {
  petStore.setCurrentPet(id)
  router.push({ path: '/reminders', query: { pet: id } })
}

/* 拖拽：位移写进 --drag，松手按 25% 卡宽吸附；中心卡与侧卡等宽不同，步长要分方向 */
const dragging = ref(false)
const dragX = ref(0)
let dragStartX = 0
let dragMoved = false

function cssNum(name: string) {
  const el = carouselEl.value
  if (!el) return 0
  return parseFloat(getComputedStyle(el).getPropertyValue(name)) || 0
}

/** 手机端 --side-w 为 0，一次手势只切一张 */
function isSingleCard() {
  return cssNum('--side-w') === 0
}

function activeCardWidth() {
  return trackEl.value?.querySelector<HTMLElement>('.pet-card.active')?.offsetWidth ?? 0
}

function stepPx(forward: boolean) {
  const gap = cssNum('--gap')
  const declared = forward ? cssNum('--center-w') : cssNum('--side-w')
  /* 手机端 --center-w 是 calc()，parseFloat 得到 NaN，改量真实卡片宽度 */
  const step = declared > 0 ? declared : activeCardWidth()
  return (step > 0 ? step : carouselEl.value?.clientWidth ?? 1) + gap
}

function dragLimit() {
  return isSingleCard() ? Math.max(64, activeCardWidth() * 0.35) : Infinity
}

function onPointerDown(e: PointerEvent) {
  if (e.pointerType === 'mouse' && e.button !== 0) return
  if (!showNav.value) return
  /* 卡片里的按钮不参与拖拽起点，否则按下即被轮播接管 */
  if ((e.target as HTMLElement).closest('button')) return
  dragging.value = true
  dragMoved = false
  dragStartX = e.clientX
}

function onPointerMove(e: PointerEvent) {
  if (!dragging.value) return
  const raw = e.clientX - dragStartX
  /* 单卡模式下限制拖动距离，避免整张卡被拖出视口 */
  const limit = dragLimit()
  dragX.value = Number.isFinite(limit) ? Math.max(-limit, Math.min(limit, raw)) : raw
  if (Math.abs(raw) > 8) {
    dragMoved = true
    /* 越过阈值才捕获指针：在 pointerdown 就 setPointerCapture 会把后续
       pointerup 与 click 一起重定向到 track，卡片里的按钮永远点不中 */
    ;(e.currentTarget as HTMLElement | null)?.setPointerCapture(e.pointerId)
  }
}

function onPointerUp() {
  if (!dragging.value) return
  dragging.value = false
  if (dragMoved) {
    const forward = dragX.value < 0
    const raw = Math.abs(dragX.value) / stepPx(forward)
    const single = isSingleCard()
    /* 手机端一次手势最多切一张，避免步长失真时直接跳到首/尾 */
    const steps = raw < (single ? 0.2 : 0.25) ? 0 : single ? 1 : Math.max(1, Math.round(raw))
    go(activeIndex.value + (forward ? steps : -steps))
  }
  dragX.value = 0
}

/* 没越过 8px 就捕获不到指针，此时若在轮播外松手，pointerup 不会回到这里；
   不补这一下 dragging 会一直为真，鼠标悬停就能拖着整排卡片走 */
function onPointerLeave() {
  if (!dragging.value || dragMoved) return
  dragging.value = false
  dragX.value = 0
}
</script>

<style scoped>
/* 页头副标题按轮播稿降到 12px */
.fg-page :deep(.page-header .desc) {
  font-size: var(--fg-text-label);
}

.carousel {
  --center-w: 900px;
  --side-w: 300px;
  --card-h: 600px;
  /* 上半区收窄：照片 220 见方，把高度让给下方的方案与提醒 */
  --photo: 220px;
  --pad-card: 32px;
  --gap: 24px;
  --pad: 90px;
  --vp-h: 640px;
  /* 邻卡只露 ~58px，淡出带再宽就把整条吃掉了 */
  --fade: 24px;

  margin-top: var(--fg-s6);
}

/* scale 会把内侧边缘一起缩走，定住原点让左右露出的宽度对称 */
.pet-card.before {
  transform-origin: right center;
}

.pet-card:not(.active):not(.before) {
  transform-origin: left center;
}

.stage {
  position: relative;
  max-width: 1080px;
  margin: 0 auto;
}

.viewport {
  height: var(--vp-h);
  overflow: hidden;
  /* 侧卡只露一条，边缘淡出到纸色，避免硬切 */
  mask-image: linear-gradient(
    90deg,
    transparent 0,
    #000 var(--fade, 56px),
    #000 calc(100% - var(--fade, 56px)),
    transparent 100%
  );
  -webkit-mask-image: linear-gradient(
    90deg,
    transparent 0,
    #000 var(--fade, 56px),
    #000 calc(100% - var(--fade, 56px)),
    transparent 100%
  );
}

.track {
  display: flex;
  align-items: center;
  gap: var(--gap);
  width: max-content;
  height: 100%;
  padding-inline: var(--pad);
  transform: translateX(
    calc(var(--active) * (var(--side-w) + var(--gap)) * -1 + var(--drag, 0px))
  );
  transition: transform 320ms cubic-bezier(0.2, 0, 0, 1);
  cursor: grab;
  touch-action: pan-y;
}

.track.is-dragging {
  transition: none;
  cursor: grabbing;
}

.track:focus-visible {
  outline: 2px solid var(--fg-accent);
  outline-offset: -4px;
}

.pet-card {
  flex: 0 0 auto;
  display: flex;
  flex-direction: column;
  width: var(--side-w);
  height: var(--card-h);
  padding: var(--pad-card);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
  transform: scale(0.96);
  opacity: 0.5;
  transition:
    width 320ms cubic-bezier(0.2, 0, 0, 1),
    transform 320ms cubic-bezier(0.2, 0, 0, 1),
    opacity 320ms cubic-bezier(0.2, 0, 0, 1);
}

.pet-card.active {
  width: var(--center-w);
  transform: none;
  opacity: 1;
}

.pet-card:not(.active):hover {
  opacity: 0.65;
}

/* 上半区：照片占左上，资料与照片同高、上下沿对齐 */
.head {
  flex: 0 0 auto;
  display: grid;
  grid-template-columns: var(--photo) 1fr;
  gap: var(--pad-card);
  align-items: stretch;
  height: var(--photo);
}

.photo {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: var(--fg-accent-soft);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
}

.photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.initial {
  font-family: var(--fg-font-serif);
  font-size: 40px;
  font-weight: 600;
  color: var(--fg-accent);
  line-height: 1;
}

.facts {
  min-width: 0;
  display: flex;
  flex-direction: column;
  padding: var(--fg-s2) 0;
}

.facts-hd {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s3);
  min-width: 0;
}

.name {
  margin: 0;
  min-width: 0;
  font-family: var(--fg-font-serif);
  font-size: 28px;
  font-weight: 600;
  letter-spacing: -0.02em;
  line-height: 1.2;
  color: var(--fg-ink);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.meta {
  margin: var(--fg-s2) 0 0;
  font-size: 13px;
  line-height: 1.5;
  color: var(--fg-ink-muted);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.stats {
  display: grid;
  grid-template-columns: 1fr 1fr 1.2fr;
  gap: var(--fg-s4);
  /* 名字与简介贴顶，资料表贴底压到照片底边 */
  margin: auto 0 0;
  padding-top: var(--fg-s3);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.stat {
  min-width: 0;
}

.stat-v {
  margin: var(--fg-s1) 0 0;
  display: flex;
  align-items: baseline;
  gap: var(--fg-s1);
  min-width: 0;
  overflow: hidden;
  font-size: 18px;
  color: var(--fg-ink);
  white-space: nowrap;
}

.stat-v .fg-num {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
}

.bcs-ok {
  color: var(--fg-accent);
}

.bcs-warn {
  color: var(--fg-warning);
}

/* 下半区：营养方案与每日提醒并列，占据卡片主要高度 */
.panels {
  flex: 1 1 auto;
  min-height: 0;
  display: grid;
  grid-template-columns: 1fr 1fr;
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.panel {
  min-width: 0;
  display: flex;
  flex-direction: column;
  padding-inline: var(--fg-s5);
}

.panel:first-child {
  padding-left: 0;
}

/* 栏位变高后加一条竖向 hairline，避免读成两块漂浮的内容 */
.panel + .panel {
  padding-right: 0;
  border-left: var(--fg-line-w) solid var(--fg-line);
}

.panel-hd {
  flex: 0 0 auto;
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s3);
}

/* 标题钉在栏顶，内容在剩余高度里垂直居中，两栏标题因此始终齐平 */
.panel-body {
  flex: 1 1 auto;
  min-height: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.panel-tt {
  margin: 0;
  font-family: var(--fg-font-serif);
  font-size: 15px;
  font-weight: 600;
  color: var(--fg-ink);
}

/* 文字按钮压掉组件默认内边距，让它和标题在同一基线上 */
.flat-btn {
  flex: 0 0 auto;
  min-height: 0;
  height: auto;
  padding: 0;
  font-size: var(--fg-text-label);
}

.food-line {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  min-width: 0;
  margin: 0 0 var(--fg-s3);
  color: var(--fg-ink-muted);
}

.food-name {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 13px;
  color: var(--fg-ink);
}

.est-tag {
  flex: 0 0 auto;
  padding: 0 var(--fg-s2);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
}

.cells {
  flex: 0 0 auto;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--fg-s4) var(--fg-s5);
  margin: 0;
}

.cell {
  min-width: 0;
}

.cell-v {
  margin: 0;
  display: flex;
  align-items: baseline;
  gap: var(--fg-s1);
  font-size: 18px;
  color: var(--fg-ink);
  white-space: nowrap;
}

.warn-list {
  display: flex;
  flex-direction: column;
}

.warn-line {
  flex: 0 0 auto;
  display: flex;
  align-items: flex-start;
  gap: var(--fg-s2);
  margin: var(--fg-s3) 0 0;
  color: var(--fg-warning);
}

.warn-more {
  align-self: flex-start;
  margin-top: var(--fg-s2);
}

.warn-text {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.panel-note {
  margin: 0;
  font-size: 13px;
  line-height: 1.6;
  color: var(--fg-ink-muted);
}

.rem-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

/* 展开后条目可能高过卡片固定高度，超出部分就地滚动而不是被裁掉 */
.rem-list.is-open,
.warn-list.is-open {
  flex: 0 1 auto;
  min-height: 0;
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: var(--fg-line) transparent;
}

.rem-list.is-open::-webkit-scrollbar,
.warn-list.is-open::-webkit-scrollbar {
  width: 4px;
}

.rem-list.is-open::-webkit-scrollbar-thumb,
.warn-list.is-open::-webkit-scrollbar-thumb {
  border-radius: 2px;
  background: var(--fg-line);
}

.rem {
  display: flex;
  align-items: baseline;
  gap: var(--fg-s3);
  min-width: 0;
  padding: var(--fg-s3) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.rem:last-child {
  border-bottom: 0;
}

.rem-time {
  flex: 0 0 auto;
  width: 46px;
  font-size: 14px;
  color: var(--fg-accent);
}

.rem-title {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 13px;
  color: var(--fg-ink);
}

.rem-rule {
  flex: 0 0 auto;
  margin-left: auto;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

/* 行内 baseline 对齐下，圆形按钮要单独回到视觉中线 */
.rem-check {
  flex: 0 0 auto;
  align-self: center;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  padding: 0;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 50%;
  background: transparent;
  color: var(--fg-line);
  cursor: pointer;
  transition: border-color 0.16s ease, background-color 0.16s ease, color 0.16s ease;
}

.rem-check:hover:not(:disabled) {
  border-color: var(--fg-accent);
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
}

.rem-check:disabled {
  cursor: default;
}

.rem-check.is-done {
  border-color: var(--fg-accent);
  background: var(--fg-accent);
  color: #fff;
}

.rem.is-done .rem-title {
  color: var(--fg-ink-muted);
}

.rem-more {
  align-self: flex-start;
  margin-top: var(--fg-s2);
}

.nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 2;
  width: 40px;
  height: 40px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  background: transparent;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 50%;
  color: var(--fg-ink);
  cursor: pointer;
  transition:
    border-color var(--fg-motion),
    color var(--fg-motion);
}

.nav-prev {
  left: 0;
}

.nav-next {
  right: 0;
}

.nav:hover:not(:disabled) {
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.nav:disabled {
  color: var(--fg-line);
  cursor: default;
}

.pager {
  display: flex;
  justify-content: center;
  margin-top: var(--fg-s5);
}

.dots {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.dot {
  width: 6px;
  height: 6px;
  padding: 0;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 50%;
  background: transparent;
  cursor: pointer;
  transition:
    background var(--fg-motion),
    border-color var(--fg-motion);
}

.dot.on {
  background: var(--fg-accent);
  border-color: var(--fg-accent);
}

.counter {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

/* 邻卡只留照片，露出的那一条本身就是照片 */
.pet-card:not(.active) .head {
  grid-template-columns: 1fr;
  height: 100%;
}

.pet-card:not(.active) .facts,
.pet-card:not(.active) .panels {
  display: none;
}

/* 骨架：同尺寸同描边，不做 shimmer */
.is-skeleton {
  cursor: default;
}

.sk {
  background: var(--fg-paper);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
}

.sk-line {
  height: 16px;
  margin-top: var(--fg-s4);
}

.sk-stats {
  height: 46px;
}

.sk-block {
  height: 92px;
  margin-top: var(--fg-s3);
}

.is-skeleton .sk:first-child {
  margin-top: 0;
}

.panel-hd .sk-line {
  margin-top: 0;
}

.callout-text {
  margin: 0;
}

.first-btn {
  margin-top: var(--fg-s4);
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
  border: 0;
}

@media (max-width: 1199px) {
  .carousel {
    --center-w: 640px;
    --side-w: 240px;
    --card-h: 520px;
    --photo: 180px;
    --pad-card: 24px;
    --gap: 20px;
    --pad: 60px;
    --vp-h: 560px;
    --fade: 40px;
  }

  .name {
    font-size: 24px;
  }
}

@media (max-width: 1023px) {
  .carousel {
    --center-w: 520px;
    --photo: 160px;
    --pad: 40px;
  }
}

@media (max-width: 767px) {
  .carousel {
    --center-w: calc(100vw - var(--fg-s6));
    --side-w: 0px;
    --card-h: auto;
    --photo: 110px;
    --pad-card: 16px;
    --gap: 0px;
    --pad: 0px;
    --vp-h: auto;
  }

  .viewport {
    height: auto;
    mask-image: none;
    -webkit-mask-image: none;
  }

  .pet-card {
    height: auto;
    padding: var(--fg-s5);
  }

  .head {
    grid-template-columns: var(--photo) 1fr;
    height: var(--photo);
  }

  .facts {
    padding: 0;
  }

  .panels {
    grid-template-columns: 1fr;
    gap: var(--fg-s5);
  }

  /* 单列时竖向分隔线要换成横向 */
  .panel,
  .panel:first-child,
  .panel + .panel {
    padding-inline: 0;
  }

  .panel + .panel {
    padding-top: var(--fg-s5);
    border-left: 0;
    border-top: var(--fg-line-w) solid var(--fg-line);
  }

  /* 窄屏一次只看一张；隐藏卡必须连 padding/border 一起收掉，
     否则 width:0 仍会占 34px，后面的卡片会被挤到右侧 */
  .pet-card:not(.active) {
    width: 0;
    padding: 0;
    border-width: 0;
    opacity: 0;
    pointer-events: none;
  }

  .nav {
    display: none;
  }
}

@media (hover: none) {
  .nav {
    display: none;
  }
}

/* ============================================================
   响应式新增：<768px 手机端细化
   桌面端（>=768px）不受影响
   ============================================================ */
@media (max-width: 767.98px) {
  .carousel {
    margin-top: var(--fg-s5);
  }

  .pet-card {
    padding: var(--fg-s4);
  }

  /* 照片缩到 96px，资料区留出足够宽度 */
  .head {
    grid-template-columns: 96px minmax(0, 1fr);
    gap: var(--fg-s3);
    height: auto;
  }

  .photo {
    width: 96px;
    height: 96px;
  }

  .facts {
    padding: 0;
  }

  .name {
    font-size: 22px;
  }

  .meta {
    font-size: 12px;
  }

  /* 三项指标改为两列，「最近更新」独占一行 */
  .stats {
    grid-template-columns: 1fr 1fr;
    gap: var(--fg-s2) var(--fg-s3);
    padding-top: var(--fg-s2);
  }

  .stats .stat:last-child {
    grid-column: 1 / -1;
  }

  .stat-v {
    font-size: 16px;
  }

  .panels {
    gap: var(--fg-s4);
    margin-top: var(--fg-s4);
    padding-top: var(--fg-s4);
  }

  .panel + .panel {
    padding-top: var(--fg-s4);
  }

  .cells {
    gap: var(--fg-s3) var(--fg-s4);
  }

  .cell-v {
    font-size: 16px;
  }

  .rem {
    gap: var(--fg-s2);
  }

  .rem-time {
    width: 42px;
    font-size: 13px;
  }

  /* 圆形打卡键视觉仍为 22px，用伪元素把点击热区扩到 44px */
  .rem-check {
    position: relative;
  }

  .rem-check::after {
    content: '';
    position: absolute;
    inset: -11px;
    border-radius: 50%;
  }

  .pager {
    margin-top: var(--fg-s4);
  }
}

@media (prefers-reduced-motion: reduce) {
  .track,
  .pet-card {
    transition: none;
  }
}
</style>
