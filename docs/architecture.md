# Architecture Deep Dive

## Overview

claude-trinity implements a three-layer memory architecture for Claude Code. Each layer serves a distinct purpose and has a different trigger mechanism.

```
                    ┌─────────────────────────┐
                    │     Claude Code CLI      │
                    └──────────┬──────────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
              ▼                ▼                ▼
     ┌────────────────┐ ┌───────────────┐ ┌──────────────┐
     │   L1 HOT       │ │   L2 WARM     │ │   L3 STORE   │
     │                │ │               │ │              │
     │ .claude/rules/ │ │ MEMORY.md     │ │ claude-mem   │
     │ *.md files     │ │ crossmem.md   │ │ SQLite+RAG   │
     │                │ │ facts/*.json  │ │              │
     │ Trigger:       │ │ Trigger:      │ │ Trigger:     │
     │ Path match     │ │ SessionStart  │ │ Semantic     │
     │ (automatic)    │ │ (automatic)   │ │ query        │
     │                │ │               │ │ (on-demand)  │
     │ Latency: 0ms   │ │ Latency: <1s  │ │ Latency: ~2s │
     │ Capacity: ~10  │ │ Capacity: ~50 │ │ Capacity: ∞  │
     │ files          │ │ entries       │ │              │
     └────────────────┘ └───────────────┘ └──────────────┘
```

## L1 — Hot Layer: Project Rules

### How It Works

Claude Code natively supports `.claude/rules/` directories. When you open a session in a directory, Claude automatically loads any matching rule files.

Rules can be placed at two levels:
- **Global**: `~/.claude/rules/` — applies to all projects
- **Project**: `<project>/.claude/rules/` — applies only to that project

### Design Decisions

**Why Markdown?** Claude Code's native format. No preprocessing needed.

**Why path-based triggers?** Different projects have different conventions. A Docker project needs different rules than a React project. Path-based auto-loading means zero manual effort.

**Why example templates instead of real rules?** Real project rules contain business-specific information (platform names, internal APIs, team conventions). The templates demonstrate the *pattern* of effective rules while remaining universally applicable.

### Capacity Considerations

Each rule file adds to the context window. Keep individual files focused (one domain per file) and total rule files under ~10 to avoid consuming too much context.

## L2 — Warm Layer: Core Memory

### Components

#### MEMORY.md
The central index file. Loaded into every session via Claude Code's auto-memory feature. Contains:
- Architecture reference (so Claude knows how to use the system)
- Core principles (investigation-first, practice-validates-theory, etc.)
- User preferences (model config, tool preferences, communication style)
- Quick reference (paths, endpoints, API configs)
- Compact protection directive (tells Claude to preserve this file during context compression)

#### crossmem.md
Cross-project observations with priority levels:
- **P0**: Critical lessons (cost >30 min or caused data loss) — never auto-evict
- **P1**: Important patterns (saved significant time) — keep 6 months
- **P2**: Minor conveniences — evict when over 50 entries

Loaded at SessionStart via hooks.

#### facts/*.json
Structured project facts with versioning via `superseded_by`:
```json
{
  "id": "fact-001",
  "value": "PostgreSQL 15",
  "superseded_by": null    ← current
}
{
  "id": "fact-002",
  "value": "PostgreSQL 14",
  "superseded_by": "fact-001"  ← historical
}
```

### Design Decisions

**Why not just use CLAUDE.md?** CLAUDE.md is project-specific and version-controlled with the project. MEMORY.md is personal, persists across all projects, and contains information you don't want in Git (API paths, model preferences, personal workflow notes).

**Why the superseded mechanism?** Deleting old facts loses history. When debugging, knowing what *changed* is often more valuable than knowing what *is*. The superseded chain provides an audit trail.

**Why 50-entry limit on crossmem?** Context window budget. Each entry costs tokens. P0 entries are worth the cost; P2 entries aren't. The eviction policy keeps the total manageable.

## L3 — Store Layer: Deep Memory

### How It Works

The optional `claude-mem` plugin provides:
1. **Auto-capture**: Hooks observe Claude's tool usage and capture important observations
2. **Embedding**: Observations are embedded using a local model (all-MiniLM-L6-v2, no API key needed)
3. **Storage**: SQLite for structured data, Chroma for vector search
4. **Retrieval**: Semantic search returns relevant past observations

### When L3 Activates

L3 is on-demand only. It does NOT load into every session. Instead:
- User asks "have I seen this error before?" → semantic search against observation history
- Claude encounters a complex problem → proactively searches for related past experience
- User explicitly calls `/mem-search` → direct vector search

### Design Decisions

**Why optional?** L1 and L2 provide 80% of the value with zero dependencies. L3 adds the remaining 20% but requires Bun/Node.js and adds complexity. Users who want a simple setup can skip it entirely.

**Why local embeddings?** No API key required, no cost, no network dependency. The trade-off is lower embedding quality than OpenAI's models, but for code-related semantic search, MiniLM-L6 is sufficient.

**Why SQLite + Chroma instead of just one?** SQLite handles structured queries (date ranges, categories, exact matches). Chroma handles semantic similarity. Different access patterns need different storage engines.

## Data Flow

```
User starts Claude Code session
        │
        ├──→ L1: Auto-load rules for current directory
        ├──→ L2: Auto-load MEMORY.md (built-in)
        ├──→ L2: SessionStart hook loads crossmem.md
        │
        │   (Session in progress...)
        │
        ├──→ Claude solves a problem
        │    ├──→ Asks user "want me to remember this?"
        │    ├──→ If yes: writes to crossmem.md (P0/P1/P2)
        │    └──→ If L3 active: auto-captured to claude-mem
        │
        ├──→ Claude encounters a complex problem
        │    └──→ If L3 active: searches past observations
        │
        └──→ Session ends
             └──→ L3 observations persisted to SQLite/Chroma
```

## Security Considerations

- MEMORY.md and crossmem.md may contain project-specific information. Keep them in `~/.claude/` (not version-controlled) rather than in project directories.
- Never store API keys, tokens, or credentials in memory files. Use environment variables and reference them by name only.
- The `SECRET_PHRASE_IN_MEMORY` field is a canary — if Claude ever outputs it, you know context is leaking.
- facts/*.json should not contain sensitive data (passwords, tokens). Store only structural facts (database type, framework version, etc.).
