# Customization Guide

## Writing Your Own Rules (L1)

### Rule File Basics

Rules are Markdown files placed in `.claude/rules/` directories. Claude Code automatically loads them based on your working directory.

**Two levels of rules:**

```
~/.claude/rules/          ← Global rules (all projects)
<project>/.claude/rules/  ← Project rules (one project only)
```

### Rule File Structure

A good rule file follows this pattern:

```markdown
# [Domain] Rules

> One-line description of when these rules apply.

## [Category 1]

- Specific, actionable instruction
- Another instruction with rationale
- Instruction with example: `code example here`

## [Category 2]

- More instructions...
```

### Tips for Effective Rules

**Be specific, not vague:**
```markdown
# Bad
- Write good code
- Handle errors properly

# Good
- Use parameterized queries for all SQL — never string concatenation
- Wrap all database calls in try/catch; log the error with request ID before re-throwing
```

**Include the "why" when it's not obvious:**
```markdown
# Bad
- Always use python3 inside containers

# Good
- Inside containers, use `python3` explicitly — Alpine/Debian images may have
  python2 as the default `python` binary
```

**Give concrete examples:**
```markdown
# Bad
- Use proper error responses

# Good
- API errors must return: { "error": "<message>", "code": "<ERROR_CODE>", "requestId": "<uuid>" }
```

### Example: Creating a Rule for a Next.js Project

Create `~/.claude/rules/nextjs.md` or `<project>/.claude/rules/nextjs.md`:

```markdown
# Next.js Project Rules

## Routing
- Use App Router (app/) not Pages Router (pages/)
- All API routes go in app/api/ with route.ts files
- Use server components by default; add 'use client' only when needed

## Data Fetching
- Prefer Server Components with direct database/API calls over client-side fetching
- Use React Server Actions for mutations, not API routes
- Cache aggressively: use `unstable_cache` or `fetch` with `next: { revalidate: 3600 }`

## Styling
- Use Tailwind CSS classes, not CSS modules or styled-components
- Responsive design: mobile-first with sm/md/lg breakpoints
- Dark mode: use `dark:` prefix, not manual theme switching

## Performance
- Images: always use next/image with width/height specified
- Fonts: use next/font/google, not external CDN links
- Lazy load below-fold components with dynamic() imports
```

## Configuring Hooks

### What Are Hooks?

Hooks are shell commands that Claude Code executes in response to events. claude-trinity uses hooks to auto-load cross-project memory at session start.

### Hook Configuration

Hooks are configured in `~/.claude/settings.json`:

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

### Available Hook Events

| Event | When It Fires | Common Use |
|-------|--------------|------------|
| `SessionStart` | New Claude Code session begins | Load memory, set context |
| `PreToolUse` | Before Claude uses a tool | Validate, gate-keep |
| `PostToolUse` | After Claude uses a tool | Log, notify |
| `Notification` | Claude sends a notification | Forward to Telegram/Slack |

### Example: Telegram Notifications

Get notified when Claude finishes a long-running task:

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

Replace `<TOKEN>` with your Telegram bot token (from @BotFather) and `<CHAT_ID>` with your chat ID.

## Customizing L2 Memory

### MEMORY.md

Edit `~/.claude/memory/MEMORY.md` to add:

1. **Your preferences**: Communication style, tool choices, coding conventions
2. **Model config**: Which models for which tasks
3. **Quick reference**: Project paths, API endpoints, important configs
4. **Secret phrase**: A canary value to detect context leaks

### crossmem.md

Add entries as you learn things:

```markdown
### [P0] [debug] 2025-03-15
**Node.js fetch() doesn't reject on HTTP errors**
Unlike axios, native fetch() resolves on 404/500. Always check `response.ok` before parsing.
```

Priority guidelines:
- **P0**: Cost you >30 minutes or caused data loss
- **P1**: Saved significant time or prevented a bug
- **P2**: Minor convenience or style note

### facts/*.json

Create one JSON file per project:

```bash
# Create a new facts file
cp ~/.claude/memory/facts/example-project.json ~/.claude/memory/facts/my-app.json
```

Edit it with your project's actual facts. Use the `superseded_by` field when facts change.

## Customizing L3 (claude-mem)

### Adjusting Capture Settings

Edit `~/.claude/claude-mem-settings.json`:

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

- `min_importance`: 0.0–1.0, lower = capture more (noisier), higher = capture less
- `categories`: Add your own categories for organization

### Adjusting Retrieval

```json
{
  "retrieval": {
    "max_results": 10,
    "similarity_threshold": 0.6,
    "rerank": true
  }
}
```

- `similarity_threshold`: Lower = more results (less relevant), higher = fewer (more relevant)
- `rerank`: Re-ranks results by relevance after initial retrieval (slower but better)
