-- =====================================================================
-- EDIP - Masquage des codes OTP / PIN deja ecrits en clair dans le
-- journal des notifications (table notif_journal).
--
-- Contexte : depuis notification-api b8d5a17 (commun 41fdcc9, portail-client
-- 4094dc5, agent-mobile 1b5d271) les nouveaux envois sont journalises avec
-- le code remplace par •••••• (voir MasquageJournal). Ce script traite
-- l'historique d'une installation existante. Rejouable : une 2e execution
-- ne trouve plus rien a masquer.
--
-- Ne modifie QUE le champ contenu_message des lignes dont le texte est un
-- message OTP/PIN reconnu par son GABARIT (pas de regex aveugle sur 6 chiffres).
-- Gabarits couverts :
--   SMS portail client      "Votre code EDIP : <code>. Valable ..." / "Your EDIP code: <code>. Valid for ..."
--   SMS PIN agent mobile    "Votre code PIN EDIP: <pin>. Agent: ..." / "Your EDIP PIN code: <pin>. Agent: ..."
--   SMS code de verification "<Institution>: votre code de verification est <code>. Il expire dans ..."
--   E-mail code de verification (sujet "Code de verification ...") : "... est : <code> Il expire ..."
--     (texte brut ou HTML ; portails client / employe, mot de passe oublie)
-- Si un nouveau gabarit OTP apparait, l'ajouter dans masquer_otp() ET dans MasquageJournal/gabarits.
--
-- ---------------------------------------------------------------------
-- PARTIE 1 : PostgreSQL  (psql -U <user> -d <base> -v backup=notif_journal_backup_otp_AAAAMMJJ -f masquage-otp-journal.sql)
-- ---------------------------------------------------------------------
-- NB : avec Hibernate, la colonne contenu_message (@Lob sur TEXT) ne contient pas
-- le texte mais l'OID d'un large object ; le texte est dans pg_largeobject.
-- Le script masque en creant un NOUVEAU large object et en repointant la ligne ;
-- l'ancien large object (en clair) reste uniquement pour la sauvegarde.
-- Si la colonne contient directement du texte (autre installation), il est traite tel quel.
-- Necessite un role pouvant lire/creer des large objects (superuser ou lo_compat_privileges).
-- ---------------------------------------------------------------------
\set ON_ERROR_STOP on
\if :{?backup}
\else
  \echo 'Passer -v backup=notif_journal_backup_otp_AAAAMMJJ'
  \quit
\endif

BEGIN;

-- Texte reel du message (large object ou texte direct)
CREATE FUNCTION pg_temp.texte_journal(v text) RETURNS text LANGUAGE sql STABLE AS $$
  SELECT CASE
           WHEN v ~ '^[0-9]{1,10}$' AND EXISTS (SELECT 1 FROM pg_largeobject_metadata WHERE oid = v::oid)
             THEN convert_from(lo_get(v::oid), 'UTF8')
           ELSE v
         END
$$;

-- Remplace le code par •••••• selon le gabarit ; tout autre texte est rendu inchange
CREATE FUNCTION pg_temp.masquer_otp(c text, sujet text) RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE WHEN c IS NULL THEN NULL ELSE
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
      CASE WHEN coalesce(sujet, '') ~* '^Code de v.rification'
           THEN regexp_replace(c,
                  '(v.rification[^:]{0,80}:\s*(?:<[^>]*>\s*)*)[A-Za-z0-9]+((?:\s*<[^>]*>)*\s*(?:Il expire|It expires))',
                  E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2', 'i')
           ELSE c END,
      '^(Votre code EDIP : )[^ ]+(\. Valable )',                    E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2'),
      '^(Your EDIP code: )[^ ]+(\. Valid for )',                    E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2'),
      '^(Votre code PIN EDIP: )[^ ]+(\. Agent: )',                  E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2'),
      '^(Your EDIP PIN code: )[^ ]+(\. Agent: )',                   E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2'),
      '^([^\n]{1,80}: votre code de verification est )[^ ]+(\. Il expire dans )', E'\\1\u2022\u2022\u2022\u2022\u2022\u2022\\2')
  END
$$;

-- Lignes concernees (texte different apres masquage)
CREATE TEMP TABLE otp_a_masquer ON COMMIT DROP AS
SELECT j.id,
       pg_temp.texte_journal(j.contenu_message) AS clair,
       pg_temp.masquer_otp(pg_temp.texte_journal(j.contenu_message), j.sujet) AS masque
  FROM notif_journal j
 WHERE pg_temp.masquer_otp(pg_temp.texte_journal(j.contenu_message), j.sujet)
       IS DISTINCT FROM pg_temp.texte_journal(j.contenu_message);

-- Sauvegarde : copie complete de la table + texte clair des seules lignes modifiees
-- (a supprimer, ainsi que les anciens large objects, une fois le resultat valide : voir PARTIE 3)
CREATE TABLE :"backup" AS
SELECT j.*, a.clair AS contenu_clair_sauvegarde
  FROM notif_journal j LEFT JOIN otp_a_masquer a ON a.id = j.id;

-- Application : nouveau large object (ou texte direct) contenant le message masque
UPDATE notif_journal j
   SET contenu_message = CASE
         WHEN j.contenu_message ~ '^[0-9]{1,10}$'
              AND EXISTS (SELECT 1 FROM pg_largeobject_metadata WHERE oid = j.contenu_message::oid)
           THEN lo_from_bytea(0, convert_to(a.masque, 'UTF8'))::text
         ELSE a.masque END
  FROM otp_a_masquer a
 WHERE a.id = j.id;

-- Controles (a lire avant le COMMIT)
SELECT (SELECT count(*) FROM notif_journal)            AS lignes_total,
       (SELECT count(*) FROM otp_a_masquer)            AS lignes_masquees,
       (SELECT count(*) FROM notif_journal j JOIN :"backup" b USING (id)
         WHERE j.id NOT IN (SELECT id FROM otp_a_masquer)
           AND (j.contenu_message IS DISTINCT FROM b.contenu_message
                OR j.sujet IS DISTINCT FROM b.sujet
                OR j.destinataire IS DISTINCT FROM b.destinataire))  AS autres_lignes_modifiees_doit_etre_0,
       (SELECT count(*) FROM notif_journal j
         WHERE pg_temp.masquer_otp(pg_temp.texte_journal(j.contenu_message), j.sujet)
               IS DISTINCT FROM pg_temp.texte_journal(j.contenu_message)) AS otp_restants_en_clair_doit_etre_0;

COMMIT;

-- ---------------------------------------------------------------------
-- PARTIE 2 : SQL Server (monolithe) - sqlcmd -d <base> -i ... ; remplacer @sauv par le nom voulu
-- contenu_message est de type text (texte direct, pas de large object) : on travaille en varchar(max).
-- Executer dans l'ordre. Les motifs ci-dessous utilisent PATINDEX/CHARINDEX (pas de regex native).
-- ---------------------------------------------------------------------
/*
BEGIN TRAN;

-- 2.1 sauvegarde complete (stopper si la table existe deja)
SELECT * INTO notif_journal_backup_otp_AAAAMMJJ FROM notif_journal;

DECLARE @masque nvarchar(10) = NCHAR(8226)+NCHAR(8226)+NCHAR(8226)+NCHAR(8226)+NCHAR(8226)+NCHAR(8226);

-- 2.2 SMS : le code est entre un prefixe et un suffixe fixes du gabarit (DATALENGTH : LEN ignore les espaces finaux)
DECLARE @g TABLE (pre varchar(100), suf varchar(100));
INSERT @g VALUES
 ('Votre code EDIP : ',                 '. Valable '),
 ('Your EDIP code: ',                   '. Valid for '),
 ('Votre code PIN EDIP: ',              '. Agent: '),
 ('Your EDIP PIN code: ',               '. Agent: '),
 (': votre code de verification est ',  '. Il expire dans ');

UPDATE j SET contenu_message = STUFF(m.txt, m.d, m.f - m.d, @masque)
  FROM notif_journal j
  CROSS JOIN @g g
  CROSS APPLY (SELECT CAST(j.contenu_message AS varchar(max)) AS txt) s
  CROSS APPLY (SELECT s.txt AS txt, CHARINDEX(g.pre, s.txt) AS p) a
  CROSS APPLY (SELECT a.txt AS txt, a.p + DATALENGTH(g.pre) AS d,
                      CHARINDEX(g.suf, a.txt, a.p + DATALENGTH(g.pre)) AS f) m
 WHERE j.type_canal = 'SMS'
   AND a.p BETWEEN 1 AND 81                 -- gabarit en debut de message
   AND m.f - m.d BETWEEN 1 AND 20           -- la valeur est un code court
   AND SUBSTRING(m.txt, m.d, m.f - m.d) <> CAST(@masque AS varchar(10));

-- 2.3 e-mails "Code de verification ..." : le code est le dernier mot avant "Il expire"
--     HTML : ...>CODE</p><p>Il expire     texte : ...<LF>CODE<LF><LF>Il expire
DECLARE @e TABLE (marqueur varchar(40), delim char(1));
INSERT @e VALUES ('</p><p>Il expire', '>'), (CHAR(10)+CHAR(10)+'Il expire', CHAR(10));

UPDATE j SET contenu_message = STUFF(m.txt, m.d, m.f - m.d, @masque)
  FROM notif_journal j
  CROSS JOIN @e e
  CROSS APPLY (SELECT CAST(j.contenu_message AS varchar(max)) AS txt) s
  CROSS APPLY (SELECT s.txt AS txt, CHARINDEX(e.marqueur, s.txt) AS f) a
  CROSS APPLY (SELECT a.txt AS txt, a.f AS f,
                      CASE WHEN a.f > 1 THEN CHARINDEX(e.delim, REVERSE(LEFT(a.txt, a.f - 1))) ELSE 0 END AS r) b
  CROSS APPLY (SELECT b.txt AS txt, b.f AS f, CASE WHEN b.r > 0 THEN b.f - b.r + 1 ELSE 0 END AS d) m
 WHERE j.type_canal = 'EMAIL' AND j.sujet LIKE 'Code de verification%'
   AND m.d > 0
   AND m.f - m.d BETWEEN 1 AND 20
   AND SUBSTRING(m.txt, m.d, m.f - m.d) <> CAST(@masque AS varchar(10));

-- 2.4 controles : nombre de lignes modifiees ; les autres lignes doivent etre identiques a la sauvegarde
SELECT COUNT(*) AS lignes_masquees
  FROM notif_journal j JOIN notif_journal_backup_otp_AAAAMMJJ b ON b.id = j.id
 WHERE CAST(j.contenu_message AS varchar(max)) <> CAST(b.contenu_message AS varchar(max));

COMMIT;   -- ou ROLLBACK si les controles ne conviennent pas
*/

-- ---------------------------------------------------------------------
-- PARTIE 3 : purge de la sauvegarde (apres validation, a la demande du client)
-- PostgreSQL : supprimer d'abord les anciens large objects en clair, puis la table
--   SELECT lo_unlink(b.contenu_message::oid) FROM :"backup" b
--    WHERE b.contenu_clair_sauvegarde IS NOT NULL AND b.contenu_message ~ '^[0-9]{1,10}$'
--      AND EXISTS (SELECT 1 FROM pg_largeobject_metadata WHERE oid = b.contenu_message::oid);
--   DROP TABLE :"backup";
-- Restauration (si besoin) : UPDATE notif_journal j SET contenu_message = b.contenu_message FROM :"backup" b WHERE b.id = j.id;
-- ---------------------------------------------------------------------
