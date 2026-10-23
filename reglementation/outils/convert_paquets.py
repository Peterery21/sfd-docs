"""Convertit les paquet-draft.yml (Lot 0) au format localisation/ du contrat v1."""
import sys, os, re, yaml
DOCS, OUT = sys.argv[1], sys.argv[2]
ZONES = {'uemoa-bceao': 'UEMOA-BCEAO', 'cemac-beac': 'CEMAC-COBAC', 'rdc-bcc': 'RDC-BCC', 'syscohada-sycebnl': 'OHADA'}
SENS = {'DEBIT': 'D', 'CREDIT': 'C', 'D': 'D', 'C': 'C', 'SOLDE': 'SOLDE', 'FLUX': 'SOLDE'}
HEAD = ('zone', 'regulateur', 'planComptable', 'version', 'pays', 'typesAssujettis', 'conventions', 'transmission',
        'sanctions', 'penaliteRetard', 'normesComplementaires', 'avertissements', 'devise', 'notesAnnexes', 'applicabiliteSFD')
def ligne(l, i):
    l = dict(l)
    if 'sens' in l and l['sens'] is not None: l['sens'] = SENS.get(str(l['sens']).upper(), l['sens'])
    if l.get('expression') == 'CROSS_SERVICE':
        l.pop('expression'); l['sourceDonnees'] = 'CROSS_SERVICE'
    if l.get('saisie') is True and not l.get('comptes') and not l.get('expression'): l['sourceDonnees'] = 'SAISIE'
    l.setdefault('ordre', (i + 1) * 10)
    return l
def rapport(r, nature_defaut='CALCULE'):
    r = dict(r)
    lay = r.get('layout') or 'GENERIC'
    r.setdefault('nature', 'DOCUMENT' if lay == 'DOCUMENT' else 'EXTERNE' if lay == 'EXTERNE' else nature_defaut)
    if r['nature'] == 'CALCULE' and not r.get('lignes') and not r.get('reprend'): r['nature'] = 'DOCUMENT'
    r['lignes'] = [ligne(l, i) for i, l in enumerate(r.get('lignes') or [])]
    return r
def fname(code): return re.sub(r'[^A-Za-z0-9_.-]', '_', str(code)) + '.yml'
def dump(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f: yaml.safe_dump(data, f, allow_unicode=True, sort_keys=False, width=200)
for src, zone in ZONES.items():
    d = yaml.safe_load(open(f'{DOCS}/{src}/paquet-draft.yml'))
    base = f'{OUT}/{zone}'
    pkg = {k: d[k] for k in HEAD if k in d}
    pkg['zone'] = zone; pkg['version'] = '2026.10.0'; pkg['sourceRecherche'] = f'sfd-docs/reglementation/{src}'
    dump(f'{base}/package.yml', pkg)
    seen = set()
    for r in d['rapports']:
        r = rapport(r)
        assert r['code'] not in seen, r['code']; seen.add(r['code'])
        dump(f'{base}/rapports/{fname(r["code"])}', r)
    for r in d.get('rapportsNonModelises') or []:
        r = rapport(r, 'EXTERNE'); r.setdefault('lignes', [])
        if r['code'] in seen: continue
        seen.add(r['code']); dump(f'{base}/rapports/{fname(r["code"])}', r)
    for cc, s in (d.get('surchargesPays') or {}).items():
        s = dict(s); s['pays'] = cc
        s['ajouter'] = [rapport(a, 'DOCUMENT') if isinstance(a, dict) else a for a in (s.get('ajouter') or [])]
        dump(f'{base}/pays/{cc}.yml', s)
    print(zone, len(seen), 'rapports', len(d.get('surchargesPays') or {}), 'pays')

# ---- Passe 2 : qualification déterministe des références (contrat v1.1) ----
import glob, collections
PREFIX = {'RESULTAT': 'SYSN-RESULTAT', 'BILAN_ACTIF': 'SYSN-BILAN-ACTIF', 'BILAN_PASSIF': 'SYSN-BILAN-PASSIF'}
ALIAS = {'CEMAC-COBAC': {'FPN': {'CAT1': 'CEMAC-REP-006.JT24', 'defaut': 'CEMAC-REP-007.KL25'}}}
report = collections.Counter()
for zdir in glob.glob(f'{OUT}/*/'):
    zone = zdir.rstrip('/').split('/')[-1]
    files = {f: yaml.safe_load(open(f)) for f in glob.glob(zdir + 'rapports/*.yml')}
    R = {r['code']: r for r in files.values()}
    defs = collections.defaultdict(list)
    for r in R.values():
        for l in r['lignes']:
            if l.get('code') and (l.get('comptes') or l.get('expression') or l.get('sourceDonnees')): defs[l['code']].append(r['code'])
    alias = ALIAS.get(zone, {})
    known = sorted({l['code'] for r in R.values() for l in r['lignes'] if l.get('code')} | set(alias), key=len, reverse=True)
    for f, r in files.items():
        loc = {l.get('code') for l in r['lignes']}
        for l in r['lignes']:
            e = l.get('expression')
            if not isinstance(e, str): continue
            for a, b in PREFIX.items(): e = re.sub(rf'\b{a}\.', b + '.', e)
            out, i = [], 0
            while i < len(e):
                m = re.match(r'([A-Za-z][A-Za-z0-9_]*(?:-[A-Za-z0-9_]+)*)\.([A-Za-z0-9_]+(?:-[A-Za-z0-9_]+)*)', e[i:])
                if m and m.group(1) in R: out.append(m.group(0)); i += m.end(); continue
                if e[i:i+3] in ('MIN', 'MAX') and e[i+3:i+4] == '(': out.append(e[i:i+3]); i += 3; continue
                if e[i:i+5] == '[N-1]': out.append('[N-1]'); i += 5; continue
                hit = next((k for k in known if e.startswith(k, i) and (i + len(k) == len(e) or not (e[i+len(k)].isalnum() or e[i+len(k)] == '_'))), None)
                if not hit or not e[i].isalpha(): out.append(e[i]); i += 1; continue
                if hit in alias: out.append('@' + hit); report['alias'] += 1
                elif hit in loc: out.append(hit)
                elif len(set(defs[hit])) == 1: out.append(f'{defs[hit][0]}.{hit}'); report['qualifiée'] += 1
                else: out.append(hit); report['NON RÉSOLUE ' + hit] += 1
                i += len(hit)
            l['expression'] = ''.join(out)
        dump(f, r)
    if alias:
        pkg = yaml.safe_load(open(zdir + 'package.yml')); pkg['alias'] = alias; dump(zdir + 'package.yml', pkg)
print(dict(report))
