# WS63 ↔ 串口屏 通信协议（Page1-5）

> **适用型号**: 淘晶驰 T1系列 4.3寸 480\*272  
> **物理层**: UART, 115200bps, 8N1, 3.3V TTL  
> **帧格式**: 逗号分隔文本帧（CSV-like），帧头 `#` / `@`，帧尾 `\r\n`  
> **屏端模式**: `recmod=1` 主动解析  
> **文档版本**: v2.4  
> **最后更新**: 2026-05-27  
> **v2.4 更新**: 同步控件命名（t01/t02/t03/t11/t21/t31/t41/t51 + vscope=global）；流程图和表格全部对齐  
> **v2.3 更新**: 新增 Page5 设置（WiFi连接/断开、背光调节）；所有页面 b3 返回统一加 cancel 帧  
> **v2.2 更新**: 新增 Page4 查找定位  
> **v2.1 更新**: 对齐 PROTOCOL.md v3.3 outbound 分步流程  
> **v2.0 更新**: 新增 Page3 盘点

---

## 控件命名速查

| 页面 | Tag ID | 状态 | vscope | 说明 |
|:--:|--------|------|:--:|------|
| page1 in | **t01** | **t11** | global | 入库页，弹键盘须 global |
| page2 out | **t02** | **t21** | global | 出库页 |
| page3 check | **t03** | **t31** | global | 盘点页 |
| page4 find | — | **t41** | global | 资产查找，t0-t5资产列表保持local |
| page5 setting | — | **t51** | global | 设置页 |

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
  │  t11: "请按匹配按钮扫描标签"
  │  sys0=0
  │
  ├─ [b0] 开始匹配标签
  │   屏 → WS63: @in,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   → 标签未注册
  │   WS63 → 屏: #TAG,0001\r\n
  │   t01 = "0001"
  │   t11 = "Tag ID: 0001 已获取,请填写物品信息"
  │   sys0 = 1
  │
  ├─ 用户点击 t3 弹键盘输入 → "扳手"
  ├─ 用户点击 t2 弹键盘输入 → "A"
  ├─ 用户点击 t1 弹键盘输入 → "50"
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ 仅 sys0==1 且三个字段非空
  │   屏 → WS63: @in,capture,0001,50,A,扳手,0\r\n
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":50,"storage_area":"A","item_name":"扳手","is_overwrite":false}
  │   t11 = "已发送,等待摄像头就绪..."
  │   sys0 = 2
  │
  │   WS63 → 屏: #PROG,1,front,0\r\n
  │   t4 = "拍摄: 1/3 front"
  │   t11 = "清晰度评分: 0"
  │   sys0 = 3
  │
  ├─ [b4] 拍正面  ←─ 仅 sys0==3
  │   屏 → WS63: @in,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32拍摄完成 → WS63 → 屏: #PROG,1,front,87.3\r\n
  │   t4 = "拍摄: 1/3 front"
  │   t11 = "清晰度评分: 87.3"
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
  │   t11 = "入库成功! 可按确认"
  │   sys0 = 4
  │
  ├─ [b7] 确认入库  ←─ 仅 sys0==4
  │   屏 → WS63: @in,confirm\r\n
  │   WS63: 持久化资产记录
  │   t11 = "确认入库中..."
  │   sys0 = 0
  │
  └─ [b3] 返回menu → @in,cancel\r\n → page 0
```

#### 2.1.2 覆写模式（c0=1，标签已存在，重新拍三视图覆写旧特征）

```
  [b0] 开始匹配标签
  │   屏 → WS63: @in,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   → 标签已注册: 扳手, A区, 库存50
  │   WS63 → 屏: #VERIFY,0001,扳手,A,50\r\n
  │   t01 = "0001"   t3 = "扳手" (沿用)   t2 = "A" (沿用)
  │   t1 = "count" (占位，用户输入新增数量)
  │   t11 = "当前库存:50 此标签已存在! 请选择模式并填写新增数量"
  │   sys0 = 5
  │
  ├─ 用户按 c0 (覆写)，c1 自动弹起
  ├─ 用户输入 t1="20", t2/t3 可修改
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ sys0==5, c0.val==1, 三个字段非空
  │   屏 → WS63: @in,capture,0001,20,A,扳手,1\r\n
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":20,"is_overwrite":true}
  │   t11 = "覆写模式: 需拍三视图,等待摄像头..."
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
  │   t11 = "更新验证模式: 仅需正面,等待摄像头..."
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
  │   │   t11 = "验证通过,数量已累加! 可按确认"
  │   │   sys0 = 4
  │   │
  │   └─ 相似度<0.75 ❌ → WS63 → 屏: #ERR,ERR_VERIFICATION_FAILED,物品不匹配\r\n
  │       t11 = "验证失败: 物品不匹配,请检查"
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
| D1.0 | `#VERIFY,<tag_id>,<name>,<area>,<current_qty>\r\n` | 标签已注册时 | t01/t3/t2显示已有信息，t1="count"占位，t11提示，sys0=5 |
| D1.1 | `#TAG,<tag_id>\r\n` | 标签未注册时 | t01=tag_id，t11提示填写，sys0=1 |
| D1.2 | `#PROG,<step>,<view>,<score>\r\n` | 每次拍摄完成后 | t4显示步骤，t11显示清晰度，sys0=3 |
| D1.3 | `#DONE,reg,<result>,<tag_id>\r\n` | 推理完成后 | success→sys0=4；success_updated→sys0=4；fail→提示 |
| D1.4 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t11=msg |
| D1.5 | `#MSG,<text>\r\n` | 通用通知 | t11=text |

---

## 三、Page2 — 出库 (out)

> 对齐 PROTOCOL.md v3.3 outbound 分步流程

### 3.1 操作流程

```
进入出库页面 (page2)
  │  t21: "请按匹配按钮扫描标签"
  │  t7: "请先输入出库数量"
  │  sys0=0
  │
  ├─ [b0] 开始匹配标签
  │   屏 → WS63: @out,start\r\n
  │   WS63: SLE扫描, RSSI取最近标签, 查询数据库
  │   WS63 → 屏: #TAG,0001,扳手,A,50\r\n
  │   t02 = "0001"   t3 = "扳手"   t2 = "A"   t1 = "50"
  │   t7 = "当前库存: 50  请输入出库数量"
  │   t21 = "Tag ID: 0001 已获取"
  │   sys0 = 1
  │
  ├─ 用户点击 t6 弹键盘输入出库数量 → "5"
  │
  ├─ [b4] 发送信息+启动摄像头  ←─ 仅 sys0==1 且 t6非空
  │   屏 → WS63: @out,capture,0001,5\r\n
  │   WS63 → ESP32: {"cmd":"outbound","tag_id":"0x0001","remove_qty":5}
  │   ESP32 查库 → 返回 asset_info（此时未初始化硬件）
  │   WS63 → 屏: #ASSET_INFO,0001,扳手,50,5,45\r\n
  │   t7 = "出库: 库存50→45  请确认后拍摄正面"
  │   t21 = ""
  │   sys0 = 2
  │
  ├─ [b5] 拍正面  ←─ 仅 sys0==2
  │   屏 → WS63: @out,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32: 初始化AI+摄像头 → 拍摄 → 特征提取 → 比对
  │   WS63 → 屏: #PROG,1,front,87.3\r\n
  │   t4 = "拍摄: 1/1 front"
  │   t21 = "清晰度评分: 87.3"
  │   sys0 = 3
  │
  │   (ESP32比对+扣减:
  │   ├─ 匹配成功 ✅ → is_match=true, 扣减完成
  │   │   WS63 → 屏: #DONE,out,success\r\n
  │   │   t21 = "出库验证通过! 库存 50→45, 可按确认"
  │   │   sys0 = 4
  │   │
  │   └─ 匹配失败 ❌ → is_match=false, 不扣减
  │       WS63 → 屏: #DONE,out,fail\r\n
  │       t21 = "验证失败: 物品不匹配"
  │
  ├─ [b7] 确认出库  ←─ 仅 sys0==4
  │   屏 → WS63: @out,confirm\r\n
  │   WS63: 持久化（ESP32已完成扣减）
  │   t21 = "确认出库完成"
  │   sys0 = 0
  │
  └─ [b3] 返回menu → @out,cancel\r\n → page 0
```

### 3.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | sys0 条件 | 说明 |
|---|----------|--------|-----------|------|
| U2.1 | b0 | `@out,start\r\n` | 无限制 | 请求扫描最近标签 |
| U2.2 | b4 | `@out,capture,<tag_id>,<out_count>\r\n` | sys0==1 且 t6非空 | 发送出库信息（触发 ESP32 查库） |
| U2.3 | b5 | `@out,photo,front\r\n` | sys0==2 | 拍正面（已收到 asset_info 确认） |
| U2.4 | b7 | `@out,confirm\r\n` | sys0==4 | 确认出库（ESP32已完成扣减） |
| U2.5 | b3 | `@out,cancel\r\n` | 无限制 | 取消当前任务，返回menu |

### 3.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D2.1 | `#TAG,<tag_id>,<name>,<area>,<total>\r\n` | 扫描到最近标签后 | t02/t3/t2/t1显示，t7提示库存+输入，sys0=1 |
| D2.1.5 | `#ASSET_INFO,<tag_id>,<name>,<qty>,<remove>,<remain>\r\n` | ESP32 返回 outbound asset_info | t7显示"库存50→45"，sys0=2 |
| D2.2 | `#PROG,<step>,<view>,<score>\r\n` | 拍摄完成后 | t4显示步骤(step=1)，t21显示清晰度，sys0=3 |
| D2.3 | `#DONE,out,<result>\r\n` | 正视图比对+扣减完成 | WS63根据 is_match 判断 success/fail；success→sys0=4 |
| D2.4 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t21=msg |
| D2.5 | `#MSG,<text>\r\n` | 通用通知 | t21=text |

---

## 四、Page3 — 盘点 (check)

### 4.1 操作流程

#### 4.1.1 全局盘点

```
进入盘点页面 (page3)
  │  t31: "请扫描或输入Tag ID"
  │  sys0=0
  │
  └─ [b2] 全局盘点
      屏 → WS63: @check,global\r\n
      WS63: SLE扫描统计附近标签数 + 查询ESP32数据库总入库数
      WS63 → 屏: #INV,3,150\r\n
      t1 = "" (清空)
      t31 = "星闪扫描:3个  数据库:150个"
```

#### 4.1.2 特定盘点（AI比对验证）

```
进入盘点页面 (page3)
  │  t03 = "tag_id" (占位)
  │  t31: "请扫描或输入Tag ID"
  │  sys0=0
  │
  ├─ 用户点击 t03 弹键盘输入 → "0001"
  │
  ├─ [b0] 特定盘点  ←─ t03非空且非占位符
  │   屏 → WS63: @check,specific,0001\r\n
  │   WS63 → ESP32: {"cmd":"get_asset","tag_id":"0x0001"}
  │   WS63 → 屏: #TAG_INFO,0001,扳手,A,50\r\n
  │   t03 = "0001"
  │   t1 = "名称:扳手  区域:A  库存:50"
  │   t31 = "标签信息已获取,可按启动摄像头"
  │   sys0 = 1
  │
  ├─ [b1] 发送信息+启动摄像头  ←─ 仅 sys0==1
  │   屏 → WS63: @check,capture,0001\r\n
  │   WS63 → ESP32: {"cmd":"inventory","tag_id":"0x0001"}
  │   t31 = "已发送,等待摄像头就绪..."
  │   sys0 = 2
  │
  │   WS63 → 屏: #PROG,1,front,0\r\n
  │   t4 = "拍摄: 1/3 front"   sys0 = 3
  │
  ├─ [b4] 拍正面  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,front\r\n
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   WS63 → 屏: #PROG,1,front,85.2\r\n
  │   t31 = "清晰度评分: 85.2"
  │   WS63 → 屏: #PROG,2,side,0\r\n → t4 = "拍摄: 2/3 side"
  │
  ├─ [b5] 拍侧面  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,side\r\n
  │   WS63 → 屏: #PROG,2,side,91.7\r\n
  │   WS63 → 屏: #PROG,3,top,0\r\n → t4 = "拍摄: 3/3 top"
  │
  ├─ [b6] 拍顶部  ←─ 仅 sys0==3
  │   屏 → WS63: @check,photo,top\r\n
  │   WS63 → 屏: #PROG,3,top,88.3\r\n
  │
  │   (ESP32三视图推理 → 比对TF卡特征)
  │   WS63 → 屏: #DONE,check,match,0.93\r\n
  │   t31 = "比对通过! 相似度:0.93"
  │   sys0 = 4
  │
  └─ [b3] 返回menu → @check,cancel\r\n → page 0
```

### 4.2 上行帧（串口屏 → WS63）

| # | 触发按钮 | 帧内容 | sys0 条件 | 说明 |
|---|----------|--------|-----------|------|
| U3.1 | b2 | `@check,global\r\n` | 无限制 | 全局盘点 |
| U3.2 | b0 | `@check,specific,<tag_id>\r\n` | t03非空且非占位符 | 查询单个资产 |
| U3.3 | b1 | `@check,capture,<tag_id>\r\n` | sys0==1 | 启动AI盘点比对 |
| U3.4 | b4 | `@check,photo,front\r\n` | sys0==3 | 拍正面 |
| U3.5 | b5 | `@check,photo,side\r\n` | sys0==3 | 拍侧面 |
| U3.6 | b6 | `@check,photo,top\r\n` | sys0==3 | 拍顶部 |
| U3.7 | b3 | `@check,cancel\r\n` | 无限制 | 取消当前任务 |

### 4.3 下行帧（WS63 → 串口屏）

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D3.1 | `#INV,<sle_count>,<db_total>\r\n` | 全局盘点完成后 | t31显示双端数量对比 |
| D3.2 | `#TAG_INFO,<tag_id>,<name>,<area>,<count>\r\n` | get_asset 返回后 | t1显示详情，t03回填，sys0=1 |
| D3.3 | `#PROG,<step>,<view>,<score>\r\n` | 每次拍摄完成后 | t4/t31显示进度，sys0=3 |
| D3.4 | `#DONE,check,<result>,<similarity>\r\n` | 盘点比对完成后 | result=match/mismatch, t31显示相似度 |
| D3.5 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t31=msg |
| D3.6 | `#MSG,<text>\r\n` | 通用通知 | t31=text |

---

## 五、Page4 — 资产查找 (find)

> **控制流向**: `list` → ESP32（查数据库）；`locate`/`stop` → WS63 SLE（直接控BS21标签）。

### 5.1 控件职责

| 控件 | 职责 | 示例值 |
|------|------|--------|
| t0–t5 | 资产条目 slot 0~5 (local) | `"0001 扳手 A*50"` |
| t6 | 资产总数 (local) | `"资产总数：150"` |
| t7 | 页码 (local) | `"第1/25页"` |
| t41 | 所有状态/错误/提示 (global) | `"正在定位..."` |
| b2.txt | 定位按钮状态 | `"定位"→"定位中..."→"已激活"` |
| c0–c5 | 选中条目（互斥） | mode=0 |

### 5.2 操作流程

```
进入查找页 (page4)
  │  t7=""  t6=""  t41=""  b2.txt="定位"
  │  sys0=0, sys3=0, sys4=0, sys5=99
  │
  ├─ [b4] 获取列表
  │   屏 → WS63: @find,list,1\r\n
  │   WS63 → ESP32: {"cmd":"list_assets_page","page":1,"page_size":6}
  │   WS63 → 屏: #LIST,1,25,150\r\n
  │   t7="第1/25页"  t6="资产总数：150"  sys4=25
  │   WS63 → 屏: #ITEM,0,0001,扳手,A,50\r\n → t0="0001 扳手 A*50"
  │   ... (逐条发6条)  sys0=1
  │
  ├─ [c2] 选中第3条 → sys5=2
  │
  ├─ [b2] 定位选中标签  ←─ sys5!=99
  │   屏 → WS63: @find,locate,0003\r\n
  │   WS63 → SLE → BS21(0003): 蜂鸣+发光
  │   WS63 → 屏: #LOCATE,found,0003\r\n
  │   b2.txt="已激活"  t41="标签正在蜂鸣..."
  │
  ├─ [b5] 停止定位 → @find,stop\r\n → b2.txt="定位"  t41="已停止定位"
  │
  ├─ [b0/b1] 翻页 → @find,list,N\r\n
  │
  └─ [b3] 返回 → @find,cancel\r\n → page 0
```

### 5.3 上行帧（串口屏 → WS63）

| # | 按钮 | 帧 | 条件 | 说明 |
|---|------|----|------|------|
| U4.1 | b4/b0/b1 | `@find,list,<page>\r\n` | b0:sys3>1, b1:sys3<sys4 | 分页列表 |
| U4.4 | b2 | `@find,locate,<tag_id>\r\n` | sys5!=99 | 标签蜂鸣 |
| U4.5 | b5 | `@find,stop\r\n` | 无限制 | 停止定位 |
| U4.6 | b3 | `@find,cancel\r\n` | 无限制 | 取消+返回 |

### 5.4 下行帧（WS63 → 串口屏）

| # | 帧 | 屏端行为 |
|---|----|----------|
| D4.1 | `#LIST,<page>,<total_pages>,<total_count>\r\n` | t7=页码, t6=总数, sys4=total_pages, 清空t0-t5+c0-c5 |
| D4.2 | `#ITEM,<slot>,<tag_id>,<name>,<area>,<count>\r\n` | t[slot]="tag_id name area*count" |
| D4.3 | `#LOCATE,<status>,<tag_id>\r\n` | b2.txt状态, t41提示 |
| D4.4 | `#ERR,<code>,<msg>\r\n` | t41=msg |
| D4.5 | `#MSG,<text>\r\n` | t41=text |

---

## 六、Page5 — 设置 (setting)

### 6.1 操作流程

```
进入设置页 (page5)
  │  t51="Status"  t3="WiFi_name"  t0="WiFi_pswd"  h0.val=100
  │
  ├─ h0 滑块拖动 → dim=h0.val (本地执行，无串口帧)
  │
  ├─ 收到 WS63 上电主动推送:
  │   ← #NET,wifi,connected,-45
  │   t51="WiFi已连接 信号:-45dBm"
  │
  ├─ [b1] 连接 WiFi → @setting,wifi,ssid,pswd\r\n
  │   ← #WIFI,ok/fail → t51="连接成功/失败"
  │   ← #NET,wifi,connected,-45 → t51="WiFi已连接 信号:-45dBm"
  │
  ├─ [b4] 断开连接 → @setting,disconnect\r\n
  │   ← #NET,wifi,disconnected, → t51="未连接"
  │
  └─ [b3] 返回 → @setting,cancel\r\n → page 0
```

### 6.2 上行帧

| # | 按钮 | 帧 | 条件 |
|---|------|----|------|
| U5.1 | b1 | `@setting,wifi,<ssid>,<password>\r\n` | t3和t0非空 |
| U5.2 | b4 | `@setting,disconnect\r\n` | 无限制 |
| U5.3 | b3 | `@setting,cancel\r\n` | 无限制 |

### 6.3 下行帧

| # | 帧 | 屏端行为 |
|---|----|----------|
| D5.1 | `#NET,<mode>,<status>,<signal>\r\n` | t51显示网络状态 |
| D5.2 | `#WIFI,<result>\r\n` | t51="连接成功/失败" |
| D5.3 | `#ERR,<code>,<msg>\r\n` | t51=msg |
| D5.4 | `#MSG,<text>\r\n` | t51=text |

---

## 七、状态机对照

| sys0 | 含义 | page1 in | page2 out | page3 check | page4 find |
|------|------|:--:|:--:|:--:|:--:|
| 0 | 空闲/初始 | b0 | b0 | b0, b2 | b4 |
| 1 | 信息已获取 | b0, b1 | b0, b4 | b0, b1, b2 | b0,b1,b2,b5,c0-c5 |
| 2 | 已发capture | b0 | b0, b5 | b0, b2 | — |
| 3 | 拍摄中 | b0, b4, b5, b6 | b0 | b4, b5, b6 | — |
| 4 | 推理完成 | b0, b7 | b0, b7 | b0, b2 | — |
| 5 | 验证模式 | b0, b1 | — | — | — |

---

## 八、WS63 处理逻辑

### 8.1 收到 `@in,start` / `@out,start`

```
SLE扫描 → RSSI取最强标签 → 查询本地数据库:
  in:  不存在→#TAG,<id>  /  已存在→#VERIFY,<id>,<name>,<area>,<qty>
  out: 已存在→#TAG,<id>,<name>,<area>,<total>  /  不存在→#ERR
```

### 8.2 收到 `@in,capture,...` (按 mode)

```
mode=0 → register + item_name + storage_area + quantity + is_overwrite:false
mode=1 → register + item_name + storage_area + quantity + is_overwrite:true
mode=2 → register + quantity (不含 item_name，触发验证模式)
```

### 8.3 收到 `@out,capture,<id>,<qty>`

```
→ outbound → asset_info(task=outbound) → #ASSET_INFO,id,name,qty,remove,remain
```

### 8.4 收到 `@<page>,photo,<view>`
```
→ capture view=<view>
```

### 8.5 ESP32 `capture_progress` → `#PROG,<step>,<view>,<blur_score>`

### 8.6 ESP32 `task_done`
```
register: success/success_updated/fail → #DONE,reg,<result>,<id>
outbound: is_match ? success : fail → #DONE,out,<result>
inventory: confidence≥0.75 ? match : mismatch → #DONE,check,<result>,<conf>
```

### 8.7 `@check,global` → SLE扫描 + list_assets_page → `#INV,<sle>,<db>`

### 8.8 `@check,specific,<id>` → get_asset → `#TAG_INFO,id,name,area,qty`

### 8.9 `@check,capture,<id>` → inventory

### 8.10 `@find,list,<page>` → list_assets_page(page_size=6) → #LIST + 逐条#ITEM

### 8.11 `@find,locate,<id>` → SLE→BS21 → #LOCATE,found/timeout

### 8.12 `@find,stop` → SLE停止

### 8.13 `@in,confirm` / `@out,confirm` → 持久化

### 8.14 `@setting,wifi,<ssid>,<pswd>` → 连接+存储 → #WIFI,ok/fail → #NET,...

### 8.15 `@setting,disconnect` → 断开 → #NET,disconnected

### 8.16 `@*,cancel` → cancel JSON → 中断ESP32任务

### 8.17 ESP32 `error` → `#ERR,<code>,<msg>`

### 8.18 上电主动推送 `#NET` 当前网络状态

---

## 九、注意事项

1. **帧尾 `\r\n` 必须完整**，不可省略
2. **连续多帧间隔 ≥10ms**（屏端 tim=50）
3. **Tag ID 屏端不带 `0x` 前缀**，WS63 负责互转
4. **中文 UTF-8**
5. **JSON字段名**: `item_name`(非name), `storage_area`(非area), `quantity`(非count), `remove_qty`(非out_count)
6. **命令名**: `register`, `outbound`, `inventory`, `get_asset`, `capture`, `cancel`, `list_assets_page`
7. **register mode B**: 不含 `item_name` 触发验证模式
8. **outbound 两步**: 先 outbound(查库) → #ASSET_INFO → 再 capture(拍摄+扣减)
9. **outbound 扣减**: ESP32 比对成功才扣减，task_done 含 is_match
10. **locate/stop 不经ESP32**: WS63直连SLE控制BS21
