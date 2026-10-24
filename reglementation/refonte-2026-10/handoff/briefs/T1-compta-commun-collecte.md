# T1 : collecte compta et commun (hors-bilan par bénéficiaire, trésorerie par contrepartie, participations). Vague 1 bis, après la fusion de S10. Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier), puis le plan `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md` (lot T1) et `<WT>/sfd-docs/reglementation/uemoa-bceao/plan-classe9-hors-bilan.yml` (classe 9 et contreparties 98x). Lis aussi les `CLAUDE.md` de chaque service et `.claude/docs/compta-dual-line.md`. `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
- `sfd-comptabilite-service` : `feature/reporting-refonte-collecte-compta`, à partir de `feature/reporting-refonte`. La fusion de S10 doit y être, avec la classe 9 UEMOA.
- `sfd-commun-service` : `feature/reporting-refonte-collecte-compta`, à partir de `feature/reporting-refonte`.
- `sfd-angular` : `feature/reporting-refonte-collecte-compta`, à partir de `feature/reporting-refonte`. Uniquement pour les écrans de paramétrage.

## Travail
1. **Hors-bilan par bénéficiaire**
   - Un engagement par signature donné à un client (classe 9 : 903, 913 et leurs sous-comptes) doit pouvoir porter un auxiliaire client, avec `CompteAuxiliaire.codeClient`. Vérifier que la saisie d'écriture et l'API d'écriture l'acceptent déjà sur la classe 9. Sinon, l'autoriser, sans aucun compte en dur.
   - Endpoint **`GET /reporting/hors-bilan/beneficiaires?dateArrete=&codeAgence=&classes=903,913`** : solde par `codeClient` à la date, via une requête agrégée sur `LigneEcriture.codeAuxiliaire`.
2. **Trésorerie par contrepartie**
   - Commun : ajouter `typeContrepartie` sur `Banque` (`BANQUE`, `EMF`, `FAITIERE`, `AUTRE` ; valeur par défaut `BANQUE`). Migration Liquibase, DTO, et le champ dans l'écran Angular de paramétrage des banques (composants partagés, i18n fr/en/ln).
   - Compta : endpoint **`GET /reporting/tresorerie/contreparties?dateArrete=&codeAgence=`**. Il renvoie le solde comptable des `CompteBancaire` groupé par `typeContrepartie`, en récupérant le type de la banque via le commun avec le client inter-service existant. Les caisses (comptes de caisse du rôle comptable de la norme) sont lues dans les rôles, jamais en dur.
3. **Participations**
   - Ajouter le type d'auxiliaire `PARTICIPATION` (`TypeAuxiliaire`), avec l'entité émettrice et le pourcentage détenu (colonnes facultatives). Ajouter l'écran Angular de création de cet auxiliaire, en réutilisant l'écran des auxiliaires.
   - Endpoint **`GET /reporting/participations?dateArrete=`** : solde par auxiliaire PARTICIPATION sur les comptes de participation de la norme. Ces comptes sont lus dans le plan de la norme (CEMAC 26x, UEMOA 412, RDC 251/252), par leur rôle ou leur nature, jamais en dur.
4. Respecter `compta-dual-line.md` : aucun compte générique de repli, et chaque module ne publie que ses propres comptes.

## Fini quand
- `scripts/claude/regress.sh` donne 0 échec sur la compta et sur le commun (baseline → après), et `regress.sh sfd-angular` donne BUILD OK.
- Les services démarrent sans profil sur une base démo jetable. Pour chacun des trois cas, tu as saisi un exemple (engagement avec auxiliaire client, banque de type FAITIERE, auxiliaire PARTICIPATION), puis appelé l'endpoint en HTTP : la valeur doit être juste. Ensuite, arrête les services et supprime la base.
- Les écrans Banque et Auxiliaire ont été vérifiés dans le navigateur.
- Le handoff `reporting-refonte-collecte-compta.md` donne les DTO exacts (pour R1) et une section « Points à valider ». Tout est commité, rien n'est poussé. Envoie le rapport au format fixe.
