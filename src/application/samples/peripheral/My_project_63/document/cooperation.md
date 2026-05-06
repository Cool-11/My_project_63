# BS21E-WS63 协同开发协议规范

> 版本：v2.0
> 更新日期：2026-05-03
> 更新说明：基于 WS63 端深度排查结果，修正连接参数冲突、补充 Notify 订阅流程、统一配网流程、增加日志规范

## 一、系统架构总览

```
┌──────────────────────────────────────────────────────────┐
│                    WS63 (SLE Client)                      │
│                                                           │
│  职责：                                                   │
│  1. 扫描 BS2x_Tag 设备，建立 tag_id→MAC 映射表           │
│  2. 映射表持久化到 NV，开机无需重新扫描                   │
│  3. 发送0x01→寻物，0x02→盘点，0x10→更新qty，0x20→配网    │
│  4. 连接后必须写入CCCD启用Notify订阅                      │
│  5. 接收0x82盘点回复和0xA0配网确认的notify                │
│                                                           │
│  NV存储：映射表 {tag_id, MAC[6], zone, item, ...}        │
└──────────────────────┬───────────────────────────────────┘
                       │ SLE 连接（广播间隙建立）
┌──────────────────────▼───────────────────────────────────┐
│                   BS21E (SLE Server)                      │
│                                                           │
│  职责：                                                   │
│  1. 上电生成唯一MAC，持久化到NV，重启不变                 │
│  2. 持续广播 tag_id + qty + status + battery              │
│  3. 收到0x01→蜂鸣器+LED响15s（寻物）                     │
│  4. 收到0x02→通过notify回复当前qty+status（盘点）         │
│  5. 收到0x10→更新qty值                                   │
│  6. 收到0x20→写入tag_id到NV，notify回复0xA0确认          │
│  7. 无连接超时→进入低功耗Standby/Sleep                    │
│                                                           │
│  NV存储：MAC地址（key=0x3000），tag_id（key=0x3001）      │
└──────────────────────────────────────────────────────────┘
```

## 二、MAC地址机制（63端必须了解）

### 2.1 MAC持久化

| 行为 | 说明 |
|------|------|
| 首次上电 | BS21E生成随机MAC，写入Flash（NV key=0x3000） |
| 再次上电 | 从Flash读取MAC，使用同一个 |
| 恢复出厂设置 | MAC保留（0x3000在user normal区，不清除） |
| 正常烧录application固件 | **MAC不变**（NV分区独立，烧录只写application分区） |
| OTA升级 | **MAC不变** |
| 全量烧录（含NV分区擦除） | ⚠️ MAC会重新生成（非正常操作） |

### 2.2 MAC格式

- 首字节 bit1=1, bit0=0（本地管理地址，非组播）
- 示例：`02:A3:5F:1B:9E:C7`
- 6字节，小端序传输

### 2.3 63端注意事项

```
⚠️ MAC地址在以下情况会变化：
   - 全量烧录（含NV分区擦除，非正常操作）
   - 手动清除NV数据

✅ 以下情况MAC不变：
   - 正常断电重启
   - 恢复出厂设置
   - 正常烧录application固件（NV分区独立，不受影响）
   - OTA升级（仅升级application分区）
```

### 2.4 Flash分区表

BS21E Flash分区独立，正常烧录不影响NV：

| 分区 | Item ID | 起始地址 | 大小 | 说明 |
|------|---------|---------|------|------|
| flashboot | 0x00 | 0x1000 | 40KB | 引导程序 |
| flashboot_backup | 0x01 | 0xB000 | 40KB | 引导备份 |
| **application** | **0x23** | **0x15000** | **544KB** | **应用固件（烧录只写这里）** |
| **NV data** | **0x25** | **0xFE000** | **8KB** | **NV数据（独立分区，不受烧录影响）** |
| FOTA | 0x26 | 0x9D000 | 388KB | OTA升级区 |

### 2.5 MAC变更兜底机制

如果发生全量烧录导致MAC变化，WS63端按以下逻辑自动修复映射表：

```
WS63扫描逻辑：
  tag_id != 0 且 MAC匹配    → 正常使用
  tag_id != 0 且 MAC不匹配  → 自动更新映射表中的MAC（方案B兜底）
  tag_id == 0               → 视为未配网，提示用户重新配网
```

## 三、SLE广播协议

### 3.1 广播数据结构

BS21E广播的厂商数据区（AD Type=0xFF, Manufacturer ID=0xA55A，小端序存储，内存中为 `5A A5`）：

```c
#pragma pack(push, 1)
typedef struct {
    uint32_t magic;      // 0xAABBCCDD（固定魔数，用于过滤BS2x设备）
    uint16_t tag_id;     // 标签ID（配网时由63端写入，默认0）
    uint16_t qty;        // 当前数量
    uint8_t  status;     // 状态：0x00=正常，0x01=寻物中
    uint8_t  battery;    // 电量百分比
    uint16_t seq;        // 序列号（每次更新递增）
} shared_proto_adv_field_t;  // 共12字节
#pragma pack(pop)
```

### 3.2 63端扫描过滤逻辑

```
1. 过滤 local_name == "BS2x_Tag"
2. 解析厂商数据区，验证 magic == 0xAABBCCDD
3. 提取 tag_id, qty, status, battery, seq
4. 以 MAC 为主键建立映射表
```

### 3.3 广播参数

| 参数 | 值 | 说明 |
|------|---|------|
| 广播间隔 | 25ms | 0xC8 × 125μs |
| 广播信道 | 0x07 | 三信道全开 |
| 广播模式 | CONNECTABLE_SCANABLE | 可连接可扫描 |
| Seek Response | 包含 local_name="BS2x_Tag" | 用于设备发现 |

## 四、SSAP单播命令协议

### 4.1 命令码定义

| 命令码 | 含义 | 数据格式 | 方向 | 回复 |
|--------|------|---------|------|------|
| 0x00 | 停止寻物 | `[0x00]` | 63→21e | 无 |
| 0x01 | 寻物 | `[0x01]` | 63→21e | 无（广播status变为0x01，15秒后自动恢复0x00） |
| 0x02 | 盘点请求 | `[0x02]` | 63→21e | Notify `[0x82, tag_id, qty, status, battery, seq]`（9字节） |
| 0x10 | 更新数量 | `[0x10, qty_hi, qty_lo]` | 63→21e | 无（广播qty实时更新） |
| 0x20 | 写入tag_id | `[0x20, tag_id_hi, tag_id_lo]` | 63→21e | Notify `[0xA0, tag_id_hi, tag_id_lo]` |

### 4.2 回复协议结构体

**0x02 盘点回复（0x82）：**

```c
#pragma pack(push, 1)
typedef struct {
    uint8_t  cmd;        // 0x82（0x02的回复，高位bit7=1表示回复）
    uint16_t tag_id;     // 当前标签ID
    uint16_t qty;        // 当前数量
    uint8_t  status;     // 当前状态
    uint8_t  battery;    // 当前电量
    uint16_t seq;        // 序列号（判断数据时效）
} shared_proto_inventory_rsp_t;  // 共9字节
#pragma pack(pop)
```

**0x20 配网确认回复（0xA0）：**

```c
#pragma pack(push, 1)
typedef struct {
    uint8_t  cmd;        // 0xA0（0x20的回复，0x20|0x80=0xA0）
    uint16_t tag_id;     // 写入的标签ID
} shared_proto_bind_rsp_t;  // 共3字节
#pragma pack(pop)
```

### 4.3 SSAP 完整交互流程（⚠️ 关键：必须启用 Notify 订阅）

```
连接建立后的完整流程：

1. 连接建立 → 配对 → SSAP Exchange
2. 发现 Service（UUID=0xFF00）
3. 发现 Property（UUID=0xFF01，权限=READ|WRITE|NOTIFY）
4. ⚠️ 写入 CCCD 启用 Notify 订阅：
   63端 → SSAP Write [0x01, 0x00] → Property的CCCD Descriptor
   说明：CCCD = Client Characteristic Configuration Descriptor
         写入 0x0001 = 启用 Notification
         不写入则 63端收不到任何 Notify 回复
5. 发送业务命令（0x00/0x01/0x02/0x10/0x20）
6. 接收 Notify 回复（0x82/0xA0）
7. 操作完成后主动断开连接
```

**⚠️ 如果不执行第4步（写入CCCD），BS21E端虽然会调用 ssaps_notify_indicate() 发送数据，但63端的协议栈不会上报 notification 回调，0x82 和 0xA0 回复永远收不到。**

### 4.4 63端各命令处理流程

```
发送0x02盘点请求:
  63端 → SSAP Write [0x02] → 21e端
  21e端 → SSAP Notify [0x82, tag_id, qty, status, battery, seq] → 63端
  63端 → 解析notify，通过seq判断数据时效，更新映射表

发送0x01寻物:
  63端 → SSAP Write [0x01] → 21e端
  21e端 → 蜂鸣器+LED响15s
  21e端 → 广播status字段变为0x01
  15秒后 → 21e端自动恢复status=0x00，seq递增，广播更新
  63端 → 可通过扫描数据观察到status从0x01变为0x00

发送0x10更新数量:
  63端 → SSAP Write [0x10, qty_hi, qty_lo] → 21e端
  21e端 → 更新qty，广播数据实时同步更新（延迟<100ms）

发送0x20写入tag_id:
  63端 → SSAP Write [0x20, tag_id_hi, tag_id_lo] → 21e端
  21e端 → 校验当前tag_id是否为0（防覆盖保护）
  21e端 → 写入NV持久化（key=0x3001），更新广播payload，递增seq
  21e端 → SSAP Notify [0xA0, tag_id_hi, tag_id_lo] → 63端（确认写入成功）
```

### 4.5 0x20 写入 tag_id 的覆盖保护

BS21E收到0x20后应进行以下校验：

```
if (当前tag_id == 0) {
    写入新tag_id → NV持久化 → 更新广播 → Notify 0xA0确认
} else if (当前tag_id == 请求的tag_id) {
    重复写入，Notify 0xA0确认（幂等）
} else {
    拒绝覆盖，Notify 0xAF 表示写入失败（tag_id已被占用）
}
```

**0xAF 错误码定义：**

| 命令码 | 含义 | 数据格式 | 方向 |
|--------|------|---------|------|
| 0xAF | 0x20写入失败（tag_id已被占用） | `[0xAF, current_tag_id_hi, current_tag_id_lo]` | 21e→63 |

## 五、SSAP服务UUID

63端连接后需要发现以下服务，UUID以字节数组形式给出（与代码中一致）：

**App UUID（16字节）：**
```
0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x10, 0x00,
0x80, 0x00, 0x00, 0x80, 0x5F, 0x9B, 0x34, 0xFB
```

**Service UUID（16字节）：**
```
0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x10, 0x00,
0x80, 0x00, 0x00, 0x80, 0x5F, 0x9B, 0x34, 0xFB
```

**Property UUID（16字节）：**
```
0x00, 0x00, 0xFF, 0x01, 0x00, 0x00, 0x10, 0x00,
0x80, 0x00, 0x00, 0x80, 0x5F, 0x9B, 0x34, 0xFB
```

| UUID类型 | 自定义短UUID | 用途 |
|----------|-------------|------|
| App UUID | `0xFFFF` | 应用标识 |
| Service UUID | `0xFF00` | 服务标识 |
| Property UUID | `0xFF01` | 读写+Notify属性（含CCCD Descriptor） |

Property权限：READ | WRITE | NOTIFY

**⚠️ Property 必须包含 CCCD Descriptor，否则63端无法写入 0x0001 启用 Notify。**

## 六、配网流程

### 6.1 完整配网流程（含ESP32交互）

```
步骤1: 只给第1个BS21E上电（其余断电或未烧录）
步骤2: WS63扫描 → 发现1台 BS2x_Tag（MAC=XX:XX:XX:XX:XX:01, tag_id=0）
步骤3: WS63通知ESP32："发现新标签，MAC=XX:XX:XX:XX:XX:01"
步骤4: 用户在ESP32屏幕上选择区域（如"A区"）和物品（如"Type-C"）
步骤5: ESP32通过JSON发送：
       {"cmd":"bind_tag","data":{"mac":"XX:XX:XX:XX:XX:01","zone":"A","item":"Type-C","qty":50}}
步骤6: WS63分配tag_id=1 → 连接BS21E → 写入CCCD → SSAP Write [0x20, 0x00, 0x01]
步骤7: BS21E → NV持久化tag_id → 更新广播 → Notify [0xA0, 0x00, 0x01] 确认
步骤8: WS63写入映射表：{tag_id:1, MAC:XX:XX:XX:XX:XX:01, zone:"A", item:"Type-C", qty:50}
步骤9: WS63 NV持久化映射表
步骤10: WS63断开连接 → 通知ESP32配网成功
步骤11: 重复步骤1-10，逐个配网
```

### 6.2 配网命令（已确认）

| 命令码 | 含义 | 数据格式 | 方向 | 回复 |
|--------|------|---------|------|------|
| 0x20 | 写入tag_id | `[0x20, tag_id_hi, tag_id_lo]` | 63→21e | Notify `[0xA0, tag_id_hi, tag_id_lo]` |

BS21E收到0x20后：
1. 校验当前tag_id是否为0（防覆盖保护，见4.5节）
2. 将tag_id写入NV持久化（key=0x3001）
3. 更新广播payload中的tag_id字段
4. 递增seq字段
5. 通过notify回复0xA0确认写入成功

### 6.3 配网容错：多台同时上电

如果误操作同时上电多台BS21E，WS63扫描到多个 tag_id=0 的设备：

```
1. WS63按RSSI排序，选择信号最强的那个连接（最近场绑定）
2. WS63通知ESP32："检测到N个未配网标签，已选择信号最强的，请确认"
3. 用户确认后继续配网流程
4. 配网完成后，已分配tag_id的设备下次扫描时tag_id!=0，不会再被误选
```

## 七、63端映射表设计

### 7.1 映射表结构（WS63端完整版）

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
    uint32_t last_seen;    // 最后扫描到的时间戳（秒），用于离线检测
} tag_entry_t;

typedef struct {
    tag_entry_t entries[MAX_TAGS];
    uint8_t     count;     // 已配网标签数量
} tag_map_t;
```

**说明：** zone、item、sle_synced、cloud_synced、last_seen 是 WS63 私有字段，不需要同步给 BS21E。BS21E 只需要 tag_id + qty + status + battery + seq。

### 7.2 映射表NV持久化

```
63端需要将映射表存入NV，确保：
- 开机后直接从NV读取映射表，无需重新扫描
- 新配网标签时追加写入NV
- tag_id与MAC绑定关系持久化
- NV key = 0x5001，一次性读写整张映射表
- 固件升级不影响NV分区，映射表不会丢失
```

### 7.3 离线标签检测

WS63每次被动扫描时更新映射表中对应标签的 `last_seen` 时间戳。

```
离线判定逻辑：
  当前时间 - last_seen > OFFLINE_THRESHOLD（建议60秒）
  → 标记该标签为离线
  → 通知ESP32显示离线状态
  → 不参与盘点统计
```

## 八、连接参数

### 8.1 参数表

| 参数 | 值 | 说明 |
|------|---|------|
| 连接间隔 | 12.5ms | ⚠️ 见8.2节单位说明 |
| 连接延迟 | ≤15 | ⚠️ 见8.3节冲突修正 |
| 监督超时 | 20s | ⚠️ 见8.3节冲突修正 |

### 8.2 ⚠️ 连接间隔单位确认（待双方确认）

WS63 SDK 中 `sle_default_connect_param_t` 的 `min_interval` / `max_interval` 字段单位需要确认：

| 假设单位 | 0x64 对应时间 | WS63应设置的值 |
|----------|-------------|---------------|
| 125μs（文档当前假设） | 100 × 125μs = 12.5ms | 0x64 |
| 0.25ms（SDK sle_conn_param注释） | 100 × 0.25ms = 25ms | 0x32（50 × 0.25ms = 12.5ms） |

**需要BS21E端协助确认：** WS63 SDK 的 `sle_default_connect_param_t` 中 interval 的单位到底是 125μs 还是 0.25ms？

### 8.3 ⚠️ 连接延迟与监督超时冲突修正

**原方案（有冲突）：**
- conn_latency = 499 → 最大静默时间 = 499 × 12.5ms = 6237.5ms
- supervision_timeout = 5000ms = 5s
- 冲突：BS21E静默6237.5ms > 监督超时5000ms → 连接会被误判超时断开

**修正方案A（推荐）：**
- conn_latency = 15 → 最大静默时间 = 15 × 12.5ms = 187.5ms
- supervision_timeout = 5000ms（5s）
- 187.5ms << 5000ms，安全

**修正方案B：**
- conn_latency = 499（保持不变）
- supervision_timeout = 20000ms（20s，0x7D0 × 10ms）
- 6237.5ms < 20000ms，安全

**需要BS21E端确认：** 选择方案A还是方案B？BS21E端的 conn_latency 是硬编码还是可协商？

### 8.4 当前BS21E连接行为

- BS21E当前不会主动断开连接，PM超时设为永不
- 只要WS63在监督超时时间内保持连接交互，连接就不会断
- 后续实现SLE PM模块后会设置合理超时，届时提前告知

## 九、63端开发检查清单

- [ ] 扫描过滤：local_name=="BS2x_Tag" + magic==0xAABBCCDD
- [ ] 映射表：tag_id→MAC，NV持久化，含zone/item/seq/last_seen等字段
- [ ] 连接：通过MAC地址发起SLE连接
- [ ] ⚠️ CCCD写入：发现Property后必须写入 [0x01, 0x00] 启用Notify
- [ ] SSAP Write：发送0x00/0x01/0x02/0x10/0x20命令
- [ ] SSAP Notify：接收0x82盘点回复（9字节，含seq）和0xA0配网确认（3字节）
- [ ] Notify解析：0xA0确认配网成功，0xAF表示tag_id已被占用
- [ ] 配网流程：逐个上电，ESP32选区，发送0x20分配tag_id
- [ ] 寻物：发送0x01，观察广播status变化（15秒后自动恢复0x00）
- [ ] 盘点：发送0x02，解析notify回复（含seq判断时效）
- [ ] 更新数量：发送0x10+2字节qty
- [ ] 被动扫描盘点：直接解析广播中的tag_id+qty+seq（无需连接）
- [ ] MAC变更兜底：tag_id匹配但MAC不匹配时自动更新映射表
- [ ] 离线检测：last_seen超时标记离线，通知ESP32
- [ ] 连接参数：确认interval单位，修正latency/timeout冲突

## 十、待双方协商事项

| # | 事项 | 状态 | 说明 |
|---|------|------|------|
| 1 | 配网写入tag_id的命令码 | ✅ 已确认 | 0x20，回复0xA0 |
| 2 | 盘点模式是否需要批量操作 | ✅ 已确认 | 被动扫描+主动查询两种方式 |
| 3 | 63端映射表最大容量 | ✅ 已确认 | 50 |
| 4 | 盘点回复notify的cmd字段 | ✅ 已确认 | 0x82（0x02|0x80），9字节含seq |
| 5 | ESP32交互流程 | ✅ 已确认 | ESP32→WS63(JSON)→BS21E(SLE) |
| 6 | ⚠️ 连接间隔单位 | 🔴 待确认 | 125μs 还是 0.25ms？影响0x64的实际时间 |
| 7 | ⚠️ 连接延迟与超时冲突 | 🔴 待确认 | 方案A(latency=15) 还是 方案B(timeout=20s)？ |
| 8 | Property是否包含CCCD Descriptor | 🔴 待确认 | 63端需要写入CCCD才能接收Notify |
| 9 | 0x20覆盖保护 | 🟡 建议实现 | tag_id!=0时拒绝覆盖，回复0xAF |
| 10 | 出库是否等同于解绑 | 🟡 待确认 | 出库后是否清除zone/item？ |

## 十一、ESP32交互补充

### 11.1 系统三端架构

```
┌──────────┐    JSON/串口    ┌──────────┐    SLE     ┌──────────┐
│  ESP32   │ ◄────────────► │  WS63    │ ◄───────► │  BS21E   │
│ 串口屏   │                │  Client  │            │  Server  │
└──────────┘                └──────────┘            └──────────┘
```

ESP32负责：用户交互界面（选区、添加数量、触发寻物）
WS63负责：SLE通信、映射表管理、协议转发
BS21E负责：标签数据存储、寻物执行

### 11.2 ESP32操作流程

**配网绑定（首次入库）：**
```
1. 只给1个BS21E上电
2. WS63扫描发现新标签（tag_id=0）
3. WS63通知ESP32："发现新标签，MAC=XX:XX:XX:XX:XX:01"
4. 用户在ESP32屏幕上选择区域和物品
5. ESP32通过JSON发送：
   {"cmd":"bind_tag","seq":1,"data":{"mac":"XX:XX:XX:XX:XX:01","zone":"A","item":"Type-C","qty":50}}
6. WS63收到后：
   a. 分配tag_id
   b. 连接BS21E → 写入CCCD → SSAP Write [0x20, tag_id_hi, tag_id_lo]
   c. 等待Notify 0xA0确认
   d. SSAP Write [0x10, qty_hi, qty_lo]（同步qty）
   e. 写入映射表 + NV持久化
   f. 断开连接
   g. 回复ESP32：{"cmd":"bind_tag","seq":1,"code":0,"data":{"tag_id":1}}
```

**日常补货入库：**
```
1. 用户在ESP32选择已有标签，补充数量
2. ESP32通过JSON发送：
   {"cmd":"stock_in","seq":2,"data":{"tag_id":1,"qty":50}}
3. WS63收到后：
   a. 更新映射表中tag_id=1的qty
   b. 连接BS21E → SSAP Write [0x10, qty_hi, qty_lo]
   c. NV持久化映射表
   d. 断开连接
   e. 回复ESP32：{"cmd":"stock_in","seq":2,"code":0}
```

**出库操作：**
```
1. 用户在ESP32选择物品，点击出库
2. ESP32通过JSON发送：
   {"cmd":"stock_out","seq":3,"data":{"tag_id":1}}
3. WS63收到后：
   a. 更新映射表中tag_id=1的qty=0
   b. 连接BS21E → SSAP Write [0x10, 0x00, 0x00]
   c. NV持久化映射表
   d. 断开连接
   e. 回复ESP32：{"cmd":"stock_out","seq":3,"code":0}
```

**⚠️ 出库语义待确认：** 出库后是否清除 zone/item 并标记 valid=0（解绑）？还是只清 qty 保留绑定关系？两种方案：

| 方案 | 出库后状态 | 下次入库 | 适用场景 |
|------|-----------|---------|---------|
| A：仅清qty | zone/item保留，valid=1 | 直接补货 | 固定位置标签 |
| B：解绑 | zone/item清空，valid=0 | 需要重新bind_tag | 移动标签 |

**需要双方确认选择哪种方案，或支持两种模式由ESP32指定。**

**寻物操作：**
```
1. 用户在ESP32选择物品，点击寻物
2. ESP32通过JSON发送：
   {"cmd":"find_item","seq":4,"data":{"tag_id":1}}
3. WS63收到后：
   a. 查映射表获取tag_id=1的MAC
   b. 连接BS21E → 写入CCCD → SSAP Write [0x01] → 蜂鸣器响
   c. 断开连接
   d. 回复ESP32：{"cmd":"find_item","seq":4,"code":0}
```

**盘点操作：**
```
1. 用户在ESP32点击盘点
2. ESP32通过JSON发送：
   {"cmd":"inventory","seq":5,"data":{"zone":"A"}}（可选指定区域）
3. WS63收到后：
   a. 被动扫描：读取广播中的qty（秒级完成）
   b. 主动查询：逐个连接发送0x02（精确数据，2~3分钟）
   c. 回复ESP32：{"cmd":"inventory","seq":5,"code":0,"data":{"tags":[...]}}
```

### 11.3 ESP32与BS21E的关系

**ESP32不直接与BS21E通信。** 所有对BS21E的操作都通过WS63中转：
- ESP32 → WS63：JSON格式（串口/WiFi）
- WS63 → BS21E：SLE SSAP协议

BS21E端不需要关心ESP32的存在，只需要响应WS63的SSAP命令。

---

## 十二、日志规范（双方必须遵守）

### 12.1 日志原则

1. **每个关键操作必须打印日志**，包括成功和失败两种情况
2. **日志格式统一**：`[模块名] 操作 结果 关键参数`
3. **日志级别**：ERROR（必须处理）> WARN（需要关注）> INFO（正常流程）> DEBUG（调试用）
4. **禁止在日志中打印敏感数据**（如密钥）

### 12.2 BS21E端必要性日志

| 模块 | 触发时机 | 日志内容 | 级别 |
|------|---------|---------|------|
| MAC生成 | 首次上电生成MAC | `[BS21E_MAC] generate MAC=%02X:%02X:%02X:%02X:%02X:%02X` | INFO |
| MAC读取 | 非首次上电读取MAC | `[BS21E_MAC] load MAC=%02X:%02X:%02X:%02X:%02X:%02X from NV` | INFO |
| tag_id写入 | 收到0x20命令 | `[BS21E_BIND] recv 0x20 tag_id=%u, current=%u` | INFO |
| tag_id NV写入 | 写入NV成功/失败 | `[BS21E_BIND] nv write tag_id=%u ret=0x%x` | INFO/ERROR |
| tag_id广播更新 | 更新广播payload | `[BS21E_BIND] adv updated tag_id=%u seq=%u` | INFO |
| tag_id回复 | 发送Notify 0xA0 | `[BS21E_BIND] notify 0xA0 tag_id=%u` | INFO |
| tag_id拒绝 | 收到0x20但已有tag_id | `[BS21E_BIND] reject 0x20 current=%u request=%u` | WARN |
| qty更新 | 收到0x10命令 | `[BS21E_QTY] recv 0x10 qty=%u, old=%u` | INFO |
| qty广播更新 | 更新广播payload | `[BS21E_QTY] adv updated qty=%u seq=%u` | INFO |
| 寻物启动 | 收到0x01命令 | `[BS21E_FIND] start alarm 15s tag_id=%u` | INFO |
| 寻物结束 | 15秒定时器到期 | `[BS21E_FIND] alarm timeout, status=0x00 seq=%u` | INFO |
| 停止寻物 | 收到0x00命令 | `[BS21E_FIND] stop alarm tag_id=%u` | INFO |
| 盘点请求 | 收到0x02命令 | `[BS21E_INV] recv 0x02, notify tag_id=%u qty=%u seq=%u` | INFO |
| NV读取失败 | 上电读取NV失败 | `[BS21E_NV] read key=0x%x ret=0x%x` | ERROR |
| 广播启动 | 开始广播 | `[BS21E_ADV] start tag_id=%u qty=%u status=%u bat=%u seq=%u` | INFO |

### 12.3 WS63端必要性日志

| 模块 | 触发时机 | 日志内容 | 级别 |
|------|---------|---------|------|
| 扫描启动 | 开始扫描 | `[WS63_SCAN] start type=ACTIVE interval=0x%x window=0x%x` | INFO |
| 扫描结果 | 收到广播 | `[WS63_SCAN] result #%u rssi=%d addr=%02X:.. tag_id=%u qty=%u seq=%u` | INFO |
| 目标匹配 | 匹配到目标设备 | `[WS63_SCAN] matched tag_id=%u MAC=%02X:..` | INFO |
| 连接建立 | 连接成功 | `[WS63_CONN] connected conn_id=%u MAC=%02X:..` | INFO |
| 连接断开 | 连接断开 | `[WS63_CONN] disconnected conn_id=%u reason=%u` | WARN |
| 配对完成 | 配对成功 | `[WS63_CONN] pair complete conn_id=%u status=0x%x` | INFO |
| SSAP Exchange | 交换完成 | `[WS63_SSAP] exchange done conn_id=%u mtu=%u` | INFO |
| Service发现 | 找到Service | `[WS63_SSAP] service found start=0x%x end=0x%x` | INFO |
| Property发现 | 找到Property | `[WS63_SSAP] property found handle=0x%x` | INFO |
| CCCD写入 | 启用Notify | `[WS63_SSAP] cccd write handle=0x%x ret=0x%x` | INFO |
| ⚠️ CCCD失败 | 写入CCCD失败 | `[WS63_SSAP] cccd write FAILED handle=0x%x ret=0x%x` | ERROR |
| Write发送 | 发送SSAP命令 | `[WS63_SSAP] write cmd=0x%02X handle=0x%x ret=0x%x` | INFO |
| Write确认 | Write回调 | `[WS63_SSAP] write cfm cmd=0x%02X status=0x%x` | INFO |
| Notify接收 | 收到Notify | `[WS63_SSAP] notify cmd=0x%02X len=%u data=%s` | INFO |
| 0xA0确认 | 配网确认 | `[WS63_BIND] notify 0xA0 tag_id=%u → bind success` | INFO |
| 0xAF拒绝 | 配网被拒绝 | `[WS63_BIND] notify 0xAF current_tag_id=%u → bind rejected` | WARN |
| 0x82盘点 | 盘点回复 | `[WS63_INV] notify 0x82 tag_id=%u qty=%u seq=%u` | INFO |
| 映射表写入 | NV持久化 | `[WS63_MAP] nv write count=%u ret=0x%x` | INFO |
| 映射表读取 | 开机加载 | `[WS63_MAP] nv read count=%u ret=0x%x` | INFO |
| MAC变更修复 | 方案B兜底 | `[WS63_MAP] mac changed tag_id=%u old=%02X:.. new=%02X:..` | WARN |
| 离线检测 | 标签离线 | `[WS63_MAP] offline tag_id=%u last_seen=%us ago` | WARN |
| JSON接收 | 收到ESP32命令 | `[WS63_UART] recv cmd=%s seq=%u` | INFO |
| JSON回复 | 回复ESP32 | `[WS63_UART] send cmd=%s seq=%u code=%u` | INFO |

### 12.4 日志格式规范

```
[模块名] 操作描述 key1=value1 key2=value2

模块名前缀：
  BS21E_MAC    - MAC地址管理
  BS21E_BIND   - tag_id绑定
  BS21E_QTY    - 数量管理
  BS21E_FIND   - 寻物报警
  BS21E_INV    - 盘点
  BS21E_NV     - NV存储
  BS21E_ADV    - 广播
  WS63_SCAN    - 扫描
  WS63_CONN    - 连接管理
  WS63_SSAP    - SSAP协议
  WS63_BIND    - 配网绑定
  WS63_INV     - 盘点
  WS63_MAP     - 映射表
  WS63_UART    - ESP32串口通信
  WS63_NV      - NV存储
```

---

## 十三、必要性注释规范

### 13.1 注释原则

1. **协议相关代码必须注释命令码含义**，如 `// 0x20: 写入tag_id`
2. **NV key 必须注释用途**，如 `// NV key=0x3001: tag_id持久化`
3. **字节序必须注释**，如 `// 小端序：低字节在前`
4. **超时/延迟值必须注释单位**，如 `// 单位：125μs` 或 `// 单位：10ms`
5. **状态机转换必须注释当前状态**，如 `// state: SCANNING → CONNECTING`

### 13.2 注释示例

```c
// Manufacturer ID = 0xA55A，小端序存储，内存中为 5A A5
#define MANUFACTURER_ID_L  0x5Au   // 低字节在前
#define MANUFACTURER_ID_H  0xA5u   // 高字节在后

// NV key分配
#define NV_KEY_MAC     0x3000  // BS21E MAC地址持久化
#define NV_KEY_TAG_ID  0x3001  // BS21E tag_id持久化

// SSAP命令码
#define CMD_STOP_FIND  0x00    // 停止寻物
#define CMD_FIND       0x01    // 寻物（蜂鸣器+LED响15s）
#define CMD_INVENTORY  0x02    // 盘点请求，回复Notify 0x82
#define CMD_UPDATE_QTY 0x10    // 更新数量，格式：[0x10, qty_hi, qty_lo]
#define CMD_BIND_TAG   0x20    // 写入tag_id，格式：[0x20, tag_id_hi, tag_id_lo]

// SSAP回复码（bit7=1表示回复）
#define RSP_INVENTORY  0x82    // 盘点回复（0x02|0x80），9字节
#define RSP_BIND_OK    0xA0    // 配网确认（0x20|0x80），3字节
#define RSP_BIND_FAIL  0xAF    // 配网拒绝（tag_id已被占用）

// 连接参数（⚠️ 单位待确认：125μs 或 0.25ms）
#define CONN_INTERVAL  0x64    // 连接间隔，当前假设125μs单位=12.5ms
#define CONN_TIMEOUT   0x07D0  // 监督超时，单位10ms=20s

// CCCD启用Notify
#define CCCD_NOTIFY_ENABLE  0x0001  // 写入CCCD启用Notification
```
