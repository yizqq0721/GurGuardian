<template>
  <table class="nutrient-table">
    <thead>
      <tr>
        <th>营养素</th>
        <th class="num">标注值</th>
        <th class="num">国标要求</th>
        <th class="verdict">判定</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="r in rows" :key="r.nutrient">
        <td>{{ r.nutrient }}</td>
        <td class="num fg-num">{{ r.actualValue }}{{ r.unit }}</td>
        <td class="num fg-muted fg-num">{{ requiredText(r) }}</td>
        <td class="verdict">
          <span class="fg-chip" :class="r.passed ? 'fg-chip--ok' : 'fg-chip--danger'">
            <component :is="r.passed ? CircleCheck : CircleX" :size="12" class="fg-icon" />
            {{ r.passed ? '达标' : '不达标' }}
          </span>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script setup lang="ts">
import { CircleCheck, CircleX } from 'lucide-vue-next'
import type { NutrientValidation } from '@/types'

defineProps<{ rows: NutrientValidation[] }>()

function requiredText(r: NutrientValidation) {
  if (r.requiredMin != null && r.requiredMax != null) return `≥${r.requiredMin} 且 ≤${r.requiredMax}${r.unit}`
  if (r.requiredMin != null) return `≥ ${r.requiredMin}${r.unit}`
  if (r.requiredMax != null) return `≤ ${r.requiredMax}${r.unit}`
  return '无要求'
}
</script>

<style scoped>
.nutrient-table {
  width: 100%;
  border-collapse: collapse;
  font-size: var(--fg-text-body);
}

th {
  text-align: left;
  font-size: var(--fg-text-label);
  font-weight: 500;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
  padding: var(--fg-s2) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

td {
  padding: var(--fg-s3) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  color: var(--fg-ink);
}

tr:last-child td {
  border-bottom: none;
}

.num {
  text-align: right;
  white-space: nowrap;
}

.verdict {
  width: 96px;
  text-align: right;
}

.fg-chip {
  justify-content: center;
}

/* 响应式新增：<768px 压缩四列，保证 320px 不横向溢出 */
@media (max-width: 767.98px) {
  .nutrient-table {
    font-size: 13px;
  }

  th {
    font-size: 11px;
    padding: var(--fg-s2) 0;
  }

  td {
    padding: var(--fg-s2) 0;
  }

  .num {
    white-space: normal;
  }

  .verdict {
    width: 64px;
  }

  .fg-chip {
    height: 20px;
    padding: 0 5px;
    font-size: 11px;
  }
}
</style>
