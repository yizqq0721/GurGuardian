import type { ActivityLevel, FoodType, LifeStage, Physiology, ProductType, ReminderType, RepeatRule, SpeciesScope } from '@/types'

export const ACTIVITY_OPTIONS: { value: ActivityLevel; label: string }[] = [
  { value: 'SEDENTARY', label: '久坐（几乎不运动）' },
  { value: 'LOW', label: '低（偶尔散步）' },
  { value: 'MODERATE', label: '中（每日规律活动）' },
  { value: 'HIGH', label: '高（大量运动）' },
  { value: 'WORKING', label: '工作犬' },
]

export const PHYSIOLOGY_OPTIONS: { value: Physiology; label: string }[] = [
  { value: 'NORMAL', label: '正常' },
  { value: 'PREGNANT', label: '妊娠期' },
  { value: 'LACTATING', label: '哺乳期' },
]

export const FOOD_TYPE_OPTIONS: { value: FoodType; label: string }[] = [
  { value: 'DRY', label: '干粮' },
  { value: 'WET', label: '湿粮' },
  { value: 'FREEZE_DRIED', label: '冻干' },
  { value: 'SNACK', label: '零食' },
  { value: 'CANNED', label: '罐头' },
]

export const PRODUCT_TYPE_OPTIONS: { value: ProductType; label: string }[] = [
  { value: 'COMPLETE', label: '全价粮（可作唯一主食）' },
  { value: 'COMPLEMENTARY', label: '补充粮（不可作唯一主食）' },
  { value: 'SNACK', label: '零食' },
]

export const LIFE_STAGE_OPTIONS: { value: LifeStage; label: string }[] = [
  { value: 'ALL', label: '全阶段' },
  { value: 'BABY', label: '幼年' },
  { value: 'ADULT', label: '成年' },
  { value: 'SENIOR', label: '老年' },
]

export const SPECIES_SCOPE_OPTIONS: { value: SpeciesScope; label: string }[] = [
  { value: 'DOG', label: '犬用' },
  { value: 'CAT', label: '猫用' },
  { value: 'BOTH', label: '犬猫通用' },
]

export const REMINDER_TYPE_OPTIONS: { value: ReminderType; label: string }[] = [
  { value: 'FEED', label: '喂食' },
  { value: 'WALK', label: '遛弯' },
  { value: 'WATER', label: '喂水/换水' },
  { value: 'GROOMING', label: '梳毛' },
  { value: 'DEWORM', label: '驱虫' },
  { value: 'VACCINE', label: '疫苗' },
  { value: 'BATH', label: '洗澡' },
  { value: 'CUSTOM', label: '自定义' },
]

export const REPEAT_RULE_OPTIONS: { value: RepeatRule; label: string }[] = [
  { value: 'DAILY', label: '每天' },
  { value: 'WEEKLY', label: '每周' },
  { value: 'MONTHLY', label: '每月' },
  { value: 'YEARLY', label: '每年' },
  { value: 'ONCE', label: '仅一次' },
]

export const FOOD_TYPE_LABEL = Object.fromEntries(FOOD_TYPE_OPTIONS.map((o) => [o.value, o.label]))
export const PRODUCT_TYPE_LABEL = Object.fromEntries(PRODUCT_TYPE_OPTIONS.map((o) => [o.value, o.label]))
export const LIFE_STAGE_LABEL = Object.fromEntries(LIFE_STAGE_OPTIONS.map((o) => [o.value, o.label]))
export const SPECIES_SCOPE_LABEL = Object.fromEntries(SPECIES_SCOPE_OPTIONS.map((o) => [o.value, o.label]))
export const REMINDER_TYPE_LABEL = Object.fromEntries(REMINDER_TYPE_OPTIONS.map((o) => [o.value, o.label]))
export const REPEAT_RULE_LABEL = Object.fromEntries(REPEAT_RULE_OPTIONS.map((o) => [o.value, o.label]))
export const ACTIVITY_LABEL = Object.fromEntries(ACTIVITY_OPTIONS.map((o) => [o.value, o.label]))
export const PHYSIOLOGY_LABEL = Object.fromEntries(PHYSIOLOGY_OPTIONS.map((o) => [o.value, o.label]))

/** BCS 1-9 分制描述（配图引导见 BcsScale 组件）。
 *  配色遵循「单一 accent + 语义色只留给风险」：理想=accent，偏瘦/偏重=warning，肥胖=danger */
export const BCS_GROUPS = [
  { range: [1, 3], label: '偏瘦', desc: '肋骨、腰椎明显可见，缺乏体脂覆盖', color: '#b45309' },
  { range: [4, 5], label: '理想', desc: '肋骨可触及但不明显，腰部线条清晰', color: '#1f5c4a' },
  { range: [6, 7], label: '偏重', desc: '肋骨较难触及，腰部线条不明显', color: '#b45309' },
  { range: [8, 9], label: '肥胖', desc: '肋骨无法触及，腹部明显下垂', color: '#b42318' },
]

export function bcsGroup(bcs: number) {
  return BCS_GROUPS.find((g) => bcs >= g.range[0] && bcs <= g.range[1]) ?? BCS_GROUPS[1]
}
