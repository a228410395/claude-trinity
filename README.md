# claude-trinity

**A three-layer memory system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that makes your AI assistant remember, learn, and adapt.**

```
┌─────────────────────────────────────────────────────────┐
│                   claude-trinity                        │
│                                                         │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │  L1 HOT     │  │  L2 WARM     │  │  L3 STORE     │  │
│  │  rules/*.md  │  │  MEMORY.md   │  │  claude-mem   │  │
│  │             │  │  crossmem.md │  │  SQLite+RAG   │  │
│  │  Path-aware │  │  facts/*.json│  │               │  │
│  │  auto-load  │  │  SessionStart│  │  Semantic     │  │
│  │             │  │  auto-load   │  │  search       │  │
│  └─────────────┘  └──────────────┘  └───────────────┘  │
│                                                         │
│  Trigger:         Trigger:          Trigger:            │
│  Automatic        Automatic         On-demand           │
│  (by file path)   (every session)   (by query)          │
└─────────────────────────────────────────────────────────┘
```

## Why claude-trinity?

Claude Code is powerful, but it forgets everything between sessions. You end up repeating the same instructions, re-explaining your project structure, and watching it make the same mistakes.

**claude-trinity** solves this with a three-layer memory architecture:

| Layer | What | When | Example |
|-------|------|------|---------|
| **L1 Hot** | Project rules | Auto-loaded by file path | "In this project, always use `python3`, never `python`" |
| **L2 Warm** | Core memory | Auto-loaded every session | Your preferences, cross-project patterns, structured facts |
| **L3 Store** | Deep memory | Searched on demand | Past debugging sessions, architecture decisions, methodology |

**Bonus**: Includes a [dialectical methodology](methodology/methodology.md) inspired by classical Chinese philosophy — a unique framework for systematic debugging and decision-making.

## Quick Start

### 1. Clone

```bash
git clone https://github.com/anthropics/claude-trinity.git
cd claude-trinity
```

### 2. Install

**macOS / Linux / WSL / Git Bash:**
```bash
bash install.sh
```

**Windows PowerShell:**
```powershell
.\install.ps1
```

### 3. Restart Claude Code

Open a new Claude Code session. The memory system is now active.

That's it. Three steps, under 5 minutes.

## What Gets Installed

```
~/.claude/
├── rules/                    # L1: Project-specific rules (examples included)
│   ├── example-web-scraper.md
│   ├── example-docker.md
│   └── example-playwright.md
│
├── memory/                   # L2: Persistent memory
│   ├── MEMORY.md             # Main memory index (edit this!)
│   ├── crossmem.md           # Cross-project observations
│   ├── facts/                # Structured project facts
│   │   └── example-project.json
│   └── methodology/          # Reasoning frameworks
│       └── methodology.md
│
├── claude-mem-settings.json  # L3: Config (optional)
└── settings.json             # Hooks config (optional)
```

## The Three Layers Explained

### L1 — Hot Layer: Project Rules

Rules files in `.claude/rules/` are automatically loaded based on the directory you're working in. They give Claude project-specific instructions that it follows without you having to repeat them.

**Example**: Your Docker project rule tells Claude to always use `python3` inside containers, to use Docker Compose service names instead of `localhost`, and to never hardcode secrets.

```markdown
# Docker Project Rules
- Inside containers, use `python3` and `pip3` explicitly
- Use Docker Compose service names for inter-container communication
- Never hardcode secrets in Dockerfiles — use .env files
```

See [templates/rules/](templates/rules/) for complete examples.

### L2 — Warm Layer: Core Memory

`MEMORY.md` is loaded at the start of every session. It contains:
- Your core principles and preferences
- Model configuration (which models for which tasks)
- Quick reference for paths, endpoints, and configs
- Instructions for Claude on how to use the memory system

`crossmem.md` stores observations that apply across projects — debugging insights, tool preferences, gotchas you've encountered.

`facts/` contains structured JSON files with verified facts about each project (database type, auth method, deployment setup, etc.).

### L3 — Store Layer: Deep Memory (Optional)

The optional `claude-mem` plugin provides:
- **SQLite storage** for all observations
- **Chroma vector database** for semantic search
- **Auto-capture** of important observations via hooks
- **On-demand retrieval** — search past sessions by meaning, not just keywords

## Methodology

claude-trinity includes a unique [dialectical methodology](methodology/methodology.md) that provides mental models for:

- **Investigation-first debugging** — No guessing; read code, check logs, understand context before proposing fixes
- **Principal contradiction analysis** — Find the root cause that, when fixed, resolves cascading failures
- **Practice-theory cycles** — Theory guides, but running the code is what validates

These aren't abstract philosophy — they're practical engineering frameworks distilled from real-world debugging sessions.

## Customization

### Writing Your Own Rules

Create a `.md` file in `~/.claude/rules/` or in your project's `.claude/rules/` directory:

```markdown
# My Project Rules
- Always use TypeScript strict mode
- Database queries must use parameterized statements
- Log all API errors with request ID
```

Rules support path-based triggers — see [docs/customization.md](docs/customization.md) for details.

### Adding Project Facts

Create a JSON file in `~/.claude/memory/facts/`:

```json
{
  "facts": [
    {
      "id": "fact-001",
      "category": "infrastructure",
      "key": "database",
      "value": "PostgreSQL 15",
      "confidence": "verified",
      "source": "docker-compose.yml",
      "created": "2025-01-15",
      "superseded_by": null
    }
  ]
}
```

The `superseded_by` field lets you track how facts change over time without losing history.

## Comparison

| Feature | claude-trinity | Vanilla Claude Code | Codex CLI | OpenCode |
|---------|---------------|-------------------|-----------|----------|
| Persistent memory | ✅ Three layers | ❌ | ❌ | ❌ |
| Auto-loaded rules | ✅ Path-aware | ✅ CLAUDE.md only | ❌ | ❌ |
| Cross-project memory | ✅ crossmem.md | ❌ | ❌ | ❌ |
| Structured facts | ✅ JSON + superseded | ❌ | ❌ | ❌ |
| Semantic search | ✅ via claude-mem | ❌ | ❌ | ❌ |
| Methodology framework | ✅ Dialectical | ❌ | ❌ | ❌ |
| Setup time | ~5 min | N/A | ~10 min | ~15 min |
| Requires API key | ❌ Free | ❌ | ✅ | ✅ |

## Documentation

- [Architecture Deep Dive](docs/architecture.md) — How the three layers work together
- [Comparison Table](docs/comparison.md) — Detailed feature comparison
- [Customization Guide](docs/customization.md) — Write your own rules and hooks
- [FAQ](docs/faq.md) — Common questions and answers

## Contributing

Contributions are welcome! Areas where help is appreciated:

- **New rule templates** — Share useful project rules (scraping, ML, mobile dev, etc.)
- **Methodology extensions** — Additional reasoning frameworks
- **Platform testing** — Testing on different OS/shell combinations
- **Documentation** — Translations, tutorials, examples

Please open an issue first to discuss significant changes.

## License

[MIT](LICENSE)

## Acknowledgments

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) by Anthropic
- [claude-mem](https://github.com/thedotmack/claude-mem) for the L3 storage layer
- The dialectical methodology draws from Mao Zedong's philosophical essays (1930s–1940s), applied here purely as engineering reasoning frameworks
