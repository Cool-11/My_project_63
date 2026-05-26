# WS63 <-> 串口屏 通信协议 v2.0

> **适用型号**: 淘晶驰 T1系列 4.3寸 480x272
> **物理层**: UART, 115200bps, 8N1, 3.3V TTL
> **帧格式**: 逗号分隔文本帧（CSV-like），帧头 `#` / `@`，帧尾 `\r\n`
> **屏端模式**: `recmod=1` 主动解析
> **UI 方案**: 单页设计，组件显示/隐藏切换视图
> **文档版本**: v2.0
> **最后更新**: 2026-05-26

---

## 一、帧格式总则

### 1.1 文本帧结构

```
帧头(1B) + CMD + 参数字段(逗号分隔) + 帧尾(2B)
```

| 字段 | 值 | 说明 |
|------|-----|------|
| 帧头 | `#` (0x23) 或 `@` (0x40) | `@` = 屏->WS63，`#` = WS63->屏 |
| 分隔符 | `,` (0x2C) | 字段间分隔 |
| 帧尾 | `\r\n` (0x0D 0x0A) | 帧结束标志 |

### 1.2 命名约定

- **CMD**: 帧头后、第一个逗号前的命令标识符
- 参数全部为可打印 ASCII 字符串，无二进制数值
- 帧长不定，屏端缓冲区 1024 字节（T1系列限制）
- WS63 单帧总长不超过 200 字节为宜

### 1.3 Tag ID 格式约定

| 通信层面 | 格式 | 示例 | 说明 |
|----------|------|------|------|
| 屏 <-> WS63 | 纯数字字符串 | `0001` | 不含 `0x` 前缀，4位补零 |
| WS63 <-> ESP32 | 十六进制字符串 | `0x0001` | 含 `0x` 前缀 |

> **WS63 职责**: 屏端协议与 ESP32 协议之间的 Tag ID 格式互转（加/去 `0x` 前缀）。

### 1.4 连续发送间隔

连续发送多帧时，间隔至少 10ms，给屏端足够的处理窗口。

---

## 二、单页 UI 布局

整个系统只有 1 个 page，通过 sys0 状态变量控制组件组的显示/隐藏来切换视图。

### 2.1 组件组划分

```
┌───────────────────────────────────────────────┐
│  状态栏（始终显示）                               │
│  t_wifi: "WiFi:已连接"  t_mqtt: "MQTT:已连接"    │
│  t_count: "标签:5/32"                           │
├───────────────────────────────────────────────┤
│                                               │
│  === 组件组A: 主菜单 (sys0=0, 可见) ===         │
│  [b_menu_in:入库] [b_menu_out:出库]            │
│  [b_menu_inv:盘点] [b_menu_find:寻物]          │
│                                               │
│  === 组件组B: 入库 (sys0=1~4, 可见) ===         │
│  t_in_tag:  "Tag: ____"                       │
│  t_in_name: "货物: [________]"  (键盘输入)      │
│  t_in_area: "区域: [________]"  (键盘输入)      │
│  t_in_qty:  "数量: [________]"  (键盘输入)      │
│  t_in_cam:  "拍摄: -/- ___"                   │
│  t_in_score:"清晰度: -"                        │
│  [b_in_scan:扫描] [b_in_front:拍正面]           │
│  [b_in_side:拍侧面] [b_in_top:拍顶部]           │
│  [b_in_ok:确认入库] [b_in_back:返回]            │
│                                               │
│  === 组件组C: 出库 (sys0=5~7, 可见) ===         │
│  t_out_tag:  "Tag: ____"                      │
│  t_out_name: "货物: ____"                     │
│  t_out_area: "区域: ____"                     │
│  t_out_qty:  "当前库存: ____"                  │
│  t_out_input:"出库数量: [________]" (键盘输入)   │
│  t_out_cam:  "拍摄: -/- ___"                  │
│  t_out_score:"清晰度: -"                       │
│  [b_out_scan:扫描] [b_out_front:拍正面]         │
│  [b_out_ok:确认出库] [b_out_back:返回]          │
│                                               │
│  === 组件组D: 盘点 (sys0=8, 可见) ===           │
│  t_inv_prog: "进度: __/__"                    │
│  t_inv_cur:  "当前: #___ ___"                 │
│  t_inv_qty:  "数量: __  电量: __%"             │
│  t_inv_bar:  "[▓▓▓▓▓░░░░] __%"               │
│  t_inv_res:  "盘点完成 正常:__ 异常:__"         │
│  [b_inv_all:全量盘点] [b_inv_back:返回]         │
│                                               │
│  === 组件组E: 寻物 (sys0=9, 可见) ===           │
│  t_find_tag: "寻物中: #___"                    │
│  [b_find_stop:停止寻物] [b_find_back:返回]      │
│                                               │
├───────────────────────────────────────────────┤
│  消息区（始终显示）                               │
│  t_status: "请按扫描按钮"                       │
└───────────────────────────────────────────────┘
```

### 2.2 组件 ID 分配表

#### 始终可见组件

| 组件ID | 类型 | 说明 |
|--------|------|------|
| t_wifi | 文本 | WiFi 状态 |
| t_mqtt | 文本 | MQTT 状态 |
| t_count | 文本 | 在线标签数 |
| t_status | 文本 | 消息提示区 |

#### 组件组A - 主菜单 (sys0=0)

| 组件ID | 类型 | 说明 |
|--------|------|------|
| b_menu_in | 按钮 | 入库 |
| b_menu_out | 按钮 | 出库 |
| b_menu_inv | 按钮 | 盘点 |
| b_menu_find | 按钮 | 寻物 |

#### 组件组B - 入库 (sys0=1~4)

| 组件ID | 类型 | 说明 |
|--------|------|------|
| t_in_tag | 文本 | Tag ID 显示 |
| t_in_name | 文本输入 | 货物名称（点击弹键盘） |
| t_in_area | 文本输入 | 存储区域（点击弹键盘） |
| t_in_qty | 数字输入 | 入库数量（点击弹数字键盘） |
| t_in_cam | 文本 | 拍摄进度 |
| t_in_score | 文本 | 清晰度评分 |
| b_in_scan | 按钮 | 扫描标签 |
| b_in_front | 按钮 | 拍正面 |
| b_in_side | 按钮 | 拍侧面 |
| b_in_top | 按钮 | 拍顶部 |
| b_in_ok | 按钮 | 确认入库 |
| b_in_back | 按钮 | 返回主菜单 |

#### 组件组C - 出库 (sys0=5~7)

| 组件ID | 类型 | 说明 |
|--------|------|------|
| t_out_tag | 文本 | Tag ID 显示 |
| t_out_name | 文本 | 货物名称（只读） |
| t_out_area | 文本 | 存储区域（只读） |
| t_out_qty | 文本 | 当前库存（只读） |
| t_out_input | 数字输入 | 出库数量（点击弹数字键盘） |
| t_out_cam | 文本 | 拍摄进度 |
| t_out_score | 文本 | 清晰度评分 |
| b_out_scan | 按钮 | 扫描标签 |
| b_out_front | 按钮 | 拍正面 |
| b_out_ok | 按钮 | 确认出库 |
| b_out_back | 按钮 | 返回主菜单 |

#### 组件组D - 盘点 (sys0=8)

| 组件ID | 类型 | 说明 |
|--------|------|------|
| t_inv_prog | 文本 | 进度文字 |
| t_inv_cur | 文本 | 当前盘点的标签信息 |
| t_inv_qty | 文本 | 当前标签数量和电量 |
| t_inv_bar | 文本 | 进度条（ASCII模拟） |
| t_inv_res | 文本 | 盘点结果汇总 |
| b_inv_all | 按钮 | 全量盘点 |
| b_inv_back | 按钮 | 返回主菜单 |

#### 组件组E - 寻物 (sys0=9)

| 组件ID | 类型 | 说明 |
|--------|------|------|
| t_find_tag | 文本 | 寻物中的标签信息 |
| b_find_stop | 按钮 | 停止寻物 |
| b_find_back | 按钮 | 返回主菜单 |

### 2.3 sys0 状态定义

| sys0 | 视图 | 含义 | 可用操作 |
|------|------|------|---------|
| 0 | 主菜单 | 空闲 | 入库/出库/盘点/寻物 |
| 1 | 入库 | 待扫描 | 扫描、返回 |
| 2 | 入库 | 已获取tag，待填信息+拍照 | 拍正/侧/顶、确认、返回 |
| 3 | 入库 | 拍摄中（等待ESP32响应） | 返回 |
| 4 | 入库 | 推理完成，待确认 | 确认入库、返回 |
| 5 | 出库 | 待扫描 | 扫描、返回 |
| 6 | 出库 | 已获取tag，待填数量+拍照 | 拍正、确认、返回 |
| 7 | 出库 | 拍摄/验证中（等待ESP32响应） | 返回 |
| 8 | 盘点 | 盘点进行中 | 取消/返回 |
| 9 | 寻物 | 寻物进行中 | 停止寻物、返回 |

### 2.4 显示/隐藏规则

屏端根据 sys0 值自动控制组件组显隐：

```
当 sys0 变化时:
  组件组A 显示 = (sys0 == 0)
  组件组B 显示 = (sys0 >= 1 && sys0 <= 4)
  组件组C 显示 = (sys0 >= 5 && sys0 <= 7)
  组件组D 显示 = (sys0 == 8)
  组件组E 显示 = (sys0 == 9)
```

每次切换视图时，清空上一个视图的输入框内容。

---

## 三、上行帧（串口屏 -> WS63）

### 3.1 入库操作

| # | 触发按钮 | 帧内容 | sys0条件 | 说明 |
|---|----------|--------|----------|------|
| U1.1 | b_in_scan | `@in,start\r\n` | sys0==1 | 请求扫描最近标签 |
| U1.2a | b_in_front | `@in,photo,front\r\n` | sys0==2 | 拍正面视图（新注册） |
| U1.2b | b_in_side | `@in,photo,side\r\n` | sys0==2 | 拍侧面视图（新注册） |
| U1.2c | b_in_top | `@in,photo,top\r\n` | sys0==2 | 拍顶部视图（新注册） |
| U1.3a | b_in_ok | `@in,capture,<tag_id>,<qty>,<area>,<name>\r\n` | sys0==2 且字段非空 | 新资产注册（5字段） |
| U1.3b | b_in_ok | `@in,capture,<tag_id>,<qty>\r\n` | sys0==4 且验证模式 | 验证式更新（3字段） |
| U1.4 | b_in_ok | `@in,confirm\r\n` | sys0==4 | 确认入库 |
| U1.5 | b_in_back | `@back\r\n` | sys0>=1 | 返回主菜单 |

> **WS63 区分新注册/验证更新**: 根据 `@in,capture` 帧中逗号数量（4个逗号=新注册, 2个逗号=验证更新）。

> **注意**: 拍照和发送信息的顺序调整为：先拍照（U1.2），再发送注册信息（U1.3）。拍完3张照片后，用户确认信息无误，点击"确认入库"发送 capture 帧。

### 3.2 出库操作

| # | 触发按钮 | 帧内容 | sys0条件 | 说明 |
|---|----------|--------|----------|------|
| U2.1 | b_out_scan | `@out,start\r\n` | sys0==5 | 请求扫描最近标签 |
| U2.2 | b_out_front | `@out,photo,front\r\n` | sys0==6 | 拍正面视图 |
| U2.3 | b_out_ok | `@out,capture,<tag_id>,<qty>\r\n` | sys0==6 且出库数量非空 | 出库+启动摄像头 |
| U2.4 | b_out_ok | `@out,confirm\r\n` | sys0==7 且验证通过 | 确认出库 |
| U2.5 | b_out_back | `@back\r\n` | sys0>=5 | 返回主菜单 |

### 3.3 盘点操作

| # | 触发按钮 | 帧内容 | sys0条件 | 说明 |
|---|----------|--------|----------|------|
| U3.1 | b_inv_all | `@inv,all\r\n` | sys0==8 | 全量盘点 |
| U3.2 | (标签列表点击) | `@inv,tag,<tag_id>\r\n` | sys0==8 | 单标签盘点 |
| U3.3 | (区域筛选选择) | `@inv,zone,<zone>\r\n` | sys0==8 | 按区域盘点 |
| U3.4 | b_inv_back | `@back\r\n` | sys0==8 | 返回主菜单 |

### 3.4 寻物操作

| # | 触发按钮 | 帧内容 | sys0条件 | 说明 |
|---|----------|--------|----------|------|
| U4.1 | (标签列表点击) | `@find,start,<tag_id>\r\n` | sys0==0 或 sys0==9 | 启动寻物 |
| U4.2 | b_find_stop | `@find,stop,<tag_id>\r\n` | sys0==9 | 停止寻物 |
| U4.3 | b_find_back | `@back\r\n` | sys0==9 | 返回主菜单 |

### 3.5 通用

| # | 触发按钮 | 帧内容 | 说明 |
|---|----------|--------|------|
| U5.1 | (主菜单按钮) | `@back\r\n` | 从任意视图返回主菜单，sys0=0 |

---

## 四、下行帧（WS63 -> 串口屏）

### 4.1 入库响应

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D1.1 | `#TAG,<tag_id>\r\n` | 标签未注册时 | t_in_tag=tag_id, 提示填写信息, sys0=2 |
| D1.2 | `#VERIFY,<tag_id>,<name>,<area>,<qty>\r\n` | 标签已注册时（验证模式） | 自动填入已有信息, 提示拍正面验证, sys0=2 |
| D1.3 | `#PROG,<step>,<view>,<score>\r\n` | 每次拍照完成后 | t_in_cam=拍摄进度, t_in_score=清晰度, sys0=2 |
| D1.4 | `#DONE,reg,success,<tag_id>\r\n` | 新注册成功 | 提示入库成功, sys0=4 |
| D1.5 | `#DONE,reg,success_updated,<tag_id>\r\n` | 验证更新成功 | 提示验证通过+库存累加结果, sys0=4 |
| D1.6 | `#DONE,reg,fail,<tag_id>\r\n` | 注册失败 | 提示失败原因, sys0=0 |

### 4.2 出库响应

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D2.1 | `#TAG,<tag_id>,<name>,<area>,<total>\r\n` | 扫描到已注册标签 | 填入标签信息, sys0=6 |
| D2.2 | `#PROG,1,front,<score>\r\n` | 正面拍摄完成后 | t_out_cam=拍摄进度, t_out_score=清晰度 |
| D2.3 | `#DONE,out,success,<new_qty>\r\n` | 验证通过+出库成功 | 提示出库成功+剩余数量, sys0=7 |
| D2.4 | `#DONE,out,fail\r\n` | 验证失败 | 提示物品不匹配, sys0=6 |
| D2.5 | `#ERR,ERR_ASSET_NOT_FOUND,标签未注册\r\n` | 扫描到未注册标签 | 提示标签未注册, sys0=5 |

### 4.3 盘点响应

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D3.1 | `#INV,START,<total>\r\n` | 盘点开始 | t_inv_prog="进度: 0/total", sys0=8 |
| D3.2 | `#INV,PROG,<done>,<total>,<tag_id>,<name>,<area>,<qty>,<battery>\r\n` | 每个标签盘点完成 | 更新进度条+当前标签信息 |
| D3.3 | `#INV,ERR,<tag_id>,<reason>\r\n` | 单个标签盘点失败 | 显示失败标签+原因（离线/超时） |
| D3.4 | `#INV,DONE,<total>,<normal>,<abnormal>\r\n` | 全部盘点完成 | 显示结果汇总, sys0=8 |
| D3.5 | `#INV,CANCEL\r\n` | 用户取消盘点 | 提示已取消, sys0=0 |

#### D3.2 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| done | 字符串 | `5` | 已完成数量 |
| total | 字符串 | `12` | 总数量 |
| tag_id | 字符串 | `0005` | 当前标签ID |
| name | 字符串 | `扳手` | 货物名称 |
| area | 字符串 | `A1` | 存放区域 |
| qty | 字符串 | `80` | 盘点到的数量 |
| battery | 字符串 | `85` | 电池百分比 |

#### D3.4 字段说明

| 字段 | 类型 | 示例值 | 说明 |
|------|------|--------|------|
| total | 字符串 | `12` | 盘点总数 |
| normal | 字符串 | `10` | 正常标签数 |
| abnormal | 字符串 | `2` | 异常标签数（离线/超时/数量异常） |

### 4.4 寻物响应

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D4.1 | `#FIND,START,<tag_id>\r\n` | 寻物启动成功 | t_find_tag="寻物中: #xxx", sys0=9 |
| D4.2 | `#FIND,STOP,<tag_id>\r\n` | 寻物停止 | 提示已停止, sys0=0 |
| D4.3 | `#FIND,FAIL,<tag_id>,<reason>\r\n` | 寻物启动失败 | 提示失败原因, sys0=0 |

### 4.5 通用响应

| # | 帧内容 | 触发时机 | 屏端行为 |
|---|--------|----------|----------|
| D5.1 | `#ERR,<code>,<msg>\r\n` | 任何错误发生时 | t_status=msg |
| D5.2 | `#MSG,<text>\r\n` | 通用通知 | t_status=text |
| D5.3 | `#STATUS,<wifi>,<mqtt>,<tag_count>\r\n` | 状态变化时 | 更新状态栏 |

#### 错误码列表

| 错误码 | 含义 |
|--------|------|
| ERR_ASSET_NOT_FOUND | 标签未注册 |
| ERR_VERIFICATION_FAILED | 物品不匹配（图像验证失败） |
| ERR_BLUR_DETECTED | 图像模糊 |
| ERR_LOW_CONFIDENCE | 置信度过低 |
| ERR_TAG_NOT_FOUND | 扫描不到标签 |
| ERR_BUSY | 系统忙（有pending操作） |
| ERR_TIMEOUT | 操作超时 |
| ERR_SLE_FAIL | SLE通信失败 |
| ERR_UNKNOWN | 未知错误 |

---

## 五、完整操作流程

### 5.1 入库 - 新资产注册

```
用户操作                       屏幕发送                      WS63 处理
──────────────────────────────────────────────────────────────────────

1. 主菜单点[入库]
   sys0: 0→1                              组件组A隐藏, 组件组B显示

2. 点[扫描]
   屏→WS63: @in,start\r\n                SLE扫描, RSSI取最近标签
                                          查询数据库: 标签不存在
   WS63→屏: #TAG,0005\r\n                t_in_tag="0005"
                                          t_status="已获取Tag,请填写信息"
                                          sys0: 1→2

3. 用户点击 t_in_name 弹键盘输入 "扳手"
   用户点击 t_in_area 弹键盘输入 "A1"
   用户点击 t_in_qty 弹键盘输入 "50"

4. 点[拍正面]
   屏→WS63: @in,photo,front\r\n          WS63→ESP32: {"cmd":"capture","view":"front"}
                                          ESP32拍照+返回
   WS63→屏: #PROG,1,front,87.3\r\n       t_in_cam="1/3 front"
                                          t_in_score="87.3"

5. 点[拍侧面]
   屏→WS63: @in,photo,side\r\n           WS63→ESP32: {"cmd":"capture","view":"side"}
   WS63→屏: #PROG,2,side,91.2\r\n        t_in_cam="2/3 side"

6. 点[拍顶部]
   屏→WS63: @in,photo,top\r\n            WS63→ESP32: {"cmd":"capture","view":"top"}
   WS63→屏: #PROG,3,top,85.7\r\n         t_in_cam="3/3 top"

7. 用户确认信息无误, 点[确认入库]
   屏→WS63: @in,capture,0005,50,A1,扳手\r\n
                                          WS63: tag_id格式转换 "0005"→"0x0005"
                                          WS63→ESP32: {"cmd":"register",
                                            "tag_id":"0x0005",
                                            "quantity":50,
                                            "storage_area":"A1",
                                            "item_name":"扳手"}
                                          (ESP32三视图推理, ~7.5秒)
   WS63→屏: #DONE,reg,success,0005\r\n   t_status="入库成功!"
                                          sys0: 2→4

8. 点[确认入库] (或自动返回)
   屏→WS63: @in,confirm\r\n              WS63: 持久化资产记录
                                          sys0: 4→0, 组件组B隐藏, 组件组A显示
```

### 5.2 入库 - 验证式更新（标签已注册）

```
1. 主菜单点[入库] → sys0=1
2. 点[扫描]
   屏→WS63: @in,start\r\n
   WS63: 查询数据库: 标签已存在 (扳手, A1, 库存50)
   WS63→屏: #VERIFY,0005,扳手,A1,50\r\n
           t_in_tag="0005", t_in_name="扳手", t_in_area="A1"
           t_in_qty="50", t_in_cam="验证模式: 仅需正面"
           sys0: 1→2

3. 用户输入新增数量 → t_in_qty="20" (覆盖显示)

4. 点[拍正面]
   屏→WS63: @in,photo,front\r\n
   WS63→ESP32: {"cmd":"capture","view":"front"}
   WS63→屏: #PROG,1,front,92.1\r\n

5. 点[确认入库]
   屏→WS63: @in,capture,0005,20\r\n      (3字段=验证更新)
   WS63→ESP32: {"cmd":"register","tag_id":"0x0005","quantity":20}

   ├─ 相似度>=0.75 → #DONE,reg,success_updated,0005\r\n
   │                  t_status="验证通过! 库存 50+20=70"
   │                  sys0=4
   │
   └─ 相似度<0.75  → #DONE,reg,fail,0005\r\n
                      t_status="验证失败: 物品不匹配"
                      sys0=0
```

### 5.3 出库

```
1. 主菜单点[出库] → sys0=5

2. 点[扫描]
   屏→WS63: @out,start\r\n
   WS63: 查询数据库: 标签存在
   WS63→屏: #TAG,0005,扳手,A1,80\r\n
           t_out_tag="0005", t_out_name="扳手"
           t_out_area="A1", t_out_qty="80"
           sys0: 5→6

3. 用户输入出库数量 → t_out_input="5"

4. 点[拍正面]
   屏→WS63: @out,photo,front\r\n
   WS63→ESP32: {"cmd":"capture","view":"front"}
   WS63→屏: #PROG,1,front,87.3\r\n

5. 点[确认出库]
   屏→WS63: @out,capture,0005,5\r\n
   WS63→ESP32: {"cmd":"outbound","tag_id":"0x0005","remove_qty":5}
   (ESP32推理+验证+扣减)

   ├─ 验证通过 → #DONE,out,success,75\r\n    (new_qty=80-5=75)
   │             t_status="出库成功! 剩余: 75"
   │             sys0: 6→7
   │
   └─ 验证失败 → #DONE,out,fail\r\n
                  t_status="验证失败: 物品不匹配"
                  sys0: 6

6. 点[确认] 或 [返回]
   屏→WS63: @out,confirm\r\n 或 @back\r\n
   sys0→0
```

### 5.4 盘点 - 全量盘点

```
1. 主菜单点[盘点] → sys0=8, 组件组D显示

2. 点[全量盘点]
   屏→WS63: @inv,all\r\n

   WS63→屏: #INV,START,12\r\n            t_inv_prog="进度: 0/12"
                                          t_inv_bar="[░░░░░░░░░░] 0%"

   (WS63逐个标签发SSAP INVENTORY命令)

   WS63→屏: #INV,PROG,1,12,0001,Type-C,A1,50,95\r\n
           t_inv_prog="进度: 1/12"
           t_inv_cur="当前: #001 Type-C A1"
           t_inv_qty="数量: 50  电量: 95%"
           t_inv_bar="[▓░░░░░░░░░] 8%"

   WS63→屏: #INV,PROG,2,12,0003,螺丝,B2,200,88\r\n
           t_inv_prog="进度: 2/12"
           t_inv_bar="[▓▓░░░░░░░░] 17%"

   ... (逐个推进)

   WS63→屏: #INV,ERR,0009,离线\r\n        (某个标签盘点失败)
           (异常计数+1, 继续下一个)

   WS63→屏: #INV,PROG,12,12,0015,热缩管,A2,300,72\r\n
           t_inv_bar="[▓▓▓▓▓▓▓▓▓▓] 100%"

   WS63→屏: #INV,DONE,12,10,2\r\n         t_inv_res="盘点完成 正常:10 异常:2"
                                          t_status="盘点完成"
                                          (停留显示结果)
```

### 5.5 盘点 - 单标签盘点

```
1. 主菜单点[盘点] → sys0=8

2. (从标签列表选择某个标签，或手动输入tag_id)
   屏→WS63: @inv,tag,0005\r\n

   WS63→屏: #INV,START,1\r\n              t_inv_prog="进度: 0/1"

   (WS63对tag_id=5发SSAP INVENTORY)

   WS63→屏: #INV,PROG,1,1,0005,扳手,A1,80,85\r\n
           t_inv_cur="当前: #005 扳手 A1"
           t_inv_qty="数量: 80  电量: 85%"

   WS63→屏: #INV,DONE,1,1,0\r\n           t_inv_res="盘点完成 正常:1 异常:0"
```

### 5.6 盘点 - 按区域盘点

```
1. 主菜单点[盘点] → sys0=8

2. (从区域筛选选择区域，或手动输入区域名)
   屏→WS63: @inv,zone,A1\r\n

   WS63: 过滤 biz_tag_map 中 area=="A1" 的标签，逐个盘点

   WS63→屏: #INV,START,4\r\n              (A1区有4个标签)

   WS63→屏: #INV,PROG,1,4,0001,Type-C,A1,50,95\r\n
   WS63→屏: #INV,PROG,2,4,0005,扳手,A1,80,85\r\n
   WS63→屏: #INV,PROG,3,4,0007,焊锡,A1,150,60\r\n
   WS63→屏: #INV,PROG,4,4,0012,电容,A1,500,90\r\n

   WS63→屏: #INV,DONE,4,4,0\r\n           t_inv_res="A1区盘点完成 正常:4 异常:0"
```

### 5.7 寻物

```
1. (从标签列表选择某个标签)
   屏→WS63: @find,start,0005\r\n

   WS63: 发SSAP FIND命令给BS21E

   ├─ 成功 → #FIND,START,0005\r\n
   │         t_find_tag="寻物中: #005 扳手"
   │         sys0=9
   │         (标签开始闪烁/蜂鸣)
   │
   └─ 失败 → #FIND,FAIL,0005,标签离线\r\n
             sys0=0

2. 点[停止寻物]
   屏→WS63: @find,stop,0005\r\n
   WS63: 发SSAP STOP FIND命令
   WS63→屏: #FIND,STOP,0005\r\n
           t_status="寻物已停止"
           sys0=0
```

---

## 六、WS63 处理逻辑

### 6.1 Tag ID 转换

```
屏→WS63:  "0005"    →  WS63内部: uint16_t 5  →  ESP32: "0x0005"
ESP32→WS63: "0x0005"  →  WS63内部: uint16_t 5  →  屏: "0005"
```

WS63 使用 `snprintf(buf, 5, "%04u", tag_id)` 生成4位补零字符串给屏幕。

### 6.2 @in,start 处理

```
1. SLE扫描 → RSSI取最强标签 → 获取tag_id
2. 查询 biz_tag_map:
   - 不存在 → 发送 #TAG,<tag_id>                          (新注册模式)
   - 已存在 → 发送 #VERIFY,<tag_id>,<name>,<area>,<qty>   (验证更新模式)
```

### 6.3 @in,capture 处理

```
解析逗号数量:
  4个逗号 (新注册): @in,capture,0005,50,A1,扳手
    → ESP32: {"cmd":"register","tag_id":"0x0005","quantity":50,
              "storage_area":"A1","item_name":"扳手"}

  2个逗号 (验证更新): @in,capture,0005,20
    → ESP32: {"cmd":"register","tag_id":"0x0005","quantity":20}
```

### 6.4 @out,capture 处理

```
@out,capture,0005,5
→ ESP32: {"cmd":"outbound","tag_id":"0x0005","remove_qty":5}
```

### 6.5 @in,photo / @out,photo 处理

```
@in,photo,front  → ESP32: {"cmd":"capture","view":"front"}
@in,photo,side   → ESP32: {"cmd":"capture","view":"side"}
@in,photo,top    → ESP32: {"cmd":"capture","view":"top"}
@out,photo,front → ESP32: {"cmd":"capture","view":"front"}
```

### 6.6 ESP32 capture_progress 处理

```
ESP32返回:
{"type":"capture_progress","tag_id":"0x0005","view":"front",
 "step":"1/3","status":"ok","blur_score":87.3,"feature_size":1280}

WS63→屏: #PROG,1,front,87.3\r\n
(step取"1/3"的分子, view原样, blur_score原样)
```

### 6.7 ESP32 task_done 处理

```
register/success:
  → #DONE,reg,success,<tag_id>\r\n

register/success_updated:
  → #DONE,reg,success_updated,<tag_id>\r\n

register/fail:
  → #DONE,reg,fail,<tag_id>\r\n

outbound/success:
  → #DONE,out,success,<new_qty>\r\n

outbound/fail:
  → #DONE,out,fail\r\n
```

### 6.8 @inv 盘点处理

```
@inv,all          → 全量盘点: 遍历 biz_tag_map 所有已注册标签
@inv,tag,0005     → 单标签盘点: 只对 tag_id=5 发 SSAP INVENTORY
@inv,zone,A1      → 区域盘点: 过滤 area=="A1" 的标签，逐个盘点

每个标签处理:
  1. 发 SSAP INVENTORY 命令
  2. 等待 notify 回调（带 qty + battery）
  3. 发送 #INV,PROG,<done>,<total>,<tag_id>,<name>,<area>,<qty>,<battery>
  4. 超时未响应 → 发送 #INV,ERR,<tag_id>,超时
  5. 全部完成 → 发送 #INV,DONE,<total>,<normal>,<abnormal>

取消:
  收到 @back 或超时 → 发送 #INV,CANCEL\r\n → sys0=0
```

### 6.9 @find 寻物处理

```
@find,start,0005
  → SSAP FIND 命令 → BS21E 开始闪烁/蜂鸣
  → 成功: #FIND,START,0005\r\n, sys0=9
  → 失败: #FIND,FAIL,0005,原因\r\n, sys0=0

@find,stop,0005
  → SSAP STOP FIND 命令
  → #FIND,STOP,0005\r\n, sys0=0
```

### 6.10 @back 处理

```
收到 @back:
  - 如果有 pending 寻物 → 先发 stop
  - 如果有 pending 盘点 → 取消
  - sys0=0
  - 组件组B/C/D/E隐藏, 组件组A显示
```

---

## 七、注意事项

1. **屏端缓冲区仅 1024 字节**（T1 系列），WS63 单帧总长不超过 200 字节
2. **帧尾 `\r\n` 必须完整发送**，不可省略
3. **连续发送多帧时**，间隔至少 10ms
4. **Tag ID 不含 `0x` 前缀**，屏端不处理十六进制转换
5. **所有字段为 ASCII 字符串**，中文使用 UTF-8 编码
6. **帧头 `@` 和 `#` 不出现在参数字段中**，避免屏端误判
7. **WS63->ESP32 JSON 字段名**必须与 ESP32 协议严格一致：
   - `item_name`（非 `name`）
   - `storage_area`（非 `area`）
   - `quantity`（非 `count`）
   - `remove_qty`（非 `out_count`）
8. **盘点时 WS63 为阻塞式逐个处理**，同一时间只有一个 SSAP 命令 pending
9. **sys0 变化时屏端自动切换视图**，WS63 不发送 page 切换指令
10. **WS63 需维护当前操作的 tag_id**，confirm 帧不带 tag_id 参数
