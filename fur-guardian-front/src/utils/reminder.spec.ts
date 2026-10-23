import { describe, expect, it } from 'vitest'
import { isDatedReminder, isDatedType, isReminderDueOn } from './reminder'

const MONDAY = '2026-10-19'
const TUESDAY = '2026-10-20'
const WEDNESDAY = '2026-10-21'
const FRIDAY = '2026-10-23'
const SATURDAY = '2026-10-24'
const SUNDAY = '2026-10-25'

describe('isReminderDueOn - ONCE', () => {
  it('在指定日期当天返回 true', () => {
    expect(isReminderDueOn({ repeatRule: 'ONCE', remindDate: TUESDAY }, TUESDAY)).toBe(true)
  })

  it('不在指定日期返回 false', () => {
    expect(isReminderDueOn({ repeatRule: 'ONCE', remindDate: TUESDAY }, WEDNESDAY)).toBe(false)
  })

  it('历史数据没有日期时按每日显示（fail-open）', () => {
    expect(isReminderDueOn({ repeatRule: 'ONCE' }, FRIDAY)).toBe(true)
  })
})

describe('isReminderDueOn - WEEKLY', () => {
  it('命中周一（1-7 编码）', () => {
    expect(isReminderDueOn({ repeatRule: 'WEEKLY', repeatDays: '1' }, MONDAY)).toBe(true)
  })

  it('命中周日（7 而不是 0）', () => {
    expect(isReminderDueOn({ repeatRule: 'WEEKLY', repeatDays: '7' }, SUNDAY)).toBe(true)
  })

  it('周日不会被误判成周一', () => {
    expect(isReminderDueOn({ repeatRule: 'WEEKLY', repeatDays: '1' }, SUNDAY)).toBe(false)
  })

  it('多选日期逐日匹配', () => {
    const reminder = { repeatRule: 'WEEKLY', repeatDays: '1,3,5' }
    expect(isReminderDueOn(reminder, MONDAY)).toBe(true)
    expect(isReminderDueOn(reminder, TUESDAY)).toBe(false)
    expect(isReminderDueOn(reminder, WEDNESDAY)).toBe(true)
    expect(isReminderDueOn(reminder, FRIDAY)).toBe(true)
    expect(isReminderDueOn(reminder, SATURDAY)).toBe(false)
  })

  it('未配置重复日时按每日显示', () => {
    expect(isReminderDueOn({ repeatRule: 'WEEKLY' }, TUESDAY)).toBe(true)
    expect(isReminderDueOn({ repeatRule: 'WEEKLY', repeatDays: '' }, TUESDAY)).toBe(true)
  })

  it('重复日全部非法时按每日显示', () => {
    expect(isReminderDueOn({ repeatRule: 'WEEKLY', repeatDays: '0,8,x' }, TUESDAY)).toBe(true)
  })
})

describe('isReminderDueOn - MONTHLY', () => {
  it('以 remindDate 为锚点命中同一天', () => {
    expect(isReminderDueOn({ repeatRule: 'MONTHLY', remindDate: '2026-01-15' }, '2026-10-15')).toBe(true)
  })

  it('非锚点日不触发', () => {
    expect(isReminderDueOn({ repeatRule: 'MONTHLY', remindDate: '2026-01-15' }, '2026-10-16')).toBe(false)
  })

  it('没有 remindDate 时回退到创建日期', () => {
    const reminder = { repeatRule: 'MONTHLY', createdAt: '2026-01-15T10:30:00' }
    expect(isReminderDueOn(reminder, '2026-10-15')).toBe(true)
    expect(isReminderDueOn(reminder, '2026-10-14')).toBe(false)
  })

  it('锚点为 31 号时短月份落到月末', () => {
    const reminder = { repeatRule: 'MONTHLY', remindDate: '2026-01-31' }
    expect(isReminderDueOn(reminder, '2026-02-27')).toBe(false)
    expect(isReminderDueOn(reminder, '2026-02-28')).toBe(true)
    expect(isReminderDueOn(reminder, '2028-02-29')).toBe(true)
  })

  it('没有可用锚点时按每日显示', () => {
    expect(isReminderDueOn({ repeatRule: 'MONTHLY' }, FRIDAY)).toBe(true)
  })

  it('锚点非法时按每日显示', () => {
    expect(isReminderDueOn({ repeatRule: 'MONTHLY', remindDate: 'not-a-date' }, FRIDAY)).toBe(true)
  })
})

describe('isReminderDueOn - YEARLY', () => {
  it('同月同日触发', () => {
    expect(isReminderDueOn({ repeatRule: 'YEARLY', remindDate: '2024-03-08' }, '2026-03-08')).toBe(true)
  })

  it('同一天但月份不同不触发', () => {
    expect(isReminderDueOn({ repeatRule: 'YEARLY', remindDate: '2024-03-08' }, '2026-10-08')).toBe(false)
  })

  it('锚点为 2 月 29 日时平年落到 2 月 28 日', () => {
    const reminder = { repeatRule: 'YEARLY', remindDate: '2024-02-29' }
    expect(isReminderDueOn(reminder, '2026-02-28')).toBe(true)
    expect(isReminderDueOn(reminder, '2028-02-29')).toBe(true)
  })
})

describe('isReminderDueOn - 归一化与兜底', () => {
  it('规则大小写与空白不影响判断', () => {
    expect(isReminderDueOn({ repeatRule: ' monthly ', remindDate: '2026-01-15' }, '2026-10-15')).toBe(true)
  })

  it('DAILY 每天都触发', () => {
    expect(isReminderDueOn({ repeatRule: 'DAILY' }, SUNDAY)).toBe(true)
  })

  it('未知规则按每日显示', () => {
    expect(isReminderDueOn({ repeatRule: 'HOURLY' }, FRIDAY)).toBe(true)
    expect(isReminderDueOn({}, FRIDAY)).toBe(true)
  })
})

describe('isDatedReminder', () => {
  it('ONCE 且有日期视为定时事件', () => {
    expect(isDatedReminder({ repeatRule: 'ONCE', remindDate: TUESDAY })).toBe(true)
  })

  it('ONCE 无日期不视为定时事件', () => {
    expect(isDatedReminder({ repeatRule: 'ONCE' })).toBe(false)
  })

  it('其他周期即使带日期也不视为定时事件', () => {
    expect(isDatedReminder({ repeatRule: 'MONTHLY', remindDate: TUESDAY })).toBe(false)
  })
})

describe('isDatedType', () => {
  it('疫苗与驱虫属于定时事件类型', () => {
    expect(isDatedType('VACCINE')).toBe(true)
    expect(isDatedType('DEWORM')).toBe(true)
  })

  it('日常提醒不属于定时事件类型', () => {
    expect(isDatedType('FEED')).toBe(false)
    expect(isDatedType('WALK')).toBe(false)
    expect(isDatedType('CUSTOM')).toBe(false)
  })
})
