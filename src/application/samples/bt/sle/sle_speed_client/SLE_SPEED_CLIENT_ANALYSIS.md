# SLE Speed Client 分析

这份文档用于解释 `sle_speed_client.c` 和 `inc/sle_speed_client.h` 的关系，以及这个 SLE Speed Client 样例从初始化、扫描、连接、配对、服务发现、收发到测速的完整流程。

## 1. 文件关系

### 头文件的作用
文件 [inc/sle_speed_client.h](inc/sle_speed_client.h) 只暴露了两个对外接口：

- `sle_client_init(...)`
- `sle_start_scan()`

它的职责很简单：把“客户端如何启动”和“如何开始扫描”这两个能力提供给外部调用者，其他细节都隐藏在 `.c` 文件内部。

### 源文件的作用
文件 [src/sle_speed_client.c](src/sle_speed_client.c) 才是真正的实现文件。它负责：

- 初始化连接参数
- 初始化扫描参数
- 注册 SLE / SSAP 各类回调
- 发现目标设备
- 建立连接
- 配对与交换 MTU
- 查找服务与属性
- 通过 notification / indication 接收数据
- 统计接收吞吐率

也就是说，`.h` 是“对外接口”，`.c` 是“业务实现”。

### 构建关系
- [sle_speed_client/CMakeLists.txt](sle_speed_client/CMakeLists.txt) 会把 `src` 目录下的 `sle_speed_client.c` 加入编译。
- [sle_speed_client/src/CMakeLists.txt](sle_speed_client/src/CMakeLists.txt) 只负责把当前 `.c` 文件加入源码列表。
- [sle_speed_client/CMakeLists.txt](sle_speed_client/CMakeLists.txt) 还会把 `inc` 目录加入公共头文件搜索路径，所以其他模块可以通过头文件使用 `sle_client_init()` 和 `sle_start_scan()`。

## 2. 这个样例的业务目标

这个样例本质上是一个 SLE 连接速度测试样例，而不是“纯业务透传”样例。它的目标是：

- 扫描目标设备
- 按 MAC 地址挑选要连接的设备
- 连接后做配对、MTU 交换和服务发现
- 收到对端发来的数据后统计包数和耗时
- 用吞吐率公式估算速率

所以它更关注“链路性能”和“收发速度”，而不是复杂业务协议。

## 3. 从初始化到测速的完整流程

### 3.1 初始化入口
主入口在 [src/sle_speed_client.c](src/sle_speed_client.c) 的末尾：

- `sle_speed_entry()` 创建任务
- `sle_speed_init()` 做延时后调用 `sle_client_init()`
- `sle_client_init()` 注册所有回调并调用 `enable_sle()`

这一段的核心是把 SLE 子系统拉起来，然后开始扫描。

### 3.2 初始化连接参数
函数 `sle_speed_connect_param_init()` 会配置默认连接参数，包括：

- `enable_filter_policy`
- `gt_negotiate`
- `initiate_phys`
- `min_interval` / `max_interval`
- `scan_interval` / `scan_window`
- `timeout`

这一步的作用是告诉协议栈：后续连接时希望用什么节奏、什么扫描/连接窗口、什么超时策略。

### 3.3 初始化扫描参数
函数 `sle_start_scan()` 会配置 `sle_seek_param_t`：

- `own_addr_type`
- `filter_duplicates`
- `seek_filter_policy`
- `seek_phys`
- `seek_type`
- `seek_interval`
- `seek_window`

然后调用：

- `sle_set_seek_param(&param)`
- `sle_start_seek()`

这一步启动扫描，开始接收广播/扫描结果。

### 3.4 SLE 使能后的回调
`enable_sle()` 成功后，协议栈会回调：

- `sle_sample_sle_enable_cbk(status)`

如果 `status == 0`，说明 SLE 已经准备好了，这时会继续执行扫描流程。

### 3.5 扫描结果处理
扫描结果进入：

- `sle_sample_seek_result_info_cbk(sle_seek_result_info_t *seek_result_data)`

这里会读取扫描到的设备地址，并和固定 MAC：

- `11:22:33:44:55:66`

做比较。

如果 MAC 匹配，就把这个地址保存到 `g_remote_addr`，然后调用：

- `sle_stop_seek()`

意思是：已经找到目标设备了，停止继续扫，准备发起连接。

### 3.6 扫描关闭后发起连接
扫描停止后会进入：

- `sle_sample_seek_disable_cbk(status)`

如果状态正常，就调用：

- `sle_connect_remote_device(&g_remote_addr)`

这一步才是真正开始连接目标设备。

### 3.7 连接状态变化
连接状态回调是：

- `sle_sample_connect_state_changed_cbk(...)`

这里会处理三种关键状态：

- `SLE_ACB_STATE_CONNECTED`：已连接
- `SLE_ACB_STATE_DISCONNECTED`：断开连接
- 其他状态：打印日志

如果已连接，而且还没配对，就会调用：

- `sle_pair_remote_device(&g_remote_addr)`

同时把 `g_conn_id` 记录下来。

如果断开，就重新开始扫描，并把接收计数清零。

### 3.8 配对完成
配对完成后进入：

- `sle_sample_pair_complete_cbk(...)`

如果配对成功，就会构造 `ssap_exchange_info_t`，设置：

- `mtu_size = SLE_MTU_SIZE_DEFAULT`
- `version = 1`

然后调用：

- `ssapc_exchange_info_req(1, g_conn_id, &info)`

这一步是为了交换 MTU 和协议版本，为后面的数据传输做准备。

### 3.9 交换信息回调
交换信息完成后进入：

- `sle_sample_exchange_info_cbk(...)`

这里会：

- 打印 MTU 和版本
- 组织 `ssapc_find_structure_param_t`
- 调用 `ssapc_find_structure(...)`

这一步相当于“去目标服务里找可以收发数据的属性”。

### 3.10 服务发现和属性发现
服务发现和属性发现分别由以下回调处理：

- `sle_sample_find_structure_cbk(...)`
- `sle_sample_find_structure_cmp_cbk(...)`
- `sle_sample_find_property_cbk(...)`

这些回调会把找到的服务信息保存到：

- `g_find_service_result`

并把可写属性句柄保存到：

- `g_sle_uart_send_param.handle`

这一步的意义是：后面真正写数据时，知道往哪个 handle 写。

### 3.11 收到数据后的处理
数据接收有两条回调：

- `sle_speed_notification_cb(...)`
- `sle_speed_indication_cb(...)`

其中：

- `notification` 适合不需要确认的快速通知
- `indication` 适合需要确认的有序通知

当前测速逻辑主要在 `sle_speed_notification_cb()` 中。

## 4. 测速逻辑

### 4.1 计数器和时间戳
测速核心依赖两个全局时间戳：

- `g_count_before_get_us`
- `g_count_after_get_us`

以及接收包计数：

- `g_recv_pkt_num`

### 4.2 RSSI 统计
`g_recv_pkt_num % RSSI_AVG_COUNT == 0` 时，会调用：

- `sle_read_remote_device_rssi(conn_id)`

作用是周期性读 RSSI，观察链路质量。

### 4.3 测速窗口
当收到第 1 个包时记录起始时间：

- `g_count_before_get_us = uapi_tcxo_get_us()`

当收满 `RECV_PKT_CNT` 个包时记录结束时间：

- `g_count_after_get_us = uapi_tcxo_get_us()`

然后计算：

- `time = (after - before) / 1000000.0`
- `speed = len * RECV_PKT_CNT * 8 / time`

也就是用：

$$
\text{speed} = \frac{\text{包长} \times \text{包数} \times 8}{\text{耗时(秒)}}
$$

来估算吞吐率，单位是 bps。

### 4.4 两种测试模式
代码里通过编译宏控制：

- `CONFIG_LARGE_THROUGHPUT_CLIENT`

如果打开，就用更大的 `RECV_PKT_CNT = 1000`，更适合大吞吐测试；否则默认 `RECV_PKT_CNT = 1`，更适合单包回环验证。

## 5. 关键回调函数之间的关系

可以把流程理解成一条链：

1. `sle_client_init()` 注册所有回调并 `enable_sle()`
2. `sle_sample_sle_enable_cbk()` 启动扫描
3. `sle_sample_seek_result_info_cbk()` 找到目标设备并保存地址
4. `sle_sample_seek_disable_cbk()` 触发连接
5. `sle_sample_connect_state_changed_cbk()` 检测连接/断开状态
6. `sle_sample_pair_complete_cbk()` 做 MTU 交换
7. `sle_sample_exchange_info_cbk()` 发起服务发现
8. `sle_sample_find_property_cbk()` 记录可写属性句柄
9. `sle_sample_write_cfm_cbk()` 确认写入
10. `sle_sample_read_cfm_cbk()` 读取回来的数据
11. `sle_speed_notification_cb()` 统计吞吐率

## 6. 这个样例里最容易混淆的点

### 6.1 头文件不是“实现文件”
头文件 [inc/sle_speed_client.h](inc/sle_speed_client.h) 只负责声明对外函数，不包含业务实现。

### 6.2 `sle_client_init()` 和 `sle_start_scan()` 是外部入口
它们是给别的模块调用的公共接口，不是给你在头文件里直接做逻辑展开的地方。

### 6.3 扫描结果并不等于服务可写句柄
扫描结果只是在广播层找到了设备，后面还必须完成：

- 连接
- 配对
- MTU 交换
- 服务发现
- 属性发现

拿到 `handle` 之后才能真正写数据。

### 6.4 测速不是“广播速度”
这个样例测的是连接后的 SLE 数据链路吞吐，不是广播本身的速率。

## 7. 一句话总结

`SLE Speed Client` 的本质是一个“先扫到指定设备，再连接，再发现服务，再持续收发并统计吞吐”的完整链路测试样例；`h` 文件只暴露入口，`c` 文件负责整个状态机和测速逻辑。

## 8. 你可以优先看哪些函数

如果你想最快看懂这份代码，建议按这个顺序读：

1. `sle_client_init()`
2. `sle_start_scan()`
3. `sle_sample_sle_enable_cbk()`
4. `sle_sample_seek_result_info_cbk()`
5. `sle_sample_connect_state_changed_cbk()`
6. `sle_sample_pair_complete_cbk()`
7. `sle_sample_exchange_info_cbk()`
8. `sle_sample_find_structure_cbk()`
9. `sle_sample_find_property_cbk()`
10. `sle_speed_notification_cb()`

## 9. 适合快速上手的阅读顺序

如果你的目标不是一次性读懂全部细节，而是先快速建立整体概念，建议按下面顺序看：

1. 先看 [inc/sle_speed_client.h](inc/sle_speed_client.h)
	先知道它对外只暴露了什么接口：`sle_client_init()` 和 `sle_start_scan()`。

2. 再看 `sle_speed_entry()` 和 `sle_speed_init()`
	这一步是程序入口，帮你理解这个样例是怎么被拉起来的。

3. 接着看 `sle_client_init()`
	这里会把所有关键回调都注册进去，是整个状态机的起点。

4. 然后看 `sle_sample_sle_enable_cbk()` 和 `sle_start_scan()`
	这一步告诉你：SLE 初始化成功以后，样例会先做扫描，不是直接开始传输。

5. 再看 `sle_sample_seek_result_info_cbk()` 和 `sle_sample_seek_disable_cbk()`
	这里是“发现目标设备 -> 停止扫描 -> 准备连接”的转折点。

6. 然后看 `sle_sample_connect_state_changed_cbk()` 和 `sle_sample_pair_complete_cbk()`
	这一步说明连接建立后怎么配对、怎么拿到连接上下文。

7. 再看 `sle_sample_exchange_info_cbk()`、`sle_sample_find_structure_cbk()`、`sle_sample_find_property_cbk()`
	这一步是服务发现和属性发现，是后续收发数据的前提。

8. 最后看 `sle_speed_notification_cb()`
	这是真正测速的地方，理解它之后就能明白这个样例为什么叫 speed client。

## 10. 这个样例本质上是广播还是连接

这个样例本质上是 **连接型业务**，不是纯广播业务。

- 广播/扫描只负责“发现目标设备”
- 真正的数据传输发生在“连接成功以后”
- 后面的配对、MTU 交换、服务发现、属性发现，都是为连接后的数据收发做准备

所以你可以把它理解成：

**广播是入口，连接才是主业务。**

## 11. 能不能拿来让 WS63 和 BS21e 连接

可以，但要满足两个条件：

1. BS21e 端必须是可连接/可扫描广播，并且广播内容能被 WS63 正确识别。
2. WS63 端的扫描匹配条件必须能命中 BS21e。

在当前这个样例里，WS63 的扫描逻辑是按固定 MAC 地址匹配的：

- `11:22:33:44:55:66`

所以从“代码能力”上说，它允许连 63 和 21e；
但从“当前默认配置”上说，它 **不是自动适配任意 21e**，你需要把匹配条件改成你真实的 BS21e 广播地址，或者改成你已经做过的那种魔数/广播字段匹配方式。

如果你现在想做的是“63 连 21e 并做一对多/透传/测速”，这个样例可以作为基础，只是你要把目标地址、服务 UUID、属性句柄这些和 21e 端对齐。

## 12. 一句话结论

这个样例的核心是 **连接后测速**，不是广播本身；
它可以作为 WS63 连接 BS21e 的基础，但你要先让扫描匹配和服务发现逻辑对上 21e 的实际广播与服务。
