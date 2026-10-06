# Vérification portail employé / workflow / Agora / transverse — 2026-10-06

Méthode : volet navigateur intégré (volet masqué : pas de capture d'écran, lecture DOM/texte + requêtes réseau), complété par appels API avec comptes de démo. Aucun commit.

## 1. Portail employé
- OK connexion (rachel.kabila), tableau de bord (solde, demandes en cours, dernier bulletin en CDF), liste bulletins (12 périodes), PDF bulletin (200, 1 page), détail bulletin (API).
- OK catalogue (8 types), « Mes demandes » (liste, filtres), formulaire avance : validations « Ce champ est obligatoire » / « supérieure ou égale à 1 ».
- OK pointage (historique), congés, profil 360, « Mes validations » des 3 managers (compteurs cohérents avec la liste).
- KO corrigé : photo d'employé cassée (URL `public/media?...` relative au portail → HTML). Relais `GET /api/portail-employe/media?url=employes/photos/...` (public, chemins photos uniquement) + réécriture des `photoUrl`. Vérifié : image/png 200, `../x` 400.
- KO corrigé : clé i18n brute `PORTAIL_EMPLOYE.PROFIL360.SEXE_FEMININ` (profil 360) — clés `SEXE_MASCULIN/FEMININ` ajoutées fr/en.
- Non vérifié : création effective d'une nouvelle demande, annulation, complétion, approbation par un manager dans l'UI (couverts par spec 80, non rejouée car non idempotente), responsive mobile, notifications détaillées.

## 2. Workflow ERP
- OK dashboard, mes tâches, suivi, kanban, notifications, délégations (Christine Kalala → Patrick Mutombo), audit, rapports, matrice des pouvoirs (route).
- KO corrigé : « Tâches en retard » = 0 alors que WF-2026-00018 (SLA 1 h) est « EN RETARD » : le dashboard ne comptait que l'échéance jour < aujourd'hui. Utilise désormais la même règle que les listes (`WorkflowInstanceServiceImpl.isLate`). Vérifié : API renvoie 1.
- KO corrigé : notification de rejet « rejetée à l'étape . » (étape vide sur instance clôturée) : repli sur la dernière étape traitée (`WorkflowNotificationDispatcher.derniereEtapeTraitee`).
- Persistance des définitions après redémarrage RH : vérifiée précédemment (declared_signature, tests WorkflowDefinitionRegisterTest). Processus PAIE disponibles : 3 (avance, validation, comptabilisation) au catalogue.
- Non vérifié : escalade/SLA en conditions réelles, timeline UI.

## 3. Agora
- OK accueil, actualités, communauté, documents (pas de clé brute / NaN).
- OK recherche Meilisearch (container local, réindexation au démarrage 8 articles + 24 posts) : requêtes « paie », « crédit », « bulletin », « Goma » renvoient des hits.
- KO SÉCURITÉ corrigé : un utilisateur hors groupes RH/Direction (alain.kalala) lisait/téléchargeait les PDF du dossier Paie RESTREINT par `GET /agora-documents/{id}`, `/versions` (documents créés « PUBLIC » dans un dossier restreint → ACL du dossier jamais consultée). `DocumentService.dossierAccessible` + contrôle ACL sur `/versions`. Vérifié : alain 403 (doc, versions, téléchargement), grace (RH) 200, dossier Paie masqué dans la liste.
- KO corrigé : document inexistant → 500 ; désormais 404 (`AgoraNotFoundAdvice`).

## 4. Reporting / devise
- OK (vérifié session précédente) : PDF préférence avec logo institution, CDF. Page Institution : devise CDF, libellé fuseau Africa/Kinshasa. Aucun XOF/FCFA dans les pages parcourues.
- KO corrigé : sous-titre de la page Institution = « Description » (clé i18n générique) → texte explicite fr/en.
- KO restant : PDF bulletin de paie sans devise (aucun « CDF ») et montants sans séparateur de milliers (`1100000,00`), « Agence : — » alors que AG001.

## 5. Shell
- OK logo Nexora conservé (sidebar/topbar). Descriptions du sidebar Paramétrage : traitées par un autre agent, non revérifiées.

## Tests
- sfd-portail-employe-service `mvn -o test` vert (+PortailMediaControllerTest) ; sfd-workflow-service vert (+assertion retard, +test étape) ; sfd-agora-service vert (+2 tests ACL dossier, +AgoraNotFoundAdviceTest) ; portail-employe-angular `ngc --noEmit` 0 erreur ; JSON i18n ERP valides (build ERP complet non rejoué).

## Fichiers modifiés
- sfd-portail-employe-service : controller/PortailMediaController (nouveau), integration/RhRestClient, config/PortailConfig, service/PortailProfilService, PortailDashboardService, test PortailMediaControllerTest.
- sfd-workflow-service : service/impl/WorkflowDashboardServiceImpl, WorkflowInstanceServiceImpl, service/WorkflowNotificationDispatcher + tests.
- sfd-agora-service : service/DocumentService, controller/DocumentController, exception/AgoraNotFoundAdvice + tests.
- sfd-portail-employe-angular : assets/i18n fr/en. sfd-angular : assets/i18n fr/en (PREFERENCE.INSTITUTION.DESCRIPTION).
- Services redémarrés : portail-employe, agora, workflow (jars/classes locaux ; VPS à redéployer).

## Restant
Voir DEFECTS_LOG.md (section « Vérif portail/WF 2026-10-06 »).
