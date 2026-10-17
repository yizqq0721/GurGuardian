<template>
  <div class="fg-page">
    <div class="page-head">
      <h2 class="fg-section-title">我的食品库</h2>
      <div class="head-right">
        <el-input
          v-model="keyword"
          placeholder="搜索品牌或名称"
          clearable
          style="width: 240px"
          @change="search"
        />
        <el-button type="primary" @click="router.push('/foods/new')">+ 录入食品</el-button>
      </div>
    </div>

    <div class="fg-card">
      <el-table v-loading="loading" :data="records">
        <el-table-column label="名称" min-width="220">
          <template #default="{ row }">
            <div>{{ row.brand ? `${row.brand} ` : '' }}{{ row.name }}</div>
            <span class="fg-muted" style="font-size: 12px">{{ row.ingredients?.slice(0, 30) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="类型" width="110">
          <template #default="{ row }">{{ FOOD_TYPE_LABEL[row.foodType] || row.foodType }}</template>
        </el-table-column>
        <el-table-column label="性质" width="110">
          <template #default="{ row }">
            <el-tag size="small" :type="row.productType === 'COMPLETE' ? 'success' : 'warning'" effect="plain">
              {{ PRODUCT_TYPE_LABEL[row.productType] || row.productType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="适用" width="110">
          <template #default="{ row }">
            {{ SPECIES_SCOPE_LABEL[row.speciesScope] || '-' }} · {{ LIFE_STAGE_LABEL[row.lifeStage] || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="代谢能" width="130">
          <template #default="{ row }">
            <span v-if="row.labeledMeKcal">{{ row.labeledMeKcal }} kcal/kg</span>
            <span v-else class="fg-muted">未标注</span>
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
      </el-table>

      <el-pagination
        v-model:current-page="page"
        :page-size="size"
        :total="total"
        layout="total, prev, pager, next"
        style="margin-top: 16px; justify-content: flex-end"
        @current-change="fetchList"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { foodApi } from '@/api/food'
import { FOOD_TYPE_LABEL, LIFE_STAGE_LABEL, PRODUCT_TYPE_LABEL, SPECIES_SCOPE_LABEL } from '@/utils/constants'
import type { Food } from '@/types'

const router = useRouter()
const loading = ref(false)
const records = ref<Food[]>([])
const page = ref(1)
const size = ref(20)
const total = ref(0)
const keyword = ref('')

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

async function remove(row: Food) {
  await ElMessageBox.confirm(`确定删除「${row.name}」吗？`, '删除确认', { type: 'warning' })
  await foodApi.remove(row.id)
  ElMessage.success('已删除')
  fetchList()
}
</script>

<style scoped>
.page-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.head-right {
  display: flex;
  gap: 12px;
}
</style>
