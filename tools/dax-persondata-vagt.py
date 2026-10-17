#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Persondatavagt for DAX-queries (TypeSafe/Jev) - vurderer om EVALUATE-resultatet eksponerer personer.

Svarer FOER queryen koeres: pass / review / block. Kaldes af dax-query.ps1 -Persondatavagt, eller direkte:
  python tools/dax-persondata-vagt.py --query-file q.dax [--columns-file kolonner.json]
  python tools/dax-persondata-vagt.py --selftest

Hvad forlader maskinen: queryteksten med tekstliteraler i sammenligninger/maengder maskeret ("LIT"),
samt tabel- og kolonneNAVNE. Aldrig data - vagten koerer foer queryen.

Exitkoder: 0 = pass, 10 = review (kraever -BekraeftAggregat), 20 = block, 2 = brugsfejl.
Er API'et utilgaengeligt, falder vagten tilbage til en lokal noegleordsregel: hit -> review, ellers pass.
En query for lang til Jev (32k tokens) giver altid review.

Taerskler og formuleringer er maalt 2026-10-17 paa jev-1.13.0 (129 repo- og syntetiske queries + 14 holdout):
ingen personniveau-query fik pass, ingen aggregat-query fik block. Modellen er fastlaast, fordi en alias-
opgradering kan flytte sandsynlighederne - koer --selftest foer MODEL aendres.
"""
import argparse, hashlib, json, os, re, sys, time, urllib.error, urllib.request
from concurrent.futures import ThreadPoolExecutor

URL = "https://api.typesafe.ai/v1/systemone"
MODEL = "jev-1.13.0"
PASS_BELOW, BLOCK_ABOVE = 0.35, 0.70   # max(helhed, delspoergsmaal): < pass, > block, ellers review
PERSON_COLUMN_ABOVE = 0.30             # personkolonne; recall 1,00 paa 39 kendte + HR_OEKONOMI's 10
CACHE = os.path.join(os.environ.get("LOCALAPPDATA", os.path.expanduser("~")), "AI-OS", "persondata-kolonner.json")
CASES = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dax-persondata-vagt.cases.json")

EXIT = {"pass": 0, "review": 10, "block": 20}
KEYWORD = re.compile(r"cpr|navn|mail|tjenestenum|fødselsdato|fornavn|efternavn|initial", re.I)

# --- Maskering: literaler brugt som VAERDIER skjules; aliasnavne ("Antal") bevares --------------
_SET = re.compile(r"\{([^{}]*)\}")
_CMP = re.compile(r'((?:=|<>|<=|>=|<|>)\s*)"[^"]*"')
_STR = re.compile(r'"[^"]*"')


def mask(q):
    q = _SET.sub(lambda m: "{" + _STR.sub('"LIT"', m.group(1)) + "}", q)
    return _CMP.sub(lambda m: m.group(1) + '"LIT"', q)


# --- TypeSafe ---------------------------------------------------------------------------------
def api_key():
    k = os.environ.get("TYPESAFE_API_KEY")
    if k or os.name != "nt":
        return k
    try:
        import winreg
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as h:
            return winreg.QueryValueEx(h, "TYPESAFE_API_KEY")[0]
    except OSError:
        return None


class Unavailable(Exception):
    pass


def ask(key, state, questions, retries=4):
    body = json.dumps({"state": state, "model": MODEL, "questions": questions}, ensure_ascii=False).encode("utf-8")
    for attempt in range(retries):
        req = urllib.request.Request(URL, data=body, method="POST",
                                     headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                return json.loads(r.read().decode("utf-8"))["answers"]
        except urllib.error.HTTPError as e:
            if e.code in (429, 529, 500, 502, 503) and attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise Unavailable(f"HTTP {e.code}: {e.read().decode('utf-8', 'replace')[:120]}")
        except (urllib.error.URLError, TimeoutError) as e:
            raise Unavailable(type(e).__name__)
    raise Unavailable("retries opbrugt")


# --- Trin 1: hvilke kolonner identificerer en person? ------------------------------------------
COLUMN_Q_VERSION = "v2"   # bump naar formuleringen aendres - cachen noegles paa versionen
COLUMN_Q = {"pid": {"type": "noul",
    "instructions": ("Table `table` in a Danish vocational school's Power BI model has a column named `column`. "
                     "Do the values in this column identify an individual person (a student, applicant, employee or guardian)?"),
    "criteria": {
        # Ordlisten er noedvendig: uden den laeste Jev "ansvar" som en ansvarlig PERSON og markerede 105 af
        # HR_OEKONOMI's 1.034 refererede kolonner (fx navision_ansvar i hver tabel) - med den 11, recall uaendret 1,00.
        "true": ("Values are a person's name, first name, surname or initials, a CPR number or any key whose name contains 'cpr' "
                 "(also surrogate person keys), a personal email address, phone number or street address, an employee number "
                 "(tjenestenummer), a user ID or person ID, or a birth date. Columns named after a person role "
                 "(Leder, Medarbejder, Person, kontaktlaerer, sagsbehandler) hold names and count as identifying."),
        "false": ("Values are codes or names of things, not people: cost centres and responsibility accounts (ansvar, navision_ansvar, "
                  "Ansvar_SD), purposes (formål), education, course and team codes (CØSA, uddannelse, udda_*, skoleforløb, hold, tmk), "
                  "accounts, departments, municipalities, file or sheet names, company or workplace names and their contact details, "
                  "candidate or measure names in a '#Measures' table, counts, amounts, flags, anchors, dates of events, "
                  "or technical keys built from such codes.")}}}


def ref(table, column):
    return "'" + table.replace("'", "''") + "'[" + column + "]"


def referenced(query, columns):
    """(tabel, kolonne)-par som queryen naevner direkte, plus alle kolonner i tabeller den naevner."""
    low = query.lower()
    tables = {t for t, _ in columns if ("'" + t.replace("'", "''") + "'").lower() in low
              or re.search(r"(?<![\w'])" + re.escape(t.lower()) + r"\s*\[", low)}
    out = {(t, c) for t, c in columns if t in tables}
    for m in re.finditer(r"'((?:[^']|'')+)'\s*\[([^\]]+)\]", query):   # ogsaa uden kolonneliste
        out.add((m.group(1).replace("''", "'"), m.group(2)))
    return sorted(out)


def person_columns(key, pairs, cache):
    ck = lambda p: COLUMN_Q_VERSION + "|" + "|".join(p)
    todo = [p for p in pairs if ck(p) not in cache]

    def one(p):
        a = ask(key, {"table": p[0], "column": p[1]}, COLUMN_Q)
        return ck(p), a["pid"]["noul"]
    with ThreadPoolExecutor(8) as ex:
        for k, v in ex.map(one, todo):
            cache[k] = round(v, 3)
    return [p for p in pairs if cache[ck(p)] > PERSON_COLUMN_ABOVE]


# --- Trin 2: eksponerer EVALUATE-resultatet personer? ------------------------------------------
QUERY_Q = {
    "overall": {"type": "noul",
        "instructions": ("Look only at the table that the DAX query in `query` returns to the user (the EVALUATE result). "
                         "Does that returned table expose individual people, either because it contains values from a column "
                         "listed in `person_identifying_columns`, or because it has one row per individual person "
                         "(for example by returning whole rows of a table listed in `person_tables`)?"),
        "criteria": {
            "true": "The returned table shows person identifiers (CPR number, surrogate person key, name, email, employee number, birth date), "
                    "including names concatenated into a text, or it returns one row per person / whole rows of a person table.",
            "false": "The returned table contains only aggregates (counts, sums, averages, distinct counts, maxima of lengths) or "
                     "non-personal keys such as course codes, years, departments or dimension tables. Person columns used only "
                     "inside COUNTROWS, DISTINCTCOUNT, FILTER conditions, or in variables that are then counted do not count."}},
    "whole_rows": {"type": "noul", "instructions": "Does the DAX query in `query` return whole rows of one of the tables listed in `person_tables` (for example EVALUATE <table>, TOPN(n, <table>, ...), FILTER(<table>, ...), CALCULATETABLE(<table>, ...), or a variable holding such rows that is RETURNed)?"},
    "id_values": {"type": "noul", "instructions": "Does the table returned by the DAX query in `query` contain a column whose values come from one of `person_identifying_columns`, directly, renamed, or concatenated into text? Using such a column only inside COUNTROWS, DISTINCTCOUNT or a FILTER condition does not count."},
    "row_per_person": {"type": "noul", "instructions": "Does the DAX query in `query` return one row for each distinct value of a column in `person_identifying_columns` (for example GENERATE, ADDCOLUMNS or SUMMARIZECOLUMNS over VALUES of a person column), so each output row describes one individual person?"},
}


def judge(key, query, pcols):
    state = {"query": mask(query),
             "person_identifying_columns": [ref(t, c) for t, c in pcols],
             "person_tables": sorted({"'" + t + "'" for t, _ in pcols})}
    a = ask(key, state, QUERY_Q)
    probs = {k: round(a[k]["noul"], 3) for k in QUERY_Q}
    m = max(probs.values())
    verdict = "block" if m > BLOCK_ABOVE else ("review" if m >= PASS_BELOW else "pass")
    return verdict, probs


def guard(query, columns=None):
    key = api_key()
    base = {"model": MODEL, "query_sha256": hashlib.sha256(query.encode("utf-8")).hexdigest()[:12]}
    try:
        if not key:
            raise Unavailable("TYPESAFE_API_KEY mangler")
        cache = {}
        if os.path.exists(CACHE):
            with open(CACHE, encoding="utf-8") as f:
                cache = json.load(f)
        pcols = person_columns(key, referenced(query, columns or []), cache)
        os.makedirs(os.path.dirname(CACHE), exist_ok=True)
        with open(CACHE, "w", encoding="utf-8") as f:
            json.dump(cache, f, ensure_ascii=False, indent=0)
        verdict, probs = judge(key, query, pcols)
        return {**base, "verdict": verdict, "probabilities": probs, "person_columns": [ref(t, c) for t, c in pcols]}
    except Unavailable as e:
        if "max_tokens_exceeded" in str(e):   # for lang til Jev: kan ikke vurderes -> altid review
            return {**base, "verdict": "review", "fallback": "queryen er for lang til vagten (32k tokens)"}
        hit = bool(KEYWORD.search(query))
        return {**base, "verdict": "review" if hit else "pass", "fallback": f"vagt utilgaengelig ({e}) - lokal noegleordsregel",
                "keyword_hit": hit}


# --- Selvtest -------------------------------------------------------------------------------
def selftest():
    key = api_key()
    if not key:
        print("TYPESAFE_API_KEY mangler"); return 2
    cases = json.load(open(CASES, encoding="utf-8"))
    bad = 0

    def q(c):
        v, p = judge(key, c["query"], [tuple(x) for x in c["person_columns"]])
        return c, v, p
    with ThreadPoolExecutor(6) as ex:
        res = list(ex.map(q, cases["queries"]))
    tally = {}
    for c, v, p in res:
        tally[(c["person_level"], v)] = tally.get((c["person_level"], v), 0) + 1
        wrong = (c["person_level"] and v == "pass") or (not c["person_level"] and v == "block")
        bad += wrong
        if wrong or v == "review":
            print(f"  {'FEJL' if wrong else 'review'}: {c['id']} (personniveau={c['person_level']}) -> {v} {p}")
    print("queries:", {f"{'person' if k[0] else 'aggregat'}->{k[1]}": n for k, n in sorted(tally.items())})

    def col(c):
        a = ask(key, {"table": c[0], "column": c[1]}, COLUMN_Q)
        return c, a["pid"]["noul"]
    with ThreadPoolExecutor(8) as ex:
        cres = list(ex.map(col, cases["columns"]))
    missed = [c for c, p in cres if c[2] and p <= PERSON_COLUMN_ABOVE]
    fp = [c for c, p in cres if not c[2] and p > PERSON_COLUMN_ABOVE]
    print(f"kolonner: {len(cres)} - personkolonner overset: {len(missed)} {missed} - falske alarmer: {len(fp)}")
    bad += len(missed)
    print("RESULTAT:", "OK" if bad == 0 else f"FEJL ({bad})")
    return 0 if bad == 0 else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--query-file")
    ap.add_argument("--columns-file", help="JSON-liste af [tabel, kolonne] eller {t, c} fra modellen (dax-query.ps1 laver den)")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()
    if a.selftest:
        return selftest()
    if not a.query_file:
        ap.error("--query-file eller --selftest")
    query = open(a.query_file, encoding="utf-8-sig").read()
    raw = json.load(open(a.columns_file, encoding="utf-8-sig")) if a.columns_file else []
    columns = [(x["t"], x["c"]) if isinstance(x, dict) else tuple(x) for x in raw]
    res = guard(query, columns)
    print(json.dumps(res, ensure_ascii=False))
    return EXIT[res["verdict"]]


if __name__ == "__main__":
    sys.exit(main())
