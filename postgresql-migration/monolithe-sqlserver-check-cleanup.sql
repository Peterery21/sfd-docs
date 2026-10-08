-- Monolithe SFD — base SQL Server EXISTANTE (option B: on garde les données).
-- Les fixers qui réécrivaient les CHECK d'enum ont été supprimés des services; les nouvelles versions de l'application ne créent
-- plus de CHECK sur les enums. Les CHECK déjà présents sur une base ancienne restent figés sur l'ancienne liste de valeurs:
-- ajouter une valeur d'enum ferait échouer les INSERT (erreur 547). Ce script LISTE puis GÉNÈRE les DROP. NE RIEN EXÉCUTER
-- sans accord; relire chaque ligne; exécuter dans une transaction après sauvegarde (01-backup-sqlserver.sh).

-- 1) Inventaire (lecture seule): CHECK qui ressemblent à des listes de valeurs d'enum générées par Hibernate
SELECT s.name AS schema_name, t.name AS table_name, cc.name AS constraint_name, cc.definition
FROM sys.check_constraints cc
JOIN sys.tables t  ON cc.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE cc.definition LIKE '%=''%'' OR %'      -- ([col]='A' OR [col]='B'...)
   OR cc.definition LIKE '%] IN (%'          -- variantes IN (...)
ORDER BY t.name, cc.name;

-- 2) Génération des DROP (lecture seule: copier le résultat, le relire, puis l'exécuter manuellement)
SELECT 'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ' DROP CONSTRAINT ' + QUOTENAME(cc.name) + ';' AS drop_statement
FROM sys.check_constraints cc
JOIN sys.tables t  ON cc.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE cc.definition LIKE '%=''%'' OR %'
   OR cc.definition LIKE '%] IN (%'
ORDER BY t.name, cc.name;

-- 3) Contrôles complémentaires proposés (lecture seule)
-- 3a) Lignes de comptabilité en attente sans version (colonne désormais NOT NULL côté entité):
-- SELECT COUNT(*) FROM ecriture_en_attente_contrepartie WHERE version IS NULL;   -- puis: UPDATE ... SET version = 0 WHERE version IS NULL;
-- 3b) Index d'ancien nom conservés après renommage (inoffensifs, à supprimer plus tard si souhaité):
--     idx_operation_(client|comptabilisee|date|numero|statut|type) sur operation_tontine, idx_paiement_date sur paiement_frais,
--     idx_zone_(code|parent|type) sur se_zone, idx_collecte_statut sur se_collecte, idx_decaissement_statut sur se_decaissement_projet,
--     idx_affectation_statut sur rh_affectation.
