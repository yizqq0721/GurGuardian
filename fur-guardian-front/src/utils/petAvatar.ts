import type { Species } from '@/types'

const modules = import.meta.glob('../photo/pet-avatar/*.png', {
  eager: true,
  query: '?url',
  import: 'default',
}) as Record<string, string>

export interface PetAvatarOption {
  /** 入库用稳定标识，避免 Vite 构建后的哈希文件名失效 */
  key: string
  species: Species
  url: string
}

const urlByKey = new Map<string, string>()

export const PET_AVATAR_OPTIONS: PetAvatarOption[] = Object.entries(modules)
  .map(([path, url]) => {
    const key = path.slice(path.lastIndexOf('/') + 1)
    urlByKey.set(key, url)
    const species: Species = key.startsWith('萌犬') ? 'dog' : 'cat'
    return { key, species, url }
  })
  .sort((a, b) => a.key.localeCompare(b.key, 'zh-Hans-CN', { numeric: true }))

export function petAvatarUrl(avatar?: string | null): string {
  if (!avatar) return ''
  if (/^(?:https?:|data:|blob:|\/)/.test(avatar)) return avatar
  return urlByKey.get(avatar) ?? ''
}

export function avatarBelongsToSpecies(avatar: string | null | undefined, species: Species): boolean {
  if (!avatar) return true
  const option = PET_AVATAR_OPTIONS.find((o) => o.key === avatar)
  return !option || option.species === species
}
