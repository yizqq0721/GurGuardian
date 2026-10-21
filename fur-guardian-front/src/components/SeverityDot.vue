<template>
  <span class="severity-dot">
    <span class="fg-dot" :class="dotClass" aria-hidden="true" />
    <span v-if="label" class="dot-label">{{ label }}</span>
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  level: 'info' | 'warn' | 'warning' | 'danger' | 'success'
  label?: string
}>()

const dotClass = computed(() => {
  if (props.level === 'danger') return 'fg-dot--danger'
  if (props.level === 'warn' || props.level === 'warning') return 'fg-dot--warning'
  if (props.level === 'success') return 'fg-dot--success'
  return ''
})
</script>

<style scoped>
.severity-dot {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
}

.dot-label {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}
</style>
