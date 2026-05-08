# app/main 模块文档

## 模块作用

系统入口和桥接层，负责模块初始化、回调注册、主循环调度。是唯一同时依赖所有子模块的**顶层协调者**，实现 business_logic 与 cloud_storage 之间的解耦桥接。

## 模块说明

### 系统启动流程

```
my63_entry()
  └→ osal_kthread_create(my63_main_task)
       └→ my63_init_modules()
            ├→ shared_protocol_init()     // 协议层初始化
            ├→ sle_network_init()         // SLE通信初始化
            ├→ uart_vision_init()         // UART通信初始化
            ├→ cloud_storage_init()       // WiFi/MQTT初始化
            ├→ business_logic_init()      // 业务逻辑初始化
            ├→ 注册cloud_storage回调      // WiFi/MQTT状态+消息回调
            ├→ 注册business_logic回调     // UART/Cloud/WiFi/MQTT回调
            ├→ 加载WiFi NV配置并自动连接
            └→ 加载MQTT NV配置（等WiFi GOT_IP后自动连接）
```

### 回调桥接机制

main.c 是 business_logic 与 cloud_storage 之间的**唯一桥梁**：

```
business_logic                    main.c (桥接)                 cloud_storage
─────────────                    ──────────────                 ─────────────
biz_cloud_publish_cb  ───────→  my63_cloud_publish_cb  ───────→  cs_mqtt_publish_telemetry()
biz_wifi_cmd_cb       ───────→  my63_wifi_cmd_cb       ───────→  cs_wifi_connect() + NV保存
biz_mqtt_cmd_cb       ───────→  my63_mqtt_cmd_cb       ───────→  cs_mqtt_connect() + NV保存
```

| 回调 | 功能 | 调用的cloud_storage API |
|------|------|------------------------|
| `my63_cloud_publish_cb` | 业务数据上报云端 | `cs_mqtt_publish_telemetry()` |
| `my63_wifi_cmd_cb` | WiFi连接+NV持久化 | `cs_wifi_connect()` + `cs_wifi_config_save_nv()` |
| `my63_mqtt_cmd_cb` | MQTT连接/断开/状态查询+NV持久化 | `cs_mqtt_connect()` + `cs_mqtt_config_save_nv()` |

### 自动重连机制

| 场景 | 触发条件 | 动作 |
|------|----------|------|
| WiFi开机自动连接 | NV中有WiFi配置 | `cs_wifi_config_load_nv()` → `cs_wifi_connect()` |
| MQTT开机自动连接 | WiFi GOT_IP + NV中有MQTT配置 | `my63_wifi_state_cb()` 中自动 `cs_mqtt_connect()` |
| WiFi断线后重连 | WiFi状态变为GOT_IP | `my63_wifi_state_cb()` 中自动 `cs_mqtt_connect()` |

### 主循环调度

```
for (;;) {
    my63_poll_uart()      // UART接收处理
    my63_poll_business()  // 业务超时检测
    my63_poll_cloud()     // DHCP轮询 + MQTT yield
    my63_poll_sle(now)    // SLE断线重扫
    my63_heartbeat(now)   // 30秒心跳日志
    osal_msleep(10)       // 10ms调度间隔
}
```

| 轮询项 | 间隔 | 功能 |
|--------|------|------|
| UART | 10ms | 环形缓冲区→JSON解析→命令分发 |
| Business | 10ms | pending命令超时检测 |
| Cloud | 10ms | DHCP获取检测 + MQTT心跳 |
| SLE | 5秒 | 断线后重新扫描 |
| Heartbeat | 30秒 | 打印系统状态摘要 |

### 心跳日志格式

```
[WS63_APP] hb sle=1/1/1 wifi=5 mqtt=2 cache=0
```

| 字段 | 含义 | 值 |
|------|------|----|
| sle | found/connected/ssap_ready | 0或1 |
| wifi | WiFi状态枚举 | 0~6 |
| mqtt | MQTT状态枚举 | 0~4 |
| cache | 离线缓存条数 | 0~16 |

### 任务配置

| 参数 | 值 |
|------|----|
| 栈大小 | 0x2000 (8KB) |
| 优先级 | 26 |
| 调度间隔 | 10ms |

## 模块定位

```
┌─────────────────────────────────────────┐
│              app/main (桥接层)              │
│  · 初始化所有模块                            │
│  · 注册回调，桥接 biz ↔ cloud               │
│  · 主循环调度                                │
│  · WiFi/MQTT自动重连                         │
├──────┬──────┬──────┬──────┬──────────────┤
│shared│ sle  │uart  │cloud │  business     │
│proto │net   │vision│store │  logic        │
└──────┴──────┴──────┴──────┴──────────────┘
```

- **依赖**：所有子模块（shared_protocol、sle_network、uart_vision、cloud_storage、business_logic）
- **被依赖**：无（顶层模块）
- **核心职责**：初始化编排 + 回调桥接 + 主循环调度

## 重点约束

1. **唯一跨层桥接点**：business_logic 与 cloud_storage 之间的所有交互必须通过 main.c 的回调，禁止直接依赖
2. **初始化顺序不可乱**：shared_protocol → sle_network → uart_vision → cloud_storage → business_logic，后续模块依赖前序模块
3. **回调中禁止阻塞**：WiFi/MQTT状态回调中不可调用阻塞函数
4. **NV加载失败不阻塞启动**：WiFi/MQTT配置加载失败时仅打印日志，系统正常启动等待UART配置
5. **主循环不可跳出**：`for(;;)` 循环是系统运行的基础，任何异常不应导致循环退出
6. **WiFi GOT_IP后才连MQTT**：MQTT依赖IP地址，必须在WiFi状态变为GOT_IP后才能连接

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_APP]` | INFO | 模块初始化、WiFi/MQTT状态变更、心跳 |
| `[WS63_APP]` | ERROR | 初始化失败、云端发布失败 |
| `[WS63_APP]` | DEBUG | 回调注册、NV加载结果 |

## 审查清单

- [ ] 初始化顺序是否正确（shared→sle→uart→cloud→biz）
- [ ] 所有4个回调是否都已注册（uart_cb、cloud_cb、wifi_cmd_cb、mqtt_cmd_cb）
- [ ] WiFi GOT_IP后是否自动连接MQTT
- [ ] NV加载失败时是否不影响系统启动
- [ ] WiFi/MQTT配置成功后是否保存到NV
- [ ] 主循环中5个poll函数是否都调用了
- [ ] 心跳日志是否包含所有关键状态
- [ ] 是否存在 business_logic 直接调用 cloud_storage 的情况（禁止）

## 验证思路

1. **完整启动**：上电后观察日志，确认5个模块依次初始化成功
2. **WiFi自动重连**：首次通过UART配置WiFi，断电重启后观察自动连接日志
3. **MQTT自动重连**：WiFi GOT_IP后观察MQTT自动连接并订阅RPC主题
4. **端到端数据流**：UART发送 `inventory` → SLE盘点 → 业务处理 → 云端上报，验证ThingsKit收到数据
5. **断线恢复**：WiFi断开后重连，验证MQTT自动重连+离线缓存补发
6. **心跳日志**：等待30秒，验证心跳日志正确反映各模块状态
7. **异常启动**：首次上电（NV为空），验证系统正常启动等待UART配置
