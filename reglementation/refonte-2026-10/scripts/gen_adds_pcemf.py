#!/usr/bin/env python3
"""Usage: gen_adds_pcemf.py <pcemf.json> <missing.json (diff --json)> <plan.yml> <adds.json out>
Pour chaque préfixe manquant : ajoute lui et ses descendants listés au PCEMF, plus les ancêtres absents du plan."""
import json, sys, yaml
src = {k: v[0] for k, v in json.load(open(sys.argv[1])).items()}
miss = json.load(open(sys.argv[2]))["CEMAC-COBAC"]
plan = {str(c["code"]) for c in yaml.safe_load(open(sys.argv[3]))["accounting-norm"]["comptes"]}
adds, nf = {}, []
for p in miss:
    d = [c for c in src if c.startswith(p)]
    if not d: nf.append(p); continue
    adds.update({c: src[c] for c in d})
for c in list(adds):
    for l in range(2, len(c)):
        a = c[:l]
        if a not in plan and a not in adds and a in src: adds[a] = src[a]
adds = {c: l for c, l in adds.items() if c not in plan}
json.dump(adds, open(sys.argv[4], "w"), ensure_ascii=False, indent=0)
print(len(adds), "à ajouter ; non trouvés:", " ".join(nf))
