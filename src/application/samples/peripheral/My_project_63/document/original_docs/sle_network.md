# SLE_NETWORK 模块文档

## 1. 角色与定位

`sle_network` 是 WS63 设备的 **SLE（Smart Link Engine）通信模块**，负责：
- 扫描发现 BS21E 标签设备
- 与 BS21E 建立 SLE 连接并完成配对
- 通过 SSAP（Simple SLE Attribute Protocol）协议交换数据
- 收发库存盘点、标签绑定等业务命令

**定位**：系统的**标签通信层**，上层业务逻辑通过 `sle_network_send_cmd()` 下发 SSAP 命令，通过回调接收 BS21E 的响应数据。

## 2. 硬件与协议基础

### 2.1 设备地址

| 设备 | 地址类型 | 说明 |
|------|----------|------|
| WS63（本地） | 手动设置 | `13:67:5C:07:00:51` |
| BS21E（目标） | 扫描获取 | 从广播包中提取 |

### 2.2 UUID 配置

模块定义了完整的 128-bit UUID 树，兼容 16-bit 短 UUID：

| 用途 | 128-bit UUID | 16-bit 简化 |
|------|-------------|-------------|
| 应用 UUID | `0000FF00-0000-1000-8000-5F9B34FB` | - |
| 服务 UUID | `0000FF00-0000-1000-8000-5F9B34FB` | 0xFF00 |
| 属性 UUID | `0000FF01-0000-1000-8000-5F9B34FB` | 0xFF01 |

**UUID 索引说明**：16-bit UUID 从 128-bit UUID 的索引 14-15 字节提取：
```c
uint16_t got = uuid[14] | (uuid[15] << 8);
```

### 2.3 广播包格式（Manufacturer Data）

BS21E 广播的 manufacturer data（type=0xFF）包含 12 字节应用数据：

| 字段 | 字节偏移 | 长度 | 说明 |
|------|----------|------|------|
| Magic | 0 | 4 | 0xAABBCCDD (LE) 或 0xDDCCBBAA (BE) |
| Tag ID | 4 | 2 | 标签唯一标识 |
| Qty | 6 | 2 | 当前库存数量 |
| Status | 8 | 1 | 状态（0=在线） |
| Battery | 9 | 1 | 电量（0-100） |
| Seq | 10 | 2 | 序列号 |

## 3. 端序兼容性

### 3.1 问题背景

BS21E 作为大端（BE）设备，其广播的 magic 字段字节序为 `DD CC BB AA`。WS63 作为小端（LE）设备，需要正确解析。

### 3.2 双端序解包策略

`shared_protocol_unpack_adv()` 实现自动检测：

```
1. 使用 read_le32() 读取 magic → 得到 0xDDCCBBAA
2. 与 SHARED_PROTO_MAGIC (0xAABBCCDD) 比较 → 不匹配
3. 使用 read_be32() 读取 magic → 得到 0xDDCCBBAA
4. 与 SHARED_PROTO_MAGIC_BE (0xDDCCBBAA) 比较 → 匹配
5. 使用 read_be16() 读取其余多字节字段
```

这样同一份广播数据，只需适配 BS21E 的字节序即可正确解析。

### 3.3 宏定义

```c
#define SHARED_PROTO_MAGIC      0xAABBCCDD  // LE 格式（WS63 默认）
#define SHARED_PROTO_MAGIC_BE   0xDDCCBBAA  // BE 格式（BS21E 广播）
```

## 4. SSAP 协议流程

### 4.1 连接建立流程

```
[WS63]                          [BS21E]
   |                                |
   |  1. sle_start_seek()           |
   |------------------------------->
   |  2. 收到广播包 (ADV)             |
   |<-------------------------------|
   |  3. sle_connect_remote_device() |
   |------------------------------->
   |  4. 连接状态 CONNECTED          |
   |<-------------------------------|
   |  5. sle_pair_remote_device()    |
   |------------------------------->
   |  6. 配对完成 (PAIR_PAIRED)       |
   |<-------------------------------|
   |  7. ssapc_exchange_info_req()   |
   |------------------------------->
   |  8. ssapc_find_structure()       |
   |    (查找主服务)                  |
   |------------------------------->
   |  9. ssapc_find_structure()       |
   |    (查找属性)                    |
   |------------------------------->
   |  10. 写入 CCCD (启用 Notify)     |
   |------------------------------->
   |  11. SSAP 交换就绪               |
   |                                |
```

### 4.2 SSAP 命令

| 命令 | 值 | 参数 | 说明 |
|------|-----|------|------|
| STOP_FIND | 0x00 | - | 停止查找 |
| FIND | 0x01 | - | 查找标签 |
| INVENTORY | 0x02 | - | 盘点所有标签 |
| UPDATE_QTY | 0x10 | qty | 更新数量 |
| BIND_TAG | 0x20 | tag_id | 绑定标签 |

### 4.3 SSAP 响应

| 响应 | 值 | 字段 | 说明 |
|------|-----|------|------|
| INVENTORY | 0x82 | tag_id, qty, status, battery, seq | 盘点响应 |
| BIND_OK | 0xA0 | tag_id | 绑定成功 |
| BIND_FAIL | 0xAF | tag_id | 绑定失败 |

## 5. 核心API

### sle_network_init

```c
int sle_network_init(void);
```

初始化 SLE 子系统。执行：
1. 注册扫描回调（seek_result_cb）
2. 注册连接回调（connect_state_changed_cb, auth_complete_cb, pair_complete_cb）
3. 注册 SSAP 回调
4. 调用 `enable_sle()` 使能 SLE

**注意**：此函数执行后 SLE 使能是异步的，`my63_sle_enable_cb` 回调中才完成后续扫描启动。

### sle_network_start_scan / stop_scan

```c
int sle_network_start_scan(void);
int sle_network_stop_scan(void);
```

启动/停止 BLE 广播扫描。使用主动扫描（SLE_SEEK_ACTIVE），扫描间隔 200ms，窗口 80ms。

### sle_network_send_cmd

```c
int sle_network_send_cmd(uint8_t cmd, uint16_t param);
```

发送 SSAP 命令。前提条件：
- `g_my63_connected == 1`
- `g_my63_property_handle != 0`
- `g_my63_cccd_written == 1`（Notify 已启用）

返回值：0=成功，负数=失败。

### sle_network_is_ssap_ready

```c
int sle_network_is_ssap_ready(void);
```

返回 1 当且仅当：已连接 + 属性句柄有效 + CCCD 已写入。

### sle_network_register_notify_cb

```c
void sle_network_register_notify_cb(sle_notify_callback cb);
```

注册 Notify 回调，接收 BS21E 主动上报的数据（盘点结果、绑定结果等）。

回调类型：
```c
typedef void (*sle_notify_callback)(const ssap_inventory_rsp_t *inv,
    const ssap_bind_rsp_t *bind);
```

## 6. 状态机

### 6.1 全局状态变量

| 变量 | 类型 | 说明 |
|------|------|------|
| g_my63_target_found | int | 是否发现目标设备 |
| g_my63_connecting | int | 是否正在连接 |
| g_my63_connected | int | 是否已连接 |
| g_my63_authenticated | int | 是否已认证/配对 |
| g_my63_ssap_ready | int | SSAP 交换是否就绪 |
| g_my63_property_handle | uint16_t | 属性句柄 |
| g_my63_cccd_written | int | CCCD 是否已写入 |
| g_my63_scan_result_count | uint32_t | 扫描结果计数 |

### 6.2 连接状态枚举（字符串化）

| 枚举值 | 含义 |
|--------|------|
| SLE_ACB_STATE_NONE | 无连接 |
| SLE_ACB_STATE_CONNECTED | 已连接 |
| SLE_ACB_STATE_DISCONNECTED | 已断开 |

### 6.3 配对状态枚举

| 枚举值 | 含义 |
|--------|------|
| SLE_PAIR_NONE | 未配对 |
| SLE_PAIR_PAIRING | 配对中 |
| SLE_PAIR_PAIRED | 已配对 |

## 7. 关键调试日志

### 7.1 扫描发现阶段

| 日志关键词 | 含义 |
|-----------|------|
| `[WS63_NET] seek result #N rssi=XX` | 第 N 个扫描结果，RSSI |
| `[WS63_NET] RAW PAYLOAD len=XX: XX...` | 原始广播数据 |
| `[WS63_NET] local_name matched` | 设备名匹配（BS2x_Tag） |
| `[WS63_NET] uuid_match: XX-bit MATCH/MISMATCH` | UUID 比对结果 |
| `[WS63_NET] adv matched tag=N` | 广播数据解析成功 |
| `[WS63_NET] connect target addr=XX:XX:...` | 开始连接 |

### 7.2 SSAP 交换阶段

| 日志关键词 | 含义 |
|-----------|------|
| `[WS63_NET] start_ssap_exchange check: connected=X conn_id=X` | SSAP 交换前置检查 |
| `[WS63_NET] ssapc_exchange_info_req ret=0xX` | SSAP 交换请求返回值 |
| `[WS63_NET] ssap exchange info ... mtu=X version=X` | SSAP 交换信息 |
| `[WS63_NET] ssap find structure: start_hdl=0xXXXX` | 发现服务结构 |
| `[WS63_NET] ssap service MATCHED` | 服务 UUID 匹配 |
| `[WS63_NET] ssap property MATCHED handle=0xXXXX` | 属性 UUID 匹配 |
| `[WS63_NET] write_cccd handle=0xXXXX` | 写入 CCCD |
| `[WS63_NET] CCCD write SUCCESS` | CCCD 写入成功 |

### 7.3 连接状态

| 日志关键词 | 含义 |
|-----------|------|
| `[WS63_NET] conn state change ... state=CONNECTED` | 连接建立 |
| `[WS63_NET] pair complete PAIR_PAIRED` | 配对完成 |
| `[WS63_NET] disconnected, reason=X` | 连接断开 |

## 8. 常见问题排查

### 8.1 扫描不到 BS21E

**检查项**：
1. BS21E 是否上电并广播？
2. WS63 天线是否正常？
3. `g_my63_scan_active` 是否为 1？
4. 串口日志中是否有 `[WS63_NET] seek result`？

### 8.2 能扫描到但不触发 SSAP 交换

**检查项**：
1. `[WS63_NET] adv payload not matched or magic invalid` → 广播格式不匹配
2. `[WS63_NET] adv tag_id mismatch=N` → tag_id 不是目标值
3. Magic 字段是 LE 还是 BE？是否正确识别？

### 8.3 SSAP 服务发现失败

**检查项**：
1. `[WS63_NET] ssap service uuid not matched` → 服务 UUID 不匹配
2. `[WS63_NET] ssap find structure: service=null status=0xX` → 服务发现返回错误
3. UUID 十六进制值是否与 BS21E 固件一致？

### 8.4 CCCD 写入失败

**检查项**：
1. `[WS63_NET] CCCD write FAILED status=0xX` → 写入返回错误码
2. 属性是否支持 Notify（`operate_indication & SSAP_OPERATE_INDICATION_BIT_NOTIFY`）？

## 9. 依赖关系

```
sle_network
├── soc_osal.h
├── securec.h
├── common_def.h
├── sle_device_discovery.h    设备扫描
├── sle_connection_manager.h 连接管理
├── sle_errcode.h            错误码
├── sle_ssap_client.h        SSAP 客户端
└── shared_protocol.h        协议编解码
```

## 10. 配置参数

| 宏 | 值 | 说明 |
|----|-----|------|
| SLE_MTU_SIZE_DEFAULT | 1500 | SSAP MTU |
| MY63_SLE_SEEK_INTERVAL_DEFAULT | 0xC8 (200) | 扫描间隔 (ms) |
| MY63_SLE_SEEK_WINDOW_DEFAULT | 0x50 (80) | 扫描窗口 (ms) |
| MY63_SLE_DEFAULT_CONN_INTERVAL | 0x64 (100) | 连接间隔 (ms) |
| MY63_SLE_DEFAULT_TIMEOUT | 0x1F4 (500) | 连接超时 (ms) |
| MY63_SCAN_RESTART_INTERVAL_MS | 10000 | 扫描重启间隔 (ms) |
