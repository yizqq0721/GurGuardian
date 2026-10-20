<template>
  <div ref="chartRef" class="weight-chart"></div>
</template>

<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import * as echarts from 'echarts'
import type { WeightLog } from '@/types'

const props = defineProps<{ logs: WeightLog[]; height?: number }>()

const chartRef = ref<HTMLElement>()
let chart: echarts.ECharts | null = null

const ACCENT = '#1f5c4a'
const INK = '#16181a'
const MUTED = '#6b6f76'
const LINE = '#e6e4de'

function render() {
  if (!chartRef.value) return
  if (!chart) chart = echarts.init(chartRef.value)
  const last = props.logs.length - 1

  chart.setOption(
    {
      grid: { left: 48, right: 24, top: 32, bottom: 28 },
      tooltip: {
        trigger: 'axis',
        backgroundColor: '#ffffff',
        borderColor: LINE,
        borderWidth: 1,
        padding: [8, 12],
        textStyle: { color: INK, fontSize: 13 },
        formatter: (params: { dataIndex: number }[]) => {
          const log = props.logs[params[0].dataIndex]
          return `${log.recordedAt}<br/>体重 <b style="font-variant-numeric:tabular-nums">${log.weightKg}</b> kg${
            log.bcs ? `<br/>BCS <b style="font-variant-numeric:tabular-nums">${log.bcs}</b> / 9` : ''
          }`
        },
      },
      xAxis: {
        type: 'category',
        data: props.logs.map((l) => l.recordedAt),
        axisLine: { lineStyle: { color: LINE } },
        axisTick: { show: false },
        axisLabel: { color: MUTED, fontSize: 11, fontFamily: 'Inter' },
      },
      yAxis: {
        type: 'value',
        scale: true,
        name: 'kg',
        nameTextStyle: { color: MUTED, fontSize: 11, align: 'left' },
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: { color: MUTED, fontSize: 11, fontFamily: 'Inter' },
        splitLine: { lineStyle: { color: LINE, type: 'solid' } },
      },
      series: [
        {
          type: 'line',
          data: props.logs.map((l, i) => ({
            value: l.weightKg,
            // 末点标注：唯一强调，其余不画标签
            label: i === last
              ? {
                  show: true,
                  formatter: `${l.weightKg} kg`,
                  position: 'top',
                  distance: 8,
                  color: INK,
                  fontSize: 13,
                  fontWeight: 600,
                  fontFamily: 'Inter',
                }
              : { show: false },
            symbolSize: i === last ? 7 : 4,
          })),
          smooth: false,
          symbol: 'circle',
          lineStyle: { color: ACCENT, width: 1.5 },
          itemStyle: { color: ACCENT, borderWidth: 0 },
          areaStyle: { color: '#e8f0ec' },
        },
      ],
    },
    true,
  )
}

function resize() {
  chart?.resize()
}

onMounted(() => {
  render()
  window.addEventListener('resize', resize)
})

watch(() => props.logs, render, { deep: true })

onBeforeUnmount(() => {
  window.removeEventListener('resize', resize)
  chart?.dispose()
  chart = null
})
</script>

<style scoped>
.weight-chart {
  width: 100%;
  height: v-bind('props.height ? `${props.height}px` : "240px"');
}
</style>
