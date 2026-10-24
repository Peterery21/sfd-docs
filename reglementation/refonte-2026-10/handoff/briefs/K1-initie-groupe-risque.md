# K1 : initiés (dirigeants, personnel, apparentés) et groupes de risque. Vague 2, après la fusion de C1. Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier), puis le plan `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md` (lot K1), le handoff C1 `reporting-refonte-collecte-credit.md` (endpoint `POST /reporting/encours/clients`), et les `CLAUDE.md` des services `sfd-client-service`, `sfd-rh-service` et `sfd-angular`. `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
Branche `feature/reporting-refonte-collecte-client`, créée depuis `feature/reporting-refonte` dans `sfd-client-service`, `sfd-rh-service` et `sfd-angular`. Si `sfd-client-service` ou `sfd-rh-service` n'a pas encore de branche `feature/reporting-refonte`, crée-la depuis `develop`.

## Travail
1. **Initiés (client)**
   - Entité `CategorieInitieClient` : client, catégorie (`DIRIGEANT`, `ADMINISTRATEUR`, `PERSONNEL`, `APPARENTE`), `dateDebut`, `dateFin` et `source` (`SAISIE` ou `RH`). Un client peut porter plusieurs catégories dans le temps.
   - Table `LienClient` : client A, client B, type de lien (`CONJOINT`, `ENFANT`, `PARENT`, `FRERE_SOEUR`, `ASSOCIE`, `AUTRE`), dates.
   - Migrations Liquibase, endpoints CRUD et onglet « Initiés et liens » dans la fiche client Angular : composants partagés, `app-confirm-modal`, i18n fr/en/ln.
   - Endpoint **`GET /reporting/inities?dateArrete=`** : liste des `codeClient` par catégorie à la date. Les APPARENTE comprennent les clients liés par `LienClient` à un DIRIGEANT ou un ADMINISTRATEUR.
2. **Personnel automatique (RH)**
   - Endpoint **`GET /reporting/employes-clients?dateArrete=`** : `codeClient` des employés actifs à la date (`Employe.codeClient`).
   - Le service client l'appelle via le client inter-service existant pour compléter la catégorie PERSONNEL (source RH), sans doublonner une saisie manuelle.
3. **Groupes de risque (client)**
   - Entité `GroupeRisque` (code, libellé, motif : `CONTROLE`, `DEPENDANCE_ECONOMIQUE`, `FAMILLE`, `AUTRE`) et `GroupeRisqueMembre` (client, dates).
   - Écran Angular de gestion, avec liste, création, ajout et retrait de membres.
   - Endpoint **`GET /reporting/groupes-risque?dateArrete=`** : groupes et membres à la date.
   - Côté crédit, ne rien modifier : le reporting calcule l'encours d'un groupe avec `POST /reporting/encours/clients` (C1).

## Fini quand
- `scripts/claude/regress.sh` donne 0 échec sur client et RH (baseline → après) ; `regress.sh sfd-angular` donne BUILD OK.
- Sur une base démo jetable :
  - saisir un dirigeant, un apparenté et un groupe de risque de 2 membres dans le navigateur ;
  - appeler les endpoints en HTTP : PERSONNEL est alimenté par le RH ;
  - arrêter les services et supprimer la base.
- e2e Angular des deux écrans ajoutés.
- Handoff `reporting-refonte-collecte-client.md` : DTO exacts (pour R1) et section « Points à valider ». Commits faits, rien poussé. Rapport au format fixe.
