# WS63 SLE 主机扫描端与广播逻辑汇报

## 结论

这个 SDK 里，63 的主机扫描端 client 主线是“先使能 SLE，再配置扫描参数，扫描到目标广播后发起连接/配对，随后做 SSAP 服务发现和数据交互”。和它配套的广播逻辑主要在 server 样例里，负责把设备做成“可连接、可扫描”的广播源，让 client 能扫到并连上。

## 1. 63 主机扫描 client 的主流程

### 1.1 `sle_speed_client.c` 是最直接的 host scan client

- [sle_start_scan](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L69) 先配置 `sle_seek_param_t`，再调用 `sle_start_seek()`，这是 client 侧真正开始扫描的入口。
- [sle_sample_sle_enable_cbk](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L83) 在 SLE 使能成功后，先设置本地地址，再初始化默认连接参数，然后启动扫描。
- [sle_sample_seek_result_info_cbk](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L110) 是扫描结果回调，代码里会拿扫描到的广播地址和预设 MAC 做匹配，匹配成功后停止扫描。
- [sle_sample_seek_disable_cbk](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L103) 在扫描停止后发起 `sle_connect_remote_device()`，把扫描阶段切到连接阶段。
- [sle_sample_connect_state_changed_cbk](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L174) 负责连接状态变化；连接成功后如果还没配对，会先做配对，断开后重新开始扫描。
- [sle_sample_pair_complete_cbk](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L206) 在配对成功后发起 MTU 交换，进入后续 SSAP 发现/读写流程。

### 1.2 这个 client 后面怎么和 server 交互

这个样例不是只停留在“扫到设备”这一步，而是继续做 SSAP：`sle_speed_client.c` 里在写确认后还会触发读请求，形成典型的“发现服务 -> 写入 -> 读取/通知”的业务链路。对 63 的主机扫描端来说，它本质上是一个“先通过广播发现目标，再进入业务连接”的 client。

## 2. 广播逻辑在哪里

### 2.1 `sle_speed_server_adv.c` 是最典型的广播配置样例

- [sle_set_default_announce_param](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L68) 配置广播模式、发现等级、信道、广播间隔、连接参数和发射功率。
- [sle_set_default_announce_data](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L89) 组装广播数据和 scan response data，并调用 `sle_set_announce_data()`。
- [sle_announce_register_cbks](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L132) 注册广播启停回调。
- [sle_uuid_server_adv_init](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L142) 依次设置参数、设置广播数据、启动广播。

这个广播样例的特点是：它把设备配置成 `connectable + scannable`，所以 client 既能扫到它，也能在扫描后继续连上它。

### 2.2 另一个 one-to-many server 也有类似广播逻辑

- [sle_uart_announce_register_cbks](application/samples/peripheral/sle_one_to_many/sle_server_many/sle_server_adv.c#L222) 在 server 侧注册 announce 回调。
- [sle_uart_server_adv_init](application/samples/peripheral/sle_one_to_many/sle_server_many/sle_server_adv.c#L238) 负责设置广播参数、设置广播数据并启动广播。

这个样例和 `sle_speed_server_adv.c` 的思路一致，只是业务名义上变成了 UART server，多连接场景下更强调广播发现和后续接入。

## 3. 其他文件夹里和 SLE 业务相关的接口

### 3.1 基础发现/广播/连接 API

- [SleAnnounceSeekRegisterCallbacks](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L83) 是统一的广播/扫描回调注册入口。
- [SleSetAnnounceParam](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L51) 和 [SleSetAnnounceData](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L46) 是对底层 `sle_set_announce_param()` / `sle_set_announce_data()` 的封装。
- [SleStartAnnounce](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L57) / [SleStartSeek](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L73) 就是启动广播和启动扫描。
- [SleSetSeekParam](application/samples/wifi/ohos_connect/hilink_adapt/adapter/oh_sle_srv_dd.c#L68) 负责配置扫描窗口、间隔、PHY、过滤等。

### 3.2 传输管理与流控

- [sle_transmission_register_callbacks](include/middleware/services/bts/sle/sle_transmition_manager.h#L128) 注册发送繁忙回调。
- [sle_transmission_signal_capability_req](include/middleware/services/bts/sle/sle_transmition_manager.h#L111) 查询链路能力，和高吞吐/流控控制相关。
- [sle_trans_data_busy_callback](include/middleware/services/bts/sle/sle_transmition_manager.h#L55) 的回调参数是链路 QoS 状态，告诉上层当前链路是空闲、流控还是繁忙。

### 3.3 GLP / CHBA 这类更上层业务

- [sle_glp_register_callbacks](include/middleware/services/bts/sle/sle_glp_manager.h#L36) 是 GLP 业务回调注册入口。
- [sle_cs_glp_report_callback](include/middleware/services/bts/sle/sle_glp_manager.h#L29) 代表 GLP 上报回调，常用于接收测量/状态类信息。
- [sle_chba_netdev_create](include/middleware/services/bts/sle_chba/sle_chba_manager.h#L26) 把 SLE 链路抽象成网络设备。
- [sle_chba_netdev_register_callbacks](include/middleware/services/bts/sle_chba/sle_chba_manager.h#L57) 注册网络设备级别的队列和链路状态回调。

## 4. 这些 SLE 术语在这里是什么意思

- [SLE_ANNOUNCE_MODE_CONNECTABLE_SCANABLE](include/middleware/services/bts/sle/sle_device_discovery.h#L94) 表示“可连接、可扫描”的广播模式，这是 client 能扫到并发起连接的前提。
- [SLE_ANNOUNCE_LEVEL_NORMAL](include/middleware/services/bts/sle/sle_device_discovery.h#L52) 表示普通可发现等级，广播时让设备对外可见。
- [SLE_SEEK_PASSIVE](include/middleware/services/bts/sle/sle_device_discovery.h#L124) 表示被动扫描，只收广播不主动发探测。
- [SLE_SEEK_ACTIVE](include/middleware/services/bts/sle/sle_device_discovery.h#L126) 表示主动扫描，会额外发探测请求。
- [SSAP_OPERATE_INDICATION_BIT_BROADCAST](include/middleware/services/bts/sle/sle_ssap_stru.h#L130) 表示这个属性值允许通过广播携带，属于“业务数据可随广播发送”的标记。

## 5. 对 63 主机扫描端的理解

从现有样例看，63 的主机扫描 client 并不是“只做扫描”的简单模式，而是完整业务链路的一部分：

1. 先通过 `sle_set_seek_param()` + `sle_start_seek()` 找到目标广播。
2. 再根据广播内容或固定地址决定是否连接。
3. 连接后做配对、MTU 交换、服务发现和数据读写。
4. 若链路质量差，还会结合传输管理/流控回调控制发包节奏。

如果你后面要继续，我可以再把这份报告扩成“扫描端时序图 + 关键回调表”，或者直接把 client 侧的调用链画成流程图。

## 6. 21e 广播长度和 63/21e 组网方式

### 6.1 广播最多能带多少字节

按当前 SDK 的样例写法，announce data 和 scan response data 都是按 251 字节来做的：

- [SLE_ADV_DATA_LEN_MAX](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L33)
- [SLE_ADV_DATA_LEN_MAX](application/samples/peripheral/sle_one_to_many/sle_server_many/sle_server_adv.c#L41)

也就是说，实际设计时可以先按 251 字节作为广播载荷上限来规划。头文件里只有 [sle_announce_data_t](include/middleware/services/bts/sle/sle_device_discovery.h#L287) 里的长度字段，字段类型是 `uint16_t`，并没有在公共头里给出更大的显式宏上限。

### 6.2 63 和 21e 应该怎么连

在这套 SLE API 里，建议按 G/T 角色理解，而不是 master/slave：

- 63 做 G 侧，也就是扫描/发起连接的一侧，样例里是 [SLE_ANNOUNCE_ROLE_G_CAN_NEGO](application/samples/bt/sle/sle_speed_client/src/sle_speed_client.c#L59)
- 21e 做 T 侧，也就是广播/被发现的一侧，样例里广播参数是 [SLE_ANNOUNCE_ROLE_T_CAN_NEGO](application/samples/bt/sle/sle_speed_server/src/sle_speed_server_adv.c#L74)
- 广播模式建议用 [SLE_ANNOUNCE_MODE_CONNECTABLE_SCANABLE](include/middleware/services/bts/sle/sle_device_discovery.h#L94)，这样 63 才能先扫到，再连上去

### 6.3 推荐通信流程

1. 21e 先配置广播参数和广播数据，广播内容尽量放设备名、短标识、服务 UUID 或简单状态字节。
2. 63 开启 seek 扫描，匹配到 21e 的广播地址或广播内容后，停止扫描并发起连接。
3. 连接后再做配对、MTU 交换、SSAP 服务发现。
4. 真正需要双向传数据时，走连接后的读写/通知，不要只依赖广播。

### 6.4 如果你只想做广播通知

那就让 21e 只负责发 announce data，63 只负责扫描解析。这个模式适合做状态上报、设备发现、短标识传递。

如果你要的是稳定的双向业务通信，还是建议把广播当入口，把连接后的 SSAP 当主通道。