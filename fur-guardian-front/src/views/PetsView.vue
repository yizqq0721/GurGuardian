<template>
  <div class="fg-page">
    <div class="page-head">
      <h2 class="fg-section-title">我的宠物</h2>
      <el-button type="primary" @click="router.push('/onboarding')">+ 添加宠物</el-button>
    </div>

    <el-empty v-if="!loading && petStore.pets.length === 0" description="还没有宠物档案">
      <el-button type="primary" @click="router.push('/onboarding')">立即创建</el-button>
    </el-empty>

    <div v-loading="loading" class="pet-grid">
      <div v-for="pet in petStore.pets" :key="pet.id" class="pet-card fg-card" @click="goPet(pet.id)">
        <div class="pet-avatar">{{ pet.species === 'dog' ? '🐶' : '🐱' }}</div>
        <div class="pet-info">
          <div class="pet-name">
            {{ pet.name }}
            <el-tag size="small" :type="pet.sex === 'male' ? 'primary' : 'danger'" effect="plain">
              {{ pet.sex === 'male' ? '♂' : '♀' }}
            </el-tag>
          </div>
          <div class="fg-muted">{{ pet.breed || '品种未填写' }}</div>
          <div class="pet-tags">
            <el-tag size="small" effect="plain">{{ ageText(pet) }}</el-tag>
            <el-tag v-if="pet.bcs" size="small" effect="plain" :color="bcsGroup(pet.bcs).color + '22'">
              BCS {{ pet.bcs }}
            </el-tag>
            <el-tag v-if="pet.neutered" size="small" effect="plain">已绝育</el-tag>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import dayjs from 'dayjs'
import { usePetStore } from '@/stores/pet'
import { bcsGroup } from '@/utils/constants'
import type { Pet } from '@/types'

const router = useRouter()
const petStore = usePetStore()
const loading = ref(false)

onMounted(async () => {
  loading.value = true
  try {
    await petStore.fetchPets(true)
  } finally {
    loading.value = false
  }
})

function ageText(pet: Pet): string {
  if (!pet.birthday) return '年龄未知'
  const months = dayjs().diff(dayjs(pet.birthday), 'month')
  if (months < 12) return `${months} 月龄`
  const years = Math.floor(months / 12)
  return `${years} 岁${months % 12 ? ` ${months % 12} 个月` : ''}`
}

function goPet(id: number) {
  petStore.setCurrentPet(id)
  router.push(`/pets/${id}`)
}
</script>

<style scoped>
.page-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.pet-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
  min-height: 120px;
}

.pet-card {
  display: flex;
  gap: 16px;
  align-items: center;
  cursor: pointer;
  transition: box-shadow 0.15s;
}

.pet-card:hover {
  box-shadow: 0 4px 16px rgba(232, 133, 61, 0.15);
}

.pet-avatar {
  font-size: 44px;
  width: 72px;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fdf3e7;
  border-radius: 50%;
  flex-shrink: 0;
}

.pet-name {
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.pet-tags {
  display: flex;
  gap: 6px;
  margin-top: 8px;
  flex-wrap: wrap;
}
</style>
