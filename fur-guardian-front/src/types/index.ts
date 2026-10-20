export interface Result<T = unknown> {
  code: number
  message: string
  data: T
  timestamp: number
}

export interface PageResult<T> {
  records: T[]
  total: number
  size: number
  current: number
  pages: number
}

export type Species = 'dog' | 'cat'
export type Sex = 'male' | 'female'
export type ActivityLevel = 'SEDENTARY' | 'LOW' | 'MODERATE' | 'HIGH' | 'WORKING'
export type Physiology = 'NORMAL' | 'PREGNANT' | 'LACTATING'
export type FoodType = 'DRY' | 'WET' | 'FREEZE_DRIED' | 'SNACK' | 'CANNED'
export type ProductType = 'COMPLETE' | 'COMPLEMENTARY' | 'SNACK'
export type LifeStage = 'ALL' | 'BABY' | 'ADULT' | 'SENIOR'
export type SpeciesScope = 'DOG' | 'CAT' | 'BOTH'
export type ReminderType = 'FEED' | 'WALK' | 'WATER' | 'GROOMING' | 'DEWORM' | 'VACCINE' | 'BATH' | 'CUSTOM'
export type RepeatRule = 'DAILY' | 'WEEKLY' | 'MONTHLY' | 'YEARLY' | 'ONCE'

export interface LoginResp {
  token: string
  userId: number
  nickname: string
}

export interface Pet {
  id: number
  name: string
  species: Species
  breed?: string
  sex: Sex
  neutered: number | boolean
  birthday?: string
  activityLevel?: ActivityLevel
  bcs?: number
  physiology?: Physiology
  avatar?: string | null
  createdAt?: string
  updatedAt?: string
}

export interface PetForm {
  name: string
  species: Species
  breed?: string
  avatar?: string
  sex: Sex
  neutered?: boolean
  birthday?: string
  activityLevel?: ActivityLevel
  bcs?: number
  physiology?: Physiology
}

export interface WeightLog {
  id: number
  petId: number
  weightKg: number
  bcs?: number
  recordedAt: string
  createdAt?: string
}

export interface FoodNutrients {
  moistureMax?: number
  crudeProteinMin?: number
  crudeFatMin?: number
  crudeFiberMax?: number
  ashMax?: number
  calciumMin?: number
  phosphorusMin?: number
  taurineMin?: number
  lysineMin?: number
}

export interface Food {
  id: number
  name: string
  brand?: string
  foodType?: FoodType
  productType?: ProductType
  lifeStage?: LifeStage
  speciesScope?: SpeciesScope
  labeledMeKcal?: number
  ingredients?: string
  nutrients?: FoodNutrients
  createdAt?: string
}

export interface FoodForm {
  name: string
  brand?: string
  foodType?: FoodType
  productType?: ProductType
  lifeStage?: LifeStage
  speciesScope?: SpeciesScope
  labeledMeKcal?: number
  ingredients?: string
  nutrients?: FoodNutrients
}

export interface NutrientValidation {
  nutrient: string
  actualValue: number
  requiredMin?: number
  requiredMax?: number
  passed: boolean
  unit: string
}

export interface NutritionPlan {
  rerKcal: number
  merKcal: number
  mainFoodGrams: number
  snackBudgetKcal: number
  snackBudgetGrams: number
  mealsPerDay: number
  gramsPerMeal: number
  energyDensityKcalPer100g: number
  energyEstimated: boolean
  calculationProcess: string
  idealWeightUsed?: number | null
  overweight: boolean
  underweight: boolean
  weightAdvice?: string | null
  validations: NutrientValidation[]
  warnings: string[]
}

export interface RecipeSource {
  docId: number
  title: string
  sourceName?: string
}

export interface RecipeSnack {
  id: number
  name: string
  brand?: string
  labeledMeKcal?: number
  /** 零食额度全部给这一种时的每日上限克数 */
  maxGrams?: number
}

export interface NutritionRecipe {
  content: string
  sources: RecipeSource[]
  snacks: RecipeSnack[]
  /** AI 不可用时返回的确定性兜底建议 */
  isFallback: boolean
}

export interface Reminder {
  id: number
  petId: number
  title: string
  reminderType: ReminderType
  remindTime?: string
  relativeMin?: number
  repeatRule?: RepeatRule
  repeatDays?: string
  createdAt?: string
}

export interface ReminderForm {
  petId: number
  title: string
  reminderType: ReminderType
  remindTime?: string
  relativeMin?: number
  repeatRule?: RepeatRule
  repeatDays?: string
}

export interface ReminderLog {
  id: number
  reminderId: number
  petId: number
  doneDate: string
  note?: string
  createdAt?: string
}

export interface Tip {
  id: number
  petId: number
  tipDate: string
  content: string
  sourceDocId?: number
  sourceName?: string
  /** 1 有用 / 0 没帮助 / null 未反馈（对应后端 tips.feedback TINYINT） */
  feedback?: number | null
  isMock: number
  createdAt?: string
}

export interface ReportRule {
  ruleId: string
  ruleName: string
  triggered: boolean
  severity: 'info' | 'warn' | 'danger'
  suggestion: string
  detail: string
}

export interface ReportConclusion {
  rules: ReportRule[]
  summary: string
}

export interface WeeklyReport {
  id: number
  petId: number
  weekStart: string
  weekEnd: string
  weightStartKg?: number
  weightEndKg?: number
  weightChangePct?: number
  bcsStart?: number
  bcsEnd?: number
  feedingCompliance?: number
  snackOverLimit?: number
  ruleConclusions?: string
  llmSummary?: string | null
  status: string
  createdAt?: string
}

export interface AiSource {
  docId: number
  title: string
  sourceName: string
}

export interface AiQueryResp {
  content: string
  sources: AiSource[]
  isFallback: boolean
}

export interface KnowledgeDoc {
  id: number
  title: string
  content?: string
  species?: string
  lifeStage?: string
  topics?: string
  severity?: 'informational' | 'caution' | 'emergency'
  sourceName?: string
  sourceUrl?: string
  updatedAt?: string
}

/** 游标翻页：nextCursor 原样回传即可，不用解析它的格式 */
export interface CursorPage<T> {
  records: T[]
  nextCursor: string | null
  hasMore: boolean
}

/** 会话里的来源快照，比 AiSource 多 sourceType/severity（服务端回查知识库补全） */
export interface ChatSource {
  docId: number
  title: string
  sourceName: string
  sourceType?: string
  severity?: string
}

export interface ChatMessage {
  id: number
  role: 'user' | 'ai'
  content: string
  sources: ChatSource[]
  isRedLine: boolean
  isFallback: boolean
  createdAt: string
}

export interface ChatSession {
  id: number
  title: string
  petId?: number | null
  messageCount: number
  sourceCount: number
  createdAt: string
  updatedAt: string
}
