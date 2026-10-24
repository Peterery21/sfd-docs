# L6b : corrections issues du Lot 6 (exactitude, contrat, UX). Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier ; règle du verrou PID à la ligne 18), puis le handoff du Lot 6 `<WT>/.claude/handoff/reporting-refonte-lot6.md`. Il contient les tableaux d'exactitude, les frictions UX et les points à valider. `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
`feature/reporting-refonte-l6b`, créée depuis `feature/reporting-refonte`, dans `sfd-reporting-service`, `sfd-angular` et `sfd-epargne-service` (pour le point 6 seulement). Si les branches `-l6-libelle-clair` (reporting), `-l6-banques-url` (compta) et `-l6-wiring` (monolithe) sont déjà fusionnées quand tu commences, pars de la nouvelle tête. Sinon, empile tes commits sur `-l6-libelle-clair` pour le reporting.

## Exactitude (prioritaire)
1. **Caisse UEMOA allégée.** Dans `DIMF-2000-BIL.yml`, A01 et A11 ont `comptesAllegee: '1011'`. Or EDIP comptabilise la caisse sur 101000. Résultat : la caisse sort de la trésorerie et le bilan est déséquilibré de 16 170 000 sur la base démo. Décision orchestrateur, sur la règle utilisateur « UEMOA allégée = plan EDIP actuel » : passer à `comptesAllegee: '101'`, puisque la source RCSFD indique « 101/1011 ». Mettre à jour les deux assertions de test (`LocalisationRegistryTest:57`, `LocalisationCloisonnementTest:364`). Ajouter un test d'exactitude : une balance avec caisse 101000 doit donner A11 = caisse et un bilan équilibré.
   Ensuite, **contrôle systématique** : pour chaque ligne UEMOA `comptesAllegee` et `comptes`, vérifier que le préfixe atteint bien les comptes **mouvementés** par les modules, via les rôles comptables UEMOA `roles-comptables.yml` (caisse, banque, crédits, dépôts…) et pas seulement les comptes déclarés au plan. Corriger les mêmes cas de figure, chacun avec un test.
2. **CEMAC, préfixes absents du plan EDIP COBAC** : 389 (REP-015.HK05), 4651 (REP-001D.RP29), 5818 (REP-001A.EG44), 634 (REP-002C.ZP06), 7140 (REP-002B.YG09). Pour chacun : trouver le compte EDIP correspondant (même libellé, dans `accounting-norms/cemac/cobac/plan-comptable*.yml`) ou, à défaut, passer la ligne en avertissement explicite `absentPlan` (jamais un 0 silencieux). Ne jamais deviner par analogie : à défaut de correspondance sûre, l'inscrire aux points à valider.
3. **CEMAC 001B.RG34** « Formule non définie » : cette ligne bloque RG99 (total du passif) et tous les totaux dépendants. Chercher la formule dans la source du paquet (`<WT>/sfd-docs/reglementation/cemac-beac/`). Sinon, passer RG34 en SAISIE, pour que les totaux soient calculables avec une ligne en saisie et explicitement signalée.
4. **RDC `RDC-REP-029.PARTICIPATIONS`** : la formule `25` renvoie un montant alors que la norme est le ratio 0,25. Remplacer par `25 / FPP`, garder la note `aConfirmer`, ajouter un test.
5. **UEMOA IND-F03 / IND-F16** : les dotations T6K/T6L valent 0 alors que 664100 porte 200 000. Vérifier le poste du compte de résultat qui reçoit 664 (T6C/T6D ?) et la formule des indicateurs. Corriger si c'est une erreur de formule, sinon l'inscrire aux points à valider.
6. **ST05, encours des dépôts** (épargne) : `encoursDepotTotal` ne contient pas les DAT (entité `DepotATerme` séparée), et le calcul `autres = max(0, total − vue − terme)` masque l'écart. Vérifier le modèle : si les DAT ne sont pas dans `compte_epargne`, ajouter l'encours DAT au total et au détail terme (DTO rétrocompatible), avec des tests. Ajuster ST05 côté reporting si nécessaire.

## Contrat
7. `POST /editions/generer` avec un code hors périmètre, et `GET /editions/{id}` inexistant ou hors périmètre, doivent renvoyer **404** au lieu de 500. Ajouter les tests.
8. **Course au démarrage** : `POST /reporting/setup/init` lancé pendant la synchronisation échoue sur `uk_formule_rapport_zone_indicateur`. Rendre l'initialisation idempotente et protégée contre la concurrence (verrou ou capture de la violation suivie d'une relecture), avec un test.

## UX (frictions 1, 2, 4, 5, 7, 8 du handoff L6)
9. Écran Formules :
   - afficher la variante effective (allégée ou développée selon la catégorie) et `comptesAllegee`, pour que le libellé et l'aperçu concordent ;
   - un second bloc « Solde des comptes » doit insérer automatiquement l'opérateur `+` (pas d'erreur technique « Caractère inattendu ») ;
   - afficher `exclut` ;
   - bouton « Calculer » inactif : afficher la raison ;
   - afficher l'agence utilisée par l'aperçu.
10. Participation :
    - traduire l'erreur `participation.collectif.hors.norme` (`http-error.utils` + i18n fr/en/ln) ;
    - filtrer le sélecteur de compte sur les racines de participation de la norme (`app-compte-selector` avec filtre, ou endpoint des racines).

Respecte les composants partagés, l'i18n fr/en/ln et `ProcessingService`.

## Fini quand
- `regress.sh` donne 0 échec pour reporting et épargne, et `regress.sh sfd-angular` donne BUILD OK.
- Les nouvelles assertions d'exactitude chiffrées passent : bilan UEMOA équilibré sur une balance qui contient 101000.
- Passage dans le navigateur interne sur une base démo UEMOA jetable (dépôt Maven isolé `/tmp/m2-l6b`, comme au Lot 6, jamais dans `~/.m2`) : bilan équilibré, écran Formules corrigé. Supprimer ensuite la base et le dépôt isolé. Ne tuer que tes propres PID.
- Handoff `reporting-refonte-l6b.md`, avec une section « Points à valider ». Commits faits, rien poussé, rapport au format fixe.
