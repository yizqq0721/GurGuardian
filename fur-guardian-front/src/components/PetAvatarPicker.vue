<template>
  <div class="avatar-picker">
    <div class="avatar-grid" role="radiogroup" :aria-label="`${speciesLabel}头像`">
      <button
        v-for="(option, i) in options"
        :key="option.key"
        type="button"
        role="radio"
        :aria-checked="modelValue === option.key"
        :aria-label="`${speciesLabel}头像 ${i + 1}`"
        class="avatar-opt"
        :class="{ 'is-active': modelValue === option.key }"
        @click="toggle(option.key)"
      >
        <img :src="option.url" alt="" loading="lazy" draggable="false" />
        <span v-if="modelValue === option.key" class="pick-mark" aria-hidden="true">
          <Check :size="11" />
        </span>
      </button>
    </div>
    <p class="pick-hint fg-muted">
      选一张插画作为{{ speciesLabel }}头像，再次点击已选头像可取消。
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'
import { Check } from 'lucide-vue-next'
import { avatarBelongsToSpecies, PET_AVATAR_OPTIONS } from '@/utils/petAvatar'
import type { Species } from '@/types'

const props = defineProps<{
  modelValue?: string | null
  species: Species
}>()

const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()

const options = computed(() => PET_AVATAR_OPTIONS.filter((o) => o.species === props.species))
const speciesLabel = computed(() => (props.species === 'cat' ? '猫咪' : '狗狗'))

watch(
  () => props.species,
  (species) => {
    if (!avatarBelongsToSpecies(props.modelValue, species)) emit('update:modelValue', '')
  },
)

function toggle(key: string) {
  emit('update:modelValue', props.modelValue === key ? '' : key)
}
</script>

<style scoped>
.avatar-picker {
  width: 100%;
}

.avatar-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(56px, 1fr));
  gap: var(--fg-s2);
  width: 100%;
  max-width: 640px;
}

.avatar-opt {
  position: relative;
  aspect-ratio: 1;
  padding: 0;
  background: var(--fg-paper);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
  cursor: pointer;
  transition: border-color var(--fg-motion);
}

.avatar-opt img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-opt:hover {
  border-color: var(--fg-line-strong);
}

.avatar-opt.is-active {
  border-color: var(--fg-accent);
  outline: 1px solid var(--fg-accent);
  outline-offset: -1px;
}

.pick-mark {
  position: absolute;
  right: 3px;
  bottom: 3px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: var(--fg-accent);
  color: var(--fg-surface);
  border-radius: 3px;
}

.pick-hint {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

@media (max-width: 640px) {
  .avatar-grid {
    grid-template-columns: repeat(auto-fill, minmax(52px, 1fr));
  }
}
</style>
