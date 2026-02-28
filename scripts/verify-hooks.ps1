# Verifies the Windows SessionStart hook end-to-end in an isolated profile.
# Usage: .\scripts\verify-hooks.ps1 [-RepoRoot <path>] [-KeepArtifacts]

param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$KeepArtifacts
)

$ErrorActionPreference = "Stop"

$templatePath = Join-Path $RepoRoot "templates\settings-hooks.windows.json"
if (-not (Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
}

$profileRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("claude-trinity-hook-e2e-" + [Guid]::NewGuid().ToString("N"))
$claudeDir = Join-Path $profileRoot ".claude"
$memoryDir = Join-Path $claudeDir "memory"
$settingsPath = Join-Path $claudeDir "settings.json"
$crossmemPath = Join-Path $memoryDir "crossmem.md"
$originalUserProfile = $env:USERPROFILE

New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null
Copy-Item -Path $templatePath -Destination $settingsPath -Force

$json = Get-Content -Raw $settingsPath | ConvertFrom-Json
$hookCommand = $json.hooks.SessionStart[0].command
if ([string]::IsNullOrWhiteSpace($hookCommand)) {
    throw "SessionStart hook command is empty."
}

$sentinel = "E2E_FULL_CHAIN_{0}" -f ([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
Set-Content -Path $crossmemPath -Value $sentinel -Encoding UTF8

function Invoke-HookCommand {
    param([string]$Command)

    $output = cmd.exe /c $Command 2>&1
    $exitCode = $LASTEXITCODE
    return [PSCustomObject]@{
        Output = ($output -join [Environment]::NewLine)
        ExitCode = $exitCode
    }
}

try {
    $env:USERPROFILE = $profileRoot

    $firstRun = Invoke-HookCommand -Command $hookCommand
    if ($firstRun.ExitCode -ne 0) {
        throw "SessionStart hook returned exit code $($firstRun.ExitCode). Output: $($firstRun.Output)"
    }
    if ($firstRun.Output -notmatch [Regex]::Escape($sentinel)) {
        throw "SessionStart hook output did not include sentinel. Output: $($firstRun.Output)"
    }

    Remove-Item -Path $crossmemPath -Force

    $secondRun = Invoke-HookCommand -Command $hookCommand
    if ($secondRun.ExitCode -ne 0) {
        throw "SessionStart hook returned exit code $($secondRun.ExitCode) when crossmem.md was missing."
    }
    if (-not [string]::IsNullOrWhiteSpace($secondRun.Output)) {
        throw "Expected empty output when crossmem.md is missing. Output: $($secondRun.Output)"
    }

    Write-Host "PASS: SessionStart hook works with existing and missing crossmem.md in isolated profile."
    Write-Host "Profile root: $profileRoot"
}
finally {
    $env:USERPROFILE = $originalUserProfile
    if (-not $KeepArtifacts -and (Test-Path $profileRoot)) {
        Remove-Item -Path $profileRoot -Recurse -Force
    }
}
