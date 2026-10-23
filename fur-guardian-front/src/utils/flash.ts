const FLASH_KEY = 'fg_flash_message'

export function setFlashMessage(message: string) {
  sessionStorage.setItem(FLASH_KEY, message)
}

export function consumeFlashMessage(): string | null {
  const message = sessionStorage.getItem(FLASH_KEY)
  if (message) {
    sessionStorage.removeItem(FLASH_KEY)
  }
  return message
}
