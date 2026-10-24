# S2 — Localisation backend, paramètres et cloisonnement (lot 1) — modèle sonnet

Lire d'abord `COMMUN.md` (même dossier) et le contrat v1.1, sections 1 à 3 (Paramètres, Localisation, Formules).

## But
Le module reporting charge les paquets de `src/main/resources/localisation/`, déjà générés par l'orchestrateur et présents sur la branche, à la façon des l10n d'Odoo : modèle versionné, instancié en base, personnalisable et réinitialisable. Il cloisonne tout par la zone et le pays de l'institution.

## Branches
- `sfd-reporting-service` : `feature/reporting-refonte-localisation` (existe déjà = fd3e413, contient les paquets ; worktree sans `-b`).
- `sfd-commun-service` : `feature/reporting-refonte-localisation` (à créer).

## Travail (sfd-reporting-service)
1. `LocalisationRegistry` :
   - parser une seule fois au démarrage `localisation/*/package.yml`, `rapports/*.yml` et `pays/*.yml` ;
   - construire une map immuable par zone, avec un checksum SHA-256 par rapport et par ligne, et la surcharge pays appliquée (ajouter, modifier, désactiver) ;
   - aucune entrée/sortie de fichier ensuite.
   Il remplace `config/ActiveZoneRegistry` et le catalogue codé en dur de `ReglementaireCatalogueService.java:145-177`, qui doit lire le registre et la base. Les `zones/*.yml` ne sont plus chargés : les supprimer s'ils ne sont plus référencés.
2. Entité `ReportingParametre` (singleton) avec ses champs DTO du contrat :
   - `zoneCode`, `paysCode`, `modeSource` (INTEGRE par défaut), `versionPaquet`, `categorieAssujetti`, en-tête, signataires ;
   - alimentée par `SetupReportingController` `/setup/init` (zoneCode, paysCode) ;
   - repli au démarrage sur `IntegrationClient.getOrganisation()` et `paysSiegeCode` si vide ;
   - mapping des codes zone du wizard : `UEMOA-BCEAO` → UEMOA-BCEAO, `CEMAC-BEAC` → CEMAC-COBAC, `RDC-BCC` → RDC-BCC ; secteur ENTREPRISE ou ASSOCIATION → OHADA.
3. Entité `RapportDefinition` et extension de `RapportFormule`, selon la section 1 « Instanciation » du contrat :
   - champs `paysCode`, `origine`, `checksumPaquet`, `versionPaquet` et champs de ligne ;
   - synchro MISSING au démarrage et à chaque changement de version ;
   - jamais d'écrasement d'une ligne PERSONNALISEE ou AJOUTEE.
   Réutiliser et adapter `FormuleSyncService` et `ZoneReglementaireMigration`. Base : `ddl-auto: update`, pas de Liquibase dans ce service. Ajouter des colonnes nullables ou avec défaut, sans contrainte CHECK, en dialecte portable PG, MSSQL et MySQL.
4. Endpoints du contrat :
   - `GET/PUT /parametres` et `GET /localisation` ;
   - formules : `GET /rapports/{code}/formules`, `GET/PUT/DELETE /formules/{id}`, `POST /rapports/{code}/formules`, les réinitialisations (formule, rapport, tout), `GET /formules/{id}/historique` (table d'historique simple), `GET /rapports/{code}/references` ;
   - `/formules/valider` et `/formules/apercu` peuvent renvoyer 501 dans ce lot : S4 les implémente.
   - Supprimer `POST /formules/zones/active`, `GET /formules/zones`, `DELETE /formules/vider` et `POST /formules/sync`.
5. **Cloisonnement** : toutes les requêtes sont filtrées par zone et par `(pays null | pays de l'institution)` ; un id ou un code hors périmètre renvoie 404. Ajouter un test de régression dédié : une formule d'une autre zone, lue par id, renvoie 404.
6. Rôles inchangés (voir le contrat, section 4). Chercher tous les appelants des méthodes publiques modifiées (grep, y compris le monolithe `sfd-erp-monolith` en lecture) et signaler les impacts.

## Travail (sfd-commun-service)
`WizardInitOrchestrator` : ajouter `paysCode` (et le secteur) à l'appel `/setup/init` du reporting, avec test.

## Périmètre
- Modifiables : `sfd-reporting-service` (config, entity, repository, service et controller de localisation, paramètres et formules, avec leurs tests) et `sfd-commun-service/.../setup/WizardInitOrchestrator*` avec son test.
- Exclus (lot S4) : le moteur `FormulaEngineService`, `DataCollectorService`, `RapportEditionServiceImpl` (génération), l'import de balance et les exports. Si leur compilation casse, faire l'adaptation minimale nécessaire et la signaler.

## Terminé quand
- `scripts/claude/regress.sh sfd-reporting-service` : 0 échec, avec la baseline notée (environ 460 tests au départ). Pareil pour `sfd-commun-service`.
- Le service démarre sans profil sur une base de démo jetable : `/actuator/health` UP, et les 4 zones chargées dans le log (nombre de rapports par zone).
- `GET /localisation` pour une institution Togo (UEMOA) ne renvoie que l'UEMOA, avec la surcharge TG.
- Commits sur les deux branches `feature/reporting-refonte-localisation`, et handoff `reporting-refonte-localisation.md`.

## Compléments (2026-10-23, orchestrateur)
- La branche `feature/reporting-refonte-localisation` est à jour en **313a0e9** : paquets et variante UEMOA. Contrat v1.1, commit sfd-docs 484b58d.
- **Variantes UEMOA** : `package.yml` contient `variantes: {defaut: ALLEGEE, parCategorie: {ART44: DEVELOPPEE}}`. Le registre expose, pour chaque ligne, les comptes effectifs selon `ReportingParametre.categorieAssujetti` : `comptesAllegee` si la variante est ALLEGEE et que ce champ existe, sinon `comptes`. Les drapeaux `aConfirmerArt44` et `planEdipIncomplet` sont conservés dans `RapportFormule` et le DTO, l'UI en fait des badges.
- **Paquet CEMAC** : 5 comptes cités sont introuvables dans le PCEMF (389, 4651, 5818, 634, 7140), probablement une erreur du Lot 0. Vérifie chaque ligne concernée contre `sfd-docs/reglementation/cemac-beac/reporting.md`. Si la ligne parle d'autre chose, corrige le compte, mais seulement avec une source. Sinon, marque la ligne `confiance: BASSE` avec une note. Le plan PCEMF à jour se trouve sur `sfd-comptabilite-service` `feature/reporting-refonte` (05a8c5a), en lecture seule.
