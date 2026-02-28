# Frequently Asked Questions

## General

### What is claude-trinity?

A three-layer memory system for Claude Code that gives your AI assistant persistent memory across sessions. It remembers your preferences, project facts, debugging insights, and applies project-specific rules automatically.

### Does it work with other AI tools (Cursor, Copilot, etc.)?

No. claude-trinity is designed specifically for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Anthropic's CLI tool. The L1 rules and hooks system are Claude Code features. However, the methodology document and the general approach (structured memory files) could inspire similar setups for other tools.

### Is it free?

Yes. claude-trinity itself is MIT-licensed and free. It requires Claude Code, which has its own pricing — but claude-trinity adds no additional cost.

### Does it send my data anywhere?

No. All memory is stored locally in `~/.claude/`. The optional L3 layer (claude-mem) also stores data locally in SQLite and Chroma. Nothing is sent to external servers unless you explicitly configure hooks to do so (e.g., Telegram notifications).

## Installation

### The install script failed. What do I do?

1. Check that you have Git installed: `git --version`
2. Check that you have bash (macOS/Linux) or PowerShell (Windows)
3. Run with `bash -x install.sh` to see detailed output
4. If a specific step fails, you can skip it: `bash install.sh --skip-claude-mem --skip-hooks`
5. Open an issue with the error output

### Can I install manually without the script?

Yes. The script just copies files. You can manually:
1. Copy `templates/rules/*.md` to `~/.claude/rules/`
2. Copy `templates/memory/*` to `~/.claude/memory/`
3. Copy `methodology/methodology.md` to `~/.claude/memory/methodology/`
4. Optionally merge `templates/settings-hooks.json` into `~/.claude/settings.json`

### Will it overwrite my existing MEMORY.md?

No. The install script detects existing files and skips them. It will never overwrite your data.

### I already have a settings.json. Will hooks be added automatically?

No. If `~/.claude/settings.json` already exists, the installer saves the hooks template as `settings-hooks-template.json` and asks you to merge manually. This prevents accidentally overwriting your existing configuration.

## Usage

### How do I add a memory entry?

Just tell Claude: "Remember this" or "Write this down." Claude will ask for confirmation and write it to the appropriate file (crossmem.md for cross-project, facts/ for project-specific, MEMORY.md for preferences).

### How do I search past memories?

If L3 (claude-mem) is installed, use semantic search to find relevant past observations. Without L3, you can ask Claude to read specific memory files: "Load crossmem" or "Check facts for project X."

### My context is getting compressed and losing information. Why?

Claude Code compresses conversation context when it gets long. MEMORY.md includes a "Compact Protection Directive" that tells Claude to preserve the memory file during compression. However, conversation-specific details may still be lost. This is why the system encourages writing important observations to files immediately rather than waiting until the end of a session.

### How many rules can I have?

There's no hard limit, but each rule file consumes context window tokens. Practical guideline: keep it under 10 rule files with focused content. A single well-written rule file is better than many vague ones.

### What's the SECRET_PHRASE for?

It's a canary value. If Claude ever outputs your secret phrase in a response, it means context is leaking — the memory file was included in output when it shouldn't have been. Set it to something unique and never share it.

## L3 (claude-mem)

### Do I need L3?

No. L1 and L2 provide the core value — persistent rules, preferences, and structured facts. L3 adds semantic search over past observations, which is useful if you have many sessions and want to search by meaning rather than keywords. Many users find L1+L2 sufficient.

### claude-mem installation failed. Can I use the rest?

Yes. L3 is fully optional. Skip it with `--skip-claude-mem` and use L1+L2 normally.

### How much disk space does L3 use?

The SQLite database and Chroma vectors grow with usage. Typical size after months of use: 50-200 MB. The local embedding model (all-MiniLM-L6-v2) is ~80 MB.

## Methodology

### Why Mao Zedong's essays?

The three essays ("On Practice", "On Contradiction", "On Investigation") contain universally applicable reasoning frameworks that happen to map very well to software engineering:
- Investigation before action → read code before guessing
- Principal contradiction → find the root cause
- Practice-theory cycle → run code, observe, theorize, repeat

This is not a political statement. The methodology extracts the philosophical and logical frameworks, which stand on their own merit as engineering principles.

### Can I use a different methodology?

Absolutely. The methodology file is just a Markdown document. Replace it with your own reasoning framework, or remove it entirely. The three-layer memory system works independently of the methodology.

## Troubleshooting

### Claude doesn't seem to be loading my rules

1. Check that rule files are in `~/.claude/rules/` (global) or `<project>/.claude/rules/` (project)
2. Verify the files end in `.md`
3. Start a new Claude Code session (rules load at session start)
4. Ask Claude: "What rules are loaded?" to verify

### Claude forgot something I told it to remember

1. Check if the session was compressed (long conversations trigger compaction)
2. Verify the memory was actually written: read `~/.claude/memory/crossmem.md`
3. Important: tell Claude to "write it down now" rather than "remember for later"

### The hooks aren't firing

1. Verify `~/.claude/settings.json` has the correct hooks structure
2. Check that the hook command works when run manually in terminal
3. Restart Claude Code — hooks are loaded at session start
4. Check timeout — if a hook takes longer than its timeout, it's silently killed
