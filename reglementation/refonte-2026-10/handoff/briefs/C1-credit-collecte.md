# C1 : collecte des données réglementaires du module crédit (vague 1 du plan de collecte). Modèle sonnet

Lis d'abord `COMMUN.md` (même dossier), puis le plan `<WT>/sfd-docs/reglementation/REPORTING_PLAN_COLLECTE.md` (lots C1 et K1) et `<WT>/sfd-docs/reglementation/cemac-beac/reporting.md`, section « Complément 2026-10-23 : barème… R-2017/07 ». `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`. Lis aussi `sfd-credit-service/CLAUDE.md` et `sfd-angular/CLAUDE.md`.

## Branches
- `sfd-credit-service` : `feature/reporting-refonte-collecte-credit`, créée depuis `feature/reporting-refonte` (= develop 9fa6ecc).
- `sfd-angular` : `feature/reporting-refonte-collecte-credit`, créée depuis `feature/reporting-refonte` (47c374a3), uniquement pour les écrans du point 5.

## Travail
Ajouter des endpoints de lecture dans le controller reporting existant du crédit (`credit/reporting/controller/ReportingController.java`), avec le même `@PreAuthorize` que les endpoints `/reporting/bceao/*`. Chaque endpoint accepte `codeAgence` (facultatif : sans agence, on consolide) et `dateArrete` (facultatif, aujourd'hui par défaut). Sa réponse comporte `aLaDateDuJour: true` quand la donnée est un instantané. Les agrégats passent par des requêtes GROUP BY, jamais par une boucle N+1, et restent portables PG/MSSQL/MySQL.

1. **`GET /reporting/risques/top?n=10`** : encours par client, du plus grand au plus petit. Seuls les statuts d'encours sont retenus (DECAISSE, EN_COURS, EN_RETARD, IMMOBILISE, DOUTEUX, CONTENTIEUX, RESTRUCTURE). Pour chaque client : `codeClient`, `encours`, `nbDossiers`. Le type de client n'est pas fourni : le reporting le récupère via le service client.
2. **`POST /reporting/encours/clients`** (body `{codesClient: [...]}`) : encours cumulé et détail par client. Le lot K1 et la clé DIMF-2013 s'en serviront.
3. **Taux** : `GET /reporting/taux?periodeDebut=&periodeFin=` renvoie le min, le max et la moyenne pondérée du **taux nominal annuel** et du **TEG** sur les dossiers décaissés dans la période.
   - Décision D3 : **enregistrer le TEG au décaissement**. Nouvelle colonne `teg` (Liquibase) sur `DossierCredit`, ou sur `DecaissementCredit` s'il y a des tranches. Elle est calculée avec la méthode actuarielle existante (`SimulationServiceImpl.calculerTaegActuariel` : extraire un calcul commun, ne pas dupliquer). Elle est renseignée au décaissement et figée ensuite.
   - Restructuration et consolidation : le taux d'origine est conservé (champ `tauxInteretAnnuelInitial` ou historique), car il est aujourd'hui écrasé.
   - Les dossiers sans TEG (antérieurs) sont exclus des statistiques TEG et comptés à part : `nbSansTeg`.
4. **Retards et agents** :
   - `GET /reporting/retards/tranches` : CRD et nombre de dossiers par tranche de `joursRetard` (1-30, 31-90, 91-180, 181 et plus), et le total si au moins 1 jour.
   - `GET /reporting/emprunteurs-par-gestionnaire` : emprunteurs actifs et encours par gestionnaire.
   - Normaliser `DossierCredit.agentCredit` vers `GestionnaireCredit`, par une colonne `gestionnaireCreditId` alimentée par une migration de rapprochement sur `code`. Les dossiers non rapprochés partent dans « NON_RATTACHE » et sont signalés. `agentCredit` n'est pas supprimé.
5. **Provisions COBAC R-2017/07** (CEMAC) :
   - Ajouter `categorieCobac` sur `ProduitGarantie` : `G1_G2` (espèces, gages d'espèces, titres d'État), `G3_G5` (contre-garantie d'établissement de crédit CEMAC, garantie multilatérale, sûretés réelles et hypothèques de 1er ou 2e rang), `NON_ELIGIBLE` (cautions personnelles et autres). Valeur par défaut `NON_ELIGIBLE`.
   - Ajouter un champ de sélection sur l'écran Angular de paramétrage du produit de garantie, avec les composants partagés et l'i18n fr/en/ln.
   - Ajouter `dateDeclassementDouteux` sur le dossier. Il est renseigné par `ClassificationService` au premier passage en DOUTEUX, et remis à null au retour en sain. Ne pas l'écraser s'il est déjà renseigné. Reprise des données existantes : utiliser l'historique de classification s'il existe, sinon la date de la migration, à signaler.
   - Endpoint **`GET /reporting/provisions-cobac?dateArrete=`** : pour chaque contrepartie douteuse (contagion à tout l'encours du client, art. 9), calculer la part couverte G1_G2 (0 %), la part couverte G3_G5 (25/50/75/100 % selon l'année écoulée depuis `dateDeclassementDouteux`, art. 17-2b), et la part non couverte (100 %). La couverture est plafonnée à l'encours.
   - La réponse donne le total requis, le détail par client et par catégorie, et `provisionsConstituees`, issu de la donnée existante du module (à citer).
   - Le calcul est écrit en fonction pure, avec des tests chiffrés : une créance de 3 ans couverte G3_G5 donne 75 %, une créance sans garantie 100 %, et un cas de couverture partielle.
6. Aucun compte en dur. Aucune modification des écritures comptables.

## Fini quand
- `scripts/claude/regress.sh sfd-credit-service` donne 0 échec (baseline → après) et `regress.sh sfd-angular` donne BUILD OK.
- Le service crédit démarre sans profil sur une base démo jetable (`/actuator/health` UP, migrations Liquibase passées). Chaque endpoint est appelé en HTTP et ses valeurs sont recoupées avec l'écran crédit (encours d'un client, classe de risque). Ensuite, arrêter le service et supprimer la base.
- Vérification dans le navigateur de l'écran produit de garantie : choix de la catégorie, puis enregistrement et relecture.
- Handoff `reporting-refonte-collecte-credit.md` : DTO exacts de chaque endpoint (pour le branchement R1), migrations, section « Points à valider ». Commits sur les branches, rien poussé. Rapport au format fixe à l'orchestrateur.

## Note pour R1 (orchestrateur)
S10 laisse CEMAC JT18, KL19 et VL08 en SAISIE, et CS02 sur `/rapports/provisions`, qui applique l'ancien barème. R1 doit les rebrancher sur `GET /reporting/provisions-cobac` (C1) :
- CS02 = provisions requises ;
- JT18, KL19 et VL08 = max(0, requis − constituées).
