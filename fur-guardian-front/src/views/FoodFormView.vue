<template>
  <div class="fg-page">
    <PageHeader
      :title="isEdit ? '编辑食品' : '录入食品'"
      :breadcrumb="isEdit ? '食品库 · 编辑' : '食品库 · 录入'"
      description="按包装袋上的「产品成分分析保证值」逐项填写即可，未标注的项留空。"
    />

    <div class="form-shell">
      <el-form class="fg-card form-card" label-position="top" @submit.prevent>
        <!-- 基本信息 -->
        <section class="section">
          <h2 class="fg-section-title">基本信息</h2>
          <div class="grid-2">
            <el-form-item label="食品名称" required>
              <el-input v-model="form.name" placeholder="例如：皇家贵宾成犬粮" />
            </el-form-item>
            <el-form-item label="品牌">
              <el-input v-model="form.brand" placeholder="例如：Royal Canin" />
            </el-form-item>
            <el-form-item label="类型">
              <el-select v-model="form.foodType" class="w-full">
                <el-option v-for="o in FOOD_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
            <el-form-item label="产品类型">
              <el-select v-model="form.productType" class="w-full">
                <el-option v-for="o in PRODUCT_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
            <el-form-item label="适用阶段">
              <el-select v-model="form.lifeStage" class="w-full">
                <el-option v-for="o in LIFE_STAGE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
            <el-form-item label="物种范围">
              <el-select v-model="form.speciesScope" class="w-full">
                <el-option v-for="o in SPECIES_SCOPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
            <el-form-item label="原料组成" class="span-2">
              <el-input
                v-model="form.ingredients"
                type="textarea"
                :rows="2"
                placeholder="按包装标注顺序，用逗号分隔"
              />
            </el-form-item>
          </div>
        </section>

        <!-- 保证分析值 + 干物质基准预览 -->
        <section class="section">
          <h2 class="fg-section-title">产品成分分析保证值</h2>
          <div class="analysis">
            <div class="grid-2">
              <el-form-item v-for="n in nutrientFields" :key="n.key" :label="n.label">
                <div class="unit-field">
                  <el-input-number
                    v-model="form.nutrients[n.key]"
                    :min="0"
                    :max="100"
                    :step="0.1"
                    :precision="1"
                    :controls="false"
                    class="unit-num"
                    placeholder="未标注"
                  />
                  <span class="unit-suffix">%</span>
                </div>
              </el-form-item>
            </div>

            <aside class="dm-panel">
              <p class="fg-label">干物质基准 DM%</p>
              <template v-if="dmBase !== null">
                <p class="fg-mono">DM ＝ 100 − 水分 {{ moistureText }} ＝ {{ dmBase.toFixed(1) }}</p>
                <div class="fg-kv">
                  <span class="dm-key">粗蛋白</span>
                  <span class="fg-num">{{ dmOf('crudeProteinMin') }} %</span>
                </div>
                <div class="fg-kv">
                  <span class="dm-key">粗脂肪</span>
                  <span class="fg-num">{{ dmOf('crudeFatMin') }} %</span>
                </div>
                <p class="fg-mono">换算 ＝ 保证值 ÷ DM × 100</p>
              </template>
              <p v-else class="dm-hint fg-muted">填写「水分」后自动换算干物质基准，便于与国标（以干物质计）对照。</p>
              <p class="dm-hint fg-muted">仅供阅读换算，提交时仍是包装上的风干基保证值。</p>
            </aside>
          </div>
        </section>

        <!-- 能量 -->
        <section class="section">
          <h2 class="fg-section-title">能量</h2>
          <div class="energy">
            <el-form-item label="标注代谢能">
              <div class="unit-field unit-field--wide">
                <el-input-number
                  v-model="form.labeledMeKcal"
                  :min="0"
                  :max="6000"
                  :controls="false"
                  class="unit-num"
                  placeholder="未标注"
                />
                <span class="unit-suffix">kcal/kg</span>
              </div>
            </el-form-item>
            <p class="fg-muted energy-note">
              {{ form.labeledMeKcal == null ? '未标注 · 将使用修正 Atwater 估算' : '按包装标注值计算，不做估算' }}
            </p>
          </div>
        </section>
      </el-form>

      <div class="action-bar">
        <el-button @click="router.back()">取消</el-button>
        <el-button type="primary" :loading="saving" @click="save">{{ isEdit ? '保存修改' : '录入' }}</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { foodApi } from '@/api/food'
import {
  FOOD_TYPE_OPTIONS,
  LIFE_STAGE_OPTIONS,
  PRODUCT_TYPE_OPTIONS,
  SPECIES_SCOPE_OPTIONS,
} from '@/utils/constants'
import type { FoodNutrients, FoodType, LifeStage, ProductType, SpeciesScope } from '@/types'

const route = useRoute()
const router = useRouter()
const editId = computed(() => (route.params.id ? Number(route.params.id) : null))
const isEdit = computed(() => editId.value !== null)

const saving = ref(false)

const nutrientFields: { key: keyof FoodNutrients; label: string }[] = [
  { key: 'moistureMax', label: '水分 ≤' },
  { key: 'crudeProteinMin', label: '粗蛋白质 ≥' },
  { key: 'crudeFatMin', label: '粗脂肪 ≥' },
  { key: 'crudeFiberMax', label: '粗纤维 ≤' },
  { key: 'ashMax', label: '粗灰分 ≤' },
  { key: 'calciumMin', label: '钙 ≥' },
  { key: 'phosphorusMin', label: '总磷 ≥' },
  { key: 'taurineMin', label: '牛磺酸 ≥（猫粮）' },
  { key: 'lysineMin', label: '赖氨酸 ≥（犬粮）' },
]

const form = reactive({
  name: '',
  brand: '',
  foodType: 'DRY' as FoodType,
  productType: 'COMPLETE' as ProductType,
  lifeStage: 'ADULT' as LifeStage,
  speciesScope: 'DOG' as SpeciesScope,
  labeledMeKcal: undefined as number | undefined,
  ingredients: '',
  nutrients: {} as Record<keyof FoodNutrients, number | undefined>,
})

/** 纯前端换算：干物质基准，不参与提交 */
const dmBase = computed<number | null>(() => {
  const m = form.nutrients.moistureMax
  if (m == null || m >= 100) return null
  return 100 - m
})

const moistureText = computed(() => {
  const m = form.nutrients.moistureMax
  return m == null ? '—' : m.toFixed(1)
})

function dmOf(key: keyof FoodNutrients) {
  const v = form.nutrients[key]
  if (v == null || dmBase.value === null) return '—'
  return ((v / dmBase.value) * 100).toFixed(1)
}

onMounted(async () => {
  if (!editId.value) return
  const [food, nutrients] = await Promise.all([
    foodApi.detail(editId.value),
    foodApi.nutrients(editId.value).catch(() => undefined),
  ])
  Object.assign(form, {
    name: food.name,
    brand: food.brand || '',
    foodType: food.foodType || 'DRY',
    productType: food.productType || 'COMPLETE',
    lifeStage: food.lifeStage || 'ADULT',
    speciesScope: food.speciesScope || 'DOG',
    labeledMeKcal: food.labeledMeKcal,
    ingredients: food.ingredients || '',
    nutrients: { ...(nutrients || food.nutrients || {}) },
  })
})

async function save() {
  if (!form.name.trim()) {
    ElMessage.warning('请填写食品名称')
    return
  }
  saving.value = true
  try {
    const nutrients: FoodNutrients = {}
    for (const { key } of nutrientFields) {
      const v = form.nutrients[key]
      if (v !== undefined && v !== null) nutrients[key] = v
    }
    const payload = {
      name: form.name.trim(),
      brand: form.brand || undefined,
      foodType: form.foodType,
      productType: form.productType,
      lifeStage: form.lifeStage,
      speciesScope: form.speciesScope,
      labeledMeKcal: form.labeledMeKcal,
      ingredients: form.ingredients || undefined,
      nutrients: Object.keys(nutrients).length ? nutrients : undefined,
    }
    if (isEdit.value && editId.value) {
      await foodApi.update(editId.value, payload)
      ElMessage.success('已保存')
    } else {
      await foodApi.create(payload)
      ElMessage.success('录入成功')
    }
    router.push('/foods')
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.form-shell {
  max-width: 960px;
  margin: 0 auto;
}

.form-card {
  padding: var(--fg-s5) var(--fg-s5) var(--fg-s2);
}

.section + .section {
  margin-top: var(--fg-s5);
  padding-top: var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.grid-2 {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  column-gap: var(--fg-s6);
}

.span-2 {
  grid-column: 1 / -1;
}

.w-full {
  width: 100%;
}

/* Element Plus 表单：标签用 12px 大写灰，行距走间距刻度 */
.form-card :deep(.el-form-item) {
  margin-bottom: var(--fg-s4);
}

.form-card :deep(.el-form-item__label) {
  font-size: var(--fg-text-label);
  font-weight: 500;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
  padding-bottom: var(--fg-s1);
  line-height: 1.6;
}

/* 带单位后缀的数字输入 */
.unit-field {
  position: relative;
  width: 100%;
}

.unit-field--wide {
  max-width: 220px;
}

.unit-num {
  width: 100%;
}

.unit-field :deep(.el-input-number) {
  width: 100%;
}

.unit-field :deep(.el-input__wrapper) {
  padding-right: var(--fg-s5);
}

.unit-field--wide :deep(.el-input__wrapper) {
  padding-right: var(--fg-s8);
}

.unit-suffix {
  position: absolute;
  top: 50%;
  right: var(--fg-s3);
  transform: translateY(-50%);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  pointer-events: none;
}

/* 保证分析值 + 换算栏 */
.analysis {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 260px;
  gap: var(--fg-s6);
  align-items: start;
}

.dm-panel {
  padding-left: var(--fg-s6);
  border-left: var(--fg-line-w) solid var(--fg-line);
}

.dm-panel > p:first-child {
  margin: 0 0 var(--fg-s3);
}

.dm-panel .fg-mono {
  margin: 0 0 var(--fg-s3);
  line-height: 1.7;
  word-break: break-all;
}

.dm-panel .fg-kv + .fg-mono {
  margin-top: var(--fg-s3);
}

.dm-key {
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
}

.dm-panel .fg-num {
  font-size: var(--fg-text-lead);
}

.dm-hint {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

/* 能量 */
.energy .el-form-item {
  margin-bottom: var(--fg-s2);
}

.energy-note {
  margin: 0;
  font-size: var(--fg-text-label);
}

/* 吸底操作栏 */
.action-bar {
  position: sticky;
  bottom: 0;
  z-index: 20;
  display: flex;
  justify-content: flex-end;
  gap: var(--fg-s3);
  margin-top: var(--fg-s5);
  padding: var(--fg-s4) var(--fg-s5);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
}

@media (max-width: 1024px) {
  .grid-2 {
    grid-template-columns: minmax(0, 1fr);
  }
  .analysis {
    grid-template-columns: minmax(0, 1fr);
  }
  .dm-panel {
    padding-left: 0;
    border-left: none;
    border-top: var(--fg-line-w) solid var(--fg-line);
    padding-top: var(--fg-s4);
  }
}

/* ===== 响应式新增：移动端（<768px）===== */
@media (max-width: 767.98px) {
  .form-shell {
    max-width: none;
  }

  .form-card {
    padding: var(--fg-s4) var(--fg-s4) var(--fg-s1);
  }

  .section + .section {
    margin-top: var(--fg-s4);
    padding-top: var(--fg-s4);
  }

  .unit-field--wide {
    max-width: none;
  }

  .dm-panel .fg-mono {
    overflow-wrap: anywhere;
  }

  .action-bar {
    flex-wrap: wrap;
    margin-top: var(--fg-s4);
    padding: var(--fg-s3) var(--fg-s4);
  }

  .action-bar :deep(.el-button) {
    flex: 1;
    margin-left: 0;
  }
}
</style>
