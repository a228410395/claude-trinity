# 常见问题

## 基本问题

### claude-trinity 是什么？

为 Claude Code 打造的三层记忆系统，让你的 AI 助手拥有跨会话的持久记忆。它能记住你的偏好、项目事实、调试心得，并自动应用项目专属规则。

### 能用在其他 AI 工具上吗（Cursor、Copilot 等）？

不能。claude-trinity 专为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)（Anthropic 的 CLI 工具）设计。L1 规则和 hooks 系统是 Claude Code 的功能。不过，方法论文档和结构化记忆的思路可以启发其他工具的类似配置。

### 免费吗？

是的。claude-trinity 本身是 MIT 协议，完全免费。它需要 Claude Code 运行（Claude Code 有自己的定价），但 claude-trinity 不增加任何额外费用。

### 会把我的数据发到外部吗？

不会。所有记忆都存储在本地 `~/.claude/` 目录下。可选的 L3 层（claude-mem）同样把数据存在本地的 SQLite 和 Chroma 中。除非你主动配置 hooks 向外发送（比如 Telegram 通知），否则不会有任何数据离开你的电脑。

## 安装问题

### 安装脚本失败了怎么办？

1. 确认已安装 Git：`git --version`
2. 确认有 bash（macOS/Linux）或 PowerShell（Windows）
3. 用 `bash -x install.sh` 运行查看详细输出
4. 如果某一步失败，可以跳过：`bash install.sh --skip-claude-mem --skip-hooks`
5. 带上错误输出开一个 issue

### 可以不用脚本手动安装吗？

可以。脚本本质上就是复制文件。你可以手动：
1. 把 `templates/rules/*.md` 复制到 `~/.claude/rules/`
2. 把 `templates/memory/*` 复制到 `~/.claude/memory/`
3. 把 `methodology/methodology.md` 复制到 `~/.claude/memory/methodology/`
4. 可选：把 `templates/settings-hooks.unix.json`（或 `.windows.json`）合并到 `~/.claude/settings.json`

### 会覆盖我现有的 MEMORY.md 吗？

不会。安装脚本会检测已有文件并跳过，绝不覆盖你的数据。

### 我已经有 settings.json 了，hooks 会自动添加吗？

不会。如果 `~/.claude/settings.json` 已存在，安装器会把 hooks 模板保存为 `settings-hooks-template.json`，提示你手动合并，避免意外覆盖你的配置。

## 使用问题

### 怎么添加记忆条目？

直接告诉 Claude："记下来"或"写下来"。Claude 会确认后写入对应文件（crossmem.md 存跨项目经验，facts/ 存项目专属事实，MEMORY.md 存偏好）。

### 怎么搜索过去的记忆？

如果安装了 L3（claude-mem），可以用语义搜索查找相关的历史观察。没有 L3 的话，可以让 Claude 读取特定文件："加载 crossmem"或"查看项目 X 的 facts"。

### 上下文被压缩了，信息丢失了，为什么？

Claude Code 在对话变长时会压缩上下文。MEMORY.md 包含了"Compact 保护指令"，告诉 Claude 在压缩时保留记忆文件。但对话中的具体细节仍可能丢失。这就是为什么系统鼓励**立刻**把重要观察写入文件，而不是等到会话结束。

### 规则文件能有多少个？

没有硬限制，但每个规则文件都消耗上下文窗口 token。实际建议：控制在 10 个以内，保持内容聚焦。一个写得好的规则文件比一堆模糊的好。

### SECRET_PHRASE 是干什么的？

这是一个金丝雀值。如果 Claude 在回复中输出了你的密钥短语，说明上下文发生了泄露——记忆文件的内容被不当暴露了。设一个独特的短语，永远不要分享。

## L3（claude-mem）

### 我需要 L3 吗？

不一定。L1 和 L2 提供了核心价值——持久规则、偏好和结构化事实。L3 增加了对历史观察的语义搜索，如果你会话很多且想按语义而非关键词搜索，L3 很有用。很多用户觉得 L1+L2 就够了。

### claude-mem 安装失败了，其他功能还能用吗？

能。L3 完全可选。用 `--skip-claude-mem` 跳过，正常使用 L1+L2。

### L3 占多少磁盘空间？

SQLite 数据库和 Chroma 向量会随使用增长。使用几个月后的典型大小：50-200 MB。本地嵌入模型（all-MiniLM-L6-v2）约 80 MB。

## 方法论

### 为什么用毛泽东的文章？

三篇文章（《实践论》《矛盾论》《反对本本主义》）包含了通用的推理框架，恰好能很好地映射到软件工程：
- 调查先行 → 先读代码再动手
- 抓主要矛盾 → 找根因
- 实践-理论循环 → 跑代码、观察、形成假设、重复

这不是政治声明。方法论提取的是哲学和逻辑框架，它们作为工程原则有独立的价值。

### 我能用其他方法论吗？

当然。方法论文件就是一个 Markdown 文档。换成你自己的推理框架，或完全删除。三层记忆系统和方法论是独立的。

## 故障排除

### Claude 好像没有加载我的规则

1. 确认规则文件在 `~/.claude/rules/`（全局）或 `<project>/.claude/rules/`（项目）
2. 确认文件以 `.md` 结尾
3. 开一个新的 Claude Code 会话（规则在会话开始时加载）
4. 问 Claude："加载了哪些规则？"来验证

### Claude 忘了我让它记住的东西

1. 检查会话是否被压缩了（长对话会触发 compact）
2. 确认记忆是否真的写入了：读 `~/.claude/memory/crossmem.md`
3. 重点：告诉 Claude "现在就写下来"而非"以后记一下"

### Hooks 没有触发

1. 确认 `~/.claude/settings.json` 的 hooks 结构正确
2. 在终端手动运行 hook 命令，确认能执行
3. 重启 Claude Code——hooks 在会话开始时加载
4. 检查超时——如果 hook 执行时间超过 timeout，会被静默终止
