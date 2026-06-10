# WS63 ↔ ESP32-S3 通信协议规范

> **文档版本**: v3.3  
> **最后更新**: 2026-05-26  
> **适用项目**: CAM_AI (ESP32-S3 视觉感知物资管理子节点)  
> **主要更新**: 
> - **v3.3**: 补全缺失命令（delete/cancel/get_asset/ping），完善下行命令体系 ⭐NEW
> - **v3.2**: Tag ID 改造（标识符从MAC地址升级为16位Tag ID，新增验证式更新流程）⭐
> - v3.1: L610 4G模块完整集成（MQTT云端通信、主动上报机制）
> - v3.0: WS63协议支持（JSON格式UART通信）
> - v2.x: 基础资产管理系统功能

---

## 目录

### 第一部分：基础通信协议（UART1）
1. [系统架构](#1-系统架构)
2. [硬件连接](#2-硬件连接)
3. [物理层规范](#3-物理层规范)
4. [帧格式](#4-帧格式)
5. [通信模型](#5-通信模型)
6. [下行命令 WS63 → ESP32](#6-下行命令-ws63--esp32)
7. [上行消息 ESP32 → WS63](#7-上行消息-esp32--ws63)
8. [任务时序流程](#8-任务时序流程)
9. [错误码定义](#9-错误码定义)
10. [状态机](#10-状态机)

### 第二部分：L610 4G模块扩展（UART2 + MQTT）
11. [L610系统架构](#11-l610系统架构)
12. [L610硬件连接](#12-l610硬件连接)
13. [L610下行命令](#13-l610下行命令-ws63--esp32)
14. [L610上行消息](#14-l610上行消息-esp32--ws63)
15. [MQTT业务流程](#15-mqtt业务流程)
16. [主动上报机制](#16-主动上报机制)
17. [AT指令透传](#17-at指令透传调试)
18. [错误处理与重试](#18-错误处理与重试)
19. [配置参数](#19-配置参数)

### 附录
20. [测试验证](#20-测试验证)
21. [常见问题](#21-常见问题)

---

## 1. 系统架构

```
┌───────────────────────┐         UART1 (JSON)      ┌──────────────────────────┐
│        WS63           │ ◄────────────────────────► │       ESP32-S3           │
│     (主控/Host)        │   TX(GPIO17) ──► RX(18)  │    (视觉感知子节点)        │
│                       │   RX(GPIO18) ◄── TX(17)  │                          │
│  职责：                │   GPIO2 ──────────► RTC   │  职责：                   │
│  · 星闪网络全局时钟     │    (唤醒信号)              │  · 3视图拍摄 (前/侧/顶)   │
│  · 人机交互/UI         │                             │  · MobileNet 特征提取     │
│  · 业务逻辑编排         │   UART0 (调试保留)          │  · 多帧融合 + 模糊检测    │
│  · 云平台通讯           │   TX/RX ────────► PC      │  · 相似度匹配 + 盘点比对  │
│  · 指令下发 + 结果收集  │                             │  · SD卡资产存储/管理       │
└───────────────────────┘                             └──────────────────────────┘
```

**核心原则：**
- WS63 掌握**控制权**（何时让 ESP32 工作）
- ESP32 掌握**数据权**（推理完成主动推送结果，无需 WS63 轮询）

---

## 2. 硬件连接

### 2.1 WS63 ↔ ESP32-S3 连接

| 信号 | ESP32-S3 引脚 | WS63 引脚 | 方向 | 说明 |
|------|-------------|----------|------|------|
| UART TX | **GPIO17** | RX | ESP32 → WS63 | cJSON 数据发送 |
| UART RX | **GPIO18** | TX | WS63 → ESP32 | cJSON 命令接收 |
| RTC 唤醒 | **GPIO2** | GPIO (推挽输出) | WS63 → ESP32 | 拉高唤醒 ESP32，拉低允许睡眠 |
| GND | GND | GND | — | 共地 |

> **调试接口（保留）**：UART0 使用默认引脚 TX=GPIO43 / RX=GPIO44，连接 PC 用于开发调试和日志输出。

---

## 3. 物理层规范

| 参数 | 值 |
|------|-----|
| 接口 | UART (全双工) |
| 波特率 | **115200** bps |
| 数据位 | 8 |
| 停止位 | 1 |
| 校验位 | 无 |
| 流控 | 无 (仅 TX/RX 两线) |
| 逻辑电平 | 3.3V LVTTL |

---

## 4. 帧格式

### 4.1 基本帧

采用 **JSON Lines** 格式（每行一个完整的 JSON 对象，以 `\n` 结尾）：

```
┌─────────────────────────────────────┬──────┐
│          JSON Body (UTF-8)          │  \n  │
│  {"type":"task_done","task":"...",...}   │  0x0A │
└─────────────────────────────────────┴──────┘
```

### 4.2 帧规则

| 规则 | 说明 |
|------|------|
| 编码 | UTF-8，无 BOM |
| 分隔符 | 每帧以 `\n` (0x0A) 结束 |
| 帧内禁止换行 | JSON 对象内部不得包含 `\n`，使用 `cJSON_PrintUnformatted()` 生成 |
| 最大帧长 | ≤ **2048 字节** |
| 解析方式 | 按 `\n` 分割帧 → `cJSON_Parse()` 解析 JSON |
| 空白帧忽略 | 收到空行或纯空白行直接丢弃 |

---

## 5. 通信模型

### 5.1 下行命令 (WS63 → ESP32)

**命令格式**：
```json
{"cmd":"command_name","param1":"value1","param2":"value2"}
```

**通用字段**：
- `cmd`: 命令名称（必填）
- 其他字段根据具体命令而定

### 5.2 上行消息 (ESP32 → WS63)

**消息格式**：
```json
{"type":"message_type","field1":"value1","field2":"value2"}
```

**通用字段**：
- `type`: 消息类型（必填）
- 其他字段根据具体消息而定

---

## 6. 下行命令 WS63 → ESP32

### 6.1 register - 资产注册 ⭐ v3.2


**Tag ID 格式规范**：
| 规则 | 值 |
|------|-----|
| 输入长度 | 4字符短格式（`0x01`）或 6字符标准格式（`0x0001`） |
| 存储格式 | 统一标准化为6字符（`0x` + 4位大写十六进制） |
| 范围 | `0x0001` - `0xFFFF`（65000+唯一标识，`0x01`=`0x0001`） |
| 大小写 | 不敏感，存储时统一转为大写 |
| 文件命名 | 直接使用 `0x0001.dat`（无需转义） |

**验证规则**：
- ✅ 合法（标准）：`0x0001`, `0x00AB`, `0xABCD`, `0xFFFF`
- ✅ 合法（短格式）：`0x01`, `0xFF`, `0xAB`（自动补零为 `0x0001`, `0x00FF`, `0x00AB`）
- ❌ 非法：`0x0000`（最小值以下）, `0x10000`（超范围）, `0xGGGG`（非hex）

#### 模式A：完整注册（新资产）

**命令格式**：
```json
{
  "cmd": "register",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "is_overwrite": false
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cmd | string | ✅ | 固定值"register" |
| tag_id | string | ✅* | Tag ID（格式：0x01-0xFFFF，支持短格式如0x01）⭐替代mac |
| mac | string | ❌* | 旧MAC地址格式（向后兼容，与tag_id二选一） |
| item_name | string | ✅ | 物品名称（验证模式时可选） |
| storage_area | string | ✅ | 存放区域（验证模式时可选） |
| quantity | number | ✅ | 数量（首次注册）或累加数量（验证模式） |
| is_overwrite | bool | ❌ | 是否允许覆写已有资产。默认 `false`（安全保护）。`true`=允许覆写，`false`=拒绝覆写。不传此字段时等效于 `false` |

> *`tag_id`和`mac`二选一，推荐使用`tag_id`

**完整注册响应**：
```
{
  "type": "task_done",
  "task": "register",
  "result": "success",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "is_overwrite": false,
  "file_size_kb": 45
}
```

#### 模式B：验证式更新（已有资产累加）⭐NEW

**触发条件**：当 `tag_id` 已存在的资产记录，且命令中**不包含** `item_name` 字段

**命令格式**（仅需 tag_id + quantity）：
```json
{
  "cmd": "register",
  "tag_id": "0x0001",
  "quantity": 20
}
```

**执行流程**：
```
WS63 → ESP32: {"cmd":"register","tag_id":"0x0001","quantity":20}
ESP32: 检查资产 0x0001 → 已存在（扳手，50件）
ESP32 → WS63: {"type":"verification_start","tag_id":"0x0001",
                "existing_item":"扳手","current_qty":50,
                "required_view":"front","message":"请拍摄正视图验证"}
WS63 → ESP32: {"cmd":"capture","view":"front"}
ESP32: 拍摄正视图 → 提取特征 → 计算相似度
├─ 相似度≥0.75 ✅ → 累加数量: 50+20=70
│  ESP32 → WS63: {"type":"task_done","task":"register","result":"success_updated",
│                  "tag_id":"0x0001","item_name":"扳手",
│                  "previous_qty":50,"added_qty":20,"new_qty":70,
│                  "verification":{"confidence":0.92,"threshold":0.75,"passed":true}}
└─ 相似度<0.75 ❌ → 拒绝更新
   ESP32 → WS63: {"type":"error","code":"ERR_VERIFICATION_FAILED",
                   "msg":"Item mismatch! Similarity: 0.45 < threshold 0.75",
                   "details":{"tag_id":"0x0001","existing_item":"扳手",
                              "captured_similarity":0.45,"threshold":0.75}}
```

**验证开始消息**：
```json
{
  "type": "verification_start",
  "tag_id": "0x0001",
  "existing_item": "扳手",
  "current_qty": 50,
  "required_view": "front",
  "message": "Please capture FRONT view for verification"
}
```

**验证成功响应**：
```json
{
  "type": "task_done",
  "task": "register",
  "result": "success_updated",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "previous_qty": 50,
  "added_qty": 20,
  "new_qty": 70,
  "verification": {
    "confidence": 0.92,
    "threshold": 0.75,
    "passed": true
  }
}
```

**验证失败响应**：
```json
{
  "type": "error",
  "code": "ERR_VERIFICATION_FAILED",
  "msg": "Item mismatch! Similarity: 0.45 < threshold 0.75",
  "details": {
    "tag_id": "0x0001",
    "existing_item": "扳手",
    "captured_similarity": 0.45,
    "threshold": 0.75,
    "suggestion": "Please check if correct item is placed"
  }
}
```

---

### 6.2 inventory - 资产盘点 ⭐ v3.2

**Tag ID格式**：`0x0001-0xFFFF`

**命令格式**：
```json
{
  "cmd": "inventory",
  "tag_id": "0x0001",
  "expected_qty": 50
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cmd | string | ✅ | 固定值"inventory" |
| tag_id | string | ✅* | Tag ID（格式：0x0001-0xFFFF）⭐替代mac |
| mac | string | ❌* | 旧MAC地址格式（向后兼容，与tag_id二选一） |
| expected_qty | number | ❌ | 预期数量（可选，用于比对） |

> *`tag_id`和`mac`二选一，推荐使用`tag_id`

**执行流程**：
1. ESP32收到盘点命令，立即先查询资产数据库
2. **返回资产基本信息**（名称、数量、区域）
3. 引导拍摄三视图（正面、侧面、顶部）
4. 每帧采集3张图像进行多帧融合
5. 提取MobileNetV2特征向量（1280维）
6. 计算加权综合置信度
7. 返回盘点结果

**资产信息消息**（ESP32 → WS63，在盘点命令收到后立即返回）：
```json
{
  "type": "asset_info",
  "task": "inventory",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50
}
```

**WS63 可依据 `asset_info` 中的信息在串口屏上显示资产详情，
以便用户在拍照前确认资产身份。**

**盘点完成响应**：
```json
{
  "type": "task_done",
  "task": "inventory",
  "result": "success",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "is_match": true,
  "weighted_confidence": 0.88,
  "front_confidence": 0.92,
  "side_confidence": 0.85,
  "top_confidence": 0.83,
  "threshold": 0.75
}
```

---

### 6.3 outbound - 出库操作 ⭐ v3.2

**Tag ID格式**：`0x0001-0xFFFF`

**命令格式**：
```json
{
  "cmd": "outbound",
  "tag_id": "0x0001",
  "remove_qty": 5
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cmd | string | ✅ | 固定值"outbound" |
| tag_id | string | ✅* | Tag ID（格式：0x0001-0xFFFF）⭐替代mac |
| mac | string | ❌* | 旧MAC地址格式（向后兼容，与tag_id二选一） |
| remove_qty | number | ✅ | 出库数量 |

> *`tag_id`和`mac`二选一，推荐使用`tag_id`

**执行流程**（分步控制）：
1. ESP32收到出库命令，立即查询资产数据库
2. **返回资产基本信息**（名称、数量、出库数、剩余数）
3. 等待 WS63 发送 `capture` 命令（硬件不提前初始化）
4. 收到 `capture front` 后初始化 AI + 摄像头
5. 拍摄正视图 → 提取特征 → 与参考特征比对
6. 匹配成功则更新数量（减去 remove_qty）
7. 返回盘点结果

**资产信息消息**（ESP32 → WS63，在出库命令收到后立即返回）：
```json
{
  "type": "asset_info",
  "task": "outbound",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "remove_qty": 5,
  "remaining_qty": 45
}
```

**WS63 可依据 `asset_info` 中的信息在串口屏上显示出库详情（物品名称、当前库存、出库数量、出库后剩余），用户确认后再发送 `capture` 命令拍照验证。**

**完整时序交互**：
```
WS63                           ESP32
  │                               │
  │── {"cmd":"outbound",          │
  │    "tag_id":"0x0001",         │
  │    "remove_qty":5}            │
  │                               │── asset_load → 读取资产记录
  │◄── asset_info ──────────────│  (立即返回，此时未初始化硬件)
  │    {item_name:"扳手",          │
  │     quantity:50,               │
  │     remove_qty:5,              │
  │     remaining_qty:45}          │
  │                               │
  │── {"cmd":"capture",           │  ← WS63 收到 asset_info 后确认无误
  │    "view":"front"}            │    再发送 capture 命令
  │                               │── ai_module_init() 【此刻才初始化】
  │                               │── camera_module_init()
  │                               │── 拍摄 → 特征提取 → 匹配
  │                               │── 匹配成功则更新数量
  │◄── task_done ───────────────│
  │    {result:"success",          │
  │     is_match:true,             │
  │     item_name:"扳手",           │
  │     original_qty:50,           │
  │     remove_qty:5,              │
  │     remaining_qty:45}          │
```

**响应示例**：
```
{
  "type": "task_done",
  "task": "outbound",
  "result": "success",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "is_match": true,
  "confidence": 0.92,
  "threshold": 0.75,
  "original_qty": 50,
  "remove_qty": 5,
  "remaining_qty": 45,
  "asset_deleted": false
}
```

---

### 6.4 capture - 分步拍摄控制 ⭐NEW v3.0

**命令格式**：
```json
{"cmd":"capture","view":"front"}
```

**视图选项**：
- `front`: 正视图
- `side`: 侧视图
- `top`: 俯视图

**响应**：
```json
{
  "type": "capture_progress",
  "tag_id": "0x0001",
  "view": "front",
  "step": "1/3",
  "status": "ok",
  "blur_score": 87.3,
  "feature_size": 1280
}
```

---

### 6.5 delete - 删除资产 ⭐ v3.2

**Tag ID格式**：`0x0001-0xFFFF`

**命令格式**：
```json
{
  "cmd": "delete",
  "tag_id": "0x0001"
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cmd | string | ✅ | 固定值"delete" |
| tag_id | string | ✅* | Tag ID（格式：0x0001-0xFFFF）⭐替代mac |
| mac | string | ❌* | 旧MAC地址格式（向后兼容，与tag_id二选一） |

> *`tag_id`和`mac`二选一，推荐使用`tag_id`

**⚠️ 重要提示**：
- WS63 应在发送此命令前自行完成用户确认
- ESP32 收到后**直接执行删除**，不再二次确认
- 删除操作不可恢复，会同时删除资产记录文件和JPEG图像

**响应示例**：
```
// 成功
{
  "type": "task_done",
  "task": "delete",
  "result": "success",
  "tag_id": "0x0001"
}

// 失败（资产不存在）
{
  "type": "error",
  "code": "ERR_ASSET_NOT_FOUND",
  "msg": "Asset not found: 0x0001"
}
```

---

### 6.6 cancel - 取消当前任务

**命令格式**：
```json
{"cmd": "cancel"}
```

**功能说明**：
- 立即中断正在执行的任务（register/inventory/outbound）
- 关闭摄像头，释放资源，重置状态机
- **唯一能在 BUSY 状态下响应的业务命令**

**适用场景**：
- 用户主动中止操作
- 检测到异常情况需要紧急停止
- 超时保护机制触发

**执行流程**：
1. 检查当前是否有正在执行的任务
2. 如果有，安全终止拍摄和推理过程
3. 关闭摄像头硬件
4. 清理临时资源（特征缓冲区等）
5. 重置状态机到 IDLE

**响应示例**：
```
// 成功取消注册任务
{
  "type": "task_done",
  "task": "register",
  "result": "cancelled"
}

// 成功取消盘点任务
{
  "type": "task_done",
  "task": "inventory",
  "result": "cancelled"
}

// 无任务可取消（空闲状态）
{
  "type": "error",
  "code": "ERR_INVALID_STATE",
  "msg": "No active task to cancel"
}
```

**状态机影响**：
```
CAPTURING ──[cancel]──► CLEANING ──[完成]──► IDLE
FINALIZING ──[cancel]──► CLEANING ──[完成]──► IDLE
```

---

### 6.7 get_asset - 查询单个资产详情 ⭐ v3.2

**Tag ID格式**：`0x0001-0xFFFF`

**命令格式**：
```json
{
  "cmd": "get_asset",
  "tag_id": "0x0001"
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cmd | string | ✅ | 固定值"get_asset" |
| tag_id | string | ✅* | Tag ID（格式：0x0001-0xFFFF）⭐替代mac |
| mac | string | ❌* | 旧MAC地址格式（向后兼容，与tag_id二选一） |

> *`tag_id`和`mac`二选一，推荐使用`tag_id`

**功能说明**：
- 根据 Tag ID 查询单个资产的详细信息
- **可在 BUSY 状态下执行**（不阻塞业务任务）
- 返回资产元数据和统计信息

**响应示例**：
```
// 资产存在
{
  "type": "asset_detail",
  "found": true,
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "created_at": "2026-05-19T10:30:00Z",
  "updated_at": "2026-05-19T15:45:00Z",
  "file_size_kb": 45,
  "has_images": true,
  "image_count": 3
}

// 资产不存在
{
  "type": "asset_detail",
  "found": false,
  "tag_id": "0x0001"
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值"asset_detail" |
| found | boolean | 资产是否存在 |
| tag_id | string | 资产Tag ID |
| item_name | string | 物品名称（仅found=true时） |
| storage_area | string | 存放区域（仅found=true时） |
| quantity | number | 当前数量（仅found=true时） |
| created_at | string | 创建时间ISO8601格式（仅found=true时） |
| updated_at | string | 最后更新时间（仅found=true时） |
| file_size_kb | number | 资产文件大小KB（仅found=true时） |
| has_images | boolean | 是否有JPEG图像（仅found=true时） |
| image_count | number | 图像数量（0-3，仅found=true时） |

---

### 6.8 ping - 心跳检测

**命令格式**：
```json
{"cmd": "ping"}
```

**功能说明**：
- 用于检测 ESP32 是否在线和正常工作
- **可在 BUSY 状态下执行**（不阻塞业务任务）
- 返回系统关键组件状态和健康指标

**适用场景**：
- WS63 定期健康检查（建议间隔30秒）
- 任务下发前确认设备就绪
- 故障诊断和远程调试

**响应示例**：
```
{
  "type": "pong",
  "camera_ready": true,
  "storage_ready": true,
  "ai_model_loaded": true,
  "current_state": "idle",
  "heap_free": 125000,
  "uptime_sec": 3600
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值"pong" |
| camera_ready | boolean | 摄像头是否就绪 |
| storage_ready | boolean | SD卡是否挂载成功 |
| ai_model_loaded | boolean | AI模型是否加载 |
| current_state | string | 当前状态机状态："idle"/"initializing"/"capturing"/"finalizing" |
| heap_free | number | 可用堆内存（字节） |
| uptime_sec | number | 系统运行时间（秒） |

**状态说明**：
| current_state | 含义 | 是否可接受新任务 |
|--------------|------|----------------|
| idle | 空闲 | ✅ 是 |
| initializing | 初始化中 | ❌ 否 |
| capturing | 拍摄中 | ❌ 否 |
| finalizing | 处理中 | ❌ 否 |

**异常响应**：
```
// 摄像头未就绪
{
  "type": "pong",
  "camera_ready": false,
  "storage_ready": true,
  "ai_model_loaded": true,
  "current_state": "idle",
  "heap_free": 120000,
  "uptime_sec": 3600
}

// SD卡未挂载
{
  "type": "pong",
  "camera_ready": true,
  "storage_ready": false,
  "ai_model_loaded": true,
  "current_state": "idle",
  "heap_free": 125000,
  "uptime_sec": 3600
}
```

---

### 6.9 list_assets_page - 分页查询资产列表 ⭐ v3.4

**命令格式**：
```json
{
  "cmd": "list_assets_page",
  "page": 1,
  "page_size": 6
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| cmd | string | ✅ | - | 固定值"list_assets_page" |
| page | number | ❌ | 1 | 页码，从1开始 |
| page_size | number | ❌ | 6 | 每页条数（1-100） |

**功能说明**：
- 支持分页查询资产列表，避免一次返回过多数据导致串口屏卡顿
- 返回总记录数和总页数，方便串口屏渲染分页控件
- 可在 **IDLE 状态下执行**（不阻塞业务任务）

**响应格式**：
```json
{
  "type": "asset_list_page",
  "page": 1,
  "page_size": 6,
  "total_count": 23,
  "total_pages": 4,
  "assets": [
    {"tag_id":"0x0001","item_name":"扳手","storage_area":"A","quantity":50},
    {"tag_id":"0x0002","item_name":"螺丝刀","storage_area":"B","quantity":30},
    {"tag_id":"0x00AB","item_name":"钳子","storage_area":"A","quantity":20},
    {"tag_id":"0x0005","item_name":"锤子","storage_area":"C","quantity":15},
    {"tag_id":"0x0007","item_name":"电钻","storage_area":"B","quantity":8},
    {"tag_id":"0x0009","item_name":"螺丝","storage_area":"A","quantity":200}
  ]
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值"asset_list_page" |
| page | number | 当前页码 |
| page_size | number | 每页条数 |
| total_count | number | 资产总数 |
| total_pages | number | 总页数 |
| assets | array | 资产对象数组（最多 page_size 条） |

**串口屏分页交互示例**：
```
串口屏                          WS63                        ESP32
  │                               │                            │
  │── 进入资产列表页               │                            │
  │                               │── list_assets_page        │
  │                               │   {"page":1,"page_size":6}│
  │                               │◄── asset_list_page ──────│
  │                               │   {page:1, total_pages:4} │
  │◄── 渲染第1页 "第1/4页"                               │
  │── 点击"下一页"                  │                            │
  │                               │── list_assets_page        │
  │                               │   {"page":2,"page_size":6}│
  │                               │◄── asset_list_page ──────│
  │◄── 渲染第2页                                              │
```

---

### 6.10 sys_info - 查询系统信息

**命令格式**：
```json
{"cmd":"sys_info"}
```

**响应**：
```json
{
  "type": "system_info",
  "heap_free": 125000,
  "sd_total_mb": 7580,
  "sd_used_mb": 1250,
  "sd_free_mb": 6330,
  "firmware_version": "v3.2",
  "state": "idle"
}
```

---

## 7. 上行消息 ESP32 → WS63

### 7.1 task_done - 任务完成 ⭐ v3.2

**触发时机**：register/inventory/outbound任务完成

**消息格式**：
```json
{
  "type": "task_done",
  "task": "register",
  "result": "success",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "quantity": 50,
  "is_overwrite": false,
  "file_size_kb": 45
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值"task_done" |
| task | string | 任务类型："register"/"inventory"/"outbound" |
| result | string | 结果："success"/"success_updated"/"failed" |
| tag_id | string | ⭐资产Tag ID（格式：0x0001-0xFFFF） |
| item_name | string | 物品名称 |
| storage_area | string | 存放区域 |
| quantity | number | 数量（注册/盘点）或新数量（出库） |
| is_overwrite | boolean | 是否覆盖已有资产 |
| file_size_kb | number | 资产文件大小（KB） |

**验证式更新响应**（result="success_updated"）：
```json
{
  "type": "task_done",
  "task": "register",
  "result": "success_updated",
  "tag_id": "0x0001",
  "item_name": "扳手",
  "storage_area": "A",
  "previous_qty": 50,
  "added_qty": 20,
  "new_qty": 70,
  "verification": {
    "confidence": 0.92,
    "threshold": 0.75,
    "passed": true
  }
}
```

---

### 7.2 capture_progress - 拍摄进度 ⭐ v3.2

**触发时机**：每次视图拍摄完成

**消息格式**：
```json
{
  "type": "capture_progress",
  "tag_id": "0x0001",
  "view": "front",
  "step": "1/3",
  "status": "ok",
  "blur_score": 87.3,
  "feature_size": 1280
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值"capture_progress" |
| tag_id | string | ⭐当前任务的Tag ID |
| view | string | 视图类型："front"/"side"/"top" |
| step | string | 进度："1/3"、"2/3"、"3/3" |
| status | string | 状态："ok"/"retry"/"failed" |
| blur_score | number | 模糊度评分（0-100，越高越清晰） |
| feature_size | number | 特征向量维度（1280） |

---

### 7.3 error - 错误消息

**触发时机**：任何命令执行失败

**消息格式**：
```
{
  "type": "error",
  "code": "ERR_INVALID_ARG",
  "msg": "Invalid argument: tag_id field missing"
}
```

---

## 8. 任务时序流程

### 8.1 注册流程

```
WS63                          ESP32
 │                              │
 │── register ──────────────►│
 │                              │── 初始化摄像头
 │                              │── 拍摄三视图（front/side/top）
 │                              │── 提取特征向量
 │                              │── 保存到SD卡
 │◄── task_done ────────────│
```

### 8.2 盘点流程

```
WS63                          ESP32
 │                              │
 │── inventory ─────────────►│
 │                              │── 拍摄三视图
 │                              │── 多帧融合
 │                              │── 特征匹配
 │                              │── 计算置信度
 │◄── task_done ────────────│
```

---

## 9. 错误码定义

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `ERR_INVALID_JSON` | JSON解析失败 | 检查JSON格式是否正确 |
| `ERR_UNKNOWN_CMD` | 未知命令 | 检查cmd字段值 |
| `ERR_MISSING_FIELD` | 缺少必填字段 | 补充缺失字段（如tag_id） |
| `ERR_INVALID_MAC` | ⚠️MAC地址格式错误（已弃用） | 请使用tag_id字段（0x0001-0xFFFF） |
| `ERR_INVALID_TAG_ID` | ⭐Tag ID格式无效 | 使用0x0001-0xFFFF格式 |
| `ERR_INVALID_FIELD` | 字段值无效 | 检查字段取值范围 |
| `ERR_ASSET_NOT_FOUND` | 资产不存在 | 检查Tag ID是否正确 |
| `ERR_ASSET_ALREADY_EXISTS` | 资产已存在 | 设置is_overwrite=true或使用验证式更新 |
| `ERR_STORAGE_NOT_READY` | 存储未就绪 | 检查SD卡状态 |
| `ERR_CAMERA_FAIL` | 摄像头初始化失败 | 检查硬件连接和供电 |
| `ERR_AI_MODEL_FAIL` | AI模型初始化失败 | 检查esp-dl组件 |
| `ERR_CAPTURE_FAIL` | 拍摄失败 | 检查摄像头状态 |
| `ERR_BLUR_DETECTED` | 图像模糊 | 调整光线或重新拍摄 |
| `ERR_INFERENCE_FAIL` | 推理失败 | 检查AI模块状态 |
| `ERR_SAVE_FAIL` | 保存失败 | 检查存储空间 |
| `ERR_INTERNAL_ERROR` | 内部错误 | 查看日志排查原因 |
| `ERR_NOT_INITIALIZED` | 未初始化 | 先执行初始化命令 |
| `ERR_TASK_BUSY` | 其他任务进行中 | 等待当前任务完成 |
| `ERR_INVALID_STATE` | 无效状态 | 检查状态机流转 |
| `ERR_INVALID_ARG` | 通用参数错误 | 检查参数类型和范围 |
| `ERR_CAMERA_INIT` | 摄像头初始化失败 | 检查硬件连接（同ERR_CAMERA_FAIL） |
| `ERR_SD_CARD` | SD卡错误 | 检查SD卡格式和状态 |
| `ERR_INSUFFICIENT_SPACE` | 存储空间不足 | 清理SD卡或更换大容量卡 |
| `ERR_LOW_CONFIDENCE` | 置信度过低 | 改善光照条件或重新拍摄 |
| `ERR_TIMEOUT` | 超时 | 检查模块响应和网络状态 |
| `ERR_VERIFICATION_FAILED` | ⭐验证失败（物品不匹配） | 确认物品是否正确放置 |
| `ERR_VERIFY_RETRIES_EXCEEDED` | ⭐验证重试超限 | 联系管理员人工处理 |

**注意**：
- ⚠️ `ERR_INVALID_MAC` 已标记为弃用，推荐使用 `ERR_INVALID_TAG_ID`
- ✅ v3.2版本新增 `ERR_INVALID_TAG_ID`、`ERR_VERIFICATION_FAILED`、`ERR_VERIFY_RETRIES_EXCEEDED`
- `ERR_CAMERA_INIT` 与 `ERR_CAMERA_FAIL` 功能相同，建议统一使用 `ERR_CAMERA_FAIL`
- 所有错误码均已在代码中实现（见 [protocol_handler.h](../main/modules/system/protocol_handler.h)）

---

## 10. 状态机

### 10.1 ESP32工作状态

```
IDLE ──[register/inventory]──► INITIALIZING
     ──[capture]─────────────► WAITING_CAPTURE
     ──[拍摄中]──────────────► CAPTURING
     ──[处理中]──────────────► FINALIZING
     ──[完成]────────────────► IDLE
```

**状态说明**：
- **IDLE**: 空闲，等待命令
- **INITIALIZING**: 初始化摄像头
- **WAITING_CAPTURE**: 等待WS63发送capture命令
- **CAPTURING**: 正在拍摄
- **FINALIZING**: 图像处理中

---

## 11. L610系统架构

### 11.1 三方通信架构

```
┌──────────────┐         UART1          ┌──────────────┐         UART2          ┌──────────────┐
│     WS63      │ ◄────────────────────► │   ESP32-S3   │ ◄────────────────────► │    L610      │
│  (主控/Host)  │   JSON Commands        │  (网关/GW)   │   AT Commands          │  (4G Module) │
│              │   cJSON Protocol       │              │   URC Events           │              │
└──────────────┘                        └──────────────┘                        └──────────────┘
     │                                        │                                        │
     ▼                                        ▼                                        ▼
  业务逻辑                              协议转换                               MQTT云端通信
  UI交互                                状态管理                               4G网络连接
  云平台对接                            资源调度                               AT指令执行
```

**核心职责分工**：

| 组件 | 职责 | 通信接口 |
|------|------|----------|
| **WS63** | 业务编排、用户交互、结果展示 | UART1 (JSON) |
| **ESP32-S3** | 协议转换、状态管理、资源调度 | UART1 (JSON) + UART2 (AT) |
| **L610** | 4G网络连接、MQTT通信、AT指令执行 | UART2 (AT) |

---

## 12. L610硬件连接

### 12.1 ESP32-S3 ↔ L610 连接

| 信号 | ESP32-S3 引脚 | L610 引脚 | 方向 | 说明 |
|------|-------------|----------|------|------|
| UART TX | **GPIO4** | RX | ESP32 → L610 | AT指令发送 |
| UART RX | **GPIO5** | TX | L610 → ESP32 | URC事件接收 |
| GND | GND | GND | — | 共地（必须） |
| VCC | 3.3V/5V | VCC | — | 供电（根据模块规格） |

> ⚠️ **重要提示**：
> - L610模块峰值电流可达2A，建议使用独立电源或确保供电稳定
> - 必须连接4G天线，否则信号极弱
> - SIM卡必须已激活且有流量套餐

### 12.2 UART配置参数

| 参数 | 值 |
|------|-----|
| 接口 | UART_NUM_2 |
| 波特率 | **115200** bps |
| 数据位 | 8 |
| 停止位 | 1 |
| 校验位 | 无 |
| 流控 | 无 |
| 缓冲区大小 | 2048 字节 |

---

## 13. L610下行命令 (WS63 → ESP32)

### 13.1 mqtt_connect - 连接MQTT服务器

**命令格式**：
```json
{
  "cmd": "mqtt_connect",
  "host": "mqtt.thingskit.com",
  "port": 1883,
  "clean_session": 1,
  "keepalive": 60
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| cmd | string | ✅ | - | 固定值"mqtt_connect" |
| host | string | ✅ | - | MQTT服务器地址 |
| port | number | ❌ | 1883 | 端口号 |
| clean_session | number | ❌ | 1 | 清除会话标志（0/1） |
| keepalive | number | ❌ | 60 | 心跳间隔（秒），范围1-300 |

**前置条件**：
- ✅ L610模块已初始化（状态为READY）
- ✅ 网络附着成功（AT+CGATT?返回1）
- ✅ 信号质量良好（AT+CSQ > 10）

**执行流程**：
1. ESP32检查L610模块状态
2. 动态生成ClientID：`WS63-{MAC}`（在register时已生成）
3. 调用`l610_mqtt_set_user()`设置MQTT凭据
4. 调用`l610_mqtt_connect()`发起连接
5. 等待L610返回+MQTTOPEN URC事件（超时15秒）
6. 向WS63上报连接结果

**响应示例**：
```
// 成功
{
  "type": "mqtt_connected",
  "state": "connected",
  "host": "mqtt.thingskit.com",
  "port": 1883
}

// 失败
{
  "type": "mqtt_error",
  "code": "MQTT_CONNECT_FAILED",
  "msg": "MQTT connection failed"
}
```

---

### 13.2 mqtt_publish - 发布MQTT消息

**命令格式**：
```json
{
  "cmd": "mqtt_publish",
  "topic": "device/status",
  "payload": "{\"mac\":\"AA:BB:CC:DD:EE:FF\",\"status\":\"online\"}",
  "qos": 1,
  "retain": 0
}
```

**字段说明**：
| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| cmd | string | ✅ | - | 固定值"mqtt_publish" |
| topic | string | ✅ | - | MQTT主题（建议≤128字节） |
| payload | string | ✅ | - | 消息内容 |
| qos | number | ❌ | 1 | QoS等级（0/1/2） |
| retain | number | ❌ | 0 | 保留标志（0/1） |

**⚠️ 限制条件**：
- **Payload最大长度：1024字节**（超过返回ERR_INVALID_SIZE）
- 必须在MQTT连接状态下执行
- AT指令总长度不能超过UART缓冲区（2048字节）

**执行流程**：
1. 检查payload长度（≤1024字节）
2. 估算AT指令总长度：`AT+MQTTPUB=1,"{topic}",{qos},{retain},"{payload}"`
3. 构造AT+MQTTPUB指令并发送至L610
4. 等待+MQTTPUB URC事件（超时10秒）
5. 向WS63上报发布结果

**响应示例**：
```
// 成功
{
  "type": "mqtt_publish_result",
  "result": "ok",
  "topic": "device/status"
}

// Payload超长
{
  "type": "error",
  "code": "ERR_INVALID_SIZE",
  "msg": "Payload too long: 1025 bytes (max 1024)"
}
```

---

### 13.3 mqtt_disconnect - 断开MQTT连接

**命令格式**：
```json
{"cmd": "mqtt_disconnect"}
```

**响应示例**：
```
{
  "type": "mqtt_connected",
  "state": "disconnected",
  "host": "mqtt.thingskit.com",
  "port": 1883
}
```

---

### 13.4 l610_at - AT指令透传（调试用）

**命令格式**：
```json
{"cmd": "l610_at", "at": "AT+CSQ"}
```

**常用AT指令**：
``bash
AT              # 测试通信
AT+CSQ          # 信号质量（返回：+CSQ: 25,99）
AT+CGATT?       # 网络附着状态（返回：+CGATT: 1）
AT+CREG?        # 注册状态（返回：+CREG: 0,1）
AT+MQTTLOG=1    # 开启MQTT详细日志
```

**响应示例**：
```
// 成功
{
  "type": "l610_at_result",
  "cmd": "AT+CSQ",
  "result": "ok",
  "response": "+CSQ: 25,99\r\nOK"
}

// 超时
{
  "type": "l610_error",
  "code": "L610_AT_TIMEOUT",
  "msg": "L610 not responding"
}
```

---

### 13.5 l610_status - 查询L610状态

**命令格式**：
```json
{"cmd": "l610_status"}
```

**响应示例**：
```
{
  "type": "l610_status",
  "l610_state": "READY",
  "mqtt_state": "CONNECTED",
  "signal_quality": 25,
  "network_attached": true,
  "current_host": "mqtt.thingskit.com",
  "current_port": 1883
}
```

---

## 14. L610上行消息 (ESP32 → WS63)

### 14.1 mqtt_connected - MQTT连接成功

**消息格式**：
```json
{
  "type": "mqtt_connected",
  "state": "connected",
  "host": "mqtt.thingskit.com",
  "port": 1883
}
```

**触发时机**：
- `mqtt_connect`命令执行成功
- 收到L610的+MQTTOPEN: 1,0 URC事件

---

### 14.2 mqtt_error - MQTT错误

**消息格式**：
```json
{
  "type": "mqtt_error",
  "code": "MQTT_CONNECT_FAILED",
  "msg": "MQTT connection failed"
}
```

**常见错误码**：
| code | 说明 | 可能原因 |
|------|------|----------|
| MQTT_CONNECT_FAILED | 连接失败 | 网络异常/服务器不可达/认证失败 |
| MQTT_PUBLISH_FAILED | 发布失败 | QoS超时/主题无效/Payload过长 |
| MQTT_DISCONNECTED | 意外断开 | 网络中断/服务器关闭连接/心跳超时 |

---

### 14.3 l610_error - L610模块错误（⭐主动上报）

**消息格式**：
```json
{
  "type": "l610_error",
  "code": "L610_NOT_RESPONDING",
  "msg": "L610 module not responding"
}
```

**触发场景**：

#### 场景1：模块失联
- **检测方式**：心跳任务连续3次AT指令超时
- **错误码**：`L610_NOT_RESPONDING`
- **日志**：`W (xxx) l610_driver: AT timeout after 5000 ms (consecutive=3/3, LOST)`

#### 场景2：MQTT意外断开
- **检测方式**：收到L610的+MQTTBROKEN URC事件
- **错误码**：`MQTT_DISCONNECTED`
- **日志**：`W (xxx) l610_manager: MQTT disconnected (URC received)`

#### 场景3：网络异常
- **检测方式**：AT+CGATT?返回0
- **错误码**：`NETWORK_DETACHED`

**重要性**：
- ✅ 这是v3.1新增的**主动上报机制**
- ✅ L610管理器通过回调函数主动向WS63发送
- ✅ 无需WS63轮询，实时性更高

---

### 14.4 mqtt_publish_result - MQTT发布结果 ⭐NEW v3.1

**消息格式**：
```json
{
  "type": "mqtt_publish_result",
  "result": "ok",
  "topic": "device/status"
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值 `"mqtt_publish_result"` |
| result | string | 结果：`"ok"` / `"failed"` |
| topic | string | 发布的MQTT主题 |

**触发时机**：
- `mqtt_publish`命令执行完成后
- 收到L610的+MQTTPUB URC事件后

**示例**：
```json
// 成功
{
  "type": "mqtt_publish_result",
  "result": "ok",
  "topic": "device/status"
}

// 失败
{
  "type": "error",
  "code": "ERR_INVALID_SIZE",
  "msg": "Payload too long: 1025 bytes (max 1024)"
}
```

---

### 14.5 l610_at_result - AT指令结果 ⭐NEW v3.1

**消息格式**：
```json
{
  "type": "l610_at_result",
  "cmd": "AT+CSQ",
  "result": "ok",
  "response": "+CSQ: 25,99\r\nOK"
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值 `"l610_at_result"` |
| cmd | string | 执行的AT指令 |
| result | string | 结果：`"ok"` / `"timeout"` / `"error"` |
| response | string | L610返回的原始响应（包含`\r\n`） |

**触发时机**：
- `l610_at`命令执行完成后
- AT指令超时或出错时

**示例**：
```
// 成功 - 信号质量查询
{
  "type": "l610_at_result",
  "cmd": "AT+CSQ",
  "result": "ok",
  "response": "+CSQ: 25,99\r\nOK"
}

// 成功 - 网络附着状态
{
  "type": "l610_at_result",
  "cmd": "AT+CGATT?",
  "result": "ok",
  "response": "+CGATT: 1\r\nOK"
}

// 超时
{
  "type": "l610_error",
  "code": "L610_AT_TIMEOUT",
  "msg": "L610 not responding after 3 retries"
}
```

**常用AT指令参考**：
| 指令 | 说明 | 预期响应 |
|------|------|----------|
| `AT` | 测试通信 | `OK` |
| `AT+CSQ` | 信号质量 | `+CSQ: 25,99` |
| `AT+CGATT?` | 网络附着 | `+CGATT: 1` |
| `AT+CREG?` | 注册状态 | `+CREG: 0,1` |
| `AT+MQTTLOG=1` | MQTT日志 | `OK` |

---

### 14.6 l610_status - L610模块状态 ⭐NEW v3.1

**消息格式**：
```json
{
  "type": "l610_status",
  "l610_state": "READY",
  "mqtt_state": "CONNECTED",
  "signal_quality": 25,
  "network_attached": true,
  "current_host": "mqtt.thingskit.com",
  "current_port": 1883
}
```

**字段说明**：
| 字段 | 类型 | 说明 |
|------|------|------|
| type | string | 固定值 `"l610_status"` |
| l610_state | string | 模块状态：`"INIT"` / `"READY"` / `"LOST"` |
| mqtt_state | string | MQTT状态：`"DISCONNECTED"` / `"CONNECTING"` / `"CONNECTED"` |
| signal_quality | number | 信号质量（0-31），99表示未知 |
| network_attached | boolean | 网络附着状态 |
| current_host | string | 当前MQTT服务器地址 |
| current_port | number | 当前MQTT端口 |

**触发时机**：
- `l610_status`命令执行后
- 心跳任务定期上报（可选）

**L610状态说明**：
| 状态 | 说明 |
|------|------|
| `INIT` | 模块初始化中 |
| `READY` | 模块就绪，可以执行AT指令 |
| `LOST` | 模块失联（连续3次AT超时） |

**MQTT状态说明**：
| 状态 | 说明 |
|------|------|
| `DISCONNECTED` | MQTT未连接 |
| `CONNECTING` | 正在连接MQTT服务器 |
| `CONNECTED` | MQTT已连接 |

**示例**：
```json
// 正常状态
{
  "type": "l610_status",
  "l610_state": "READY",
  "mqtt_state": "CONNECTED",
  "signal_quality": 25,
  "network_attached": true,
  "current_host": "mqtt.thingskit.com",
  "current_port": 1883
}

// 模块失联
{
  "type": "l610_status",
  "l610_state": "LOST",
  "mqtt_state": "DISCONNECTED",
  "signal_quality": 99,
  "network_attached": false,
  "current_host": "",
  "current_port": 0
}
```

---

## 15. MQTT业务流程

### 15.1 完整连接流程

```
WS63                          ESP32                         L610
 │                              │                              │
 │── mqtt_connect ──────────►│                              │
 │                              │── AT+MQTTUSER ──────────►│
 │                              │◄── OK ───────────────────│
 │                              │── AT+MQTTOPEN ──────────►│
 │                              │◄── +MQTTOPEN: 1,0 ──────│
 │◄── mqtt_connected ───────│                              │
 │                              │                              │
 │── mqtt_publish ──────────►│                              │
 │                              │── AT+MQTTPUB ───────────►│
 │                              │◄── +MQTTPUB: 1,0 ───────│
 │◄── mqtt_publish_result ──│                              │
 │                              │                              │
 │── mqtt_disconnect ───────►│                              │
 │                              │── AT+MQTTCLOSE ─────────►│
 │                              │◄── OK ───────────────────│
 │◄── mqtt_disconnected ────│                              │
```

### 15.2 ClientID生成规则 ⭐ v3.2

**格式**：`WS63-{TagID}`

**示例**：
- Tag ID：`0x0001`
- ClientID：`WS63-0x0001`

**生成时机**：
- 在`register`命令执行时生成（使用tag_id字段）
- 存储在`g_l610_client_id`全局变量
- 每次`mqtt_connect`时自动使用

**向后兼容**：
- ⚠️ 如果使用旧版mac字段，ClientID将为 `WS63-AA:BB:CC:DD:EE:FF`
- ✅ 推荐使用tag_id字段，ClientID更简洁且符合物联网规范

**优势**：
- ✅ 云端可通过ClientID识别设备来源
- ✅ 每个设备有唯一标识（65000+唯一Tag ID）
- ✅ 符合物联网设备命名规范
- ✅ Tag ID比MAC地址更短，节省MQTT报文长度

---

## 16. 主动上报机制 ⭐NEW v3.1

### 16.1 机制说明

v3.1版本新增了L610模块**主动向WS63上报**的能力，无需WS63轮询查询。

**实现方式**：
1. WS63在`protocol_handler_init()`中注册回调函数
2. L610管理器保存该回调函数指针
3. 检测到URC事件或错误时，直接调用回调发送JSON

**代码实现**：
```c
// protocol_handler.c:L180
void protocol_handler_init(void) {
    // 注册L610主动上报回调
    extern void l610_manager_register_send_func(void (*)(const char *));
    l610_manager_register_send_func(ws63_send_json_raw);
    ESP_LOGI(TAG, "L610 manager send callback registered");
}
```

### 16.2 上报场景

| 场景 | 触发条件 | 错误码 | 上报延迟 |
|------|---------|--------|----------|
| 模块失联 | 连续3次AT超时 | L610_NOT_RESPONDING | ≤90秒（心跳间隔30秒×3） |
| MQTT断开 | 收到+MQTTBROKEN URC | MQTT_DISCONNECTED | <1秒（URC即时处理） |
| 网络异常 | CGATT状态变为0 | NETWORK_DETACHED | ≤30秒（下次心跳检测） |

---

## 17. AT指令透传调试

### 17.1 常用AT指令速查

| 指令 | 说明 | 预期响应 | 用途 |
|------|------|----------|------|
| `AT` | 测试通信 | `OK` | 验证模块在线 |
| `AT+CSQ` | 信号质量 | `+CSQ: 25,99` | 检查信号强度 |
| `AT+CGATT?` | 网络附着 | `+CGATT: 1` | 确认GPRS附着 |
| `AT+CREG?` | 注册状态 | `+CREG: 0,1` | 检查网络注册 |
| `AT+MQTTLOG=1` | MQTT日志 | `OK` | 开启详细日志 |

---

## 18. 错误处理与重试

### 18.1 AT指令重试机制 ⭐NEW v3.1

**问题**：单次AT超时直接返回错误，网络波动时容易误判模块失联

**解决方案**：
- 最多重试3次（`L610_AT_MAX_RETRY = 3`）
- 重试间隔200ms
- 根据连续超时次数动态调整日志级别

**日志策略**：
| 连续超时次数 | 日志级别 | 说明 |
|------------|---------|------|
| 1次 | DEBUG | 首次超时，可能是偶发 |
| 2次 | WARNING | 连续超时，需要关注 |
| ≥3次 | ERROR | 达到阈值，标记LOST |

---

### 18.2 Payload长度保护 ⭐NEW v3.1

**限制**：
- Payload限制：最大1024字节
- AT指令总长度估算：防止超过UART缓冲区（2048字节）

**三重防护**：
1. 协议层检查（protocol_handler.c）
2. 驱动层检查（l610_mqtt.c）
3. AT指令总长度估算

---

### 18.3 资源清理机制 ⭐NEW v3.1

**清理内容**：
- 销毁3个信号量（g_mqtt_open_sem, g_mqtt_pub_sem, g_mqtt_close_sem）
- 重置MQTT状态为DISCONNECTED
- 清空host/port缓存

**调用时机**：`l610_manager_stop()`

---

## 19. 配置参数

### 19.1 L610模块配置

```c
// UART配置
#define L610_UART_NUM        UART_NUM_2
#define L610_UART_TX_PIN     GPIO_NUM_4
#define L610_UART_RX_PIN     GPIO_NUM_5
#define L610_UART_BAUD       115200
#define L610_UART_BUF_SIZE   2048

// MQTT配置
#define L610_MQTT_USERNAME   "IekgXZSavYJ6KEJFyvb4"
#define L610_MQTT_PASSWORD   ""
#define L610_MQTT_KEEPALIVE  60
#define L610_MQTT_QOS        1

// 重试配置
#define L610_AT_MAX_RETRY    3
#define L610_AT_DEFAULT_TIMEOUT 5000
#define L610_LOST_THRESHOLD  3

// 心跳配置
#define L610_HEARTBEAT_INTERVAL_SEC 30
```

---

## 20. 测试验证

### 20.1 快速测试清单

- [ ] L610模块通信正常（AT指令响应）
- [ ] 信号质量良好（CSQ > 15）
- [ ] 网络附着成功（CGATT=1）
- [ ] MQTT连接成功
- [ ] 消息发布成功（至少10条）
- [ ] Payload长度保护生效（1025字节拒绝）
- [ ] 断开连接正常
- [ ] 重连功能正常（至少3次）
- [ ] 异常上报机制工作（断开网线测试）
- [ ] 内存无泄漏（运行1小时heap稳定）

### 20.2 详细测试指南

请参考完整的调试指南：**[L610_DEBUG_GUIDE.md](L610_DEBUG_GUIDE.md)**

---

## 21. 常见问题

### 21.1 L610无响应

**排查步骤**：
1. 检查UART接线（TX↔RX交叉）
2. 测量供电电压（应为3.3V或5V）
3. 检查SIM卡是否插入且已激活
4. 使用USB转TTL直接连接L610测试

### 21.2 MQTT连接失败

**排查步骤**：
1. 检查网络连接：`AT+CGATT?`应返回1
2. 检查信号质量：`AT+CSQ`应>10
3. 验证MQTT参数（host/port/username）
4. 查看L610日志：`AT+MQTTLOG=1`开启详细日志

### 21.3 Payload发送失败

**原因**：Payload超过1024字节限制

**解决方案**：
1. 压缩JSON数据
2. 分片发送（多次publish）
3. 使用二进制格式代替JSON

---

## 附录

### A. 相关文档

- **调试指南**：[L610_DEBUG_GUIDE.md](L610_DEBUG_GUIDE.md)
- **快速入门**：[QUICKSTART.md](QUICKSTART.md)
- **用户手册**：[USER_GUIDE.md](USER_GUIDE.md)
- **故障排查**：[TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **版本日志**：README.md §版本历史

### B. 版本历史

- **v3.3** (2026-05-26): 补全缺失命令（delete/cancel/get_asset/ping），完善下行命令体系 ⭐NEW
- **v3.2** (2026-05-19): Tag ID 改造（标识符升级、验证式更新流程）⭐
- **v3.1** (2026-05-10): L610 4G模块完整集成
- **v3.0** (2026-04-29): WS63协议支持
- **v2.x**: 基础资产管理系统功能

---

**文档版本**: v3.3  
**最后更新**: 2026-05-26  
**维护者**: TcXc  
**反馈邮箱**: 202500201056@stumail.sztu.edu.cn
