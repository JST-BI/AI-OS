#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pre-commit scanner: blokerer Excel-filer med persondata (CPR / e-mail / navn-kolonner).
Hook-mode (ingen argumenter): scanner git-staged Excel-filer (staged indhold).
Test-mode (filstier som argumenter): scanner filer fra disk.
Exit 1 hvis personhenforbar fil findes / ikke kan verificeres."""
import sys, re, io, zipfile, subprocess

EXC = ('.xlsx', '.xlsm', '.xlsb', '.xls')
CPR   = re.compile(r'\b\d{6}-\d{4}\b')
EMAIL = re.compile(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')
KW    = re.compile(r'(?i)(?<![a-zæøå])(cpr|personnummer|fornavn|efternavn|navn|e-?mail)(?![a-zæøå])')

def xlsx_text(data):
    out=[]
    with zipfile.ZipFile(io.BytesIO(data)) as z:
        for n in z.namelist():
            if n.startswith('xl/') and n.endswith('.xml') and ('sharedStrings' in n or '/worksheets/' in n):
                try: xml=z.read(n).decode('utf-8','ignore')
                except Exception: continue
                out.append(re.sub(r'<[^>]+>',' ',xml))
    return '\n'.join(out)

def findings(name, data):
    low=name.lower()
    try:
        if low.endswith(('.xlsx','.xlsm')):
            text=xlsx_text(data)
        else:  # .xls/.xlsb binaer: best-effort raastscan (kun CPR/e-mail er paalidelige)
            text=data.decode('latin-1','ignore')
    except Exception as e:
        return ['kan ikke laeses som Excel ('+type(e).__name__+') - blokeret for en sikkerheds skyld']
    f=[]
    if CPR.search(text):   f.append('CPR-nummer (DDMMYY-XXXX)')
    if EMAIL.search(text): f.append('e-mailadresse')
    kw=sorted({m.group(1).lower() for m in KW.finditer(text)})
    if kw: f.append('noegleord: '+', '.join(kw))
    return f

def staged():
    out=subprocess.run(['git','diff','--cached','--name-only','--diff-filter=ACM','-z'],
                       capture_output=True).stdout
    return [p for p in out.split(b'\x00') if p]

def staged_bytes(p):
    return subprocess.run(['git','show',b':'+p],capture_output=True).stdout

def main():
    args=sys.argv[1:]
    bad={}
    if args:  # test-mode: disk
        for a in args:
            if a.lower().endswith(EXC):
                data=open(a,'rb').read()
                f=findings(a,data)
                if f: bad[a]=f
                else: print('OK  (ren): '+a)
    else:     # hook-mode: staged
        for p in staged():
            name=p.decode('utf-8','surrogateescape')
            if name.lower().endswith(EXC):
                f=findings(name, staged_bytes(p))
                if f: bad[name]=f
    if bad:
        sys.stderr.write('\n❌ COMMIT BLOKERET - personhenforbare Excel-filer:\n')
        for k,v in bad.items():
            sys.stderr.write('   - %s: %s\n' % (k, '; '.join(v)))
        sys.stderr.write('\nExcel med navn/CPR/mail maa ikke paa GitHub.\n'
                         'Fjern fra commit:  git restore --staged "<fil>"\n'
                         'Fejlalarm?         git commit --no-verify\n')
        return 1
    return 0

sys.exit(main())
