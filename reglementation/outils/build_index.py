#!/usr/bin/env python3
"""Fusionne verification/*-verification.md dans les tables de règles et génère index.json + stats.
Usage: python3 outils/build_index.py [--apply]   (--apply réécrit la colonne vérification des fichiers)"""
import re, json, sys, pathlib, collections
root = pathlib.Path(__file__).resolve().parent.parent
apply = '--apply' in sys.argv
ZONES = {'uemoa-bceao': 'UEMOA-BCEAO', 'cemac-beac': 'CEMAC-BEAC', 'rdc-bcc': 'RDC-BCC', 'syscohada-sycebnl': 'OHADA'}
verd = {}
for vf in (root / 'verification').glob('*-verification.md'):
    for line in vf.read_text(encoding='utf-8').splitlines():
        c = [x.strip() for x in line.strip().strip('|').split('|')]
        if len(c) >= 2 and re.match(r'^[A-Z]+-[A-Z0-9]+-\d+', c[0]):
            m = re.search(r'[✔◐✘?]', c[1])
            if m: verd[c[0]] = (m.group(0), c[2] if len(c) > 2 else '')
CORRIGES = {'RDC-CLO-009','RDC-CPT-010','RDC-EPA-004','RDC-EPA-016','RDC-PSO-003','RDC-PSO-006','RDC-PSO-007','CEMAC-TUS-014','OHADA-CLO-009'}  # ✘ corrigés dans le texte après vérification, pas encore re-vérifiés
rows = []
idre = re.compile(r'^\|\s*([A-Z]+-[A-Z0-9]+-\d+)\s*\|')
for d, zone in ZONES.items():
    for f in sorted((root / d).glob('*.md')):
        lines = f.read_text(encoding='utf-8').splitlines()
        changed = False
        for i, line in enumerate(lines):
            if not idre.match(line): continue
            c = [x.strip() for x in line.strip().strip('|').split('|')]
            if len(c) < 6: continue
            rid = c[0]
            v = verd.get(rid, ('?', ''))[0]
            if apply and c[-1] != v:
                c[-1] = v; lines[i] = '| ' + ' | '.join(c) + ' |'; changed = True
            rows.append(dict(id=rid, zone=zone, theme=f.stem, fichier=f'{d}/{f.name}', regle=c[1][:300],
                             source=c[2], url=next((x for x in c[2:] if x.startswith('http')), c[3]), confiance=(re.search(r'HAUTE|MOYENNE|BASSE', ' '.join(c[3:])) or [c[4]])[0], statut=v, note_verif=verd.get(rid, ('', ''))[1][:300], corrige_apres_verif=rid in CORRIGES))
        if changed: f.write_text('\n'.join(lines) + '\n', encoding='utf-8')
(root / 'index.json').write_text(json.dumps(rows, ensure_ascii=False, indent=1), encoding='utf-8')
st = collections.defaultdict(collections.Counter)
for r in rows: st[r['zone']][r['statut']] += 1
print(f'{len(rows)} règles; verdicts reçus: {len(verd)}')
for z, c in st.items(): print(z, sum(c.values()), dict(c))
