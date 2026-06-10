# WS63 硬件测试流程表

> 日期: 2026-05-17
> 测试环境: WS63 + BS21E + 串口助手(模拟ESP32)
> 串口工具: SSCOM x2（日口 + 业务口）

---

## 串口配置

| | 日口 (UART_LOG) | 业务口 (UART_VISION) |
|---|---|---|
| 用途 | 看 WS63 运行日志 | 发送/接收 JSON 命令 |
| 波特率 | 115200 8N1 | 115200 8N1 |
| WS63 引脚 | 板载 UART | TX=GPIO15, RX=GPIO16 |
| 操作 | 只看不发 | 发命令 + 模拟 ESP32 回复 |

---

## 测试一：BS21E 端 — SLE 基础链路

### T1.1 启动扫描

| # | 操作 | 发送到 | 预期日志 (日口) |
|---|------|--------|----------------|
| 1 | WS63 上电 | - | `[WS63_APP] ===== APP ENTRY DONE` |
| 2 | 等 3~5 秒 | - | `[WS63_NET] scan started` |
| 3 | BS21E 上电（放旁边 <2m） | - | `[WS63_NET] seek found tag_id=X mac=XX:XX:XX:XX:XX:XX` |
| 4 | 发 scan_list | 业务口 | 看响应中是否有 BS21E |

**业务口发送:**
```json
{"cmd":"scan_list","seq":1,"data":{}}
```

**预期响应:**
```json
{"cmd":"scan_list","seq":1,"code":0,"msg":"ok","data":{"scan_list":[{"tag_id":X,"battery":100,"qty":0,"status":0,"registered":false}]}}
```

**判定:** tag_id 出现在 scan_list → PASS; 没有 → BS21E 未上电或距离太远

---

### T1.2 入库 (inbound) — SLE 连接 + 绑定

| # | 操作 | 发送到 | 预期日志 (日口) |
|---|------|--------|----------------|
| 1 | 发 inbound | 业务口 | `[WS63_BIZ] uart cmd=inbound` |
| 2 | 等待连接 | - | `[WS63_NET] connect_by_tag tag_id=X` |
| 3 | 等待配对 | - | `[WS63_NET] conn state changed connected=1` |
| 4 | 等待 SSAP | - | `[WS63_NET] pair complete` → `ssap ready` |
| 5 | 等待 bind | - | `[WS63_BIZ] sle bind cmd=0x20 tag_id=X` |
| 6 | 等待响应 | - | `[WS63_BIZ] sle notify bind cmd=0xA0 tag_id=X` |

**业务口发送:**
```json
{"cmd":"inbound","seq":10,"data":{"tag_id":<从scan_list获取>,"zone":"A1","item":"USB-C Cable"}}
```

**预期响应:**
```json
{"cmd":"inbound","seq":10,"code":0,"msg":"ok","data":{"tag_id":<N>}}
```

**判定:**
- PASS: code=0, 日志有 `cmd=0xA0`
- FAIL code=-4: 扫描表中无此 tag_id → 等几秒重试
- FAIL code=-5: 已注册 → 先 outbound
- FAIL code=-6: 有 pending → 等 5 秒
- FAIL code=-8: connect_by_tag 失败 → 检查距离
- FAIL code=-10: 超时 → SLE 流程卡住，看日志卡在哪一步

---

### T1.3 解绑 (outbound) — 全量出库

| # | 操作 | 发送到 | 预期日志 (日口) |
|---|------|--------|----------------|
| 1 | 发 outbound | 业务口 | `[WS63_BIZ] uart cmd=outbound` |
| 2 | 等待 unbind | - | `[WS63_BIZ] sle unbind cmd=0x21 tag_id=X` |
| 3 | 等待响应 | - | `[WS63_BIZ] sle notify bind cmd=0xA1 tag_id=X` |

**业务口发送:**
```json
{"cmd":"outbound","seq":11,"data":{"tag_id":<同上>}}
```

**预期响应:**
```json
{"cmd":"outbound","seq":11,"code":0,"msg":"ok","data":{"tag_id":<N>}}
```

**判定:**
- PASS: code=0, 日志有 `cmd=0xA1`
- FAIL code=-3: tag_id 不在映射表中
- FAIL code=-5: 解绑失败 (0xAF)

---

### T1.4 重新入库 — 解绑后重绑

| # | 操作 | 说明 |
|---|------|------|
| 1 | 等 BS21E 重新广播 | 解绑后 BS21E tag_id=0，等待 scan_list 出现 |
| 2 | 发 inbound | 与 T1.2 相同 |

**业务口发送:**
```json
{"cmd":"scan_list","seq":12,"data":{}}
```
确认 BS21E 仍在扫描表中。

```json
{"cmd":"inbound","seq":13,"data":{"tag_id":<N>,"zone":"A1","item":"Re-bind Test"}}
```

**判定:** 同 T1.2

---

### T1.5 部分出库 — update_qty

| # | 操作 | 说明 |
|---|------|------|
| 1 | 先入库 | 确保有已注册标签 |
| 2 | 发 outbound + remove_qty | 测试部分出库 |

**业务口发送:**
```json
{"cmd":"outbound","seq":14,"data":{"tag_id":<N>,"remove_qty":5}}
```

**预期响应:**
```json
{"cmd":"outbound","seq":14,"code":0,"msg":"ok","data":{"tag_id":<N>,"qty":<剩余>}}
```

**判定:** qty 正确减少 → PASS

---

### T1.6 寻物 — find

**业务口发送:**
```json
{"cmd":"find","seq":15,"data":{"tag_id":<N>}}
```

**预期:** BS21E 蜂鸣器响 + LED 闪，15 秒后自动停

**预期响应:**
```json
{"cmd":"find","seq":15,"code":0,"msg":"ok","data":{"tag_id":<N>,"zone":"A1","item":"USB-C Cable"}}
```

---

### T1.7 盘点 — inventory

**业务口发送:**
```json
{"cmd":"inventory","seq":16,"data":{}}
```

**预期响应:**
```json
{"cmd":"inventory","seq":16,"code":0,"msg":"ok","data":{"count":1,"tags":[{"tag_id":<N>,"zone":"A1","item":"USB-C Cable","qty":0,"status":2,"battery":100}]}}
```

---

### T1.8 列表 — list

**业务口发送:**
```json
{"cmd":"list","seq":17,"data":{}}
```

**预期:** 返回所有已注册标签

---

## 测试二：ESP32 端 — 模拟注册流程

> 用串口助手连接业务口，模拟 ESP32 收发

### T2.1 注册完整流程 (register)

| # | 操作 | 谁发 | 发什么 |
|---|------|------|--------|
| 1 | 发 register 命令 | 串口助手→WS63 | `{"cmd":"register","seq":20,"data":{"tag_id":<N>,"storage_area":"B3","item_name":"HDMI Adapter"}}` |
| 2 | 等 WS63 完成 SLE bind | - | 日口出现 `register bind OK, forward to esp32` |
| 3 | WS63 发给 ESP32 | WS63→串口助手 | 业务口 TX 收到: `{"cmd":"register","tag_id":<N>,"item_name":"HDMI Adapter","storage_area":"B3","qty":0}` |
| 4 | 模拟 ESP32 回复 | 串口助手→WS63 | `{"type":"task_done","task":"register","result":"success","tag_id":<N>}` |
| 5 | 收最终响应 | WS63→串口助手 | `{"cmd":"register","seq":20,"code":0,"msg":"ok","data":{...}}` |

**关键:** 步骤 3 和 4 之间不能超过 15 秒，否则超时。

**判定:**
- PASS: 步骤 5 收到 code=0
- FAIL: 超时 → 步骤 4 发太慢
- FAIL: code=-10 → 没收到步骤 3 的 TX 数据或步骤 4 发错了

---

### T2.2 注册超时测试

| # | 操作 | 说明 |
|---|------|------|
| 1 | 发 register | 同 T2.1 步骤 1 |
| 2 | 等 WS63 bind 成功 | 日口出现 `forward to esp32` |
| 3 | **不回复 task_done** | 等 15 秒 |
| 4 | 观察超时 | 业务口收到 code=-10, msg="timeout" |

**判定:** 15 秒超时 → PASS; 少于 15 秒 → FAIL

---

### T2.3 注册失败 — BS21E 拒绝 bind

| # | 操作 | 说明 |
|---|------|------|
| 1 | 确保 BS21E 已绑定 | 先做一次成功的 inbound |
| 2 | 不解绑，直接 register 同 tag_id | BS21E 会拒绝 (0xAF) |

**业务口发送:**
```json
{"cmd":"register","seq":21,"data":{"tag_id":<已绑定的N>,"storage_area":"A1","item_name":"Dup"}}
```

**预期响应:**
```json
{"cmd":"register","seq":21,"code":-5,"msg":"bind failed"}
```

**判定:** code=-5 → PASS; BS21E 正确拒绝了重复绑定

---

### T2.4 模拟 ESP32 error

| # | 操作 | 说明 |
|---|------|------|
| 1 | 发 register | 启动注册流程 |
| 2 | 等 bind 成功 | 日口出现 `forward to esp32` |
| 3 | 模拟 ESP32 报错 | 发: `{"type":"error","msg":"camera fail"}` |

**串口助手发送 (模拟 ESP32):**
```json
{"type":"error","msg":"camera fail"}
```

**预期响应:**
```json
{"cmd":"register","seq":<N>,"code":-1,"msg":"camera fail"}
```

**判定:** 错误消息正确转发 → PASS

---

### T2.5 模拟 ESP32 状态消息

无 pending 时发送，不应影响系统:

**串口助手发送:**
```json
{"type":"mqtt_connected","broker":"mqtt.example.com"}
```

**预期响应:**
```json
{"cmd":"mqtt_connected","seq":0,"code":0,"msg":"ok","data":{"type":"mqtt_connected","broker":"mqtt.example.com"}}
```

**串口助手发送:**
```json
{"type":"l610_at_result","result":"+CEREG: 0,1"}
```

**预期:** 转发到业务口

---

## 测试三：异常场景

### T3.1 无效 JSON

**串口助手发送:**
```
{broken json
```

**预期:** 日口 `json parse fail`，业务口无响应或 code=-2

---

### T3.2 未知命令

```json
{"cmd":"nonexistent","seq":99,"data":{}}
```

**预期:** `code=-99, msg="unknown cmd"`

---

### T3.3 BS21E 不在线时入库

```json
{"cmd":"inbound","seq":98,"data":{"tag_id":99,"zone":"A1","item":"Ghost"}}
```

**预期:** `code=-4, msg="tag_id not found in scan table"`

---

### T3.4 pending 冲突

```json
{"cmd":"inventory","seq":30,"data":{}}
```
立即再发:
```json
{"cmd":"inbound","seq":31,"data":{"tag_id":<N>,"zone":"A1","item":"Test"}}
```

**预期:** inbound 收到 `code=-6, msg="busy, pending active"`

---

## 测试四：WiFi + MQTT + 上云

### T4.1 连接 WiFi

**业务口发送:**
```json
{"cmd":"wifi_connect","seq":50,"data":{"ssid":"YourSSID","psk":"YourPassword"}}
```

**预期响应:**
```json
{"cmd":"wifi_connect","seq":50,"code":0,"msg":"connecting"}
```

**日口观察:**
```
[WS63_CLOUD] wifi connecting ssid=YourSSID
[WS63_CLOUD] wifi got ip x.x.x.x
```

**验证:**
```json
{"cmd":"wifi_status","seq":51,"data":{}}
```
预期: `wifi_state=1` (已连接)

**判定:** wifi_state=1 → PASS; wifi_state=0 → SSID/密码错误或信号弱

---

### T4.2 连接 MQTT

WiFi 连接成功后:

**业务口发送:**
```json
{"cmd":"mqtt_connect","seq":52,"data":{"host":"mqtt.thingsboard.io","port":1883,"client_id":"ws63_gw_01","username":"your_token","password":""}}
```

**预期响应:**
```json
{"cmd":"mqtt_connect","seq":52,"code":0,"msg":"ok"}
```

**日口观察:**
```
[WS63_CLOUD] mqtt connecting uri=tcp://mqtt.thingsboard.io:1883
[WS63_CLOUD] mqtt connected
```

**验证:**
```json
{"cmd":"mqtt_status","seq":53,"data":{}}
```
预期: `mqtt_state=1` (已连接)

**判定:** mqtt_state=1 → PASS

---

### T4.3 入库自动上云

WiFi + MQTT 都连接后，执行入库:

```json
{"cmd":"inbound","seq":54,"data":{"tag_id":<N>,"zone":"A1","item":"USB-C Cable"}}
```

**日口观察:**
```
[WS63_BIZ] inbound bind OK tag_id=<N>
[WS63_BIZ] cloud publish: {"tag_update":{"tag_id":<N>,"zone":"A1","item":"USB-C Cable","qty":0,"status":2,"battery":100}}
[WS63_CLOUD] mqtt publish OK topic=v1/devices/me/telemetry
```

**判定:** 日口出现 `mqtt publish OK` → 自动上云成功

---

### T4.4 出库自动上云

```json
{"cmd":"outbound","seq":55,"data":{"tag_id":<N>}}
```

**日口观察:**
```
[WS63_BIZ] outbound unbind OK tag_id=<N>
[WS63_BIZ] cloud publish: {"tag_update":{"tag_id":<N>,...}}
```

**判定:** 出库后自动发布 tag_update → PASS

---

### T4.5 MQTT 手动发布

```json
{"cmd":"mqtt_publish","seq":56,"data":{"payload":{"test_key":"test_value","ts":12345}}}
```

**预期响应:**
```json
{"cmd":"mqtt_publish","seq":56,"code":0,"msg":"ok"}
```

**日口:** `mqtt publish OK`

**判定:** 自定义 payload 发布成功 → PASS

---

### T4.6 NV 持久化 — 重启自动重连

| # | 操作 | 说明 |
|---|------|------|
| 1 | 确认 WiFi+MQTT 已连接 | wifi_status=1, mqtt_status=1 |
| 2 | 重启 WS63 | 断电重上电 |
| 3 | 等 5~10 秒 | WiFi 自动连接 (从 NV 读取) |
| 4 | 观察日口 | `wifi cfg loaded from nv ssid=...` → `wifi got ip` → `mqtt connected` |
| 5 | 验证 | wifi_status=1, mqtt_status=1 |

**判定:** 重启后自动恢复 WiFi+MQTT → PASS

---

### T4.7 WiFi 断开重连

| # | 操作 | 说明 |
|---|------|------|
| 1 | WiFi+MQTT 已连接 | 确认状态 |
| 2 | 关闭路由器/热点 | WiFi 断开 |
| 3 | 等 10 秒 | 日口出现 WiFi 断开日志 |
| 4 | 重新开启路由器 | WiFi 自动重连 |
| 5 | 观察日口 | `wifi got ip` → `mqtt connected` (自动重连 MQTT) |

**判定:** WiFi 恢复后 MQTT 自动重连 → PASS

---

## 测试五：端到端完整流程（含上云）

| 步骤 | 命令 | 预期 |
|------|------|------|
| 1 | `wifi_connect` | code=0, wifi_state=1 |
| 2 | `mqtt_connect` | code=0, mqtt_state=1 |
| 3 | `scan_list` | BS21E 在表中 |
| 4 | `inbound(tag_id=N, zone=A1, item=Test)` | code=0, 日口出现 mqtt publish OK |
| 5 | `list` | count=1 |
| 6 | `find(tag_id=N)` | BS21E 蜂鸣 |
| 7 | `inventory` | 返回标签状态 |
| 8 | `outbound(tag_id=N)` | code=0, 日口出现 mqtt publish OK |
| 9 | `list` | count=0 |
| 10 | 重启 WS63 | |
| 11 | 等 10 秒 | WiFi+MQTT 自动重连 |
| 12 | `register(tag_id=N, ...)` | SLE bind → 转发 ESP32 |
| 13 | 模拟 ESP32 task_done | code=0, 日口出现 mqtt publish OK |
| 14 | `list` | count=1, NV 持久化确认 |

---

## 测试六：WiFi/MQTT 异常

### T6.1 WiFi 密码错误

```json
{"cmd":"wifi_connect","seq":60,"data":{"ssid":"YourSSID","psk":"wrong_password"}}
```

**预期:** code=0 (立即返回)，但日口出现连接失败日志，wifi_status=0

---

### T6.2 MQTT 无 WiFi 时连接

WiFi 未连接时:

```json
{"cmd":"mqtt_connect","seq":61,"data":{"host":"mqtt.example.com","port":1883}}
```

**预期:** code=-5 或日口连接失败

---

### T6.3 MQTT 参数缺失

```json
{"cmd":"mqtt_connect","seq":62,"data":{"client_id":"test"}}
```

**预期:** `code=-2, msg="missing uri/host"`

---

## 日志关键字速查

| 关键字 | 含义 |
|--------|------|
| `seek found` | 扫描到 BS21E 广播 |
| `connect_by_tag` | 开始连接指定标签 |
| `connected=1` | SLE 连接成功 |
| `pair complete` | 配对完成 |
| `ssap ready` | SSAP 交换完成，可以发命令 |
| `sle bind cmd=0x20` | 发送 BIND_TAG |
| `sle unbind cmd=0x21` | 发送 UNBIND_TAG |
| `notify bind cmd=0xA0` | 收到 bind 成功 |
| `notify bind cmd=0xA1` | 收到 unbind 成功 |
| `notify bind cmd=0xAF` | 收到 bind/unbind 失败 |
| `forward to esp32` | register 流程转发 ESP32 |
| `esp32 task_done` | 收到 ESP32 回复 |
| `pending timeout` | 等待超时 |
| `bind failed` | BS21E 拒绝绑定 |
| `unbind send fail` | 解绑命令发送失败 |
| `wifi got ip` | WiFi 获取到 IP |
| `mqtt connected` | MQTT 连接成功 |
| `mqtt publish OK` | MQTT 发布成功 |
| `wifi cfg loaded from nv` | WiFi 配置从 NV 恢复 |
| `mqtt cfg loaded from nv` | MQTT 配置从 NV 恢复 |
| `cloud publish` | 自动上云 tag_update |

| 关键字 | 含义 |
|--------|------|
| `seek found` | 扫描到 BS21E 广播 |
| `connect_by_tag` | 开始连接指定标签 |
| `connected=1` | SLE 连接成功 |
| `pair complete` | 配对完成 |
| `ssap ready` | SSAP 交换完成，可以发命令 |
| `sle bind cmd=0x20` | 发送 BIND_TAG |
| `sle unbind cmd=0x21` | 发送 UNBIND_TAG |
| `notify bind cmd=0xA0` | 收到 bind 成功 |
| `notify bind cmd=0xA1` | 收到 unbind 成功 |
| `notify bind cmd=0xAF` | 收到 bind/unbind 失败 |
| `forward to esp32` | register 流程转发 ESP32 |
| `esp32 task_done` | 收到 ESP32 回复 |
| `pending timeout` | 等待超时 |
| `bind failed` | BS21E 拒绝绑定 |
| `unbind send fail` | 解绑命令发送失败 |
