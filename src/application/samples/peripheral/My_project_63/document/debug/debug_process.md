# Debug 过程与工程思维记录

> 本文档记录本次排查的完整思考过程，教你一套嵌入式跨设备联调的 debug 方法论。

## 一、排查方法论：从协议层到应用层逐层验证

### 核心原则：先确认底层，再怀疑上层

嵌入式系统出问题时，90% 的人会先怀疑业务逻辑。但实际经验表明，**底层协议不匹配才是最常见的致命错误**。

排查顺序：
```
1. 物理层：接线、电平、波特率
2. 协议层：字节序、数据结构、字段长度
3. 传输层：连接参数、MTU、超时
4. 应用层：业务逻辑、状态机、命令分发
```

本次排查直接从第 2 层（协议层）开始，因为我假设物理层已验证。

### 方法：逐字段对比法

拿同一份数据，分别在两端用人工计算验证：

```
BS21E 发送 tag_id=1:
  proto_write_u16_be(buf, 1)
  → buf[0] = 0x00, buf[1] = 0x01  (大端: 高字节在前)

WS63 接收:
  read_le16(buf) 
  → 0x00 | (0x01 << 8) = 0x0100 = 256  (小端: 低字节在前)

结论: 256 ≠ 1，字节序不匹配!
```

这种"纸上跑数据"的方法比在硬件上加断点快 10 倍。

## 二、本次排查的思考链

### Step 1: 读 BS21E 的序列化函数

```c
// BS21E shared_protocol.c
static void proto_write_u16_be(uint8_t *buf, uint16_t val)
{
    buf[0] = (uint8_t)(val >> 8);    // 高字节在前
    buf[1] = (uint8_t)(val & 0xFF);  // 低字节在后
}
```

看到函数名有 `_be` 后缀，立刻确认：**BS21E 所有多字节字段都是大端序**。

### Step 2: 检查 WS63 的反序列化函数

```c
// WS63 shared_protocol.c
static uint16_t read_le16(const uint8_t *buf)
{
    return (uint16_t)(buf[0] | ((uint16_t)buf[1] << 8));  // 低字节在前
}
```

函数名有 `_le` 前缀，确认：**WS63 用小端序读取**。

### Step 3: 检查哪里用了哪个函数

`unpack_adv()` 有自动检测：
```c
field->magic = read_le32(&in_buf[0]);
if (field->magic == SHARED_PROTO_MAGIC) {
    // LE 匹配，用 LE 读后续字段
} else {
    // 尝试 BE
    if (be_magic == SHARED_PROTO_MAGIC_BE) {
        field->tag_id = read_be16(&in_buf[4]);  // BE!
    }
}
```

但 `unpack_inventory()` 直接用 `read_le16`，没有自动检测。

**关键洞察**：同一个文件里，有的函数有自动检测，有的没有。这就是不一致的根源。

### Step 4: 验证打包方向

`pack_write_cmd()` 用 `write_le16`，但 BS21E 用大端解析：
```c
// BS21E
cmd->tag_id = ((uint16_t)data[1] << 8) | (uint16_t)data[2];  // 大端
```

WS63 发 `[0x01, 0x00]` (LE for 1)，BS21E 读成 `0x0100 = 256`。确认打包方向也错了。

## 三、工程思维：为什么这种 bug 会发生

### 根因分析

1. **开发时只测了广播**：广播解析有自动检测，所以看起来没问题。
2. **Notify 和 Write 是后加的功能**：在 Step1-Step2 开发时，广播已经能工作了。后加的 Notify 解析和 Write 打包直接复制了 LE 的写法，没有检查 BS21E 端的字节序。
3. **缺少端到端测试**：没有在真实硬件上发送一个已知值（比如 tag_id=1），然后在另一端打印确认。

### 预防措施

1. **协议文档化**：在 `shared_protocol.h` 中明确标注每个字段的字节序。
2. **编译期断言**：`_Static_assert` 只能检查大小，不能检查字节序。需要运行时自测。
3. **自测函数**：`shared_protocol_init()` 中的 pack→unpack 自测应该覆盖字节序验证。

## 四、嵌入式跨设备联调 Checklist

以后开发任何跨设备功能，按这个清单检查：

```
□ 字节序：发送端用 BE/LE？接收端用 BE/LE？一致吗？
□ 字段长度：uint16_t 还是 uint8_t？两端 sizeof 一样吗？
□ 结构体对齐：packed 吗？两端的 struct 定义完全一样吗？
□ 命令码：发送的 cmd 值和接收端的 switch-case 匹配吗？
□ 超时：发送端等多久？接收端处理要多久？会不会超时？
□ 错误处理：如果接收端处理失败，发送端怎么知道？
□ 边界值：tag_id=0 怎么处理？qty=65535 呢？空数据呢？
```

## 五、代码阅读技巧

### 快速定位字节序问题的方法

1. 搜索 `_be` 和 `_le` 关键词
2. 搜索 `<< 8` 和 `>> 8` 位移操作
3. 搜索 `memcpy` 直接拷贝结构体（通常意味着隐式字节序依赖）

### 快速理解一个模块的方法

1. 先看 `.h` 文件：了解接口和数据结构
2. 再看 `_init()` 函数：了解初始化流程
3. 再看 `_poll()` 或回调函数：了解运行时行为
4. 最后看错误处理和边界条件

### 跨设备代码的阅读顺序

1. 先看发送端的打包/序列化代码
2. 再看接收端的解析/反序列化代码
3. 逐字段对比字节序和长度
4. 用已知值手工计算验证

## 六、本次修复的验证方法

### 验证 FIX-01 (Notify 字节序)

1. ESP32 发送 `{"cmd":"inventory","seq":1,"data":{}}`
2. WS63 发送 SSAP_CMD_INVENTORY(0x02) 给 BS21E
3. BS21E 回复 `[0x82, 0x00, 0x01, 0x00, 0x32, 0x00, 0x5F, 0x00, 0x03]`
   - tag_id=1, qty=50, status=0, battery=95, seq=3
4. WS63 打印 `[WS63_NET] inventory rsp: tag=1 qty=50 status=0 bat=95 seq=3`
5. **修复前会打印**: tag=256 qty=12800 status=0 bat=95 seq=768

### 验证 FIX-02 (Write 字节序)

1. ESP32 发送 `{"cmd":"inbound","seq":2,"data":{"zone":"A1","item":"test"}}`
2. WS63 分配 tag_id=1，发送 `[0x20, 0x00, 0x01]` (BE for tag_id=1)
3. BS21E 打印 `[BS2x_PROTO] parse OK action=BIND_TAG(0x20) tag_id=1`
4. **修复前会打印**: tag_id=256

### 验证 FIX-03 (本地地址)

1. 观察启动日志 `[WS63_NET] using real local addr: XX:XX:XX:XX:XX:XX`
2. 确认地址不是硬编码的 `13:67:5C:07:00:51`
3. 如果 `sle_get_local_addr` 失败，会打印 `WARN` 并使用 fallback

### 验证 FIX-04 (tag_id 过滤)

1. 启动后观察扫描日志，确认能看到 `adv matched tag=X` 的输出
2. 修复前所有广播都被 `tag_id mismatch` 过滤掉
