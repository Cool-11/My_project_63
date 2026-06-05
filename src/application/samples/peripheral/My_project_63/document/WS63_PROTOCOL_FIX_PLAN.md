# WS63 端协议对齐修复计划

## 问题诊断

**现象**：WS63 通过 UART 向 ESP32 发送命令，ESP32 无响应（无法解析命令）。

**根因**：WS63 端使用 `uart_vision_send_json()` 发送命令时，JSON 被包裹在 WS63 内部信封格式中，与 ESP32 期望的扁平格式不匹配。

### 当前 WS63 发送格式（信封格式，ESP32 无法解析）

```json
{"cmd":"register","seq":1,"code":0,"msg":"","data":{"tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50}}
```

- `cmd` / `seq` / `code` / `msg` 是 WS63 内部协议字段
- 业务参数被嵌套在 `data` 子对象中
- ESP32 在顶层查找 `tag_id`、`item_name` 等字段 → 全部为 NULL → 返回参数缺失错误

### ESP32 期望格式（扁平格式）

```json
{"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50}
```

参数直接放在顶层，ESP32 可以直接通过 `cJSON_GetObjectItem(root, "tag_id")` 获取。

---

## 修复方案

**原则**：WS63 作为客户端适配 ESP32 服务端的协议格式。ESP32 端不做兼容（保持代码简洁）。

**改动范围**：仅修改 WS63 应用层中向 ESP32 发送命令的代码。不修改 `uart_vision.c` / `uart_vision.h` 基础库。

**方法**：所有发给 ESP32 的命令，改用 `uart_vision_send_raw_json()` 直接发送 JSON 字符串（扁平格式），不再使用 `uart_vision_send_json()` 包裹信封。

---

## 具体改动

### 改动前（伪代码示例）

```c
// WS63 应用层某处发送 register 命令
uart_vision_send_json(seq, "register", 0, "ok",
    "{\"tag_id\":\"0x0001\",\"item_name\":\"扳手\",\"storage_area\":\"A\",\"quantity\":50}");
// ↑ 实际发出：{"cmd":"register","seq":1,"code":0,"msg":"ok","data":{...}}
// ↑ ESP32 收到后找不到 tag_id，解析失败
```

### 改动后

```c
// 直接发送扁平 JSON（ESP32 原生格式）
uart_vision_send_raw_json(
    "{\"cmd\":\"register\",\"tag_id\":\"0x0001\",\"item_name\":\"扳手\",\"storage_area\":\"A\",\"quantity\":50}");
// ↑ 实际发出：{"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50}
// ↑ ESP32 收到后正确解析所有字段
```

### 所有 ESP32 命令的扁平格式参考

```c
// ===== 业务命令 =====

// 注册
{"cmd":"register","tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50}

// 盘点（仅传 tag_id，后续 capture 单独发）
{"cmd":"inventory","tag_id":"0x0001"}

// 出库
{"cmd":"outbound","tag_id":"0x0001","remove_qty":5}

// 拍摄（分为三次发送：正面、侧面、顶部）
{"cmd":"capture","view":"front"}
{"cmd":"capture","view":"side"}
{"cmd":"capture","view":"top"}

// 删除
{"cmd":"delete","tag_id":"0x0001"}

// 取消当前任务
{"cmd":"cancel"}

// ===== 查询命令 =====

// 心跳
{"cmd":"ping"}

// 系统信息
{"cmd":"sys_info"}

// 资产列表（分页）
{"cmd":"list_assets_page","page":1,"page_size":6}

// 查询单个资产
{"cmd":"get_asset","tag_id":"0x0001"}

// ===== L610 4G 命令（透传给 l610_driver）=====

// MQTT 连接
{"cmd":"mqtt_connect","host":"mqtt.example.com","port":1883,"clean_session":1,"keepalive":60}

// MQTT 断开
{"cmd":"mqtt_disconnect"}

// MQTT 发布
{"cmd":"mqtt_publish","topic":"/device/data","payload":"{\"key\":\"value\"}","qos":1,"retain":0}

// 查询 L610 状态
{"cmd":"l610_status"}

// 发送 AT 指令
{"cmd":"l610_at","at":"AT+CSQ"}

// MQTT 连接检查
{"cmd":"l610_mqtt_check"}
```

---

## ESP32 响应格式

ESP32 返回的 JSON 均以 `type` 字段标识消息类型。WS63 端的 `uv_dispatch_line()` 已正确处理此格式（通过 `type` 字段识别 ESP32 消息）。

### 响应类型

```json
// 心跳响应
{"type":"pong","camera_ready":true,"storage_ready":true}

// 拍摄进度
{"type":"capture_progress","tag_id":"0x0001","view":"front","step":"1/3","status":"ok","blur_score":87.3}

// 硬件就绪
{"type":"capture_progress","tag_id":"0x0001","view":"none","step":"0/3","status":"ready"}

// 任务完成
{"type":"task_done","task":"register","tag_id":"0x0001","result":"success","item_name":"扳手","quantity":50}
{"type":"task_done","task":"inventory","tag_id":"0x0001","result":"success","item_name":"扳手","quantity":50,"is_match":true,"confidence":0.92,"threshold":0.75}
{"type":"task_done","task":"outbound","tag_id":"0x0001","result":"success","item_name":"扳手","quantity":45,"original_qty":50,"remove_qty":5,"remaining_qty":45,"is_match":true,"confidence":0.88,"threshold":0.75}

// 资产列表（分页响应 - 需要 ESP32 端补充实现，当前通过 CLI text 输出）
// TODO: 后续版本补充 JSON 格式的 asset_list_page 响应

// 错误
{"type":"error","code":"ERR_GENERIC","msg":"Camera init failed"}

// 任务取消
{"type":"task_cancelled","result":"ok"}

// L610 MQTT 连接结果
{"type":"mqtt_connected","state":"connected","host":"mqtt.example.com","port":1883}

// L610 MQTT 发布结果
{"type":"mqtt_publish_done","result":"success","topic":"/device/data"}

// L610 状态
{"type":"l610_status","mqtt_state":"connected","signal_quality":25}

// L610 AT 结果
{"type":"l610_at_result","cmd":"AT+CSQ","result":"ok","response":"+CSQ: 25,0"}

// L610 MQTT 检查
{"type":"l610_mqtt_check_result","connected":true,"mqtt_state":"connected"}
```

---

## 工作流程示意

以注册流程为例：

```
WS63                                ESP32
  |                                    |
  |-- {"cmd":"register",...} -------->|  1. WS63 发送注册命令（扁平 JSON）
  |                                    |  2. ESP32 解析命令，初始化摄像头
  |<-- {"type":"capture_progress",    |
  |      "view":"none","step":"0/3",  |  3. ESP32 返回就绪状态
  |      "status":"ready"} -----------|
  |                                    |
  |-- {"cmd":"capture",              |
  |     "view":"front"} ------------->|  4. WS63 发送拍摄正面指令
  |                                    |  5. ESP32 拍摄并推理
  |<-- {"type":"capture_progress",    |
  |      "view":"front","step":"1/3", |  6. ESP32 返回拍摄进度
  |      "blur_score":87.3} ----------|
  |                                    |
  |-- {"cmd":"capture","view":"side"}>|  7. WS63 发送拍摄侧面
  |<-- {"type":"capture_progress",...}|  
  |                                    |
  |-- {"cmd":"capture","view":"top"}->|  9. WS63 发送拍摄顶部
  |<-- {"type":"capture_progress",...}|
  |                                    |
  |<-- {"type":"task_done",           |
  |      "task":"register",           | 11. ESP32 返回任务完成
  |      "result":"success",...} -----|
```

---

## 注意事项

1. **换行符**：`uart_vision_send_raw_json()` 已自动追加 `\r\n`，无需额外处理
2. **UART 回环**：WS63 发出扁平 JSON 后，RX 也会收到回环。`uv_dispatch_line()` 中 "仅有 cmd 无 type 无 code" 的分支会正确丢弃这些回环消息（line 189-192）
3. **seq 序列号**：扁平格式不含 seq 字段，如需请求-响应匹配，可在 JSON 中自行添加 `"seq":N` 字段（ESP32 会原样保留在响应中 — TODO）
4. **字符串转义**：用 `cJSON_PrintUnformatted()` 构建 JSON 字符串时注意转义，特别是 `item_name` 等用户输入字段可能含特殊字符

---

## 验证步骤

1. 修改 WS63 端发送代码，改用 `uart_vision_send_raw_json()` + 扁平格式
2. 编译烧录 WS63 和 ESP32
3. ESP32 串口监视器观察：
   - `[UART0] RAW ...` 应显示 JSON 的 hex 字节
   - `[JSON→CLI] cmd=register ...` 应显示解析出的命令和参数
4. WS63 调试日志观察：
   - `[WS63_UART] raw send len=...` 确认发送成功
   - `[WS63_UART] recv ESP32 msg type=...` 确认收到 ESP32 响应
5. 端到端测试：注册 → 拍照 → 盘点 → 出库 → 删除 全流程
