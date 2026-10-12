#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pre-commit check: AGENTS.md er instruktionsfilen, CLAUDE.md er kun en pegefil.

AGENTS.md er den eneste, modeluafhaengige instruktionsfil i hver mappe. Codex
laeser den direkte; Claude Code laeser CLAUDE.md, som derfor KUN maa indeholde
importlinjen "@AGENTS.md". Saa ser begge vaerktoejer samme fil, og ingen regel
kan drive mellem dem.

Blokerer en commit hvor
  - CLAUDE.md er andet end pegefilen (nogen har skrevet regler i den igen), eller
  - CLAUDE.md committes uden at AGENTS.md findes i samme mappe, eller
  - AGENTS.md committes uden at CLAUDE.md-pegefilen findes i samme mappe.

Hook-mode (ingen argumenter): kontrollerer det STAGED indhold af hver mappe hvor
mindst en af de to filer er med i commit'en (AGENTS.md/CLAUDE.md slaas op i
index, saa en allerede committet modpart taeller med).
Test-mode (mappestier som argumenter): kontrollerer filerne paa disk.
Exit 1 ved fejl."""
import sys, os, subprocess

PAIR = ('CLAUDE.md', 'AGENTS.md')
POINTER = '@AGENTS.md'


def er_pegefil(data):
    if data is None:
        return False
    tekst = data.decode('utf-8-sig', 'replace').replace('\r\n', '\n').strip()
    return tekst == POINTER


def staged_paths():
    out = subprocess.run(['git', 'diff', '--cached', '--name-only', '--diff-filter=ACMR', '-z'],
                         capture_output=True).stdout
    return [p.decode('utf-8', 'surrogateescape') for p in out.split(b'\x00') if p]


def index_bytes(path):
    """Indholdet som det ligger i git-index. None hvis ikke i index."""
    r = subprocess.run(['git', 'show', ':' + path], capture_output=True)
    return r.stdout if r.returncode == 0 else None


def vurder(label, claude, agents):
    """claude/agents er bytes eller None. Returnerer en fejltekst eller None."""
    if claude is None and agents is None:
        return None
    if agents is None:
        return 'AGENTS.md mangler - instruktionerne skal staa i AGENTS.md, CLAUDE.md er kun pegefil'
    if claude is None:
        return 'CLAUDE.md (pegefil) mangler - skriv en CLAUDE.md der kun indeholder "@AGENTS.md"'
    if not er_pegefil(claude):
        return ('CLAUDE.md er ikke pegefilen - flyt teksten til AGENTS.md og lad CLAUDE.md '
                'kun indeholde "@AGENTS.md"')
    return None


def check_staged():
    dirs = sorted({os.path.dirname(p) for p in staged_paths()
                   if os.path.basename(p) in PAIR})
    problems = []
    for d in dirs:
        paths = [(d + '/' + n if d else n) for n in PAIR]
        claude, agents = (index_bytes(p) for p in paths)
        fejl = vurder(d or '.', claude, agents)
        if fejl:
            problems.append((d or '.', fejl))
    return problems


def check_disk(dirs):
    problems = []
    for d in dirs:
        paths = [os.path.join(d, n) for n in PAIR]
        blobs = [open(p, 'rb').read() if os.path.isfile(p) else None for p in paths]
        fejl = vurder(d, *blobs)
        if fejl:
            problems.append((d, fejl))
        else:
            print('OK  (AGENTS.md + pegefil): ' + d)
    return problems


def main():
    args = sys.argv[1:]
    problems = check_disk(args) if args else check_staged()
    if problems:
        sys.stderr.write('\nCOMMIT BLOKERET - instruktionsfilerne er ikke i orden:\n')
        for where, why in problems:
            sys.stderr.write('   - %s: %s\n' % (where, why))
        sys.stderr.write('\nAGENTS.md er den eneste instruktionsfil (uafhaengig af AI-model).\n'
                         'CLAUDE.md maa kun indeholde linjen "@AGENTS.md", som Claude Code\n'
                         'laeser som import - saa ser begge vaerktoejer samme regler.\n\n'
                         'Ret det:    & "AI OS\\tools\\sync-agents-md.ps1"   (skriver pegefilerne)\n'
                         'Fejlalarm?  git commit --no-verify\n')
        return 1
    return 0


sys.exit(main())
