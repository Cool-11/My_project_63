# Claude Code 插件使用指南

> 已安装 10 个插件，覆盖测试、审查、文档、安全、编排五大场景。

## 插件清单

| 分类 | 插件名 | 版本 | 来源 |
|------|--------|------|------|
| 测试 | unit-testing | 1.2.0 | agents |
| 测试 | qa-orchestra | 1.0.0 | agents |
| 测试 | ruflo-testgen | 0.2.0 | ruflo |
| 代码审查 | comprehensive-review | 1.3.0 | agents |
| 代码审查 | ruflo-jujutsu | 0.2.0 | ruflo |
| 文档 | ruflo-docs | 0.2.0 | ruflo |
| 安全 | security-scanning | 1.3.1 | agents |
| 编排 | full-stack-orchestration | 1.3.0 | agents |
| 编排 | ruflo-core | 0.2.2 | ruflo |
| 开发 | python-development | 1.2.2 | agents |

---

## 什么时候用什么

### 写完一个模块后 → 测试

| 场景 | 命令 | 说明 |
|------|------|------|
| 给某个 .c 文件写单元测试 | `/test-generate <文件路径>` | 自动分析函数签名，生成测试用例 |
| 找出哪些代码没被测试覆盖 | `/testgen <目录或文件>` | 覆盖率分析 + 缺失测试检测 |
| 端到端 QA 测试 | `/qa-orchestra` | 多 agent 协作，含浏览器验证 |

**适用时机**：
- 新增了 business_logic 的某个 cmd 处理函数后
- 修完 bug 后想确认不会复现
- 提交前想确认测试覆盖率

---

### 改完代码后 → 审查

| 场景 | 命令 | 说明 |
|------|------|------|
| 全面代码审查（架构+安全+性能） | `/full-review <文件或目录>` | 三个专业 agent 并行审查 |
| 只想看当前 git 改动的风险 | `/jujutsu` | diff 分析 + 风险评分 + 改动分类 |
| 优化 PR 描述 | `/pr-enhance` | 自动生成 PR 标题、描述、测试计划 |

**适用时机**：
- 改完 sle_network.c 后不确定有没有引入问题
- 准备提交前想看改动风险评分
- 写 PR 时需要自动生成描述

**推荐组合**：先 `/jujutsu` 看风险，再 `/full-review` 深入审查。

---

### 写完代码后 → 文档

| 场景 | 命令 | 说明 |
|------|------|------|
| 给某个模块生成文档 | `/ruflo-docs <文件或目录>` | 自动分析代码生成说明文档 |
| 更新整个项目的文档 | `/ruflo-docs .` | 全量扫描 + 文档更新 |

**适用时机**：
- 新增了一个组件（比如 cloud_storage）后需要写说明
- 代码改了但文档没更新
- 比赛前需要整理项目文档

---

### 涉及安全相关代码时 → 安全扫描

| 场景 | 命令 | 说明 |
|------|------|------|
| 代码安全漏洞扫描 | `/security-sast` | 静态分析，找缓冲区溢出、注入等问题 |
| 检查依赖库有没有已知漏洞 | `/security-dependencies` | 扫描第三方库的 CVE |
| 安全加固建议 | `/security-hardening` | 给出具体的加固措施 |

**适用时机**：
- 涉及 UART 数据解析（缓冲区溢出风险）
- 涉及 MQTT 认证（凭据泄露风险）
- 比赛评审前的安全自查

---

### 需要拆分复杂任务时 → 编排

| 场景 | 命令 | 说明 |
|------|------|------|
| 查看 ruflo 系统状态 | `/ruflo-status` | 查看 MCP server、agent 状态 |
| 全栈功能开发编排 | `/full-stack-feature "功能描述"` | 自动拆分后端+前端+数据库任务 |

**适用时机**：
- 需要同时改 WS63 + ESP32 + 串口屏的跨设备功能
- 复杂功能需要拆分成多个子任务逐步完成

---

## 嵌入式 C 项目的推荐工作流

```
1. 写代码
   └─ 改 business_logic.c / sle_network.c 等

2. 审查（选一个）
   ├─ /jujutsu          ← 快速看风险评分
   └─ /full-review xxx.c  ← 深入审查

3. 测试
   └─ /test-generate xxx.c  ← 生成单元测试

4. 文档
   └─ /ruflo-docs xxx.c  ← 更新文档

5. 安全（可选）
   └─ /security-sast  ← 提交前安全扫描
```

---

## 命令速查表

```
测试:
  /test-generate <path>     生成单元测试
  /testgen <path>           覆盖率分析 + 测试生成
  /qa-orchestra             端到端 QA

审查:
  /full-review <path>       多维度代码审查
  /jujutsu                  git diff 风险分析
  /pr-enhance               PR 描述优化

文档:
  /ruflo-docs <path>        生成/更新文档

安全:
  /security-sast            静态安全扫描
  /security-dependencies    依赖漏洞扫描
  /security-hardening       安全加固

编排:
  /ruflo-status             系统状态
  /full-stack-feature "xxx" 全栈功能编排
```

---

## 注意事项

- 这些插件主要面向 Python/JavaScript 生态，对嵌入式 C 项目的能力有限
- `/test-generate` 生成的测试框架可能是 pytest/Jest，需要手动适配成 C 的测试
- `/security-sast` 对 C 代码的缓冲区溢出、指针越界检测有一定能力
- `/jujutsu` 是最通用的，任何项目都能用
- `/ruflo-docs` 生成的文档格式可能需要手动调整
