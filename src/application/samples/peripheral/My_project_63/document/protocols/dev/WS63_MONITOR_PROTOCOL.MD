# WS63 ↔ 串口屏 通信协议（Page1-5）

> **适用型号**: 淘晶驰 T1系列 4.3寸 480\*272  
> **物理层**: UART, 115200bps, 8N1, 3.3V TTL  
> **帧格式**: 逗号分隔文本帧（CSV-like），帧头 `#` / `@`，帧尾 `\r\n`  
> **屏端模式**: `recmod=1` 主动解析  
> **文档版本**: v2.3  
> **最后更新**: 2026-05-27  
> **v2.3 更新**: 新增 Page5 设置（WiFi连接/断开、背光调节）；所有页面 b3 返回统一加 cancel 帧；同步代码汇总  
> **v2.2 更新**: 新增 Page4 查找定位（分页列表+标签蜂鸣）；补全 ESP32 命令映射  
> **v2.1 更新**: 对齐 PROTOCOL.md v3.3 outbound 分步流程（新增 #ASSET_INFO 帧、出库 asset_info 确认步骤、task_done 改用 is_match 判断）  
> **v2.0 更新**: 新增 Page3 盘点；对齐 PROTOCOL.md v3.3（get_asset/inventory 命令映射、asset_detail/asset_info 下行帧）

---

## 一、帧格式总则

### 1.1 文本帧结构

```
帧头(1B) + 命令段 + 参数字段(逗号分隔) + 帧尾(2B)
```

| 字段 | 值 | 说明 |
|------|-----|------|
| 帧头 | `#` (0x23) 或 `@` (0x40) | `@` = 屏→WS63，`#` = WS63→屏 |
| 分隔符 | `,` (0x2C) | 字段间分隔 |
| 帧尾 | `\r\n` (0x0D 0x0A) | 帧结束标志 |

### 1.2 命名约定

- **CMD**: 帧头后、第一个逗号前的命令标识符
- 参数全部为可打印 ASCII 字符串，无二进制数值
- 帧长不定，屏端缓冲区 1024 字节（T1系列限制）

### 1.3 Tag ID 格式约定

| 通信层面 | 格式 | 示例 | 说明 |
|----------|------|------|------|
| 屏 ↔ WS63 | 纯数字字符串 | `0001` | 不含 `0x` 前缀，屏端直接显示 |
| WS63 ↔ ESP32 | 十六进制字符串 | `0x0001` | 含 `0x` 前缀，符合 PROTOCOL.md 规范 |
| `asset_list_page.assets[N].tag_id` | 十六进制字符串 | `"0x0001"` | PROTOCOL 标准格式 |

> **WS63 职责**: 屏端协议与 ESP32 协议之间的 Tag ID 格式互转（加/去 `0x` 前缀）。

---

## 二、Page1 — 入库 (in)

### 2.1 操作流程

#### 2.1.1 新资产注册（标签未注册）

```
进入入库页面 (page1)
  │  t5: "请按匹配按钮扫描标签"
  │  sys0=0
  │
  ├─ [b0] 开始匹配标签
  │   屏 → WS63: @in,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   → 标签未注册
  │   WS63 → 屏: #TAG,0001\r\n
  │   t0 = "0001"
  │   t5 = "Tag ID: 0001 已获取,请填写物品信息"
  │   sys0 = 1
  │
  ├─ 用户点击 t3 弹键盘输入 → "扳手"
  ├─ 用户点击 t2 弹键盘输入 → "A"
  ├─ 用户点击 t1 弹键盘输入 → "50"
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ 仅 sys0==1 且三个字段非空
  │   屏 → WS63: @in,capture,0001,50,A,扳手,0\r\n
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":50,"storage_area":"A","item_name":"扳手","is_overwrite":false}
  │   t5 = "已发送,等待摄像头就绪..."
  │   sys0 = 2
  │
  │   WS63 → 屏: #PROG,1,front,0\r\n
  │   t4 = "拍摄: 1/3 front"
  │   t5 = "清晰度评分: 0"
  │   sys0 = 3
  │
  ├─ [b4] 拍正面  ←─ 仅 sys0==3
  │   屏 → WS63: @in,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32拍摄完成 → WS63 → 屏: #PROG,1,front,87.3\r\n
  │   t4 = "拍摄: 1/3 front"
  │   t5 = "清晰度评分: 87.3"
  │
  │   WS63 → 屏: #PROG,2,side,0\r\n
  │   t4 = "拍摄: 2/3 side"
  │
  ├─ [b5] 拍侧面  ←─ 仅 sys0==3
  │   屏 → WS63: @in,photo,side\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"side"}
  │   ESP32拍摄完成 → WS63 → 屏: #PROG,2,side,91.2\r\n
  │
  │   WS63 → 屏: #PROG,3,top,0\r\n
  │   t4 = "拍摄: 3/3 top"
  │
  ├─ [b6] 拍顶部  ←─ 仅 sys0==3
  │   屏 → WS63: @in,photo,top\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"top"}
  │   ESP32拍摄完成 → WS63 → 屏: #PROG,3,top,85.7\r\n
  │
  │   (ESP32开始三视图推理, ~7.5秒)
  │   WS63 → 屏: #DONE,reg,success,0001\r\n
  │   t5 = "入库成功! 可按确认"
  │   sys0 = 4
  │
  ├─ [b7] 确认入库  ←─ 仅 sys0==4
  │   屏 → WS63: @in,confirm\r\n
  │   WS63: 持久化资产记录
  │   t5 = "确认入库中..."
  │   sys0 = 0
  │
  └─ [b3] 返回menu → page 0
```

#### 2.1.2 覆写模式（c0=1，标签已存在，重新拍三视图覆写旧特征）

```
  [b0] 开始匹配标签
  │   屏 → WS63: @in,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   → 标签已注册: 扳手, A区, 库存50
  │   WS63 → 屏: #VERIFY,0001,扳手,A,50\r\n
  │   t0 = "0001"   t3 = "扳手" (沿用)   t2 = "A" (沿用)
  │   t1 = "count" (占位，用户输入新增数量)
  │   t5 = "当前库存:50 此标签已存在! 请选择模式并填写新增数量"
  │   sys0 = 5
  │
  ├─ 用户按 c0 (覆写)，c1 自动弹起
  ├─ 用户输入 t1="20", t2/t3 可修改
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ sys0==5, c0.val==1, 三个字段非空
  │   屏 → WS63: @in,capture,0001,20,A,扳手,1\r\n
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":20,"is_overwrite":true}
  │   t5 = "覆写模式: 需拍三视图,等待摄像头..."
  │   sys0 = 2
  │
  │   (后续三视图拍摄流程同 2.1.1，结束于 #DONE,reg,success,0001)
  │   库存 50+20=70，特征向量被新三视图覆写
```

#### 2.1.3 更新验证模式（c1=1，标签已存在，仅正面比对累加数量）

```
  [b0] 开始匹配标签
  │   屏 → WS63: @in,start\r\n
  │   → 标签已注册
  │   WS63 → 屏: #VERIFY,0001,扳手,A,50\r\n
  │   sys0 = 5
  │
  ├─ 用户按 c1 (更新验证)，c0 自动弹起
  ├─ 用户输入 t1="20" (仅需数量)
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ sys0==5, c1.val==1, t1非空
  │   屏 → WS63: @in,capture,0001,20,,,2\r\n
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":20}
  │   (不含 item_name/storage_area，触发验证模式)
  │   t5 = "更新验证模式: 仅需正面,等待摄像头..."
  │   sys0 = 2
  │
  │   WS63 → 屏: #PROG,1,front,0\r\n
  │   t4 = "拍摄: 1/3 front"   sys0 = 3
  │
  ├─ [b4] 拍正面  ←─ 仅 sys0==3
  │   屏 → WS63: @in,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32拍摄 → 推理 → 比对TF卡特征
  │   WS63 → 屏: #PROG,1,front,92.1\r\n
  │
  │   ├─ 相似度≥0.75 ✅ → WS63 → 屏: #DONE,reg,success_updated,0001\r\n
  │   │   t5 = "验证通过,数量已累加! 可按确认"
  │   │   sys0 = 4
  │   │
  │   └─ 相似度<0.75 ❌ → WS63 → 屏: #ERR,ERR_VERIFICATION_FAILED,物品不匹配\r\n
  │       t5 = "验证失败: 物品不匹配,请检查"
  │       sys0 = 0
  │
  ├─ [b7] 确认入库  ←─ 仅 sys0==4
  │   屏 → WS63: @in,confirm\r\n
  │   sys0 = 0
  │
  └─ [b3] 返回menu → @in,cancel\r\n → page 0
```

### 2.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | sys0 条件 | 说明 |
|---|----------|--------|-----------|------|
| U1.1 | b0 | `@in,start\r\n` | 无限制 | 请求扫描最近标签 |
| U1.2 | b1 | `@in,capture,<tag_id>,<count>,<area>,<name>,<mode>\r\n` | 见下表 | 发送标签信息+启动摄像头 |
| U1.3 | b4 | `@in,photo,front\r\n` | sys0==3 | 拍正面视图 |
| U1.4 | b5 | `@in,photo,side\r\n` | sys0==3 | 拍侧面视图 |
| U1.5 | b6 | `@in,photo,top\r\n` | sys0==3 | 拍顶部视图 |
| U1.6 | b7 | `@in,confirm\r\n` | sys0==4 | 确认入库 |
| U1.7 | b3 | `@in,cancel\r\n` | 无限制 | 取消当前任务，返回menu |

#### U1.2 mode 参数说明

| mode | 场景 | sys0 | 验证字段 | WS63 下发 ESP32 |
|:--:|------|:--:|------|------|
| `0` | 新注册 | 1 | t1/t2/t3 非空 | `register` + `item_name` + `storage_area` + `quantity` + `is_overwrite:false` |
| `1` | 覆写 | 5 + c0=1 | t1/t2/t3 非空 | `register` + `item_name` + `storage_area` + `quantity` + `is_overwrite:true` |
| `2` | 更新验证 | 5 + c1=1 | 仅 t1 非空 | `register` + `quantity`（不含 item_name，触发验证模式） |

### 2.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D1.0 | `#VERIFY,<tag_id>,<name>,<area>,<current_qty>\r\n` | 标签已注册时 | t0/t3/t2显示已有信息，t1="count"占位，t5提示，sys0=5 |
| D1.1 | `#TAG,<tag_id>\r\n` | 标签未注册时 | t0=tag_id，t5提示填写，sys0=1 |
| D1.2 | `#PROG,<step>,<view>,<score>\r\n` | 每次拍摄完成后 | t4显示步骤，t5显示清晰度，sys0=3 |
| D1.3 | `#DONE,reg,<result>,<tag_id>\r\n` | 推理完成后 | success→sys0=4；success_updated→sys0=4；fail→提示 |
| D1.4 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t5=msg |
| D1.5 | `#MSG,<text>\r\n` | 通用通知 | t5=text |

#### D1.2 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| `step` | 字符串 | `1`/`2`/`3` | 当前拍摄步骤序号（验证模式 step 始终为 1） |
| `view` | 字符串 | `front`/`side`/`top` | 当前拍摄视图类型 |
| `score` | 字符串 | `87.3` | 清晰度评分，保留1位小数 |

#### D1.3 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| `result` | 字符串 | `success`/`success_updated`/`fail` | 入库结果 |

---

## 三、Page2 — 出库 (out)

> 对齐 PROTOCOL.md v3.3 outbound 分步流程：
> 1. b4 发 outbound → ESP32 查库，立即返回 `asset_info`（含 `remaining_qty`）→ 屏显示确认信息
> 2. b5 发 capture front → ESP32 初始化硬件+拍摄+比对+扣减 → `task_done`（含 `is_match`）

### 3.1 操作流程

```
进入出库页面 (page2)
  │  t5: "请按匹配按钮扫描标签"
  │  t7: "请先输入出库数量"
  │  sys0=0
  │
  ├─ [b0] 开始匹配标签
  │   屏 → WS63: @out,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   WS63 → 屏: #TAG,0001,扳手,A,50\r\n
  │   t0 = "0001"   t3 = "扳手"   t2 = "A"   t1 = "50"
  │   t7 = "当前库存: 50  请输入出库数量"
  │   t5 = "Tag ID: 0001 已获取"
  │   sys0 = 1
  │
  ├─ 用户点击 t6 弹键盘输入出库数量 → "5"
  │
  ├─ [b4] 发送信息+启动摄像头  ←─ 仅 sys0==1 且 t6非空
  │   屏 → WS63: @out,capture,0001,5\r\n
  │   WS63 → ESP32: {"cmd":"outbound","tag_id":"0x0001","remove_qty":5}
  │   ESP32 查库 → 返回 asset_info（此时未初始化硬件）:
  │   {"type":"asset_info","task":"outbound","item_name":"扳手",
  │    "quantity":50,"remove_qty":5,"remaining_qty":45}
  │   WS63 → 屏: #ASSET_INFO,0001,扳手,50,5,45\r\n
  │   t7 = "出库: 库存50→45  请确认后拍摄正面"
  │   t5 = ""
  │   sys0 = 2
  │
  ├─ [b5] 拍正面  ←─ 仅 sys0==2（⚠️ v2.1: 此步 sys0==2 而非 3）
  │   屏 → WS63: @out,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32: 初始化AI+摄像头 → 拍摄 → 特征提取 → 比对
  │   WS63 → 屏: #PROG,1,front,87.3\r\n
  │   t4 = "拍摄: 1/1 front"
  │   t5 = "清晰度评分: 87.3"
  │   sys0 = 3
  │
  │   (ESP32比对+扣减:
  │   ├─ 匹配成功 ✅ → is_match=true, 扣减完成
  │   │   WS63 → 屏: #DONE,out,success\r\n
  │   │   t5 = "出库验证通过! 库存 50→45, 可按确认"
  │   │   sys0 = 4
  │   │
  │   └─ 匹配失败 ❌ → is_match=false, 不扣减
  │       WS63 → 屏: #DONE,out,fail\r\n
  │       t5 = "验证失败: 物品不匹配"
  │
  ├─ [b7] 确认出库  ←─ 仅 sys0==4
  │   屏 → WS63: @out,confirm\r\n
  │   WS63: 持久化（ESP32已完成扣减）
  │   t5 = "确认出库完成"
  │   sys0 = 0
  │
  └─ [b3] 返回menu → @out,cancel\r\n → page 0
```

### 3.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | sys0 条件 | 说明 |
|---|----------|--------|-----------|------|
| U2.1 | b0 | `@out,start\r\n` | 无限制 | 请求扫描最近标签 |
| U2.2 | b4 | `@out,capture,<tag_id>,<out_count>\r\n` | sys0==1 且 t6非空 | 发送出库信息（触发 ESP32 查库） |
| U2.3 | b5 | `@out,photo,front\r\n` | sys0==2 | ⚠️ v2.1: 拍正面（此时已收到 asset_info 确认） |
| U2.4 | b7 | `@out,confirm\r\n` | sys0==4 | 确认出库（ESP32已完成扣减） |
| U2.5 | b3 | `@out,cancel\r\n` | 无限制 | 取消当前任务，返回menu |

### 3.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D2.1 | `#TAG,<tag_id>,<name>,<area>,<total>\r\n` | 扫描到最近标签后 | t0/t3/t2/t1显示，t7提示库存+输入，sys0=1 |
| D2.1.5 | `#ASSET_INFO,<tag_id>,<name>,<qty>,<remove>,<remain>\r\n` ⭐v2.1 | ESP32 返回 outbound asset_info | t7显示"库存50→45"确认信息，sys0=2 |
| D2.2 | `#PROG,<step>,<view>,<score>\r\n` | 拍摄完成后 | t4显示步骤(step=1)，t5显示清晰度，sys0=3 |
| D2.3 | `#DONE,out,<result>\r\n` | 正视图比对+扣减完成 | WS63根据 is_match 判断 success/fail；success→sys0=4 |
| D2.4 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t5=msg |
| D2.5 | `#MSG,<text>\r\n` | 通用通知 | t5=text |

#### D2.1.5 字段说明 ⭐v2.1

| 字段 | 类型 | 示例值 | 来源 | 说明 |
|------|------|--------|------|------|
| `tag_id` | 字符串 | `0001` | 屏→WS63传入 | 16位Tag ID |
| `name` | 字符串 | `扳手` | `item_name` | 物品名称 |
| `qty` | 字符串 | `50` | `quantity` | 当前库存总量 |
| `remove` | 字符串 | `5` | `remove_qty` | 本次出库数量 |
| `remain` | 字符串 | `45` | `remaining_qty` | 出库后剩余数量 |

---

## 四、Page3 — 盘点 (check)

### 4.1 操作流程

#### 4.1.1 全局盘点

```
进入盘点页面 (page3)
  │  t5: "请扫描或输入Tag ID"
  │  sys0=0
  │
  └─ [b2] 全局盘点
      屏 → WS63: @check,global\r\n
      WS63: SLE扫描统计附近标签数 + 查询ESP32数据库总入库数
      WS63 → 屏: #INV,3,150\r\n
      t1 = "" (清空)
      t5 = "星闪扫描:3个  数据库:150个"
```

#### 4.1.2 特定盘点（AI比对验证）

```
进入盘点页面 (page3)
  │  t0 = "tag_id" (占位)
  │  t5: "请扫描或输入Tag ID"
  │  sys0=0
  │
  ├─ 用户点击 t0 弹键盘输入 → "0001"
  │
  ├─ [b0] 特定盘点  ←─ t0非空且非占位符
  │   屏 → WS63: @check,specific,0001\r\n
  │   WS63 → ESP32: {"cmd":"get_asset","tag_id":"0x0001"}
  │   ESP32 → WS63: {"type":"asset_detail","found":true,"tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50,...}
  │   WS63 → 屏: #TAG_INFO,0001,扳手,A,50\r\n
  │   t0 = "0001"
  │   t1 = "名称:扳手  区域:A  库存:50"
  │   t5 = "标签信息已获取,可按启动摄像头"
  │   sys0 = 1
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ 仅 sys0==1
  │   屏 → WS63: @check,capture,0001\r\n
  │   WS63 → ESP32: {"cmd":"inventory","tag_id":"0x0001"}
  │   t5 = "已发送,等待摄像头就绪..."
  │   sys0 = 2
  │
  │   (ESP32 返回 asset_info 确认资产，WS63可忽略或记录日志)
  │
  │   WS63 → 屏: #PROG,1,front,0\r\n
  │   t4 = "拍摄: 1/3 front"
  │   sys0 = 3
  │
  ├─ [b4] 拍正面  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   WS63 → 屏: #PROG,1,front,85.2\r\n
  │   t5 = "清晰度评分: 85.2"
  │
  │   WS63 → 屏: #PROG,2,side,0\r\n
  │   t4 = "拍摄: 2/3 side"
  │
  ├─ [b5] 拍侧面  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,side\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"side"}
  │   WS63 → 屏: #PROG,2,side,91.7\r\n
  │
  │   WS63 → 屏: #PROG,3,top,0\r\n
  │   t4 = "拍摄: 3/3 top"
  │
  ├─ [b6] 拍顶部  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,top\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"top"}
  │   WS63 → 屏: #PROG,3,top,88.3\r\n
  │
  │   (ESP32三视图推理 → 比对TF卡特征)
  │   WS63 → 屏: #DONE,check,match,0.93\r\n
  │   t5 = "比对通过! 相似度:0.93"
  │   sys0 = 4
  │
  └─ [b3] 返回menu → @check,cancel\r\n → page 0
```

### 4.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | sys0 条件 | 说明 |
|---|----------|--------|-----------|------|
| U3.1 | b2 | `@check,global\r\n` | 无限制 | 全局盘点：SLE扫描数+DB总数 |
| U3.2 | b0 | `@check,specific,<tag_id>\r\n` | t0非空且非占位符 | 查询单个资产信息 |
| U3.3 | b1 | `@check,capture,<tag_id>\r\n` | sys0==1 | 启动AI盘点比对 |
| U3.4 | b4 | `@check,photo,front\r\n` | sys0==3 | 拍正面 |
| U3.5 | b5 | `@check,photo,side\r\n` | sys0==3 | 拍侧面 |
| U3.6 | b6 | `@check,photo,top\r\n` | sys0==3 | 拍顶部 |
| U3.7 | b3 | `@check,cancel\r\n` | 无限制 | 取消当前任务，返回menu |

### 4.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | PROTOCOL 对应 | 屏端行为 |
|---|--------|----------|--------------|----------|
| D3.1 | `#INV,<sle_count>,<db_total>\r\n` | 全局盘点完成后 | WS63本地拼装 | t5显示双端数量对比 |
| D3.2 | `#TAG_INFO,<tag_id>,<name>,<area>,<count>\r\n` | get_asset 返回后 | `asset_detail` / `asset_info` | t1显示详情，t0回填，sys0=1 |
| D3.3 | `#PROG,<step>,<view>,<score>\r\n` | 每次拍摄完成后 | `capture_progress` | t4/t5显示进度，sys0=3 |
| D3.4 | `#DONE,check,<result>,<similarity>\r\n` | 盘点比对完成后 | `task_done`(inventory) | result=match/mismatch, t5显示相似度 |
| D3.5 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | `error` | t5=msg |
| D3.6 | `#MSG,<text>\r\n` | 通用通知 | — | t5=text |

#### D3.2 字段说明

| 字段 | 类型 | 示例值 | 来源 | 说明 |
|------|------|--------|------|------|
| `tag_id` | 字符串 | `0001` | `tag_id` | 16位Tag ID |
| `name` | 字符串 | `扳手` | `item_name` | 物品名称 |
| `area` | 字符串 | `A` | `storage_area` | 存放区域 |
| `count` | 字符串 | `50` | `quantity` | 当前库存数量 |

#### D3.4 字段说明

| 字段 | 类型 | 示例值 | 来源 | 说明 |
|------|------|--------|------|------|
| `result` | 字符串 | `match`/`mismatch` | WS63判断: `confidence >= 0.75` → match | 比对结果 |
| `similarity` | 字符串 | `0.93` | `matched_asset.confidence` | 相似度，保留2位小数 |

---

## 五、Page4 — 资产查找 (find) ⭐v2.2

> **功能**: 分页浏览所有注册资产，选中后通过 SLE 让标签蜂鸣/发光定位实物。
> **控制流向**: `list` → ESP32（查数据库）；`locate`/`stop` → WS63 SLE（直接控BS21标签）。
> **显示格式**: 每条 `"tag_id name area*count"`，6条/页，t7=页码，t8=状态，b2.txt=定位状态。

### 5.1 控件职责

| 控件 | 职责 | 示例值 |
|------|------|--------|
| t0–t5 | 资产条目 slot 0~5 | `"0001 扳手 A*50"` |
| t6 | 资产总数 | `"资产总数：150"` |
| t7 | 页码 | `"第1/25页"` |
| t8 | 所有状态/错误/提示 | `"正在定位..."` `"已是第一页"` |
| b2.txt | 定位按钮状态 | `"定位"`→`"定位中..."`→`"已激活"` |
| c0–c5 | 选中条目（互斥） | mode=0(弹起), sys5=0-5/99 |

### 5.2 操作流程

```
进入查找页 (page4)
  │  t7=""  t6=""  t8=""  b2.txt="定位"
  │  sys0=0, sys3=0, sys4=0, sys5=99
  │
  ├─ [b4] 获取列表
  │   屏 → WS63: @find,list,1\r\n
  │   WS63 → ESP32: {"cmd":"list_assets_page","page":1,"page_size":6}
  │   ESP32 → WS63: {"type":"asset_list_page","page":1,"total_pages":25,
  │                    "total_count":150,"assets":[...6条...]}
  │   WS63 → 屏: #LIST,1,25,150\r\n
  │   t7="第1/25页"  t6="资产总数：150"  sys4=25
  │   WS63 → 屏: #ITEM,0,0001,扳手,A,50\r\n   → t0="0001 扳手 A*50"
  │   WS63 → 屏: #ITEM,1,0002,螺丝刀,B,30\r\n → t1="0002 螺丝刀 B*30"
  │   ... (逐条发6条)
  │   sys0=1
  │
  ├─ [c2] 选中第3条 → sys5=2
  │
  ├─ [b2] 定位选中标签  ←─ sys5!=99
  │   spstr t2.txt,t6.txt," ",0 → 提取 "0003"
  │   屏 → WS63: @find,locate,0003\r\n
  │   WS63 → SLE → BS21(0003): 蜂鸣+发光
  │   WS63 → 屏: #LOCATE,found,0003\r\n
  │   b2.txt="已激活"  t8="标签正在蜂鸣..."
  │
  ├─ [b5] 停止定位
  │   屏 → WS63: @find,stop\r\n
  │   WS63 → SLE: 停止蜂鸣
  │   b2.txt="定位"  t8="已停止定位"
  │
  ├─ [b0] 上一页  ←─ sys3>1
  │   sys3=sys3-1  →  @find,list,<sys3>  →  (同上)
  │
  ├─ [b1] 下一页  ←─ sys3<sys4
  │   sys3=sys3+1  →  @find,list,<sys3>  →  (同上)
  │
  └─ [b3] 返回 → @find,cancel\r\n → page 0
```

### 5.3 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | 条件 | 说明 |
|---|----------|--------|------|------|
| U4.1 | b4 | `@find,list,<page>\r\n` | 无限制 | 请求第N页资产列表 |
| U4.2 | b0 | `@find,list,<sys3>\r\n` | sys3>1 | 上一页（复用list） |
| U4.3 | b1 | `@find,list,<sys3>\r\n` | sys3<sys4 | 下一页（复用list） |
| U4.4 | b2 | `@find,locate,<tag_id>\r\n` | sys5!=99 | 让选中标签蜂鸣/发光 |
| U4.5 | b5 | `@find,stop\r\n` | 无限制 | 停止蜂鸣/发光 |
| U4.6 | b3 | `@find,cancel\r\n` | 无限制 | 取消当前操作，返回menu |

### 5.4 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D4.1 | `#LIST,<page>,<total_pages>,<total_count>\r\n` | ESP32 asset_list_page 返回 | t7=页码, t6=总数, sys4=total_pages, 清空t0-t5+c0-c5 |
| D4.2 | `#ITEM,<slot>,<tag_id>,<name>,<area>,<count>\r\n` | 逐条（0~5, 至少1条） | t[slot]="tag_id name area*count" |
| D4.3 | `#LOCATE,<status>,<tag_id>\r\n` | 标签响应/超时 | b2.txt="已激活"/"未找到", t8状态提示 |
| D4.4 | `#ERR,<code>,<msg>\r\n` | 错误发生时 | t8=msg |
| D4.5 | `#MSG,<text>\r\n` | 通用通知 | t8=text |

#### D4.2 字段说明

| 字段 | 类型 | 示例值 | 来源 | 说明 |
|------|------|--------|------|------|
| `slot` | 字符串 | `0`~`5` | WS63按顺序分配 | 对应t0-t5 |
| `tag_id` | 字符串 | `0001` | `tag_id` → 去0x | Tag ID（屏端格式） |
| `name` | 字符串 | `扳手` | `item_name` | 物品名称 |
| `area` | 字符串 | `A` | `storage_area` | 存放区域 |
| `count` | 字符串 | `50` | `quantity` | 库存数量 |

#### D4.3 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| `status` | 字符串 | `found` / `timeout` | `found`=标签响应蜂鸣，`timeout`=超时未响应 |
| `tag_id` | 字符串 | `0001` | 定位目标Tag ID |

---

## 六、Page5 — 设置 (setting)

### 6.1 操作流程

```
进入设置页 (page5)
  │  t5="Status"  t3="WiFi_name"  t0="WiFi_pswd"  h0.val=100
  │
  ├─ h0 滑块拖动 → dim=h0.val (实时调背光，本地执行，无串口帧)
  │
  ├─ 收到 WS63 上电主动推送:
  │   ← #NET,wifi,connected,-45
  │   t5="WiFi已连接 信号:-45dBm"
  │
  ├─ 用户点击 t3 输入 → "MyWiFi"
  ├─ 用户点击 t0 输入 → "12345678"
  │
  ├─ [b1] 连接 WiFi
  │   屏 → WS63: @setting,wifi,MyWiFi,12345678\r\n
  │   t5="正在连接 MyWiFi..."
  │   ← #NET,wifi,connecting,
  │   ← #WIFI,ok  或  #WIFI,fail
  │   t5="WiFi连接成功!" 或 "WiFi连接失败"
  │   ← #NET,wifi,connected,-45
  │   t5="WiFi已连接 信号:-45dBm"
  │   (同一WiFi下次自动连接，WS63存储凭据)
  │
  ├─ [b4] 断开连接
  │   屏 → WS63: @setting,disconnect\r\n
  │   t5="正在断开..."
  │   ← #NET,wifi,disconnected,
  │   t5="未连接"
  │
  └─ [b3] 返回 → @setting,cancel\r\n → page 0
```

### 6.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | 条件 | 说明 |
|---|----------|--------|------|------|
| U5.1 | b1 | `@setting,wifi,<ssid>,<password>\r\n` | t3和t0非空且非占位符 | 连接WiFi |
| U5.2 | b4 | `@setting,disconnect\r\n` | 无限制 | 断开当前网络连接 |
| U5.3 | b3 | `@setting,cancel\r\n` | 无限制 | 取消当前操作，返回menu |

### 6.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D5.1 | `#NET,<mode>,<status>,<signal>\r\n` | 网络状态变化/上电推送 | t5显示网络状态 |
| D5.2 | `#WIFI,<result>\r\n` | WiFi连接结果 | t5="连接成功!" / "连接失败" |
| D5.3 | `#ERR,<code>,<msg>\r\n` | 错误发生时 | t5=msg |
| D5.4 | `#MSG,<text>\r\n` | 通用通知 | t5=text |

#### D5.1 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| `mode` | 字符串 | `wifi` / `4g` | 网络模式 |
| `status` | 字符串 | `connected` / `connecting` / `disconnected` | 连接状态 |
| `signal` | 字符串 | `-45`（WiFi dBm）/ `25`（4G CSQ） | 信号强度，disconnected 时为空 |

> **背光调节不走串口**：h0 滑块 → `dim=h0.val`，纯本地操作。

---

## 七、状态机对照

| sys0 | 含义 | page1 in | page2 out | page3 check | page4 find |
|------|------|:--:|:--:|:--:|:--:|
| 0 | 空闲/初始 | b0 | b0 | b0, b2 | b4 |
| 1 | 信息已获取，待操作 | b0, b1 | b0, b4 | b0, b1, b2 | b0,b1,b2,b5,c0-c5 |
| 2 | 已发capture/outbound | b0 | b0, b5 | b0, b2 | — |
| 3 | 拍摄中 | b0, b4, b5, b6 | b0 | b4, b5, b6 | — |
| 4 | 推理/比对完成，待确认 | b0, b7 | b0, b7 | b0, b2 | — |
| 5 | 验证模式（page1专属） | b0, b1 | — | — | — |

> page4 额外变量: `sys3`=当前页码, `sys4`=总页数, `sys5`=选中slot(0-5=选中, 99=未选)

---

## 八、WS63 处理逻辑参考

### 8.0 Tag ID 转换

```
屏→WS63: "0001"    →  WS63内部: "0x0001"  →  ESP32: "0x0001"
ESP32→WS63: "0x0001"  →  WS63内部: "0001"  →  屏: "0001"
```

### 8.1 收到 `@in,start` / `@out,start`

```
SLE扫描 → RSSI取最强标签 → 查询本地数据库:

  in 页:
    标签不存在 → 发送 #TAG,<tag_id>
    标签已存在 → 发送 #VERIFY,<tag_id>,<name>,<area>,<qty>

  out 页:
    标签已存在 → 发送 #TAG,<tag_id>,<name>,<area>,<total>
    标签不存在 → 发送 #ERR,ERR_ASSET_NOT_FOUND,标签未注册
```

### 8.2 收到 `@in,capture,...` (根据 mode 区分)

```
mode=0 (新注册, 6字段):
  → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":50,"storage_area":"A","item_name":"扳手","is_overwrite":false}

mode=1 (覆写, 6字段):
  → ESP32: {"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":20,"is_overwrite":true}

mode=2 (更新验证, 6字段):
  → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":20}
  (⚠️ 不含 item_name/storage_area，ESP32自动进入验证模式)
```

### 8.3 收到 `@out,capture,<id>,<qty>` ⭐v2.1

```
→ ESP32: {"cmd":"outbound","tag_id":"0x0001","remove_qty":5}

ESP32 立即返回（未初始化硬件）:
  {"type":"asset_info","task":"outbound","tag_id":"0x0001",
   "item_name":"扳手","storage_area":"A","quantity":50,
   "remove_qty":5,"remaining_qty":45}

→ 屏: #ASSET_INFO,0001,扳手,50,5,45\r\n
  屏端显示确认信息，等待用户按 b5 拍摄正面
```

### 8.4 收到 `@<page>,photo,<view>`

```
→ ESP32: {"cmd":"capture","view":"<view>"}
```

### 8.5 ESP32回传 `capture_progress`

```
{
  "type": "capture_progress",
  "tag_id": "0x0001",
  "view": "front",
  "step": "1/3",
  "status": "ok",
  "blur_score": 87.3,
  "feature_size": 1280
}

→ 屏: #PROG,1,front,87.3\r\n
(step取"1/3"的分子, view原样, blur_score原样保留1位小数)
```

### 8.6 ESP32回传 `task_done`

```
register/success:
  → #DONE,reg,success,<tag_id>\r\n

register/success_updated:
  → #DONE,reg,success_updated,<tag_id>\r\n

register/fail:
  → #DONE,reg,fail,<tag_id>\r\n

outbound (根据 is_match 判断):
  收到 task_done(outbound) 后检查 is_match 字段:
    is_match=true  → #DONE,out,success\r\n
    is_match=false → #DONE,out,fail\r\n
  （⚠️ v2.1: 不再依赖 confidence 阈值，直接用 ESP32 的 is_match）

inventory/success:
  → 检查 matched_asset.confidence:
     ≥0.75 → #DONE,check,match,<confidence>\r\n
     <0.75 → #DONE,check,mismatch,<confidence>\r\n
```

### 8.7 ESP32回传 `verification_start`

```
{
  "type": "verification_start",
  "tag_id": "0x0001",
  "existing_item": "扳手",
  "current_qty": 50,
  "required_view": "front",
  "message": "请拍摄正视图验证"
}

→ WS63: 该消息在 @in,capture 发出后产生。
  如果已通过 #VERIFY 提前告知用户，此消息仅做日志记录，
  或转成 #MSG,请拍摄正面视图验证\r\n 作为二次提醒。
```

### 7.8 收到 `@check,global`

```
WS63本地:
  1. SLE扫描统计附近标签数 → sle_count
  2. → ESP32: {"cmd":"list_assets_page","page":1,"page_size":1}
     ← {"type":"asset_list_page","total_count":150,...}
  3. → 屏: #INV,<sle_count>,<total_count>\r\n
```

### 7.9 收到 `@check,specific,<id>`

```
→ ESP32: {"cmd":"get_asset","tag_id":"0x0001"}
← {"type":"asset_detail","found":true,"tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50,...}

→ 屏: #TAG_INFO,0001,扳手,A,50\r\n

若 found=false:
→ 屏: #ERR,ERR_ASSET_NOT_FOUND,标签未注册\r\n
```

### 7.10 收到 `@check,capture,<id>`

```
→ ESP32: {"cmd":"inventory","tag_id":"0x0001"}

ESP32 首先返回: {"type":"asset_info","task":"inventory","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50}
→ WS63: 可选日志记录，不重复下发 #TAG_INFO（屏端已显示）

后续流程: capture_progress → task_done (见 8.5/8.6)
```

### 7.11 收到 `@find,list,<page>` ⭐v2.2

```
→ ESP32: {"cmd":"list_assets_page","page":<page>,"page_size":6}
← {"type":"asset_list_page","page":N,"total_pages":T,"total_count":C,
   "assets":[{"tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50},
             {"tag_id":"0x0002","item_name":"螺丝刀","storage_area":"B","quantity":30},
             ...]}

→ 屏: #LIST,<page>,<total_pages>,<total_count>\r\n
→ 逐条(slot=0~5):
   提取: tag_id去0x前缀 → tag
   提取: item_name, storage_area, quantity
   #ITEM,<slot>,<tag>,<item_name>,<storage_area>,<quantity>\r\n
```

### 7.12 收到 `@find,locate,<tag_id>` ⭐v2.2

```
⚠️ 不经ESP32 — WS63直接通过SLE向BS21发送定位指令

WS63 → SLE → BS21(<tag_id>): 蜂鸣/发光指令
  BS21响应 → #LOCATE,found,<tag_id>\r\n
  超时(如3秒) → #LOCATE,timeout,<tag_id>\r\n
```

### 7.13 收到 `@find,stop` ⭐v2.2

```
⚠️ 不经ESP32 — WS63直接通过SLE停止标签蜂鸣

WS63 → SLE: 停止当前定位信号
→ 可选: #MSG,已停止\r\n
```

### 7.14 收到 `@in,confirm` / `@out,confirm`

```
in:  标记入库完成，持久化资产记录
out: 确认出库完成（ESP32已在 task_done 中执行扣减）
```

### 7.15 ESP32回传 `error`

```
→ 提取 code + msg → #ERR,<code>,<msg>\r\n

常用错误码: ERR_VERIFICATION_FAILED, ERR_ASSET_NOT_FOUND,
            ERR_BLUR_DETECTED, ERR_LOW_CONFIDENCE, ...
完整列表见 PROTOCOL.md 第9节
```

---

## 八、PROTOCOL.md 对齐检查清单

### 8.1 下行帧（WS63 → 屏）← PROTOCOL 上行消息

| 屏下行帧 | PROTOCOL 上行消息 | 关键字段映射 | 状态 |
|----------|------------------|-------------|:--:|
| `#TAG` | WS63本地拼装（无直接对应） | — | ✅ |
| `#VERIFY` | `verification_start` | tag_id, existing_item→name, current_qty | ✅ |
| `#PROG` | `capture_progress` | step(取分子), view, blur_score→score | ✅ |
| `#DONE,reg,...` | `task_done`(register) | result, tag_id | ✅ |
| `#ASSET_INFO` | `asset_info`(task=outbound) | item_name→name, quantity, remove_qty, remaining_qty | ✅ |
| `#DONE,out,...` | `task_done`(outbound) | is_match→result (true=success, false=fail) | ✅ |
| `#DONE,check,...` | `task_done`(inventory) | confidence→similarity, WS63判断match/mismatch | ✅ |
| `#TAG_INFO` | `asset_detail` / `asset_info` | tag_id, item_name→name, storage_area→area, quantity→count | ✅ |
| `#INV` | WS63本地拼装（SLE + list_assets_page.total_count） | — | ✅ |
| `#LIST` | `asset_list_page` | page, total_pages, total_count | ✅ ⭐v2.2 |
| `#ITEM` | `asset_list_page.assets[N]` | tag_id→去0x, item_name→name, storage_area→area, quantity→count | ✅ ⭐v2.2 |
| `#LOCATE` | WS63本地（SLE响应） | status, tag_id | ✅ ⭐v2.2 |
| `#ERR` | `error` | code, msg | ✅ |
| `#MSG` | 通用 | text | ✅ |

### 8.2 上行帧（屏 → WS63）→ PROTOCOL 下行命令

| 屏上行帧 | PROTOCOL 下行命令 | 关键字段映射 | 状态 |
|----------|------------------|-------------|:--:|
| `@in,capture,mode=0` | `register` (模式A) | tag_id, quantity, storage_area, item_name | ✅ |
| `@in,capture,mode=1` | `register` (模式A+覆写) | + is_overwrite:true | ✅ |
| `@in,capture,mode=2` | `register` (模式B) | 仅 tag_id+quantity（不含 item_name 触发验证） | ✅ |
| `@out,capture` | `outbound` | tag_id, remove_qty | ✅ |
| `@check,specific` | `get_asset` | tag_id | ✅ |
| `@check,capture` | `inventory` | tag_id | ✅ |
| `@check,global` | WS63本地处理 | — | ✅ |
| `@find,list` | `list_assets_page` | page, page_size=6 | ✅ ⭐v2.2 |
| `@find,locate` | WS63→SLE（不经ESP32） | — | ✅ ⭐v2.2 |
| `@find,stop` | WS63→SLE（不经ESP32） | — | ✅ ⭐v2.2 |
| `@*,photo,<view>` | `capture` | view | ✅ |

---

## 九、注意事项

1. **屏端缓冲区仅 1024 字节**（T1 系列），WS63 单帧总长不超过 200 字节为宜
2. **帧尾 `\r\n` 必须完整发送**，不可省略，否则屏端永远等不到帧尾
3. **连续发送多帧时**，间隔至少 10ms，给屏端 `tim=50` 定时器足够的处理窗口
4. **Tag ID 不含 `0x` 前缀**，屏端不处理十六进制→十进制转换；WS63 负责与 ESP32 之间的 `0x` 前缀互转
5. **所有字段为 ASCII 字符串**，包含中文时 WS63 需确保 UTF-8 编码
6. **帧头 `@` 和 `#` 不出现在参数字段中**，避免屏端误判
7. **WS63→ESP32 JSON 字段名**必须与 PROTOCOL.md 严格一致：
   - `item_name`（非 `name`）
   - `storage_area`（非 `area`）
   - `quantity`（非 `count`）
   - `remove_qty`（非 `out_count`）
   - 命令名 `outbound`（非 `outbound_verify`）
   - 命令名 `inventory`（非 `inventory_verify`）
   - 命令名 `get_asset`（非 `query`）
   - 命令名 `list_assets_page`（非 `list_assets`）
8. **验证式更新**（register mode B）：WS63 发送 `register` 不含 `item_name` 字段时，ESP32 自动进入验证模式
9. **盘点相似度判断**：WS63 收到 `task_done`(inventory) 后，自行比较 `matched_asset.confidence >= 0.75` 来决定发 `match` 还是 `mismatch`
10. **outbound 分步流程** ⭐v2.1：b4 发 outbound → ESP32 立即返回 asset_info（含 remaining_qty，此时**未初始化硬件**）→ 屏端确认 → b5 发 capture front → ESP32 **此刻才初始化** AI+摄像头 → 拍摄+比对+扣减 → task_done（含 is_match）
11. **outbound 扣减**：ESP32 在比对成功后才执行扣减，task_done 返回时已完成；比对失败则不扣减
12. **Page2 sys0==2 含义变更** ⭐v2.1：原为"等待摄像头就绪"，现为"已收到 asset_info 确认信息，等待用户拍摄正面"；b5 按钮条件从 `sys0==3` 改为 `sys0==2`
13. **Page4 分页控制** ⭐v2.2：WS63 需维护当前页变量；翻页时清空 t0-t5 和 c0-c5 状态；每页固定 6 条（page_size=6）
14. **Page4 locate/stop 不经ESP32** ⭐v2.2：WS63 直接通过 SLE 控制 BS21 标签蜂鸣/发光，不经过 UART1→ESP32 路径；若标签未响应需超时处理（建议 3 秒）
15. **Page4 t6 复用为提取缓冲** ⭐v2.2：b2 按钮事件中 `spstr tN.txt,t6.txt," ",0` 提取 tag_id 用 t6 做中转（后续 #LIST 会覆盖 t6）
