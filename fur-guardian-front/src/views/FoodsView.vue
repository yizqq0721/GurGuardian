<template>
  <div class="fg-page">
    <PageHeader
      title="我的食品库"
      breadcrumb="食品库"
      description="把包装袋上的保证值录进来，营养方案才能逐项对照国标判定；未标注的项留空即可。"
    />

    <!-- 工具栏：搜索 + 筛选 chip + 主操作 -->
    <section class="toolbar">
      <el-input
        v-model="keyword"
        class="search"
        size="large"
        placeholder="搜索品牌或名称"
        clearable
        @change="search"
      >
        <template #prefix>
          <Search :size="20" class="fg-icon" />
        </template>
      </el-input>

      <div class="filters">
        <div class="chip-row">
          <p class="fg-label chip-caption">类型</p>
          <button
            v-for="c in foodTypeChips"
            :key="c.value || 'ALL'"
            type="button"
            class="fchip"
            :class="{ 'is-on': foodTypeFilter === c.value }"
            @click="foodTypeFilter = c.value"
          >{{ c.label }}</button>
        </div>
        <div class="chip-row">
          <p class="fg-label chip-caption">性质</p>
          <button
            v-for="c in productTypeChips"
            :key="c.value || 'ALL'"
            type="button"
            class="fchip"
            :class="{ 'is-on': productTypeFilter === c.value }"
            @click="productTypeFilter = c.value"
          >{{ c.label }}</button>
        </div>
      </div>

      <el-button type="primary" class="create" @click="router.push('/foods/new')">录入食品</el-button>
    </section>

    <section class="fg-card table-card">
      <el-table v-loading="loading" :data="visible" row-key="id">
        <el-table-column label="名称" min-width="260">
          <template #default="{ row }">
            <div class="name-line">
              <span class="food-name">{{ row.brand ? `${row.brand} ` : '' }}{{ row.name }}</span>
              <span
                v-if="row.productType"
                class="fg-chip"
                :class="row.productType === 'COMPLETE' ? 'fg-chip--ok' : 'fg-chip--warn'"
              >{{ PRODUCT_TYPE_SHORT[row.productType] || row.productType }}</span>
            </div>
            <p v-if="row.ingredients" class="ingredients fg-muted">{{ row.ingredients.slice(0, 30) }}</p>
          </template>
        </el-table-column>

        <el-table-column label="类型" width="96">
          <template #default="{ row }">{{ FOOD_TYPE_LABEL[row.foodType] || row.foodType || '—' }}</template>
        </el-table-column>

        <el-table-column label="适用阶段" width="160">
          <template #default="{ row }">
            {{ SPECIES_SCOPE_LABEL[row.speciesScope] || '—' }} · {{ LIFE_STAGE_LABEL[row.lifeStage] || '—' }}
          </template>
        </el-table-column>

        <el-table-column label="代谢能 kcal/kg" width="150" align="right" class-name="fg-num">
          <template #default="{ row }">
            <span v-if="row.labeledMeKcal">{{ row.labeledMeKcal }}</span>
            <span v-else class="fg-muted">未标注</span>
          </template>
        </el-table-column>

        <el-table-column label="粗蛋白 %DM" width="130" align="right" class-name="fg-num">
          <template #default="{ row }">
            <span v-if="proteinDm(row) !== null">{{ proteinDm(row) }}</span>
            <span v-else class="fg-muted">—</span>
          </template>
        </el-table-column>

        <el-table-column label="更新时间" width="120">
          <template #default="{ row }">
            <span class="fg-muted">{{ updateTime(row) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="140" fixed="right">
          <template #default="{ row }">
            <el-button size="small" text type="primary" @click="router.push(`/foods/${row.id}/edit`)">
              编辑
            </el-button>
            <el-button size="small" text type="danger" @click="remove(row)">删除</el-button>
          </template>
        </el-table-column>

        <template #empty>
          <EmptyState
            variant="foods"
            :description="isFiltering ? '当前筛选没有匹配的食品' : '食品库还是空的，录入第一袋粮'"
          >
            <el-button v-if="isFiltering" @click="clearFilters">清除筛选</el-button>
            <el-button v-else type="primary" @click="router.push('/foods/new')">录入食品</el-button>
          </EmptyState>
        </template>
      </el-table>

      <div class="table-foot">
        <div class="foot-notes">
          <p class="fg-mono">粗蛋白 %DM ＝ 粗蛋白 ≥% ÷ (100 − 水分 %) × 100</p>
          <p class="fg-muted foot-legend">全价＝可作唯一主食，补充／零食＝不可作唯一主食。</p>
          <p v-if="isFiltering" class="fg-muted foot-legend">
            类型／性质筛选作用于本页 {{ records.length }} 条记录，换页后重新计算。
          </p>
        </div>
        <el-pagination
          v-model:current-page="page"
          :page-size="size"
          :total="total"
          layout="total, prev, pager, next"
          class="pager"
          @current-change="fetchList"
        />
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from 'lucide-vue-next'
import { foodApi } from '@/api/food'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import {
  FOOD_TYPE_LABEL,
  FOOD_TYPE_OPTIONS,
  LIFE_STAGE_LABEL,
  SPECIES_SCOPE_LABEL,
} from '@/utils/constants'
import { fromNow } from '@/utils/format'
import type { Food, FoodType, ProductType } from '@/types'

const router = useRouter()
const loading = ref(false)
const records = ref<Food[]>([])
const page = ref(1)
const size = ref(20)
const total = ref(0)
const keyword = ref('')
const foodTypeFilter = ref<FoodType | ''>('')
const productTypeFilter = ref<ProductType | ''>('')

/** chip 只显示短标签，完整含义写进表下脚注 */
const PRODUCT_TYPE_SHORT: Record<string, string> = {
  COMPLETE: '全价',
  COMPLEMENTARY: '补充',
  SNACK: '零食',
}

const foodTypeChips: { value: FoodType | ''; label: string }[] = [
  { value: '', label: '全部' },
  ...FOOD_TYPE_OPTIONS.map((o) => ({ value: o.value, label: o.label })),
]

const productTypeChips: { value: ProductType | ''; label: string }[] = [
  { value: '', label: '全部' },
  ...Object.entries(PRODUCT_TYPE_SHORT).map(([value, label]) => ({
    value: value as ProductType,
    label,
  })),
]

const isFiltering = computed(() => !!foodTypeFilter.value || !!productTypeFilter.value)

const visible = computed(() =>
  records.value.filter(
    (f) =>
      (!foodTypeFilter.value || f.foodType === foodTypeFilter.value) &&
      (!productTypeFilter.value || f.productType === productTypeFilter.value),
  ),
)

onMounted(fetchList)

async function fetchList() {
  loading.value = true
  try {
    const res = await foodApi.list({ page: page.value, size: size.value, keyword: keyword.value || undefined })
    records.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function search() {
  page.value = 1
  fetchList()
}

function clearFilters() {
  foodTypeFilter.value = ''
  productTypeFilter.value = ''
}

/** 保证值是风干基，按水分换算成干物质基准；缺水分就不换算 */
function proteinDm(row: Food): string | null {
  const protein = row.nutrients?.crudeProteinMin
  const moisture = row.nutrients?.moistureMax
  if (protein == null || moisture == null) return null
  const dm = 100 - moisture
  if (dm <= 0) return null
  return ((protein / dm) * 100).toFixed(1)
}

function updateTime(row: Food) {
  const withUpdated = row as Food & { updatedAt?: string }
  return fromNow(withUpdated.updatedAt ?? row.createdAt)
}

async function remove(row: Food) {
  await ElMessageBox.confirm(`确定删除「${row.name}」吗？`, '删除确认', { type: 'warning' })
  await foodApi.remove(row.id)
  ElMessage.success('已删除')
  fetchList()
}
</script>

<style scoped>
/* 工具栏 */
.toolbar {
  display: flex;
  align-items: center;
  gap: var(--fg-s6);
  margin-bottom: var(--fg-s5);
}

.search {
  width: 260px;
  flex: none;
}

.search :deep(.el-input__prefix) {
  color: var(--fg-ink-muted);
}

.filters {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: var(--fg-s2);
}

.chip-row {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  flex-wrap: wrap;
}

.chip-caption {
  width: 32px;
  flex: none;
}

.fchip {
  height: 32px;
  padding: 0 var(--fg-s3);
  display: inline-flex;
  align-items: center;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  color: var(--fg-ink-muted);
  font-family: inherit;
  font-size: var(--fg-text-body);
  line-height: 1;
  cursor: pointer;
  transition: color var(--fg-motion), background-color var(--fg-motion), border-color var(--fg-motion);
}

.fchip:hover {
  color: var(--fg-ink);
  border-color: var(--fg-line-strong);
}

.fchip.is-on {
  background: var(--fg-accent-soft);
  border-color: transparent;
  color: var(--fg-accent);
  font-weight: 500;
}

.create {
  flex: none;
  align-self: flex-start;
  height: 40px;
}

/* 表格 */
.table-card {
  padding: var(--fg-s3) var(--fg-s5) 0;
}

.table-card :deep(.el-table__body tr:last-child > .el-table__cell) {
  border-bottom: none;
}

/* 表头带单位，取消全局大写以免 KCAL/KG 这类单位变形 */
.table-card :deep(th.el-table__cell) {
  text-transform: none;
}

.name-line {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
}

.food-name {
  font-weight: 500;
}

.ingredients {
  margin: var(--fg-s1) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.table-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s5);
  padding: var(--fg-s4) 0;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.foot-notes {
  min-width: 0;
}

.foot-notes p {
  margin: 0;
}

.foot-notes p + p {
  margin-top: var(--fg-s1);
}

.foot-legend {
  font-size: var(--fg-text-label);
}

.pager {
  flex: none;
}

@media (max-width: 1024px) {
  .toolbar {
    flex-wrap: wrap;
    align-items: flex-start;
    gap: var(--fg-s4);
  }
  .create {
    margin-left: auto;
  }
  .table-foot {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
