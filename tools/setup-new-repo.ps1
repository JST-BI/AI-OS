#Requires -Version 5.1
<#
.SYNOPSIS
  Set up a new SOSU repo with the versioned pre-commit hooks and Codex config.
.DESCRIPTION
  Copies .githooks/ from the AI OS repo (canonical source) into the target repo,
  ensures .gitattributes forces eol=lf on the hook files (so the shell shebang
  is not broken by CRLF on Windows checkout), writes .codex/config.toml from the
  canonical template, and runs 'git config core.hooksPath .githooks'.
  Idempotent - safe to re-run.

  The hooks block two things:
    1. Commits of Excel files (.xlsx/.xlsm/...) that contain personal data: CPR
       (DDMMYY-XXXX), e-mail addresses, or columns named
       navn/fornavn/efternavn/cpr/personnummer/mail. Clean Excel files are allowed.
    2. Commits of CLAUDE.md / CLAUDE.local.md / .claude/CLAUDE.md - AGENTS.md is the single,
       model-independent instruction file (Claude Code >= v2.1.277 and Codex read it
       directly); a CLAUDE.md variant makes Claude Code ignore AGENTS.md.
    3. Skill-mirror drift (.claude/skills vs .agents/skills; repos without skills are skipped).
.PARAMETER RepoPath
  Path to the target repo root (must already be a git repo, i.e. contain .git).
.EXAMPLE
  .\setup-new-repo.ps1 -RepoPath "<OneDrive>\AI SOSU\BI-NYTPROJEKT"
.NOTES
  After cloning the repo on another machine, the hook must be re-activated once:
      git config core.hooksPath .githooks
  Git does not run versioned hooks automatically (security).
#>
param(
  [Parameter(Mandatory = $true)][string]$RepoPath
)
$ErrorActionPreference = 'Stop'
$utf8 = [System.Text.UTF8Encoding]::new($false)   # UTF-8 without BOM

# AI OS root = parent of this script's tools\ folder; canonical hooks live in .githooks\
$aiOsRoot = Split-Path -Parent $PSScriptRoot
$src = Join-Path $aiOsRoot '.githooks'

if (-not (Test-Path (Join-Path $RepoPath '.git'))) { throw "Not a git repo (no .git): $RepoPath" }
if (-not (Test-Path $src)) { throw "Canonical hooks not found at: $src" }

# 1) Copy canonical hook files into the target repo
$dst = Join-Path $RepoPath '.githooks'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
foreach ($f in 'pre-commit', 'check_excel_pii.py', 'check_kun_agents_md.py', 'check_skills_mirror.py', 'README.md') {
  Copy-Item (Join-Path $src $f) (Join-Path $dst $f) -Force
}
# The pointer-file check was retired 2026-11-01 - remove a stale copy
Remove-Item (Join-Path $dst 'check_md_mirror.py') -ErrorAction SilentlyContinue
Write-Host "  .githooks/ copied"

# 2) Ensure .gitattributes forces LF on the hook files
$ga = Join-Path $RepoPath '.gitattributes'
$txt = if (Test-Path $ga) { [System.IO.File]::ReadAllText($ga, $utf8) } else { '' }
if ($txt -notmatch '\.githooks/pre-commit') {
  $txt = $txt.TrimEnd("`r", "`n")
  if ($txt.Length -gt 0) { $txt += "`n" }
  $txt += "# Git-hooks must always be LF (shell + python run via sh; CRLF breaks shebang)`n"
  $txt += ".githooks/pre-commit text eol=lf`n"
  $txt += ".githooks/check_excel_pii.py text eol=lf`n"
  $txt += ".githooks/check_kun_agents_md.py text eol=lf`n"
  $txt += ".githooks/check_skills_mirror.py text eol=lf`n"
  [System.IO.File]::WriteAllText($ga, $txt, $utf8)
  Write-Host "  .gitattributes: eol=lf rules added"
}
elseif ($txt -notmatch 'check_kun_agents_md\.py' -or $txt -notmatch 'check_skills_mirror\.py') {
  # Repo set up before these hooks existed - swap/add just the missing lines
  $txt = $txt -replace '(?m)^\.githooks/check_md_mirror\.py text eol=lf\r?\n?', ''
  $txt = $txt.TrimEnd("`r", "`n") + "`n"
  if ($txt -notmatch 'check_kun_agents_md\.py') { $txt += ".githooks/check_kun_agents_md.py text eol=lf`n" }
  if ($txt -notmatch 'check_skills_mirror\.py') { $txt += ".githooks/check_skills_mirror.py text eol=lf`n" }
  [System.IO.File]::WriteAllText($ga, $txt, $utf8)
  Write-Host "  .gitattributes: eol=lf rules updated for the hook checks"
}
else {
  Write-Host "  .gitattributes: eol=lf rules already present"
}

# 3) Codex project config (.codex/config.toml) from the canonical template.
#    Codex reads TOML from .codex/ (lowercase) only - Claude Code's JSON format
#    has no effect there. Raises project_doc_max_bytes so a large AGENTS.md is
#    not silently truncated at the 65536-byte default.
$codexTpl = Join-Path $PSScriptRoot 'codex-config.template.toml'
if (Test-Path $codexTpl) {
  $codexDir = Join-Path $RepoPath '.codex'
  New-Item -ItemType Directory -Force -Path $codexDir | Out-Null
  Copy-Item $codexTpl (Join-Path $codexDir 'config.toml') -Force
  Write-Host "  .codex/config.toml written"
}
else {
  Write-Warning "  codex-config.template.toml not found at $codexTpl - skipped"
}

# 4) Activate the versioned hooks for this clone
& git -C $RepoPath config core.hooksPath .githooks
Write-Host "OK: hooks installed (Excel-PII + AGENTS.md-only + skills mirror) + core.hooksPath set for: $RepoPath"
Write-Host "    Remember to commit .githooks/, .gitattributes and .codex/."
