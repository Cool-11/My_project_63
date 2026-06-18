# 协议文档 1：WS63 ↔ BS21E (SLE/SSAP)

> 物理层：NearLink SLE 无线通信
> 传输层：SSAP 协议（类 BLE GATT）
> 应用层：自定义二进制协议

## 1. 连接拓扑

```
┌──────────┐    SLE 无线     ┌──────────┐
│  WS63    │◄──────────────►│  BS21E   │
│ (Client) │   SSAP 协议     │ (Server) │
│  网关     │                │  电子标签  │
└──────────┘                └──────────┘
```

- WS63 作为 SLE Client（主动扫描、主动连接）
- BS21E 作为 SLE Server（被动广播、被动响应）
- 一个 WS63 可连接多个 BS21E（当前代码限制单连接，待扩展）

## 2. SSAP 服务结构

| 项目 | UUID (128-bit) | 短 UUID | 说明 |
|------|----------------|---------|------|
| Application | `0000FFFF-0000-1000-8000-5F9B34FB` | 0xFFFF | 应用注册 |
| Service | `0000FF00-0000-1000-8000-5F9B34FB` | 0xFF00 | 主服务 |
| Property | `0000FF01-0000-1000-8000-5F9B34FB` | 0xFF01 | 读写+通知属性 |
| CCCD | 标准 0x2902 | - | 客户端配置描述符（启用 Notify） |

属性权限：
- Property(0xFF01)：Read + Write + Notify
- CCCD：Read + Write

## 3. 广播数据格式

BS21E 持续广播，WS63 通过扫描获取数据。

### 3.1 Manufacturer Data (AD Type=0xFF)

| 偏移 | 长度 | 内容 | 字节序 | 说明 |
|------|------|------|--------|------|
| 0 | 1 | 0x0F | - | AD 长度 (15) |
| 1 | 1 | 0xFF | - | AD Type: Manufacturer Specific |
| 2 | 1 | 0x5A | - | Manufacturer ID 低字节 |
| 3 | 1 | 0xA5 | - | Manufacturer ID 高字节 (=0xA55A) |
| 4 | 4 | 0xAA 0xBB 0xCC 0xDD | 大端 | Magic 校验值 |
| 8 | 2 | tag_id | 大端 | 标签 ID |
| 10 | 2 | qty | 大端 | 库存数量 |
| 12 | 1 | status | - | 0x00=正常, 0x01=寻物中, 0x02=缺货 |
| 13 | 1 | battery | - | 电池百分比 (0~100) |
| 14 | 2 | seq | 大端 | 序列号（每次数据变化递增） |

### 3.2 Scan Response Data (Local Name)

| 偏移 | 长度 | 内容 | 说明 |
|------|------|------|------|
| 0 | 1 | 0x02 | AD 长度 |
| 1 | 1 | 0x0C | AD Type: TX Power Level |
| 2 | 1 | 0x00 | TX 功率 0dBm |
| 3 | 1 | 0x0A | 名称长度+1 |
| 4 | 1 | 0x0B | AD Type: Complete Local Name |
| 5 | 9 | "BS2x_Tag" | 本地名称 |

## 4. 连接参数

| 参数 | 值 | 单位 | 实际时间 | 说明 |
|------|-----|------|----------|------|
| 广播间隔 | 0xC8 (200) | 125us | 500ms | 广播频率 |
| 连接间隔 | 0x64 (100) | 0.625ms | 62.5ms | 双方一致 |
| 连接延迟 | 0x0F (15) | slots | 最大静默 937.5ms | BS21E 端设置 |
| 监督超时 | 0x1F4 (500) | 10ms | 5s | 超过此时间判定断连 |
| MTU | 512 | bytes | - | WS63 请求值 |

## 5. SSAP 命令协议

### 5.1 命令格式 (WS63 → BS21E)

通过 SSAP Write 发送到 Property(0xFF01)。

| 命令 | 字节[0] | 长度 | 附加数据 | 说明 |
|------|---------|------|----------|------|
| STOP_FIND | 0x00 | 1 | 无 | 停止寻物 |
| FIND | 0x01 | 1 | 无 | 触发蜂鸣器/LED |
| INVENTORY | 0x02 | 1 | 无 | 请求盘点数据 |
| UPDATE_QTY | 0x10 | 3 | [qty_hi, qty_lo] 大端 | 更新库存数量 |
| BIND_TAG | 0x20 | 3 | [tag_id_hi, tag_id_lo] 大端 | 绑定标签 ID |

### 5.2 响应格式 (BS21E → WS63)

通过 SSAP Notify 从 Property(0xFF01) 发送。

| 响应 | 字节[0] | 长度 | 字段布局 | 说明 |
|------|---------|------|----------|------|
| INVENTORY_RSP | 0x82 | 9 | [cmd, tag_id_hi, tag_id_lo, qty_hi, qty_lo, status, battery, seq_hi, seq_lo] | 盘点回复 |
| BIND_OK | 0xA0 | 3 | [cmd, tag_id_hi, tag_id_lo] | 绑定成功 |
| BIND_FAIL | 0xAF | 3 | [cmd, tag_id_hi, tag_id_lo] | 绑定失败（已被其他网关绑定） |

**所有多字节字段均为大端序（Big-Endian）。**

## 6. 连接流程

```
WS63                              BS21E
  │                                 │
  │  1. enable_sle()                │
  │  2. start_scan()                │
  │                                 │
  │◄─── 广播 (Manufacturer Data) ───│  BS21E 持续广播
  │                                 │
  │  3. 解析广播，匹配目标           │
  │  4. stop_scan()                 │
  │  5. connect()                   │
  │────────────────────────────────►│
  │                                 │
  │◄──────── CONNECTED ────────────│
  │                                 │
  │  6. pair()                      │
  │────────────────────────────────►│
  │◄──────── PAIRED ───────────────│
  │                                 │
  │  7. ssap_exchange_info (MTU)    │
  │────────────────────────────────►│
  │◄──────── MTU 协商完成 ─────────│
  │                                 │
  │  8. find_structure (Service)    │
  │────────────────────────────────►│
  │◄──────── UUID 0xFF00 ─────────│
  │                                 │
  │  9. find_structure (Property)   │
  │────────────────────────────────►│
  │◄──────── UUID 0xFF01 ─────────│
  │                                 │
  │  10. write_cccd [0x01, 0x00]    │
  │────────────────────────────────►│
  │◄──────── CCCD 写入确认 ───────│
  │                                 │
  │  === SSAP READY ===             │
  │                                 │
  │  11. write_cmd (INVENTORY)      │
  │────────────────────────────────►│
  │◄──────── Notify (0x82 数据) ───│
  │                                 │
  │  12. write_cmd (BIND_TAG)       │
  │────────────────────────────────►│
  │◄──────── Notify (0xA0/0xAF) ──│
```

## 7. 断连恢复

- BS21E 断连后自动重启广播
- WS63 检测到断连后自动重启扫描
- 连接/配对失败时：解除配对 → 等待 1 秒 → 重新扫描
- SSAP 状态全部重置（property_handle, cccd_written 等）

## 8. NV 存储

| 设备 | NV Key | 数据 | 说明 |
|------|--------|------|------|
| BS21E | 0x3000 | MAC 地址 (6B) | 首次启动随机生成，永久保存 |
| BS21E | 0x3001 | tag_id (2B) | 绑定时写入，掉电保持 |
| WS63 | 0x5001 | 标签映射表 (~1154B) | 最多 32 个标签 |
