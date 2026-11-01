#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pre-commit check: AGENTS.md er eneste instruktionsfil - ingen CLAUDE.md-varianter.

Claude Code (>= v2.1.277) og Codex laeser begge AGENTS.md direkte. Claude Code springer
AGENTS.md OVER, hvis der ligger en CLAUDE.md, .claude/CLAUDE.md eller CLAUDE.local.md i
arbejdsmappen eller over den. En saadan fil er derfor ikke harmloes: den slukker stille
for reglerne. Denne check blokerer commit af dem.

Hook-mode (ingen argumenter): kontrollerer stagede tilfoejelser/aendringer.
Test-mode (stier som argumenter): kontrollerer de angivne stier.
Exit 1 ved fund."""
import sys, os, subprocess

FORBUDT = ('CLAUDE.md', 'CLAUDE.local.md')


def forbudt(path):
    return os.path.basename(path.replace('\\', '/')) in FORBUDT


def staged_paths():
    out = subprocess.run(['git', 'diff', '--cached', '--name-only', '--diff-filter=ACMR', '-z'],
                         capture_output=True).stdout
    return [p.decode('utf-8', 'surrogateescape') for p in out.split(b'\x00') if p]


def main(argv):
    fund = [p for p in (argv or staged_paths()) if forbudt(p)]
    for p in fund:
        print(f'pre-commit: {p} - skriv reglerne i AGENTS.md; en CLAUDE.md faar Claude Code '
              f'til at ignorere AGENTS.md (fjern med: git rm --cached "{p}")', file=sys.stderr)
    return 1 if fund else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
