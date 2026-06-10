# UART_VISION 模块文档

## 1. 角色与定位

`uart_vision` 是 WS63 设备的**串口命令通道模块**，负责：
- 通过 UART1 接收上位机（串口助手/ESP32）发送的 JSON 格式命令
- 解析命令并分发给业务逻辑层（`business_logic`）
- 将响应结果通过 UART1 发送回上位机

**定位**：系统的**配置/命令入口**，用于动态配置 WiFi、MQTT 连接参数，以及下发业务指令（入库/出库/盘点等）。

## 2. 通信参数

| 参数 | 值 | 说明 |
|------|-----|------|
| 总线 | UART_BUS_1 | UART1 |
| 波特率 | 115200 | |
| 数据位 | 8 | UART_DATA_BIT_8 |
| 停止位 | 1 | UART_STOP_BIT_1 |
| 校验位 | None | UART_PARITY_NONE |
| TX 引脚 | GPIO15 (S_AGPIO15) | PIN_MODE_1 复用模式 |
| RX 引脚 | GPIO16 (S_AGPIO16) | PIN_MODE_1 复用模式 |

**引脚复用模式说明**：WS63 SDK 中 `PIN_MODE_1` 是 UART 功能的标准化复用模式。所有官方 UART 示例均使用 `PIN_MODE_1`（枚举值=1）。用户指定的 mode 值 16/17 超出了 SDK `pin_mode_t` 枚举范围（0-7），因此使用 `PIN_MODE_1`。

## 3. 串口助手发送格式

### 3.1 JSON 命令帧格式

```json
{"cmd":"<命令名>","seq":<序号>,"data":<数据对象>}
```

- `cmd`：命令名字符串（必填）
- `seq`：序号，响应时会原样返回（必填）
- `data`：数据对象（可选）

### 3.2 行结束符

支持两种行结束符：
- `\r\n`（Windows 风格，串口助手推荐）
- `\r`（部分串口助手发送）
- `\n`（Unix 风格）

环形缓冲区会自动处理 `\r\n` 合并，避免出现空行。

### 3.3 示例命令

**WiFi 连接：**
```
{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}
```

**MQTT 连接：**
```
{"cmd":"mqtt_connect","seq":2,"data":{"uri":"tcp://192.168.1.100:1883","client_id":"ws63_001","username":"admin","password":"password"}}
```

**入库：**
```
{"cmd":"inbound","seq":3,"data":{"zone":"A1","item":"ITEM001"}}
```

**出库：**
```
{"cmd":"outbound","seq":4,"data":{"tag_id":1}}
```

**盘点：**
```
{"cmd":"inventory","seq":5}
```

## 4. 响应格式

模块回复 JSON 格式响应：

```json
{"cmd":"<原命令名>","seq":<序号>,"code":<状态码>,"msg":"<消息>","data":<数据>}
```

- `code`：0=成功，负数=失败
- `msg`：状态消息
- `data`：可选的返回数据

## 5. 核心API

### uart_vision_init

```c
int uart_vision_init(void);
```

初始化 UART1，配置引脚、波特率、注册接收回调。内部执行：
1. `uapi_pin_set_mode()` 设置 TX/RX 引脚为 PIN_MODE_1
2. `uapi_uart_init()` 初始化 UART1（115200, 8N1）
3. `uapi_uart_register_rx_callback()` 注册接收回调

**返回值**：0=成功，非0=失败

### uart_vision_send_json

```c
int uart_vision_send_json(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json);
```

发送 JSON 响应。先发送 JSON 字符串，再发送 `\r\n`。避免在 cJSON 缓冲区末尾追加换行符导致堆溢出。

**参数**：
- `seq`：原命令序号
- `cmd`：原命令名
- `code`：状态码
- `msg`：状态消息
- `data_json`：数据 JSON 字符串（可选）

**返回值**：0=成功，负数=失败

### uart_vision_register_cmd_handler

```c
void uart_vision_register_cmd_handler(uv_cmd_handler_t handler);
```

注册命令处理回调。当收到完整 JSON 命令行时，调用此回调。

回调类型定义：
```c
typedef void (*uv_cmd_handler_t)(const char *cmd, uint16_t seq, const char *data_json);
```

### uart_vision_poll

```c
void uart_vision_poll(void);
```

轮询处理函数。在主循环中调用，负责：
1. 检查 UART 接收超时（100ms），丢弃不完整行
2. 检测行结束符（\r 或 \n）
3. 读取完整行并分发给命令处理器

### uart_vision_ring_usage

```c
uint16_t uart_vision_ring_usage(void);
```

返回环形缓冲区当前使用量（字节数）。供主循环心跳日志监控缓冲区状态。

## 6. 环形缓冲区

### 6.1 规格

| 参数 | 值 |
|------|-----|
| 缓冲区大小 | 512 字节 |
| 单行最大长度 | 256 字节 |
| 接收超时 | 100 ms |

### 6.2 溢出处理

当缓冲区满时，新数据覆盖旧数据，丢弃计数 `g_uv_ring_drop_count` 增加。下一次 poll 时会打印丢弃数量。

### 6.3 换行符处理

- `uv_ring_has_newline()`：检测 `\r` 或 `\n` 任意一个
- `uv_ring_read_line()`：读到 `\r` 或 `\n` 时终止；遇到 `\r\n` 连续序列时自动跳过 `\n`，避免输出空行

## 7. 内部关键实现

### uv_ring_has_newline

```c
static bool uv_ring_has_newline(void)
```

遍历环形缓冲区，查找 `\r` 或 `\n`，最大检测距离 UV_LINE_MAX。找到返回 true。

### uv_ring_read_line

```c
static uint16_t uv_ring_read_line(uint8_t *out, uint16_t max_len)
```

从环形缓冲区读取一行，遇到 `\r` 或 `\n` 终止。如果遇到 `\r\n`，自动消费 `\n`。返回读取的字符数（不含终止符）。

### uv_check_timeout

```c
static void uv_check_timeout(void)
```

检查距离最后接收数据是否超过 100ms。如果缓冲区有数据但无完整行，丢弃这些不完整数据。

## 8. 注意事项

### 8.1 UART1 与 LOG 系统冲突

当前编译配置 `CONFIG_LOG_UART=1`（menuconfig），LOG 系统占用 UART1（921600 波特率）。`uart_vision_init()` 调用 `uapi_uart_deinit(UV_UART_BUS)` 会关闭并重新初始化 UART1，导致 **LOG 输出丢失或波特率不匹配**。

**解决方案**：
1. 修改 menuconfig 将 LOG 迁移到 UART2：`CONFIG_LOG_UART=2`
2. 或确认 LOG 在 deinit 之前已输出完毕

### 8.2 波特率 115200 vs LOG 921600

应用层使用 115200 波特率，LOG 系统使用 921600 波特率。共用 UART1 时会出现乱码。检查 `ws63_liteos_app.config` 中的 `CONFIG_UART1_BAUDRATE` 设置。

### 8.3 串口助手设置

推荐使用以下设置：
- 波特率：115200
- 数据位：8
- 停止位：1
- 校验位：无
- 流控制：无
- 发送格式：JSON + `\r\n` 结束

## 9. 依赖关系

```
uart_vision
├── soc_osal.h        OS 抽象层（osal_printk）
├── uart.h            UART 驱动接口
├── pinctrl.h         GPIO 引脚控制
├── cJSON.h           JSON 解析
└── tcxo.h            时间戳（超时检测）
```

## 10. 测试验证

### 10.1 串口助手测试

1. 连接 WS63 UART1（TX=GPIO15, RX=GPIO16）
2. 串口助手设置：115200, 8N1
3. 发送：`{"cmd":"wifi_connect","seq":1,"data":{"ssid":"test","psk":"test123"}}`
4. 预期响应：`{"cmd":"wifi_connect","seq":1,"code":0,"msg":"connecting"}`

### 10.2 日志关键词

| 关键词 | 含义 |
|--------|------|
| `[WS63_UART] init start` | UART 初始化开始 |
| `[WS63_UART] pin set tx=15 mode=1 rx=16 mode=1` | 引脚配置成功 |
| `[WS63_UART] init ok bus=1 baud=115200` | UART 初始化成功 |
| `[WS63_UART] dispatch line len=XX content=...` | 收到命令 |
| `[WS63_UART] recv cmd=xxx seq=XX` | 命令解析成功 |
| `[WS63_UART] send cmd=xxx seq=XX` | 响应发送 |
| `[WS63_UART] timeout drop partial line` | 超时丢弃不完整行 |
| `[WS63_UART] ring drop count=XX` | 缓冲区溢出丢弃计数 |
