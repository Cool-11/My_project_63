# 总任务拆分：WS63 适配 BS21E + ESP32 通信

> 日期: 2026-05-17
> 总任务数: 68 个
> 预估总工时: 分 5 个阶段执行

---

## 阶段一：协议层同步（P0 必须先做）

| # | 任务 | 文件 | 说明 |
|---|------|------|------|
| 1 | WS63 shared_protocol.h 加 SSAP_RSP_UNBIND_OK | WS63: shared_protocol.h | 定义 0xA1 |
| 2 | WS63 shared_protocol.h 加 SSAP_RSP_UNBIND_FAIL | WS63: shared_protocol.h | 定义 0xAF（unbind 复用） |
| 3 | 确认连接参数单位统一为 0.625ms | 双方文档 | BS21E 文档注释 125μs 更正 |
| 4 | WS63 补 conn_latency 参数 | WS63: sle_network.c | 加 0x0F 与 BS21E 对齐 |
| 5 | WS63 notification_cb 加 0xA1 处理 | WS63: business_logic.c | 解绑成功响应分发 |
| 6 | WS63 notification_cb 加 unbind 失败处理 | WS63: business_logic.c | 0xAF 复用为 unbind 失败 |
| 7 | BS21E 出库保留 tag_id | BS21E: storage_sync.c | clear_tag_id 改为只清 qty/status |
| 8 | BS21E 重复绑定同 tag_id 跳过 NV 写入 | BS21E: storage_sync.c | 值相同时不写 NV |
| 9 | BS21E CLAUDE.md 同步 UNBIND_TAG | BS21E: CLAUDE.md | 命令表加 0x21 |
| 10 | BS21E Kconfig 加 MAX_CONNECTIONS | BS21E: Kconfig | 暴露配置项 |

---

## 阶段二：WS63 扫描逻辑重构（核心改动）

| # | 任务 | 文件 | 说明 |
|---|------|------|------|
| 11 | 定义扫描表结构体 sle_scan_entry_t | WS63: sle_network.h | tag_id/mac/battery/qty/status/last_seen |
| 12 | 定义扫描表全局数组 | WS63: sle_network.c | g_scan_table[32] + g_scan_count |
| 13 | 新增扫描表添加函数 | WS63: sle_network.c | scan_table_add_or_update() |
| 14 | 新增扫描表查找函数 | WS63: sle_network.c | scan_table_find_by_tag() |
| 15 | 新增扫描表过期清理函数 | WS63: sle_network.c | 30s 未扫到标离线，5min 清除 |
| 16 | 改造 seek_result_cb 不停扫描 | WS63: sle_network.c | 删掉 stop_scan + 自动连接 |
| 17 | seek_result_cb 记录到扫描表 | WS63: sle_network.c | tag_id > 0 记录，= 0 忽略 |
| 18 | seek_result_cb 更新已入库标签状态 | WS63: sle_network.c | 映射表里有的更新 battery/qty |
| 19 | 新增 sle_network_connect_by_tag() | WS63: sle_network.c | 从扫描表找 mac，发起连接 |
| 20 | 新增 sle_network_get_scan_table() | WS63: sle_network.c/h | 返回扫描表指针 |
| 21 | 新增 sle_network_get_scan_count() | WS63: sle_network.c/h | 返回扫描数量 |
| 22 | 断开回调自动重启扫描 | WS63: sle_network.c | disconnect_cb 里 start_scan |
| 23 | 删除 MY63_TARGET_TAG_ID 硬编码 | WS63: sle_network.c | 不再筛选特定 tag_id |
| 24 | 删除自动连接逻辑 | WS63: sle_network.c | seek_result_cb 不再 connect |

---

## 阶段三：WS63 业务逻辑改造

| # | 任务 | 文件 | 说明 |
|---|------|------|------|
| 25 | 删除 g_biz_next_tag_id 分配机制 | WS63: business_logic.c | tag_id 由 BS21E 预设 |
| 26 | biz_cmd_register 改为读取用户指定 tag_id | WS63: business_logic.c | 从 data_json 读 tag_id |
| 27 | biz_cmd_register 从扫描表查 mac | WS63: business_logic.c | 调 scan_table_find_by_tag |
| 28 | biz_cmd_register 预检查 | WS63: business_logic.c | 检查扫描表/映射表/pending |
| 29 | biz_cmd_register 调 connect_by_tag 连接 | WS63: business_logic.c | 替代原来的直接 send_cmd |
| 30 | biz_cmd_outbound 加 remove_qty 逻辑 | WS63: business_logic.c | 部分出库更新 qty，全量解绑 |
| 31 | biz_cmd_outbound 部分出库发 UPDATE_QTY | WS63: business_logic.c | qty > 0 发 0x10 |
| 32 | biz_cmd_outbound 全量出库发 UNBIND_TAG | WS63: business_logic.c | qty = 0 发 0x21 |
| 33 | biz_sle_notify_cb 加 0xA1 处理 | WS63: business_logic.c | unbind 成功 → 删映射 + 回复 |
| 34 | biz_sle_notify_cb 加 unbind 失败处理 | WS63: business_logic.c | 0xAF → 本地删除 + 回复 |
| 35 | task_done 后断开连接 | WS63: business_logic.c | 调 sle_network_disconnect |
| 36 | 断开后自动恢复扫描 | WS63: business_logic.c | 由 disconnect 回调触发 |
| 37 | 新增 biz_cmd_scan_list 命令 | WS63: business_logic.c | 返回扫描表给串口屏 |
| 38 | biz_uart_cmd_handler 注册 scan_list | WS63: business_logic.c | 分发入口 |
| 39 | scan_list 回复格式含 status + registered | WS63: business_logic.c | JSON 构造 |
| 40 | inventory 传参数给 ESP32 | WS63: business_logic.c | tag_id + zone + item + qty |
| 41 | register 传参数给 ESP32 | WS63: business_logic.c | tag_id + zone + item + qty |
| 42 | 删除 biz_map_alloc 函数 | WS63: business_logic.c/h | 不再动态分配 |
| 43 | 新增 biz_map_add 直接添加 | WS63: business_logic.c/h | 用户指定 tag_id |
| 44 | biz_map_load_nv 恢复逻辑调整 | WS63: business_logic.c | 删 next_tag_id 恢复 |

---

## 阶段四：BS21E 侧改动

| # | 任务 | 文件 | 说明 |
|---|------|------|------|
| 45 | storage_sync_clear_tag_id 改为保留 tag_id | BS21E: storage_sync.c | 只清 qty=0/status=NORMAL |
| 46 | storage_sync_set_tag_id 加重复绑定检查 | BS21E: storage_sync.c | 值相同时跳过 NV 写入 |
| 47 | 断开事件处理：停止声光 | BS21E: main.c | on_conn_state_changed 里处理 |
| 48 | 断开事件处理：恢复状态 | BS21E: main.c | FINDING → NORMAL |
| 49 | UART 自测逻辑抽公共函数 | BS21E: main.c | 减少重复代码 |
| 50 | MAC 种子增强 | BS21E: sle_slave_mgr.c | 混入芯片 ID 增加随机性 |
| 51 | FINDING 重复收到 0x01 加日志 | BS21E: main.c | 区分首次/重复 |
| 52 | unbind_rsp 结构体改名或独立定义 | BS21E: shared_protocol.h | 语义清晰化 |

---

## 阶段五：测试 + 文档 + 提交

| # | 任务 | 文件 | 说明 |
|---|------|------|------|
| 53 | 编译 WS63 零错误零警告 | WS63 全项目 | make 确认 |
| 54 | 编译 BS21E 零错误零警告 | BS21E 全项目 | make 确认 |
| 55 | 测试：list 命令基础通信 | 串口助手 | 发 JSON 收 JSON |
| 56 | 测试：scan_list 返回扫描表 | 串口助手 | 确认 tag_id/battery/status |
| 57 | 测试：register 指定 tag_id 入库 | 串口助手 + BS21E | 完整绑定流程 |
| 58 | 测试：register ESP32 task_done 匹配 | 串口助手模拟 | 确认不再超时 |
| 59 | 测试：outbound 部分出库 | 串口助手 + BS21E | qty 更新，不解绑 |
| 60 | 测试：outbound 全量出库 | 串口助手 + BS21E | 解绑 + tag_id 保留 |
| 61 | 测试：inventory 传参给 ESP32 | 串口助手模拟 | 确认参数完整 |
| 62 | 测试：WiFi 连接 + MQTT 上云 | 实际 WiFi | 本地 MQTT |
| 63 | 测试：scan_list 标签过期 | 移走标签 | 30s 后状态变离线 |
| 64 | 测试：连接失败重试 | 模拟信号差 | 确认重试逻辑 |
| 65 | 写修复报告 | document/fix/ | 所有改动汇总 |
| 66 | 更新 CLAUDE.md | WS63: CLAUDE.md | 同步新架构说明 |
| 67 | git commit 提交到 dev 分支 | git | 所有改动打包 |
| 68 | git push 推送到远程 | git | 推送到 dev |

---

## 执行顺序

```
阶段一（协议同步）→ 阶段二（扫描重构）→ 阶段三（业务改造）→ 阶段四（BS21E）→ 阶段五（测试提交）
     W1-W10              W11-W24             W25-W44             B45-B52           T53-T68
```

每个阶段完成后暂停，等你确认后再进入下一阶段。
