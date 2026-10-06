# Handoff démo IFOD — préparer le VPS (état 2026-10-05)

## Déjà fait en LOCAL (via UI, specs Playwright rejouables: sfd-angular/e2e/demo-ifod, run: `rtk proxy npx playwright test -c playwright.demo.config.ts <spec>`, workers 1)
01 institution+logo+agences, 02 compta (plan PCCI, banques, mobile money, exercice 2026, journées), 03 épargne produits, 05 jours fériés RDC, 06 pays/zone, 10 RH paramétrage, 20 paie IFOD_RDC (simulation vérifiée), 50 Agora, 60 workflow. Données: e2e/demo-ifod/data/*.json.

## PAS fait
- Employés (24) + contrats liés aux grilles + photos : spec 30-rh-employes interrompu (état partiel, vérifier en base avant de rejouer)
- Clients + comptes épargne internes (6 internes/3 externes créés au moment de l'arrêt), spec 40-clients-epargne, mapping data/comptes-internes.json
- Paie: périodes oct 2025→sep 2026 (calcul/validation/comptabilisation/paiement), oct 2026 ouverte, avances, envoi bulletins (simulation)
- Portail employé: comptes + demandes
- Tests bout en bout Phase 4, rapport final

## Bloquants / prérequis pour le VPS
1. Déployer d'abord toutes les modifs (non commitées localement, branche feature/demo-ifod) : push dans l'ordre integration-api → workflow → épargne → rh → paie → portail-employe-service → sfd-angular → portail-employe-angular + commun, compta, agora, report-api; Jenkins SUCCESS avant chaque suivant. Corrections de la 2e session aussi à inclure.
2. Lib Java/commons/activity-tracking-starter-full : @Column(length=4000) sur AuditLog.roles non publiée. Sur VPS: soit rebuild/republier la lib, soit `ALTER TABLE dbo.audit_log ALTER COLUMN roles NVARCHAR(MAX) NULL` après le 1er démarrage.
3. Reset BD VPS = perte de toutes les données dev: BACKUP DATABASE d'abord, accord explicite requis. Script: 00_reset.sql (+ docker restart commun d'abord, purge MinIO erp-sfd/*, Meilisearch index agora, RabbitMQ vhost /sfd).
4. Ordre de démarrage: commun d'abord, workflow AVANT rh/paie. Après wizard: redémarrer compta, épargne, client, caisse.
5. Après tout redémarrage de rh: rejouer `60-workflow -g "définition"` (RH remet les définitions workflow aux modèles par défaut).
6. Meilisearch/RabbitMQ agora.events: vérifier côté VPS (host sfd-meilisearch-dev, clé master dans ~/pierre/meilisearch/.env).
7. Sécurité: mot de passe SMTP committé dans l'historique git de sfd-paie-service → à renouveler. Jenkinsfile portail-employe-service hostPort 4632 en conflit avec workflow dev sur le VPS.
8. Wizard VPS: mot de passe admin fort fourni par l'utilisateur (ne pas réutiliser le local).

## Défauts ouverts connus: sfd-docs/demo-ifod/DEFECTS_LOG.md
Notables: logo PDF rapports (sfd-report-api), schémas comptables épargne hors PCCI, approbateurs par groupe non résolus, paie service à (re)démarrer pour que les processus PAIE soient disponibles, comptes salaires internes dépendent des comptes épargne.


## MAJ 2026-10-05 (session suite) — specs à rejouer sur le VPS, dans cet ordre
- 30 (employés 24 + contrats), 35 (domiciliation interne, après 40), 40 (clients + comptes épargne ; dépend de la caisse/session ouverte 39), 31 (sanction seulement : `-g sanction`), 32/33 (congés, absences, HS, formations), 34/38 (recrutement), 36 (pointages), 37 (évaluations), 50 (Agora ; recherche : `AGORA_SEARCH=1 ... -g recherche`, Meilisearch requis), 60 (workflow ; rejouer `-g "définition"` après CHAQUE redémarrage de rh).
- **41 puis 42** (nouveau) : promotions/mutation lancées par le workflow (Démarrer un process), chaîne RRH→DGA→DG, « Appliquer » reporte salaire/poste/catégorie/échelon (promotion) et agence (mutation) sur le dossier. NE PAS rejouer 31 `-g promotion|mutation` (brouillons directs sans workflow).
- Code livré cette session (à déployer avec rh) : unicité employé (pièce, CNSS, e-mails) ; application promotion/mutation sur l'employé (statut VALIDEE requis) ; agora : réindexation Meilisearch au démarrage (`MeilisearchReindexRunner`) ; angular : promotion-edition lit l'employé par id si hors liste du store (`EmployeService.getById`).
- Données locales à corriger (hors UI, SQL refusé par le classifieur) : promotions 3/4 supprimées, mais 3 demandes appliquées à vide avant le correctif (promo IFOD-0011, IFOD-0014, mutation IFOD-0011) → sur le VPS elles ne seront pas créées (nouvelles cibles : promos IFOD-0010/0016, mutation IFOD-0008).
- Piège scripts : `restart_service.sh` lancé en tâche de fond puis tué par le timeout tue aussi le service → toujours `(nohup script > log 2>&1 < /dev/null &)`.
