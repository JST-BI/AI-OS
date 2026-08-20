#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pre-commit check: CLAUDE.md og AGENTS.md skal vaere byte-identiske spejle.

Claude Code laeser CLAUDE.md; Codex laeser AGENTS.md. De to filer er samme
indhold under to navne, saa begge vaerktoejer ser praecis de samme regler.
Driver de fra hinanden, faar de to vaerktoejer forskellige instrukser - og
den slags opdages foerst naar en agent handler forkert.

Hook-mode (ingen argumenter): sammenligner det STAGED indhold af hvert par
hvor mindst den ene fil er med i commit'en.
Test-mode (mappestier som argumenter): sammenligner filerne paa disk.
Exit 1 hvis et spejl mangler eller afviger."""
import sys, os, subprocess

PAIR = ('CLAUDE.md', 'AGENTS.md')


def staged_paths():
    out = subprocess.run(['git', 'diff', '--cached', '--name-only', '--diff-filter=ACMR', '-z'],
                         capture_output=True).stdout
    return [p.decode('utf-8', 'surrogateescape') for p in out.split(b'\x00') if p]


def index_bytes(path):
    """Indholdet som det ligger i git-index (efter eol-normalisering). None hvis ikke i index."""
    r = subprocess.run(['git', 'show', ':' + path], capture_output=True)
    return r.stdout if r.returncode == 0 else None


def check_staged():
    # Mapper hvor mindst den ene halvdel af parret er med i commit'en
    dirs = sorted({os.path.dirname(p) for p in staged_paths()
                   if os.path.basename(p) in PAIR})
    problems = []
    for d in dirs:
        paths = [(d + '/' + n if d else n) for n in PAIR]
        blobs = [index_bytes(p) for p in paths]
        label = d if d else '.'
        missing = [p for p, b in zip(paths, blobs) if b is None]
        if missing:
            problems.append((label, 'mangler i commit/index: ' + ', '.join(missing)))
        elif blobs[0] != blobs[1]:
            problems.append((label, 'CLAUDE.md og AGENTS.md er ikke identiske'))
    return problems


def check_disk(dirs):
    problems = []
    for d in dirs:
        paths = [os.path.join(d, n) for n in PAIR]
        missing = [p for p in paths if not os.path.isfile(p)]
        if missing:
            problems.append((d, 'findes ikke: ' + ', '.join(missing)))
            continue
        data = [open(p, 'rb').read().replace(b'\r\n', b'\n') for p in paths]
        if data[0] != data[1]:
            problems.append((d, 'CLAUDE.md og AGENTS.md er ikke identiske'))
        else:
            print('OK  (spejl intakt): ' + d)
    return problems


def main():
    args = sys.argv[1:]
    problems = check_disk(args) if args else check_staged()
    if problems:
        sys.stderr.write('\nCOMMIT BLOKERET - CLAUDE.md/AGENTS.md-spejlet er brudt:\n')
        for where, why in problems:
            sys.stderr.write('   - %s: %s\n' % (where, why))
        sys.stderr.write('\nClaude Code laeser CLAUDE.md, Codex laeser AGENTS.md.\n'
                         'De skal vaere identiske, ellers foelger de to vaerktoejer\n'
                         'forskellige regler.\n\n'
                         'Ret det:   Copy-Item CLAUDE.md AGENTS.md; git add CLAUDE.md AGENTS.md\n'
                         'Alle repos: & "AI OS\\tools\\sync-agents-md.ps1"\n'
                         'Fejlalarm?  git commit --no-verify\n')
        return 1
    return 0


sys.exit(main())
