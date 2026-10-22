<template>
  <div class="avatar-picker">
    <div class="avatar-grid" role="radiogroup" :aria-label="`${speciesLabel}头像`">
      <button
        v-for="(option, i) in options"
        :key="option.key"
        type="button"
        role="radio"
        :aria-checked="modelValue === option.key"
        :aria-label="`${speciesLabel}头像 ${i + 1}`"
        class="avatar-opt"
        :class="{ 'is-active': modelValue === option.key }"
        @click="toggle(option.key)"
      >
        <img :src="option.url" alt="" loading="lazy" draggable="false" />
        <span v-if="modelValue === option.key" class="pick-mark" aria-hidden="true">
          <Check :size="11" />
        </span>
      </button>

      <button
        type="button"
        class="avatar-opt avatar-upload"
        :class="{ 'is-active': isCustomAvatar }"
        :disabled="uploading"
        :aria-label="isCustomAvatar ? '重新上传头像' : '上传本地图片作为头像'"
        @click="pickFile"
      >
        <template v-if="isCustomAvatar">
          <img :src="modelValue || ''" alt="" draggable="false" />
          <span class="pick-mark" aria-hidden="true">
            <Check :size="11" />
          </span>
        </template>
        <template v-else>
          <Upload :size="18" aria-hidden="true" />
          <span class="upload-text">{{ uploading ? '上传中' : '上传' }}</span>
        </template>
        <span v-if="uploading" class="upload-mask" aria-hidden="true">
          <span class="spinner" />
        </span>
      </button>
    </div>
    <input
      ref="fileInput"
      class="file-input"
      type="file"
      accept="image/jpeg,image/png,image/webp"
      @change="onFileChange"
    />
    <p class="pick-hint fg-muted">
      选一张插画作为{{ speciesLabel }}头像，再次点击已选头像可取消；也可上传 JPG/PNG/WebP 图片（≤5MB）。
      <button v-if="isCustomAvatar" type="button" class="hint-action" @click="clearCustom">
        移除上传的图片
      </button>
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { Check, Upload } from 'lucide-vue-next'
import { ElMessage } from 'element-plus'
import { avatarBelongsToSpecies, PET_AVATAR_OPTIONS } from '@/utils/petAvatar'
import { uploadApi } from '@/api/upload'
import type { Species } from '@/types'

const MAX_FILE_SIZE = 5 * 1024 * 1024
const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp']

const props = defineProps<{
  modelValue?: string | null
  species: Species
}>()

const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()

const fileInput = ref<HTMLInputElement>()
const uploading = ref(false)

const options = computed(() => PET_AVATAR_OPTIONS.filter((o) => o.species === props.species))
const speciesLabel = computed(() => (props.species === 'cat' ? '猫咪' : '狗狗'))
const isCustomAvatar = computed(() => /^https?:\/\//.test(props.modelValue || ''))

watch(
  () => props.species,
  (species) => {
    if (!avatarBelongsToSpecies(props.modelValue, species)) emit('update:modelValue', '')
  },
)

function toggle(key: string) {
  emit('update:modelValue', props.modelValue === key ? '' : key)
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
  } catch {
    // request.ts 已统一提示错误
  } finally {
    uploading.value = false
    input.value = ''
  }
}

function clearCustom() {
  emit('update:modelValue', '')
}
</script>

<style scoped>
.avatar-picker {
  width: 100%;
}

.avatar-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(56px, 1fr));
  gap: var(--fg-s2);
  width: 100%;
  max-width: 640px;
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

.avatar-upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  border-style: dashed;
  color: var(--fg-ink-muted);
}

.avatar-upload:hover:not(:disabled) {
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.avatar-upload:disabled {
  cursor: wait;
  opacity: 0.7;
}

.upload-text {
  font-size: 11px;
  letter-spacing: 0.04em;
}

.upload-mask {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgb(255 255 255 / 65%);
}

.spinner {
  width: 14px;
  height: 14px;
  border: 2px solid var(--fg-line-strong);
  border-top-color: var(--fg-accent);
  border-radius: 50%;
  animation: avatar-spin 0.8s linear infinite;
}

@keyframes avatar-spin {
  to { transform: rotate(360deg); }
}

.file-input {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
  border: 0;
}

.pick-hint {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.hint-action {
  padding: 0;
  margin-left: 6px;
  font: inherit;
  color: var(--fg-accent);
  text-decoration: underline;
  background: none;
  border: 0;
  cursor: pointer;
}

@media (max-width: 640px) {
  .avatar-grid {
    grid-template-columns: repeat(auto-fill, minmax(52px, 1fr));
  }
}
</style>
