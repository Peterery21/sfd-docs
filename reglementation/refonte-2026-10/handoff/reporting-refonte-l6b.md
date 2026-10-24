# L6b — corrections finales (reporting, épargne, Angular)

Branches `feature/reporting-refonte-l6b` (non poussées) : reporting (depuis `-l6-libelle-clair` + cherry-pick de `-l6-caisse-allegee` 136751e), épargne (depuis feature/reporting-refonte), Angular (idem).

## Fait
| # | Sujet | Résultat |
|---|---|---|
| 1 | Caisse UEMOA allégée | A01/A11 `comptesAllegee: 101` (+ assertions LocalisationRegistryTest/CloisonnementTest/ExactitudeCalculsTest). Test `uemoa_bilanAllege_comptesEdipMouvementes_equilibre` : 101000, 114100, 202200+202270, 251100, 252100, 571110 → A11 1000, A01 1500, B01 820 (pas de double compte 2022/20227), E90 = L90 = 2320. |
| 1b | Contrôle systématique des préfixes (rôles RCS_SFD → BIL et CR) | Tous les rôles à mouvement sont atteints dans la variante allégée : voir « Contrôle » ci-dessous. Aucun autre cas du type 1011/101 en allégée. |
| 2 | CEMAC 5 préfixes | 634→**624** (même libellé « transfert de fonds », plan COBAC ; ZP07 exclut 624 pour éviter le double compte, comme XG06/XG07). 389, 4651, 5818, 7140 : pas de correspondance sûre → nouveau champ de paquet `absentPlan` ; la ligne est calculée sur les autres comptes et porte un avertissement explicite (« compte(s) X absent(s) du plan… valeur partielle »). Tests : HK05, ZP06/ZP07. |
| 3 | RG34 | Source (`reporting.md`, `paquet-draft.yml`) : « NON TROUVÉ ». RG34 **et RG35** (même défaut) passent en SAISIE : erreur « Saisie manuelle requise » au lieu de « Formule non définie » ; une fois saisies, RG32 calculable. Test. |
| 4 | RDC PARTICIPATIONS | `SOLDE("25", D) / FPP` (la forme `25 / FPP` du brief n'existe pas dans la grammaire : un nombre nu est un littéral), note `aConfirmer`. Test 184/920 = 0,2 CONFORME. |
| 5 | IND-F03 / F16 | **Pas une erreur de formule.** T6K/T6L = pertes sur créances irrécouvrables (669x), pas les dotations 664 (T6B/T6C/T6D). IND-F03 = (T6K+T6L)/encours : 0 tant qu'aucune perte n'est passée, la dotation 664100 (200 000) n'y entre pas par définition RCSFD. IND-F16 : FG = S02+S1A+S2A+T50 (frais de personnel, autres frais, dotations au fonds 65) : 664 n'y entre pas non plus. Rien modifié → point à valider. |
| 6 | ST05 DAT (épargne) | Confirmé : `depot_a_terme` est hors `compte_epargne`. `encours-bceao` : total = comptes − comptes de type DAT (legacy) + DAT ACTIF ; champs ajoutés `encoursDat`, `ecartAutresDepots` (non borné, `encoursAutresDepots` reste plafonné à 0). Épargne 985/0. Reporting : aucune adaptation de code (lit `encoursDepotTotal`) ; note ST05 mise à jour. Détail : `l6b-epargne.md`. |
| 7 | 404 | `Rapport inconnu…` lève `ReportingNotFoundException` (@ResponseStatus 404). ITs : `GET /editions/999999` 404 ; `POST /editions/generer` code hors périmètre 404 (aucune édition créée). |
| 8 | Course init | `FormuleSyncService.VERROU` (ReentrantLock) pris par le chargeur de démarrage et par `/setup/init` ; en plus, `/setup/init` rejoue une fois la synchro sur `DataIntegrityViolationException` (autre instance). Test contrôleur. |
| 9-10 | UX | Voir `l6b-angular.md` : variante effective + `comptesAllegee` + `exclut`, `+` automatique, raison du bouton Calculer, agence de l'aperçu, erreur participation traduite (fr/en/ln). Backend : `FormuleDto` expose `exclut` et `variante`. |

## Contrôle des préfixes (UEMOA)
Méthode : pour chaque rôle de `roles-comptables.yml` (rempli à 6 chiffres, comme l'instance), liste des lignes de DIMF-2000-BIL et DIMF-2080 dont un préfixe l'atteint, en allégée.
- BIL : tous les rôles ont ≥ 1 ligne (CAISSE→A01/A10/A11 ; BANQUE→A12 dr / F01 cr ; crédits 2022/2023/20227/2031/2037/291-294/299x→B01 ; 2511/2512/2531/2521/2545/2551→G01/G10 ; 3791/3792→C01/H01 ; capital/réserves/résultat→L01 ; classes 6/7→E05/L75).
- CR (2080) : 6011/6019/6025/6029/7011/7021/7025/7028/7029/708/664/669/764/671/771 atteints (R08, R3A, V08, V3A, V6U, T6B, T6K allégée, X6B/X6C, T80, X80).
- Les lignes de détail RCSFD à sous-comptes (60111, 25111, 25116, 20221, 70212…) n'existent pas dans le plan EDIP (qui s'arrête à 2511, 2022, 6011…) : valent 0 car aucun compte ne les porte ; leur ligne parente porte le total. En variante développée (ART44), B01/G01 n'ont que les sous-comptes (20221, 25111…) et **n'incluent pas** 2022/2511/2531 : le bilan développé ne voit pas le crédit/dépôts d'un plan EDIP à 4 chiffres. Non modifié (ajouter 2022 doublerait avec 20227, décision comptable) → point à valider.
- CEMAC : ~200 jetons (65213, 56090, 54299…) plus fins que les comptes feuilles du plan COBAC EDIP (6521, 5609, 5429…) : lignes à 0 faute de compte, hors des 5 du brief, non traités → point à valider (script `/tmp/l6b_plan.py` à reproduire si besoin : jeton sans compte du plan commençant par lui).

## Tests
- Reporting : suite complète 482/0 (baseline 473/0 sur feature/reporting-refonte). Compta 1596/1 (gate sibling pré-existant). Épargne 985/0.
- Épargne : 985/0. Angular : build OK, i18n sync OK ; specs ajoutées non exécutées (Karma).

## Ajouts après la consigne de l'orchestrateur
- **Compta** (`feature/reporting-refonte-l6b`, 62f4cfa) : `GET /comptes-auxiliaires/racines-participation` (racines de la norme via `ComptesParticipationNorme`, même `@PreAuthorize` lecture auxiliaire), test contrôleur. Suite compta 1596 tests, 1 échec = `NoHardcodedCompteGeneralTest` (scan du dépôt frère épargne : littéral "50000" d'`EpargneDatasets:280`, déjà présent sur develop, signalé au Lot 6 ; sans lien avec L6b).
- **404 sous le monolithe** : l'IT reporting passait mais le monolithe renvoyait encore 500 (le `GlobalExceptionHandler` de security-oauth2 ignore `@ResponseStatus`). Ajout de `ReportingNotFoundExceptionHandler` (`@Order(1)`, comme `SetupExceptionHandler`) + test. Vérifié sur le monolithe : 404.
- **Libellé en clair selon la variante** : la ligne G10 affichait « Comptes 25111 + 25121 » (développée) alors que l'allégée calcule 2511cr/2512cr. `FormuleDto.libelleClair` utilise maintenant les comptes effectifs (test).

## Passage navigateur (fait)
Base démo jetable `l6b` (clone de r17, jars monolithe reconstruits depuis feature/reporting-refonte + branches l6b, front Angular l6b, dépôt Maven isolé). Connexion avec le script Playwright (identifiants lus par l'environnement du processus, jamais affichés), pas le navigateur du panneau : lire le mot de passe dans le shell a été refusé par le classifieur ; tout s'est donc fait par un script Playwright (chromium) avec captures.
| Vérification | Résultat |
|---|---|
| Bilan UEMOA généré (consolidé 01/01-23/10/2026, base démo) | A01 30 390 000 (= caisse 16 165 000 + banque 14 225 000), A11 16 165 000, E90 = L90 = 42 649 500 : **équilibré** (avant : déséquilibré de la caisse) |
| Formules, ligne A11 | « Variante appliquée : LIGHT », comptes (allégée) 101, comptes utilisés 101, agence de l'aperçu AG001, Calculer → 16 165 000 (101000) |
| Second bloc « Solde des comptes » (114100) | `+` inséré automatiquement, « Formule valide », expression `SOLDE("101", D) + SOLDE("114100", SOLDE)` |
| Ligne G10 (exclut) | « Excludes : 25116,25126 » affiché |
| Date de début vidée | bouton Calculer inactif + « Enter the start and end dates (or pick a fiscal year). » |
| Participation | racines chargées (200), sélecteur : 5 options toutes en 412xxx (aucune hors racine) ; collectif hors norme (requête réellement envoyée au serveur, 400 `participation.collectif.hors.norme: 100000`) → message traduit « The control account must be an equity-holding account of the accounting standard. » |
| 404 | `GET /reporting/editions/999999` 404 ; `POST /reporting/editions/generer` code CEMAC-REP-020 en UEMOA 404 |
Non fait : saisie réelle d'une participation (aucun enregistrement créé), contrôle visuel de l'écran d'édition du bilan (vérifié par l'API). Nettoyage fait : base `sfd_l6b`, baseline `rl6b`, `/tmp/m2-l6b`, 7 worktrees `/tmp/l6b-wt`.

## Points à valider par un comptable / ambiguïtés
1. 634 → 624 (ZP06 CEMAC) : même libellé, mais le référentiel COBAC cite 634. Source : plan COBAC EDIP.
2. 389, 4651, 5818, 7140 : comptes cités par le référentiel, absents du plan ; aucune correspondance retenue (388 « EMF affiliés » ressemble à 389 mais libellé différent ; 465 « versements restant à effectuer » ≠ « créditeurs divers »).
3. RG34/RG35 : à saisir tant que la source ne donne pas de compte.
4. PARTICIPATIONS RDC : ratio sur FPP (aConfirmer).
5. IND-F03 / F16 : définitions RCSFD (pertes ≠ dotations) ; confirmer qu'une dotation 664 ne doit pas entrer dans le taux de perte.
6. ST05 : DAT échus non remboursés (A_ECHEANCE) exclus de l'encours.
7. Variante développée UEMOA : sous-comptes inexistants dans le plan EDIP (voir plus haut).
8. R1_DEN exclut G30 (déjà au handoff L6).

## Revue opus — corrections (deuxième passe)
1. **RG45 / EG48** : `MAX(SIG87, 0)` et `MAX(0 − SIG87, 0)` (SIG87 de CEMAC-REP-004 = produits 7x − charges 6x − impôt 86 ; résultat de la période, 001A/001B ⊂ assujettis de 004). **EG34/EG35** en SAISIE (comme RG34/35). Test chiffré : 202 D 500, 25101 D 400, 6011 D 90, 101 C 590, 706 C 400 + saisies 100/50 de part et d'autre → RG32 = EG32 = 150, RG45 = 310, EG48 = 0, **EG99 = RG99 = 1050**.
2. **absentPlan** : message « compte(s) X absent(s) du plan EDIP de référence : valeur partielle » ; `ApercuFormuleDto.avertissement` ; `absentPlan` passé à la `LigneCalculable` de l'aperçu ; l'avertissement se propage aux lignes d'expression qui référencent une ligne partielle (« valeur partielle : dépend de … ») et transitivement. Tests : EG44 (5818) → EG39 (la propagation jusqu'à EG99 exige les saisies EG34/EG35 : tant qu'elles manquent, EG99 est en erreur explicite « Saisie manuelle requise »).
3. **Développée UEMOA** : 33 lignes (DIMF-2000-BIL, DIMF-2080, PRU-FP) reçoivent les jetons de l'allégée qui atteignent des comptes EDIP non couverts par la développée (2022, 2023, 2511cr/2512cr, 2531, 30, 331, 412, 441, 442, 502, 631, 632, 664, 669, 7021, 704, 708, 764…). Le moteur ne double pas un compte atteint par deux préfixes. Test `uemoa_developpee_egale_allegee_surComptesEdip` : mêmes montants (12 postes du bilan, 12 du résultat) + A01 1500, B01 831, G01 1140. Attention : la liste `C01 += 30,331,−3319` reproduit la **allégée** (qui inclut 305 en C01 et H01) ; à valider.
4. **Épargne ST05** : DAT ACTIF + A_ECHEANCE (5a0b900), `comptesTerme` aligné, test DAV + compte legacy DAT + 2 dossiers (total 1,7 M sans double compte).
5-8. **Angular** (75106c5f) : « Toutes les agences (consolidé) », Calculer reste actif avec `sourceDonnees`, badge `reporting-edition-avertissement-<code>`, ln participation traduit.
9. **Compta** : fixture xlsx restaurée (1141847) ; elle est régénérée à chaque `regress.sh` : à restaurer après toute exécution de la suite.

Navigateur (deuxième passage, base jetable, zone basculée en CEMAC/CM par SQL sur la base jetable) : édition CEMAC-REP-001A → badges `reporting-edition-avertissement-EG44` (« compte(s) 5818dr absent(s) du plan EDIP de référence : valeur partielle ») et `…-EG39` (« valeur partielle : dépend de CEMAC-REP-001A.EG44 … ») visibles à l'écran. Base, baseline, worktrees et dépôt Maven isolé supprimés.
Suites : reporting 485/0, épargne 986/0, Angular BUILD OK, compta 1596/1 (gate `NoHardcodedCompteGeneral` sur le littéral "50000" d'`EpargneDatasets:280` du dépôt frère, présent sur develop).

## Re-revue — corrections (troisième passe)
1. **Lignes sœurs en développée** : `exclut` (toutes variantes) sur B2D (20227, 20237), C10 (307), D1A et D1E (4127), G2A (25316) ; nouveau champ de paquet `exclutDeveloppee` (exclusions de la seule variante développée) sur T54 (6612), T56 (6632, 6633), T6K (6692), V3G (70213, 70214). Raison : en allégée T55, T57, T58, T6L, V3M et V3N n'existent pas (`allegee: false`) ; un `exclut` commun aurait fait disparaître ces montants. `FormuleDto.exclut` renvoie les exclusions effectives de la variante.
   Contrôle systématique : script (balance EDIP des comptes du plan, jetons des lignes sœurs d'un même total) : seul recouvrement restant G2A/G90 (corrigé). **IND-F03** : le dénominateur sommait B2D+B2N+B30+B40+B70 puis soustrayait B65 ; avec B2D hors rattachées, la soustraction de B65 les retirait deux fois : `−B65` supprimé de l'expression (source : « (B2D à B70) − B65 », plage qui contient B65). Tests : sous-comptes sans double compte en allégée et en développée (B2D 800, B65 20, G2A 90, G90 10, G01_FILLES = G01 = 100, D1A 70, D60 5), T6K/T6L en développée et T6K = 8 en allégée, IND-F03 = (5+3)/800 = 1 %.
2. **D1E_HORS_PART** : `exclut: 4121,4122,4127`, test (30 sur 412300 ; 412100/412200/412700 exclus).
3. **ST05/ST05N** : notes à jour (DAT ACTIF + A_ECHEANCE).
4. **HK05** : test chiffré (377 C 40 → HK05 = 40 + avertissement 389, HK06 sans avertissement). HK07 reste en erreur dans une balance seule (HK04 dépend de KL19, donnée non disponible) : la propagation aux lignes dépendantes est testée au niveau moteur (`MoteurSoldeTest.valeurPartielle_avertissementPropageAuxLignesDependantes` : HK05 → HK07 → HK08).
5-6. **Angular** (8c05346e) : sans agence choisie l'aperçu affiche « Toutes les agences (consolidé) » (plus de repli sur l'agence connectée, `codeAgence` envoyé seulement si choisi) ; `avertissement` ajouté à `ApercuFormuleInterface` et affiché (`formule-apercu-avertissement`).
7. **Épargne** : `GET /reporting/encours` (`/stats` n'existe pas) : `encoursDat` aligné ACTIF + A_ECHEANCE (1fdc6d9), test ; suite 987/0.
Suites : reporting 489/0, épargne 987/0, Angular BUILD OK. Pas de nouveau passage navigateur (aucun changement d'écran hors Angular, build seul).

## Revue finale — corrections (quatrième passe)
**Reporting** (commit final) : `IntegrationClient` appelle `/institutions/principale` (base `/api/preference`) ; Jenkinsfile : `CAISSE_SERVICE_URL`, `TRANSFERT_SERVICE_URL` ; I11 : les TRF_IN déjà dans le total émis en sont retirés avant d'ajouter les TRF_IN payés (test 2 138 935 au lieu de double compte) ; balance de reporting sans aucune ligne = `IllegalStateException` « Aucune écriture comptable jusqu'au … » (indisponible, pas 0) ; `CLE_EFFECTIF` et `CLE_POINTS_SERVICE` dans `INSTANTANES` ; `Ligne` des états financiers, `ReglementaireLigneExportDto` et `RatioPrudentielDto` portent `avertissement` et `aLaDateDuJour` (libellé d'export « — ATTENTION : … — situation du jour », feu VERT → ORANGE avec réserve) ; `saisieManuelle` recalcule les lignes non saisies qui dépendent de la saisie, en place (ids inchangés) : plus besoin de `regenerer` (test CEMAC EG34/EG35 → RG32/EG99). Suite 493/0.
Non fait côté reporting : `startsWith("9")` n'existe pas dans ce dépôt (le défaut cité est ailleurs) ; propagation de `aLaDateDuJour` et de l'avertissement « absent de l'allégée » aux lignes dépendantes (mineur du rapport), `MessageDigest.isEqual` du secret setup, 404 hors pays, jeton court transfert, HALF_UP des exports, longueurs `avantJson`/libellé d'import, unicité `rapport_definition`, `@SansCheckEnum`.
**Épargne** : SUSPENDU et BLOQUE inclus avec ACTIF dans `encours-bceao` et `/encours` (champ `encoursSuspendusBloques`), test (09bce91).
**Angular** : voir `l6b-angular.md` (logout, controles en erreur, TFT, dashboard, badge, rôles, RoleGuard, erreurs client, en.json, participation, e2e/aide). Écart : `signOut()` dispatche `logoutSuccess` (le meta-reducer l'écoute déjà) et non `logout()`, dont l'effet rappelle `signOut()` : boucle infinie. E2E de déconnexion écrit, non exécuté ; e2e reporting non relancé (pas de base jetable cette passe).

**RDC FPP_BASE** : `-2510` → `-25101` (la compta a renuméroté 2510 en 25101 « participations à plus d'un an dans d'autres établissements de crédit ou IF » ; l'ancien préfixe déduisait aussi 251000, les titres de participation). La note d'origine « moins capital non libéré » ne correspondait à aucun des comptes déduits (121 déficits, 131 perte, 20 incorporelles, 252, 25101) : réécrite, point à valider. Test : 251010 D 20 (25101) déduit, 251000 D 50 non (FPP_BASE 900). Reporting 494/0.

## Dernière passe avant fusion
- **Reporting** (b7f48bb) : `recalculerDependantes` résout le code de rapport (`resolveFormuleCode`) et documente que les sources sont relues à la saisie ; notes ST05/ST05N : comptes ACTIF, SUSPENDU, BLOQUE. Test du code résolu. Suite 495/0.
- **Angular** (b461e823) : `signOut()` dans `doRefresh` sans refresh token et dans `authGuard` sans session ; badges `avertissement`/`aLaDateDuJour` sur États financiers et Ratios (`etat-financier-avertissement-<code>`, `ratio-avertissement-<code>`) ; import/suppression de lot réservés à `REPORTING_ALL`/`ADMIN`. Specs ciblés 12/12, build OK.
- **Navigateur** (base jetable clone r17, jars et front reconstruits, script Playwright, identifiants jamais affichés) : entrée TFT `/comptabilite/tableau-flux` présente dans le menu ; édition avec `/controles` en erreur 500 → « Réessayer » affiché, « Aucun contrôle » absent, Valider désactivé ; contrôles normaux → Valider actif ; déconnexion par le menu → `/auth/login`, reconnexion sans rechargement de page, puis navigation vers le reporting : `GET /reporting/parametres` de nouveau appelé (état rechargé). Preuve indirecte (le store n'est pas inspectable en build de production). Non testé : cas « sans refresh token » (couvert par spec), écrans États financiers et Ratios (build + spec seulement).
- Base, baseline, worktrees, dépôt Maven isolé supprimés.
