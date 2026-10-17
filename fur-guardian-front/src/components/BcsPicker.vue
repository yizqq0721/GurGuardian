<template>
  <div class="bcs-picker">
    <p class="fg-muted" style="margin-top: 0">
      体况评分 BCS（9 分制）：俯视和侧视观察宠物的腰线与肋骨触感，选择最接近的一档。4-5 分为理想体态。
    </p>
    <div class="bcs-grid">
      <button
        v-for="n in 9"
        :key="n"
        type="button"
        class="bcs-cell"
        :class="{ active: modelValue === n }"
        :style="{ '--group-color': bcsGroup(n).color }"
        @click="emit('update:modelValue', n)"
      >
        <span class="bcs-num">{{ n }}</span>
        <span class="bcs-shape" :data-level="n"></span>
        <span class="bcs-label">{{ bcsGroup(n).label }}</span>
      </button>
    </div>
    <div class="bcs-desc" :style="{ color: bcsGroup(modelValue).color }">
      {{ modelValue }} 分 · {{ bcsGroup(modelValue).label }} —— {{ bcsGroup(modelValue).desc }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { bcsGroup } from '@/utils/constants'

defineProps<{ modelValue: number }>()
const emit = defineEmits<{ (e: 'update:modelValue', v: number): void }>()
</script>

<style scoped>
.bcs-grid {
  display: grid;
  grid-template-columns: repeat(9, 1fr);
  gap: 6px;
}

.bcs-cell {
  border: 2px solid var(--fg-border);
  border-radius: 10px;
  background: #fff;
  padding: 10px 4px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  transition: all 0.15s;
}

.bcs-cell:hover {
  border-color: var(--group-color);
}

.bcs-cell.active {
  border-color: var(--group-color);
  background: color-mix(in srgb, var(--group-color) 10%, #fff);
}

.bcs-num {
  font-weight: 700;
  font-size: 16px;
  color: var(--group-color);
}

.bcs-label {
  font-size: 12px;
  color: var(--fg-ink-light);
}

/* 用圆形胖瘦示意体型轮廓 */
.bcs-shape {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 2px solid var(--group-color);
  transform: scaleX(0.55);
}

.bcs-shape[data-level='2'] { transform: scaleX(0.62); }
.bcs-shape[data-level='3'] { transform: scaleX(0.7); }
.bcs-shape[data-level='4'] { transform: scaleX(0.8); }
.bcs-shape[data-level='5'] { transform: scaleX(0.9); }
.bcs-shape[data-level='6'] { transform: scaleX(1); }
.bcs-shape[data-level='7'] { transform: scaleX(1.15); }
.bcs-shape[data-level='8'] { transform: scaleX(1.3); }
.bcs-shape[data-level='9'] { transform: scaleX(1.45); }

.bcs-desc {
  margin-top: 12px;
  font-size: 13px;
  text-align: center;
}
</style>
