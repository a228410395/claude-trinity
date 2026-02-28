#!/usr/bin/env bash
# claude-trinity installer
# Supports: macOS, Linux, WSL, Git Bash on Windows
# Usage: bash install.sh [--skip-claude-mem] [--skip-hooks] [--yes]

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

# ── Globals ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKIP_CLAUDE_MEM=false
SKIP_HOOKS=false
AUTO_YES=false
INSTALLED=()
SKIPPED=()

# ── Parse Args ──────────────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --skip-claude-mem) SKIP_CLAUDE_MEM=true ;;
    --skip-hooks)      SKIP_HOOKS=true ;;
    --yes|-y)          AUTO_YES=true ;;
    --help|-h)
      echo "Usage: bash install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --skip-claude-mem   Skip claude-mem (L3) installation"
      echo "  --skip-hooks        Skip hooks configuration"
      echo "  --yes, -y           Auto-accept all prompts"
      echo "  --help, -h          Show this help"
      exit 0
      ;;
    *) echo -e "${RED}Unknown option: $arg${NC}"; exit 1 ;;
  esac
done

# ── Helpers ─────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; }

confirm() {
  if $AUTO_YES; then return 0; fi
  local prompt="$1 [y/N] "
  read -rp "$prompt" answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

check_command() {
  command -v "$1" &>/dev/null
}

safe_copy() {
  local src="$1" dest="$2"
  if [[ -f "$dest" ]]; then
    warn "File already exists: $dest (skipping)"
    SKIPPED+=("$dest")
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  INSTALLED+=("$dest")
  success "Installed: $dest"
}

# ── Banner ──────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║        claude-trinity installer              ║${NC}"
echo -e "${CYAN}║   Three-Layer Memory System for Claude Code  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ── Step 1: Environment Check ──────────────────────────────────────
info "Step 1/6: Checking environment..."

OS="unknown"
case "$(uname -s)" in
  Linux*)   OS="linux" ;;
  Darwin*)  OS="macos" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows-bash" ;;
esac

if [[ "$OS" == "unknown" ]]; then
  error "Unsupported OS: $(uname -s)"
  exit 1
fi
success "OS detected: $OS"

# Check Git
if check_command git; then
  success "Git found: $(git --version | head -1)"
else
  error "Git is required but not found. Please install Git first."
  exit 1
fi

# Check Node.js (needed for claude-mem)
if check_command node; then
  NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
  if [[ "$NODE_VERSION" -ge 18 ]]; then
    success "Node.js found: $(node -v)"
  else
    warn "Node.js $(node -v) found but v18+ recommended for claude-mem"
  fi
else
  warn "Node.js not found. claude-mem (L3) requires Node.js >= 18"
  if ! $SKIP_CLAUDE_MEM; then
    warn "Will skip claude-mem installation. Use --skip-claude-mem to suppress this warning."
    SKIP_CLAUDE_MEM=true
  fi
fi

# Check Claude Code
if check_command claude; then
  success "Claude Code found: $(claude --version 2>/dev/null || echo 'version unknown')"
else
  warn "Claude Code CLI not detected in PATH. Install from: https://docs.anthropic.com/en/docs/claude-code"
  warn "Continuing anyway — files will be placed in ~/.claude/"
fi

echo ""

# ── Step 2: Create Directory Structure ─────────────────────────────
info "Step 2/6: Creating directory structure..."

mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/memory/facts"
success "Directory structure ready"

echo ""

# ── Step 3: Install L1 — Rule Templates ────────────────────────────
info "Step 3/6: Installing L1 (Hot Layer) — Rule templates..."
info "Rules are project-specific. Copying examples to ~/.claude/rules/"

for rule_file in "$SCRIPT_DIR"/templates/rules/*.md; do
  if [[ -f "$rule_file" ]]; then
    filename=$(basename "$rule_file")
    safe_copy "$rule_file" "$CLAUDE_DIR/rules/$filename"
  fi
done

echo ""

# ── Step 4: Install L2 — Memory Templates ──────────────────────────
info "Step 4/6: Installing L2 (Warm Layer) — Memory templates..."

safe_copy "$SCRIPT_DIR/templates/memory/MEMORY.md" "$CLAUDE_DIR/memory/MEMORY.md"
safe_copy "$SCRIPT_DIR/templates/memory/crossmem.md" "$CLAUDE_DIR/memory/crossmem.md"

for fact_file in "$SCRIPT_DIR"/templates/memory/facts/*.json; do
  if [[ -f "$fact_file" ]]; then
    filename=$(basename "$fact_file")
    safe_copy "$fact_file" "$CLAUDE_DIR/memory/facts/$filename"
  fi
done

# Copy methodology
mkdir -p "$CLAUDE_DIR/memory/methodology"
if [[ -f "$SCRIPT_DIR/methodology/methodology.md" ]]; then
  safe_copy "$SCRIPT_DIR/methodology/methodology.md" "$CLAUDE_DIR/memory/methodology/methodology.md"
fi

echo ""

# ── Step 5: Install L3 — claude-mem (Optional) ─────────────────────
if $SKIP_CLAUDE_MEM; then
  info "Step 5/6: Skipping claude-mem (L3) installation (--skip-claude-mem)"
  SKIPPED+=("claude-mem")
else
  info "Step 5/6: Installing claude-mem (L3 Store Layer)..."

  if confirm "Install claude-mem plugin? (Requires Bun or npm)"; then
    # Check for Bun
    if ! check_command bun; then
      info "Bun not found. Attempting to install..."
      if confirm "Install Bun (JavaScript runtime)? Needed for claude-mem"; then
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
        if check_command bun; then
          success "Bun installed successfully"
        else
          warn "Bun installation may require restarting your shell"
          warn "Skipping claude-mem for now. Run install.sh again after restarting."
          SKIP_CLAUDE_MEM=true
        fi
      else
        warn "Skipping Bun and claude-mem installation"
        SKIP_CLAUDE_MEM=true
      fi
    fi

    if ! $SKIP_CLAUDE_MEM; then
      # Copy claude-mem config
      safe_copy "$SCRIPT_DIR/templates/claude-mem-settings.json" "$CLAUDE_DIR/claude-mem-settings.json"

      info "To complete claude-mem setup, run:"
      echo "  claude mcp add claude-mem -- npx -y @anthropic-ai/claude-code-mcp-server"
      echo ""
      info "Or install manually from: https://github.com/thedotmack/claude-mem"
      INSTALLED+=("claude-mem-config")
    fi
  else
    info "Skipping claude-mem installation"
    SKIPPED+=("claude-mem")
  fi
fi

echo ""

# ── Step 6: Configure Hooks (Optional) ─────────────────────────────
if $SKIP_HOOKS; then
  info "Step 6/6: Skipping hooks configuration (--skip-hooks)"
  SKIPPED+=("hooks")
else
  info "Step 6/6: Configuring hooks..."

  SETTINGS_FILE="$CLAUDE_DIR/settings.json"

  if [[ -f "$SETTINGS_FILE" ]]; then
    warn "Existing settings.json found at $SETTINGS_FILE"
    info "Hook template saved to: $CLAUDE_DIR/settings-hooks-template.json"
    info "Please merge manually to avoid overwriting your existing configuration."
    safe_copy "$SCRIPT_DIR/templates/settings-hooks.json" "$CLAUDE_DIR/settings-hooks-template.json"
  else
    if confirm "Create hooks configuration? (SessionStart will auto-load crossmem.md)"; then
      safe_copy "$SCRIPT_DIR/templates/settings-hooks.json" "$SETTINGS_FILE"
    else
      info "Skipping hooks configuration"
      SKIPPED+=("hooks")
    fi
  fi
fi

echo ""

# ── Summary ─────────────────────────────────────────────────────────
echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Installation Summary${NC}"
echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo ""

if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo -e "${GREEN}Installed (${#INSTALLED[@]} items):${NC}"
  for item in "${INSTALLED[@]}"; do
    echo "  ✓ $item"
  done
  echo ""
fi

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo -e "${YELLOW}Skipped (${#SKIPPED[@]} items):${NC}"
  for item in "${SKIPPED[@]}"; do
    echo "  ○ $item"
  done
  echo ""
fi

echo -e "${GREEN}Next steps:${NC}"
echo "  1. Edit ~/.claude/memory/MEMORY.md with your preferences"
echo "  2. Add project-specific rules to ~/.claude/rules/"
echo "  3. Restart Claude Code to activate the memory system"
echo ""
echo "  Read the docs: https://github.com/anthropics/claude-trinity"
echo ""
echo -e "${GREEN}Done!${NC} Three-layer memory system is ready."
echo ""
