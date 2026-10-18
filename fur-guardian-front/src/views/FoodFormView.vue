<template>
  <div class="fg-page">
    <div class="fg-card" style="max-width: 780px; margin: 0 auto">
      <h2 class="fg-section-title">{{ isEdit ? '编辑食品' : '录入食品' }}</h2>
      <p class="fg-muted">
        按包装袋上的「产品成分分析保证值」逐项填写即可，未标注的项留空。代谢能（kcal/kg）若未标注，系统将按修正 Atwater 公式估算。
      </p>

      <el-form label-position="top">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="食品名称" required>
              <el-input v-model="form.name" placeholder="例如：皇家贵宾成犬粮" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="品牌">
              <el-input v-model="form.brand" placeholder="例如：Royal Canin" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="类型">
              <el-select v-model="form.foodType" style="width: 100%">
                <el-option v-for="o in FOOD_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="性质">
              <el-select v-model="form.productType" style="width: 100%">
                <el-option v-for="o in PRODUCT_TYPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="适用物种">
              <el-select v-model="form.speciesScope" style="width: 100%">
                <el-option v-for="o in SPECIES_SCOPE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="生命阶段">
              <el-select v-model="form.lifeStage" style="width: 100%">
                <el-option v-for="o in LIFE_STAGE_OPTIONS" :key="o.value" :value="o.value" :label="o.label" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="代谢能 (kcal/kg)">
              <el-input-number v-model="form.labeledMeKcal" :min="0" :max="6000" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="原料组成">
          <el-input v-model="form.ingredients" type="textarea" :rows="2" placeholder="按包装标注顺序，用逗号分隔" />
        </el-form-item>

        <el-divider content-position="left">产品成分分析保证值（%）</el-divider>
        <el-row :gutter="16">
          <el-col v-for="n in nutrientFields" :key="n.key" :span="8">
            <el-form-item :label="n.label">
              <el-input-number
                v-model="form.nutrients[n.key]"
                :min="0"
                :max="100"
                :step="0.1"
                :precision="1"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>

      <div class="form-actions">
        <el-button type="primary" :loading="saving" @click="save">{{ isEdit ? '保存修改' : '录入' }}</el-button>
        <el-button @click="router.back()">取消</el-button>
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
.form-actions {
  display: flex;
  gap: 12px;
}
</style>
