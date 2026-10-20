<template>
  <div v-loading="loading" class="fg-page">
    <PageHeader
      title="宠物档案"
      :breadcrumb="form.name ? `${form.name} · 档案` : '宠物档案'"
      :back="{ to: `/pets/${petId}`, label: '宠物主页' }"
      description="这里的每一项都会进入 MER 与营养达标计算，改完记得保存。"
    />

    <div class="fg-card profile-card">
      <el-form label-position="top" class="profile-form">
        <section class="block">
          <h2 class="fg-section-title">基本信息</h2>
          <el-row :gutter="24">
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
                <el-radio-group v-model="form.species" class="seg">
                  <el-radio-button value="dog">
                    <Dog :size="20" class="fg-icon" />
                    犬
                  </el-radio-button>
                  <el-radio-button value="cat">
                    <Cat :size="20" class="fg-icon" />
                    猫
                  </el-radio-button>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="性别" required>
                <el-radio-group v-model="form.sex" class="seg">
                  <el-radio-button value="male">公</el-radio-button>
                  <el-radio-button value="female">母</el-radio-button>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="头像">
            <PetAvatarPicker v-model="form.avatar" :species="form.species" />
          </el-form-item>
        </section>

        <section class="block">
          <h2 class="fg-section-title">生理与活动</h2>
          <el-row :gutter="24">
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
                <el-radio-group v-model="form.neutered" class="seg">
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
        </section>

        <section class="block">
          <h2 class="fg-section-title">体况评分 BCS</h2>
          <p class="block-hint fg-muted">
            俯视与侧视观察腰线与肋骨触感，选最接近的一档；4-5 分为理想体态。
          </p>
          <BcsScale v-model="form.bcs" />
          <BcsReference :species="form.species" />
        </section>
      </el-form>

      <div class="form-actions">
        <el-button type="danger" plain @click="removePet">删除档案</el-button>
        <el-button type="primary" :loading="saving" @click="save">保存修改</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Cat, Dog } from 'lucide-vue-next'
import { petApi } from '@/api/pet'
import BcsReference from '@/components/BcsReference.vue'
import BcsScale from '@/components/BcsScale.vue'
import PageHeader from '@/components/PageHeader.vue'
import PetAvatarPicker from '@/components/PetAvatarPicker.vue'
import { usePetStore } from '@/stores/pet'
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
  avatar: '',
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
      avatar: pet.avatar || '',
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
      avatar: form.avatar,
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
.profile-card {
  max-width: 880px;
  margin: 0 auto;
}

/* 分组只靠发丝横线，不给彩色底 */
.block {
  padding-bottom: var(--fg-s2);
  margin-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.block:last-of-type {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.block-hint {
  margin: calc(-1 * var(--fg-s2)) 0 var(--fg-s4);
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

.profile-form :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  color: var(--fg-ink-muted);
  padding-bottom: var(--fg-s2);
}

.profile-form :deep(.el-form-item) {
  margin-bottom: var(--fg-s4);
}

/* 分段控件：选中 = accent-soft 底 + accent 线，不用实心色块 */
.seg :deep(.el-radio-button__inner) {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--fg-s2);
  height: 40px;
  border: var(--fg-line-w) solid var(--fg-line);
  border-left: none;
  background: var(--fg-surface);
  color: var(--fg-ink-muted);
  font-weight: 500;
  box-shadow: none !important;
  transition: background var(--fg-motion), color var(--fg-motion);
}

.seg :deep(.el-radio-button:first-child .el-radio-button__inner) {
  border-left: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius) 0 0 var(--fg-radius);
}

.seg :deep(.el-radio-button:last-child .el-radio-button__inner) {
  border-radius: 0 var(--fg-radius) var(--fg-radius) 0;
}

.seg :deep(.el-radio-button__inner:hover) {
  color: var(--fg-ink);
}

.seg :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
  position: relative;
  z-index: 1;
  background: var(--fg-accent-soft);
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.form-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--fg-s3);
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
  padding-bottom: var(--fg-s1);
}

@media (max-width: 768px) {
  .seg :deep(.el-radio-button__inner) {
    padding-left: var(--fg-s3);
    padding-right: var(--fg-s3);
  }
}
</style>
