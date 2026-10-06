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
