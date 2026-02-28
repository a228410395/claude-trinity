# claude-trinity installer for Windows PowerShell
# Usage: .\install.ps1 [-SkipClaudeMem] [-SkipHooks] [-Yes]

param(
    [switch]$SkipClaudeMem,
    [switch]$SkipHooks,
    [switch]$Yes,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# ── Globals ─────────────────────────────────────────────────────────
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$Installed = @()
$Skipped = @()

# ── Helpers ─────────────────────────────────────────────────────────
function Write-Info    { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Ok      { param($msg) Write-Host "[OK]   $msg" -ForegroundColor Green }
function Write-Warn    { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err     { param($msg) Write-Host "[ERR]  $msg" -ForegroundColor Red }

function Confirm-Action {
    param($Prompt)
    if ($Yes) { return $true }
    $answer = Read-Host "$Prompt [y/N]"
    return $answer -match '^[Yy]$'
}

function Test-Command {
    param($Name)
    $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Copy-SafeFile {
    param($Source, $Dest)
    if (Test-Path $Dest) {
        Write-Warn "File already exists: $Dest (skipping)"
        $script:Skipped += $Dest
        return
    }
    $destDir = Split-Path -Parent $Dest
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Copy-Item $Source $Dest
    $script:Installed += $Dest
    Write-Ok "Installed: $Dest"
}

# ── Help ────────────────────────────────────────────────────────────
if ($Help) {
    Write-Host @"
Usage: .\install.ps1 [OPTIONS]

Options:
  -SkipClaudeMem   Skip claude-mem (L3) installation
  -SkipHooks       Skip hooks configuration
  -Yes             Auto-accept all prompts
  -Help            Show this help
"@
    exit 0
}

# ── Banner ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "        claude-trinity installer                " -ForegroundColor Cyan
Write-Host "   Three-Layer Memory System for Claude Code    " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Environment Check ──────────────────────────────────────
Write-Info "Step 1/6: Checking environment..."

$psVersion = $PSVersionTable.PSVersion
Write-Ok "PowerShell $psVersion on Windows"

if (Test-Command "git") {
    Write-Ok "Git found: $(git --version)"
} else {
    Write-Err "Git is required but not found. Please install Git first."
    exit 1
}

if (Test-Command "node") {
    $nodeVer = (node -v).TrimStart('v').Split('.')[0]
    if ([int]$nodeVer -ge 18) {
        Write-Ok "Node.js found: $(node -v)"
    } else {
        Write-Warn "Node.js $(node -v) found but v18+ recommended for claude-mem"
    }
} else {
    Write-Warn "Node.js not found. claude-mem (L3) requires Node.js >= 18"
    if (-not $SkipClaudeMem) {
        Write-Warn "Will skip claude-mem installation."
        $SkipClaudeMem = $true
    }
}

if (Test-Command "claude") {
    Write-Ok "Claude Code found"
} else {
    Write-Warn "Claude Code CLI not detected in PATH."
    Write-Warn "Install from: https://docs.anthropic.com/en/docs/claude-code"
}

Write-Host ""

# ── Step 2: Create Directory Structure ─────────────────────────────
Write-Info "Step 2/6: Creating directory structure..."

$dirs = @(
    (Join-Path $ClaudeDir "rules"),
    (Join-Path $ClaudeDir "memory\facts")
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}
Write-Ok "Directory structure ready"
Write-Host ""

# ── Step 3: Install L1 — Rule Templates ────────────────────────────
Write-Info "Step 3/6: Installing L1 (Hot Layer) - Rule templates..."

$rulesDir = Join-Path $ScriptDir "templates\rules"
if (Test-Path $rulesDir) {
    Get-ChildItem "$rulesDir\*.md" | ForEach-Object {
        Copy-SafeFile $_.FullName (Join-Path $ClaudeDir "rules\$($_.Name)")
    }
}
Write-Host ""

# ── Step 4: Install L2 — Memory Templates ──────────────────────────
Write-Info "Step 4/6: Installing L2 (Warm Layer) - Memory templates..."

Copy-SafeFile (Join-Path $ScriptDir "templates\memory\MEMORY.md") (Join-Path $ClaudeDir "memory\MEMORY.md")
Copy-SafeFile (Join-Path $ScriptDir "templates\memory\crossmem.md") (Join-Path $ClaudeDir "memory\crossmem.md")

$factsDir = Join-Path $ScriptDir "templates\memory\facts"
if (Test-Path $factsDir) {
    Get-ChildItem "$factsDir\*.json" | ForEach-Object {
        Copy-SafeFile $_.FullName (Join-Path $ClaudeDir "memory\facts\$($_.Name)")
    }
}

# Copy methodology
$methodDir = Join-Path $ClaudeDir "memory\methodology"
if (-not (Test-Path $methodDir)) {
    New-Item -ItemType Directory -Path $methodDir -Force | Out-Null
}
$methodSrc = Join-Path $ScriptDir "methodology\methodology.md"
if (Test-Path $methodSrc) {
    Copy-SafeFile $methodSrc (Join-Path $methodDir "methodology.md")
}
Write-Host ""

# ── Step 5: Install L3 — claude-mem (Optional) ─────────────────────
if ($SkipClaudeMem) {
    Write-Info "Step 5/6: Skipping claude-mem (L3) installation"
    $Skipped += "claude-mem"
} else {
    Write-Info "Step 5/6: Installing claude-mem (L3 Store Layer)..."

    if (Confirm-Action "Install claude-mem plugin?") {
        Copy-SafeFile (Join-Path $ScriptDir "templates\claude-mem-settings.json") (Join-Path $ClaudeDir "claude-mem-settings.json")

        Write-Info "To complete claude-mem setup, see:"
        Write-Host '  https://github.com/thedotmack/claude-mem#installation'
        Write-Host ""
        Write-Info "Follow the official README for the correct MCP registration command."
    } else {
        Write-Info "Skipping claude-mem"
        $Skipped += "claude-mem"
    }
}
Write-Host ""

# ── Step 6: Configure Hooks (Optional) ─────────────────────────────
if ($SkipHooks) {
    Write-Info "Step 6/6: Skipping hooks configuration"
    $Skipped += "hooks"
} else {
    Write-Info "Step 6/6: Configuring hooks..."

    $settingsFile = Join-Path $ClaudeDir "settings.json"

    if (Test-Path $settingsFile) {
        Write-Warn "Existing settings.json found at $settingsFile"
        Write-Info "Hook template saved separately. Please merge manually."
        Copy-SafeFile (Join-Path $ScriptDir "templates\settings-hooks.windows.json") (Join-Path $ClaudeDir "settings-hooks-template.json")
    } else {
        if (Confirm-Action "Create hooks configuration?") {
            Copy-SafeFile (Join-Path $ScriptDir "templates\settings-hooks.windows.json") $settingsFile
        } else {
            $Skipped += "hooks"
        }
    }
}
Write-Host ""

# ── Summary ─────────────────────────────────────────────────────────
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Installation Summary" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($Installed.Count -gt 0) {
    Write-Host "Installed ($($Installed.Count) items):" -ForegroundColor Green
    foreach ($item in $Installed) {
        Write-Host "  + $item"
    }
    Write-Host ""
}

if ($Skipped.Count -gt 0) {
    Write-Host "Skipped ($($Skipped.Count) items):" -ForegroundColor Yellow
    foreach ($item in $Skipped) {
        Write-Host "  o $item"
    }
    Write-Host ""
}

Write-Host "Next steps:" -ForegroundColor Green
Write-Host "  1. Edit ~/.claude/memory/MEMORY.md with your preferences"
Write-Host "  2. Add project-specific rules to ~/.claude/rules/"
Write-Host "  3. Restart Claude Code to activate the memory system"
Write-Host ""
Write-Host "  Read the docs: https://github.com/a228410395/claude-trinity"
Write-Host ""
Write-Host "Done! Three-layer memory system is ready." -ForegroundColor Green
Write-Host ""
