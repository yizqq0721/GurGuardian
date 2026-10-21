#!/usr/bin/env node
/**
 * 把 docs/食材营养数据知识 的中文整理稿与食材数值抽取切分成 knowledge_docs 条目，输出幂等 SQL。
 *
 *   node sql/build-food-nutrition-seed.mjs [语料根目录] > sql/knowledge_seed_food_nutrition.sql
 *
 * 收录：根目录总索引与跨来源对比、10 份板块说明、3 份食材成分中文稿、
 *       01–04 板块 raw_extracts 下的逐食材数值抽取。
 * 跳过：PDF、data 原始文件、_cache；05–07 板块的英文全文抽取（FEDIAF/NRC/WSAVA，
 *       体量大且与现有 WSAVA 营养条目重复）。
 */
import fs from 'node:fs'
import path from 'node:path'

const DEFAULT_ROOT = 'D:/code/养宠智能助手/docs/食材营养数据知识'
const ROOT = process.argv[2] || DEFAULT_ROOT

const MAX_CHUNK = 1200      // 单条正文字符上限（Redis 向量按整条嵌入，太长会稀释语义）
const HARD_SPLIT = 2000     // 超过这个长度的段落强制切
const RAW_BOARDS = new Set([
  '01-usda-fooddata-central',
  '02-japan-mext-food-composition',
  '03-china-food-composition',
  '04-fao-infoods',
])

const BOARDS = {
  '01-usda-fooddata-central': {
    tags: ['营养', '食材'],
    sourceName: 'USDA FoodData Central (SR Legacy)',
    sourceType: 'official',
    url: 'https://fdc.nal.usda.gov/',
  },
  '02-japan-mext-food-composition': {
    tags: ['营养', '食材'],
    sourceName: '日本食品標準成分表（八訂）増補2023年',
    sourceType: 'official',
    url: 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html',
  },
  '03-china-food-composition': {
    tags: ['营养', '食材'],
    sourceName: '中国食物成分表（第6版）在线查询平台',
    sourceType: 'official',
    url: 'https://nlc.chinanutri.cn/fq/',
  },
  '04-fao-infoods': {
    tags: ['营养', '食材', '数据来源'],
    sourceName: 'FAO/INFOODS 食物成分数据库目录',
    sourceType: 'official',
    url: 'https://www.fao.org/food-composition/tables-and-databases/en',
  },
  '05-fediaf-nutritional-guidelines': {
    tags: ['营养', '营养标准'],
    sourceName: 'FEDIAF Nutritional Guidelines 2025',
    sourceType: 'standard',
    url: 'https://europeanpetfood.org/self-regulation/nutritional-guidelines/',
  },
  '06-wsava-global-nutrition': {
    tags: ['营养', '营养指南'],
    sourceName: 'WSAVA Global Nutrition Guidelines',
    sourceType: 'guideline',
    url: 'https://wsava.org/global-guidelines/global-nutrition-guidelines/',
  },
  '07-nrc-nutrient-requirements': {
    tags: ['营养', '营养需求'],
    sourceName: 'NRC Nutrient Requirements of Dogs and Cats (2006)',
    sourceType: 'book',
    url: 'https://nap.nationalacademies.org/catalog/10668/nutrient-requirements-of-dogs-and-cats',
  },
  '08-aafco': {
    tags: ['营养', '营养标准'],
    sourceName: 'AAFCO',
    sourceType: 'official',
    url: 'https://www.aafco.org/',
  },
  '09-gb-pet-food-standards': {
    tags: ['营养', '营养标准'],
    sourceName: 'GB/T 31216-2014 / GB/T 31217-2014',
    sourceType: 'standard',
    url: 'https://openstd.samr.gov.cn/bzgk/gb/',
  },
  '10-ecvcn-balanceit': {
    tags: ['营养', '营养资源'],
    sourceName: 'ECVCN / Balance IT',
    sourceType: 'official',
    url: 'https://www.ecvcn.org/',
  },
}

const FOOD_NAMES = ['猪肝', '猪心', '鸡肝', '鸡心', '牛肝', '牛心']

// 板块/文件名 → 中文短标题；同一食材在不同来源下必须分开建条，不能合并
const RAW_TITLES = {
  '01-usda-fooddata-central/pork-liver-raw': '猪肝（生，USDA）',
  '01-usda-fooddata-central/pork-heart-raw': '猪心（生，USDA）',
  '01-usda-fooddata-central/chicken-liver-raw': '鸡肝（生，USDA）',
  '01-usda-fooddata-central/chicken-heart-raw': '鸡心（生，USDA）',
  '02-japan-mext-food-composition/beef-heart': '牛心（生，日本八订）',
  '02-japan-mext-food-composition/beef-liver': '牛肝（生，日本八订）',
  '02-japan-mext-food-composition/chicken-heart': '鸡心（生，日本八订）',
  '02-japan-mext-food-composition/chicken-liver': '鸡肝（生，日本八订）',
  '02-japan-mext-food-composition/pork-heart': '猪心（生，日本八订）',
  '02-japan-mext-food-composition/pork-liver': '猪肝（生，日本八订）',
  '03-china-food-composition/chicken-heart': '鸡心（生，中国第6版）',
  '03-china-food-composition/chicken-liver': '鸡肝（生，中国第6版）',
  '03-china-food-composition/pig-heart': '猪心（生，中国第6版）',
  '03-china-food-composition/pig-liver': '猪肝（生，中国第6版）',
  '03-china-food-composition/pig-liver-braised': '猪肝（卤煮，中国第6版）',
  '04-fao-infoods/china-2018': '中国食物成分表第6版（FAO 目录）',
  '04-fao-infoods/china-2019': '中国食物成分表第6版第2卷（FAO 目录）',
  '04-fao-infoods/japan-2023': '日本食品標準成分表（FAO 目录）',
  '04-fao-infoods/infoods-index': 'FAO/INFOODS 食物成分表目录',
}

const COMPILATION_SUFFIX = {
  '01-食材营养成分-USDA': 'USDA',
  '01-食材营养成分-日本八订': '日本八订',
  '01-食材营养成分-中国食物成分表': '中国第6版',
}

const BOARD_SHORT = {
  '01-usda-fooddata-central': 'USDA FoodData Central',
  '02-japan-mext-food-composition': '日本食品標準成分表',
  '03-china-food-composition': '中国食物成分表',
  '04-fao-infoods': 'FAO/INFOODS 目录',
  '05-fediaf-nutritional-guidelines': 'FEDIAF 营养指南 2025',
  '06-wsava-global-nutrition': 'WSAVA 全球营养指南',
  '07-nrc-nutrient-requirements': 'NRC 犬猫营养需要 2006',
  '08-aafco': 'AAFCO 犬猫营养 profiles',
  '09-gb-pet-food-standards': 'GB/T 31216/31217 标准',
  '10-ecvcn-balanceit': 'ECVCN 与 Balance IT',
}

const HEADING_ZH = {
  'Nutrients (per 100 g)': '每 100 g 营养数据',
  'Food Portions': '食物份量',
}

const CAUTION_RE = /中毒|致命|致死|死亡|梗阻|阻塞|窒息|急诊|紧急|危险|禁用|慎用|禁忌|休克|脱水|不良事件|危及|风险/
const META_SECTION_RE = /关键词索引|参考文献|引用文献|文献转录|文献目录|References?\b|Bibliography|中英文?对照表|分块首尾|跨块断裂|核对表|抽取稿异常|抽取异常|缺失登记|本稿覆盖/

const q = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''").replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/g, '')}'`
const cut = (s, n) => (s.length > n ? s.slice(0, n) : s)
const denum = (h) => h.replace(/^\d+(\.\d+)*[\.、]?\s*/, '').trim()

function parseFrontMatter(text) {
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/)
  if (!m) return { fm: {}, body: text }
  const fm = {}
  for (const line of m[1].split(/\r?\n/)) {
    const kv = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/)
    if (kv) fm[kv[1]] = kv[2].trim().replace(/^["']|["']$/g, '')
  }
  return { fm, body: text.slice(m[0].length) }
}

function collectFiles() {
  const files = []
  for (const e of fs.readdirSync(ROOT, { withFileTypes: true })) {
    if (e.isFile() && e.name.endsWith('.md') && !e.name.startsWith('_')) {
      files.push(path.join(ROOT, e.name))
    }
  }
  for (const board of Object.keys(BOARDS)) {
    const dir = path.join(ROOT, board)
    if (!fs.existsSync(dir)) continue
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      if (e.isFile() && e.name.endsWith('.md') && !e.name.startsWith('_')
          && (e.name === '00-板块说明.md' || e.name.startsWith('01-食材营养成分-'))) {
        files.push(path.join(dir, e.name))
      }
    }
    if (!RAW_BOARDS.has(board)) continue
    const rawDir = path.join(dir, 'raw_extracts')
    if (!fs.existsSync(rawDir)) continue
    for (const e of fs.readdirSync(rawDir, { withFileTypes: true })) {
      if (e.isFile() && e.name.endsWith('.md') && !e.name.startsWith('_')) {
        files.push(path.join(rawDir, e.name))
      }
    }
  }
  return files.sort()
}

function plainHeading(h) {
  return h
    .replace(/\[[a-z0-9-]+\]\([^)]*\)/gi, '')
    .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')
    .replace(/`/g, '')
    .replace(/[\s\u3000]+/g, ' ')
    .trim()
}

function stripMetaSections(body) {
  const parts = body.split(/\n(?=#{2,3} )/)
  const kept = []
  let h2 = ''
  for (const p of parts) {
    const head = p.match(/^(#{2,3})\s*(.+)$/m)
    const level = head ? head[1].length : 0
    const h = head ? denum(plainHeading(head[2])) : ''
    if (level === 2) h2 = h
    if (META_SECTION_RE.test(h) || META_SECTION_RE.test(h2)) continue
    kept.push(p)
  }
  return kept.join('\n')
}

function cleanSection(text) {
  return text
    .split(/\r?\n/)
    .filter((l) => !/^(-{3,}|\*{3,}|_{3,})\s*$/.test(l.trim()))
    .filter((l) => !/^>\s*(来源|原文|原文档)\s*[:：]/.test(l.trim()))
    .map((l) => l.replace(/^(#{1,6})\s+/, ''))
    .join('\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
}

function splitOversized(text) {
  if (text.length <= HARD_SPLIT) return [text]
  const paras = text.split(/\n\s*\n/)
  const out = []
  let buf = ''
  for (const p of paras) {
    if (buf && buf.length + p.length + 2 > MAX_CHUNK) {
      out.push(buf.trim())
      buf = ''
    }
    if (p.length > HARD_SPLIT) {
      if (buf.trim()) { out.push(buf.trim()); buf = '' }
      // 超长段落按句子硬切，避免截断表格行
      let rest = p
      while (rest.length > HARD_SPLIT) {
        const win = rest.slice(0, HARD_SPLIT)
        const cutAt = Math.max(win.lastIndexOf('。'), win.lastIndexOf('\n'), win.lastIndexOf('；'))
        const at = cutAt > HARD_SPLIT * 0.5 ? cutAt + 1 : HARD_SPLIT
        out.push(rest.slice(0, at).trim())
        rest = rest.slice(at)
      }
      buf = rest
      continue
    }
    buf += (buf ? '\n\n' : '') + p
  }
  if (buf.trim()) out.push(buf.trim())
  return out.filter(Boolean)
}

function inferSpecies(text) {
  const dog = /犬|狗|\bdogs?\b/i.test(text)
  const cat = /猫|\bcats?\b/i.test(text)
  // 同时涉及或都不涉及 → 留空：检索侧按 species LIKE 过滤，'both' 会被漏掉
  if (dog === cat) return ''
  return dog ? 'dog' : 'cat'
}

function inferLifeStage(text) {
  const young = /幼犬|幼猫|幼龄|断奶|离乳|pupp(y|ies)|kitten/i.test(text)
  const senior = /老年|老龄|高龄|senior|geriatric/i.test(text)
  if (young === senior) return ''
  return young ? 'young' : 'senior'
}

function headingOf(chunk, fallback) {
  const first = chunk.split(/\r?\n/)[0].trim()
  const h = denum(plainHeading(first))
  return h && h.length <= 60 ? h : fallback
}

function resolveFileMeta(file, fm, isRaw) {
  const rel = path.relative(ROOT, file).split(path.sep)
  const boardKey = BOARDS[rel[0]] ? rel[0] : ''
  const board = boardKey ? BOARDS[boardKey] : null
  const base = path.basename(file, '.md')

  let sourceName
  let sourceType
  let tags
  if (board) {
    sourceName = board.sourceName
    sourceType = board.sourceType
    tags = [...board.tags]
  } else if (base.startsWith('00-')) {
    sourceName = '食材营养数据知识库（总索引）'
    sourceType = 'article'
    tags = ['营养', '食材', '知识索引']
  } else {
    sourceName = '食材营养数据知识库（跨来源对比）'
    sourceType = 'article'
    tags = ['营养', '食材', '跨来源对比']
  }

  let sourceUrl = ''
  if (isRaw) {
    if (boardKey === '01-usda-fooddata-central' && fm.fdc_id) {
      sourceUrl = `https://fdc.nal.usda.gov/fdc-app.html#/food-details/${fm.fdc_id}/nutrients`
    } else if (boardKey === '03-china-food-composition' && fm.food_id) {
      sourceUrl = `https://nlc.chinanutri.cn/fq/foodinfo/${fm.food_id}.html`
    } else if (fm.source_url) {
      sourceUrl = fm.source_url
    } else if (board) {
      sourceUrl = board.url
    }
  } else if (fm.source_url) {
    sourceUrl = fm.source_url
  }

  return { board, boardKey, sourceName, sourceType, tags, sourceUrl: cut(sourceUrl, 500) }
}

function resolveDocTitle(file, fm, body, isRaw) {
  const base = path.basename(file, '.md')
  const rel = path.relative(ROOT, file).split(path.sep)
  const isBoardDoc = BOARDS[rel[0]] && !rel.includes('raw_extracts')

  if (isRaw && RAW_TITLES[`${rel[0]}/${base}`]) return RAW_TITLES[`${rel[0]}/${base}`]

  const h1 = body.match(/^#\s+(.+)$/m)
  let title = fm.title || fm.name || (h1 ? h1[1].trim() : '')
    || base.replace(/^\d+-/, '').replace(/\.md$/, '')
  title = plainHeading(title)

  if (isBoardDoc && base.startsWith('01-食材营养成分-')) {
    const name = base.replace(/^01-食材营养成分-/, '')
    const suffix = COMPILATION_SUFFIX[base] || name
    return `${title.split(/[：:（(]/)[0].trim()}（${suffix}）`
  }
  return title
}

function shortTitleOf(docTitle, file, isRaw) {
  if (isRaw) return cut(docTitle, 40)
  const base = path.basename(file, '.md')
  const boardKey = path.relative(ROOT, file).split(path.sep)[0]
  if (base === '00-板块说明' && BOARD_SHORT[boardKey]) return BOARD_SHORT[boardKey]
  if (base === '01-跨来源食材营养对比') return '跨来源食材营养对比'
  if (base.startsWith('01-食材营养成分-')) return cut(docTitle, 40)
  return cut((docTitle.split(/[：:（(]/)[0] || docTitle).replace(/\s+/g, ' ').trim() || docTitle, 28)
}

function buildTopics(tags, title, content, h2s) {
  const topics = [...tags]
  const foodHits = FOOD_NAMES.filter((f) => title.includes(f) || content.includes(f))
  if (foodHits.length) {
    topics.push('内脏', ...foodHits)
  }
  for (const h of h2s) topics.push(denum(plainHeading(h)))
  return cut(
    [...new Set(topics)]
      .map((t) => t.trim())
      .filter((t) => t.length >= 2 && t.length <= 20)
      .join(','),
    200,
  )
}

let files = collectFiles()
const rows = []
const usedTitles = new Set()
const stats = new Map()

for (const file of files) {
  const raw = fs.readFileSync(file, 'utf8').replace(/\r\n?/g, '\n')
  const { fm, body: fmBody } = parseFrontMatter(raw)
  const isRaw = path.relative(ROOT, file).split(path.sep).includes('raw_extracts')
  const meta = resolveFileMeta(file, fm, isRaw)
  const docTitle = resolveDocTitle(file, fm, fmBody, isRaw)
  const shortDoc = shortTitleOf(docTitle, file, isRaw)
  const body = stripMetaSections(fmBody)
  const h2s = [...body.matchAll(/^##\s+(.+)$/gm)]
    .map((m) => m[1].trim())
    .slice(0, 3)
  const sourceName = cut(meta.sourceName, 200)

  const sections = body.split(/\n(?=#{2,3} )/).map((s) => {
    const head = s.match(/^(#{2,3})\s*(.+)$/m)
    return {
      level: head ? head[1].length : 0,
      heading: head ? denum(plainHeading(head[2])) : '',
      text: cleanSection(s),
    }
  }).filter((s) => s.text)

  // USDA 的 H1 段只剩英文标题、没有正文；有后续小节时丢掉
  if (isRaw && sections.length > 1 && !sections[0].text.includes('\n') && sections[0].text.length < 200) {
    sections.shift()
  }

  let buf = ''
  let bufHeading = ''
  let bufLevel = 0
  let bufStarted = false
  let part = 0
  const rawFallback = meta.boardKey === '04-fao-infoods' ? '来源记录' : '每 100 g 营养数据'
  const push = (text, heading, level) => {
    for (const piece of splitOversized(text)) {
      let h
      if (isRaw) {
        h = HEADING_ZH[heading] || heading || rawFallback
      } else {
        h = heading || (level >= 2 ? headingOf(piece, '') : '')
        const dup = h === shortDoc || (h.length > 8 && (shortDoc.includes(h) || h.includes(shortDoc)))
        if (!h || dup) h = `第 ${++part} 段`
      }
      h = cut(h, 40)
      let title = cut(`${shortDoc} · ${h}`.replace(/\s+/g, ' '), 200)
      let n = 2
      while (usedTitles.has(title)) title = cut(`${shortDoc} · ${h} (${n++})`, 200)
      usedTitles.add(title)

      rows.push({
        title,
        content: piece,
        species: inferSpecies(piece),
        life_stage: inferLifeStage(piece),
        topics: buildTopics(meta.tags, title, piece, h2s),
        severity: CAUTION_RE.test(piece) ? 'caution' : 'informational',
        source_name: sourceName,
        source_type: meta.sourceType,
        source_url: meta.sourceUrl,
      })
    }
  }

  for (const sec of sections) {
    const cleaned = sec.text
    if (buf && buf.length + cleaned.length + 2 > MAX_CHUNK) {
      push(buf, bufHeading, bufLevel)
      buf = ''
      bufHeading = ''
      bufLevel = 0
      bufStarted = false
    }
    if (cleaned.length > MAX_CHUNK) {
      const heading = isRaw ? (sec.level >= 2 ? sec.heading : '') : sec.heading
      push(cleaned, heading, sec.level)
      continue
    }
    buf += (buf ? '\n\n' : '') + cleaned
    if (!bufStarted) {
      bufHeading = isRaw ? (sec.level >= 2 ? sec.heading : '') : sec.heading
      bufLevel = sec.level
      bufStarted = true
    }
  }
  if (buf.trim()) push(buf, bufHeading, bufLevel)

  const topic = meta.tags[0] || '营养'
  const rec = stats.get(topic) || { files: 0, rows: 0, chars: 0 }
  rec.files++
  stats.set(topic, rec)
}

for (const r of rows) {
  const rec = stats.get(r.topics.split(',')[0])
  if (rec) { rec.rows++; rec.chars += r.content.length }
}

const COLS = '(title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status)'
const out = []
out.push('-- ============================================================')
out.push('-- FurGuardian 知识库语料扩充：食材营养数据（猪肝 / 猪心 / 鸡肝 / 鸡心 / 牛肝 / 牛心）')
out.push(`-- 由 sql/build-food-nutrition-seed.mjs 生成，语料根目录 ${ROOT}`)
out.push(`-- 共 ${files.length} 篇 → ${rows.length} 条，按 ## / ### 标题切分；小节合并到 ${MAX_CHUNK} 字，超长表格硬切至 ≤ ${HARD_SPLIT} 字`)
out.push(`-- 生成时间 ${new Date().toISOString().slice(0, 10)}`)
out.push('-- 幂等：先按本批 title 精确 DELETE，可反复执行')
out.push('-- 收录：总索引、跨来源对比、10 份板块说明、3 份食材成分中文稿、USDA/日本八订/中国成分表/INFOODS 逐食材抽取')
out.push('-- 不入库：PDF、data 原始文件、_cache、FEDIAF/NRC/WSAVA 英文全文抽取')
out.push('-- 来源差异大，同一食材的不同来源各自成条，不取平均值')
out.push('-- 入库后由 KnowledgeEmbeddingJob（每日 03:00）处理 embedding_id IS NULL 的条目')
out.push('-- ============================================================')
out.push('')
out.push('SET NAMES utf8mb4;')
out.push('')
out.push('USE fur_guardian;')
out.push('')
out.push('-- 幂等删除（仅本批生成的标题，不影响原有 80 条种子）')
const titles = rows.map((r) => r.title)
for (let i = 0; i < titles.length; i += 200) {
  out.push(`DELETE FROM knowledge_docs WHERE title IN (${titles.slice(i, i + 200).map((t) => q(t)).join(', ')});`)
}
out.push('')
for (let i = 0; i < rows.length; i += 40) {
  out.push(`INSERT INTO knowledge_docs ${COLS} VALUES`)
  const vals = rows.slice(i, i + 40).map((r) => `(${[
    q(r.title), q(r.content), q(r.species), q(r.life_stage), q(''), q(r.topics),
    q(r.severity), q(r.source_name), q(r.source_type), q(r.source_url), q('approved'),
  ].join(', ')})`)
  out.push(vals.join(',\n') + ';')
  out.push('')
}

process.stdout.write(out.join('\n'))

process.stderr.write(`\n文件 ${files.length} 篇 → 条目 ${rows.length} 条\n`)
process.stderr.write('主题分布:\n')
for (const [k, v] of [...stats.entries()].sort((a, b) => b[1].rows - a[1].rows)) {
  process.stderr.write(`  ${k.padEnd(8)} 文件${String(v.files).padStart(3)}  条目${String(v.rows).padStart(4)}  字数${String(v.chars).padStart(8)}\n`)
}
const lens = rows.map((r) => r.content.length).sort((a, b) => a - b)
process.stderr.write(`正文长度 中位${lens[Math.floor(lens.length / 2)]} / 最长${lens[lens.length - 1]}\n`)
const sp = {}
for (const r of rows) sp[r.species || '(通用)'] = (sp[r.species || '(通用)'] || 0) + 1
process.stderr.write(`species: ${JSON.stringify(sp)}\n`)
const sv = {}
for (const r of rows) sv[r.severity] = (sv[r.severity] || 0) + 1
process.stderr.write(`severity: ${JSON.stringify(sv)}\n`)
const src = {}
for (const r of rows) src[r.source_name] = (src[r.source_name] || 0) + 1
process.stderr.write('source_name:\n')
for (const [k, v] of Object.entries(src).sort((a, b) => b[1] - a[1])) {
  process.stderr.write(`  ${String(v).padStart(4)}  ${k}\n`)
}
