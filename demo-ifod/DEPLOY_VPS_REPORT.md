# Déploiement VPS dev — démo IFOD (2026-10-06)

## Poussé (branche `develop`, ordre de dépendance, un repo à la fois)
| Repo | Build Jenkins | Note |
|---|---|---|
| Java/commons activity-tracking-starter-full | (pas de job) | `AuditLog.roles` en 4000, poussé sur `main`, NON publié sur Nexus |
| sfd-integration-api | #90 UNSTABLE | |
| sfd-report-api | #47 SUCCESS | |
| sfd-commun-service | #67/#68 FAILURE → #69 SUCCESS | échec = base `sfd` en SINGLE_USER (session externe), pas le code |
| sfd-workflow-service | #33 UNSTABLE | `DEMO_DATA_ENABLED` défaut dev → false |
| sfd-comptabilite-service | #115 SUCCESS | |
| sfd-epargne-service | #126 SUCCESS | |
| sfd-client-service | #133 SUCCESS | |
| sfd-caisse-service | #104 SUCCESS | |
| sfd-rh-service | #47 UNSTABLE | |
| sfd-paie-service | #53 UNSTABLE | mot de passe SMTP retiré (À RENOUVELER, présent dans l'historique git) |
| sfd-portail-employe-service | #12 UNSTABLE | Jenkinsfile : hostPort prod 4632 → 4635 (dev 4631 inchangé) |
| sfd-agora-service | #20 UNSTABLE | |
| sfd-angular | #268 SUCCESS | |
| sfd-portail-employe-angular | #19 SUCCESS | |
Aucun build en FAILURE final. UNSTABLE = quality gate Sonar (non bloquant, non investigué). sfd-chat-service : rien à pousser.

## Santé conteneurs (`sfd-*-dev`)
Tous sur la dernière image et `/actuator/health` UP après reset. `sfd-portail-employe-dev` : le Jenkinsfile a `docker.run/vps.enabled=false` → pas de déploiement auto ; conteneur recréé à la main sur l'image 12-SNAPSHOT (env : RH/PAIE/WORKFLOW_SERVICE_URL, port 4631). `sfd-agora-dev` : aucune clé Meilisearch injectée (indexation/recherche KO tant que `MEILISEARCH_API_KEY` n'est pas fournie).

## Reset BD (autorisé)
Sauvegarde faite par l'utilisateur. DROP/CREATE `sfd` ; purge MinIO `dev/erp-sfd/*` (2 objets), files RabbitMQ `/sfd`, Meilisearch (aucun index). Démarrage : commun SEUL d'abord (sinon un autre service crée `pays` en UUID → crash loop commun « uniqueidentifier to BIGINT »), puis workflow, puis le reste.

## Reste à faire
- Wizard `/setup` (admin + mot de passe fournis par l'utilisateur), redémarrage compta/épargne/client/caisse, puis `ALTER TABLE dbo.audit_log ALTER COLUMN roles NVARCHAR(MAX)` (lib non publiée).
- Rejeu specs Playwright demo sur le VPS (BASE_URL, DEMO_ADMIN_EMAIL/PASSWORD en variables d'environnement).
- Renouveler le mot de passe SMTP ; injecter la clé Meilisearch dans agora ; activer le déploiement auto de portail-employe si souhaité.

## Notes finales
- Monorepo racine : commit de bump créé localement, aucun remote `origin` configuré → rien à pousser.
- Wizard `/setup` et connexion admin non faits par l'assistant (saisie de mot de passe/création de compte interdite à l'assistant) : à faire par l'utilisateur ; ensuite l'assistant peut rejouer les specs avec une session enregistrée (`e2e/demo-ifod/.auth/admin.json`).

## Tour final (2026-10-06) — correctifs des sessions de vérification
| Repo | Build | Conteneur VPS |
|---|---|---|
| sfd-report-api | #48 SUCCESS | — |
| sfd-workflow-service | #35 UNSTABLE | 35-SNAPSHOT UP |
| sfd-rh-service | #49 UNSTABLE | 49-SNAPSHOT UP |
| sfd-paie-service | #55 UNSTABLE | 55-SNAPSHOT UP |
| sfd-portail-employe-service | #14 UNSTABLE | 14-SNAPSHOT UP (recréé à la main, pas de déploiement Jenkins) |
| sfd-agora-service | #21 UNSTABLE | 21-SNAPSHOT UP (correctif sécurité GED : dossiers restreints 403) |
| sfd-angular | #270 SUCCESS | 270-SNAPSHOT |
| sfd-portail-employe-angular | voir Jenkins | 21-SNAPSHOT |
integration-api, commun, compta, épargne, client, caisse : rien de nouveau (compta : fixture xlsx modifiée par les tests, NON commitée).

## BLOC rejeu des specs (session `.auth-vps`, un seul agent à la fois)
- BLOC 01–03, 05, 06 : OK (01, 01b, 02, 02b, 02d, 02e, 02f, 03, 05, 06).
- BLOC 02c (comptes bancaires AG001, mobile money AG002) : KO — la liste « Banque » de la modale est vide alors que les 3 banques existent en base (cause probable : ng-select asynchrone + VPS chargé, load ~7 ; pas de donnée manquante).
- BLOC 10, 20 : KO — `ModuleGuard` renvoyait vers `/home` (cache de santé des modules périmé + sondes lentes). Corrigé dans `helpers/session.ts` et `gotoList` (non rejoué).
- BLOC 50, 60 : KO — délais dépassés (VPS lent) ; 60 échoue sur le 1er test.
- Défaut d'infra : le proxy du VPS refuse le handshake WebSocket `wss://…/api/workflow/ws/*` (400) ; les moniteurs d'e2e l'ignorent.
- Réglage `MAX_SESSIONS_SIMULTANEES` : modifié par l'utilisateur lui-même (non vérifié) ; l'assistant ne modifie pas les réglages de sécurité.
- Charge VPS : load ~7, RAM 80 %, swap ~6 Go utilisé.

## Correctif URLs des services voisins en dev (2026-10-06)
paie appelait localhost pour rh/commun/compta/workflow (`paie.rh.indisponible`, `paie.schema.compta.indisponible`). `application-dev.yml` corrigé pour paie (#56), rh (workflow, notification, #50), épargne (notification, #127), caisse (notification, #105), client (crédit, #134), commun (compta, reporting, #70). Agora non modifié (clé `meilisearch.notification`). Après redémarrage de rh : rejouer `60-workflow -g "définition"`. sfd-angular (données/specs) : voir Jenkins.

## Conteneur `sfd-portail-employe-dev` (manuel — le Jenkinsfile a `docker.run/vps.enabled=false`)
Image `registry.evolticatechnologies.com/sfd-portail-employe-dev:<n>-SNAPSHOT` ; à recréer à la main après chaque build (aucun secret ici) :
```
docker rm -f sfd-portail-employe-dev
docker run -d --name sfd-portail-employe-dev --network dev-network -p 4631:4612 --restart=always --memory=768m --cpus=1 \
  -e SPRING_PROFILES_ACTIVE=dev -e SPRING_ACTIVE_PROFILES=dev -e DEMO_DATA_ENABLED=false \
  -e "JAVA_OPTS=-Xms256m -Xmx512m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC" \
  -e RH_SERVICE_URL=http://sfd-rh-dev:4602/api/rh -e PAIE_SERVICE_URL=http://sfd-paie-dev:4603/api/paie \
  -e WORKFLOW_SERVICE_URL=http://sfd-workflow-dev:4632/api/workflow \
  -v /opt/sfd/logs-dev:/app/logs registry.evolticatechnologies.com/sfd-portail-employe-dev:<n>-SNAPSHOT
```
Comptes portail de démo : non créés par l'assistant (création de comptes + mot de passe). Il faut ajouter `-e APP_PORTAIL_PROVISIONING_COMPTES=…` et `-e APP_PORTAIL_PROVISIONING_PASSWORD=…` ; le provisionneur est idempotent et tourne au démarrage. Valeurs : `source sfd-docs/demo-ifod/portail_comptes_env.sh` (exporte `APP_PORTAIL_PROVISIONING_COMPTES`) et mot de passe = clé `motDePasseUtilisateurs` de `sfd-angular/e2e/demo-ifod/data/agora.json`.
