import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  appId: 'com.furguardian.app',
  appName: 'FurGuardian',
  webDir: 'www',
  server: {
    url: 'https://47.98.17.243/?app=1',
    cleartext: false,
  },
  android: {
    backgroundColor: '#fef8ef',
  },
}

export default config
