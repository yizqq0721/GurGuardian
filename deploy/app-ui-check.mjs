import { spawn } from 'node:child_process'
import { writeFileSync, mkdirSync } from 'node:fs'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9333
const OUT = 'E:/华为云比赛/2版本/deploy/app-ui-check'
const BASE = 'https://47.98.17.243'
mkdirSync(OUT, { recursive: true })

const edge = spawn(EDGE, [
  '--headless=new',
  `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-appui',
  '--window-size=390,844',
  '--hide-scrollbars',
  '--disable-gpu',
  '--no-first-run',
  'about:blank',
], { stdio: 'ignore' })

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

async function waitVersion() {
  for (let i = 0; i < 60; i++) {
    try {
      const r = await fetch(`http://127.0.0.1:${PORT}/json/version`)
      if (r.ok) return r.json()
    } catch {}
    await sleep(300)
  }
  throw new Error('edge did not start')
}

class CDP {
  constructor(ws) {
    this.ws = ws
    this.id = 0
    this.pending = new Map()
    this.events = new Map()
    ws.addEventListener('message', (ev) => {
      const msg = JSON.parse(ev.data)
      if (msg.id && this.pending.has(msg.id)) {
        const { resolve, reject } = this.pending.get(msg.id)
        this.pending.delete(msg.id)
        msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result)
      } else if (msg.method) {
        const list = this.events.get(msg.method) || []
        list.forEach((fn) => fn(msg.params))
      }
    })
  }
  send(method, params = {}) {
    const id = ++this.id
    this.ws.send(JSON.stringify({ id, method, params }))
    return new Promise((resolve, reject) => this.pending.set(id, { resolve, reject }))
  }
  once(method, timeout = 20000) {
    return new Promise((resolve, reject) => {
      const list = this.events.get(method) || []
      const timer = setTimeout(() => reject(new Error(`timeout ${method}`)), timeout)
      const handler = (p) => {
        clearTimeout(timer)
        this.events.set(method, (this.events.get(method) || []).filter((f) => f !== handler))
        resolve(p)
      }
      list.push(handler)
      this.events.set(method, list)
    })
  }
}

async function connect(wsUrl) {
  const ws = new WebSocket(wsUrl)
  await new Promise((res, rej) => {
    ws.addEventListener('open', res)
    ws.addEventListener('error', rej)
  })
  return new CDP(ws)
}

async function shoot(cdp, name) {
  await sleep(1200)
  const { data } = await cdp.send('Page.captureScreenshot', { format: 'png' })
  writeFileSync(`${OUT}/${name}.png`, Buffer.from(data, 'base64'))
  console.log('shot', name)
}

async function go(cdp, path) {
  const loaded = cdp.once('Page.loadEventFired', 25000).catch(() => null)
  await cdp.send('Page.navigate', { url: `${BASE}${path}` })
  await loaded
  await sleep(1200)
}

const version = await waitVersion()
const target = await (await fetch(`http://127.0.0.1:${PORT}/json/new?about:blank`, { method: 'PUT' })).json()
const cdp = await connect(target.webSocketDebuggerUrl)
await cdp.send('Page.enable')
await cdp.send('Runtime.enable')
await cdp.send('Emulation.setDeviceMetricsOverride', {
  width: 390, height: 844, deviceScaleFactor: 2, mobile: true,
})
await cdp.send('Emulation.setTouchEmulationEnabled', { enabled: true, maxTouchPoints: 5 })

// 1) 未登录：App 壳应落在登录页
await go(cdp, '/auth?app=1')
await shoot(cdp, '01-login')
const flag = await cdp.send('Runtime.evaluate', {
  expression: `JSON.stringify({app: localStorage.getItem('fg_app_shell'), url: location.pathname + location.search, cls: document.documentElement.className})`,
  returnByValue: true,
})
console.log('state', flag.result.value)

// 2) 用演示账号拿 token，写入与 userStore 相同的键
const login = await cdp.send('Runtime.evaluate', {
  expression: `(async () => {
    const r = await fetch('/api/auth/login', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:'demo',password:'123456'})});
    const j = await r.json();
    if (j.code !== 200) return 'login failed ' + JSON.stringify(j);
    localStorage.setItem('fg_token', j.data.token);
    localStorage.setItem('fg_user', JSON.stringify({userId:j.data.userId, nickname:j.data.nickname, isAdmin: !!j.data.isAdmin}));
    return 'ok';
  })()`,
  awaitPromise: true,
  returnByValue: true,
})
console.log('login', login.result.value)

for (const [path, name] of [
  ['/', '02-home-pets'],
  ['/reminders', '03-reminders'],
  ['/knowledge', '04-knowledge'],
  ['/settings', '05-me'],
  ['/pets/1', '06-pet-home'],
  ['/pets/1/nutrition', '07-nutrition'],
  ['/reports', '08-reports'],
]) {
  await go(cdp, path)
  const info = await cdp.send('Runtime.evaluate', {
    expression: `JSON.stringify({url: location.pathname, title: document.querySelector('.appbar-title')?.textContent, tabs: [...document.querySelectorAll('.tabbar-label')].map(e=>e.textContent), active: document.querySelector('.tabbar-item.is-active .tabbar-label')?.textContent, hasTopbar: !!document.querySelector('.topbar'), hasHamburger: !!document.querySelector('.nav-toggle'), overflowX: document.documentElement.scrollWidth > window.innerWidth})`,
    returnByValue: true,
  })
  console.log(name, info.result.value)
  await shoot(cdp, name)
}

// 3) 网页版不受影响：清掉 App 标记后同一地址应回到原布局
await cdp.send('Runtime.evaluate', {
  expression: `localStorage.removeItem('fg_app_shell')`,
  returnByValue: true,
})
await go(cdp, '/pets')
const web = await cdp.send('Runtime.evaluate', {
  expression: `JSON.stringify({url: location.pathname, hasTopbar: !!document.querySelector('.topbar'), tabs: document.querySelectorAll('.tabbar-label').length, hamburger: getComputedStyle(document.querySelector('.nav-toggle')).display, cls: document.documentElement.className})`,
  returnByValue: true,
})
console.log('web-mode', web.result.value)
await shoot(cdp, '09-web-mode')

await cdp.send('Page.captureScreenshot', { format: 'png' }).catch(() => {})
edge.kill()
process.exit(0)
