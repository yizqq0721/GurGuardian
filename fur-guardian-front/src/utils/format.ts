import dayjs from 'dayjs'

/** 生日 → 「N 月龄」/「N 岁 M 个月」，多个页面共用 */
export function ageText(birthday?: string): string {
  if (!birthday) return '年龄未知'
  const months = dayjs().diff(dayjs(birthday), 'month')
  if (months < 12) return `${months} 月龄`
  const years = Math.floor(months / 12)
  return `${years} 岁${months % 12 ? ` ${months % 12} 个月` : ''}`
}

export function dateText(value?: string, pattern = 'YYYY-MM-DD'): string {
  return value ? dayjs(value).format(pattern) : '—'
}

export function dateTimeText(value?: string): string {
  return value ? dayjs(value).format('MM-DD HH:mm') : '—'
}

/** 相对时间：用于「最近更新」列，超过 7 天回退到日期 */
export function fromNow(value?: string): string {
  if (!value) return '—'
  const mins = dayjs().diff(dayjs(value), 'minute')
  if (mins < 1) return '刚刚'
  if (mins < 60) return `${mins} 分钟前`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours} 小时前`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days} 天前`
  return dateText(value)
}
