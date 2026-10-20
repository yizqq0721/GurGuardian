# 食材营养数据来源（猪肝 / 鸡心 / 猪心等）

> 本文档说明当前知识库在“具体食材营养成分”上的缺口，并列出可自行补录数据的权威网站。
> 生成日期：2026-10-20

## 1. 当前知识库的实际情况

检索 `sql/knowledge_seed.sql`、`sql/knowledge_seed_wsava.sql` 后确认：

- 现有内容只有泛化描述，例如“动物心脏、肝脏富含牛磺酸”“长期大量喂食动物肝脏有维生素 A 中毒风险”。
- **没有**猪肝、鸡心、猪心、鸡肝等具体食材的每 100 g 热量、蛋白质、脂肪、维生素 A、铜、铁、牛磺酸等数值。
- 也没有这些食材在犬猫日粮中的建议占比或喂食频率。

因此 AI 每日食谱会遵守提示词约束：**知识库未覆盖的食材不编造营养数据或剂量**。在补录数据之前，食谱只会给出“少量、煮熟、不调味、注意肝脏维生素 A 风险”这类保守建议，而不会给出精确克数。

## 2. 推荐数据源

### 2.1 食材成分数值（每 100 g）

| 来源 | 网址 | 适用内容 | 说明 |
| --- | --- | --- | --- |
| USDA FoodData Central | https://fdc.nal.usda.gov/ | 猪肝、鸡心、猪心、鸡肝等生鲜食材的热量、蛋白质、脂肪、矿物质、维生素 | 美国农业部官方数据库，可导出 CSV/JSON；搜索 `pork liver raw`、`chicken heart raw`、`pork heart raw` |
| 中国食物成分表（第 6 版） | https://www.chinanutri.cn/ | 中式常见食材与内脏的营养成分 | 中国疾控中心营养与健康所；优先用中文食物名核对，注意“可食部”和烹调方式 |
| 日本食品标准成分表（八订） | https://fooddb.mext.go.jp/ | 猪肝、鸡心、鸡肝等亚洲常见食材 | 日本文部科学省官方数据库，可补充 USDA 未覆盖的品种 |
| FAO/INFOODS | https://www.fao.org/infoods/infoods/en/ | 各国食物成分数据库索引 | 用于查找其他国家的官方成分表 |

采集时至少记录：**热量 kcal、粗蛋白 g、粗脂肪 g、钙 mg、磷 mg、铁 mg、锌 mg、铜 mg、维生素 A IU/µg、牛磺酸 mg**（若来源提供），并注明是生重还是熟重。

### 2.2 犬猫营养需求与安全上限

| 来源 | 网址 | 适用内容 |
| --- | --- | --- |
| NRC《Nutrient Requirements of Dogs and Cats》(2006) | https://nap.nationalacademies.org/catalog/10668/nutrient-requirements-of-dogs-and-cats | 犬猫各生命阶段营养需要量、推荐摄入量与安全上限 |
| AAFCO | https://www.aafco.org/ | 美国犬猫粮营养 profiles，可用于对照全价粮最低/最高值 |
| FEDIAF Nutritional Guidelines | https://europeanpetfood.org/self-regulation/nutritional-guidelines/ | 欧洲犬猫全价/补充食品营养标准 |
| WSAVA Global Nutrition Guidelines | https://wsava.org/global-guidelines/global-nutrition-guidelines/ | 犬猫营养评估、体况评分、零食与家庭自制粮的临床建议 |
| Merck Veterinary Manual | https://www.merckvetmanual.com/ | 营养素缺乏/过量、肝脏与心脏疾病相关饮食管理 |
| GB/T 31216-2014《全价宠物食品 犬粮》 | https://openstd.samr.gov.cn/bzgk/gb/ | 中国犬粮国标（在“国家标准全文公开系统”检索标准号） |
| GB/T 31217-2014《全价宠物食品 猫粮》 | https://openstd.samr.gov.cn/bzgk/gb/ | 中国猫粮国标（同上） |
| ECVCN（欧洲兽医与比较营养学院） | https://www.ecvcn.org/ | 欧洲认证营养专科资料与转诊信息 |
| Balance IT（UC Davis 团队） | https://balanceit.com/ | 自制犬猫食谱配比与营养完整性校验（需兽医参与） |

### 2.3 器官肉喂食安全（补录知识库时的依据）

- 肝脏：维生素 A 与铜含量高，长期大量喂食存在中毒风险；NRC 与 Merck Veterinary Manual 均有上限与中毒描述。
- 心脏：蛋白质与牛磺酸来源之一，但仍需计入每日总热量，不能替代全价主粮。
- 内脏总体建议：作为少量加餐，占每日热量的小比例；必须煮熟、不调味、去骨，生食存在细菌与寄生虫风险。
- 猫的牛磺酸需求参见现有知识条目“牛磺酸对猫的必要性”“猫必须从食物获取牛磺酸”。

## 3. 建议补录到 `knowledge_docs` 的格式

表结构见 `sql/schema.sql` 中的 `knowledge_docs`。建议每条食材单独一条，示例：

```sql
INSERT INTO knowledge_docs
(title, content, species, life_stage, breed_tags, topics, severity,
 source_name, source_type, source_url, review_status)
VALUES
('猪肝（生）营养成分与喂食注意',
 '每100g生猪肝约含：热量…kcal、蛋白质…g、脂肪…g、维生素A…、铜…mg、铁…mg。来源：USDA FoodData Central（编号…，查询日期…）。犬猫可作为少量加餐，必须煮熟、不调味；因维生素A和铜含量高，不建议每日或大量喂食。',
 'both', 'adult,young,senior', '', '营养,食材,猪肝,内脏,维生素A', 'caution',
 'USDA FoodData Central', 'article', 'https://fdc.nal.usda.gov/', 'approved');
```

注意事项：

1. `species` 用 `dog` / `cat` / `both`，与现有检索过滤一致。
2. `topics` 至少包含 `营养,食材,内脏`，并加入食材名，便于向量检索命中。
3. `source_url` 填具体食材页面或数据库查询页，不要只填首页。
4. 数值必须注明**生重/熟重**与**可食部**；不同来源差异大时，在正文中说明取数依据。
5. 补录后需要重新生成向量索引入库（参考 `df4710f` 提交中的定时入库任务与知识库管理流程），否则检索仍然不会命中新条目。

## 4. 与 AI 食谱的关系

`NutritionRecipeService` 的提示词明确要求：知识库未覆盖的食材不得编造营养成分、热量或剂量。补录上述数据后，AI 才能在“可以补充的食材”小节中给出有依据的建议；主粮克数、餐次与零食额度始终来自 `NutritionCalculator` 的确定性计算，不受知识库影响。
