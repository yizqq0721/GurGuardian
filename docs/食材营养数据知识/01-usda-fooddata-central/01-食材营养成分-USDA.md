# 猪肝、鸡心等食材营养成分（USDA FoodData Central）

> 抓取日期：2026-10-20
> 来源：USDA FoodData Central（SR Legacy 数据）
> 计量基准：每 100 g **生重、可食部**
> 说明：本文件为中文整理稿，完整营养项目见 `raw_extracts/` 下各食材的原文抽取；原始 API 返回见 `data/`。

## 1. 四种目标食材关键数值

| 食材 | FDC ID | 热量 kcal | 蛋白质 g | 脂肪 g | 钙 mg | 磷 mg | 铁 mg | 锌 mg | 铜 mg | 维生素 A µg RAE | 维生素 A IU | 牛磺酸 mg | 胆固醇 mg | 维生素 B12 µg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | 167862 | 134 | 21.39 | 3.65 | 9 | 288 | 23.3 | 5.76 | 0.677 | 6502 | 21650 | 71.06 | 301 | 26 |
| 猪心（生） | 168267 | 118 | 17.27 | 4.36 | 5 | 169 | 4.68 | 2.80 | 0.408 | 8 | 25 | 76.21 | 131 | 3.79 |
| 鸡肝（生） | 171060 | 119 | 16.92 | 4.83 | 8 | 297 | 8.99 | 2.67 | 0.492 | 3296 | 11078 | 76.46 | 345 | 16.58 |
| 鸡心（生） | 171458 | 153 | 15.55 | 9.33 | 12 | 177 | 5.96 | 6.59 | 0.346 | 9 | 30 | 73.56 | 136 | 7.29 |

## 2. 其他已记录项目

| 食材 | 碳水 g | 钠 mg | 钾 mg | 镁 mg | 维生素 E mg | 硫胺素 mg | 核黄素 mg | 烟酸 mg | 维生素 B6 mg | 维生素 C mg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | 2.47 | 87 | 273 | 18 | — | 0.283 | 3.005 | 15.301 | 6.65 | 25.3 |
| 猪心（生） | 1.33 | 56 | 294 | 19 | 0.63 | 0.613 | 1.185 | 6.765 | 2.515 | 5.3 |
| 鸡肝（生） | 0.73 | 71 | 230 | 19 | 0.70 | 0.305 | 1.778 | 9.728 | 6.233 | 17.9 |
| 鸡心（生） | 0.71 | 74 | 176 | 15 | — | 0.152 | 0.728 | 4.883 | 2.559 | 3.2 |

> “—”表示该食材的 USDA 记录中未列出该项目，不等于含量为零。

## 3. 数据说明

1. 四条记录均来自 USDA FoodData Central 的 **SR Legacy** 数据集，英文描述分别为：
   - Pork, fresh, variety meats and by-products, liver, raw
   - Pork, fresh, variety meats and by-products, heart, raw
   - Chicken, liver, all classes, raw
   - Chicken, heart, all classes, raw
2. 查询通过 FDC 官方 API 完成：`https://api.nal.usda.gov/fdc/v1/foods/search` 与 `https://api.nal.usda.gov/fdc/v1/food/{fdcId}`。
3. 原始 API JSON 保存在 `data/`，逐项营养表保存在 `raw_extracts/`，每条都带 FDC ID 与查询日期，便于复核。
4. USDA 的“raw”对应生重；未给出“可食部”百分比时，按 100 g 可食部计。
5. 牛肝、牛心为附加条目，因 USDA API 的 DEMO_KEY 触发限流，本次未完成详情抓取；如后续需要，可用正式 API Key 补齐。日本八订中已包含牛肝、牛心数据，见 `02-japan-mext-food-composition/`。
6. USDA 数据为美国常见品种与检测批次，不能直接等同于中国市售猪肝、鸡心的精确值；用于 RAG 时应同时标注来源与数值差异。

## 4. 原文文件

| 食材 | 原文抽取 | 原始 JSON |
| --- | --- | --- |
| 猪肝（生） | [pork-liver-raw.md](raw_extracts/pork-liver-raw.md) | `data/food-167862-pork-liver-raw.json` |
| 猪心（生） | [pork-heart-raw.md](raw_extracts/pork-heart-raw.md) | `data/food-168267-pork-heart-raw.json` |
| 鸡肝（生） | [chicken-liver-raw.md](raw_extracts/chicken-liver-raw.md) | `data/food-171060-chicken-liver-raw.json` |
| 鸡心（生） | [chicken-heart-raw.md](raw_extracts/chicken-heart-raw.md) | `data/food-171458-chicken-heart-raw.json` |

## 5. 版权与使用

USDA FoodData Central 数据为美国政府公开数据，可用于研究与开发；引用时保留 FDC ID、数据来源与查询日期。本文件中的中文译名为整理时添加，不是 USDA 官方中文名。
