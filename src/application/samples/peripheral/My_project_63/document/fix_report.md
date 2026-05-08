# WS63-BS21E 仓库管理系统 - 修复汇报

## 修订历史

| 日期 | 版本 | 修改内容 |
|------|------|----------|
| 2026-05-08 | v1.0 | 初始版本：P0 UART修复 + P1 SLE端序兼容 + P2 边界处理 |

## 1. 修改文件清单

| 文件路径 | 修改阶段 | 优先级 |
|----------|----------|--------|
| `components/uart_vision/uart_vision.h` | P0 | 高 |
| `components/uart_vision/uart_vision.c` | P0 | 高 |
| `components/shared_protocol/shared_protocol.h` | P1 | 高 |
| `components/shared_protocol/shared_protocol.c` | P1 | 高 |
| `components/sle_network/sle_network.c` | P1/P2 | 高 |
| `components/cloud_storage/cloud_storage.c` | P2 | 中 |
| `components/business_logic/business_logic.c` | P2 | 中 |
| `app/main.c` | P2 | 中 |

---

## 2. P0: UART 命令通道修复

### 2.1 问题描述

- 串口助手发送 JSON 命令后无响应
- 环形缓冲区 `\r` 换行符未正确处理
- JSON 发送存在堆溢出风险

### 2.2 修改内容

#### uart_vision.h

| 宏 | 原值 | 新值 | 说明 |
|----|------|------|------|
| UV_UART_BUS | - | 1 | UART1 总线 |
| UV_UART_TX_PIN | - | 15 | GPIO15 |
| UV_UART_RX_PIN | - | 16 | GPIO16 |
| UV_UART_TX_PIN_MODE | - | 1 | PIN_MODE_1 |
| UV_UART_RX_PIN_MODE | - | 1 | PIN_MODE_1 |
| UV_RING_SIZE | - | 512 | 环形缓冲区大小 |
| UV_LINE_MAX | - | 256 | 单行最大长度 |
| UV_LINE_TIMEOUT_MS | - | 100 | 接收超时(毫秒) |

#### uart_vision.c

1. **\r 换行符检测**：`uv_ring_has_newline()` 同时检测 `\r` 和 `\n`
2. **\r\n 合并处理**：`uv_ring_read_line()` 遇到 `\r\n` 序列自动跳过 `\n`
3. **堆溢出修复**：`uart_vision_send_json()` 分两次调用 `uapi_uart_write()`
4. **超时机制**：100ms 内无完整行则丢弃不完整数据
5. **调试日志增强**：
   - 接收时间戳、原始行内容、引脚 mode 值
   - 缓冲区满计数 (`ring drop count`)
   - 超时丢弃计数 (`timeout drop`)
6. **ring_usage()**：新增接口供心跳监控缓冲区使用量

### 2.3 验证方法

```
发送: {"cmd":"wifi_connect","seq":1,"data":{"ssid":"test","psk":"test123"}}
预期: {"cmd":"wifi_connect","seq":1,"code":0,"msg":"connecting"}
```

---

## 3. P1: SLE 端序兼容 + SSAP 调试

### 3.1 问题描述

- BS21E 广播 magic 字段为 `DD CC BB AA`（大端）
- WS63 只支持小端解析 `AA BB CC DD`
- SSAP 服务发现失败但无详细日志

### 3.2 修改内容

#### shared_protocol.h

| 宏 | 值 | 说明 |
|----|-----|------|
| SHARED_PROTO_MAGIC | 0xAABBCCDD | 小端格式 |
| SHARED_PROTO_MAGIC_BE | 0xDDCCBBAA | 大端格式 |

#### shared_protocol.c

1. **read_be32 / read_be16**：新增大端字节序读取函数
2. **shared_protocol_unpack_adv()**：双端序自动检测
   - 先用 LE 读取 magic，不匹配则尝试 BE
   - tag_id / qty / seq 字段跟随 magic 的端序
3. **shared_protocol_validate()**：同时接受 LE/BE magic

#### sle_network.c

1. **UUID 匹配日志**：`my63_uuid_match()` 打印 16-bit UUID 比对结果
2. **SSAP 全链路日志**：
   - exchange_info 请求/响应
   - find_structure 服务/属性 UUID
   - CCCD 写入结果
3. **连接状态字符串化**：`my63_connect_state_changed_cb()` 使用枚举字符串

---

## 4. P2: 边界处理 + 安全加固

### 4.1 修改内容

#### business_logic.c

- 3 处未检查的 `strncpy_s()` 返回值添加日志

#### cloud_storage.c

| 函数 | 修改 | 说明 |
|------|------|------|
| `cs_wifi_do_connect()` | SSID 长度校验 | ssid 非空且 ≤ 32 字节 |
| `cs_mqtt_connect()` | URI 格式校验 | 必须以 `tcp://` 或 `ssl://` 开头 |
| `cloud_storage_poll()` | DHCP 超时保护 | 30 秒超时后自动断开 WiFi |

#### sle_network.c

| 函数 | 修改 | 说明 |
|------|------|------|
| `my63_seek_result_cb()` | tag_id=0 过滤 | 跳过无效广播 |
| `my63_notify_result_cb()` | notify 长度校验 | 最小 9 字节检查 |
| `my63_restart_scan_after_security_fail()` | 延迟重启 | 失败后延迟 1 秒再扫描 |

#### main.c

- 心跳日志增加 `uart_ring` 缓冲区使用量输出

---

## 5. ⚠️ 已知风险

### 5.1 UART1 与 LOG 系统冲突

| 配置项 | 当前值 | 说明 |
|--------|--------|------|
| CONFIG_LOG_UART | 1 | LOG 使用 UART1 |
| CONFIG_LOG_UART_BAUDRATE | 921600 | LOG 波特率 |
| UV_UART_BAUDRATE | 115200 | 应用波特率 |

**问题**：`uart_vision_init()` 调用 `uapi_uart_deinit(1)` 后重新初始化 UART1，LOG 输出将丢失或乱码。

**解决方案**（二选一）：
1. 修改 menuconfig 将 LOG 迁移到 UART2：`CONFIG_LOG_UART=2`
2. 或在 `uart_vision_init()` 之前确保 LOG 已完成输出

### 5.2 SLE_ACB_STATE 枚举

SDK 中 `sle_connection_manager.h` 只定义了 3 种连接状态：
- `SLE_ACB_STATE_NONE`
- `SLE_ACB_STATE_CONNECTED`
- `SLE_ACB_STATE_DISCONNECTED`

代码中不应使用 `SLE_ACB_STATE_CONNECTING` / `SLE_ACB_STATE_DISCONNECTING`（编译错误）。

---

## 6. 端到端测试步骤

### 6.1 编译烧录

```bash
cd /home/cool/fbb_ws63/src
python3 build.py ws63-liteos-app
```

烧录路径：
```
output/ws63/acore/ws63-liteos-app/ws63-liteos-app-sign.bin
```

### 6.2 UART 动态配网测试

**硬件连接**：
- WS63 UART1: TX=GPIO15, RX=GPIO16
- 串口助手: 115200, 8N1

**测试步骤**：

| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 发送 `{"cmd":"wifi_connect","seq":1,"data":{"ssid":"你的SSID","psk":"你的密码"}}` | 收到 `{"cmd":"wifi_connect","seq":1,"code":0,"msg":"connecting"}` |
| 2 | 等待 5-10 秒，观察 LOG | 显示 WiFi 连接成功、DHCP 获取完成 |
| 3 | 发送 `{"cmd":"mqtt_connect","seq":2,"data":{"uri":"tcp://IP:PORT","client_id":"ws63_001"}}` | 收到 MQTT 连接响应 |
| 4 | 观察心跳日志 | `wifi=X mqtt=X` 状态变为已连接 |

**日志关键词**：
```
[WS63_CLOUD] WiFi connected
[WS63_CLOUD] dhcp ok ip=XXX.XXX.XXX.XXX
[WS63_CLOUD] mqtt connect success
[WS63_APP] hb ... wifi=2 mqtt=2
```

### 6.3 SLE 扫描 + SSAP 交换测试

**前提条件**：BS21E 标签已上电并广播

**测试步骤**：

| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 观察 LOG | 显示 `[WS63_NET] seek result` 扫描结果 |
| 2 | 确认扫描到 BS21E | 日志显示 `uuid_match: 16-bit MATCH` |
| 3 | 观察连接建立 | `[WS63_NET] conn state ... CONNECTED` |
| 4 | 观察配对 | `[WS63_NET] pair complete PAIR_PAIRED` |
| 5 | 观察 SSAP 交换 | `[WS63_NET] CCCD write SUCCESS` |
| 6 | 观察 SSAP 就绪 | `[WS63_NET] ssap exchange SUCCESS` |

**日志关键词**：
```
[WS63_NET] seek result #1 rssi=-XX
[WS63_NET] RAW PAYLOAD len=XX: XX...
[WS63_NET] local_name matched
[WS63_NET] uuid_match: 16-bit MATCH
[WS63_NET] adv matched tag=N
[WS63_NET] connect target addr=XX:XX:XX:XX:XX:XX
[WS63_NET] conn state ... CONNECTED
[WS63_NET] pair complete PAIR_PAIRED
[WS63_NET] ssap exchange info ... mtu=X version=X
[WS63_NET] ssap find structure: start_hdl=0xXXXX
[WS63_NET] ssap service MATCHED
[WS63_NET] ssap property MATCHED handle=0xXXXX
[WS63_NET] write_cccd handle=0xXXXX
[WS63_NET] CCCD write SUCCESS
[WS63_NET] ssap exchange SUCCESS
[WS63_APP] hb ... sle=1/1/1
```

### 6.4 业务命令测试

**盘点命令**：
```
发送: {"cmd":"inventory","seq":10}
预期: 收到 SSAP INVENTORY 响应
日志: [WS63_NET] notify: inventory tag_id=X qty=X battery=X
```

**绑定命令**：
```
发送: {"cmd":"bind_tag","seq":11,"data":{"tag_id":1}}
预期: 收到绑定响应
日志: [WS63_NET] notify: bind tag_id=X result=OK/FAIL
```

---

## 7. 文档清单

| 文档 | 路径 | 说明 |
|------|------|------|
| uart_vision.md | `document/uart_vision.md` | UART 通信参数、串口助手格式 |
| sle_network.md | `document/sle_network.md` | SLE 连接、SSAP 流程 |
| shared_protocol.md | `document/shared_protocol.md` | 协议编解码、端序兼容 |
| 本文档 | `document/fix_report.md` | 修复汇报 + 测试步骤 |

---

## 8. 待优化项

| 优先级 | 问题 | 建议方案 |
|--------|------|----------|
| 高 | UART1 与 LOG 共用引脚 | 迁移 LOG 到 UART2 |
| 中 | SSAP 服务 UUID 硬编码 | 从 NV 存储读取，支持多设备 |
| 中 | WiFi 重连逻辑 | 增加自动重连 + 退避 |
| 低 | MQTT QoS 配置 | 支持配置化 |
