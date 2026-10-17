<template>
  <div class="onboarding-page">
    <div class="onboarding-card fg-card">
      <h2 class="fg-section-title">🐾 创建你的第一个宠物档案</h2>
      <p class="fg-muted">只需 4 步，完成后即可生成个体化营养方案。所有信息之后都可以修改。</p>

      <el-steps :active="step" align-center class="steps">
        <el-step title="基本信息" />
        <el-step title="身体数据" />
        <el-step title="体况评分" />
        <el-step title="完成" />
      </el-steps>

      <!-- 第 1 步：基本信息 -->
      <div v-show="step === 0" class="step-body">
        <el-form label-position="top">
          <el-form-item label="它叫什么名字？" required>
            <el-input v-model="form.name" placeholder="例如：豆豆" maxlength="20" />
          </el-form-item>
          <el-form-item label="物种" required>
            <el-radio-group v-model="form.species" size="large">
              <el-radio-button value="dog">🐶 狗狗</el-radio-button>
              <el-radio-button value="cat">🐱 猫咪</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="品种">
            <el-input v-model="form.breed" placeholder="例如：玩具贵宾 / 英短（选填）" />
          </el-form-item>
          <el-form-item label="性别" required>
            <el-radio-group v-model="form.sex">
              <el-radio-button value="male">男孩</el-radio-button>
              <el-radio-button value="female">女孩</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </div>

      <!-- 第 2 步：身体数据 -->
      <div v-show="step === 1" class="step-body">
        <el-form label-position="top">
          <el-form-item label="出生日期">
            <el-date-picker
              v-model="form.birthday"
              type="date"
              value-format="YYYY-MM-DD"
              placeholder="不记得准确日期可估计"
              :disabled-date="(d: Date) => d.getTime() > Date.now()"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="是否绝育">
            <el-radio-group v-model="form.neutered">
              <el-radio-button :value="true">已绝育</el-radio-button>
              <el-radio-button :value="false">未绝育</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="活动量">
            <el-select v-model="form.activityLevel" style="width: 100%">
              <el-option v-for="o in ACTIVITY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
            </el-select>
          </el-form-item>
          <el-form-item label="生理状态">
            <el-select v-model="form.physiology" style="width: 100%">
              <el-option v-for="o in PHYSIOLOGY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
            </el-select>
          </el-form-item>
        </el-form>
      </div>

      <!-- 第 3 步：BCS -->
      <div v-show="step === 2" class="step-body">
        <BcsPicker v-model="form.bcs" />
        <el-form label-position="top" style="margin-top: 16px">
          <el-form-item label="当前体重 (kg)">
            <el-input-number v-model="weight" :min="0.5" :max="80" :step="0.1" :precision="1" />
            <span class="fg-muted" style="margin-left: 12px">选填，用于生成首条体重记录</span>
          </el-form-item>
        </el-form>
      </div>

      <!-- 第 4 步：完成 -->
      <div v-show="step === 3" class="step-body done">
        <div class="done-icon">🎉</div>
        <h3>{{ form.name }} 的档案已创建</h3>
        <p class="fg-muted">接下来去录入主粮，就能生成每日喂食方案了。</p>
      </div>

      <div class="step-actions">
        <el-button v-if="step > 0 && step < 3" @click="step--">上一步</el-button>
        <el-button v-if="step < 2" type="primary" :disabled="step === 0 && !canNextStep0" @click="step++">
          下一步
        </el-button>
        <el-button v-if="step === 2" type="primary" :loading="submitting" @click="submit">
          创建档案
        </el-button>
        <el-button v-if="step === 3" type="primary" @click="goFoods">去录入主粮</el-button>
        <el-button v-if="step === 3" @click="goPets">先看看主页</el-button>
        <el-button v-if="step < 3" text class="skip-btn" @click="skip">跳过引导</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { petApi } from '@/api/pet'
import { usePetStore } from '@/stores/pet'
import BcsPicker from '@/components/BcsPicker.vue'
import { ACTIVITY_OPTIONS, PHYSIOLOGY_OPTIONS } from '@/utils/constants'
import type { ActivityLevel, Physiology, Sex, Species } from '@/types'

const router = useRouter()
const petStore = usePetStore()

const step = ref(0)
const submitting = ref(false)
const createdPetId = ref<number | null>(null)
const weight = ref<number>()

const form = reactive({
  name: '',
  species: 'dog' as Species,
  breed: '',
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
.onboarding-page {
  min-height: 100vh;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 48px 24px;
  background: linear-gradient(160deg, #fff3e4 0%, #fdf8f3 70%);
}

.onboarding-card {
  width: 640px;
  padding: 32px 40px;
}

.steps {
  margin: 24px 0;
}

.step-body {
  min-height: 320px;
}

.step-body.done {
  text-align: center;
  padding-top: 48px;
}

.done-icon {
  font-size: 48px;
}

.step-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 16px;
}

.skip-btn {
  position: absolute;
  right: 24px;
}

.onboarding-card {
  position: relative;
}
</style>
