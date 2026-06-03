# P0 功能需求文档

> **来源**: grill-me 对话确认 + 协议文档比对
> **日期**: 2026-06-01
> **状态**: 待实现
> **约束**: 严格遵循 CLAUDE.md，不擅自优化未提及的模块

---

## 一、硬件确认

| 项目 | 值 |
|------|-----|
| UART2 RX | GPIO7, 复用模式2 |
| UART2 TX | GPIO8, 复用模式2 |
| 波特率 | 115200 |
| 帧尾 | `\r\n` |
| 串口屏型号 | 淘晶驰 T1 4.3寸 480×272 |

---

## 二、注册表架构

```
WS63 NV Flash (0x5001)          ESP32 TF 卡
┌──────────────────┐            ┌──────────────────┐
│ biz_tag_map_t    │            │ 资产特征文件      │
│ ├─ tag_id        │            │ ├─ 0x0001.dat    │
│ ├─ mac           │            │ ├─ 0x0002.dat    │
│ ├─ zone          │            │ └─ ...           │
│ ├─ item          │            │                  │
│ ├─ qty           │            │ JPEG 图像        │
│ ├─ status        │            │ ├─ 0x0001_front  │
│ └─ battery       │            │ ├─ 0x0001_side   │
└──────────────────┘            │ └─ 0x0001_top    │
                                └──────────────────┘
权威源头: WS63                  视觉特征存储
```

- 入库时两份**同时写入**
- WS63 重启后从 NV Flash 恢复，两端数据一致
- WS63 是权威源头，ESP32 也有自己的表做管理分配

---

## 三、Tag ID 转换规则

```
屏 → WS63:    "0001"     (纯数字，无0x前缀)
WS63 内部:    uint16_t 1
WS63 → ESP32: "0x0001"   (含0x前缀，十六进制字符串)
ESP32 → WS63: "0x0001"   (JSON字段值)
WS63 → 屏:    "0001"     (去0x前缀)
```

---

## 四、通用规则

### 4.1 超时与重试

| 参数 | SLE 命令 | ESP32 命令 |
|------|---------|-----------|
| 超时时间 | 3 秒 | 5 秒 |
| 重试次数 | 3 次 | 3 次 |
| 重试间隔 | 立即 | 立即 |
| 最大总耗时 | 9 秒 | 15 秒 |
| 失败返回 | `#ERR,ERR_TIMEOUT,操作超时` | `#ERR,ERR_TIMEOUT,操作超时` |

### 4.2 RSSI 取最强标签

- `@in,start` 和 `@out,start` 都从 `g_scan_table` 取 RSSI 最强的标签
- `@in,start` 过滤条件：未在 `biz_map` 中注册的标签
- `@out,start` 过滤条件：已在 `biz_map` 中注册的标签

### 4.3 扫描表为空 / 无匹配标签

- `@in,start` 扫描表为空或无未注册标签 → 返回 `#ERR,ERR_NO_TAG,未找到标签`
- `@out,start` 扫描表为空或无已注册标签 → 返回 `#ERR,ERR_NO_TAG,未找到标签`
- `@in,start` 所有标签都已注册 → 返回 `#FULL` 给屏

### 4.4 BS21E 不在范围的处理

- `@in,confirm` 时 BS21E 不在范围 → 返回绑定失败 → **需要从 `@in,start` 重新开始**
- ESP32 的三视图数据不保留，需要重新拍摄

---

## 五、Page1 入库完整流程

### 5.1 操作流程

```
进入入库页面 (page1)
  │  sys0=0
  │
  ├─ [b0] @in,start
  │   WS63: 读 scan_table → 过滤未注册 → 取 RSSI 最强
  │   ├─ 找到未注册标签
  │   │   WS63 → 屏: #TAG,0001\r\n
  │   │   t0 = "0001", sys0 = 1
  │   │
  │   ├─ 所有标签都已注册
  │   │   WS63 → 屏: #FULL\r\n
  │   │
  │   └─ 扫描表为空
  │       WS63 → 屏: #ERR,ERR_NO_TAG,未找到标签\r\n
  │
  ├─ 用户填写: t3="扳手", t2="A", t1="50"
  │
  ├─ [b1] @in,capture,0001,50,A,扳手,0
  │   WS63: 记录 tag_id + MAC 到 g_biz_pending（不连接 BS21E）
  │   WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":50,
  │                   "storage_area":"A","item_name":"扳手","is_overwrite":false}
  │   WS63 → 屏: #PROG,1,front,0\r\n, sys0=3
  │
  ├─ [b4] @in,photo,front → capture → #PROG,1,front,87.3
  ├─ [b5] @in,photo,side  → capture → #PROG,2,side,91.2
  ├─ [b6] @in,photo,top   → capture → #PROG,3,top,85.7
  │
  │   ESP32 三视图推理完成
  │   ESP32 → WS63: task_done(register, success)
  │   WS63 → 屏: #DONE,reg,success,0001\r\n, sys0=4
  │
  ├─ [b7] @in,confirm
  │   WS63: 连接 BS21E（用 MAC）
  │   WS63: 发 BIND_TAG
  │   ├─ 成功
  │   │   蜂鸣 5 秒
  │   │   写 NV Flash (biz_map_save_nv)
  │   │   上云 ThingsKit (biz_publish_tag_update)
  │   │   WS63 → 屏: #MSG,绑定成功\r\n
  │   │   sys0 = 0
  │   │
  │   └─ 失败 (BS21E 不在范围)
  │       WS63 → 屏: #ERR,ERR_BIND_FAIL,绑定失败\r\n
  │       需要从 @in,start 重新开始
  │
  └─ [b3] @in,cancel → 发 cancel 给 ESP32 → 清 pending → 返回主页
```

### 5.2 上行帧

| 按钮 | 帧内容 | sys0 条件 | 说明 |
|------|--------|-----------|------|
| b0 | `@in,start\r\n` | 无限制 | 扫描最强未注册标签 |
| b1 | `@in,capture,<id>,<qty>,<area>,<name>,<mode>\r\n` | sys0==1 | mode: 0=新注册, 1=覆写, 2=验证 |
| b4 | `@in,photo,front\r\n` | sys0==3 | 拍正面 |
| b5 | `@in,photo,side\r\n` | sys0==3 | 拍侧面 |
| b6 | `@in,photo,top\r\n` | sys0==3 | 拍顶部 |
| b7 | `@in,confirm\r\n` | sys0==4 | 确认入库 |
| b3 | `@in,cancel\r\n` | 无限制 | 取消 |

### 5.3 下行帧

| 帧内容 | 触发时机 | 屏端行为 |
|--------|---------|---------|
| `#TAG,<id>\r\n` | 扫到未注册标签 | t0=id, sys0=1 |
| `#FULL\r\n` | 所有标签已注册 | 提示已满 |
| `#PROG,<step>,<view>,<score>\r\n` | 拍摄完成 | t4=步骤, t5=清晰度, sys0=3 |
| `#DONE,reg,<result>,<id>\r\n` | 推理完成 | success→sys0=4 |
| `#ERR,<code>,<msg>\r\n` | 错误 | t5=msg |
| `#MSG,<text>\r\n` | 通用通知 | t5=text |

### 5.4 mode 参数

| mode | 场景 | WS63→ESP32 |
|------|------|-----------|
| 0 | 新注册 | register + item_name + storage_area + quantity + is_overwrite:false |
| 1 | 覆写 | register + item_name + storage_area + quantity + is_overwrite:true |
| 2 | 验证 | register + quantity（不含 item_name） |

---

## 六、Page2 出库完整流程

### 6.1 操作流程

```
进入出库页面 (page2)
  │  sys0=0
  │
  ├─ [b0] @out,start
  │   WS63: 读 scan_table → 过滤已注册 → 取 RSSI 最强
  │   ├─ 找到已注册标签
  │   │   WS63 → 屏: #TAG,0001,扳手,A,50\r\n
  │   │   t0="0001", t3="扳手", t2="A", t1="50", sys0=1
  │   │
  │   └─ 无已注册标签
  │       WS63 → 屏: #ERR,ERR_NO_TAG,未找到标签\r\n
  │
  ├─ 用户输入: t6="5" (出库数量)
  │
  ├─ [b4] @out,capture,0001,5
  │   WS63 → ESP32: {"cmd":"outbound","tag_id":"0x0001","remove_qty":5}
  │   ESP32 返回 asset_info（未初始化硬件）:
  │   {"type":"asset_info","task":"outbound","item_name":"扳手",
  │    "quantity":50,"remove_qty":5,"remaining_qty":45}
  │   WS63 → 屏: #ASSET_INFO,0001,扳手,50,5,45\r\n, sys0=2
  │
  ├─ [b5] @out,photo,front
  │   WS63 → ESP32: {"cmd":"capture","view":"front"}
  │   ESP32: 初始化AI+拍摄+比对+扣减
  │   ├─ is_match=true
  │   │   WS63 → 屏: #DONE,out,success\r\n, sys0=4
  │   └─ is_match=false
  │       WS63 → 屏: #DONE,out,fail\r\n
  │
  ├─ [b7] @out,confirm
  │   WS63: 持久化（ESP32 已完成扣减）
  │   sys0=0
  │
  └─ [b3] @out,cancel → cancel + 清 pending → 返回主页
```

### 6.2 上行帧

| 按钮 | 帧内容 | sys0 条件 | 说明 |
|------|--------|-----------|------|
| b0 | `@out,start\r\n` | 无限制 | 扫描最强已注册标签 |
| b4 | `@out,capture,<id>,<qty>\r\n` | sys0==1 且 t6非空 | 发出库信息 |
| b5 | `@out,photo,front\r\n` | sys0==2 | 拍正面验证 |
| b7 | `@out,confirm\r\n` | sys0==4 | 确认出库 |
| b3 | `@out,cancel\r\n` | 无限制 | 取消 |

### 6.3 下行帧

| 帧内容 | 触发时机 | 屏端行为 |
|--------|---------|---------|
| `#TAG,<id>,<name>,<area>,<total>\r\n` | 扫到已注册标签 | t0/t3/t2/t1显示, sys0=1 |
| `#ASSET_INFO,<id>,<name>,<qty>,<remove>,<remain>\r\n` | ESP32返回asset_info | t7显示确认, sys0=2 |
| `#PROG,<step>,<view>,<score>\r\n` | 拍摄完成 | t4/t5显示, sys0=3 |
| `#DONE,out,<result>\r\n` | 比对+扣减完成 | success/fail, sys0=4 |
| `#ERR,<code>,<msg>\r\n` | 错误 | t5=msg |

---

## 七、Page3 盘点完整流程

### 7.1 全局盘点

```
[b2] @check,global
  │
  ├─ 1. SLE 扫描统计（读 g_scan_table，不连接）
  │     → 附近 BS21E 标签数量 sle_count
  │
  ├─ 2. ESP32 list_assets_page → 获取 TF 卡资产总数
  │     → total_count
  │
  ├─ 3. 比对（tag_id + item_name + quantity）
  │     ├─ WS63 NV 有 + ESP32 TF 有 + SLE 扫到 → ✅ 成功
  │     ├─ WS63 NV 有 + ESP32 TF 有 + SLE 没扫到 → ❌ 未盘点到
  │     └─ WS63 NV 有 + ESP32 TF 没有 → ❌ 数据不匹配
  │
  └─ 4. 返回
      WS63 → 屏: #INV,<sle_count>,<total_count>\r\n
      逐条失败: #MSG,<tag_id> <失败原因>\r\n
```

### 7.2 特定盘点

```
[b0] @check,specific,<id>
  WS63 → ESP32: {"cmd":"get_asset","tag_id":"0x0001"}
  ESP32 → WS63: asset_detail
  WS63 → 屏: #TAG_INFO,<id>,<name>,<area>,<count>\r\n, sys0=1

[b1] @check,capture,<id>
  WS63 → ESP32: {"cmd":"inventory","tag_id":"0x0001"}
  WS63 → 屏: #PROG,1,front,0\r\n, sys0=3

[b4/b5/b6] @check,photo,<view>
  WS63 → ESP32: {"cmd":"capture","view":"<view>"}
  → #PROG

  task_done(inventory):
  confidence ≥ 0.75 → #DONE,check,match,<conf>
  confidence < 0.75 → #DONE,check,mismatch,<conf>
```

### 7.3 上行帧

| 按钮 | 帧内容 | 说明 |
|------|--------|------|
| b2 | `@check,global\r\n` | 全局盘点 |
| b0 | `@check,specific,<id>\r\n` | 查询单个资产 |
| b1 | `@check,capture,<id>\r\n` | 启动AI盘点 |
| b4 | `@check,photo,front\r\n` | 拍正面 |
| b5 | `@check,photo,side\r\n` | 拍侧面 |
| b6 | `@check,photo,top\r\n` | 拍顶部 |
| b3 | `@check,cancel\r\n` | 取消 |

---

## 八、Page4 查找完整流程

### 8.1 获取列表

```
[b4] @find,list,1
  WS63 → ESP32: {"cmd":"list_assets_page","page":1,"page_size":6}
  ESP32 → WS63: asset_list_page
  WS63 → 屏: #LIST,1,25,150\r\n
  WS63 → 屏: #ITEM,0,0001,扳手,A,50\r\n (逐条, 最多6条)
  t0-t5 显示资产条目, t7="第1/25页", t6="资产总数:150"
```

### 8.2 分页

```
[b0] 上一页 → @find,list,<page-1> (sys3>1)
[b1] 下一页 → @find,list,<page+1> (sys3<sys4)
```

### 8.3 多选寻物

```
用户勾选 c0-c5 中的多个标签
[b2] @find,locate,<tag_id>
  │
  ├─ WS63 同时连接最多 8 个 BS21E 标签
  ├─ 发送蜂鸣指令
  ├─ 蜂鸣 5 秒
  ├─ 自动发送停止指令（0x00）
  │
  ├─ 某个标签连接失败 → 其他标签继续蜂鸣
  └─ WS63 → 屏: #LOCATE,found,<tag_id>\r\n 或 #LOCATE,timeout,<tag_id>\r\n
```

### 8.4 停止寻物

```
[b5] @find,stop
  WS63 → 所有已连接标签: 停止蜂鸣
  WS63 → 屏: #MSG,已停止\r\n
```

### 8.5 上行帧

| 按钮 | 帧内容 | 条件 | 说明 |
|------|--------|------|------|
| b4 | `@find,list,<page>\r\n` | 无限制 | 获取第N页 |
| b0 | `@find,list,<page-1>\r\n` | sys3>1 | 上一页 |
| b1 | `@find,list,<page+1>\r\n` | sys3<sys4 | 下一页 |
| b2 | `@find,locate,<tag_id>\r\n` | sys5!=99 | 寻物（多选） |
| b5 | `@find,stop\r\n` | 无限制 | 停止 |
| b3 | `@find,cancel\r\n` | 无限制 | 取消 |

### 8.6 下行帧

| 帧内容 | 触发时机 | 屏端行为 |
|--------|---------|---------|
| `#LIST,<page>,<tp>,<tc>\r\n` | asset_list_page返回 | t7=页码, t6=总数 |
| `#ITEM,<slot>,<id>,<name>,<area>,<count>\r\n` | 逐条 | t[slot]显示 |
| `#LOCATE,found,<id>\r\n` | 标签响应蜂鸣 | b2.txt="已激活" |
| `#LOCATE,timeout,<id>\r\n` | 超时未响应 | t8="未找到" |
| `#ERR,<code>,<msg>\r\n` | 错误 | t8=msg |

---

## 九、Page5 设置

### 9.1 上行帧

| 按钮 | 帧内容 | 说明 |
|------|--------|------|
| b1 | `@setting,wifi,<ssid>,<password>\r\n` | 连接WiFi |
| b4 | `@setting,disconnect\r\n` | 断开WiFi |
| b3 | `@setting,cancel\r\n` | 取消 |

### 9.2 下行帧

| 帧内容 | 触发时机 | 屏端行为 |
|--------|---------|---------|
| `#NET,wifi,<status>,<signal>\r\n` | 网络状态变化 | t5显示 |
| `#WIFI,<result>\r\n` | WiFi连接结果 | ok/fail |
| `#ERR,<code>,<msg>\r\n` | 错误 | t5=msg |

---

## 十、状态机

| sys0 | 含义 | page1 | page2 | page3 | page4 |
|:----:|------|:-----:|:-----:|:-----:|:-----:|
| 0 | 空闲 | b0 | b0 | b0,b2 | b4 |
| 1 | 信息已获取 | b0,b1 | b0,b4 | b0,b1,b2 | b0,b1,b2,b5 |
| 2 | 已发capture | b0 | b0,b5 | b0,b2 | — |
| 3 | 拍摄中 | b0,b4,b5,b6 | b0 | b4,b5,b6 | — |
| 4 | 待确认 | b0,b7 | b0,b7 | b0,b2 | — |
| 5 | 验证模式(仅入库) | b0,b1 | — | — | — |

---

## 十一、ESP32 响应处理映射

| ESP32 响应 | WS63 处理 | WS63→屏 |
|-----------|---------|---------|
| `capture_progress` | 提取step/view/blur_score | `#PROG,<step>,<view>,<score>` |
| `asset_info`(outbound) | 提取出库详情 | `#ASSET_INFO,<id>,<name>,<qty>,<remove>,<remain>` |
| `asset_info`(inventory) | 日志记录 | 不转发屏 |
| `asset_detail` | 提取资产详情 | `#TAG_INFO,<id>,<name>,<area>,<count>` |
| `asset_list_page` | 分页数据 | `#LIST` + `#ITEM`×N |
| `task_done`(register) | 提取result+tag_id | `#DONE,reg,<result>,<id>` |
| `task_done`(outbound) | 检查is_match | `#DONE,out,success/fail` |
| `task_done`(inventory) | 检查confidence | `#DONE,check,match/mismatch,<conf>` |
| `verification_start` | 提取message | `#MSG,<message>` |
| `pong` | 日志记录 | 不转发屏 |
| `error` | 提取code+msg | `#ERR,<code>,<msg>` |

---

## 十二、待实现 P0 功能清单

| # | 功能 | 文件 | 说明 |
|---|------|------|------|
| 1 | `@in,start` SLE扫描+查DB分支 | biz_screen_cmd.c | 未注册→#TAG; 已注册→#FULL; 无标签→#ERR |
| 2 | `@in,capture` 记录pending（不连BS21E） | biz_screen_cmd.c | 记录tag_id+MAC，发register给ESP32 |
| 3 | `@in,confirm` 连接BS21E+BIND | biz_screen_cmd.c | 连接→BIND_TAG→蜂鸣5s→NV+上云 |
| 4 | `@out,start` SLE扫描+查DB分支 | biz_screen_cmd.c | 已注册→#TAG,name,area,total; 无标签→#ERR |
| 5 | `@check,global` SLE+ESP32比对 | biz_screen_cmd.c | SLE计数+list_assets_page→#INV+#MSG |
| 6 | `@find,locate` 多选SLE蜂鸣 | biz_screen_cmd.c | 同时连接最多8标签，蜂鸣5s，自动停止 |
| 7 | `@find,stop` 停止蜂鸣 | biz_screen_cmd.c | 停止所有已连接标签的蜂鸣 |
| 8 | 超时+重试机制 | biz_core.c | SLE 3s/ESP32 5s, 3次重试, 最多6s |
| 9 | `@in,confirm` BS21E不在范围处理 | biz_screen_cmd.c | #ERR → 需从@in,start重来 |

---

**约束**: 严格遵循 CLAUDE.md，不擅自优化未提及的模块。
