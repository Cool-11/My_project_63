# WS63 智能仓储网关 — 修改代码测试用例

> 生成日期: 2026-05-15
> 测试对象: `business_logic.c`, `uart_vision.c`
> 测试方式: 手动测试（串口发送 JSON，观察响应和日志）
> 环境: WS63 开发板 + ESP32 屏幕 + BS21E 标签（部分用例需全部，部分仅需 WS63）

## 串口测试工具配置

- 波特率: 115200
- 数据位: 8, 停止位: 1, 无校验
- 换行: `\n` 或 `\r\n`
- 工具推荐: SSCOM / minicom / PuTTY

## 响应格式说明

请求: `{"cmd":"<name>","seq":<N>,"data":{...}}\n`
响应: `{"cmd":"<name>","seq":<N>,"code":<0>,"msg":"ok","data":{...}}\r\n`

- `code=0` 成功, `code<0` 失败

---

## 一、Functional（功能测试）

### TC-001: biz_cmd_register — 正常注册流程（SLE bind + ESP32 register）

**描述:** 发送 register 命令，验证 SLE 绑定成功后自动转发到 ESP32，最终收到 ESP32 task_done 回复。

**前置条件:**
- WS63 已初始化，SLE 已连接 BS21E（`sle_network_is_ssap_ready() != 0`）
- ESP32 已通过 UART 连接
- 标签映射表未满

**输入:**
```json
{"cmd":"register","seq":101,"data":{"storage_area":"A1","item_name":"USB-C Cable"}}
```

**预期输出 (最终):**
```json
{"cmd":"register","seq":101,"code":0,"msg":"ok","data":{"task":"register","result":"success"}}
```

**预期日志:**
```
[WS63_BIZ] uart cmd=register seq=101
[WS63_BIZ] alloc tag_id=<N> count=<M>
[WS63_BIZ] pending cmd=register seq=101 tag_id=<N> timeout=15000ms
[WS63_BIZ] sle bind cmd=0x00 tag_id=<N>
[WS63_BIZ] passthrough cmd=register to esp32
[WS63_BIZ] esp32 task_done task=register matched pending=register
```

**判定:**
- PASS: 收到 code=0 的最终响应，日志中出现 bind -> passthrough -> task_done 完整链路
- FAIL: 收到 code<0 或超时无响应

---

### TC-002: biz_cmd_register — 存储区域和物品名称字段验证

**描述:** 验证 register 命令正确解析 storage_area 和 item_name 字段并存入标签映射表。

**前置条件:** 同 TC-001

**输入:**
```json
{"cmd":"register","seq":102,"data":{"storage_area":"B3","item_name":"HDMI Adapter"}}
```

**预期:** NV 保存后，通过 list 命令可查看到新标签的 zone="B3"、item="HDMI Adapter"。

**验证步骤:**
1. 等待 register 流程完成（TC-001）
2. 发送: `{"cmd":"list","seq":200,"data":{}}`
3. 检查响应 data.tags 数组中包含 zone="B3"、item="HDMI Adapter" 的条目

**判定:**
- PASS: list 响应中能找到匹配条目
- FAIL: 条目缺失或字段值错误

---

### TC-003: biz_cmd_outbound — 通过 tag_id 出库

**描述:** 使用 tag_id 查找标签并执行出库（unbind）流程。

**前置条件:**
- 至少有一个已注册标签（tag_id 已知）
- SLE 已连接

**输入:**
```json
{"cmd":"outbound","seq":103,"data":{"tag_id":1}}
```

**预期输出 (SLE 可用时):**
```json
{"cmd":"outbound","seq":103,"code":0,"msg":"ok","data":{"tag_id":1}}
```

**预期日志:**
```
[WS63_BIZ] uart cmd=outbound seq=103
[WS63_BIZ] pending cmd=outbound seq=103 tag_id=1 timeout=5000ms
[WS63_BIZ] remove tag_id=1 count=<N-1>
```

**判定:**
- PASS: code=0, tag 从映射表移除
- FAIL: code<0 或 tag 仍在表中

---

### TC-004: biz_cmd_outbound — 通过 MAC 地址出库

**描述:** 使用 MAC 地址查找标签并执行出库流程（新增的 mac 查找功能）。

**前置条件:**
- 至少有一个已注册标签，其 MAC 地址已知（通过 SLE 连接后记录）

**输入:**
```json
{"cmd":"outbound","seq":104,"data":{"mac":"aa:bb:cc:dd:ee:ff"}}
```

**预期输出:**
```json
{"cmd":"outbound","seq":104,"code":0,"msg":"ok","data":{"tag_id":<N>}}
```

**判定:**
- PASS: 正确匹配到对应 tag_id 并移除
- FAIL: 返回 "tag not found"（MAC 不匹配）或 code<0

---

### TC-005: biz_cmd_outbound — SLE 不可用时的本地降级

**描述:** SLE 未连接时，outbound 直接本地移除标签而不等待 SLE 响应。

**前置条件:**
- SLE 未连接（`sle_network_is_ssap_ready() == 0`）
- 至少有一个已注册标签

**输入:**
```json
{"cmd":"outbound","seq":105,"data":{"tag_id":1}}
```

**预期输出:**
```json
{"cmd":"outbound","seq":105,"code":0,"msg":"ok","data":{"tag_id":1}}
```

**预期日志:**
```
[WS63_BIZ] outbound unbind send fail, remove locally
[WS63_BIZ] remove tag_id=1 count=<N-1>
```

**判定:**
- PASS: 立即返回 code=0（不超时等待），tag 已移除
- FAIL: 等待超时或 tag 未移除

---

### TC-006: biz_cmd_mqtt_connect — URI 格式

**描述:** 使用 "uri" 字段直接指定 MQTT broker 地址。

**前置条件:**
- MQTT 回调已注册
- WiFi 已连接

**输入:**
```json
{"cmd":"mqtt_connect","seq":106,"data":{"uri":"tcp://broker.example.com:1883","client_id":"ws63_gw_01","username":"user1","password":"pass123"}}
```

**预期输出:**
```json
{"cmd":"mqtt_connect","seq":106,"code":0,"msg":"ok"}
```

**判定:**
- PASS: code=0, MQTT 回调收到 uri="tcp://broker.example.com:1883"
- FAIL: code<0 或 uri 传递错误

---

### TC-007: biz_cmd_mqtt_connect — host+port 格式（ESP32 兼容）

**描述:** 使用 "host"+"port" 格式，自动组装为 "tcp://host:port" URI（ESP32 格式兼容）。

**前置条件:** 同 TC-006

**输入:**
```json
{"cmd":"mqtt_connect","seq":107,"data":{"host":"192.168.1.100","port":8883,"client_id":"ws63_gw_02"}}
```

**预期输出:**
```json
{"cmd":"mqtt_connect","seq":107,"code":0,"msg":"ok"}
```

**预期:** MQTT 回调收到 uri="tcp://192.168.1.100:8883"

**判定:**
- PASS: uri 正确拼接为 "tcp://192.168.1.100:8883"
- FAIL: uri 格式错误或 port 缺失时未使用默认 1883

---

### TC-008: biz_cmd_mqtt_connect — host 格式无 port（默认端口）

**描述:** 只提供 host 不提供 port，验证默认使用 1883。

**前置条件:** 同 TC-006

**输入:**
```json
{"cmd":"mqtt_connect","seq":108,"data":{"host":"mqtt.thingsboard.io"}}
```

**预期:** MQTT 回调收到 uri="tcp://mqtt.thingsboard.io:1883"

**判定:**
- PASS: 默认端口 1883 被正确填充
- FAIL: uri 不含端口或解析失败

---

### TC-009: biz_cmd_passthrough_to_esp32 — 扁平 JSON 构造

**描述:** 验证 passthrough 命令将 data 字段合并到 root 对象（扁平格式），发送给 ESP32。

**前置条件:** ESP32 已通过 UART 连接

**输入:**
```json
{"cmd":"get_assets","seq":109,"data":{"filter":"zone_A"}}
```

**预期发送到 ESP32 的原始 JSON:**
```json
{"cmd":"get_assets","seq":109,"filter":"zone_A"}
```

**判定:**
- PASS: ESP32 收到的 JSON 中 cmd、seq、filter 均在顶层，无嵌套 data
- FAIL: JSON 中存在 "data" 嵌套层

---

### TC-010: biz_cmd_passthrough_to_esp32 — 无 data 字段

**描述:** passthrough 命令不带 data 字段，仅发送 cmd 和 seq。

**前置条件:** ESP32 已连接

**输入:**
```json
{"cmd":"sys_info","seq":110}
```

**预期发送到 ESP32:**
```json
{"cmd":"sys_info","seq":110}
```

**判定:**
- PASS: 仅包含 cmd 和 seq，无多余字段
- FAIL: 出现空 data 对象或其他字段

---

### TC-011: biz_cmd_passthrough_to_esp32 — l610_at 透传

**描述:** 验证 l610_at 命令正确透传到 ESP32。

**前置条件:** ESP32 已连接

**输入:**
```json
{"cmd":"l610_at","seq":111,"data":{"at_cmd":"AT+CEREG?"}}
```

**预期发送到 ESP32:**
```json
{"cmd":"l610_at","seq":111,"at_cmd":"AT+CEREG?"}
```

**判定:**
- PASS: at_cmd 字段在顶层
- FAIL: 字段嵌套在 data 中

---

### TC-012: biz_handle_esp32_msg — task_done 匹配（register 流程）

**描述:** 模拟 ESP32 上报 task_done，验证与 pending register 命令的匹配。

**前置条件:**
- 已发起 register 命令（TC-001），pending 状态为 register

**模拟 ESP32 上行:**
```json
{"type":"task_done","task":"register","result":"success","tag_id":1}
```

**预期 WS63 串口输出:**
```json
{"cmd":"register","seq":101,"code":0,"msg":"ok","data":{"task":"register","result":"success","tag_id":1}}
```

**判定:**
- PASS: seq 与原始 register 请求一致，code=0，pending 被清除
- FAIL: seq 不匹配或 pending 未清除

---

### TC-013: biz_handle_esp32_msg — error 消息处理

**描述:** 模拟 ESP32 上报 error，验证 pending 命令收到错误回复。

**前置条件:**
- 有一个活跃的 pending 命令

**模拟 ESP32 上行:**
```json
{"type":"error","msg":"camera init fail"}
```

**预期 WS63 串口输出:**
```json
{"cmd":"<pending_cmd>","seq":<pending_seq>,"code":-1,"msg":"camera init fail"}
```

**判定:**
- PASS: 错误消息正确转发，pending 清除
- FAIL: msg 丢失或 pending 未清除

---

### TC-014: biz_handle_esp32_msg — 状态消息转发（mqtt_connected）

**描述:** 验证 MQTT 状态消息直接转发到串口屏幕。

**前置条件:** 无活跃 pending

**模拟 ESP32 上行:**
```json
{"type":"mqtt_connected","broker":"mqtt.example.com"}
```

**预期 WS63 串口输出:**
```json
{"cmd":"mqtt_connected","seq":0,"code":0,"msg":"ok","data":{"type":"mqtt_connected","broker":"mqtt.example.com"}}
```

**判定:**
- PASS: 消息以 seq=0 转发，不影响 pending 状态
- FAIL: 消息丢失或干扰 pending

---

### TC-015: biz_handle_esp32_msg — L610 状态转发

**描述:** 验证 l610_error、l610_at_result、l610_status 消息的转发。

**前置条件:** 无

**模拟 ESP32 上行:**
```json
{"type":"l610_at_result","result":"+CEREG: 0,1"}
```

**预期 WS63 串口输出:**
```json
{"cmd":"l610_at_result","seq":0,"code":0,"msg":"ok","data":{"type":"l610_at_result","result":"+CEREG: 0,1"}}
```

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-016: uv_dispatch_line — type 字段回退（ESP32 兼容）

**描述:** 验证 JSON 中使用 "type" 而非 "cmd" 时，dispatch 能正确识别。

**前置条件:** cmd handler 已注册

**输入 (串口发送):**
```json
{"type":"task_done","seq":0,"data":{"task":"register","result":"success"}}
```

**预期日志:**
```
[WS63_UART] recv cmd=task_done seq=0
```

**判定:**
- PASS: cmd 被正确解析为 "task_done"
- FAIL: 报 "missing cmd/type field"

---

### TC-017: uv_dispatch_line — cmd 优先于 type

**描述:** 同时存在 "cmd" 和 "type" 字段时，"cmd" 优先。

**输入:**
```json
{"cmd":"find","type":"task_done","seq":5,"data":{"tag_id":1}}
```

**预期日志:**
```
[WS63_UART] recv cmd=find seq=5
```

**判定:**
- PASS: 使用 "cmd" 值 "find"，忽略 "type" 值
- FAIL: 使用了 "type" 值

---

### TC-018: uv_dispatch_line — seq 缺失默认为 0

**描述:** JSON 中无 seq 字段时，默认 seq=0。

**输入:**
```json
{"cmd":"list","data":{}}
```

**预期日志:**
```
[WS63_UART] recv cmd=list seq=0
```

**判定:**
- PASS: seq=0
- FAIL: seq 为随机值或崩溃

---

### TC-019: uv_dispatch_line — data 字段缺失

**描述:** JSON 中无 data 字段时，data_json 为 NULL 传给 handler。

**输入:**
```json
{"cmd":"inventory","seq":6}
```

**预期:** business_logic 收到 data_json=NULL，inventory 正常执行（inventory 不解析 data）。

**判定:**
- PASS: 正常执行
- FAIL: 空指针崩溃

---

### TC-020: uart_vision_send_raw_json — 正常发送

**描述:** 验证 raw JSON 发送功能，直接输出 JSON 字符串加换行。

**前置条件:** UART TX 正常

**触发方式:** 通过 passthrough 命令间接触发

**输入:**
```json
{"cmd":"get_assets","seq":120,"data":{}}
```

**预期:** ESP32 收到完整 JSON + `\r\n`

**判定:**
- PASS: ESP32 收到 `{"cmd":"get_assets","seq":120}\r\n`
- FAIL: JSON 不完整或无换行符

---

### TC-021: uv_dispatch_line — 完整命令分发链（list 命令）

**描述:** 验证从串口输入到命令分发到响应输出的完整链路。

**输入:**
```json
{"cmd":"list","seq":201,"data":{}}
```

**预期输出:**
```json
{"cmd":"list","seq":201,"code":0,"msg":"ok","data":{"count":<N>,"tags":[...]}}
```

**判定:**
- PASS: 响应中 cmd、seq 匹配，data 包含 tags 数组
- FAIL: 响应缺失或格式错误

---

### TC-022: biz_cmd_register — 完整双阶段流程验证

**描述:** 验证 register 的完整流程: SLE bind -> 等待 BS21E bind 响应 -> 转发 ESP32 -> 等待 task_done。

**前置条件:** WS63 + ESP32 + BS21E 全部在线

**输入:**
```json
{"cmd":"register","seq":130,"data":{"storage_area":"C2","item_name":"Power Bank"}}
```

**预期流程:**
1. WS63 发送 SSAP_CMD_BIND_TAG 给 BS21E
2. BS21E 返回 bind OK
3. WS63 转发 `{"cmd":"register","tag_id":<N>}` 给 ESP32
4. ESP32 处理后返回 `{"type":"task_done","task":"register",...}`
5. WS63 最终回复串口屏幕

**判定:**
- PASS: 收到最终 code=0 响应
- FAIL: 任一阶段超时或失败

---

## 二、Edge Cases（边界测试）

### TC-030: biz_cmd_register — 标签映射表满（BIZ_TAG_MAX=32）

**描述:** 映射表已注册 32 个标签时，新 register 应返回 "map full"。

**前置条件:** 已注册 32 个标签

**输入:**
```json
{"cmd":"register","seq":131,"data":{"storage_area":"A1","item_name":"Overflow Item"}}
```

**预期输出:**
```json
{"cmd":"register","seq":131,"code":-3,"msg":"map full"}
```

**判定:**
- PASS: code=-3，不崩溃
- FAIL: 崩溃或返回其他错误码

---

### TC-031: biz_cmd_register — storage_area 和 item_name 缺失

**描述:** register 命令不包含可选字段 storage_area 和 item_name。

**前置条件:** SLE 已连接

**输入:**
```json
{"cmd":"register","seq":132,"data":{}}
```

**预期:** register 流程正常执行，zone 和 item 为空字符串。

**判定:**
- PASS: 流程正常完成，tag 条目 zone=""、item=""
- FAIL: 崩溃或流程中断

---

### TC-032: biz_cmd_register — 超长字符串截断

**描述:** storage_area 超过 BIZ_ZONE_LEN(8)、item_name 超过 BIZ_ITEM_LEN(16) 时应截断。

**前置条件:** SLE 已连接

**输入:**
```json
{"cmd":"register","seq":133,"data":{"storage_area":"ABCDEFGHIJ","item_name":"ThisIsAVeryLongItemNameThatExceeds"}}
```

**预期:** zone 截断为 7 字符+"\\0"（"ABCDEFGH"），item 截断为 15 字符+"\\0"。

**验证:** list 命令确认字段长度。

**判定:**
- PASS: 不溢出，字段正确截断
- FAIL: 内存溢出或字符串未截断

---

### TC-033: biz_parse_mac — 标准 MAC 格式

**描述:** 各种合法 MAC 地址格式。

**输入 (通过 outbound):**
```json
{"cmd":"outbound","seq":134,"data":{"mac":"00:11:22:33:44:55"}}
```

**预期:** 正确解析并匹配。

**判定:**
- PASS: 正确解析 6 字节 MAC
- FAIL: 解析失败

---

### TC-034: biz_parse_mac — 大写 MAC 地址

**描述:** MAC 地址使用大写十六进制。

**输入:**
```json
{"cmd":"outbound","seq":135,"data":{"mac":"AA:BB:CC:DD:EE:FF"}}
```

**预期:** `sscanf %02x` 支持大小写，应正常解析。

**判定:**
- PASS: 正确解析
- FAIL: 解析失败（sscanf 不区分大小写，应通过）

---

### TC-035: biz_parse_mac — 无效 MAC 格式

**描述:** 各种无效 MAC 格式。

**测试向量:**

| 输入 mac | 预期 |
|-----------|------|
| `"00:11:22:33:44"` | 解析失败（少于6组） |
| `"00:11:22:33:44:55:66"` | 解析失败（多于6组） |
| `"00-11-22-33-44-55"` | 解析失败（分隔符错误） |
| `"gg:hh:ii:jj:kk:ll"` | 解析失败（非十六进制） |
| `""` | 解析失败（空字符串） |
| `"not_a_mac"` | 解析失败 |

**每个测试向量的输入:**
```json
{"cmd":"outbound","seq":136,"data":{"mac":"<MAC_VALUE>"}}
```

**预期输出:**
```json
{"cmd":"outbound","seq":136,"code":-3,"msg":"tag not found"}
```

**判定:**
- PASS: 所有无效格式返回 "tag not found"（mac 解析失败 -> entry=NULL）
- FAIL: 任一格式导致崩溃或意外匹配

---

### TC-036: biz_cmd_outbound — tag_id 和 mac 同时提供

**描述:** 同时提供 tag_id 和 mac 时，tag_id 优先。

**前置条件:** tag_id=1 存在，mac 对应 tag_id=2

**输入:**
```json
{"cmd":"outbound","seq":137,"data":{"tag_id":1,"mac":"aa:bb:cc:dd:ee:ff"}}
```

**预期:** 移除 tag_id=1（tag_id 优先）

**判定:**
- PASS: tag_id=1 被移除
- FAIL: tag_id=2 被移除或两者都未移除

---

### TC-037: biz_cmd_outbound — tag_id 和 mac 均缺失

**描述:** outbound 不提供任何查找字段。

**输入:**
```json
{"cmd":"outbound","seq":138,"data":{}}
```

**预期输出:**
```json
{"cmd":"outbound","seq":138,"code":-3,"msg":"tag not found"}
```

**判定:**
- PASS: code=-3，不崩溃
- FAIL: 崩溃或意外行为

---

### TC-038: biz_cmd_mqtt_connect — URI 和 host 同时提供

**描述:** 同时提供 uri 和 host 时，uri 优先（代码中先检查 j_uri）。

**输入:**
```json
{"cmd":"mqtt_connect","seq":139,"data":{"uri":"tcp://primary:1883","host":"secondary","port":8883}}
```

**预期:** MQTT 回调收到 uri="tcp://primary:1883"

**判定:**
- PASS: uri 优先
- FAIL: host 覆盖了 uri

---

### TC-039: biz_cmd_mqtt_connect — uri 和 host 均缺失

**描述:** 不提供 uri 也不提供 host。

**输入:**
```json
{"cmd":"mqtt_connect","seq":140,"data":{"client_id":"test"}}
```

**预期输出:**
```json
{"cmd":"mqtt_connect","seq":140,"code":-2,"msg":"missing uri/host"}
```

**判定:**
- PASS: code=-2
- FAIL: 崩溃或错误码不对

---

### TC-040: biz_get_pending_timeout_ms — register 超时 15s

**描述:** register 命令的 pending 超时为 15 秒（ESP32 视觉处理时间较长）。

**验证方法:**
1. 发送 register 命令但不模拟 BS21E 响应
2. 等待 5 秒 — 不应超时
3. 等待到 15 秒 — 应超时

**输入:**
```json
{"cmd":"register","seq":141,"data":{"storage_area":"A1","item_name":"Test"}}
```

**预期日志 (15秒后):**
```
[WS63_BIZ] pending timeout cmd=register seq=141
```

**判定:**
- PASS: 5 秒时未超时，15 秒时超时
- FAIL: 5 秒时就超时

---

### TC-041: biz_get_pending_timeout_ms — inbound 超时 5s

**描述:** inbound 命令的 pending 超时为 5 秒（SLE 命令）。

**输入:**
```json
{"cmd":"inbound","seq":142,"data":{"zone":"A1","item":"Test"}}
```

**预期:** 约 5 秒后超时。

**判定:**
- PASS: 约 5 秒超时
- FAIL: 超时时间不是 5 秒

---

### TC-042: uv_dispatch_line — 最大行长度（UV_LINE_MAX=512）

**描述:** 发送接近 512 字节的 JSON 行。

**输入:** 构造一个约 510 字节的 JSON:
```json
{"cmd":"test","seq":143,"data":{"fill":"<480字节的A填充>"}}
```

**预期:** 正常解析（< UV_LINE_MAX-1）

**判定:**
- PASS: 正常处理
- FAIL: 截断或丢弃

---

### TC-043: uv_dispatch_line — 超长行丢弃

**描述:** 发送超过 UV_LINE_MAX(512) 字节的 JSON 行。

**输入:** 构造一个约 600 字节的 JSON。

**预期日志:**
```
[WS63_UART] line too long drop len=<N>
```

**判定:**
- PASS: 超长行被丢弃，不影响后续命令
- FAIL: 缓冲区溢出或后续命令异常

---

### TC-044: uv_ring_push — 环形缓冲区满丢弃

**描述:** 快速发送大量数据填满 2048 字节环形缓冲区。

**前置条件:** 不调用 poll（不消费缓冲区）

**操作:** 连续发送 3 条 700 字节的 JSON（不带换行，防止被消费）。

**预期日志:**
```
[WS63_UART] ring drop count=<N>
```

**判定:**
- PASS: 多余数据被丢弃，drop_count 递增
- FAIL: 缓冲区溢出写坏数据

---

### TC-045: biz_cmd_passthrough_to_esp32 — data 字段含嵌套对象

**描述:** data 字段包含嵌套 JSON 对象时，应正确扁平化。

**输入:**
```json
{"cmd":"get_assets","seq":145,"data":{"filter":{"zone":"A1","type":"tag"}}}
```

**预期发送到 ESP32:**
```json
{"cmd":"get_assets","seq":145,"filter":{"zone":"A1","type":"tag"}}
```

**判定:**
- PASS: 嵌套对象被正确提升到顶层
- FAIL: 嵌套对象丢失或 data 壳保留

---

### TC-046: uv_ring_read_line — \r\n 和 \n 换行处理

**描述:** 验证不同换行符的处理。

**测试向量:**

| 输入 | 预期 |
|------|------|
| `{"cmd":"list","seq":1}\n` | 正常解析 |
| `{"cmd":"list","seq":2}\r\n` | 正常解析（跳过 \n） |
| `{"cmd":"list","seq":3}\r` | 正常解析 |

**判定:**
- PASS: 所有换行格式都能正确解析
- FAIL: \r\n 产生空行或重复解析

---

### TC-047: biz_handle_esp32_msg — task 为 NULL 或非字符串

**描述:** task_done 消息中 task 字段缺失或类型错误。

**模拟 ESP32 上行:**
```json
{"type":"task_done","task":123}
```

**预期:** 消息被忽略（task 不是字符串）。

**判定:**
- PASS: 无输出，无崩溃
- FAIL: 崩溃或异常回复

---

### TC-048: biz_handle_esp32_msg — task 无匹配 pending

**描述:** task_done 到达但无匹配的 pending 命令。

**前置条件:** 无活跃 pending

**模拟 ESP32 上行:**
```json
{"type":"task_done","task":"register","result":"success"}
```

**预期日志:**
```
[WS63_BIZ] esp32 task_done task=register no pending match
```

**判定:**
- PASS: 仅打印日志，无输出
- FAIL: 异常回复或崩溃

---

### TC-049: biz_handle_esp32_msg — error 消息无活跃 pending

**描述:** error 到达但无活跃 pending。

**模拟 ESP32 上行:**
```json
{"type":"error","msg":"some error"}
```

**预期:** 仅打印日志，不回复串口。

**判定:**
- PASS: 日志中有 error 记录，无串口输出
- FAIL: 异常回复

---

### TC-050: biz_handle_esp32_msg — error 消息无 msg 字段

**描述:** error 消息缺少 msg 字段。

**前置条件:** 有活跃 pending

**模拟 ESP32 上行:**
```json
{"type":"error"}
```

**预期:** 使用默认消息 "esp32 error"。

**判定:**
- PASS: msg="esp32 error"
- FAIL: msg 为空或崩溃

---

## 三、Error Handling（错误处理测试）

### TC-060: biz_cmd_register — SLE 未就绪

**描述:** SLE 未连接时发送 register。

**前置条件:** `sle_network_is_ssap_ready() == 0`

**输入:**
```json
{"cmd":"register","seq":150,"data":{"storage_area":"A1","item_name":"Test"}}
```

**预期输出:**
```json
{"cmd":"register","seq":150,"code":-1,"msg":"sle not ready"}
```

**判定:**
- PASS: code=-1, "sle not ready"
- FAIL: 尝试发送 SLE 命令导致崩溃

---

### TC-061: biz_cmd_register — 无效 JSON

**描述:** 发送非法 JSON 字符串。

**输入:**
```
{"cmd":"register","seq":151,"data":{invalid
```

**预期输出:**
```json
{"cmd":"register","seq":151,"code":-2,"msg":"json parse fail"}
```

**判定:**
- PASS: code=-2
- FAIL: 崩溃

---

### TC-062: biz_cmd_register — SLE 发送失败

**描述:** SLE 已连接但发送命令失败。

**前置条件:** 可通过断开 BS21E 天线或模拟 SLE 层错误

**输入:**
```json
{"cmd":"register","seq":152,"data":{"storage_area":"A1","item_name":"Test"}}
```

**预期输出:**
```json
{"cmd":"register","seq":152,"code":-4,"msg":"sle send fail"}
```

**预期:** 已分配的 tag 被移除（`biz_map_remove`）。

**判定:**
- PASS: code=-4, tag 被回滚
- FAIL: tag 残留在表中

---

### TC-063: biz_cmd_register — BS21E bind 响应失败

**描述:** BS21E 返回 bind 失败响应。

**前置条件:** SLE 已连接，BS21E 可能因标签已绑定等原因返回失败

**预期:**
```json
{"cmd":"register","seq":153,"code":-5,"msg":"bind failed"}
```

**预期:** tag 被移除。

**判定:**
- PASS: code=-5, tag 回滚
- FAIL: tag 残留

---

### TC-064: biz_cmd_outbound — 无效 JSON

**输入:**
```
{broken json
```

**预期输出:**
```json
{"cmd":"outbound","seq":154,"code":-1,"msg":"json parse fail"}
```

**判定:**
- PASS: code=-1
- FAIL: 崩溃

---

### TC-065: biz_cmd_mqtt_connect — MQTT 回调未注册

**描述:** MQTT 回调函数指针为 NULL。

**前置条件:** 未调用 `business_logic_register_mqtt_cmd_cb`

**输入:**
```json
{"cmd":"mqtt_connect","seq":155,"data":{"uri":"tcp://broker:1883"}}
```

**预期输出:**
```json
{"cmd":"mqtt_connect","seq":155,"code":-3,"msg":"mqtt not available"}
```

**判定:**
- PASS: code=-3
- FAIL: 空指针崩溃

---

### TC-066: biz_cmd_mqtt_connect — 无效 JSON

**输入:**
```
not json at all
```

**预期输出:**
```json
{"cmd":"mqtt_connect","seq":156,"code":-1,"msg":"json parse fail"}
```

**判定:**
- PASS: code=-1
- FAIL: 崩溃

---

### TC-067: biz_cmd_passthrough_to_esp32 — cJSON_CreateObject 失败

**描述:** 内存不足时 cJSON_CreateObject 返回 NULL。

**前置条件:** 需要模拟内存耗尽（难以手动触发，可代码审查确认路径）

**预期输出:**
```json
{"cmd":"get_assets","seq":157,"code":-1,"msg":"json create fail"}
```

**判定:**
- PASS: 优雅处理
- FAIL: 空指针崩溃

---

### TC-068: uv_dispatch_line — 非 JSON 输入

**描述:** 发送纯文本或二进制数据。

**输入:**
```
Hello World
```

**预期日志:**
```
[WS63_UART] json parse fail len=11
```

**判定:**
- PASS: 静默丢弃，不崩溃
- FAIL: 崩溃或异常行为

---

### TC-069: uv_dispatch_line — JSON 中 cmd 字段非字符串

**描述:** cmd 字段为数字或其他类型。

**输入:**
```json
{"cmd":123,"seq":158}
```

**预期日志:**
```
[WS63_UART] missing cmd/type field
```

**判定:**
- PASS: 丢弃，不崩溃
- FAIL: 崩溃或误处理

---

### TC-070: uv_dispatch_line — 空 JSON 对象

**输入:**
```json
{}
```

**预期日志:**
```
[WS63_UART] missing cmd/type field
```

**判定:**
- PASS: 丢弃
- FAIL: 崩溃

---

### TC-071: uart_vision_send_json — cmd 为 NULL

**描述:** cmd 参数为 NULL。

**预期:** 函数返回 -1，不崩溃。

**判定:**
- PASS: 返回 -1
- FAIL: 崩溃

---

### TC-072: uart_vision_send_raw_json — json_str 为 NULL

**描述:** json_str 参数为 NULL。

**预期:** 函数返回 -1。

**判定:**
- PASS: 返回 -1
- FAIL: 崩溃

---

### TC-073: 未知命令处理

**描述:** 发送业务逻辑不认识的 cmd。

**输入:**
```json
{"cmd":"nonexistent_command","seq":159,"data":{}}
```

**预期输出:**
```json
{"cmd":"nonexistent_command","seq":159,"code":-99,"msg":"unknown cmd"}
```

**判定:**
- PASS: code=-99
- FAIL: 崩溃或无响应

---

### TC-074: biz_cmd_outbound — SLE 发送 unbind 失败的降级

**描述:** SLE 已连接但 unbind 发送失败，应降级为本地移除。

**输入:**
```json
{"cmd":"outbound","seq":160,"data":{"tag_id":1}}
```

**预期日志:**
```
[WS63_BIZ] outbound unbind send fail, remove locally
```

**预期输出:**
```json
{"cmd":"outbound","seq":160,"code":0,"msg":"ok","data":{"tag_id":1}}
```

**判定:**
- PASS: 降级成功，tag 本地移除
- FAIL: 等待超时或 tag 未移除

---

### TC-075: pending 超时后 inbound 清理

**描述:** inbound 命令超时后，已分配的 tag 应被清理。

**输入:**
```json
{"cmd":"inbound","seq":161,"data":{"zone":"A1","item":"Timeout Test"}}
```

**预期:** 5 秒后超时，tag 被移除。

**预期输出:**
```json
{"cmd":"inbound","seq":161,"code":-10,"msg":"timeout"}
```

**判定:**
- PASS: code=-10, tag 不在表中
- FAIL: tag 残留

---

## 四、Protocol Compatibility（协议兼容性测试）

### TC-080: ESP32 type→cmd 回退 — task_done

**描述:** ESP32 使用 "type" 字段发送 task_done，WS63 应正确处理。

**输入 (模拟 ESP32):**
```json
{"type":"task_done","task":"register","result":"success"}
```

**预期:** business_logic 收到 cmd="task_done"。

**判定:**
- PASS: 正确分发到 biz_handle_esp32_msg
- FAIL: 报 "missing cmd/type field"

---

### TC-081: ESP32 type→cmd 回退 — mqtt_connected

**输入:**
```json
{"type":"mqtt_connected","broker":"mqtt.example.com"}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-082: ESP32 type→cmd 回退 — mqtt_error

**输入:**
```json
{"type":"mqtt_error","msg":"connection refused"}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-083: ESP32 type→cmd 回退 — mqtt_publish_result

**输入:**
```json
{"type":"mqtt_publish_result","topic":"v1/devices/me/telemetry","code":0}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-084: ESP32 type→cmd 回退 — l610_error

**输入:**
```json
{"type":"l610_error","msg":"AT timeout"}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-085: ESP32 type→cmd 回退 — l610_at_result

**输入:**
```json
{"type":"l610_at_result","result":"OK"}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-086: ESP32 type→cmd 回退 — l610_status

**输入:**
```json
{"type":"l610_status","state":1}
```

**预期:** 转发到串口屏幕。

**判定:**
- PASS: 正确转发
- FAIL: 消息丢失

---

### TC-087: biz_map_esp32_task — register 映射为 inbound/register

**描述:** ESP32 返回 task="register"，映射后应与 pending.cmd 匹配。

**测试场景 1 (pending=register):**
- pending.cmd = "register"
- ESP32 task = "register"
- biz_map_esp32_task("register") 返回 "register"（wait -- 需要确认映射逻辑）

**代码分析:**
```c
static const char *biz_map_esp32_task(const char *task)
{
    if (task == NULL) return "unknown";
    if (strcmp(task, "register") == 0) return "inbound";  // 映射为 "inbound"
    return task;
}
```

**关键发现:** `biz_map_esp32_task("register")` 返回 `"inbound"` 而非 `"register"`。

**测试场景 1 (pending=inbound):**
- pending.cmd = "inbound"
- ESP32 task = "register" -> mapped = "inbound"
- strcmp("inbound", "inbound") == 0 -> 匹配成功

**测试场景 2 (pending=register):**
- pending.cmd = "register"
- ESP32 task = "register" -> mapped = "inbound"
- strcmp("inbound", "register") != 0 -> 不匹配！

**问题:** 当 biz_cmd_register 设置 pending.cmd="register" 时，ESP32 返回 task="register" 被映射为 "inbound"，与 pending.cmd="register" 不匹配。

**但注意:** 在 biz_sle_notify_cb 中，bind 成功后 register 流程不走 biz_clear_pending，而是保持 pending 等 ESP32 回复。此时 pending.cmd 仍然是 "register"。

**判定:**
- 发现潜在 BUG: biz_cmd_register 设置 pending.cmd="register"，但 biz_map_esp32_task 将 "register" 映射为 "inbound"，导致 task_done 永远无法匹配 pending.cmd="register"。
- **建议修复:** 将 biz_cmd_register 中的 `biz_set_pending("register", ...)` 改为 `biz_set_pending("inbound", ...)`，或者修改 biz_map_esp32_task 使 "register" 映射为 "register"。

---

### TC-088: biz_cmd_passthrough_to_esp32 — 扁平 JSON 与 ESP32 预期对齐

**描述:** 验证 passthrough 发送的 JSON 格式符合 ESP32 预期的扁平格式。

**输入:**
```json
{"cmd":"l610_at","seq":162,"data":{"at_cmd":"AT+CSQ","timeout":3000}}
```

**预期 ESP32 收到:**
```json
{"cmd":"l610_at","seq":162,"at_cmd":"AT+CSQ","timeout":3000}
```

**判定:**
- PASS: 扁平格式，data 字段被合并
- FAIL: 保留 data 嵌套

---

### TC-089: 单待处理槽约束 — 新命令覆盖旧 pending

**描述:** 当有一个 pending 命令未完成时，新命令的行为。

**前置条件:** 已发送 inventory（pending 活跃，5s 超时）

**操作:** 在 inventory pending 期间发送 inbound。

**预期:** inbound 应能正常执行（当前代码不检查是否有其他 pending，新命令会覆盖旧 pending）。

**注意:** 这是设计上的已知约束（单待处理槽），验证行为是否符合预期。

**判定:**
- PASS: 新命令覆盖旧 pending，旧命令最终超时
- FAIL: 崩溃或死锁

---

### TC-090: NV 存储持久性 — 断电恢复

**描述:** 注册标签后断电重启，验证标签映射表从 NV 恢复。

**操作:**
1. 注册 2-3 个标签
2. 通过 list 确认标签存在
3. 重启 WS63
4. 再次发送 list

**预期:** 重启后 list 返回相同的标签列表。

**判定:**
- PASS: 标签数据完整恢复
- FAIL: 标签丢失或数据损坏

---

### TC-091: NV 数据损坏恢复

**描述:** NV 数据被损坏时，系统应优雅降级。

**前置条件:** 需要通过工具修改 NV 区域或模拟读取失败

**预期日志:**
```
[WS63_BIZ] nv read fail ret=0xXXXX
[WS63_BIZ] nv load fail, start empty
```

**预期:** count=0, next_id=1, 系统正常运行。

**判定:**
- PASS: 降级为空表，不崩溃
- FAIL: 崩溃或使用损坏数据

---

### TC-092: 多 ESP32 状态消息快速到达

**描述:** 连续发送多个 ESP32 状态消息，验证不干扰 pending。

**前置条件:** 有活跃 pending

**操作:** 快速连续发送:
```json
{"type":"mqtt_connected","broker":"a"}
{"type":"mqtt_publish_result","code":0}
{"type":"l610_status","state":1}
```

**预期:** 三个消息均转发到串口，pending 不受影响。

**判定:**
- PASS: 所有消息正确转发
- FAIL: 消息丢失或 pending 被错误清除

---

### TC-093: biz_cmd_passthrough — capture_progress 消息处理

**描述:** ESP32 上报 capture_progress，验证正确分发。

**输入:**
```json
{"type":"capture_progress","step":"focus","percent":50}
```

**预期:** business_logic 层收到 cmd="capture_progress"，但当前代码中 capture_progress 在 uart_cmd_handler 的 ESP32 上游分支中，会调用 biz_handle_esp32_msg，但 biz_handle_esp32_msg 不认识 "capture_progress"（不属于 task_done/error/status 系列），走 else 分支打印 "unknown msg"。

**判定:**
- PASS: 打印 unknown msg 日志，不崩溃
- FAIL: 崩溃或意外行为

---

### TC-094: biz_cmd_passthrough — asset_list 和 system_info 消息处理

**描述:** ESP32 上报 asset_list 和 system_info，这些在 uart_cmd_handler 中被路由到 biz_handle_esp32_msg。

**输入:**
```json
{"type":"asset_list","assets":[{"id":1,"name":"USB-C"}]}
```

**预期:** biz_handle_esp32_msg 中 cmd="asset_list" 不匹配 task_done/error/status 系列，走 else 分支。

**判定:**
- PASS: 打印 unknown msg 日志
- FAIL: 崩溃

---

### TC-095: 完整 register 流程中断电恢复

**描述:** register 流程中（SLE bind 已发送，等待响应），断电重启。

**操作:**
1. 发送 register
2. 在 BS21E 响应前断电
3. 重启后检查标签表

**预期:** 由于 pending 未完成且 NV 可能已写入新 tag，重启后该 tag 状态为 IDLE（bind 未确认）。

**判定:**
- PASS: 系统正常启动，tag 存在但状态为 IDLE
- FAIL: 系统崩溃或 tag 数据不一致

---

## 五、测试执行检查表

| 测试组 | 用例数 | 通过 | 失败 | 阻塞 |
|--------|--------|------|------|------|
| Functional | 22 (TC-001 ~ TC-022) | | | |
| Edge Cases | 21 (TC-030 ~ TC-050) | | | |
| Error Handling | 16 (TC-060 ~ TC-075) | | | |
| Protocol Compatibility | 16 (TC-080 ~ TC-095) | | | |
| **总计** | **75** | | | |

## 六、已知问题

### BUG-001: biz_cmd_register 的 pending.cmd 与 biz_map_esp32_task 映射不匹配

**严重程度:** 高

**描述:** `biz_cmd_register()` 调用 `biz_set_pending("register", seq, tag_id)`，但 `biz_map_esp32_task("register")` 返回 `"inbound"`。当 ESP32 返回 `task_done` 时，mapped="inbound" 与 pending.cmd="register" 不匹配，导致 register 流程永远无法收到 ESP32 的 task_done 确认，最终超时。

**影响:** register 命令的第二阶段（ESP32 视觉处理确认）永远无法成功，总是超时返回 code=-10。

**修复建议:**
- 方案 A: 在 `biz_sle_notify_cb` 的 register bind 成功分支中，将 `biz_set_pending("register", ...)` 改为 `biz_set_pending("inbound", ...)`，使 pending.cmd 与 mapped 一致。
- 方案 B: 修改 `biz_map_esp32_task()` 使 "register" 映射为 "register"（但这会影响 inbound 流程的 task 映射）。
- 方案 C: 在 biz_cmd_register 中设置 pending 时使用 "register"，但在 biz_sle_notify_cb 的 bind 成功后将 pending.cmd 更新为 "inbound"（不调用 biz_set_pending，直接修改字段）。

**推荐:** 方案 C，因为 register 流程是 SLE bind -> ESP32 register，两个阶段的 pending.cmd 需要不同。
