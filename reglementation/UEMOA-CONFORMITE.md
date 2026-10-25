# UEMOA / BCEAO — Conformité du reporting EDIP au référentiel SFD

- Zone : UEMOA (RCS_SFD) — Date : 2026-10-25 — Rédacteur : Claude (revue documentaire, aucun code modifié)
- Référentiel : [UEMOA-SFD-REFERENTIEL-EXTRAIT.md](UEMOA-SFD-REFERENTIEL-EXTRAIT.md) (sources dNN, F, n02 et pages). Points ouverts : [REPORTING_POINTS_A_VALIDER.md](REPORTING_POINTS_A_VALIDER.md), section « Lot R ».
- Code lu : worktree `uemoa-reporting` (origin/develop), `src/main/resources/localisation/UEMOA-BCEAO/rapports/*.yml` (noté `<fichier>:<ligne>`, préfixe `rapports/` omis), `source/ModulesProvider.java`, `moteur/MoteurCalcul.java`.
- Moteur (vérifié dans `MoteurCalcul.contribution`, l.640-689) : chaque compte de la balance est lu **une seule fois** par ligne ; un préfixe « − » l'emporte sur un « + ». Les listes qui mêlent racine et sous-comptes (ex. `2022,20221`) ne comptent donc pas en double **dans une même ligne**. Deux lignes distinctes peuvent en revanche se recouvrir (voir T6K/T6L).
- Statuts : **OK** = conforme au texte ; **écart** = calcul présent mais différent du texte ; **absent EDIP** = exigé par le texte, non calculé ; **hors texte** = présent dans EDIP sans base dans les textes lus, ou texte hors champ.
- Source de donnée retenue : **balance en priorité** ; module en repli quand la balance ne porte pas l'information (Crédit : échéancier, retards, décaissements ; Épargne : déposants ; Client : sexe, personne morale, groupement ; RH : effectifs, fonctions).

## 1. Ratios prudentiels (Instr. 010-08-2010, 016-12-2010)

| Élément | Texte (source, page) | Calcul EDIP actuel | Statut | Correction proposée | Source retenue |
|---|---|---|---|---|---|
| Fonds propres réglementaires (FP) | + L10…L80 ; − L62, E05\*, incorporels D24+D31+D41+D46, L70/L80 négatifs, compléments de provisions, participations FP dans SFD/EC ; L75 et E05 en infra-annuel seulement (d06 p.7-8 ; d07 p.4-5) | `UEMOA-REP-PRU-FP.yml:33-37` : `…+L70+L75+L80−E05−(D24+D31+D41+D46)−FP_DED_PROV−FP_DED_PART`. L75 (`DIMF-2000-BIL.yml:1047`) = 70…77 − 60…67 et E05 (`:606`) = 60…67 − 70…77, **tous deux signés** : en cours d'exercice, FP compte **2 × (produits − charges)** | **écart** (majeur) | E05 = MAX(charges − produits ; 0) et L75 = MAX(produits − charges ; 0) (MIN/MAX déjà supportés, `moteur/Expression.java:302`) ; FP_DED_PROV et FP_DED_PART restent en saisie (U22) | balance ; saisie pour les compléments exigés par les Autorités |
| R1 limitation des risques | risques nets des provisions **et des dépôts de garantie** / ressources ; ≤ 200 % ; mensuel art. 44, trimestriel autres (d06 p.4, p.19) | `UEMOA-REP-PRU-01.yml:15-32` : postes conformes ; dépôts de garantie **non déduits** (note « À CONFIRMER », l.18) ; N1A…Q1A lus dans `DIMF-2000-HB` | **écart** | déduire les dépôts de garantie reçus des débiteurs (2545), globalement ou par débiteur plafonné à son encours, après décision R2 du lot R | balance (2545) ; module Crédit si imputation par débiteur |
| R2 couverture des emplois MLT | ressources et emplois à **durée résiduelle > 12 mois** ; ≥ 100 % ; trimestriel (d06 p.5-6) | `UEMOA-REP-PRU-02.yml:15-24` : soldes entiers ; le filtre résiduel n'existe qu'en note (l.18) | **écart** | ventiler par échéance résiduelle B30/B40/B70 (échéancier) et G15/G2A/G60 (échéances) ; postes sans échéance (L01, D1E, D23…) en entier | modules Crédit et Épargne (échéances) ; balance pour le reste |
| R3 prêts aux dirigeants, personnel, personnes liées | encours brut des **prêts et engagements par signature** / FP ; ≤ 10 % (d06 p.7-8) | `UEMOA-REP-PRU-03.yml:15-18` → `DIMF-2013.yml:16` I13_TOTAL (Client + Crédit) **sans engagements par signature** (note l.19) | **écart** | ajouter les engagements par signature donnés aux mêmes personnes ; dénominateur après correction de FP | modules Client (initiés) + Crédit ; engagements par tiers (classe 9) |
| R4 une seule signature | prêts **et engagements de financement et de garantie** au plus gros emprunteur, **structures qu'il contrôle comprises** / FP ; ≤ 10 % (d06 p.9-10) | `UEMOA-REP-PRU-04.yml:15-18` → `DIMF-2012.yml:19` I12_MAX : plus gros encours de crédit d'un client, sans hors bilan ni regroupement (U17) | **écart** | agréger par groupe (liens de contrôle du module Client) et ajouter les engagements donnés | modules Crédit (encours par client) + Client (liens) |
| R5 liquidité | actifs et passifs à **≤ 3 mois** résiduels ; ≥ 100 / 80 / 60 % selon catégorie (d06 p.11-12) | `UEMOA-REP-PRU-05.yml:16-45` : soldes entiers (B30 et B40 en entier) ; normes par catégorie présentes | **écart** | même ventilation résiduelle que R2, à ≤ 3 mois ; catégorie lue dans `categorieAssujetti` | modules Crédit, Épargne (échéances) ; balance |
| R6 opérations autres que l'épargne et le crédit | montant hors art. 4 / risques du ratio I sans A2A ; ≤ 5 % (d06 p.13) | `UEMOA-REP-PRU-06.yml:15-24` : I11_AUTRES_OPS (transferts + change + saisie) / liste sans A2A | **OK** | — | modules Transfert, Caisse ; saisie (assurance, mobile money) |
| R7 réserve générale | dotation ≥ 15 % × (L80 + L70 déficitaire) (d06 p.14) | `UEMOA-REP-PRU-07.yml:15-28` : `(L80+MIN(L70,0))×0,15` | **OK** | option : comparer à la dotation effective (DIMF 2016, ligne 772) | balance |
| R8 capitalisation | FP / total actif net ≥ 15 % ; mensuel (d06 p.15-16) | `UEMOA-REP-PRU-08.yml:15-32` : FP / E90 | **écart** (induit) | corriger FP et E90 (§ 3, E05/L75) | balance |
| R9 participations | D1E hors EC et SFD, **nets** / FP ≤ 25 % (d06 p.17) | `UEMOA-REP-PRU-09.yml:15-18` → `UEMOA-REP-PRU-FP.yml:20-32` : D1E_HORS_PART = 4123, 4124, 4125 en développée ; 412 entier en allégée ; provision 4129 non déduite | **écart** | déduire 4129 (par auxiliaire de participation ou au prorata) ; en allégée, exclure les participations EC/SFD par l'auxiliaire PARTICIPATION déjà lu (`ModulesProvider.java`, `plusFortePArticipation`) | balance + auxiliaires de participation |
| R10 immobilisations et participations | D24, D25, D31 hors frais immobilisés, D36, D41, D45, D46/D47 hors biens acquis par garantie depuis < 2 ans, D1E hors SFD/EC / FP ≤ 100 % ; trimestriel (d07 p.1-2, p.4-5) | `UEMOA-REP-PRU-10.yml:15-33` : D31, D46, D47 pris en entier (note l.18) | **écart** | date d'acquisition (ou saisie) pour D46/D47 < 2 ans ; exclure 4412 (frais d'établissement, D34) de D31 | balance + module Immobilisations (date d'entrée) |
| État récapitulatif annuel | ratios au 31/12, 3 exemplaires, 6 mois (d06 art. 3-4, p.2) | `UEMOA-REP-PRU-ANN.yml:1-21` (document, 180 j) | **OK** | — | — |

## 2. Indicateurs périodiques (Instr. 020-12-2010)

Périodicité et délai : `UEMOA-REP-IND-FIN.yml:3-11` et `UEMOA-REP-IND-NF.yml:3-11` (mensuel art. 44, trimestriel autres, 30 jours) : **OK** (d11 p.1-2).

| Indicateur | Texte (d11, page) | Calcul EDIP actuel (`UEMOA-REP-IND-FIN.yml` sauf mention) | Statut | Correction proposée | Source retenue |
|---|---|---|---|---|---|
| F1 PAR 30/90/180 | encours à ≥ 1 échéance impayée > x j / encours brut (B2D à B70 − B65) ; 3 normes (p.4) | `:14-38` : `VAR_CRD_RETARD_30/VAR_ENCOURS_CREDITS` ; dénominateur = encours **module** (`:415`) ; PAR 90 et 180 calculés (`:471`, `:479`) sans ligne ni norme | **écart** | dénominateur `VAR_ENCOURS_BRUT` (balance, `:338`) ; trois lignes F01-30, F01-90, F01-180 avec leur norme | numérateur : module Crédit (retards) ; dénominateur : balance |
| F2 taux de provisions | B70 colonne 2 / B70 colonne 1 ; ≥ 40 % (p.4) | `:39-53` : 2991-2993 / 291-294 (`:320`, `:329`) | **OK** | — | balance |
| F3 taux de perte | (T6K + T6L) / encours brut ; < 2 % (p.4) | `:54-67` ; `DIMF-2080.yml:973` T6K = `6691,669` et `:981` T6L = `6692` : en **développée**, la racine 669 fait entrer 6692 dans T6K, donc 6692 compte **deux fois** | **écart** | T6K développée = 6691 seul (669 seulement en `comptesAllegee`), ou F3 lu directement sur le compte 669 | balance |
| F4 montant moyen décaissé | mouvements débit des comptes de crédits CT/MT/LT (balance) / nombre de crédits décaissés (p.5) | `:68-82` : décaissements du module Crédit (`:487`, `:495`) | **écart** (repli assumé, H9) | garder le module tant que la balance n'isole pas les décaissements ; contrôle de cohérence avec les débits de 202-204 | module Crédit (repli) |
| F5 épargne moyenne | dépôts G10 à G35 / épargnants, épargne obligatoire comprise, comptés une fois (p.5) | `:83-96` : encours **module** Épargne (`:423`) / épargnants actifs du module (`:447`, confiance BASSE) | **écart** | numérateur = balance G10 + G15 + G2A + G30 + G35 ; dénominateur = personnes distinctes titulaires d'au moins un dépôt (DAT, garantie, épargne obligatoire comprises) | balance ; module Épargne (comptage) |
| F6 encours moyen par emprunteur | (B2D à B70) − B65 / emprunteurs (p.5) | `:97-110` : encours **module** / emprunteurs actifs | **écart** | numérateur = `VAR_ENCOURS_BRUT` (balance) | balance ; module Crédit (comptage) |
| F7 productivité des agents de crédit | emprunteurs actifs / **agents de crédit** ; ≥ 130 (p.6) | `:111-125` → `:455` clé `RDC-REP-030.EMPR_PAR_AGENT` : gestionnaires ayant au moins un dossier (`ModulesProvider.java:616`) | **écart** | dénominateur = agents de crédit déclarés dans RH (fonction), à la date de calcul | module Crédit (emprunteurs) ; module RH (agents) |
| F8 productivité du personnel | **clients actifs** (≥ 1 dépôt et/ou crédit en cours) / employés ; > 115 (p.6) | `:126-139` → `:503` : aucune source (`ModulesProvider.java:321` lève une erreur) | **absent EDIP** | union sans doublon des clients ayant un crédit en cours (Crédit) ou un dépôt non nul (Épargne). Le statut Client `ACTIF` n'est qu'un **repli** : c'est un statut administratif, pas la définition du texte (H8) | modules Crédit ∪ Épargne ; repli Client statut ACTIF ; employés : RH |
| F9 CE / portefeuille | (R08 à T6B) / encours brut moyen ; ≤ 35 % (p.6) | `:140-154` : comptes 60-66 / moyenne ouverture-clôture | **OK** | (moyenne : H1) | balance |
| F10 FG / portefeuille | S02 à T50 / encours brut moyen (p.6) | `:155-174` : S02 + S1A + S2A + T50 (`:381`) | **OK** | — | balance |
| F11 personnel / portefeuille | S02 / encours brut moyen (p.6) | `:175-193` | **OK** | — | balance |
| F12 rentabilité des FP | RE / L01 moyen ; > 15 % (p.7) | `:194-208` : PE (70-73, 75, 76) − CE (60-66) / L01 moyen | **OK** | (périmètre PE/CE : H3) | balance |
| F13 rendement sur actif | RE / E90 moyen ; > 3 % (p.7) | `:209-222` | **écart** (induit) | dépend de la correction de E90 (§ 3) | balance |
| F14 autosuffisance | PE / CE ; > 130 % (p.7) | `:223-236` | **OK** | — | balance |
| F15 marge bénéficiaire | RE / PE ; > 20 % (p.7) | `:237-250` | **OK** | — | balance |
| F16 coefficient d'exploitation | FG / PFN ; ≤ 40 / 60 % (p.7) | `:251-270` | **OK** | — | balance |
| F17 rendement des actifs | (V08 à V7A) / actifs productifs ; > 15 % (p.8) | `:271-284` | **OK** | — | balance |
| F18 liquidité de l'actif | (A10 + A12 + A2H + A2J + C10) / E90 (p.8) | `:285-304` | **écart** (induit) | E90 (§ 3) | balance |
| F19 capitalisation | L01 / E90 (p.8) | `:305-319` | **écart** (induit) | E90 (§ 3) | balance |
| Tableau 1 membres | H/F, personnes morales, groupements et leurs membres (p.9) | `UEMOA-REP-IND-NF.yml:17-25` : libellés seulement | **absent EDIP** | brancher `CLE_MEMBRES_HOMMES/FEMMES` (`ModulesProvider.java:278-281`) ; ajouter personnes morales et groupements | module Client |
| Tableau 2 dirigeants et personnel | organes ; employés par catégorie et contrat (p.9) | `UEMOA-REP-IND-NF.yml:26-34` | **absent EDIP** | effectifs RH par fonction (dirigeant / autre) et contrat (CDI/CDD, national/expatrié) ; organes en saisie | module RH ; saisie |
| Tableau 3 déposants | H/F, personnes morales (p.10) | `UEMOA-REP-IND-NF.yml:35-41` | **absent EDIP** | titulaires distincts de dépôts, ventilés par sexe et type | modules Épargne + Client |
| Tableau 4 crédits en cours | nombre H/F, personnes morales (p.10) | `UEMOA-REP-IND-NF.yml:42-48` | **absent EDIP** | dossiers décaissés non soldés, ventilés | modules Crédit + Client |
| Tableau 5 crédits par objet | montants (milliers FCFA) par objet (p.10) | `UEMOA-REP-IND-NF.yml:49-57` | **absent EDIP** | encours par objet du dossier | module Crédit |
| Tableau 6 crédits en souffrance | nombre H/F, personnes morales (p.11) | `UEMOA-REP-IND-NF.yml:58-64` | **absent EDIP** | dossiers ayant **au moins une échéance impayée** (RCSFD, d18 p.66), avec la tranche 0-3 mois selon l'option de déclassement du SFD ; rapprochement avec 292-294 | module Crédit ; contrôle balance 29x |
| Tableau 7 surveillance | affiliées, contrôles, réunions, points de service, rapports (p.11) | `UEMOA-REP-IND-NF.yml:65-74` | **absent EDIP** | points de service : `CLE_POINTS_SERVICE` existante ; le reste en saisie | paramètres de l'institution ; saisie |

## 3. États financiers (Instr. 001-02-2018, 030-02-2009 ; RCSFD)

| Élément | Texte (source, page) | EDIP actuel | Statut | Correction proposée | Source retenue |
|---|---|---|---|---|---|
| DIMF 2000 bilan : postes, concordances, colonnes | annexe 1.1 (F A9-A19 ; d18 p.143-149) ; colonnes brut / amort.-prov. / net N, net N-1 (d18 p.157 ; F A45) | `DIMF-2000-BIL.yml:1-1085` : postes et concordances développée/allégée conformes ; colonnes BRUT, AMT_PROV, NET, NET_N1 | **OK** | — | balance |
| E05 / L75 / E90 / L90 | E05 à l'actif si charges > produits ; L75 au passif si produits > charges (infra-annuel) ; E90, L90 sans formule publiée (F A18-A19 ; d18 p.148-149) | `DIMF-2000-BIL.yml:606` E05 et `:1047` L75 signés, tous deux calculés ; `:616` E90 inclut E05 ; `:1075` L90 = F01+G01+H01+K01+L01 **sans L75**. En cas de bénéfice, E05 négatif réduit l'actif au lieu de porter L75 au passif | **écart** (majeur) | E05 = MAX(…;0), L75 = MAX(…;0), L90 = F01 + G01 + H01 + K01 + L01 + L75 ; contrôle E90 = L90 | balance |
| A11 / A01 caisse (allégée) | allégée A11 = 1011 (d18 p.143) ; développée A11 = 101 (F A9) | `comptesAllegee: 101` (décision U13) | **écart** (assumé, décidé) | aucun ; garder la trace U13 | balance |
| B2N comptes ordinaires débiteurs | ex 2511 en développée (F A12) et en allégée (d18 p.145) | `DIMF-2000-BIL.yml:145` : `2511dr,2512dr` | **écart** (mineur) | retirer 2512dr, ou le justifier (livret débiteur, à valider) | balance |
| DIMF 2000 hors bilan | développée seulement (F annexe 2 ; concordance A20) ; aucun modèle en allégée (d18) | `DIMF-2000-HB.yml` : postes N1A…N90 conformes à F A20, appliqués aussi en allégée | **OK** (développée) / **hors texte** (allégée) | marquer le hors bilan « développée » ; en allégée, ne l'utiliser que pour les ratios | balance classe 9 |
| DIMF 2080 compte de résultat | annexe 1.1 (F A21-A27 ; d18 p.150-154) | `DIMF-2080.yml` conforme ; mais les racines EDIP ajoutées en développée (`:973` T6K 669, `:882` T54 661, T56 663, `:1189` V3G 7021) font chevaucher des lignes sœurs (T6K/T6L, T54/T55, T56/T57-T58, V3G/V3M-V3N) | **écart** (détail) | en développée, ne mettre la racine que sur le poste parent ; les totaux T51, T6B, V3A ne changent pas | balance |
| SIG (marge d'intérêt, PFN…) | définis en texte, sans code ni formule (d18 p.122-123) | `DIMF-2080.yml` : SIG_TCI, SIG_TPI, SIG_MI | **hors texte** (formules déduites) | garder, libellé « formule déduite » | balance |
| DIMF 2005 emplois-ressources | colonnes amort./prov. et nets ; totaux B02, G02 (d18 p.169) | `DIMF-2005.yml:13-` : renvois aux postes du bilan ; B02, G02 sans calcul | **écart** | B02 = B2D + B30 (+ B40) + B70 ; G02 = G10 + G15 + G2A + G60 + G70 ; colonne amort./prov. = 2991-2993 sur B70 | balance |
| DIMF 2010 crédits en souffrance | A (191-193 / 291-293), B (162 et 254), C = A − B, D (199 et 299), E = C − D ; 3 tranches (d18 p.170) | `DIMF-2010.yml:17-31` : 4 lignes sans comptes | **absent EDIP** | ≤ 6 mois = 192/292 ; 6-12 = 193/293 ; 12-24 = 194/294 ; B = dépôts de garantie des débiteurs concernés (module) ; D = 1991-1993 / 2991-2993 | balance ; module Crédit pour B |
| DIMF 2011 informations annexes | 15 lignes (d18 p.171) | `DIMF-2011.yml:12-` : I11_AUTRES_OPS seul calculé | **écart** | membres H/F (Client) ; dépôts > 1 an 126-128, 252, 253, 254-255 (balance + échéance) ; recouvrements réalisés et attendus (Crédit) | balance ; modules Client, Crédit |
| DIMF 2011-1 engagements par signature | CT / MLT (F annexe 4.8) | `DIMF-2011-1.yml` : sans calcul | **absent EDIP** | classe 9 donnée (901, 903, 911, 913) ventilée par durée | balance classe 9 |
| DIMF 2012 dix plus gros débiteurs | 10 lignes ; durée initiale, résiduelle ; nets (d18 p.172) | `DIMF-2012.yml:15-` : seul I12_MAX calculé | **écart** | top 10 du module Crédit (`/reporting/risques/top`, n = 10) et total | module Crédit |
| DIMF 2013 prêts aux dirigeants | encours bruts, engagements par signature compris (d18 p.173, texte p.126) | `DIMF-2013.yml:16` I13_TOTAL sans engagements | **écart** | voir R3 | modules Client + Crédit |
| DIMF 2014 ressources affectées | 181 / 182 / 183 et crédits sur ressources affectées (d18 p.174) | `DIMF-2014.yml:14-` : sans calcul | **absent EDIP** | ligne 1 = balance 181, 182, 183 ; lignes 2-3 = crédits financés par ces ressources (module Crédit) | balance ; module Crédit |
| DIMF 2015 valeurs immobilisées | brut, amort./prov., net (d18 p.175) | `DIMF-2015.yml:13-` : renvois aux postes du bilan | **OK** | — | balance |
| DIMF 2016 affectation du résultat | L80, L70, 770 à affecter, 772-779 (d18 p.176) | `DIMF-2016.yml:13-` : L80 et L70 calculés ; 770 sans formule ; 772-779 sans saisie | **écart** | 770 = L80 + L70 ; 772-779 en saisie (décision d'AG) ; contrôle 772 ≥ R7 | balance ; saisie |
| DIMF 2006, 2007, 2008, 2009, 2018 (développée) | modèles F annexe 4 | structures seulement | **absent EDIP** | 2009 (détail du compte 6221) en priorité, exigé par 001-02-2018 ; les autres en saisie | balance ; RH ; saisie |
| États combinés / consolidés SFD | loi art. 49 ; 030-02-2009 art. 5 ; 001-02-2018 art. 2-3 ; RCSFD annexe 6 (F A203, non transcrite) | `DIMF-2900.yml`, `DIMF-2980.yml` : `statut: A_CONFIRMER`, sans lignes | **absent EDIP** | transcrire l'annexe 6 (PDF à obtenir), puis combiner caisses et agences avec élimination des comptes réciproques (liaison 39) | balance par entité |
| Instr. 033-11-2016 | établissements de crédit ; hors champ SFD (d19 p.1) | non utilisée par EDIP | **hors texte** (hors champ, correct) | ne pas l'appliquer aux SFD | — |
| Annexes 001-02-2018, publication | art. 2-6 (d02 p.1-3) | `UEMOA-REP-EF-ANNEXES.yml`, `UEMOA-REP-FIN-002.yml` (notification sous 7 j) | **OK** | — | — |
| Rapports « nouvelle loi » LOI-001 à 006 | loi 2023 : textes d'application non publiés (n02 art. 172) | `UEMOA-REP-LOI-001…006.yml` | **hors texte** (anticipation) | garder inactifs tant que la BCEAO n'a rien publié | — |

## 4. Décompte et priorités

| Statut | Ratios (12 lignes) | Indicateurs (26) | États (21) | Total |
|---|---|---|---|---|
| OK | 3 | 9 | 4 | 16 |
| écart | 9 | 9 | 9 | 27 |
| absent EDIP | 0 | 8 | 5 | 13 |
| hors texte | 0 | 0 | 4 | 4 |

La ligne du hors bilan compte en OK (développée) et en hors texte (allégée). Les « écarts induits » (R8, F13, F18, F19) sont comptés en écart.

Écarts à corriger en code, par effet sur les chiffres :
1. **E05 / L75 / L90** (`DIMF-2000-BIL.yml:606, 1047, 1075`) : bornes à 0 et L75 au passif. Corrige FP (double comptage du résultat infra-annuel) et, par ricochet, R3, R4, R8, R9, R10, F13, F18, F19.
2. **Durée résiduelle** dans R2 et R5 (`UEMOA-REP-PRU-02.yml`, `UEMOA-REP-PRU-05.yml`) : les soldes entiers faussent les deux ratios.
3. **F1 PAR** (`UEMOA-REP-IND-FIN.yml:14`) : dénominateur balance, trois lignes 30 / 90 / 180 j.
4. **T6K développée** (`DIMF-2080.yml:973`) : retirer la racine 669 (6692 compté deux fois dans F3).
5. **F5, F6** : numérateurs depuis la balance (G10 à G35 ; VAR_ENCOURS_BRUT).
6. **R3, R4** : engagements par signature et regroupement par groupe.
7. **F8 et tableaux non financiers 1 à 7** : brancher Crédit ∪ Épargne, Client, RH (clés déjà présentes pour membres H/F et points de service).
8. **DIMF 2010, 2014, 2011-1, 2016 (770)** : formules simples sur la balance.
