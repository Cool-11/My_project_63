# SHARED_PROTOCOL 模块文档

## 1. 角色与定位

`shared_protocol` 是 WS63 与 BS21E 之间 **SLE 广播数据与 SSAP 消息的编解码模块**，负责：
- 广播包（ADV Payload）的打包与解包
- 库存盘点响应的解析
- 标签绑定响应的解析
- SSAP 命令的打包

**定位**：SLE 通信的**协议层**，独立于 SLE 连接管理，与 `sle_network` 协同工作。

## 2. 端序兼容性设计

### 2.1 问题背景

WS63 是小端序（Little Endian）设备，BS21E 是大端序（Big Endian）设备。同一个 32 位 magic 数 `0xAABBCCDD` 在两者的内存中字节序列相反：

| 设备 | 字节序列（内存中） | 解释 |
|------|------------------|------|
| WS63 (LE) | `AA BB CC DD` | 最低字节在前 |
| BS21E (BE) | `DD CC BB AA` | 最高字节在前 |

### 2.2 解决方案：双端序自动检测

```c
// shared_protocol_unpack_adv() 核心逻辑

uint32_t magic_le = read_le32(&in_buf[0]);
if (magic_le == SHARED_PROTO_MAGIC) {
    // 小端 BS21E 或其他 LE 设备
    field->tag_id = read_le16(&in_buf[4]);
    field->qty = read_le16(&in_buf[6]);
    field->seq = read_le16(&in_buf[10]);
} else {
    // 尝试大端
    uint32_t magic_be = read_be32(&in_buf[0]);
    if (magic_be == SHARED_PROTO_MAGIC_BE) {
        // 大端 BS21E
        field->tag_id = read_be16(&in_buf[4]);
        field->qty = read_be16(&in_buf[6]);
        field->seq = read_be16(&in_buf[10]);
    } else {
        return SHARED_PROTO_ERR_MAGIC;
    }
}
```

### 2.3 字节序辅助函数

```c
static uint32_t read_le32(const uint8_t *buf)
{
    return (uint32_t)(buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24));
}

static uint32_t read_be32(const uint8_t *buf)
{
    return (uint32_t)((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]);
}

static uint16_t read_be16(const uint8_t *buf)
{
    return (uint16_t)((buf[0] << 8) | buf[1]);
}
```

## 3. 数据结构

### 3.1 广播字段 (shared_proto_adv_field_t)

```c
typedef struct __attribute__((packed)) {
    uint32_t magic;      // 0xAABBCCDD (LE) 或 0xDDCCBBAA (BE)
    uint16_t tag_id;     // 标签唯一标识
    uint16_t qty;        // 当前库存数量
    uint8_t  status;     // 状态 (0=在线)
    uint8_t  battery;    // 电量 (0-100)
    uint16_t seq;        // 序列号
} shared_proto_adv_field_t;
// 总长度: 4+2+2+1+1+2 = 12 bytes
_Static_assert(sizeof(shared_proto_adv_field_t) == 12, "must be 12 bytes");
```

### 3.2 盘点响应 (ssap_inventory_rsp_t)

```c
typedef struct __attribute__((packed)) {
    uint8_t  cmd;        // 0x82 = SSAP_RSP_INVENTORY
    uint16_t tag_id;    // 标签 ID
    uint16_t qty;        // 数量
    uint8_t  status;     // 状态
    uint8_t  battery;    // 电量
    uint16_t seq;        // 序列号
} ssap_inventory_rsp_t;
// 总长度: 1+2+2+1+1+2 = 9 bytes
_Static_assert(sizeof(ssap_inventory_rsp_t) == 9, "must be 9 bytes");
```

### 3.3 绑定响应 (ssap_bind_rsp_t)

```c
typedef struct __attribute__((packed)) {
    uint8_t  cmd;        // 0xA0=成功, 0xAF=失败
    uint16_t tag_id;    // 标签 ID
} ssap_bind_rsp_t;
// 总长度: 1+2 = 3 bytes
_Static_assert(sizeof(ssap_bind_rsp_t) == 3, "must be 3 bytes");
```

## 4. SSAP 命令

| 命令名 | 值 | 说明 |
|--------|-----|------|
| SSAP_CMD_STOP_FIND | 0x00 | 停止查找 |
| SSAP_CMD_FIND | 0x01 | 查找标签 |
| SSAP_CMD_INVENTORY | 0x02 | 盘点 |
| SSAP_CMD_UPDATE_QTY | 0x10 | 更新数量 |
| SSAP_CMD_BIND_TAG | 0x20 | 绑定标签 |

## 5. SSAP 响应

| 响应名 | 值 | 说明 |
|--------|-----|------|
| SSAP_RSP_INVENTORY | 0x82 | 盘点响应 |
| SSAP_RSP_BIND_OK | 0xA0 | 绑定成功 |
| SSAP_RSP_BIND_FAIL | 0xAF | 绑定失败 |

## 6. CCCD 配置

```c
#define SSAP_CCCD_NOTIFY_EN 0x0001
```

Notify 特性需要写入 CCCD (Client Characteristic Configuration Descriptor) 来启用主动上报。

## 7. 核心API

### shared_protocol_init

```c
int shared_protocol_init(void);
```

空函数，当前无初始化逻辑。预留扩展。

### shared_protocol_unpack_adv

```c
int shared_protocol_unpack_adv(const uint8_t *in_buf, uint16_t in_len,
    shared_proto_adv_field_t *field);
```

解包广播数据。自动检测 LE/BE 字节序。

**参数**：
- `in_buf`：输入数据缓冲
- `in_len`：数据长度（最小 12 字节）
- `field`：输出字段结构

**返回值**：
- `SHARED_PROTO_OK (0)`：成功
- `SHARED_PROTO_ERR_NULL (-1)`：空指针
- `SHARED_PROTO_ERR_LEN (-2)`：数据长度不足
- `SHARED_PROTO_ERR_MAGIC (-3)`：magic 不匹配（既不是 LE 也不是 BE）
- `SHARED_PROTO_ERR_RANGE (-4)`：字段值超出范围

### shared_protocol_pack_adv

```c
int shared_protocol_pack_adv(const shared_proto_adv_field_t *field,
    uint8_t *out_buf, uint16_t out_len);
```

打包广播数据为字节流（LE 字节序）。

**参数**：
- `field`：输入字段结构
- `out_buf`：输出缓冲（最小 12 字节）
- `out_len`：缓冲长度

**返回值**：0=成功，负数=失败

### shared_protocol_validate

```c
int shared_protocol_validate(const shared_proto_adv_field_t *field);
```

验证解包后的字段是否有效。检查：
- magic 是 LE (0xAABBCCDD) 或 BE (0xDDCCBBAA)
- tag_id > 0
- qty 在有效范围
- battery ≤ 100

**返回值**：0=有效，负数=无效

### shared_protocol_unpack_inventory

```c
int shared_protocol_unpack_inventory(const uint8_t *buf, uint16_t len,
    ssap_inventory_rsp_t *out);
```

解析盘点响应。最小长度 9 字节。

**返回值**：0=成功，负数=失败

### shared_protocol_unpack_bind_rsp

```c
int shared_protocol_unpack_bind_rsp(const uint8_t *buf, uint16_t len,
    ssap_bind_rsp_t *out);
```

解析绑定响应。最小长度 3 字节。

**返回值**：0=成功，负数=失败

### shared_protocol_pack_write_cmd

```c
int shared_protocol_pack_write_cmd(uint8_t cmd, uint16_t param,
    uint8_t *out_buf, uint16_t out_len);
```

打包 SSAP 写命令。输出格式为 3 字节：`CMD(1) + PARAM(2)`。

## 8. Magic 宏定义

```c
#define SHARED_PROTO_MAGIC     0xAABBCCDD  // 小端格式（WS63 默认）
#define SHARED_PROTO_MAGIC_BE  0xDDCCBBAA  // 大端格式（BS21E 广播）
```

两个宏是同一个整数值在不同字节序下的表示：
- `0xAABBCCDD` 的 LE 字节序内存布局：`AA BB CC DD`
- `0xDDCCBBAA` 的 BE 字节序内存布局：`DD CC BB AA`

当 BS21E 以大端方式广播 magic 时，其字节序列为 `DD CC BB AA`，恰好等于 `SHARED_PROTO_MAGIC_BE` 的内存布局。

## 9. 调试日志关键词

| 日志关键词 | 含义 |
|-----------|------|
| `[WS63_SHARED] unpack_adv len=XX` | 开始解包 |
| `[WS63_SHARED] LE magic=0xXXXXXXXX` | 小端 magic 读取结果 |
| `[WS63_SHARED] LE magic mismatch (got XXXXXXXX vs expected XXXXXXXX)` | LE 不匹配 |
| `[WS63_SHARED] try BE raw=0xXXXXXXXX` | 尝试大端解析 |
| `[WS63_SHARED] unpack BE ok` | 大端解析成功 |
| `[WS63_SHARED] magic invalid (LE=0x%08X, BE=0x%08X)` | magic 完全无效 |
| `[WS63_SHARED] validate ok` | 字段验证通过 |
| `[WS63_SHARED] validate err: tag_id=0` | tag_id 无效 |
| `[WS63_SHARED] validate err: qty too large` | qty 超范围 |
| `[WS63_SHARED] validate err: battery>100` | 电量超范围 |

## 10. 依赖关系

```
shared_protocol
└── stdint.h (内置)
```

无外部依赖，纯数据编解码模块。

## 11. 测试用例

### 11.1 LE magic 解包

输入（WS63 格式）：`DD CC BB AA 01 00 05 00 00 01 64 00`
- magic = `read_le32` → 0xDDCCBBAA ≠ 0xAABBCCDD
- magic_be = `read_be32` → 0xDDCCBBAA == 0xDDCCBBAA ✓
- tag_id = `read_be16` → 0x0001 = 1
- qty = `read_be16` → 0x0005 = 5
- seq = `read_be16` → 0x0064 = 100

### 11.2 长度不足

输入长度 8 字节 → 返回 `SHARED_PROTO_ERR_LEN (-2)`

### 11.3 无效 Magic

输入 magic 既不等于 0xAABBCCDD 也不等于 0xDDCCBBAA → 返回 `SHARED_PROTO_ERR_MAGIC (-3)`
