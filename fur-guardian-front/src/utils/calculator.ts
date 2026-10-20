import type { ActivityLevel, Physiology, Species } from '@/types'

/**
 * 落地页尝鲜计算器使用的纯前端 RER/MER 估算。
 * 与后端 pet-nutrition-core 公式口径一致：RER = 70 × BW^0.75，MER = RER × k。
 */
export function calcRer(weightKg: number): number {
  return 70 * Math.pow(weightKg, 0.75)
}

export interface MerFactorInput {
  species: Species
  ageMonths: number
  neutered: boolean
  activityLevel: ActivityLevel
  physiology: Physiology
  bcs?: number
}

export function merFactor(input: MerFactorInput): { factor: number; note: string } {
  const { species, ageMonths, neutered, activityLevel, physiology, bcs } = input

  if (physiology === 'PREGNANT') return { factor: 2.5, note: '妊娠期' }
  if (physiology === 'LACTATING') return { factor: 3.0, note: '哺乳期' }

  if (species === 'dog') {
    if (ageMonths < 4) return { factor: 3.0, note: '幼犬 0-4 月' }
    if (ageMonths < 12) return { factor: 2.0, note: '幼犬 4-12 月' }
    if (activityLevel === 'WORKING') return { factor: 3.0, note: '工作犬（取区间中值）' }
    if (activityLevel === 'HIGH') return { factor: 2.0, note: '活跃犬' }
    if (activityLevel === 'SEDENTARY' || (bcs !== undefined && bcs >= 7)) {
      return { factor: 1.2, note: '久坐 / 肥胖倾向' }
    }
    return neutered
      ? { factor: 1.6, note: '已绝育成年犬' }
      : { factor: 1.8, note: '未绝育成年犬' }
  }

  // cat
  if (ageMonths < 4) return { factor: 2.5, note: '幼猫 <4 月' }
  if (ageMonths < 12) return { factor: 2.0, note: '幼猫 4 月-成年' }
  if (activityLevel === 'SEDENTARY' || (bcs !== undefined && bcs >= 7)) {
    return { factor: 1.2, note: '久坐 / 肥胖倾向' }
  }
  return neutered
    ? { factor: 1.6, note: '已绝育成年猫' }
    : { factor: 1.4, note: '未绝育成年猫' }
}

export function calcMer(weightKg: number, input: MerFactorInput): {
  rer: number
  factor: number
  factorNote: string
  mer: number
} {
  const rer = calcRer(weightKg)
  const { factor, note } = merFactor(input)
  return { rer, factor, factorNote: note, mer: rer * factor }
}

/** 每日主粮克数 */
export function calcDailyGrams(merKcal: number, kcalPerKg: number): number {
  return merKcal / (kcalPerKg / 1000)
}

/** 零食热量上限：10% MER */
export function snackBudget(merKcal: number): number {
  return merKcal * 0.1
}
