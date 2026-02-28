# Release Checklist

Use this checklist before tagging a release.

## 1. Automated Gates (required)

- All jobs in `.github/workflows/install-smoke.yml` are green on `master`.
- Unix smoke tests pass on Ubuntu and macOS.
- Windows smoke test passes and runs `scripts/verify-hooks.ps1`.

## 2. Manual Gates (required)

### 2.1 Real Claude Code Session Trigger

Run one real, fresh Claude Code session and confirm:

1. `SessionStart` hook runs.
2. `~/.claude/memory/crossmem.md` content is visible to Claude at session start.
3. No hook parse errors appear on your OS shell.

### 2.2 Existing Settings Merge Path

Confirm installer behavior with an existing `~/.claude/settings.json`:

1. Installer does not overwrite existing settings.
2. `settings-hooks-template.json` is generated.
3. Template content matches platform (`settings-hooks.unix.json` or `settings-hooks.windows.json`).

### 2.3 Optional L3 Path

Confirm docs still point users to the official `claude-mem` install page:

- <https://github.com/thedotmack/claude-mem#installation>

## 3. Security Review (required)

- Verify users are prompted before running `curl -fsSL https://bun.sh/install | bash`.
- Keep a manual installation fallback in docs for users who disallow remote script execution.
- Re-check any new hook command for shell injection risk before release.

## 4. Release Packaging

1. Update docs for any behavior change.
2. Create tag and GitHub Release notes with:
   - Supported OS list
   - Known limitations
   - Upgrade notes from previous versions
