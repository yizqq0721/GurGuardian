# 抓取报告

- 抓取日期：2026-10-20
- 目标：补录猪肝、鸡心、猪心、鸡肝等具体食材每 100 g 营养数值，整理为后续 RAG 语料
- 输出目录：`docs/食材营养数据知识/`
- 结构参照：`docs/wsava全球指南知识/`
- 结果：10 个板块、96 个文件（其中 45 份 Markdown）、约 37 MB；29 份原文抽取（约 620,000 字节）；11 份 PDF

## 1. 分来源结果

| 来源 | 入口 | 结果 | 文件 |
| --- | --- | --- | --- |
| USDA FoodData Central | `api.nal.usda.gov/fdc/v1`，SR Legacy | 4 条完整详情（猪肝 167862、猪心 168267、鸡肝 171060、鸡心 171458）；牛肝、牛心因 429 限流未完成 | `01-usda-fooddata-central/data/*.json`、`raw_extracts/*.md` |
| 日本食品標準成分表（八訂）増補2023年 | mext.go.jp 官方下载页 | 下载 Excel 1,973,402 字节、PDF 2,273,280 字节；提取 6 条（含牛肝、牛心） | `02-japan-mext-food-composition/` |
| 中国食物成分表（第6版）在线平台 | `nlc.chinanutri.cn/fq/` | 抓取猪、鸡分类列表；提取猪肝 797、猪心 802、鸡肝 884、鸡心 885、猪肝卤煮 809 | `03-china-food-composition/` |
| FAO/INFOODS | `fao.org/food-composition/tables-and-databases/en` | 遍历 11 页，保存 220 条目录链接；中国 2018/2019、日本 2023 三条详情 | `04-fao-infoods/` |
| FEDIAF | europeanpetfood.org | 下载 2025 年 9 月版 PDF（2,282,715 字节），全文抽取 394,460 字节 | `05-fediaf-nutritional-guidelines/` |
| WSAVA Global Nutrition | wsava.org | 下载 7 份核心 PDF；全部完成文本抽取 | `06-wsava-global-nutrition/` |
| NRC | nap.nationalacademies.org | 下载官方免费犬猫手册 2 份 PDF；完整 2006 报告未下载（付费/在线阅读） | `07-nrc-nutrient-requirements/` |
| AAFCO | aafco.org | 首页动态加载，仅保存 4,780 字节不完整快照；未取得 nutrient profiles | `08-aafco/data/aafco-home.html` |
| GB/T 31216/31217 | openstd.samr.gov.cn | 取得 2 项标准元数据与详情页；全文需在线预览，未取得 PDF | `09-gb-pet-food-standards/` |
| ECVCN / Balance IT | ecvcn.org、balanceit.com | 保存首页快照；无公开可批量下载的食材数据 | `10-ecvcn-balanceit/` |

## 2. 需要人工处理 / 已知告警

1. **USDA 429 限流**：牛肝详情未取到，牛心未开始；牛肝仅保留 `search-beef-liver-raw.json`。日本八订已提供牛肝、牛心替代数据。如需 USDA 版本，申请正式 FDC API Key 后重跑 `_cache/crawl_usda.mjs`。
2. **日本站点限速**：首次 Excel 下载不完整（618,866 / 1,973,402 字节，zip 校验失败），已用断点续传补齐并通过 zip 完整性检查；PDF 下载耗时约 8 分钟。日志见 `_cache/japan-download.log`。
3. **WSAVA 零食指南下载超时告警**：`WSAVA_GuidetoTreats_Cats_251107.pdf` 下载过程中出现超时提示，但最终文件为 5,623,751 字节且 `pdftotext` 成功抽取；建议人工打开末页确认。`Implementing` 与两份零食指南以图片为主，文本仅 4–8 KB，检索时优先人工整理或 PDF 阅读。
4. **AAFCO**：官网正文由脚本加载，抓取到的 HTML 不完整；nutrient profiles 在付费 Official Publication 中，本目录未入库正文。
5. **GB/T 标准**：详情页提供“在线预览 / 下载标准”，但预览依赖浏览器专用组件，本次未取得标准 PDF；目录仅保存元数据与页面快照。
6. **中国平台字段缺口**：未列钙、牛磺酸；维生素 A 未细分 RAE 与视黄醇，跨来源比较时按 µg 量级参考。
7. **日本八订牛磺酸**：本表未列；牛磺酸仅 USDA 提供，不能把“未列出”当零。

## 3. 完整性检查

- 日本 Excel：`zipfile.testzip()` 返回 `None`；工作表 `11肉類` 已解析，6 条目标行齐全。
- 中国详情页：每条解析出 27 个项目，含能量、蛋白质、脂肪、胆固醇、维生素、矿物质与脂肪酸构成。
- USDA：4 条详情分别包含 75 / 113 / 69 / 86 个营养项目；每条 JSON 均带 FDC ID 与查询日期。
- Markdown 原文抽取：29 份，均带 YAML frontmatter；FEDIAF 全文 394,460 字节，WSAVA 指南 47,924 字节，NRC 犬/猫手册 38,409 / 44,471 字节。
- PDF：11 份，均可被 `pdftotext` 打开；日本八订 PDF 作为存档，正文以 Excel 为准，未做 OCR。
- 未修改 `docs/food-nutrition-data-sources.md` 与 `docs/数据来源参考.md`。

## 4. 抓取过程产物（不要入库）

- `_cache/crawl_usda.mjs`：USDA API 抓取脚本
- `_cache/japan-download.log`：日本站点下载日志
- 各板块 `data/` 下的 HTML/JSON/Excel：用于溯源与复核，不作为 RAG 文本直接入库

## 5. 建议的下一步

1. 人工复核三来源数值，重点确认维生素 A 单位（µg vs µg RAE）与生熟口径。
2. 按 `docs/food-nutrition-data-sources.md` §3 的格式写入 `knowledge_docs`，每条食材单独一条，来源差异写入正文。
3. 重新生成向量索引，验证“猪肝”“鸡心”“牛磺酸”“维生素 A 中毒”等查询能否命中。
4. 如需 AAFCO/GB/NRC 具体阈值，取得官方现行版并注明章节后再入库。
