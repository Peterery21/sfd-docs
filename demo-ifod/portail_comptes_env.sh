#!/bin/bash
# Variables de provisionnement des comptes du portail employé IFOD (sourcées par 01_start_stack.sh).
# Comptes : 8 employés + 3 managers (Patrick Mutombo, Alain Kalala, Solange Mbuyi), identifiés par matricule + e-mail pro.
# Mot de passe initial = motDePasseUtilisateurs (e2e/demo-ifod/data/agora.json, fixture de démo) ; jamais écrit dans ce fichier.
D=/Users/pierreadopre/Projects/erp-sfd/sfd-angular/e2e/demo-ifod/data
export APP_PORTAIL_PROVISIONING_COMPTES="$(python3 - <<PY
import json
emps={e['n']:e for e in json.load(open('$D/rh-employes.json'))}
managers={3,15,20}; agents=[6,7,8,10,11,13,14,16]
ag={'Siège Gombe':'AG001'}
out=[]
for n in sorted(managers|set(agents)):
    e=emps[n]
    out.append("IFOD-%04d|%s|%s|%s|%s"%(n,e['emailPersonnel'],e.get('telephonePersonnel','').replace(' ',''),'AG004' if n==8 else e.get('agence','AG001'),'true' if n in managers else 'false'))
print(';'.join(out))
PY
)"
export APP_PORTAIL_PROVISIONING_PASSWORD="$(python3 -c "import json;print(json.load(open('$D/agora.json'))['motDePasseUtilisateurs'])")"
