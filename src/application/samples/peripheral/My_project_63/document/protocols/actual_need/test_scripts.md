# P0 功能测试脚本

> **测试环境**: 1个 BS21E 标签 + 串口屏 + WS63
> **串口监控**: 115200bps, 看 `[WS63_BIZ]`/`[WS63_NET]` 日志

---

## 测试前准备

1. BS21E 标签已配网（tag_id 已设定）
2. WS63 已烧录最新固件
3. 串口屏已连接 UART2 (GPIO7/8)
4. 串口调试助手连接 WS63 调试串口

---

## TC1: 入库 — 新标签注册（正常流程）

**前置**: BS21E 标签在附近，未在 biz_map 中注册

**串口屏操作**:
```
1. 进入 Page1 入库页面
2. 按 b0 (匹配标签)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=in params=start
```

**预期屏显示**:
- t0 显示 tag_id（如 "0005"）
- sys0 = 1

**串口屏操作**:
```
3. 填写 t3="扳手", t2="A", t1="50"
4. 按 b1 (启动摄像头)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=in params=capture,0005,50,A,扳手,0
[WS63_BIZ] screen in,capture tag=0005 qty=50 mode=0
```

**预期屏显示**:
- t5 = "已发送,等待摄像头就绪..."
- sys0 = 3

**串口屏操作**:
```
5. 按 b4 (拍摄Front)
6. 按 b5 (拍摄Side)
7. 按 b6 (拍摄Top)
```

**预期日志**:
```
[WS63_BIZ] capture_progress step=1 view=front score=87.3
[WS63_BIZ] capture_progress step=2 view=side score=91.2
[WS63_BIZ] capture_progress step=3 view=top score=85.7
```

**预期屏显示**:
- t4 = "拍摄: 3/3 top"
- t5 = "清晰度评分: 85.7"

**串口屏操作**:
```
8. 等待 ESP32 推理（~7.5秒）
9. 按 b7 (确认入库)
```

**预期日志**:
```
[WS63_BIZ] bind cmd=0x82 tag=5
[WS63_BIZ] in,confirm BIND_OK tag=5
```

**预期屏显示**:
- t5 = "绑定成功"
- BS21E 蜂鸣 5 秒

**验证项**:
- [ ] tag_id 正确显示
- [ ] 三视图拍摄正常
- [ ] BIND 成功
- [ ] BS21E 蜂鸣 5 秒
- [ ] ThingsKit 收到 tag_005 数据

---

## TC2: 入库 — 所有标签已注册

**前置**: 附近所有 BS21E 都已在 biz_map 中

**串口屏操作**:
```
1. 按 b0 (匹配标签)
```

**预期屏显示**:
- t5 显示 "FULL" 相关提示

**预期日志**:
```
[WS63_BIZ] screen cmd=in params=start
```

---

## TC3: 入库 — 附近无标签

**前置**: 附近无 BS21E 标签（拿走标签）

**串口屏操作**:
```
1. 按 b0 (匹配标签)
```

**预期屏显示**:
- t5 显示 "未找到标签"

**预期日志**:
```
[WS63_BIZ] screen cmd=in params=start
```

---

## TC4: 入库 — 取消操作

**串口屏操作**:
```
1. @in,capture,0005,50,A,扳手,0
2. 按 b3 (返回/取消)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=in params=cancel
```

**预期屏显示**:
- t5 = "已取消入库"

---

## TC5: 出库 — 正常流程

**前置**: tag_id=5 已注册，库存 50

**串口屏操作**:
```
1. 进入 Page2 出库页面
2. 按 b0 (匹配标签)
```

**预期屏显示**:
- t0 = "0005"
- t3 = "扳手"
- t2 = "A"
- t1 = "50"
- sys0 = 1

**串口屏操作**:
```
3. 输入 t6 = "5"
4. 按 b4 (启动摄像头)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=out params=capture,0005,5
[WS63_BIZ] screen out,capture tag=0005 qty=5
```

**预期屏显示**:
- t7 显示出库确认信息
- sys0 = 2

**串口屏操作**:
```
5. 按 b5 (拍摄Front)
```

**预期日志**:
```
[WS63_BIZ] capture_progress step=1 view=front score=87.3
```

**预期屏显示**:
- sys0 = 3 → 4

---

## TC6: 盘点 — 全局盘点

**串口屏操作**:
```
1. 进入 Page3 盘点页面
2. 按 b2 (全局盘点)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=check params=global
[WS63_BIZ] check,global sle_count=1
```

**预期屏显示**:
- t5 显示 "星闪扫描:1个 数据库:X个"

---

## TC7: 查找 — 分页列表

**串口屏操作**:
```
1. 进入 Page4 查找页面
2. 按 b4 (获取列表)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=find params=list,1
```

**预期屏显示**:
- t7 = "第1/X页"
- t0-t5 显示资产条目

---

## TC8: 查找 — 寻物（单标签）

**串口屏操作**:
```
1. 勾选 c0
2. 按 b2 (寻找)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=find params=locate,0005
[WS63_BIZ] find,locate tag=0005 beep started
```

**预期**:
- BS21E 蜂鸣 5 秒
- 5 秒后自动停止

**预期日志（5秒后）**:
```
[WS63_BIZ] locate auto-stop tag=5
```

---

## TC9: 查找 — 手动停止

**串口屏操作**:
```
1. @find,locate,0005
2. 立即按 b5 (停止)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=find params=stop
[WS63_BIZ] find,stop all beeps stopped
```

**预期**: 蜂鸣立即停止

---

## TC10: 设置 — WiFi 连接

**串口屏操作**:
```
1. 进入 Page5 设置页面
2. 输入 t3="MyWiFi", t0="12345678"
3. 按 b1 (连接WiFi)
```

**预期日志**:
```
[WS63_BIZ] screen cmd=setting params=wifi,MyWiFi,12345678
```

**预期屏显示**:
- t5 = "WiFi连接成功!" 或 "WiFi连接失败"

---

## 调试命令速查

### 串口屏发送（手动测试）

```
@in,start\r\n
@in,capture,0005,50,A,扳手,0\r\n
@in,photo,front\r\n
@in,photo,side\r\n
@in,photo,top\r\n
@in,confirm\r\n
@in,cancel\r\n

@out,start\r\n
@out,capture,0005,5\r\n
@out,photo,front\r\n
@out,confirm\r\n

@check,global\r\n
@check,specific,0005\r\n
@check,capture,0005\r\n

@find,list,1\r\n
@find,locate,0005\r\n
@find,stop\r\n

@setting,wifi,MyWiFi,12345678\r\n
@setting,disconnect\r\n
```

### 日志过滤

```bash
# 只看业务逻辑日志
grep "\[WS63_BIZ\]" /dev/ttyUSB0

# 只看 SLE 网络日志
grep "\[WS63_NET\]" /dev/ttyUSB0

# 只看错误
grep -E "ERR|FAIL|error" /dev/ttyUSB0
```

---

## 测试检查清单

| TC | 功能 | 结果 | 备注 |
|----|------|------|------|
| TC1 | 入库正常流程 | ⬜ | |
| TC2 | 所有标签已注册 | ⬜ | |
| TC3 | 附近无标签 | ⬜ | |
| TC4 | 取消操作 | ⬜ | |
| TC5 | 出库正常流程 | ⬜ | |
| TC6 | 全局盘点 | ⬜ | |
| TC7 | 分页列表 | ⬜ | |
| TC8 | 单标签寻物 | ⬜ | |
| TC9 | 手动停止 | ⬜ | |
| TC10 | WiFi连接 | ⬜ | |
