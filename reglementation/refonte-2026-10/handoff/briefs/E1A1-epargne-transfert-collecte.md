# E1 + A1 : collecte des données réglementaires (épargne, transfert, caisse) — vague 1 du plan de collecte. Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier) et le plan `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md` (lots E1 et A1), puis les `CLAUDE.md` de chaque service touché. `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
Branche `feature/reporting-refonte-collecte-ope`, créée depuis `feature/reporting-refonte` (= develop), dans `sfd-epargne-service`, `sfd-transfert-service` et `sfd-caisse-service`.

## Règles communes
- Endpoints de lecture seule, sous le préfixe `/reporting` de chaque service. Le `@PreAuthorize` est celui des endpoints reporting existants : il y en a dans l'épargne (`epargne/reporting/controller/ReportingController.java`) ; ailleurs, copier le modèle de rôle de service.
- Paramètres : `codeAgence` (facultatif, consolidé s'il est absent), `periodeDebut`, `periodeFin`, ou `dateArrete`.
- Agrégats en GROUP BY, portables PG/MSSQL/MySQL.

## E1 — épargne
1. **`GET /reporting/taux-depots?periodeDebut=&periodeFin=`** renvoie le min, le max et la moyenne pondérée :
   - des taux DAT (`DepotATerme.tauxAnnuel`, ou `tauxDerogatoire` s'il est renseigné) sur les DAT constitués dans la période ;
   - des taux appliqués sur l'épargne (`HistoriqueInteretCompte.tauxApplique`) sur la période.
   Le détail est donné par produit.
2. Enrichir **`POST /reporting/encours-bceao`** avec le nombre de comptes actifs par type (vue, terme, épargne), en plus des clients actifs distincts. Ajouter des champs sans casser le DTO existant.

## A1 — transfert et caisse
3. Transfert : **`GET /reporting/operations?periodeDebut=&periodeFin=`** renvoie le nombre, `montantEnvoi` et `frais`, par `typeTransfert`, en distinguant émis et payés selon le statut et les dates. Exclure les transferts annulés ou rejetés.
4. Caisse : vérifier que les opérations `CHANGE` sont persistées avec un montant et une devise exploitables. Si oui, **`GET /reporting/operations-change?periodeDebut=&periodeFin=`** renvoie le nombre et le montant par devise et par sens (achat ou vente). Si non, ne crée rien : explique ce qui manque dans le handoff.
5. Assurance et mobile money ne sont pas concernés : ils restent en saisie manuelle (décision D2).

## Fini quand
- `scripts/claude/regress.sh <service>` donne 0 échec, baseline → après, pour chacun des 3 services.
- Chaque service démarre sans profil sur une base démo jetable, et chaque endpoint est appelé en HTTP. Les valeurs sont recoupées avec les écrans (liste des DAT, liste des transferts). Ensuite, arrêter les services et supprimer la base.
- Handoff `reporting-refonte-collecte-ope.md` : DTO exacts de chaque endpoint (pour le branchement R1) et section « Points à valider ». Commits sur les branches, rien poussé. Rapport au format fixe à l'orchestrateur.
