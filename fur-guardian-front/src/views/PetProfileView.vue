<template>
  <div class="fg-page" v-loading="loading">
    <div class="fg-card" style="max-width: 720px; margin: 0 auto">
      <h2 class="fg-section-title">档案详情 · {{ form.name }}</h2>
      <el-form label-position="top">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="昵称" required>
              <el-input v-model="form.name" maxlength="20" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="品种">
              <el-input v-model="form.breed" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="物种" required>
              <el-radio-group v-model="form.species">
                <el-radio-button value="dog">🐶 犬</el-radio-button>
                <el-radio-button value="cat">🐱 猫</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" required>
              <el-radio-group v-model="form.sex">
                <el-radio-button value="male">公</el-radio-button>
                <el-radio-button value="female">母</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出生日期">
              <el-date-picker
                v-model="form.birthday"
                type="date"
                value-format="YYYY-MM-DD"
                :disabled-date="(d: Date) => d.getTime() > Date.now()"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否绝育">
              <el-radio-group v-model="form.neutered">
                <el-radio-button :value="true">已绝育</el-radio-button>
                <el-radio-button :value="false">未绝育</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="活动量">
              <el-select v-model="form.activityLevel" style="width: 100%">
                <el-option v-for="o in ACTIVITY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="生理状态">
              <el-select v-model="form.physiology" style="width: 100%">
                <el-option v-for="o in PHYSIOLOGY_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="体况评分 BCS">
          <BcsPicker v-model="form.bcs" />
        </el-form-item>
      </el-form>

      <div class="form-actions">
        <el-button type="primary" :loading="saving" @click="save">保存修改</el-button>
        <el-button type="danger" plain @click="removePet">删除档案</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { petApi } from '@/api/pet'
import { usePetStore } from '@/stores/pet'
import BcsPicker from '@/components/BcsPicker.vue'
import { ACTIVITY_OPTIONS, PHYSIOLOGY_OPTIONS } from '@/utils/constants'
import type { ActivityLevel, Physiology, Sex, Species } from '@/types'

const route = useRoute()
const router = useRouter()
const petStore = usePetStore()
const petId = Number(route.params.id)

const loading = ref(false)
const saving = ref(false)

const form = reactive({
  name: '',
  species: 'dog' as Species,
  breed: '',
  sex: 'male' as Sex,
  neutered: false,
  birthday: '',
  activityLevel: 'LOW' as ActivityLevel,
  physiology: 'NORMAL' as Physiology,
  bcs: 5,
})

onMounted(async () => {
  loading.value = true
  try {
    const pet = await petApi.detail(petId)
    Object.assign(form, {
      name: pet.name,
      species: pet.species,
      breed: pet.breed || '',
      sex: pet.sex,
      neutered: !!pet.neutered,
      birthday: pet.birthday || '',
      activityLevel: pet.activityLevel || 'LOW',
      physiology: pet.physiology || 'NORMAL',
      bcs: pet.bcs ?? 5,
    })
  } finally {
    loading.value = false
  }
})

async function save() {
  saving.value = true
  try {
    await petApi.update(petId, {
      name: form.name,
      species: form.species,
      breed: form.breed || undefined,
      sex: form.sex,
      neutered: form.neutered,
      birthday: form.birthday || undefined,
      activityLevel: form.activityLevel,
      physiology: form.physiology,
      bcs: form.bcs,
    })
    await petStore.fetchPets(true)
    ElMessage.success('已保存')
  } finally {
    saving.value = false
  }
}

async function removePet() {
  await ElMessageBox.confirm(
    `确定删除「${form.name}」的档案吗？相关的体重记录和提醒将一并删除，此操作不可恢复。`,
    '删除确认',
    { type: 'warning', confirmButtonText: '删除', confirmButtonClass: 'el-button--danger' },
  )
  await petApi.remove(petId)
  await petStore.fetchPets(true)
  ElMessage.success('已删除')
  router.push('/pets')
}
</script>

<style scoped>
.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 8px;
}
</style>
