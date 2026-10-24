# Handoff K1 : initiés, liens entre clients, groupes de risque (reporting réglementaire)

Branche `feature/reporting-refonte-collecte-client` (créée depuis `feature/reporting-refonte`), rien de poussé :
- `sfd-rh-service` 111ecf6 ; `sfd-client-service` cdb45ff ; `sfd-angular` 9dbff106, ede2737d, 89b778dd.
Pas de Liquibase dans ces services (Hibernate `ddl-auto: update`, comme le crédit) : tables `categorie_initie_client`, `lien_client`, `groupe_risque`, `groupe_risque_membre` créées au démarrage.

## DTO pour R1 (dates ISO, `codeClient` = `Client.numeroClient`)
- Client `GET /api/client/reporting/inities?dateArrete=` (défaut aujourd'hui ; rôles `ROLE_CLIENT_RAPPORT_READ|ROLE_CLIENT_ALL|ROLE_ADMIN`) :
  `{dateArrete, categories:{DIRIGEANT:[code], ADMINISTRATEUR:[code], PERSONNEL:[code], APPARENTE:[code]}, personnelRhIndisponible:boolean}`
  - Une période est active si `dateDebut <= date` et (`dateFin` nulle ou `>= date`). Un lien sans date est actif.
  - APPARENTE = saisies APPARENTE + clients liés (dans les deux sens) à un DIRIGEANT ou ADMINISTRATEUR actif à la date. Règle (revue opus) : par dérivation, un client déjà DIRIGEANT ou ADMINISTRATEUR à la date n'est pas ajouté en APPARENTE (pas de double comptage) ; une saisie APPARENTE manuelle est conservée.
  - PERSONNEL = saisies + employés RH en poste, dédoublonné. Si RH injoignable : `personnelRhIndisponible=true`, saisie seule. R1 doit alors mettre la ligne en ERREUR, pas 0.
- Client `GET /api/client/reporting/groupes-risque?dateArrete=` : `{dateArrete, groupes:[{code, libelle, motif: CONTROLE|DEPENDANCE_ECONOMIQUE|FAMILLE|AUTRE, membres:[code]}]}` (groupes sans membre actif à la date absents). Encours du groupe : `POST /api/credit/reporting/encours/clients` (C1) avec `membres`.
- RH `GET /api/rh/reporting/employes-clients?dateArrete=` : `{dateArrete, codesClient:[...]}` (`ROLE_RH_RAPPORT_READ|ROLE_RH_RAPPORT_ALL|ROLE_ADMIN`). Employé en poste : `codeClient` non vide, embauché à la date, et (`dateSortie` nulle et statut ≠ SORTI) ou `dateSortie >= date`. SUSPENDU compte comme en poste.
- CRUD (contrat complet : notes partagées `K1-contrat-api-client.md`) : `/{clientId}/initie-categories`, `/{clientId}/liens`, `/groupes-risque[/{id}[/membres[/{mid}/retrait]]]`. Codes d'erreur réels : `initie.chevauchement`, `initie.periode.invalide`, `initie.notfound`, `lien.meme-client`, `lien.notfound`, `groupe-risque.code-existant|non-vide|notfound|membre.notfound|membre-deja-actif|membre-deja-retire|membre-chevauchement`, `lien.doublon`, `lien.modification-client-a`.
- Appel RH : `RhEmployesClient` (client service), JWT de service forcé, `sfd.rh.base-url|connect-timeout|read-timeout` (défaut `http://localhost:4602/api/rh`, env `RH_SERVICE_URL`).

## Angular
Onglet « Initiés et liens » (fiche client, `client-detail-tab-inities-liens`), écrans `/client/groupes-risque` et `/client/groupes-risque/:id`, entrée de menu 1085, i18n fr/en/ln, specs `e2e/functional/client/client-inities-liens.spec.ts` et `client-groupes-risque.spec.ts`. Hors périmètre touché (signalé) : `layouts/shared-menu/menu.ts`, `core/utils/http-error.utils.ts`.

## Vérifications (2026-10-23)
- RH : 528 → 530 tests, 0 échec. Client : 1449 → 1466, 0 échec. Angular : BUILD OK (25 warnings, aucun sur les fichiers K1).
- Base démo jetable `sfd_k1` (baseline `latest`), client et RH lancés seuls (4598 / 4602), front construit servi derrière un proxy local :
  - HTTP : dirigeant, apparenté par lien conjoint, chevauchement refusé (400), lien à soi-même refusé, groupe de 2 membres, doublon de membre refusé, retrait daté (membre présent avant la date de fin, absent après) ; PERSONNEL = employé RH en poste (CLI004) sans doublon avec la saisie, employé sorti en 2025 exclu.
  - Navigateur : écran groupes de risque (création, ajout de 2 membres via le sélecteur client), onglet de la fiche client (catégorie et lien affichés, lien ajouté par la modale).
  - e2e : les 2 specs passent (4 passed avec setup/seed) contre cet environnement.
  - Base et processus supprimés.
- Non vérifié : RH réellement arrêté (couvert par test unitaire `RhEmployesClientTest`), suppression d'une catégorie/lien et retrait de membre dans le navigateur (couverts par les specs e2e), ln.json : d'autres clés COMPTABILITE.* manquent en lingala (préexistant).

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| Apparentés : quels liens comptent | tout `LienClient` actif (même type AUTRE/ASSOCIE) avec un dirigeant/administrateur ; pas de transitivité | brief K1, DIMF-2013 |
| Personnel de l'IMF : dirigeants/administrateurs comptés aussi en PERSONNEL ? | catégories indépendantes, un client peut figurer dans plusieurs | brief K1 |
| Employé sorti le jour de `dateSortie` | encore compté ce jour-là (`dateSortie >= date`) | cohérence avec `dateFin` inclusive |
| Employé SUSPENDU | compté en poste | statut RH |
| Source `RH` jamais persistée | PERSONNEL RH calculé à la volée, pas de ligne `source=RH` en base | brief : « sans doublonner une saisie » |
| Historique des liens | `dateDebut/dateFin` facultatives ; lien sans date = toujours actif | — |
| Suppression d'un groupe | refusée dès qu'il a eu un membre (historique des arrêtés passés) | — |
| Groupe de risque : cumul du bénéficiaire effectif / lien capitalistique | seule la liste de membres est stockée, sans pourcentage | plan CEMAC DA04/DB04 |

## Corrections de la revue opus (même jour)
- Propriétés `sfd.rh.*` (test de binding avec faux serveur HTTP ; l'ancien préfixe `app.rh.*` est ignoré).
- Ajout de membre : verrou d'écriture sur le groupe (`findByIdForUpdate`, portable, à la place d'un index unique partiel non portable MySQL/SQL Server/PostgreSQL) + refus si la période recouvre une appartenance existante (fin incluse) : `groupe-risque.membre-chevauchement`.
- Lien : modification refusée depuis le client B, orientation A→B jamais modifiée ; doublon (même paire, même type, deux sens, périodes recouvrantes) refusé ; APPARENTE sans double comptage ; rôle RH `ROLE_RH_RAPPORT_ALL`.
- `RhExceptionHandler` : ajout d'un handler `AccessDeniedException` → 403. Le handler générique transformait tout refus `@PreAuthorize` du RH en 500 (défaut préexistant, signalé hors périmètre strict K1, corrigé car le 403 de l'endpoint en dépend).
- Tests ajoutés : `@DataJpaTest` des 3 requêtes à la date, `@WebMvcTest` sécurité active (403 sans rôle) sur les 3 endpoints reporting, cas chevauchement, doublon et orientation.
- Angular : clé `ERRORS.GROUPE_RISQUE_MEMBRE_NOTFOUND` (renommée), + 8 clés d'erreur fr/en/ln.
- Tests : RH 528 → 533, client 1449 → 1483, 0 échec ; Angular BUILD OK (25 warnings). Pas rejoué dans le navigateur (aucun changement d'écran).
