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

## SPECS PRÊTS (session « suite » 2026-10-05/06) — rejeu VPS : `BASE_URL`, `DEMO_ADMIN_EMAIL`, `DEMO_ADMIN_PASSWORD`, `DEMO_USERS_PASSWORD` (mot de passe des comptes approbateurs/portail ; défaut = fixture locale agora.json → à surcharger sur le VPS), `PORTAIL_URL`
SPEC READY: 41-rh-carriere-workflow.spec.ts (passes locally; prérequis 30, 31 sanction, workflow définitions actives — `60-workflow -g définition` après chaque redémarrage de rh)
SPEC READY: 42-rh-carriere-approbations.spec.ts (passes locally; prérequis 41, 60 comptes approbateurs ; effet « Appliquer » exige sfd-rh-service avec correctif promotion/mutation)
SPEC READY: 70-paie-periodes.spec.ts (passes locally; prérequis 20 ; crée 13 périodes oct 2025→oct 2026 ; exige correctif angular filtre année/libellé)
SPEC READY: 72-paie-effet-retroactif.spec.ts (passes locally; prérequis 20 ; sur VPS 20 saisit déjà 01/01/2025 → no-op)
SPEC READY: 71-paie-calcul.spec.ts (passes locally; prérequis 70, 72, employés 30 ; annulation oct 2025 inutile sur VPS si paie corrigée déployée avant le 1er calcul)
SPEC READY: 75-compta-mobile-salaire.spec.ts (passes locally; prérequis 02c ; laisse Orange Money seul compte mobile actif par agence)
SPEC READY: 76-rh-domiciliation-faustin.spec.ts (passes locally; prérequis 30 ; sur VPS data/rh-employes.json crée déjà IFOD-0013 en mobile money → no-op)
SPEC READY: 73-paie-cloture.spec.ts (passes locally; prérequis 71, 75, 40/35 comptes épargne internes, journées ouvertes 02d, sfd-integration-api avec correctif AgenceHeaderInterceptor déployé dans paie ; DEMO_DATE_COMPTABLE=jj/mm/aaaa = journée ouverte)
SPEC READY: 74-paie-workflow.spec.ts (passes locally; prérequis 71, 60, comptes Grâce/Christine/Joseph ; septembre 2026 par workflow : à exclure de 73)
SPEC READY: 77-paie-avances.spec.ts + 78-paie-avances-approbations.spec.ts (pass locally; prérequis 71, 60 ; avance approuvée/décaissée IFOD-0010, refusée IFOD-0011)
SPEC READY: 79-paie-envoi-bulletins.spec.ts (passes locally; prérequis 74 ; envoi e-mail en SIMULATION)
SPEC READY: 80-portail-employe.spec.ts (passes locally ; NON idempotent : chaque rejeu crée de nouvelles demandes en cours — à jouer une seule fois ; prérequis 74, 60 (`60-workflow -g définition` APRÈS le correctif éditeur « Listes de valeurs autorisées » : portail.lookups employes pour congé/absence/mission/heures sup, déjà dans data/workflow.json) ; prérequis : service portail-employe avec correctifs (profil réel, notifications, bulletins publiés), Angular portail :4202, comptes via `sfd-docs/demo-ifod/portail_comptes_env.sh` (provisionnement par variables d'environnement APP_PORTAIL_PROVISIONING_* au démarrage du service — pas d'écran d'administration des accès).
Code à déployer en plus (cette session) : sfd-rh (unicité, application promo/mutation, libellés département/agence + backfill), sfd-paie (génération sans bulletin avant embauche, portail bulletins publiés, repli), sfd-workflow (tri mes-demandes), sfd-portail-employe (provisionner, profil sans démo, notifications), sfd-integration-api (AgenceHeaderInterceptor : ré-installer le jar), sfd-agora (réindexation Meilisearch), sfd-angular (périodes paie, génération, promotion-edition), portail-employe-angular (dates profil).

Code portail ajouté (à déployer) : portail-employe-angular (page de connexion « split card » validée sur maquette Stitch : carrousel, mémorisation de l'identifiant, aide RH ; présélection du champ « Employé » unique ; dates profil), sfd-angular (éditeur de processus : options des listes autorisées), sfd-rh (lookups portail `employes` par défaut pour congé/absence/mission/heures sup).
ORDRE DE REJEU COMPLET sur VPS : 01, 01b, 02, 02b, 02c, 02d, 02e?(optionnel), 02f, 03, 05, 06, 10, 20, 30, 39, 40, 35, 31 (sanction seulement), 32, 33, 34, 36, 37, 38, 50, 60 (-g groupes/comptes puis définitions), 41, 42, 70, 72, 71, 75, 76, 73 (jusqu'à août 2026), 74, 77, 78, 79, 80. Après tout redémarrage de rh : `60-workflow -g "définition"`.
SPEC READY: 43-rh-evaluation-360.spec.ts (passes locally; prérequis 30, 37 ; code requis : sfd-rh avec noms d'évaluateurs/source par défaut + handler 400 corps illisible, sfd-angular avec type d'évaluation `EVALUATION_360` ; le test « reprise » est sans effet sur une base neuve ; saisie des retours 360° non automatisable : réservée à l'évaluateur, aucun écran évaluateur)
SPEC READY: 39a-compta-auxiliaires.spec.ts (passes sur VPS; DOIT tourner avant 39 sur tout environnement neuf; génère comptes auxiliaires CDF AG001-AG004). Ordre: ... 30, 39a, 39, 40, 35 ...
