# claude-trinity

**为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 打造的三层记忆系统，让你的 AI 助手能够记住、学习和适应。**

```
┌─────────────────────────────────────────────────────────┐
│                   claude-trinity                        │
│                                                         │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │  L1 热层     │  │  L2 温层      │  │  L3 库层      │  │
│  │  rules/*.md  │  │  MEMORY.md   │  │  claude-mem   │  │
│  │             │  │  crossmem.md │  │  SQLite+RAG   │  │
│  │  路径感知    │  │  facts/*.json│  │               │  │
│  │  自动加载    │  │  会话启动     │  │  语义搜索     │  │
│  │             │  │  自动加载     │  │  按需召回     │  │
│  └─────────────┘  └──────────────┘  └───────────────┘  │
│                                                         │
│  触发方式：       触发方式：         触发方式：          │
│  自动（按路径）   自动（每次会话）    按需（语义查询）    │
└─────────────────────────────────────────────────────────┘
```

## 为什么需要 claude-trinity？

Claude Code 很强大，但每次会话之间它会忘记一切。你不得不反复解释同样的指令、重新说明项目结构，看着它犯同样的错误。

**claude-trinity** 通过三层记忆架构解决这个问题：

| 层级 | 内容 | 触发时机 | 示例 |
|------|------|----------|------|
| **L1 热层** | 项目规则 | 按文件路径自动加载 | "在这个项目里始终用 `python3`，不要用 `python`" |
| **L2 温层** | 核心记忆 | 每次会话自动加载 | 你的偏好、跨项目模式、结构化事实 |
| **L3 库层** | 深度记忆 | 按需搜索 | 历史调试记录、架构决策、方法论 |

**额外亮点**：内含基于毛泽东哲学著作的[辩证方法论](methodology/methodology.md)——一套独特的系统化调试和决策框架。

## 快速开始

### 1. 克隆

```bash
git clone https://github.com/anthropics/claude-trinity.git
cd claude-trinity
```

### 2. 安装

**macOS / Linux / WSL / Git Bash：**
```bash
bash install.sh
```

**Windows PowerShell：**
```powershell
.\install.ps1
```

### 3. 重启 Claude Code

打开新的 Claude Code 会话，记忆系统即刻生效。

就这么简单。三步搞定，不到5分钟。

## 安装内容

```
~/.claude/
├── rules/                    # L1：项目专属规则（含示例）
│   ├── example-web-scraper.md
│   ├── example-docker.md
│   └── example-playwright.md
│
├── memory/                   # L2：持久记忆
│   ├── MEMORY.md             # 主记忆索引（编辑它！）
│   ├── crossmem.md           # 跨项目观察记录
│   ├── facts/                # 结构化项目事实
│   │   └── example-project.json
│   └── methodology/          # 推理框架
│       └── methodology.md
│
├── claude-mem-settings.json  # L3：配置（可选）
└── settings.json             # Hooks 配置（可选）
```

## 三层架构详解

### L1 — 热层：项目规则

`.claude/rules/` 中的规则文件根据你的工作目录自动加载。它们给 Claude 提供项目专属指令，无需你重复说明。

**示例**：Docker 项目规则告诉 Claude 在容器内始终使用 `python3`，用 Docker Compose 服务名代替 `localhost`，以及不要硬编码密钥。

详见 [templates/rules/](templates/rules/) 中的完整示例。

### L2 — 温层：核心记忆

`MEMORY.md` 在每次会话开始时加载，包含：
- 核心原则和偏好
- 模型配置（哪个模型做哪类任务）
- 路径、端点、配置速查
- 给 Claude 的记忆系统使用说明

`crossmem.md` 存储跨项目通用的观察——调试心得、工具偏好、踩过的坑。

`facts/` 包含结构化的 JSON 文件，记录每个项目的已验证事实（数据库类型、认证方式、部署方案等）。

### L3 — 库层：深度记忆（可选）

可选的 `claude-mem` 插件提供：
- **SQLite 存储** 所有观察记录
- **Chroma 向量数据库** 语义搜索
- **自动捕获** 通过 hooks 记录重要观察
- **按需检索** 按语义搜索历史会话，而非仅靠关键词

## 方法论

claude-trinity 包含独特的[辩证方法论](methodology/methodology.md)，提供以下思维模型：

- **调查先行** — 不猜测；先读代码、查日志、理解上下文，再提方案
- **抓主要矛盾** — 找到解决后能连锁解决其他问题的根因
- **实践-理论循环** — 理论指导实践，但运行代码才是检验标准

这些不是抽象哲学——而是从真实调试经验中提炼的实战工程框架。

## 核心原则（精华5条）

1. **没有调查就没有发言权** — 先读代码/文档/日志，搞清楚再动手
2. **实践是检验真理的唯一标准** — 必须实测，不是"应该能跑"
3. **抓主要矛盾** — 先解决 P0，具体问题具体分析
4. **战略乐观战术谨慎** — 问题一定能解决，但要一步步来
5. **反对教条主义和经验主义** — 结合实际环境，不套模板不凭经验猜

## 对比

| 功能 | claude-trinity | 原生 Claude Code | Codex CLI | OpenCode |
|------|---------------|-----------------|-----------|----------|
| 持久记忆 | ✅ 三层架构 | ❌ | ❌ | ❌ |
| 自动加载规则 | ✅ 路径感知 | ✅ 仅 CLAUDE.md | ❌ | ❌ |
| 跨项目记忆 | ✅ crossmem.md | ❌ | ❌ | ❌ |
| 结构化事实 | ✅ JSON + 版本追溯 | ❌ | ❌ | ❌ |
| 语义搜索 | ✅ via claude-mem | ❌ | ❌ | ❌ |
| 方法论框架 | ✅ 辩证法 | ❌ | ❌ | ❌ |
| 安装时间 | ~5 分钟 | 无需安装 | ~10 分钟 | ~15 分钟 |
| 需要 API Key | ❌ 免费 | ❌ | ✅ | ✅ |

## 文档

- [架构深度解析](docs/architecture.md) — 三层如何协作
- [对比表](docs/comparison.md) — 详细功能对比
- [自定义指南](docs/customization.md) — 编写自己的规则和 hooks
- [常见问题](docs/faq.md) — FAQ

## 贡献

欢迎贡献！以下方向特别需要帮助：

- **新规则模板** — 分享你的项目规则（爬虫、ML、移动开发等）
- **方法论扩展** — 额外的推理框架
- **平台测试** — 不同 OS/Shell 组合的测试
- **文档** — 翻译、教程、示例

请先开 issue 讨论重大变更。

## 许可证

[MIT](LICENSE)
