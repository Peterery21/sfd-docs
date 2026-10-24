# S1 — Rapprochement des plans comptables EDIP avec les paquets (lot 1bis) — modèle sonnet

Lire d'abord `COMMUN.md` (même dossier).

## But
Compléter les plans comptables EDIP, pour que chaque compte cité par les paquets de localisation existe avec le bon libellé et le bon sens. Sans cela, les états réglementaires restent faux.

## Entrées
- Paquets (comptes cités) : `sfd-reporting-service` sur la branche `feature/reporting-refonte` (fd3e413), `src/main/resources/localisation/{UEMOA-BCEAO,CEMAC-COBAC,RDC-BCC}/rapports/*.yml`, champs `comptes` et `comptesAllegee`. Lecture seule.
- Sources réglementaires :
  - `<WT>/sfd-docs/reglementation/uemoa-bceao/reporting.md` (RCSFD développé, PDF : https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf) ;
  - `cemac-beac/reporting.md` (PCEMF janv. 2010, beac.int) ;
  - `rdc-bcc/reporting.md` (PCCI, Instr. 002/006).
- Plans actuels : `sfd-comptabilite-service/src/main/resources/config/accounting-norms/{uemoa/rcs_sfd,cemac/cobac,rdc/pcci}/plan-comptable*.yml`.

## Travail
1. Écrire un script de diff : la liste des comptes cités par les paquets qui sont absents du plan EDIP (un préfixe est couvert si un compte du plan commence par lui). Ordre de grandeur actuel : environ 230 manquants en UEMOA, environ 150 en CEMAC, 2 en RDC (2510, 255).
2. Pour chaque compte manquant, l'ajouter au bon plan :
   - avec le numéro, le libellé officiel, le parent et la classe, selon le format YAML existant du fichier ;
   - **seulement si la source réglementaire le donne** (RCSFD développé, PCEMF, PCCI) ;
   - sinon, le lister comme « non trouvé » dans le handoff, sans l'inventer.
3. UEMOA, version développée et version allégée :
   - les comptes du développé absents du plan doivent être ajoutés comme sous-comptes ;
   - ne pas casser les comptes existants de l'allégée ;
   - ne jamais renuméroter ni supprimer un compte existant, car des écritures et des rôles comptables (`roles-comptables.yml`) y pointent.
4. CEMAC : vérifier les classes PCEMF (30 LT, 31 MT, 32 CT, 33 souffrance, 37 ordinaires, 39 provisions). Signaler toute contradiction avec le plan EDIP actuel sans la corriger en force (décision métier) ; la consigner dans le handoff.
5. Les comptes ajoutés doivent être chargeables par le loader existant : trouver qui lit `plan-comptable*.yml` (grep), le setup ou le wizard, et le test qui le couvre.

## Périmètre
- Modifiables : `sfd-comptabilite-service/src/main/resources/config/accounting-norms/**/plan-comptable*.yml`, plus les tests de chargement du plan dans `sfd-comptabilite-service/src/test/**`.
- Exclus : `roles-comptables.yml` (le lire, ne pas le modifier), le code Java du moteur de comptabilisation, `sfd-reporting-service`, les autres services.

## Terminé quand
- Script de diff relancé : 0 compte manquant non justifié. Les restants sont listés « non trouvé » avec la source consultée.
- `scripts/claude/regress.sh sfd-comptabilite-service` : 0 échec. Baseline et résultat notés.
- Commit sur `feature/reporting-refonte-plans`.
- Le handoff `reporting-refonte-plans.md` donne, par zone, le nombre de comptes ajoutés, les « non trouvé », les contradictions, et le chemin du script de diff.
