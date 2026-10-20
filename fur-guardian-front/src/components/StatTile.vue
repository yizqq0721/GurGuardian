<template>
  <div class="stat-tile">
    <p class="fg-label">{{ label }}</p>
    <p class="value-line">
      <span class="fg-value" :class="{ 'fg-value--hero': hero }">{{ value }}</span>
      <span v-if="unit" class="fg-unit">{{ unit }}</span>
    </p>
    <p v-if="caption" class="caption">{{ caption }}</p>
    <p v-if="delta !== undefined && delta !== null" class="delta" :class="deltaClass">
      <TrendingUp v-if="delta > 0" :size="14" class="fg-icon" />
      <TrendingDown v-else-if="delta < 0" :size="14" class="fg-icon" />
      <span class="fg-num">{{ deltaSign }}{{ Math.abs(delta) }}{{ deltaUnit }}</span>
      <span v-if="deltaLabel" class="delta-label">{{ deltaLabel }}</span>
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { TrendingUp, TrendingDown } from 'lucide-vue-next'

const props = withDefaults(
  defineProps<{
    label: string
    value: string | number
    unit?: string
    caption?: string
    delta?: number
    deltaUnit?: string
    deltaLabel?: string
    hero?: boolean
    /** delta 变好还是变坏由业务语义决定：体重上涨对偏胖宠物是坏事 */
    deltaDirection?: 'up-is-good' | 'up-is-bad' | 'neutral'
  }>(),
  { deltaDirection: 'neutral', deltaUnit: '', hero: false },
)

const deltaSign = computed(() => (props.delta && props.delta > 0 ? '+' : ''))

const deltaClass = computed(() => {
  if (props.deltaDirection === 'neutral' || !props.delta) return 'is-neutral'
  const upIsGood = props.deltaDirection === 'up-is-good'
  const good = upIsGood ? props.delta! >= 0 : props.delta! <= 0
  return good ? 'is-good' : 'is-bad'
})
</script>

<style scoped>
.stat-tile {
  min-width: 0;
}

.value-line {
  margin: var(--fg-s2) 0 0;
  display: flex;
  align-items: baseline;
}

.caption {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.delta {
  margin: var(--fg-s2) 0 0;
  display: flex;
  align-items: center;
  gap: var(--fg-s1);
  font-size: var(--fg-text-label);
}

.delta.is-good {
  color: var(--fg-accent);
}

.delta.is-bad {
  color: var(--fg-warning);
}

.delta.is-neutral {
  color: var(--fg-ink-muted);
}

.delta-label {
  color: var(--fg-ink-muted);
}
</style>
