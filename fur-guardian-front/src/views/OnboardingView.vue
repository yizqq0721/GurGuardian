<template>
  <div class="ob-page">
    <div class="ob-col">
      <header class="ob-head">
        <p class="ob-kicker">创建你的第一个宠物档案</p>
        <p class="ob-progress fg-mono">{{ step + 1 }} / 4</p>
        <div class="ob-track" aria-hidden="true">
          <span class="ob-fill" :style="{ width: `${(step + 1) * 25}%` }" />
        </div>
        <h1 class="fg-h2 ob-title">{{ STEP_LABELS[step] }}</h1>
        <p v-if="step < 3" class="ob-sub">只需 4 步，完成后即可生成个体化营养方案。所有信息之后都可以修改。</p>
      </header>

      <!-- 第 1 步：基本信息 -->
      <section v-show="step === 0" class="ob-body">
        <el-form label-position="top" class="ob-form">
          <el-form-item label="它叫什么名字？" required>
            <el-input v-model="form.name" size="large" placeholder="例如：豆豆" maxlength="20" />
          </el-form-item>

          <el-form-item label="物种" required>
            <div class="species-group" role="radiogroup" aria-label="物种">
              <button
                v-for="s in SPECIES_OPTIONS"
                :key="s.value"
                type="button"
                role="radio"
                :aria-checked="form.species === s.value"
                class="species-btn"
                :class="{ 'is-active': form.species === s.value }"
                @click="form.species = s.value"
              >
                <component :is="s.icon" :size="24" class="fg-icon" />
                <span>{{ s.label }}</span>
              </button>
            </div>
          </el-form-item>

          <el-form-item label="头像（选填）">
            <PetAvatarPicker v-model="form.avatar" :species="form.species" />
          </el-form-item>

          <el-form-item label="品种">
            <el-input v-model="form.breed" size="large" placeholder="例如：玩具贵宾 / 英短（选填）" />
          </el-form-item>

          <el-form-item label="性别" required>
            <el-radio-group v-model="form.sex" class="seg">
              <el-radio-button value="male">男孩</el-radio-button>
              <el-radio-button value="female">女孩</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </section>

      <!-- 第 2 步：身体数据 -->
      <section v-show="step === 1" class="ob-body">
        <el-form label-position="top" class="ob-form">
          <el-form-item label="出生日期">
            <el-date-picker
              v-model="form.birthday"
              type="date"
              size="large"
              value-format="YYYY-MM-DD"
              placeholder="不记得准确日期可估计"
              :disabled-date="(d: Date) => d.getTime() > Date.now()"
              style="width: 100%"
            />
          </el-form-item>

          <el-form-item label="是否绝育">
            <el-radio-group v-model="form.neutered" class="seg">
              <el-radio-button :value="true">已绝育</el-radio-button>
              <el-radio-button :value="false">未绝育</el-radio-button>
            </el-radio-group>
          </el-form-item>

          <el-form-item label="活动量">
            <el-select v-model="form.activityLevel" size="large" style="width: 100%">
              <el-option v-for="o in ACTIVITY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
            </el-select>
          </el-form-item>

          <el-form-item label="生理状态">
            <el-select v-model="form.physiology" size="large" style="width: 100%">
              <el-option v-for="o in PHYSIOLOGY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
            </el-select>
          </el-form-item>
        </el-form>
      </section>

      <!-- 第 3 步：体况评分 + 体重 -->
      <section v-show="step === 2" class="ob-body">
        <p class="bcs-lead">
          体况评分 BCS（9 分制）：俯视和侧视观察宠物的腰线与肋骨触感，选择最接近的一档。4-5 分为理想体态。
        </p>
        <BcsScale v-model="form.bcs" />
        <BcsReference :species="form.species" />

        <el-form label-position="top" class="ob-form bcs-form">
          <el-form-item label="当前体重 (kg)">
            <div class="weight-wrap">
              <div class="weight-line">
                <el-input-number
                  v-model="weight"
                  class="weight-num"
                  size="large"
                  :min="0.5"
                  :max="80"
                  :step="0.1"
                  :precision="1"
                  :controls="false"
                />
                <span class="weight-unit fg-unit">kg</span>
              </div>
              <span class="weight-hint">选填，用于生成首条体重记录</span>
            </div>
          </el-form-item>
        </el-form>
      </section>

      <!-- 第 4 步：完成 -->
      <section v-show="step === 3" class="ob-body done">
        <CircleCheck :size="24" class="fg-icon done-mark" />
        <h2 class="fg-h3 done-title">{{ form.name }} 的档案已创建</h2>
        <p class="ob-sub">接下来去录入主粮，就能生成每日喂食方案了。</p>
      </section>

      <footer class="ob-bar">
        <div class="bar-left">
          <el-button v-if="step > 0 && step < 3" text @click="step--">上一步</el-button>
        </div>
        <div class="bar-right">
          <el-button v-if="step < 3" text class="skip-btn" @click="skip">跳过引导</el-button>
          <el-button v-if="step < 2" type="primary" size="large" :disabled="step === 0 && !canNextStep0" @click="step++">
            继续
          </el-button>
          <el-button v-if="step === 2" type="primary" size="large" :loading="submitting" @click="submit">
            创建档案
          </el-button>
          <template v-if="step === 3">
            <el-button type="primary" size="large" @click="goFoods">去录入主粮</el-button>
            <el-button size="large" @click="goPets">先看看主页</el-button>
          </template>
        </div>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { Cat, CircleCheck, Dog } from 'lucide-vue-next'
import { petApi } from '@/api/pet'
import { usePetStore } from '@/stores/pet'
import BcsReference from '@/components/BcsReference.vue'
import BcsScale from '@/components/BcsScale.vue'
import PetAvatarPicker from '@/components/PetAvatarPicker.vue'
import { ACTIVITY_OPTIONS, PHYSIOLOGY_OPTIONS } from '@/utils/constants'
import type { ActivityLevel, Physiology, Sex, Species } from '@/types'

const router = useRouter()
const petStore = usePetStore()

const SPECIES_OPTIONS = [
  { value: 'dog' as Species, label: '犬', icon: Dog },
  { value: 'cat' as Species, label: '猫', icon: Cat },
]

const STEP_LABELS = ['基本信息', '身体数据', '体况评分与体重', '创建完成']

const step = ref(0)
const submitting = ref(false)
const createdPetId = ref<number | null>(null)
const weight = ref<number>()

const form = reactive({
  name: '',
  species: 'dog' as Species,
  breed: '',
  avatar: '',
  sex: 'male' as Sex,
  neutered: true,
  birthday: '',
  activityLevel: 'LOW' as ActivityLevel,
  physiology: 'NORMAL' as Physiology,
  bcs: 5,
})

const canNextStep0 = computed(() => form.name.trim().length > 0)

async function submit() {
  submitting.value = true
  try {
    const id = await petApi.create({
      name: form.name.trim(),
      species: form.species,
      breed: form.breed || undefined,
      avatar: form.avatar || undefined,
      sex: form.sex,
      neutered: form.neutered,
      birthday: form.birthday || undefined,
      activityLevel: form.activityLevel,
      physiology: form.physiology,
      bcs: form.bcs,
    })
    createdPetId.value = id
    if (weight.value) {
      await petApi.addWeight(id, {
        weightKg: weight.value,
        bcs: form.bcs,
        recordedAt: dayjs().format('YYYY-MM-DD'),
      })
    }
    await petStore.fetchPets(true)
    petStore.setCurrentPet(id)
    step.value = 3
  } catch {
    ElMessage.error('创建失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}

function skip() {
  router.push('/pets')
}

function goFoods() {
  router.push('/foods/new')
}

function goPets() {
  router.push(createdPetId.value ? `/pets/${createdPetId.value}` : '/pets')
}
</script>

<style scoped>
.ob-page {
  min-height: 100vh;
  background: transparent;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: var(--fg-s8) var(--fg-s5) var(--fg-s8);
}

/* 单列 560px，正文直接落在纸上，不嵌套卡片 */
.ob-col {
  width: 560px;
  max-width: 100%;
  display: flex;
  flex-direction: column;
}

.ob-head {
  padding-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.ob-kicker {
  margin: 0 0 var(--fg-s4);
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
}

.ob-progress {
  margin: 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.ob-track {
  margin-top: var(--fg-s2);
  height: 2px;
  background: var(--fg-line);
  overflow: hidden;
}

.ob-fill {
  display: block;
  height: 100%;
  background: var(--fg-accent);
  transition: width var(--fg-motion);
}

.ob-title {
  margin: var(--fg-s5) 0 var(--fg-s2);
  font-size: var(--fg-text-h2);
}

.ob-sub {
  margin: 0;
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.ob-body {
  flex: 1;
  min-height: 360px;
  padding-top: var(--fg-s6);
}

/* ---------- 表单 ---------- */
.ob-form :deep(.el-form-item) {
  margin-bottom: var(--fg-s5);
}

.ob-form :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  font-weight: 500;
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
  line-height: 1.6;
  padding-bottom: var(--fg-s2);
}

.ob-form :deep(.el-input__wrapper) {
  height: 40px;
  padding: 0 var(--fg-s3);
}

.ob-form :deep(.el-select__wrapper) {
  min-height: 40px;
}

/* 数字与日期用等宽数字，避免跳动；文本框保持无衬线 */
.ob-form :deep(.el-input-number .el-input__inner),
.ob-form :deep(.el-date-editor .el-input__inner) {
  font-family: var(--fg-font-num);
  font-variant-numeric: tabular-nums;
}

/* 犬 / 猫：64px 高分段按钮 */
.species-group {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s3);
  width: 100%;
}

.species-btn {
  appearance: none;
  height: 64px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--fg-s3);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  color: var(--fg-ink);
  font-family: inherit;
  font-size: var(--fg-text-lead);
  font-weight: 500;
  cursor: pointer;
  transition: background var(--fg-motion), border-color var(--fg-motion), color var(--fg-motion);
}

.species-btn:hover {
  border-color: var(--fg-line-strong);
  color: var(--fg-accent);
}

.species-btn.is-active {
  background: var(--fg-accent-soft);
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

/* 性别 / 绝育：发丝分段按钮 */
.seg {
  gap: var(--fg-s2);
}

.seg :deep(.el-radio-button .el-radio-button__inner) {
  outline: none;
  box-shadow: none !important;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  height: 40px;
  min-width: 108px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0 var(--fg-s4);
  font-size: var(--fg-text-body);
  font-weight: 500;
  background: var(--fg-surface);
  color: var(--fg-ink);
  transition: background var(--fg-motion), border-color var(--fg-motion), color var(--fg-motion);
}

.seg :deep(.el-radio-button .el-radio-button__inner:hover) {
  color: var(--fg-accent);
  border-color: var(--fg-line-strong);
}

.seg :deep(.el-radio-button.is-active .el-radio-button__inner) {
  background: var(--fg-accent-soft);
  border-color: var(--fg-accent);
  color: var(--fg-accent);
  box-shadow: none !important;
}

/* ---------- BCS ---------- */
.bcs-lead {
  margin: 0 0 var(--fg-s4);
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.bcs-form {
  margin-top: var(--fg-s6);
}

.weight-wrap {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--fg-s2);
}

.weight-line {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
}

.weight-num {
  width: 160px;
}

.weight-num :deep(.el-input__wrapper) {
  padding: 0 var(--fg-s3);
}

.weight-unit {
  margin-left: 0;
  font-size: var(--fg-text-lead);
}

.weight-hint {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

/* ---------- 完成 ---------- */
.done {
  padding-top: var(--fg-s7);
}

.done-mark {
  color: var(--fg-accent);
}

.done-title {
  margin: var(--fg-s4) 0 var(--fg-s2);
}

/* ---------- 底部操作条 ---------- */
.ob-bar {
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s4);
}

.bar-left {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.bar-right {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.bar-right .skip-btn {
  color: var(--fg-ink-muted);
}

.bar-right .skip-btn:hover {
  color: var(--fg-accent);
}

@media (max-width: 640px) {
  .ob-page {
    padding: var(--fg-s6) var(--fg-s4);
  }
  .species-group {
    grid-template-columns: minmax(0, 1fr);
  }
}

/* ============================================================
   响应式新增：<768px 手机端（桌面端不受影响）
   ============================================================ */
@media (max-width: 767.98px) {
  .ob-page {
    padding: 24px var(--fg-s4) 32px;
  }

  .ob-head {
    padding-bottom: var(--fg-s4);
  }

  .ob-kicker {
    margin-bottom: var(--fg-s2);
  }

  .ob-title {
    margin: var(--fg-s4) 0 var(--fg-s2);
  }

  .ob-body {
    min-height: 0;
    padding-top: var(--fg-s5);
  }

  .ob-form :deep(.el-form-item) {
    margin-bottom: var(--fg-s4);
  }

  .ob-form :deep(.el-input__wrapper),
  .ob-form :deep(.el-select__wrapper) {
    height: 44px;
    min-height: 44px;
  }

  /* 物种仍为单列大按钮 */
  .species-group {
    grid-template-columns: minmax(0, 1fr);
  }

  .species-btn {
    height: 56px;
  }

  /* 分段按钮等宽铺满 */
  .seg {
    display: flex;
    width: 100%;
  }

  .seg :deep(.el-radio-button) {
    flex: 1;
  }

  .seg :deep(.el-radio-button .el-radio-button__inner) {
    width: 100%;
    min-width: 0;
    height: 44px;
  }

  .bcs-form {
    margin-top: var(--fg-s5);
  }

  .weight-num {
    width: 140px;
  }

  .done {
    padding-top: var(--fg-s6);
  }

  /* 底部操作条允许折行，按钮保持 44px */
  .ob-bar {
    flex-wrap: wrap;
    row-gap: var(--fg-s3);
    margin-top: var(--fg-s4);
  }

  .bar-right {
    flex-wrap: wrap;
    justify-content: flex-end;
    row-gap: var(--fg-s2);
  }
}
</style>
