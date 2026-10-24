# Lot 6 — intégration, e2e, exactitude (notes de travail, mises à jour au fil de l'eau)

Environnement : worktrees détachés /tmp/l6-wt/<repo> sur les SHA du brief ; dépôt Maven /tmp/m2-refonte ; baseline copiée ~/.edip-baselines/rrefonte-tg (clone de r17, front reconstruit depuis angular 0ef93b6a) ; env rep-uemoa (:8100/:4300). Scripts : scratchpad de la session.

## Suites (départ → final), 0 push
| Dépôt | Départ (handoffs) | Final L6 |
|---|---|---|
| commun | — | 466/0 |
| compta | 1573/0 (3 ign.) | 1594/1 (3 ign.) : `NoHardcodedCompteGeneralTest` — le test scanne les dépôts frères (`../sfd-epargne-service`, `../sfd-credit-service`) ; il relève `"50000"` (EpargneDatasets:280, exemple de colonne) et `"150000"` (CreditDatasets:278), littéraux présents aussi sur `develop` (git grep) : pas une régression de la refonte, à traiter à part (ajouter ces fichiers `*Datasets` aux exclusions du gate). Mesure identique avec ou sans le correctif banques-url |
| crédit | 694/0 | 701/0 (14 ign.) |
| épargne | — | 984/0 |
| transfert | — | 79/0 |
| caisse | — | 224/0 |
| client | — | 1483/0 |
| RH | — | 533/0 |
| reporting | 421/0 (S10) | 471/0 → 472/0 avec L6 libellé clair |
| monolithe | 33 erreurs (jar develop) | 33 erreurs → 1 échec → **162/0** (re-mesuré après les 3 commits wiring) |
| angular | BUILD OK | BUILD OK (25 warnings) |

## Correctifs L6 (branches -l6-, non fusionnées)
1. reporting `feature/reporting-refonte-l6-importlot` 6557a4d : `@Entity(name="ReportingImportLot")`. Cause : doublon d'entité `ImportLot` avec le module d'import commun, contexte Spring du monolithe KO (32 des 33 erreurs).
2. client `feature/reporting-refonte-l6-purge` 7ef1216 : contrôles de purge (6 SQL + liste) pour categorie_initie_client, lien_client, groupe_risque_membre. Cause : MonolithPurgeClesEtrangeresTest (FK vers client non couvertes).
3. monolithe `feature/reporting-refonte-l6-wiring` (6bb3392, 3 commits : 3eef51d, 0734e00, 6bb3392) : 3eef51d `sfd.rh.base-url` (RhEmployesClient lisait le port 4602 → personnelRhIndisponible=true) ; 0734e00 `comptabiliteWebClient` base `/api` (le reporting préfixe déjà `/comptabilite` : URL `/api/comptabilite/comptabilite/reporting/balance` → 404 → toutes les éditions INTEGRE en erreur « Balance comptable indisponible »).
4. reporting `feature/reporting-refonte-l6-libelle-clair` 5f8344d (empile importlot) : libellé clair des références « DIMF-2000-BIL.A10 » rendu « DIMF − 2000 − BIL.A10 ».
5. compta `feature/reporting-refonte-l6-banques-url` 2e0f910 (tests ciblés BanqueCommunClientTest + ReportingCollecteServiceTest OK) + monolithe wiring (commit « endpoint des banques ») : `BanqueCommunClient` appelait `/preference/banques` sur une base déjà `/api/preference` dans le monolithe (404 → 503 sur `GET /comptabilite/reporting/tresorerie/contreparties`). Chemin configurable `app.preference.endpoints.banques` (défaut inchangé), `/banques` dans le monolithe.

## UEMOA (TG) — résultats (base rep-uemoa, jar L6)
e2e `reporting-reglementaire` 24/24, client groupes-risque + initiés/liens 4/4 (2 specs), crud reporting 11/11. Aucun e2e n'existe pour : catégorie COBAC des garanties, Banque/type de contrepartie, auxiliaire Participation (vérifiés à la main dans le navigateur interne, voir plus bas).
Vérifications reportées OK : 6 endpoints C1 (200 ; TEG vide : dossiers antérieurs à D3, gestionnaires vides : agent.credit@sfd.com non rapproché), T1 (caisse/épargne/transfert avec periodeDebut+periodeFin), K1 inities/groupes-risque, personnel RH (CLI003 lié à un employé → PERSONNEL ; personnelRhIndisponible passe de true à false après le correctif de câblage), classe 9 : suppression des 92 comptes C9 puis `POST /comptabilite/setup/init?institutionId=1` → accountsCreated=92, 383 autres intacts.
Écran catégorie COBAC : GARANTIES 1-2 enregistrée (« Modification effectuée »). Écran Banque : BCEAO → Autre. Écran Participations : refus API d'un collectif hors racine 412 (`participation.collectif.hors.norme: 100000`, message brut non traduit), création sur 412000 OK, apparaît dans l'écran et dans `/reporting/participations`.
STANDALONE : modèle = onglet Balance + 3 annexes (DIMF-2011.I11_AUTRES_OPS_CALC, DIMF-2012.I12_MAX, DIMF-2013.I13_TOTAL) ; import (preview + confirm, 15 comptes, équilibré) ; BIL, CR, R5 générés en IMPORT = valeurs identiques à INTEGRE (0 écart) ; export ZIP (xlsx + manifest.json) OK. Mode remis en INTEGRE, lot supprimé.
Formules (navigateur) : A11 « Billets et monnaies » : bloc solde des comptes passé en expression `SOLDE("101", D) + SOLDE("114100", D)`, aperçu 30 395 000 (101000 16 170 000 + 114100 14 225 000), enregistrement → PERSONNALISÉE, édition régénérée A11 = 30 395 000, « Réinitialiser » du rapport → PAQUET. Indicateur : ouverture du rapport « Coefficient de liquidité », contrôle du libellé clair (bug corrigé, point 4) ; modification d'un indicateur non faite dans l'UI (couvert par l'e2e configuration).
Cloisonnement UEMOA : `/rapports/CEMAC-REP-020/formules` 404, `/references` 404, `localisation` et `tableau-periode` 54 rapports DIMF/UEMOA uniquement. Écart : `POST /editions/generer` avec un code CEMAC renvoie 500 (« Rapport inconnu ou sans formule pour votre périmètre ») au lieu de 404.

## CEMAC (CM) et RDC (CD)
Le seed démo est refusé pour ces deux pays : « la norme comptable du pays CM n'a pas de rôles comptables complets (roles-comptables.yml absent ou incomplet) » (COBAC et PCCI). Bases créées avec le wizard **sans démo** (script edip-env copié et étendu : organisation CEMAC/norme COBAC, RDC/PCCI), plan comptable chargé (CM 1159 comptes ; CD 495), paramètres reporting CEMAC-COBAC/CM et RDC-BCC/CD, modèle STANDALONE puis balance synthétique équilibrée (81 comptes CM, 60 CD, tirés des préfixes des formules), annexes remplies. Conséquence : pas de cross-service réel ni de comptabilité intégrée sur ces zones ; le cross-service CEMAC a été vérifié sur la base démo TG avec la zone reporting basculée en CEMAC (méthode S10).
Cloisonnement : UEMOA ne voit aucun rapport CEMAC (formules, références, tableau-période 54 rapports DIMF/UEMOA, localisation) ; CEMAC et RDC ne voient aucun rapport UEMOA. Id de formule d'une autre zone (id 1 = UEMOA, présent dans la base CEMAC et RDC) : 404. ZIP avec un code d'une autre zone : 404. Écart : `POST /editions/generer` avec un code d'une autre zone renvoie 500 (« Rapport inconnu ou sans formule pour votre périmètre »), `GET /editions/999` (inexistant) 500 aussi : attendu 404.
STANDALONE : modèle CEMAC = Balance + 26 onglets (JT18, KL19, VL08, DA02/04, DB02/04, PA02M, CS01/CS02, ST02H/F, ST03, ST04, ST05, ST05N, ST06A/B, ST07A-D, ST08A/B, ST09A/B), RDC = Balance + 4 onglets (029.RISQUE_CLIENT_IMF_MONTANT, 029.RISQUE_MEMBRE_COOPEC_MONTANT, 030.CRD_EN_RETARD, 030.EMPR_PAR_AGENT), UEMOA = Balance + 3. Import, génération, export ZIP (xlsx/pdf + manifest) OK sur les 3 zones.

## Exactitude : méthode
Recalcul indépendant (script Python hors moteur) : pour chaque ligne à comptes simples, somme des soldes de la balance (API `/comptabilite/reporting/balance` en INTEGRE, ou balance importée) par préfixe, suffixes dr/cr, déduction `-`. Limite : `exclut` n'est pas exposé par `FormuleDto` (il n'est pas non plus affiché dans l'écran Formules, sauf s'il figure dans la note) : les 2 écarts apparents (CEMAC RG17 −50 000 : exclut 35109 ; YG21 −1 200 000 : exclut 792) sont la bonne application de `exclut`. Totaux, ratios et indicateurs recalculés à la main depuis les lignes.
Comparaisons : UEMOA 424 lignes à comptes (31 non nulles) 0 écart moteur/formule ; CEMAC 123 lignes (68 non nulles) 0 écart réel ; RDC 55 lignes (53 non nulles) 0 écart.

### UEMOA (TG, démo, consolidé 01/01-23/10/2026, plan allégé par défaut)
| Ligne | Édition | Recalcul à la main | Écart | Cause |
|---|---|---|---|---|
| DIMF-2000-BIL.A01 (trésorerie) | 14 225 000 | 30 395 000 (101000 16 170 000 + 114100 14 225 000 ; = total trésorerie de `/tresorerie/contreparties`) | −16 170 000 | **`comptesAllegee` « 1011 » ne correspond à aucun compte du plan EDIP (101000)** : la caisse sort du poste |
| A11 Billets et monnaies | 0 | 16 170 000 | −16 170 000 | idem (comptesAllegee '1011') |
| A10 Valeur en caisse | 16 170 000 | 16 170 000 | 0 | formule '10' |
| A12 Comptes ordinaires débiteurs | 14 225 000 | 14 225 000 | 0 | |
| B01 Opérations membres | 12 800 000 | 12 800 000 (13 000 000 − 200 000) | 0 | |
| B2D / B70 | 13 000 000 / −200 000 | idem | 0 | |
| G01 Dépôts | 15 654 500 | 15 654 500 (15 649 500 + 5 000, G2A −12 500 et G30 +12 500 se compensent) | 0 | |
| L01 Fonds propres / L60 Capital | 27 000 000 / 25 000 000 | idem | 0 | |
| L75 Excédent | 540 500 | 540 500 (produits 1 215 500 − charges 675 000) | 0 | |
| DIMF-2080 T84 / X84 | 675 000 / 1 215 500 | idem | 0 | résultat CR = résultat bilan (540 500) |
| E90 Total actif | 26 484 500 | 42 654 500 | −16 170 000 | cause A01 ; L90 total passif 42 654 500 : **bilan déséquilibré** à cause de A01, équilibré après correction |
| IND-F17 rendement des actifs | 10,995 % | 4,46 % (1 215 500 / 27 225 000) | +6,53 pts | A01 − A10 négatif (−1 945 000) |
| IND-F18 liquidité de l'actif | 114,77 % | 71,26 % (30 395 000 / 42 654 500) | +43,5 pts | E90 |
| IND-F19 capitalisation | 101,95 % | 63,30 % (27 000 000 / 42 654 500) | +38,7 pts | E90 |
| PRU-08 R8_DEN | 26 484 500 | 42 654 500 | −16 170 000 | E90 ; R8_NUM en ERREUR (saisies FP_DED_PROV, FP_DED_PART) : normal |
| PRU-05 R5 (R5_NUM 43 395 000 / R5_DEN 15 654 500) | 277,20 % | 277,20 % | 0 | |
| PRU-01 R1_DEN | 42 642 000 | 42 642 000 (F..G2A −12 500 + G10 + G35 + L01) | 0 | G30 (dépôts de garantie) non inclus par la formule : à confirmer |
Lignes en erreur explicite (jamais 0) : D32-D35 « NON_TROUVE », 14 lignes d'IND-FIN « Formule non définie », FP_DED_* « Saisie manuelle requise ». IND-F03 = 0 (aucune perte) et IND-F16 = 0 : dénominateur sans résultat d'exploitation, à regarder (les dotations T6K/T6L valent 0 alors que 664100 porte 200 000 : poste T6C/T6D, pas T6K/L ; à valider).
Hors-bilan : 0 ligne non nulle sur la base démo (aucun compte de classe 9 mouvementé) : signe non vérifiable sur données ; les 15+17 lignes `C`/`D` de la classe 9 sont testées en unitaire (S10).
Cross-service (module vs compta) : crédit encours 15 675 693 (module) vs compta 202200 13 000 000 ; épargne dépôts : compta 15 654 500 vs module 6 100 000 (comptes) + DAT 17 082 500 : les données démo des modules et la compta ne se recoupent pas ; les états DIMF lisent la compta uniquement, sans impact sur ces écarts.

### CEMAC (CM, STANDALONE, balance synthétique 81 comptes, CAT2)
| Ligne | Édition | Recalcul | Écart | Cause |
|---|---|---|---|---|
| 001B.RG02 Capital social | 18 605 000 | 18 605 000 (101300) | 0 | |
| RG03 Actionnaires capital non appelé | −260 000 | −260 000 | 0 | |
| RG04 Primes / RG06 Réserves oblig. / RG07 libres | 750 000 / 480 000 / 3 125 000 | idem | 0 | |
| RG08 Report / RG09 / RG10 / RG13 | 50 000 / 260 000 / 1 200 000 / 1 200 000 | idem | 0 | |
| RG17 Dépôts à régime spécial | 6 480 000 | 6 530 000 | −50 000 | **voulu** : `exclut 35109` (351090 Bons de caisse réseau, 50 000) |
| RG19 / RG20 | 125 000 / 3 000 000 | idem | 0 | |
| 002B.YG05 / YG07 / YG09 / YG17 | 480 000 / 125 000 / 750 000 / 1 200 000 | idem | 0 | |
| YG21 Autres reprises | 0 | 1 200 000 (79) | −1 200 000 | **voulu** : `exclut 792` |
| YG99 Total produits | 2 555 000 | 2 555 000 (Σ crédits classe 7) | 0 | |
| 004.SIG83 résultat courant | −3 885 000 | −3 885 000 (classe 7 2 555 000 − classe 6 6 440 000) | 0 | |
| SIG87 résultat net | −4 635 000 | −4 635 000 (− impôt 860000 750 000) | 0 | |
| 007.KL25 Fonds propres nets (KL12 25 410 000 − KL20 3 582 000 + KL24 4 010 000) | 25 838 000 | 25 838 000 | 0 | = VL01 de REP-009 |
| 009.VL10 ratio couverture | 429,06 % | 25 838 000 / (6 125 000 − 103 000) = 429,06 % | 0 | VL08 saisie 103 000 |
| 020.ST01 capital CAT2 | 18 605 000 | 18 605 000 (ST01A, 101300) | 0 | CAT1 (ST01B) non rejoué |
| 001B.RG99 total passif | ERREUR | — | — | RG34 « Formule non définie » : une ligne sans formule bloque tous les totaux dépendants : bilan non contrôlable |
Cross-service CEMAC (base TG, zone basculée CEMAC/CM, INTEGRE) : ST02H 6 / ST02F 4 = `client/reporting/bceao/stats` ; ST05 6 100 000 = `epargne encours-bceao.encoursDepotTotal` ; ST05N 13 = 6 vue + 4 terme + 3 épargne ; ST06A 15 675 693 et ST06B 3 633 333 = `credit bceao/encours` ; ST06C = A − B = 12 042 360 ; ST07A 14 225 000 / ST07D 16 165 000 (caisses, solde compta) ; ST08A/B 6,5 / 4,5 = taux dépôts min/max ; ST09A/B en erreur explicite (« Aucun crédit avec TEG décaissé sur la période (6 dossiers sans TEG) »). DA02/DB02 en erreur car le plan TG n'a pas de compte 942 (artefact de la zone basculée, message explicite du service compta). CEMAC-REP-019 CS02 = 0 (aucun douteux).
**Constat ST05** : `encoursDepotTotal` = Σ `compte_epargne` actifs (6 100 000) alors que DAT actifs = 17 082 500 et `autres = max(0, total − vue − terme)` = 0 masque l'incohérence : le code suppose que les DAT sont inclus dans le total. Si les DAT ne sont pas dans `compte_epargne`, ST05 est sous-évalué (point à valider).

### RDC (CD, STANDALONE, balance synthétique 60 comptes, IMF)
| Ligne | Édition | Recalcul | Écart | Cause |
|---|---|---|---|---|
| 001.A_CAISSE / A_BANQUE | 480 000 / 750 000 | idem | 0 | |
| A_CRED_CT / MT / LT | 125 000 / 1 200 000 / 125 000 | idem | 0 | |
| A_LITIGIEUX / A_PROVISIONS | −1 235 000 / 1 380 000 | idem | 0 | |
| A_IMMO | 8 870 000 | idem | 0 | |
| P_EPARGNES / P_DAT | 2 525 000 / 750 000 | idem | 0 | |
| P_CAPITAL / P_RESULTAT | 750 000 / −625 000 (130 − 131) | idem | 0 | résultat du bilan = comptes 13x, résultat du CR = compte 87 (−1 200 000) : équivalents seulement balance clôturée |
| TOTAL_ACTIF vs TOTAL_PASSIF | 11 355 000 / 13 600 000 | — | 2 245 000 | balance synthétique non clôturée (classes 6/7 hors bilan) ; P_EMPRUNTS_TRESO sans formule : à contrôler sur une vraie balance |
| 011 RET_61_90 / PROV_61_90 | −750 000 / 480 000 | idem | 0 | |
| 029.LIQUIDITE | 0,4871 | 1 230 000 / 2 525 000 = 0,4871 | 0 | |
| 029.COUV_EMPLOIS | 0,3694 | (2 560 000 + 750 000) / 8 960 000 | 0 | |
| 029.SOLVABILITE | 6,3602 | 2 560 000 / 402 500 | 0 | |
| 029.RISQUES_TOTAL_COOPEC | 0,1772 | 900 000 / 5 080 000 | 0 | |
| 029.PARTICIPATIONS | 3 875 000 (montant) | — | — | **la formule `25` renvoie un montant mais la norme est un ratio (0,25)** : conformité toujours NON_CONFORME ; devrait être `25 / FPP` (la validation accepte `25 / FPP`) |
Lignes en erreur explicite : APPARENTES, POSITION_CHANGE_*, CAPITALISATION (« Formule non définie »), 030 « MOYENNE_PERIODE non gérée par le moteur ».

## Frictions UX (Formules et édition)
1. Écran Formules : le libellé affiche la formule **développée** (« Comptes 101 ») alors que l'édition utilise la **allégée** (« 1011 ») et que l'aperçu en direct applique aussi l'allégée : l'aperçu affiche 0 pour « Comptes 101 » sans explication ; l'utilisateur ne voit jamais `comptesAllegee`.
2. Ajouter un compte crée un 2e bloc « Solde des comptes » sans opérateur : message « Caractère inattendu « S » en position 17 » (technique). Il faut passer en « Mode avancé » pour écrire `+`.
3. Libellés clairs des références `DIMF-2000-BIL.A10` rendus « DIMF − 2000 − BIL.A10 » : corrigé (branche l6-libelle-clair).
4. `exclut` (exclusions de comptes) n'est affiché nulle part dans l'écran Formules.
5. Le bouton « Calculer » de l'aperçu est inactif tant que la formule est invalide, sans indication ; l'aperçu utilise l'agence connectée (AG001) sans l'afficher dans le champ « Choisir une agence ».
6. Date « fin de période » par défaut = fin de mois : en STANDALONE aucun import à cette date, le message « Aucune balance importée pour le 2026-10-31 (importez la balance dans Données importées) » est clair mais il faut ressaisir la date (champ date natif).
7. Message d'erreur participation brut : `participation.collectif.hors.norme: 100000` (clé i18n non traduite).
8. Saisie « Compte de participation » : le sélecteur propose tout le plan (100000 en tête) alors que seuls les comptes sous la racine 412 sont acceptés ; l'erreur n'arrive qu'à l'enregistrement.
9. Réinitialiser un rapport : modale de confirmation correcte ; réinitialiser une ligne seule non essayé.

## Incident machine
En tuant un PID présumé de mon monolithe de seed (5910), j'ai tué `com.docker.virtualization` (Docker Desktop) vers 00:30. Relancé par `open -a Docker` ; pg_container/pgadmin/rabbitmq repartis, 22 bases intactes. Orchestrateur prévenu.

## Points à valider par un comptable / ambiguïtés
1. Bilan UEMOA allégé : caisse = compte 101 du plan EDIP (101000) vs « 1011 » du paquet allégé (RCSFD annexe 1.1 : « 101/1011 »). Choix provisoire : rien modifié (deux tests de l'orchestrateur assertent '1011' : LocalisationRegistryTest:57 et LocalisationCloisonnementTest:364). Correctif proposé : `comptesAllegee: 101` sur A01 et A11 de DIMF-2000-BIL.yml + les 2 assertions. Source : paquet DIMF-2000-BIL.
2. R1_DEN UEMOA exclut G30 (dépôts de garantie reçus) : à confirmer (instruction prudentielle).
3. RDC-REP-029.PARTICIPATIONS : formule `25` (montant) contre norme 0,25 (ratio) : à remplacer par `25 / FPP` après validation.
4. ST05 : DAT inclus ou non dans `compte_epargne` (voir CEMAC).
5. IND-F03 / F16 UEMOA : lignes T6K, T6L et S02.. à 0 alors que 664100 porte 200 000 (dotations).
6. Purge des lots d'import : les tables K1 (initiés, liens, groupes de risque) bloquent la purge comme les autres dépendances ; à valider (purge en cascade possible à la place).
7. Seed démo CEMAC/RDC impossible tant que les rôles comptables COBAC/PCCI ne sont pas complets (hors périmètre refonte).
8. `/editions/generer` et `/editions/{id}` : 500 au lieu de 404 pour un code ou un id hors périmètre.
9. Course au démarrage : un `POST /reporting/setup/init` lancé pendant la synchro de démarrage échoue sur `uk_formule_rapport_zone_indicateur` (idempotent au 2e appel).

## Fin de session
Arrêtés et supprimés : envs rep-uemoa/cemac/rdc/xs/fin (processus, bases `sfd_rep_*`, `edipseed_*`, vhosts), baselines `rrefonte-*`, `/tmp/m2-refonte`, 11 worktrees détachés `/tmp/l6-wt/*`, fichiers d'auth temporaires. `~/.edip-baselines/latest` restauré sur r17 (baseline-create l'écrase). Les envs `edip-1` et `remise` d'autres sessions n'ont pas été touchés (pas de `down-all`). Rien de poussé. Seules traces dans les dépôts : les 5 branches `-l6-` ci-dessus (non fusionnées dans `feature/reporting-refonte`).
Ordre d'intégration conseillé : reporting importlot → libelle-clair, client purge, compta banques-url, monolithe wiring (le monolithe dépend des trois autres pour que sa suite passe : sans importlot 32 erreurs de contexte, sans purge 1 échec).
Non couvert : ST01B (CAT1 / affiliés) non rejoué ; réinitialisation d'une seule ligne de formule non essayée ; modification d'un indicateur dans l'UI non faite (e2e configuration passe) ; CROSS_SERVICE CEMAC/RDC hors zone TG ; hors-bilan non nul (pas de mouvement de classe 9 dans la démo) ; Angular : build seulement (`regress.sh sfd-angular`), pas de tests unitaires Angular.

## Compléments demandés par l'orchestrateur
### (a) Branches l6 restantes (après fusion de importlot et purge dans feature/reporting-refonte, branches locales supprimées)
| Dépôt | Branche | SHA | Diff |
|---|---|---|---|
| reporting | feature/reporting-refonte-l6-libelle-clair | 5f8344d | `FormuleLocalisationSupport` : regex de référence qualifiée `RAPPORT.LIGNE` (tirets non transformés en « − ») + 1 test ; empilée sur 6557a4d déjà intégré |
| compta | feature/reporting-refonte-l6-banques-url | 2e0f910 | `BanqueCommunClient` : chemin lu dans `app.preference.endpoints.banques` (défaut `/preference/banques`) + clé dans application.yml + 3 appels de test |
| monolithe | feature/reporting-refonte-l6-wiring | 6bb3392 (3eef51d, 0734e00, 6bb3392) | application.yml : `sfd.rh.base-url` et `app.preference.endpoints.banques: /banques` ; `MonolithWebClientConfig.comptabiliteWebClient` en base `/api` |
Fusionnées par l'orchestrateur : reporting 6557a4d (entité `ReportingImportLot`), client 7ef1216 (contrôles de purge K1).
### (b) Exactitude UEMOA en INTEGRE : voir tableau « UEMOA (TG, démo, consolidé…) » ci-dessus (lignes recalculées depuis la balance compta API contre l'édition générée en INTEGRE sur le jar final).
### (c) Refus du seed démo CEMAC et RDC
Cause : `ComptabiliteDemoDataLoader.verifierRolesNorme` (compta) appelle `roleComptableService.rolesNonDefinis(RoleComptable.requisPourDemo())` ; l'enum est dans `sfd-integration-api/.../comptabilite/RoleComptable.java` et exige **46 rôles** (CAISSE, BANQUE, MOBILE_MONEY, SFD_CORRESPONDANT, CREDIT_COURT/MOYEN_TERME, DECOUVERT, CREDIT_IMMOBILISE, CREANCES_RATTACHEES, CREDIT_SOUFFRANCE*, PROVISION_CREANCE_*, DOTATION_PROVISION_*, REPRISE_PROVISION, PERTE_IRRECOUVRABLE, COMPTE_VUE, EPARGNE_LIVRET, DEPOT_A_TERME, DEPOT_GARANTIE, AUTRES_DEPOTS_MEMBRE, …). Le fichier `roles-comptables.yml` n'existe que pour UEMOA (`sfd-comptabilite-service/src/main/resources/config/accounting-norms/uemoa/rcs_sfd/roles-comptables.yml`, 52 rôles). Les dossiers `cemac/cobac/` et `rdc/pcci/` ne contiennent que `journaux.yml`, `metadata.yml`, `plan-comptable.yml`, `plan-comptable-sfd-extension.yml` : **aucun rôle n'est défini**, donc les 46 sont manquants (message tronqué : « Rôles non définis : [CAISSE, BANQUE, MOBILE_MONEY, SFD_CORRESPONDANT, … »). Corriger = créer ces 2 fichiers avec les comptes du plan COBAC/PCCI (validation comptable requise, aucun compte par analogie).
### (d) Frictions UX : section « Frictions UX » ci-dessus (9 points).
