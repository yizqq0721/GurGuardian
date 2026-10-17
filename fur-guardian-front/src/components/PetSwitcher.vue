<template>
  <el-select
    v-if="petStore.pets.length > 1"
    :model-value="petStore.currentPet?.id"
    size="small"
    style="width: 140px"
    @change="handleChange"
  >
    <el-option
      v-for="pet in petStore.pets"
      :key="pet.id"
      :value="pet.id"
      :label="`${pet.species === 'dog' ? '🐶' : '🐱'} ${pet.name}`"
    />
  </el-select>
  <el-tag v-else-if="petStore.currentPet" size="small" effect="plain">
    {{ petStore.currentPet.species === 'dog' ? '🐶' : '🐱' }} {{ petStore.currentPet.name }}
  </el-tag>
</template>

<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { usePetStore } from '@/stores/pet'

const petStore = usePetStore()
const router = useRouter()
const route = useRoute()

function handleChange(id: number) {
  petStore.setCurrentPet(id)
  // 若当前在宠物相关页面，跳转到新宠物对应页面
  const petPageMatch = route.path.match(/^\/pets\/(\d+)(.*)$/)
  if (petPageMatch) {
    router.push(`/pets/${id}${petPageMatch[2]}`)
  }
}
</script>
