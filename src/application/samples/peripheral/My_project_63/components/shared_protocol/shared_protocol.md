# shared_protocol 模块文档

## 模块作用

定义 WS63 与 BS21E 标签之间的二进制通信协议，提供协议帧的封包/解包/校验能力。是 SLE 通信层与业务层之间的**协议桥梁**。

## 模块说明

### 核心数据结构

| 结构体 | 大小 | 用途 |
|--------|------|------|
| `shared_proto_adv_field_t` | 12字节 | SLE广播字段：magic(4) + tag_id(2) + qty(2) + status(1) + battery(1) + seq(2) |
| `ssap_inventory_rsp_t` | 9字节 | 盘点响应：cmd(1) + tag_id(2) + qty(2) + status(1) + battery(1) + seq(2) |
| `ssap_bind_rsp_t` | 3字节 | 绑定响应：cmd(1) + tag_id(2) |

### 命令码定义

| 命令 | 值 | 方向 | 说明 |
|------|----|------|------|
| `SSAP_CMD_STOP_FIND` | 0x00 | WS63→BS21E | 停止寻物 |
| `SSAP_CMD_FIND` | 0x01 | WS63→BS21E | 开始寻物 |
| `SSAP_CMD_INVENTORY` | 0x02 | WS63→BS21E | 触发盘点 |
| `SSAP_CMD_UPDATE_QTY` | 0x10 | WS63→BS21E | 更新数量 |
| `SSAP_CMD_BIND_TAG` | 0x20 | WS63→BS21E | 绑定标签 |
| `SSAP_RSP_INVENTORY` | 0x82 | BS21E→WS63 | 盘点响应 |
| `SSAP_RSP_BIND_OK` | 0xA0 | BS21E→WS63 | 绑定成功 |
| `SSAP_RSP_BIND_FAIL` | 0xAF | BS21E→WS63 | 绑定失败 |

### 核心API

| 函数 | 功能 |
|------|------|
| `shared_protocol_init()` | 模块初始化 |
| `shared_protocol_pack_adv()` | 将广播字段打包为字节流 |
| `shared_protocol_unpack_adv()` | 从字节流解包广播字段 |
| `shared_protocol_validate()` | 校验magic和字段范围 |
| `shared_protocol_unpack_inventory()` | 解包盘点响应 |
| `shared_protocol_unpack_bind_rsp()` | 解包绑定响应 |
| `shared_protocol_pack_write_cmd()` | 打包SSAP写命令 |

### 字节序

所有多字节字段使用**小端序（Little-Endian）**，与WS63 RISC-V架构一致。

## 模块定位

```
┌─────────────┐
│ business_logic │  业务层：使用 ssap_inventory_rsp_t / ssap_bind_rsp_t
├─────────────┤
│ shared_protocol │  协议层：封包/解包/校验（本模块）
├─────────────┤
│  sle_network   │  传输层：SLE收发原始字节流
└─────────────┘
```

- **不依赖**任何硬件驱动或OS接口（除 `soc_osal.h` 的 `osal_printk`）
- **不被**任何上层模块直接调用封包函数，仅被 `sle_network` 调用
- 业务层只使用本模块定义的**数据结构和命令码常量**

## 重点约束

1. **结构体必须 packed**：所有结构体使用 `__attribute__((packed))`，确保与BS21E端协议对齐
2. **大小必须静态断言**：`_Static_assert` 保证结构体大小与协议定义一致，编译期拦截大小偏移
3. **Magic校验**：`0xAABBCCDD`，用于区分有效广播帧与噪声数据
4. **battery范围**：0~100，超出返回 `SHARED_PROTO_ERR_RANGE`
5. **禁止修改已有字段偏移**：协议一旦与BS21E对齐，字段顺序和大小不可变更

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_SHARED]` | ERROR | NULL指针、Magic不匹配、字段越界 |
| `[WS63_SHARED]` | INFO | 初始化完成 |

## 审查清单

- [ ] 结构体是否有 `__attribute__((packed))`
- [ ] 是否有 `_Static_assert` 校验大小
- [ ] Magic值是否为 `0xAABBCCDD`
- [ ] 新增字段是否在结构体末尾追加（不破坏已有偏移）
- [ ] 解包函数是否对输入长度做边界检查
- [ ] 多字节字段是否使用 `read_le16`/`read_le32` 读取

## 验证思路

1. **封包→解包一致性**：构造 `shared_proto_adv_field_t`，pack后再unpack，逐字段比对
2. **Magic校验**：修改magic为非法值，验证 `shared_protocol_validate()` 返回 `ERR_MAGIC`
3. **越界校验**：设置 battery=101，验证返回 `ERR_RANGE`
4. **长度不足**：传入短于协议帧的buffer，验证返回 `ERR_LEN`
5. **端序验证**：用已知值pack，检查输出字节序为小端
