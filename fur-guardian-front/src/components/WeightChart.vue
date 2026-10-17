<template>
  <div ref="chartRef" class="weight-chart"></div>
</template>

<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import * as echarts from 'echarts'
import type { WeightLog } from '@/types'

const props = defineProps<{ logs: WeightLog[] }>()

const chartRef = ref<HTMLElement>()
let chart: echarts.ECharts | null = null

function render() {
  if (!chartRef.value) return
  if (!chart) chart = echarts.init(chartRef.value)
  chart.setOption({
    grid: { left: 44, right: 16, top: 30, bottom: 28 },
    tooltip: {
      trigger: 'axis',
      formatter: (params: { dataIndex: number }[]) => {
        const log = props.logs[params[0].dataIndex]
        return `${log.recordedAt}<br/>体重：${log.weightKg} kg${log.bcs ? `<br/>BCS：${log.bcs}` : ''}`
      },
    },
    xAxis: {
      type: 'category',
      data: props.logs.map((l) => l.recordedAt),
      axisLine: { lineStyle: { color: '#d8ccc0' } },
    },
    yAxis: {
      type: 'value',
      name: 'kg',
      scale: true,
      splitLine: { lineStyle: { color: '#f0e6da' } },
    },
    series: [
      {
        type: 'line',
        data: props.logs.map((l) => l.weightKg),
        smooth: true,
        symbol: 'circle',
        symbolSize: 8,
        lineStyle: { color: '#e8853d', width: 3 },
        itemStyle: { color: '#e8853d' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(232,133,61,0.25)' },
            { offset: 1, color: 'rgba(232,133,61,0.02)' },
          ]),
        },
      },
    ],
  })
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
  height: 260px;
}
</style>
