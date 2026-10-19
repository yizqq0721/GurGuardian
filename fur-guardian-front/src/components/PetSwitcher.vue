<template>
  <el-select
    v-if="petStore.pets.length > 1"
    :model-value="petStore.currentPet?.id"
    class="pet-switcher"
    popper-class="pet-switcher-popper"
    @change="handleChange"
  >
    <template #prefix>
      <component :is="speciesIcon(petStore.currentPet?.species)" :size="16" class="fg-icon" />
    </template>
    <el-option
      v-for="pet in petStore.pets"
      :key="pet.id"
      :value="pet.id"
      :label="pet.name"
    >
      <span class="opt">
        <component :is="speciesIcon(pet.species)" :size="16" class="fg-icon" />
        <span>{{ pet.name }}</span>
        <span class="opt-breed fg-muted">{{ pet.breed }}</span>
      </span>
    </el-option>
  </el-select>

  <span v-else-if="petStore.currentPet" class="pet-current">
    <component :is="speciesIcon(petStore.currentPet.species)" :size="16" class="fg-icon" />
    <span>{{ petStore.currentPet.name }}</span>
  </span>
</template>

<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { Dog, Cat } from 'lucide-vue-next'
import { usePetStore } from '@/stores/pet'

const petStore = usePetStore()
const router = useRouter()
const route = useRoute()

function speciesIcon(species?: string) {
  return species === 'cat' ? Cat : Dog
}

function handleChange(id: number) {
  petStore.setCurrentPet(id)
  // 若当前在宠物相关页面，跳转到新宠物对应页面
  const petPageMatch = route.path.match(/^\/pets\/(\d+)(.*)$/)
  if (petPageMatch) {
    router.push(`/pets/${id}${petPageMatch[2]}`)
  }
}
</script>

<style scoped>
.pet-switcher {
  width: 160px;
}

.pet-switcher :deep(.el-select__wrapper) {
  border-color: transparent;
  background: transparent;
  box-shadow: none !important;
  padding-left: 0;
  font-size: var(--fg-text-body);
}

.pet-switcher :deep(.el-select__wrapper:hover) {
  border-color: var(--fg-line);
}

.pet-switcher :deep(.el-select__wrapper.is-focused) {
  border-color: var(--fg-accent);
  box-shadow: 0 0 0 2px var(--fg-accent-soft) !important;
}

.pet-current {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
}

.opt {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
}

.opt-breed {
  font-size: var(--fg-text-label);
  margin-left: auto;
  padding-left: var(--fg-s4);
}
</style>
