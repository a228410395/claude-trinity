# 自定义指南

## 编写自己的规则（L1）

### 规则文件基础

规则是放在 `.claude/rules/` 目录下的 Markdown 文件。Claude Code 根据你的工作目录自动加载它们。

**两个层级：**

```
~/.claude/rules/          ← 全局规则（所有项目）
<project>/.claude/rules/  ← 项目规则（仅该项目）
```

### 规则文件结构

好的规则文件遵循这个模式：

```markdown
# [领域] 规则

> 一句话描述这些规则的适用场景。

## [类别 1]

- 具体、可执行的指令
- 带理由的另一条指令
- 带示例的指令：`代码示例`

## [类别 2]

- 更多指令...
```

### 写出有效规则的技巧

**要具体，不要模糊：**
```markdown
# 差
- 写好代码
- 正确处理错误

# 好
- 所有 SQL 必须使用参数化查询——禁止字符串拼接
- 所有数据库调用用 try/catch 包裹；抛出前先带 request ID 记录日志
```

**不明显时要说明原因：**
```markdown
# 差
- 容器内始终使用 python3

# 好
- 容器内显式使用 `python3`——Alpine/Debian 镜像的默认 `python` 可能是 python2
```

**给出具体示例：**
```markdown
# 差
- 使用正确的错误响应

# 好
- API 错误必须返回：{ "error": "<message>", "code": "<ERROR_CODE>", "requestId": "<uuid>" }
```

### 示例：为 Next.js 项目创建规则

创建 `~/.claude/rules/nextjs.md` 或 `<project>/.claude/rules/nextjs.md`：

```markdown
# Next.js 项目规则

## 路由
- 使用 App Router (app/) 而非 Pages Router (pages/)
- 所有 API 路由放在 app/api/ 下，使用 route.ts 文件
- 默认使用 Server Components；只在需要时添加 'use client'

## 数据获取
- 优先使用 Server Components 直接调用数据库/API，而非客户端获取
- 使用 React Server Actions 处理变更，而非 API 路由
- 积极缓存：使用 `unstable_cache` 或 `fetch` 配合 `next: { revalidate: 3600 }`

## 样式
- 使用 Tailwind CSS 类，不用 CSS modules 或 styled-components
- 响应式设计：移动优先，使用 sm/md/lg 断点
- 暗色模式：使用 `dark:` 前缀，不要手动切换主题

## 性能
- 图片：始终使用 next/image 并指定 width/height
- 字体：使用 next/font/google，不要用外部 CDN 链接
- 首屏下方组件用 dynamic() 懒加载
```

## 配置 Hooks

### 什么是 Hooks？

Hooks 是 Claude Code 响应事件时执行的 shell 命令。claude-trinity 用 hooks 在会话开始时自动加载跨项目记忆。

### Hook 配置

Hooks 配置在 `~/.claude/settings.json` 中。命令语法取决于你的平台。

**macOS / Linux / WSL：**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "description": "Load cross-project memory",
        "command": "cat \"$HOME/.claude/memory/crossmem.md\" 2>/dev/null || true",
        "timeout": 5000
      }
    ]
  }
}
```

**Windows (PowerShell)：**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "description": "Load cross-project memory",
        "command": "powershell -NoProfile -Command \"$f=Join-Path $env:USERPROFILE '.claude\\memory\\crossmem.md'; if(Test-Path $f){Get-Content $f -Raw}\"",
        "timeout": 5000
      }
    ]
  }
}
```

> **注意**：安装脚本会自动为你的平台选择正确的模板。

### 可用的 Hook 事件

| 事件 | 触发时机 | 常见用途 |
|------|---------|---------|
| `SessionStart` | 新 Claude Code 会话开始 | 加载记忆、设置上下文 |
| `PreToolUse` | Claude 使用工具之前 | 验证、拦截 |
| `PostToolUse` | Claude 使用工具之后 | 记录日志、通知 |
| `Notification` | Claude 发送通知时 | 转发到 Telegram/Slack |

### 示例：Telegram 通知

Claude 完成耗时任务后收到通知：

```json
{
  "hooks": {
    "Notification": [
      {
        "description": "Forward to Telegram",
        "command": "curl -s -X POST 'https://api.telegram.org/bot<TOKEN>/sendMessage' -d chat_id=<CHAT_ID> -d text=\"Claude: $CLAUDE_NOTIFICATION_MESSAGE\"",
        "timeout": 10000
      }
    ]
  }
}
```

将 `<TOKEN>` 替换为你的 Telegram bot token（从 @BotFather 获取），`<CHAT_ID>` 替换为你的聊天 ID。

## 自定义 L2 记忆

### MEMORY.md

编辑 `~/.claude/memory/MEMORY.md`，添加：

1. **你的偏好**：沟通风格、工具选择、编码规范
2. **模型配置**：哪个模型做哪类任务
3. **快速参考**：项目路径、API 端点、重要配置
4. **密钥短语**：用于检测上下文泄露的金丝雀值

### crossmem.md

发现新东西时随时添加：

```markdown
### [P0] [debug] 2025-03-15
**Node.js fetch() 不会在 HTTP 错误时 reject**
不像 axios，原生 fetch() 在 404/500 时也会 resolve。必须在解析前检查 `response.ok`。
```

优先级规则：
- **P0**：花了你 >30 分钟或导致数据丢失
- **P1**：节省了大量时间或防止了 bug
- **P2**：小技巧或风格偏好

### facts/*.json

每个项目创建一个 JSON 文件：

```bash
# 创建新的 facts 文件
cp ~/.claude/memory/facts/example-project.json ~/.claude/memory/facts/my-app.json
```

填入你项目的实际事实。事实变更时使用 `superseded_by` 字段。

## 自定义 L3（claude-mem）

### 调整捕获设置

编辑 `~/.claude/claude-mem-settings.json`：

```json
{
  "capture": {
    "auto_observe": true,
    "min_importance": 0.3,
    "categories": [
      "debug_insight",
      "architecture_decision",
      "your_custom_category"
    ]
  }
}
```

- `min_importance`：0.0–1.0，越低捕获越多（更嘈杂），越高捕获越少
- `categories`：添加你自己的分类来组织记忆

### 调整检索设置

```json
{
  "retrieval": {
    "max_results": 10,
    "similarity_threshold": 0.6,
    "rerank": true
  }
}
```

- `similarity_threshold`：越低结果越多（相关性越低），越高结果越少（相关性越高）
- `rerank`：初次检索后按相关性重排（更慢但效果更好）
