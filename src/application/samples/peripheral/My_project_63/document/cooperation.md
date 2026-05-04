# BS21E-WS63 协同开发协议规范

## 一、系统架构总览

```
┌──────────────────────────────────────────────────────────┐
│                    WS63 (SLE Client)                      │
│                                                           │
│  职责：                                                   │
│  1. 扫描 BS2x_Tag 设备，建立 tag_id→MAC 映射表           │
│  2. 映射表持久化到 NV，开机无需重新扫描                   │
│  3. 发送0x01→寻物，0x02→盘点，0x10→更新qty               │
│  4. 接收盘点回复 notify                                   │
│                                                           │
│  NV存储：映射表 {tag_id, MAC[6]}                          │
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
│  6. 无连接超时→进入低功耗Standby/Sleep                    │
│                                                           │
│  NV存储：MAC地址（key=0x3000），重启后读取同一MAC         │
└──────────────────────────────────────────────────────────┘
```

## 二、MAC地址机制（63端必须了解）

### 2.1 MAC持久化

| 行为 | 说明 |
|------|------|
| 首次上电 | BS21E生成随机MAC，写入Flash（NV key=0x3000） |
| 再次上电 | 从Flash读取MAC，使用同一个 |
| 恢复出厂设置 | MAC保留（0x3000在user normal区，不清除） |
| 重新烧录固件 | NV分区可能被擦除，MAC会重新生成 |

### 2.2 MAC格式

- 首字节 bit1=1, bit0=0（本地管理地址，非组播）
- 示例：`02:A3:5F:1B:9E:C7`
- 6字节，小端序传输

### 2.3 63端注意事项

```
⚠️ MAC地址在以下情况会变化：
   - 重新烧录完整固件（含NV分区擦除）
   - 手动清除NV数据

✅ 以下情况MAC不变：
   - 正常断电重启
   - 恢复出厂设置
   - OTA升级（仅升级application分区）
```

## 三、SLE广播协议

### 3.1 广播数据结构

BS21E广播的厂商数据区（AD Type=0xFF, Manufacturer ID=0xA55A）：

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
3. 提取 tag_id, qty, status, battery
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

| 命令码 | 含义 | 数据格式 | 方向 |
|--------|------|---------|------|
| 0x00 | 停止寻物 | `[0x00]` | 63→21e |
| 0x01 | 寻物 | `[0x01]` | 63→21e |
| 0x02 | 盘点请求 | `[0x02]` | 63→21e |
| 0x10 | 更新数量 | `[0x10, qty_hi, qty_lo]` | 63→21e |

### 4.2 盘点回复协议（0x02的notify回复）

BS21E收到0x02后，通过SSAP Notify回复当前数据：

```c
#pragma pack(push, 1)
typedef struct {
    uint8_t  cmd;        // 0x82（0x02的回复，高位bit7=1表示回复）
    uint16_t tag_id;     // 当前标签ID
    uint16_t qty;        // 当前数量
    uint8_t  status;     // 当前状态
    uint8_t  battery;    // 当前电量
} shared_proto_inventory_rsp_t;  // 共7字节
#pragma pack(pop)
```

### 4.3 63端处理流程

```
发送0x02盘点请求:
  63端 → SSAP Write [0x02] → 21e端
  21e端 → SSAP Notify [0x82, tag_id, qty, status, battery] → 63端
  63端 → 解析notify，更新映射表中该标签的qty/status/battery

发送0x01寻物:
  63端 → SSAP Write [0x01] → 21e端
  21e端 → 蜂鸣器+LED响15s
  21e端 → 广播status字段变为0x01
  63端 → 可通过扫描数据观察到status变化

发送0x10更新数量:
  63端 → SSAP Write [0x10, qty_hi, qty_lo] → 21e端
  21e端 → 更新qty，广播数据同步更新
```

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
| Property UUID | `0xFF01` | 读写+Notify属性 |

Property权限：READ | WRITE | NOTIFY

## 六、配网流程

```
步骤1: 只给第1个BS21E上电（其余断电或未烧录）
步骤2: WS63扫描 → 发现1台 BS2x_Tag（MAC=XX:XX:XX:XX:XX:01）
步骤3: WS63连接 → SSAP Write [0x10, 0x00, 0x01]（写入tag_id=1）
       ⚠️ 当前0x10是更新qty，配网写入tag_id需要新增命令码
       或者：首次配网用0x10写入qty字段暂存tag_id，后续再规范
步骤4: WS63断开 → 映射表记录 {tag_id:1, MAC:XX:XX:XX:XX:XX:01}
步骤5: 重复步骤1-4，逐个配网
```

### 6.1 配网命令（待双方确认）

当前协议中没有"写入tag_id"的命令，建议新增：

| 命令码 | 含义 | 数据格式 | 方向 |
|--------|------|---------|------|
| 0x20 | 写入tag_id | `[0x20, tag_id_hi, tag_id_lo]` | 63→21e |

**此命令需要双方协商确认后实现。**

## 七、63端映射表设计参考

```c
#define MAX_TAGS 50

typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];     // BS21E的SLE MAC地址
    uint16_t qty;
    uint8_t  status;     // 0x00=正常，0x01=寻物中
    uint8_t  battery;
    bool     valid;      // 该槽位是否有效
} tag_entry_t;

typedef struct {
    tag_entry_t entries[MAX_TAGS];
    uint8_t     count;   // 已配网标签数量
} tag_map_t;
```

### 7.1 映射表NV持久化

```
63端需要将映射表存入NV，确保：
- 开机后直接从NV读取映射表，无需重新扫描
- 新配网标签时追加写入NV
- tag_id与MAC绑定关系持久化
```

## 八、连接参数

| 参数 | 值 | 说明 |
|------|---|------|
| 连接间隔 | 12.5ms | 0x64 × 125μs |
| 连接延迟 | 499 | 从设备可跳过499个连接事件 |
| 监督超时 | 5000ms | 0x1F4 × 10ms |

## 九、63端开发检查清单

- [ ] 扫描过滤：local_name=="BS2x_Tag" + magic==0xAABBCCDD
- [ ] 映射表：tag_id→MAC，NV持久化
- [ ] 连接：通过MAC地址发起SLE连接
- [ ] SSAP Write：发送0x00/0x01/0x02/0x10命令
- [ ] SSAP Notify：接收0x82盘点回复
- [ ] 配网流程：逐个上电，分配tag_id
- [ ] 寻物：发送0x01，观察广播status变化
- [ ] 盘点：发送0x02，解析notify回复
- [ ] 更新数量：发送0x10+2字节qty

## 十、待双方协商事项

| # | 事项 | 说明 |
|---|------|------|
| 1 | 配网写入tag_id的命令码 | 建议0x20，需确认 |
| 2 | 盘点模式是否需要批量操作 | 当前是逐个连接盘点，是否需要广播盘点？ |
| 3 | 63端映射表最大容量 | 建议50，需确认 |
| 4 | 盘点回复notify的cmd字段 | 建议0x82（0x02|0x80），需确认 |
