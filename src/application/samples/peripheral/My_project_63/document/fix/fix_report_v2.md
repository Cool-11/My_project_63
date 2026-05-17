# WS63 端代码排查与修复报告 v2

> 日期：2026-05-13
> 排查范围：WS63 端全部源码 + BS21E 端 My_project_2x 对照验证

## 修复总览

| 编号 | 严重度 | 模块 | 问题 | 影响 | 状态 |
|------|--------|------|------|------|------|
| FIX-01 | **P0** | shared_protocol | Notify 响应解析用小端，BS21E 发大端 | 盘点/绑定回复 tag_id/qty/seq 全部读反 | ✅ 已修复 |
| FIX-02 | **P0** | shared_protocol | Write 命令打包用小端，BS21E 期望大端 | 发送 tag_id=1，BS21E 收到 256 | ✅ 已修复 |
| FIX-03 | **P0** | sle_network | 本地 MAC 地址硬编码 `13:67:5C:07:00:51` | 换板子后无法通信 | ✅ 已修复 |
| FIX-04 | **P1** | sle_network | `MY63_TARGET_TAG_ID=0` 导致所有已绑定标签被过滤 | 无法连接 tag_id>0 的标签 | ✅ 已修复 |
| FIX-05 | **P1** | cloud_storage | MQTT `MQTTClient_connect()` 阻塞主循环 | 网络延迟时 UART/SLE 全部卡死 | ⚠️ 已知风险 |
| FIX-06 | **P2** | business_logic | 无标签离线检测机制 | 标签断电后状态永远是 ONLINE | 待实现 |
| FIX-07 | **P1** | sle_network | MTU 请求 1500 超出 SDK 样例范围 | 可能导致 MTU 协商异常 | ✅ 已修复 |

---

## FIX-01: Notify 响应大小端解析错误 (P0)

### 根因

BS21E 端 `shared_proto_serialize_inventory_rsp()` 使用 `proto_write_u16_be()` 序列化，所有多字节字段为**大端序**：
```c
// BS21E shared_protocol.c:71-75
proto_write_u16_be(&buf[1], rsp->tag_id);   // 大端: [hi, lo]
proto_write_u16_be(&buf[3], rsp->qty);      // 大端: [hi, lo]
proto_write_u16_be(&buf[7], rsp->seq);      // 大端: [hi, lo]
```

WS63 端 `shared_protocol_unpack_inventory()` 使用 `read_le16()` 解析：
```c
// WS63 shared_protocol.c:220-224 (修复前)
out->tag_id = read_le16(&buf[1]);   // 小端: [lo, hi] — 错误!
out->qty = read_le16(&buf[3]);      // 小端: [lo, hi] — 错误!
out->seq = read_le16(&buf[7]);      // 小端: [lo, hi] — 错误!
```

### 影响

- tag_id=1 (0x0001) 被读成 0x0100 = 256
- qty=50 (0x0032) 被读成 0x3200 = 12800
- seq=3 (0x0003) 被读成 0x0300 = 768

盘点回复全部字段错误，映射表更新数据完全错误。绑定回复同理。

### 为什么广播解析没问题

`shared_protocol_unpack_adv()` 有自动检测机制：先尝试 LE 读 magic，如果 magic 不匹配 0xAABBCCDD，则尝试 BE。BS21E 发送 `AA BB CC DD`，LE 读成 `0xDDCCBBAA` 不匹配，BE 读成 `0xAABBCCDD` 匹配，后续字段用 BE 解析。所以广播解析是正确的。

但 `unpack_inventory()` 和 `unpack_bind_rsp()` 没有这个自动检测，直接用 `read_le16`。

### 修复

```c
// shared_protocol.c — shared_protocol_unpack_inventory()
out->tag_id = read_be16(&buf[1]);   // 修复: 大端
out->qty = read_be16(&buf[3]);      // 修复: 大端
out->seq = read_be16(&buf[7]);      // 修复: 大端

// shared_protocol.c — shared_protocol_unpack_bind_rsp()
out->tag_id = read_be16(&buf[1]);   // 修复: 大端
```

---

## FIX-02: Write 命令大小端打包错误 (P0)

### 根因

WS63 端 `shared_protocol_pack_write_cmd()` 使用 `write_le16()` 打包参数：
```c
// WS63 shared_protocol.c:285 (修复前)
write_le16(&out_buf[1], param);  // 小端: [lo, hi]
```

BS21E 端 `shared_proto_parse_unicast_cmd()` 使用大端序解析：
```c
// BS21E shared_protocol.c:178,185
cmd->qty = ((uint16_t)data[1] << 8) | (uint16_t)data[2];     // 大端
cmd->tag_id = ((uint16_t)data[1] << 8) | (uint16_t)data[2];  // 大端
```

### 影响

- 发送 `SSAP_CMD_BIND_TAG` + tag_id=1 → WS63 发 `[0x20, 0x01, 0x00]` → BS21E 读成 tag_id=256
- 发送 `SSAP_CMD_UPDATE_QTY` + qty=50 → WS63 发 `[0x10, 0x32, 0x00]` → BS21E 读成 qty=12800

入库绑定和数量更新全部失败。

### 修复

新增 `write_be16()` 函数，`pack_write_cmd()` 改用大端打包：
```c
static void write_be16(uint8_t *buf, uint16_t value)
{
    buf[0] = (uint8_t)((value >> 8) & 0xFFU);
    buf[1] = (uint8_t)(value & 0xFFU);
}

// pack_write_cmd 中:
write_be16(&out_buf[1], param);  // 修复: 大端
```

---

## FIX-03: WS63 本地 MAC 地址硬编码 (P0)

### 根因

`sle_network.c:436` 硬编码了本地地址：
```c
uint8_t local_addr[SLE_ADDR_LEN] = {0x13, 0x67, 0x5c, 0x07, 0x00, 0x51};
```

### 影响

换一块 WS63 开发板，MAC 地址不同，但代码仍然设置这个固定地址。SLE 协议层使用的本地地址与实际硬件 MAC 不匹配，可能导致：
- 连接建立后被对端拒绝
- 地址冲突

### 修复

改为使用 SDK 接口 `sle_get_local_addr()` 获取真实 MAC，失败时才用 fallback：
```c
sle_addr_t local_address = {0};
if (sle_get_local_addr(&local_address) == ERRCODE_SLE_SUCCESS) {
    // 使用真实地址
} else {
    // fallback to hardcoded
}
sle_set_local_addr(&local_address);
```

---

## FIX-04: tag_id 过滤器导致无法连接已绑定标签 (P1)

### 根因

```c
#define MY63_TARGET_TAG_ID  0
```

扫描回调中的过滤逻辑：
```c
if (adv.tag_id == 0) {        // 跳过未绑定标签
    return;
}
if (adv.tag_id != 0) {        // 跳过所有已绑定标签! 矛盾!
    return;
}
```

当 `MY63_TARGET_TAG_ID=0` 时：
- tag_id=0 的广播被跳过（"invalid"）
- tag_id>0 的广播被跳过（"mismatch target=0"）
- **所有广播都被跳过，永远无法连接**

### 影响

系统只能通过 local_name fallback 连接（降级模式），无法读取广播中的 tag_id/qty 等信息。

### 修复

```c
if (MY63_TARGET_TAG_ID != 0 && adv.tag_id != MY63_TARGET_TAG_ID) {
    // 只在指定了目标 tag_id 时才过滤
    return;
}
```

当 `MY63_TARGET_TAG_ID=0` 时接受所有有效广播，支持多标签扫描。

---

## FIX-05: MQTT 同步 API 阻塞主循环 (P1, 已知风险)

### 根因

`cloud_storage.c` 使用 Paho MQTT 同步 API：
- `MQTTClient_connect()` — 阻塞直到连接成功或超时 (10秒)
- `MQTTClient_waitForCompletion()` — 阻塞直到发布确认 (5秒)

这些调用在 `cloud_storage_poll()` → `cs_mqtt_connect()` → `cs_mqtt_publish()` 路径上，而 `cloud_storage_poll()` 在主循环中每 10ms 调用一次。

### 影响

MQTT 连接期间（最多 10 秒），主循环被阻塞：
- UART 数据在环形缓冲区堆积，可能溢出
- SLE pending 超时误判（5 秒超时被阻塞延长）
- 心跳日志延迟

### 缓解措施（暂不修改）

当前使用场景下，MQTT 连接只在启动时和 WiFi 重连时发生，频率低。可以接受短暂阻塞。

未来优化方向：将 MQTT 操作放到独立线程，或使用异步 API。

---

## FIX-06: 无标签离线检测 (P2, 待实现)

### 现状

`biz_tag_status_t` 有 `BIZ_TAG_OFFLINE` 状态，但代码中从未设置。标签断电或离开范围后，状态永远是 `BIZ_TAG_ONLINE`。

### 建议实现

在 `business_logic_poll()` 中增加定时扫描逻辑：
- 每 60 秒检查一次所有 ONLINE 标签
- 如果某标签连续 N 次盘点未响应，标记为 OFFLINE
- 需要 BS21E 端配合：收到 inventory 命令后必须回复

---

## FIX-07: MTU 请求值超出合理范围 (P1)

### 根因

WS63 端 `sle_network.c` 中 `SLE_MTU_SIZE_DEFAULT` 设置为 1500，远超 SDK 样例范围（251~520）。

BS21E 端未调用 `ssaps_set_info()` 设置 MTU，依赖协议栈默认值（约 300）。

MTU 协商时取两端较小值，如果 WS63 请求 1500 但 BS21E 默认 300，协商结果为 300。

### 修复

将 `SLE_MTU_SIZE_DEFAULT` 从 1500 改为 512（SDK 样例范围内的安全值）。

当前最大 payload 仅 12 字节（广播字段），不会溢出。

---

## BS21E vs WS63 参数对齐确认

| 参数 | BS21E 值 | WS63 值 | 是否一致 | 备注 |
|------|----------|---------|----------|------|
| Service UUID | 0xFF00 | 0xFF00 | ✅ | 128-bit 完全一致 |
| Property UUID | 0xFF01 | 0xFF01 | ✅ | 128-bit 完全一致 |
| CCCD 位置 | Property 上 | Property 上 | ✅ | 已确认在 Property(0xFF01) 上 |
| CCCD UUID | 0x2902 | 0x2902 | ✅ | 标准 CCCD |
| Manufacturer ID | 0xA55A | 0xA55A | ✅ | LE: 5A A5 |
| Magic | 0xAABBCCDD | 0xAABBCCDD | ✅ | 大端传输 |
| 广播字段大小端 | 大端 | 自动检测 | ✅ | 修复后 notify 也用大端 |
| 命令字段大小端 | 大端(解析) | 大端(打包) | ✅ | 修复后一致 |
| 连接间隔 | 0x64 | 0x64 | ✅ | 0.625ms/slot, 62.5ms |
| 连接延迟 | 0x0F | N/A | ⚠️ | WS63 端未设置 latency |
| 监督超时 | 0x1F4 | 0x1F4 | ✅ | 5000ms |
| MTU | 默认(~300) | 512 | ✅ | 协商取较小值，当前 payload 远小于 MTU |
| Local Name | "BS2x_Tag" | "BS2x_Tag" | ✅ | 8 字节 |
| NV tag_id | 0x3001 | N/A | - | BS21E 端存储 |
| NV 标签映射 | N/A | 0x5001 | - | WS63 端存储 |

## 连接参数单位说明（已确认）

SDK 头文件对 `conn_interval_min/max` 的单位描述存在矛盾，已通过代码分析确认：

| 来源 | 说法 | 0x64 对应时间 |
|------|------|---------------|
| BS21E SDK header `sle_device_discovery.h` | 0.25ms | 25ms |
| WS63 SDK header `sle_connection_manager.h` | 0.625ms (1 slot) | 62.5ms |
| BS21E SDK 样例代码注释 | 125us | 12.5ms |

**结论**：实际单位 = 0.625ms/slot（与 BLE slot 定义一致），0x64 = 100 slots = 62.5ms。

两端都使用 0x64，参数已对齐。
