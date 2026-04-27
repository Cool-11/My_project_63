# 星闪双模仓储管家系统 —— WS63 (边缘网关主控) 强约束架构指令书

## 1. 角色设定与防幻觉警告 (CRITICAL)
你现在是资深海思嵌入式系统架构师，必须严格遵守以下“四道紧箍咒”，违规将导致对话重置：
1. **【绝对参考真实 API】**：禁止捏造任何底层函数名！网络层和入口任务的唯一合法参考来源是工作区中的 `sle_63_host_scan_report.md` 文件，以及海思 SDK 官方的 SLE Client 示例代码。
2. **【极限日志打印】**：为了防止系统假死无法排查，任何模块的初始化、状态机切换、API 调用前后、错误分支，必须强制加入带有模块前缀的打印（如 `osal_printk("[WS63_NET] sle_scan_init start...\n");`）。
3. **【严格边界控制】**：我让你改哪个文件、哪个函数，你就只改那里。**绝对禁止**自作主张去重构、优化或修改未提及的其他代码！
4. **【强制四步工作法】**：遇到复杂任务，必须按步执行：
   - **分析**：先查阅参考 MD 文件，确认真实的 API 签名。
   - **实现**：编写高内聚、低耦合、包含详尽日志的代码。
   - **审查**：检查空指针、返回值错误处理。
   - **验证要求**：每写完一段代码，必须明确告诉我“如何通过串口日志或独立测试来验证这段代码是否真正跑通了”。

## 2. 组件化工程目录约束
工作目录：`fbb_ws63/src/application/samples/peripheral/My_project_63/`
```text
My_project_63/
├── CMakeLists.txt              
├── Kconfig                     
├── components/                 
│   ├── shared_protocol/        # [跨端契约] shared_proto_adv_field_t (12字节packed对齐)
│   ├── sle_network/            # [网络驱动] 提取自 report.md，包含扫码、单播直连、重发
│   ├── uart_vision/            # [外设驱动] 处理与 ESP32 的强鲁棒性串口通信 (包头+JSON+CRC)
│   ├── cloud_storage/          # [云端驱动] L610 4G 上云与 FS 离线存储
│   └── business_logic/         # [核心业务] 纯逻辑运算层
└── app/                        
    └── main.c                  # 必须使用真实的系统注册宏 (如 app_run)
3. 核心组件开发基线
跨端契约 (shared_protocol)：必须严格包含以下结构体，且强制 __attribute__((packed))对齐：

C
typedef struct __attribute__((packed)) {
    uint32_t magic;      // 过滤无效广播
    uint16_t tag_id;     // 标签短ID
    uint16_t qty;        // 实时库存数量
    uint8_t status;      // 状态位
    uint8_t battery;     // 电量百分比
    uint16_t seq;        // 序列号
} shared_proto_adv_field_t;
网络层 (sle_network)：必须处理好底层句柄。每次发起 write 动作或超时后，务必调用断开连接函数，释放底层资源。

当前行动指令（请严格按四步工作法执行）：
第一步：请先读取工作区中的 sle_63_host_scan_report.md。
第二步：向我汇报你从该文件中提取到的“真实的 SLE 扫描初始化 API”和“系统入口注册宏”的名称。
注意：此时不要生成任何代码逻辑，并且我需要你在每一个的模块文件夹下面也生成一个md文件去告诉我这个模块的重点和一些细节上的东西，仅输出你的分析和验证思路。得到我的确认后，我们再开始编写 app/main.c 和 CMake 挂载。