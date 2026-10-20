<template>
  <component
    :is="href ? 'a' : 'span'"
    class="source-chip"
    :href="href || undefined"
    :target="href ? '_blank' : undefined"
    :rel="href ? 'noopener noreferrer' : undefined"
  >
    <LinkIcon :size="12" class="fg-icon" />
    <span>{{ label }}</span>
  </component>
</template>

<script setup lang="ts">
import { Link as LinkIcon } from 'lucide-vue-next'

withDefaults(defineProps<{ label: string; href?: string }>(), { label: '' })
</script>

<style scoped>
.source-chip {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s1);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  text-decoration: none;
  max-width: 100%;
}

.source-chip > span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

a.source-chip:hover {
  color: var(--fg-accent);
  text-decoration: underline;
}
</style>
