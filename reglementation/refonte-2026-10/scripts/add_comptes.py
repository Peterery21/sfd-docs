#!/usr/bin/env python3
"""Ajoute des comptes (code -> libellé) à un plan-comptable.yml sans toucher à l'existant.
Usage: add_comptes.py <plan.yml> <adds.json {code: libellé}>
Attributs (classe, nature, sens, mandataire, analytique) hérités du compte existant le plus proche
(plus long préfixe commun, puis proximité numérique). Insertion en position triée (après le
dernier code existant inférieur)."""
import json, re, sys, yaml

def nearest(code, existing):
    def key(e):
        n = 0
        while n < min(len(e["code"]), len(code)) and e["code"][n] == code[n]: n += 1
        try: d = abs(int(e["code"].ljust(8, "0")) - int(code.ljust(8, "0")))
        except ValueError: d = 10**9
        return (-n, d)
    return min(existing, key=key)

def main():
    plan, adds = sys.argv[1], json.load(open(sys.argv[2]))
    text = open(plan, encoding="utf-8").read()
    doc = yaml.safe_load(text)["accounting-norm"]
    existing = [dict(c, code=str(c["code"])) for c in doc["comptes"]]
    have = {c["code"] for c in existing}
    adds = {c: re.sub(r"\s+", " ", l).strip() for c, l in adds.items() if c not in have}
    blocks = list(re.finditer(r'^    - code: "?([^"\n]+)"?\n(?:      .*\n)*\n?', text, re.M))
    codes = [m.group(1) for m in blocks]
    out, pos_of = text, {}
    for code in sorted(adds, reverse=True):
        prev = [i for i, c in enumerate(codes) if c < code]
        ref = nearest(code, existing)
        blk = (f'    - code: "{code}"\n      libelle: "{adds[code].replace(chr(34), chr(39))}"\n'
               f'      classeComptable: "{code[0]}"\n      natureCompte: "{ref["natureCompte"]}"\n'
               f'      sensCompte: "{ref["sensCompte"]}"\n      mandataire: {str(ref["mandataire"]).lower()}\n'
               f'      analytique: {str(ref["analytique"]).lower()}\n\n')
        m = blocks[prev[-1]]
        pos_of[code] = (m.end(), blk)
    # insertion de la fin vers le début pour ne pas décaler les offsets
    ins = {}
    for code, (pos, blk) in pos_of.items(): ins.setdefault(pos, []).append((code, blk))
    for pos in sorted(ins, reverse=True):
        chunk = "".join(b for _, b in sorted(ins[pos]))
        if not out[:pos].endswith("\n\n"): chunk = "\n" + chunk
        out = out[:pos] + chunk + out[pos:]
    open(plan, "w", encoding="utf-8").write(out)
    print(len(adds), "ajoutés")
main()
