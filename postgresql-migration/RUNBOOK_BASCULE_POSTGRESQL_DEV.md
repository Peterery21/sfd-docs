# Runbook — bascule du VPS dev (services SFD) de SQL Server vers PostgreSQL

Statut : **préparé, NON exécuté**. Aucune commande de ce document n'a été lancée sur le VPS. Aucun secret n'y figure : les mots de passe
sont saisis au moment de l'exécution ou générés sur le VPS dans un fichier `chmod 600` hors dépôt.

## 0. État constaté (lecture seule)
- VPS `82.180.131.215`. Conteneurs applicatifs `sfd-<service>-dev` (21 services + `sfd-angular-dev`, `sfd-angular-monolith-dev`, portails Angular), réseau `dev-network`.
- SQL Server : conteneur `sql-server-dev` (2019), réseau `dev-network`, données `/home/ubuntu/pierre/sqlserver/sql-server` (volume hôte). **Il n'est jamais arrêté ni modifié.**
- PostgreSQL : un conteneur `pg_container` (postgres:15.2, port 5432) + `pgadmin4_container` **existent déjà** sur le VPS (réseau `postgres_default`, données `/home/ubuntu/pierre/postgres/data/postgresql`). Il n'y a donc **rien à installer** : on y crée un rôle applicatif et la base `sfd`, et on le rattache à `dev-network`.
- Le moteur d'un service est choisi par `DATABASE_URL` (le dialecte Hibernate est détecté, les `application-dev.yml` ont pour défaut SQL Server). Les Jenkinsfiles ne fixent pas la base ; le déploiement fait `docker run` avec `springEnv` + `--network dev-network`.
- Le backend du monolithe n'apparaît pas parmi les conteneurs en marche (seul `sfd-angular-monolith-dev:49-SNAPSHOT`, ancien).

## 1. Conditions d'entrée (toutes obligatoires)
1. Libs publiées : `security-oauth2` **3.11.1** (corrige `users.enabled bit` : sans cela aucune connexion sur PostgreSQL), `notification-api`, `chat-api` ; poms des services alignés (agora 3.7.0 → 3.11.1) ; builds Jenkins + Sonar verts.
2. P4 + 4 renommages d'index (`rh`, `suivi-evaluation`, `epargne`, `client`) + monolithe poussés, builds verts.
3. **Recette P7 verte en local** (voir §6).
4. Fenêtre de bascule validée par l'utilisateur ; aucune démo en cours.

## 2. Séquence (chaque étape : ce qu'elle fait / ce qu'elle risque / comment annuler)
Tous les scripts sont dans `scripts/`, en **simulation par défaut** (`--apply` pour agir), idempotents, et n'affichent jamais de secret.

| # | Commande (depuis le VPS) | Effet | Destructif ? | Annulation |
|---|---|---|---|---|
| 0 | `./scripts/00-preflight.sh` | contrôles en lecture seule (docker, conteneurs, réseau, ≥ 20 Go) | non | — |
| 1 | `SQLSERVER_SA_PASSWORD=… ./scripts/01-backup-sqlserver.sh` | `BACKUP DATABASE sfd` (COMPRESSION, CHECKSUM) + `RESTORE VERIFYONLY` + copie hors conteneur dans `/opt/sfd/backups/pre-pg/<horodatage>/` + SHA256 | non (crée des fichiers) | supprimer le dossier |
| 2 | `PG_ADMIN_PASSWORD=… ./scripts/02-prepare-postgres.sh` puis `… --apply` | rattache `pg_container` à `dev-network`, crée le rôle `sfd_app` et la base `sfd`, écrit `/opt/sfd/env/sfd-pg-dev.env` (600) | non (additif) | `DROP DATABASE sfd; DROP ROLE sfd_app; docker network disconnect dev-network pg_container` |
| 3 | `./scripts/03-switch-services-to-postgres.sh` puis `… --apply` | **première action intrusive** : pour chaque service, sauvegarde sa configuration d'exécution, arrête l'ancien conteneur, le renomme `<nom>-old`, lance le nouveau (même image, mêmes ports/volumes/réseau/limites) avec l'environnement PostgreSQL, attend `/actuator/health` = UP puis supprime l'ancien. Ordre : commun, compta, client, épargne, crédit, caisse, puis le reste. Arrêt au premier échec ; si le lancement échoue l'ancien conteneur est restauré | oui (recrée les conteneurs ; **aucune donnée supprimée**) | `./scripts/99-rollback.sh --apply` |
| 4 | `./scripts/04-verify.sh` | santé de chaque service et moteur utilisé (lecture seule) | non | — |
| 5 | Setup de la nouvelle institution (§6) | création des données de référence dans PostgreSQL | additif | recréer la base `sfd` (script de reset PG) |
| 6 | Persistance Jenkins (§5) | évite qu'un prochain déploiement Jenkins ne ré-aiguille un service vers SQL Server | oui (config CI) | revert du commit |

Notes :
- Durée estimée de l'étape 3 : ~21 services × 1–2 min (création du schéma au premier démarrage), **commun d'abord** (il crée `pays`, `institution`… et le démarrage concurrent des autres services pouvait provoquer des courses de création).
- `ddl-auto: update` crée le schéma ; les créations d'index en doublon (noms globaux sous PostgreSQL) ont été supprimées par les renommages ; le test de garde `EntityIndexNamesUniqueTest` du monolithe l'empêche de revenir.
- Rien n'est migré depuis SQL Server : la base PostgreSQL démarre **vide** (décision utilisateur). Les anciennes données restent dans SQL Server pour comparaison.

## 3. Retour arrière
`./scripts/99-rollback.sh --apply` recrée chaque conteneur depuis la configuration enregistrée à l'étape 3 (donc **sans** l'environnement PostgreSQL : retour aux valeurs par défaut `application-dev.yml`, c'est-à-dire SQL Server). SQL Server n'ayant jamais été arrêté, aucune restauration de données n'est nécessaire. La sauvegarde `.bak` n'est un filet que si SQL Server lui-même était endommagé (`RESTORE DATABASE … FROM DISK`). Le monolithe n'est pas concerné (il reste sur SQL Server avec ses données).

## 4. Garde-fous
- Un seul service à la fois, arrêt au premier échec, ancien conteneur conservé (`-old`) tant que le nouveau n'est pas sain.
- Aucun `rm`/`stop` sur `sql-server-dev`, `pg_container`, volumes ou répertoires de données.
- Mots de passe : saisis à l'exécution (`SQLSERVER_SA_PASSWORD`, `PG_ADMIN_PASSWORD`) ou générés (rôle applicatif) ; fichiers en `chmod 600` sous `/opt/sfd/env/` ; jamais dans git, journaux ou réponses.
- Les scripts ont été testés sur un conteneur factice local : sauvegarde de configuration, recréation avec surcharge d'environnement sans doublon de clé, rollback, garde-fou sur configuration absente, restauration de l'ancien conteneur en cas d'échec de lancement.

## 5. Persistance côté Jenkins (à décider)
Sans cette étape, le prochain build d'un service redéploie avec les valeurs par défaut (SQL Server) et annule la bascule pour ce service.
- **Option A (recommandée)** : dans `jenkins-blueprints` (`DockerUtils` / `javaMicroservicePipeline`), ajouter `--env-file /opt/sfd/env/sfd-pg-dev.env` aux arguments `docker run` en dev si le fichier existe. 1 dépôt à modifier, aucun secret dans git.
- Option B : `extraArgs: '… --env-file /opt/sfd/env/sfd-pg-dev.env'` dans les 21 Jenkinsfiles.
Après bascule validée, passer le défaut de `application-dev.yml` à PostgreSQL est facultatif (confort de lecture).

## 6. Recette « institution vierge » (P7) — à dérouler d'abord en local, puis sur le VPS
1. Base vide (`sfd` PostgreSQL) ; démarrer commun puis les autres services (ou `./dev.sh start <module>`).
2. Navigateur : assistant de démarrage → Institution, pays/zones, devises, agences, administrateur et rôles, plan comptable + schémas comptables, paramétrage des modules (`Setup*Loader`).
3. e2e : connexion, puis une opération par module central (client, épargne, crédit, caisse, comptabilité).
4. Reset de démo : `scripts/reset-database-pg.sh` (dropdb/createdb avec sauvegarde `pg_dump`) puis ressaisie de la démo IFOD.
Le compte initial est celui du setup ; ne jamais écrire son mot de passe dans le dépôt.

## 7. Monolithe
Reste sur SQL Server **avec ses données** (option B de l'utilisateur) : voir `monolithe-sqlserver-donnees-existantes.md` pour le nettoyage facultatif des CHECK d'enum existants (non exécuté sans accord). Il démarre sur PostgreSQL en changeant seulement `DATABASE_URL/USER/PASSWORD/DRIVER`.
