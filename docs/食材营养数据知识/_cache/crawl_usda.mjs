import fs from 'node:fs/promises';
import path from 'node:path';

const ROOT = path.resolve(import.meta.dirname, '..');
const OUT = path.join(ROOT, '01-usda-fooddata-central');
const DATA = path.join(OUT, 'data');
const RAW = path.join(OUT, 'raw_extracts');
const API = 'https://api.nal.usda.gov/fdc/v1';
const KEY = 'DEMO_KEY';
const QUERIED_AT = '2026-10-20';

const FOODS = [
  { slug: 'pork-liver-raw', query: 'pork liver raw', match: /^pork, fresh, variety meats and by-products, liver, raw$/i },
  { slug: 'chicken-liver-raw', query: 'chicken liver raw', match: /^chicken, liver, all classes, raw$/i },
  { slug: 'chicken-heart-raw', query: 'chicken heart raw', match: /^chicken, heart, all classes, raw$/i },
  { slug: 'pork-heart-raw', query: 'pork heart raw', match: /^pork, fresh, variety meats and by-products, heart, raw$/i },
  { slug: 'beef-liver-raw', query: 'beef liver raw', match: /^beef, variety meats and by-products, liver, raw$/i },
  { slug: 'beef-heart-raw', query: 'beef heart raw', match: /^beef, variety meats and by-products, heart, raw$/i },
];

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function getJson(url, tries = 3) {
  for (let i = 1; i <= tries; i++) {
    const res = await fetch(url, { headers: { 'User-Agent': 'FurGuardian-Research/1.0 (internal RAG corpus)' } });
    if (!res.ok) {
      if (i === tries) throw new Error(`${res.status} ${res.statusText}: ${url}`);
      await sleep(3000 * i);
      continue;
    }
    return res.json();
  }
}

const clean = (s) => s.replace(/[^a-zA-Z0-9]+/g, '-').replace(/^-|-$/g, '').toLowerCase();

for (const item of FOODS) {
  const searchUrl = `${API}/foods/search?query=${encodeURIComponent(item.query)}&dataType=SR%20Legacy&pageSize=20&api_key=${KEY}`;
  const search = await getJson(searchUrl);
  const hit = search.foods.find((f) => item.match.test(f.description)) || search.foods[0];
  if (!hit) throw new Error(`No result for ${item.query}`);
  await fs.writeFile(path.join(DATA, `search-${item.slug}.json`), JSON.stringify(search, null, 2));

  const detail = await getJson(`${API}/food/${hit.fdcId}?api_key=${KEY}`);
  await fs.writeFile(path.join(DATA, `food-${hit.fdcId}-${item.slug}.json`), JSON.stringify(detail, null, 2));

  const rows = detail.foodNutrients
    .filter((n) => n.amount != null)
    .map((n) => ({
      id: n.nutrient.id,
      number: n.nutrient.number,
      name: n.nutrient.name,
      unit: n.nutrient.unitName,
      amount: n.amount,
    }))
    .sort((a, b) => a.id - b.id);

  const frontmatter = [
    '---',
    'kb: "food-nutrition-data"',
    'type: "raw_extract"',
    'source: "USDA FoodData Central"',
    `fdc_id: ${detail.fdcId}`,
    `description: "${detail.description.replaceAll('"', '\\"')}"`,
    `data_type: "${detail.dataType}"`,
    `publication_date: "${detail.publicationDate ?? ''}"`,
    `queried_at: "${QUERIED_AT}"`,
    'language: "en"',
    '---',
    '',
    `# ${detail.description}`,
    '',
    `> 来源: <https://fdc.nal.usda.gov/fdc-app.html#/food-details/${detail.fdcId}/nutrients>　|　FDC ID: ${detail.fdcId}　|　数据类型: ${detail.dataType}　|　查询日期: ${QUERIED_AT}`,
    '',
    '## Nutrients (per 100 g)',
    '',
    '| Nutrient ID | Nutrient | Amount | Unit |',
    '| --- | --- | --- | --- |',
    ...rows.map((r) => `| ${r.id} | ${r.name} | ${r.amount} | ${r.unit} |`),
    '',
    '## Food Portions',
    '',
    ...(detail.foodPortions ?? []).map(
      (p) => `- ${p.portionDescription || p.measureUnit?.name || 'portion'} (${p.gramWeight} g)`,
    ),
    '',
  ];
  await fs.writeFile(path.join(RAW, `${item.slug}.md`), frontmatter.join('\n'));

  const pick = (id) => rows.find((r) => r.id === id)?.amount;
  console.log(
    JSON.stringify({
      slug: item.slug,
      fdcId: detail.fdcId,
      description: detail.description,
      kcal: pick(1008),
      protein_g: pick(1003),
      fat_g: pick(1004),
      vitaminA_rae_ug: pick(1106),
      copper_mg: pick(1098),
      iron_mg: pick(1089),
      taurine_mg: pick(1051),
      nutrients: rows.length,
    }),
  );
  await sleep(1200);
}
