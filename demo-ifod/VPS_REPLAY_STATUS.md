[vps-rh] 00-vps-sessions: OK (read-only) MAX_SESSIONS=20, INVALIDER_ANCIENNE; marker created 02:00
[vps-rh] 02c: OK (spec fixed: bank ng-select pick instead of fill; monitor ignores 50x on agora-notifications) 8m
[vps-agora] 50-agora run1: users+? 2 passed (28 min, VPS slow), groupe sécurité KO modal reset timeout -> spec rendue robuste, relance
[vps-paie] 20-paie-parametrage: PARTIEL 7/9 OK (profil, barèmes, cotisations, rubriques OK; schémas comptables KO: paie VPS appelle localhost:4595 compta/4632 workflow -> BLOCKED-BY-DEPLOY sfd-paie-service application-dev.yml fix) 02:38
[vps-paie] 72-paie-effet-retroactif: OK 9/9 7.4m
[vps-paie] 70-paie-periodes: OK 17/17 24.5m
[vps-paie] 20 restant (schémas comptables, journal PA, simulation): BLOCKED-BY-DEPLOY — sfd-paie-service/src/main/resources/application-dev.yml (URLs rh/compta/workflow/preference en sfd-*-dev, non commité). A redéployer puis rejouer: 20-paie-parametrage (idempotent). Vérif navigateur non faite (pas de session).
[vps-rh] 10-rh-parametrage: OK (data fixes: salaireMinLegal>0, postes categorie by code) ~45m
[vps-paie] 20-paie-parametrage: OK 9/9 (schémas, journal PA, simulation IPR 88 886,40 / net 1 051 113,60 vérifiés) après redéploiement paie #56
[vps-agora] 50-agora: OK (11/12, recherche non jouée: clé Meilisearch invalide côté agora-dev 'The provided API key is invalid') ~1h45
[vps-paie] 39a-compta-auxiliaires (nouveau spec, préalable de 39: génération comptes auxiliaires CDF AG001-4): OK 4.0m
[vps-paie] 39-caisse-prealables: OK 6/6 5.5m
[vps-paie] 40-clients-epargne: OK 23/23 (clients+comptes épargne; 2 retries dus à 502 caisse/workflow transitoires; data/comptes-internes.json et clients-externes.json réécrits avec les valeurs VPS -> 35 peut suivre)
[vps-agora] 60-workflow: groupes+comptes+12 définitions+3 BASE+délégation OK (19 tests, 54 min); instances KO 'Valider' absent sur WF-2026-00012 (attend 30-rh-employes de vps-rh) — à rejouer -g instances
[vps-rh] 30-rh-employes: employés créés OK (24, 26m), photos KO timeout 20m (retry)
[vps-agora] 60-workflow instances: BLOCKED-BY-DEPLOY — workflow->rh lookups 'module injoignable' : selfUrl enregistrée = localhost (défaut). Fix: app.workflow.process.self-url dans sfd-rh-service et sfd-paie-service application-dev.yml (non commité). Après redéploiement rh+paie: rejouer 60-workflow -g instances (cache refs local déplacé)
[vps-agora] 60-workflow définitions (rejeu post-redéploiement rh/paie): OK 15/15 20min
[vps-paie] 35-rh-domiciliation-interne: OK 13 domiciliations INTERNE 20.9m
[vps-paie] 31-rh-carriere (sanction): OK 1.3m
[vps-paie] 33-rh-temps-formations: OK 7/7 12.8m (32 en attente de [vps-agora] 60 instances)
[vps-agora] 60-workflow instances+écrans: OK (congé approuvé/en attente/rejeté, mission DAF, mutation en cours, SLA express = WF-2026-00001..6; écrans OK 5 min; spec écrans paramétrée sur ref mission) ~30min
[vps-paie] 71-paie-calcul: OK 14/14 16.8m (oct 2025->sep 2026 calculés, 23/24 bulletins)
[vps-agora] 41-rh-carriere-workflow: OK 2/2 (nettoyage, rien à supprimer) 2.3m
[vps-paie] 75-compta-mobile-salaire: OK 5/5; 76-rh-domiciliation-faustin: OK 2/2 (no-op)
[vps-rh] 30 photos OK 24/24 (27m)
[vps-paie] 73-paie-cloture: KO Octobre 2025 (1/11): bulletins validés mais comptabilisation refusée (net-nul) -> 0 comptabilisé. CAUSE: employés VPS sans poste (IFOD-0019/0021/0022 + autres, libellé poste vide) => brut 0 en paie. A corriger côté RH (vps-rh: poste/grille des employés) puis recalculer; 73 STOP, 32/74/77-79 non lancés.
[vps-agora] 42-rh-carriere-approbations: OK 3/3 (promo IFOD-0010 WF-00007, promo IFOD-0016 WF-00008, mutation IFOD-0008 WF-00009 : chaîne RRH>DGA>DG, statut APPLIQUÉE) 19min
[vps-paie] CONTROLE bulletins (71b, lecture seule): Octobre 2025 = 21 bulletins VALIDE (0 comptabilisés) dont >=6 à brut 0 sur la 1re page -> STOP (règle: VALIDE net 0). Mars 2026 = 23 CALCULE (5+ brut 0 sur page 1). Déc 2025: liste vide dans mon contrôle (à revérifier). 71 patché (#recalculer) mais NON rejoué. En attente de [vps-rh] 30 contrats + décision coordinateur.
[vps-rh] 30 contrats: OK 24/24 contrats ACTIF avec grille+poste+salaire>0 (0 manquant); #24 fix: timezoneId Africa/Kinshasa in playwright.demo.config.ts (dateFinEssai UTC off-by-one) + contrat-edition.component.ts local-date fix (needs deploy) 06:50
[vps-paie] 71 recalcul: BLOCKED-BY-DEPLOY. 'Génération des bulletins' ne propose que les périodes OUVERTE; après le 1er calcul elles passent CALCULEE (aucune action UI pour rouvrir) -> DEJA_FAIT, bulletins à brut 0 (IFOD-0013/15/19/21/22/12...) non recalculés; Oct-Déc 2025 = 0 bulletin (disparus?). Fix: sfd-angular generation-bulletins.component.ts (filtre OUVERTE||CALCULEE), non commité -> redéployer sfd-angular puis rejouer 71 (#recalculer), 71b, 73...
[vps-rh] 36-rh-pointages: PARTIAL 70/72 saisis (IFOD-0020, IFOD-0021 le 02/10 KO: sélecteur employé sans correspondance .text-success, après retry) 3h
[vps-rh] 37-rh-evaluations: KO évaluation 2026 IFOD-0011 (1/2, likely VPS reboot) - to rerun after VPS BACK. PAUSED. Next: 37, 38, 34, 43, then 44/45
[vps-rh] 36-rh-pointages: OK 72/72 after rerun
[vps-rh] 37-rh-evaluations: OK (retry)
[vps-rh] 34-rh-evaluation-recrutement: OK (campagne 2026, 2 offres publiées, 5 candidatures) after monitor ignores chat/ws 502
[vps-agora] 60-workflow définitions re-replay (rh 54 / angular 278): OK (retries after transient 502 chat/workflow restart) ~25min
[vps-paie] 71 recalcul post-deploy 278: OK 12/13 (Nov25->Sep26 recalculés, 0 brut 0 en 2026; Nov 2025 22 bulletins CALCULÉ vérifié écran). Oct 2025 = 14 ANNULÉ + 7 VALIDÉ (période VALIDEE, non regénérable par l'écran: les 14 employés n'ont pas de bulletin oct 2025, acceptable/à voir) 
[vps-paie] 73-paie-cloture: PARTIEL — Oct 2025 comptabilisé (7 bulletins), 4 payés, 3 KO 'Compte épargne introuvable' (paie appelle localhost:4596 = epargne). Nov 2025 comptabilisé 22 mais paiement non lancé (502 transitoire paie). BLOCKED-BY-DEPLOY: sfd-paie-service application-dev.yml (+app.epargne/caisse/client/notification/template-notification URLs, non commité). Après redéploiement paie: rejouer 73 (idempotent: reprend les COMPTABILISE à payer), puis 32,74,77,78,79.
