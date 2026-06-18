# ThingsKit 网关设备创建指南

> 日期: 2026-05-18
> 平台: thingskit.aiotcomm.com.cn

---

## 一、创建网关设备

### 1.1 进入设备管理

1. 登录 ThingsKit
2. 左侧菜单 → **设备管理** 或 **Device Management**
3. 点击 **添加设备** 或 **+**

### 1.2 填写网关信息

| 字段 | 填写内容 | 说明 |
|------|---------|------|
| 设备名称 | `aiotcomm11` | 必须和 MQTT clientID 一致 |
| 设备类型 | **网关** / **Gateway** | 关键！必须选网关类型 |
| 设备配置文件 | `default` | 或创建一个网关专用的 profile |
| 标签/描述 | `WS63智能仓储网关` | 可选 |

### 1.3 设置网关凭证

创建后进入设备详情：

1. 找到 **设备凭证** / **Device Credentials**
2. 认证方式选择: **MQTT Basic** 或 **用户名/密码**
3. 填写:

| 字段 | 值 |
|------|-----|
| Client ID | `aiotcomm11` |
| Username | `aiotcomm11` |
| Password | `aiotcomm11` |

4. 保存

---

## 二、创建子设备

### 2.1 方式一：在网关下创建子设备（推荐）

1. 进入网关设备 `aiotcomm11` 的详情页
2. 找到 **子设备** / **Related Devices** / **Gateway Devices** 标签
3. 点击 **添加子设备** / **+**
4. 填写:

| 字段 | 填写内容 |
|------|---------|
| 设备名称 | `tag_1` |
| 设备类型 | `sensor` 或 `default` |

5. 重复创建 `tag_2`、`tag_3`...

### 2.2 方式二：创建独立设备再关联

1. **设备管理** → **添加设备**
2. 设备名称: `tag_1`，类型: `default`（不是网关）
3. 创建后进入设备详情
4. 找到 **关联网关** / **Assign to Gateway**
5. 选择网关 `aiotcomm11`
6. 重复 `tag_2`、`tag_3`...

---

## 三、为子设备绑定物模型

### 3.1 创建设备配置文件 (Device Profile)

1. 左侧菜单 → **设备配置文件** / **Device Profiles**
2. 点击 **添加** / **+**
3. 填写:

| 字段 | 值 |
|------|-----|
| 名称 | `Smart Tag` |
| 传输类型 | `MQTT` |
| 默认规则链 | `Root Rule Chain` |

### 3.2 定义物模型 (Telemetry)

在设备配置文件中，找到 **遥测** / **Telemetry** / **Device Transport Configuration**：

添加以下 6 个字段：

| # | 功能名称 | 标识符 | 数据类型 | 取值范围 | 单位 |
|---|---------|--------|---------|---------|------|
| 1 | 标签ID | `tag_id` | 整型 | 0~65535 | - |
| 2 | 仓库区域 | `zone` | 字符串 | 最长7字符 | - |
| 3 | 货物名称 | `item` | 字符串 | 最长15字符 | - |
| 4 | 库存数量 | `qty` | 整型 | 0~65535 | 个 |
| 5 | 标签状态 | `status` | 整型 | 0~2 | - |
| 6 | 电池电量 | `battery` | 整型 | 0~100 | % |

### 3.3 给子设备分配配置文件

1. 进入子设备 `tag_1` 详情
2. **设备配置文件** 选择 `Smart Tag`
3. 保存
4. 对 `tag_2`、`tag_3` 重复

---

## 四、验证

### 4.1 网关连接测试

WS63 串口发送:
```json
{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}
```
```json
{"cmd":"mqtt_connect","seq":2,"data":{"host":"thingskit.aiotcomm.com.cn","port":11883,"client_id":"aiotcomm11","username":"aiotcomm11","password":"aiotcomm11"}}
```

日口应出现: `mqtt connected`

### 4.2 子设备数据验证

入库后，WS63 发送:
```json
{"cmd":"inbound","seq":3,"data":{"tag_id":1,"zone":"A1","item":"USB-C Cable"}}
```

WS63 以网关格式上报:
```json
{"tag_1":[{"tag_id":1,"zone":"A1","item":"USB-C Cable","qty":0,"status":2,"battery":100}]}
```

在 ThingsKit 上:
1. 进入子设备 `tag_1`
2. **遥测数据** / **Latest Telemetry**
3. 应看到 tag_id/zone/item/qty/status/battery

---

## 五、常见问题

### Q: 找不到"网关"设备类型
在 **设备配置文件** 中创建一个新 profile，传输类型选 MQTT，高级设置中开启 **Gateway** 选项。

### Q: 子设备收不到数据
1. 确认子设备名称和 JSON key 完全一致（`tag_1` 不是 `Tag_1`）
2. 确认子设备已关联到网关设备
3. 确认网关设备类型是"网关"

### Q: 物模型字段看不到
1. 确认子设备绑定了正确的设备配置文件
2. 确认配置文件中定义了遥测字段
3. 数据第一次上报后才会出现
