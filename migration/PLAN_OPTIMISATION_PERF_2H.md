# Migration de données — plan d'optimisation vers 2 h pour 50 M lignes (à reprendre plus tard)

> Document de reprise autonome. Décision du 2026-10-21 : ~3 h 15 accepté pour l'instant, la perf de l'itération 5 est poussée telle quelle ; ce plan sert quand on voudra viser 2 h.
> Source des mesures : note `L-PERF-iter5.md` (session perf itération 5), commits lib `8c2122d`, `b1a254a`, `3039826`, épargne `0b534eb`, crédit `2051aee` (branche `feature/migration-perf`).

## 1. Point de départ

| Mesure (machine dev 16 Go, PG 15 Docker, `shared_buffers` 128 Mo) | Valeur |
|---|---|
| Lot de référence | 1,98 M lignes (`generer_iter4.py`, 4 agences × 100 k clients), snapshot `sfd_pv400k` |
| Import (CHARGER + FINALISER) après étape 2 | ~480 s ⇒ ~4 100 lignes/s |
| dont FINALISER | ~94 s (compta 58, épargne 36 → 20 après étape 2) |
| Validation (hors import) | 296–350 s |
| Extrapolation 50 M | import ≈ 3 h 15 (linéaire), ≈ 2 h 50 (puissance 0,95) ; FINALISER seul ≈ 39 min |
| Cible 2 h pour l'import complet | ≥ 6 900 lignes/s ⇒ ~290 s à 1,98 M (−40 %) |

**Ambiguïté à trancher d'abord (P0)** : le plan d'origine dit « Performance FINALISER : 50 M lignes en moins de 2 h ». FINALISER seul est déjà à ~39 min. La cible « 2 h » vise-t-elle (a) FINALISER, (b) CHARGER + FINALISER, ou (c) validation + import ? (c) demande ~11 000 lignes/s : la validation seule dépasse 2 h à 50 M aujourd'hui.

## 2. Leviers classés (gain estimé à 1,98 M, sur la base ~480 s)

| # | Levier | Où | Gain estimé | Risque |
|---|---|---|---|---|
| L1 | Mesurer sur un serveur représentatif de la prod (NVMe, 8+ cœurs, PG non Docker, `shared_buffers` 25 % RAM, `max_wal_size` 8–16 Go, `checkpoint_timeout` 15 min, `wal_compression on`) | infra | ×1,3 à ×2 sur tout (à mesurer) | nul ; c'est peut-être suffisant à lui seul |
| L2 | Tables de staging `imp_*` en `UNLOGGED` (PG) : elles sont rejouables depuis les fichiers, le WAL est inutile | lib (DDL staging), SQL Server/MySQL : neutre | 10–20 % sur CHARGER | perte du staging sur crash PG ⇒ reprise du lot depuis les fichiers (déjà le cas en ÉCHEC) |
| L3 | Statut CHARGEE posé à l'insertion au lieu d'un `UPDATE` d'une colonne indexée (non HOT, ~60 s) ; à défaut `fillfactor` 80 sur les staging + index partiel | lib | ~60 s | moyen : la progression et la reprise lisent ce statut |
| L4 | `cible_id` des échéances (32 s, sert à l'annulation) : ids pré-alloués par séquence (`nextval` en masse) ou table de correspondance remplie par `INSERT … RETURNING` / clé naturelle | crédit | ~25 s | moyen : annulation exacte à reprouver |
| L5 | Compta FINALISER : soldes `compte_auxiliaire` en un seul `INSERT … SELECT … GROUP BY` (au lieu d'`UPDATE`), `INSERT ligne_ecriture` par `etapesFinalisation` en tranches ; index secondaires de `ligne_ecriture` suspendus puis recréés si le lot dépasse un seuil (PG seulement) | compta | ~25–30 s | moyen : pièces AN et auxiliaires à reprouver |
| L6 | Client `CLIENTS`, `PARTS_SOCIALES` : même méthode que l'étape 2 (fusion des UPDATE de résolution, plus de `beforeLoad` qui réécrit le staging) | client | ~20–40 s (à profiler) | faible |
| L7 | Datasets indépendants en parallèle (graphe de dépendances des contributeurs : stock, immo, RH en même temps que l'épargne), pool `PoolImport` à 4–6 connexions | lib | 15–30 % du temps total si les contributeurs lourds sont indépendants | élevé : verrous, ordre d'annulation, progression ; à faire en dernier |
| L8 | CHARGER par `COPY` (PG `CopyManager`) / bulk insert (SQL Server `SqlBulkCopy`-like, MySQL `LOAD DATA`) au lieu de lots JDBC | lib | 20–40 % sur l'écriture du staging | moyen : 3 implémentations par moteur |
| L9 | Validation : règles crédit de rapprochement balance (`INSERT INTO imp_erreur … JOIN` 85 s à 2 M) en agrégats préalables par agence/compte ; statistiques déjà rafraîchies (fait) | crédit + autres | ~60–100 s sur la validation | faible |

Somme réaliste sans L1 ni L7 : L2 ~50 + L3 60 + L4 25 + L5 25 + L6 30 ≈ 190 s ⇒ ~290 s ⇒ **≈ 2 h** pour l'import complet. Avec L1 la marge est confortable ; L7/L8 seulement si besoin.

## 3. Phases

### P0 — Cadrage et banc de mesure (½ j)
- Trancher la cible (§1 a/b/c).
- Banc reproductible : script qui restaure le snapshot `sfd_pv400k`, lance l'import par l'API sur une **copie privée** du jar monolithe (jamais `~/.edip-baselines/*/monolith.jar` : d'autres sessions le remplacent), port dédié avec garde sur le PID, et sort le tableau par dataset (journal des durées déjà ajouté par la lib) + `lignes_par_seconde`.
- Si possible, même banc sur un serveur de la cible (L1) : décider si la suite est nécessaire.

### P1 — Gains sans risque fonctionnel (1–2 j)
- L2 `UNLOGGED` (PG) ; L9 validation crédit ; réglages PG de session déjà en place (`app.import.pg.*`) revus sur le serveur cible.
- Preuve : mêmes résultats (md5 des comptes épargne, pièces AN équilibrées par agence, 0 écart auxiliaire), annulation exacte (photo des tables triée), suites lib + services 0 échec.

### P2 — Lib (2 j)
- L3 statut CHARGEE ; option L8 `COPY` pour PG d'abord (SQL Server/MySQL gardent le chemin actuel).
- Tests : reprise d'un lot en ÉCHEC au milieu d'une tranche, progression exacte, tests Testcontainers PG/SQL Server/MySQL (itération 5).

### P3 — Contributeurs (2–3 j, un écrivain par dépôt, en parallèle)
- Crédit L4, compta L5, client L6. Chacun : profil `pg_stat_statements` / `log_min_duration_statement`, réécriture, mesure avant/après sur le banc, résultats identiques.

### P4 — Parallélisme des datasets (optionnel, 3 j)
- L7 seulement si P1–P3 (et L1) ne suffisent pas.

## 4. Règles à respecter (rappel)
- SQL portable PG/SQL Server/MySQL ; toute optimisation propre à PG est conditionnée au moteur et neutre ailleurs.
- `CAST` typés y compris dans CASE/COALESCE ; pas de `LIMIT/TOP/UPDATE…FROM`.
- Jamais de `mvn install` de la lib dans `.m2-migration-repo` pendant que d'autres sessions testent : repo Maven séparé (`~/.m2-migration-perf`).
- Commandes lourdes via `~/.edip-heavy/heavy.sh` ; pas de run 50 M sur la machine de dev.
- Chaque phase : push un dépôt à la fois (lib d'abord, snapshot Nexus, puis services), Jenkins/Sonar/VPS vérifiés entre chaque.

## 5. Critère de fin
Tableau avant/après par dataset sur le banc, extrapolation 50 M ≤ 2 h pour la cible tranchée en P0, résultats fonctionnels identiques, annulation exacte, suites 0 échec, preuve navigateur d'un lot complet 01→10 sur base vide.
