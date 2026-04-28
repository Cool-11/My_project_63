星闪智能仓储 WS63 ↔ BS21E 联调协同规范
版本：v1.0生效日期：2026-04-28当前状态：BS21E 端已准备完毕，安全模式暂不启用（仅用于快速验证基础链路），先跑通「扫描→连接→SSAP 发现→简单指令收发」闭环
前置说明
核心原则：所有标🔴的项必须 100% 严格对齐，否则联调会直接失败
当前优先级：先验证基础链路，基础链路跑通后统一开启安全模式
BS21E 端状态：已烧录通用固件，tag_id=0，电量模拟值 = 95，广播间隔 = 200ms
一、🔴 最高优先级：协议一致性（两端必须完全一致）
1.1 广播 Payload 结构体
直接引用 BS21E 端提供的 shared_protocol.h，禁止单独定义：
c
运行
#pragma pack(push, 1)
typedef struct {
    uint32_t magic;      // 魔数：0xAABBCCDD（用于过滤杂波）
    uint16_t tag_id;     // 标签ID（库位号）
    uint16_t qty;        // 库存数量
    uint8_t status;      // 状态：0x00正常 / 0x01寻物报警
    uint8_t battery;     // 电量百分比：0-100
    uint16_t seq;        // 序列号（每次Qty变化时自增）
} shared_proto_adv_field_t;
#pragma pack(pop)

// 🔴 必须添加编译时检查
_Static_assert(sizeof(shared_proto_adv_field_t) == 12, "广播Payload结构体必须为12字节！");
1.2 魔数
必须严格使用：0xAABBCCDD
二、🔴 SSAP 服务与特征配置（两端必须完全一致）
表格
类型	UUID 值	说明
App UUID	0000FFFF-0000-1000-8000-00805f9b34fb	星闪通用 App UUID
Service UUID	0000FF00-0000-1000-8000-00805f9b34fb	自定义星闪标签服务 UUID
Property UUID	0000FF01-0000-1000-8000-00805f9b34fb	自定义数据读写特征 UUID（可写 + 可通知）
三、🔴 SSAP 单播指令格式（两端必须完全一致）
3.1 指令定义
表格
指令名称	字节 [0]	字节 [1]	字节 [2]	说明
寻物报警	0x01	-	-	BS21E 开启声光 + 15s 自动停止定时器
停止报警	0x00	-	-	BS21E 立即关闭声光
更新库存数量	0x10	高字节	低字节	强制覆盖 BS21E 的 qty 字段
3.2 指令示例
寻物：[0x01] → 1 字节
停止：[0x00] → 1 字节
更新为 45：[0x10, 0x00, 0x2D] → 3 字节
四、广播参数配置（BS21E 端已固定，WS63 端需匹配）
表格
参数	BS21E 端当前值	WS63 端需匹配值	备注
广播模式	CONNECTABLE_SCANABLE	CONNECTABLE_SCANABLE	✅ 一致
广播间隔 Min	0xC8（200ms）	160-320（100-200ms）	✅ 在范围内
广播间隔 Max	0xC8（200ms）	160-320（100-200ms）	✅ 在范围内
广播信道	0x07（全信道 37/38/39）	SLE_ADV_CHANNEL_MAP_ALL 或 0x07	✅ 一致
广播功率	0（0dBm）	0（0dBm）	✅ 一致
五、连接参数配置（BS21E 端已固定，WS63 端需兼容）
表格
参数	BS21E 端当前值	WS63 端需兼容值	备注
连接监听窗口	海思 SDK 默认（2ms）	无需配置，协议栈自动处理	硬件原生支持
断链自动恢复	连接断开后自动调用 sle_start_announce()	断链后自动恢复扫描	已实现
连接间隔 Min	0x64（100ms）	兼容 100-200ms 即可	
连接间隔 Max	0x64（100ms）	兼容 100-200ms 即可	
最大延迟	0x1F3（499）	兼容即可	
超时监控	0x1F4（500ms）	兼容即可	
六、安全模式配置（当前状态：暂不启用）
表格
模块	当前配置	说明
安全模式	SLE_SECURITY_MODE_NO_SECURITY	仅用于快速验证基础链路
后续计划	基础链路跑通后统一改为 SLE_SECURITY_MODE_ENCRYPTED + SLE_PAIRING_TYPE_JUST_WORKS	
七、WS63 端开发验收清单（逐项打勾后再联调）
表格
序号	验收项	是否完成
1	直接引用了 BS21E 端提供的 shared_protocol.h	☐
2	添加了广播 Payload 结构体的编译时检查	☐
3	广播扫描时过滤魔数 0xAABBCCDD	☐
4	按 Service UUID 0000FF00-... 查找服务	☐
5	按 Property UUID 0000FF01-... 读写特征	☐
6	发送 SSAP Write 时使用正确的指令格式	☐
7	广播参数与 BS21E 端匹配	☐
8	安全模式暂不启用	☐
9	断链后自动恢复扫描	☐
八、联调流程（验收清单完成后执行）
给 BS21E 上电，确认 BS21E 端串口日志正常
给 WS63 上电，确认 WS63 端能扫描到 tag_id=0 的标签
确认 WS63 端能成功连接 BS21E
确认 WS63 端能成功发现 SSAP 服务和特征
测试发送「寻物报警」指令，确认 BS21E 有响应
测试发送「停止报警」指令，确认 BS21E 有响应
测试发送「更新库存数量」指令，确认 BS21E 广播的 qty 字段已更新
测试断链后自动恢复

九、调试补丁：扫描原始数据诊断（v1.0 补丁，2026-04-29）
9.1 问题背景
网关 target 一直为 0，疑似报文过滤太严格导致 magic 匹配失败。需要放开扫描打印限制，在解包和验证 magic 之前先把所有扫描到的设备的 MAC 地址和 Payload 前若干字节的 HEX 直接打印出来，以便判断是 BS21E 没发出来信号，还是发出来的结构体不对齐导致 magic 匹配失败。
9.2 涉及文件
components/sle_network/sle_network.c
9.3 修改点一：my63_seek_result_cb（扫描结果回调）
位置：my63_seek_result_cb 函数体内，在已有的 MAC 地址打印之后、调用 my63_extract_adv_field 之前。
修改内容：新增原始 Payload HEX 打印，最多打印前 32 字节。
修改前代码：
c
运行
    osal_printk("[WS63_NET] seek result rssi=%d, addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
        ...);

    if (my63_extract_adv_field(seek_result_data, &adv) == 0) {
修改后代码：
c
运行
    osal_printk("[WS63_NET] seek result rssi=%d, addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
        ...);

    osal_printk("[WS63_NET] RAW PAYLOAD len=%u: ", (unsigned int)seek_result_data->data_length);
    if (seek_result_data->data != NULL && seek_result_data->data_length > 0) {
        uint16_t dump_len = seek_result_data->data_length;
        if (dump_len > 32) {
            dump_len = 32;
        }
        for (uint16_t i = 0; i < dump_len; i++) {
            osal_printk("%02X ", seek_result_data->data[i]);
        }
    } else {
        osal_printk("(null or empty)");
    }
    osal_printk("\r\n");

    if (my63_extract_adv_field(seek_result_data, &adv) == 0) {
作用：每次扫描回调触发时，无论是否匹配 magic，都会先打印原始 Payload 的 HEX 字节流（最多 32 字节），让开发者直接看到 BS21E 广播的原始数据。
9.4 修改点二：my63_extract_adv_field（AD 字段解析函数）
位置：my63_extract_adv_field 函数体内的 for 循环中。
修改内容：为每个解析到的 AD field 增加诊断打印，包括 offset、len、type、data_len 和 HEX 内容；对 manufacturer 字段（type=0xFF）单独打印长度不匹配或 magic 失败的详细信息。
修改前代码：
c
运行
    for (uint8_t offset = 0; (uint8_t)(offset + 1U) < length;) {
        uint8_t field_len = data[offset];
        uint8_t field_type;
        uint8_t field_data_len;

        if (field_len == 0 || (uint8_t)(offset + field_len) >= length + 1U) {
            break;
        }

        field_type = data[offset + 1U];
        field_data_len = (uint8_t)(field_len - 1U);

        if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER && field_data_len == SHARED_PROTO_ADV_FIELD_LEN) {
            if (shared_protocol_unpack_adv(&data[offset + 2U], field_data_len, out_field) == SHARED_PROTO_OK) {
                return 1;
            }
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }
修改后代码：
c
运行
    for (uint8_t offset = 0; (uint8_t)(offset + 1U) < length;) {
        uint8_t field_len = data[offset];
        uint8_t field_type;
        uint8_t field_data_len;

        if (field_len == 0 || (uint8_t)(offset + field_len) >= length + 1U) {
            osal_printk("[WS63_NET] AD field parse break at offset=%u field_len=%u total_len=%u\r\n",
                (unsigned int)offset, (unsigned int)field_len, (unsigned int)length);
            break;
        }

        field_type = data[offset + 1U];
        field_data_len = (uint8_t)(field_len - 1U);

        osal_printk("[WS63_NET] AD field offset=%u len=%u type=0x%02X data_len=%u hex: ",
            (unsigned int)offset, (unsigned int)field_len, (unsigned int)field_type,
            (unsigned int)field_data_len);
        {
            uint8_t print_len = field_data_len;
            if (print_len > 16) {
                print_len = 16;
            }
            for (uint8_t p = 0; p < print_len; p++) {
                osal_printk("%02X ", data[offset + 2U + p]);
            }
        }
        osal_printk("\r\n");

        if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER && field_data_len == SHARED_PROTO_ADV_FIELD_LEN) {
            if (shared_protocol_unpack_adv(&data[offset + 2U], field_data_len, out_field) == SHARED_PROTO_OK) {
                return 1;
            }
            osal_printk("[WS63_NET] manufacturer field found but unpack/magic failed, first 4 bytes: %02X %02X %02X %02X\r\n",
                data[offset + 2U], data[offset + 3U], data[offset + 4U], data[offset + 5U]);
        } else if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER) {
            osal_printk("[WS63_NET] manufacturer field type=0xFF but data_len=%u expect=%u\r\n",
                (unsigned int)field_data_len, (unsigned int)SHARED_PROTO_ADV_FIELD_LEN);
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }
作用：逐字段打印广播数据的 AD structure，帮助定位以下问题：
- BS21E 是否真的在广播 manufacturer 字段（type=0xFF）
- manufacturer 字段的 data_len 是否等于 12（SHARED_PROTO_ADV_FIELD_LEN）
- 如果 data_len 不等于 12，说明 BS21E 端广播结构体长度与 WS63 端期望不一致
- 如果 data_len 等于 12 但 magic 仍然失败，打印前 4 字节可直接看到 BS21E 实际发出的 magic 值
9.5 预期串口输出示例
场景 A：BS21E 正常广播，magic 对齐成功
[WS63_NET] seek result rssi=-45, addr=XX:XX:XX:XX:XX:XX
[WS63_NET] RAW PAYLOAD len=XX: 07 FF DD CC BB AA 00 00 5F 00 00 5F ...
[WS63_NET] AD field offset=0 len=7 type=0xFF data_len=6 hex: DD CC BB AA 00 00
[WS63_NET] manufacturer field type=0xFF but data_len=6 expect=12
[WS63_NET] adv payload not matched or magic invalid
→ 说明 BS21E 广播的 manufacturer 字段长度不对（只有 6 字节而非 12 字节），需要检查 BS21E 端广播数据填充逻辑。
场景 B：BS21E 正常广播，magic 完全匹配
[WS63_NET] seek result rssi=-45, addr=XX:XX:XX:XX:XX:XX
[WS63_NET] RAW PAYLOAD len=XX: 0D FF DD CC BB AA 00 00 00 00 00 5F 00 01 ...
[WS63_NET] AD field offset=0 len=13 type=0xFF data_len=12 hex: DD CC BB AA 00 00 00 00 00 5F 00 01
[WS63_NET] adv matched tag=0 qty=0 status=0 bat=95 seq=1
→ 说明 magic 对齐成功，target 应该被找到。
场景 C：完全没有任何 RAW PAYLOAD 输出
→ 说明 BS21E 没有发出可被 WS63 扫描到的广播信号，需要检查 BS21E 端是否上电、广播是否启动。
9.6 诊断决策树
1. 看到 RAW PAYLOAD 但没有 AD field 打印 → 广播数据格式异常，可能不是标准 AD structure
2. 看到 AD field 但没有 type=0xFF → BS21E 没有使用 manufacturer specific 类型广播，需检查 BS21E 端广播配置
3. 看到 type=0xFF 但 data_len ≠ 12 → 两端结构体长度不一致，需对齐 shared_protocol.h
4. 看到 type=0xFF 且 data_len=12 但 unpack/magic failed → 看 first 4 bytes 判断实际 magic 值，可能是字节序问题（大端 vs 小端）
5. 完全没有 RAW PAYLOAD → BS21E 未广播或信号未到达 WS63
9.7 补丁回退说明
此补丁仅用于诊断，会增加串口输出量。基础链路跑通后，建议：
- 移除 my63_seek_result_cb 中的 RAW PAYLOAD 打印
- 移除 my63_extract_adv_field 中的逐字段 AD field 打印
- 保留 magic 失败时的 first 4 bytes 打印（作为长期诊断保留）

十、调试补丁 v2：local_name 匹配 + 主动扫描 + 扫描计数器（2026-04-29）
10.1 问题背景
补丁 v1 烧录后串口日志显示 seek_result_cb 从未被触发（无 RAW PAYLOAD 输出），说明问题不在 magic 过滤，而是扫描根本没收到任何设备。同时确认 BS21E 端广播数据结构为：DISCOVERY_LEVEL + ACCESS_MODE + manufacturer data + TX_POWER_LEVEL + COMPLETE_LOCAL_NAME("BS2x_Tag")，seek_rsp_data = NULL。
10.2 修改点一：被动扫描 → 主动扫描
文件：components/sle_network/sle_network.c
位置：sle_network_start_scan 函数
修改：param.seek_type[0] = 0 → param.seek_type[0] = SLE_SEEK_ACTIVE
原因：sle_one_to_many 官方样例使用 seek_type=1（主动扫描），主动扫描会发送 SCAN_REQ 让对端回应 SCAN_RSP，能发现更多设备。被动扫描只收广播，可能漏掉某些广播格式的设备。
10.3 修改点二：新增 my63_check_local_name 函数
文件：components/sle_network/sle_network.c
功能：遍历广播数据中的 AD structure，查找 type=0x09（COMPLETE_LOCAL_NAME）字段，与 "BS2x_Tag" 做字符串匹配。
匹配逻辑：
- 如果 local_name 完全匹配 "BS2x_Tag"（8字节），返回 1
- 如果找到 local_name 但不匹配，打印实际 name 值和期望值，方便对比
- 如果没有找到 local_name 字段，返回 0
10.4 修改点三：seek_result_cb 增加 local_name 降级连接
文件：components/sle_network/sle_network.c
位置：my63_seek_result_cb 函数
逻辑变更：
1. 先检查 local_name 是否匹配 "BS2x_Tag"
2. 再检查 manufacturer data（magic + tag_id）
3. 如果 manufacturer data 匹配成功 → 正常连接（优先路径）
4. 如果 manufacturer data 匹配失败但 local_name 匹配成功 → 降级连接（按 name 连接）
5. 两者都不匹配 → 跳过
目的：即使 manufacturer data 结构不对齐或 magic 不匹配，只要 local_name 对了就能连上，确保基础链路先跑通。
10.5 修改点四：扫描计数器 + 扫描活跃状态
文件：components/sle_network/sle_network.c + sle_network.h
新增全局变量：
- g_my63_scan_result_count：扫描回调被触发的累计次数
- g_my63_scan_active：当前扫描是否处于活跃状态（1=扫描中，0=已停止）
新增 API：
- uint32_t sle_network_get_scan_count(void)：获取扫描结果计数
- int sle_network_get_scan_active(void)：获取扫描活跃状态
作用：在心跳日志中显示 scan_cnt 和 scan_on，一眼判断扫描是否在工作。
10.6 修改点五：心跳日志增强 + 扫描自动重启
文件：app/main.c
修改内容：
1. 心跳日志增加 scan_cnt=%u scan_on=%d 字段
2. 当 target=0 且 scan_cnt=0 且 scan_on=0 时，自动调用 sle_network_start_scan() 重启扫描
作用：防止扫描意外停止后系统假死，确保扫描持续进行。
10.7 预期串口输出变化
修改前心跳：
[WS63_APP] heartbeat alive target=0 connected=0 link_lost=0 authenticated=0 ssap_ready=0
修改后心跳：
[WS63_APP] heartbeat target=0 connected=0 link_lost=0 authenticated=0 ssap_ready=0 scan_cnt=0 scan_on=1
关键诊断字段：
- scan_cnt=0 scan_on=1 → 扫描在跑但没收到任何设备，检查 BS21E 是否上电广播
- scan_cnt>0 scan_on=1 → 收到了设备但没匹配上，看 RAW PAYLOAD 和 AD field 日志
- scan_cnt=0 scan_on=0 → 扫描已停止且无结果，系统会自动重启扫描
10.8 BS21E 广播数据结构参考
BS21E 端实际广播 AD structure 组成：
AD Field 1: DISCOVERY_LEVEL (type=0x07)
AD Field 2: ACCESS_MODE (type=0x03)
AD Field 3: Manufacturer Specific Data (type=0xFF) — 包含 shared_proto_adv_field_t
AD Field 4: TX_POWER_LEVEL (type=0x0A)
AD Field 5: COMPLETE_LOCAL_NAME (type=0x09) — 值为 "BS2x_Tag"
seek_rsp_data: NULL（无扫描响应数据）
WS63 端匹配策略：优先匹配 manufacturer data（magic + tag_id），降级匹配 local_name("BS2x_Tag")