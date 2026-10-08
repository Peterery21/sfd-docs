# Monolithe — base SQL Server existante avec données (option B)

Décision utilisateur : le monolithe **garde ses données SQL Server** et démarre toujours sur SQL Server (valeurs par défaut
`DATABASE_URL=jdbc:sqlserver://…`). Il est devenu multi-moteur : passer à PostgreSQL = changer `DATABASE_URL/USER/PASSWORD/DRIVER`.

À vérifier / faire avant de redéployer le monolithe sur la base existante :
1. Sauvegarde (`scripts/01-backup-sqlserver.sh`).
2. CHECK d'enum figés : exécuter `monolithe-sqlserver-check-cleanup.sql` **après relecture** (inventaire puis DROP générés). Sans cela, l'ajout d'une valeur d'enum fera échouer des INSERT.
3. `ecriture_en_attente_contrepartie.version` : corriger les `NULL` (voir script, §3a).
4. `ddl-auto: update` crée les nouveaux index (renommés) ; les anciens restent (inoffensifs).
5. Le monolithe a été remis à niveau (fixers retirés, libs alignées, configuration complétée) : il ne démarrait plus contre les derniers jars. Tests de schéma sur les 3 moteurs : voir le commit « feat(db): monolithe multi-BD ».
6. Angular `sfd-angular-monolith-dev` : l'image déployée est ancienne (49-SNAPSHOT contre 288 pour `sfd-angular-dev`) ; reconstruire le job `sfd-angular-monolith` après la fin de la migration et vérifier la connexion, le setup et une opération par domaine dans le navigateur.
