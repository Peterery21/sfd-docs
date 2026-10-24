#!/usr/bin/env python3
"""Extrait code->libellé du PCEMF (texte PDF). Liste des comptes (l.953-2620) prioritaire,
puis fonctionnement des comptes (l.2621+) en complément. Sortie JSON {code: [libellé, source]}."""
import re, sys, json
SEP = r"\s*(?:[–\-]\s*|\s)"
LINE = re.compile(r"^\s*(\d{2,6}(?:\s*/\s*\d{2,6})*)" + SEP + r"(\D.*?)\s*$")
BARE = re.compile(r"^\s*(\d{2,6}(?:\s*/\s*\d{2,6})*)\s*$")
HDR = re.compile(r"Commission Bancaire|^CLASSE|^PCEMF|LISTE DES COMPTES")
def labsplit(lab, i):
    return re.sub(r"LT\s*/\s*MT", ["LT", "MT"][i], re.sub(r"A LONG TERME\s*/\s*A MOYEN TERME", ["A LONG TERME", "A MOYEN TERME"][i], lab))
def parse(path, part, out):
    raw = open(path, encoding="utf-8").read().split("\n")
    # numéro de page = ligne numérique juste avant l'en-tête « Commission Bancaire »
    raw = [l for i, l in enumerate(raw) if not (re.match(r"^\s*\d+\s*$", l) and i + 1 < len(raw) and "Commission Bancaire" in raw[i + 1])]
    a = next(i for i, l in enumerate(raw) if l.strip() == "LISTE DES COMPTES")
    b = next(i for i, l in enumerate(raw) if i > a and l.strip() == "CLASSE 1")
    lines = raw[a:b] if part == "liste" else raw[b:]
    last = pend = None
    new = set()
    for l in lines:
        if HDR.search(l): last = pend = None; continue
        m = LINE.match(l)
        if m and not re.match(r"^\d", m.group(2)):
            codes = [c.strip() for c in m.group(1).split("/")]
            last = []
            for i, c in enumerate(codes):
                lb = labsplit(m.group(2), i) if len(codes) == 2 else m.group(2)
                if c not in out: out[c] = lb; new.add(c); last.append(c)
            pend = None
        elif BARE.match(l):
            pend = [c.strip() for c in l.split("/")]; last = None
        elif pend and l.strip():
            last = []
            for c in pend:
                if c not in out: out[c] = l.strip(); new.add(c); last.append(c)
            pend = None
        elif last and l.strip() and len(l.strip()) <= 45 and l.strip()[0].islower() and last and (len(last[0]) >= 4 or out[last[0]].count("(") > out[last[0]].count(")")) and len(out[last[0]]) < 100:
            for c in last: out[c] += " " + l.strip()
        elif l.strip():
            last = None
    return out
if __name__ == "__main__":
    d = {}
    parse(sys.argv[1], "liste", d)
    first = set(d)
    parse(sys.argv[1], "fonct", d)
    clean = lambda v: (lambda t: t[:1].upper() + t[1:])(re.sub(r"\s+", " ", v).strip().rstrip("."))
    json.dump({k: [clean(v), "liste" if k in first else "fonctionnement"] for k, v in d.items()}, sys.stdout, ensure_ascii=False, indent=0)
