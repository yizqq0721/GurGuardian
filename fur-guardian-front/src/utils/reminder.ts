import type { ReminderType } from '@/types'

/** 疫苗、驱虫是「某一天去做」的事件，按用户指定日期提醒一次 */
export const DATED_REMINDER_TYPES: ReminderType[] = ['VACCINE', 'DEWORM']

export function isDatedType(type: ReminderType) {
  return DATED_REMINDER_TYPES.includes(type)
}

/** 有日期的仅一次提醒只在当天出现；旧的周期数据保持每天可见，升级后不会消失 */
export function isReminderDueOn(
  reminder: { repeatRule?: string; remindDate?: string },
  date: string,
) {
  if (reminder.repeatRule === 'ONCE' && reminder.remindDate) {
    return reminder.remindDate === date
  }
  return true
}

export function isDatedReminder(reminder: { repeatRule?: string; remindDate?: string }) {
  return reminder.repeatRule === 'ONCE' && !!reminder.remindDate
}
