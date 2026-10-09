-- Inspection LECTURE SEULE de la base SQL Server restaurée (monolithe). Aucune écriture dans ce fichier.
-- Usage (depuis le VPS, mot de passe fourni par l'opérateur, jamais écrit ici) :
--   docker cp ce_fichier sql-server-dev:/tmp/i.sql
--   docker exec -it sql-server-dev /opt/mssql-tools18/bin/sqlcmd -S localhost -U <user> -C -d sfd -i /tmp/i.sql
SET NOCOUNT ON;
SELECT 'institution' t, COUNT(*) n FROM institution UNION ALL
SELECT 'agence', COUNT(*) FROM agence UNION ALL
SELECT 'users', COUNT(*) FROM users UNION ALL
SELECT 'plan_comptable', COUNT(*) FROM plan_comptable UNION ALL
SELECT 'journal', COUNT(*) FROM journal UNION ALL
SELECT 'setup_status', COUNT(*) FROM setup_status;
SELECT code, libelle FROM agence;
SELECT user_id, email, enabled FROM users;
