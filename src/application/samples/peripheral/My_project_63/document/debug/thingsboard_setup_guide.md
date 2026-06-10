# ThingsBoard 云平台配置流程

> 日期: 2026-05-17
> 平台: ThingsBoard (demo.thingsboard.io 或自建)
> 设备: WS63 网关

---

## 一、注册账号

### 1.1 使用 ThingsBoard Demo 服务器

1. 浏览器打开 `https://demo.thingsboard.io`
2. 点击右上角 **Register**
3. 填写邮箱、密码，完成注册
4. 登录进入 Dashboard

> 如果是国内访问慢，可使用 `https://thingsboard.cloud` 或自建服务器

### 1.2 自建服务器 (可选)

```bash
docker run -d --name mytb --restart always \
  -p 9090:9090 -p 1883:1883 -p 5683:5683/udp \
  -v ~/.mytb-data:/data -v ~/.mytb-logs:/var/log/thingsboard \
  thingsboard/tb-postgres
```

访问 `http://localhost:9090`，默认账号: `sysadmin@thingsboard.org` / `sysadmin`

---

## 二、创建设备

### 2.1 添加设备

1. 左侧菜单 → **Devices** → 右上角 **+** (Add device)
2. 填写:
   - **Name**: `WS63_Gateway_01` (自定义)
   - **Device profile**: `default` (保持默认)
   - **Label**: `智能仓储网关` (可选)
3. 点击 **Add** 创建

### 2.2 获取 Access Token

1. 在设备列表中点击刚创建的设备
2. 点击 **Manage credentials** (或左侧 **Device credentials**)
3. 记录以下信息:

| 字段 | 值 | 说明 |
|------|-----|------|
| **Access token** | `A1_TEST_TOKEN_123` | MQTT 连接的 username |
| **Device profile** | `default` | 设备配置文件 |

> Access token 就是 MQTT 的 username，password 留空

### 2.3 设备凭证配置

ThingsBoard 设备凭证类型选择 **Access token** (默认):

| MQTT 参数 | 值 |
|-----------|-----|
| Broker URI | `tcp://demo.thingsboard.io:1883` |
| Username | `<你的 Access token>` |
| Password | (留空) |
| Client ID | `ws63_gw_01` (任意字符串) |

---

## 三、配置物模型 (Device Profile)

### 3.1 进入 Device Profile

1. 左侧菜单 → **Device profiles**
2. 点击 **default** (或新建一个)

### 3.2 配置遥测数据 (Telemetry)

ThingsBoard 的物模型是**动态创建**的——只要设备上报了新 key，平台自动创建对应属性。不需要手动预先配置。

WS63 上报的 JSON 格式:
```json
{
  "tag_update": {
    "tag_id": 1,
    "zone": "A1",
    "item": "USB-C Cable",
    "qty": 50,
    "status": 2,
    "battery": 95
  }
}
```

ThingsBoard 会自动创建:
- 遥测键: `tag_update` (JSON 对象)

### 3.3 推荐物模型配置 (手动)

如果需要更精细的控制，可以创建自定义 Device Profile:

1. **Device profiles** → **+** (Add)
2. Name: `Smart Warehouse Gateway`
3. **Transport type**: `MQTT`
4. **Rule chain**: `Root Rule Chain` (默认)

然后配置 **Attributes** (服务端属性):

| Key | 类型 | 说明 |
|-----|------|------|
| gateway_type | string | "ws63" |
| firmware_version | string | 固件版本 |

**Telemetry** (遥测) 无需预先配置，自动创建。

---

## 四、WS63 端连接命令

### 4.1 串口发送 WiFi 配置

```json
{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}
```

等待日口出现: `wifi got ip x.x.x.x`

验证:
```json
{"cmd":"wifi_status","seq":2,"data":{}}
```
预期: `wifi_state=1`

### 4.2 串口发送 MQTT 配置

```json
{"cmd":"mqtt_connect","seq":3,"data":{"host":"thingskit.aiotcomm.com.cn","port":11883,"client_id":"aiotcomm11","username":"aiotcomm11","password":"aiotcomm11"}}
```

**参数说明:**

| 参数 | 值 |
|------|-----|
| host | `thingskit.aiotcomm.com.cn` |
| port | `11883` |
| client_id | `aiotcomm11` |
| username | `aiotcomm11` |
| password | `aiotcomm11` |

> URI 格式:
> ```json
> {"cmd":"mqtt_connect","seq":3,"data":{"uri":"tcp://thingskit.aiotcomm.com.cn:11883","client_id":"aiotcomm11","username":"aiotcomm11","password":"aiotcomm11"}}
> ```

验证:
```json
{"cmd":"mqtt_status","seq":4,"data":{}}
```
预期: `mqtt_state=1`

> 发布主题: `v1/devices/me/telemetry` (自动，无需配置)
> 订阅主题: `v1/devices/me/rpc/request/+` (自动，无需配置)

---

## 五、数据验证

### 5.1 入库触发上云

```json
{"cmd":"inbound","seq":10,"data":{"tag_id":1,"zone":"A1","item":"USB-C Cable"}}
```

成功后 WS63 自动发布到 `v1/devices/me/telemetry`:
```json
{"tag_update":{"tag_id":1,"zone":"A1","item":"USB-C Cable","qty":0,"status":2,"battery":100}}
```

### 5.2 ThingsBoard 查看数据

1. 左侧菜单 → **Devices** → 点击 `WS63_Gateway_01`
2. 点击 **Latest telemetry** 标签页
3. 应该能看到 `tag_update` 键及其值

### 5.3 ThingsBoard Dashboard 展示

创建 Dashboard 展示标签数据:

1. 左侧菜单 → **Dashboards** → **+** (Create new)
2. Name: `Smart Warehouse`
3. 点击 **Add widget** → 选择 **Cards** → **Latest values**
4. **Add alias** → Entity type: `Device` → 选择 `WS63_Gateway_01`
5. 添加 **Widget bundle**: **Cards** → **Entities table**
6. 数据源: `tag_update` telemetry key

---

## 六、远程下发命令 (RPC)

ThingsBoard 支持通过 RPC 向设备下发命令。

### 6.1 订阅 Topic

WS63 自动订阅: `v1/devices/me/rpc/request/+`

### 6.2 下发格式

ThingsBoard RPC 请求格式:
```json
{"method":"inbound","params":{"tag_id":1,"zone":"A1","item":"Test"},"id":123}
```

WS63 需要在 `my63_mqtt_msg_cb` 中解析 method 字段并转发到 business_logic。

> 当前代码中 RPC 下发处理可能需要额外开发，取决于 business_logic 是否已对接 mqtt_msg_cb。

---

## 七、常见问题

### Q: MQTT 连接失败

1. 确认 WiFi 已连接 (`wifi_status=1`)
2. 确认 host 和 port 正确
3. 确认 username 是 ThingsBoard 的 **Access token** (不是账号密码)
4. 确认 password 留空
5. 检查日口: `[WS63_CLOUD] mqtt connect fail ret=X`

### Q: 数据上报但 ThingsBoard 看不到

1. 确认 topic 是 `v1/devices/me/telemetry`
2. 确认 JSON 格式正确
3. 在 ThingsBoard 设备页面检查 **Events** 标签页是否有数据
4. 检查 Device Profile 的 Rule Chain 是否正确

### Q: demo.thingsboard.io 访问慢

1. 使用 ThingsBoard Cloud: `https://thingsboard.cloud`
2. 或自建 Docker 服务器
3. 或使用国内 IoT 平台 (需修改 topic 格式)

### Q: WiFi 密码含特殊字符

JSON 中特殊字符需要转义:
- 双引号: `\"`
- 反斜杠: `\\`
- 例: 密码是 `p@ss"word` → `"psk":"p@ss\"word"`

---

## 八、快速验证 Checklist

| # | 步骤 | 命令/操作 | 预期 |
|---|------|----------|------|
| 1 | ThingsBoard 创建设备 | Web 界面 | 获取 Access token |
| 2 | WS63 连 WiFi | `wifi_connect` | wifi_state=1 |
| 3 | WS63 连 MQTT | `mqtt_connect` | mqtt_state=1 |
| 4 | 入库 | `inbound` | 日口 `mqtt publish OK` |
| 5 | ThingsBoard 查数据 | Latest telemetry | 看到 tag_update |
| 6 | 重启 WS63 | 断电重上电 | WiFi+MQTT 自动恢复 |
| 7 | 再次入库 | `inbound` | 数据继续上报 |
