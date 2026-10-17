-- ============================================================
-- FurGuardian 知识库语料种子数据
-- 共80条: 营养30 + 日常护理20 + 症状红线20 + 季节行为10
-- 来源: 国标、WSAVA、NRC、Merck兽医手册等权威资料
-- 禁止AI生成，所有条目须可溯源
-- ============================================================

USE fur_guardian;

-- ========================
-- 一、营养类 (30条)
-- ========================

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('成犬粗蛋白最低要求', '根据GB/T 31216-2014《全价宠物食品 犬粮》，成犬粮粗蛋白（干物质基准）最低含量为18%。低于此值可能导致蛋白质缺乏，表现为毛发粗糙、免疫力下降。建议成犬粮粗蛋白选择在22%-30%之间，以保证充足的氨基酸供应。', 'dog', 'adult', '', '营养,蛋白质', 'informational', 'GB/T 31216-2014 全价宠物食品 犬粮', 'standard', '', 'approved'),

('幼犬蛋白质需求高于成犬', '幼犬处于快速生长期，对蛋白质的需求显著高于成犬。根据国标GB/T 31216-2014，幼犬粮粗蛋白（干物质基准）最低含量为22%，实际推荐量在26%-32%。优质蛋白质来源包括鸡肉、鱼肉、鸡蛋等动物性蛋白，其氨基酸组成更接近犬猫需求。', 'dog', 'young', '', '营养,蛋白质,幼犬', 'informational', 'GB/T 31216-2014 全价宠物食品 犬粮', 'standard', '', 'approved'),

('成猫粗蛋白最低要求', '根据GB/T 31217-2014《全价宠物食品 猫粮》，成猫粮粗蛋白（干物质基准）最低含量为25%，高于犬粮标准。猫是严格肉食动物，对蛋白质需求天生较高。建议选择粗蛋白在30%-40%之间的猫粮，以满足其生理需求。', 'cat', 'adult', '', '营养,蛋白质', 'informational', 'GB/T 31217-2014 全价宠物食品 猫粮', 'standard', '', 'approved'),

('猫是严格肉食动物', '猫（Felis catus）是严格的肉食动物（obligate carnivore），其消化系统、代谢途径和营养需求均适应以动物性组织为主的饮食。猫对动物蛋白的依赖程度高于犬，必需营养素如牛磺酸、花生四烯酸、维生素A等只能从动物性来源获取或体内合成量不足。', 'cat', 'adult,young,senior', '', '营养,肉食动物', 'informational', 'NRC. Nutrient Requirements of Dogs and Cats. 2006', 'book', '', 'approved'),

('牛磺酸对猫的必要性', '牛磺酸是猫的必需氨基酸，猫体内合成量不足以满足需求，必须从食物中获取。缺乏牛磺酸可导致扩张型心肌病（DCM）、视网膜退化和繁殖障碍。国标要求猫粮牛磺酸含量≥0.1%（干粮干物质基准）或≥0.2%（湿粮）。动物心脏、肝脏含量丰富。', 'cat', 'adult,young,senior', '', '营养,牛磺酸,心脏', 'caution', 'GB/T 31217-2014; NRC 2006', 'standard', '', 'approved'),

('犬钙磷比推荐范围', '犬粮的钙磷比（Ca:P）推荐范围为1.0:1至2.0:1，最佳约1.2:1至1.4:1。钙磷比过高或过低都会影响骨骼发育，尤其是大型犬幼犬。国标要求钙最低含量成犬0.5%、幼犬1.0%（干物质基准），磷对应成犬0.4%、幼犬0.8%。', 'dog', 'adult,young', '', '营养,钙磷比,矿物质', 'informational', 'GB/T 31216-2014; NRC 2006', 'standard', '', 'approved'),

('猫钙磷比要求', '猫粮的钙磷比推荐范围为1.0:1至1.5:1。国标GB/T 31217-2014要求成猫粮钙≥0.6%、磷≥0.5%（干物质基准），幼猫粮钙≥0.8%、磷≥0.6%。过高的钙摄入可能与猫泌尿系统疾病有关，需保持适当平衡。', 'cat', 'adult,young', '', '营养,钙磷比,矿物质', 'informational', 'GB/T 31217-2014; NRC 2006', 'standard', '', 'approved'),

('犬粮脂肪最低要求', '根据国标GB/T 31216-2014，成犬粮粗脂肪（干物质基准）最低含量为5%，幼犬粮为8%。脂肪提供必需脂肪酸（亚油酸、α-亚麻酸）和脂溶性维生素。但过高脂肪摄入会导致肥胖，肥胖倾向宠物应选择脂肪含量适中（10%-15%）的粮食。', 'dog', 'adult,young', '', '营养,脂肪', 'informational', 'GB/T 31216-2014 全价宠物食品 犬粮', 'standard', '', 'approved'),

('猫粮脂肪最低要求', '根据国标GB/T 31217-2014，成猫粮粗脂肪（干物质基准）最低含量为9%，幼猫粮为9%。猫对脂肪的利用率高，脂肪也是重要的能量来源。但绝育后活动量下降的猫需注意控制脂肪摄入，防止肥胖。建议选择脂肪含量12%-18%的猫粮。', 'cat', 'adult,young', '', '营养,脂肪', 'informational', 'GB/T 31217-2014 全价宠物食品 猫粮', 'standard', '', 'approved'),

('犬粮粗纤维上限', '国标GB/T 31216-2014规定成犬粮粗纤维（干物质基准）最大含量为9%。适量纤维有助于肠道蠕动，但过高会降低食物消化率和适口性。功能性纤维（如甜菜粕、洋车前子壳）在推荐用量下可改善粪便质量。', 'dog', 'adult', '', '营养,纤维', 'informational', 'GB/T 31216-2014 全价宠物食品 犬粮', 'standard', '', 'approved'),

('DHA对幼犬大脑发育的作用', 'DHA（二十二碳六烯酸）是一种Omega-3长链多不饱和脂肪酸，对幼犬大脑和视网膜发育有重要作用。研究表明，含有DHA的日粮可提高幼犬的学习能力和视觉功能。母乳和鱼油是DHA的天然来源。建议选择标注含DHA的幼犬粮。', 'dog', 'young', '', '营养,DHA,Omega-3,幼犬', 'informational', 'NRC 2006; WSAVA Global Nutrition Guidelines', 'guideline', '', 'approved'),

('干物质基准换算方法', '不同含水量的食品无法直接比较营养成分。干物质基准（DM）换算公式：DM% = 实际含量 ÷ (1 - 水分%)。例如：湿粮标注粗蛋白10%、水分78%，则DM基准粗蛋白 = 10% ÷ (1-0.78) = 45.5%。干粮标注粗蛋白30%、水分10%，则DM基准 = 30% ÷ (1-0.10) = 33.3%。换算后湿粮蛋白反而更高。', 'dog,cat', 'adult,young,senior', '', '营养,干物质换算', 'informational', 'WSAVA Global Nutrition Guidelines', 'guideline', '', 'approved'),

('修正Atwater公式估算热量', '当食品包装未标注热量时，可用修正Atwater公式估算：kcal/g = 蛋白质(g)×3.5 + 脂肪(g)×8.5 + 碳水化合物(g)×3.5。此公式使用修正系数（蛋白3.5而非4.0、碳水3.5而非4.0），因宠物对蛋白和碳水的消化率略低于人类。注意标注为"估算值"。', 'dog,cat', 'adult,young,senior', '', '营养,热量计算', 'informational', 'NRC 2006; AAFCO', 'standard', '', 'approved'),

('零食10%热量上限原则', '零食提供的热量不应超过宠物每日总能量摄入的10%。超出此比例可能导致营养不均衡，因为零食通常不具备主粮的营养完整性。计算方法：先算出宠物每日MER（维持能量需求），零食热量≤MER×10%。例如MER=500kcal的犬，零食上限为50kcal/天。', 'dog,cat', 'adult,young,senior', '', '营养,零食,热量', 'caution', 'WSAVA Global Nutrition Guidelines', 'guideline', '', 'approved'),

('维生素D在宠物营养中的作用', '维生素D促进钙磷吸收，维持骨骼健康。犬可在皮肤中合成少量维生素D3，但仍需从食物中获取大部分。猫几乎不能通过阳光合成维生素D，完全依赖食物来源。国标要求犬粮维生素D≥500IU/kg（成犬），猫粮≥900IU/kg。过量可导致中毒。', 'dog,cat', 'adult,young', '', '营养,维生素D', 'informational', 'NRC 2006; GB/T 31216-2014', 'standard', '', 'approved'),

('猫必须从食物获取牛磺酸', '与犬不同，猫体内合成牛磺酸的能力极为有限。猫肝脏中半胱氨酸亚硫酸羧酶活性低，无法将半胱氨酸充分转化为牛磺酸。此外，猫结合胆汁酸使用牛磺酸（而非甘氨酸），导致每日牛磺酸损失较大。因此猫粮必须额外添加牛磺酸，最低含量0.1%（干物质基准）。', 'cat', 'adult,young,senior', '', '营养,牛磺酸', 'informational', 'NRC 2006', 'book', '', 'approved'),

('大型犬幼犬生长速度控制', '大型犬（成年体重>25kg）幼犬期生长速度过快会增加骨关节疾病风险，特别是髋关节发育不良和骨软骨病。建议：1）大型犬幼犬粮能量密度适中（360-410kcal/100g）；2）钙含量控制在0.8%-1.6%（干物质基准）；3）保持适度生长速度，不要追求"胖"。', 'dog', 'young', '大型犬', '营养,大型犬,幼犬,骨骼', 'caution', 'NRC 2006; WSAVA Nutrition Toolkit', 'guideline', '', 'approved'),

('老年犬蛋白质管理', '健康老年犬不需要限制蛋白质摄入。过去认为老年犬应低蛋白饮食以保护肾脏的观点已被推翻。除非已确诊慢性肾病（CKD），否则老年犬仍需充足的优质蛋白质（DM基准25%以上）来维持肌肉量。肌少症（sarcopenia）在老年犬中比肾病更常见。', 'dog', 'senior', '', '营养,老年,蛋白质', 'informational', 'WSAVA Global Nutrition Guidelines; Laflamme DP, 2012', 'guideline', '', 'approved'),

('绝育后猫的体重管理', '绝育后猫的基础代谢率下降约20%-30%，同时食欲可能增加。如果不调整饮食，绝育后猫肥胖风险显著增加。建议：1）绝育后减少日粮10%-20%；2）选择绝育猫专用粮（纤维适度增加、脂肪适度降低）；3）定时定量喂食，不自由采食；4）每周称重监控。', 'cat', 'adult', '', '营养,绝育,体重管理', 'caution', 'WSAVA Global Nutrition Toolkit', 'guideline', '', 'approved'),

('猫泌尿道健康与饮食', '猫下泌尿道疾病（FLUTD）与饮食密切相关。关键饮食管理：1）增加饮水量（湿粮或流动水碗）；2）控制尿液pH在6.2-6.8之间；3）降低日粮中镁含量；4）处方粮可有效预防鸟粪石结晶复发。自由采食的猫饮水量通常低于定时喂食的猫。', 'cat', 'adult,senior', '', '营养,泌尿道,饮水', 'caution', 'Merck Veterinary Manual - Feline Lower Urinary Tract Disease', 'article', '', 'approved'),

('犬RER计算公式', '静息能量需求（RER）= 70 × 体重(kg)^0.75。这是计算犬每日能量需求的第一步。例如：10kg犬的RER = 70 × 10^0.75 = 70 × 5.62 = 394kcal/日。对于3-40kg范围内的犬，此公式准确度高。超出此范围可使用线性公式：RER = 30 × 体重(kg) + 70。', 'dog', 'adult,young,senior', '', '营养,能量计算,RER', 'informational', '中国兽医协会《犬猫临床营养摄入能量需求计算操作指南》', 'guideline', '', 'approved'),

('猫RER简化计算公式', '猫的静息能量需求（RER）通用公式为：RER = 70 × 体重(kg)^0.75。对于正常体型成猫，也可使用简化公式：RER ≈ 40 × 体重(kg)。例如4kg猫的RER ≈ 40 × 4 = 160kcal/日。肥胖猫应按理想体重计算RER，避免过度限制导致肝脂质沉积症。', 'cat', 'adult,young,senior', '', '营养,能量计算,RER', 'informational', '中国兽医协会《犬猫临床营养摄入能量需求计算操作指南》', 'guideline', '', 'approved'),

('宠物妊娠哺乳期营养需求', '妊娠母犬/母猫在妊娠前5周不需要额外增加能量。妊娠最后3周和哺乳期能量需求显著增加，可达维持量的2-3倍。哺乳期母犬能量需求约为RER的3-4倍。应提供高能量密度、高蛋白的食物，幼犬/猫粮可满足此需求。保证充足饮水。', 'dog,cat', 'adult', '', '营养,妊娠,哺乳', 'informational', 'NRC 2006; WSAVA Nutrition Guidelines', 'guideline', '', 'approved'),

('生骨肉喂养的风险', '生骨肉（BARF）喂养存在多项风险：1）沙门氏菌和大肠杆菌污染风险（对宠物和人均有风险）；2）寄生虫感染风险；3）营养不均衡（钙磷比失调常见）；4）骨头碎片可能导致牙齿断裂或消化道损伤。FDA和AAFP均不推荐生骨肉喂养。如选择自制饮食，需咨询宠物营养师。', 'dog,cat', 'adult,young,senior', '', '营养,生骨肉,安全', 'caution', 'FDA; AAFP; Merck Veterinary Manual', 'article', '', 'approved'),

('维生素A中毒在猫中的风险', '猫对维生素A过量敏感。长期过量摄入可导致颈椎关节融合、骨质增生和肝脏损伤。主要风险来源是长期大量喂食动物肝脏。猫粮中维生素A上限为350,000IU/kg（干物质基准）。正常食用商业猫粮不会中毒，风险主要来自不当自制饮食。', 'cat', 'adult,senior', '', '营养,维生素A,中毒', 'caution', 'NRC 2006; Merck Veterinary Manual', 'book', '', 'approved'),

('宠物肥胖的危害', '宠物肥胖（BCS≥7/9）与多种健康问题相关：1）糖尿病（猫尤为显著）；2）骨关节疾病；3）心血管疾病；4）呼吸系统问题；5）某些癌症风险增加；6）寿命缩短（研究显示超重犬寿命缩短约2年）。减重应在兽医指导下进行，速度控制在每周减体重的1%-2%。', 'dog,cat', 'adult,senior', '', '营养,肥胖,体重管理', 'caution', 'WSAVA Global Nutrition Guidelines; Laflamme DP, 2012', 'guideline', '', 'approved'),

('亚油酸是犬猫必需脂肪酸', '亚油酸（C18:2 n-6）是犬猫的必需脂肪酸，体内无法合成，必须从食物获取。缺乏表现为皮肤干燥、脱毛、伤口愈合延迟。猫还需要花生四烯酸（C20:4 n-6），因为猫缺乏Δ6-去饱和酶，无法从亚油酸有效合成。动物脂肪是主要来源。', 'dog,cat', 'adult,young', '', '营养,脂肪酸,皮肤', 'informational', 'NRC 2006', 'book', '', 'approved'),

('犬粮粗灰分上限', '国标GB/T 31216-2014规定成犬粮粗灰分（干物质基准）最大含量为10%。粗灰分反映矿物质总量，过高可能影响适口性和消化率。但灰分高低不直接等同于粮食质量，关键是矿物质的种类和比例是否合理。', 'dog', 'adult', '', '营养,灰分,矿物质', 'informational', 'GB/T 31216-2014 全价宠物食品 犬粮', 'standard', '', 'approved'),

('猫粮牛磺酸最低含量标准', '国标GB/T 31217-2014规定：猫干粮牛磺酸含量≥0.1%（干物质基准），猫湿粮≥0.2%（干物质基准）。牛磺酸在加工和储存过程中会有损失，因此实际添加量通常高于最低标准。选购猫粮时应关注牛磺酸含量标注。', 'cat', 'adult,young', '', '营养,牛磺酸,标准', 'informational', 'GB/T 31217-2014 全价宠物食品 猫粮', 'standard', '', 'approved'),

('全价粮与补充粮的区别', '全价粮（Complete Food）可提供宠物每日所需的全部营养素，可作为唯一食物。补充粮（Complementary Food）仅提供部分营养，不能作为唯一主食，如零食、肉干、罐头（部分）。包装上应标注"全价"或"补充"字样。长期以补充粮为主食会导致营养不均衡。', 'dog,cat', 'adult,young,senior', '', '营养,全价粮,补充粮', 'informational', '农业农村部《宠物饲料管理办法》2018年', 'guideline', '', 'approved');

-- ========================
-- 二、日常护理类 (20条)
-- ========================

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('绝育后宠物代谢率变化', '绝育后犬猫的代谢率下降约20%-30%，同时食欲可能增加。这是因为性激素减少影响了能量代谢调节。绝育后应：1）减少日粮10%-20%或更换绝育配方粮；2）增加运动量；3）每周称重，BCS维持在4-5/9。绝育肥胖不是必然，关键在于饮食管理。', 'dog,cat', 'adult', '', '护理,绝育,体重', 'informational', 'WSAVA Global Nutrition Toolkit', 'guideline', '', 'approved'),

('BCS体况评分九分制说明', 'BCS（Body Condition Score）体况评分采用1-9分制：1分=极度消瘦，5分=理想体态（可触及肋骨但不可见，侧面可见腹部上收），9分=极度肥胖。4-5分为理想范围。评分方法：触摸肋骨覆盖脂肪厚度、观察腰腹线条。建议每月评估一次，是判断喂养是否合理的最直观指标。', 'dog,cat', 'adult,young,senior', '', '护理,BCS,体重', 'informational', 'WSAVA Body Condition Score Charts', 'guideline', '', 'approved'),

('犬牙周病预防', '约80%的3岁以上犬存在不同程度的牙周疾病。预防措施：1）每日刷牙（使用宠物专用牙膏，人用牙膏含氟有毒）；2）提供咀嚼洁齿产品（VOHC认证产品）；3）定期口腔检查。牙周病不仅影响口腔，细菌还可进入血液影响心脏、肾脏等器官。', 'dog', 'adult,senior', '', '护理,口腔,牙齿', 'informational', 'Merck Veterinary Manual - Dental Disease in Dogs', 'article', '', 'approved'),

('猫每日饮水量参考', '健康猫每日饮水量约为40-60ml/kg体重（含食物中的水分）。以4kg猫为例，每日总水摄入约160-240ml。吃干粮的猫需额外饮水约100-160ml（干粮含水量仅约10%）。增加饮水的方法：使用流动水碗、多放几个水碗、增加湿粮比例。饮水量突然增加可能是肾病或糖尿病的信号。', 'cat', 'adult,senior', '', '护理,饮水', 'informational', 'Merck Veterinary Manual; Ellis E, 2013', 'article', '', 'approved'),

('犬每日饮水量参考', '健康犬每日饮水量约为50-100ml/kg体重（含食物中的水分）。以10kg犬为例，每日总水摄入约500-1000ml。运动后、天气炎热、吃干粮时饮水量会增加。饮水量突然显著增加（>100ml/kg/日）可能是肾病、糖尿病、子宫蓄脓等疾病的信号，应及时就医。', 'dog', 'adult,young,senior', '', '护理,饮水', 'informational', 'Merck Veterinary Manual', 'article', '', 'approved'),

('犬换毛期护理', '双层被毛犬种（如金毛、哈士奇、柴犬）每年春秋两季会大量脱毛，持续2-4周。换毛期护理：1）每日梳毛去除死毛，减少毛发打结和皮肤问题；2）适当增加Omega-3脂肪酸补充，促进皮肤健康；3）不要剃毛（双层被毛有隔热和保温功能，剃毛后可能不正常再生）。', 'dog', 'adult', '双层被毛犬种', '护理,毛发,梳毛', 'informational', 'WSAVA Nutrition Toolkit; AKC Grooming Guide', 'guideline', '', 'approved'),

('猫梳毛频率建议', '短毛猫建议每周梳毛1-2次，长毛猫建议每日梳毛。梳毛可以：1）减少毛球症风险（猫舔毛吞入过多毛发可形成毛球）；2）促进皮肤血液循环；3）增进人猫感情。梳毛时注意检查皮肤是否有肿块、寄生虫或异常脱毛区域。', 'cat', 'adult,senior', '', '护理,毛发,梳毛', 'informational', 'AAFP Cat Care Guidelines', 'guideline', '', 'approved'),

('犬指甲修剪频率', '犬指甲建议每2-4周修剪一次。不常外出的室内犬指甲磨损少，需要更频繁修剪。指甲过长会影响步态、导致关节疼痛，甚至弯曲长入肉中。修剪时避免剪到血线（粉色部分），如不慎剪出血可用止血粉按压。不确定时可请兽医或美容师操作。', 'dog', 'adult,young,senior', '', '护理,指甲', 'informational', 'AKC Nail Trimming Guide', 'guideline', '', 'approved'),

('猫洗澡频率建议', '猫通常不需要频繁洗澡。健康短毛猫一年洗1-2次即可，长毛猫可适当增加。猫会自行梳理毛发保持清洁。需要洗澡的情况：1）接触了有害物质；2）皮肤疾病需要药浴；3）年老肥胖猫无法自行梳理。洗澡使用猫专用沐浴露，水温38°C左右，洗后彻底吹干防止着凉。', 'cat', 'adult,senior', '', '护理,洗澡', 'informational', 'AAFP Cat Care Guidelines; Merck Veterinary Manual', 'article', '', 'approved'),

('犬洗澡频率建议', '健康犬建议每2-4周洗一次澡，过于频繁会破坏皮肤油脂保护层。使用犬专用沐浴露（pH值与犬皮肤匹配，人用产品偏碱性）。皮肤敏感的犬可使用燕麦配方或低敏配方。洗澡水温37-38°C，洗后彻底吹干，特别注意耳道内不要进水。', 'dog', 'adult,young,senior', '', '护理,洗澡', 'informational', 'AKC Grooming Guide; Merck Veterinary Manual', 'article', '', 'approved'),

('宠物应激反应识别', '宠物应激信号：犬——舔唇、打哈欠、转头回避、尾巴夹紧、身体僵硬、耳朵后贴；猫——瞳孔放大、耳朵后贴、尾巴快速摆动、躲藏、拒绝进食。常见应激源：搬家、陌生人/动物、噪音（鞭炮/雷声）、就医。减少应激：提供安全躲避空间、使用信息素产品、逐步适应。', 'dog,cat', 'adult,young,senior', '', '护理,应激,行为', 'informational', 'Merck Veterinary Manual - Behavior; ISFM Cat-Friendly Guidelines', 'article', '', 'approved'),

('老年宠物体检频率', '7岁以上的犬猫建议每半年体检一次（年轻宠物每年一次即可）。老年体检应包含：1）全血细胞计数和生化检查；2）尿液分析；3）甲状腺功能检查（猫尤为重要）；4）影像学检查（X光/B超）。早期发现慢性病可显著提高治疗效果和生活质量。', 'dog,cat', 'senior', '', '护理,老年,体检', 'informational', 'AAHA Senior Care Guidelines; AAFP Senior Guidelines', 'guideline', '', 'approved'),

('犬疫苗接种基础周期', '幼犬基础免疫：6-8周龄首免（犬瘟热、细小病毒、腺病毒），每隔3-4周加强一次，至16周龄共3-4针。12月龄加强一次，此后每1-3年加强一次（根据疫苗类型和当地法规）。狂犬疫苗：3月龄首免，此后每年或每3年加强。具体方案请咨询当地兽医。', 'dog', 'young', '', '护理,疫苗,免疫', 'informational', 'AAHA Canine Vaccination Guidelines 2017', 'guideline', '', 'approved'),

('猫疫苗接种基础周期', '幼猫基础免疫：6-8周龄首免（猫瘟、猫杯状病毒、猫疱疹病毒），每隔3-4周加强一次，至16周龄共3针。12月龄加强一次，此后每1-3年加强一次。狂犬疫苗：3月龄首免。室内猫也建议接种核心疫苗，因为病原体可通过衣物等带入家中。', 'cat', 'young', '', '护理,疫苗,免疫', 'informational', 'AAFP Feline Vaccination Guidelines 2020', 'guideline', '', 'approved'),

('犬常规驱虫周期', '体内驱虫：成年犬建议每3个月一次。使用心丝虫预防药的犬可同时覆盖肠道寄生虫。体外驱虫：每月一次（尤其春夏季节）。心丝虫预防：每月一次，从幼犬2月龄开始。驱虫药选择应根据当地寄生虫流行情况和宠物生活方式，建议咨询兽医。', 'dog', 'adult,young,senior', '', '护理,驱虫', 'informational', 'CAPC（Companion Animal Parasite Council）Guidelines', 'guideline', '', 'approved'),

('猫常规驱虫周期', '体内驱虫：成年猫建议每3个月一次。即使完全室内猫也可能通过鞋底、窗台等途径感染寄生虫。体外驱虫：每月一次（尤其多猫家庭或有外出情况的猫）。心丝虫预防：每月一次，从2月龄开始。广谱驱虫药可同时覆盖蛔虫、钩虫和绦虫。', 'cat', 'adult,young,senior', '', '护理,驱虫', 'informational', 'CAPC Guidelines; ESCCAP', 'guideline', '', 'approved'),

('新宠物到家适应期护理', '新宠物到家需要1-2周适应期。建议：1）准备安静、温暖、安全的独立空间；2）提供充足的食物和水，但不要因为紧张而过度关注进食情况；3）前3天减少接触和噪音，让宠物自行探索；4）逐步引入家庭成员和其他宠物；5）避免立即洗澡（应激状态下免疫力低）。', 'dog,cat', 'young,adult', '', '护理,适应期,新宠物', 'informational', 'ASCP New Pet Guidelines; Merck Veterinary Manual', 'article', '', 'approved'),

('公猫尿闭是致死急症', '公猫尿道狭窄，极易发生尿闭（尿道阻塞）。症状：频繁蹲厕但无尿或仅几滴、舔舐生殖器、叫唤不安、腹部胀痛。尿闭24-48小时可导致急性肾衰竭和高钾血症，危及生命。⚠️ 发现公猫排尿困难应立即就医，不可在家观察等待。预防：增加饮水量、控制体重、减少应激。', 'cat', 'adult', '', '护理,尿闭,急诊', 'emergency', 'Merck Veterinary Manual - Urethral Obstruction in Cats', 'article', '', 'approved'),

('犬中暑预防与急救', '犬中暑信号：剧烈喘息、流涎过多、牙龈发红/发紫、步态不稳、呕吐腹泻、意识模糊。急救：1）立即转移到阴凉处；2）用凉水（非冰水）淋湿身体，尤其腹部和脚垫；3）风扇加速蒸发降温；4）体温降至39.5°C时停止降温；5）立即送医。预防：高温天避免户外运动，永远不要把犬留在车内。', 'dog', 'adult,young,senior', '', '护理,中暑,急救', 'emergency', 'Merck Veterinary Manual - Heat Stroke; AVMA', 'article', '', 'approved'),

('猫出行应激管理', '猫对出行和环境变化高度敏感。减少出行应激：1）使用熟悉的航空箱，提前一周放在家中让猫适应；2）航空箱内放熟悉的毛巾；3）可使用猫信息素喷雾（Feliway）；4）出行前4-6小时停止喂食（防晕车呕吐）；5）车内保持安静，航空箱用毛巾遮盖减少视觉刺激。', 'cat', 'adult,young,senior', '', '护理,出行,应激', 'informational', 'ISFM Cat-Friendly Handling Guidelines; AAFP', 'guideline', '', 'approved');

-- ========================
-- 三、症状红线类 (20条)
-- ========================

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('犬呕吐的家庭观察要点', '犬偶尔呕吐（1-2次/天，精神食欲正常）可先居家观察：1）禁食12-24小时但保证饮水；2）恢复喂食时少量多餐，选择易消化食物；3）观察呕吐物颜色和内容物。⚠️ 以下情况需立即就医：频繁呕吐、呕吐带血、伴随腹泻、精神萎靡、腹部胀大、怀疑吞食异物。', 'dog', 'adult,young,senior', '', '症状,呕吐', 'caution', 'Merck Veterinary Manual - Vomiting in Dogs', 'article', '', 'approved'),

('猫呕吐的常见原因与就医信号', '猫呕吐比犬更常见，但频繁呕吐不是"正常"的。居家观察条件：偶吐1次、精神食欲正常、呕吐物为未消化食物。⚠️ 需就医的信号：频繁呕吐（>3次/天）、呕吐带血或咖啡渣样、伴随腹泻或拒食、呕吐物有粪臭味（可能肠梗阻）。猫连续呕吐超过24小时有肝脂质沉积风险。', 'cat', 'adult,senior', '', '症状,呕吐', 'caution', 'Merck Veterinary Manual - Vomiting in Cats', 'article', '', 'approved'),

('宠物腹泻的家庭处理与就医时机', '轻度腹泻（成形软便，精神食欲正常）可居家观察：1）禁食12小时后少量多餐；2）保证充足饮水防脱水；3）可添加益生菌。⚠️ 立即就医信号：水样腹泻超过24小时、便血（鲜红或黑色柏油样）、伴随呕吐、发热、幼宠或老年宠腹泻、精神极度萎靡。幼宠腹泻脱水可致命。', 'dog,cat', 'adult,young,senior', '', '症状,腹泻', 'caution', 'Merck Veterinary Manual - Diarrhea', 'article', '', 'approved'),

('便血是严重警示信号', '宠物便血分两种：1）鲜红色血便（hematochezia）——出血来自下消化道/直肠，常见于肠炎、寄生虫、息肉；2）黑色柏油样便（melena）——出血来自上消化道，提示胃/十二指肠出血，更为严重。两种情况均需就医检查。⚠️ 伴随呕吐、拒食、精神差的便血应紧急就医。', 'dog,cat', 'adult,young,senior', '', '症状,便血,急诊', 'emergency', 'Merck Veterinary Manual - Blood in Stool', 'article', '', 'approved'),

('宠物便秘的识别与处理', '便秘信号：频繁蹲厕但排便困难或无便、排便时叫唤、粪便干硬小球状、食欲下降。家庭处理：增加饮水量、添加少量南瓜泥（富含纤维）、增加运动。⚠️ 超过48小时未排便应就医。猫便秘需排除毛球阻塞。反复便秘的猫可能需要长期饮食管理（处方纤维粮）。', 'dog,cat', 'adult,senior', '', '症状,便秘', 'caution', 'Merck Veterinary Manual - Constipation', 'article', '', 'approved'),

('宠物食欲下降的评估', '宠物偶尔一顿不吃不一定是问题，但持续拒食超过24小时（猫）或48小时（犬）应就医。需关注的伴随症状：精神萎靡、呕吐腹泻、发热、饮水量变化、体重下降。猫长时间拒食（>48小时）有肝脂质沉积症风险，尤其肥胖猫，应尽早干预。幼宠食欲下降应更积极就医。', 'dog,cat', 'adult,young,senior', '', '症状,食欲', 'caution', 'Merck Veterinary Manual; WSAVA Nutrition Toolkit', 'article', '', 'approved'),

('宠物精神萎靡的评估', '精神萎靡是许多疾病的非特异性表现。评估要点：1）持续时间——超过24小时需关注；2）伴随症状——是否同时出现呕吐、腹泻、拒食、发热；3）行为变化——是否躲藏、不愿互动、对平时喜欢的事物无反应。⚠️ 幼宠精神萎靡进展可能很快，不应等待观察，应尽早就医。', 'dog,cat', 'adult,young,senior', '', '症状,精神', 'caution', 'Merck Veterinary Manual', 'article', '', 'approved'),

('宠物多饮多尿的鉴别', '多饮（>100ml/kg/日）多尿是重要的疾病信号。常见原因：1）肾脏疾病；2）糖尿病（猫多见）；3）子宫蓄脓（未绝育母犬）；4）甲亢（猫多见）；5）库兴氏综合征（犬多见）。⚠️ 出现多饮多尿应尽快就医做血液和尿液检查，不要简单归因于"天气热"或"运动多"。', 'dog,cat', 'adult,senior', '', '症状,多饮多尿', 'caution', 'Merck Veterinary Manual - Polyuria and Polydipsia', 'article', '', 'approved'),

('猫排尿困难需紧急处理', '猫（尤其公猫）排尿困难是最紧急的宠物急诊之一。症状：频繁蹲厕、排尿姿势但无尿或仅几滴、舔舐生殖器、哭叫、腹部疼痛。可能原因：尿道阻塞（结石/栓子）、特发性膀胱炎。⚠️ 尿闭超过24小时可导致急性肾衰竭和高钾血症（心脏骤停风险），必须立即就医。', 'cat', 'adult', '', '症状,排尿困难,急诊', 'emergency', 'Merck Veterinary Manual - Urethral Obstruction', 'article', '', 'approved'),

('宠物皮肤问题的初步识别', '常见皮肤问题信号：过度舔舐/抓挠、脱毛（局灶性或弥漫性）、皮肤发红、皮屑增多、异味、耳朵频繁甩头。常见原因：1）过敏（食物/环境/跳蚤）；2）寄生虫（螨虫、真菌）；3）细菌感染；4）内分泌疾病。⚠️ 持续瘙痒超过1周、大面积脱毛或皮肤溃烂应就医做皮肤刮片检查。', 'dog,cat', 'adult,young,senior', '', '症状,皮肤', 'caution', 'Merck Veterinary Manual - Skin Disorders', 'article', '', 'approved'),

('宠物眼部分泌物的评估', '少量眼屎属正常。异常信号：1）大量黄绿色分泌物——可能结膜炎或角膜溃疡；2）单侧流泪——可能异物或鼻泪管阻塞；3）眼睛发红、肿胀——需紧急就医（青光眼/葡萄膜炎可致盲）；4）第三眼睑外露——提示全身性疾病。⚠️ 犬猫角膜溃疡禁用含激素眼药水，需先做荧光素染色排除。', 'dog,cat', 'adult,young,senior', '', '症状,眼部', 'caution', 'Merck Veterinary Manual - Eye Disorders', 'article', '', 'approved'),

('宠物鼻分泌物的评估', '清亮少量鼻涕可为正常。异常信号：1）黄绿色浓涕——可能上呼吸道感染或鼻腔异物；2）单侧鼻涕——可能牙齿脓肿或鼻腔肿瘤；3）带血鼻涕——需排查肿瘤、凝血障碍或真菌感染；4）伴随打喷嚏、呼吸声异常。⚠️ 猫鼻分泌物伴打喷嚏、眼分泌物增多，常见于猫鼻支（疱疹病毒），应就医。', 'dog,cat', 'adult,young,senior', '', '症状,鼻部', 'caution', 'Merck Veterinary Manual - Nasal Discharge', 'article', '', 'approved'),

('宠物体重骤降的警示', '非刻意减重情况下，体重下降超过体重的5%应引起重视。常见原因：1）甲亢（猫最常见）；2）糖尿病；3）慢性肾病；4）消化系统疾病（IBD、淋巴瘤）；5）寄生虫感染。⚠️ 体重下降伴随食欲增加（多食消瘦）高度提示甲亢或糖尿病，应尽快就医检查。', 'dog,cat', 'adult,senior', '', '症状,体重下降', 'caution', 'Merck Veterinary Manual - Weight Loss', 'article', '', 'approved'),

('宠物腹部胀硬需紧急就医', '腹部明显胀大、触诊紧张坚硬是严重急症信号。可能原因：1）胃扩张-扭转（GDV，大型犬深胸犬高发）——表现为腹部膨隆、干呕、流涎、不安；2）子宫蓄脓——未绝育母犬产后1-2月高发；3）腹腔积液——心/肝/肾疾病或肿瘤；4）内出血。⚠️ 腹部胀硬伴精神差必须立即急诊，GDV数小时内可致命。', 'dog,cat', 'adult,senior', '', '症状,腹部,急诊', 'emergency', 'Merck Veterinary Manual - GDV; Abdominal Distension', 'article', '', 'approved'),

('宠物跛行的家庭评估', '跛行（瘸腿）评估：1）轻度跛行（偶尔提脚，能负重）——可观察24-48小时，限制运动；2）完全不负重、三脚跳——应就医拍片；3）伴随肢体肿胀、发热、疼痛叫唤——尽快就医。常见原因：扭伤、韧带断裂（犬十字韧带常见）、骨折、关节炎（老年）、指甲断裂。⚠️ 不要给宠物用人用止痛药。', 'dog,cat', 'adult,young,senior', '', '症状,跛行', 'caution', 'Merck Veterinary Manual - Lameness', 'article', '', 'approved'),

('宠物体表肿块的评估原则', '发现宠物体表肿块时注意：1）记录大小、位置、质地（硬/软）、活动度、增长速度；2）"七规则"——快速增长、质地硬、固定不活动、表面溃烂、边界不清、直径>2cm、颜色不均匀——任一特征需警惕；3）细针穿刺（FNA）是简单快速的初步检查。⚠️ 任何持续增大或2周以上不消退的肿块都应就医检查。', 'dog,cat', 'adult,senior', '', '症状,肿块', 'caution', 'Merck Veterinary Manual - Tumors and Tumors of the Skin', 'article', '', 'approved'),

('宠物伤口化脓的处理', '伤口化脓信号：红肿热痛、有脓性分泌物（黄白色）、异味。家庭初步处理：1）剃除伤口周围毛发；2）生理盐水冲洗；3）碘伏消毒（不要用酒精，刺激性大）。⚠️ 以下情况需就医：伤口深可见肌肉/骨骼、咬伤（感染风险高）、化脓伴发热、伤口>2cm、位于面部/关节处。不要自行使用人用抗生素软膏。', 'dog,cat', 'adult,young,senior', '', '症状,伤口', 'caution', 'Merck Veterinary Manual - Wound Management', 'article', '', 'approved'),

('宠物误食异物的紧急处理', '宠物误食常见异物：巧克力、葡萄/葡萄干、洋葱、木糖醇（口香糖）、老鼠药、人用药物、玩具碎片、丝袜等。⚠️ 紧急处理原则：1）不要自行催吐（腐蚀性物质催吐会加重损伤）；2）带上被误食物品的包装前往医院；3）记录误食时间和估计量。⚠️ 巧克力（可可碱）、木糖醇、葡萄对犬有明确毒性，应立即就医。', 'dog,cat', 'adult,young,senior', '', '症状,中毒,急诊', 'emergency', 'ASPCA Animal Poison Control; Merck Veterinary Manual', 'article', '', 'approved'),

('宠物抽搐的急救要点', '抽搐（癫痫发作）急救：1）保持冷静，不要试图按住宠物；2）移开周围硬物和尖锐物品防碰伤；3）不要把手伸进宠物嘴里（不会咬舌，但会咬伤你）；4）记录发作持续时间和表现；5）发作后立即送医。⚠️ 抽搐持续超过5分钟或连续发作（癫痫持续状态）是危及生命的急症，必须立即就医。', 'dog,cat', 'adult,young,senior', '', '症状,抽搐,急诊', 'emergency', 'Merck Veterinary Manual - Seizures', 'article', '', 'approved'),

('宠物呼吸困难的识别', '呼吸困难信号：张口呼吸（猫正常不张口呼吸）、腹式呼吸（腹部用力）、呼吸频率>40次/分（休息时）、牙龈/舌头青紫（发绀）、不愿躺下（端坐呼吸）。⚠️ 呼吸困难是最紧急的急诊之一，可能原因包括：心力衰竭、胸腔积液、肺炎、气道阻塞、中毒。必须立即就医，途中保持安静、避免应激。', 'dog,cat', 'adult,senior', '', '症状,呼吸困难,急诊', 'emergency', 'Merck Veterinary Manual - Dyspnea', 'article', '', 'approved');

-- ========================
-- 四、季节行为类 (10条)
-- ========================

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('夏季犬中暑预防要点', '犬通过喘气散热，高温高湿环境下极易中暑。预防要点：1）避开上午10点至下午4点户外运动；2）提供阴凉处和充足饮水；3）永远不要把犬留在停放的车内（10分钟车内温度可致命）；4）柏油路面烫脚测试——手背贴路面5秒，过烫则不宜遛弯；5）短鼻犬种（法斗、巴哥等）风险更高。', 'dog', 'adult,young,senior', '短鼻犬种', '季节,夏季,中暑', 'caution', 'AVMA Hot Weather Tips; Merck Veterinary Manual', 'article', '', 'approved'),

('冬季犬关节保暖建议', '寒冷天气可加重关节炎症状。老年犬和大型犬尤其注意：1）提供温暖干燥的睡眠环境，远离地面寒风；2）适当增加Omega-3脂肪酸补充，有助减轻关节炎症；3）保持适度运动（不要因天冷完全停止）；4）雨雪天后擦干四肢，检查脚垫是否有裂纹或融雪剂残留；5）必要时穿保暖衣。', 'dog', 'senior', '大型犬', '季节,冬季,关节', 'informational', 'Merck Veterinary Manual - Osteoarthritis', 'article', '', 'approved'),

('猫冬季关节保暖', '老年猫（>7岁）骨关节炎发生率高达60%以上，但猫善于隐藏疼痛。冬季保暖建议：1）提供温暖的猫窝（远离窗户和门口）；2）使用加热垫（注意防咬线）或暖水袋；3）确保猫砂盆在容易到达的位置（关节疼痛的猫可能不愿爬高）；4）适当补充关节营养素（葡萄糖胺/软骨素）。', 'cat', 'senior', '', '季节,冬季,关节', 'informational', 'AAFP Senior Care Guidelines', 'guideline', '', 'approved'),

('春季宠物驱虫加强', '春季气温回升，寄生虫开始活跃。驱虫重点：1）体外驱虫——跳蚤、蜱虫在春季大量繁殖，每月一次体外驱虫不可省略；2）心丝虫——蚊虫开始出现时恢复月度预防；3）蜱虫高发地区外出后检查皮肤褶皱和耳后。即使室内宠物，跳蚤卵也可通过人的鞋底带入家中。', 'dog,cat', 'adult,young,senior', '', '季节,春季,驱虫', 'informational', 'CAPC Seasonal Parasite Guidelines', 'guideline', '', 'approved'),

('夏季宠物皮肤湿热护理', '高温高湿环境易发皮肤问题：1）皮肤褶皱处（法斗/巴哥面部褶皱、肥胖宠物腹部褶皱）保持干燥，每日擦拭防止间擦疹；2）游泳或洗澡后彻底吹干，尤其耳道内；3）湿热环境真菌感染（皮癣）风险增加，发现圆形脱毛斑应就医；4）避免过度洗澡破坏皮肤屏障。', 'dog,cat', 'adult,young', '', '季节,夏季,皮肤', 'informational', 'Merck Veterinary Manual - Skin Disorders', 'article', '', 'approved'),

('秋季宠物食欲增加管理', '秋季气温下降，部分宠物食欲自然增加（为冬季储备能量），这是正常的生理反应。但室内宠物不需要额外"增肥"。管理建议：1）维持定时定量喂食，不因食欲增加而加量；2）坚持零食10%上限原则；3）保持日常运动量；4）BCS维持在4-5/9。冬季肥胖的宠物在来年春季更易出现代谢问题。', 'dog,cat', 'adult', '', '季节,秋季,食欲', 'informational', 'WSAVA Global Nutrition Guidelines', 'guideline', '', 'approved'),

('节假日宠物饮食禁忌', '节假日餐桌食物对宠物存在多种风险：1）巧克力/可可——含可可碱，对犬有毒；2）葡萄/葡萄干——可致犬急性肾衰竭；3）洋葱/大蒜——破坏红细胞导致溶血性贫血；4）木糖醇（无糖食品）——致犬低血糖和肝衰竭；5）鸡骨/鱼骨——可刺穿消化道；6）酒精——即使少量也有中毒风险。⚠️ 坚持喂宠物自己的粮食，不分享人食。', 'dog,cat', 'adult,young,senior', '', '季节,节假日,饮食禁忌,中毒', 'caution', 'ASPCA Human Foods Toxic to Pets; Merck Veterinary Manual', 'article', '', 'approved'),

('春节鞭炮对宠物的应激管理', '鞭炮噪音是宠物最常见的应激源之一。管理建议：1）提前准备安全的躲避空间（封闭、安静的房间）；2）播放白噪音或音乐掩盖鞭炮声；3）可使用宠物信息素（Adaptil犬/Feliway猫）辅助安抚；4）严重应激的宠物可在兽医指导下短期使用抗焦虑药物；5）不要强行把躲藏的宠物拉出来。', 'dog,cat', 'adult,young,senior', '', '季节,节假日,应激,噪音', 'informational', 'ISFM Cat-Friendly Guidelines; DASG', 'guideline', '', 'approved'),

('梅雨季节宠物皮肤病预防', '梅雨季节（6-7月）湿度持续>80%，皮肤问题高发。预防要点：1）保持居住环境通风干燥，可使用除湿机；2）犬洗澡后彻底吹干，特别注意脚趾间和耳道；3）长毛猫适当修剪腹部和四肢毛发减少潮湿；4）定期检查皮肤褶皱处是否有发红、异味；5）食盆水盆每日清洗防霉变。', 'dog,cat', 'adult,young', '', '季节,梅雨,皮肤', 'informational', 'Merck Veterinary Manual - Dermatology', 'article', '', 'approved'),

('冬季室内干燥对宠物皮肤影响', '冬季暖气导致室内湿度降至20%-30%（理想40%-60%），可引起宠物皮肤干燥、瘙痒、皮屑增多。护理建议：1）使用加湿器维持室内湿度40%-50%；2）适当补充Omega-3/6脂肪酸改善皮肤屏障；3）减少洗澡频率（冬季犬可2-3周一次）；4）使用宠物专用保湿喷雾；5）保证充足饮水。', 'dog,cat', 'adult,senior', '', '季节,冬季,皮肤,干燥', 'informational', 'Merck Veterinary Manual - Skin Care', 'article', '', 'approved');
