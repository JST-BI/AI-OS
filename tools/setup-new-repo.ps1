#Requires -Version 5.1
<#
.SYNOPSIS
  Set up a new SOSU repo with the versioned Excel-PII pre-commit hook.
.DESCRIPTION
  Copies .githooks/ from the AI OS repo (canonical source) into the target repo,
  ensures .gitattributes forces eol=lf on the hook files (so the shell shebang
  is not broken by CRLF on Windows checkout), and runs
  'git config core.hooksPath .githooks'. Idempotent - safe to re-run.

  The hook blocks commits of Excel files (.xlsx/.xlsm/...) that contain personal
  data: CPR (DDMMYY-XXXX), e-mail addresses, or columns named
  navn/fornavn/efternavn/cpr/personnummer/mail. Clean Excel files are allowed.
.PARAMETER RepoPath
  Path to the target repo root (must already be a git repo, i.e. contain .git).
.EXAMPLE
  .\setup-new-repo.ps1 -RepoPath "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI-SOSU\BI-NYTPROJEKT"
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
foreach ($f in 'pre-commit', 'check_excel_pii.py', 'README.md') {
  Copy-Item (Join-Path $src $f) (Join-Path $dst $f) -Force
}
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
  [System.IO.File]::WriteAllText($ga, $txt, $utf8)
  Write-Host "  .gitattributes: eol=lf rules added"
}
else {
  Write-Host "  .gitattributes: eol=lf rules already present"
}

# 3) Activate the versioned hooks for this clone
& git -C $RepoPath config core.hooksPath .githooks
Write-Host "OK: Excel-PII hook installed + core.hooksPath set for: $RepoPath"
Write-Host "    Remember to commit .githooks/ and .gitattributes."
