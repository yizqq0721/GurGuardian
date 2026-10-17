import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { petApi } from '@/api/pet'
import type { Pet } from '@/types'

const CURRENT_KEY = 'fg_current_pet'

export const usePetStore = defineStore('pet', () => {
  const pets = ref<Pet[]>([])
  const currentPetId = ref<number | null>(Number(localStorage.getItem(CURRENT_KEY)) || null)
  const loaded = ref(false)

  const currentPet = computed(() =>
    pets.value.find((p) => p.id === currentPetId.value) ?? pets.value[0] ?? null,
  )

  async function fetchPets(force = false) {
    if (loaded.value && !force) return
    pets.value = await petApi.list()
    loaded.value = true
    if (pets.value.length && !pets.value.some((p) => p.id === currentPetId.value)) {
      setCurrentPet(pets.value[0].id)
    }
  }

  function setCurrentPet(id: number) {
    currentPetId.value = id
    localStorage.setItem(CURRENT_KEY, String(id))
  }

  function reset() {
    pets.value = []
    currentPetId.value = null
    loaded.value = false
    localStorage.removeItem(CURRENT_KEY)
  }

  return { pets, currentPetId, currentPet, fetchPets, setCurrentPet, reset }
})
