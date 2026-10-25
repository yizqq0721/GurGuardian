#!/usr/bin/env node
// 演示数据体检与刷新：node deploy/demo-pets.mjs check
//                     node deploy/demo-pets.mjs refresh [--apply]
// 默认连接线上演示账号，可用 FG_BASE / FG_USER / FG_PASS 覆盖。
// 可选 FG_TODAY=yyyy-MM-dd 指定基准日（用于预演未来某天的刷新计划）。

const BASE = process.env.FG_BASE || 'https://47.98.17.243';
const USER = process.env.FG_USER || 'demo';
const PASS = process.env.FG_PASS || '123456';
const MODE = process.argv[2] || 'check';
const APPLY = process.argv.includes('--apply');

const DAY = 86400000;
const pad = (n) => String(n).padStart(2, '0');
const iso = (d) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
const parse = (s) => new Date(`${s.slice(0, 10)}T00:00:00`);
const shift = (d, n) => new Date(d.getTime() + n * DAY);
const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

const today = process.env.FG_TODAY ? parse(process.env.FG_TODAY) : new Date();
today.setHours(0, 0, 0, 0);
const windowStart = shift(today, -6);

const PETS = {
  旺财: { foodId: 1, grams: [95, 95], bcs: 5, weights: [[-6, 11.9], [-3, 12.0], [0, 12.1]] },
  阿黄: { foodId: 1, grams: [165, 165], bcs: 5, weights: [[-6, 15.1], [-3, 15.3], [0, 15.2]] },
  奶糖: { foodId: 2, grams: [40, 40], bcs: 6, weights: [[-6, 4.6], [-3, 4.7], [0, 4.8]] },
  汤圆: { foodId: 2, grams: [65, 60], bcs: 7, weights: [[-6, 6.8], [-3, 6.9], [0, 7.0]] },
};

let token = '';

async function api(method, path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method,
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  const json = await res.json();
  if (json.code !== 200) throw new Error(`${method} ${path} -> code ${json.code} ${json.message}`);
  return json.data;
}

function range(from, to) {
  const out = [];
  for (let d = new Date(from); d <= to; d = shift(d, 1)) out.push(new Date(d));
  return out;
}

function dueDates(reminder, logs, from, to) {
  const earliest = logs
    .filter((l) => l.reminderId === reminder.id && l.doneDate)
    .map((l) => parse(l.doneDate))
    .sort((a, b) => a - b)[0];
  const created = reminder.createdAt ? parse(reminder.createdAt) : null;
  const anchor = earliest && (!created || earliest < created) ? earliest : created;
  const start = anchor && anchor > from ? anchor : from;
  const dates = [];
  for (let d = new Date(start); d <= to; d = shift(d, 1)) {
    let due;
    if (reminder.remindDate) {
      due = iso(d) === reminder.remindDate.slice(0, 10);
    } else {
      const rule = reminder.repeatRule || 'DAILY';
      const day = d.getDay() === 0 ? 7 : d.getDay();
      if (rule === 'WEEKLY') {
        const days = (reminder.repeatDays || '').split(/[,，、\s]+/).filter((s) => /^[1-7]$/.test(s)).map(Number);
        due = days.length ? days.includes(day) : !anchor || anchor.getDay() === d.getDay();
      } else if (rule === 'MONTHLY') {
        due = !anchor || anchor.getDate() === d.getDate();
      } else if (rule === 'YEARLY') {
        due = !anchor || (anchor.getMonth() === d.getMonth() && anchor.getDate() === d.getDate());
      } else {
        due = true;
      }
    }
    if (due) dates.push(iso(d));
  }
  return dates;
}

async function load(pet) {
  const [reminders, logs, feeding, weights] = await Promise.all([
    api('GET', `/api/reminder/list?petId=${pet.id}`),
    api('GET', `/api/reminder/logs?petId=${pet.id}&startDate=${iso(windowStart)}&endDate=${iso(today)}`),
    api('GET', `/api/feeding/list?petId=${pet.id}&startDate=${iso(windowStart)}&endDate=${iso(today)}`),
    api('GET', `/api/pet/${pet.id}/weight-history`),
  ]);
  const stats = reminders.map((r) => {
    const due = dueDates(r, logs, windowStart, today);
    const doneDates = new Set(logs.filter((l) => l.reminderId === r.id).map((l) => l.doneDate.slice(0, 10)));
    const missing = due.filter((d) => !doneDates.has(d));
    return { reminder: r, due, done: due.length - missing.length, missing };
  });
  const feedingDays = [...new Set(feeding.map((f) => f.fedDate.slice(0, 10)))].sort();
  const weightDays = [...new Set(weights.map((w) => (w.recordedAt || '').slice(0, 10)).filter(Boolean))]
    .filter((d) => d >= iso(windowStart) && d <= iso(today));
  return { pet, reminders, logs, feeding, weights, stats, feedingDays, weightDays };
}

async function login() {
  token = (await api('POST', '/api/auth/login', { username: USER, password: PASS })).token;
}

async function main() {
  await login();
  const pets = await api('GET', '/api/pet/list');
  const found = Object.keys(PETS).map((name) => pets.find((p) => p.name === name));
  const missingPets = Object.keys(PETS).filter((_, i) => !found[i]);
  if (missingPets.length) throw new Error(`演示宠物缺失：${missingPets.join('、')}；请按部署记录 §27 重建`);

  const data = {};
  for (const pet of found) data[pet.name] = await load(pet);

  if (MODE === 'refresh') {
    await refresh(data);
  } else {
    check(data);
  }
}

function number(n) {
  return Math.round(n * 10) / 10;
}

function check(data) {
  const fails = [];
  const warnings = [];
  console.log(`\n演示数据检查  基准日 ${iso(today)}（${weekdays[today.getDay()]}）  窗口 ${iso(windowStart)} ~ ${iso(today)}\n`);

  for (const [name, d] of Object.entries(data)) {
    const totalDue = d.stats.reduce((s, x) => s + x.due.length, 0);
    const totalDone = d.stats.reduce((s, x) => s + x.done, 0);
    const walkMiss = d.stats
      .filter((x) => x.reminder.reminderType === 'WALK' && x.missing.length)
      .flatMap((x) => x.missing.map((date) => `${x.reminder.title}缺${date}（${weekdays[parse(date).getDay()]}）`));
    console.log(`${name}(${d.pet.id})  喂养 ${d.feedingDays.length}/7 天；打卡 ${totalDone}/${totalDue}；体重 ${d.weightDays.length} 点${walkMiss.length ? '；' + walkMiss.join('；') : ''}`);
  }
  console.log('');

  const named = (name) => data[name];
  const stat = (d, type, title) => d.stats.find((x) => x.reminder.reminderType === type && (!title || x.reminder.title.includes(title)));

  const ahuangEvening = stat(named('阿黄'), 'WALK', '傍晚');
  const ahuangMiss = ahuangEvening?.missing || [];
  if (ahuangMiss.length === 1 && ahuangMiss[0] === iso(shift(today, -3))) {
    console.log(`[PASS] 阿黄 3 天前傍晚遛弯缺口仍可见（${ahuangMiss[0]}）`);
  } else {
    fails.push(`阿黄傍晚遛弯应有且仅有 1 次缺口（预期 ${iso(shift(today, -3))}，实际 ${ahuangMiss.join('、') || '无'}）`);
  }

  const tangyuanFeeding = named('汤圆').feedingDays;
  if (tangyuanFeeding.length === 6 && !tangyuanFeeding.includes(iso(shift(today, -2)))) {
    console.log(`[PASS] 汤圆喂养缺口仍可见（缺 ${iso(shift(today, -2))}）`);
  } else {
    fails.push(`汤圆应有 6/7 天喂养记录且缺 ${iso(shift(today, -2))}，实际 ${tangyuanFeeding.length}/7：${tangyuanFeeding.join('、')}`);
  }

  const vaccine = named('旺财').reminders.find((r) => r.reminderType === 'VACCINE');
  const vaccineDelta = vaccine?.remindDate ? Math.round((parse(vaccine.remindDate) - today) / DAY) : null;
  if (vaccineDelta !== null && vaccineDelta >= 1 && vaccineDelta <= 7) {
    console.log(`[PASS] 旺财疫苗在 7 天窗口内（${vaccine.remindDate.slice(0, 10)}，${vaccineDelta} 天后）`);
  } else {
    fails.push(`旺财疫苗日期应落在未来 1~7 天，实际 ${vaccine?.remindDate || '无'}${vaccineDelta !== null ? `（${vaccineDelta} 天）` : ''}`);
  }

  const milkGroom = stat(named('奶糖'), 'GROOMING');
  if (milkGroom && milkGroom.due.length === 3 && milkGroom.done === 3) {
    console.log(`[PASS] 奶糖梳毛 3/3（下一次 ${nextGroom(named('奶糖')) || '未知'}）`);
  } else {
    fails.push(`奶糖梳毛应为 3/3，实际 ${milkGroom ? `${milkGroom.done}/${milkGroom.due.length}` : '无梳毛提醒'}`);
  }

  for (const name of ['旺财', '阿黄', '奶糖']) {
    if (named(name).feedingDays.length !== 7) {
      fails.push(`${name} 应有 7/7 天喂养记录，实际 ${named(name).feedingDays.length}/7`);
    }
  }
  for (const [name, d] of Object.entries(data)) {
    if (d.weightDays.length < 2) {
      warnings.push(`${name} 近 7 天体重记录只有 ${d.weightDays.length} 点，体重趋势演示会变平`);
    }
  }

  if (fails.length) {
    console.log('\n[FAIL] 演示数据需要刷新：');
    for (const f of fails) console.log(`  - ${f}`);
    console.log('\n执行刷新（会写入线上演示账号）：node deploy/demo-pets.mjs refresh --apply');
    process.exitCode = 1;
  } else {
    console.log('\n[PASS] 演示数据完整，缺口与疫苗场景均可用');
  }
  for (const w of warnings) console.log(`[WARN] ${w}`);
}

function nextGroom(d) {
  const r = d.reminders.find((x) => x.reminderType === 'GROOMING');
  if (!r) return null;
  const days = (r.repeatDays || '').split(',').map(Number);
  for (let i = 1; i <= 7; i++) {
    const d0 = shift(today, i);
    const w = d0.getDay() === 0 ? 7 : d0.getDay();
    if (!days.length || days.includes(w)) return iso(d0);
  }
  return null;
}

function isSkipped(petName, reminder, date) {
  if (petName === '阿黄' && (reminder.title || '').includes('傍晚') && iso(date) === iso(shift(today, -3))) return true;
  if (petName === '汤圆' && reminder.reminderType === 'FEED' && iso(date) === iso(shift(today, -2))) return true;
  return false;
}

async function refresh(data) {
  const actions = [];
  for (const [name, d] of Object.entries(data)) {
    const plan = PETS[name];

    for (const date of range(windowStart, today)) {
      const dateKey = iso(date);
      const skippedFeeding = isSkipped(name, { reminderType: 'FEED' }, date);
      for (let meal = 0; meal < 2; meal++) {
        if (skippedFeeding) continue;
        const exists = d.feeding.some((f) => f.fedDate.slice(0, 10) === dateKey && f.mealIndex === meal + 1);
        if (!exists) actions.push({ kind: 'feeding', pet: d.pet, date: dateKey, meal: meal + 1, grams: plan.grams[meal] });
      }

      for (const s of d.stats) {
        if (!s.due.includes(dateKey) || isSkipped(name, s.reminder, date)) continue;
        const exists = d.logs.some((l) => l.reminderId === s.reminder.id && l.doneDate.slice(0, 10) === dateKey);
        if (!exists) actions.push({ kind: 'checkin', pet: d.pet, reminder: s.reminder, date: dateKey });
      }
    }

    for (const [offset, kg] of plan.weights) {
      const dateKey = iso(shift(today, offset));
      if (!d.weightDays.includes(dateKey)) {
        actions.push({ kind: 'weight', pet: d.pet, date: dateKey, kg, bcs: plan.bcs });
      }
    }
  }

  const vaccine = data['旺财'].reminders.find((r) => r.reminderType === 'VACCINE');
  const vaccineTarget = iso(shift(today, 5));
  if (vaccine && vaccine.remindDate.slice(0, 10) !== vaccineTarget) {
    actions.push({ kind: 'vaccine', pet: data['旺财'].pet, reminder: vaccine, date: vaccineTarget });
  }

  const counts = actions.reduce((m, a) => ({ ...m, [a.kind]: (m[a.kind] || 0) + 1 }), {});
  console.log(`\n刷新计划：${Object.entries(counts).map(([k, v]) => `${k} ${v}`).join('，') || '无需补写'}`);
  if (!APPLY) {
    console.log('当前为预演（未写入）。确认后执行：node deploy/demo-pets.mjs refresh --apply');
    return;
  }

  for (const a of actions) {
    if (a.kind === 'feeding') {
      await api('POST', '/api/feeding', {
        petId: a.pet.id, foodId: PETS[a.pet.name].foodId, grams: a.grams, fedDate: a.date, mealIndex: a.meal,
      });
    } else if (a.kind === 'checkin') {
      const note = a.reminder.reminderType === 'WALK' ? '按时遛弯' : '按时完成';
      await api('POST', `/api/reminder/${a.reminder.id}/checkin`, { doneDate: a.date, note });
    } else if (a.kind === 'weight') {
      await api('POST', `/api/pet/${a.pet.id}/weight`, { weightKg: a.kg, bcs: a.bcs, recordedAt: a.date });
    } else if (a.kind === 'vaccine') {
      const r = a.reminder;
      await api('PUT', `/api/reminder/${r.id}`, {
        petId: a.pet.id,
        title: r.title,
        reminderType: r.reminderType,
        remindTime: (r.remindTime || '10:00:00').slice(0, 5),
        remindDate: a.date,
        repeatRule: 'ONCE',
      });
    }
  }
  console.log(`已写入 ${actions.length} 项，重新运行 check 复核：node deploy/demo-pets.mjs check`);
}

main().catch((e) => {
  console.error(`[ERROR] ${e.message}`);
  if (process.env.FG_DEBUG) console.error(e.stack);
  process.exitCode = 1;
});
