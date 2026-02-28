# claude-trinity 推广文案集

> 各平台直接复制粘贴，按需微调。

---

## 1. V2EX（创意/分享节点）

**标题：** Claude Code 用户必备：三层记忆系统，让 AI 不再失忆

**正文：**

用 Claude Code 的朋友应该都有这个痛点：每次开新会话，之前说过的项目规范、调试经验、工具偏好全忘了，又得重头解释一遍。

我做了个开源工具 claude-trinity，给 Claude Code 加了三层持久记忆：

- L1 热层：按项目目录自动加载规则（比如"这个项目用 python3 不要用 python"）
- L2 温层：每次会话自动注入你的偏好、跨项目经验、项目事实
- L3 库层：可选的语义搜索，能从历史会话里按语义找到相关经验

安装就三步，不到5分钟：

```
git clone https://github.com/a228410395/claude-trinity.git
cd claude-trinity
bash install.sh
```

重启 Claude Code 就生效了。

几个特点：
- 免费，MIT 协议，不需要额外 API key
- 跨平台：macOS / Linux / WSL / Windows PowerShell 都支持
- 不覆盖你已有的配置，幂等安装
- 内含一套基于辩证法的调试方法论（别笑，真的好用）

GitHub：https://github.com/a228410395/claude-trinity

欢迎 star、提 issue、贡献规则模板。

---

## 2. 掘金

**标题：** 开源｜Claude Code 三层记忆系统：让你的 AI 编程助手拥有持久记忆

**正文：**

## 痛点

Claude Code 很强大，但有一个致命缺陷：**会话间零记忆**。

每次新会话：
- 你得重新解释项目结构
- 重复说明编码规范
- 看着 AI 犯同样的错误

这不应该是 2026 年 AI 编程的体验。

## 解决方案：claude-trinity

我开源了一套三层记忆架构，直接集成到 Claude Code：

```
L1 热层    →  .claude/rules/*.md     →  按目录自动加载项目规则
L2 温层    →  MEMORY.md + crossmem   →  每次会话自动注入核心记忆
L3 库层    →  claude-mem (SQLite+RAG) →  语义搜索历史经验（可选）
```

### 安装

```bash
git clone https://github.com/a228410395/claude-trinity.git
cd claude-trinity
bash install.sh    # Windows: .\install.ps1
```

### 亮点

1. **零成本** — 不需要额外 API key，不需要付费
2. **5分钟部署** — clone → install → 重启，完事
3. **不侵入** — 不修改 Claude Code 本身，纯文件配置
4. **跨项目记忆** — crossmem.md 在项目间传递经验
5. **版本追溯** — facts/*.json 用 superseded 机制追踪变更历史
6. **方法论加持** — 内置辩证法调试框架（调查先行/抓主要矛盾/实践验证）

### 对比

| 功能 | claude-trinity | 原生 Claude Code | Cursor |
|------|---------------|-----------------|--------|
| 跨会话持久记忆 | ✅ 三层 | ❌ | ⚠️ 有限 |
| 跨项目记忆 | ✅ | ❌ | ❌ |
| 语义搜索历史 | ✅ | ❌ | ❌ |
| 免费 | ✅ | ✅ | ❌ 订阅制 |

GitHub：https://github.com/a228410395/claude-trinity

star 是最大的动力，欢迎试用反馈。

---

## 3. 知乎（回答/文章）

**标题：** 如何让 Claude Code 拥有持久记忆？我做了一个开源方案

**正文：**

> 这篇文章适合正在用 Claude Code 做日常开发的程序员。

### 问题

Claude Code 的上下文在会话结束后就丢失了。CLAUDE.md 只能做项目级的简单说明，跨项目经验、调试心得、个人偏好全靠每次手动重复。

### 我的方案

我把自己半年来打磨的记忆系统脱敏开源了：**claude-trinity**

它的核心思路是分层：

**L1 热层（自动，毫秒级）**
`.claude/rules/` 目录下的 Markdown 文件，按你的工作目录自动加载。比如你在 Docker 项目里工作，Docker 规则自动生效；切到前端项目，前端规则自动替换。

**L2 温层（自动，每次会话）**
- `MEMORY.md`：核心偏好、模型配置、常用路径速查
- `crossmem.md`：跨项目观察记录，按 P0/P1/P2 分级
- `facts/*.json`：结构化项目事实，支持版本追溯

**L3 库层（按需，语义搜索）**
集成 claude-mem 插件，用本地向量数据库存储所有历史观察，需要时语义搜索召回。

### 方法论

额外做了一套基于毛泽东《实践论》《矛盾论》的调试方法论——

不是搞政治，是这些哲学框架真的能映射到工程实践：
- 没有调查就没有发言权 → 先读代码再动手
- 抓主要矛盾 → 找根因，不要追枝节
- 实践是检验真理的唯一标准 → 跑一遍，不是"应该能行"

### 链接

GitHub：https://github.com/a228410395/claude-trinity

MIT 协议，免费使用。安装5分钟，star 一秒钟 :)

---

## 4. Reddit（r/ClaudeAI 或 r/ChatGPTCoding）

**Title:** I built an open-source persistent memory system for Claude Code — 3 layers, 5-minute setup, zero cost

**Body:**

Claude Code is amazing, but it forgets everything between sessions. I got tired of re-explaining my project structure, coding conventions, and debugging insights every single time.

So I built **claude-trinity** — a three-layer memory architecture that gives Claude Code persistent, structured memory:

- **L1 Hot**: Project rules auto-loaded by directory (`.claude/rules/*.md`)
- **L2 Warm**: Core preferences + cross-project patterns auto-loaded every session
- **L3 Store**: Optional semantic search over your entire coding history via claude-mem

**Install:**
```
git clone https://github.com/a228410395/claude-trinity.git
cd claude-trinity
bash install.sh
```

Restart Claude Code. Done. Under 5 minutes.

**Why it's worth trying:**
- Free, MIT licensed, no API keys needed
- Cross-platform (macOS, Linux, WSL, Windows PowerShell)
- Won't overwrite your existing config
- Includes a dialectical methodology for systematic debugging
- CI-tested on Ubuntu, macOS, and Windows

**GitHub:** https://github.com/a228410395/claude-trinity

Would love feedback. What memory features would you want in an AI coding assistant?

---

## 5. Twitter/X

**英文版（@anthropic 蹭流量）：**

I built an open-source 3-layer memory system for @AnthropicAI's Claude Code.

L1: Auto-loaded project rules
L2: Persistent preferences + cross-project memory
L3: Semantic search over coding history

Free. 5-minute setup. MIT licensed.

https://github.com/a228410395/claude-trinity

#ClaudeCode #AI #OpenSource #DevTools

**中文版：**

给 Claude Code 做了个三层记忆系统，开源了。

L1 热层：按项目自动加载规则
L2 温层：偏好+跨项目记忆每次自动注入
L3 库层：语义搜索历史调试经验

免费，5分钟安装，MIT 协议。

https://github.com/a228410395/claude-trinity

#ClaudeCode #AI编程 #开源

---

## 6. 小红书

**标题：** AI编程效率翻倍！Claude Code 必装记忆插件

**正文：**

用 Claude Code 写代码的姐妹/兄弟们！

是不是每次开新对话都要重新解释一遍项目？
是不是看着 AI 犯同样的错误想摔键盘？

我做了个免费开源工具 claude-trinity 🔥

✅ 自动记住你的项目规范
✅ 自动加载你的编码偏好
✅ 跨项目经验自动传递
✅ 历史调试记录语义搜索

安装只要5分钟，clone 下来跑一行命令就行

GitHub 搜 claude-trinity 或直接访问：
github.com/a228410395/claude-trinity

免费开源 MIT 协议 不要钱！

还有个亮点：内置了一套基于哲学思维的调试方法论
（没有调查就没有发言权 → 先读代码再动手，真的好用）

求 star ⭐ 你的 star 就是我更新的动力！

#AI编程 #ClaudeCode #程序员 #效率工具 #开源项目

---

## 7. 投稿 Awesome 列表（PR 描述模板）

**awesome-claude / awesome-ai-tools 类仓库的 PR：**

**Title:** Add claude-trinity — persistent memory system for Claude Code

**Body:**

- **Name:** claude-trinity
- **URL:** https://github.com/a228410395/claude-trinity
- **Description:** Three-layer persistent memory system for Claude Code (L1 rules + L2 core memory + L3 semantic search). Free, MIT licensed, 5-minute setup.
- **Category suggestion:** Claude Code Tools / Plugins / Memory

Added under the relevant section. Follows the contribution guidelines.
