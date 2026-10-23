import { onBeforeUnmount, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElNotification } from 'element-plus'
import dayjs from 'dayjs'
import { reminderApi } from '@/api/reminder'
import type { Reminder } from '@/types'
import { isReminderDueOn } from '@/utils/reminder'

const CHECK_INTERVAL = 60_000
const FIRST_CHECK_DELAY = 4_000
const IN_APP_KEY = 'fg_notify_inapp'
const NOTIFIED_PREFIX = 'fg_reminder_notified_'

export function isInAppNotifyEnabled() {
  return localStorage.getItem(IN_APP_KEY) !== '0'
}

export function setInAppNotifyEnabled(enabled: boolean) {
  localStorage.setItem(IN_APP_KEY, enabled ? '1' : '0')
}

export function canUseSystemNotification() {
  return 'Notification' in window && Notification.permission === 'granted'
}

function notifiedKey(date: string) {
  return `${NOTIFIED_PREFIX}${date}`
}

function readNotified(date: string): Set<number> {
  try {
    const raw = localStorage.getItem(notifiedKey(date))
    const ids = raw ? (JSON.parse(raw) as unknown) : []
    return new Set(Array.isArray(ids) ? ids.filter((id): id is number => typeof id === 'number') : [])
  } catch {
    return new Set()
  }
}

function markNotified(date: string, ids: number[]) {
  const key = notifiedKey(date)
  const merged = readNotified(date)
  ids.forEach((id) => merged.add(id))
  localStorage.setItem(key, JSON.stringify([...merged]))
  // 只保留当天的去重记录，避免 localStorage 无限增长
  for (let i = localStorage.length - 1; i >= 0; i -= 1) {
    const name = localStorage.key(i)
    if (name?.startsWith(NOTIFIED_PREFIX) && name !== key) localStorage.removeItem(name)
  }
}

function isTimeReached(reminder: Reminder) {
  if (!reminder.remindTime) return true
  const [hour, minute] = reminder.remindTime.split(':').map(Number)
  if (!Number.isFinite(hour) || !Number.isFinite(minute)) return true
  const now = dayjs()
  return now.hour() * 60 + now.minute() >= hour * 60 + minute
}

function buildMessage(reminders: Reminder[]) {
  const labels = reminders
    .slice()
    .sort((a, b) => (a.remindTime || '99:99').localeCompare(b.remindTime || '99:99'))
    .map((r) => `${r.remindTime ? r.remindTime.slice(0, 5) : '全天'} ${r.title}`)
  const shown = labels.slice(0, 4).join('；')
  return labels.length > 4 ? `${shown} 等 ${labels.length} 项` : shown
}

export function useReminderNotify() {
  const router = useRouter()
  let timer: number | undefined
  let firstTimer: number | undefined
  let checking = false

  function openReminders() {
    void router.push('/reminders')
  }

  function showSystemNotification(title: string, body: string) {
    if (!canUseSystemNotification()) return
    const notification = new Notification(title, { body, tag: 'fg-reminder' })
    notification.onclick = () => {
      window.focus()
      openReminders()
      notification.close()
    }
  }

  async function check() {
    if (checking) return
    checking = true
    try {
      const today = dayjs().format('YYYY-MM-DD')
      const reminders = await reminderApi.list(undefined, true)
      const due = reminders.filter((r) => isReminderDueOn(r, today) && isTimeReached(r))
      if (!due.length) return

      const petIds = [...new Set(due.map((r) => r.petId))]
      const logGroups = await Promise.all(
        petIds.map((petId) =>
          reminderApi
            .logs({ petId, startDate: today, endDate: today }, true)
            .catch(() => []),
        ),
      )
      const doneIds = new Set(logGroups.flat().map((log) => log.reminderId))
      const notified = readNotified(today)

      // 未设置具体时间（如饭后提醒）的条目由打开页面触发，避免一天内反复打扰
      const pending = due.filter((r) => !doneIds.has(r.id) && !notified.has(r.id))
      if (!pending.length) return

      const inApp = isInAppNotifyEnabled()
      const hidden = document.visibilityState === 'hidden'
      if (!inApp && !(hidden && canUseSystemNotification())) return

      const title = `今日提醒 · ${pending.length} 项待完成`
      const message = buildMessage(pending)

      if (inApp) {
        ElNotification({
          title,
          message,
          type: 'warning',
          duration: 10000,
          position: 'bottom-right',
          onClick: openReminders,
        })
      }
      if (hidden) {
        showSystemNotification(title, message)
      }
      markNotified(today, pending.map((r) => r.id))
    } catch {
      // 网络异常时静默跳过本轮，下一轮自动重试
    } finally {
      checking = false
    }
  }

  function onVisibilityChange() {
    if (document.visibilityState === 'visible') void check()
  }

  onMounted(() => {
    firstTimer = window.setTimeout(() => void check(), FIRST_CHECK_DELAY)
    timer = window.setInterval(() => void check(), CHECK_INTERVAL)
    document.addEventListener('visibilitychange', onVisibilityChange)
  })

  onBeforeUnmount(() => {
    if (firstTimer) window.clearTimeout(firstTimer)
    if (timer) window.clearInterval(timer)
    document.removeEventListener('visibilitychange', onVisibilityChange)
  })

  return { check }
}

export function sendTestNotification() {
  ElNotification({
    title: '测试通知',
    message: '通知已联动：喂食、遛弯、疫苗等到点后，我们会这样提醒你。',
    type: 'success',
    duration: 6000,
    position: 'bottom-right',
  })
  if (canUseSystemNotification()) {
    new Notification('FurGuardian 测试通知', {
      body: '到点的提醒将同时出现在站内和系统通知中。',
      tag: 'fg-reminder-test',
    })
  }
}
