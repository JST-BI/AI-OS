"""STE-tjek af en "Vis mig"-side (dansk efter ASD-STE100-principperne, references/ste-dansk.md).

Kald: python -I -B -X utf8 ste_tjek.py <side.html> [--maks-trin 20] [--maks-tekst 25]

Læser den synlige tekst (ikke <script>, <style>, <pre>, <code>, <svg>-kode eller et sammenfoldet
<details class="teknik">) og melder:
  - sætninger over grænsen: 20 ord i et trin (<li> i <ol>), 25 ord i anden tekst (STE 4.2)
  - ord fra fy-listen (STE 8.1 / foretrukne ord) og "man" (STE 3.5)
  - mulig s-passiv i trin (STE 3.2)
  - ord med mere end 20 bogstaver uden tegn som _ . / \\ (lange sammensætninger, STE 2.1)
  - forkortelser med store bogstaver og om de står i <abbr title> eller i "Ord du møder" (STE 8.1)
  - figurer (<svg>, <pre class="mermaid">, <img>) uden <figcaption> (SKILL.md "Grafik")
  - afsnittet "Hvor ligger det": OK kun med mindst én fuld sti (C:\\, Y:\\, \\\\server) og uden relative stier
    og løse filnavne (SKILL.md "Sidens opbygning")
Exit 0 altid – fundene er råd, ikke stop. Navne fra kilden må gerne stå.
"""
import argparse, os, re, sys
from html.parser import HTMLParser

FY = ['man', 'evt.', 'mv.', 'm.m.', 'osv.', 'bl.a.', 'ift.', 'ifm.', 'jf.', 'dvs.', 'pga.', 'vha.', 'hhv.',
      'herunder', 'således', 'hvorvidt', 'endvidere', 'eksekvere', 'eksekveres', 'initiere', 'implementere',
      'implementeres', 'validere', 'valideres', 'påkrævet', 'foretage', 'foretages']
SKJUL = {'script', 'style', 'pre', 'code', 'svg', 'kbd', 'samp'}
BLOK = {'p', 'li', 'td', 'th', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'figcaption', 'dd', 'dt', 'blockquote', 'caption', 'summary', 'div', 'section'}
PASSIV = re.compile(r'\b\w{3,}(?:eres|es)\b', re.I)
IKKE_PASSIV = {'findes', 'synes', 'mindes', 'lykkes', 'skyldes', 'trives', 'kendes', 'ses', 'des', 'disses', 'hinandens',
               'ordres', 'filens', 'lines', 'tabellens', 'gruppes', 'måles', 'parentes', 'proces'}
# ikke forkortelser: STE-advarselsordene (references/ste-dansk.md 7.2), statusord og måleenheder
IKKE_FORKORTELSE = {'ADVARSEL', 'FORSIGTIG', 'BEMÆRK', 'OK', 'KB', 'MB', 'GB', 'TB'}


class Laeser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stak = []           # åbne tags
        self.skjult = 0
        self.tekster = []        # (slags, tekst)
        self.buf = []
        self.abbr = set()
        self.figurer = 0
        self.figurer_uden = 0
        self.i_figur = []        # [har_caption]
        self.ordliste = []
        self.i_ordliste = False
        self.details = []        # True for <details class="teknik">

    def _skyl(self):
        t = ' '.join(''.join(self.buf).split())
        if t:
            slags = 'trin' if ('li' in self.stak and self._i_ol()) else 'tekst'
            self.tekster.append((slags, t))
            if self.i_ordliste:
                self.ordliste.append(t)
        self.buf = []

    def _i_ol(self):
        for t in reversed(self.stak):
            if t in ('ol', 'ul'):
                return t == 'ol'
        return False

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag in BLOK:
            self._skyl()
        if tag == 'details':
            teknik = 'teknik' in (a.get('class') or '')
            self.details.append(teknik)
            self.skjult += teknik
        if tag in SKJUL or (tag == 'pre' and 'mermaid' in (a.get('class') or '')):
            self.skjult += 1
        if tag == 'abbr' and a.get('title'):
            self.abbr.add(None)
        if tag == 'figure':
            self.i_figur.append(False)
        if tag in ('svg', 'img') or (tag == 'pre' and 'mermaid' in (a.get('class') or '')):
            if not self.i_figur:
                self.figurer_uden += 1
            self.figurer += 1
        if tag == 'figcaption' and self.i_figur:
            self.i_figur[-1] = True
        self.stak.append(tag)

    def handle_endtag(self, tag):
        if tag in BLOK:
            self._skyl()
        if tag in SKJUL:
            self.skjult = max(0, self.skjult - 1)
        if tag == 'details' and self.details:
            self.skjult = max(0, self.skjult - self.details.pop())
        if tag == 'figure' and self.i_figur:
            if not self.i_figur.pop():
                self.figurer_uden += 1
        if tag in self.stak:
            while self.stak and self.stak.pop() != tag:
                pass

    def handle_data(self, data):
        if self.skjult:
            return
        if self.stak and self.stak[-1] in ('h2', 'h3') and 'ord du møder' in data.lower():
            self.i_ordliste = True
        elif self.stak and self.stak[-1] in ('h2', 'h3'):
            self.i_ordliste = False
        if self.stak and self.stak[-1] == 'abbr':
            self.abbr.add(data.strip())
        self.buf.append(data)


EXT = r'(?:ps1|py|tmdl|pbip|pbix|xlsx|xlsm|json|md|csv|dax|txt|html|pdf|docx|pptx)'
FULD = re.compile(r'(?:\b[A-Za-z]:\\|\\\\[\w.$-]+\\)[^<>"\n]*?(?=\s*(?:$|[,;)]\s|\si\s|\s\(|\.\s))')   # drev- eller UNC-sti (" - " hører til OneDrive-stien)
RELATIV = re.compile(r'(?<![:\\\w])[\w][\w .+()-]*(?:[\\/][\w .+()-]+)+\.' + EXT + r'\b', re.I)   # mappe\fil.ext uden drev
FILNAVN = re.compile(r'(?<![\\/\w.-])[\w.+-]+\.' + EXT + r'\b', re.I)


def tjek_stier(html):
    """SKILL.md 'Hvor ligger det': den fulde sti til hver kildefil som én tekst, der kan sættes ind i Stifinder. Læser
    afsnittets rå tekst (også <code>) stykke for stykke og melder: fulde stier (C:\\..., Y:\\..., \\\\server\\...),
    relative stier (mappe\\fil.ext uden drev) og filnavne uden sti. OK = mindst én fuld sti og ingen af de to andre."""
    import html as h
    m = re.search(r'(?is)<h[23][^>]*>[^<]*hvor ligger[^<]*</h[23]>(.*?)(?=<h[23][\s>]|</body>|$)', html)
    if not m:
        return '"Hvor ligger det": AFSNIT MANGLER'
    stykker = [h.unescape(s).strip() for s in re.split(r'<[^>]+>', m.group(1))]
    fulde, relative, uden = [], [], []
    for s in filter(None, stykker):
        fs = FULD.findall(s)
        fulde += fs
        rest = FULD.sub(' ', s)
        rs = RELATIV.findall(rest)
        relative += [x.strip() for x in rs]
        uden += FILNAVN.findall(RELATIV.sub(' ', rest))
    kendte = {os.path.basename(x.replace('\\', '/')).lower() for x in fulde}
    uden = sorted({f for f in uden if f.lower() not in kendte})
    relative = sorted(set(relative))
    status = 'OK' if fulde and not relative and not uden else 'RET'
    return ('"Hvor ligger det": %s - fulde stier %d, relative stier %d%s, filnavne uden sti %d%s' % (
        status, len(fulde), len(relative), (' (' + '; '.join(relative[:5]) + ')') if relative else '',
        len(uden), (' (' + ', '.join(uden[:8]) + ')') if uden else ''))


def saetninger(t):
    # punktum efter forkortelse/tal splitter ikke; ét ord = token med mindst ét bogstav eller ciffer
    dele = re.split(r'(?<=[.!?])\s+(?=[A-ZÆØÅ0-9"«(])', t)
    return [d for d in dele if d.strip()]


def ord_i(s):
    return [w for w in re.findall(r"[\wæøåÆØÅ'’.\-/\\]+", s) if re.search(r'[\wæøå]', w, re.I)]


def main(argv=None):
    sys.stdout.reconfigure(encoding='utf-8')
    ap = argparse.ArgumentParser()
    ap.add_argument('fil'); ap.add_argument('--maks-trin', type=int, default=20); ap.add_argument('--maks-tekst', type=int, default=25)
    a = ap.parse_args(argv)
    p = Laeser()
    html = open(a.fil, encoding='utf-8').read()
    p.feed(html); p._skyl()
    lange, fy, passiv, langeord, forkort = [], {}, [], {}, {}
    n_s = n_ord = 0
    for slags, t in p.tekster:
        for s in saetninger(t):
            w = ord_i(s); n_s += 1; n_ord += len(w)
            graense = a.maks_trin if slags == 'trin' else a.maks_tekst
            if len(w) > graense:
                lange.append((slags, len(w), s[:110]))
            for x in w:
                xl = x.lower().strip('.,;:()"')
                xl_p = x.lower().strip(',;:()"')
                for f in FY:
                    if (f.endswith('.') and xl_p == f) or (not f.endswith('.') and xl == f):
                        fy[f] = fy.get(f, 0) + 1
                if len(xl) > 20 and not re.search(r'[_./\\0-9-]', x):
                    langeord[xl] = langeord.get(xl, 0) + 1
                if re.fullmatch(r'[A-ZÆØÅ]{2,6}\d*', x.strip('.,;:()"')) and x.strip('.,;:()"') not in IKKE_FORKORTELSE:
                    forkort[x.strip('.,;:()"')] = forkort.get(x.strip('.,;:()"'), 0) + 1
            if slags == 'trin':
                for m in PASSIV.finditer(s):
                    if m.group(0).lower() not in IKKE_PASSIV and not m.group(0).lower().endswith('ses'):
                        passiv.append((m.group(0), s[:90]))
    ordliste = ' '.join(p.ordliste)
    print(f'STE-tjek: {a.fil}')
    print(f'  {n_s} sætninger, gennemsnit {n_ord / max(n_s, 1):.1f} ord; figurer {p.figurer} (uden billedtekst: {p.figurer_uden})')
    print(f'  for lange sætninger: {len(lange)}')
    for slags, n, s in lange[:30]:
        print(f'    [{slags} {n} ord] {s}')
    print(f'  fy-ord: {sum(fy.values())}' + (' – ' + ', '.join(f'{k} ×{v}' for k, v in sorted(fy.items())) if fy else ''))
    print(f'  mulig s-passiv i trin: {len(passiv)}')
    for o, s in passiv[:15]:
        print(f'    "{o}": {s}')
    print(f'  lange ord (> 20 bogstaver): {len(langeord)}' + (' – ' + ', '.join(sorted(langeord)[:15]) if langeord else ''))
    print('  ' + tjek_stier(html))
    uforklaret = [k for k in sorted(forkort) if k not in p.abbr and k not in ordliste]
    print(f'  forkortelser: {len(forkort)}, heraf uden <abbr title> og uden for "Ord du møder": {len(uforklaret)}'
          + (' – ' + ', '.join(uforklaret[:20]) if uforklaret else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
