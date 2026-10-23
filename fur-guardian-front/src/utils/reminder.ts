import dayjs from 'dayjs'
import type { ReminderType } from '@/types'

/** 疫苗、驱虫是「某一天去做」的事件，按用户指定日期提醒一次 */
export const DATED_REMINDER_TYPES: ReminderType[] = ['VACCINE', 'DEWORM']

export function isDatedType(type: ReminderType) {
  return DATED_REMINDER_TYPES.includes(type)
}

/**
 * 判断提醒是否落在指定日期。
 * 月/年提醒没有独立的「几号」字段，以 remindDate（或创建日期）为锚点；
 * 锚点日大于当月天数时落在月末（如 31 号在 2 月按 28/29 号处理）。
 */
export function isReminderDueOn(
  reminder: {
    repeatRule?: string
    remindDate?: string
    repeatDays?: string
    createdAt?: string
  },
  date: string,
) {
  const rule = (reminder.repeatRule || '').trim().toUpperCase()
  const target = dayjs(date)

  if (rule === 'ONCE') {
    return !reminder.remindDate || reminder.remindDate === date
  }
  if (rule === 'WEEKLY') {
    const days = (reminder.repeatDays || '')
      .split(',')
      .map((d) => Number(d.trim()))
      .filter((d) => Number.isInteger(d) && d >= 1 && d <= 7)
    if (!days.length) return true
    // dayjs().day() 周日为 0，项目内 repeatDays 用 1-7 表示周一到周日
    return days.includes(target.day() || 7)
  }
  if (rule === 'MONTHLY' || rule === 'YEARLY') {
    const anchor = reminder.remindDate || reminder.createdAt
    if (!anchor) return true
    const anchorDate = dayjs(anchor)
    if (!anchorDate.isValid()) return true
    if (rule === 'YEARLY' && anchorDate.month() !== target.month()) return false
    return target.date() === Math.min(anchorDate.date(), target.daysInMonth())
  }
  return true
}

export function isDatedReminder(reminder: { repeatRule?: string; remindDate?: string }) {
  return reminder.repeatRule === 'ONCE' && !!reminder.remindDate
}
