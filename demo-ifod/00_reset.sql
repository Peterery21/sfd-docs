-- Reset complet de la base ERP SFD (drop + recréation). DESTRUCTIF : toutes les données de `sfd` sont perdues.
-- Tous les services doivent être arrêtés avant. Une sauvegarde BACKUP DATABASE doit avoir été faite avant.
USE master;
IF DB_ID(N'sfd') IS NOT NULL
BEGIN
    ALTER DATABASE sfd SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE sfd;
END
CREATE DATABASE sfd;
