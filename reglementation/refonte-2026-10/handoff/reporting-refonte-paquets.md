# S2b — complétion des paquets de localisation (handoff, 2026-10-23)

Branches locales (rien poussé) :
- `refs/heads/feature/reporting-refonte-paquets` dans `sfd-reporting-service` (depuis 84ca433) ;
- `refs/heads/feature/reporting-refonte-paquets` dans `sfd-docs` (depuis 7da8dbe) : `plan-classe9-allege.yml` et mise en garde dans `convert_paquets.py`.

## Chiffres (lignes calculables, test `PaquetsCompletudeTest`)
Mesure : balance donnant un solde débiteur à chaque préfixe de compte cité, données CROSS_SERVICE indisponibles, saisies manuelles à 0 (les lignes SAISIE comptent donc comme calculables). Colonne « annexes » : données CROSS_SERVICE branchées à 1.

| Zone | Départ (S4) | Départ (même test) | Après | Après, annexes branchées |
|---|---|---|---|---|
| UEMOA (allégée) | 429/602 | 429/602 | **495/602** | 504/602 |
| UEMOA (développée) | 437 (test) | 437/602 | 495/602 | — |
| CEMAC | 397/467 | 399/467 | **402/467** | 449/467 |
| RDC | 70/98 | 79/98 | **79/100** (2 lignes ajoutées) | 86/100 |
| OHADA | 290/452 | 290/452 | **328/452** | 328/452 |

L'écart de départ (CEMAC, RDC) vient de la balance du test, différente de celle de S4 (qui avait aussi des divisions par zéro).

**Ratios prudentiels UEMOA** : R1, R3 à R10 sont calculables dès que les trois données CROSS_SERVICE ci-dessous sont fournies (test : aucune ERREUR restante, `UEMOA-REP-PRU-01..10`). Tant qu'elles ne sont pas branchées, R3, R4, R6 sont en ERREUR « Donnée non disponible : <clé> ». Les ratios qui utilisent FP exigent aussi les deux saisies `FP_DED_PROV` et `FP_DED_PART`.

## Ce qui a été fait, avec sa source
### UEMOA
1. **Comptes « ex » (cause racine de B2N, F1A, G10)** : le chargeur ne lit pas `comptesEx` / `comptesExAllegee`, donc ces comptes étaient ignorés en silence, y compris dans A01, A12, B01, F01, G01 (sous-évaluation). Fusionnés dans `comptes` / `comptesAllegee` avec suffixe `dr` (actif) ou `cr` (passif). Source : RCSFD annexe 1.1, règle « ex » (lue dans le PDF) ; liste de comptes : paquet S2. Confiance MOYENNE. 8 lignes (A01, A12, B01, B2N, F01, F1A, G01, G10).
2. **I11_AUTRES_OPS, I12_MAX, I13_TOTAL** : `sourceDonnees: CROSS_SERVICE:<clé>`. Clés (à brancher par l'orchestrateur) : `institution.montantAutresOperations`, `credit.plusGrosEncoursMembre`, `credit.encoursDirigeantsPersonnelPersonnesLiees`. Les références dans PRU-03/04/06 sont désormais qualifiées (`DIMF-2013.I13_TOTAL`…) : non qualifiées, elles donnaient REFERENCE_INCONNUE.
3. **Postes absents de l'allégée (`allegee: false`)** : le moteur n'a pas ce concept. Les lignes portaient un « ancêtre » comme `comptesAllegee` (ex. `4,-4` pour D40, D41, D45, D46, D47, D50 à D53, D70 à D73 : retranchait toute la classe 4, et D41 + D46 sont dans FP ; `41` pour D10 ; `55` pour L59 ; `6011` pour les sous-lignes de DIMF-2080…). Remplacé : plus de `comptesAllegee`, donc les comptes détaillés, qui n'existent pas au plan allégé, donnent 0. Une `noteAllegee` explique. Concerne DIMF-2000-BIL et DIMF-2080 (149 lignes avec `noteAllegee`) ; DIMF-2000-HB inchangé (comptesAllegee identique à comptes).
4. **Allégée D1E, D1L, D32 à D35** (plan RCSFD allégé, classe 4, lu) : D1E = `412,-4129` (HAUTE) ; D1L et D32 à D35 : postes absents de l'allégée (la classe 41 n'a que 412 ; 441 sans sous-comptes), donc `allegee: false`.
5. **Totaux incomplets du bilan** (E90 ≠ L90 sur une balance réelle) : B01 + `20231,20237`, C01 + `307`, D01 + `42` (allégée aussi). Raison : ces comptes sont dans des lignes filles (B2D, B65, C55, D1S, D60) mais absents du total. À valider (voir plus bas).
6. **Hiérarchie `parent`** sur DIMF-2000-BIL (130 lignes), DIMF-2000-HB (6), DIMF-2080 (200) : ligne précédente la plus proche, de même sens, dont les comptes recouvrent ceux de la fille. Les images du modèle officiel sont illisibles dans le PDF extrait. Confiance MOYENNE. **Le chargeur Java ne lit pas `parent`** (`LignePaquet`) : à ajouter si l'UI doit l'afficher ; le champ n'a pas d'effet de calcul.
7. **États liés au bilan par le code poste** : DIMF-2005 (13 lignes), DIMF-2015 (14), DIMF-2016 (L80, L70) deviennent `DIMF-2000-BIL.<code>`. Source (lue) : RCSFD, documents de synthèse §A.3 : « Un même poste prévu avec des ventilations différentes dans plusieurs documents est identifié avec le même code poste ». Valeur nette seulement.
8. **Indicateurs périodiques IND-FIN** : F03, F16, F17, F18, F19 en expressions (ratios en %), d'après le `codeRcsfd` et les notes de lecture du paquet (instruction 020-12-2010, annexe I). MOYENNE.
9. `D1E_HORS_PART` : sens `D` ajouté (il manquait, la ligne était en erreur).
10. **Classe 9** : voir « Constats ».

### CEMAC
- **XG07** : `exclut` + `624` (XG06 le porte déjà ; XG01 additionne les deux). Même défaut corrigé pour YG09 (+ 724, YG08), YG17 (`774,775,77910`, HAUTE : la source dit « 77 hors 774, 775, 77910 »), YG21 (`7913,7971,792,79910`, HAUTE : « 79 hors … »), LP09 (+ 724), LP18 (`774,775,779`), LP22 (`7913,799,792,7971`).
- **XG21** : `65255` repris de ZP21 (même poste « Frais de formation » dans CEMAC-REP-002C) ; la source imprimée porte « 25 255 ». Confiance BASSE, à valider COBAC.

### RDC
- **RDC-REP-001** : A_DEBITEURS `46dr`, P_CREDITEURS `46cr`, A_REGUL `47dr`, P_REGUL `47cr`.
- **Données du sous-journal crédit** en CROSS_SERVICE : CRD_EN_RETARD (`credit.crdEnRetard`, donc PAR), EMPR_PAR_AGENT (`credit.emprunteursParAgentCredit`), et deux lignes de montant ajoutées `RISQUE_CLIENT_IMF_MONTANT` (`credit.plusGrosRisqueClient`) et `RISQUE_MEMBRE_COOPEC_MONTANT` (`credit.plusGrosRisqueMembre`) ; les ratios correspondants valent montant / FPP (la norme 5 % / 10 % porte sur le ratio).

### OHADA
- **SYSN-NOTE34-CAFG** : `sens` ajouté aux 9 lignes (654 D, 754 C, 77 C, 787 C, HAO produits C, 67 D, 83/85 D, 87 D, 89 D). Source : Guide §4.2.3.2 (OHADA-ETF-102) + nature des comptes.
- **EBNL-SMT-BILAN / -RESULTAT** : 17 postes saisis passent en `SAISIE`. Source : la note du paquet (SMT en comptabilité de trésorerie, journal unique de trésorerie, notes 1 à 5), art. 5-6 SYCEBNL.

## Constats pour l'orchestrateur (hors périmètre)
1. **Java** : (a) `parent` n'est pas lu ; (b) `comptesEx`, `allegee`, `base: MOYENNE_PERIODE`, `flux`/`sens ENC|DEC` ne sont pas gérés (le paquet UEMOA contient `base: MOYENNE_PERIODE` dans RDC et les extensions TFT d'OHADA) ; (c) le TFT méthode directe (EBNL-A-TFT, 17 lignes + 6 dépendantes ; SYSN-TFT ; EBNL-P-TRT) a besoin des mouvements de la période, pas du solde : le moteur ne les lit pas.
2. **Classe 9 UEMOA** : le PDF RCSFD allégé (cb-umoa) n'a pas de classe 9. Son plan de comptes s'arrête à la classe 7 (vérifié sur le texte extrait). Le hors-bilan existe dans la copie du Trésor de Côte d'Ivoire (développée, jeu allégé « idem »). `sfd-docs/reglementation/uemoa-bceao/plan-classe9-allege.yml` en tire 46 comptes (901 à 9652…) depuis le modèle DIMF 2000-HB déjà transcrit, avec le libellé du poste (pas celui du compte). Les libellés officiels des comptes restent à lire dans le RCSFD développé.
3. `convert_paquets.py` écraserait ces corrections si on le relançait : mise en garde ajoutée en tête. Les paquets font foi.
4. 18 données CROSS_SERVICE CEMAC et 5 de RDC/UEMOA restent à brancher (clés ci-dessus et `RAPPORT.LIGNE` par défaut pour CEMAC).

## Lignes encore en erreur et pourquoi
- **UEMOA (98 sans formule)** : UEMOA-REP-RAP-001 (29, tableaux du rapport annuel, textes/tables) ; DIMF-2011 (14 : effectifs, populations, dépôts > 1 an : sous-journal, non trouvé) ; IND-FIN F01, F02, F04 à F15 (échéancier, effectifs, moyennes de période, ou plages « V08 à X6B − W53 » ambiguës) ; IND-NF (7 tableaux) ; DIMF-2005 B02 et G02 (codes absents du bilan) ; DIMF-2006 à 2009 et 2018 (tableaux de biens, une ligne chacun) ; DIMF-2010 (4) ; DIMF-2011-1 (3) ; DIMF-2012 (3) ; DIMF-2013 I13_LIGNES ; DIMF-2014 (4 : lignes sans code, colonnes CT/MT/LT) ; DIMF-2016 (9 : codes 77x propres à l'état) ; FS-001 (2) ; D-lignes diverses. Tous « non trouvé » ou non comptables.
- **CEMAC** : EG34, EG35, EG48, RG34, RG35, RG45, EP50, RP50 (liaisons et soldes d'excédent : « NON TROUVÉ, pas de compte dans la table ») ; HB04, HB09 (autres engagements) ; JT18, KL19, VL08, DA02, DA04, DB02, DB04, PA02, CS01, CS02, ST01 à ST09 (CROSS_SERVICE non branchées) et les ratios qui en dépendent.
- **RDC** : P_EMPRUNTS_TRESO, SUBVENTION, CHARGES_PERSONNEL, DOT_AMORT (comptes PCCI non trouvés : PDF PCCI 2009 non disponible), ENG_RECUS_IF, APPARENTES (sous-journal, dénominateur variable COOPEC/IMF), POSITION_CHANGE_*, CAPITALISATION, EFFICACITE_OP, ROE, ROA, RENDEMENT_PORTEFEUILLE, AUTOSUFFISANCE (comptes de charges non trouvés).
- **OHADA (103 sans formule)** : EBNL-A-NOTES (45) et EBNL-P-NOTES (26), EBNL-SMT-NOTES (5) : notes narratives ou tableaux à joindre, sans formule ; à passer en `nature: DOCUMENT` si l'orchestrateur le décide. EBNL-A-TFT (flux), EBNL-P-TRT, EBNL-P-TER FX/FY/FZ (mêmes comptes 51,52,53,55,57 pour trois fonds : indistinguables), EBNL-P-TEB.

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| 2511 : le solde est pris compte par compte (25116 « dettes rattachées » créditeur compté en G10, 25117 débiteur en B2N) | `2511dr` en B2N, `2511cr` en G10 | RCSFD annexe 1.1, règle « ex » |
| Totaux B01, C01, D01 complétés (20231, 20237, 307, 42) : ces comptes appartiennent bien aux totaux ? | oui, pour que E90 = L90 | cohérence avec les lignes filles ; plan RCSFD |
| Postes `allegee: false` valent 0 en allégée | oui (comptes absents du plan allégé) | plan RCSFD allégé |
| Hiérarchie `parent` déduite des comptes | informatif | inclusion des comptes |
| DIMF-2005/2015/2016 = valeur nette du bilan, colonnes brut et amortissements non détaillées | oui | RCSFD §A.3 |
| IND-F18 : A2H + A2J (le texte imprime « A2H++A2J ») ; IND-F17 numérateur (V08 à V7A) = V08+V3A+V4B+V5B+V6U+V7A | oui | note de la ligne |
| IND-F03/F17/F18/F19 : brut ou net pour le portefeuille (B70 est net de provisions) | net, comme le bilan | instruction 020-12-2010 (« brut » dans le texte) |
| XG21 = 65255 (coquille « 25 255 ») | 65255, BASSE | CEMAC-REP-002C ZP21 |
| Doubles comptages CEMAC YG09, LP09, LP18, LP22 : « Autres » = total moins les lignes détaillées | oui | totaux = sommes de lignes ; YG17 et YG21 sourcés |
| Ratios RDC RISQUE_CLIENT/MEMBRE = montant du sous-journal / FPP | oui | Instr. BCC 002 art. 29 |
| SMT : postes saisis à la main (journal de trésorerie), VA à VC = variations N−(N−1) saisies | oui | SYCEBNL art. 5-6 |
| Clés CROSS_SERVICE (noms) et module qui les fournit | à décider | — |
| Classe 9 : sens des soldes et libellés des comptes | `SOLDE`, libellés des postes | RCSFD développé (copie CI) |

## Régression
Baseline 487 tests / 0 échec (suite S4 à 84ca433 : 482 + 5 selon son handoff ; mesuré ici : 483 avant mon test). Après : **488 / 0** (+5 `PaquetsCompletudeTest`, 1 test d'exactitude ajouté).
Trois tests de `ExactitudeCalculsTest` encodaient l'ancien comportement et ont été mis à jour (pas affaiblis) : B2N n'est plus en erreur (vaut 0 sans solde 2511) ; un poste encore sans formule (DIMF-2005.B02) garde le test « erreur explicite » ; R1C allégée vaut 50 (poste absent de l'allégée, plus d'ancêtre 6011) ; R1 est calculable et R3 reste en erreur sur la donnée CROSS_SERVICE manquante.
Commit : 7cbcd5b.

## Reproduire
Test : `scripts/claude/regress.sh sfd-reporting-service -Dtest=PaquetsCompletudeTest` ; détail par ligne dans `sfd-reporting-service/target/completude/<zone>-<variante>[-annexes].tsv` (statut OK ou type d'erreur + message).

## Correctifs de revue opus (SHA 4733b06, docs b8c4c40)
Rebase sur 029ea57 propre. Suite : **433 / 0** (le total baisse car S6 a retiré des tests ; baseline 029ea57 non re-mesurée ici). `RatiosPrudentielsServiceTest` : aucun changement nécessaire (R3, R4, R6 y attendent déjà « Donnée non disponible »).
- **Java chargeur et moteur** : `allegee: false` lu (`LignePaquet.absentPlanAllege`) ; en variante ALLEGEE la ligne vaut 0 explicite, `ResultatLigne.avertissement`, exposé par `FormuleDto.absentPlanAllege`, `RapportLigne` et `RapportLigneDto` (`avertissement`, `absentPlanAllege`) ; colonnes ajoutées par ddl-auto update (`RapportFormule.absentPlanAllege`, `RapportLigne.avertissement`, `.absentPlanAllege`). `base` (MOYENNE_PERIODE) lu : la ligne passe en ERREUR explicite « Base de calcul … non gérée » (RDC ABANDON, EFFICACITE_OP, ROE, ROA, RENDEMENT_PORTEFEUILLE ; seule ABANDON était calculée). Angular : à afficher (`absentPlanAllege`, `avertissement`).
- **Paquets** : D32 à D35 `comptesAllegee: NON_TROUVE` ; E05, L75, DIMF-2080 X84 : le préfixe `7` (stand-in de 73) retiré, 73 n'existe pas au plan allégé (classe 7 : 70, 71, 72, 74, 75, 76, 77) ; B2N `2511dr,2512dr` ; G01 et G90 `25116cr,25126cr` ; G10 `exclut 25116,25126` ; ligne de contrôle `G01_FILLES` + `controle.egal` sur G01 (ALERTE) ; C6B `39dr`, H6B `39cr`. RDC `2` (A_IMMO, EMPLOIS_STABLES, IMMO_RETENUES) : la classe 2 entière est voulue par l'Instr. BCC 002 et 009 (« immobilisations nettes, classe 2 ») : inchangé.
- **Tests d'exactitude** : balance comptes ordinaires (2511 D 300, 2512 D 120, 25111 C 40, 1141 C 60, 57111 C 5000, 59 C 1000) : B2N 420, G10 40, F1A 60, R1 = 420/6100×100 = 6,8852 (calcul dans le commentaire). R1C et R1D : 0 explicite en allégée, 50 et 80 en développée.
- **Classe 9** : fichier renommé `plan-classe9-hors-bilan.yml`, `allegee` retiré, `origine: modele-DIMF-2000-HB-copie-CI`, confiance BASSE.
- **Décompte** (sans annexes ; avec annexes) : UEMOA allégée 488/603 (D32-35 NON_TROUVE, +1 ligne de contrôle) ; développée 496/603 ; CEMAC 402/467 ; RDC 78/100 (ABANDON en erreur) ; OHADA 328/452.
