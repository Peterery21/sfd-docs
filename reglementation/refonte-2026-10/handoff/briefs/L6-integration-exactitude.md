# Lot 6 : intégration, e2e et exactitude des données de la refonte du reporting. Modèle sonnet ; l'orchestrateur fait ensuite une revue finale opus.

Commence par lire `COMMUN.md` (même dossier ; règle du verrou PID à la ligne 18). Lis aussi `.claude/docs/env-test.md` et le skill `prepush`. Côté métier, lis `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md`, `REPORTING_POINTS_A_VALIDER.md` et le handoff de chaque lot dans `<WT>/.claude/handoff/`. `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches d'intégration (`feature/reporting-refonte`, rien n'est poussé)
| Dépôt | SHA |
|---|---|
| commun | e2fb0ab |
| compta | 1112917 |
| crédit | 3a102db |
| épargne | ba48f0a |
| transfert | dee880f |
| caisse | f67d0f4 |
| client | c20101f |
| RH | 12af30c |
| reporting | a286ba1 |
| monolithe | a2cf5a1 |
| angular | 0ef93b6a |

Les autres dépôts du monolithe restent sur `develop`. Ne modifie aucune de ces branches. Si tu dois corriger quelque chose, crée `feature/reporting-refonte-l6-<sujet>` dans le dépôt concerné et signale-le dans le rapport.

## Règle impérative : le dépôt Maven est isolé
`~/.m2` est partagé avec d'autres sessions. N'y installe **aucun** artefact de la refonte. Tu as 75 Go libres sur le disque.
1. `cp -cR ~/.m2/repository /tmp/m2-refonte` : clone APFS, quasi gratuit.
2. Toutes tes commandes Maven prennent `-Dmaven.repo.local=/tmp/m2-refonte`.
3. Pour chaque dépôt listé ci-dessus, crée un worktree **détaché** sur le SHA indiqué, puis lance `./mvnw -o -q install -DskipTests -Dmaven.repo.local=/tmp/m2-refonte`, dans l'ordre lib → services → monolithe. Le constat de départ à corriger : la suite monolithe échoue (33 erreurs, `SetupReportingLoader` exige `ZoneReportingLoader`), parce qu'elle lisait le jar reporting de `develop` présent dans `~/.m2`.
4. Supprime `/tmp/m2-refonte` et les worktrees détachés à la fin.

## Étapes
1. **Suites.**
   - `regress.sh` sur chaque service listé, avec le dépôt isolé (passe-le via `MAVEN_OPTS` ou les arguments de `regress.sh`) : 0 échec.
   - Suite du monolithe : 0 échec.
   - `regress.sh sfd-angular` : BUILD OK.
   - Note, pour chaque dépôt, la mesure de départ et la mesure finale.
2. **Jar du monolithe** construit avec le dépôt isolé (exec jar), et front construit depuis l'Angular 0ef93b6a (`build-front` ; voir env-test.md).
3. **Bases de démo jetables**, sous verrou et après `resources.sh 2048` :
   - UEMOA (TG) : `edip-env.sh up rep-uemoa --baseline <rN>`, puis `restart --jar <jar refonte>`.
   - CEMAC (CM) et RDC (CD) : `baseline-create ... --jar <jar refonte> --pays CM|CD` si aucune baseline n'existe. Paramètres de reporting : zone, pays, mode INTEGRE.
   - Une base à la fois si la RAM est inférieure à 6 Go.
4. **e2e** : `e2e/functional/reporting-reglementaire/` en entier, ainsi que les e2e des écrans ajoutés :
   - catégorie COBAC des garanties ;
   - Banque, type de contrepartie ;
   - auxiliaire Participation ;
   - initiés et liens de la fiche client ;
   - groupes de risque.
   Objectif : 0 échec et aucun skip injustifié.
5. **Vérifications reportées** (HTTP et navigateur interne) :
   - les 6 endpoints C1 ;
   - les endpoints T1 et K1 ;
   - l'écran de catégorie COBAC ;
   - le capital ST01 ;
   - la classe 9 ajoutée sur une base existante (`POST /setup/init`) ;
   - le personnel alimenté par le RH.
6. **Exactitude** (navigateur interne, comme un utilisateur), pour chaque zone :
   - générer le bilan, le compte de résultat, un état d'indicateurs et les ratios ;
   - pour un échantillon d'au moins 10 lignes par zone, recalculer la valeur à la main (balance compta, écrans crédit, épargne, client) et la comparer à l'édition ;
   - vérifier aussi : bilan équilibré, résultat du compte de résultat égal au résultat du bilan, totaux = somme des détails, signe du hors-bilan, provisions COBAC (requises/complémentaires) cohérentes avec l'écran crédit ;
   - consigner chaque écart dans un tableau « ligne | édition | recalcul | écart | cause ».
7. **Parcours sans aide** : sur la page Formules, modifier une formule (bloc « solde des comptes » et un indicateur), consulter l'aperçu, enregistrer, réinitialiser. Note toute friction.
8. **Cloisonnement** : une institution UEMOA ne voit aucun rapport ni aucune formule CEMAC, et inversement. Un id hors zone donne 404.
9. **Mode STANDALONE** : télécharger le modèle (présence des onglets annexes avec les nouvelles clés), importer, générer, puis l'export ZIP.

## Fin
- Arrête les services, supprime les bases, `/tmp/m2-refonte` et les worktrees détachés.
- Handoff `reporting-refonte-lot6.md` :
  - tableau des suites (départ → final) ;
  - résultats e2e ;
  - tableau d'exactitude par zone ;
  - écarts et leur cause ;
  - frictions UX ;
  - points à valider.
- Rapport au format fixe. Pas de push.
