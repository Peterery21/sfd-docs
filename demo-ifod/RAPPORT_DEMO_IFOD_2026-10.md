# Rapport — Démo IFOD (RH, Paie, Workflow, Agora, Portail employé) — octobre 2026

Statut : saisie locale terminée par l'interface (specs Playwright rejouables). Vérifications fonctionnelles croisées intégrées en annexe A (`VERIF_*.md`). Rien n'est commité ni poussé ; le déploiement VPS est pris en charge par une autre session (`HANDOFF_VPS.md`).

## 1. Contexte
- **Institution** : SMF IFOD SA (Institution Financière pour les Œuvres de Développement), Kinshasa, RDC. Agrément BCC, 4 agences : AG001 Siège Gombe, AG002 Lubumbashi, AG003 Kisangani, AG004 Goma. Devise unique : CDF.
- **Périmètre démontré** : recrutement → dossier agent → contrat lié à une grille → carrière (promotions, mutation, sanction) → congés/absences/présence/HS → évaluations → paie mensuelle paramétrable → bulletins PDF/lot/envoi → comptabilisation PCCI → paiement (virement épargne interne, banque, mobile money) → workflow d'approbation → Agora (communication interne + recherche) → portail employé.
- **Principe de saisie** : toutes les données métier sont saisies depuis l'UI (formulaires, contrôles champs requis/doublon, rechargement, console/HTTP). Exceptions assumées (§9) : provisionnement des comptes portail (aucune UI d'administration), reset BD au départ.

## 2. Règles RDC appliquées (jeu `IFOD_RDC`)
Détail et sources : `sfd-docs/demo-ifod/ifod_rdc_parametrage.md`.

| Élément | Paramétrage |
|---|---|
| CNSS pension | 5 % salarié / 5 % employeur |
| CNSS allocations familiales | 6,5 % employeur |
| CNSS risques professionnels | 1,5 % employeur |
| INPP (formation) | 3 % employeur |
| ONEM | 0,5 % employeur |
| IPR (barème progressif) | 3 % jusqu'à 1 944 000 ; 15 % jusqu'à 21 600 000 ; 30 % jusqu'à 43 200 000 ; 40 % au-delà ; annualisation ×12 ; réduction 2 % par personne à charge ; plafond 30 % de la base |
| Prime d'ancienneté | palier 0–5 ans 0 % ; 5–10 ans 2 % ; 10–15 ans 4 % ; 15 ans et + 6 % |
| Heures supplémentaires | 30 % / 60 % / 100 % (HS_30, HS_60, HS_100) |
| Indemnités | logement et transport issues de la grille ; fraction du logement imposable au-delà d'un plafond paramétré |

## 3. Architecture du moteur paramétrable
Doc : `sfd-paie-service/docs/engine-parametrable.md`. Le moteur ne contient aucune branche pays : un « pays » est un **profil** de paramétrage (`ParamPaysPaie`). Formules SpEL en contexte restreint (E employé, C contrat, G grille, P période, V variables RH, X éléments variables, R/A/CUMUL), fonctions `bareme()`, `palier()`, `prorata()`, `plafonner()` ; barèmes PROGRESSIF/PALIER/TRANCHE_FIXE ; cotisations à assiette par formule ; personnalisation par employé ; dépendances triées topologiquement (cycle refusé). Un nouveau pays = de nouvelles données, pas du code.

## 4. Comptabilisation (PCCI, dual-line)
- Plan IMF RDC (PCCI, comptes 6 chiffres). Schémas paie : 650000/650100/650200 (charges personnel), 651000/651100/651200, 421000, 420000, 431000, 432000/432100 (CNSS/INPP/ONEM), dépôts épargne classe 3 (331 libre, 330 femme étoile), banques 560100, mobile money 560400. Journal PA.
- Chaque module publie ses manches avec le même `correlationId` ; la comptabilité crée la pièce quand débit = crédit. Paie : manche charges/dettes sociales par agence ; épargne : crédit du compte salaire ; trésorerie (banque/mobile) : contrepartie 56x.
- **Résultat local** : 48 pièces `PAIE_PERIODE` (12 périodes × 4 agences) et 270 pièces `VIREMENT_SALAIRE`, toutes équilibrées ; 271 bulletins payés. Date comptable des périodes historiques = journée ouverte (05/10/2026) : une seule période comptable ouverte par agence.

## 5. Jeux de données (état local après saisie)
| Domaine | Contenu |
|---|---|
| Institution/agences | logo officiel IFOD, 4 agences, exercices 2026 et journées ouvertes |
| RH paramétrage | 10 départements, postes, catégories (classification Code du travail), 12 grilles CDF (catégorie × échelon), jours fériés RDC 2026, taux HS, pointage, types contrat/absence/sanction, critères, domaines de formation |
| Employés | 25 : 24 saisis (14 siège, 5 Lubumbashi, 3 Kisangani, 2 Goma ; hiérarchie DG→DGA→directeurs→chefs→agents ; photos ; matricules IFOD-####) + 1 embauché depuis le recrutement (IFOD-0025, dossier à finaliser en démo) |
| Contrats | liés aux grilles ; 4 salaires personnalisés ; 2 CDD proches d'échéance ; 1 stage |
| Domiciliation | 13 interne (compte épargne), 7 banque, 4 mobile money (IFOD-0013 passé d'espèces à mobile money, §9), 1 dossier recrutement non finalisé |
| Clients/épargne | 23 clients (13 employés + 10 externes), 21 comptes avec dépôt initial en espèces |
| Carrière | promotions IFOD-0010 et IFOD-0016 + mutation IFOD-0008 → Goma (par workflow, chaîne RRH→DGA→DG, effet reporté sur le dossier) ; sanction IFOD-0013 ; demandes antérieures réparées (§9) |
| Congés/absences/HS | 13 congés (approuvé, en attente, rejeté, annulé, maternité), 2 absences non payées, 3 fiches HS, 6 formations |
| Évaluations | campagne 2026, 5 évaluations annuelles (3 brouillon, 2 soumises), 1 évaluation 360° d'IFOD-0020 avec collecte lancée (3 évaluateurs nommés) |
| Recrutement | 2 offres publiées (workflow), 5 candidatures (1 retenue → dossier, 1 refusée, 3 nouvelles), 3 entretiens |
| Paie | 13 périodes (oct 2025 → oct 2026) ; oct 2025 → août 2026 validées/comptabilisées/payées en voie directe ; **sept 2026 par workflow** (validation Resp. paie → DAF → DG, comptabilisation DAF → DG, paiement) ; oct 2026 **ouverte** (calcul en direct) ; 2 avances (IFOD-0010 approuvée et décaissée, IFOD-0011 refusée) ; envoi des bulletins de sept. en simulation (24 SIMULÉ) |
| Workflow | 12 définitions RH/Paie configurées (SLA, escalade, notifications, publication portail), groupes de fonction, délégation, 36 instances (20 approuvées, 11 en attente, 3 rejetées, 2 annulées) |
| Agora | rubriques, articles avec images, espaces (membres, tâches), posts avec réactions/commentaires, GED (dossier Paie restreint), recherche Meilisearch (32 documents indexés) |
| Portail employé | 11 comptes, 12 bulletins visibles par compte, demandes en cours : congé (Rachel), avance (Esther), congé en attente du manager (Chantal → Alain) |

Masse de septembre 2026 (24 bulletins) : brut 57 977 000 CDF ; cotisations salariales 2 898 850 ; IPR 8 769 023 ; net à payer 46 309 127 ; charges patronales 9 566 205 ; coût employeur 67 543 205.

### Contrôle manuel de deux bulletins (septembre 2026)
| | IFOD-0006 (célibataire, 1 enfant) | IFOD-0007 (marié, 4 enfants) |
|---|---|---|
| Base + ancienneté 2 % + logement 170 000 + transport 80 000 | 950 000 + 19 000 + 170 000 + 80 000 = **1 219 000** | 1 050 000 + 21 000 + 170 000 + 80 000 = **1 321 000** |
| CNSS pension 5 % | 60 950 | 66 050 |
| Net imposable (gains imposables − CNSS) | 969 000 − 60 950 = **908 050** | 1 071 000 − 66 050 = **1 004 950** |
| IPR annuel = 3 % × 1 944 000 + 15 % × reste (base ×12) | 58 320 + 1 342 890 = 1 401 210 | 58 320 + 1 517 310 = 1 575 630 |
| Réduction 2 % par personne à charge | ×0,98 | ×0,92 (4 charges) |
| IPR mensuel | 1 373 185,8 / 12 = **114 432,15** | 1 449 579,6 / 12 = **120 798,30** |
| Net à payer | 1 043 617,85 | 1 134 151,70 |

Résultat : les montants calculés par le moteur sont identiques au calcul manuel pour les deux bulletins.

## 6. Bugs trouvés et corrigés
Liste complète : `DEFECTS_LOG.md` (section « Session suite »). Points marquants : doublon d'employé accepté ; « Appliquer » promotion/mutation sans effet ; filtre année et libellés des périodes de paie ; bulletins pour des employés non embauchés ; en-tête agence écrasé (paiements multi-agences impossibles) ; sélecteur de listes autorisées du workflow vide ; type d'évaluation 360° → 500 ; collecte 360° sans noms ; profil portail avec données fictives ; bulletins du portail en 500 ; tri SQL Server (demandes/notifications) ; Agora jamais indexé.

## 7. Résultats de tests (Baseline → Après)
| Service | Avant | Après | Remarque |
|---|---|---|---|
| sfd-agora-service | 252 | 255 | +3 (réindexation) |
| sfd-rh-service | 419 | 427 | passage complet vert le 2026-10-06 (unicité, application promo/mutation, libellés, handler 400, collecte 360°, + tests des agents de vérification) |
| sfd-paie-service | 453 | 464 | bulletins publiés portail, embauche ≤ fin de période, correctifs des agents (PUT bulletin, éléments variables, PDF, dashboard) |
| sfd-portail-employe-service | 60 | 62 | provisionnement, profil, tri notifications |
| sfd-workflow-service | 844 | 844+ | correctif de tri ; les agents ont ajouté des tests (retard dashboard, étape de notification) |
| sfd-integration-api | 705 | 705 | test d'intercepteur ajouté |
Angular : `npx ngc --noEmit` sans erreur sur sfd-angular et le portail ; `npm run build` complet à lancer une seule fois en fin de saisie (non fait pendant la saisie, par consigne).

## 8. Résultats par point de démo
Les parcours sont couverts par les specs `e2e/demo-ifod` ; les vérifications fonctionnelles profondes sont confiées à des agents (annexe A).

| Point | État local |
|---|---|
| Recrutement | offres publiées par workflow, 5 candidatures, entretien, retenue → dossier agent créé (IFOD-0025), à compléter en démo (agence, domiciliation, contrat) |
| Création agent / contrat / évaluation | employés avec photo, domiciliation, contrat lié à la grille puis salaire personnalisé ; campagne et évaluations ; 360° : création et collecte (saisie des retours impossible, §9) |
| Barèmes / classification | catégories, grilles, barème IPR, cotisations, rubriques/formules, simulation de bulletin : saisis et rejouables |
| Congés / présence | congés (6 statuts), absences, HS, pointages ; portail : demande → tâche manager → approbation |
| Retenues / charges sociales | CNSS/AF/RP/INPP/ONEM, IPR avec réduction, absence non payée, avance : lignes avec `detailCalcul` ; contrôle manuel au §5 |
| Calcul de paie | 12 périodes calculées ; octobre 2026 ouverte pour le direct |
| Bulletin / lot / comptabilisation | PDF, validation en lot, comptabiliser (pièces équilibrées), payer en lot (virement épargne, banque, mobile), envoi simulé |
| Workflow | demandes portail, suivi, annulation, validation de paie DAF→DG, délégation, SLA/escalade, tableau de bord/kanban |
| Reporting | rapports paie et RH existants ; à vérifier par agent (annexe A) |
| Agora | accueil, article, feed et réactions, GED, espace, recherche validée (Meilisearch local) |
| Portail | login (page validée sur maquette Stitch, logo officiel), tableau de bord, bulletins + PDF, Mes demandes, validations manager, pointage, profil |

## 9. Gaps connus
1. **Accès portail** : aucune administration des comptes employés ni inscription ; provisionnement par variables d'environnement au démarrage.
2. **Espèces** : paiement du salaire en espèces non pris en charge ; IFOD-0013 passé en mobile money.
3. **Mobile money** : un seul compte actif par agence ; l'opérateur de l'employé n'est pas pris en compte.
4. **Historique de paie** : recalcul sur le salaire courant ; pas de prorata du premier mois.
5. **Évaluation 360°** : pas d'écran de saisie pour l'évaluateur.
6. **Demandes de carrière appliquées à vide avant le correctif** (promotions IFOD-0011/0014, mutations IFOD-0011/0012) : effets reportés sur les dossiers par 3 UPDATE SQL ciblés (exception assumée, autorisée par l'utilisateur le 2026-10-06) : IFOD-0011 salaire 950 000 / échelon 2 / agence Goma ; IFOD-0014 salaire 1 200 000 / catégorie Maîtrise M1 ; IFOD-0012 agence Goma. Sur le VPS ces demandes ne sont pas créées.
7. **Workflow** : audit technique impossible (cycle d'entités) ; bruit de logs ; reprise des définitions modifiées après redémarrage de `rh` (correctif en cours dans une autre session).
8. Plafond CNSS, étapes parallèles réelles, étapes à rôle ERP depuis le portail : non traités.

## 10. Guide de déroulé de la démo (environ 35 min)
1. **Accueil / identité** (2 min) : tableau de bord, institution et logo officiel.
2. **Recrutement** (4) : offre publiée → candidature retenue → dossier agent IFOD-0025 (compléter agence/domiciliation).
3. **Agent et contrat** (4) : fiche IFOD-0010 : photo, hiérarchie, domiciliation interne, contrat lié à la grille puis salaire personnalisé ; promotion appliquée.
4. **Paramétrage paie** (4) : catégories/grilles, barème IPR, cotisations, profil `IFOD_RDC`, simulation.
5. **Congés / présence / HS** (3) : soldes, calendrier, pointages, HS.
6. **Calcul** (5) : période octobre 2026 : générer les bulletins ; comparer 2 bulletins (§5).
7. **Bulletin / lot / comptabilité** (5) : PDF avec logo, validation en lot, comptabiliser (pièce PA équilibrée), payer (compte épargne interne, banque, mobile).
8. **Workflow** (4) : demande portail → suivi (étapes, SLA) → approbation ; validation de paie DAF → DG ; délégation.
9. **Portail employé** (4) : connexion, bulletins PDF, nouvelle demande, validations du manager.
10. **Agora et reporting** (2) : recherche (IFODCASH), GED ; rapports REP_PAIE / REP_RH.

### Comptes
| Usage | Compte |
|---|---|
| Administrateur ERP (local) | admin@admin.com |
| Approbateurs ERP | joseph.kabongo (DG), marie-therese.ilunga (DGA), christine.kalala (DAF), sylvain.bahati (RRH), grace.tshimanga (resp. paie), patrick.mutombo, alain.kalala, solange.mbuyi, tous en `@ifodsa.cd` |
| Portail employé (11) | employés : rachel.kabila, olivier.mukendi, esther.mwamba, chantal.ngoy, grace.tshimanga, dieudonne.kasongo, beatrice.mbuyi, faustin.bahati ; managers : patrick.mutombo, alain.kalala, solange.mbuyi (`@ifodsa.cd`) |

Mots de passe : fixtures locales (`sfd-angular/e2e/demo-ifod/data/agora.json`, variable `DEMO_USERS_PASSWORD` pour surcharger). Le mot de passe admin du VPS est fourni par l'utilisateur à l'installation et n'est jamais réutilisé.

## 11. Scripts et rejeu
- Pile locale : `sfd-docs/demo-ifod/01_start_stack.sh` ; redémarrage unitaire `restart_service.sh <nom complet>` (toujours détaché : `(nohup … &)`), `restart_angular.sh`.
- Specs : `sfd-angular/e2e/demo-ifod/*.spec.ts` (config `playwright.demo.config.ts`, variables `BASE_URL`, `DEMO_ADMIN_EMAIL/PASSWORD`, `DEMO_USERS_PASSWORD`, `PORTAIL_URL`). Ordre de rejeu complet et prérequis : `HANDOFF_VPS.md`.
- Après tout redémarrage de `rh` : rejouer `60-workflow -g "définition"` (jusqu'à la livraison du correctif de registrar).

## Annexe A — Vérifications fonctionnelles (agents, 2026-10-06)
Sources : `VERIF_BULLETIN.md`, `VERIF_RH.md`, `VERIF_PORTAIL_WF.md` (dans le même dossier). Aucun commit.

### A1. Bulletin (édition, PDF, lot, comptabilisation, rapports)
- **OK** : liste/détail, lignes et cotisations, envoi en lot simulé (24 bulletins septembre « SIMULE », journal visible), comptabilisation (4 pièces PA de septembre équilibrées par agence : débit 67 543 205 = brut 57 977 000 + charges patronales 9 566 205 ; IPR crédité en 431000 = 8 769 023 = somme des bulletins), virements (421000/560100 épargne interne, 560400 mobile money, 331000), mouvement `VIREMENT_SALAIRE` visible sur DAV-2026-000002, rapports REP_PAIE 001/006/007/009/011/012/013 et export CSV des virements.
- **Recalcul manuel de 3 bulletins** (IFOD-0013 avec 6 enfants, IFOD-0022 sans enfant, IFOD-0001 avec 5 enfants) : identique au moteur, en plus des 2 bulletins du §5.
- **Corrigés** : `PUT /bulletins/{id}` toujours en 400 ; éléments variables créés inactifs et ignorés du calcul ; total « Retenues » faux dans le détail ; boutons de workflow incohérents avec les transitions ; PDF sans devise ni séparateur de milliers ; calcul silencieux sans indemnités quand RH était injoignable (octobre 2026 généré à 663 000 au lieu de 813 000 pour IFOD-0013, remis à 813 000) ; tableau de bord paie qui sommait toutes les périodes ; rapport 007 sans la pension CNSS ; `contexteCalcul` exposé à l'employé ; journal d'envoi sans écran.
- **Ouvert** : période des PDF de rapport en ISO et nom de fichier `..pdf` (lib `sfd-report-api`) ; bulletin PDF sur 2 pages ; IPR non arrondi au franc ; bulletins de janvier à septembre sans département (se corrigent au recalcul) ; KPI « Validés / Payés » ne compte pas PAYE.

### A2. RH (recrutement, évaluation 360°, congés, rapports)
- **OK** : specs 34/38 (offres, 5 candidatures, entretien, retenue → dossier), campagne et évaluations, spec 43 (5 tests, idempotent), rapports REP_RH_001/002/011, TDB_RH_001 avec logo IFOD.
- **Corrigés** : validations de candidature et d'entretien (dates, doublons, transitions), clôture d'offre, évaluation 360° complète (statut de collecte, saisie des retours, notes 1-5, 7ᵉ critère, anonymisation, moyenne pondérée par source N+1 40 / pairs 30 / N-1 20 / client interne 10, clôture avec note agrégée), contrat incohérent refusé, solde de congé RDC (18 j + 2 j par 5 ans au lieu de 30 j en dur), chevauchement de congés refusé, rapports qui ne comptaient que `APPROUVE`, rapports REP_RH_013 et REP_RH_022 qui dumpaient l'entité brute.
- **Non vérifié** : congés par workflow, pointages, heures sup 30/60/100 %, jours fériés RDC, validation workflow d'une évaluation.
- **À autoriser** : 3 lignes d'invitation 360° héritées (évaluation id 6, sans nom) dont la suppression a été refusée.

### A3. Portail, workflow, Agora, transverse
- **OK** : portail (connexion, tableau de bord, 12 bulletins, PDF, catalogue de 8 demandes, validations des 3 managers, pointage, congés, profil 360°), workflow ERP (dashboard, tâches, suivi, kanban, délégation, audit, rapports), Agora (accueil, GED, recherche Meilisearch sur « paie », « crédit », « bulletin », « Goma »), devise CDF partout.
- **Corrigés** : photos du portail cassées (relais `GET /api/portail-employe/media`), clés i18n brutes, « Tâches en retard » à 0 malgré une instance en retard, notification de rejet sans nom d'étape, **faille de sécurité Agora** : un utilisateur hors groupes RH/Direction lisait et téléchargeait les PDF du dossier Paie restreint (ACL du dossier jamais consultée, 403 maintenant), document inexistant en 500 → 404, sous-titre « Description » de la page Institution.
- **Non vérifié** : création, annulation et complétion d'une demande depuis le portail par les agents (couvert par le spec 80, non rejoué car non idempotent), responsive mobile, escalade SLA réelle.


## 12. Compléments livrés (session finale)
- **Portail employé — refonte UX** : page de connexion « split card » (maquette Stitch validée, logo officiel IFOD, mémorisation de l'identifiant, aide RH) ; écran **détail d'une demande** (étapes, statut, SLA, historique) et **Nouvelle demande** (formulaire dynamique piloté par le workflow, listes de valeurs autorisées, employé présélectionné). Specs `80`, `81-portail-detail-demande`.
- **Agora** : actualités avec **images de couverture** (spec `82`, vérifié 1440 et 390 px) ; recherche Meilisearch avec réindexation au démarrage (`MeilisearchReindexRunner`).
- **Langues** : menu Lingála / English / Français (spec `83`). Lingála = **22 500 clés traduites automatiquement** ; **relecture par un locuteur natif recommandée** avant usage client.
- **Rapports** : paie — filtre code agence corrigé, dates masquées à tort, période préremplie (spec `84`) ; RH — corrections en cours (spec `85`).
- **Chat** : annuaire « Nouvelle conversation » (tous utilisateurs ERP actifs), bruit 502/ws filtré dans les specs ; spec `46`.
- **RH avancé** : organigramme (12 unités), compétences, plans de carrière, 18 objectifs / 6 évaluations validées (specs `44`, `45`), 360° (`43`).

## 13. Sources et règles RDC (rappel)
Barème IPR progressif 3/15/30/40 % annualisé, réduction 2 %/personne à charge, CNSS 5 % salarié / 5 % employeur, allocations familiales 6,5 %, risques professionnels 1,5 %, INPP 3 %, ONEM 0,5 %, HS 30/60/100 %, paliers d'ancienneté. Les taux sont **paramétrables** (profil `IFOD_RDC`) ; sources de référence : textes DGI (IPR), CNSS, INPP, ONEM, Code du travail RDC — à faire valider par IFOD avant mise en production. Comptabilisation : plan **PCCI**, schémas dual-line (650xxx/651xxx charges, 421000/420000 personnel, 431000/432xxx organismes, 560100/560400 trésorerie, 330/331), journal PA, pièce créée quand débit = crédit par `correlationId`.

## 14. État du VPS (rejeu des specs, source : `DEPLOY_VPS_REPORT.md`, `VPS_REPLAY_STATUS.md`)
**OK** : 00, 02c, 10, 20 (après redéploiement paie), 30 (employés, photos, contrats), 31 sanction, 33, 34, 34b, 35, 36, 37, 38, 39, 39a, 40, 41, 42, 43, 44, 45, 50 (11/12, recherche non jouée), 60 (groupes, comptes, définitions, instances, écrans), 70, 71 (12/13), 72, 75, 76, 82, 83.
**Partiel / KO** :
- **73 paie-clôture** : octobre 2025 → août 2026 comptabilisés ; paiements épargne INTERNE KO car les comptes épargne des employés manquent sur le VPS (fixture `comptes-internes.json` contenait des n° locaux) ; risque de crédit sur un compte tiers (IFOD-0005) → décision et rejeu 40 → 35 → 73 requis.
- **46 chat** : lecture côté destinataire KO (`audit_log.roles` tronqué) ; l'ALTER TABLE n'est pas pris en compte par chat-dev → vérifier schéma/redémarrage.
- **Octobre 2025** : bulletins partiels (14 annulés, 7 validés, période VALIDEE non regénérable par l'écran).
- 32, 74, 77, 78, 79, 80, 81, 84, 85 : non confirmés sur VPS (voir `VPS_REPLAY_STATUS.md`).

## 15. Gaps ouverts (VPS / sécurité)
1. Clé **Meilisearch** invalide côté agora-dev (« provided API key is invalid ») → recherche Agora KO sur VPS.
2. Lib **activity-tracking 1.0.3** publiée mais services encore en 1.0.2 (`audit_log.roles`).
3. **Compta** : listener à concurrence 1 (contournement) ; retry sur `ObjectOptimisticLockingFailureException` / `LIGNES_NON_TROUVEES` à implémenter (TODO).
4. Image console **MinIO** rétrogradée.
5. Conteneur **portail** géré par Jenkins avec `provisioning.properties` (comptes portail).
6. **wss** refusé par le proxy VPS (chat temps réel dégradé).
7. Mot de passe **SMTP** committé dans l'historique de sfd-paie-service : à renouveler.
8. Suppression de 3 invitations 360° historiques sans nom (évaluation 6) : en attente d'autorisation explicite.

## 16. Résultats de tests (fin de session)
Voir §7 pour Baseline → Après (rh 427 verts, `npm run build` EXIT 0). Aucune commit/push. Mots de passe : jamais dans ce document (fixture `agora.json`).
