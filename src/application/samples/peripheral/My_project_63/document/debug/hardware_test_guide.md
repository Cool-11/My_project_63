# WS63 智能仓储网关 — 硬件测试全流程

> 日期: 2026-05-17
> 测试对象: WS63 网关 + BS21E 标签 + 串口助手(模拟 ESP32)
> 固件版本: dev 分支 (Phase 1-4)

---

## 一、测试环境搭建

### 1.1 硬件准备

| 设备 | 数量 | 说明 |
|------|------|------|
| WS63 开发板 | 1 | 网关，已烧录 dev 分支固件 |
| BS21E 标签 | 1~2 | SLE 电子标签，已烧录 bs2x dev 分支固件 |
| USB-TTL 模块 | 2 | CP2102/CH340 均可 |
| 杜邦线 | 若干 | 连接 UART |

### 1.2 接线方案

```
                    ┌─────────────┐
  USB-TTL #1 (日口) │  WS63 开发板 │
  TX ──────────────►│ UART_RX (日口)│  ← WS63 日志输出 (115200)
  RX ◄──────────────│ UART_TX (日口)│
                    │             │
  USB-TTL #2 (业务口)│             │
  TX ──────────────►│ GPIO16(RX)  │  ← 模拟 ESP32 发送 (115200)
  RX ◄──────────────│ GPIO15(TX)  │  → WS63 发给 ESP32 的数据
                    └─────────────┘
```

**WS63 UART 引脚定义** (来自 `uart_vision.h`):
- 业务口 TX: GPIO15 (WS63 → ESP32/串口助手)
- 业务口 RX: GPIO16 (ESP32/串口助手 → WS63)
- 波特率: 115200, 8N1

**注意**: 日口和业务口是两个不同的 UART。日口看日志，业务口收发 JSON 命令。

### 1.3 串口助手配置

推荐工具: **SSCOM** / **Mobaxterm** / **minicom**

| 参数 | 日口 (UART_LOG) | 业务口 (UART_VISION) |
|------|-----------------|---------------------|
| 波特率 | 115200 | 115200 |
| 数据位 | 8 | 8 |
| 停止位 | 1 | 1 |
| 校验 | None | None |
| 换行符 | - | `\n` 或 `\r\n` |

**SSCOM 设置要点**:
1. 打开两个 SSCOM 窗口，分别连接日口和业务口的 COM 端口
2. 业务口的 SSCOM 中勾选"发送新行"或手动在命令末尾加 `\n`
3. 建议勾选"显示发送时间"方便对照日志

### 1.4 上电顺序

1. 先连接好所有串口
2. 给 WS63 上电
3. 观察日口输出，等待出现: `[WS63_APP] ===== APP ENTRY DONE, entering main loop =====`
4. 等待约 3~5 秒，SLE 开始扫描广播
5. 将 BS21E 上电（放在 WS63 附近，距离 < 2 米）

---

## 二、启动自检 (验证基础链路)

### 2.1 检查 WS63 启动日志

上电后在日口观察以下关键日志（按出现顺序）:

```
[WS63_APP] ===== APP ENTRY START =====
[WS63_APP] shared_protocol_init OK
[WS63_APP] sle_network_init OK
[WS63_APP] uart_vision_init OK
[WS63_APP] cloud_storage_init OK
[WS63_APP] business_logic_init OK
[WS63_APP] ===== APP ENTRY DONE, entering main loop =====
```

**判定**: 全部 OK → PASS; 任一 FAIL → 检查对应模块

### 2.2 检查 SLE 扫描

启动后约 3 秒，日口应出现扫描相关日志:

```
[WS63_NET] sle enabled, starting scan
[WS63_NET] scan started
```

每 30 秒出现心跳日志:
```
[WS63_APP] HB tgt=0/0 ssap=0 scan_tbl=0 wifi=0 mqtt=0 uart=0
```

- `tgt=0/0`: target_found=0, connected=0 (正常，还没发现标签)
- `scan_tbl=0`: 扫描表为空 (正常，还没扫到 BS21E)

### 2.3 检查 BS21E 广播

将 BS21E 上电后，WS63 日口应出现:

```
[WS63_NET] seek found tag_id=1 mac=XX:XX:XX:XX:XX:XX bat=N qty=N status=0x00
```

此时心跳日志变为: `scan_tbl=1`

**判定**: 出现 seek found 日志 → SLE 扫描链路 OK

### 2.4 检查 UART 业务口

在业务口串口助手发送:

```json
{"cmd":"list","seq":1,"data":{}}
```

预期响应:
```json
{"cmd":"list","seq":1,"code":0,"msg":"ok","data":{"count":0,"tags":[]}}
```

**判定**: 收到 JSON 响应 → UART 业务口链路 OK

### 2.5 检查扫描表

在业务口发送:

```json
{"cmd":"scan_list","seq":2,"data":{}}
```

预期响应 (BS21E 已上电时):
```json
{"cmd":"scan_list","seq":2,"code":0,"msg":"ok","data":{"scan_list":[{"tag_id":1,"battery":100,"qty":0,"status":0,"registered":false}]}}
```

**判定**: `scan_list` 中有 BS21E 条目 → 扫描表正常; `registered:false` → 未注册（正确）

---

## 三、入库测试 (inbound)

### 3.1 测试流程

入库流程: WS63 发送 inbound → 查扫描表 → 连接 BS21E → 配对 → SSAP 交换 → 发 BIND_TAG → 收响应 → 回复

**前提**: BS21E 已上电且出现在扫描表中

### 3.2 步骤

**Step 1**: 在业务口发送:

```json
{"cmd":"inbound","seq":10,"data":{"tag_id":1,"zone":"A1","item":"USB-C Cable"}}
```

**Step 2**: 观察日口日志 (按时间顺序):

```
[WS63_BIZ] uart cmd=inbound seq=10
[WS63_BIZ] inbound tag_id=1 zone=A1 item=USB-C Cable
[WS63_BIZ] pending cmd=inbound seq=10 tag_id=1 timeout=5000ms
[WS63_NET] connect_by_tag tag_id=1 mac=XX:XX:XX:XX:XX:XX
[WS63_NET] scan stopped
[WS63_NET] sle connect start
[WS63_NET] conn state changed conn_id=0xXXXX connected=1
[WS63_NET] pair start
[WS63_NET] pair complete
[WS63_NET] ssap exchange info req
[WS63_NET] ssap find structure primary_service
[WS63_NET] ssap service found uuid=0xFF00
[WS63_NET] ssap find structure property
[WS63_NET] ssap property found uuid=0xFF01 handle=0xXXXX
[WS63_NET] ssap write CCCD done
[WS63_NET] ssap ready
[WS63_BIZ] sle bind cmd=0x20 tag_id=1
[WS63_BIZ] sle notify bind cmd=0xA0 tag_id=1
[WS63_BIZ] inbound bind OK tag_id=1
```

**Step 3**: 业务口收到最终响应:

```json
{"cmd":"inbound","seq":10,"code":0,"msg":"ok","data":{"tag_id":1}}
```

**Step 4**: 验证标签已注册:

```json
{"cmd":"list","seq":11,"data":{}}
```

预期:
```json
{"cmd":"list","seq":11,"code":0,"msg":"ok","data":{"count":1,"tags":[{"tag_id":1,"zone":"A1","item":"USB-C Cable","qty":0,"status":2,"battery":100}]}}
```

**判定**:
- PASS: code=0, list 中有该标签, 日志完整
- FAIL: code<0, 检查错误码含义 (见下表)

### 3.3 错误码速查

| code | msg | 含义 | 排查 |
|------|-----|------|------|
| -3 | missing tag_id | 未传 tag_id 字段 | 检查 JSON 格式 |
| -4 | tag_id not in scan | 扫描表中无此 tag_id | 确认 BS21E 已上电，发送 scan_list 确认 |
| -5 | already registered | 该 tag_id 已注册 | 先 outbound 解绑 |
| -6 | busy | 有其他 pending 命令 | 等 5 秒后重试 |
| -7 | map full | 标签映射表满 (32 条) | outbound 释放空间 |
| -8 | connect_by_tag fail | SLE 连接失败 | 检查距离、BS21E 是否在线 |
| -9 | bind send fail | SSAP 发送失败 | SLE 连接可能已断开 |
| -10 | timeout | 5 秒超时 | SLE 配对/SSAP 流程卡住，检查距离 |

---

## 四、注册测试 (register)

### 4.1 测试流程

注册流程比入库多一步 ESP32 交互: SLE bind → 转发 ESP32 → 等 task_done

由于我们用串口助手模拟 ESP32，需要手动发送 task_done 响应。

### 4.2 步骤

**Step 1**: 先确保有未注册的 BS21E 在扫描表中。发送:

```json
{"cmd":"register","seq":20,"data":{"tag_id":2,"storage_area":"B3","item_name":"HDMI Adapter"}}
```

**Step 2**: 观察日口，直到出现:

```
[WS63_BIZ] sle bind cmd=0x20 tag_id=2
[WS63_BIZ] sle notify bind cmd=0xA0 tag_id=2
[WS63_BIZ] register bind OK, forward to esp32
[WS63_BIZ] passthrough cmd=register to esp32
```

**Step 3**: 此时 WS63 通过业务口 TX 发送给 ESP32（串口助手可看到）:

```json
{"cmd":"register","seq":20,"tag_id":2,"item_name":"HDMI Adapter","storage_area":"B3","qty":0}
```

**Step 4**: **在业务口串口助手中模拟 ESP32 回复**:

```json
{"type":"task_done","task":"register","result":"success","tag_id":2}
```

**Step 5**: 业务口收到最终响应:

```json
{"cmd":"register","seq":20,"code":0,"msg":"ok","data":{"type":"task_done","task":"register","result":"success","tag_id":2}}
```

**判定**:
- PASS: 收到 code=0, 日志显示完整链路
- FAIL: 检查是否在 15 秒内发送了 task_done

### 4.3 超时测试

发送 register 后**不发送 task_done**，等待 15 秒:

```
[WS63_BIZ] pending timeout cmd=register seq=XX
```

业务口收到:
```json
{"cmd":"register","seq":XX,"code":-10,"msg":"timeout"}
```

**判定**: 15 秒超时 → PASS; 少于 15 秒超时 → FAIL

---

## 五、出库测试 (outbound)

### 5.1 全量出库 (unbind)

前提: tag_id=1 已注册

```json
{"cmd":"outbound","seq":30,"data":{"tag_id":1}}
```

日口日志:
```
[WS63_BIZ] uart cmd=outbound seq=30
[WS63_BIZ] outbound tag_id=1 full
[WS63_BIZ] pending cmd=outbound seq=30 tag_id=1 timeout=15000ms
[WS63_BIZ] sle unbind cmd=0x21 tag_id=1
[WS63_BIZ] sle notify bind cmd=0xA1 tag_id=1
[WS63_BIZ] outbound unbind OK tag_id=1
```

预期响应:
```json
{"cmd":"outbound","seq":30,"code":0,"msg":"ok","data":{"tag_id":1}}
```

验证:
```json
{"cmd":"list","seq":31,"data":{}}
```
count 应为 0（如果只有一个标签）。

### 5.2 部分出库 (update_qty)

前提: tag_id=1 已注册且 qty=100

```json
{"cmd":"outbound","seq":32,"data":{"tag_id":1,"remove_qty":30}}
```

预期响应:
```json
{"cmd":"outbound","seq":32,"code":0,"msg":"ok","data":{"tag_id":1,"qty":70}}
```

日口日志:
```
[WS63_BIZ] outbound tag_id=1 partial remove_qty=30
[WS63_BIZ] sle update_qty cmd=0x10 tag_id=1 qty=70
```

**判定**: qty 从 100 变为 70 → PASS

### 5.3 通过 MAC 出库

```json
{"cmd":"outbound","seq":33,"data":{"mac":"aa:bb:cc:dd:ee:ff"}}
```

需要用 BS21E 的实际 MAC 地址（从扫描日志中获取）。

---

## 六、寻物测试 (find)

### 6.1 通过 tag_id 寻物

```json
{"cmd":"find","seq":40,"data":{"tag_id":1}}
```

预期:
```json
{"cmd":"find","seq":40,"code":0,"msg":"ok","data":{"tag_id":1,"zone":"A1","item":"USB-C Cable"}}
```

同时 BS21E 标签开始蜂鸣 + 闪灯，持续 15 秒后自动停止。

### 6.2 通过物品名称寻物

```json
{"cmd":"find","seq":41,"data":{"item":"USB-C Cable"}}
```

预期同上。

### 6.3 SLE 直连寻物 (完整链路)

如果标签已注册但当前未连接 SLE:

```json
{"cmd":"find","seq":42,"data":{"tag_id":1}}
```

日口会显示 connect_by_tag → 配对 → SSAP → 发送 FIND (0x01) 的完整链路。

---

## 七、盘点测试 (inventory)

### 7.1 发起盘点

```json
{"cmd":"inventory","seq":50,"data":{}}
```

预期 (标签在线时):
```json
{"cmd":"inventory","seq":50,"code":0,"msg":"ok","data":{"count":1,"tags":[{"tag_id":1,"zone":"A1","item":"USB-C Cable","qty":70,"status":2,"battery":95}]}}
```

日口日志:
```
[WS63_BIZ] inventory → ssap inventory cmd=0x02
[WS63_BIZ] sle notify inv tag_id=1 qty=70 status=0x02 bat=95
```

### 7.2 SLE 不可用时

如果 BS21E 未上电或超出范围:

```json
{"cmd":"inventory","seq":51,"data":{}}
```

预期:
```json
{"cmd":"inventory","seq":51,"code":-1,"msg":"sle not ready"}
```

---

## 八、数量更新测试 (update_qty)

```json
{"cmd":"update_qty","seq":60,"data":{"tag_id":1,"qty":50}}
```

预期:
```json
{"cmd":"update_qty","seq":60,"code":0,"msg":"ok","data":{"tag_id":1,"qty":50}}
```

---

## 九、模拟 ESP32 消息测试

用串口助手在业务口模拟 ESP32 发送各种上行消息。

### 9.1 task_done (无匹配 pending)

```json
{"type":"task_done","task":"register","result":"success"}
```

预期 (无 pending 时): 日口打印 `no pending match`，业务口无输出。

### 9.2 error 消息

```json
{"type":"error","msg":"camera init fail"}
```

预期 (有 pending 时): 业务口收到 code=-1, msg="camera init fail"
预期 (无 pending 时): 日口打印日志，业务口无输出

### 9.3 MQTT 状态转发

```json
{"type":"mqtt_connected","broker":"mqtt.example.com"}
```

预期: 业务口收到:
```json
{"cmd":"mqtt_connected","seq":0,"code":0,"msg":"ok","data":{"type":"mqtt_connected","broker":"mqtt.example.com"}}
```

### 9.4 L610 状态转发

```json
{"type":"l610_at_result","result":"+CEREG: 0,1"}
```

预期: 业务口收到转发

---

## 十、WiFi/MQTT 测试

### 10.1 WiFi 连接

```json
{"cmd":"wifi_connect","seq":70,"data":{"ssid":"YourSSID","psk":"YourPassword"}}
```

预期:
```json
{"cmd":"wifi_connect","seq":70,"code":0,"msg":"connecting"}
```

日口观察 WiFi 连接结果。连接成功后心跳日志 `wifi=1`。

### 10.2 WiFi 状态查询

```json
{"cmd":"wifi_status","seq":71,"data":{}}
```

预期:
```json
{"cmd":"wifi_status","seq":71,"code":0,"msg":"ok","data":{"wifi_state":1}}
```

### 10.3 MQTT 连接

```json
{"cmd":"mqtt_connect","seq":72,"data":{"host":"mqtt.thingsboard.io","port":1883,"client_id":"ws63_gw_01"}}
```

预期:
```json
{"cmd":"mqtt_connect","seq":72,"code":0,"msg":"ok"}
```

---

## 十一、完整注册+出库全流程测试

这是一个端到端的完整业务流程测试。

### 测试步骤

| # | 操作 | 发送命令 | 预期结果 |
|---|------|---------|---------|
| 1 | 查看扫描表 | `{"cmd":"scan_list","seq":100,"data":{}}` | scan_list 中有 BS21E，registered=false |
| 2 | 注册标签 | `{"cmd":"register","seq":101,"data":{"tag_id":1,"storage_area":"A1","item_name":"Test Item"}}` | SSAP bind OK 后，WS63 通过 TX 发送 register 给 ESP32 |
| 3 | 模拟 ESP32 回复 | `{"type":"task_done","task":"register","result":"success","tag_id":1}` | 收到 code=0 |
| 4 | 确认注册 | `{"cmd":"list","seq":102,"data":{}}` | count=1, 有 tag_id=1 |
| 5 | 盘点 | `{"cmd":"inventory","seq":103,"data":{}}` | 返回标签最新状态 |
| 6 | 寻物 | `{"cmd":"find","seq":104,"data":{"tag_id":1}}` | BS21E 蜂鸣+闪灯 |
| 7 | 部分出库 | `{"cmd":"outbound","seq":105,"data":{"tag_id":1,"remove_qty":10}}` | qty 减少 |
| 8 | 全量出库 | `{"cmd":"outbound","seq":106,"data":{"tag_id":1}}` | 标签从映射表移除 |
| 9 | 确认移除 | `{"cmd":"list","seq":107,"data":{}}` | count=0 |

### 日志检查点

全流程中日口应出现的关键日志序列:

```
[WS63_BIZ] uart cmd=register seq=101
[WS63_NET] connect_by_tag tag_id=1
[WS63_NET] conn state changed connected=1
[WS63_NET] pair complete
[WS63_NET] ssap ready
[WS63_BIZ] sle bind cmd=0x20 tag_id=1
[WS63_BIZ] sle notify bind cmd=0xA0 tag_id=1
[WS63_BIZ] register bind OK, forward to esp32
[WS63_BIZ] passthrough cmd=register to esp32
[WS63_BIZ] esp32 task_done task=register matched pending=inbound
[WS63_BIZ] uart cmd=outbound seq=106
[WS63_BIZ] sle unbind cmd=0x21 tag_id=1
[WS63_BIZ] sle notify bind cmd=0xA1 tag_id=1
[WS63_BIZ] outbound unbind OK tag_id=1
```

---

## 十二、异常场景测试

### 12.1 BS21E 未上电时入库

```json
{"cmd":"inbound","seq":200,"data":{"tag_id":99,"zone":"A1","item":"Ghost"}}
```

预期: `code=-4, msg="tag_id not in scan"`

### 12.2 重复注册

先注册 tag_id=1，再发一次:

```json
{"cmd":"register","seq":201,"data":{"tag_id":1,"storage_area":"A1","item_name":"Dup"}}
```

预期: `code=-5, msg="already registered"`

### 12.3 有 pending 时发新命令

发送 inventory 后立即发 inbound (不等 inventory 完成):

```json
{"cmd":"inventory","seq":202,"data":{}}
{"cmd":"inbound","seq":203,"data":{"tag_id":1,"zone":"A1","item":"Test"}}
```

预期: inbound 收到 `code=-6, msg="busy"`

### 12.4 无效 JSON

```
{broken json
```

预期: 日口打印 `json parse fail`，业务口无响应或收到 code=-2

### 12.5 未知命令

```json
{"cmd":"nonexistent","seq":204,"data":{}}
```

预期: `code=-99, msg="unknown cmd"`

### 12.6 BS21E 超出范围后重连

1. 注册标签成功
2. 将 BS21E 移到远处（> 10 米）或断电
3. 等待 30 秒（扫描表超时）
4. 发送 inventory → 超时
5. 将 BS21E 拿回/上电
6. 等待扫描表重新出现
7. 再次 inventory → 成功

---

## 十三、BS21E 侧 UART 自测 (独立测试)

BS21E 也有一个 UART 自测接口，可独立验证标签功能。

### 13.1 接线

BS21E UART 引脚: TX=GPIO26, RX=GPIO27, 115200, 8N1

### 13.2 命令表 (HEX 模式)

| 发送 (HEX) | 功能 | 预期回复 |
|------------|------|---------|
| `01` | 寻物 (FIND_ME) | 蜂鸣器响 15 秒 |
| `00` | 停止寻物 (STOP_FIND) | 蜂鸣器停 |
| `02` | 盘点 (INVENTORY) | 日志打印 tag/qty/status/bat |
| `10 00 32` | 更新数量 (UPDATE_QTY qty=50) | 日志打印 qty 更新 |
| `20 00 05` | 绑定标签 (BIND_TAG tag_id=5) | 日志打印 bind done |
| `21` | 解绑标签 (UNBIND_TAG) | 日志打印 unbind done |

### 13.3 BS21E 日志示例

```
[BS2x_APP] ===== APP ENTRY START =====
[BS2x_APP] pm_init done
[BS2x_APP] hardware_hal_init OK
[BS2x_APP] sle_slave_init OK
[BS2x_APP] storage_sync_init OK
[BS2x_APP] ===== APP ENTRY DONE, entering main loop =====
[BS2x_APP][UART_TEST] init OK
[BS2x_APP][UART_TEST] 命令表(HEX模式发送):
[BS2x_APP][UART_TEST]   01       = 寻物(FIND_ME)
[BS2x_APP][UART_TEST]   00       = 停止寻物(STOP_FIND)
[BS2x_APP][UART_TEST]   02       = 盘点(INVENTORY)
[BS2x_APP][UART_TEST]   10 XX XX = 更新数量(UPDATE_QTY)
[BS2x_APP][UART_TEST]   20 XX XX = 绑定标签(BIND_TAG)
[BS2x_APP][UART_TEST]   21       = 解绑标签(UNBIND_TAG)
```

---

## 十四、测试检查表

| 测试项 | 用例 | 通过 | 备注 |
|--------|------|------|------|
| **启动自检** | | | |
| WS63 启动日志 | 2.1 | | |
| SLE 扫描启动 | 2.2 | | |
| BS21E 广播发现 | 2.3 | | |
| UART 业务口连通 | 2.4 | | |
| 扫描表数据 | 2.5 | | |
| **入库** | | | |
| 正常入库 | 3.2 | | |
| 重复入库拒绝 | 12.2 | | |
| BS21E 不在线 | 12.1 | | |
| **注册** | | | |
| 正常注册 (含 ESP32 模拟) | 4.2 | | |
| 注册超时 | 4.3 | | |
| **出库** | | | |
| 全量出库 | 5.1 | | |
| 部分出库 | 5.2 | | |
| MAC 出库 | 5.3 | | |
| **寻物** | | | |
| tag_id 寻物 | 6.1 | | |
| 名称寻物 | 6.2 | | |
| **盘点** | | | |
| 正常盘点 | 7.1 | | |
| SLE 不可用 | 7.2 | | |
| **ESP32 模拟** | | | |
| task_done 处理 | 9.1 | | |
| error 处理 | 9.2 | | |
| MQTT 状态转发 | 9.3 | | |
| **异常** | | | |
| 无效 JSON | 12.4 | | |
| 未知命令 | 12.5 | | |
| pending 冲突 | 12.3 | | |
| **端到端** | | | |
| 完整注册+出库流程 | 11 | | |

---

## 十五、常见问题排查

### Q: WS63 扫不到 BS21E

1. 确认 BS21E 已上电，日志中有 `sle_slave_init OK`
2. 确认距离 < 2 米
3. 检查 BS21E 的 SLE 地址是否已随机化（首次上电会生成新 MAC）
4. 在 WS63 日口查看心跳中 `scan_tbl` 值

### Q: 入库/注册超时

1. 检查 SLE 连接是否成功（日口 `connected=1`）
2. 检查配对是否成功（`pair complete`）
3. 检查 SSAP 交换是否完成（`ssap ready`）
4. 如果卡在某一步，可能是连接参数不匹配

### Q: register 流程中 ESP32 task_done 不匹配

1. 确认 task_done 的 `task` 字段值是 `"register"`
2. 确认在 15 秒内发送
3. 确认 pending 状态为 `"inbound"`（bind 成功后会从 register 改为 inbound）

### Q: 串口助手收不到 JSON 响应

1. 确认连接的是业务口（GPIO15/16），不是日口
2. 确认发送的 JSON 以 `\n` 结尾
3. 确认波特率 115200, 8N1
4. 尝试发送 `{"cmd":"list","seq":1,"data":{}}` 测试连通性

### Q: NV 数据断电丢失

NV 存储在 flash 中，断电不丢失。如果数据丢失：
1. 检查 NV key 是否冲突 (0x5001)
2. 检查日志中是否有 `nv read fail`
3. 可能是 NV 区域被擦除（重新烧录固件时）
