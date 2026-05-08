# sle_network 模块文档

## 模块作用

管理 WS63 与 BS21E 标签之间的 SLE（星闪低功耗蓝牙）通信全流程，包括设备扫描、连接、SSAP服务发现、数据收发。是系统与物理标签交互的**唯一传输通道**。

## 模块说明

### SLE通信流程

```
扫描(Scan) → 发现目标(Found) → 连接(Connect) → 认证(Auth) → SSAP就绪(Ready)
                                                          ↓
                                              写命令(Write) → 接收通知(Notify)
```

### 核心API

| 函数 | 功能 |
|------|------|
| `sle_network_init()` | 初始化SLE协议栈、注册回调 |
| `sle_network_start_scan()` | 启动SLE扫描，搜索BS21E广播 |
| `sle_network_stop_scan()` | 停止扫描 |
| `sle_network_send_cmd(cmd, param)` | 通过SSAP Write发送命令到BS21E |
| `sle_network_disconnect()` | 断开SLE连接 |
| `sle_network_register_notify_cb(cb)` | 注册BS21E通知回调 |

### 状态查询API

| 函数 | 返回值 | 含义 |
|------|--------|------|
| `sle_network_is_target_found()` | 0=未发现, 1=已发现 | 是否扫描到BS21E |
| `sle_network_is_connected()` | 0=未连接, 1=已连接 | SLE链路是否建立 |
| `sle_network_is_authenticated()` | 0=未认证, 1=已认证 | 是否完成配对认证 |
| `sle_network_is_ssap_ready()` | 0=未就绪, 1=已就绪 | SSAP服务是否可写 |
| `sle_network_get_scan_count()` | 扫描结果数量 | 当前扫描到的设备数 |
| `sle_network_get_scan_active()` | 0=空闲, 1=扫描中 | 扫描是否正在进行 |

### 通知回调

```c
typedef void (*sle_notify_callback)(
    const ssap_inventory_rsp_t *inv,   // 盘点响应（非NULL时有效）
    const ssap_bind_rsp_t *bind        // 绑定响应（非NULL时有效）
);
```

- 回调在SLE协议栈上下文中触发，**不可阻塞**
- `inv` 和 `bind` 最多一个非NULL

### 关键配置参数

| 参数 | 值 | 说明 |
|------|----|------|
| 扫描间隔 | 400 | 单位：SLE时基 |
| 扫描窗口 | 20 | 单位：SLE时基 |
| 连接间隔 | 0x64 | 单位：SLE时基 |
| 连接超时 | 0x1F4 | 单位：SLE时基 |
| MTU | 1500 | SSAP最大传输单元 |
| 目标设备名 | `"BS2x_Tag"` | BS21E广播名称 |
| Service UUID | `0xFF00` | SSAP服务UUID |
| Property UUID | `0xFF01` | SSAP特征UUID |
| 重扫间隔 | 10000ms | 连接断开后重新扫描的等待时间 |

## 模块定位

```
┌─────────────┐
│ business_logic │  业务层：调用 send_cmd()，接收 notify_cb
├─────────────┤
│  sle_network   │  传输层：SLE连接管理+数据收发（本模块）
├─────────────┤
│shared_protocol │  协议层：提供封包/解包函数
└─────────────┘
```

- **依赖**：`shared_protocol`（封包/解包）、SLE SDK API
- **被依赖**：`business_logic`（发送命令、接收通知）
- **不依赖**：`cloud_storage`、`uart_vision`、`app`

## 重点约束

1. **回调上下文不可阻塞**：SLE通知回调在协议栈线程中执行，禁止调用 `osal_msleep`、`cs_mqtt_publish` 等阻塞/耗时操作
2. **SSAP Ready检查**：发送命令前必须检查 `sle_network_is_ssap_ready()`，否则写操作会失败
3. **单连接模型**：当前只支持与一个BS21E设备连接，不支持多设备并发
4. **扫描→连接→SSAP是严格顺序**：必须依次完成，不可跳步
5. **断线后自动重扫**：由 main.c 的 poll 逻辑驱动，不在本模块内自动重连

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_SLE]` | INFO | 扫描启动/停止、设备发现、连接状态变更、SSAP就绪 |
| `[WS63_SLE]` | ERROR | 连接失败、SSAP写失败、认证失败 |
| `[WS63_SLE]` | DEBUG | 通知数据内容、扫描结果详情 |

## 审查清单

- [ ] 发送命令前是否检查 `is_ssap_ready()`
- [ ] 通知回调中是否有阻塞操作
- [ ] 断线后是否清理了SSAP状态
- [ ] 扫描参数是否与BS21E广播参数匹配
- [ ] UUID是否与BS21E端GATT服务一致
- [ ] `send_cmd` 是否对返回值做了检查

## 验证思路

1. **扫描发现**：BS21E上电后，调用 `start_scan()`，观察日志是否打印 `[WS63_SLE] target found`
2. **连接建立**：确认自动连接后日志打印 `connected` + `authenticated` + `ssap ready`
3. **命令下发**：调用 `send_cmd(SSAP_CMD_INVENTORY, 0)`，观察BS21E是否响应
4. **通知接收**：BS21E触发盘点后，验证 `notify_cb` 被调用且数据正确
5. **断线重连**：BS21E断电后，确认状态变为 `link_lost`，重新上电后自动重扫重连
6. **异常场景**：未扫描到设备时调用 `send_cmd()`，验证返回错误码
