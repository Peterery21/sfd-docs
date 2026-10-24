# PP : prepush complet de la refonte du reporting (sans push). Modèle sonnet

L'utilisateur a autorisé le push le 2026-10-24. **Ton travail s'arrête au prepush : tu ne pousses rien.** C'est l'orchestrateur qui pousse, dépôt par dépôt, une fois ton rapport reçu.

Avant de commencer, lis :
- `COMMUN.md`, dans le même dossier (verrou PID, ligne 18) ;
- le skill `prepush` et `.claude/docs/prepush.md` ;
- `.claude/docs/env-test.md`.

## Branches à valider (SHA à ne pas modifier)
| Dépôt | Branche | SHA |
|---|---|---|
| sfd-commun-service | feature/reporting-refonte | 8e0b9ab |
| sfd-comptabilite-service | feature/reporting-refonte | d7c01c3 |
| sfd-comptabilite-service | feature/roles-comptables-cemac-rdc | c2735cb |
| sfd-credit-service | feature/reporting-refonte | 6606a20 |
| sfd-epargne-service | feature/reporting-refonte | 46a2316 |
| sfd-transfert-service | feature/reporting-refonte | 32f4c2c |
| sfd-caisse-service | feature/reporting-refonte | d74583d |
| sfd-client-service | feature/reporting-refonte | 5dc80eb |
| sfd-rh-service | feature/reporting-refonte | ed97ee3 |
| sfd-reporting-service | feature/reporting-refonte | 7bea88e |
| sfd-erp-monolith | feature/reporting-refonte | 8aa1449 |
| sfd-angular | feature/reporting-refonte | d5ed31ef |

Pour chaque dépôt, travaille dans un worktree **détaché** sur le SHA indiqué : `git -C /Users/pierreadopre/Projects/erp-sfd/<repo> worktree add --detach <wt>/<repo> <SHA>`. Ne touche jamais au checkout principal, qui est utilisé par d'autres sessions.

## Règles impératives
- **Base de données** : ne démarre jamais un service sur la base `sfd`. Crée une base jetable `sfd_prepush_refonte` dans `pg_container`, puis pointe chaque service dessus avec `DATABASE_URL`. Reprends `DATABASE_USER` et `DATABASE_PASSWORD` comme le fait `scripts/edip-env/edip-env.sh` (variables `PG_USER` / `PG_PASSWORD`), **sans jamais afficher leurs valeurs**. Supprime la base à la fin.
- **Maven** : utilise un dépôt Maven isolé, `cp -cR ~/.m2/repository /tmp/m2-pp`, avec `-Dmaven.repo.local=/tmp/m2-pp` partout. Installe les services dans l'ordre de dépendance avant le monolithe. Supprime le dépôt isolé à la fin. N'écris **jamais** dans `~/.m2`.
- `sfd-rh-service` n'a pas de `mvnw` : emprunte celui de `sfd-reporting-service` (copié puis retiré, sans le commiter).
- Lance un service à la fois, sous le verrou PID. Ne tue que tes propres PID : vérifie `ps -o command= -p <pid>` avant chaque `kill`.

## Étapes, pour chaque service dans l'ordre commun → compta (refonte, puis rôles) → crédit → épargne → transfert → caisse → client → RH → reporting
1. `./mvnw clean package -DskipTests -o -q`, avec le dépôt isolé : exit 0.
2. `scripts/claude/regress.sh <worktree>`, avec le dépôt isolé si besoin : ligne OK et 0 échec. Note le nombre de tests.
3. Démarrage **sans profil** sur la base jetable : `actuator/health` doit répondre `"status":"UP"` dans les 90 s. Le statut dégradé est accepté s'il est UP (RabbitMQ). Arrête ensuite le service.

## Monolithe
Installe les services dans `/tmp/m2-pp`, puis lance `./mvnw clean package -DskipTests -o` et la suite de tests (0 échec). Démarre ensuite le jar exec sur une base jetable : `/actuator/health` doit répondre UP.

## Angular et e2e
- `regress.sh sfd-angular` doit donner BUILD OK.
- `e2e:crud` : sur une base démo jetable (`edip-env.sh up pp-refonte --baseline r17`, puis `restart --jar <jar monolithe refonte>`, avec le front construit depuis l'Angular d5ed31ef, comme au Lot 6), lance `npm run e2e:crud` (au minimum `e2e:crud:reporting`, `compta`, `credit`, `epargne`, `client`, `caisse`). Attendu : 0 échec, et 0 skip injustifié sur ces modules.
- Lance ensuite l'e2e fonctionnel `e2e/functional/reporting-reglementaire` : 0 échec.
- Termine par `edip-env.sh down pp-refonte`.

## Sortie
- Un rapport au format fixe à l'orchestrateur (session local_7abf2d26-b8a4-41cc-87f8-5f2fb16d5104), sous forme d'un tableau par dépôt : `build | tests | UP | e2e`.
- Toute anomalie fait STOP : ne la corrige pas toi-même, décris-la précisément dans le rapport.
- Nettoyage final : bases jetables, `/tmp/m2-pp` et worktrees.
