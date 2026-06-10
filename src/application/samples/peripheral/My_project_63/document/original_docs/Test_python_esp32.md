# WS63 ESP32 UART 命令测试报告

## 测试时间
2026-05-07 11:36

## 测试目标
模拟ESP32通过UART发送JSON命令，验证WS63固件代码逻辑的正确性，覆盖：
- UART环形缓冲区 + 换行符处理
- JSON命令解析 + seq配对
- Business Logic命令分发
- NV存储读写路径
- 云端回调桥接

---

## 问题汇总

### 问题0（阻塞性）：AT框架占用UART0 → 命令无法到达代码

| 项目 | 详情 |
|------|------|
| 现象 | `at_recv` 持续累加（71→142→215→288→361），但无 `[WS63_UART] recv cmd=` 日志 |
| 根因 | WS63固件中AT框架注册在UART0（烧录口），拦截所有数据。我们的UART回调从未被触发 |
| 影响 | **所有UART命令无法到达业务代码**，WiFi/MQTT配置无法下发 |
| 状态 | 🔴 需修复 |

**证据**：
```
[WS63_APP] at_recv 71    ← 数据到达AT框架
[WS63_APP] at_recv 142   ← 继续累积
[WS63_APP] at_recv 215   ← 永远不会被我们的代码处理
```

**解决方向**：将AT框架迁移到UART2，或在menuconfig中禁用AT框架对UART0的占用。

---

### 问题1（功能性）：环形缓冲区不支持 `\r` 换行符

| 项目 | 详情 |
|------|------|
| 现象 | 串口助手发送的JSON命令中 `\r\n` 被当作普通字符，无法识别为完整行 |
| 根因 | `uv_ring_has_newline()` 和 `uv_ring_read_line()` 只检测 `\n`（0x0A），不检测 `\r`（0x0D） |
| 位置 | `uart_vision.c` 第32-70行 |
| 影响 | 串口助手按Enter发送时，如果Enter对应 `\r\n`，第一条命令永远无法被解析 |
| 状态 | 🟡 需修复 |

**当前代码**：
```c
// uart_vision.c:37
if (g_uv_ring[i] == '\n' && dist < UV_LINE_MAX) {  // ← 只检测\n，不检测\r
    return true;
}
```

**需修改为**：
```c
if ((g_uv_ring[i] == '\n' || g_uv_ring[i] == '\r') && dist < UV_LINE_MAX) {
    return true;
}
```

---

### 问题2（非阻塞）：NV存储首次读取失败

| 项目 | 详情 |
|------|------|
| 现象 | `[WS63_BIZ] nv read fail ret=0x80003081` |
| 根因 | `0x80003081 = ERRCODE_NV_KEY_NOT_FOUND`，NV Key（0x5001/0x5002/0x5003）从未写入过flash |
| 影响 | 首次上电时正常回退到空状态，不影响启动。配置后写入NV即可 |
| 状态 | 🟢 正常行为 |

**NV Key分配**：
| Key | 用途 |
|-----|------|
| 0x5001 | business_logic 标签映射表 |
| 0x5002 | cloud_storage MQTT配置 |
| 0x5003 | cloud_storage WiFi配置 |

---

## 测试结果

```
Total: 17, Passed: 16, Failed: 1
Pass Rate: 94.1%
```

### 通过项（16项）

| 编号 | 测试项 | 结果 | 说明 |
|------|--------|------|------|
| 2.1 | 环形缓冲区 `\n` 结尾检测 | ✅ | 数据+`\n`可被正确识别为完整行 |
| 2.2 | 环形缓冲区 `\r\n` 结尾检测 | ✅ | 模拟器中`read_line`正确跳过`\r` |
| 2.3 | 无换行符检测 | ✅ | 缓冲区无数据时不产生误判 |
| 2.4 | 多条命令连续处理 | ✅ | 两条命令依次解析，seq正确 |
| 3.1 | wifi_connect seq=1 | ✅ | 命令解析正确，seq=1配对，code=0 |
| 3.2 | wifi_connect seq=99 | ✅ | seq配对正确，seq=99原样返回 |
| 3.3 | list命令 | ✅ | 返回标签计数=0 |
| 3.4 | mqtt_connect seq=6 | ✅ | 正确解析URI/ClientID/Username |
| 3.5 | inbound seq=7 | ✅ | 分配tag_id=1，zone=A1 |
| 3.6 | inventory seq=8 | ✅ | 返回盘点时间戳和标签数 |
| 3.7 | 多命令seq顺序 | ✅ | [10,11]顺序正确 |
| 4.2 | biz_uart_cmd_handler存在 | ✅ | 命令分发函数已实现 |
| 4.3 | NV Key不冲突 | ✅ | 0x5001/0x5002/0x5003三个独立Key |
| 4.4 | main.c回调桥接 | ✅ | 3个回调注册函数均已调用 |
| 4.5 | business_logic与cloud_storage解耦 | ✅ | business_logic.c不include cloud_storage.h |
| 4.6 | ThingsKit主题常量 | ✅ | `v1/devices/me/telemetry` 和 `rpc/request/+` 均已定义 |

### 失败项（1项）

| 编号 | 测试项 | 结果 | 原因 |
|------|--------|------|------|
| 4.1 | uv_ring_has_newline `\r` 支持 | ❌ | 当前代码只检测`\n`，不检测`\r` |

---

## 日志分析

### 原始日志（2026-05-07）

```
[WS63_BIZ] nv read fail ret=0x80003081  ← NV Key不存在（正常，首次启动）
[WS63_BIZ] nv load fail, start empty     ← 业务层正确回退到空状态
[WS63_UART] cmd handler registered=0x3698f2  ← UART命令回调已注册
[WS63_NET] notify callback registered cb=0x3697d0 ← SLE通知回调已注册
[WS63_BIZ] uart cb registered=0x3692ec   ← 业务层UART回调已注册
[WS63_BIZ] cloud cb registered=0x36b94e   ← 云端发布回调已注册
[WS63_BIZ] wifi cmd cb registered=0x36b7fc ← WiFi命令回调已注册
[WS63_BIZ] mqtt cmd cb registered=0x36b92a ← MQTT命令回调已注册
[WS63_CLOUD] wifi cfg nv read fail ret=0x80003081  ← WiFi NV配置不存在
[WS63_CLOUD] mqtt cfg nv read fail ret=0x80003081    ← MQTT NV配置不存在
[WS63_APP] all modules init done          ← 所有模块初始化完成
{"cmd":"list","seq":1,"data":{}}\n         ← 上位机发送的命令（到达AT框架）
at_recv 71                                  ← AT框架接收计数（持续增长）
```

### 关键结论

1. **模块初始化全部成功**：shared_protocol → sle_network → uart_vision → cloud_storage → business_logic 链路正常
2. **回调注册全部成功**：4个回调（UART/Cloud/WiFi/MQTT）均已正确注册到main.c
3. **NV首次读取失败是预期行为**：Key不存在 → 正常回退 → 不影响启动
4. **UART命令未到达业务层**：AT框架阻塞了UART0，`at_recv`持续增长证明数据被AT框架收走

---

## WiFi连不上的根因分析

WiFi配置命令 `{"cmd":"wifi_connect",...}` 发送后WS63没有反应，根因是：

```
上位机发送JSON
    ↓
AT框架拦截（UART0被占用）
    ↓
our uart_vision.c 的 uv_uart_rx_cb 从未被调用
    ↓
uv_ring 没有数据
    ↓
uv_process_ring 无事发生
    ↓
biz_uart_cmd_handler 从未被调用
    ↓
cs_wifi_connect 从未被调用
    ↓
WiFi 不连接
```

**两步解决**：
1. 将 `uart_vision.c` 的 `UV_UART_BUS` 从 1 改回 0（使用烧录口UART0的GPIO引脚）
2. 修改 menuconfig 将 `CONFIG_AT_UART` 从 0 改为 2（让AT框架占用UART2）

---

## 代码路径验证

### 正确路径（已通过）

```
wifi_connect 命令
  → AT框架（被阻塞）❌  或  uart_vision rx_cb ✅
  → uv_ring_has_newline()  ✅
  → uv_ring_read_line()    ✅
  → uv_dispatch_line()     ✅
  → biz_uart_cmd_handler() ✅
  → my63_wifi_cmd_cb()     ✅
  → cs_wifi_connect()      ✅
  → cs_wifi_config_save_nv() ✅
```

### 问题路径

```
mqtt_connect 命令
  → AT框架（UART0被占用） ❌  ← 当前问题
  → at_recv 计数增长，但业务层收不到

mqtt_publish_telemetry 回调
  → business_logic.c  ✅ 不直接include cloud_storage.h
  → 通过 biz_cloud_publish_t 回调桥接  ✅
  → main.c 的 my63_cloud_publish_cb  ✅
  → cs_mqtt_publish_telemetry() ✅
```

---

## 烧录说明

### 全量烧录 vs 增量烧录

| 方式 | 命令 | 说明 |
|------|------|------|
| 全量烧录 | 烧录整个固件（bootloader + app + resource） | 首次或重大更新时使用 |
| 增量烧录 | 只烧录 app 固件 | 调试业务代码时使用，NV区域不会被擦除 |

当前修改涉及：
- `uart_vision.c` / `uart_vision.h` → 增量烧录即可
- menuconfig 修改 → 需要重新编译后全量烧录

---

## 待修复项（按优先级）

| 优先级 | 问题 | 修复内容 | 文件 |
|--------|------|---------|------|
| P0 | AT框架占用UART0 | menuconfig: `CONFIG_AT_UART=2` | ws63_liteos_app.config |
| P0 | UART0引脚配置 | `UV_UART_BUS=0`, `TX=41`, `RX=42` | uart_vision.h |
| P1 | 环形缓冲区 `\r` 支持 | 检测 `\n` 或 `\r` | uart_vision.c |
| P2 | NV存储首次写入 | 首次配置后正常写入 | 不影响当前功能 |

---

## 测试脚本使用说明

```bash
# 安装依赖
pip install pyserial cjson

# 模拟测试（无需硬件）
python3 test_esp32_uart.py --simulate

# 真实硬件测试（需要串口）
python3 test_esp32_uart.py --port /dev/ttyUSB0 --baud 115200
```

测试脚本路径：
```
My_project_63/document/test_esp32_uart.py
```
