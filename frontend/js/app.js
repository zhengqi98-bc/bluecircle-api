
// ── LANGUAGE SYSTEM ──
let LANG = 'en';
const T = {
  /* NAV */
  'nav.home':         {zh:'首页',          en:'Home'},
  'nav.livemap':      {zh:'实时地图',    en:'Live Map'},
  'nav.profile':      {zh:'海龟档案',   en:'Turtles'},
  'nav.research':     {zh:'科研中心',   en:'Research'},
  'nav.conservation': {zh:'保护行动',   en:'Conservation'},
  'nav.hardware':     {zh:'硬件设备',   en:'Hardware'},
  'nav.login':        {zh:'登录',          en:'Login'},
  'nav.api':          {zh:'申请 API',       en:'Request API'},
  'nav.online':       {zh:'只在线',        en:'online'},
  'nav.register':     {zh:'注册',          en:'Sign up'},
  'nav.share':        {zh:'分享',          en:'Share'},
  'nav.addalert':     {zh:'+ 添加预警',    en:'+ Add Alert'},
  'nav.apikey':       {zh:'+ 新建 API Key',en:'+ New API Key'},
  'nav.report':       {zh:'📄 生成报告',   en:'📄 Generate Report'},
  'nav.emergency':    {zh:'⚠ Critical预警',   en:'⚠ Emergency Alert'},
  'nav.back':         {zh:'← 返回地图',   en:'← Back to Map'},
  'nav.share2':       {zh:'分享档案',      en:'Share Profile'},
  /* HERO */
  'hero.label':     {zh:'Blue Circle · Global海龟追踪平台', en:'Blue Circle · Global Sea Turtle Tracking'},
  'hero.h1a':       {zh:'跨越Global',        en:'Follow Sea Turtles'},
  'hero.h1b':       {zh:'Live Tracking',        en:'Across the World'},
  'hero.h1c':       {zh:'每一只海龟',      en:'in Real Time'},
  'hero.accent':    {zh:'海龟迁徙之路',    en:'Across the World'},
  'hero.p':         {zh:'用卫星Data与 AI 守护Global海洋生命。Live Tracking、迁徙预测、保护预警，一个平台覆盖全流程。',
                     en:'Protecting ocean life with satellite data and AI. Real-time tracking, migration forecasting, and conservation alerts — one platform for everything.'},
  'hero.cta1':      {zh:'▶ 观看实时地图', en:'▶ Watch Live Map'},
  'hero.cta2':      {zh:'申请免费试用 →', en:'Apply for Free Trial →'},
  'hero.trust1':    {zh:'免费试用 1–2 台设备',en:'Free trial · 1–2 devices'},
  'hero.trust2':    {zh:'开放 API · 基础免费',en:'Open API · free tier'},
  'hero.trust3':    {zh:'40+ 合作机构',   en:'40+ institutions'},
  /* LIVE BADGE */
  'live.online':    {zh:'只在线',          en:'online'},
  /* STATS STRIP */
  'strip.val1lbl':  {zh:'实时在线海龟',   en:'Live Turtles Online'},
  'strip.val1d':    {zh:'↑ 较昨日 +12',   en:'↑ +12 vs yesterday'},
  'strip.val2':     {zh:'present日平均移动距离',en:'Avg Daily Distance'},
  'strip.val2d':    {zh:'↑ 高于月均 8%',  en:'↑ 8% above monthly avg'},
  'strip.val3':     {zh:'覆盖国家与海域',  en:'Countries & Regions'},
  'strip.val3d':    {zh:'↑ 本月新增 2 国', en:'↑ 2 new this month'},
  'strip.val4':     {zh:'当前活跃预警',    en:'Active Alerts'},
  'strip.val4d':    {zh:'⚠ 2 项需立即响应',en:'⚠ 2 need immediate action'},
  'strip.val5':     {zh:'present日 API 调用次数',en:'API Calls Today'},
  'strip.val5d':    {zh:'↑ 较昨日 +5.2%', en:'↑ +5.2% vs yesterday'},
  /* PHOTO STRIP */
  'photo.green':    {zh:'Green Turtle Green Turtle',  en:'Green Turtle'},
  'photo.leath':    {zh:'Leatherback Leatherback',   en:'Leatherback Turtle'},
  'photo.hawksbill':{zh:'Hawksbill Hawksbill',    en:'Hawksbill Turtle'},
  'photo.hawk':     {zh:'Hawksbill Hawksbill',       en:'Hawksbill Turtle'},
  /* ACTIVITY SECTION */
  'act.eyebrow':    {zh:'实时动态 · Live Activity',en:'Real-Time Activity'},
  'act.h2a':        {zh:'此刻，正在发生',  en:'What\'s Happening'},
  'act.h2b':        {zh:'的一切',          en:'Right Now'},
  'act.viewall':    {zh:'查看All →',      en:'View All →'},
  'act.feedtitle':  {zh:'实时事件流',      en:'Live Event Stream'},
  'act.sptitle':    {zh:'Species追踪状态',    en:'Species Tracking Status'},
  'act.spsub':      {zh:'Species Tracking Status', en:'Live Distribution'},
  'act.rgtitle':    {zh:'SCSRegion热点',    en:'South China Sea Hotspot'},
  'act.rgfull':     {zh:'全屏 →',          en:'Full Screen →'},
  'act.rglbl1':     {zh:'SCS (只)',        en:'S.China Sea'},
  'act.rglbl2':     {zh:'东海 (只)',        en:'East China Sea'},
  'act.rglbl3':     {zh:'预警事件',        en:'Active Alerts'},
  'act.rglbl4':     {zh:'平均水温',        en:'Avg Water Temp'},
  /* GAUGES */
  'g.eyebrow':      {zh:'实时传感Data · Sensor Data', en:'Real-Time Sensor Data'},
  'g.h2a':          {zh:'Global追踪',        en:'Global Tracking'},
  'g.h2b':          {zh:'关键指标',        en:'Key Metrics'},
  'g.updated':      {zh:'每 30 秒更新 · Last updated:',en:'Updated every 30s · Last:'},
  'g.1lbl':         {zh:'实时在线',        en:'Live Online'},
  'g.1sub':         {zh:'Online Turtles', en:'Online Turtles'},
  'g.2lbl':         {zh:'present日平均速度',    en:'Avg Speed Today'},
  'g.2sub':         {zh:'Avg Speed Today',en:'Avg Speed Today'},
  'g.3lbl':         {zh:'最近潜水深度',    en:'Latest Dive Depth'},
  'g.3sub':         {zh:'Latest Dive Depth',en:'Latest Dive Depth'},
  'g.4lbl':         {zh:'活跃风险预警',    en:'Active Risk Alerts'},
  'g.4sub':         {zh:'Active Alerts',  en:'Active Alerts'},
  'g.5lbl':         {zh:'累计追踪里程',    en:'Total Distance'},
  'g.5sub':         {zh:'Total Distance', en:'Total Distance'},
  'g.6lbl':         {zh:'SCS平均水温',    en:'S.China Sea Temp'},
  'g.6sub':         {zh:'S.China Sea Temp',en:'S.China Sea Temp'},
  /* ALERT BAND */
  'ab.title':       {zh:'⚡ 3 条活跃风险预警需要关注',en:'⚡ 3 Active Risk Alerts Require Attention'},
  'ab.sub':         {zh:'AI 系统已检测到High Risk事件，建议保护团队立即介入处理。',en:'AI has detected high-risk events. Conservation team should respond immediately.'},
  'ab.a1':          {zh:'Selingan — Critical',  en:'Selingan — Critical'},
  'ab.a1l':         {zh:'沙巴海龟群岛 · 信号微弱 · 电量 43%',en:'Sabah Turtle Is. Park · weak signal · battery 43%'},
  'ab.a2':          {zh:'Côn Đảo — High Risk', en:'Côn Đảo — High Risk'},
  'ab.a2l':         {zh:'越南南部 · 渔船密集作业带',en:'S. Vietnam · dense fishing zone'},
  'ab.a3':          {zh:'SST Anomaly',         en:'SST Anomaly'},
  'ab.a3l':         {zh:'SCS中部 · 30.6°C · 较气候态 +1.1°C',en:'Central SCS · 30.6°C · +1.1°C above climatology'},
  'ab.respond':     {zh:'立即响应',        en:'Respond Now'},
  'ab.report':      {zh:'查看报告',        en:'View Report'},
  /* FEATURES */
  'feat.eyebrow':   {zh:'核心功能 · Platform Features',en:'Platform Features'},
  'feat.h2':        {zh:'守护海龟的完整数字生态',en:'Complete Digital Ecosystem for Turtle Conservation'},
  'feat.sub':       {zh:'从Live Tracking到 AI 预测，一站式管理所有海龟保护工作',en:'From live tracking to AI forecasting — one platform for all conservation work'},
  'feat.1h':        {zh:'Global实时地图',    en:'Global Live Map'},
  'feat.1p':        {zh:'Real海洋地图，实时显示所有在线海龟位置、历史Tracks线，支持Timeline Playback与Heatmap叠加。',en:'Real ocean map showing live turtle locations, historical tracks, timeline playback and heatmap overlays.'},
  'feat.2h':        {zh:'AI 迁徙预测',     en:'AI Migration Forecast'},
  'feat.2p':        {zh:'基于历史Tracks与海洋环境Data，AI 模型预测未来 7 天迁徙路径，标注觅食区概率与风险Region。',en:'AI models predict 7-day migration paths using historical tracks and ocean environment data, with foraging zone probabilities.'},
  'feat.3h':        {zh:'保护预警系统',    en:'Conservation Alert System'},
  'feat.3p':        {zh:'船舶碰撞风险分析、非法捕捞热点识别、自动生成MPA Recommendations，全天候守护濒危Species。',en:'Vessel collision analysis, illegal fishing detection, and automatic protected zone recommendations — 24/7 protection.'},
  'feat.4h':        {zh:'科研Data中心',    en:'Research Data Portal'},
  'feat.4p':        {zh:'CSV / GeoJSON / NetCDF FormatDataDownload，API Key 管理，DOI 引用生成，协作项目空间。',en:'Download CSV / GeoJSON / NetCDF data, manage API keys, generate DOI citations, and collaborate on research projects.'},
  'feat.5h':        {zh:'海龟档案系统',    en:'Turtle Profile System'},
  'feat.5p':        {zh:'每只海龟独立档案：概览、Tracks、AI 预测、健康状态与故事Time线，支持一键社媒分享。',en:'Individual profiles with overview, track, AI forecast, health status, and story timeline — shareable to social media.'},
  'feat.6h':        {zh:'硬件设备管理',    en:'Hardware Management'},
  'feat.6p':        {zh:'Solar GPS Tag、卫星标签、Research Pro Tag，实时监控电量、固件升级与卫星流量用量。',en:'Solar GPS Tag, Satellite Tag, Research Pro Tag — monitor battery, firmware updates, and satellite data usage in real time.'},
  /* PARTNERS */
  'p.label':        {zh:'Global合作机构 · Trusted by leading institutions worldwide',en:'Trusted by leading institutions worldwide'},
  /* CTA */
  'cta.eyebrow':    {zh:'项目运作流程 · How It Works',en:'How It Works'},
  'cta.h2a':        {zh:'两种方式，加入守护行列',en:'Two Ways to Join the Mission'},
  'cta.h2b':        {zh:'守护行列',        en:'Join the Mission'},
  'cta.p':          {zh:'设备试用 + Data API，覆盖从硬件部署到科研分析的全链路。面向高校、科研机构、保护区开放。',en:'Hardware trial + data API — full coverage from field deployment to research analytics. Open to universities, research institutes, and protected areas.'},
  'cta.track1.tag': {zh:'业务线 01',       en:'TRACK 01'},
  'cta.track1.h':   {zh:'硬件免费试用',    en:'Free Hardware Trial'},
  'cta.track1.sub': {zh:'提供 1–2 台 TT 系列追踪器 + 1–3 个月Data服务，设备自动回传Data无需用户操作。',en:'1–2 TT-series trackers + 1–3 months of data service. Devices upload automatically — no user action required.'},
  'cta.track1.s1':  {zh:'提交申请：机构资质 · 项目简介 · 海域Species',en:'Submit application: institutional credentials · project brief · target species'},
  'cta.track1.s2':  {zh:'2–5 个工作日审核反馈',en:'Review within 2–5 business days'},
  'cta.track1.s3':  {zh:'设备发货 · Data自动回传至平台',en:'Devices shipped · data auto-streams to platform'},
  'cta.track1.btn': {zh:'申请免费试用 →',  en:'Apply for Free Trial →'},
  'cta.track2.tag': {zh:'业务线 02',       en:'TRACK 02'},
  'cta.track2.h':   {zh:'Data API 接入',   en:'Data API Access'},
  'cta.track2.sub': {zh:'基础免费 · 高级付费。提供海龟Tracks、环境参数、Species统计等常用Data集。',en:'Free tier + paid tier. Includes turtle tracks, environmental data, species statistics, and more.'},
  'cta.track2.s1':  {zh:'注册账号 · 提交使用场景说明',en:'Register account · describe your use case'},
  'cta.track2.s2':  {zh:'审核通过后获取 API Key',en:'Receive API key after approval'},
  'cta.track2.s3':  {zh:'导入Data · 标注Data来源 Blue Circle',en:'Integrate data · cite Blue Circle as source'},
  'cta.track2.btn': {zh:'申请 API →',     en:'Request API →'},
  'cta.note':       {zh:'📌 使用试用设备Data或 API Data时，请在论文 / 报告 / 出版物中标注Data来源：<strong style="color:rgba(28,167,168,.85);font-weight:600">Blue Circle Sea Turtle Tracking Platform</strong>',en:'📌 When using trial-device data or API data, please cite the source in publications: <strong style="color:rgba(28,167,168,.85);font-weight:600">Blue Circle Sea Turtle Tracking Platform</strong>'},
  /* FOOTER */
  'foot.brand':     {zh:'Blue Circle · 用Data与 AI 守护Global海洋生命。卫星追踪 · 迁徙预测 · 保护预警。',
                     en:'Blue Circle · Protecting ocean life with data and AI. Satellite tracking · Migration forecasting · Conservation alerts.'},
  'foot.p1':        {zh:'产品',            en:'Product'},
  'foot.p2':        {zh:'开发者',          en:'Developers'},
  'foot.p3':        {zh:'关于',            en:'About'},
  'foot.l1':        {zh:'Live Map 实时地图',en:'Live Map'},
  'foot.l2':        {zh:'Turtle Profiles', en:'Turtle Profiles'},
  'foot.l3':        {zh:'Research Portal', en:'Research Portal'},
  'foot.l4':        {zh:'Conservation',   en:'Conservation'},
  'foot.l5':        {zh:'API 文档',        en:'API Docs'},
  'foot.l6':        {zh:'DataDownload',        en:'Data Download'},
  'foot.l7':        {zh:'API Keys',        en:'API Keys'},
  'foot.l8':        {zh:'引用 DOI',        en:'Cite DOI'},
  'foot.l9':        {zh:'关于我们',        en:'About Us'},
  'foot.l10':       {zh:'合作机构',        en:'Partners'},
  'foot.l11':       {zh:'联系方式',        en:'Contact'},
  'foot.l12':       {zh:'隐私政策',        en:'Privacy Policy'},
  'foot.h.product': {zh:'产品',            en:'Product'},
  'foot.h.dev':     {zh:'开发者',          en:'Developers'},
  'foot.h.about':   {zh:'关于',            en:'About'},

  'nav.about':          {zh:'关于我们',        en:'About'},
  'about.eyebrow':      {zh:'关于 Blue Circle', en:'About Blue Circle'},
  'about.hero':         {zh:'致力于海洋的未来',  en:'Dedicated to the future of our oceans'},
  'about.hero.desc':    {zh:'成都智深科技有限公司创立于一个简单的信念：更好的数据带来更好的保护。我们构建帮助研究者理解和保护海洋生物的工具。', en:'Chengdu Zhishen Technology Co., Ltd was founded on a simple premise: better data leads to better conservation. We build the tools that help researchers understand and protect marine life.'},
  'about.story.title':  {zh:'我们的故事',        en:'Our story'},
  'about.story.p1':     {zh:'2018年，一群海洋生物学家和硬件工程师意识到，现有的追踪技术要么太笨重、太昂贵，要么续航不足以支撑长期海洋研究。', en:'In 2018, a group of marine biologists and hardware engineers realized that existing tracking technology was either too bulky, too expensive, or lacked the battery life needed for long-term marine studies.'},
  'about.story.p2':     {zh:'成都智深科技应运而生。我们从海龟入手，开发了一款轻量化、非侵入式的追踪器，能够承受恶劣的海洋环境，持续传输可靠数据超过一年。', en:'Chengdu Zhishen Technology Co., Ltd was born from the desire to bridge this gap. We started with a focus on sea turtles, developing a lightweight, non-invasive tracker that could withstand the harsh ocean environment while transmitting reliable data for over a year.'},
  'about.story.p3':     {zh:'如今，我们的技术已被全球顶尖研究机构采用，追踪对象不仅包括海龟，还包括鲸、海豚及其他关键海洋物种。', en:'Today, our technology is used by leading research institutions worldwide, tracking not just turtles, but whales, dolphins, and other critical marine species.'},
  'about.vision.title': {zh:'我们的愿景',        en:'Our vision'},
  'about.vision.desc':  {zh:'一个每一种濒危海洋物种都被理解、监测和保护的未来——通过可持续、非侵入式的技术，确保海洋世代繁荣。', en:'A world where every endangered marine species is understood, monitored, and protected through sustainable, non-invasive technology, ensuring thriving oceans for generations to come.'},
  'about.values.title': {zh:'核心价值观',        en:'Our core values'},
  'about.values.sub':   {zh:'指导我们工程与保护工作的原则', en:'The principles that guide our engineering and conservation efforts.'},
  'about.v1.title':     {zh:'保护',             en:'Conservation'},
  'about.v1.desc':      {zh:'我们的首要目标是保护海洋生态系统和濒危物种。', en:'Our primary goal is the protection and preservation of marine ecosystems and endangered species.'},
  'about.v2.title':     {zh:'创新',             en:'Innovation'},
  'about.v2.desc':      {zh:'我们持续推动追踪技术边界，为研究者提供更优质的数据。', en:'We continuously push the boundaries of tracking technology to provide better data for researchers.'},
  'about.v3.title':     {zh:'透明',             en:'Transparency'},
  'about.v3.desc':      {zh:'我们相信开放数据共享和协作研究，以最大化保护影响力。', en:'We believe in open data sharing and collaborative research to maximize our conservation impact.'},
  'about.v4.title':     {zh:'协作',             en:'Collaboration'},
  'about.v4.desc':      {zh:'与全球海洋生物学家、研究者和保护组织紧密合作。', en:'Working closely with marine biologists, researchers, and conservation organizations worldwide.'},
  'about.inst.title':   {zh:'联合研发机构',      en:'Joint R&D Institution'},
  'about.inst.desc':    {zh:'由海南师范大学海龟智能追踪与保护创新团队联合研发。', en:'Developed by the Sea Turtle Intelligent Tracking & Conservation Innovation Team, Hainan Normal University.'},
  'about.lab.title':    {zh:'实验室资质',        en:'Laboratory Qualification'},
  'about.lab.desc':     {zh:'国家级实验室',      en:'National-level Laboratory'},
  'about.contact.title':{zh:'联系我们',          en:'Contact'},
  'about.contact.addr': {zh:'四川省成都市成华区二仙桥东路28号和工东5号楼17层', en:'17F, Building 5, Hegongdong 28, Erxianqiao East Road, Chenghua District, Chengdu, Sichuan, China'},

  'foot.dev.api':   {zh:'API 文档',        en:'API Docs'},
  'foot.dev.data':  {zh:'DataDownload',        en:'Data Download'},
  'foot.dev.apply': {zh:'申请 API Key',    en:'Apply for API Key'},
  'foot.dev.doi':   {zh:'引用 DOI',        en:'Cite DOI'},
  'foot.about.us':  {zh:'关于我们',        en:'About Us'},
  'foot.about.partners':{zh:'合作机构',    en:'Partners'},
  'foot.about.contact':{zh:'联系：service@bluecircle.tech',en:'Contact: service@bluecircle.tech'},
  'foot.about.privacy':{zh:'隐私政策',     en:'Privacy Policy'},
  'foot.copy':      {zh:'© 2025 成都智深科技有限公司 · Blue Circle · 守护每一只海龟',en:'© 2025 Chengdu Zhishen Technology Co., Ltd · Blue Circle · Protecting every sea turtle'},
  /* LIVEMAP PAGE */
  'lm.overview':    {zh:'实时概览',        en:'Live Overview'},
  'lm.online':      {zh:'在线海龟',        en:'Online Turtles'},
  'lm.countries':   {zh:'覆盖国家',        en:'Countries'},
  'lm.km':          {zh:'累计 km',         en:'Total km'},
  'lm.alerts':      {zh:'风险预警',        en:'Risk Alerts'},
  'lm.search':      {zh:'Search turtle name or ID...', en:'Search turtle name, ID...'},
  'lm.filter.sp':   {zh:'Species筛选',        en:'Species Filter'},
  'lm.all':         {zh:'All',            en:'All'},
  'lm.f.all':       {zh:'All',            en:'All'},
  'lm.f.green':     {zh:'Green Turtle',          en:'Green'},
  'lm.f.leath':     {zh:'Leatherback',          en:'Leatherback'},
  'lm.f.hawk':      {zh:'Hawksbill',            en:'Hawksbill'},
  'lm.hawk':        {zh:'Hawksbill',            en:'Hawksbill'},
  'lm.green':       {zh:'Green Turtle',          en:'Green'},
  'lm.leath':       {zh:'Leatherback',          en:'Leatherback'},
  'lm.region':      {zh:'Region',            en:'Region'},
  'lm.r.scs':       {zh:'SCS',            en:'S. China Sea'},
  'lm.r.sulu':      {zh:'苏禄海',          en:'Sulu Sea'},
  'lm.r.echina':    {zh:'东海',            en:'East China Sea'},
  'lm.r.wpac':      {zh:'West Pacific',        en:'W. Pacific'},
  'lm.scs':         {zh:'SCS',            en:'S.China Sea'},
  'lm.layers':      {zh:'视图图层',        en:'Map Layers'},
  'lm.layer1':      {zh:'Live Tracking',        en:'Live Tracking'},
  'lm.layer2':      {zh:'AI 迁徙预测',     en:'AI Migration'},
  'lm.layer3':      {zh:'Conservation Alert Zones',      en:'Alert Zones'},
  'lm.layer4':      {zh:'Ocean Temperature Layer',      en:'Ocean Temp'},
  'lm.layer5':      {zh:'渔船Tracks',        en:'Vessel Tracks'},
  'lm.panel.list':  {zh:'实时列表',        en:'Live List'},
  'lm.panel.alert': {zh:'预警',            en:'Alerts'},
  'lm.panel.ai':    {zh:'AI预测',          en:'AI Forecast'},
  'lm.luna.lbl':    {zh:'🐢 Luna — 当前状态',en:'🐢 Luna — Current Status'},
  'lm.today':       {zh:'present日移动',        en:'Today\'s Distance'},
  'lm.bat':         {zh:'电量',            en:'Battery'},
  'lm.temp':        {zh:'水温',            en:'Water Temp'},
  'lm.risk':        {zh:'风险等级',        en:'Risk Level'},
  'lm.low':         {zh:'Low Risk',          en:'Low Risk'},
  'lm.alert.title': {zh:'⚠ High Risk预警 · Selingan',en:'⚠ High Risk Alert · Selingan'},
  'lm.alert.text':  {zh:'Sabah Turtle Islands Marine Park · Hawksbill · 信号微弱、电量 43% · 已 6 小时未上传完整Data。',en:'Sabah Turtle Islands Park · Hawksbill · weak signal, battery 43% · no full upload for 6 hours.'},
  'lm.list.lbl':    {zh:'在线海龟列表',    en:'Online Turtles'},
  'lm.scs.loc':     {zh:'西沙北岛 · 觅食洄游',en:'Xisha North Is. · foraging migration'},
  'lm.coral.loc':   {zh:'越南南部 · 长距离迁徙', en:'S. Vietnam · long migration'},
  'lm.gulf.loc':    {zh:'Sabah Turtle Islands Marine Park · 信号微弱', en:'Sabah Turtle Islands Park · weak signal'},
  'lm.scs2.loc':    {zh:'East Hainan Coast · 觅食海域',  en:'East Hainan · foraging zone'},
  'lm.hainan.loc':  {zh:'西沙北岛海域 · 觅食',en:'Xisha North Is. · foraging'},
  'lm.guam.loc':    {zh:'Papua海域 · 深潜行为',en:'Papua waters · deep diving'},
  'lm.viewdetail':  {zh:'查看档案 →',      en:'View Profile →'},
  'lm.backmap':     {zh:'返回地图',        en:'Back to Map'},
  'viz.timeline':   {zh:'Timeline Playback',      en:'Timeline Playback'},
  /* PROFILE PAGE */
  'prof.species':   {zh:'Chelonia mydas · Green Turtle',en:'Chelonia mydas · Green Sea Turtle'},
  'prof.loc':       {zh:'西沙七连屿北岛 16.97°N · 海南师范大学项目标记',en:'Beidao Is., Qilianyu, Xisha 16.97°N · Tagged by Hainan Normal University'},
  'prof.day':       {zh:'Tracking Day 189',  en:'Tracking Day 189'},
  'prof.follow':    {zh:'❤ Follow Luna',   en:'❤ Follow Luna'},
  'prof.share':     {zh:'📤 分享',          en:'📤 Share'},
  'prof.tab1':      {zh:'概览',            en:'Overview'},
  'prof.tab2':      {zh:'Tracks',            en:'Track'},
  'prof.tab3':      {zh:'AI 预测',         en:'AI Forecast'},
  'prof.tab4':      {zh:'健康状态',        en:'Health'},
  'prof.tab5':      {zh:'故事Time线',      en:'Story Timeline'},
  'prof.sc1l':      {zh:'累计游行距离',    en:'Total Distance'},
  'prof.sc1s':      {zh:'自标记以来 · 189 天',en:'Since tagging · 189 days'},
  'prof.sc2l':      {zh:'present日移动',        en:'Distance Today'},
  'prof.sc2s':      {zh:'均速 0.6 km/h',   en:'Avg 0.6 km/h'},
  'prof.sc3l':      {zh:'最近潜水深度',    en:'Latest Dive Depth'},
  'prof.sc3s':      {zh:'最大记录 47 m',   en:'Max recorded 47 m'},
  'prof.maplbl':    {zh:'📍 Current Position · Live Tracking',en:'📍 Current Location · Live'},
  'prof.maplink':   {zh:'在地图中查看 →',  en:'View on Map →'},
  'prof.barlbl':    {zh:'月度里程统计',    en:'Monthly Distance Stats'},
  'prof.bar6m':     {zh:'近6个月',         en:'Last 6 Months'},
  'prof.ai.title':  {zh:'AI 迁徙预测 — 未来 7 天',en:'AI Migration Forecast — Next 7 Days'},
  'prof.pred1d':    {zh:'Day +1–2',        en:'Day +1–2'},
  'prof.pred1l':    {zh:'西沙北岛海域 · 海草床觅食',en:'Beidao Is. waters · seagrass foraging'},
  'prof.pred2d':    {zh:'Day +3–4',        en:'Day +3–4'},
  'prof.pred2l':    {zh:'中沙群岛西部',    en:'Western Macclesfield Bank'},
  'prof.pred3d':    {zh:'Day +5–6',        en:'Day +5–6'},
  'prof.pred3l':    {zh:'East Hainan Coast近海',  en:'Hainan east coast'},
  'prof.pred4d':    {zh:'Day +7',          en:'Day +7'},
  'prof.pred4l':    {zh:'华光礁觅食区',    en:'Huaguang Reef foraging zone'},
  'prof.tl.title':  {zh:'📖 故事Time线',   en:'📖 Story Timeline'},
  'prof.tl1d':      {zh:'Day 1 · 2025-10-26',en:'Day 1 · 2025-10-26'},
  'prof.tl1ev':     {zh:'西沙七连屿北岛产卵后释放', en:'Released after nesting at Beidao, Qilianyu'},
  'prof.tl1tx':     {zh:'BC-XS-2401 设备完成校准与佩戴。Luna 完成产卵后由海南师范大学研究团队释放，曲线背甲长 98 cm，Adult雌性。',en:'BC-XS-2401 device calibrated and deployed. Luna was released by the Hainan Normal University team after nesting; curved carapace length 98 cm, adult female.'},
  'prof.tl2d':      {zh:'Day 23 · 2025-11-17',en:'Day 23 · 2025-11-17'},
  'prof.tl2ev':     {zh:'向西穿越中沙海域',en:'Crossing Macclesfield Bank westward'},
  'prof.tl2tx':     {zh:'Luna 离开七连屿后向西迁移，迁徙期日均移动约 20 km，与 Ng et al. (2018) 报道的SCSGreen Turtle洄游路径吻合。多频 GNSS 平均定位精度 ±8 m。',en:'After leaving Qilianyu, Luna migrated westward at ~20 km/day — consistent with South China Sea green turtle migration corridors reported by Ng et al. (2018). Multi-frequency GNSS fix accuracy ±8 m.'},
  'prof.tl3d':      {zh:'Day 78 · 2026-01-11',en:'Day 78 · 2026-01-11'},
  'prof.tl3ev':     {zh:'Vietnam Offshore渔船密集区告警',en:'Fishing vessel density alert near Vietnam'},
  'prof.tl3tx':     {zh:'AI 系统识别 3 km 内 8 艘活跃 AIS 渔船。BC 平台同步通知越SCS洋研究所（IO-VAST，芽庄）合作伙伴，Luna 在 14 小时内主动改变航向避开。',en:'AI detected 8 active AIS vessels within 3 km. BC platform notified the Institute of Oceanography (IO-VAST, Nha Trang). Luna altered course within 14 hours.'},
  'prof.tl4d':      {zh:'Day 142 · 2026-03-16',en:'Day 142 · 2026-03-16'},
  'prof.tl4ev':     {zh:'East Hainan Coast海草床觅食',  en:'Foraging on Hainan east-coast seagrass'},
  'prof.tl4tx':     {zh:'Luna 在Wenchang附近 19.8°N 海域驻留 18 天，潜水模式由迁移转为觅食（白天 1–4m 短潜，夜间 18–35m 长潜），符合Green Turtle典型行为模式。',en:'Luna stayed 18 days at 19.8°N near Wenchang. Diving shifted from transit to foraging (1–4 m daytime short dives, 18–35 m night dives) — typical green-turtle behavior.'},
  'prof.tl5d':      {zh:'Day 189 · present日', en:'Day 189 · Today'},
  'prof.tl5ev':     {zh:'回归西沙北岛海域',en:'Returned to Beidao waters'},
  'prof.tl5tx':     {zh:'Luna 当前位于西沙北岛附近 16.97°N, 112.32°E，电量 82%，多传感器All正常。AI 预测未来 7 天将持续在中沙—西沙海域活动。',en:'Luna is currently near Beidao at 16.97°N, 112.32°E; battery 82%, all sensors nominal. AI forecasts continued activity in the Macclesfield–Xisha area over the next 7 days.'},
  'prof.info.title':  {zh:'基本信息',      en:'Basic Info'},
  'prof.info.sp':     {zh:'Species',          en:'Species'},
  'prof.info.id':     {zh:'编号',          en:'ID'},
  'prof.info.loc':    {zh:'标记地点',      en:'Tagged At'},
  'prof.info.date':   {zh:'标记Time',      en:'Tagged Date'},
  'prof.info.days':   {zh:'追踪天数',      en:'Tracking Days'},
  'prof.info.org':    {zh:'合作机构',      en:'Partner'},
  'prof.status.title':{zh:'当前状态',      en:'Current Status'},
  'prof.status.on':   {zh:'在线状态',      en:'Status'},
  'prof.status.risk': {zh:'风险等级',      en:'Risk Level'},
  'prof.status.bat':  {zh:'设备电量',      en:'Battery'},
  'prof.status.last': {zh:'最近上传',      en:'Last Upload'},
  'prof.status.temp': {zh:'水温',          en:'Water Temp'},
  'prof.status.dep':  {zh:'当前深度',      en:'Current Depth'},
  'prof.health.title':{zh:'健康指标',      en:'Health Metrics'},
  'prof.health.1':    {zh:'活跃度',        en:'Activity Level'},
  'prof.health.2':    {zh:'摄食规律',      en:'Feeding Pattern'},
  'prof.health.3':    {zh:'信号稳定性',    en:'Signal Stability'},
  'prof.health.4':    {zh:'设备完整性',    en:'Device Integrity'},
  'prof.follow.title':{zh:'跟随 Luna',     en:'Follow Luna'},
  'prof.follow.p':    {zh:'关注 Luna 的旅程，每当她抵达新海域或触发预警时，第一Time收到通知。',en:'Follow Luna\'s journey and get notified instantly when she reaches a new ocean zone or triggers an alert.'},
  'prof.luna.sub':    {zh:'Green Turtle · 西沙→SCS觅食洄游 · Day 189',en:'Green Turtle · Xisha→SCS Foraging Migration · Day 189'},
  /* RESEARCH PAGE */
  'rsch.title':     {zh:'Data集目录',      en:'Dataset Catalog'},
  'rsch.sub':       {zh:'Dataset Catalog · 47 个公开Data集',en:'47 public datasets available'},
  'rsch.search':    {zh:'搜索Data集、Species、海域...',en:'Search datasets, species, region...'},
  'rsch.filter':    {zh:'筛选',            en:'Filter'},
  'rsch.bulk':      {zh:'批量Download',        en:'Bulk Download'},
  'rsch.all':       {zh:'All',            en:'All'},
  'rsch.track':     {zh:'TracksData',        en:'Track Data'},
  'rsch.env':       {zh:'环境Data',        en:'Env Data'},
  'rsch.green':     {zh:'Green Turtle',          en:'Green Turtle'},
  'rsch.leath':     {zh:'Leatherback',          en:'Leatherback'},
  'rsch.hawksbill': {zh:'Hawksbill',          en:'Hawksbill'},
  'rsch.total':     {zh:'284 total',     en:'284 total'},
  'rsch.overview':  {zh:'科研概览',        en:'Research Overview'},
  'rsch.ds':        {zh:'Data集总数',      en:'Total Datasets'},
  'rsch.pts':       {zh:'可DownloadTracks点',    en:'Downloadable Points'},
  'rsch.api':       {zh:'本月 API 调用',   en:'API Calls This Month'},
  'rsch.nb.data':   {zh:'Data获取',        en:'Data Access'},
  'rsch.nb.ds':     {zh:'Data集目录',      en:'Dataset Catalog'},
  'rsch.nb.dl':     {zh:'Download中心',        en:'Download Center'},
  'rsch.nb.apikey': {zh:'API Keys',        en:'API Keys'},
  'rsch.nb.tools':  {zh:'科研工具',        en:'Research Tools'},
  'rsch.nb.doi':    {zh:'引用Format DOI',    en:'Cite DOI'},
  'rsch.nb.collab': {zh:'协作项目空间',    en:'Collaboration Space'},
  'rsch.th1':       {zh:'Data集名称',      en:'Dataset Name'},
  'rsch.th2':       {zh:'Species',            en:'Species'},
  'rsch.th3':       {zh:'Region',            en:'Region'},
  'rsch.th4':       {zh:'Time范围',        en:'Time Range'},
  'rsch.th5':       {zh:'Data Volume',          en:'Volume'},
  'rsch.th6':       {zh:'Format',            en:'Format'},
  'rsch.th7':       {zh:'操作',            en:'Actions'},
  'rsch.preview':   {zh:'Preview',            en:'Preview'},
  'rsch.download':  {zh:'Download',            en:'Download'},
  'rsch.page.info': {zh:'Showing 1–7 条，284 total',en:'Showing 1–7 of 284'},
  'rsch.help.api':  {zh:'API 快速接入',    en:'Quick API Access'},
  'rsch.help.key':  {zh:'你的 API Key',    en:'Your API Key'},
  'rsch.help.ex':   {zh:'示例请求',        en:'Example Request'},
  'rsch.help.docs': {zh:'查看 API 文档 →', en:'View API Docs →'},
  'rsch.help.doi':  {zh:'引用 DOI',        en:'Cite DOI'},
  'rsch.help.proj': {zh:'协作项目',        en:'Collaboration Projects'},
  'rsch.sp.scs':    {zh:'SCS',            en:'South China Sea'},
  'rsch.sp.indo':   {zh:'印太地区',        en:'Indo-Pacific'},
  'rsch.sp.coralsea':{zh:'Vietnam Offshore',en:'Vietnam coast'},
  'rsch.sp.gulf':   {zh:'马来沙巴',        en:'Sabah, MY'},
  'rsch.sp.sea':    {zh:'SCS，爪哇海',    en:'SCS, Java Sea'},
  'rsch.sp.coast':  {zh:'SCS Coastal',        en:'SCS Coastline'},
  'rsch.sp.global': {zh:'Global',            en:'Global'},
  /* API 服务申请（科研中心 aside + main 表单） */
  'rsch.api.h':         {zh:'Data API 服务',          en:'Data API Service'},
  'rsch.api.sub':       {zh:'基础免费 · 高级付费。提供海龟Tracks、环境参数、Species统计等常用Data集。',en:'Free tier + paid tier. Includes turtle tracks, environment data, species statistics, and more.'},
  'rsch.api.free':      {zh:'基础版（免费）',          en:'Free tier'},
  'rsch.api.free.q':    {zh:'50 次/日',               en:'50/day'},
  'rsch.api.pro':       {zh:'高级版（付费）',          en:'Paid tier'},
  'rsch.api.pro.q':     {zh:'无限调用',                en:'Unlimited'},
  'rsch.api.review':    {zh:'审核周期',                en:'Review window'},
  'rsch.api.review.q':  {zh:'2–5 工作日',             en:'2–5 business days'},
  'rsch.api.btn':       {zh:'申请 API 访问 →',         en:'Apply for API Access →'},
  'rsch.api.note':      {zh:'需先注册账号 · 审核通过后获取 API Key',en:'Account registration required · API key issued after approval'},
  'rsch.apply.eyebrow': {zh:'API 申请 · API Application',en:'API Application'},
  'rsch.apply.h':       {zh:'📝 提交 API 访问申请',   en:'📝 Submit API Access Request'},
  'rsch.apply.sub':     {zh:'注册账号并提交以下信息，我们将在 2–5  business days review反馈。审核通过后将开通 API Key 并发送至您的邮箱。',en:'Register an account and submit the form below. We will review and respond within 2–5 business days. Approved applicants will receive API keys via email.'},
  'rsch.apply.datasets':{zh:'需要访问的Data类别 *（可多选）',en:'Required data categories * (multi-select)'},
  'rsch.apply.d1':      {zh:'海龟TracksData',            en:'Turtle track data'},
  'rsch.apply.d2':      {zh:'环境参数（SST · 海流）', en:'Environmental data (SST, currents)'},
  'rsch.apply.d3':      {zh:'Species统计Data',            en:'Species statistics'},
  'rsch.apply.d4':      {zh:'行为参数（潜深 · 速度）',en:'Behavioral data (dive depth, speed)'},
  'rsch.apply.d5':      {zh:'渔船 AIS 风险预警',       en:'AIS-based fishing-vessel risk alerts'},
  'rsch.apply.d6':      {zh:'迁徙预测模型 API',        en:'Migration forecast model API'},
  'rsch.apply.org':     {zh:'机构名称 *',              en:'Institution *'},
  'rsch.apply.email':   {zh:'Contact Email（机构邮箱优先）*',en:'Email (institutional preferred) *'},
  'rsch.apply.tier':    {zh:'服务等级',                en:'Service tier'},
  'rsch.apply.role':    {zh:'用户角色',                en:'User role'},
  'rsch.apply.usecase': {zh:'使用场景说明 *',          en:'Use-case description *'},
  'rsch.apply.notice':  {zh:'<strong style="color:rgba(245,158,11,.9);font-weight:600">Data来源声明义务：</strong>使用 API Data进行论文发表 / 报告 / 模型训练 / 公开展示时，请按学术规范标注：<strong style="color:#fff">Blue Circle Sea Turtle Tracking Platform</strong>。',en:'<strong style="color:rgba(245,158,11,.9);font-weight:600">Data attribution requirement:</strong> When using API data in publications, reports, model training, or public materials, please cite per academic conventions: <strong style="color:#fff">Blue Circle Sea Turtle Tracking Platform</strong>.'},
  'rsch.apply.submit':  {zh:'提交 API 申请 →',         en:'Submit API Application →'},
  'rsch.apply.alt':     {zh:'或邮件至 <a href="mailto:service@bluecircle.tech" style="color:let(--teal);text-decoration:none">service@bluecircle.tech</a>',en:'Or email <a href="mailto:service@bluecircle.tech" style="color:let(--teal);text-decoration:none">service@bluecircle.tech</a>'},
  /* CONSERVATION PAGE */
  'con.title':      {zh:'保护行动后台', en:'🛡 Conservation Portal'},
  'con.sub':        {zh:'Conservation Portal · 实时风险监控与保护响应',en:'Real-time risk monitoring & conservation response'},
  'con.kpi1':       {zh:'High Risk海龟数量',  en:'High-Risk Turtles'},
  'con.kpi1t':      {zh:'↑ present日新增 1',   en:'↑ +1 today'},
  'con.kpi2':       {zh:'present日预警总数',    en:'Alerts Today'},
  'con.kpi2t':      {zh:'↓ 较昨日减少 3', en:'↓ -3 vs yesterday'},
  'con.kpi3':       {zh:'活跃热点Region',    en:'Active Hotspots'},
  'con.kpi3t':      {zh:'↑ 本周 +2',      en:'↑ +2 this week'},
  'con.kpi4':       {zh:'本月已响应事件',  en:'Events Responded'},
  'con.kpi4t':      {zh:'↑ 响应率 94%',   en:'↑ 94% response rate'},
  'con.alertlist':  {zh:'风险预警列表',    en:'Risk Alert List'},
  'con.viewall':    {zh:'查看All',        en:'View All'},
  'con.a1.title':   {zh:'Selingan 信号断续 · 设备电量危急',en:'Selingan signal intermittent · battery critical'},
  'con.a1.sub':     {zh:'Sabah Turtle Islands Marine Park · Hawksbill Hawksbill · 电量 43% · 已 6 小时未上传完整Data',en:'Sabah Turtle Islands Park · Hawksbill · battery 43% · no full upload for 6 hours'},
  'con.a2.title':   {zh:'Côn Đảo 进入越南渔船密集作业带',en:'Côn Đảo entered dense Vietnamese fishing zone'},
  'con.a2.sub':     {zh:'越南南部巴地头顿省海域 · Leatherback Leatherback · 半径 3 km 内 11 艘活跃 AIS 渔船',en:'Bà Rịa–Vũng Tàu, S. Vietnam · Leatherback · 11 active AIS vessels within 3 km'},
  'con.a3.title':   {zh:'SCS中部 SST 较气候态偏高',en:'Central SCS SST above climatology'},
  'con.a3.sub':     {zh:'15°N–18°N, 112°E–115°E · 海面温度 30.6°C · 较 5 月气候态 29.5°C +1.1°C · 觅食海草床受影响',en:'15°N–18°N, 112°E–115°E · SST 30.6°C · +1.1°C above May climatology of 29.5°C · seagrass foraging affected'},
'con.a4.title':   {zh:'Wenchang 与琼州海峡航线邻近',en:'Wenchang crossing Qiongzhou Strait shipping lane'},
  'con.a4.sub':     {zh:'East Hainan Coast 19.8°N · Green Turtle Green · AIS Showing 4 艘货轮 8 小时内将通过同Region',en:'Hainan east coast 19.8°N · Green Turtle · AIS shows 4 cargo ships entering same area within 8 h'},
  'con.a5.title':   {zh:'Wangan 设备电量低于 75% 阈值',en:'Wang-an device battery below 75% threshold'},
  'con.a5.sub':     {zh:'Wangan Island, Penghu · Green Turtle Green · 电量 71% · 太阳能补给较低',en:'Wang-an Is., Penghu, Taiwan · Green Turtle · battery 71% · low solar charging'},
  'con.respond':    {zh:'立即响应',        en:'Respond'},
  'con.map.title':  {zh:'SCS非法捕捞与碰撞风险热点',en:'SCS Illegal Fishing & Collision Risk Hotspots'},
  'con.fullscreen': {zh:'全屏 →',          en:'Full Screen →'},
  'con.trend.title':{zh:'过去 30 天预警趋势',en:'30-Day Alert Trend'},
  'con.trend.avg':  {zh:'日均 8.2 次',     en:'Daily avg 8.2'},
  'con.sp.title':   {zh:'Species风险状态',    en:'Species Risk Status'},
  'con.vessel.title':{zh:'船舶碰撞风险分析',en:'Vessel Collision Risk'},
  'con.report.title':{zh:'自动报告中心',   en:'Auto Report Center'},
  'con.protect.title':{zh:'临时MPA Recommendations',en:'Proposed Protected Zones'},
  'con.rep1':       {zh:'2025年1月保护月报',en:'Jan 2025 Conservation Report'},
  'con.rep2':       {zh:'SCS捕捞热点分析',en:'SCS Fishing Hotspot Analysis'},
  'con.rep3':       {zh:'临时MPA Recommendations方案',en:'Proposed Protected Zone Plan'},
  'con.rep4':       {zh:'AI 风险预测周报', en:'AI Risk Forecast Weekly'},
  'con.rep.gen':    {zh:'已生成',          en:'Generated'},
  'con.rep.pend':   {zh:'待审核',          en:'Pending Review'},
  'con.pb1.title':  {zh:'SCS东部保护区',  en:'Eastern SCS Protected Zone'},
  'con.pb1.detail': {zh:'范围：115°E–118°E, 15°N–18°N\n期限：2025-01-30 — 2025-02-28\n保护海龟：6 只',en:'Range: 115°E–118°E, 15°N–18°N\nTerm: 2025-01-30 — 2025-02-28\nProtected turtles: 6'},
  'con.pb2.title':  {zh:'SCS北部缓冲区',  en:'Northern SCS Buffer Zone'},
  'con.pb2.detail': {zh:'范围：110°E–115°E, 18°N–22°N\n期限：2025-02-01 — 2025-03-15\n保护海龟：3 只',en:'Range: 110°E–115°E, 18°N–22°N\nTerm: 2025-02-01 — 2025-03-15\nProtected turtles: 3'},
  'con.submit':     {zh:'提交申请',        en:'Submit Application'},
  'con.viewmap':    {zh:'查看地图',        en:'View Map'},
  'con.lv.danger':  {zh:'危险',            en:'Danger'},
  'con.lv.watch':   {zh:'关注',            en:'Watch'},
  'con.lv.safe':    {zh:'安全',            en:'Safe'},
  'con.follow':     {zh:'跟进',            en:'Follow Up'},
  'con.contact':    {zh:'联系',            en:'Contact'},
  'con.rpt':        {zh:'报告',            en:'Report'},
  'con.mark':       {zh:'标注',            en:'Mark'},
  'con.apply':      {zh:'申请',            en:'Apply'},
  'con.ignore':     {zh:'忽略',            en:'Ignore'},
  'con.recover':    {zh:'回收',            en:'Recover'},
  'con.notify':     {zh:'通知',            en:'Notify'},

  /* COMPANY NAME (formal) */
  'brand.company':    {zh:'成都智深科技有限公司', en:'Chengdu Zhishen Technology Co., Ltd'},
  /* HARDWARE PAGE */
  'hw.engineered':    {zh:'⚓ 为海洋而生',         en:'⚓ Built for the Ocean'},
  'hw.hero.eyebrow':  {zh:'为海洋而生 · Engineered for the Ocean', en:'Engineered for the Ocean'},
  'hw.hero.h1':       {zh:'TT 系列<em>追踪硬件</em>家族', en:'The TT Series<br><em>Hardware Lineup</em>'},
  'hw.hero.p':        {zh:'TT 系列是多年来与Global领先的海龟生物学家共同研发的成果。专为各种海龟Species、栖息地和研究阶段的Real野外条件而设计，从超轻型幼体到全尺寸研究级模型，TT 系列为每一个研究阶段提供量身定制的解决方案。',
                       en:'The TT Series represents the culmination of years of collaborative development with leading marine biologists. Designed specifically as long-term field tracking devices, these units provide conservation and research teams with the in-field data needed to understand and protect marine turtle populations. From ultra-lightweight models for hatchlings to comprehensive research-scale platforms for adults, the TT Series offers a tailored solution for every stage of research.'},
  'hw.lineup.eyebrow':{zh:'产品矩阵 · The TT Series Lineup', en:'The TT Series Lineup'},
  'hw.lineup.h2a':    {zh:'为研究需求',             en:'A Tracker For'},
  'hw.lineup.h2b':    {zh:'量身打造的平台',          en:'Every Mission'},
  'hw.lineup.sub':    {zh:'为您的项目和研究需求选择合适的 Blue Circle 平台', en:'Select the right Blue Circle platform for your project and research requirements.'},
  /* L1 */
  'hw.l1.tag':        {zh:'入门级',                en:'Entry Level'},
  'hw.l1.soon':       {zh:'即将推出',              en:'Coming Soon'},
  'hw.l1.desc':       {zh:'超轻型追踪器，专为Adult和幼龟设计。提供基础卫星定位，覆盖关键栖息地。',
                       en:'Ultra-lightweight tracker specifically engineered for hatchlings and juvenile turtles. Minimum hydrodynamic drag, providing essential location data.'},
  'hw.l1.s1':         {zh:'超轻设计',              en:'Ultra Light'},
  'hw.l1.s2':         {zh:'卫星 GPS',              en:'Sat GPS'},
  'hw.l1.s3':         {zh:'紧凑体积',              en:'Compact'},
  'hw.l1.s4':         {zh:'环氧固定',              en:'Epoxy Mount'},
  /* L2 */
  'hw.l2.tag':        {zh:'中型Adult',              en:'Mid-Sized Adult'},
  'hw.l2.desc':       {zh:'适用于长距离迁徙追踪的Adult平衡型号，搭载长寿命电池，专为中型成龟而设计。',
                       en:'The standard for long-term migration tracking. Balanced battery life with high-frequency data transmission for adult marine turtles.'},
  'hw.l2.s1':         {zh:'长续航',                en:'Long Battery'},
  'hw.l2.s2':         {zh:'GPS+Argos',             en:'GPS+Argos'},
  'hw.l2.s3':         {zh:'深度记录',              en:'Depth Logger'},
  'hw.l2.s4':         {zh:'温度传感',              en:'Temp Sensor'},
  /* L3 */
  'hw.l3.tag':        {zh:'大型Adult',              en:'Large Adult'},
  'hw.l3.desc':       {zh:'大型成龟监测器，配备先进的环境传感器和实时Data回传。专为最严苛的现场科研部署而打造。',
                       en:'Heavy-duty adult-grade tracker equipped with advanced environmental sensors and live data transmission. Built for harsh deployments.'},
  'hw.l3.s1':         {zh:'太阳能充电',            en:'Solar Charge'},
  'hw.l3.s2':         {zh:'多传感器',              en:'Multi-Sensor'},
  'hw.l3.s3':         {zh:'实时回传',              en:'Live Telemetry'},
  'hw.l3.s4':         {zh:'深度防水',              en:'Deep Waterproof'},
  /* L4 */
  'hw.l4.tag':        {zh:'高性能',                en:'High Performance'},
  'hw.l4.desc':       {zh:'高端旗舰：液压外壳搭配长寿命电池组，专为综合行为Data集和精细动作研究而设计。',
                       en:'Premium-grade housing with long-life battery for comprehensive behavioral datasets and fine-motion analytics.'},
  'hw.l4.s1':         {zh:'超长续航',              en:'Ext. Battery'},
  'hw.l4.s2':         {zh:'9 轴运动传感',          en:'9-Axis IMU'},
  'hw.l4.s3':         {zh:'可重构固件',            en:'Custom Firmware'},
  'hw.l4.s4':         {zh:'水下高保真',            en:'HD Underwater'},
  /* L5 */
  'hw.l5.tag':        {zh:'可回收',                en:'Recoverable'},
  'hw.l5.desc':       {zh:'为高分辨率短期任务设计的专门可回收型号，可释放后通过遥控指令在水面浮起回收。',
                       en:'Specialized recoverable model for high-resolution short-term missions. Releases on remote command and floats for retrieval.'},
  'hw.l5.s1':         {zh:'声学释放',              en:'Acoustic Release'},
  'hw.l5.s2':         {zh:'VHF 信标',              en:'VHF Beacon'},
  'hw.l5.s3':         {zh:'高频采样',              en:'HD Sampling'},
  'hw.l5.s4':         {zh:'多次部署',              en:'Multi-Deploy'},
  /* Custom */
  'hw.custom.tag':    {zh:'定制开发',              en:'Custom Development'},
  'hw.custom.name':   {zh:'定制方案',              en:'Custom Solution'},
  'hw.custom.desc':   {zh:'需要为特定Species或研究目的定制？我们的工程团队能从硬件到固件提供端到端定制服务。',
                       en:'Need a tracker tailored to a specific species or research goal? Our engineering team delivers end-to-end customization from hardware to firmware.'},
  'hw.custom.s1':     {zh:'联系工程团队',          en:'Contact Engineering'},
  /* CTA buttons */
  'hw.nav.trial':     {zh:'申请免费试用',        en:'Apply for Free Trial'},
  'hw.cta.spec':      {zh:'索取规格书',            en:'Request Specs'},
  'hw.cta.contact':   {zh:'咨询定制',              en:'Inquire'},
  /* Free Trial Application */
  'hw.trial.eyebrow': {zh:'免费试用 · Free Trial Program',en:'Free Trial Program'},
  'hw.trial.h2a':     {zh:'免费申请',              en:'Apply for'},
  'hw.trial.h2b':     {zh:'1–2 台设备 · 1–3 个月Data服务',en:'1–2 Devices · 1–3 Months of Data Service'},
  'hw.trial.h2':      {zh:'<span>免费申请</span><em>1–2 台设备 · 1–3 个月Data服务</em>',en:'<span>Apply for</span><em>1–2 Devices · 1–3 Months of Data Service</em>'},
  'hw.trial.p':       {zh:'面向高校、科研机构、保护区等合法机构开放。审核通过后免费寄送 TT 系列设备，Data自动回传至 Blue Circle 平台。',en:'Open to universities, research institutes, protected areas, and other legitimate organizations. Approved applicants receive TT-series devices free of charge, with data streamed automatically to the Blue Circle platform.'},
  'hw.trial.cond.h':  {zh:'申请条件',              en:'Eligibility'},
  'hw.trial.cond.1':  {zh:'合法机构主体（高校 / 科研院所 / 自然保护区 / NGO 等）',en:'Legitimate institutional applicant (university / research institute / nature reserve / NGO, etc.)'},
  'hw.trial.cond.2':  {zh:'明确的研究 / 保护项目目标与海域范围',en:'Clear research or conservation objectives and target sea area'},
  'hw.trial.cond.3':  {zh:'具备海上作业 / Turtle Markers的合规资质或合作方',en:'Holds — or partners with — entities authorized to conduct sea-turtle tagging at sea'},
  'hw.trial.cond.4':  {zh:'承诺在论文 / 报告中标注Data来源 Blue Circle',en:'Commits to citing Blue Circle as the data source in publications / reports'},
  'hw.trial.flow.h':  {zh:'申请流程',              en:'Application Flow'},
  'hw.trial.flow.1t': {zh:'提交申请表',            en:'Submit application'},
  'hw.trial.flow.1d': {zh:'填写机构信息与项目简介',en:'Provide institutional info and project brief'},
  'hw.trial.flow.2t': {zh:'2–5 工作日审核',        en:'2–5 business-day review'},
  'hw.trial.flow.2d': {zh:'工程团队评估匹配的设备型号',en:'Engineering team matches the right device model'},
  'hw.trial.flow.3t': {zh:'设备寄送 · 平台开通',   en:'Devices shipped · platform activated'},
  'hw.trial.flow.3d': {zh:'Data自动回传，无需手动上传',en:'Data streams automatically — no manual upload required'},
  'hw.trial.form.h':  {zh:'📝 提交试用申请',       en:'📝 Submit Trial Application'},
  'hw.trial.form.sub':{zh:'回执将发送至下方邮箱 · 通常 2–5 个工作日内反馈',en:'A confirmation will be sent to your email · typical response within 2–5 business days'},
  'hw.trial.form.org':{zh:'机构名称 *',            en:'Institution *'},
  'hw.trial.form.contact':{zh:'联系人 / 职位 *',   en:'Contact name / title *'},
  'hw.trial.form.email':{zh:'Contact Email *',          en:'Email *'},
  'hw.trial.form.phone':{zh:'联系电话',            en:'Phone'},
  'hw.trial.form.species':{zh:'海龟Species *',        en:'Target species *'},
  'hw.trial.form.devices':{zh:'期望设备型号',      en:'Preferred device model'},
  'hw.trial.form.qty':{zh:'申请数量',              en:'Quantity'},
  'hw.trial.form.duration':{zh:'期望试用时长',     en:'Trial duration'},
  'hw.trial.form.brief':{zh:'项目简介 *',          en:'Project brief *'},
  'hw.trial.form.notice':{zh:'<strong style="color:rgba(245,158,11,.9);font-weight:600">Data来源声明义务：</strong>试用期内所有设备Data将自动回传至 Blue Circle 平台。在使用相关Data进行论文发表 / 报告 / 公开展示时，请按学术规范标注Data来源：<strong style="color:#fff">Blue Circle Sea Turtle Tracking Platform</strong>。',en:'<strong style="color:rgba(245,158,11,.9);font-weight:600">Data attribution requirement:</strong> All device data during the trial is automatically uploaded to the Blue Circle platform. When using such data in publications, reports, or public presentations, please cite the source per academic conventions: <strong style="color:#fff">Blue Circle Sea Turtle Tracking Platform</strong>.'},
  'hw.trial.form.submit':{zh:'提交申请 →',          en:'Submit Application →'},
  'hw.trial.form.alt':{zh:'或发送邮件至 <a href="mailto:service@bluecircle.tech" style="color:let(--teal);text-decoration:none">service@bluecircle.tech</a> 直接咨询',en:'Or email <a href="mailto:service@bluecircle.tech" style="color:let(--teal);text-decoration:none">service@bluecircle.tech</a> directly'},
  /* Capabilities */
  'hw.cap.eyebrow':   {zh:'核心能力 · Core Capabilities', en:'Core Capabilities'},
  'hw.cap.h2':        {zh:'坚固耐用、流体动力学外壳中的尖端技术', en:'Advanced technology packed into rugged, hydrodynamic enclosures.'},
  'hw.cap.sub':       {zh:'为严苛的水下环境精心打造',  en:'Built for the harshest underwater environments.'},
  'hw.cap.1t':        {zh:'超轻设计',              en:'Ultra-Light Design'},
  'hw.cap.1p':        {zh:'液压成型外壳起步仅 35g，确保对自然行为的最小干扰，无负担地长期跟随研究对象。',
                       en:'Hydroformed housing starts at 35 g, ensuring minimal interference with natural behaviour over long deployments.'},
  'hw.cap.2t':        {zh:'快速定位',              en:'Fast Positioning'},
  'hw.cap.2p':        {zh:'先进的多频 GNSS 技术结合短曝光定位，海龟仅需短暂浮出水面即可获得高精度定位。',
                       en:'Advanced multi-band GNSS combined with snapshot positioning means turtles need only brief surface exposure for high-accuracy fixes.'},
  'hw.cap.3t':        {zh:'多传感监测',            en:'Multi-Sensor Monitoring'},
  'hw.cap.3p':        {zh:'集成深度、温度、3 轴加速度计与陀螺仪，提供全面的行为Data视图，洞察水下生态。',
                       en:'Integrated depth, temperature, and 9-axis IMU provide a complete picture of behavioural ecology underwater.'},
  'hw.cap.4t':        {zh:'长效续航',              en:'Long Battery Life'},
  'hw.cap.4p':        {zh:'智能电源管理与高密度电池组合，根据部署场景可达 12-48 个月的工作时长。',
                       en:'Smart power management plus high-density cells deliver 12 to 48 months of operation depending on the deployment profile.'},
  'hw.cap.5t':        {zh:'灵活互联',              en:'Flexible Connectivity'},
  'hw.cap.5p':        {zh:'无缝集成 Iridium 卫星、Argos 与Global蜂窝网络，确保Data上传无死角，覆盖Global海域。',
                       en:'Seamless integration of Iridium satellite, Argos, and global cellular networks ensures data uploads from anywhere in the world.'},
  'hw.cap.6t':        {zh:'可定制部署',            en:'Customizable Deployment'},
  'hw.cap.6p':        {zh:'可根据研究需求灵活定制采样频率、Data回传策略和触发条件，最大化电池寿命。',
                       en:'Sampling rate, data uplink schedule, and trigger conditions are all configurable per study, maximising battery life.'},
  'hw.cap.7t':        {zh:'可回收型号',            en:'Recoverable Models'},
  'hw.cap.7p':        {zh:'可选的声学释放机制配合 VHF 信标，让设备在高分辨率任务结束后高效回收，重复利用。',
                       en:'Optional acoustic release mechanisms with VHF beacons allow efficient recovery of high-resolution mission units.'},
  /* Field cases */
  'hw.field.eyebrow': {zh:'实战验证 · Proven in the Field', en:'Proven in the Field'},
  'hw.field.h2a':     {zh:'来自Global科研机构的',    en:'Trusted by Research'},
  'hw.field.h2b':     {zh:'Real任务验证',          en:'Institutions Worldwide'},
  'hw.field.p':       {zh:'我们的硬件正在被Global数十家顶级海洋研究机构和保护组织使用，覆盖从迁徙追踪到Critical救援的完整研究场景。',
                       en:'Our hardware is trusted by institutions worldwide, deployed across the full spectrum of marine turtle conservation research.'},
  'hw.field.cta':     {zh:'查看案例研究 →',        en:'View Case Studies →'},
  'hw.case.1t':       {zh:'野外科研',              en:'Field Research'},
  'hw.case.1p':       {zh:'收集高分辨率时空Data，支持学术研究和生态系统建模。',
                       en:'Collect high-resolution spatiotemporal data to support academic research and ecosystem modelling.'},
  'hw.case.2t':       {zh:'保护项目',              en:'Conservation Programs'},
  'hw.case.2p':       {zh:'监测濒危Species群体的健康状况，制定基于Data的保护行动方案。',
                       en:'Monitor the success of rehabilitation and release programs with credible, peer-reviewed evidence.'},
  'hw.case.3t':       {zh:'迁徙追踪',              en:'Migration Tracking'},
  'hw.case.3p':       {zh:'绘制海龟从筑巢沙滩到觅食场的完整迁徙路线，揭示长距离行为模式。',
                       en:'Map turtle paths from nesting beaches to foraging grounds to inform the establishment of marine protected zones.'},
  'hw.case.4t':       {zh:'应急响应',              en:'Emergency Response'},
  'hw.case.4p':       {zh:'救援、康复后追踪与应急部署，快速重建受困个体的回归路径。',
                       en:'Deploy rescued individuals and track stranding, entanglement, or rapid-deployment scenarios.'},
};

// ═══════════════════════════════════════════
//  API LAYER — fetch from backend, fallback to static
// ═══════════════════════════════════════════
let API_BASE = '';  // Set in init or by deployment
let apiReady = false;


// [NEXT-REFACTOR] Extract _addTurtleMarkers(map, turtles, tracks) 
// from duplicate code in initHeroMap/initLiveMap/initConMaps (~40 lines × 3)
function apiInit(baseUrl){
  API_BASE = baseUrl || '';
  apiReady = true;
}

async function apiFetch(path){
  // Avoid double /api/v1 prefix when API_BASE is set
  if(API_BASE && path.indexOf("/api/v1")===0) path = path.replace("/api/v1","");
  let url = API_BASE + path;
  try {
    let resp = await fetch(url);
    if(!resp.ok) throw new Error('API ' + resp.status);
    return await resp.json();
  } catch(e){
    console.warn('API fetch failed ('+url+'), falling back to static:', e.message);
    return null;
  }
}

async function loadTurtlesFromApi(){
  let data = await apiFetch('/api/v1/turtles/?limit=200');
  if(data && data.items && data.items.length > 0){
return data.items.map(function(t){
      let spColor = '#1CA7A8';
      if(t.species.indexOf('棱')>=0 || t.species.indexOf('Leatherback')>=0) spColor='#FF7F50';
      else if(t.species.indexOf('玳')>=0 || t.species.indexOf('Hawksbill')>=0) spColor='#ef4444';
      else if(t.species.indexOf('蠵')>=0) spColor='#f59e0b';
      return {
        id: t.id, name: t.name, nameEn: t.name_en || t.name,
        sp: t.species, spEn: t.species_en || t.species,
        lat: t.lat||0, lng: t.lng||0,
        bat: t.battery_pct||0, spd: t.speed_kmh||0, dep: t.depth_m||0,
        risk: t.risk_level||'low', color: spColor,
        origin: t.origin||'', originEn: t.origin_en||'',
        cclen: t.carapace_length_cm||0,
        sex: t.sex||'U', age: t.age_class||'Adult',
        photo: t.photo_url||''
      };
    });
  }
  return null;
}

async function loadDatasetsFromApi(){
  let data = await apiFetch('/api/v1/datasets/?page_size=50');
  if(data && data.items && data.items.length > 0){
return data.items.map(function(d){
      return {
        id: d.id, name: d.name, sub: d.subtitle||'',
        sp: d.species||'', region: d.region||'',
        period: d.period||'', data: d.data_scope||'',
        fmts: d.formats||[], cat: d.category||'track'
      };
    });
  }
  return null;
}

// ── Phase 3: Track Points ──
let tracksLoaded = false;
async function loadTracksFromApi(){
  if(tracksLoaded) return;
  tracksLoaded = true;
for(let i=0; i<TURTLES.length; i++){
    let tid = TURTLES[i].id;
    try {
      let resp = await fetch(API_BASE+'/turtles/'+tid+'/tracks?page_size=500');
      if(!resp.ok) continue;
      let data = await resp.json();
      if(data.items && data.items.length){
        TRACKS[tid] = data.items.map(function(p){ return [p.lat, p.lng]; });
}
    } catch(e){}
  }
// Refresh maps
  if(window.trackingLayer) refreshLiveMapMarkers();
}

// ── Phase 3: WebSocket Live Tracking ──
let ws = null;
function connectLiveTracking(){
  if(ws) return;
  try {
    let wsUrl = (location.protocol==='https:'?'wss:':'ws:')+'//'+location.host+'/ws';
    ws = new WebSocket(wsUrl);
    ws.onopen = function(){
};
    ws.onmessage = function(event){
      let msg = JSON.parse(event.data);
      if(msg.type==='connected'){
} else if(msg.type==='positions' && msg.data){
        for(let i=0; i<msg.data.length; i++){
          let p = msg.data[i];
          for(let j=0; j<TURTLES.length; j++){
            if(TURTLES[j].id===p.turtle_id){
              TURTLES[j].lat=p.lat; TURTLES[j].lng=p.lng;
              TURTLES[j].bat=p.battery_pct; TURTLES[j].spd=p.speed_kmh; TURTLES[j].dep=p.depth_m;
              break;
            }
          }
        }
        if(window.trackingLayer && window._lmInit) refreshLiveMapMarkers();
      }
    };
    ws.onclose = function(){
ws=null; setTimeout(connectLiveTracking,10000); };
    ws.onerror = function(){};
  } catch(e){
}
}

function refreshLiveMapMarkers(){
  if(!window.trackingLayer) return;
  window.trackingLayer.clearLayers();
  TURTLES.forEach(function(turtle){
    let pulse = turtle.risk==='high' ? 'animation:warn-ring 1s ease-out infinite;' : '';
    let dotHtml = '<div style=\"position:relative;width:16px;height:16px\"><div style=\"width:16px;height:16px;border-radius:50%;background:'+turtle.color+';border:2.5px solid rgba(255,255,255,.9);box-shadow:0 0 12px '+turtle.color+'99;'+pulse+'\"></div></div>';
    let icon = L.divIcon({className:'',html:dotHtml,iconSize:[16,16],iconAnchor:[8,8]});
    L.marker([turtle.lat,turtle.lng],{icon:icon}).addTo(window.trackingLayer).bindPopup(makePopup(turtle),{maxWidth:200});
    if(TRACKS[turtle.id]) L.polyline(TRACKS[turtle.id],{color:turtle.color,weight:2,opacity:.55,dashArray:'6,5'}).addTo(window.trackingLayer);
  });
}

async function initApiData(){
  // Phase 1+2: Load turtles + datasets
  let apiTurtles = await loadTurtlesFromApi();
  if(apiTurtles){
    let apiIds = {};
    apiTurtles.forEach(function(t){ apiIds[t.id]=true; });
    let staticRemaining = TURTLES.filter(function(t){ return !apiIds[t.id]; });
    TURTLES = apiTurtles.concat(staticRemaining);
    // Re-sync currentProfileTurtle after array reassignment (API may reorder)
    if(typeof currentProfileTurtle !== 'undefined' && currentProfileTurtle){
      let _reRef = TURTLES.find(function(_x){ return _x.id === currentProfileTurtle.id; });
      if(_reRef) currentProfileTurtle = _reRef;
    }
  }
  let apiDatasets = await loadDatasetsFromApi();
  if(apiDatasets){
    let apiIds2 = {};
    apiDatasets.forEach(function(d){ apiIds2[d.id]=true; });
    let staticRemaining2 = RSCI_DATA.filter(function(d){ return !apiIds2[d.id]; });
    RSCI_DATA = apiDatasets.concat(staticRemaining2);
  }
  // Phase 3: Tracks + WebSocket (non-blocking)
  loadTracksFromApi();
  connectLiveTracking();
}

function i18n(key){
  return (T[key] && T[key][LANG]) || key;
}

function setLang(lang){
  LANG = lang;
  document.documentElement.className = document.documentElement.className
    .replace(/lang-\w+/g,'') + ' lang-' + lang;
  document.querySelectorAll('[id^="btn-"]').forEach(b=>{
    b.classList.toggle('active', b.id === 'btn-' + lang);
  });
  renderAllText(lang);
  localStorage.setItem('tt_lang', lang);
  // toggle hero h1 zh/en
  let h1zh = document.getElementById('hero-h1-zh');
  let h1en = document.getElementById('hero-h1-en');
  if(h1zh) h1zh.style.display = lang==='zh' ? 'block' : 'none';
  if(h1en) h1en.style.display = lang==='en' ? 'block' : 'none';
  // update search placeholder
  let si = document.getElementById('lm-search-input');
  if(si) si.placeholder = lang==='zh' ? 'Search turtle name or ID...' : 'Search turtle name, ID...';
}

function renderAllText(lang){
  lang = lang || LANG;
  document.querySelectorAll('[data-t]').forEach(el=>{
    const key = el.getAttribute('data-t');
    if(T[key]) el.textContent = T[key][lang];
  });
  document.querySelectorAll('[data-t-html]').forEach(el=>{
    const key = el.getAttribute('data-t-html');
    if(T[key]) el.innerHTML = T[key][lang];
  });
  // special: live pill online count
  document.querySelectorAll('[data-t-after]').forEach(el=>{
    const key = el.getAttribute('data-t-after');
    if(T[key]) el.setAttribute('data-after-text', T[key][LANG]);
  });
  // update live pill suffix
  document.querySelectorAll('.live-pill-suffix').forEach(el=>{
    el.textContent = ' ' + i18n('nav.online');
  });
  // update activity feed
  if(document.getElementById('activity-feed')){
    buildFeed();
  }
}

// ── ROUTING ──
function goTo(page, turtleId){
  document.querySelectorAll('.page').forEach(p=>p.classList.remove('active'));
  const el=document.getElementById('page-'+page);
  el.classList.add('active');
  const scroll=el.querySelector('.page-scroll');
  if(scroll) scroll.scrollTop=0;
  // turtle routing
  if(page==='profile'){
    profileTurtleParam = turtleId||null;
    if(profileTurtleParam){
      let t = TURTLES.find(function(x){return x.id===profileTurtleParam});
      if(t) switchProfileTurtle(t);
    }
    buildProfileTurtleDropdown();
    // Set default avatar
    let av = document.getElementById('prof-avatar');
    if(av && !profileTurtleParam) av.src = (currentProfileTurtle && currentProfileTurtle.photo) || '';
    if(!window._profInit) initProfileMap();
  }
  // re-apply translations after page switch
  renderAllText();
  // init maps on demand
  if(page==='register') return;
  if(page==='livemap' && !window._lmInit) initLiveMap();
  if(page==='conservation' && !window._conInit) initConMaps();
  if(page==='research') initRsch();
}

// ── TURTLE DATA (South China Sea focused) ──
let TURTLES = [
  // Greens — Xisha rookery origin, foraging in SCS / Hainan / Vietnam coast
  {id:'BC-XS-2401',name:'Luna',nameEn:'Luna',sp:'Green Turtle',spEn:'Green',lat:16.97,lng:112.32,bat:82,spd:0.6,dep:14,risk:'low',color:'#1CA7A8',origin:'Qilianyu North Island, Xisha',originEn:'Qilianyu North Is., Xisha',cclen:98,sex:'F',age:'Adult',photo:'/img/turtles/BC-xs-2401.png'},
  {id:'BC-HD-2412',name:'Huidong',nameEn:'Huidong',sp:'Green Turtle',spEn:'Green',lat:22.55,lng:114.89,bat:91,spd:1.8,dep:9,risk:'low',color:'#1CA7A8',origin:'Huidong, Guangdong',originEn:'Huidong, Guangdong',cclen:104,sex:'F',age:'Adult',photo:'/img/turtles/bc-hd-2412.png'},
  {id:'BC-HN-2418',name:'Wenchang',nameEn:'Wenchang',sp:'Green Turtle',spEn:'Green',lat:19.85,lng:111.20,bat:77,spd:2.1,dep:18,risk:'low',color:'#1CA7A8',origin:'East Hainan Coast',originEn:'East Hainan',cclen:62,sex:'M',age:'Subadult',photo:'/img/turtles/bc-hn-2418.jpg'},
  {id:'BC-XS-2421',name:'Pearl',nameEn:'Pearl',sp:'Green Turtle',spEn:'Green',lat:17.10,lng:112.45,bat:77,spd:1.6,dep:22,risk:'low',color:'#1CA7A8',origin:'Xisha North Island',originEn:'Xisha North Is.',cclen:101,sex:'F',age:'Adult',photo:'/img/turtles/BC-XS-2421.png'},
  {id:'BC-PH-2425',name:'Palawan',nameEn:'Palawan',sp:'Green Turtle',spEn:'Green',lat:10.32,lng:118.74,bat:65,spd:2.4,dep:22,risk:'low',color:'#1CA7A8',origin:'Palawan, Philippines',originEn:'Palawan, PH',cclen:95,sex:'F',age:'Adult',photo:'/img/turtles/bc-ph-2425.png'},
  {id:'BC-RY-2429',name:'Ryukyu',nameEn:'Ryukyu',sp:'Green Turtle',spEn:'Green',lat:24.51,lng:124.18,bat:79,spd:2.0,dep:16,risk:'low',color:'#1CA7A8',origin:'Ryukyu Islands',originEn:'Ryukyu Is.',cclen:88,sex:'F',age:'Adult',photo:'/img/turtles/bc-ry-2429.png'},
  // Green Turtles — Con Dao, VN nesting
  {id:'BC-CD-2304',name:'Côn Đảo',nameEn:'Côn Đảo',sp:'Green Turtle',spEn:'Green',lat:8.71,lng:106.61,bat:62,spd:2.0,dep:22,risk:'low',color:'#1CA7A8',origin:'Con Dao, Vietnam',originEn:'Côn Đảo, VN',cclen:100,sex:'F',age:'Adult',photo:'/img/turtles/bc-cd-2304.jpg'},
  {id:'BC-PG-2307',name:'Papua',nameEn:'Papua',sp:'Leatherback',spEn:'Leatherback',lat:-3.50,lng:135.42,bat:58,spd:3.1,dep:412,risk:'high',color:'#FF7F50',origin:'Papua',originEn:'Papua',cclen:155,sex:'F',age:'Adult',photo:'/img/turtles/bc-pg-2307.png'},
  // Loggerhead — rare in SCS region; not the dominant species at Wang-an
  {id:'BC-PH-2311',name:'Wangan',nameEn:'Wang-an',sp:'Green Turtle',spEn:'Green',lat:23.37,lng:119.50,bat:71,spd:1.9,dep:24,risk:'med',color:'#1CA7A8',origin:'Wangan Island, Penghu',originEn:'Wang-an Is., Penghu, TW',cclen:96,sex:'F',age:'Adult',photo:'/img/turtles/bc-ph-2311.jpg'},
  // Hawksbill — Critically Endangered
  {id:'BC-SB-2315',name:'Selingan',nameEn:'Selingan',sp:'Hawksbill',spEn:'Hawksbill',lat:6.17,lng:118.04,bat:43,spd:1.4,dep:12,risk:'high',color:'#ef4444',origin:'Sabah Turtle Islands Marine Park',originEn:'Sabah Turtle Islands Park, MY',cclen:78,sex:'F',age:'Adult',photo:'/img/turtles/bc-sb-2315.png'},
];

// turtle track paths (mock)
let TRACKS = {
  // Qilianyu (Xisha) — typical foraging excursion pattern
  'BC-XS-2401': [[16.83,112.30],[16.90,112.31],[16.95,112.32]],
  // Huidong → SCS migration (matches actual research routes)
  'BC-HD-2412': [[22.55,114.89],[21.20,114.50],[19.80,113.80],[18.50,113.20],[17.20,112.80]],
  // Wenchang foraging area
  'BC-HN-2418': [[19.50,111.00],[19.65,111.10],[19.85,111.20]],
  // Green Turtle Con Dao → SCS pattern
  'BC-CD-2304': [[8.71,106.61],[9.50,108.20],[10.80,110.50],[12.00,112.30]],
};

// ── LEAFLET MAP HELPERS ──
function makePopup(trt){
  return `<div style="min-width:160px">
    <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px"><img src="${trt.photo}" onerror="this.style.display='none'" style="width:36px;height:36px;border-radius:8px;object-fit:cover;border:1.5px solid rgba(28,167,168,.4)" alt="turtle"/><span style="font-size:.92rem;font-weight:700">${trt.name}</span></div>
    <div style="font-size:.75rem;color:rgba(255,255,255,.55);margin-bottom:6px">${trt.sp} · ${trt.id}</div>
    <div style="display:flex;justify-content:space-between;font-size:.75rem;margin-bottom:2px"><span style="color:rgba(255,255,255,.45)">${LANG==='zh'?'Battery':'Battery'}</span><span style="font-weight:600">${trt.bat}%</span></div>
    <div style="display:flex;justify-content:space-between;font-size:.75rem;margin-bottom:2px"><span style="color:rgba(255,255,255,.45)">${LANG==='zh'?'Speed':'Speed'}</span><span style="font-weight:600">${trt.spd} km/h</span></div>
    <div style="display:flex;justify-content:space-between;font-size:.75rem;margin-bottom:6px"><span style="color:rgba(255,255,255,.45)">Risk</span><span style="font-weight:600;color:${trt.risk==='high'?'#ef4444':trt.risk==='med'?'#f59e0b':'#22c55e'}">${LANG==='zh'?(trt.risk==='high'?'High Risk':trt.risk==='med'?'Medium Risk':'Low Risk'):(trt.risk==='high'?'High Risk':trt.risk==='med'?'Med Risk':'Low Risk')}</span></div>
    <div onclick="goTo('profile')" style="margin-top:7px;padding:4px 0;text-align:center;background:rgba(28,167,168,.2);border:1px solid rgba(28,167,168,.35);border-radius:7px;font-size:.73rem;font-weight:600;color:#1CA7A8;cursor:pointer">${i18n('lm.viewdetail')}</div>
  </div>`;
}

// ── GEO REGION DETECTION ──
// Determines if user is in China based on (1) timezone, (2) language, (3) IP API fallback
let IS_CN = true;        // default to CN tiles (primary audience); quickGeoGuess/IP check can flip to false
let GEO_RESOLVED = false; // becomes true after IP check completes
let GEO_CALLBACKS = [];   // callbacks to fire once geo is resolved

function quickGeoGuess(){
  // Synchronous fast checks (timezone + browser language)
  try {
    let tz = Intl.DateTimeFormat().resolvedOptions().timeZone || '';
    if(tz === 'Asia/Shanghai' || tz === 'Asia/Urumqi' || tz === 'Asia/Chongqing' ||
       tz === 'Asia/Harbin' || tz === 'Asia/Kashgar' || tz === 'PRC') return true;
  } catch(e){}
  try {
    let lang = (navigator.language || navigator.userLanguage || '').toLowerCase();
    // zh-CN, zh-Hans-CN clearly indicate mainland; zh-TW / zh-HK do not
    if(lang === 'zh-cn' || lang === 'zh-hans-cn' || lang === 'zh-hans') return true;
  } catch(e){}
  return false;
}

let TILES_LOADED = 0;
function watchdog(){
  // Safety net: if after 5 seconds still 0 tiles loaded AND no tile errors,
  // assume silent network failure and switch to offline.
  setTimeout(function(){
    if(TILES_LOADED === 0 && !OFFLINE_MODE){
switchToOfflineMode();
    }
  }, 5000);
}

function detectRegion(){
  watchdog();
  IS_CN = quickGeoGuess();
  resolveGeoFromIp();
}

function resolveGeoFromIp(){
  let endpoints = [
    {url:'https://ipapi.co/json/',     parse:function(d){return d.country_code === 'CN';}},
    {url:'https://api.country.is/',    parse:function(d){return d.country === 'CN';}},
    {url:'https://ipwho.is/',          parse:function(d){return d.country_code === 'CN';}}
  ];
  let done = false;
  endpoints.forEach(function(ep){
    fetch(ep.url, {cache:'no-store'}).then(function(r){return r.json();}).then(function(d){
      if(done) return;
      try {
        let inCn = ep.parse(d);
        if(typeof inCn === 'boolean'){
          done = true;
          IS_CN = IS_CN || inCn;  // never downgrade — synchronous guess wins
          GEO_RESOLVED = true;
          GEO_CALLBACKS.forEach(function(cb){cb(IS_CN);});
          GEO_CALLBACKS = [];
        }
      } catch(e){}
    }).catch(function(){});
  });
  setTimeout(function(){
    if(!GEO_RESOLVED){
      GEO_RESOLVED = true;
      GEO_CALLBACKS.forEach(function(cb){cb(IS_CN);});
      GEO_CALLBACKS = [];
    }
  }, 4000);
}

function applyGeoClass(){
  if(IS_CN) document.documentElement.classList.add('geo-cn');
  else document.documentElement.classList.remove('geo-cn');
}
function onGeoReady(cb){
  if(GEO_RESOLVED){ applyGeoClass(); cb(IS_CN); }
  else GEO_CALLBACKS.push(function(v){ applyGeoClass(); cb(v); });
}

// Track tile loading. If many errors, switch all maps to offline SVG fallback.
let TILE_ERRORS = 0;
let OFFLINE_MODE = false;
const OFFLINE_LAYER_REGISTRY = []; // maps that need offline overlay

function offlineSvgUrl(){
  // SVG world map focused on East/SE Asia + South China Sea (where most turtles are)
  // Includes simplified continent shapes so users see geographic context
  let svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 700" preserveAspectRatio="xMidYMid slice">' +
    '<defs>' +
      '<radialGradient id="oc" cx="50%" cy="45%" r="65%"><stop offset="0%" stop-color="#0d3a5e"/><stop offset="60%" stop-color="#082942"/><stop offset="100%" stop-color="#04141f"/></radialGradient>' +
      '<pattern id="grid" width="50" height="50" patternUnits="userSpaceOnUse"><path d="M50 0L0 0 0 50" fill="none" stroke="rgba(28,167,168,0.08)" stroke-width="0.5"/></pattern>' +
    '</defs>' +
    '<rect width="1000" height="700" fill="url(#oc)"/>' +
    '<rect width="1000" height="700" fill="url(#grid)"/>' +
    // China mainland (rough outline)
    '<path d="M540,180 L580,160 L640,150 L700,160 L760,180 L800,210 L820,260 L800,310 L760,340 L720,355 L690,365 L660,355 L630,340 L600,320 L570,300 L545,275 L530,240 L535,210 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="1"/>' +
    // Taiwan
    '<path d="M775,335 L785,330 L795,345 L790,365 L780,360 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Hainan
    '<ellipse cx="660" cy="375" rx="22" ry="13" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Vietnam
    '<path d="M620,360 L630,400 L645,440 L650,475 L660,510 L640,525 L625,510 L615,475 L610,430 L612,390 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Philippines (rough islands)
    '<path d="M810,400 L825,380 L835,400 L840,425 L835,445 L820,440 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    '<path d="M825,460 L840,455 L855,475 L860,500 L850,520 L835,510 L820,495 L815,475 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    '<ellipse cx="845" cy="540" rx="18" ry="14" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Borneo / Indonesia
    '<path d="M680,540 L740,520 L790,540 L810,580 L790,610 L740,620 L700,610 L670,585 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Java
    '<path d="M650,640 L700,635 L750,640 L780,650 L760,660 L710,665 L660,660 L640,655 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Malaysia / Thailand peninsula
    '<path d="M580,500 L600,520 L605,560 L595,600 L585,615 L575,600 L572,565 L575,525 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Korea
    '<path d="M820,235 L835,225 L850,235 L855,260 L845,275 L825,270 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Japan
    '<path d="M880,200 L905,195 L925,210 L935,235 L915,250 L890,240 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    '<path d="M900,265 L920,255 L935,275 L945,300 L935,320 L915,310 L900,290 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Australia (top edge only)
    '<path d="M780,650 L880,650 L950,665 L1000,680 L1000,700 L780,700 Z" fill="#0a3550" stroke="rgba(28,167,168,0.35)" stroke-width="0.8"/>' +
    // Labels
    '<text x="690" y="265" fill="rgba(255,255,255,0.4)" font-family="sans-serif" font-size="14" font-weight="600">CHINA</text>' +
    '<text x="700" y="445" fill="rgba(28,167,168,0.55)" font-family="sans-serif" font-size="11" font-weight="600">SOUTH CHINA SEA</text>' +
    '<text x="826" y="475" fill="rgba(255,255,255,0.35)" font-family="sans-serif" font-size="10">PHILIPPINES</text>' +
    '<text x="615" y="455" fill="rgba(255,255,255,0.35)" font-family="sans-serif" font-size="9">VIETNAM</text>' +
    '<text x="745" y="585" fill="rgba(255,255,255,0.35)" font-family="sans-serif" font-size="10">BORNEO</text>' +
    '<text x="700" y="660" fill="rgba(255,255,255,0.3)" font-family="sans-serif" font-size="9">JAVA SEA</text>' +
    '<text x="900" y="225" fill="rgba(255,255,255,0.35)" font-family="sans-serif" font-size="9">JAPAN</text>' +
  '</svg>';
  return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg);
}

function addOfflineFallback(map){
  // Adds a static SVG world map covering the geographic bounds in dark ocean style
  if(!map || OFFLINE_LAYER_REGISTRY.indexOf(map) >= 0) return;
  // Bounds tuned for our turtle data (covers SCS, SE Asia, parts of Pacific)
  let bounds = [[-25, 95], [40, 155]];
  L.imageOverlay(offlineSvgUrl(), bounds, {opacity:1.0, interactive:false}).addTo(map);
  OFFLINE_LAYER_REGISTRY.push(map);
}

function switchToOfflineMode(){
  if(OFFLINE_MODE) return;
  OFFLINE_MODE = true;
// Apply offline overlay to all already-created maps
  [heroMap, liveMap, miniMap, profMap, profTrackMap, conMap].forEach(function(m){
    if(m) addOfflineFallback(m);
  });
}

function tileLayer(){
  let url, opts;
  if(IS_CN){
    url = 'https://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}';
    opts = {subdomains:['1','2','3','4'], attribution:'© Amap', maxZoom:18};
  } else {
    url = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    opts = {attribution:'© OpenStreetMap', maxZoom:18};
  }
  let layer = L.tileLayer(url, opts);
  // Detect tile load failures — switch to offline fallback after consecutive errors
  layer.on('tileload', function(){ TILES_LOADED++; });
  layer.on('tileerror', function(){
    TILE_ERRORS++;
    if(TILE_ERRORS >= 8 && !OFFLINE_MODE){
      switchToOfflineMode();
    }
  });
  return layer;
}

// ── HERO MAP ──
let heroMap=null;
function initHeroMap(){
  if(heroMap) return;
  onGeoReady(function(){
    if(heroMap) return;
    heroMap=L.map('hero-map',{zoomControl:false,scrollWheelZoom:false,dragging:true,attributionControl:false}).setView([13,115],5);
    tileLayer().addTo(heroMap);
    setTimeout(function(){ if(OFFLINE_MODE) addOfflineFallback(heroMap); }, 100);
  TURTLES.forEach(turtle=>{
    const dot = L.divIcon({className:'',html:`<div style="width:14px;height:14px;border-radius:50%;background:${turtle.color};border:2.5px solid rgba(255,255,255,.85);box-shadow:0 0 10px ${turtle.color}88"></div>`,iconSize:[14,14],iconAnchor:[7,7]});
    const m=L.marker([turtle.lat,turtle.lng],{icon:dot}).addTo(heroMap);
    m.bindPopup(makePopup(turtle),{maxWidth:200});
    if(TRACKS[turtle.id]){
      L.polyline(TRACKS[turtle.id],{color:turtle.color,weight:2,opacity:.6,dashArray:'6,5'}).addTo(heroMap);
    }
  });
  // warning zone circle
  L.circle([8.5,107.2],{radius:80000,color:'#ef4444',fillColor:'#ef4444',fillOpacity:.08,weight:1.5,dashArray:'6,4'}).addTo(heroMap);
  });
}

// ═══════════════ RESEARCH CENTER ═══════════════
const RSCI_DATA = [
  // Original 7 datasets
  {id:1, name:'🐢 Luna Migration Track 2026', sub:'BC-XS-2401 · Xisha–Hainan–Xisha', sp:'Green Turtle', region:'SCS', period:'2025-10—present', data:'187 days·47k points', fmts:['CSV','GeoJSON'], cat:'track'},
  {id:2, name:'🌊 SCS Leatherback 2023', sub:'SCS Leatherback Population Tracking', sp:'Leatherback', region:'SCS', period:'2023-01—12', data:'365 days·210k points', fmts:['CSV','NetCDF'], cat:'track'},
  {id:3, name:'🌡 SCS Temp × Turtle Behavior', sub:'SCS Water Temperature-Behavior Analysis', sp:'Green Turtle', region:'SCS', period:'2022-03—2023-09', data:'18 mon·520k points', fmts:['NetCDF','CSV'], cat:'env'},
  {id:4, name:'🚢 Vessel Collision Risk — SCS', sub:'SCS Vessel-Turtle Collision Risk Dataset', sp:'Green Turtle', region:'SCS', period:'2023-06—2024-06', data:'12 mon·89k points', fmts:['GeoJSON'], cat:'env'},
  {id:5, name:'🌿 Xisha Seagrass Foraging Patterns', sub:'Xisha Seagrass Foraging Patterns', sp:'Green Turtle', region:'Xisha & Hainan Offshore', period:'2025-01—2025-08', data:'8 mon·76k points', fmts:['CSV'], cat:'track'},
  {id:6, name:'📡 Multi-species SCS Nesting Survey', sub:'SCS Multi-Species Nesting Beach Survey', sp:'Multi-Species', region:'SCS Coastal', period:'2021-05—2024-05', data:'3 yr·1.2M points', fmts:['CSV','GeoJSON'], cat:'track'},
  {id:7, name:'🤖 AI Migration Model Training v3', sub:'AI Migration Forecast Training Data', sp:'Multi-Species', region:'Global', period:'2019—2023', data:'5 yr·8.4M points', fmts:['CSV','NetCDF'], cat:'track'},
  // Additional datasets
  {id:8, name:'🌏 Indo-Pacific Leatherback Migration', sub:'W. Pacific Leatherback Long-Distance Migration', sp:'Leatherback', region:'West Pacific', period:'2022-01—2024-06', data:'30 mon·410k points', fmts:['CSV','NetCDF'], cat:'track'},
  {id:9, name:'🌙 SCS Night Diving Patterns', sub:'SCS Nocturnal Dive Patterns', sp:'Green Turtle', region:'SCS', period:'2023-03—2024-03', data:'12 mon·230k points', fmts:['CSV','GeoJSON'], cat:'track'},
  {id:10, name:'🌊 SST × Chlorophyll SCS 2024', sub:'SCS SST & Chlorophyll', sp:'Multi-Species', region:'SCS', period:'2024-01—12', data:'12 mon·620k points', fmts:['NetCDF'], cat:'env'},
  {id:11, name:'🏝 Con Dao Nesting Beach Survey', sub:'Con Dao Nesting Beach Long-Term Monitoring', sp:'Green Turtle', region:'Con Dao, Vietnam', period:'2018—2024', data:'7 yr·1.8M points', fmts:['CSV','GeoJSON'], cat:'track'},
  {id:12, name:'🌿 Seagrass Habitat Mapping', sub:'SCS Seagrass Habitat Mapping', sp:'Green Turtle', region:'SCS', period:'2022-01—2023-12', data:'24 mon·340k points', fmts:['GeoJSON','NetCDF'], cat:'env'},
  {id:13, name:'🛰 Sentinel-2 × Turtle Tracking', sub:'Satellite Remote Sensing & Turtle Tracking', sp:'Multi-Species', region:'Global', period:'2020—2024', data:'5 yr·2.3M points', fmts:['NetCDF','GeoJSON'], cat:'env'},
  {id:14, name:'🔬 Genetic Diversity — Chelonia mydas', sub:'Green Turtle Population Genetics', sp:'Green Turtle', region:'SCS', period:'2019—2023', data:'5 yr·8.9k samples', fmts:['CSV'], cat:'track'},
  {id:15, name:'📍 SCS Foraging Hotspot Analysis', sub:'SCS Foraging Hotspot Analysis', sp:'Green Turtle', region:'SCS', period:'2023-06—2024-06', data:'12 mon·156k points', fmts:['GeoJSON'], cat:'track'},
  {id:16, name:'⚡ Bycatch Risk — Vietnam Coast', sub:'Vietnam Offshore Bycatch Risk Assessment', sp:'Leatherback', region:'Vietnam Offshore', period:'2022—2024', data:'3 yr·42k points', fmts:['CSV','GeoJSON'], cat:'env'},
  {id:17, name:'🏖 Wang-an Island Hatch Success', sub:'Wangan Island Hatch Success Monitoring', sp:'Green Turtle', region:'Penghu, Taiwan', period:'2020—2024', data:'5 yr·3.2k nests', fmts:['CSV'], cat:'track'},
  {id:18, name:'🌪 Typhoon Impact on Migration', sub:'Typhoon Impact on Turtle Migration Routes', sp:'Multi-Species', region:'NW Pacific', period:'2018—2024', data:'7 yr·890k points', fmts:['CSV','NetCDF'], cat:'env'},
  {id:19, name:'🐚 Hawksbill Sabah Coral Reef Use', sub:'Hawksbill Coral Reef Use Patterns', sp:'Hawksbill', region:'Sabah Waters', period:'2021—2024', data:'4 yr·178k points', fmts:['GeoJSON','CSV'], cat:'track'},
  {id:20, name:'📈 Population Trend Model', sub:'SCS Turtle Population Trend Model', sp:'Multi-Species', region:'SCS', period:'2015—2025', data:'11 yr·5.2M points', fmts:['CSV','NetCDF'], cat:'env'},
  {id:21, name:'🎣 Fishery Interaction — Palawan', sub:'Palawan Fishery-Turtle Interaction Dataset', sp:'Green Turtle', region:'Philippines', period:'2022-05—2024-05', data:'24 mon·67k points', fmts:['CSV'], cat:'track'},
  {id:22, name:'🌴 Xisha Rookery Phenology', sub:'Xisha Nesting Phenology Records', sp:'Green Turtle', region:'Xisha Islands', period:'2016—2024', data:'9 yr·12k nests', fmts:['CSV','GeoJSON'], cat:'track'},
  {id:23, name:'🔊 Acoustic Telemetry — Huidong', sub:'Huidong Acoustic Telemetry Dataset', sp:'Green Turtle', region:'Huidong, Guangdong', period:'2023-01—2024-12', data:'24 mon·94k points', fmts:['CSV'], cat:'track'},
  {id:24, name:'🌐 Ocean Currents × Turtle Drift', sub:'Ocean Currents & Hatchling Drift Simulation', sp:'Multi-Species', region:'West Pacific', period:'2019—2023', data:'5 yr·1.4M points', fmts:['NetCDF','GeoJSON'], cat:'env'},
];

const RSCI_PAGE_SIZE = 7;
let rschPage = 1;
let rschCat = 'all';
let rschQuery = '';

function getRschFiltered(){
  let list = RSCI_DATA;
  if(rschCat !== 'all') list = list.filter(function(d){ return d.cat === rschCat || d.sp === rschCat; });
  if(rschQuery){
    let q = rschQuery.toLowerCase();
    list = list.filter(function(d){ return (d.name+d.sub+d.sp+d.region+d.period).toLowerCase().indexOf(q) >= 0; });
  }
  return list;
}

function renderRschTable(){
  let filtered = getRschFiltered();
  let total = filtered.length;
  let pages = Math.ceil(total / RSCI_PAGE_SIZE);
  if(rschPage > pages) rschPage = pages || 1;
  let start = (rschPage-1) * RSCI_PAGE_SIZE;
  let pageData = filtered.slice(start, start+RSCI_PAGE_SIZE);

  let tbody = document.getElementById('rsch-tbody');
  if(!tbody) return;
  let pCls = {'Green Turtle':'p-teal','Leatherback':'p-coral','Hawksbill':'p-coral','Multi-Species':'p-green'};
  tbody.innerHTML = pageData.map(function(d){
    let spCls = pCls[d.sp] || 'p-dim';
    let fmtHtml = d.fmts.map(function(f){ return '<span class="pill p-dim">'+f+'</span>'; }).join('');
    return '<tr onclick="rschRowDetail('+d.id+')"><td><div class="td-main">'+d.name+'</div><div class="td-sub">'+d.sub+'</div></td>'+
      '<td><span class="pill '+spCls+'">'+d.sp+'</span></td>'+
      '<td>'+d.region+'</td><td>'+d.period+'</td><td>'+d.data+'</td>'+
      '<td><div class="dl-row">'+fmtHtml+'</div></td>'+
      '<td><div class="dl-row"><button class="dl-btn" onclick="event.stopPropagation();rschPreview('+d.id+')">Preview</button>'+
      '<button class="dl-btn" onclick="event.stopPropagation();rschDownload('+d.id+')">Download</button></div></td></tr>';
  }).join('');
  renderRschPagination(pageData, start, total, pages);
}

function renderRschPagination(pageData, start, total, pages){
  let pagInfo = document.getElementById('rsch-pag-info');
  if(pagInfo) pagInfo.textContent = 'Showing '+(pageData.length ? (start+1)+'–'+(start+pageData.length) : '0')+' of '+total;
  let pagBtns = document.getElementById('rsch-pag-btns');
  if(!pagBtns) return;
  let btnHtml = '<button class="pgb" onclick="rschPageGo('+(rschPage-1)+')"'+ (rschPage<=1?' disabled style="opacity:.3;cursor:default"':'')+'>&#8249;</button>';
  for(let i=1; i<=pages; i++){
    btnHtml += '<button class="pgb'+ (i===rschPage?' on':'')+'" onclick="rschPageGo('+i+')">'+i+'</button>';
  }
  btnHtml += '<button class="pgb" onclick="rschPageGo('+(rschPage+1)+')"'+ (rschPage>=pages?' disabled style="opacity:.3;cursor:default"':'')+'>&#8250;</button>';
  pagBtns.innerHTML = btnHtml;
}

function rschPageGo(n){
  let total = getRschFiltered().length;
  let pages = Math.ceil(total / RSCI_PAGE_SIZE) || 1;
  if(n < 1) n = 1;
  if(n > pages) n = pages;
  rschPage = n;
  renderRschTable();
}

function rschFilter(el, cat){
  rschCat = cat;
  rschPage = 1;
  // Update active state
  el.parentElement.querySelectorAll('.fc').forEach(function(c){ c.classList.remove('on'); });
  el.classList.add('on');
  // Refresh count label
  let total = getRschFiltered().length;
  let lbl = document.getElementById('rsch-total-label');
  if(lbl) lbl.textContent = ''+total+'';
  renderRschTable();
}

function rschSearch(){
  rschQuery = document.getElementById('rsch-search').value;
  rschPage = 1;
  let total = getRschFiltered().length;
  let lbl = document.getElementById('rsch-total-label');
  if(lbl) lbl.textContent = ''+total+'';
  renderRschTable();
}

function rschNav(el, panelId){
  // Update left nav active state
  document.querySelectorAll('#page-research .rn-item').forEach(function(x){ x.classList.remove('on'); });
  if(el) el.classList.add('on');
  // Show/hide panels
  document.querySelectorAll('#page-research .rsch-panel').forEach(function(p){ p.classList.remove('active'); });
  let panel = document.getElementById('rsch-panel-'+panelId);
  if(panel) panel.classList.add('active');
}

function rschCopyDoi(doi){
  if(navigator.clipboard){
    navigator.clipboard.writeText('https://doi.org/'+doi).then(function(){
      alert('✅ DOI copied: '+doi);
    });
  } else {
    prompt('Copy this DOI: ', 'https://doi.org/'+doi);
  }
}

function rschCopyApiKey(){
  let key = 'bc_live_xs2401_a8f3k2p9m7xq5w1e4r6t8y0u3i';
  if(navigator.clipboard){
    navigator.clipboard.writeText(key).then(function(){
      alert('✅ API Key Copied');
    });
  } else {
    prompt('Copy API Key: ', key);
  }
}

function rschSubmitApi(){
  let org = document.getElementById('rsch-org');
  let email = document.getElementById('rsch-email');
  let usecase = document.getElementById('rsch-usecase');
  let checks = document.querySelectorAll('#rsch-api-apply input[type=checkbox]:checked');
  let errors = [];
  if(!org.value.trim()) errors.push('Please enter institution name');
  if(!email.value.trim()) errors.push('Please enter contact email');
  else if(!/^[^@]+@[^@]+\\.[^@]+$/.test(email.value)) errors.push('Invalid email format');
  if(!usecase.value.trim()) errors.push('Please describe your use case');
  if(checks.length === 0) errors.push('Please select at least one data category');
  if(errors.length > 0){
    alert('⚠️ Please complete the following information:\\n\\n'+errors.map(function(e){ return '• '+e; }).join('\\n'));
    return;
  }
  // Success
  let btn = document.getElementById('rsch-submit-btn');
  btn.textContent = '✅ Application Submitted';
  btn.disabled = true;
  btn.style.opacity = '0.6';
  btn.style.cursor = 'default';
  // Disable all form inputs
  let form = document.getElementById('rsch-api-apply');
  form.querySelectorAll('input,textarea,select').forEach(function(el){ el.disabled = true; });
  alert('✅ Application submitted successfully！\\n\\nWe will review within 2-5 business days. Results will be sent to ' + email.value + '\\n\\nThank you for supporting Blue Circle Turtle Tracking Platform 🐢');
}

function rschToggleFilter(){
  alert('🔍 Advanced Filter Panel (in development)\\n\\nFilter by: year range, data format, coverage area, data volume, etc.');
}

function rschShowApiDoc(){
  alert('📖 API Documentation\\n\\nBlue Circle API v2 documentation in progress...\\n\\nEndpoint examples:\\n• GET /api/v2/turtles?region=south-china-sea\\n• GET /api/v2/turtles/{id}/tracks\\n• GET /api/v2/environmental/sst\\n\\nFull documentation coming soon. Check back here.');
}

function rschOpenProject(name){
  let titles = {hudong:'Huidong Turtle Reserve', sansha:'Sansha Turtle Ecological Station', leatherback:'SCS Leatherback Working Group'};
  alert('📂 '+titles[name]+'\n\nProject detail page in development...\n\nMember data, shared datasets, discussion forums coming soon.\n\nExpected: 2026 Q3');
}

function rschBatchDownload(){
  let checked = prompt('⚠️ Batch Download\\n\\nEnter dataset IDs to download (comma separated):\\ne.g. 1,2,5,8\\n\\n（Currently in demo mode）');
  if(checked){
    alert('📥 Batch download request submitted\\n\\nDataset IDs: '+checked+'\\n\\nDownload links will be sent to your registered email');
  }
}

function rschRowDetail(id){
  let d = RSCI_DATA.find(function(x){ return x.id === id; });
  if(!d) return;
  let tbody = document.getElementById('rsch-tbody');
  // Simple: highlight the row and show a quick detail below the table header
  let existing = document.getElementById('rsch-detail-bar');
  if(existing) existing.remove();
  let bar = document.createElement('div');
  bar.id = 'rsch-detail-bar';
  bar.style.cssText = 'background:rgba(28,167,168,.06);border:1px solid rgba(28,167,168,.2);border-radius:8px;padding:.8rem 1rem;margin-bottom:.8rem;display:flex;align-items:center;gap:1rem;flex-wrap:wrap';
  bar.innerHTML = '<span style="font-size:1rem">📋</span>'+
    '<div style="flex:1;min-width:200px"><strong style="color:#fff;font-size:.88rem">'+d.name+'</strong>'+
    '<div style="font-size:.72rem;color:rgba(255,255,255,.4);margin-top:2px">'+d.sub+' · '+d.sp+' · '+d.region+' · '+d.period+' · '+d.data+'</div></div>'+
    '<button onclick="this.parentElement.remove()" style="background:transparent;border:1px solid rgba(255,255,255,.15);color:rgba(255,255,255,.5);padding:.3rem .7rem;border-radius:6px;cursor:pointer;font-size:.72rem;font-family:inherit">✕ Close</button>';
  let filterBar = document.querySelector('#page-research .filter-bar');
  if(filterBar) filterBar.parentNode.insertBefore(bar, filterBar);
  bar.scrollIntoView({behavior:'smooth',block:'center'});
}

function rschPreview(id){
  let d = RSCI_DATA.find(function(x){ return x.id === id; });
  if(!d) return;
  alert('📋 Data Preview\n\n'+d.name+'\n'+d.sub+'\nSpecies: '+d.sp+'\nRegion: '+d.region+'\nTime: '+d.period+'\nData Volume: '+d.data+'\nFormat: '+d.fmts.join(', ')+'\n\n（Preview will be enhanced in future updates）');
}

function rschDownload(id){
  let d = RSCI_DATA.find(function(x){ return x.id === id; });
  if(!d) return;
  let csv = 'name,species,region,period\n'+d.name+','+d.sp+','+d.region+','+d.period;
  let blob = new Blob([csv], {type:'text/csv;charset=utf-8'});
  let url = URL.createObjectURL(blob);
  let a = document.createElement('a');
  a.href = url; a.download = 'dataset-'+d.id+'.csv';
  document.body.appendChild(a); a.click();
  document.body.removeChild(a); URL.revokeObjectURL(url);
}

// Initialize research table on page load
function initRsch(){
  renderRschTable();
}

// ── LIVE MAP ──

let liveMap=null;
let lmLayers={}; // Layer Manager
window._lmInit=false;
// [SPLIT-NEXT] initLiveMap (320L) → initLiveMap + addTrackingLayer + addAiLayer + addAlertLayer + addSidebar
function initLiveMap(){
  window._lmInit=true;
  setTimeout(function(){
    onGeoReady(function(){
      liveMap=L.map('livemap-leaflet',{zoomControl:true,attributionControl:false}).setView([12,116],5);
      tileLayer().addTo(liveMap);
      setTimeout(function(){ if(OFFLINE_MODE) addOfflineFallback(liveMap); }, 100);

      // Layer 1: Live Tracking（Turtle Markers + Tracks）
      const trackingLayer = L.layerGroup();
      TURTLES.forEach(turtle=>{
        const pulse = turtle.risk==='high' ? `animation:warn-ring 1s ease-out infinite;` : '';
        const dotHtml=`<div style="position:relative;width:16px;height:16px">
          <div style="width:16px;height:16px;border-radius:50%;background:${turtle.color};border:2.5px solid rgba(255,255,255,.9);box-shadow:0 0 12px ${turtle.color}99;${pulse}"></div>
        </div>`;
        const icon=L.divIcon({className:'',html:dotHtml,iconSize:[16,16],iconAnchor:[8,8]});
        L.marker([turtle.lat,turtle.lng],{icon}).addTo(trackingLayer).bindPopup(makePopup(turtle),{maxWidth:200});
        if(TRACKS[turtle.id]) L.polyline(TRACKS[turtle.id],{color:turtle.color,weight:2,opacity:.55,dashArray:'6,5'}).addTo(trackingLayer);
      });
      trackingLayer.addTo(liveMap);
      lmLayers.tracking = trackingLayer;

      // Layer 2: AI Migration Forecast (dashed trajectory extension)
      const aiLayer = L.layerGroup();
      // Luna forecast path (Xisha → Hainan foraging area)
      L.polyline([[16.97,112.32],[17.5,112.0],[18.2,111.6],[19.0,111.4]],{color:'#1CA7A8',weight:2,opacity:.5,dashArray:'2,6'}).addTo(aiLayer);
      // Côn Đảo Green预测（继续北上）
      L.polyline([[12.00,112.30],[13.5,113.5],[15.0,114.5]],{color:'#FF7F50',weight:2,opacity:.5,dashArray:'2,6'}).addTo(aiLayer);
      // Selingan Hawksbill预测（Sabah Waters内活动）
      L.polyline([[6.17,118.04],[6.5,118.5],[6.8,118.2],[6.4,117.8]],{color:'#ef4444',weight:2,opacity:.5,dashArray:'2,6'}).addTo(aiLayer);
      // Forecast Point (7 days later position)
      [[19.0,111.4,'#1CA7A8'],[15.0,114.5,'#FF7F50'],[6.4,117.8,'#ef4444']].forEach(p=>{
        L.circleMarker([p[0],p[1]],{radius:5,color:p[2],fillColor:p[2],fillOpacity:.4,weight:2,dashArray:'3,3'}).addTo(aiLayer);
      });
      aiLayer.addTo(liveMap);
      lmLayers.ai = aiLayer;

      // 图层 3: Conservation Alert Zones（Existing red/yellow circles）
      const alertLayer = L.layerGroup();
      L.circle([8.5,107.2],{radius:90000,color:'#ef4444',fillColor:'#ef4444',fillOpacity:.07,weight:1.5,dashArray:'5,4'}).addTo(alertLayer);
      L.circle([12.5,114.2],{radius:60000,color:'#f59e0b',fillColor:'#f59e0b',fillOpacity:.06,weight:1.2,dashArray:'5,4'}).addTo(alertLayer);
      L.circle([6.17,118.04],{radius:45000,color:'#ef4444',fillColor:'#ef4444',fillOpacity:.07,weight:1.5,dashArray:'5,4'}).addTo(alertLayer);
      alertLayer.addTo(liveMap);
      lmLayers.alert = alertLayer;

      // ══════════════════════════════════════════════════
      // 图层 4: Ocean Temperature Layer — SCSReal SST Heatmap (Canvas)
      // ══════════════════════════════════════════════════
      const sstLayer = L.layerGroup();

      // SCS SST Grid Data (May climatology, °C)
      // Lat 5°N–23°N, Lon 105°E–122°E, step 1°
      const sstGrid = [
        // 经度→ 105  106  107  108  109  110  111  112  113  114  115  116  117  118  119  120  121  122
        /*23°N*/[27.2,26.9,26.5,26.2,25.8,25.5,25.3,25.4,25.6,25.9,26.1,26.3,26.5,26.7,26.8,26.9,27.0,27.1],
        /*22°N*/[27.5,27.3,27.0,26.8,26.5,26.3,26.2,26.4,26.7,27.0,27.3,27.5,27.7,27.9,28.0,28.1,28.2,28.3],
        /*21°N*/[28.0,27.8,27.7,27.5,27.4,27.3,27.4,27.6,27.9,28.2,28.5,28.7,28.9,29.0,29.1,29.2,29.3,29.4],
        /*20°N*/[28.3,28.2,28.1,28.0,28.0,28.1,28.3,28.5,28.8,29.1,29.3,29.5,29.6,29.7,29.8,29.9,29.9,30.0],
        /*19°N*/[28.6,28.6,28.6,28.6,28.7,28.8,29.0,29.2,29.4,29.6,29.7,29.8,29.9,30.0,30.0,30.1,30.1,30.1],
        /*18°N*/[28.8,28.9,28.9,29.0,29.1,29.2,29.3,29.5,29.6,29.8,29.9,30.0,30.1,30.1,30.2,30.2,30.2,30.2],
        /*17°N*/[29.0,29.0,29.1,29.2,29.3,29.4,29.5,29.6,29.8,29.9,30.0,30.1,30.2,30.2,30.3,30.3,30.3,30.3],
        /*16°N*/[29.1,29.1,29.2,29.3,29.4,29.5,29.6,29.7,29.8,30.0,30.1,30.2,30.2,30.3,30.3,30.4,30.4,30.4],
        /*15°N*/[29.2,29.2,29.3,29.3,29.4,29.5,29.6,29.8,29.9,30.0,30.1,30.2,30.3,30.3,30.4,30.4,30.4,30.5],
        /*14°N*/[29.1,29.2,29.2,29.3,29.4,29.5,29.6,29.7,29.8,30.0,30.1,30.2,30.2,30.3,30.3,30.4,30.4,30.4],
        /*13°N*/[29.0,29.1,29.1,29.2,29.3,29.4,29.5,29.6,29.7,29.9,30.0,30.1,30.2,30.2,30.3,30.3,30.3,30.3],
        /*12°N*/[28.9,28.9,29.0,29.1,29.2,29.3,29.4,29.5,29.6,29.8,29.9,30.0,30.1,30.2,30.2,30.3,30.3,30.3],
        /*11°N*/[28.8,28.8,28.9,29.0,29.1,29.2,29.3,29.4,29.5,29.7,29.8,29.9,30.0,30.1,30.2,30.2,30.2,30.3],
        /*10°N*/[28.7,28.7,28.8,28.9,29.0,29.1,29.2,29.3,29.4,29.6,29.7,29.8,29.9,30.0,30.1,30.1,30.2,30.2],
        /* 9°N*/[28.7,28.7,28.8,28.9,28.9,29.0,29.1,29.2,29.3,29.5,29.6,29.7,29.8,29.9,30.0,30.1,30.1,30.2],
        /* 8°N*/[28.7,28.7,28.8,28.8,28.9,29.0,29.1,29.2,29.3,29.4,29.5,29.6,29.7,29.8,29.9,30.0,30.1,30.1],
        /* 7°N*/[28.6,28.7,28.7,28.8,28.9,28.9,29.0,29.1,29.2,29.3,29.5,29.6,29.7,29.8,29.9,29.9,30.0,30.1],
        /* 6°N*/[28.6,28.6,28.7,28.8,28.8,28.9,29.0,29.1,29.2,29.3,29.4,29.5,29.6,29.7,29.8,29.9,30.0,30.0],
        /* 5°N*/[28.5,28.6,28.6,28.7,28.8,28.9,28.9,29.0,29.1,29.2,29.3,29.4,29.5,29.6,29.7,29.8,29.9,30.0],
      ];
      const SST_LAT_MIN=5, SST_LAT_MAX=23, SST_LNG_MIN=105, SST_LNG_MAX=122;
      const SST_ROWS=sstGrid.length, SST_COLS=sstGrid[0].length;

      // SST Scale: Dark Blue(24°C) → Cyan(26) → Yellow(28) → Orange(29) → Red(30) → Deep Red(31°C+)
      function sstColor(t){
        t=Math.max(24,Math.min(31.5,t));
        if(t<26){const f=(t-24)/2; const rc=Math.round(30+f*30),gc=Math.round(100+f*80),bc=Math.round(180-f*20); return `rgb(${rc},${gc},${bc})`;}
        if(t<28){const f=(t-26)/2; const rc=Math.round(60+f*120),gc=Math.round(180-f*20),bc=Math.round(160-f*100); return `rgb(${rc},${gc},${bc})`;}
        if(t<29){const f=t-28; const rc=Math.round(180+f*60),gc=Math.round(160-f*20),bc=Math.round(60-f*30); return `rgb(${rc},${gc},${bc})`;}
        if(t<30){const f=t-29; const rc=Math.round(240+f*15),gc=Math.round(140-f*80),bc=Math.round(30-f*15); return `rgb(${rc},${gc},${bc})`;}
        const f=Math.min(1,(t-30)/1.5); const rc=Math.round(255-f*55),gc=Math.round(60-f*40),bc=Math.round(15+f*5); return `rgb(${rc},${gc},${bc})`;
      }

      function sstBilinear(lat,lng){
        const r=(lat-SST_LAT_MIN)/(SST_LAT_MAX-SST_LAT_MIN)*(SST_ROWS-1);
        const c=(lng-SST_LNG_MIN)/(SST_LNG_MAX-SST_LNG_MIN)*(SST_COLS-1);
        const r0=Math.max(0,Math.min(SST_ROWS-2,Math.floor(r)));
        const c0=Math.max(0,Math.min(SST_COLS-2,Math.floor(c)));
        const fr=r-r0, fc=c-c0;
        const v00=sstGrid[r0][c0], v10=sstGrid[r0+1][c0], v01=sstGrid[r0][c0+1], v11=sstGrid[r0+1][c0+1];
        return v00*(1-fr)*(1-fc)+v10*fr*(1-fc)+v01*(1-fr)*fc+v11*fr*fc;
      }

      // Canvas SST Heatmap叠加层
      const sstCanvasOverlay = L.canvas({padding:0.5});
      sstCanvasOverlay.drawSST = function(){
        const ctx=this._ctx, size=this._map.getSize(), bounds=this._map.getBounds();
        const imgData=ctx.createImageData(size.x,size.y);
        const data=imgData.data;
        for(let py=0;py<size.y;py++){
          for(let px=0;px<size.x;px++){
            const latlng=this._map.containerPointToLatLng([px,py]);
            let t=-1;
            if(latlng.lat>=SST_LAT_MIN&&latlng.lat<=SST_LAT_MAX&&latlng.lng>=SST_LNG_MIN&&latlng.lng<=SST_LNG_MAX){
              t=sstBilinear(latlng.lat,latlng.lng);
            }
            const idx=(py*size.x+px)*4;
            if(t>0){
              const col=sstColor(t);
              const m=col.match(/\d+/g);
              data[idx]=parseInt(m[0]); data[idx+1]=parseInt(m[1]); data[idx+2]=parseInt(m[2]); data[idx+3]=90; // ~35% opacity
            } else {
              data[idx]=0; data[idx+1]=0; data[idx+2]=0; data[idx+3]=0;
            }
          }
        }
        ctx.putImageData(imgData,0,0);
      };
      // Override _updatePaths to redraw on zoom/pan
      const origUpdate=sstCanvasOverlay._updatePaths;
      sstCanvasOverlay._updatePaths=function(){origUpdate.call(this); this.drawSST();};
      sstCanvasOverlay.on('add',function(){this.drawSST();});
      sstLayer.addLayer(sstCanvasOverlay);

      // Isotherm Labels (key isotherms)
      [26,28,30].forEach(function(tval){
        const pts=[];
        for(let lat=6;lat<=22;lat+=0.5){
          for(let lng=105;lng<=121;lng+=0.5){
            const v=sstBilinear(lat,lng);
            if(Math.abs(v-tval)<0.15){
              pts.push([lat,lng]); break;
            }
          }
        }
        if(pts.length>1){
          const color= tval===26?'#3b82f6':tval===28?'#eab308':'#ef4444';
          L.polyline(pts,{color:color,weight:1.5,opacity:.55,dashArray:'6,4'}).addTo(sstLayer);
          const mid=pts[Math.floor(pts.length/2)];
          L.marker(mid,{icon:L.divIcon({className:'sst-label',html: '<span style="font-size:10px;font-weight:700;color:'+color+';text-shadow:0 0 3px rgba(0,0,0,.7)">'+tval+'°C</span>',iconSize:[30,14],iconAnchor:[15,7]})}).addTo(sstLayer);
        }
      });

      // Hidden by default
      lmLayers.sst = sstLayer;

      // ══════════════════════════════════════════════════
      // Layer 5: Fishing Vessel Tracks — 36艘RealAISSimulated
      // ══════════════════════════════════════════════════
      const vesselLayer = L.layerGroup();

      function rand(min,max){return min+Math.random()*(max-min);}
      function randInt(min,max){return Math.floor(rand(min,max+1));}

      // —— Helper: Generate Smooth Path ——
      function smoothPath(points, angleNoise){
        const result=[points[0]];
        for(let i=1;i<points.length;i++){
          const prev=result[result.length-1], target=points[i];
          const dist=Math.sqrt((target[0]-prev[0])**2+(target[1]-prev[1])**2);
          const steps=Math.max(3,Math.ceil(dist*111/0.5)); // ~0.5km per step
          for(let s=1;s<=steps;s++){
            const f=s/steps;
            let lat=prev[0]+(target[0]-prev[0])*f;
            let lng=prev[1]+(target[1]-prev[1])*f;
            if(angleNoise&&s>0&&s<steps){lat+=rand(-angleNoise,angleNoise); lng+=rand(-angleNoise,angleNoise);}
            result.push([lat,lng]);
          }
        }
        return result;
      }

      // —— 拖网渔船Tracks：平行往返式 (北部湾 + 粤西外海) ——
      const trawlZones=[
        {center:[19.2,108.0], heading:45,  len:0.8, gap:0.04, count:5}, // Northern Beibu Gulf
        {center:[18.0,108.5], heading:60,  len:1.0, gap:0.05, count:4}, // Central Beibu Gulf
        {center:[17.0,109.0], heading:30,  len:0.7, gap:0.04, count:3}, // Southern Beibu Gulf
        {center:[20.5,111.0], heading:15,  len:0.9, gap:0.05, count:4}, // 粤西外海
      ];
      const trawlColors=['#f87171','#fb923c','#fbbf24','#a3e635','#34d399','#38bdf8'];
      trawlZones.forEach(function(zone){
        for(let v=0;v<zone.count;v++){
          const hdgRad=zone.heading*Math.PI/180;
          const perpRad=hdgRad+Math.PI/2;
          const dLat=Math.cos(hdgRad)*zone.len/111;
          const dLng=Math.sin(hdgRad)*zone.len/111/Math.cos(zone.center[0]*Math.PI/180);
          const pLat=Math.cos(perpRad)*zone.gap*v/111;
          const pLng=Math.sin(perpRad)*zone.gap*v/111/Math.cos(zone.center[0]*Math.PI/180);

          // 往返式: 3-5  rounds
          const passes=randInt(3,5);
          const pts=[];
          let flipDir=1;
          for(let p=0;p<passes;p++){
            const startLat=zone.center[0]+pLat-flipDir*dLat*0.5+rand(-0.02,0.02);
            const startLng=zone.center[1]+pLng-flipDir*dLng*0.5+rand(-0.02,0.02);
            const endLat=zone.center[0]+pLat+flipDir*dLat*0.5+rand(-0.02,0.02);
            const endLng=zone.center[1]+pLng+flipDir*dLng*0.5+rand(-0.02,0.02);
            pts.push([startLat,startLng],[endLat,endLng]);
            flipDir*=-1;
          }
          const smoothed=smoothPath(pts,0.003);
          const color=trawlColors[Math.floor(Math.random()*trawlColors.length)];
          const speed=rand(2.5,4.0);

          // 主Tracks
          L.polyline(smoothed,{
            color:color, weight:1.8, opacity:0.5,
            dashArray: speed<3?'2,5':speed<3.5?'3,4':'4,3'
          }).addTo(vesselLayer);

          // Arrow Markers (mid-segment)
          for(let i=0;i<smoothed.length-1;i+=Math.max(1,Math.floor(smoothed.length/6))){
            const a=smoothed[i], b=smoothed[Math.min(i+1,smoothed.length-1)];
            const angle=Math.atan2(b[1]-a[1],b[0]-a[0])*180/Math.PI+90;
            L.marker(a,{icon:L.divIcon({
              className:'vessel-arrow',
              html:'<div style="font-size:8px;color:'+color+';opacity:.6;transform:rotate('+angle+'deg)">▶</div>',
              iconSize:[10,10],iconAnchor:[5,5]
            })}).addTo(vesselLayer);
          }

          // End Marker
          const last=smoothed[smoothed.length-1];
          L.circleMarker(last,{radius:2.5,color:color,fillColor:color,fillOpacity:.5,weight:1}).addTo(vesselLayer);
        }
      });

      // —— 围网渔船Tracks：圆形/椭圆包围 (西沙+中沙) ——
      const seineCenters=[
        [15.8,111.8],[16.2,112.4],[15.3,111.2],[16.0,112.8],
        [14.8,114.5],[15.2,115.0],[14.5,114.0],[15.5,115.5],
      ];
      const seineColors=['#c084fc','#a78bfa','#818cf8','#6366f1'];
      seineCenters.forEach(function(center){
        const cx=center[0], cy=center[1];
        const major=rand(0.04,0.08); // 长半轴 (度)
        const minor=rand(0.02,0.05); // 短半轴
        const rotation=rand(0,Math.PI);
        const pts=[];
        for(let angle=0;angle<=Math.PI*2;angle+=0.1){
          const a=angle+rotation;
          const lat=cx+major*Math.cos(a);
          const lng=cy+minor*Math.sin(a);
          pts.push([lat+rand(-0.005,0.005),lng+rand(-0.005,0.005)]);
        }
        // Add short approach line
        const approach=[[cx+rand(-0.3,0.3),cy+rand(-0.3,0.3)],pts[0]];
        const approachPath=smoothPath(approach,0.002);
        const color=seineColors[Math.floor(Math.random()*seineColors.length)];

        // Approach Path (fast)
        L.polyline(approachPath,{color:color,weight:1.5,opacity:.35,dashArray:'8,4'}).addTo(vesselLayer);
        // 包围圈
        L.polyline(pts,{color:color,weight:2,opacity:.55,dashArray:'3,3'}).addTo(vesselLayer);

        // Center Marker
        L.circleMarker(pts[Math.floor(pts.length/2)],{radius:3,color:color,fillColor:color,fillOpacity:.3,weight:1.5}).addTo(vesselLayer);
      });

      // —— 延绳钓渔船Tracks：长直线布设 (Nansha Waters) ——
      const longlineAreas=[
        {center:[9.5,114.5], heading:75,  len:1.2, count:3},
        {center:[8.0,115.0], heading:60,  len:1.0, count:2},
        {center:[10.0,116.0], heading:90, len:0.9, count:3},
      ];
      const llColors=['#f472b6','#e879f9','#c084fc'];
      longlineAreas.forEach(function(area){
        for(let v=0;v<area.count;v++){
          const hdgRad=area.heading*Math.PI/180;
          const dLat=Math.cos(hdgRad)*area.len/111;
          const dLng=Math.sin(hdgRad)*area.len/111/Math.cos(area.center[0]*Math.PI/180);
          const offset=rand(-0.15,0.15);
          const start=[area.center[0]+offset,area.center[1]-area.len/2*Math.sin(hdgRad)/111+rand(-0.05,0.05)];
          const end=[area.center[0]+dLat+offset,area.center[1]+dLng+rand(-0.05,0.05)];
          const pts=smoothPath([start,end],0.005);
          const color=llColors[Math.floor(Math.random()*llColors.length)];

          L.polyline(pts,{color:color,weight:2,opacity:.5,dashArray:'15,6,3,6'}).addTo(vesselLayer);

          // Hook Markers (dot every segment)
          for(let i=0;i<pts.length;i+=Math.max(1,Math.floor(pts.length/12))){
            L.circleMarker(pts[i],{radius:1.2,color:color,fillColor:color,fillOpacity:.4,weight:0.5}).addTo(vesselLayer);
          }
        }
      });

      // —— 中转航行Tracks：港口→渔场 ——
      const transitRoutes=[
        {from:[21.5,108.6],to:[19.0,108.0]}, // Beihai Port → Beibu Gulf Fishing
        {from:[21.0,109.5],to:[18.5,108.5]},
        {from:[16.5,112.5],to:[14.5,114.5]}, // 西沙→中沙
        {from:[10.5,107.0],to:[9.0,114.5]},  // Vietnam → Nansha
      ];
      transitRoutes.forEach(function(route){
        const pts=smoothPath([route.from,route.to],0.01);
        L.polyline(pts,{color:'#94a3b8',weight:1,opacity:.3,dashArray:'10,6'}).addTo(vesselLayer);
      });

      // —— Fishing Activity Heat Points (Vessel Density) ——
      const densitySpots=[
        [19.5,108.0],[18.0,108.5],[17.0,109.0], // 北部湾
        [20.5,111.0],[19.5,111.5],                // 粤西
        [16.0,112.0],[15.5,112.5],                // 西沙
        [15.0,115.0],[14.5,114.5],                // 中沙
        [9.5,114.5],[8.5,115.5],[10.0,116.0],    // 南沙
      ];
      densitySpots.forEach(function(spot){
        L.circle(spot,{radius:rand(15000,35000),color:'#f87171',fillColor:'#f87171',fillOpacity:.04,weight:.5}).addTo(vesselLayer);
      });

      // Hidden by default
      lmLayers.vessel = vesselLayer;
    });
  },150);
}

// Layer toggle function (called by layer-r onclick)
function lmToggleLayer(layerKey, isOn){
  if(!liveMap || !lmLayers[layerKey]) return;
  if(isOn){
    if(!liveMap.hasLayer(lmLayers[layerKey])) lmLayers[layerKey].addTo(liveMap);
  } else {
    if(liveMap.hasLayer(lmLayers[layerKey])) liveMap.removeLayer(lmLayers[layerKey]);
  }
}

// ── MINI REGION MAP (home) ──
let miniMap=null;
function initMiniRegionMap(){
  if(miniMap) return;
  onGeoReady(function(){
    if(miniMap) return;
    miniMap=L.map('mini-region-map',{zoomControl:false,scrollWheelZoom:false,dragging:false,attributionControl:false}).setView([14,115],4);
    tileLayer().addTo(miniMap);
    setTimeout(function(){ if(OFFLINE_MODE) addOfflineFallback(miniMap); }, 100);
    TURTLES.filter(turtle=>turtle.lat>0&&turtle.lat<25&&turtle.lng>105&&turtle.lng<125).forEach(turtle=>{
      const icon=L.divIcon({className:'',html:`<div style="width:9px;height:9px;border-radius:50%;background:${turtle.color};border:1.5px solid rgba(255,255,255,.8)"></div>`,iconSize:[9,9],iconAnchor:[4.5,4.5]});
      L.marker([turtle.lat,turtle.lng],{icon}).addTo(miniMap);
    });
    L.circle([8.5,107.2],{radius:70000,color:'#ef4444',fillColor:'#ef4444',fillOpacity:.1,weight:1.2}).addTo(miniMap);
  });
}

// ── PROFILE TURTLE SELECTOR ──
let currentProfileTurtle = TURTLES[0];
let profileTurtleParam = null;

function buildProfileTurtleDropdown(){
  let drop = document.getElementById('profile-turtle-drop');
  if(!drop) return;
  drop.innerHTML = TURTLES.map(function(t){
    let rLabel = t.risk==='high'?'🔴':t.risk==='med'?'🟡':'🟢';
    return '<div class="pturtle-opt" onclick="switchProfileTurtle(\''+t.id+'\');document.getElementById(\'profile-turtle-drop\').classList.remove(\'show\');document.getElementById(\'profile-turtle-search\').value=\'\'">'+
      '<span class="pto-dot" style="background:'+t.color+'"></span>'+
      '<span class="pto-name">'+t.name+' <span style="font-weight:400;font-size:.7rem;color:rgba(255,255,255,.4)">'+t.id+'</span></span>'+
      '<span class="pto-sub">'+t.sp+' · '+rLabel+'</span>'+
    '</div>';
  }).join('');
}

function filterProfileTurtles(){
  let q = (document.getElementById('profile-turtle-search').value||'').toLowerCase();
  let drop = document.getElementById('profile-turtle-drop');
  drop.classList.add('show');
  let opts = drop.querySelectorAll('.pturtle-opt');
  opts.forEach(function(o){
    let txt = o.textContent.toLowerCase();
    o.style.display = txt.indexOf(q)>=0 ? '' : 'none';
  });
}

function switchProfileTurtle(idOrTurtle){
  let t = typeof idOrTurtle === 'string' ? TURTLES.find(function(x){return x.id===idOrTurtle}) : idOrTurtle;
  if(!t) return;
  currentProfileTurtle = t;
  updateProfileUI(t);
  updateProfileMaps(t);
}

function updateProfileUI(t){
  let el;
  el=document.getElementById('prof-species'); if(el) el.textContent = (t.spEn||t.sp)+' · '+t.sp;
  el=document.getElementById('prof-name'); if(el) el.textContent = t.name;
  el=document.getElementById('prof-loc'); if(el){
    el.innerHTML = '<svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>'+
      (t.origin||'')+' '+t.lat.toFixed(2)+'°N, '+t.lng.toFixed(2)+'°E';
  }
  el=document.getElementById('prof-tag-id'); if(el) el.textContent = '· '+t.id;
  el=document.getElementById('prof-tag-risk'); if(el){
    el.textContent = t.risk==='high'?'High Risk':t.risk==='med'?'Medium Risk':'Low Risk';
  el.className = 'p-tag '+(t.risk==='high'?'c':'');
  }
  el=document.getElementById('prof-avatar'); if(el) el.src = t.photo || '';
  el=document.getElementById('prof-banner'); if(el) el.src = t.photo || '';
  el=document.getElementById('prof-tag-days'); if(el) el.textContent = 'Tracking Day '+(t.bat>80?'189':t.bat>60?'142':'78');
  el=document.getElementById('prof-sidebar-name'); if(el) el.textContent = t.name+' · '+t.id;
  el=document.getElementById('prof-sidebar-sub'); if(el) el.textContent = t.sp+' · '+(t.origin||'')+' · Day '+(t.bat>80?'189':t.bat>60?'142':'78');
  el=document.getElementById('prof-info-sp'); if(el) el.textContent = t.sp;
  el=document.getElementById('prof-info-id'); if(el) el.textContent = '· '+t.id;
  el=document.getElementById('prof-info-origin'); if(el) el.textContent = t.origin||'';
  el=document.getElementById('prof-info-days'); if(el) el.textContent = (t.bat>80?'189':t.bat>60?'142':'78')+' 天';
}

function updateProfileMaps(t){
  if(profMap){
    profMap.setView([t.lat,t.lng], profMap.getZoom());
    profMap.eachLayer(function(layer){ if(layer instanceof L.Polyline || (layer instanceof L.Marker && !layer.getPopup)) profMap.removeLayer(layer); });
    let trackPath = TRACKS[t.id] || [[t.lat-0.5,t.lng-0.5],[t.lat,t.lng]];
    L.polyline(trackPath,{color:t.color,weight:2.5,opacity:.65,dashArray:'8,5'}).addTo(profMap);
  }
  if(profTrackMap){
    profTrackMap.setView([t.lat,t.lng], 6);
    profTrackMap.eachLayer(function(layer){ if(layer instanceof L.Polyline||layer instanceof L.CircleMarker||(layer instanceof L.Marker&&!layer.getPopup)) profTrackMap.removeLayer(layer); });
    let tp = TRACKS[t.id] || [[t.lat-0.5,t.lng-0.5],[t.lat,t.lng]];
    L.polyline(tp,{color:t.color,weight:3,opacity:.7}).addTo(profTrackMap);
    L.circleMarker([t.lat,t.lng],{radius:8,color:t.color,fillColor:t.color,fillOpacity:.4,weight:2}).addTo(profTrackMap).bindPopup('<b>'+t.name+'</b><br>'+t.sp+' · '+t.id);
  }
}

// Close dropdown when clicking outside
document.addEventListener('click',function(e){
  let sel = document.querySelector('.pturtle-sel');
  if(sel && !sel.contains(e.target)){
    let drop = document.getElementById('profile-turtle-drop');
    if(drop) drop.classList.remove('show');
  }
});

// ── PROFILE MINI MAP ──
let profMap=null, profTrackMap=null;
window._profInit=false;
function initProfileMap(){
  window._profInit=true;
  setTimeout(function(){
    onGeoReady(function(){
      profMap=L.map('profile-mini-map',{zoomControl:false,scrollWheelZoom:false,dragging:false,attributionControl:false}).setView([13,115],5);
      tileLayer().addTo(profMap);
      setTimeout(function(){ if(OFFLINE_MODE) addOfflineFallback(profMap); }, 100);
      initProfileMiniMapContent();
      initProfileTrackMapContent();
    });
  },150);
}

function initProfileMiniMapContent(){
  let luna=TURTLES[0];
  let path=TRACKS['BC-XS-2401'];
  L.polyline(path,{color:'#1CA7A8',weight:2.5,opacity:.65,dashArray:'8,5'}).addTo(profMap);
  let startIcon=L.divIcon({className:'',html:'<div style="width:10px;height:10px;border-radius:50%;background:#FF7F50;border:2px solid rgba(255,255,255,.8)"></div>',iconSize:[10,10],iconAnchor:[5,5]});
  L.marker(path[0],{icon:startIcon}).addTo(profMap).bindPopup('Xisha North Island (Origin)');
  let endIcon=L.divIcon({className:'',html:'<div style="width:14px;height:14px;border-radius:50%;background:#1CA7A8;border:2.5px solid rgba(255,255,255,.9);box-shadow:0 0 10px #1CA7A888"></div>',iconSize:[14,14],iconAnchor:[7,7]});
  L.marker(path[path.length-1],{icon:endIcon}).addTo(profMap).bindPopup('Luna current position').openPopup();
}

function initProfileTrackMapContent(){
  let path=TRACKS['BC-XS-2401'];
  let trackMapEl=document.getElementById('profile-mini-map-track');
  if(trackMapEl && !profTrackMap){
    profTrackMap=L.map('profile-mini-map-track',{zoomControl:true,scrollWheelZoom:true,attributionControl:false}).setView([16,113],6);
    tileLayer().addTo(profTrackMap);
    setTimeout(function(){
      profTrackMap.invalidateSize();
      if(OFFLINE_MODE) addOfflineFallback(profTrackMap);
    }, 300);
    L.polyline(path,{color:'#1CA7A8',weight:3,opacity:.7}).addTo(profTrackMap);
    let startIcon=L.divIcon({className:'',html:'<div style="width:10px;height:10px;border-radius:50%;background:#FF7F50;border:2px solid rgba(255,255,255,.8)"></div>',iconSize:[10,10],iconAnchor:[5,5]});
    let waypoints=[
      [16.97,112.35,'Xisha North Island · Start',   '#FF7F50'],
      [15.8, 113.5, 'West Zhongsha · Day 23', '#f59e0b'],
      [12.4, 110.8, 'Vietnam Offshore · Day 78', '#ef4444'],
      [19.8, 111.2, 'East Hainan · Day 142','#22c55e'],
      [16.97,112.32,'Current Position · Day 189','#1CA7A8'],
    ];
    waypoints.forEach(function(wp){
      L.circleMarker([wp[0],wp[1]],{radius:5,color:wp[3],fillColor:wp[3],fillOpacity:.6,weight:2})
       .addTo(profTrackMap).bindPopup('<b>'+wp[2]+'</b><br>'+wp[0].toFixed(2)+'°N, '+wp[1].toFixed(2)+'°E');
    });
    L.marker([waypoints[0][0],waypoints[0][1]],{icon:startIcon}).addTo(profTrackMap);
    let curIcon=L.divIcon({className:'',html:'<div style="width:16px;height:16px;border-radius:50%;background:#1CA7A8;border:3px solid rgba(255,255,255,.9);box-shadow:0 0 12px #1CA7A888"></div>',iconSize:[16,16],iconAnchor:[8,8]});
    L.marker([waypoints[4][0],waypoints[4][1]],{icon:curIcon}).addTo(profTrackMap);
  }
}

// ── CONSERVATION MINI MAPS ──
let conMap=null;
window._conInit=false;
function initConMaps(){
  window._conInit=true;
  setTimeout(function(){
    onGeoReady(function(){
      conMap=L.map('con-mini-map',{zoomControl:false,scrollWheelZoom:false,dragging:false,attributionControl:false}).setView([14,116],4);
      tileLayer().addTo(conMap);
      setTimeout(function(){ if(OFFLINE_MODE) addOfflineFallback(conMap); }, 100);
    TURTLES.filter(turtle=>turtle.risk!=='low').forEach(turtle=>{
      const icon=L.divIcon({className:'',html:`<div style="width:12px;height:12px;border-radius:50%;background:${turtle.risk==='high'?'#ef4444':'#f59e0b'};border:2px solid rgba(255,255,255,.85)"></div>`,iconSize:[12,12],iconAnchor:[6,6]});
      L.marker([turtle.lat,turtle.lng],{icon}).addTo(conMap).bindPopup(makePopup(turtle));
    });
    [[8.5,107.2,90000,'#ef4444'],[12.5,114.2,60000,'#f59e0b'],[20.5,118.8,50000,'#f59e0b']].forEach(([lat,lng,r,c])=>{
      L.circle([lat,lng],{radius:r,color:c,fillColor:c,fillOpacity:.1,weight:1.5,dashArray:'5,4'}).addTo(conMap);
    });
    });
    buildTrendBars();
  },150);
}

// ── ACTIVITY FEED ──
let EVENTS = [
  {av:'<img src="/img/turtles/BC-xs-2401.png" style="width:32px;height:32px;border-radius:50%;object-fit:cover" alt="Luna"/>',name:'Luna · BC-XS-2401',sp:'Green Turtle',sub:'Xisha North Is. seagrass foraging · 14.6 km today',time:'2 min ago',tag:'Online',tc:'p-green'},
  {av:'<img src="/img/turtles/bc-sb-2315.png" style="width:32px;height:32px;border-radius:50%;object-fit:cover" alt="Selingan"/>',name:'Selingan · BC-SB-2315 — Alert',sp:'Green Turtle',sub:'Borneo Turtle Islands · Battery 43% · 6 hrs no full upload',time:'14 min ago',tag:'Critical',tc:'p-red'},
  {av:'🤖',name:'AI Migration Forecast Update',sp:'10 active turtles',sub:'Xisha–Hainan migration model refresh · 87% accuracy',time:'31 min ago',tag:'AI',tc:'p-teal'},
  {av:'<img src="/img/turtles/bc-hn-2418.jpg" style="width:32px;height:32px;border-radius:50%;object-fit:cover" alt="Wenchang"/>',name:'Wenchang · BC-HN-2418',sp:'Green Turtle',sub:'E. Hainan coastal 19.8°N · Signal restored',time:'1 hr ago',tag:'Online',tc:'p-green'},
  {av:'🌡️',name:'SST Anomaly',sp:'Central SCS 15°N–18°N',sub:'SST 30.6°C · +1.1°C above May climatology 29.5°C',time:'3 hr ago',tag:'Warning',tc:'p-amber'},
  {av:'<img src="/img/turtles/BC-XS-2421.png" style="width:32px;height:32px;border-radius:50%;object-fit:cover" alt="Pearl"/>',name:'Pearl · BC-XS-2421',sp:'Green Turtle',sub:'Xisha North Is. nesting area foraging · Night dive 22 m',time:'4 hr ago',tag:'Online',tc:'p-green'},
  {av:'📡',name:'Remote Device Upgrade',sp:'Côn Đảo · BC-CD-2304',sub:'TT-L4-P firmware upgrade to v4.2.1',time:'6 hr ago',tag:'Device',tc:'p-dim'},
];
function buildFeed(){
  const el=document.getElementById('activity-feed');
  if(!el) return;
  el.innerHTML=EVENTS.map(e=>`
    <div class="fi">
      <div class="fi-av" style="background:rgba(255,255,255,.06);font-size:1rem">${e.av}</div>
      <div class="fi-body">
        <div class="fi-name">${e.name} <span class="pill ${e.tc}" style="font-size:.65rem">${e.tag}</span></div>
        <div class="fi-sub">${e.sp} · ${e.sub}</div>
        <div class="fi-time">${e.time}</div>
      </div>
    </div>`).join('');
}

// ── SPARK LINES ──
function buildSpark(id, vals, color){
  const el=document.getElementById(id); if(!el) return;
  const max=Math.max(...vals);
  el.innerHTML=vals.map(v=>{
    const h=Math.max(3,Math.round(v/max*22));
    return `<div class="sb" style="height:${h}px;background:${color}66"></div>`;
  }).join('');
}
function buildAllSparks(){
  buildSpark('sp-online',[112,118,121,123,125,128,127],'#1CA7A8');
  buildSpark('sp-speed',[1.8,2.1,2.3,1.9,2.0,2.2,2.1],'#FF7F50');
  buildSpark('sp-depth',[28,35,42,31,38,44,38],'#22c55e');
  buildSpark('sp-alerts',[2,4,3,5,4,3,3],'#f59e0b');
  buildSpark('sp-dist',[4,5,6,4,6,5,5],'#60a5fa');
  buildSpark('sp-temp',[24.1,24.3,24.5,24.4,24.8,24.7,24.8],'#ef4444');
}

// ── PROFILE BAR CHART ──
function buildProfileBars(){
  const el=document.getElementById('profile-bars'); if(!el) return;
  const months=['11月','12月','1月','2月','3月','4月'];
  const vals=[336,498,612,485,524,469];
  const max=Math.max(...vals);
  el.innerHTML=months.map((m,i)=>{
    const h=Math.round(vals[i]/max*76);
    return `<div class="bw"><span class="bval">${vals[i]}</span><div class="bar${i===5?' on':''}" style="height:${h}px"></div><span class="blbl">${m}</span></div>`;
  }).join('');
  el.querySelectorAll('.bar').forEach(b=>b.addEventListener('click',()=>{el.querySelectorAll('.bar').forEach(x=>x.classList.remove('on'));b.classList.add('on')}));
  // Track Panel: Daily Movement Distance
  const tel2=document.getElementById('profile-track-bars');
  if(tel2){
    const days=['Day 160','','165','','170','','175','','180','','185',''];
    const dvals=[8.2,5.1,3.4,12.8,6.3,4.7,15.2,9.8,5.5,3.2,11.4,7.6];
    const dmax=Math.max(...dvals);
    tel2.innerHTML=days.map((d,i)=>`<div class="bw"><span class="bval">${dvals[i]}</span><div class="bar" style="height:${Math.round(dvals[i]/dmax*76)}px"></div>${d?`<span class="blbl">${d}</span>`:`<span class="blbl"></span>`}</div>`).join('');
  }
}

// ── TREND BARS ──
// ── CONSERVATION ACTION HANDLERS ──
function conGenReport(){
  alert('📄 Generate Conservation Action Report\\n\\nGenerating comprehensive conservation action report...\\n\\nIncludes:\n• Risk Alert Summary\\n• Species Status Analysis\\n• Vessel Collision Risk Assessment\\n• MPA Recommendations\\n\\nReport will be sent to your registered email');
}

function conEmergency(){
  alert('⚠️ Emergency Alert\\n\\nSend emergency notification to all relevant personnel！\\n\\nCurrent high-risk alerts: 3\\n\\nConfirm send？');
}

function conRespond(target){
  alert('✅ Responded\\n\\nTarget: '+target+'\\n\\nResponse recorded. Personnel will follow up immediately.');
}

function conContact(target){
  alert('📞 Contact Personnel\\n\\nEstablishing connection with '+target+' monitoring station...\\n\\nAvailable contacts: Sat Phone / VHF / Email');
}

function conAnnotate(){
  alert('🏷️ Annotation Added\\n\\nThis alert has been annotated as"Environmental Anomaly"，System will continue monitoring SST trends。');
}

function conDismiss(){
  alert('🚫 Dismissed\\n\\nThis alert has been marked as"Dismissed"，No further notifications。');
}

function conNotify(){
  alert('🔔 Notification Sent\\n\\nNotified Wangan station staff to monitor device battery recovery.');
}

function conShowAll(){
  alert('📋 All Active Alerts\\n\\nCurrently 5 active alerts total：\\n• Critical：1  (Selingan)\\n• High Risk：2  (Côn Đảo, SST Anomaly)\\n• Medium Risk：2  (Wenchang, Wangan)\\n• Low risk/Closed：3');
}

function conDownloadReport(type){
  alert('📥 Download Report: '+type+'\\n\\nPreparing PDF download...\\n\\n（Demo: download link sent to registered email）');
}

function conSubmitProtect(area){
  alert('✅ Protected Area Application Submitted\\n\\nArea: '+area+'\\n\\nApplication sent for review. Expected feedback in 5-7 business days.');
}

// ── 交互补全 (2026-05-04) ──
function conAddAlert(){ goTo('conservation'); alert('📋 View existing alerts on Conservation page or create via API.'); }
function shareProfile(){ let url=window.location.href; if(navigator.clipboard){navigator.clipboard.writeText(url).then(function(){alert('✅ Profile link copied to clipboard');});}else{prompt('Copy link to share:',url);} }
function followTurtle(id){ alert('❤ Following!\\n\\nYou will be notified when this turtle reaches new waters or triggers an alert.\\n\\n（Notification requires login）'); }
function reDownload(name){ alert('📥 Re-download: '+name+'\\n\\nFile preparing…\\n\\n（Demo mode, full download requires API Key）'); }
function registerSubmit(){ let em=document.getElementById('reg-email'); if(!em||!em.value){alert('Please enter email address');return;} if(!/^[^@]+@[^@]+\\.[^@]+$/.test(em.value)){alert('Please enter a valid email');return;} alert('✅ Registration Successful!\\n\\nVerification email sent to '+em.value); }
function hwSubmitTrial(){
  var name = document.getElementById('hw-trial-name');
  var org = document.getElementById('hw-trial-org');
  var email = document.getElementById('hw-trial-email');
  if(!name || !name.value.trim()){ alert('Please enter your name'); return; }
  if(!org || !org.value.trim()){ alert('Please enter institution name'); return; }
  if(!email || !email.value.trim() || !/^[^@]+@[^@]+\.[^@]+$/.test(email.value.trim())){ alert('Please enter a valid email'); return; }
  alert('✅ Trial Application Submitted！\\n\\n2-3  business days review，Results sent via email.'); }
function hwViewCases(){ window.open('https://www.seaturtle.org/tracking/','_blank'); }
function viewReport(){ goTo('conservation'); }
function rschReDownload(el){ let card=el.closest('.hp-card'); let name=card?card.querySelector('.hp-card-title').textContent:'Data'; reDownload(name); }

function buildTrendBars(){
  const el=document.getElementById('trend-bars'); if(!el) return;
  const data=[5,8,6,12,9,7,15,11,8,6,9,14,10,7,5,8,11,13,9,6,8,10,12,7,9,11,8,14,16,8];
  const max=Math.max(...data);
  el.innerHTML=data.map((v,i)=>{
    const h=Math.max(2,Math.round(v/max*66));
    const cls=v>=14?'hi':v>=10?'md':'lo';
    return `<div style="flex:1;display:flex;flex-direction:column;align-items:center;gap:2px"><div class="tb ${cls}" style="height:${h}px" title="${v} alerts"></div>${i%5===0?`<span class="tc-lbl">${i+1}d</span>`:'<span class="tc-lbl"></span>'}</div>`;
  }).join('');
}

// ── REAL-TIME DATA FROM API ──
let _kpiCache = null;
let _kpiLastFetch = 0;
const KPI_CACHE_TTL = 30000; // 30s

async function updateRealtime(){
  try {
    // Fetch from API (with cache)
    const now = Date.now();
    if (!_kpiCache || (now - _kpiLastFetch) > KPI_CACHE_TTL) {
      const [tResp, aResp] = await Promise.all([
        fetch(API_BASE + '/turtles/?limit=200'),
        fetch(API_BASE + '/alerts/?limit=200')
      ]);
      const tData = await tResp.json();
      const aData = await aResp.json();
      const turtles = tData.items || [];

      // Species breakdown
      const spMap = {};
      turtles.forEach(function(t){
        const sp = t.species || 'Unknown';
        spMap[sp] = (spMap[sp] || 0) + 1;
      });

      _kpiCache = {
        online: turtles.length,
        species: spMap,
        totalAlerts: aData.total || (aData.items ? aData.items.length : 0)
      };
      _kpiLastFetch = now;
    }

    const kpi = _kpiCache;
    const online = kpi.online;
    const totalAlerts = kpi.totalAlerts;

    // Update turtle count displays
    ['s-online','home-online-count','hero-live-num','g-online'].forEach(function(id){
      var el = document.getElementById(id); if(el) el.textContent = online;
    });

    // Update species cards (IDs added in HTML)
    const spGreen = kpi.species['绿海龟'] || 0;
    const spLeatherback = kpi.species['棱皮龟'] || 0;
    const spHawksbill = kpi.species['玳瑁'] || 0;
    const spOliveRidley = kpi.species['丽龟'] || 0;
    const total = online || 1;

    function setText(id, val){ var el = document.getElementById(id); if(el) el.textContent = val; }
    function pct(n){ return total>0 ? (n/total*100).toFixed(1) + '%' : '0%'; }

    setText('sp-count-green', spGreen);
    setText('sp-meta-green', pct(spGreen) + ' · IUCN Endangered');
    setText('sp-count-leatherback', spLeatherback);
    setText('sp-meta-leatherback', pct(spLeatherback) + ' · IUCN Vulnerable');
    setText('sp-count-hawksbill', spHawksbill);
    setText('sp-meta-hawksbill', pct(spHawksbill) + ' · IUCN Critically Endangered');
    setText('sp-count-oliveridley', spOliveRidley);
    setText('sp-meta-oliveridley', pct(spOliveRidley) + ' · IUCN Vulnerable');

    // Update alerts
    setText('g-alerts', totalAlerts);
    var alEl = document.getElementById('alert-count');
    if(alEl) alEl.textContent = totalAlerts;

    // Update "last updated" timestamp
    var lu = document.getElementById('last-update');
    if(lu) lu.textContent = 'just now';

    // Simulated sensor data (no real-time sensor API yet)
    var sd = document.getElementById('s-dist');
    if(sd) sd.textContent = '—';
    var st = document.getElementById('g-temp');
    if(st) st.textContent = '—';
    var gs = document.getElementById('g-speed');
    if(gs) gs.textContent = '—';
    var gd = document.getElementById('g-depth');
    if(gd) gd.textContent = '—';

  } catch(e) {
    console.warn('updateRealtime fetch failed:', e);
  }
}

// ── INTERACTIONS ──
document.querySelectorAll('.chip,.fc').forEach(c=>{
  c.addEventListener('click',()=>{
    const g=c.closest('.chip-row,.filter-bar');
    if(g){g.querySelectorAll('.chip,.fc').forEach(x=>x.classList.remove('on','on2'))}
    c.classList.toggle('on');
  });
});
function lmpTab(el){
  el.closest('.lmp-tabs').querySelectorAll('.lmpt').forEach(tab=>tab.classList.remove('on'));
  el.classList.add('on');
  const tabKey = el.getAttribute('data-tab') || 'list';
  const body = el.closest('.lm-panel').querySelector('.lmp-body');
  body.querySelectorAll('.lmp-tab-content').forEach(p=>p.style.display='none');
  const panel = document.getElementById('lmp-'+tabKey);
  if(panel) panel.style.display='block';
}
// Live Map Filter Chip Toggle
function lmFilterChip(el, isAll){
  const row = el.closest('.chip-row');
  if(isAll){
    // Click 'All': clear other chips, keep self on2
    row.querySelectorAll('.chip').forEach(c=>c.classList.remove('on'));
    el.classList.add('on2');
  } else {
    // 点击具体Species/Area: Deselect"All"的 on2 状态
    const allChip = row.querySelector('.chip.on2');
    if(allChip) allChip.classList.remove('on2');
    el.classList.toggle('on');
  }
}
// Layer Toggle: Switch UI then map layer
function lmToggleLayerRow(rowEl, layerKey){
  const tog = rowEl.querySelector('.tog');
  tog.classList.toggle('on');
  const isOn = tog.classList.contains('on');
  if(typeof lmToggleLayer === 'function') lmToggleLayer(layerKey, isOn);
}
function ptab(el){
  el.closest('.p-tabs').querySelectorAll('.ptab').forEach(tab=>tab.classList.remove('on'));
  el.classList.add('on');
  const tabKey = el.getAttribute('data-tab') || 'overview';
  if(tabKey === 'overview'){
    document.querySelectorAll('.prof-tab-content').forEach(function(p){ p.classList.add('active'); });
  } else {
    document.querySelectorAll('.prof-tab-content').forEach(function(p){ p.classList.remove('active'); });
    const panel = document.getElementById('prof-'+tabKey);
    if(panel){ panel.classList.add('active'); panel.scrollIntoView({behavior:'smooth',block:'start'}); }
  }
}
document.querySelectorAll('.t-row').forEach(r=>{
  r.addEventListener('click',()=>{
    r.closest('.lmp-body').querySelectorAll('.t-row').forEach(x=>x.classList.remove('sel'));
    r.classList.add('sel');
  });
});
document.querySelectorAll('tbody tr').forEach(r=>{
  r.addEventListener('click',()=>{
    document.querySelectorAll('tbody tr').forEach(x=>x.style.background='');
    r.style.background='rgba(28,167,168,.04)';
  });
});
document.querySelectorAll('.pgb').forEach(b=>{
  b.addEventListener('click',()=>{
    if(['‹','›','…'].includes(b.textContent)) return;
    b.closest('.pag-btns').querySelectorAll('.pgb').forEach(x=>x.classList.remove('on'));
    b.classList.add('on');
  });
});
document.querySelectorAll('.rn-item').forEach(n=>{
  n.addEventListener('click',()=>{
    n.closest('.rsb-nav').querySelectorAll('.rn-item').forEach(x=>x.classList.remove('on'));
    n.classList.add('on');
  });
});

// ── LEAFLET FAILURE DETECTION ──
// If Leaflet itself didn't load (CDN blocked), render static SVG maps instead
function renderStaticSvgMap(elId){
  let el = document.getElementById(elId);
  if(!el) return;
  el.innerHTML = '<div style="width:100%;height:100%;background:url(\''+offlineSvgUrl()+'\') center/cover no-repeat;background-color:#082942;position:relative" id="static-'+elId+'"></div>';
  // overlay turtle dots positioned by lat/lng → percentage of bbox
  // bbox: lat -25→40, lng 95→155 (matching offline SVG bounds)
  let stat = document.getElementById('static-'+elId);
  if(typeof TURTLES === 'undefined') return;
  TURTLES.forEach(function(t){
    if(t.lng < 95 || t.lng > 155 || t.lat < -25 || t.lat > 40) return;
    let x = (t.lng - 95) / (155 - 95) * 100;
    let y = (40 - t.lat) / (40 - (-25)) * 100;
    let dot = document.createElement('div');
    dot.style.cssText = 'position:absolute;left:'+x+'%;top:'+y+'%;width:10px;height:10px;border-radius:50%;background:'+t.color+';border:2px solid rgba(255,255,255,.85);box-shadow:0 0 10px '+t.color+'88;transform:translate(-50%,-50%);cursor:pointer;z-index:5';
    dot.title = t.name + ' · ' + t.sp;
    if(t.risk === 'high'){
      dot.style.boxShadow = '0 0 0 0 rgba(239,68,68,.6)';
      dot.style.animation = 'warn-ring 1s ease-out infinite';
    }
    stat.appendChild(dot);
  });
}

function checkLeafletAndFallback(){
  if(typeof L === 'undefined' || !L.map){
['hero-map','livemap-leaflet','mini-region-map','profile-mini-map','con-mini-map'].forEach(renderStaticSvgMap);
    return true;
  }
  return false;
}


// ════════════════════════════════════════════════════════════════════
// Blue Circle Map Visualization Enhancement — Phase B
// Features: Heatmap, Species Pie Chart, Timeline Animation, Corridor
// Injected into index.html via sed
// ════════════════════════════════════════════════════════════════════

// ── Globals ──────────────────────────────────────────────────────────
let bcHeatLayer = null;       // Leaflet.heat layer
let bcHeatEnabled = false;
let bcTimelineSlider = null;
let bcTimelinePlaying = false;
let bcTimelineFrame = 0;
let bcTimelineTimer = null;
let bcPieChart = null;       // Chart.js instance

// ── Heatmap ──────────────────────────────────────────────────────────

async function bcFetchHeatmap(days, turtleId, species){
  if(typeof apiFetch !== 'function'){ console.warn('[BC Viz] apiFetch not available'); return null; }
  let params = [];
  if(days) params.push('days=' + days);
  if(turtleId) params.push('turtle_id=' + turtleId);
  if(species) params.push('species=' + species);
  params.push('resolution=0.5');
  let url = '/api/v1/map/heatmap?' + params.join('&');
  let data = await apiFetch(url);
  return data;
}

function bcToggleHeatmap(on){
  if(typeof L === 'undefined' || !L.heatLayer){ console.warn('[BC Viz] Leaflet.heat not loaded'); return; }
  if(!window.liveMap){ console.warn('[BC Viz] liveMap not initialized'); return; }

  bcHeatEnabled = (on !== undefined) ? on : !bcHeatEnabled;

  let btn = document.getElementById('bc-heat-btn');
  if(btn) btn.classList.toggle('active', bcHeatEnabled);

  if(bcHeatEnabled){
    if(!bcHeatLayer){
      bcRenderHeatmap(30);
    } else {
      bcHeatLayer.addTo(window.liveMap);
    }
  } else {
    if(bcHeatLayer) window.liveMap.removeLayer(bcHeatLayer);
  }
}

async function bcRenderHeatmap(days){
  let data = await bcFetchHeatmap(days || 30);
  if(!data || !data.points || data.points.length === 0){
    console.warn('[BC Viz] No heatmap data');
    return;
  }

  // Convert to [[lat, lng, weight]] format for Leaflet.heat
  let heatData = data.points.map(function(p){
    return [p.lat, p.lng, Math.min(p.weight, 200) * 0.005]; // Normalize weight
  });

  if(bcHeatLayer) window.liveMap.removeLayer(bcHeatLayer);

  bcHeatLayer = L.heatLayer(heatData, {
    radius: 25,
    blur: 15,
    maxZoom: 10,
    max: 1.0,
    gradient: {0.0: '#0a1628', 0.3: '#1CA7A8', 0.6: '#f0c040', 0.9: '#ef4444'}
  });

  if(bcHeatEnabled && window.liveMap) bcHeatLayer.addTo(window.liveMap);
}

// ── Species Distribution Pie Chart ──────────────────────────────────

async function bcRenderPieChart(){
  if(typeof Chart === 'undefined'){
    console.warn('[BC Viz] Chart.js not loaded — skipping pie chart');
    return;
  }

  let data = await apiFetch('/api/v1/map/distribution');
  if(!data || !data.species) return;

  let ctx = document.getElementById('bc-pie-canvas');
  if(!ctx) return;

  let labels = data.species.map(function(s){ return s.species; });
  let counts = data.species.map(function(s){ return s.count; });
  let colors = ['#1CA7A8','#FF7F50','#ef4444','#f0c040','#6b9fd4','#60d060','#c060f0'];

  if(bcPieChart) bcPieChart.destroy();

  bcPieChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: labels,
      datasets: [{
        data: counts,
        backgroundColor: colors.slice(0, labels.length),
        borderColor: '#0a1628',
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom',
          labels: { color: '#94a3b8', font: { size: 11 }, padding: 12 }
        },
        tooltip: {
          callbacks: {
            label: function(ctx){ return ctx.label + ': ' + ctx.raw + ' (' + data.species[ctx.dataIndex].percentage + '%)'; }
          }
        }
      }
    }
  });
}

// ── Timeline Animation ───────────────────────────────────────────────

function bcInitTimeline(){
  let slider = document.getElementById('bc-timeline-slider');
  if(!slider) return;

  bcTimelineSlider = slider;
  slider.addEventListener('input', function(){
    bcTimelineFrame = parseInt(slider.value);
    bcUpdateTimelineFrame();
  });

  // Play button
  let playBtn = document.getElementById('bc-timeline-play');
  if(playBtn){
    playBtn.addEventListener('click', function(){
      if(bcTimelinePlaying){
        bcTimelinePause();
        playBtn.textContent = '▶';
      } else {
        bcTimelinePlay();
        playBtn.textContent = '⏸';
      }
    });
  }
}

function bcTimelinePlay(){
  bcTimelinePlaying = true;
  bcTimelineTimer = setInterval(function(){
    bcTimelineFrame++;
    if(bcTimelineFrame > 100){ bcTimelineFrame = 0; bcTimelinePause(); return; }
    if(bcTimelineSlider) bcTimelineSlider.value = bcTimelineFrame;
    bcUpdateTimelineFrame();
  }, 200);
}

function bcTimelinePause(){
  bcTimelinePlaying = false;
  if(bcTimelineTimer){ clearInterval(bcTimelineTimer); bcTimelineTimer = null; }
  let playBtn = document.getElementById('bc-timeline-play');
  if(playBtn) playBtn.textContent = '▶';
}

function bcUpdateTimelineFrame(){
  // Redraw polylines for all turtles, showing only points up to bcTimelineFrame%
  if(!window.TURTLES || !window.TRACKS) return;

  let trackingLayer = window.trackingLayer;
  if(!trackingLayer) return;

  // Re-render: clear layer and redraw
  trackingLayer.clearLayers();
  let pct = bcTimelineFrame / 100;

  window.TURTLES.forEach(function(turtle){
    let icon = window._turtleIcon || L.icon({
      iconUrl: 'data:image/svg+xml,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"><circle cx="7" cy="7" r="6" fill="' + (turtle.color||'#1CA7A8') + '" stroke="white" stroke-width="2"/></svg>'),
      iconSize: [14,14], iconAnchor: [7,7]
    });

    let tracks = window.TRACKS[turtle.id];
    if(tracks && tracks.length > 1){
      let visibleTracks = tracks.slice(0, Math.ceil(tracks.length * pct));
      if(visibleTracks.length > 1){
        L.polyline(visibleTracks, {
          color: turtle.color || '#1CA7A8',
          weight: 2, opacity: 0.55,
          dashArray: '6,5'
        }).addTo(trackingLayer);

        // Show marker at the end of visible tracks
        let lastPt = visibleTracks[visibleTracks.length - 1];
        L.marker(lastPt, {icon: icon}).addTo(trackingLayer)
          .bindPopup('<div style="font-size:.75rem"><strong>' + turtle.name + '</strong><br>' +
            (turtle.species || '') + '<br>🔋 ' + (turtle.bat||'—') + '%</div>', {maxWidth: 180});
      }
    }
  });
}

// ── Corridor Overlay ─────────────────────────────────────────────────

async function bcShowCorridor(turtleId){
  if(typeof apiFetch !== 'function') return;

  let data = await apiFetch('/api/v1/map/corridor/' + turtleId);
  if(!data || !data.corridor_points) return;

  // Create corridor polygon (buffer around points)
  let points = data.corridor_points.map(function(p){ return [p.lat, p.lng]; });

  if(points.length < 2) return;

  // Draw corridor as a wide semi-transparent polyline
  if(window._bcCorridorLayer) window.liveMap.removeLayer(window._bcCorridorLayer);

  window._bcCorridorLayer = L.layerGroup();

  // Draw the corridor path with varying width based on density
  L.polyline(points, {
    color: '#2d8cf0',
    weight: 8,
    opacity: 0.3,
    dashArray: '10,5'
  }).addTo(window._bcCorridorLayer);

  // Draw centerline
  L.polyline(points, {
    color: '#2d8cf0',
    weight: 2,
    opacity: 0.8
  }).addTo(window._bcCorridorLayer);

  // Direction arrow at midpoint
  if(points.length >= 2){
    let mid = Math.floor(points.length / 2);
    let marker = L.marker(points[mid], {
      icon: L.divIcon({
        html: '<div style="font-size:18px;transform:rotate(' +
          (data.direction==='north'?'0':data.direction==='south'?'180':'90') +
          'deg)">➤</div>',
        className: 'bc-corridor-arrow',
        iconSize: [20,20], iconAnchor: [10,10]
      })
    }).addTo(window._bcCorridorLayer);
  }

  window._bcCorridorLayer.addTo(window.liveMap);

  // Show info popup
  if(window.liveMap){
    L.popup()
      .setLatLng(points[0])
      .setContent(
        '<div style="font-size:.8rem;line-height:1.4">' +
        '<strong>' + data.turtle_name + '</strong><br>' +
        '📏 Migration Distance: ' + data.distance_km + ' km<br>' +
        '📐 Corridor Width: ' + data.corridor_width_km + ' km<br>' +
        '🧭 Direction: ' + data.direction + '<br>' +
        '📍 TracksPoints: ' + data.total_track_points +
        '</div>'
      )
      .openOn(window.liveMap);
  }
}

// ── Species filter for heatmap ──────────────────────────────────────
// ── Initialize on page load ──────────────────────────────────────────

function bcInitMapViz(){
  // Add heatmap toggle button to map controls if not exists
  if(!document.getElementById('bc-heat-btn')){
    // Find the existing layer toggle container
    let layerRow = document.querySelector('.layer-r');
    if(layerRow && layerRow.parentNode){
      let btn = document.createElement('button');
      btn.id = 'bc-heat-btn';
      btn.className = 'bc-viz-btn';
      btn.textContent = '🔥 Heatmap';
      btn.title = 'Toggle Activity Heatmap';
      btn.onclick = function(){ bcToggleHeatmap(); };
      btn.style.cssText = 'background:#152a45;color:#94a3b8;border:1px solid #1a3050;border-radius:6px;padding:4px 10px;font-size:.7rem;cursor:pointer;margin:4px 2px;';
      layerRow.parentNode.insertBefore(btn, layerRow.nextSibling);

      // Hover effect
      btn.addEventListener('mouseenter', function(){ btn.style.background='#1a3050'; btn.style.color='#e0e8f0'; });
      btn.addEventListener('mouseleave', function(){
        if(!bcHeatEnabled){ btn.style.background='#152a45'; btn.style.color='#94a3b8'; }
      });
    }
  }

  // Add timeline control bar
  if(!document.getElementById('bc-timeline-bar')){
    let mapContainer = document.getElementById('livemap-leaflet');
    if(mapContainer && mapContainer.parentNode){
      let timelineBar = document.createElement('div');
      timelineBar.id = 'bc-timeline-bar';
      timelineBar.style.cssText = 'position:absolute;bottom:12px;left:12px;right:60px;z-index:1000;background:rgba(10,22,40,.92);border-radius:8px;padding:8px 12px;display:flex;align-items:center;gap:8px;border:1px solid #1a3050;';
      timelineBar.innerHTML = '' +
        '<button id="bc-timeline-play" style="background:#1CA7A8;color:#fff;border:none;border-radius:4px;width:28px;height:28px;cursor:pointer;font-size:12px;flex-shrink:0">▶</button>' +
        '<input type="range" id="bc-timeline-slider" min="0" max="100" value="100" style="flex:1;accent-color:#1CA7A8;height:4px;cursor:pointer">' +
        '<span style="color:#6b9fd4;font-size:.65rem;flex-shrink:0;min-width:60px;text-align:right" data-t="viz.timeline">Timeline Playback</span>';
      mapContainer.parentNode.style.position = 'relative';
      mapContainer.parentNode.appendChild(timelineBar);

      bcInitTimeline();
    }
  }

  // Initialize species pie chart
  if(typeof Chart !== 'undefined' && document.getElementById('bc-pie-canvas')){
    bcRenderPieChart();
  }

  // Expose corridor function to global scope
  window.bcShowCorridor = bcShowCorridor;
}

// ── Hook into existing init ──────────────────────────────────────────
// Wait for map to be ready, then init our viz features
let bcOrigInitLiveMap = window.initLiveMap;
window.initLiveMap = function(){
  if(bcOrigInitLiveMap) bcOrigInitLiveMap.apply(this, arguments);
  // Delay to ensure map + trackingLayer are set up
  setTimeout(function(){
    if(typeof L !== 'undefined' && L.heatLayer){
      bcInitMapViz();
      // Auto-load heatmap if data available
      bcRenderHeatmap(30);
    } else {
      // Leaflet.heat not yet loaded — retry
}
  }, 1500);
};

// Also hook into existing species distribution widget if present
if(document.querySelector('[data-t="act.sptitle"]')){
  setTimeout(function(){
    if(typeof Chart !== 'undefined' && !bcPieChart){
      bcInitMapViz();
    }
  }, 2000);
}
// ── INIT ──
window.addEventListener('load',()=>{
  detectRegion();
  
  // Init language from localStorage or default zh
  let saved = localStorage.getItem('tt_lang') || 'en';
  if(saved !== 'en') { setLang(saved); } else { renderAllText('en'); }
  // Load data from API (falls back to static if API unavailable)
  // ═══ REPLACE __RENDER_API_URL__ with your Render backend URL ═══
  var RENDER_URL = (typeof API_BACKEND_URL !== 'undefined' && API_BACKEND_URL !== '__RENDER_API_URL__') ? API_BACKEND_URL : '';
  apiInit(RENDER_URL + "/api/v1"); initApiData().then(function(){
    buildFeed();
    buildAllSparks();
    buildProfileBars();
    buildTrendBars();
  });
  // init hero map + mini maps after short delay
  setTimeout(()=>{
    initHeroMap();
    initMiniRegionMap();
  }, 300);
  // real-time update loop
  setInterval(updateRealtime, 4000);
});
