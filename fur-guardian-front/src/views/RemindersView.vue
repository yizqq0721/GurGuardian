<template>
  <div class="fg-page">
    <PageHeader
      title="提醒管理"
      :breadcrumb="scopeLabel"
      description="把喂食、遛弯、护理排进一天的时间轴，完成一项就打一次卡。"
    >
      <template #actions>
        <div class="day-nav" role="group" aria-label="切换日期">
          <button class="day-btn" type="button" :disabled="!canPrev" aria-label="前一天" @click="shiftDate(-1)">
            <ChevronLeft :size="20" class="fg-icon" />
          </button>
          <p class="day-label">
            <span class="day-date">{{ viewDateLabel }}</span>
            <span v-if="isToday" class="fg-muted day-tag">今天</span>
            <span v-else class="fg-muted day-tag">回顾</span>
          </p>
          <button class="day-btn" type="button" :disabled="!canNext" aria-label="后一天" @click="shiftDate(1)">
            <ChevronRight :size="20" class="fg-icon" />
          </button>
        </div>

        <span class="head-divider" aria-hidden="true" />

        <p class="fg-mono streak">
          <Flame :size="20" class="fg-icon" />
          <span>连续</span>
          <span class="streak-num">{{ streak }}</span>
          <span>天</span>
        </p>

        <el-button @click="goCalendar">
          <CalendarDays :size="20" class="fg-icon" />查看待办日历
        </el-button>

        <el-button type="primary" :disabled="!petStore.currentPet" @click="openCreate">
          <Plus :size="20" class="fg-icon" />新建提醒
        </el-button>
      </template>
    </PageHeader>

    <EmptyState v-if="!petStore.currentPet" variant="pets" description="请先创建宠物档案，再安排每日提醒">
      <el-button type="primary" @click="router.push('/onboarding')">去创建</el-button>
    </EmptyState>

    <template v-else>
      <section class="toolbar">
        <span class="fg-label">查看宠物</span>
        <el-radio-group v-model="filterPetId" size="small" @change="onFilterChange">
          <el-radio-button :value="undefined">全部</el-radio-button>
          <el-radio-button v-for="p in petStore.pets" :key="p.id" :value="p.id">{{ p.name }}</el-radio-button>
        </el-radio-group>
        <el-checkbox v-model="onlyToday" class="todo-check" size="small">只看今日待办</el-checkbox>
      </section>

      <div class="fg-split">
        <!-- 时间轴主体 -->
        <div class="main-col">
          <section v-loading="loading" class="fg-card tl-card">
            <header class="tl-head">
              <h2 class="fg-section-title">当日时间轴</h2>
              <p class="fg-muted tl-progress">
                共 <span class="fg-num">{{ shownTotal }}</span> 项 · 已完成
                <span class="fg-num">{{ shownDone }}</span> 项
              </p>
            </header>

            <p v-if="loadError" class="fg-callout fg-callout--danger">
              提醒列表加载失败，请检查网络后重试。
              <button class="link-btn" type="button" @click="fetchReminders">重新加载</button>
            </p>

            <p v-else-if="!isToday" class="fg-callout">
              正在回顾 {{ viewDateLabel }} 的完成情况，打卡仅在今天有效。
            </p>

            <div v-for="group in timelineGroups" :key="group.key" class="tl-group">
              <p class="fg-label tl-group-label">{{ group.label }}</p>
              <ul class="tl">
                <li
                  v-for="r in group.rows"
                  :key="r.id"
                  class="tl-row"
                  :class="{ 'is-done': isDone(r.id) }"
                >
                  <div class="tl-time">
                    <span :class="r.remindTime ? 'fg-num time-text' : 'time-text time-alt'">{{ rowTime(r) }}</span>
                  </div>
                  <span class="tl-marker" aria-hidden="true"><span class="tl-dot" /></span>

                  <el-checkbox
                    class="tl-check"
                    :model-value="isDone(r.id)"
                    :disabled="!isToday || isDone(r.id)"
                    :aria-label="`打卡：${r.title}`"
                    @change="onCheck(r)"
                  />

                  <div class="tl-body">
                    <p class="tl-title">
                      <component :is="iconFor(r.reminderType)" :size="20" class="fg-icon tl-ico" />
                      <span class="tl-name">{{ r.title }}</span>
                    </p>
                    <p class="tl-meta">
                      <span class="fg-muted meta-text">{{ typeLabel(r) }} · {{ petName(r.petId) }}</span>
                      <span v-if="isDatedReminder(r)" class="fg-chip">
                        计划 {{ dateText(r.remindDate, 'M月D日') }}
                      </span>
                      <span v-else class="fg-chip">
                        {{ repeatLabel(r) }}<template v-if="r.repeatDays">（{{ repeatDaysText(r.repeatDays) }}）</template>
                      </span>
                      <span v-if="r.relativeMin != null" class="fg-chip">饭后 {{ r.relativeMin }} 分钟</span>
                    </p>
                    <p v-if="hasRowLinks(r)" class="tl-links">
                      <button
                        v-if="r.reminderType === 'FEED'"
                        type="button"
                        class="tl-link"
                        @click="openFeedDialog(r)"
                      >
                        <UtensilsCrossed :size="14" class="fg-icon" />记录喂食
                      </button>
                      <template v-if="r.reminderType === 'WALK'">
                        <button type="button" class="tl-link" @click="goNearby(r)">
                          <MapPin :size="14" class="fg-icon" />找遛弯点
                        </button>
                        <span
                          v-if="isToday && weather"
                          class="tl-weather"
                          :class="`is-${weather.level.toLowerCase()}`"
                        >
                          <component :is="weatherIcon(weather)" :size="14" class="fg-icon" />
                          <span class="fg-num">{{ weather.low }}~{{ weather.high }}°C</span>
                          <span>{{ weather.text }}</span>
                          <span class="tl-weather-advice">{{ weather.advice }}</span>
                        </span>
                        <span v-else-if="isToday && weatherState === 'loading'" class="tl-weather is-loading">
                          正在获取今日天气…
                        </span>
                        <button
                          v-else-if="isToday && userStore.location"
                          type="button"
                          class="tl-link"
                          @click="maybeLoadWeather(true)"
                        >
                          <CloudSun :size="14" class="fg-icon" />
                          {{ weatherActionText }}
                        </button>
                        <router-link
                          v-else-if="isToday"
                          class="tl-link"
                          to="/profile"
                        >
                          <MapPin :size="14" class="fg-icon" />获取当前位置
                        </router-link>
                      </template>
                      <button
                        v-if="knowledgePromptFor(r)"
                        type="button"
                        class="tl-link"
                        @click="askKnowledge(r)"
                      >
                        <ArrowUpRight :size="14" class="fg-icon" />问一问
                      </button>
                    </p>
                  </div>

                  <el-dropdown trigger="click" class="tl-more" @command="onRowCommand($event, r)">
                    <button class="more-btn" type="button" aria-label="更多操作">
                      <MoreHorizontal :size="20" class="fg-icon" />
                    </button>
                    <template #dropdown>
                      <el-dropdown-menu>
                        <el-dropdown-item command="edit">编辑</el-dropdown-item>
                        <el-dropdown-item command="remove">删除</el-dropdown-item>
                      </el-dropdown-menu>
                    </template>
                  </el-dropdown>
                </li>
              </ul>
            </div>

            <EmptyState
              v-if="!loading && !loadError && !shownTotal"
              variant="default"
              :description="
                reminders.length === 0
                  ? '还没有提醒，点击「新建提醒」安排第一项'
                  : onlyToday
                    ? '今日待办已全部完成'
                    : '这一天没有到期的提醒'
              "
            />
          </section>

          <section v-if="upcomingEvents.length" class="fg-card upcoming-card">
            <header class="tl-head">
              <h2 class="fg-section-title">接下来的日程</h2>
              <p class="fg-muted tl-progress">疫苗、驱虫按设定日期提醒一次</p>
            </header>

            <ul class="upcoming-list">
              <li v-for="r in upcomingEvents" :key="r.id" class="upcoming-row">
                <span class="upcoming-date fg-num">{{ dateText(r.remindDate, 'M月D日') }}</span>
                <span class="upcoming-week fg-muted">周{{ weekName(r.remindDate) }}</span>
                <span class="upcoming-title">{{ r.title }}</span>
                <span class="upcoming-meta fg-muted">
                  {{ typeLabel(r) }} · {{ petName(r.petId) }}<template v-if="r.remindTime"> · {{ r.remindTime.slice(0, 5) }}</template>
                </span>
                <span class="fg-chip">{{ daysUntil(r.remindDate) }}</span>
              </li>
            </ul>
          </section>
        </div>

        <!-- 侧栏：本周完成度 -->
        <aside class="aside-col">
          <section class="fg-card">
            <h2 class="fg-section-title">本周完成率</h2>

            <StatTile
              label="今日完成"
              :value="todayRate"
              unit="%"
              :caption="`已打卡 ${doneToday} 项 / 共 ${dueTodayReminders.length} 项`"
            />

            <div class="fg-divider" />

            <div class="bars" role="img" :aria-label="`近 7 天每日完成提醒项数：${barsAria}`">
              <div
                v-for="d in weekDays"
                :key="d.date"
                class="bar-col"
                :class="{ 'is-viewed': d.date === viewDate }"
              >
                <span class="bar-count fg-num">{{ d.count || '—' }}</span>
                <span class="bar-track">
                  <span class="bar-fill" :class="{ 'is-zero': d.count === 0 }" :style="{ height: barHeight(d.count) }" />
                </span>
                <span class="bar-day">{{ d.weekday }}</span>
              </div>
            </div>
            <p class="bar-note fg-muted">柱高按当日已完成的提醒条目数，单位：项</p>
          </section>

          <section class="fg-card">
            <h2 class="fg-section-title">打卡概览</h2>
            <div class="kv-list">
              <div class="fg-kv">
                <span class="fg-label">近 7 天累计</span>
                <span class="fg-num kv-value">{{ weekTotal }} 项</span>
              </div>
              <div class="fg-kv">
                <span class="fg-label">有打卡的天数</span>
                <span class="fg-num kv-value">{{ activeDays }} 天</span>
              </div>
              <div class="fg-kv">
                <span class="fg-label">连续打卡</span>
                <span class="fg-num kv-value">{{ streak }} 天</span>
              </div>
              <div class="fg-kv">
                <span class="fg-label">提醒条目</span>
                <span class="fg-num kv-value">{{ reminders.length }} 项</span>
              </div>
            </div>
          </section>
        </aside>
      </div>

      <div class="drawer-host">
        <el-drawer
          v-model="drawerVisible"
          direction="rtl"
          size="480px"
          :title="editingId ? '编辑提醒' : '新建提醒'"
        >
          <el-form label-position="top" class="drawer-form">
            <el-form-item label="提醒标题" required>
              <el-input v-model="form.title" placeholder="例如：早餐 / 晚间遛弯" maxlength="30" />
            </el-form-item>

            <el-form-item label="类型" required>
              <el-select v-model="form.reminderType" style="width: 100%" @change="onTypeChange">
                <el-option v-for="o in REMINDER_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>

            <el-form-item label="关联宠物" required>
              <el-select v-model="form.petId" style="width: 100%">
                <el-option v-for="p in petStore.pets" :key="p.id" :value="p.id" :label="p.name" />
              </el-select>
            </el-form-item>

            <el-form-item v-if="!formIsEvent" label="提醒方式">
              <el-radio-group v-model="timeMode">
                <el-radio-button value="fixed">固定时间</el-radio-button>
                <el-radio-button value="relative">相对时间（饭后）</el-radio-button>
              </el-radio-group>
            </el-form-item>

            <el-form-item v-if="formIsEvent || timeMode === 'fixed'" label="提醒时间">
              <el-time-picker v-model="form.remindTime" format="HH:mm" value-format="HH:mm" class="time-pick" />
            </el-form-item>

            <el-form-item v-if="!formIsEvent && timeMode === 'relative'" label="饭后多少分钟">
              <el-input-number v-model="form.relativeMin" :min="5" :max="240" :step="5" />
              <span class="fg-muted num-hint">如「饭后 30 分钟」遛狗，防胃扭转</span>
            </el-form-item>

            <el-form-item v-if="!formIsEvent" label="重复规则">
              <el-select v-model="form.repeatRule" style="width: 100%">
                <el-option v-for="o in REPEAT_RULE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>

            <el-form-item v-if="!formIsEvent && form.repeatRule === 'WEEKLY'" label="重复日">
              <el-checkbox-group v-model="weekdayChecks">
                <el-checkbox
                  v-for="(label, i) in ['一','二','三','四','五','六','日']"
                  :key="i"
                  class="weekday-check"
                  :value="String(i + 1)"
                >
                  {{ label }}
                </el-checkbox>
              </el-checkbox-group>
            </el-form-item>

            <el-form-item v-if="formIsDated" label="计划日期" required>
              <el-date-picker
                v-model="form.remindDate"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="选择要做这件事的日期"
                :disabled-date="pastDateDisabled"
                style="width: 100%"
              />
              <span class="fg-muted num-hint">
                {{ formIsEvent ? '疫苗、驱虫这类事件按日期提醒一次，不会周期重复' : '仅一次的提醒只在这一天出现' }}
              </span>
            </el-form-item>

            <div
              v-if="form.reminderType === 'WALK'"
              class="wx-panel"
              :class="weather ? `is-${weather.level.toLowerCase()}` : ''"
            >
              <component
                :is="weather ? weatherIcon(weather) : CloudSun"
                :size="18"
                class="fg-icon wx-ico"
              />
              <div class="wx-body">
                <p class="wx-title">今日遛弯天气</p>
                <p v-if="weather" class="wx-text">
                  {{ weather.location }} · {{ weather.text
                  }}<template v-if="weather.textNight && weather.textNight !== weather.text">转{{ weather.textNight }}</template>
                  <span class="wx-temp fg-num">{{ weather.low }}~{{ weather.high }}°C</span>
                  <span class="wx-meta">
                    {{ weather.windDirection }}风{{ weather.windScale }}级<template v-if="weather.humidity"> · 湿度 {{ weather.humidity }}%</template>
                  </span>
                  <span class="wx-advice">{{ weather.advice }}</span>
                </p>
                <p v-if="weather" class="wx-source">
                  按当前位置「{{ userStore.location }}」查询 · <router-link to="/profile">重新定位</router-link>
                </p>
                <p v-else-if="weatherState === 'loading'" class="wx-text">正在获取今日天气…</p>
                <p v-else class="wx-text">
                  {{ weatherEmptyText }}
                  <button v-if="userStore.location" type="button" class="wx-link" @click="maybeLoadWeather(true)">重新获取天气</button>
                  <router-link v-else class="wx-link" to="/profile">去获取位置</router-link>
                </p>
              </div>
            </div>
          </el-form>

          <template #footer>
            <el-button @click="drawerVisible = false">取消</el-button>
            <el-button type="primary" :loading="saving" @click="save">保存</el-button>
          </template>
        </el-drawer>
      </div>

      <el-dialog v-model="feedOpen" class="feed-dialog" width="480px" title="记录这次喂食">
        <p class="feed-context">
          <UtensilsCrossed :size="16" class="fg-icon" />
          <span>{{ feedRow?.title }} · {{ feedRow ? petName(feedRow.petId) : '' }}</span>
        </p>

        <el-form label-position="top" class="feed-form">
          <el-form-item label="从食品库选择">
            <el-select
              v-model="feedFoodId"
              filterable
              placeholder="搜索或选择食品"
              style="width: 100%"
              :loading="feedFoodLoading"
            >
              <el-option v-for="f in feedFoodOptions" :key="f.id" :value="f.id" :label="f.name">
                <span class="feed-option-name">{{ f.name }}</span>
                <span v-if="f.brand" class="feed-option-brand">{{ f.brand }}</span>
              </el-option>
            </el-select>
            <p v-if="!feedFoodLoading && !feedFoodOptions.length" class="feed-empty fg-muted">
              食品库还没有适合{{ feedPetLabel }}的食品。
              <button type="button" class="feed-go" @click="goFoods">先去录入</button>
            </p>
          </el-form-item>

          <el-form-item label="实际吃了多少克">
            <div class="feed-grams">
              <el-input-number v-model="feedGrams" :min="1" :max="2000" :step="5" controls-position="right" />
              <span v-if="feedKcal != null" class="fg-muted feed-kcal">
                按标注值约 <span class="fg-num">{{ feedKcal }}</span> kcal
              </span>
            </div>
          </el-form-item>
        </el-form>

        <template #footer>
          <el-button @click="feedOpen = false">取消</el-button>
          <el-button :loading="feedSaving" @click="checkinOnly">仅打卡</el-button>
          <el-button type="primary" :loading="feedSaving" :disabled="!feedFoodId" @click="saveFeedAndCheckin">
            保存并打卡
          </el-button>
        </template>
      </el-dialog>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import type { Component } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'
import {
  ArrowUpRight,
  Bath,
  Bell,
  Brush,
  CalendarDays,
  ChevronLeft,
  ChevronRight,
  CloudLightning,
  CloudRain,
  CloudSun,
  Droplets,
  Flame,
  Footprints,
  MapPin,
  MoreHorizontal,
  Pill,
  Plus,
  Snowflake,
  Sun,
  Syringe,
  UtensilsCrossed,
  Wind,
} from 'lucide-vue-next'
import { reminderApi } from '@/api/reminder'
import { foodApi } from '@/api/food'
import { feedingApi } from '@/api/feeding'
import { weatherApi } from '@/api/weather'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import StatTile from '@/components/StatTile.vue'
import { usePetStore } from '@/stores/pet'
import { useUserStore } from '@/stores/user'
import { dateText } from '@/utils/format'
import { readSavedGeo } from '@/utils/geo'
import { isDatedReminder, isDatedType, isReminderDueOn } from '@/utils/reminder'
import {
  REMINDER_TYPE_LABEL,
  REMINDER_TYPE_OPTIONS,
  REPEAT_RULE_LABEL,
  REPEAT_RULE_OPTIONS,
} from '@/utils/constants'
import type { Food, Reminder, ReminderLog, ReminderType, RepeatRule, SpeciesScope, WeatherToday } from '@/types'

const router = useRouter()
const route = useRoute()
const petStore = usePetStore()
const userStore = useUserStore()

const loading = ref(false)
const loadError = ref(false)
const saving = ref(false)
const reminders = ref<Reminder[]>([])
const logs = ref<ReminderLog[]>([])
const optimisticChecked = ref<Set<number>>(new Set())
/* 宠物卡片上的「提醒管理」用 ?pet= 指明是哪只，从顶栏进入时保持「全部」 */
const petFromQuery = Number(route.query.pet)
const filterPetId = ref<number | undefined>(
  Number.isInteger(petFromQuery) && petFromQuery > 0 ? petFromQuery : undefined,
)
const onlyToday = ref(false)

/** 遛弯天气只对今天有意义；有关联定位坐标时按坐标查询，否则按已保存的位置查询 */
const weather = ref<WeatherToday | null>(null)
const weatherState = ref<'idle' | 'loading' | 'ready' | 'unavailable'>('idle')

const drawerVisible = ref(false)
const editingId = ref<number | null>(null)
const timeMode = ref<'fixed' | 'relative'>('fixed')
const weekdayChecks = ref<string[]>([])

const feedOpen = ref(false)
const feedRow = ref<Reminder | null>(null)
const feedFoods = ref<Food[]>([])
const feedFoodId = ref<number>()
const feedGrams = ref(60)
const feedFoodLoading = ref(false)
const feedSaving = ref(false)

/** 打卡的是哪只宠物，就只给它能吃的粮：未标注的按通用处理，DOG/CAT 互斥 */
const feedPetScope = computed<SpeciesScope | null>(() => {
  const pet = petStore.pets.find((p) => p.id === feedRow.value?.petId)
  if (!pet) return null
  return pet.species === 'dog' ? 'DOG' : 'CAT'
})

const feedPetLabel = computed(() => {
  if (feedPetScope.value === 'CAT') return '猫咪'
  if (feedPetScope.value === 'DOG') return '狗狗'
  return '宠物'
})

const feedFoodOptions = computed(() => {
  const scope = feedPetScope.value
  if (!scope) return feedFoods.value
  return feedFoods.value.filter(
    (f) => !f.speciesScope || f.speciesScope === 'BOTH' || f.speciesScope === scope,
  )
})

const feedSelectedFood = computed(() => feedFoodOptions.value.find((f) => f.id === feedFoodId.value))

const feedKcal = computed(() => {
  const food = feedSelectedFood.value
  if (!food?.labeledMeKcal) return null
  return Math.round((food.labeledMeKcal * feedGrams.value) / 100) / 10
})

/** 时间轴可回顾的窗口 = 打卡日志已拉取的近 7 天，不额外请求接口 */
const WEEKDAY_CN = ['日', '一', '二', '三', '四', '五', '六']
const windowStart = dayjs().subtract(6, 'day').startOf('day')
const viewDate = ref(dayjs().format('YYYY-MM-DD'))

const form = reactive({
  petId: 0,
  title: '',
  reminderType: 'FEED' as ReminderType,
  remindTime: '08:00',
  relativeMin: 30,
  remindDate: dayjs().format('YYYY-MM-DD'),
  repeatRule: 'DAILY' as RepeatRule,
})

/** 疫苗、驱虫不再提供周期选项，只选一个执行日期 */
const formIsEvent = computed(() => isDatedType(form.reminderType))
const formIsDated = computed(() => formIsEvent.value || form.repeatRule === 'ONCE')

function onTypeChange(type: ReminderType) {
  if (isDatedType(type)) {
    form.repeatRule = 'ONCE'
    timeMode.value = 'fixed'
  } else if (form.repeatRule === 'ONCE') {
    form.repeatRule = 'DAILY'
  }
  if (type === 'WALK') void maybeLoadWeather(true)
}

function pastDateDisabled(date: Date) {
  return !editingId.value && dayjs(date).isBefore(dayjs().startOf('day'))
}

const checkedIds = computed(() => {
  const today = dayjs().format('YYYY-MM-DD')
  const set = new Set(logs.value.filter((l) => l.doneDate === today).map((l) => l.reminderId))
  optimisticChecked.value.forEach((id) => set.add(id))
  return set
})

const isToday = computed(() => viewDate.value === dayjs().format('YYYY-MM-DD'))

/** 所选日期已打卡的提醒 id：历史日期只读，只反映当天日志 */
const viewDoneIds = computed(() => {
  const set = new Set(logs.value.filter((l) => l.doneDate === viewDate.value).map((l) => l.reminderId))
  if (isToday.value) optimisticChecked.value.forEach((id) => set.add(id))
  return set
})

/** 一次性事件只在计划日期出现，周期提醒沿用每天可见 */
const viewDueReminders = computed(() =>
  reminders.value.filter((r) => isReminderDueOn(r, viewDate.value)),
)

const filteredReminders = computed(() => {
  if (!onlyToday.value) return viewDueReminders.value
  return viewDueReminders.value.filter((r) => !checkedIds.value.has(r.id))
})

/** 定时提醒按真实时间排序；餐后与未设置时间的提醒各成一段，时间轴不伪造钟点 */
const timelineGroups = computed(() => {
  const list = filteredReminders.value
  const timed = list
    .filter((r) => !!r.remindTime)
    .sort((a, b) => (a.remindTime as string).localeCompare(b.remindTime as string))
  const relative = list.filter((r) => !r.remindTime && r.relativeMin != null)
  const unset = list.filter((r) => !r.remindTime && r.relativeMin == null)

  const groups: { key: string; label: string; rows: Reminder[] }[] = []
  if (timed.length) groups.push({ key: 'timed', label: '定时提醒', rows: timed })
  if (relative.length) groups.push({ key: 'relative', label: '餐后提醒', rows: relative })
  if (unset.length) groups.push({ key: 'unset', label: '未设置时间', rows: unset })
  return groups
})

const shownRows = computed(() => timelineGroups.value.flatMap((g) => g.rows))
const shownTotal = computed(() => shownRows.value.length)
const shownDone = computed(() => shownRows.value.filter((r) => viewDoneIds.value.has(r.id)).length)

/** 今日口径只算今天到期的提醒，未来的一次性事件不占今日待办 */
const dueTodayReminders = computed(() =>
  reminders.value.filter((r) => isReminderDueOn(r, dayjs().format('YYYY-MM-DD'))),
)

const doneToday = computed(() =>
  dueTodayReminders.value.filter((r) => checkedIds.value.has(r.id)).length,
)

const todayRate = computed(() =>
  dueTodayReminders.value.length
    ? Math.round((doneToday.value / dueTodayReminders.value.length) * 100)
    : 0,
)

const upcomingEvents = computed(() =>
  reminders.value
    .filter((r) => isDatedReminder(r) && (r.remindDate ?? '') > dayjs().format('YYYY-MM-DD'))
    .sort((a, b) => (a.remindDate ?? '').localeCompare(b.remindDate ?? ''))
    .slice(0, 5),
)

function weekName(date?: string) {
  return date ? WEEKDAY_CN[dayjs(date).day()] : ''
}

function daysUntil(date?: string) {
  if (!date) return ''
  const days = dayjs(date).startOf('day').diff(dayjs().startOf('day'), 'day')
  return days === 1 ? '明天' : `${days} 天后`
}

/** 按提醒条目去重后统计，避免同一提醒的多条日志把柱高与累计次数抬高 */
const doneIdsByDate = computed(() => {
  const map = new Map<string, Set<number>>()
  logs.value.forEach((l) => {
    const set = map.get(l.doneDate) ?? new Set<number>()
    set.add(l.reminderId)
    map.set(l.doneDate, set)
  })
  return map
})

const weekDays = computed(() => {
  return Array.from({ length: 7 }, (_, i) => {
    const d = dayjs().subtract(6 - i, 'day')
    const date = d.format('YYYY-MM-DD')
    return {
      date,
      label: i === 6 ? '今天' : d.format('MM-DD'),
      weekday: WEEKDAY_CN[d.day()],
      count: doneIdsByDate.value.get(date)?.size ?? 0,
    }
  })
})

const weekTotal = computed(() => weekDays.value.reduce((s, d) => s + d.count, 0))
const activeDays = computed(() => weekDays.value.filter((d) => d.count > 0).length)
const weekMax = computed(() => Math.max(1, ...weekDays.value.map((d) => d.count)))

/** 连续天数：从今天往回数，今天尚未打卡不打断已有连续 */
const streak = computed(() => {
  let n = 0
  for (let i = 0; i < 7; i += 1) {
    const date = dayjs().subtract(i, 'day').format('YYYY-MM-DD')
    const count = doneIdsByDate.value.get(date)?.size ?? 0
    if (count > 0) n += 1
    else if (i === 0) continue
    else break
  }
  return n
})

const barsAria = computed(() =>
  weekDays.value.map((d) => `${d.label} ${d.count} 项`).join('，'),
)

const scopeLabel = computed(() =>
  filterPetId.value == null
    ? `全部宠物 · ${petStore.pets.length} 只`
    : `${petName(filterPetId.value)} · 提醒`,
)

const viewDateLabel = computed(() => {
  const d = dayjs(viewDate.value)
  return `${d.month() + 1}月${d.date()}日 周${WEEKDAY_CN[d.day()]}`
})

const canPrev = computed(() => !dayjs(viewDate.value).subtract(1, 'day').isBefore(windowStart))
const canNext = computed(() => !isToday.value)

function shiftDate(delta: number) {
  const next = dayjs(viewDate.value).add(delta, 'day')
  if (next.isBefore(windowStart) || next.isAfter(dayjs(), 'day')) return
  viewDate.value = next.format('YYYY-MM-DD')
  void maybeLoadWeather(false)
}

function isDone(id: number) {
  return viewDoneIds.value.has(id)
}

function rowTime(r: Reminder) {
  if (r.remindTime) return r.remindTime
  return r.relativeMin != null ? '餐后' : '—'
}

function typeLabel(r: Reminder) {
  return REMINDER_TYPE_LABEL[r.reminderType] || r.reminderType
}

function repeatLabel(r: Reminder) {
  return REPEAT_RULE_LABEL[r.repeatRule || ''] || '每天'
}

function barHeight(count: number) {
  if (!count) return '2px'
  return `${Math.max(8, Math.round((count / weekMax.value) * 48))}px`
}

const REMINDER_TYPE_ICONS: Record<ReminderType, Component> = {
  FEED: UtensilsCrossed,
  WALK: Footprints,
  WATER: Droplets,
  GROOMING: Brush,
  DEWORM: Pill,
  VACCINE: Syringe,
  BATH: Bath,
  CUSTOM: Bell,
}

function iconFor(type: ReminderType): Component {
  return REMINDER_TYPE_ICONS[type] ?? Bell
}

/** 疫苗/驱虫的提醒类型直接落到知识库预设问题上 */
const KNOWLEDGE_PROMPTS: Partial<Record<ReminderType, string>> = {
  VACCINE: '犬猫疫苗接种前后需要注意什么？',
  DEWORM: '犬猫应该多久驱虫一次？驱虫前后要注意什么？',
}

function knowledgePromptFor(row: Reminder) {
  return KNOWLEDGE_PROMPTS[row.reminderType]
}

function hasRowLinks(row: Reminder) {
  if (row.reminderType === 'WALK') return true
  if (knowledgePromptFor(row)) return true
  return row.reminderType === 'FEED' && isToday.value && !isDone(row.id)
}

function weatherIcon(w: WeatherToday) {
  const text = `${w.text}${w.textNight ?? ''}`
  if (text.includes('雷')) return CloudLightning
  if (text.includes('雪')) return Snowflake
  if (text.includes('雨')) return CloudRain
  if (text.includes('晴')) return Sun
  if (text.includes('风') || Number(w.windScale) >= 5) return Wind
  return CloudSun
}

const weatherActionText = computed(() =>
  weatherState.value === 'unavailable' ? '重新获取天气' : '查看今日天气',
)

const weatherEmptyText = computed(() => {
  if (!userStore.location) return '还没获取当前位置，获取后就能查看当日遛弯天气。'
  if (weatherState.value === 'unavailable') return '按当前位置暂时取不到天气，请稍后重试或重新定位。'
  return '正在等待今日天气。'
})

/**
 * 未获取位置时不请求天气、也不主动申请定位，界面直接引导去用户信息获取；
 * interactive=true 允许用户在已有位置时手动重试。
 */
async function maybeLoadWeather(interactive = false) {
  if (!isToday.value || weather.value || weatherState.value === 'loading') return
  const hasWalkToday = reminders.value.some(
    (r) => r.reminderType === 'WALK' && isReminderDueOn(r, viewDate.value),
  )
  if (!hasWalkToday && !interactive) return
  if (!userStore.location) {
    weatherState.value = 'idle'
    return
  }

  weatherState.value = 'loading'
  try {
    const point = readSavedGeo(24 * 60 * 60 * 1000)
    const data = await weatherApi.today(point ? { lat: point.lat, lng: point.lng } : undefined)
    weather.value = data
    weatherState.value = data ? 'ready' : 'unavailable'
  } catch {
    weatherState.value = 'unavailable'
  }
}

// 首次登录时本地缓存还没有城市，等 AppLayout 拉回资料后再补一次天气
watch(
  () => userStore.location,
  (location) => {
    if (location) void maybeLoadWeather(false)
  },
)

onMounted(async () => {
  await petStore.fetchPets()
  if (petStore.currentPet) form.petId = petStore.currentPet.id
  await Promise.all([fetchReminders(), fetchLogs()])
  void maybeLoadWeather(false)
})

async function fetchReminders() {
  loading.value = true
  loadError.value = false
  try {
    reminders.value = await reminderApi.list(filterPetId.value)
  } catch {
    loadError.value = true
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
  void maybeLoadWeather(false)
}

function goCalendar() {
  router.push({
    name: 'reminder-calendar',
    query: filterPetId.value != null ? { pet: String(filterPetId.value) } : {},
  })
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
    remindDate: dayjs().format('YYYY-MM-DD'),
    repeatRule: 'DAILY',
  })
  drawerVisible.value = true
}

/** 溢出菜单沿用原有编辑 / 删除动作，命令式派发避免依赖组件内部实现 */
function onRowCommand(command: unknown, row: Reminder) {
  if (command === 'edit') openEdit(row)
  else if (command === 'remove') void remove(row)
}

function openEdit(row: Reminder) {
  editingId.value = row.id
  if (row.reminderType === 'WALK') void maybeLoadWeather(false)
  timeMode.value = row.relativeMin != null ? 'relative' : 'fixed'
  weekdayChecks.value = row.repeatDays ? row.repeatDays.split(',') : []
  Object.assign(form, {
    petId: row.petId,
    title: row.title,
    reminderType: row.reminderType,
    remindTime: row.remindTime || '08:00',
    relativeMin: row.relativeMin ?? 30,
    remindDate: row.remindDate || dayjs().format('YYYY-MM-DD'),
    repeatRule: row.repeatRule || 'DAILY',
  })
  drawerVisible.value = true
}

async function save() {
  if (!form.title.trim()) {
    ElMessage.warning('请填写提醒标题')
    return
  }
  if (formIsDated.value && !form.remindDate) {
    ElMessage.warning('请选择提醒日期')
    return
  }
  saving.value = true
  try {
    const payload = {
      petId: form.petId,
      title: form.title.trim(),
      reminderType: form.reminderType,
      remindTime: timeMode.value === 'fixed' || formIsEvent.value ? form.remindTime : undefined,
      relativeMin: !formIsEvent.value && timeMode.value === 'relative' ? form.relativeMin : undefined,
      remindDate: formIsDated.value ? form.remindDate : undefined,
      repeatRule: formIsEvent.value ? 'ONCE' : form.repeatRule,
      repeatDays: !formIsEvent.value && form.repeatRule === 'WEEKLY' && weekdayChecks.value.length
        ? weekdayChecks.value.join(',')
        : undefined,
    }
    if (editingId.value) {
      await reminderApi.update(editingId.value, payload)
    } else {
      await reminderApi.create(payload)
    }
    ElMessage.success('已保存')
    drawerVisible.value = false
    fetchReminders()
  } finally {
    saving.value = false
  }
}

/** 接口只支持打卡、不支持撤销，已完成的行保持只读 */
function onCheck(row: Reminder) {
  if (!isToday.value || checkedIds.value.has(row.id)) return
  if (row.reminderType === 'FEED') {
    openFeedDialog(row)
    return
  }
  checkin(row)
}

async function checkin(row: Reminder) {
  await reminderApi.checkin(row.id, { doneDate: dayjs().format('YYYY-MM-DD') })
  optimisticChecked.value = new Set(optimisticChecked.value).add(row.id)
  ElMessage.success(`已完成「${row.title}」`)
  fetchLogs()
}

function goNearby(row: Reminder) {
  router.push({
    path: '/nearby',
    query: {
      category: 'park',
      reminderId: String(row.id),
      reminderTitle: row.title,
      petId: String(row.petId),
    },
  })
}

function askKnowledge(row: Reminder) {
  const q = knowledgePromptFor(row)
  if (q) router.push({ path: '/knowledge', query: { q } })
}

function openFeedDialog(row: Reminder) {
  if (!isToday.value || isDone(row.id)) return
  feedRow.value = row
  feedFoodId.value = undefined
  feedGrams.value = 60
  feedOpen.value = true
  feedFoods.value = []
  loadFeedFoods()
}

async function loadFeedFoods() {
  feedFoodLoading.value = true
  try {
    const page = await foodApi.list({ page: 1, size: 100 })
    feedFoods.value = page.records
  } catch {
    feedFoods.value = []
  } finally {
    feedFoodLoading.value = false
  }
}

function goFoods() {
  feedOpen.value = false
  router.push('/foods')
}

async function saveFeedAndCheckin() {
  const row = feedRow.value
  const food = feedSelectedFood.value
  if (!row || !food) return
  feedSaving.value = true
  try {
    await feedingApi.create({
      petId: row.petId,
      foodId: food.id,
      grams: feedGrams.value,
      fedDate: dayjs().format('YYYY-MM-DD'),
    })
  } catch {
    feedSaving.value = false
    return
  }
  try {
    await reminderApi.checkin(row.id, {
      doneDate: dayjs().format('YYYY-MM-DD'),
      note: `${food.name} ${feedGrams.value}g`.slice(0, 255),
    })
    optimisticChecked.value = new Set(optimisticChecked.value).add(row.id)
    ElMessage.success(`已记录 ${food.name} ${feedGrams.value}g，并完成「${row.title}」打卡`)
    feedOpen.value = false
    fetchLogs()
  } catch {
    ElMessage.warning('喂食已记录，但打卡没有完成，请直接点这一行的圆圈补打卡')
  } finally {
    feedSaving.value = false
  }
}

async function checkinOnly() {
  const row = feedRow.value
  if (!row) return
  feedSaving.value = true
  try {
    await checkin(row)
    feedOpen.value = false
  } finally {
    feedSaving.value = false
  }
}

async function remove(row: Reminder) {
  await ElMessageBox.confirm(`确定删除提醒「${row.title}」吗？`, '删除确认', { type: 'warning' })
  await reminderApi.remove(row.id)
  ElMessage.success('已删除')
  fetchReminders()
}
</script>

<style scoped>
/* ---------- 页头：日期切换 + 连续天数 + 新建 ---------- */
.day-nav {
  display: flex;
  align-items: center;
  gap: var(--fg-s1);
}

.day-btn {
  width: 32px;
  height: 32px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  color: var(--fg-ink-muted);
  cursor: pointer;
  transition: color var(--fg-motion), border-color var(--fg-motion), background var(--fg-motion);
}

.day-btn:hover:not(:disabled) {
  color: var(--fg-accent);
  border-color: var(--fg-line-strong);
  background: var(--fg-accent-soft);
}

.day-btn:disabled {
  color: var(--fg-line-strong);
  cursor: not-allowed;
}

.day-label {
  margin: 0;
  min-width: 132px;
  text-align: center;
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: var(--fg-s2);
}

.day-date {
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-lead);
  font-weight: 600;
  letter-spacing: -0.01em;
  font-variant-numeric: tabular-nums;
}

.day-tag {
  font-size: var(--fg-text-label);
}

.head-divider {
  width: var(--fg-line-w);
  height: 24px;
  background: var(--fg-line);
}

.streak {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0;
  white-space: nowrap;
}

.streak-num {
  color: var(--fg-accent);
  font-variant-numeric: tabular-nums;
}

:deep(.head-actions) {
  flex-wrap: wrap;
  align-items: center;
}

.el-button .fg-icon {
  margin-right: var(--fg-s2);
}

/* ---------- 筛选条 ---------- */
.toolbar {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  flex-wrap: wrap;
  padding: var(--fg-s3) 0 var(--fg-s4);
  margin-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.todo-check {
  margin-left: auto;
  margin-right: 0;
}

/* ---------- 时间轴 ---------- */
.tl-card {
  position: relative;
  min-height: 240px;
}

.tl-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s4);
  margin-bottom: var(--fg-s4);
}

.tl-head .fg-section-title {
  margin: 0;
}

.tl-progress {
  margin: 0;
  font-size: var(--fg-text-label);
  white-space: nowrap;
}

.tl-group + .tl-group {
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.tl-group-label {
  margin: 0 0 var(--fg-s3) var(--fg-s2);
}

.tl {
  list-style: none;
  margin: 0;
  padding: 0;
}

.tl-row {
  display: grid;
  grid-template-columns: 64px 12px 24px minmax(0, 1fr) 32px;
  align-items: start;
  gap: var(--fg-s3);
  padding: var(--fg-s3) var(--fg-s2);
  border-radius: var(--fg-radius);
  transition: background var(--fg-motion);
}

.tl-row:hover {
  background: var(--fg-accent-soft);
}

.tl-time {
  height: var(--fg-s8);
  display: flex;
  align-items: center;
  justify-content: flex-end;
  text-align: right;
}

.time-text {
  font-size: var(--fg-text-lead);
  font-weight: 600;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.01em;
}

.time-alt {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  font-family: var(--fg-font-mono);
}

/* 竖发的 1px 时间轴：首尾收在圆点上 */
.tl-marker {
  position: relative;
  align-self: stretch;
  display: flex;
  justify-content: center;
}

.tl-marker::before {
  content: '';
  position: absolute;
  top: 0;
  bottom: 0;
  width: var(--fg-line-w);
  background: var(--fg-line);
}

.tl-row:first-child .tl-marker::before {
  top: var(--fg-s4);
}

.tl-row:last-child .tl-marker::before {
  bottom: auto;
  height: var(--fg-s4);
}

.tl-dot {
  position: relative;
  z-index: 1;
  width: var(--fg-s2);
  height: var(--fg-s2);
  margin-top: var(--fg-s3);
  border-radius: 50%;
  border: var(--fg-line-w) solid var(--fg-line-strong);
  background: var(--fg-surface);
}

.is-done .tl-dot {
  border-color: var(--fg-accent);
  background: var(--fg-accent);
}

.tl-body {
  min-width: 0;
}

.tl-title {
  height: var(--fg-s8);
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0;
  min-width: 0;
}

.tl-ico {
  color: var(--fg-ink-muted);
}

.tl-name {
  font-size: var(--fg-text-lead);
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.is-done .tl-name {
  text-decoration: line-through;
  color: var(--fg-ink-muted);
  font-weight: 500;
}

.is-done .tl-ico {
  color: var(--fg-accent);
}

.tl-meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s2);
  margin: var(--fg-s2) 0 0;
}

.meta-text {
  font-size: var(--fg-text-label);
}

.tl-more {
  height: var(--fg-s8);
  display: flex;
  align-items: center;
}

.more-btn {
  width: 32px;
  height: 32px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  border: var(--fg-line-w) solid transparent;
  border-radius: var(--fg-radius);
  background: transparent;
  color: var(--fg-ink-muted);
  cursor: pointer;
  transition: color var(--fg-motion), background var(--fg-motion), border-color var(--fg-motion);
}

.more-btn:hover {
  color: var(--fg-accent);
  background: var(--fg-surface);
  border-color: var(--fg-line);
}

.link-btn {
  border: none;
  background: none;
  padding: 0;
  margin-left: var(--fg-s2);
  font: inherit;
  color: var(--fg-danger);
  text-decoration: underline;
  cursor: pointer;
}

/* 24px 打卡框：勾选态一律用 accent */
.tl-check {
  margin-right: 0;
  height: var(--fg-s8);
  --el-checkbox-input-width: 24px;
  --el-checkbox-input-height: 24px;
  --el-checkbox-border-radius: 6px;
  --el-checkbox-checked-bg-color: var(--fg-accent);
  --el-checkbox-checked-input-border-color: var(--fg-accent);
  --el-checkbox-checked-icon-color: var(--fg-surface);
  --el-checkbox-checked-text-color: var(--fg-accent);
  --el-checkbox-input-border-color-hover: var(--fg-accent);
  --el-checkbox-disabled-checked-input-fill: var(--fg-accent);
  --el-checkbox-disabled-checked-input-border-color: var(--fg-accent);
  --el-checkbox-disabled-checked-icon-color: var(--fg-surface);
  --el-checkbox-disabled-input-fill: var(--fg-paper);
  --el-checkbox-disabled-border-color: var(--fg-line);
  --el-checkbox-disabled-icon-color: var(--fg-line-strong);
  --el-checkbox-bg-color: var(--fg-surface);
  --el-checkbox-input-border: var(--fg-line-w) solid var(--fg-line-strong);
}

.tl-check :deep(.el-checkbox__inner::after) {
  width: 5px;
  height: 10px;
  border-right-width: 2px;
  border-bottom-width: 2px;
}

/* ---------- 侧栏 ---------- */
.main-col,
.aside-col {
  min-width: 0;
}

.aside-col {
  position: sticky;
  top: calc(var(--fg-topbar-h) + var(--fg-s5));
}

.aside-col .fg-card + .fg-card {
  margin-top: var(--fg-s5);
}

.bars {
  display: flex;
  align-items: flex-end;
  gap: var(--fg-s3);
}

.bar-col {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--fg-s2);
  padding: var(--fg-s2) 0;
  border-radius: var(--fg-radius);
  transition: background var(--fg-motion);
}

.bar-col.is-viewed {
  background: var(--fg-accent-soft);
}

.bar-count {
  font-size: var(--fg-text-label);
  line-height: 1;
  color: var(--fg-ink-muted);
  font-variant-numeric: tabular-nums;
}

.bar-track {
  height: 48px;
  width: 12px;
  display: flex;
  align-items: flex-end;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.bar-fill {
  width: 12px;
  background: var(--fg-accent);
  transition: height var(--fg-motion);
}

.bar-fill.is-zero {
  background: var(--fg-line-strong);
}

.bar-day {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.bar-note {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.kv-list {
  margin-top: calc(-1 * var(--fg-s2));
}

.kv-value {
  font-size: var(--fg-text-lead);
  font-weight: 600;
  white-space: nowrap;
}

/* ---------- 抽屉表单：发丝边框、无投影 ---------- */
.num-hint {
  margin-left: var(--fg-s3);
  font-size: var(--fg-text-label);
}

.time-pick {
  width: 160px;
}

.weekday-check {
  margin-right: var(--fg-s4);
}

/* ---------- 遛弯天气：抽屉提示 ---------- */
.wx-panel {
  display: flex;
  align-items: flex-start;
  gap: var(--fg-s3);
  margin-top: var(--fg-s2);
  padding: var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-line);
  border-left-width: 2px;
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
}

.wx-panel.is-good {
  border-left-color: var(--fg-success);
  background: var(--fg-accent-soft);
}

.wx-panel.is-caution {
  border-left-color: var(--fg-warning);
  background: var(--fg-warning-soft);
}

.wx-panel.is-avoid {
  border-left-color: var(--fg-danger);
  background: var(--fg-danger-soft);
}

.wx-ico {
  flex: none;
  margin-top: 2px;
  color: var(--fg-ink-muted);
}

.wx-panel.is-good .wx-ico { color: var(--fg-success); }
.wx-panel.is-caution .wx-ico { color: var(--fg-warning); }
.wx-panel.is-avoid .wx-ico { color: var(--fg-danger); }

.wx-body {
  min-width: 0;
}

.wx-title {
  margin: 0 0 var(--fg-s1);
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
  font-weight: 500;
}

.wx-text {
  margin: 0;
  font-size: var(--fg-text-body);
  line-height: 1.7;
}

.wx-temp {
  margin: 0 var(--fg-s2);
  font-weight: 600;
}

.wx-meta {
  display: block;
  color: var(--fg-ink-muted);
  font-size: var(--fg-text-label);
}

.wx-advice {
  display: block;
  margin-top: var(--fg-s1);
  font-weight: 600;
}

.wx-panel.is-good .wx-advice { color: var(--fg-success); }
.wx-panel.is-caution .wx-advice { color: var(--fg-warning); }
.wx-panel.is-avoid .wx-advice { color: var(--fg-danger); }

.wx-source {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.wx-source a {
  color: var(--fg-accent);
  text-decoration: underline;
}

.wx-link {
  margin-left: var(--fg-s2);
  padding: 0;
  border: none;
  background: none;
  font: inherit;
  color: var(--fg-accent);
  text-decoration: underline;
  cursor: pointer;
}

/* el-drawer 默认不 append-to-body，节点仍在本页作用域内，可用 :deep 命中 */
.drawer-host :deep(.el-drawer) {
  --el-drawer-padding-primary: var(--fg-s5);
  --el-drawer-bg-color: var(--fg-surface);
  box-shadow: none;
  border-left: var(--fg-line-w) solid var(--fg-line);
}

.drawer-host :deep(.el-drawer__header) {
  margin-bottom: 0;
  padding: var(--fg-s4) var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  color: var(--fg-ink);
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h3);
  font-weight: 600;
  letter-spacing: -0.01em;
}

.drawer-host :deep(.el-drawer__body) {
  padding: var(--fg-s5);
}

.drawer-host :deep(.el-drawer__footer) {
  padding: var(--fg-s4) var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.drawer-form :deep(.el-form-item) {
  margin-bottom: var(--fg-s5);
}

.drawer-form :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
  font-weight: 500;
  padding-bottom: var(--fg-s2);
}

/* ---------- 接下来的日程 ---------- */
.upcoming-card {
  margin-top: var(--fg-s5);
}

.upcoming-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: var(--fg-s2);
}

.upcoming-row {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  padding: var(--fg-s3) var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
}

.upcoming-date {
  font-weight: 600;
  white-space: nowrap;
}

.upcoming-week {
  font-size: var(--fg-text-label);
  white-space: nowrap;
}

.upcoming-title {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.upcoming-meta {
  margin-left: auto;
  font-size: var(--fg-text-label);
  white-space: nowrap;
}

@media (max-width: 768px) {
  .tl-row {
    grid-template-columns: 52px 12px 24px minmax(0, 1fr) 32px;
    gap: var(--fg-s2);
  }
}

/* ===== 响应式新增：移动端（<768px）===== */
@media (max-width: 767.98px) {
  .day-nav {
    width: 100%;
  }

  .day-btn {
    width: 44px;
    height: 44px;
  }

  .day-label {
    flex: 1;
    min-width: 0;
    justify-content: flex-start;
    text-align: left;
  }

  .head-divider {
    display: none;
  }

  .toolbar {
    gap: var(--fg-s2);
    padding: var(--fg-s3) 0;
    margin-bottom: var(--fg-s4);
  }

  .toolbar :deep(.el-radio-group) {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    gap: var(--fg-s1);
  }

  .toolbar :deep(.el-radio-button) {
    flex: 1 1 auto;
  }

  .toolbar :deep(.el-radio-button__inner) {
    width: 100%;
    padding: 0 var(--fg-s3);
  }

  .todo-check {
    margin-left: 0;
  }

  .tl-card {
    min-height: 0;
  }

  .tl-head {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--fg-s1);
    margin-bottom: var(--fg-s3);
  }

  .tl-row {
    grid-template-columns: 48px 44px minmax(0, 1fr) 44px;
    gap: var(--fg-s2);
    padding: var(--fg-s3) 0;
  }

  .tl-marker {
    display: none;
  }

  .tl-time {
    height: auto;
    align-items: flex-start;
    padding-top: var(--fg-s2);
  }

  .tl-check {
    width: 44px;
    height: auto;
    min-height: 44px;
    align-items: flex-start;
    justify-content: center;
    padding-top: var(--fg-s1);
  }

  .tl-title {
    height: auto;
    align-items: flex-start;
  }

  .tl-name {
    white-space: normal;
    overflow: visible;
    text-overflow: clip;
    line-height: 1.45;
    overflow-wrap: anywhere;
  }

  .tl-more {
    height: auto;
  }

  .more-btn {
    width: 44px;
    height: 44px;
  }

  .aside-col {
    position: static;
  }

  .drawer-host :deep(.el-drawer__header),
  .drawer-host :deep(.el-drawer__footer) {
    padding: var(--fg-s3) var(--fg-s4);
  }

  .drawer-host :deep(.el-drawer__body) {
    padding: var(--fg-s4);
  }

  .time-pick {
    width: 100%;
  }

  .num-hint {
    display: block;
    margin-left: 0;
    margin-top: var(--fg-s2);
  }

  .weekday-check {
    margin-right: var(--fg-s3);
  }

  .upcoming-row {
    flex-wrap: wrap;
    align-items: baseline;
    gap: var(--fg-s2) var(--fg-s3);
  }

  .upcoming-title {
    order: -1;
    flex: 1 1 100%;
    white-space: normal;
  }

  .upcoming-meta {
    margin-left: 0;
    white-space: normal;
  }

  .tl-weather {
    max-width: 100%;
    white-space: normal;
  }

  .wx-panel {
    padding: var(--fg-s3);
  }
}

/* ---------- 行内联动入口 ---------- */
.tl-links {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s2) var(--fg-s4);
  margin: var(--fg-s2) 0 0;
}

.tl-link {
  display: inline-flex;
  align-items: center;
  gap: 2px;
  padding: 0;
  border: none;
  background: none;
  font: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
  cursor: pointer;
}

.tl-link:hover {
  text-decoration: underline;
}

/* ---------- 遛弯天气：时间轴行内徽标 ---------- */
.tl-weather {
  display: inline-flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s1) var(--fg-s2);
  padding: 2px 10px;
  border-radius: 999px;
  background: var(--fg-paper);
  color: var(--fg-ink-muted);
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

.tl-weather.is-good {
  background: var(--fg-accent-soft);
  color: var(--fg-success);
}

.tl-weather.is-caution {
  background: var(--fg-warning-soft);
  color: var(--fg-warning);
}

.tl-weather.is-avoid {
  background: var(--fg-danger-soft);
  color: var(--fg-danger);
}

.tl-weather.is-loading {
  background: var(--fg-paper);
}

.tl-weather-advice {
  opacity: 0.9;
}

/* ---------- 喂食打卡弹窗（dialog 会 teleport 到 body，容器样式走 :global） ---------- */
.feed-context {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0 0 var(--fg-s4);
  font-weight: 600;
}

.feed-form :deep(.el-form-item:last-child) {
  margin-bottom: 0;
}

.feed-option-brand {
  float: right;
  margin-left: var(--fg-s4);
  color: var(--fg-ink-muted);
  font-size: var(--fg-text-label);
}

.feed-empty {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
}

.feed-go {
  padding: 0;
  border: none;
  background: none;
  font: inherit;
  color: var(--fg-accent);
  text-decoration: underline;
  cursor: pointer;
}

.feed-grams {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s3);
}

.feed-kcal {
  font-size: var(--fg-text-label);
}

:global(.feed-dialog) {
  max-width: 92vw;
}
</style>
