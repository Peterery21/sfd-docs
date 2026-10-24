# R1 : branchement des nouvelles données dans le reporting (vague 3 du plan de collecte). Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier ; verrou PID à la ligne 18) et le plan `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md`. Lis ensuite les handoffs des lots, dans `<WT>/.claude/handoff/`, qui donnent les DTO exacts :
- `reporting-refonte-collecte-credit.md` (C1)
- `reporting-refonte-collecte-ope.md` (E1+A1)
- `reporting-refonte-collecte-compta.md` (T1)
- `reporting-refonte-collecte-client.md` (K1)
- `reporting-refonte-restes.md` (S10 : état actuel de `ModulesProvider`)

Lis enfin la note « Note pour R1 » en fin de `C1-credit-collecte.md`.

`<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
- `sfd-reporting-service` : `feature/reporting-refonte-branchement`, depuis `feature/reporting-refonte`.
- `sfd-angular` : `feature/reporting-refonte-branchement`, depuis `feature/reporting-refonte`, uniquement pour le point 4.

## Travail
1. **Connecteurs.** Ajoute un appel par nouvel endpoint dans les connecteurs existants (`IntegrationClient` et `*ReportingConnector`), avec le même mode d'authentification, les mêmes timeouts et le même cache que l'existant. Un module en panne doit sortir en ERREUR explicite, jamais à 0.
2. **ModulesProvider.** Branche chaque clé CROSS_SERVICE des paquets UEMOA, CEMAC et RDC sur sa source, selon la table du plan :
   - **Plus gros risques** :
     - CEMAC DA02/DB02, UEMOA `plusGrosEncoursMembre`, RDC `plusGrosRisqueClient` et `plusGrosRisqueMembre` = top 1 de C1 `/reporting/risques/top`, plus le solde hors-bilan du même client (T1 `/reporting/hors-bilan/beneficiaires`).
     - Le type de client (personne physique, personne morale, groupe) vient du service client.
     - Les clés « membre » et « client » se distinguent selon le type de client. Si la règle n'est pas claire, consigne-la dans les points à valider.
   - **Risques de plus de 10 % des FPN** (CEMAC DA04/DB04) : encours cumulé par groupe de risque, via K1 `/reporting/groupes-risque` puis C1 `POST /reporting/encours/clients`. Un client sans groupe compte comme un groupe à lui seul. Garder les bénéficiaires au-dessus de 10 % de `@FPN` ; le plafond par client (PLAFOND_CLIENT) suit la même règle.
   - **Dirigeants, personnel et apparentés** (UEMOA DIMF-2013 I13_TOTAL) : K1 `/reporting/inities`, puis C1 `encours/clients`.
   - **Taux** (CEMAC ST08/ST09) : C1 `/reporting/taux` pour le TEG et le nominal (préciser lequel est retenu pour ST09, dans le paquet et le handoff), et E1 `/reporting/taux-depots`.
   - **Retards et agents** (RDC `crdEnRetard`, `emprunteursParAgentCredit`) : C1 `/reporting/retards/tranches` et `/reporting/emprunteurs-par-gestionnaire`.
   - **Provisions** :
     - CEMAC CS02 = provisions requises ;
     - JT18, KL19, VL08 = max(0, requis − constituées), via C1 `/reporting/provisions-cobac`. Elles quittent l'état SAISIE.
     - Ajoute un test chiffré qui vérifie que le FPN ne déduit pas le stock de provisions.
   - **Trésorerie et participations** : CEMAC ST07 vient de T1 `/reporting/tresorerie/contreparties`, PA02 de T1 `/reporting/participations`.
   - **Autres opérations** (UEMOA `institution.montantAutresOperations`) : somme des transferts (A1 `/reporting/operations`) et du change (A1 `/reporting/operations-change`). Assurance et mobile money restent en SAISIE (décision D2) : la ligne additionne ce qui est calculé et ce qui est saisi, si le format le permet ; sinon, note-le.
   - **Dépôts** : ST05, nombre de comptes, via E1 `encours-bceao`.
3. **Paquets YAML.** Mets à jour les lignes concernées : source CROSS_SERVICE et clé, retrait de SAISIE, et note `aConfirmer` gardée là où une décision comptable reste ouverte. Mets aussi à jour le modèle Excel STANDALONE pour que toutes ces clés figurent dans l'onglet « données annexes ».
4. **Angular, écran d'édition** :
   - un badge « donnée non renseignée » sur une ligne en ERREUR dont la cause est une saisie métier manquante (initié, groupe, catégorie COBAC…), avec le message du backend ;
   - un avertissement « valeur à la date du jour » quand l'édition porte sur une période passée et contient des données en instantané (`aLaDateDuJour`).
   Utilise les composants partagés, l'i18n en fr, en et ln.
5. **Recomptage** des lignes calculables par zone (`PaquetsCompletudeTest`).

## Fini quand
- `regress.sh sfd-reporting-service` donne 0 échec (baseline → après) et `regress.sh sfd-angular` BUILD OK.
- Les tests unitaires couvrent chaque clé branchée, avec un connecteur mocké et des valeurs chiffrées.
- La vérification runtime de bout en bout se fait au Lot 6 (orchestrateur), monolithe reconstruit : elle ne fait pas partie de R1.
- Handoff `reporting-refonte-branchement.md` : table « clé → source → champ », recomptage, points à valider. Commits faits, rien poussé, rapport au format fixe.
