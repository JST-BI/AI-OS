# -*- coding: utf-8 -*-
"""Tjekker de TMDL-krydsreferencer som validate-tmdl.ps1 STRUKTURELT ikke kan se.

HVORFOR DEN FINDES (2026-09-08). En ny tabel fik `queryGroup: STU\\GEN` — en gruppe der
ikke var erklaeret i model.tmdl. validate-tmdl.ps1 meldte GROENT, og PBI Desktop naegtede
at aabne modellen med:

    Cannot resolve all the paths while de-serializing Database.
    Property QueryGroup of object "partition ..." refers to an object which cannot be found

Validatoren kan ikke fange det, og det er ikke en fejl i den: den kalder samme
`TmdlSerializer.DeserializeDatabaseFromFolder` som PBI, men DAX Studios TOM-bibliotek
stopper paa kompatibilitetsniveauet (modellen bruger DAX UDF'er, der kraever 1000000)
LAENGE foer den naar til at opløse krydsreferencer. Grønt fra validate-tmdl.ps1 betyder
altsaa "TMDL parsede", ikke "PBI kan indlaese den".

Koeres foer hver PBI-genaabning der har roert model.tmdl eller tilfoejet en tabel:

    python "AI OS/tools/tmdl-krydsreferencer.py" "<sti til ...SemanticModel/definition>"

Exit 0 = ingen fund. Exit 1 = mindst ét fund; PBI vil afvise modellen.
"""
import io
import os
import re
import sys


def laes(sti):
    return io.open(sti, encoding="utf-8", newline="").read().replace("\r\n", "\n")


def main(definition):
    if not os.path.isdir(definition):
        print("FEJL: findes ikke: %s" % definition)
        return 2

    model_sti = os.path.join(definition, "model.tmdl")
    tabeldir = os.path.join(definition, "tables")
    model = laes(model_sti)
    fund = []

    # --- 1) queryGroup: alle brugte skal vaere erklaeret i model.tmdl -----------
    erklaeret = set()
    for m in re.finditer(r"^queryGroup (?:'([^']+)'|(\S.*?))\s*$", model, re.M):
        erklaeret.add((m.group(1) or m.group(2)).strip())

    filer = []
    for navn in ("expressions.tmdl",):
        p = os.path.join(definition, navn)
        if os.path.exists(p):
            filer.append(p)
    if os.path.isdir(tabeldir):
        filer += [os.path.join(tabeldir, f) for f in sorted(os.listdir(tabeldir)) if f.endswith(".tmdl")]

    for f in filer:
        for m in re.finditer(r"^\s*queryGroup:\s*(?:'([^']+)'|(\S.*?))\s*$", laes(f), re.M):
            g = (m.group(1) or m.group(2)).strip()
            if g not in erklaeret:
                fund.append("queryGroup '%s' er IKKE erklaeret i model.tmdl (brugt i %s)"
                            % (g, os.path.basename(f)))

    # --- 2) ref table peger paa en fil der findes, og omvendt -------------------
    refs = [r.strip().strip("'") for r in re.findall(r"^ref table (.+)$", model, re.M)]
    for r in refs:
        if not os.path.exists(os.path.join(tabeldir, r + ".tmdl")):
            fund.append("model.tmdl har 'ref table %s', men tables/%s.tmdl findes ikke" % (r, r))
    paa_disk = {f[:-5] for f in os.listdir(tabeldir)} if os.path.isdir(tabeldir) else set()
    for t in sorted(paa_disk - set(refs)):
        fund.append("tables/%s.tmdl er IKKE refereret i model.tmdl - tabellen indlaeses ikke" % t)

    # --- 3) dublerede lineageTags: ADVARSEL, ikke roedt ------------------------
    # HR_OEKONOMI har allerede én dublet paa main, og PBI aabner fint med den. Den
    # bloker derfor ikke - men den skal ses, for en dublet kan flytte formatering og
    # feltbindinger mellem to objekter uden at noget fejler.
    advarsler = []
    set_tags = {}
    for f in filer + [model_sti]:
        for i, linje in enumerate(laes(f).split("\n"), 1):
            m = re.match(r"^\s*lineageTag:\s*(\S+)\s*$", linje)
            if m:
                set_tags.setdefault(m.group(1), []).append("%s:%d" % (os.path.basename(f), i))
    for tag, steder in sorted(set_tags.items()):
        if len(steder) > 1:
            advarsler.append("lineageTag %s optraeder %d steder: %s" % (tag, len(steder), ", ".join(steder)))

    for a in advarsler:
        print("GUL: " + a)

    if fund:
        print("ROED: %d fund - PBI vil afvise modellen." % len(fund))
        for f in fund:
            print("  - " + f)
        return 1
    print("GROEN: queryGroups erklaeret, og ref table <-> filer stemmer.")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
