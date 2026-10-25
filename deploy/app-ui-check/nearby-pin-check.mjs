import { spawn } from 'node:child_process'
import { writeFileSync } from 'node:fs'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9335
const OUT = 'E:/华为云比赛/2版本/deploy/app-ui-check'
const BASE = 'http://127.0.0.1:5173'

const edge = spawn(EDGE, [
  '--headless=new',
  `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-nearby',
  '--window-size=390,844',
  '--hide-scrollbars',
  '--disable-gpu',
  '--no-first-run',
  'about:blank',
], { stdio: 'ignore' })

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

for (let i = 0; i < 60; i++) {
  try {
    if ((await fetch(`http://127.0.0.1:${PORT}/json/version`)).ok) break
  } catch {}
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

// 先落到同源页面，写入登录态
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
for (let i = 0; i < 40; i++) {
  await sleep(500)
  const count = await evaluate(`document.querySelectorAll('.nby-pin').length`)
  if (count > 0) break
}
await sleep(1800)
const medical = await evaluate(`JSON.stringify({
  pins: document.querySelectorAll('.nby-pin').length,
  glyph: document.querySelector('.nby-pin')?.innerHTML,
  mapCards: document.querySelectorAll('.amap-maps').length,
  title: document.querySelector('h2.fg-section-title')?.textContent?.trim(),
})`)
console.log('medical', medical)
await shot('pin-medical')

// 切到散步公园
const toggled = await evaluate(`(() => {
  const items = [...document.querySelectorAll('.el-segmented__item')];
  const park = items.find((e) => e.textContent.includes('散步公园'));
  if (!park) return 'no-park-option';
  park.click();
  return 'clicked';
})()`)
console.log('toggle', toggled)
await sleep(5000)
const park = await evaluate(`JSON.stringify({
  pins: document.querySelectorAll('.nby-pin').length,
  glyph: document.querySelector('.nby-pin')?.innerHTML,
  title: document.querySelector('h2.fg-section-title')?.textContent?.trim(),
})`)
console.log('park', park)
await shot('pin-park')

// 提醒页完成项
await send('Page.navigate', { url: `${BASE}/reminders?app=1` })
await sleep(4500)
const done = await evaluate(`(() => {
  const rows = [...document.querySelectorAll('.tl-row')];
  const doneRow = rows.find((r) => r.classList.contains('is-done')) || rows[0];
  if (!doneRow) return JSON.stringify({rows: 0});
  doneRow.classList.add('is-done');
  const name = doneRow.querySelector('.tl-name');
  return JSON.stringify({rows: rows.length, text: name?.textContent, decoration: getComputedStyle(name).textDecorationLine, color: getComputedStyle(name).color});
})()`)
console.log('reminders', done)
await shot('reminders-done')

edge.kill()
process.exit(0)
