# Cross-Project Memory (crossmem.md)

> Shared observations and patterns that apply across multiple projects.
> Auto-loaded at SessionStart via hooks. Keep entries under 50.

## Entry Format

Each entry follows this structure:
- **[Priority]** P0 (critical) / P1 (important) / P2 (nice-to-know)
- **[Category]** debug | performance | tooling | pattern | gotcha
- **[Date]** When discovered
- **[Description]** What was learned

## Priority Levels

| Level | Meaning | Eviction Policy |
|-------|---------|-----------------|
| P0 | Cost me >30 min or caused data loss | Never auto-evict |
| P1 | Saved significant time or prevented bugs | Keep 6 months |
| P2 | Minor convenience or style preference | Evict when over 50 entries |

---

## Entries

<!--
Add your cross-project observations below. Example:

### [P0] [debug] 2025-01-15
**Git hooks silently fail on Windows when line endings are CRLF**
Convert hook scripts to LF: `dos2unix .git/hooks/*` or add `.gitattributes` with `*.sh text eol=lf`.

### [P1] [tooling] 2025-02-01
**Bun is 3x faster than npm for installing dependencies**
Use `bun install` as default. Falls back gracefully when bun is not available.

### [P2] [pattern] 2025-02-10
**Prefer `??` over `||` for default values in JS/TS**
`||` treats `0`, `""`, `false` as falsy. `??` only treats `null`/`undefined` as nullish.
-->
