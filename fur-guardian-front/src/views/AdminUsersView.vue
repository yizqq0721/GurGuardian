<template>
  <div class="fg-page">
    <PageHeader
      title="用户管理"
      breadcrumb="管理后台"
      description="查看注册用户及其宠物档案，必要时禁用异常账号。管理员账号只能由数据库预置，不开放注册。"
    />

    <section class="toolbar">
      <el-input
        v-model="keyword"
        class="search"
        size="large"
        placeholder="搜索账号或昵称"
        clearable
        @change="search"
      >
        <template #prefix>
          <Search :size="20" class="fg-icon" />
        </template>
      </el-input>
      <p class="total-hint fg-muted">
        共 <span class="fg-num">{{ total }}</span> 个用户
      </p>
    </section>

    <section class="fg-card table-card">
      <el-table v-loading="loading" :data="records" row-key="id">
        <el-table-column label="ID" width="80" class-name="fg-num">
          <template #default="{ row }">{{ row.id }}</template>
        </el-table-column>

        <el-table-column label="账号" min-width="200">
          <template #default="{ row }">
            <div class="account-line">
              <el-avatar :size="28" :src="row.avatar || undefined">{{ initial(row) }}</el-avatar>
              <span class="account-name">{{ row.username }}</span>
              <span v-if="row.isAdmin" class="fg-chip fg-chip--ok">管理员</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="昵称" min-width="140">
          <template #default="{ row }">
            <span :class="{ 'fg-muted': !row.nickname }">{{ row.nickname || '未设置' }}</span>
          </template>
        </el-table-column>

        <el-table-column label="宠物数" width="100" align="right" class-name="fg-num">
          <template #default="{ row }">{{ row.petCount }}</template>
        </el-table-column>

        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <span class="fg-chip" :class="row.status === 1 ? 'fg-chip--ok' : 'fg-chip--warn'">
              {{ row.status === 1 ? '正常' : '已禁用' }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="注册时间" width="170">
          <template #default="{ row }">
            <span class="fg-muted">{{ dateTimeText(row.createdAt) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button size="small" text type="primary" @click="openDetail(row)">详情</el-button>
            <el-button
              v-if="canToggle(row)"
              size="small"
              text
              :type="row.status === 1 ? 'danger' : 'primary'"
              @click="toggleStatus(row)"
            >{{ row.status === 1 ? '禁用' : '启用' }}</el-button>
          </template>
        </el-table-column>

        <template #empty>
          <EmptyState
            variant="search"
            :description="keyword ? '没有匹配的用户' : '还没有注册用户'"
          />
        </template>
      </el-table>

      <div class="table-foot">
        <p class="foot-legend fg-muted">禁用后该账号将无法再登录；管理员账号不能禁用自己。</p>
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

    <el-dialog v-model="detailVisible" title="用户详情" width="92%" class="detail-dialog">
      <div v-loading="detailLoading" class="detail-body">
        <template v-if="detail">
          <dl class="detail-meta">
            <div>
              <dt class="fg-label">用户 ID</dt>
              <dd class="fg-num">{{ detail.id }}</dd>
            </div>
            <div>
              <dt class="fg-label">账号</dt>
              <dd>
                {{ detail.username }}
                <span v-if="detail.isAdmin" class="fg-chip fg-chip--ok">管理员</span>
              </dd>
            </div>
            <div>
              <dt class="fg-label">昵称</dt>
              <dd>{{ detail.nickname || '未设置' }}</dd>
            </div>
            <div>
              <dt class="fg-label">状态</dt>
              <dd>
                <span class="fg-chip" :class="detail.status === 1 ? 'fg-chip--ok' : 'fg-chip--warn'">
                  {{ detail.status === 1 ? '正常' : '已禁用' }}
                </span>
              </dd>
            </div>
            <div>
              <dt class="fg-label">注册时间</dt>
              <dd class="fg-muted">{{ dateTimeText(detail.createdAt) }}</dd>
            </div>
            <div>
              <dt class="fg-label">最近更新</dt>
              <dd class="fg-muted">{{ dateTimeText(detail.updatedAt) }}</dd>
            </div>
          </dl>

          <h3 class="fg-section-title pets-title">宠物档案（{{ detail.pets.length }}）</h3>
          <el-table v-if="detail.pets.length" :data="detail.pets" size="small" row-key="id">
            <el-table-column prop="name" label="名称" min-width="110" />
            <el-table-column label="物种" width="80">
              <template #default="{ row }">{{ row.species === 'cat' ? '猫' : '犬' }}</template>
            </el-table-column>
            <el-table-column label="品种" min-width="120">
              <template #default="{ row }">
                <span :class="{ 'fg-muted': !row.breed }">{{ row.breed || '未填写' }}</span>
              </template>
            </el-table-column>
            <el-table-column label="性别" width="70">
              <template #default="{ row }">
                {{ row.sex === 'female' ? '母' : row.sex === 'male' ? '公' : '—' }}
              </template>
            </el-table-column>
            <el-table-column label="生日" width="110">
              <template #default="{ row }">{{ dateText(row.birthday) }}</template>
            </el-table-column>
          </el-table>
          <p v-else class="no-pets fg-muted">该用户还没有宠物档案。</p>
        </template>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from 'lucide-vue-next'
import { adminApi } from '@/api/admin'
import EmptyState from '@/components/EmptyState.vue'
import PageHeader from '@/components/PageHeader.vue'
import { useUserStore } from '@/stores/user'
import { dateText, dateTimeText } from '@/utils/format'
import type { AdminUser, AdminUserDetail } from '@/types'

const userStore = useUserStore()

const loading = ref(false)
const records = ref<AdminUser[]>([])
const page = ref(1)
const size = ref(20)
const total = ref(0)
const keyword = ref('')

const detailVisible = ref(false)
const detailLoading = ref(false)
const detail = ref<AdminUserDetail | null>(null)

onMounted(fetchList)

async function fetchList() {
  loading.value = true
  try {
    const res = await adminApi.listUsers({
      page: page.value,
      size: size.value,
      keyword: keyword.value || undefined,
    })
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

function initial(row: AdminUser) {
  return row.username.slice(0, 1).toUpperCase()
}

function canToggle(row: AdminUser) {
  return !row.isAdmin && row.id !== userStore.userInfo?.userId
}

async function openDetail(row: AdminUser) {
  detailVisible.value = true
  detailLoading.value = true
  detail.value = null
  try {
    detail.value = await adminApi.getUser(row.id)
  } finally {
    detailLoading.value = false
  }
}

async function toggleStatus(row: AdminUser) {
  const next = row.status === 1 ? 0 : 1
  const confirmed = await ElMessageBox.confirm(
    next === 0
      ? `禁用后「${row.username}」将无法再登录，确定继续吗？`
      : `确定启用「${row.username}」吗？`,
    next === 0 ? '禁用账号' : '启用账号',
    { type: 'warning', confirmButtonText: next === 0 ? '禁用' : '启用' },
  ).catch(() => false)
  if (!confirmed) return

  await adminApi.updateStatus(row.id, next)
  ElMessage.success(next === 1 ? '已启用' : '已禁用')
  fetchList()
}
</script>

<style scoped>
.toolbar {
  display: flex;
  align-items: center;
  gap: var(--fg-s5);
  margin-bottom: var(--fg-s5);
}

.search {
  width: 280px;
  flex: none;
}

.search :deep(.el-input__prefix) {
  color: var(--fg-ink-muted);
}

.total-hint {
  margin: 0 0 0 auto;
  font-size: var(--fg-text-body);
}

.table-card {
  padding: var(--fg-s3) var(--fg-s5) 0;
}

.table-card :deep(.el-table__body tr:last-child > .el-table__cell) {
  border-bottom: none;
}

.account-line {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  min-width: 0;
}

.account-name {
  font-weight: 500;
}

.table-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s5);
  padding: var(--fg-s4) 0;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.foot-legend {
  margin: 0;
  font-size: var(--fg-text-label);
}

.pager {
  flex: none;
}

.detail-dialog {
  max-width: 640px;
}

.detail-body {
  min-height: 120px;
  max-height: 68vh;
  overflow-y: auto;
}

.detail-meta {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: var(--fg-s4);
  margin: 0;
}

.detail-meta dt {
  margin: 0 0 var(--fg-s1);
}

.detail-meta dd {
  margin: 0;
  font-size: var(--fg-text-body);
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  flex-wrap: wrap;
}

.pets-title {
  margin: var(--fg-s6) 0 var(--fg-s3);
}

.no-pets {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-body);
}

@media (max-width: 767.98px) {
  .toolbar {
    flex-direction: column;
    align-items: stretch;
    gap: var(--fg-s3);
    margin-bottom: var(--fg-s4);
  }

  .search {
    width: 100%;
  }

  .total-hint {
    margin: 0;
    align-self: flex-start;
  }

  .table-card {
    padding: 0 var(--fg-s4);
  }

  .table-foot {
    flex-direction: column;
    align-items: flex-start;
  }

  .detail-meta {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
