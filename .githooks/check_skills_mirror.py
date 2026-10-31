#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pre-commit check: .agents/skills/ er eneste kilde, .claude/skills/ et byte-identisk spejl.

Samme princip som AGENTS.md/CLAUDE.md: Codex laeser .agents/skills/, Claude Code
.claude/skills/. Spejlet skrives KUN af tools/sync-skills.ps1, saa ingen skill kan
drive mellem vaerktoejerne.

Blokerer en commit, naar en sti under en af de to mapper er med i commit'en, og
git-index derefter ikke har praecis samme filer med samme indhold i begge mapper
(sammenlignet paa blob-hash, saa en allerede committet modpart taeller med).
Repoer uden .agents/skills/ i index springes over.
Test-mode (repo-sti som argument): sammenligner filerne paa disk. Exit 1 ved fejl."""
import hashlib, os, subprocess, sys

KILDE, SPEJL = '.agents/skills/', '.claude/skills/'


def git(*a):
    return subprocess.run(['git', *a], capture_output=True).stdout


def index_map(prefix):
    out = git('ls-files', '-s', '-z', '--', prefix)
    m = {}
    for rec in out.split(b'\x00'):
        if not rec:
            continue
        meta, path = rec.split(b'\t', 1)
        m[path.decode('utf-8', 'surrogateescape')[len(prefix):]] = meta.split()[1].decode()
    return m


def disk_map(root, prefix):
    base = os.path.join(root, prefix)
    m = {}
    for d, _, files in os.walk(base):
        for f in files:
            p = os.path.join(d, f)
            m[os.path.relpath(p, base).replace(os.sep, '/')] = hashlib.sha256(open(p, 'rb').read()).hexdigest()
    return m


def sammenlign(k, s):
    fejl = []
    for r in sorted(set(k) | set(s)):
        if r not in s:
            fejl.append(SPEJL + r + ' mangler i spejlet')
        elif r not in k:
            fejl.append(SPEJL + r + ' har ingen modpart i ' + KILDE + ' (kilden)')
        elif k[r] != s[r]:
            fejl.append(SPEJL + r + ' afviger fra ' + KILDE + r)
    return fejl


def main():
    if sys.argv[1:]:
        root = sys.argv[1]
        k, s = disk_map(root, KILDE), disk_map(root, SPEJL)
    else:
        staged = git('diff', '--cached', '--name-only', '-z').split(b'\x00')
        if not any(p.decode('utf-8', 'surrogateescape').startswith((KILDE, SPEJL)) for p in staged if p):
            return 0
        k, s = index_map(KILDE), index_map(SPEJL)
    if not k:
        return 0
    fejl = sammenlign(k, s)
    if fejl:
        sys.stderr.write('\nCOMMIT BLOKERET - skills er ikke i orden:\n')
        for f in fejl:
            sys.stderr.write('   - %s\n' % f)
        sys.stderr.write('\n.agents/skills/ er eneste kilde (uafhaengig af AI-model); .claude/skills/ er\n'
                         'et genereret spejl, som Claude Code laeser. Rediger i .agents/skills/ og koer:\n'
                         '   & "AI OS\\tools\\sync-skills.ps1"\n'
                         'Fejlalarm?  git commit --no-verify\n')
        return 1
    if sys.argv[1:]:
        print('OK: .claude/skills/ er et spejl af .agents/skills/ (%d filer)' % len(k))
    return 0


sys.exit(main())
