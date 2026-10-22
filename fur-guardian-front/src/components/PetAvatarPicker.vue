<template>
  <div class="avatar-picker">
    <div class="avatar-choices">
      <div class="choice">
        <button
          type="button"
          class="avatar-tile"
          :class="{ 'is-active': isSystemSelected }"
          aria-haspopup="dialog"
          :aria-label="`选择系统${speciesLabel}头像`"
          @click="systemOpen = true"
        >
          <img v-if="systemPreview" :src="systemPreview" alt="" draggable="false" />
          <span v-else class="tile-empty">
            <PawPrint :size="18" />
            <span>系统头像</span>
          </span>
          <span v-if="isSystemSelected" class="pick-mark" aria-hidden="true">
            <Check :size="11" />
          </span>
          <span class="tile-cue" aria-hidden="true">
            {{ isSystemSelected ? '点击切换' : '点击选择' }}
          </span>
        </button>
        <span class="choice-label">系统头像</span>
      </div>

      <div class="choice">
        <button
          type="button"
          class="avatar-tile"
          :class="{ 'is-active': isCustom, 'is-empty': !isCustom && !uploading }"
          :disabled="uploading"
          :aria-label="isCustom ? '更换上传的头像' : '上传本地图片作为头像'"
          @click="pickFile"
        >
          <template v-if="isCustom && !uploading">
            <img :src="modelValue || ''" alt="" draggable="false" />
            <span class="pick-mark" aria-hidden="true"><Check :size="11" /></span>
            <span class="tile-cue" aria-hidden="true">点击更换</span>
          </template>
          <span v-else-if="uploading" class="tile-empty tile-uploading" aria-live="polite">
            <LoaderCircle :size="18" class="spin" />
            <span>上传中</span>
          </span>
          <span v-else class="tile-empty">
            <Upload :size="18" />
            <span>上传图片</span>
          </span>
        </button>
        <span class="choice-label">上传头像</span>
        <input
          ref="fileInput"
          class="file-input"
          type="file"
          accept="image/jpeg,image/png,image/webp"
          @change="onFileChange"
        />
      </div>
    </div>

    <div class="avatar-foot">
      <p class="pick-hint fg-muted">
        系统头像点开后可挑选，也可上传本地图片（JPG / PNG / WebP，≤ 5MB）。
      </p>
      <button v-if="modelValue" type="button" class="clear-link" @click="clearAvatar">
        清除头像
      </button>
    </div>

    <el-dialog
      v-model="systemOpen"
      :title="`选择${speciesLabel}头像`"
      width="min(520px, 92vw)"
      append-to-body
      class="avatar-dialog"
    >
      <div class="dialog-grid" role="radiogroup" :aria-label="`${speciesLabel}头像列表`">
        <button
          v-for="(option, i) in options"
          :key="option.key"
          type="button"
          role="radio"
          :aria-checked="modelValue === option.key"
          :aria-label="`${speciesLabel}头像 ${i + 1}`"
          class="avatar-opt"
          :class="{ 'is-active': modelValue === option.key }"
          @click="chooseSystem(option.key)"
        >
          <img :src="option.url" alt="" loading="lazy" draggable="false" />
          <span v-if="modelValue === option.key" class="pick-mark" aria-hidden="true">
            <Check :size="11" />
          </span>
        </button>
      </div>
      <template #footer>
        <el-button v-if="modelValue" text @click="clearAvatar">清除头像</el-button>
        <el-button @click="systemOpen = false">取消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Check, LoaderCircle, PawPrint, Upload } from 'lucide-vue-next'
import { uploadApi } from '@/api/upload'
import { avatarBelongsToSpecies, PET_AVATAR_OPTIONS } from '@/utils/petAvatar'
import type { Species } from '@/types'

const props = defineProps<{
  modelValue?: string | null
  species: Species
}>()

const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()

const MAX_FILE_SIZE = 5 * 1024 * 1024
const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp']

const options = computed(() => PET_AVATAR_OPTIONS.filter((o) => o.species === props.species))
const speciesLabel = computed(() => (props.species === 'cat' ? '猫咪' : '狗狗'))

const fileInput = ref<HTMLInputElement>()
const systemOpen = ref(false)
const uploading = ref(false)

const systemOption = computed(() => PET_AVATAR_OPTIONS.find((o) => o.key === props.modelValue))
const isSystemSelected = computed(() => systemOption.value?.species === props.species)
const isCustom = computed(() => /^https?:\/\//.test(props.modelValue || ''))
const systemPreview = computed(() =>
  isSystemSelected.value ? systemOption.value?.url : options.value[0]?.url,
)

watch(
  () => props.species,
  (species) => {
    systemOpen.value = false
    if (!avatarBelongsToSpecies(props.modelValue, species)) emit('update:modelValue', '')
  },
)

function chooseSystem(key: string) {
  emit('update:modelValue', key)
  systemOpen.value = false
}

function clearAvatar() {
  emit('update:modelValue', '')
  systemOpen.value = false
}

function pickFile() {
  if (uploading.value) return
  fileInput.value?.click()
}

async function onFileChange(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  if (!ACCEPTED_TYPES.includes(file.type)) {
    ElMessage.error('仅支持 JPG、PNG、WebP 格式的图片')
    input.value = ''
    return
  }
  if (file.size > MAX_FILE_SIZE) {
    ElMessage.error('图片大小不能超过 5MB')
    input.value = ''
    return
  }

  uploading.value = true
  try {
    const { url } = await uploadApi.avatar(file)
    emit('update:modelValue', url)
    ElMessage.success('头像上传成功')
  } catch {
    // request.ts 已经统一提示错误
  } finally {
    uploading.value = false
    input.value = ''
  }
}
</script>

<style scoped>
.avatar-picker {
  width: 100%;
}

.avatar-choices {
  display: flex;
  flex-wrap: wrap;
  gap: var(--fg-s5);
}

.choice {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--fg-s2);
}

.avatar-tile {
  position: relative;
  width: 92px;
  height: 92px;
  padding: 0;
  background: var(--fg-paper);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
  cursor: pointer;
  transition:
    border-color var(--fg-motion),
    box-shadow var(--fg-motion);
}

.avatar-tile:hover:not(:disabled) {
  border-color: var(--fg-line-strong);
}

.avatar-tile:disabled {
  cursor: progress;
}

.avatar-tile.is-empty {
  border-style: dashed;
  background: var(--fg-surface);
}

.avatar-tile img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-tile.is-active {
  border-color: var(--fg-accent);
  outline: 1px solid var(--fg-accent);
  outline-offset: -1px;
}

.choice-label {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  letter-spacing: 0.02em;
}

.tile-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  width: 100%;
  height: 100%;
  font-size: 11px;
  color: var(--fg-ink-muted);
}

.tile-uploading {
  color: var(--fg-accent);
}

.spin {
  animation: avatar-spin 0.9s linear infinite;
}

@keyframes avatar-spin {
  to {
    transform: rotate(360deg);
  }
}

.tile-cue {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  padding: 3px 0 4px;
  font-size: 10px;
  line-height: 1.4;
  color: #fff;
  text-align: center;
  background: rgb(20 24 20 / 52%);
  opacity: 0;
  transition: opacity var(--fg-motion);
  pointer-events: none;
}

.avatar-tile:hover .tile-cue,
.avatar-tile:focus-visible .tile-cue {
  opacity: 1;
}

.pick-mark {
  position: absolute;
  right: 3px;
  bottom: 3px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: var(--fg-accent);
  color: var(--fg-surface);
  border-radius: 3px;
}

.avatar-foot {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--fg-s2) var(--fg-s4);
  margin-top: var(--fg-s3);
}

.pick-hint {
  margin: 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.clear-link {
  padding: 0;
  font-family: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
  background: none;
  border: 0;
  cursor: pointer;
}

.clear-link:hover {
  text-decoration: underline;
}

.file-input {
  display: none;
}

.dialog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
  gap: var(--fg-s2);
  max-height: 46vh;
  padding-right: 4px;
  overflow-y: auto;
}

.avatar-opt {
  position: relative;
  aspect-ratio: 1;
  padding: 0;
  background: var(--fg-paper);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
  cursor: pointer;
  transition: border-color var(--fg-motion);
}

.avatar-opt img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-opt:hover {
  border-color: var(--fg-line-strong);
}

.avatar-opt.is-active {
  border-color: var(--fg-accent);
  outline: 1px solid var(--fg-accent);
  outline-offset: -1px;
}

@media (max-width: 640px) {
  .avatar-choices {
    gap: var(--fg-s4);
  }

  .avatar-tile {
    width: 80px;
    height: 80px;
  }

  .dialog-grid {
    grid-template-columns: repeat(auto-fill, minmax(56px, 1fr));
  }
}
</style>
