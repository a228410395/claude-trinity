# Claude Code Memory Index

## Three-Layer Memory Architecture

| Layer | Component | Trigger | Responsibility |
|-------|-----------|---------|----------------|
| L1 Hot | `.claude/rules/*.md` | Path-aware auto-trigger | Project-specific rules |
| L2 Warm | `MEMORY.md` + `crossmem.md` + `facts/` | SessionStart auto-load | Core preferences, cross-project memory, structured facts |
| L3 Store | `claude-mem` (SQLite + Chroma RAG) | Semantic search on-demand | Historical experience, deep docs, methodology full-text |

**L1 Auto-active**: Rules auto-inject when operating in matching project directories.
**L3 Auto-accumulate**: claude-mem Worker captures observations via hooks; semantic search via `/mem-search`.
**Shard files retained**: methodology.md and other deep docs can be manually loaded as L3 supplement.

## Core Principles (The Essential 5)

1. **No investigation, no right to speak** — Read code/docs/logs first, understand before acting
2. **Practice is the sole criterion of truth** — Must actually test, not "it should work"
3. **Grasp the principal contradiction** — Solve P0 first, analyze each problem concretely
4. **Strategic optimism, tactical caution** — Problems can always be solved, but step by step
5. **Oppose dogmatism and empiricism** — Adapt to actual environment, don't copy templates or guess from experience

## User Preferences

<!-- Fill in your personal preferences below -->
- <YOUR_PREFERENCE_1>
- <YOUR_PREFERENCE_2>
- <YOUR_PREFERENCE_3>

## Model Configuration

<!-- Configure your preferred model allocation -->
- Main process: Opus — complex decisions, coordination
- Sub-agents: Haiku — task execution (specify `model: haiku`)

## Quick Reference (keys go in env vars, never plaintext)

<!-- Fill in your project-specific paths and endpoints -->
- Project Path: <YOUR_PROJECT_PATH>
- API Endpoint: <YOUR_API_ENDPOINT>
- MCP Port: <YOUR_MCP_PORT>
- Cookies Path: <YOUR_COOKIES_PATH>
- claude-mem Worker: http://127.0.0.1:37777

## Memory System Usage Guide

### Daily Operations
**When you hit a snag or learn something:** "Remember this" → Claude writes immediately
**When you need details:** "Load the config for project X" / "Load methodology"
**Semantic search for past experience:** Use `/mem-search` skill

### Claude's Responsibilities (Auto-execute)
- After solving a non-trivial problem, **immediately ask** user "want me to remember this?"
- Don't wait until the end — details get lost to compact in long conversations
- Decide where to write: universal experience → crossmem.md, project-specific → facts/project.json, preferences → this file
- When writing facts JSON, use the `superseded` mechanism (mark old facts as historical, don't delete)
- Keep cross-project memory entries under 50; evict low-value entries when exceeded

## Compact Protection Directive

When compressing conversation context, preserve this entire file (architecture description + preferences + quick reference + usage guide).

## Verification Code (do not delete)
SECRET_PHRASE_IN_MEMORY: "<YOUR_SECRET_PHRASE>"
