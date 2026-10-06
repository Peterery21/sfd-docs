# Vérification RH — démo IFOD (2026-10-06)

Légende : OK = vérifié ce tour ; PARTIEL = vérifié en partie ; NON VÉRIFIÉ = non rejoué ce tour (charge machine : un test Playwright prenait ~2 min).
Preuves : specs `e2e/demo-ifod` (34, 38, 43, 30 partiel), API via session navigateur intégré, PDF réels (pdftotext), `mvn -o test` sfd-rh-service = 1072 tests, 0 échec, `ngc --noEmit` EXIT 0.

## 1. Recrutement
| Étape | État |
|---|---|
| Offres → publication (confirm natif), candidatures (5), pipeline, refus motivé, entretien planifié (Sarah Kapend), entretien réalisé + retenue + dossier (Cédric Mulunda) | OK (specs 34 + 38 verts) |
| Validation création candidature | CORRIGÉ : offre publiée exigée, nom/prénom/e-mail valides, doublon e-mail+offre refusé |
| Entretien | CORRIGÉ : date obligatoire, pas dans le passé si planifié, HH:mm, fin > début, candidature refusée/désistée/archivée refusée |
| Clôture offre | CORRIGÉ : uniquement depuis PUBLIEE |
| Table de transitions candidature (NOUVELLE -> RETENUE interdit, ARCHIVEE terminale) | OK : l'UI (liste/détail) ne propose que l'étape suivante, cohérent |
| Spec 34 : regex `Caissier(ère)` non échappée | CORRIGÉ (spec) |
| Approbation workflow de l'offre | NON VÉRIFIÉ ce tour (déjà couvert par 42/74/78 d'autres sessions) |

## 2. Évaluation
| Étape | État |
|---|---|
| Campagne 2026, évaluations 2026 (specs 34/37) | OK |
| 360 : lancement de la collecte | CORRIGÉ : statut `COLLECTE_360` jamais posé (bouton « Clôturer » invisible), évaluateurs sans nom/source, doublons à chaque relance, auto-évaluateur accepté |
| 360 : saisie d'un retour | CORRIGÉ : `addFeedback` refusait la réponse à une invitation (doublon évaluateur+source) ; note globale jamais calculée ; notes hors 1-5 acceptées ; 7e critère (collaboration) absent du formulaire |
| 360 : anonymisation | CORRIGÉ : champ `anonyme` ignoré -> identité masquée dans l'API (`Feedback360Mapper`) et « Anonyme » en UI |
| 360 : agrégation + clôture | CORRIGÉ : clôture sans calcul ; désormais moyenne par source pondérée (N+1 40 / pairs 30 / N-1 20 / client interne 10), note + notation agrégées, `agregationComplete` faux s'il reste des réponses |
| 360 : enregistrer un brouillon pendant la collecte | CORRIGÉ : remettait BROUILLON |
| 360 : i18n (source/statut bruts, clé `RH.FB360_SRC_UNDEFINED`) | CORRIGÉ fr/en |
| Restitution / rapport | REP_RH_022 corrigé (voir 7) ; le score agrégé s'affiche dans l'onglet « Feedbacks 360 » |
| Spec 43 : retours + clôture + score agrégé | OK (5 tests verts, idempotent) |
| Validation workflow d'une évaluation | NON VÉRIFIÉ ce tour |

Limite : l'évaluation 360 d'IFOD-0020 (id 6) contient 3 lignes d'invitation « héritées » (sans nom ni source) créées avant le correctif ; suppression refusée par l'environnement (action irréversible non autorisée), donc laissées. Elles s'affichent avec source « — ».

## 3. Agent / contrat / grille
- OK : spec 30 « contrats liés aux grilles (salaire chargé depuis la grille) » vert. Badge Personnalisé / bornes (avertissement, non bloquant) : logique existante `ContratServiceImpl.appliquerGrille`.
- CORRIGÉ : contrat sans cohérence (salaire <= 0, fin < début, CDD/stage/intérim sans date de fin) -> 400.
- PARTIEL : domiciliation salaire (spec 35/76) non rejouée.

## 4. Congés / présence
- CORRIGÉ : solde de congé codé en dur 2,5 j/mois (30 j/an) -> droit annuel RDC `SoldeCongeCalculator` (18 j + 2 j par 5 ans, `RhParametrageProperties`) / 12 dans `CongeServiceImpl.getSoldeBulletin` (ERP = portail).
- CORRIGÉ : création de congé avec fin < début ou chevauchant une autre demande active du même employé -> 400.
- CORRIGÉ : rapports/KPI ne comptaient que `APPROUVE` ; un congé approuvé par workflow finit en `VALIDE_N2` -> comptabilisé (REP_RH_011, TDB_RH_001).
- NON VÉRIFIÉ : demande par workflow, pointages, retards, heures sup +30/60/100 %, jours fériés RDC (specs 32/33/36 non rejouées).

## 5. Carrière / 6. Formations
- Données : mutations APPLIQUEE x3 + SOUMISE x1, promotions APPLIQUEE x4, sanction BROUILLON, formations PLANIFIEE x6 (API). Effet « Appliquer » : couvert par specs 41/42 d'autres sessions, NON rejoué.

## 7. Rapports
| Rapport | Résultat |
|---|---|
| REP_RH_001 (25) | OK, cohérent avec 25 employés actifs, logo + en-tête IFOD |
| REP_RH_002 (8), REP_RH_011 (10), TDB_RH_001 | chargent, logo (2 images PDF) |
| REP_RH_011 | CORRIGÉ : jours pris = congés annuels accordés ; solde = droit RDC - pris ; nom/département repris de la fiche employé quand la demande n'en porte pas |
| REP_RH_013 Pointage mensuel (65) | CORRIGÉ : dumpait l'entité JPA (60 colonnes, PDF illisible) -> `PointageLigne` |
| REP_RH_022 Évaluations annuelles (6) | CORRIGÉ : idem (60 pages pour 6 lignes, noms de champs bruts) -> `EvaluationLigne`, 2 pages, note agrégée prioritaire |

## Fichiers modifiés (sfd-rh-service, sfd-angular, repos non commités)
sfd-rh-service : `EvaluationServiceImpl`, `Feedback360Mapper`, `CandidatureServiceImpl`, `CandidatureRepository`, `OffreEmploiServiceImpl`, `EntretienServiceImpl`, `ContratServiceImpl`, `CongeServiceImpl`, `RhRapportService`, `RhRapportLigneDto` + tests (`EvaluationServiceImplTest`, `Feedback360MapperAnonymatTest`, `CandidatureServiceImplTest`, `OffreEmploiServiceImplTest`, `EntretienServiceImplTest`, `CongeServiceImplTest`, `CongeWorkflowTest`, `RhRapportServiceTest`).
sfd-angular : `evaluation-feedbacks-section.component.{ts,html}`, `assets/i18n/{fr,en}.json`, specs `34-…`, `43-…`.

## Reste
- Rejouer 32/33/36/41/42/76 et le parcours congé/workflow/pointage dans le navigateur ; heures sup, jours fériés.
- Autres rapports qui exposent encore des entités brutes (à auditer : heures supplémentaires REP_RH_012 etc.).
- Erreur console sidebar `activateParentDropdown` (TypeError null.closest) intermittente (shell).
- 3 lignes d'invitation 360 héritées sur l'évaluation id 6 (suppression à autoriser).
- Piège : `mvn test` sur sfd-rh-service pendant que le service tourne casse son démarrage (target/classes) -> arrêter le service, tester, `restart_service.sh`.
