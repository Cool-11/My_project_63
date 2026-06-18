# WS63 全链路硬件测试 — 子任务清单

> 日期: 2026-05-18
> 前提: WS63 + BS21E 已烧录 dev 分支固件
> 工具: 2 个 SSCOM 窗口（日口 + 业务口）

---

## 子任务 1：WiFi 连接测试

**目标:** WS63 通过串口命令连上 WiFi

### 步骤

1. WS63 上电，日口等到 `APP ENTRY DONE`
2. 业务口发送:
```json
{"cmd":"wifi_connect","seq":1,"data":{"ssid":"cool","psk":"hjs113213"}}
```
3. 预期响应: `{"cmd":"wifi_connect","seq":1,"code":0,"msg":"connecting"}`
4. 日口等待: `wifi got ip x.x.x.x`
5. 验证:
```json
{"cmd":"wifi_status","seq":2,"data":{}}
```
6. 预期: `wifi_state=1`

### 判定
- wifi_state=1 → PASS，进入子任务 2
- wifi_state=0 → FAIL，检查 SSID/密码/信号

---

## 子任务 2：MQTT 连接测试

**目标:** WS63 连上 ThingsKit 云平台

### 步骤

1. 确认子任务 1 已通过
2. 业务口发送:
```json
{"cmd":"mqtt_connect","seq":3,"data":{"host":"thingskit.aiotcomm.com.cn","port":11883,"client_id":"aiotcomm11","username":"aiotcomm11","password":"aiotcomm11"}}
```
3. 预期响应: `{"cmd":"mqtt_connect","seq":3,"code":0,"msg":"ok"}`
4. 日口等待: `mqtt connected`
5. 验证:
```json
{"cmd":"mqtt_status","seq":4,"data":{}}
```
6. 预期: `mqtt_state=1`

### 判定
- mqtt_state=1 → PASS，进入子任务 3
- mqtt_state=0 → FAIL，检查日口错误日志

### 常见错误
| 日口错误 | 原因 |
|----------|------|
| `connect fail ret=-5` | 用户名/密码错误 |
| `connect fail ret=-4` | 连接超时，检查 host/port |
| `mqtt not available` | cloud_storage 未初始化 |

---

## 子任务 3：NV 持久化测试

**目标:** 断电重启后 WiFi + MQTT 自动恢复

### 步骤

1. 确认子任务 2 已通过（WiFi+MQTT 都连接中）
2. WS63 断电，等 3 秒
3. WS63 重新上电
4. 日口观察:
```
[WS63_APP] wifi cfg loaded from nv ssid=cool
[WS63_APP] mqtt cfg loaded from nv uri=tcp://thingskit.aiotcomm.com.cn:11883
[WS63_CLOUD] wifi got ip x.x.x.x
[WS63_CLOUD] mqtt connected
```
5. 验证:
```json
{"cmd":"wifi_status","seq":1,"data":{}}
{"cmd":"mqtt_status","seq":2,"data":{}}
```
6. 预期: wifi_state=1, mqtt_state=1

### 判定
- 两个都是 1 → PASS，进入子任务 4
- WiFi 恢复但 MQTT 未恢复 → 检查日口，可能是 MQTT 连接时序问题
- 都未恢复 → NV 写入失败

---

## 子任务 4：SLE 扫描测试

**目标:** WS63 发现 BS21E 标签

### 步骤

1. BS21E 上电（放在 WS63 附近 <2m）
2. 等待 3~5 秒
3. 日口观察:
```
[WS63_NET] seek found tag_id=X mac=XX:XX:XX:XX:XX:XX bat=N qty=0 status=0x00
```
4. 业务口验证:
```json
{"cmd":"scan_list","seq":10,"data":{}}
```
5. 预期响应包含 BS21E 条目:
```json
{"cmd":"scan_list","seq":10,"code":0,"msg":"ok","data":{"scan_list":[{"tag_id":X,"battery":N,"qty":0,"status":0,"registered":false}]}}
```

### 判定
- scan_list 有 BS21E → PASS，进入子任务 5
- scan_list 为空 → 检查 BS21E 是否上电、距离

---

## 子任务 5：入库测试 (inbound)

**目标:** WS63 连接 BS21E → SLE 绑定 → 上云

### 步骤

1. 确认子任务 4 已通过（scan_list 有 BS21E）
2. 业务口发送:
```json
{"cmd":"inbound","seq":20,"data":{"tag_id":<从scan_list获取>,"zone":"A1","item":"USB-C Cable"}}
```
3. 日口观察完整链路:
```
[WS63_BIZ] uart cmd=inbound seq=20
[WS63_NET] connect_by_tag tag_id=X
[WS63_NET] connected=1
[WS63_NET] pair complete
[WS63_NET] ssap ready
[WS63_BIZ] sle bind cmd=0x20 tag_id=X
[WS63_BIZ] sle notify bind cmd=0xA0 tag_id=X
[WS63_BIZ] inbound bind OK tag_id=X
```
4. 预期响应:
```json
{"cmd":"inbound","seq":20,"code":0,"msg":"ok","data":{"tag_id":<N>}}
```
5. **如果 MQTT 已连接**，日口还应出现:
```
[WS63_CLOUD] mqtt publish OK topic=v1/devices/me/telemetry
```
6. 验证映射表:
```json
{"cmd":"list","seq":21,"data":{}}
```
7. 预期: count=1，有 tag_id=N 的条目

### 判定
- code=0 + 日志完整 + list 有条目 → PASS
- code=-4: 扫描表无此 tag_id → 等几秒重试
- code=-6: 有 pending → 等 5 秒
- code=-10: 超时 → 日志卡在哪一步

---

## 子任务 6：入库自动上云验证

**目标:** 确认入库后数据自动上报到 ThingsKit

### 步骤

1. 确认子任务 5 已通过且 MQTT 已连接
2. 日口查找:
```
[WS63_CLOUD] mqtt publish OK
```
3. 去 ThingsKit 平台:
   - 设备管理 → 点击设备 → 遥测数据/实时数据
   - 看是否有 `tag_update` 数据

### 判定
- ThingsKit 看到 tag_update 数据 → PASS
- ThingsKit 没看到 → 检查日口是否有 publish OK，检查平台设备凭证

---

## 子任务 7：寻物测试 (find)

**目标:** WS63 通过 SLE 让 BS21E 蜂鸣

### 步骤

1. 业务口发送:
```json
{"cmd":"find","seq":30,"data":{"tag_id":<已入库的tag_id>}}
```
2. 预期: BS21E 蜂鸣器响 + LED 闪，持续 15 秒
3. 预期响应:
```json
{"cmd":"find","seq":30,"code":0,"msg":"ok","data":{"tag_id":<N>,"zone":"A1","item":"USB-C Cable"}}
```

### 判定
- BS21E 蜂鸣 + code=0 → PASS
- code=-3: tag_id 不在映射表中

---

## 子任务 8：盘点测试 (inventory)

**目标:** WS63 从 BS21E 读取最新状态

### 步骤

1. 业务口发送:
```json
{"cmd":"inventory","seq":40,"data":{}}
```
2. 日口观察:
```
[WS63_BIZ] sle inventory cmd=0x02
[WS63_BIZ] sle notify inv tag_id=X qty=N status=0x02 bat=N
```
3. 预期响应: 包含标签最新 qty/status/battery

### 判定
- 收到完整数据 → PASS
- code=-10: 超时 → SLE 连接可能断开

---

## 子任务 9：出库测试 (outbound)

**目标:** 全量出库解绑 + 自动上云

### 步骤

1. 业务口发送:
```json
{"cmd":"outbound","seq":50,"data":{"tag_id":<已入库的tag_id>}}
```
2. 日口观察:
```
[WS63_BIZ] sle unbind cmd=0x21 tag_id=X
[WS63_BIZ] sle notify bind cmd=0xA1 tag_id=X
[WS63_BIZ] outbound unbind OK tag_id=X
```
3. 预期响应:
```json
{"cmd":"outbound","seq":50,"code":0,"msg":"ok","data":{"tag_id":<N>}}
```
4. 如果 MQTT 已连接，日口应有: `mqtt publish OK`
5. 验证:
```json
{"cmd":"list","seq":51,"data":{}}
```
6. 预期: count=0

### 判定
- code=0 + list 为空 + 日志有 0xA1 → PASS
- code=-5: 解绑失败

---

## 子任务 10：模拟 ESP32 — register 完整流程

**目标:** 串口助手模拟 ESP32，完成 register 二阶段流程

### 步骤

1. 先重新入库（让标签回到映射表），或用未注册的标签
2. 确认 scan_list 有目标标签
3. 业务口发送:
```json
{"cmd":"register","seq":60,"data":{"tag_id":<N>,"storage_area":"B3","item_name":"HDMI Adapter"}}
```
4. 日口等待: `register bind OK, forward to esp32`
5. **此时 WS63 通过业务口 TX 发送给 ESP32**，串口助手应收到:
```json
{"cmd":"register","tag_id":<N>,"item_name":"HDMI Adapter","storage_area":"B3","qty":0}
```
6. **在 15 秒内**，串口助手发送（模拟 ESP32 回复）:
```json
{"type":"task_done","task":"register","result":"success","tag_id":<N>}
```
7. 预期最终响应:
```json
{"cmd":"register","seq":60,"code":0,"msg":"ok","data":{"type":"task_done","task":"register","result":"success","tag_id":<N>}}
```

### 判定
- code=0 → PASS
- code=-10 → 超时，步骤 6 发太慢或格式错误
- 没收到步骤 5 的 TX 数据 → WS63 bind 可能失败

---

## 子任务 11：出库上云验证

**目标:** 确认出库后 ThingsKit 收到数据更新

### 步骤

1. 确认子任务 9 已执行且 MQTT 已连接
2. 日口查找: `mqtt publish OK`
3. ThingsKit 平台查看最新遥测数据
4. 数据应反映标签已出库（status 变化）

### 判定
- ThingsKit 数据更新 → PASS

---

## 子任务 12：手动 MQTT 发布测试

**目标:** 验证手动发布自定义 payload

### 步骤

1. 业务口发送:
```json
{"cmd":"mqtt_publish","seq":70,"data":{"payload":{"test":"hello","ts":12345}}}
```
2. 预期响应: code=0
3. ThingsKit 平台查看是否收到

### 判定
- ThingsKit 收到 → PASS

---

## 子任务 13：异常场景测试

### 13.1 无效 JSON
```
{broken
```
预期: 日口 `json parse fail`

### 13.2 未知命令
```json
{"cmd":"xxx","seq":99,"data":{}}
```
预期: `code=-99`

### 13.3 标签不在线
```json
{"cmd":"inbound","seq":100,"data":{"tag_id":99,"zone":"A1","item":"Ghost"}}
```
预期: `code=-4`

### 13.4 pending 冲突
```json
{"cmd":"inventory","seq":101,"data":{}}
```
立即再发:
```json
{"cmd":"inbound","seq":102,"data":{"tag_id":<N>,"zone":"A1","item":"X"}}
```
预期: inbound 收到 `code=-6`

---

## 测试顺序总览

| 子任务 | 内容 | 依赖 |
|--------|------|------|
| 1 | WiFi 连接 | 无 |
| 2 | MQTT 连接 | 子任务 1 |
| 3 | NV 持久化（重启恢复） | 子任务 2 |
| 4 | SLE 扫描 | 无 |
| 5 | 入库 (inbound) | 子任务 4 |
| 6 | 入库自动上云验证 | 子任务 2 + 5 |
| 7 | 寻物 (find) | 子任务 5 |
| 8 | 盘点 (inventory) | 子任务 5 |
| 9 | 出库 (outbound) | 子任务 5 |
| 10 | register 流程 | 子任务 4 |
| 11 | 出库上云验证 | 子任务 9 |
| 12 | 手动 MQTT 发布 | 子任务 2 |
| 13 | 异常场景 | 子任务 2 + 4 |

---

## 串口助手操作要点

### 业务口发送
- 每条 JSON 命令末尾加 `\n` 或勾选"发送新行"
- 等上一条响应回来再发下一条（pending 机制限制同时只能有一个 SLE 命令）

### 业务口接收（模拟 ESP32）
- 子任务 10 需要在业务口 TX 方向观察 WS63 发给 ESP32 的数据
- 收到后在 RX 方向发送 task_done 回复
- 注意：SSCOM 同一窗口的 TX 和 RX 是分开的，TX 是你发的，RX 是你收的

### 日口
- 只看不发
- 重点看 `[WS63_BIZ]`、`[WS63_NET]`、`[WS63_CLOUD]` 前缀的日志
