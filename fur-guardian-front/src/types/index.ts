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
  isAdmin: boolean
}

export interface UserProfile {
  userId: number
  username: string
  nickname?: string
  /** 当前位置，精确到区/县，用于天气与遛弯建议 */
  location?: string
}

/** 反向地理编码结果，label 只到区/县，不含街道门牌 */
export interface GeoAddress {
  province?: string
  city?: string
  district?: string
  label: string
}

export interface AdminUser {
  id: number
  username: string
  nickname?: string
  avatar?: string
  status: number
  isAdmin: boolean
  petCount: number
  createdAt?: string
}

export interface AdminPet {
  id: number
  name: string
  species: Species
  breed?: string
  sex?: Sex
  birthday?: string
  avatar?: string
  createdAt?: string
}

export interface AdminUserDetail {
  id: number
  username: string
  nickname?: string
  avatar?: string
  status: number
  isAdmin: boolean
  createdAt?: string
  updatedAt?: string
  pets: AdminPet[]
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

export interface WeatherToday {
  location: string
  text: string
  textNight?: string
  high: number
  low: number
  windDirection?: string
  windScale?: string
  humidity?: string
  precip?: number
  level: 'GOOD' | 'CAUTION' | 'AVOID'
  advice: string
}

export interface Reminder {
  id: number
  petId: number
  title: string
  reminderType: ReminderType
  remindTime?: string
  relativeMin?: number
  remindDate?: string
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
  remindDate?: string
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

export interface FeedingLog {
  id: number
  petId: number
  foodId: number
  fedDate: string
  mealIndex: number
  grams: number
  /** 按食品标注代谢能折算的这一餐热量，食品未标注时为 null */
  kcal?: number | null
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

/** 周边资源分类：medical=宠物医疗（宠物诊所/兽医站），park=公园 */
export type PlaceCategory = 'medical' | 'park'

export interface NearbyPlace {
  id: string
  name: string
  /** 高德类型串，如 "医疗保健服务;动物医疗保健;宠物诊所"，末段为最具体分类 */
  type: string
  address?: string | null
  tel?: string | null
  /** GCJ-02 火星坐标 */
  lat: number
  lng: number
  distanceMeters: number
}

export interface WalkRoute {
  distanceMeters: number
  durationSeconds: number
  /** 折线点串 [[lng, lat], ...] */
  polyline: [number, number][]
}
