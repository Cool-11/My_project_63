# WS63端对《BS21E-WS63 协同开发协议规范》的审核反馈

> 审核方：WS63 Client 端
> 审核日期：2026-05-03
> 审核依据：cooperation.md（BS21E Server端提供）
> 审核结论：**四大业务方向正确，但存在3项P0阻塞问题必须先解决，否则系统无法运行**

---

## 审核总览

| 业务场景 | 能否跑通 | 阻塞项 |
|----------|---------|--------|
| 配网（入库前置） | ❌ 不能 | P0-1：0x20命令未确认；P0-2：tag_id持久化未明确 |
| 入库（日常） | ✅ 能 | — |
| 盘点 | ⚠️ 部分 | P1-1：0x82回复缺seq；P1-4：缺少被动扫描方案 |
| 出库 | ✅ 能 | — |
| 寻物 | ✅ 能 | — |

---

## 🔴 P0 阻塞项（不解决则系统无法运行）

---

### P0-1：配网写入 tag_id 的命令 0x20 未确认，BS21E 端未实现

**文档现状：**

cooperation.md 第六节写明：

> "当前0x10是更新qty，配网写入tag_id需要新增命令码"
> "或者：首次配网用0x10写入qty字段暂存tag_id，后续再规范"

建议的 0x20 命令标注为"待双方协商确认"，BS21E 端尚未实现。

**为什么是阻塞项：**

配网是整个系统的起点。没有写入 tag_id 的命令，WS63 无法给 BS21E 分配身份编号，后续所有业务（入库、盘点、出库、寻物）都无法启动。

**为什么不能用 0x10 暂存 tag_id：**

0x10 的语义是"更新数量"，数据格式是 `[0x10, qty_hi, qty_lo]`。如果用 0x10 暂存 tag_id：

1. BS21E 收到后会更新广播中的 qty 字段为 tag_id 的值，导致 WS63 扫描时读到错误的 qty
2. qty 和 tag_id 的取值范围不同（qty 最大 65535，tag_id 最大 50），语义混淆
3. 后续 0x10 正式写入 qty 时，tag_id 信息会被覆盖丢失
4. 无法区分"这是数量"还是"这是标签ID"，两端逻辑都会混乱

**WS63 端建议：**

确认 0x20 命令码，格式如下：

| 命令码 | 含义 | 数据格式 | 方向 |
|--------|------|---------|------|
| 0x20 | 写入 tag_id | `[0x20, tag_id_hi, tag_id_lo]` | 63→21e |

BS21E 收到 0x20 后：
1. 将 tag_id 写入 NV 持久化
2. 更新广播 payload 中的 tag_id 字段
3. 递增 seq 字段
4. 通过 notify 回复 `[0xA0, tag_id_hi, tag_id_lo]`（0x20 | 0x80 = 0xA0）确认写入成功

**需要 BS21E 端确认：**
- [ ] 是否接受 0x20 命令码？
- [ ] 是否能实现 tag_id 写入后更新广播 payload？
- [ ] 是否能实现 notify 回复确认？

---

### P0-2：tag_id 写入后 BS21E 是否 NV 持久化未明确

**文档现状：**

cooperation.md 未说明 BS21E 收到 0x20 写入 tag_id 后是否存入 Flash。

**为什么是阻塞项：**

如果 BS21E 断电后 tag_id 恢复为默认值 0，配网操作等于白做。

**风险场景：**

```
配网完成：tag_id=1~50 全部写入，映射表建立
仓库停电 → 所有 BS21E 断电
来电重启 → tag_id 全部回到 0
WS63 扫描 → 50个标签全是 tag_id=0，无法区分
映射表失效 → 系统瘫痪 → 需要重新逐个配网
```

**WS63 端建议：**

BS21E 端必须将 tag_id 持久化到 NV，行为与 MAC 地址一致：

| 行为 | tag_id 处理 |
|------|------------|
| 收到 0x20 写入 | 存入 NV（建议 key=0x3001） |
| 断电重启 | 从 NV 读取 tag_id，恢复广播 |
| 恢复出厂设置 | tag_id 保留（不清除） |
| 重新烧录固件 | tag_id 可能丢失（与 MAC 同风险，见 P0-3） |

**需要 BS21E 端确认：**
- [ ] tag_id 写入后是否 NV 持久化？
- [ ] 断电重启后 tag_id 是否能恢复？
- [ ] 建议使用哪个 NV key 存储 tag_id？

---

### P0-3：重新烧录 BS21E 固件后 MAC 会变，映射表全部失效

**文档现状：**

cooperation.md 第二节原文：

> "重新烧录固件 → NV分区可能被擦除，MAC会重新生成"

**为什么是阻塞项：**

WS63 映射表以 MAC 为连接目标。如果 BS21E 固件升级后 MAC 变了，映射表中 50 条 MAC 全部失效，WS63 无法连接任何标签。

**风险场景：**

```
系统运行中：映射表 tag_id=1 → MAC=02:A3:5F:1B:9E:C7
BS21E 需要固件升级 → 烧录新固件
升级后 MAC 变为 02:B8:4D:7C:2E:F1
WS63 扫描 → tag_id=1 但 MAC 不匹配 → 连接失败
50个标签全部如此 → 系统瘫痪 → 需要重新逐个配网
```

**WS63 端建议方案A（推荐，BS21E端修改）：**

将 MAC 地址存储在不受固件升级影响的 NV 区域。参考 WS63 的做法：

```
WS63 的 NV 分区：
  应用固件区    ← 烧录/升级只改这里
  NV user区    ← 独立分区，烧录固件不会碰
  → 所以 WS63 的映射表在固件升级后不会丢
```

建议 BS21E 端确认：烧录工具是否支持"只擦除 application 分区，保留 NV 分区"？如果支持，MAC 变更问题就不存在。

**WS63 端建议方案B（WS63端兜底）：**

WS63 端实现 MAC 变更自动修复逻辑：

```
WS63 扫描到广播：
  1. 解析 tag_id
  2. 查映射表：tag_id 匹配但 MAC 不匹配
  3. 自动更新映射表中的 MAC 为新值
  4. NV 持久化更新后的映射表
```

此方案的前提是：BS21E 固件升级后 tag_id 不丢失（回到 P0-2，tag_id 必须 NV 持久化）。

**需要 BS21E 端确认：**
- [ ] 烧录工具是否支持保留 NV 分区？
- [ ] 如果不支持，BS21E 端是否有其他方式保证 MAC 在固件升级后不变？
- [ ] 如果 MAC 确实会变，tag_id 是否能保证不变？（tag_id 不变则方案B可用）

---

## 🟡 P1 重要问题（不解决则功能不完整或数据不准）

---

### P1-1：0x82 盘点回复缺少 seq 字段

**文档现状：**

`shared_proto_inventory_rsp_t` 结构体共 7 字节：

```c
typedef struct {
    uint8_t  cmd;        // 0x82
    uint16_t tag_id;     // 2字节
    uint16_t qty;        // 2字节
    uint8_t  status;     // 1字节
    uint8_t  battery;    // 1字节
} shared_proto_inventory_rsp_t;  // 共7字节
```

**问题：**

广播 payload `shared_proto_adv_field_t` 中有 `seq` 字段（每次更新递增），但盘点回复中没有。WS63 收到盘点回复后无法判断数据是否比映射表中的更新。

**风险场景：**

```
WS63 映射表：tag_id=1, qty=50, seq=5
BS21E 被其他操作更新了 qty=30, seq=6
WS63 发送 0x02 盘点请求
BS21E 回复：tag_id=1, qty=30（无 seq）
WS63 无法判断 qty=30 是否比当前 qty=50 更新
```

**WS63 端建议：**

在 `shared_proto_inventory_rsp_t` 中增加 `seq` 字段：

```c
typedef struct {
    uint8_t  cmd;        // 0x82
    uint16_t tag_id;     // 2字节
    uint16_t qty;        // 2字节
    uint8_t  status;     // 1字节
    uint8_t  battery;    // 1字节
    uint16_t seq;        // 2字节（新增）
} shared_proto_inventory_rsp_t;  // 共9字节
```

**需要 BS21E 端确认：**
- [ ] 是否同意在 0x82 回复中增加 seq 字段？

---

### P1-2：Manufacturer ID 字节序未标注，联调时易误解

**文档现状：**

cooperation.md 写 `Manufacturer ID=0xA55A`，但实际广播数据（WS63 扫描日志）为：

```
hex: 5A A5 DD CC BB AA ...
```

内存中先出现 `5A` 后出现 `A5`，这是小端序存储。

**问题：**

文档没有标注字节序，WS63 端开发者可能按大端序解析，导致 Manufacturer ID 匹配失败。

**WS63 端建议：**

文档中明确标注：

> Manufacturer ID = 0xA55A，小端序存储，内存中为 `5A A5`

**需要 BS21E 端确认：**
- [ ] 确认 Manufacturer ID 在广播中是小端序存储？

---

### P1-3：WS63 端映射表需要扩展业务字段

**文档现状：**

cooperation.md 第七节给出的映射表结构：

```c
typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];
    uint16_t qty;
    uint8_t  status;
    uint8_t  battery;
    bool     valid;
} tag_entry_t;
```

**问题：**

此结构只包含 SLE 层数据，缺少 WS63 业务逻辑必需的字段。这些字段不需要同步给 BS21E，是 WS63 私有数据，但 WS63 端必须拥有。

**缺少的字段及用途：**

| 字段 | 类型 | 用途 | 来源 |
|------|------|------|------|
| zone | char[8] | 区域标识（A/B/C区） | ESP32 入库时指定 |
| item | char[16] | 物品名称（Type-C等） | ESP32 入库时指定 |
| seq | uint16_t | 序列号，判断数据时效 | BS21E 广播 |
| sle_synced | uint8_t | SLE同步状态：0=待同步，1=已同步 | WS63 内部状态 |
| cloud_synced | uint8_t | 上云状态：0=待上云，1=已上云 | WS63 内部状态 |

**WS63 端扩展后的映射表：**

```c
#define MAX_TAGS 50

typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];
    char     zone[8];
    char     item[16];
    uint16_t qty;
    uint8_t  status;
    uint8_t  battery;
    uint16_t seq;
    uint8_t  sle_synced;
    uint8_t  cloud_synced;
    uint8_t  valid;
} tag_entry_t;

typedef struct {
    tag_entry_t entries[MAX_TAGS];
    uint8_t     count;
} tag_map_t;
```

**说明：**

此修改仅影响 WS63 端，不需要 BS21E 端做任何改动。列出此条是为了让 BS21E 端了解 WS63 的完整数据模型，避免后续联调时产生误解。

**不需要 BS21E 端确认，WS63 端自行实现。**

---

### P1-4：盘点只支持主动连接查询，缺少被动扫描方案

**文档现状：**

cooperation.md 只定义了 0x02 主动连接盘点方式：

```
WS63 → BS21E: SSAP Write [0x02]
BS21E → WS63: SSAP Notify [0x82, tag_id, qty, status, battery]
```

**问题：**

50 个标签逐个连接盘点，每个连接+断开约 2~3 秒，全量盘点需要 2~3 分钟。对于日常快速盘点场景，速度太慢。

**WS63 端建议：**

两种盘点方式结合使用：

| 方式 | 触发条件 | 过程 | 耗时 | 准确度 |
|------|---------|------|------|--------|
| 被动扫描盘点 | 定时触发（如每小时） | WS63 扫描广播，读取 tag_id+qty+seq | 秒级 | 一般（依赖广播数据时效） |
| 主动查询盘点 | 用户手动触发 | WS63 逐个连接，发送 0x02 | 2~3分钟 | 高（实时数据） |

被动扫描盘点不需要 BS21E 端做任何改动——WS63 只需解析广播 payload 中的 tag_id、qty、seq 字段即可。

**需要 BS21E 端确认：**
- [ ] 广播中的 qty 字段是否与内部 qty 实时同步？（即 BS21E 更新 qty 后，下一次广播是否立即反映新值？）
- [ ] 如果广播 qty 有延迟，延迟大约多久？

---

## 🟢 P2 建议优化（不影响核心功能，但影响体验或可维护性）

---

### P2-1：配网流程缺少 ESP32 交互环节

**文档现状：**

cooperation.md 第六节配网流程只有 WS63 和 BS21E 的交互，没有 ESP32 参与。

**问题：**

配网时 zone（区域）的分配没有来源。我们之前确认的业务逻辑是：用户在 ESP32 串口屏上选择区域，ESP32 通过 JSON 把 zone 传给 WS63。

**建议的完整配网流程：**

```
步骤1: 只给第1个BS21E上电
步骤2: WS63扫描 → 发现1台 BS2x_Tag（tag_id=0，未配网）
步骤3: WS63通知ESP32："发现新标签，MAC=XX:XX:XX:XX:XX:01"
步骤4: 用户在ESP32屏幕上选择区域（如"A区"）和物品（如"Type-C"）
步骤5: ESP32通过JSON发送：{"cmd":"bind_tag","data":{"mac":"XX:XX:XX:XX:XX:01","zone":"A","item":"Type-C"}}
步骤6: WS63分配tag_id=1 → SSAP Write [0x20, 0x00, 0x01] → BS21E
步骤7: WS63写入映射表：{tag_id:1, MAC:XX:XX:XX:XX:XX:01, zone:"A", item:"Type-C"}
步骤8: WS63 NV持久化
步骤9: 重复步骤1-8
```

**不需要 BS21E 端确认，WS63 和 ESP32 端自行实现。**

---

### P2-2：BS21E 寻物结束后 status 恢复时机未明确

**文档现状：**

cooperation.md 写"收到0x01后广播status变为0x01"，但没说 15 秒报警结束后 status 是否自动恢复为 0x00。

**问题：**

WS63 扫描时看到 status=0x01，不知道是正在寻物还是寻物已结束但 status 没更新。

**WS63 端建议：**

BS21E 15 秒报警结束后：
1. 自动将 status 恢复为 0x00
2. 递增 seq
3. 下一次广播携带更新后的 status 和 seq

**需要 BS21E 端确认：**
- [ ] 15 秒报警结束后 status 是否自动恢复为 0x00？
- [ ] 恢复时是否递增 seq？

---

### P2-3：BS21E 连接超时时间未明确

**文档现状：**

cooperation.md 写"无连接超时→进入低功耗Standby/Sleep"，但没说超时时间是多少。

**问题：**

WS63 连接 BS21E 后如果操作时间过长，BS21E 可能主动断开进入休眠，导致操作中断。

**WS63 端建议：**

明确 BS21E 的连接超时时间，WS63 端需要在此时间内完成所有操作并主动断开。

**需要 BS21E 端确认：**
- [ ] BS21E 连接超时时间是多少秒？
- [ ] 超时后 BS21E 是直接断开还是先通知 WS63？

---

## 确认事项汇总

以下是需要 BS21E 端回复确认的完整清单：

| 编号 | 优先级 | 确认事项 | WS63端建议 |
|------|--------|---------|-----------|
| P0-1 | 🔴 | 是否接受 0x20 写入 tag_id 命令？ | 接受，格式 `[0x20, tag_id_hi, tag_id_lo]` |
| P0-1 | 🔴 | 0x20 写入后是否 notify 回复确认？ | 回复 `[0xA0, tag_id_hi, tag_id_lo]` |
| P0-2 | 🔴 | tag_id 写入后是否 NV 持久化？ | 必须，建议 key=0x3001 |
| P0-2 | 🔴 | 断电重启后 tag_id 是否恢复？ | 必须恢复 |
| P0-3 | 🔴 | 烧录工具是否支持保留 NV 分区？ | 建议支持 |
| P0-3 | 🔴 | 如果 MAC 会变，tag_id 是否能保证不变？ | tag_id 不变则 WS63 可自动修复映射表 |
| P1-1 | 🟡 | 0x82 回复是否增加 seq 字段？ | 建议增加，9字节 |
| P1-2 | 🟡 | Manufacturer ID 是否小端序存储？ | 确认后文档标注 |
| P1-4 | 🟡 | 广播 qty 是否与内部 qty 实时同步？ | 建议实时同步 |
| P2-2 | 🟢 | 15秒报警后 status 是否自动恢复 0x00？ | 建议自动恢复 |
| P2-2 | 🟢 | 恢复时是否递增 seq？ | 建议递增 |
| P2-3 | 🟢 | 连接超时时间是多少秒？ | 请明确数值 |

---

## 附录：WS63 端映射表完整设计

以下为 WS63 端映射表的最终设计，供 BS21E 端参考（不需要 BS21E 端实现）：

```c
#define MAX_TAGS 50

typedef struct {
    uint16_t tag_id;       // 主键，WS63分配，不可复用
    uint8_t  mac[6];       // BS21E的SLE MAC地址（连接用）
    char     zone[8];      // 区域标识，ESP32指定（如"A"、"B"）
    char     item[16];     // 物品名称，ESP32指定（如"Type-C"）
    uint16_t qty;          // 当前数量，权威值在WS63
    uint8_t  status;       // 0x00=正常，0x01=寻物中
    uint8_t  battery;      // 电量百分比
    uint16_t seq;          // 序列号，判断数据时效
    uint8_t  sle_synced;   // 0=待同步到BS21E，1=已同步
    uint8_t  cloud_synced; // 0=待上云，1=已上云
    uint8_t  valid;        // 0=槽位空闲，1=已占用
} tag_entry_t;             // 共 41 字节

typedef struct {
    tag_entry_t entries[MAX_TAGS];  // 50 × 41 = 2050 字节
    uint8_t     count;              // 已配网标签数量
} tag_map_t;                       // 共 2051 字节
```

NV 持久化方案：
- NV key = 0x5001，一次性读写整张映射表（2051 字节）
- WS63 开机时 `uapi_nv_read` 恢复到 RAM
- 每次修改后 `uapi_nv_write` 同步到 Flash
- 固件升级不影响 NV 分区，映射表不会丢失
