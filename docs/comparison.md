# Comparison: claude-trinity vs Alternatives

## Feature Matrix

| Feature | claude-trinity | Vanilla Claude Code | Codex CLI (OpenAI) | OpenCode | Cursor / Windsurf |
|---------|---------------|--------------------|--------------------|----------|-------------------|
| **Memory** | | | | | |
| Persistent memory across sessions | ✅ Three layers | ❌ | ❌ | ❌ | ⚠️ Limited |
| Auto-loaded project rules | ✅ Path-aware `.claude/rules/` | ✅ CLAUDE.md only | ❌ | ❌ | ⚠️ .cursorrules |
| Cross-project memory | ✅ crossmem.md | ❌ | ❌ | ❌ | ❌ |
| Structured facts with versioning | ✅ JSON + superseded | ❌ | ❌ | ❌ | ❌ |
| Semantic search over history | ✅ via claude-mem (L3) | ❌ | ❌ | ❌ | ❌ |
| Context compression protection | ✅ Compact directive | ❌ | N/A | N/A | N/A |
| **Methodology** | | | | | |
| Built-in reasoning framework | ✅ Dialectical method | ❌ | ❌ | ❌ | ❌ |
| Investigation-first principle | ✅ | ❌ | ❌ | ❌ | ❌ |
| Debugging decision trees | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Setup** | | | | | |
| Install time | ~5 min | N/A | ~10 min | ~15 min | ~5 min |
| Requires API key | ❌ Free | ❌ | ✅ OpenAI key | ✅ Various | ✅ Subscription |
| One-command install | ✅ `bash install.sh` | N/A | ✅ `npm install` | ⚠️ Build needed | ✅ Installer |
| Cross-platform | ✅ bash + PowerShell | ✅ | ✅ | ⚠️ Mostly Linux | ✅ |
| **Extensibility** | | | | | |
| Custom rules | ✅ Markdown files | ✅ CLAUDE.md | ❌ | ❌ | ⚠️ Limited |
| Hooks system | ✅ SessionStart + more | ✅ | ❌ | ❌ | ❌ |
| Plugin ecosystem | ✅ via Claude Code | ✅ | ⚠️ | ❌ | ✅ |

## Detailed Comparisons

### vs Vanilla Claude Code

claude-trinity builds ON TOP of Claude Code — it's not a replacement. You're still using Claude Code; you're just adding structured memory.

**What Vanilla Claude Code gives you:**
- CLAUDE.md per project (good for project-level instructions)
- `.claude/rules/` directory support
- Hooks system

**What claude-trinity adds:**
- A template for effective MEMORY.md with architectural awareness
- Cross-project memory (crossmem.md) that carries learnings between projects
- Structured facts with version tracking (superseded mechanism)
- Optional semantic search over all past observations (L3)
- A methodology framework for systematic problem-solving
- Ready-to-use rule templates for common project types

### vs Codex CLI

Codex CLI is OpenAI's command-line coding assistant. It's a different tool entirely.

| Aspect | claude-trinity | Codex CLI |
|--------|---------------|-----------|
| Base model | Claude (Anthropic) | GPT-4 / o-series (OpenAI) |
| Memory | Three-layer persistent | None between sessions |
| Cost | Free (uses your Claude Code sub) | Requires OpenAI API key |
| Customization | Markdown rules + hooks | Limited configuration |
| IDE integration | Via Claude Code | Standalone CLI |

### vs OpenCode

OpenCode is an open-source terminal-based AI coding tool.

| Aspect | claude-trinity | OpenCode |
|--------|---------------|----------|
| Maturity | Built on Claude Code (production) | Community project |
| Model support | Claude models | Multiple providers |
| Memory | Three layers | No persistent memory |
| Setup | 5 min | Build from source |
| Platform | All (bash/PS1) | Primarily Linux |

### vs IDE-integrated tools (Cursor, Windsurf)

These are full IDE replacements with AI built in.

| Aspect | claude-trinity | Cursor / Windsurf |
|--------|---------------|-------------------|
| Approach | Memory layer for CLI | Full IDE |
| Cost | Free | Subscription required |
| Memory | Three layers, structured | Basic context retention |
| Editor lock-in | None (use any editor) | Must use their IDE |
| Terminal workflow | Native | Secondary |
| Customization | Full control | Platform-dependent |

## When to Choose claude-trinity

**Choose claude-trinity if you:**
- Already use Claude Code and want to make it smarter
- Prefer terminal-based workflows
- Want persistent, structured memory across sessions
- Value methodology and systematic approaches
- Don't want to pay for additional subscriptions
- Want full control over your AI's context and rules

**Don't choose claude-trinity if you:**
- Prefer a GUI/IDE experience (consider Cursor)
- Need multi-model support (consider OpenCode)
- Don't use Claude Code
