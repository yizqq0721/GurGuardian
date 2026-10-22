<template>
  <section class="fg-card cal-card">
    <header class="cal-head">
      <div class="cal-heading">
        <h2 class="fg-section-title">护理日历</h2>
        <p class="fg-muted cal-sub">疫苗、驱虫等按日期提醒的事项</p>
      </div>
      <div class="cal-nav" role="group" aria-label="切换月份">
        <button type="button" class="cal-nav-btn" aria-label="上个月" @click="shiftMonth(-1)">
          <ChevronLeft :size="18" class="fg-icon" />
        </button>
        <p class="cal-month">{{ monthLabel }}</p>
        <button type="button" class="cal-nav-btn" aria-label="下个月" @click="shiftMonth(1)">
          <ChevronRight :size="18" class="fg-icon" />
        </button>
        <button v-if="!isCurrentMonth" type="button" class="cal-today-btn" @click="goCurrentMonth">
          回到本月
        </button>
      </div>
    </header>

    <div class="cal-scroll">
      <div class="cal-inner">
        <div class="cal-weekdays" aria-hidden="true">
          <span v-for="w in WEEKDAYS" :key="w" class="cal-weekday">周{{ w }}</span>
        </div>
        <div class="cal-grid" role="grid" :aria-label="`${monthLabel}按日期提醒`">
          <div
            v-for="cell in cells"
            :key="cell.key"
            class="cal-cell"
            :class="{
              'is-out': !cell.inMonth,
              'is-today': cell.isToday,
              'has-events': cell.events.length > 0,
              'is-past': cell.events.length > 0 && cell.isPast,
            }"
            role="gridcell"
          >
            <span class="cal-day fg-num">{{ cell.day }}</span>
            <ul v-if="cell.events.length" class="cal-events">
              <li
                v-for="r in cell.events.slice(0, visibleEvents)"
                :key="r.id"
                class="cal-event"
                :title="eventTitle(r)"
              >
                <component :is="iconFor(r.reminderType)" :size="12" class="fg-icon cal-event-ico" />
                <span class="cal-event-title">{{ r.title }}</span>
              </li>
              <li v-if="cell.events.length > visibleEvents" class="cal-more" :title="moreTitle(cell.events)">
                +{{ cell.events.length - visibleEvents }} 项
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <p v-if="!monthEvents.length" class="fg-muted cal-empty">
      本月没有按日期安排的提醒，疫苗、驱虫可在「新建提醒」里选择计划日期。
    </p>
  </section>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import type { Component } from 'vue'
import dayjs from 'dayjs'
import { Bell, ChevronLeft, ChevronRight, Pill, Syringe } from 'lucide-vue-next'
import { REMINDER_TYPE_LABEL } from '@/utils/constants'
import { isDatedReminder } from '@/utils/reminder'
import type { Reminder, ReminderType } from '@/types'

const props = defineProps<{
  reminders: Reminder[]
  petNames: Record<number, string>
}>()

const WEEKDAYS = ['一', '二', '三', '四', '五', '六', '日']
const visibleEvents = 2
const TYPE_ICONS: Partial<Record<ReminderType, Component>> = {
  VACCINE: Syringe,
  DEWORM: Pill,
}

const anchor = ref(dayjs().startOf('month'))
const monthLabel = computed(() => anchor.value.format('YYYY年M月'))
const isCurrentMonth = computed(() => anchor.value.isSame(dayjs(), 'month'))

const monthEvents = computed(() =>
  props.reminders.filter((r) => r.remindDate && isDatedReminder(r) && dayjs(r.remindDate).isSame(anchor.value, 'month')),
)

const eventsByDate = computed(() => {
  const map = new Map<string, Reminder[]>()
  monthEvents.value.forEach((r) => {
    const key = r.remindDate as string
    const list = map.get(key)
    if (list) list.push(r)
    else map.set(key, [r])
  })
  map.forEach((list) =>
    list.sort((a, b) => (a.remindTime ?? '99:99').localeCompare(b.remindTime ?? '99:99')),
  )
  return map
})

const cells = computed(() => {
  const monthStart = anchor.value
  const leading = (monthStart.day() + 6) % 7
  const gridStart = monthStart.subtract(leading, 'day')
  const total = Math.ceil((leading + monthStart.daysInMonth()) / 7) * 7
  const today = dayjs().startOf('day')

  return Array.from({ length: total }, (_, i) => {
    const d = gridStart.add(i, 'day')
    const key = d.format('YYYY-MM-DD')
    const inMonth = d.isSame(monthStart, 'month')
    return {
      key,
      day: d.date(),
      inMonth,
      isToday: d.isSame(today, 'day'),
      isPast: d.isBefore(today, 'day'),
      events: inMonth ? eventsByDate.value.get(key) ?? [] : [],
    }
  })
})

function shiftMonth(delta: number) {
  anchor.value = anchor.value.add(delta, 'month')
}

function goCurrentMonth() {
  anchor.value = dayjs().startOf('month')
}

function iconFor(type: ReminderType): Component {
  return TYPE_ICONS[type] ?? Bell
}

function eventTitle(r: Reminder) {
  const meta = [
    r.remindTime ? r.remindTime.slice(0, 5) : '',
    REMINDER_TYPE_LABEL[r.reminderType] || r.reminderType,
    props.petNames[r.petId] || '',
  ].filter(Boolean)
  return `${r.title}${meta.length ? ` · ${meta.join(' · ')}` : ''}`
}

function moreTitle(events: Reminder[]) {
  return events.map((r) => r.title).join('、')
}
</script>

<style scoped>
.cal-card {
  margin-bottom: var(--fg-s5);
}

.cal-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--fg-s3) var(--fg-s4);
  margin-bottom: var(--fg-s4);
}

.cal-heading .fg-section-title {
  margin-bottom: var(--fg-s1);
}

.cal-sub {
  margin: 0;
  font-size: var(--fg-text-label);
}

.cal-nav {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
}

.cal-nav-btn {
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

.cal-nav-btn:hover {
  color: var(--fg-accent);
  border-color: var(--fg-line-strong);
  background: var(--fg-accent-soft);
}

.cal-month {
  margin: 0;
  min-width: 104px;
  text-align: center;
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-lead);
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

.cal-today-btn {
  padding: 0 var(--fg-s2);
  height: 32px;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  color: var(--fg-ink-muted);
  font-size: var(--fg-text-label);
  cursor: pointer;
}

.cal-today-btn:hover {
  color: var(--fg-accent);
  border-color: var(--fg-line-strong);
}

.cal-scroll {
  overflow-x: auto;
}

.cal-inner {
  min-width: 0;
}

.cal-weekdays,
.cal-grid {
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 6px;
}

.cal-weekdays {
  margin-bottom: 6px;
}

.cal-weekday {
  text-align: center;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.cal-cell {
  min-height: 92px;
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
  padding: 6px 8px;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
}

.cal-cell.is-out {
  border-color: transparent;
  background: transparent;
  color: var(--fg-line-strong);
}

.cal-day {
  width: 22px;
  height: 22px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  font-variant-numeric: tabular-nums;
}

.cal-cell.has-events {
  border-color: var(--fg-accent);
  background: var(--fg-accent-soft);
}

.cal-cell.is-past {
  border-color: var(--fg-line-strong);
  background: var(--fg-paper);
}

.cal-cell.is-today .cal-day {
  background: var(--fg-accent);
  color: var(--fg-surface);
  font-weight: 600;
}

.cal-events {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 2px;
  min-width: 0;
}

.cal-event {
  display: flex;
  align-items: center;
  gap: 3px;
  min-width: 0;
  padding: 1px 4px;
  border-left: 2px solid var(--fg-accent);
  border-radius: 2px;
  background: var(--fg-surface);
  font-size: 11px;
  line-height: 1.6;
  color: var(--fg-ink);
}

.cal-event-ico {
  flex: none;
  color: var(--fg-accent);
}

.cal-event-title {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.cal-cell.is-past .cal-event {
  border-left-color: var(--fg-line-strong);
  color: var(--fg-ink-muted);
}

.cal-cell.is-past .cal-event-ico {
  color: var(--fg-ink-muted);
}

.cal-more {
  padding-left: 4px;
  font-size: 11px;
  color: var(--fg-ink-muted);
}

.cal-empty {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-label);
}

@media (max-width: 767.98px) {
  .cal-card {
    padding: var(--fg-s4);
  }

  .cal-nav {
    width: 100%;
    justify-content: space-between;
  }

  .cal-month {
    flex: 1;
    min-width: 0;
  }

  .cal-nav-btn {
    width: 44px;
    height: 44px;
  }

  .cal-today-btn {
    height: 44px;
  }

  .cal-inner {
    min-width: 620px;
  }

  .cal-cell {
    min-height: 84px;
  }
}
</style>
