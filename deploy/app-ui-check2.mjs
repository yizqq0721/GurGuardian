import { spawn } from 'node:child_process'
import { writeFileSync, mkdirSync } from 'node:fs'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9334
const OUT = 'E:/华为云比赛/2版本/deploy/app-ui-check'
const BASE = 'https://47.98.17.243'
mkdirSync(OUT, { recursive: true })

const edge = spawn(EDGE, [
  '--headless=new',
  `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-appui2',
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
  await sleep(1500)
}

async function evaluate(cdp, expression) {
  const r = await cdp.send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })
  if (r.exceptionDetails) throw new Error(JSON.stringify(r.exceptionDetails))
  return r.result.value
}

async function clickSelector(cdp, selector) {
  const rect = await evaluate(cdp, `(() => {
    const el = document.querySelector(${JSON.stringify(selector)});
    if (!el) return null;
    const r = el.getBoundingClientRect();
    return { x: r.x + r.width / 2, y: r.y + r.height / 2 };
  })()`)
  if (!rect) throw new Error(`not found: ${selector}`)
  for (const type of ['mousePressed', 'mouseReleased']) {
    await cdp.send('Input.dispatchMouseEvent', {
      type, x: rect.x, y: rect.y, button: 'left', clickCount: 1,
    })
  }
  await sleep(900)
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

await go(cdp, '/auth?app=1')
await evaluate(cdp, `(async () => {
  const r = await fetch('/api/auth/login', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:'demo',password:'123456'})});
  const j = await r.json();
  localStorage.setItem('fg_token', j.data.token);
  localStorage.setItem('fg_user', JSON.stringify({userId:j.data.userId, nickname:j.data.nickname, isAdmin: !!j.data.isAdmin}));
  return 'ok';
})()`)

// 知识问答：历史抽屉应与顶栏、底栏对齐
await go(cdp, '/knowledge')
await clickSelector(cdp, '.hist-btn')
const drawer = await evaluate(cdp, `(() => {
  const pane = document.querySelector('.sess-pane');
  const mask = document.querySelector('.drawer-mask');
  const appbar = document.querySelector('.appbar');
  const tabbar = document.querySelector('.tabbar');
  const box = (el) => el ? { top: Math.round(el.getBoundingClientRect().top), bottom: Math.round(el.getBoundingClientRect().bottom), left: Math.round(el.getBoundingClientRect().left), width: Math.round(el.getBoundingClientRect().width) } : null;
  return JSON.stringify({ appbar: box(appbar), tabbar: box(tabbar), pane: box(pane), mask: box(mask) });
})()`)
console.log('drawer', drawer)
await shoot(cdp, '10-knowledge-drawer')
await clickSelector(cdp, '.drawer-mask')
await sleep(500)

for (const [path, name] of [
  ['/profile', '11-user-profile'],
  ['/reminders/calendar', '12-calendar'],
  ['/foods', '13-foods'],
  ['/nearby', '14-nearby'],
]) {
  await go(cdp, path)
  const info = await evaluate(cdp, `JSON.stringify({url: location.pathname, title: document.querySelector('.appbar-title')?.textContent, back: !!document.querySelector('.appbar-btn'), overflowX: document.documentElement.scrollWidth > window.innerWidth, dupBack: !!document.querySelector('.fg-back') && getComputedStyle(document.querySelector('.fg-back')).display !== 'none'})`)
  console.log(name, info)
  await shoot(cdp, name)
}

edge.kill()
process.exit(0)
