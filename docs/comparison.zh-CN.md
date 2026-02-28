# 竞品对比：claude-trinity vs 其他方案

## 功能矩阵

| 功能 | claude-trinity | 原生 Claude Code | Codex CLI (OpenAI) | OpenCode | Cursor / Windsurf |
|------|---------------|-----------------|-------------------|----------|-------------------|
| **记忆** | | | | | |
| 跨会话持久记忆 | ✅ 三层架构 | ❌ | ❌ | ❌ | ⚠️ 有限 |
| 自动加载项目规则 | ✅ 路径感知 `.claude/rules/` | ✅ 仅 CLAUDE.md | ❌ | ❌ | ⚠️ .cursorrules |
| 跨项目记忆 | ✅ crossmem.md | ❌ | ❌ | ❌ | ❌ |
| 结构化事实 + 版本追溯 | ✅ JSON + superseded | ❌ | ❌ | ❌ | ❌ |
| 历史语义搜索 | ✅ via claude-mem (L3) | ❌ | ❌ | ❌ | ❌ |
| 上下文压缩保护 | ✅ Compact 指令 | ❌ | N/A | N/A | N/A |
| **方法论** | | | | | |
| 内置推理框架 | ✅ 辩证法 | ❌ | ❌ | ❌ | ❌ |
| 调查先行原则 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 调试决策树 | ✅ | ❌ | ❌ | ❌ | ❌ |
| **部署** | | | | | |
| 安装时间 | ~5 分钟 | 无需安装 | ~10 分钟 | ~15 分钟 | ~5 分钟 |
| 需要 API key | ❌ 免费 | ❌ | ✅ OpenAI key | ✅ 多种 | ✅ 订阅制 |
| 一键安装 | ✅ `bash install.sh` | 无需安装 | ✅ `npm install` | ⚠️ 需编译 | ✅ 安装器 |
| 跨平台 | ✅ bash + PowerShell | ✅ | ✅ | ⚠️ 主要 Linux | ✅ |
| **扩展性** | | | | | |
| 自定义规则 | ✅ Markdown 文件 | ✅ CLAUDE.md | ❌ | ❌ | ⚠️ 有限 |
| Hooks 系统 | ✅ SessionStart 等 | ✅ | ❌ | ❌ | ❌ |
| 插件生态 | ✅ via Claude Code | ✅ | ⚠️ | ❌ | ✅ |

## 详细对比

### vs 原生 Claude Code

claude-trinity 是构建在 Claude Code **之上**的——不是替代品。你仍然在用 Claude Code，只是加了结构化记忆。

**原生 Claude Code 提供的：**
- 每个项目一个 CLAUDE.md（项目级指令）
- `.claude/rules/` 目录支持
- Hooks 系统

**claude-trinity 额外增加的：**
- 有架构感知的 MEMORY.md 模板
- 跨项目记忆（crossmem.md），在项目间传递经验
- 结构化事实 + 版本追踪（superseded 机制）
- 可选的历史观察语义搜索（L3）
- 系统化问题解决的方法论框架
- 常用项目类型的即用规则模板

### vs Codex CLI

Codex CLI 是 OpenAI 的命令行编码助手，完全不同的工具。

| 维度 | claude-trinity | Codex CLI |
|------|---------------|-----------|
| 基础模型 | Claude (Anthropic) | GPT-4 / o 系列 (OpenAI) |
| 记忆 | 三层持久化 | 会话间无记忆 |
| 费用 | 免费（使用你的 Claude Code 订阅） | 需要 OpenAI API key |
| 自定义 | Markdown 规则 + hooks | 配置有限 |
| IDE 集成 | 通过 Claude Code | 独立 CLI |

### vs OpenCode

OpenCode 是一个开源的终端 AI 编码工具。

| 维度 | claude-trinity | OpenCode |
|------|---------------|----------|
| 成熟度 | 基于 Claude Code（生产级） | 社区项目 |
| 模型支持 | Claude 系列 | 多供应商 |
| 记忆 | 三层架构 | 无持久记忆 |
| 部署 | 5 分钟 | 需从源码编译 |
| 平台 | 全平台（bash/PS1） | 主要 Linux |

### vs IDE 集成工具（Cursor、Windsurf）

这些是内置 AI 的完整 IDE 替代品。

| 维度 | claude-trinity | Cursor / Windsurf |
|------|---------------|-------------------|
| 方式 | CLI 的记忆层 | 完整 IDE |
| 费用 | 免费 | 需要订阅 |
| 记忆 | 三层结构化 | 基本上下文保留 |
| 编辑器锁定 | 无（用任何编辑器） | 必须用它的 IDE |
| 终端工作流 | 原生支持 | 次要功能 |
| 自定义程度 | 完全控制 | 取决于平台 |

## 什么时候选 claude-trinity

**选 claude-trinity 如果你：**
- 已经在用 Claude Code，想让它更聪明
- 偏好终端工作流
- 想要跨会话的持久化结构化记忆
- 重视方法论和系统化方法
- 不想为额外订阅付费
- 想完全控制 AI 的上下文和规则

**不选 claude-trinity 如果你：**
- 偏好 GUI/IDE 体验（考虑 Cursor）
- 需要多模型支持（考虑 OpenCode）
- 不使用 Claude Code
