#!/usr/bin/env python3
"""Comptes cités par les paquets de localisation absents des plans EDIP.

Usage: diff-plans-paquets.py <dir localisation> <dir accounting-norms> [--json]
Un préfixe cité est couvert si un compte du plan commence par lui.
"""
import glob, json, os, re, sys
import yaml

ZONES = {
    "UEMOA-BCEAO": "uemoa/rcs_sfd",
    "CEMAC-COBAC": "cemac/cobac",
    "RDC-BCC": "rdc/pcci",
}
TOKEN = re.compile(r"^-?(\d+)(dr|cr)?$")


def cited(loc, zone):
    out = {}
    files = glob.glob(f"{loc}/{zone}/rapports/*.yml") + glob.glob(f"{loc}/{zone}/pays/*.yml")
    for f in files:
        doc = yaml.safe_load(open(f)) or {}
        stack = [doc]
        while stack:
            n = stack.pop()
            if isinstance(n, dict):
                for k in ("comptes", "comptesAllegee"):
                    v = n.get(k)
                    if isinstance(v, str):
                        for t in v.split(","):
                            m = TOKEN.match(t.strip())
                            if m:
                                out.setdefault(m.group(1), set()).add(os.path.basename(f))
                stack.extend(n.values())
            elif isinstance(n, list):
                stack.extend(n)
    return out


def plan_codes(norms, sub):
    codes = set()
    for f in glob.glob(f"{norms}/{sub}/plan-comptable*.yml"):
        doc = yaml.safe_load(open(f))["accounting-norm"]
        codes.update(str(c["code"]) for c in doc.get("comptes", []))
    return codes


def main():
    loc, norms = sys.argv[1], sys.argv[2]
    res = {}
    for zone, sub in ZONES.items():
        plan = plan_codes(norms, sub)
        miss = {c: sorted(r) for c, r in cited(loc, zone).items()
                if not any(p.startswith(c) for p in plan)}
        res[zone] = dict(sorted(miss.items()))
    if "--json" in sys.argv:
        print(json.dumps(res, indent=1))
    else:
        for z, m in res.items():
            print(f"{z}: {len(m)} manquants")
            print("  " + " ".join(m))


main()
