import { spawn } from 'node:child_process'
import { writeFileSync } from 'node:fs'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9337
const OUT = 'E:/华为云比赛/2版本/deploy/app-ui-check'
const BASE = 'https://47.98.17.243'

const edge = spawn(EDGE, [
  '--headless=new', `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-prodpins',
  '--window-size=390,844', '--hide-scrollbars', '--disable-gpu', '--no-first-run', 'about:blank',
], { stdio: 'ignore' })
const sleep = (ms) => new Promise((r) => setTimeout(r, ms))
for (let i = 0; i < 60; i++) {
  try { if ((await fetch(`http://127.0.0.1:${PORT}/json/version`)).ok) break } catch {}
  await sleep(300)
}
const target = await (await fetch(`http://127.0.0.1:${PORT}/json/new?about:blank`, { method: 'PUT' })).json()
const ws = new WebSocket(target.webSocketDebuggerUrl)
await new Promise((res, rej) => { ws.addEventListener('open', res); ws.addEventListener('error', rej) })
let seq = 0
const pending = new Map()
ws.addEventListener('message', (ev) => {
  const m = JSON.parse(ev.data)
  if (m.id && pending.has(m.id)) {
    const { resolve, reject } = pending.get(m.id)
    pending.delete(m.id)
    m.error ? reject(new Error(JSON.stringify(m.error))) : resolve(m.result)
  }
})
const send = (method, params = {}) => {
  const id = ++seq
  ws.send(JSON.stringify({ id, method, params }))
  return new Promise((resolve, reject) => pending.set(id, { resolve, reject }))
}
const evaluate = async (expression) => {
  const r = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })
  if (r.exceptionDetails) throw new Error(JSON.stringify(r.exceptionDetails))
  return r.result.value
}
const shot = async (name) => {
  const { data } = await send('Page.captureScreenshot', { format: 'png' })
  writeFileSync(`${OUT}/${name}.png`, Buffer.from(data, 'base64'))
  console.log('shot', name)
}
await send('Page.enable')
await send('Runtime.enable')
await send('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 2, mobile: true })
await send('Emulation.setTouchEmulationEnabled', { enabled: true, maxTouchPoints: 5 })
await send('Browser.grantPermissions', { origin: BASE, permissions: ['geolocation'] })
await send('Emulation.setGeolocationOverride', { latitude: 30.2741, longitude: 120.1551, accuracy: 25 })

await send('Page.navigate', { url: `${BASE}/auth` })
await sleep(2500)
const login = await evaluate(`(async () => {
  const r = await fetch('/api/auth/login', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:'demo',password:'123456'})});
  const j = await r.json();
  if (j.code !== 200) return 'login failed ' + JSON.stringify(j);
  localStorage.setItem('fg_token', j.data.token);
  localStorage.setItem('fg_user', JSON.stringify({userId:j.data.userId, nickname:j.data.nickname, isAdmin: !!j.data.isAdmin}));
  return 'ok';
})()`)
console.log('login', login)

await send('Page.navigate', { url: `${BASE}/nearby?app=1` })
for (let i = 0; i < 50; i++) {
  await sleep(500)
  if (await evaluate(`document.querySelectorAll('.nby-pin').length > 0`)) break
}
await sleep(2000)
const medical = await evaluate(`(() => {
  const map = document.querySelector('.map').getBoundingClientRect();
  const inside = [...document.querySelectorAll('.nby-pin')].filter((el) => {
    const r = el.getBoundingClientRect();
    const x = r.x + r.width / 2, y = r.y + r.height / 2;
    return x > map.x && x < map.x + map.width && y > map.y && y < map.y + map.height;
  }).length;
  const glyph = document.querySelector('.nby-pin svg circle') ? 'paw' : 'other';
  return JSON.stringify({ entry: [...document.scripts].map(s => s.src).find(s => s.includes('/assets/index-'))?.split('/').pop(), pins: document.querySelectorAll('.nby-pin').length, inside, glyph, title: document.querySelector('h2.fg-section-title')?.textContent?.trim() });
})()`)
console.log('medical', medical)
await shot('prod-pin-medical')

await evaluate(`(() => { const p = [...document.querySelectorAll('.el-segmented__item')].find(e => e.textContent.includes('散步公园')); p?.click(); })()`)
await sleep(5500)
const park = await evaluate(`(() => {
  const map = document.querySelector('.map').getBoundingClientRect();
  const inside = [...document.querySelectorAll('.nby-pin')].filter((el) => {
    const r = el.getBoundingClientRect();
    const x = r.x + r.width / 2, y = r.y + r.height / 2;
    return x > map.x && x < map.x + map.width && y > map.y && y < map.y + map.height;
  }).length;
  return JSON.stringify({ pins: document.querySelectorAll('.nby-pin').length, inside, glyph: document.querySelector('.nby-pin svg path')?.getAttribute('d')?.slice(0, 12) });
})()`)
console.log('park', park)
await shot('prod-pin-park')

await send('Page.navigate', { url: `${BASE}/reminders?app=1` })
await sleep(4500)
const reminders = await evaluate(`(() => {
  const done = document.querySelector('.is-done .tl-name');
  const entries = [...document.scripts].map(s => s.src).find(s => s.includes('/assets/index-'))?.split('/').pop();
  return JSON.stringify({ entry: entries, doneRow: !!done, decoration: done ? getComputedStyle(done).textDecorationLine : null, rows: document.querySelectorAll('.tl-row').length });
})()`)
console.log('reminders', reminders)
await shot('prod-reminders-done')

edge.kill()
process.exit(0)
