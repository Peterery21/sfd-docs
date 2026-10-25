# UEMOA / BCEAO — Extrait consolidé du référentiel SFD (ratios, indicateurs, états financiers, plan de comptes, versions)

- Zone : UEMOA (BCEAO, Commission Bancaire de l'UMOA)
- Thème : référentiel réglementaire du reporting SFD, tel que lu dans les textes
- Date de rédaction : 2026-10-25 — Rédacteur : Claude (consolidation des extractions A à F)
- Fichiers liés : [uemoa-bceao/reporting.md](uemoa-bceao/reporting.md) (inventaire et formules), [UEMOA-CONFORMITE.md](UEMOA-CONFORMITE.md) (comparaison avec EDIP), [REPORTING_POINTS_A_VALIDER.md](REPORTING_POINTS_A_VALIDER.md) (section « Lot R »)
- Statut : extrait de lecture. Rien n'est déduit par analogie. Ce qui est ambigu ou non vérifié porte la marque **[AMBIGU]** ou **[NON VÉRIFIÉ]**.

## 0. Sources et notation

| Réf. | Texte | Lecture | Pagination citée |
|---|---|---|---|
| d06 | Instr. BCEAO n° 010-08-2010 du 30/08/2010, règles prudentielles des SFD (19 p.) | scan, lu à l'image | page du PDF |
| d07 | Instr. n° 016-12-2010 du 29/12/2010, financement des immobilisations et des participations | scan, lu à l'image | page du PDF |
| d11 | Instr. n° 020-12-2010 du 29/12/2010, indicateurs périodiques | scan, lu à l'image (annexe en paysage p.4-8) | page du PDF |
| d12 | Instr. n° 021-12-2010 du 29/12/2010, version allégée du RCSFD | scan | page du PDF |
| d16 | Instr. n° 007-06-2010 du 14/06/2010, contrôle des SFD de l'article 44 | scan | page du PDF |
| d01 | Avis n° 008-04-2020 du 27/04/2020 (Covid-19) | scan | page du PDF |
| d02 | Instr. n° 001-02-2018, états financiers et publication des SFD contrôlés par la BCEAO et la CB | couche texte | page du PDF |
| d19 | Instr. n° 033-11-2016 du 15/11/2016, états financiers consolidés (**établissements de crédit**) | couche texte | page du PDF |
| d17 | Recueil BCEAO SFD, édition de décembre 2011 (176 p.) | couche texte ; annexes illisibles | Pn = page du PDF |
| d20 | Recueil BCEAO, chapitre VII « microfinance », avril 2016 (80 p.) | couche texte | page du PDF |
| d18 | RCSFD 1re édition, **version allégée** (201 p.) | chap. IV et annexes lus à l'image | page du PDF (annexes A1… = PDF − 134) |
| F | RCSFD 1re édition **complète** (versions développée et allégée), copie du Trésor de Côte d'Ivoire, ISBN 978-2-916140-08-7, <https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf> | **texte extrait par `tvly extract`, PDF non téléchargé (certificat TLS invalide), tableaux non contrôlés à l'image** | page **imprimée** du livre (p.NN corps, ANN annexes) |
| n02 | Sénégal, loi n° 2025-04 du 19/02/2025 (transposition de la loi uniforme microfinance 2023) | scan ; seules les pages impaires sont présentes | page imprimée |
| n03 | Instr. n° 003-07-2019 (organismes externes d'évaluation du crédit) | couche texte | page du PDF |

Toutes les données tirées de F sont **[NON VÉRIFIÉ À L'IMAGE]** : elles viennent d'une extraction de texte, sans contrôle visuel des tableaux. Elles concordent avec d18 partout où les deux versions se recouvrent.

## (a) Ratios prudentiels — Instr. 010-08-2010 (d06) et 016-12-2010 (d07)

Dispositions générales :
- Assujettis : SFD, unions, fédérations, confédérations (d06 p.1 ; d07 p.1). Le périmètre (réseau consolidé, caisse, agence) n'est **pas précisé [AMBIGU]**. Seule la liquidité distingue les SFD affiliés et non affiliés.
- Transmission (d06 art. 3, p.2) : ratios annuels sur les états au 31/12, en 3 exemplaires (Ministre, BCEAO, CB), dans les 6 mois. Données mensuelles : au plus tard 1 mois après la fin du mois. Trimestrielles : au plus tard 1 mois après la fin du trimestre.
- Support (d06 art. 4, p.2) : électronique pour les SFD de l'article 44 ; papier admis pour les autres. Signature d'une personne habilitée.
- « SFD de l'article 44 » : encours de dépôts **ou** de crédits ≥ 2 000 000 000 FCFA au terme de 2 exercices consécutifs ; pour les mutualistes, seuil apprécié sur la faîtière et ses caisses affiliées (d16 art. 2, p.3-4).
- d06 art. 6 (p.2) abroge et remplace toutes les dispositions antérieures de même objet ; vigueur le 30/08/2010 (p.2). d07 n'a pas de clause d'abrogation (p.2).

**Fonds propres réglementaires** (définition commune aux annexes III, IV, VIII, IX de d06, p.7-8, 9-10, 15-16, 17, et à l'annexe de d07, p.4-5) :
- **+** L10 subventions d'investissement ; L20 fonds affectés ; L27 fonds de crédit ; L30 provisions pour risques et charges ; L35 provisions réglementées ; L41 emprunts et titres subordonnés ; L45 FRFG ; L50 primes liées au capital ; L55 réserves ; L59 écart de réévaluation ; L60 capital ; L65 fonds de dotation ; L70 report à nouveau positif ; L75 excédent des produits sur les charges (\*) ; L80 résultat positif.
- **−** L62 capital non appelé ; E05 excédent des charges sur les produits (\*) ; immobilisations incorporelles nettes (D24 + D31 + D41 + D46) ; L70 négatif ; L80 déficitaire ; complément de provisions exigé par les Autorités et non constitué ; participations constituant des fonds propres dans d'autres SFD ou établissements de crédit.
- (\*) « utilisés que dans le cadre de la production des états financiers infra annuels » (note de bas de page, d06 p.8). Le code L75 manque à l'impression en annexe IX, ajouté à la main (d06 p.17).

| N° | Ratio | Numérateur A | Dénominateur B | Norme | Périodicité art. 44 / autres | Base légale | Réf. |
|---|---|---|---|---|---|---|---|
| I | Limitation des risques | Risques **nets des provisions et des dépôts de garantie** : A12, A2A, A3A, A70, B2D, B2N, B30, B40, B70, C10, D1E, D1L, engagements par signature donnés N1A + N1J + N3A + Q1A | F1A, F2A, F3A, F50, G2A, G10, G15, G35, G60, G70, L01 | A/B ≤ 200 % | mensuelle / trimestrielle | loi art. 147 | d06 p.4, p.19 ; d17 P97-P98 |
| II | Couverture des emplois MLT par des ressources stables | Ressources à **durée résiduelle > 12 mois** : L01, F2A, F3F, F50, G15, G2A, G30, G35, G60, G70 | Emplois MLT nets : A2H, A2I, A2J, A3C (> 1 an), A70, B30, B40, B70, D1E, D1L, D10, D1S, D23, D30, D40 | ≥ 100 % | trimestrielle / trimestrielle | art. 147 | d06 p.5-6, p.19 |
| III | Prêts aux dirigeants, au personnel et aux personnes liées | Encours **brut** des prêts et engagements par signature (tableaux annexés aux états, vérifiés sur l'état détaillé des crédits) | Fonds propres | ≤ 10 % | mensuelle / trimestrielle | loi art. 35, décret art. 20 | d06 p.7-8, p.19 |
| IV | Risques sur une seule signature | Encours brut des prêts et engagements de financement et de garantie au **plus gros emprunteur** ; « seule signature » = personne et structures qu'elle contrôle (exclusif, conjoint, influence notable) | Fonds propres | ≤ 10 % | mensuelle / trimestrielle | art. 147 | d06 p.9-10, p.19 |
| V | Coefficient de liquidité | Valeurs réalisables et disponibles à **≤ 3 mois** (durée résiduelle), nettes : A10, A12, A2J, A2A, A3B, B2D, B2N, B30, B40, C10, C30, C40, C56, créances rattachées A60 + B65 + C55, engagements donnés N1A + N1J + N2A + N2J | Passif exigible à ≤ 3 mois : F1A, F2A, F3E, F3F, F50, G10, G15, G2A, G30, G35, G60, G70, H10, H40, dettes rattachées F60 + G90, engagements reçus N1H + N1K + N2H + N2M | ≥ 100 % (mutualistes non affiliées, autres SFD collectant des dépôts) ; ≥ 80 % (mutualistes affiliées) ; ≥ 60 % (SFD sans collecte) | mensuelle / mensuelle si collecte, sinon trimestrielle | art. 147 | d06 p.11-12, p.19 |
| VI | Opérations autres que l'épargne et le crédit | Montant consacré aux activités hors art. 4 al. 1-2 de la loi | Risques portés (liste du ratio I **sans A2A**) | ≤ 5 % | trimestrielle / trimestrielle | loi art. 36 | d06 p.13, p.19 |
| VII | Réserve générale | Base = L80 + L70 déficitaire | — | dotation annuelle ≥ 15 % de la base (excédents nets avant ristourne ou dividendes, après imputation du report à nouveau déficitaire), obligatoire quel que soit le cumul atteint, non partageable | trimestrielle / trimestrielle | loi art. 85, 124 | d06 p.14, p.19 |
| VIII | Capitalisation | Fonds propres de fin de période | Total actif net | ≥ 15 % ; délai de 2 ans pour les SFD en activité à la date de signature de l'instruction (d06 p.16 ; vigueur 30/08/2010) | mensuelle / mensuelle | loi art. 85, 123 | d06 p.15-16, p.19 |
| IX | Prises de participation | D1E hors participations dans les établissements de crédit et les SFD | Fonds propres | ≤ 25 % | trimestrielle / trimestrielle | loi art. 36 | d06 p.17, p.19 |
| X | Financement des immobilisations et des participations | Nets : D24, D25, D31 (hors frais et valeurs immobilisés), D36, D41, D45, D46 et D47 (hors biens acquis par réalisation de garantie depuis moins de 2 ans), D1E (hors SFD et établissements de crédit) | Fonds propres (même définition) | ≤ 100 % | trimestrielle (1 mois) ; annuelle (6 mois, 3 ex.) | loi art. 85, 115, 123, 147 | d07 p.1-2, p.4-5 ; d20 p.44-46 |

Ambiguïtés du texte :
- **[AMBIGU]** Ratio I : « nets des dépôts de garantie » sans dire quels postes déduire (F2C ? G30 ?) (d06 p.4).
- **[AMBIGU]** Ratio III : l'intitulé vise dirigeants, personnel et personnes liées ; l'introduction vise dirigeants et personnel, le §1 (numérateur) les seuls dirigeants (d06 p.7).
- Ratio VI : A2A absent du dénominateur alors qu'il figure au ratio I (d06 p.13 contre p.4). Tel quel dans le texte.
- **[AMBIGU]** Ratio V : A2J est libellé « dépôts à court terme » dans l'annexe ; le poste A2J est « autres dépôts constitués » (1281).
- **[AMBIGU]** Ratio X : les incorporels (D24, D31, D41, D46) figurent au numérateur **et** sont déduits des fonds propres (d07 p.4-5). Tel quel.
- Annotations manuscrites du lecteur sur le scan (d06 p.5, 11, 12, 16) : non normatives, ignorées.
- Avis 008-04-2020 (d01 p.1) : report d'échéances de 3 mois renouvelable une fois, créances reportées dans un sous-compte des crédits immobilisés ; **aucune dérogation explicite aux ratios**.

## (b) Indicateurs périodiques — Instr. 020-12-2010 (d11)

- Périodicité : mensuelle pour les SFD de l'article 44, trimestrielle pour les autres (art. 2, p.1). Délai : 30 jours calendaires (art. 3, p.1-2). Défaut : pénalités de la loi art. 73 (5 000, 10 000 puis 15 000 FCFA par jour et par omission, d20 p.18). Support électronique (art. 44) ou papier signé (art. 4, p.2). Abroge et remplace les dispositions antérieures ; vigueur 1/01/2011 (art. 6, p.2).
- Les codes RCSFD des formules sont des **codes de postes** des états DIMF (voir (c)), pas des comptes.

### I. Indicateurs financiers (d11 p.4-8 ; d20 p.65-70)

| N° | Groupe | Indicateur | Formule | Codes RCSFD | Norme | Réf. |
|---|---|---|---|---|---|---|
| F1 | I Qualité du portefeuille | Portefeuille à risque PAR x (x = 30, 90, 180 j) | encours des crédits ayant au moins une échéance impayée depuis plus de x jours / encours brut, souffrance comprise | dén. (B2D à B70) − B65 | < 5 % (≥ 30 j) ; < 3 % (≥ 90 j) ; < 2 % (> 180 j) | d11 p.4 |
| F2 | I | Taux de provisions pour créances en souffrance | provisions constituées / créances en souffrance brutes | B70 colonne 2 / B70 colonne 1 | ≥ 40 % | d11 p.4 |
| F3 | I | Taux de perte sur créances | crédits passés en perte dans la période / encours brut de la période | (T6K + T6L) / [(B2D à B70) − B65] | < 2 % | d11 p.4 |
| F4 | II Activité | Montant moyen des crédits décaissés | mouvements débit des comptes de crédits CT, MT, LT (balance générale) / nombre de crédits décaissés | — | tendance haussière | d11 p.5 |
| F5 | II | Épargne moyenne par épargnant | dépôts fin de période / nombre d'épargnants | G10 à G35 | tendance haussière | d11 p.5 |
| F6 | II | Encours moyen par emprunteur | crédits sains + en souffrance / nombre d'emprunteurs | (B2D à B70) − B65 | tendance haussière | d11 p.5 |
| F7 | III Efficacité | Productivité des agents de crédit | emprunteurs actifs / agents de crédit | — | ≥ 130 (écart à justifier) | d11 p.6 |
| F8 | III | Productivité du personnel | clients actifs / employés | — | > 115 | d11 p.6 |
| F9 | III | Charges d'exploitation / portefeuille | CE / encours brut moyen | (R08 à T6B) / moyenne [(B2D à B70) − B65] | ≤ 35 % | d11 p.6 |
| F10 | III | Frais généraux / portefeuille | frais de personnel + impôts et taxes + autres charges externes et diverses + dotations au FRFG / encours brut moyen | (S02 à T50) / moyenne [(B2D à B70) − B65] | < 15 % crédit direct ; < 20 % épargne et crédit | d11 p.6 |
| F11 | III | Charges de personnel / portefeuille | salaires + charges sociales + stagiaires / encours brut moyen | S02 / moyenne [(B2D à B70) − B65] | < 5 % crédit direct ; < 10 % épargne et crédit | d11 p.6 |
| F12 | IV Rentabilité | Rentabilité des fonds propres | RE / fonds propres moyens | RE = (V08 à X6B − W53) − (R08 à T6B) ; dén. L01 | > 15 % | d11 p.7 |
| F13 | IV | Rendement sur actif | RE / actif moyen | E90 | > 3 % | d11 p.7 |
| F14 | IV | Autosuffisance opérationnelle | PE / CE | (V08 à X6B − W53) / (R08 à T6B) | > 130 % | d11 p.7 |
| F15 | IV | Marge bénéficiaire | RE / PE | idem | > 20 % | d11 p.7 |
| F16 | IV | Coefficient d'exploitation | FG / produit financier net | S02 à T50 / [(V08 à V7A) − (R08 à R7A)] | ≤ 40 % crédit direct ; ≤ 60 % épargne et crédit | d11 p.7 |
| F17 | V Gestion du bilan (d20 p.70) ; sans en-tête dans d11 [AMBIGU] | Taux de rendement des actifs | intérêts et commissions perçus / actifs productifs | (V08 à V7A) / [(A01 − A10 − A60 − A70) + (B01 − B65 − B70) + (C10 + C56) + D1A] | > 15 % | d11 p.8 |
| F18 | V Gestion du bilan | Liquidité de l'actif | disponibilités et comptes courants bancaires + instruments financiers facilement négociables / actif total | (A10 + A12 + A2H + A2J + C10) / E90 | > 2 % crédit direct ; > 5 % épargne et crédit | d11 p.8 |
| F19 | V | Capitalisation | fonds propres / actif total | L01 / E90 | > 15 % | d11 p.8 |

Agrégats (d11 p.7 ; d20 p.68) : **PE** = total des produits sauf subventions d'exploitation et produits exceptionnels ; **CE** = total des charges sauf charges exceptionnelles, pertes sur exercices antérieurs et impôt sur le résultat ; **RE** = PE − CE.

Lecture des plages de postes en comptes (déduite de l'ordre des postes du modèle DIMF 2080 et de l'annexe 1.1 de F) **[AMBIGU, à valider]** :
- R08 à T6B = postes R08 … R8L, S02 … S4S, T50, T51, T6B = comptes 60, 61, 62, 63, 64, 65, 66 (67 et 69 exclus).
- V08 à X6B − W53 = postes V08 … V8C, W4A … W53, X50, X51, X6B, moins W53 = comptes 70, 71, 72, 73, 75, 76 (74 subventions et 77 exclus). Le compte 73 n'existe que dans la version développée (W50 = 731, 732).
- S02 à T50 = S02, S1A, S2A (= S2B + S3A + S4A), T50 = comptes 62, 63, 64, 65 et 6116 (S3M). L'annexe 1.1 donne pour S2A une liste qui omet 6116 ; le total du modèle l'inclut via S3A **[AMBIGU]**.
- V08 à V7A = V08, V3A, V4B, V5B, V6U, V7A = comptes 701 à 709 ; R08 à R7A = 601 à 609.
- T6K + T6L : développée T6K = 6691 (pertes couvertes par des provisions), T6L = 6692 (non couvertes) (F A24) ; allégée T6K = 669, pas de T6L (d18 p.152).
- « (B2D à B70) − B65 » : B70 est **net** de provisions dans l'annexe 1.1 alors que le texte parle d'encours **brut** **[AMBIGU]** ; la lecture brute = B2D + B2N + B30 + B40 + (291 + 292 + 293 + 294). B65 n'est pas compris dans B2D…B40 : la soustraction est sans effet sur la somme des postes.
- « Moyenne » : le texte ne fixe ni le nombre de points ni la méthode **[AMBIGU]**.

### II. Indicateurs non financiers (d11 p.9-11 ; d20 p.71-72)

Colonnes : trimestre T-1, trimestre T, variation (%). Base mensuelle pour les SFD de l'article 44 (renvoi 2, d11 p.9).

| Tableau | Contenu | Réf. |
|---|---|---|
| 1 | Membres, bénéficiaires ou clients : total = (1) personnes physiques non membres d'un groupement, hommes (a) + femmes (b), + (2) personnes morales ; nombre de groupements ; membres des groupements, hommes (c) + femmes (d). Un groupement compte pour une unité. | d11 p.9 |
| 2 | Dirigeants et personnel : conseil d'administration, conseil de surveillance, comité de crédit ; employés = (1) dirigeants (fonctions de direction ou de gérance) + (2) autres ; nationaux CDI / CDD ; expatriés CDI / CDD | d11 p.9 |
| 3 | Déposants : (1) personnes physiques H/F + (2) personnes morales | d11 p.10 |
| 4 | Crédits en cours (nombre) : (1) personnes physiques H/F + (2) personnes morales | d11 p.10 |
| 5 | Crédits par objet (milliers FCFA) : immobiliers, équipement, consommation, trésorerie, autres | d11 p.10 |
| 6 | Crédits en souffrance (nombre) : (1) H/F + (2) personnes morales | d11 p.11 |
| 7 | Surveillance : institutions affiliées\*, affiliées contrôlées\*, taux de mise en œuvre des recommandations, réunions du conseil de surveillance\*, agences ou points de service\*\*, rapports de contrôle interne\*\* (\* faîtières ; \*\* non mutualistes) | d11 p.11 |

### Définitions

| Terme | Définition du texte | Réf. |
|---|---|---|
| Client actif | personne ayant **au moins un dépôt et/ou un crédit en cours** auprès de l'institution, comptée une seule fois | d11 p.6 ; d20 p.68 |
| Emprunteur (F6) | personne ayant un encours de crédit vis-à-vis de l'institution, comptée une fois | d11 p.5 |
| Emprunteur actif (F7) | personne ayant un ou plusieurs crédits en cours, comptée une fois | d11 p.6 |
| Épargnant (F5) | personne disposant d'un ou plusieurs dépôts, **épargne obligatoire comprise**, comptée une fois | d11 p.5 ; d20 p.66 |
| Crédit en souffrance | non défini par l'Instr. 020 ; règle du RCSFD : tout crédit ayant **au moins une échéance impayée** est déclassé pour la **totalité de son encours**, échu ou non ; déclassement **facultatif de 0 à 3 mois** d'impayé ; tranches par ancienneté de la **première échéance impayée** : ≤ 6 mois (292), > 6 à ≤ 12 mois (293), > 12 à ≤ 24 mois (294) ; au-delà de 24 mois, passage en perte (669) ; 291 = crédits immobilisés (redevenus sains après régularisation, rééchelonnés, concordat respecté) | d18 p.66 (membres), p.57 (IF) ; F p.~72 (plan) |
| Provisionnement minimal | base = encours − dépôts de garantie du débiteur ou de sa caution auprès du SFD ; 0-3 mois facultatif ; ≤ 6 mois 40 % ; > 6 à 12 mois 80 % ; > 12 à 24 mois 100 % | d18 p.58 (IF), p.67 (membres) |
| Membre actif | **NON DÉFINI** (seuls « client actif » et « emprunteur actif » le sont) | d11 |
| Agent de crédit, employé | **NON DÉFINIS** (l'employé n'est décrit que par le tableau 2) | d11 |

Périmètre (réseau, caisse, agence) : **non précisé [AMBIGU]**.

## (c) États financiers

### c.1 Instruction 001-02-2018 (d02)

- Champ : SFD soumis au contrôle de la BCEAO et de la CB (art. 1er, p.1), c'est-à-dire ceux de l'article 44. Base légale : loi SFD art. 49, 51 à 54, 73, 147 ; visas des Instr. 025-02-2009 et 030-02-2009 (p.1).
- Composantes (art. 2, p.1-2) : bilan, hors bilan, compte de résultat, annexes. Annexes obligatoires : déclaration de conformité au RCSFD ; méthodes d'évaluation ; dérogations et leur incidence ; changements de méthode et de présentation ; **tableau des emplois et des ressources** (DIMF 2005) ; **état des crédits en souffrance** (DIMF 2010) ; **état des engagements par signature** (DIMF 2011-1) ; **état des valeurs immobilisées** (DIMF 2015) ; **détail du compte « Personnel extérieur à l'institution »** (DIMF 2009, compte 6221).
- Base de présentation (art. 2, p.2) : unions, fédérations et confédérations d'IMCEC → états **combinés** ; SFD non mutualistes qui collectent l'épargne ou octroient du crédit → états **consolidés** « le cas échéant » ; dans les deux cas selon le RCSFD.
- Annexes supplémentaires des états combinés ou consolidés (art. 3, p.2) : liste des entités du périmètre et règle de détermination ; nature des liens ; qualité des ayants droit et des minoritaires ; régimes de taxation ; attestation d'exhaustivité du périmètre ; entrées et sorties de périmètre.
- Rubriques (art. 4, p.3) : une rubrique nulle sur **2 exercices consécutifs** peut être omise, sauf les rubriques principales (regroupement le plus élevé d'une classe).
- Publication (art. 5-6, p.3) : aux frais du SFD, selon la loi (art. 54 : 6 mois, Journal officiel ou deux journaux) ; références notifiées au Ministère des Finances et à la Direction nationale de la BCEAO **sous 7 jours** ; l'avis cite bilan, hors bilan, compte de résultat et l'accès du public aux annexes.
- Délais : aucun délai propre ; renvoi à la loi art. 51 et 54 (6 mois) et à l'Instr. 030-02-2009 art. 6. Sanctions : réglementation SFD (art. 7).
- Abrogation (art. 8, p.3) : « dispositions antérieures contraires traitant du même objet », sans texte nommé. Le lien avec l'Instr. 030-02-2009 est une **inférence** (non écrit).
- Signature : « Dakar, le 23 … 2018 », mois illisible dans la couche texte **[NON VÉRIFIÉ]** ; entrée en vigueur à la signature.
- Instr. 030-02-2009 (d20 p.35-36) : états du chapitre 5 du RCSFD ; **version développée** pour les SFD de l'article 44, **allégée** possible pour les autres (art. 4) ; arrêté au 31/12 ; 5 exemplaires au Ministre sous 6 mois, plus 2 à la BCEAO et 2 à la CB pour l'article 44 ; conservation 10 ans.
- Instr. 021-12-2010 (d12 p.1-2) : version allégée ouverte si encours de dépôts ou de crédit < 50 M FCFA pendant 2 exercices consécutifs ; option pour la développée irréversible sauf autorisation ; GEC en transition autorisés.

### c.2 Consolidation : Instr. 033-11-2016 hors champ SFD

- **L'Instr. 033-11-2016 (d19) ne s'applique pas aux SFD.** Elle vise les banques, établissements financiers à caractère bancaire et compagnies financières, sur le fondement de la loi bancaire et du PCB révisé (d19 p.1). La microfinance n'y figure que comme activité connexe à l'activité bancaire (art. 2 b, p.2). En vigueur au 1/01/2018 (art. 35, p.12).
- Elle reste utile comme référence de méthode (contrôle exclusif > 40 % sans détenteur supérieur, influence notable présumée à 1/5, IG/IP/MEE, seuil d'importance négligeable 2 % du total bilan, écart d'acquisition amorti sur 20 ans au plus) mais **ne crée aucune obligation pour un SFD**.
- Règles SFD de combinaison et de consolidation : loi art. 49 (comptes « sous une forme consolidée ou combinée » selon les règles de la BCEAO, d20 p.15) ; Instr. 030-02-2009 art. 5 ; Instr. 001-02-2018 art. 2-3 ; Instr. 018-12-2010 (rapport annuel combiné pour les réseaux, avec les rapports de chaque entité ; consolidé pour les non mutualistes, d20 p.51-52) ; Instr. 017-12-2010 (annexe des normes de gestion par caisse dans les états combinés ou consolidés, d20 p.47-51).
- Modèles SFD : RCSFD **annexe 6 « États financiers consolidés »** (F, sommaire des annexes, p. A203). **Non transcrit** dans les extractions : contenu **[NON VÉRIFIÉ]**.

### c.3 Modèles DIMF (RCSFD) — en-têtes, colonnes, sens

- Codification (d18 p.118-120) : code document de 3 caractères (catégorie A bilan, B état annexe, R compte de résultat ; rang ; zone 0 = pays, 9 = activité globale) ; code poste de 3 caractères, 1re lettre = classe (A/F classe 1 actif/passif, B/G classe 2, C/H classe 3, D/K classe 4, E/L classe 5, R/S/T charges, V/W/X produits, N/P/Q hors bilan). La table lettre ↔ classe de d18 p.120 est illisible : correspondance **déduite** de l'annexe 1.
- En-tête (d18 p.118) : état, pays, dénomination, état de chargement, date d'arrêté AAAA/MM/JJ, N.S., feuillet, périodicité (D/M/T/S/A), monnaie ; montants **en francs CFA**.
- Bilan actif : colonnes **N : brut, amortissements/provisions, net ; N-1 : net**. Bilan passif : **N, N-1** (nets). Hors bilan : N, N-1. Compte de résultat : charges et produits en liste double, **N, N-1** ; les lignes de SIG n'ont pas de code (d18 p.157-166 ; F A41-A48, A57 et suiv.).
- Sens : actif = soldes débiteurs, nets via les « − » de l'annexe 1.1 ; passif = soldes créditeurs ; « ex NNNN » = compte compté à l'actif s'il est débiteur, au passif s'il est créditeur (d18 p.141 ; F A7).
- Versions : allégée = annexes 2.0/2.1 (bilan) et 3.0 (CR) ; **développée = annexe 2.2 (bilan) et 2.3** (deuxième présentation), annexe 3 développée (CR, code D : RA0/RB0) (F A35-A78). L'allégée n'a **pas de modèle de hors bilan** (d18, annexe 2 = bilan seul) ; F contient un hors bilan (annexe 2).
- Totaux E90 et L90 : aucune formule publiée **[AMBIGU]** ; lecture par somme des rubriques E90 = A01 + B01 + C01 + D01 + E01 + E05, L90 = F01 + G01 + H01 + K01 + L01. Dans le modèle, L75 est présenté dans le bloc des fonds propres, mais l'annexe 1.1 ne le met pas dans L01 (L01 = 501 + 502 + 51 à 59) **[AMBIGU]** : en infra-annuel, le résultat en cours doit apparaître soit en E05 (actif, si charges > produits) soit en L75 (passif, si produits > charges), jamais les deux.
- Remarques allégée (d18) : postes A16, A17, A20, A21, C6G, C6N, C6Q, C6R, H6G, H6P détaillés dans l'annexe 1 mais absents du modèle ; aucune colonne N-1 brute.
- États annexes (d18 p.169-176 ; F A79 et suiv.) : DIMF 2005 emplois-ressources (colonnes amortissements/provisions, net) ; 2010 crédits en souffrance (A crédits 191-193 / 291-293 — 294 non cité **[AMBIGU]** — ; B dépôts de garantie 162 et 254 ; C = A − B ; D provisions 199 et 299 ; E = C − D ; 3 tranches ≤ 6, 6-12, 12-24 mois, alors que le texte p.123 en prévoit 4 et une ventilation par nature) ; 2011 informations annexes ; 2012 dix plus gros débiteurs ; 2013 prêts aux dirigeants, au personnel, aux personnes liées ; 2014 ressources affectées (181 CT, 182 MT, 183 LT) ; 2015 valeurs immobilisées (brut, amortissements/provisions, net) ; 2016 affectation du résultat (codes 77x = codes de lignes, pas des comptes ; 776 utilisé deux fois). Développée seulement : 2006 crédit-bail, 2007 concession, 2008 réserve de propriété, 2009 personnel extérieur, 2011-1 engagements par signature, 2018 réévaluation.

### c.4 Nomenclature des postes et concordance avec les comptes (versions développée et allégée)

Développée : F annexe 1.1, p. A9 à A27 (texte extrait, **[NON VÉRIFIÉ À L'IMAGE]**). Allégée : d18 annexe 1.1, p. PDF 143 à 154 (lue à l'image). « absent de l'allégée » = poste sans concordance dans d18. Les sous-postes de détail (A13, B02, D32…) n'apparaissent pas tous dans les modèles publiés. Coquilles du texte relevées par l'inventaire (reporting.md T25 à T30) : D70 « +491+492−493 » se lit 491 + 492 + 493 − provisions ; L01 omet 503 (L27) à l'impression ; F01 contient « 1176 1516 » sans signe.

#### Bilan — actif (DIMF 2000, AA0)

Sens : D. Colonnes : Brut / Amort.-prov. / Net (N) ; Net (N-1).

| Poste | Libellé (modèle, F annexes 2-3) | Comptes — développée (F annexe 1.1, p.) | Comptes — allégée (d18 annexe 1.1, p. PDF) |
|---|---|---|---|
| A01 | OPERATIONS DE TRESORERIE ET AVEC LES INSTITUTIONS FINANCIERES | + 101 + 1101+ 111111+ 111121+1121+1131 + ex 1141 + ex 1151 + ex 1161 + ex 1171 + 111117+111127+1137+1147 + 1157 + 1167 + 1177 + 1261 + 1271 +1281 + 1267 + 1277 +1287 + 1311 + 1331 + ex 1511+ ex1521+ex 1531+ ex 1541+ ex 1551+ ex 1561 + ex 1571 + 1317 + 1337 + 1517+ 1527 + 1537 + 1547 +1557 + 1567 +1577 + 191+ 192+193 + 194 - 199 (A9) | +1011 +1131 +ex1141 +ex1161 +ex1171 +1261 +1271 +1281 +1311 +1331 +ex1541 +ex1561 +ex1571 +1137 +1147 +1167 +1177 +1267 +1277 +1287 +1317 +1337 +1547 +ex1567 +ex1577 +191 +192 +193 +194 −199 (143) |
| A10 | Valeur en caisse | + 10 (A9) | +10 (143) |
| A11 | Billets et monnaies | + 101 (A9) | +1011 (143) |
| A12 | Comptes ordinaires débiteurs | + 1101 + 1111 + 1121 + 1131 + ex 1141 + ex 1151 + ex 1161 + ex 1171 (A9) | +1131 +ex1141 +ex1161 +ex1171 +ex1541 +ex1561 +ex1571 (143) |
| A13 | (détail Annexe 1, hors modèle publié) | + 111111+1511 (A9) | absent de l'allégée |
| A14 | (détail Annexe 1, hors modèle publié) | +111121 (A9) | absent de l'allégée |
| A15 | (détail Annexe 1, hors modèle publié) | + 1121+ ex 1521 (A9) | absent de l'allégée |
| A16 | (détail Annexe 1, hors modèle publié) | + 1131 + ex 1531 (A9) | +1131 (143) |
| A17 | (détail Annexe 1, hors modèle publié) | + ex 1141 + ex1541 (A9) | +ex1141 (143) |
| A19 | (détail Annexe 1, hors modèle publié) | + ex 1151+ ex 1551 (A9) | absent de l'allégée |
| A20 | (détail Annexe 1, hors modèle publié) | + ex 1161 + ex 1561 (A9) | +ex1161 (143) |
| A21 | (détail Annexe 1, hors modèle publié) | +ex 1171 + ex 1571 (A9) | +ex1171 (143) |
| A2A | Autres comptes de dépôts débiteurs | + 1261 + 1271 +1281 (A9) | +1261 +1271 +1281 (143) |
| A2H | Dépôts à terme constitués | + 1261 (A10) | +1261 (143) |
| A2I | Dépôts de garantie constitués | + 1271 (A10) | +1271 (143) |
| A2J | Autres dépôts constitués | +1281 (A10) | +1281 (143) |
| A3A | Comptes de prêts | + 1311 + 1331 (A10) | +1311 +1331 (143) |
| A3B | Prêts à moins d'un an | + 1311 (A10) | +1311 (143) |
| A3C | Prêts à terme | + 1331 (A10) | +1331 (143) |
| A60 | Créances rattachées | + 111117+111127 + 1137+1147 + 1157 + 1167 +1177 + 1267 + 1277+1287 + 1317 + 1337 + 1517+ 1527 + 1537 + 1547 + 1557 + 1567 +1577 (A10) | +1167 +1177 +1267 +1277 +1287 +1317 +1337 +1547 +1567 +1577 (1137 et 1147 présents dans A01 mais absents de A60 — voir ambiguïtés) (143) |
| A70 | Prêts en souffrance | +191+ 192+193 + 194 - 1991 - 1992 -1993 (A10) | +191 +192 +193 +194 −199 (143) |
| A71 | Prêts en souffrance de 6 mois au plus | +192 - 1991 (A10) | +192 −1991 (143) |
| A72 | Prêts en souffrance de plus de 6 mois à 12 mois au plus | +193 - 1992 (A10) | +193 −1992 (143) |
| A73 | Prêts en souffrance de plus de 12 mois à 24 mois au plus | +194 -1993 (A10) | +194 −1993 (143) |
| B01 | OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | + 20221 + 20227 + 2031 + 2041 + ex 2511 + 2037 + 2047 + 291 + 292 + 293 + 294 - 299 (A12) | +2022 +2023 +20227 +2031 +ex2511 +2037 +291 +292 +293 +294 −2991 −2992 −2993 (145) |
| B02 | (détail Annexe 1, hors modèle publié) | + 20221 + 2031 + 2041 + ex 2511 + 291 + 292 + 293 + 294 - 299 (A12) | absent de l'allégée |
| B03 | (détail Annexe 1, hors modèle publié) | + 20221 + 2031 + 2041 + ex 2511 (A12) | absent de l'allégée |
| B2D | Crédits à court terme | + 20221 + 20231 (A12) | +2022 +2023 (145) |
| B2N | Comptes ordinaires | + ex 2511 (A12) | +ex2511 (145) |
| B30 | Crédits à moyen terme | + 2031 (A12) | +2031 (145) |
| B40 | Crédits à long terme | + 2041 (A12) | absent de l'allégée |
| B65 | Créances rattachées | + 20227 + 20237 + 2037 + 2047 (A12) | +20227 +2037 (145) |
| B70 | Crédits en souffrance | + 291 + 292 + 293 + 294 – 2991 - 2992 - 2993 (A12) | +291 +292 +293 +294 −2991 −2992 −2993 (145) |
| B71 | Crédits en souffrance de 6 mois au plus | + 292 - 2991 (A12) | +292 −2991 (145) |
| B72 | Crédits en souffrance de plus de 6 mois à 12 mois au plus | + 293 - 2992 (A12) | +293 −2992 (145) |
| B73 | Crédits en souffrance de plus de 12 mois à 24 mois au plus | + 294 - 2993 (A12) | +294 −2993 (145) |
| C01 | OPERATIONS SUR TITRES ET OPERATIONS DIVERSES | + 301 + 302 + 303 + 304 - 309 + 3211 + 3221 + 3231 + 3241 - 3219 – 3229 – 3239 - 3249 + 3311 + 3711 + 3713 + 3741 + 3742 + 378 + 3791 + 381 + 39 + 33191 - 33199 (A14) | +30 −309 +3211 +3221 +3231 −3219 −3229 −3239 +331 −3319 +378 +3791 +381 (146) |
| C10 | Titres de placement | + 301 + 302 + 303 + 304 - 309 (A14) | +30 −309 (146) |
| C30 | Comptes de stocks | + 3211 + 3221 + 3231 + 3241 - 3219 – 3229 - 3239 -3249 (A14) | +3211 +3221 +3231 −3219 −3229 −3239 (146) |
| C31 | Stocks de meubles | + 3211 - 3219 (A14) | +3211 −3219 (146) |
| C32 | Stocks de marchandises | + 3221 - 3229 (A14) | +3221 −3229 (146) |
| C33 | Stocks de fournitures | + 3231 - 3239 (A14) | +3231 −3239 (146) |
| C34 | Autres stocks et assimilés | + 3241 - 3249 (A14) | absent de l'allégée |
| C40 | Débiteurs divers | + 33111 + 33112 +33113 + 33114 + 33115 + 33116 + 33191 - 33199 (A14) | +331 −3319 (146) |
| C55 | Créances rattachées | + 307 (A14) | +307 (146) |
| C56 | Valeurs à l'encaissement avec crédit immédiat | + 37111 + 37112 (A14) | absent de l'allégée |
| C59 | Valeurs à rejeter | + 3713 (A14) | absent de l'allégée |
| C6A | Comptes d'ordre et divers | + 3741 + 3742 + 3791 + 378 + 3811 + 3812 + 3814 + 3815 + 39 (A14) | +378 +3791 +3811 +3812 +3814 +3815 (146) |
| C6B | Comptes de liaison | + 39 (A14) | absent de l'allégée |
| C6C | Comptes de différence de conversion | + 3741 + 37421 + 37429 (A14) | absent de l'allégée |
| C6D | (détail Annexe 1, hors modèle publié) | + 3741 (A14) | absent de l'allégée |
| C6E | (détail Annexe 1, hors modèle publié) | + 37421 (A14) | absent de l'allégée |
| C6F | (détail Annexe 1, hors modèle publié) | + 37429 (A14) | absent de l'allégée |
| C6G | Comptes de régularisation actif | + 3811 + 3812 + 3814 + 3815 (A14) | +3811 +3812 +3814 +3815 (146) |
| C6N | (détail Annexe 1, hors modèle publié) | + 378 + 3791 (A14) | +378 +3791 (146) |
| C6Q | Comptes transitoires | + 378 (A14) | +378 (146) |
| C6R | Comptes d'attente - actif | + 3791 (A14) | +3791 (146) |
| D01 | VALEURS IMMOBILISEES | + 41 + 43 + 44 + 45 + 46 + 47 + 49 (A16) | +41 +43 +44 (147) |
| D1A | Immobilisations financières | 4101 + 4102 + 4121 + 4122 + 4123 + 4124 + 4125 + 4141 + 4142 - 4129 - 4149 (A16) | +412 −4129 (147) |
| D10 | Prêts et titres subordonnés | 4101 + 4102 (A16) | absent de l'allégée |
| D1E | Titres de participation | + 4121 + 4122 + 4123 + 4124 + 4125 - 4129 (A16) | absent de l'allégée |
| D1L | Titres d'investissement | + 4141 + 4142 - 4149 (A16) | absent de l'allégée |
| D1S | Dépôts et cautionnements | + 42 - 429 (A16) | +421 −429 (147) |
| D23 | Immobilisations en cours | + (4311 – 4319) + ( 4321 - 4329) (A16) | +(4311 −4319) +(4321 −4329) (147) |
| D24 | Incorporelles | + 4311 - 4319 (A16) | +4311 −4319 (147) |
| D25 | Corporelles | + 4321 - 4329 (A16) | +4321 −4329 (147) |
| D30 | Immobilisations d'exploitation | + 4411 + 4412 + 4413 + 4421 - (4418 + 4419 + 4428 + 4429) (A16) | +441 +442 −(4418 +4419 +4428 +4429) (147) |
| D31 | Incorporelles | + 4411 + 4412 + 4413 - 4418 - 4419 (A16) | +441 −4418 −4419 (147) |
| D32 | (détail Annexe 1, hors modèle publié) | + 44111 - (4418 + 4419) (A16) | absent de l'allégée |
| D33 | (détail Annexe 1, hors modèle publié) | + 44112 - (4418 + 4419) (A16) | absent de l'allégée |
| D34 | (détail Annexe 1, hors modèle publié) | + 4412 - (4418 + 4419) (A16) | absent de l'allégée |
| D35 | (détail Annexe 1, hors modèle publié) | + 4413 - (4418 + 4419) (A16) | absent de l'allégée |
| D36 | Corporelles | + 4421 - 4428 - 4429 (A16) | +442 −4428 −4429 (147) |
| D40 | Immobilisations hors exploitation | + 4511 + 4513 - 4518 - 4519 + 4521 - 4528 - 4529 + 4531 - 4538 - 4539 + 4541 - 4548 - 4549 (A17) | absent de l'allégée |
| D41 | Incorporelles | + 4511 + 4513 - 4518 - 4519 (A17) | absent de l'allégée |
| D42 | (détail Annexe 1, hors modèle publié) | + 45111 - (4518 + 4519) (A17) | absent de l'allégée |
| D43 | (détail Annexe 1, hors modèle publié) | + 45112 - (4518 + 4519) (A17) | absent de l'allégée |
| D44 | (détail Annexe 1, hors modèle publié) | + 4513 - (4518 + 4519) (A17) | absent de l'allégée |
| D45 | Corporelles | + 4521 - 4528 - 4529 (A17) | absent de l'allégée |
| D46 | Incorporelles | + 4531 - 4538 - 4539 (A17) | absent de l'allégée |
| D47 | Corporelles | + 4541 - 4548 - 4549 (A17) | absent de l'allégée |
| D50 | Crédit bail et opérations assimilées | + 461 + 462 + 463 + 464 - 468 - 469 + 471 + 472 + 473 + 474 - 478 - 479 (A17) | absent de l'allégée |
| D51 | Crédit-bail | + 461 + 463 + 464 - (468+469) (A17) | absent de l'allégée |
| D52 | L.O.A. | + 462 + (463 + 464) - (468 + 469) (A17) | absent de l'allégée |
| D53 | Location-vente | + 471 + 472 + 473 + 474 – (478 + 479) (A17) | absent de l'allégée |
| D60 | Créances rattachées | 4107 + 4127 + 4147 + 427 + 467 + 477 (A17) | +4127 +427 (147) |
| D70 | Créances en souffrance | + 491 + 492 - 493 (A17) | absent de l'allégée |
| D71 | Créances en souffrance de 6 mois au plus | + 491 - 49961 - 49971 (A17) | absent de l'allégée |
| D72 | Créances en souffrance de plus de 6 mois à 12 mois au plus | + 492 - 49962 - 49972 (A17) | absent de l'allégée |
| D73 | Créances en souffrance de plus de 12 mois à 24 mois au plus | + 493 - 49963 - 49973 (A17) | absent de l'allégée |
| E01 | ACTIONNAIRES, ASSOCIES OU MEMBRES | + 5731 + 5732 (A18) | +5731 +5732 (148) |
| E02 | Actionnaires, associés ou membres, capital non appelé | + 5731 (A18) | absent de l'allégée |
| E03 | Actionnaires, associés ou membres, capital appelé non versé | + 5732 (A18) | absent de l'allégée |
| E05 | EXCEDENT DES CHARGES SUR LES PRODUITS | + (60 + 61 + 62 + 63 + 64 + 65 + 66 + 67) - (70 + 71 + 72 + 73 + 74 +75 + 76 + 77) (A18) | +(60+61+62+63+64+65+66+67) −(70+71+72+73+74+75+76+77) (148) |
| E90 | TOTAL ACTIF | aucune formule publiée (somme des rubriques) | idem |

#### Bilan — passif (DIMF 2000, AB0)

Sens : C. Colonnes : Net N ; Net N-1.

| Poste | Libellé (modèle, F annexes 2-3) | Comptes — développée (F annexe 1.1, p.) | Comptes — allégée (d18 annexe 1.1, p. PDF) |
|---|---|---|---|
| F01 | OPERATIONS DE TRESORERIE ET AVEC LES INSTITUTIONS FINANCIERES | +ex 111111+ ex 111121 + ex 1141 + ex 1151 + ex 1161+ ex 1171+ ex 1511+ ex 1521 + ex 1531 + ex 1541 + ex 1551+ ex 1561 + 1571 + 111116 +111126 + 1136 + 1146 + 1156 + 1166 + 1176 1516 +1611 + 1621 + 1651 + 1616 + 1626 + 1656 + 1751 + 1781+ 1756 + 1786 + 179 +18 (A11) | +ex1141 +ex1161 +ex1171 +1136 +1146 +1166 +1176 +ex1541 +ex1561 +ex1571 +1546 +ex1566 +ex1576 +1611 +1621 +1651 +1616 +1626 +1656 +1751 +1781 +1756 +1786 +179 +18 (144) |
| F1A | Comptes ordinaires créditeurs | + ex 111111 + ex 111121 + ex 1141 + ex 1151 + ex 1161 + ex 1171 1521 + ex 1531 + ex 1541 + ex 1511+ ex 1551+ ex 1561 + ex 1571 (A11) | +ex1141 +ex1161 +ex1171 +ex1541 +ex1561 +ex1571 (144) |
| F2A | Autres comptes de dépôts créditeurs | +1611 + 1621 + 1651 (A11) | +1611 +1621 +1651 (144) |
| F2B | Dépôts à terme reçus | +1611 (A11) | +1611 (144) |
| F2C | Dépôts de garantie reçus | +1621 (A11) | +1621 (144) |
| F2D | Autres dépôts reçus | +1651 (A11) | +1651 (144) |
| F3A | Comptes d'emprunts | + 1751 + 1781 (A11) | +1751 +1781 (144) |
| F3E | Emprunts à moins d'un an | + 1751 (A11) | +1751 (144) |
| F3F | Emprunts à terme | + 1781 (A11) | +1781 (144) |
| F50 | Autres sommes dues aux institutions financières | + 179 (A11) | +179 (144) |
| F55 | Ressources affectées | +18 (A11) | +18 (144) |
| F60 | Dettes rattachées | +111116 + 111126 + 1136 … (A11, tronqué : texte source corrompu, voir points à valider) | +1136 +1146 +1166 +1176 +1546 +1566 +1576 +1756 +1786 +1616 +1626 +1656 (144) |
| G01 | OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | + ex 25111 + ex 25121 + 2521 + 25311 + 25321 + 25331 + 25391 + 2545 + 2551 + 2711 + 2721 + 2722 + 2725 + 25116 + 25126 + 2526 + 2546 + 2556 + 25316 + 25326 + 25336 + 25396 2716 + 2726 (A13) | +ex2511 +ex2512 +2521 +2531 +2545 +2551 +2711 +2721 +2722 +2725 +25116 +25126 +2526 +25316 +2546 +2556 +2716 +2726 (145) |
| G02 | (détail Annexe 1, hors modèle publié) | + ex 25111 + ex 25121 + 2521 + 25311 + 25321 + 25331 + 25391 + 2541 + 2542 + 2543 + 2544 + 2545 + 2551 + 2711 + 2721 + 2722 + 2725 (A13) | absent de l'allégée |
| G10 | Comptes ordinaires créditeurs | + ex 25111 + ex 25121 (A13) | +ex2511 +ex2512 (145) |
| G15 | Dépôts à terme reçus | + 2521 (A13) | +2521 (145) |
| G2A | Comptes d'épargne à régime spécial | + 25311 + 25321 + 25331 + 25391 (A13) | +2531 (145) |
| G30 | Autres dépôts de garantie reçus | +2545 (A13) | +2545 (145) |
| G35 | Autres dépôts reçus | + 2551 (A13) | +2551 (145) |
| G60 | Emprunts | + 2711 (A13) | +2711 (145) |
| G70 | Autres sommes dues | + 2721 + 2722 + 2725 (A13) | +2721 +2722 +2725 (145) |
| G90 | Dettes rattachées | + 25116 + 25126 + 2526 + 2546 + 2556 + 25316 + 25326 + 25336 + 25396 2716 + 2726 (A13) | +25116 +25126 +2526 +25316 +2546 +2556 +2716 +2726 (145) |
| H01 | OPERATIONS SUR TITRES ET OPERATIONS DIVERSES | + 305 + 332 + 3712 + 3741 + 3743 + 3792 + 382 + 39 (A15) | +305 +332 +3792 +382 (146) |
| H10 | Versements restant à effectuer | + 305 (A15) | +305 (146) |
| H40 | Créditeurs divers | + 332 (A15) | +332 (146) |
| H6A | Comptes d'ordre et divers | + 3741 + 3743 + 3792 + 3822 + 3824 + 3825 + 39 (A15) | +3792 +3822 +3824 +3825 (146) |
| H6B | Comptes de liaison | + 39 (A15) | absent de l'allégée |
| H6G | Comptes de régularisation - passif | + 3822 + 3824 + 3825 (A15) | +3822 +3824 +3825 (146) |
| H6C | Comptes de différences de conversion | + 3741 + 37431 + 37439 (A15) | absent de l'allégée |
| H6P | Comptes d'attente - passif | + 3792 (A15) | +3792 (146) |
| K01 | VERSEMENTS RESTANT A EFFECTUER SUR IMMOBILISATIONS FINANCIERES | + 4126 (A17) | +4126 (147) |
| K20 | Titres de participation | + 4126 (A17) | +4126 (147) |
| L01 | PROVISIONS, FONDS PROPRES ET ASSIMILES | + 501 + 502 + 51 + 52 + 53 + 54 + 55 + 56 + 57 + 58 + 59 (A19) | +501 +502 +503 +51 +52 +53 +54 +55 +56 +57 +58 +59 (149) |
| L10 | Subventions d'investissement | + 5011 + 5012 (A19) | +5011 +5012 (149) |
| L20 | Fonds affectés | + 5021 + 5022 + 5023 + 5024 + 5029 (A19) | +502 (149) |
| L21 | Fonds de garantie | + 5021 (A19) | absent de l'allégée |
| L22 | Fonds d'assurance | + 5022 (A19) | absent de l'allégée |
| L23 | Fonds de bonification | + 5023 (A19) | absent de l'allégée |
| L24 | Fonds de sécurité | + 5024 (A19) | absent de l'allégée |
| L25 | Autres fonds affectés | + 5029 (A19) | absent de l'allégée |
| L27 | Fonds de crédit | + 503 (A19) | +503 (149) |
| L30 | Provisions pour Risques et Charges | + 511 + 512 + 519 (A19) | +511 +519 (149) |
| L31 | Provisions pour charges de retraite | + 511 (A19) | +511 (149) |
| L32 | Provisions pour risque d'exécution des engagements par signature | + 512 (A19) | absent de l'allégée |
| L33 | Autres provisions pour risques et charges | + 519 (A19) | +519 (149) |
| L35 | Provisions réglementées | + 52 (A19) | +52 (149) |
| L36 | Provisions pour risques afférents aux opérations de crédits à moyen et long termes | + 521 (A19) | +521 (149) |
| L37 | Provision spéciale de réévaluation | + 522 (A19) | absent de l'allégée |
| L41 | Emprunts et titres émis subordonnés | + 532 (A19) | +532 (149) |
| L43 | Dettes rattachées aux emprunts et titres émis subordonnés | + 536 (A19) | +536 (149) |
| L45 | Fonds pour risques financiers généraux | + 54 (A19) | +54 (149) |
| L50 | Primes liées au capital | + 551 (A19) | +551 (149) |
| L55 | Réserves | + 5521 + 5522 + 5523 (A19) | +5521 +5522 +5523 (149) |
| L56 | Réserve générale | + 5521 (A19) | +5521 (149) |
| L57 | Réserves facultatives | + 5522 (A19) | +5522 (149) |
| L58 | Autres réserves | + 5523 (A19) | +5523 (149) |
| L59 | Ecart de réévaluation des immobilisations | + 553 (A19) | absent de l'allégée |
| L60 | Capital | + 5711 + 5712 (A19) | +5711 +5712 (149) |
| L61 | Capital appelé | + 5711 (A19) | +5711 (149) |
| L62 | Capital non appelé | + 5712 (A19) | +5712 (149) |
| L65 | Fonds de dotation | + 56 (A19) | +56 (149) |
| L70 | Report à nouveau (+ ou -) | + 58 (A19) | +58 (149) |
| L75 | Excédent des produits sur les charges | + (70 + 71 + 72 + 73 + 74 + 75 + 76 + 77) - (60 + 61 + 62 + 63 + 64 + 65 + 66 + 67) (A19) | +(70+71+72+73+74+75+76+77) −(60+61+62+63+64+65+66+67) (149) |
| L80 | Résultat de l'exercice (+ ou -) | + 59 (A19) | +59 (153-154) |
| L81 | Excédent ou déficit en instance d'approbation | + 591 (A19) | +591 (149) |
| L82 | Excédent ou déficit de l'exercice | + 592 (A19) | +592 (149) |
| L90 | TOTAL PASSIF | aucune formule publiée (somme des rubriques) | idem |

#### Hors bilan (DIMF 2000 hors bilan, version développée seulement)

Sens : selon compte (engagement donné D, reçu C). Colonnes : N ; N-1.

| Poste | Libellé (modèle, F annexes 2-3) | Comptes — développée (F annexe 1.1, p.) | Comptes — allégée (d18 annexe 1.1, p. PDF) |
|---|---|---|---|
| N1A | ENGAGEMENTS DONNES EN FAVEUR DES INSTITUTIONS FINANCIERES | +901 (A20) | absent de l'allégée |
| N1H | ENGAGEMENTS RECUS DES INSTITUTIONS FINANCIERES | +902 (A20) | absent de l'allégée |
| N1J | ENGAGEMENTS DONNES EN FAVEUR DES MEMBRES, BENEFICIAIRES OU CLIENTS | +903 (A20) | absent de l'allégée |
| N1K | ENGAGEMENTS RECUS DES MEMBRES, BENEFICIAIRES OU CLIENTS | +904 (A20) | absent de l'allégée |
| N2A | D'ordre des institutions financières | +911 (A20) | absent de l'allégée |
| N2H | Reçus des institutions financières | + 912 (A20) | absent de l'allégée |
| N2J | D'ordre des membres, bénéficiaires ou clients | + 913 (A20) | absent de l'allégée |
| N2M | Reçus des membres, bénéficiaires ou clients | + 914 (A20) | absent de l'allégée |
| N3A | Titres à livrer | + 9211+ 9212 + 9219 (A20) | absent de l'allégée |
| N3B | Intervention à l'émission | +9211 (A20) | absent de l'allégée |
| N3C | Marché gris | +9212 (A20) | absent de l'allégée |
| N3D | Autres titres à livrer | +9219 (A20) | absent de l'allégée |
| N3E | Titres à recevoir | +9221 + 9222 + 9229 (A20) | absent de l'allégée |
| NRF (N3F ?) | Intervention à l'émission | +9221 (A20) | absent de l'allégée |
| NRG (N3G ?) | Marché gris | +9222 (A20) | absent de l'allégée |
| N3H | Autres titres à livrer (sic source ; sous N3E « à recevoir ») | +9229 (A20) | absent de l'allégée |
| P1A | Francs CFA achetés non encore reçus | +9311 (A20) | absent de l'allégée |
| P1B | Devises achetées non encore reçues | +9312 (A20) | absent de l'allégée |
| P1C | Francs CFA vendus non encore livrés | +9313 (A20) | absent de l'allégée |
| P1D | Devises vendues non encore livrées | +9314 (A20) | absent de l'allégée |
| P1E | Devises prêtées non encore livrées | +9331 (A20) | absent de l'allégée |
| P1F | Devises empruntées non encore reçues | +9332 (A20) | absent de l'allégée |
| P1G | Opérations de change à terme francs cfa à recevoir contre devises à livrer | +9321 (A20) | absent de l'allégée |
| P1H | Opérations de change à terme devises à recevoir contre FCFA à livrer | +9322 (A20) | absent de l'allégée |
| P1J | Opérations de change à terme devises à recevoir contre devises à livrer | +9323 (A20) | absent de l'allégée |
| P1K | Opérations de change à terme devises à livrer contre devises à recevoir | +9324 (A20) | absent de l'allégée |
| P1L | Report/déport non couru à recevoir | +9341 (A20) | absent de l'allégée |
| P1M | Report/déport non couru à payer | +9342 (A20) | absent de l'allégée |
| P1R | Intérêts non courus en devises couverts à recevoir | +9351 (A20) | absent de l'allégée |
| P1S | Intérêts non courus en devises couverts à payer | +9352 (A20) | absent de l'allégée |
| P1V | Ajustements devises hors bilan AUTRES ENGAGEMENTS | +936 (A20) | absent de l'allégée |
| Q1A | Engagements donnés | +951 (A20) | absent de l'allégée |
| Q1B | Engagements reçus | +952 (A20) | absent de l'allégée |
| Q1C | Valeurs à l'encaissement non disponibles | +9611 + 9613 (A20) | absent de l'allégée |
| Q1F | Comptes exigibles après encaissements | +9612 + 9614 (A20) | absent de l'allégée |
| Q1J | Comptes de suivi des engagements de financement consortiaux | +9621 (A20) | absent de l'allégée |
| Q1K | Comptes de suivi des engagements de garantie consortiaux | +9631 (A20) | absent de l'allégée |
| Q1L | Comptes de suivi des crédits consortiaux | +9651 (A20) | absent de l'allégée |
| Q1M | Crédits distribués pour le compte de tiers | +9661 (A20) | absent de l'allégée |
| N90 | ENGAGEMENTS DOUTEUX | +99 (A20) | absent de l'allégée |

#### Compte de résultat — charges (DIMF 2080, RA0)

Sens : D. Colonnes : N ; N-1.

| Poste | Libellé (modèle, F annexes 2-3) | Comptes — développée (F annexe 1.1, p.) | Comptes — allégée (d18 annexe 1.1, p. PDF) |
|---|---|---|---|
| R08 | CHARGES SUR OPERATIONS AVEC LES INSTITUTIONS FINANCIERES | + 6011 + 6015 + 6016 + 6017 + 6018 + 6019 (A21) | +6011 +6015 +6016 +6017 +6018 +6019 (150-152) |
| R1A | Intérêts sur comptes ordinaires créditeurs | + 6011 + 6015 (A21) | +6011 +6015 (150-152) |
| R1B | Organe financier | +60111 + 60151 (A21) | absent de l'allégée |
| R1C | Caisse centrale | +60112 (A21) | absent de l'allégée |
| R1D | Trésor Public | +60152 (A21) | absent de l'allégée |
| R1E | CCP | +60113 + 60153 (A21) | absent de l'allégée |
| R1F | Banques et correspondants | + 60114 + 60154 (A21) | absent de l'allégée |
| R1H | Etablissements financiers | + 60115 + 60155 (A21) | absent de l'allégée |
| R1I | SFD | +60116 + 60156 (A21) | absent de l'allégée |
| R1K | Autres institutions financières | +60117 + 60157 (A21) | absent de l'allégée |
| R1L | Intérêts sur autres comptes de dépôts créditeurs | + 6016 (A21) | +6016 (150-152) |
| R1N | Dépôts à terme reçus | +60161 (A21) | absent de l'allégée |
| R1P | Dépôts de garantie reçus | +60162 (A21) | absent de l'allégée |
| R1Q | Autres dépôts reçus | +60165 (A21) | absent de l'allégée |
| R2A | Intérêts sur comptes d'emprunts | + 6017 (A21) | +6017 (150-152) |
| R2F | Intérêts sur emprunts à moins d'un an | + 60175 (A21) | absent de l'allégée |
| R2G | Intérêts sur emprunts à terme | + 60178 (A21) | absent de l'allégée |
| R2R | Autres intérêts | + 6018 (A21) | +6018 (150-152) |
| R2T | Divers intérêts | + 60189 (A21) | absent de l'allégée |
| R2Z | Commissions | + 6019 (A21) | +6019 (150-152) |
| R3A | CHARGES SUR OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | + 6025 + 6027 + 6028 + 6029 (A21) | +6025 +6027 +6028 +6029 (150-152) |
| R3C | Intérêts sur comptes des membres, bénéficiaires ou clients | + 6025 (A21) | +6025 (150-152) |
| R3D | Intérêts sur comptes ordinaires créditeurs | + 60251 (A21) | +60251 (150-152) |
| R3F | Intérêts sur dépôts à terme reçus | + 60252 (A21) | +60252 (150-152) |
| R3G | Intérêts sur comptes d'épargne à régime spécial | + 60253 (A21) | +60253 (150-152) |
| R3H | Intérêts sur dépôts de garantie reçus | + 60254 (A21) | +60254 (150-152) |
| R3J | Intérêts sur autres dépôts reçus | + 60255 (A21) | +60255 (150-152) |
| R3N | Intérêts sur emprunts et autres sommes dues | + 6027 (A21) | +6027 (150-152) |
| R3Q | Autres Intérêts | + 6028 (A21) | +6028 (150-152) |
| R3T | Commissions | + 6029 (A21) | +6029 (150-152) |
| R4B | CHARGES SUR OPERATIONS SUR TITRES ET OPERATIONS DIVERSES | + 6031 + 6038 + 6039 (A22) | +6031 +6038 +6039 (150-152) |
| R4C | Charges et pertes sur titres de placement | + 6031 (A22) | +6031 (150-152) |
| R4K | Charges sur opérations diverses | + 6038 (A22) | +6038 (150-152) |
| R4N | Commissions | + 6039 (A22) | +6039 (150-152) |
| R5B | CHARGES SUR IMMOBILISATIONS FINANCIERES | + 60411 + 60412 (A22) | +6041 (150-152) |
| R5C | Frais d'acquisition | +60411 (A22) | absent de l'allégée |
| R5D | Etalement de la prime | +60412 (A22) | absent de l'allégée |
| R5E | CHARGES SUR CREDIT BAIL et OPERATIONS ASSIMILEES | + 6046 + 6047 (A22) | absent de l'allégée |
| R5G | Charges sur opérations de crédit bail | + 60461 + 60463 + 60464 (A22) | absent de l'allégée |
| R5H | Dotations aux amortissements | + 604611 + 604631 + 604641 (A22) | absent de l'allégée |
| R5J | Dotations aux provisions | + 604612 + 604632 + 604642 (A22) | absent de l'allégée |
| R5K | Moins-values de cession | + 604613 + 604633 + 604643 (A22) | absent de l'allégée |
| R5L | Autres charges | + 604619 + 604639 + 604649 (A22) | absent de l'allégée |
| R5M | Charges sur opérations de location avec option d'achat | + 60462 + 60463 + 60464 (A22) | absent de l'allégée |
| R5N | Dotations aux amortissements | + 604621 + 604631 + 60464 (A22) | absent de l'allégée |
| R5P | Dotations aux provisions | + 604622 + 604632 + 604642 (A22) | absent de l'allégée |
| R5Q | Moins-values de cession | + 604623 + 604633 + 604643 (A22) | absent de l'allégée |
| R5R | Autres charges | + 604629 + 604639 + 604649 (A22) | absent de l'allégée |
| R5S | Charges sur opérations de location-vente | + 60471 + 60472 + 60473 + 60474 (A22) | absent de l'allégée |
| R5T | Dotations aux amortissements | + 604721 + 604731 + 604741 (A22) | absent de l'allégée |
| R5U | Dotations aux provisions | + 604712 + 604722 + 604732 + 604742 (A22) | absent de l'allégée |
| R5V | Moins-values de cession | + 604713 + 604723 + 604733 + 604743 (A22) | absent de l'allégée |
| R5X | Autres charges | + 604719 + 604729 + 604739 + 604749 (A22) | absent de l'allégée |
| R5Y | Charges sur emprunts et titres émis subordonnés | + 60532 (A22) | +6053 (150-152) |
| R6A | CHARGES SUR OPERATIONS DE CHANGE | + 6061 + 6069 (A22) | absent de l'allégée |
| R6B | Pertes sur opérations de change | + 6061 (A22) | absent de l'allégée |
| R6C | Commissions | + 6069 (A22) | absent de l'allégée |
| R6F | CHARGES SUR OPERATIONS HORS BILAN | +6071 + 6072 + 6073 + 6075 (A22) | absent de l'allégée |
| R6K | Charges sur engagements de financements reçus des institutions financières | +60712 (A22) | absent de l'allégée |
| R6L | Charges sur engagements de financements reçus des membres, clients ou bénéficiaires | +60714 (A22) | absent de l'allégée |
| R6M | Charges sur engagements de garantie reçus des institutions financières | +60722 (A22) | absent de l'allégée |
| R6P | Charges sur engagements de garantie reçus des membres, bénéficiaires ou clients | +60724 (A22) | absent de l'allégée |
| R6S | Charges sur engagements sur titres | +6073 (A22) | absent de l'allégée |
| R6T | Charges sur autres engagements reçus | +6075 (A22) | absent de l'allégée |
| R6V | CHARGES SUR PRESTATIONS DE SERVICES FINANCIERS | +6081 + 6089 (A22) | +608 (150-152) |
| R6W | Charges sur les moyens de paiement | +6081 (A22) | absent de l'allégée |
| R6X | Autres charges sur prestations de services financiers | +6089 (A22) | absent de l'allégée |
| R7A | AUTRES CHARGES D'EXPLOITATION FINANCIERE | + 6091 + 6098 + 6099 (A22) | +6091 +6098 +6099 (150-152) |
| R7B | Moins-values sur cession d'éléments d'actif | + 6091 (A22) | +6091 (150-152) |
| R7C | Transferts de produits d'exploitation financière | + 6098 (A22) | +6098 (150-152) |
| R7D | Diverses charges d'exploitation financière | + 6099 (A22) | +6099 (150-152) |
| R8G | Achats de marchandises | + 6117 + 6118 - 6119 (A22) | +6117 +6118 −6119 (150-152) |
| R8J | Stocks vendus | + 6112 (A22) | +6112 (150-152) |
| R8L | Variations de stocks de marchandises | + 612 (A22) | +612 (150-152) |
| S02 | FRAIS DE PERSONNEL | + 641 + 642 + 643 (A23) | +641 +642 +643 (150-152) |
| S03 | Salaires et traitements | + 641 (A23) | +641 (150-152) |
| S04 | Charges sociales | + 642 (A23) | +642 (150-152) |
| S05 | (détail Annexe 1, hors modèle publié) | + 643 (A23) | +643 (150-152) |
| S1A | IMPOTS ET TAXES | + 6311 + 6312 + 6321 + 6323 + 6324 + 6329 + 633 (A23) | +631 +632 +633 (150-152) |
| S1B | Autres impôts, taxes et versements assimilés sur rémunérations | + 6311 + 6312 (A23) | +631 (150-152) |
| S1C | Autres impôts , taxes et prélévements assimilés versés à l'administration des impôts | + 6321 + 6323 + 6324 + 6329 (A23) | +632 (150-152) |
| S1D | Impôts directs | + 6321 (A23) | absent de l'allégée |
| S1G | Impôts indirects | + 6323 (A23) | absent de l'allégée |
| S1H | Droits d'enregistrement et de timbre | + 6324 (A23) | absent de l'allégée |
| S1J | Impôts et taxes divers | + 6329 (A23) | absent de l'allégée |
| S1K | Autres impôts, taxes et prélèvements assimilés versés aux autres organismes | + 633 (A23) | +633 (150-152) |
| S2A | AUTRES CHARGES EXTERNES ET CHARGES DIVERSES D'EXPLOITATION | + 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6217+6218 - 6219 + 6221 + 6222 + 6223 + 6224 + 6225 + 6226 + 6227 + 6228 + 6231+ 6232 – 6229+6233 (A23) | +6211 +6212 +6213 +6214 +6215 +6216 +6217 +6218 −6219 +6221 +6222 +6223 +6224 +6225 +6226 +6227 +6228 +6231 +6232 −6229 +6233 +6235 +6238 +6239 (150-152) |
| S2B | Services extérieurs | + 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6218 - 6219 (A23) | +6211 +6212 +6213 +6214 +6215 +6216 +6217 +6218 −6219 (150-152) |
| S2C | Redevances de crédit-bail | + 6211 + 6217 (A23) | +6211 (150-152) |
| S2D | Loyers | + 6212 (A23) | +6212 (150-152) |
| S2F | Charges locatives et de co-propriété | + 6213 (A23) | +6213 (150-152) |
| S2H | Entretien et réparations | + 6214 (A23) | +6214 (150-152) |
| S2J | Primes d'assurance | + 6215 (A23) | +6215 (150-152) |
| S2K | Etudes et recherches | + 6216 (A23) | +6216 (150-152) |
| S2M | Frais de formation du personnel | + 6217 (A23) | +6217 (150-152) |
| S2L | Divers | + 6218 - 6219 (A23) | +6218 −6219 (150-152) |
| S3A | Autres services extérieurs | + 6221 + 6222 + 6223 + 6224 + 6225 + 6226 + 6227 + 6228 - 6229 + 6116 (A23) | +6221 +6222 +6223 +6224 +6225 +6226 +6227 +6228 −6229 +6116 (150-152) |
| S3B | Personnel extérieur à l'institution | + 6221 (A23) | +6221 (150-152) |
| S3C | Rémunérations d'intermédiaires et honoraires | + 6222 (A23) | +6222 (150-152) |
| S3E | Publicité, publications et relations publiques | + 6223 (A23) | +6223 (150-152) |
| S3G | Transports de biens | + 6224 (A23) | +6224 (150-152) |
| S3J | Transports collectifs du personnel | + 6225 (A23) | +6225 (150-152) |
| S3L | Déplacements, missions et réceptions | + 6226 (A23) | +6226 (150-152) |
| S3N | Frais postaux et frais de télécommunication | + 6227 (A23) | +6227 (150-152) |
| S3M | Achats non stockés de matières et fournitures | + 6116 (A23) | +6116 (150-152) |
| S3P | Divers | + 6228 - 6229 (A23) | +6228 −6229 (150-152) |
| S4A | Charges diverses d'exploitation | + 6231+ 6232 + 6233 + 6235 + 6238 + 6239 (A23) | +6231 +6232 +6233 +6235 +6238 +6239 (150-152) |
| S4B | Redevances pour concessions,brevets, licences, procédés, droits et valeurs similaires | + 6231 (A23) | +6231 (150-152) |
| S4D | Indemnités de fonction versées | + 6232 (A23) | +6232 (150-152) |
| S4I | Frais de tenue d'assemblée | + 6233 (A23) | +6233 (150-152) |
| S4K | Moins-values de cession sur immobilisations | + 6235 (A23) | +6235 (150-152) |
| S4L | sur immobilisations corporelles et incorporelles | + 62351 (A23) | absent de l'allégée |
| S4M | sur immobilisations financières | + 62352 (A23) | absent de l'allégée |
| S4P | Transferts de produits d'exploitation non financière | + 6238 (A23) | +6238 (150-152) |
| S4Q | Produits rétrocédés | + 62381 (A23) | absent de l'allégée |
| S4R | Autres transferts de produits | + 62389 (A23) | absent de l'allégée |
| S4S | Autres charges diverses d'exploitation non financière | + 6239 (A23) | +6239 (150-152) |
| T50 | DOTATIONS AU FONDS POUR RISQUES FINANCIERS GENERAUX | +65 (A24) | +65 (150-152) |
| T51 | DOTATIONS AUX AMORTISSEMENTS ET AUX PROVISIONS SUR IMMOBILISATIONS | + 661 + 662 + 663 (A24) | +661 +662 +663 (150-152) |
| T53 | Dotation aux amortissements de charges à répartir | +662 (A24) | +662 (150-152) |
| T54 | Dotations aux amortissements des immobilisations d'exploitation | + 6611 (A24) | +661 (150-152) |
| T55 | Dotations aux amortissements des immobilisations hors exploitation | + 6612 (A24) | absent de l'allégée |
| T56 | Dotations aux provisions pour dépréciation des immobilisations en cours | + 6631 (A24) | +663 (150-152) |
| T57 | Dotations aux provisions pour dépréciation des immobilisations d'exploitation | + 6632 (A24) | absent de l'allégée |
| T58 | Dotations aux provisions pour dépréciation des immobilisations hors exploitation | + 6633 (A24) | absent de l'allégée |
| T6B | DOTATIONS AUX PROVISIONS ET PERTES SUR CREANCES IRRECOUVRABLES | 6641+ 6642 + 6643 + 666 + 667 + 668 + 669 (A24) | +664 +666 +667 +668 +669 (150-152) |
| T6C | Dotations aux provisions sur créances en souffrance | + 6641 + 6642 + 6643 (A24) | +6641 +6642 +6643 (150-152) |
| T6D | Dotations aux provisions sur créances en souffrance de 6 mois au plus | + 6641 (A24) | +6641 (150-152) |
| T6E | Dotations aux provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus | + 6642 (A24) | +6642 (150-152) |
| T6F | Dotations aux provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus | + 6643 (A24) | +6643 (150-152) |
| T6G | Dotations aux provisions pour dépréciation d'autres éléments d'actif | + 666 (A24) | +666 (150-152) |
| T6H | Dotations aux provisions pour risques et charges | + 667 (A24) | +667 (150-152) |
| T6J | Dotations aux provisions réglementées | + 668 (A24) | +668 (150-152) |
| T6K | Pertes sur créances irrécouvrables couvertes par des provisions | + 6691 (A24) | +669 (150-152) |
| T6L | Pertes sur créances irrécouvrables non couvertes par des provisions | + 6692 (A24) | absent de l'allégée |
| T80 | CHARGES EXCEPTIONNELLES | + 671 (A24) | +671 (150-152) |
| T81 | PERTES SUR EXERCICES ANTERIEURS | + 672 (A24) | +672 (150-152) |
| T82 | IMPOTS SUR LES EXCEDENTS | + 69 (A24) | +69 (150-152) |
| T84 | TOTAL CHARGES | + 60 + 61 + 62 + 63 + 64 + 65+ 66 + 67 + 69 + 59 (A24) | +60 +61 +62 +63 +64 +65 +66 +67 +69 +59 (150-152) |

#### Compte de résultat — produits (DIMF 2080, RB0)

Sens : C. Colonnes : N ; N-1.

| Poste | Libellé (modèle, F annexes 2-3) | Comptes — développée (F annexe 1.1, p.) | Comptes — allégée (d18 annexe 1.1, p. PDF) |
|---|---|---|---|
| V08 | PRODUITS SUR OPERATIONS AVEC LES INSTITUTIONS FINANCIERES | + 7011 + 7012 + 7013 + 7015 + 7018 + 7019 (A25) | +7011 +7012 +7013 +7015 +7018 +7019 (153-154) |
| V1A | Intérêts sur comptes ordinaires débiteurs | + 7011 + 7015 (A25) | +7011 +7015 (153-154) |
| V1B | Organe financier | + 70111 + 70151 (A25) | absent de l'allégée |
| V1C | Caisse centrale | +70112 (A25) | absent de l'allégée |
| V1D | Trésor Public | +70152 (A25) | absent de l'allégée |
| V1E | CCP | +70113+ 70153 (A25) | absent de l'allégée |
| V1F | Banques et correspondants | + 70114 + 70154 (A25) | absent de l'allégée |
| V1H | Etablissements financiers | + 70115 + 70155 (A25) | absent de l'allégée |
| V1I | SFD | +70116 + 70156 (A25) | absent de l'allégée |
| V1K | Autres institutions financières | +70117 + 70157 (A25) | absent de l'allégée |
| V1L | Intérêts sur autres comptes de dépôts débiteurs | + 7012 (A25) | +7012 (153-154) |
| V1Q | Intérêts sur dépôts à terme constitués | + 70126 (A25) | absent de l'allégée |
| V1R | Intérêts sur dépôts de garantie constitués | + 70127 (A25) | absent de l'allégée |
| V1S | Intérêts sur autres dépôts constitués | +70128 (A25) | absent de l'allégée |
| V2A | Intérêts sur comptes de prêts | + 7013 (A25) | +7013 (153-154) |
| V2C | Intérêts sur prêts à moins d'un an | + 70131 (A25) | absent de l'allégée |
| V2G | Intérêts sur prêts à terme | + 70133 (A25) | absent de l'allégée |
| V2Q | Autres Intérêts | + 7018 (A25) | +7018 (153-154) |
| V2S | Divers Intérêts | + 70189 (A25) | absent de l'allégée |
| V2T | Commissions | + 7019 (A25) | +7019 (153-154) |
| V3A | PRODUITS SUR OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | + 7021 + 7028 + 7029 (A26) | +7021 +7025 +7028 +7029 (153-154) |
| V3B | Intérêts sur crédits aux membres, bénéficiaires ou clients | + 7021 (A26) | +7021 (153-154) |
| V3G | Autres crédits à court terme | + 70212 (A26) | +7025 (153-154) |
| V3M | Intérêts sur crédits à moyen terme | + 70213 (A26) | absent de l'allégée |
| V3N | Intérêts sur crédits à long terme | + 70214 (A26) | absent de l'allégée |
| V3R | Autres Intérêts | + 7028 (A26) | +7028 (153-154) |
| V3T | Divers Intérêts | + 70289 (A26) | absent de l'allégée |
| V3X | Commissions | + 7029 (A26) | +7029 (153-154) |
| V4B | PRODUITS SUR OPERATIONS SUR TITRES ET SUR OPERATIONS DIVERSES | + 7031 + 7033 + 7038 + 7039 (A26) | +7038 +7039 (153-154) |
| V4C | Produits et profits sur titres de placement | + 7031 (A26) | absent de l'allégée |
| V4D | Intérêts sur crédits accordés au personnel non membre | + 7033 (A26) | absent de l'allégée |
| V4E | Produits sur opérations diverses | + 7038 (A26) | +7038 (153-154) |
| V4F | Commissions | + 7039 (A26) | +7039 (153-154) |
| V5B | PRODUITS SUR IMMOBILISATIONS FINANCIERES | + 7041 (A26) | +704 (153-154) |
| V5C | Produits sur prêts et titres subordonnés | +70410 (A26) | absent de l'allégée |
| V5D | Dividendes et produits assimilés sur titres de participation | + 70412 (A26) | absent de l'allégée |
| V5F | Produits et profits sur titres d'investissement | + 70414 (A26) | absent de l'allégée |
| V5G | PRODUITS SUR OPERATIONS DE CREDIT BAIL ET OPERATIONS ASSIMILEES | + 7046 + 7047 (A26) | absent de l'allégée |
| V5H | Produits sur opérations de crédit-bail | + 70461 + 70463 + 70464 (A26) | absent de l'allégée |
| V5J | Loyers | + 704611 + 704631 (A26) | absent de l'allégée |
| V5K | Reprises de provisions | + 704612 + 704632 + 704642 (A26) | absent de l'allégée |
| V5L | Plus-values de cession | + 704613 + 704633 + 704643 (A26) | absent de l'allégée |
| V5M | Autres produits | + 704619 + 704639 + 704649 (A26) | absent de l'allégée |
| V5N | Produits sur opérations de location avec option d'achat | + 70462 + 70463 + 70464 (A26) | absent de l'allégée |
| V5P | Loyers | + 704621 + 704631 (A26) | absent de l'allégée |
| V5Q | Reprises de provisions | + 704622 + 704632 + 704642 (A26) | absent de l'allégée |
| V5R | Plus-values de cession | + 704623 + 704633 + 704643 (A26) | absent de l'allégée |
| V5S | Autres produits | + 704629 + 704639 + 704649 (A26) | absent de l'allégée |
| V5T | Produits sur opérations de location vente | + 7047 (A26) | absent de l'allégée |
| V5V | Loyers | + 704721 + 704731 (A26) | absent de l'allégée |
| V5W | Reprises de provisions | + 704722 + 704732 + 704742 (A26) | absent de l'allégée |
| V5X | Plus-values de cession | + 704723 + 704733 + 704743 (A26) | absent de l'allégée |
| V5Y | Autres produits | + 704729 + 704739 + 704749 (A26) | absent de l'allégée |
| V6A | PRODUITS SUR OPERATIONS DE CHANGE | +7061+ 7069 (A26) | absent de l'allégée |
| V6B | Gains sur opérations de change | +7061 (A26) | absent de l'allégée |
| V6C | Commissions | +7069 (A26) | absent de l'allégée |
| V6F | PRODUITS SUR OPERATIONS HORS BILAN | +7071 + 7072 + 7073 + 7075 + 7076 (A26) | absent de l'allégée |
| V6K | Produits sur engagements de financement donnés aux institutions financières | +70711 (A26) | absent de l'allégée |
| V6L | Produits sur engagements de financement donnés aux membres, bénéficiaires ou clients | +70713 (A26) | absent de l'allégée |
| V6N | Produits sur engagements de garantie donnés aux institutions financières | +70721 (A26) | absent de l'allégée |
| V6P | Produits sur engagements de garantie donnés aux membres, bénéficiaires ou clients | +70723 (A26) | absent de l'allégée |
| V6Q | Produits sur engagements sur titres | 7073 (A26) | absent de l'allégée |
| V6R | Produits sur autres engagements donnés | 7075 (A26) | absent de l'allégée |
| V6S | Produits sur opérations effectuées pour le compte de tiers | 7076 (A26) | absent de l'allégée |
| V6U | PRODUITS SUR PRESTATIONS DE SERVICES FINANCIERS | 7081 + 7089 (A26) | +708 (153-154) |
| V6V | Produits sur les moyens de paiement | 7081 (A26) | absent de l'allégée |
| V6W | Autres produits sur prestations de services financiers | 7089 (A26) | absent de l'allégée |
| V7A | AUTRES PRODUITS D'EXPLOITATION FINANCIERE | + 7091 + 7098 + 7099 (A27) | +7091 +7098 +7099 (153-154) |
| V7B | Plus - values sur cession d'éléments d'actif | + 7091 (A27) | +7091 (153-154) |
| V7C | Transferts de charges d'exploitation financière | + 7098 (A27) | +7098 (153-154) |
| V7D | Divers produits d'exploitation financière | + 7099 (A27) | +7099 (153-154) |
| V8B | Ventes de marchandises (à confirmer) | + 7111 (A27) | +7111 (153-154) |
| V8C | Vente de marchandises | + 7118 - 7119 (A27) | +7118 −7119 (153-154) |
| W4A | PRODUITS DIVERS D'EXPLOITATION | + 721 + 722 + 725 + 727 + 728 + 729 (A27) | +722 +725 +728 +729 (153-154) |
| W4B | Redevances pour concessions, brevets, licences, droits et valeurs similaires | + 721 (A27) | absent de l'allégée |
| W4D | Indemnités de fonction et rémunération d'administrateurs, gérants reçues | + 722 (A27) | +722 (153-154) |
| W4G | Plus-values de cession | + 7251 + 7252 (A27) | +7251 +7252 (153-154) |
| W4H | sur immobilisations incorporelles et corporelles | + 7251 (A27) | +7251 (153-154) |
| W4J | sur immobilisations financières | + 7252 (A27) | +7252 (153-154) |
| W4L | Transferts de charges d'exploitation non financière | + 7281 + 7282 + 7289 (A27) | +7281 +7282 +7289 (153-154) |
| W4M | Charges refacturées | + 7281 (A27) | +7281 (153-154) |
| W4N | Charges à répartir sur plusieurs exercices | + 7282 (A27) | +7282 (153-154) |
| W4P | Autres transferts de charges | + 7289 (A27) | +7289 (153-154) |
| W4Q | AUTRES PRODUITS DIVERS D'EXPLOITATION | + 729 (A27) | +729 (153-154) |
| W4K | Revenus des immeubles hors exploitation | + 727 (A27) | absent de l'allégée |
| W50 | PRODUCTION IMMOBILISEE | + 731 + 732 (A27) | absent de l'allégée |
| W51 | Immobilisations corporelles | +731 (A27) | absent de l'allégée |
| W52 | Immobilisations incorporelles | +732 (A27) | absent de l'allégée |
| W53 | SUBVENTIONS D'EXPLOITATION | + 74 (A27) | +74 (153-154) |
| X50 | REPRISES DU FONDS POUR RISQUES FINANCIERS GENERAUX | +75 (A27) | +75 (153-154) |
| X51 | REPRISES D'AMORTISSEMENTS ET PROVISIONS SUR IMMOBILISATIONS | + 761 + 763 (A27) | +761 +763 (153-154) |
| X54 | Reprises d'amortissements des immobilisations | + 761 (A27) | +761 (153-154) |
| X56 | Reprises de provisions sur immobilisations | + 763 (A27) | +763 (153-154) |
| X6B | REPRISES DE PROVISIONS ET RECUPERATIONS SUR CREANCES AMORTIES | + 7641 + 7642 +7643+ 766 + 767 + 768 + 769 (A27) | +764 +766 +767 +768 +769 (153-154) |
| X6C | Reprises de provisions sur créances en souffrance | + 7641 + 7642 + 7643 (A27) | +764 (153-154) |
| X6D | Reprises de provisions sur créances en souffrance de 6 mois au plus | + 7641 (A27) | absent de l'allégée |
| X6E | Reprises de provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus | + 7642 (A27) | absent de l'allégée |
| X6F | Reprises de provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus | +7643 (A27) | absent de l'allégée |
| X6G | Reprises de provisions pour dépréciation des autres éléments d'actif | + 766 (A27) | +766 (153-154) |
| X6H | Reprises de provisions pour risques et charges | + 767 (A27) | +767 (153-154) |
| X6I | Reprises de provisions réglementées | + 768 (A27) | +768 (153-154) |
| X6J | Récupération sur créances amorties | + 769 (A27) | +769 (153-154) |
| X80 | PRODUITS EXCEPTIONNELS | + 771 (A27) | +771 (153-154) |
| X81 | PROFITS SUR EXERCICES ANTERIEURS | + 772 (A27) | +772 (153-154) |
| X84 | TOTAL PRODUITS | + 70 + 71 + 72 + 73 + 74 + 75 + 76 + 77 + 59 (A27) | +70 +71 +72 +73 +74 +75 +76 +77 +59 (153-154) |

## (d) Plan de comptes

### d.1 Structure et durées (CT / MT / LT)

- 7 classes de bilan et de gestion + classe 9 hors bilan ; 1er chiffre = classe (d18 p.13-14). Le plan interne d'un SFD ne comporte que les comptes généraux du RCSFD, subdivisables ; une opération sans compte adapté exige l'autorisation de la BCEAO ; les comptes auxiliaires sont libres mais leurs soldes concordent avec le RCSFD (Instr. 026-02-2009 art. 2-6, d20 p.34-35).
- Allégée (d18 p.31-42) : 48 rubriques, 130 comptes, 194 sous-comptes = **372 codes**. Développée (F p.61-98) : **1 440 codes** extraits, dont les 372 de l'allégée (marqués **[A]** ci-dessous). Aucun code de l'allégée n'est absent de la développée.

| Objet | Court terme | Moyen terme | Long terme | Réf. |
|---|---|---|---|---|
| Crédits aux membres (durée **initiale**, différé compris) | 202 : 2022 crédits ordinaires ≤ 12 mois (202211 0-6 mois, 202212 > 6-12 mois) ; 2023 découverts | 203 : > 12 et ≤ 36 mois (20311 > 1-2 ans, 20312 > 2-3 ans) | 204 : > 3 ans (20411 > 3-10 ans, 20412 > 10 ans) — **développée seulement** | d18 p.60 ; F p.71, chap. IV 1.1.3 |
| Prêts aux institutions financières | 131 à moins d'1 an | 133 prêts à terme | (133) | d18 p.31 ; F p.65 |
| Emprunts auprès des institutions financières | 175 à moins d'1 an (F3E) | 178 à terme (F3F) | (178) | F annexe 1.1 A11 |
| Ressources affectées | 181 | 182 | 183 | d18 p.32 ; DIMF 2014 |
| Dépôts à terme reçus des membres (2521x) et dépôts de garantie (2545x) | 0-6 mois, 6-12 mois | 1-2 ans, 2-3 ans | 3-10 ans, > 10 ans | F p.71-72 |
| Dépôts constitués auprès des IF (1261x, 1271x) | 0-6 mois, 6-12 mois | 1-2 ans, 2-3 ans | 3-10 ans, > 10 ans | F p.62-64 |
| Engagements hors bilan | même découpage (LT > 3 ans) | | | F chap. IV 1.5.3 |
| Provisions réglementées | — | 521 « crédits à moyen et long termes » | | d18 p.37, p.87 |

- **[AMBIGU]** Le chap. IV de l'allégée parle de crédits « à court, moyen et long termes » (d18 p.60) mais son plan n'a pas de 204 ; B40 n'existe qu'en développée.
- Ratios II et V : le filtre est la **durée résiduelle** (> 12 mois ; ≤ 3 mois), alors que le plan ventile par **durée initiale** pour les crédits (et par durée pour les dépôts, sans préciser initiale ou résiduelle **[AMBIGU]**). Le calcul des ratios exige donc l'échéancier, pas seulement les soldes des comptes.
- Créances en souffrance (classement par ancienneté de la 1re échéance impayée) : IF 191 immobilisés, 192 ≤ 6 mois (1921 0-3, 1922 > 3-6), 193 > 6-12, 194 > 12-24, provisions 1991-1993 ; membres 291 immobilisés, 292 ≤ 6 mois, 293 > 6-12, 294 > 12-24, provisions 2991-2993 (d18 p.32-34 ; F p.72). Pertes : 669 (allégée) ; 6691 couvertes par des provisions, 6692 non couvertes (développée, F p.90).
- Écarts internes de l'allégée : 20237 cité au chap. IV mais absent du plan allégé ; 512, 6691, 7031, 7712, 1151 cités ailleurs sans compte au plan allégé (d18 p.20-21, 60, 67, 86, 105, 141). La développée contient 20237, 512, 6691, 6692.

### d.2 Plan de comptes complet (version développée, F p.61-98 ; [A] = présent dans l'allégée d18 p.31-42)

Extraction automatique du texte de F : libellés et pages **[NON VÉRIFIÉ À L'IMAGE]**. L'indentation suit la longueur du code.

#### Classe 1 OPERATIONS DE TRESORERIE ET AVEC LES INSTITUTIONS FINANCIERES (p.61)

- 10 VALEURS EN CAISSE (p.61) **[A]**
  - 101 Billets et monnaies (p.61) **[A]**
    - 1011 Billets et monnaies émis par la BCEAO (p.61) **[A]**
    - 1012 Billets et monnaies étrangers (p.61)
- 11 COMPTES ORDINAIRES CHEZ LES INSTITUTIONS FINANCIERES (p.61) **[A]**
  - 110 Banque Centrale (p.61)
    - 1101 Banque Centrale (p.61)
  - 111 Organe Financier/Caisse Centrale (p.61)
    - 1111 Organe Financier/Caisse Centrale (p.61)
      - 11111 Organe Financier (p.61)
        - 111111 Organe Financier (p.61)
        - 111116 Dettes rattachées (p.61)
        - 111117 Créances rattachées (p.61)
      - 11112 Caisse Centrale (p.61)
        - 111121 Caisse Centrale (p.61)
        - 111126 Dettes rattachées (p.61)
        - 111127 Créances rattachées (p.61)
  - 112 Trésor Public (p.61)
    - 1121 Trésor Public (p.61)
  - 113 Centre des Chèques Postaux (p.61) **[A]**
    - 1131 Centre des Chèques Postaux (p.61) **[A]**
    - 1136 Dettes rattachées (p.61) **[A]**
    - 1137 Créances rattachées (p.61) **[A]**
  - 114 Banques et correspondants (p.61) **[A]**
    - 1141 Banques et correspondants (p.61) **[A]**
    - 1146 Dettes rattachées (p.61) **[A]**
    - 1147 Créances rattachées (p.61) **[A]**
  - 115 Etablissements Financiers (p.61)
    - 1151 Etablissements Financiers (p.61)
    - 1156 Dettes rattachées (p.61)
    - 1157 Créances rattachées (p.61)
  - 116 Systèmes Financiers Décentralisés (p.61) **[A]**
    - 1161 Systèmes Financiers Décentralisés (p.61) **[A]**
    - 1166 Dettes rattachées (p.61) **[A]**
    - 1167 Créances rattachées (p.61) **[A]**
  - 117 Autres institutions financières (p.61) **[A]**
    - 1171 Autres institutions financières (p.61) **[A]**
    - 1176 Dettes rattachées (p.61) **[A]**
    - 1177 Créances rattachées (p.61) **[A]**
- 12 AUTRES COMPTES DE DEPOTS CHEZ LES INSTITUTIONS FINANCIERES (p.61) **[A]**
  - 126 Dépôts à terme constitués (p.61) **[A]**
    - 1261 Dépôts à terme constitués (p.61) **[A]**
      - 12611 Dépôts à terme constitués de 0 à 6 mois au plus (p.62)
        - 126111 Dépôts à terme constitués de 0 à 6 mois au plus chez l’organe financier (p.62)
        - 126112 Dépôts à terme constitués de 0 à 6 mois au plus au Trésor public (p.62)
        - 126113 Dépôts à terme constitués de 0 à 6 mois au plus chez les CCP (p.62)
        - 126114 Dépôts à terme constitués de 0 à 6 mois au plus chez les banques et correspondants (p.62)
        - 126115 Dépôts à terme constitués de 0 à 6 mois au plus chez les établissements financiers (p.62)
        - 126116 Dépôts à terme constitués de 0 à 6 mois au plus chez les SFD (p.62)
        - 126117 Dépôts à terme constitués de 0 à 6 mois au plus chez les autres institutions financières (p.62)
      - 12612 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus (p.62)
        - 126121 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez l’organe financier (p.62)
        - 126122 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus au Trésor Public (p.62)
        - 126123 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez les CCP (p.62)
        - 126124 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez les banques et correspondants (p.62)
        - 126125 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez les établissements financiers (p.62)
        - 126126 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez les SFD (p.62)
        - 126127 Dépôts à terme constitués de plus de 6 mois à 12 mois au plus chez les autres institutions financières (p.62)
      - 12613 Dépôts à terme constitués de plus d’1 an à 2 ans au plus (p.62)
        - 126131 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez l’organe Financier (p.62)
        - 126132 Dépôts à terme constitués de plus d’1 an à 2 ans au plus au Trésor Public (p.62)
        - 126133 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez les CCP (p.62)
        - 126134 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez les banques et correspondants (p.62)
        - 126135 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez les établissements financiers (p.62)
        - 126136 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez les SFD (p.62)
        - 126137 Dépôts à terme constitués de plus d’1 an à 2 ans au plus chez les autres institutions financières (p.62)
      - 12614 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus (p.62)
        - 126141 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez l’organe financier (p.62)
        - 126142 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus au Trésor Public (p.62)
        - 126143 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez les CCP (p.62)
        - 126144 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez les banques et correspondants (p.62)
        - 126145 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez les établissements financiers (p.62)
        - 126146 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez les SFD (p.63)
        - 126147 Dépôts à terme constitués de plus de 2 ans à 3 ans au plus chez les autres institutions financières (p.63)
      - 12615 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus (p.63)
        - 126151 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez l’organe financier (p.63)
        - 126152 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus au Trésor Public (p.63)
        - 126153 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez les CCP (p.63)
        - 126154 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez les banques et correspondants (p.63)
        - 126155 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez les établissements financiers (p.63)
        - 126156 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez les SFD (p.63)
        - 126157 Dépôts à terme constitués de plus de 3 ans à 10 ans au plus chez les autres institutions financières (p.63)
      - 12616 Dépôts à terme constitués de plus de 10 ans (p.63)
        - 126161 Dépôts à terme constitués de plus de 10 ans chez l’organe financier (p.63)
        - 126162 Dépôts à terme constitués de plus de 10 ans au Trésor Public (p.63)
        - 126163 Dépôts à terme constitués de plus de 10 ans chez les CCP (p.63)
        - 126164 Dépôts à terme constitués de plus de 10 ans chez les banques et correspondants (p.63)
        - 126165 Dépôts à terme constitués de plus de 10 ans chez les établissements financiers (p.63)
        - 126166 Dépôts à terme constitués de plus de 10 ans chez les SFD (p.63)
        - 126167 Dépôts à terme constitués de plus de 10 ans chez les autres institutions financières (p.63)
    - 1267 Créances rattachées (p.63) **[A]**
  - 127 Dépôts de garantie constitués (p.63) **[A]**
    - 1271 Dépôts de garantie constitués (p.63) **[A]**
      - 12711 Dépôts de garantie constitués de 0 à 6 mois au plus (p.63)
        - 127111 Dépôts de garantie constitués de 0 à 6 mois au plus chez l’organe financier (p.63)
        - 127112 Dépôts de garantie constitués de 0 à 6 mois au plus au Trésor Public (p.63)
        - 127113 Dépôts de garantie constitués de 0 à 6 mois au plus chez les CCP (p.63)
        - 127114 Dépôts de garantie constitués de 0 à 6 mois au plus chez les banques et correspondants (p.63)
        - 127115 Dépôts de garantie constitués de 0 à 6 mois au plus chez les établissements financiers (p.63)
        - 127116 Dépôts de garantie constitués de 0 à 6 mois au plus chez les SFD (p.63)
        - 127117 Dépôts de garantie constitués de 0 à 6 mois au plus chez les autres institutions financières (p.63)
      - 12712 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus (p.63)
        - 127121 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez l’organe financier (p.63)
        - 127122 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus au Trésor Public (p.63)
        - 127123 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez les CCP (p.63)
        - 127124 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez les banques et correspondants (p.64)
        - 127125 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez les établissements financiers (p.64)
        - 127126 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez les SFD (p.64)
        - 127127 Dépôts de garantie constitués de plus de 6 mois à 12 mois au plus chez les autres institutions financières (p.64)
      - 12713 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus (p.64)
        - 127131 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez l’organe financier (p.64)
        - 127132 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus au Trésor Public (p.64)
        - 127133 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez les CCP (p.64)
        - 127134 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez les banques et correspondants (p.64)
        - 127135 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez les établissements financiers (p.64)
        - 127136 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez les SFD (p.64)
        - 127137 Dépôts de garantie constitués de plus d’1 an à 2 ans au plus chez les autres institutions financières (p.64)
      - 12714 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus (p.64)
        - 127141 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez l’organe financier (p.64)
        - 127142 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus au Trésor Public (p.64)
        - 127143 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez les CCP (p.64)
        - 127144 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez les banques et correspondants (p.64)
        - 127145 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez les établissements financiers (p.64)
        - 127146 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez les SFD (p.64)
        - 127147 Dépôts de garantie constitués de plus de 2 ans à 3 ans au plus chez les autres institutions financières (p.64)
      - 12715 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus (p.64)
        - 127151 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez l’organe financier (p.64)
        - 127152 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus au Trésor Public (p.64)
        - 127153 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez les CCP (p.64)
        - 127154 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez les banques et correspondants (p.64)
        - 127155 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez les établissements financiers (p.64)
        - 127156 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez les SFD (p.64)
        - 127157 Dépôts de garantie constitués de plus de 3 ans à 10 ans au plus chez les autres institutions financières (p.65)
      - 12716 Dépôts de garantie constitués de plus de 10 ans (p.65)
        - 127161 Dépôts de garantie constitués de plus de 10 ans chez l’organe financier (p.65)
        - 127162 Dépôts de garantie constitués de plus de 10 ans au Trésor Public (p.65)
        - 127163 Dépôts de garantie constitués de plus de 10 ans chez les CCP (p.65)
        - 127164 Dépôts de garantie constitués de plus de 10 ans chez les banques et correspondants (p.65)
        - 127165 Dépôts de garantie constitués de plus de 10 ans chez les établissements financiers (p.65)
        - 127166 Dépôts de garantie constitués de plus de 10 ans chez les SFD (p.65)
        - 127167 Dépôts de garantie constitués de plus de 10 ans chez les autres institutions financières (p.65)
    - 1277 Créances rattachées (p.65) **[A]**
  - 128 Autres dépôts constitués (p.65) **[A]**
    - 1281 Autres dépôts constitués (p.65) **[A]**
    - 1287 Créances rattachées (p.65) **[A]**
- 13 COMPTES DE PRETS AUX INSTITUTIONS FINANCIERES (p.65) **[A]**
  - 131 Prêts à moins d’1 an (p.65) **[A]**
    - 1311 Prêts à moins d’1 an (p.65) **[A]**
      - 13111 Prêts à moins d’1 an à l’Organe Financier/Caisse Centrale (p.65)
        - 131111 Prêts à moins d’1 an à l’Organe Financier (p.65)
        - 131112 Prêts à moins d’1 an à la Caisse Centrale (p.65)
      - 13112 Prêts à moins d’1 an aux banques et correspondants (p.65)
      - 13113 Prêts à moins d’1 an aux SFD (p.65)
      - 13114 Prêts à moins d’1 an à d’autres institutions financières (p.65)
    - 1317 Créances rattachées (p.65) **[A]**
  - 133 Prêts à terme (p.65) **[A]**
    - 1331 Prêts à terme (p.65) **[A]**
      - 13311 Prêts à terme à l’Organe Financier/Caisse Centrale (p.65)
        - 133111 Prêts à terme à l’Organe Financier (p.65)
        - 133112 Prêts à terme à la Caisse Centrale (p.65)
      - 13312 Prêts à terme aux banques et correspondants (p.65)
      - 13313 Prêts à terme aux SFD (p.65)
      - 13314 Prêts à terme à d’autres institutions financières (p.65)
    - 1337 Créances rattachées (p.65) **[A]**
- 15 COMPTES ORDINAIRES DES INSTITUTIONS FINANCIERES (p.65) **[A]**
  - 151 Organe financier (p.65)
    - 1511 Organe Financier (p.65)
    - 1516 Dettes rattachées (p.65)
    - 1517 Créances rattachées (p.65)
  - 152 Trésor Public (p.65)
    - 1521 Trésor Public (p.65)
    - 1526 Dettes rattachées (p.65)
    - 1527 Créances rattachées (p.65)
  - 153 Centre des Chèques Postaux (p.66)
    - 1531 Centre des Chèques Postaux (p.66)
    - 1536 Dettes rattachées (p.66)
    - 1537 Créances rattachées (p.66)
  - 154 Banques et correspondants (p.66) **[A]**
    - 1541 Banques et correspondants (p.66) **[A]**
    - 1546 Dettes rattachées (p.66) **[A]**
    - 1547 Créances rattachées (p.66) **[A]**
  - 155 Etablissements financiers (p.66)
    - 1551 Etablissements financiers (p.66)
    - 1556 Dettes rattachées (p.66)
    - 1557 Créances rattachées (p.66)
  - 156 Systèmes Financiers Décentralisés (p.66) **[A]**
    - 1561 Systèmes Financiers Décentralisés (p.66) **[A]**
    - 1566 Dettes rattachées (p.66) **[A]**
    - 1567 Créances rattachées (p.66) **[A]**
  - 157 Autres institutions financières (p.66) **[A]**
    - 1571 Autres institutions financières (p.66) **[A]**
    - 1576 Dettes rattachées (p.66) **[A]**
    - 1577 Créances rattachées (p.66) **[A]**
- 16 AUTRES COMPTES DE DEPOTS DES INSTITUTIONS FINANCIERES (p.66) **[A]**
  - 161 Dépôts à terme reçus (p.66) **[A]**
    - 1611 Dépôts à terme reçus (p.66) **[A]**
      - 16111 Dépôts à terme reçus de 0 à 6 mois au plus (p.66)
        - 161111 Dépôts à terme reçus de 0 à 6 mois au plus de l’organe financier (p.66)
        - 161112 Dépôts à terme reçus de 0 à 6 mois au plus du Trésor Public (p.66)
        - 161113 Dépôts à terme reçus de 0 à 6 mois au plus des CCP (p.66)
        - 161114 Dépôts à terme reçus de 0 à 6 mois au plus des banques et correspondants (p.66)
        - 161115 Dépôts à terme reçus de 0 à 6 mois au plus des établissements financiers (p.66)
        - 161116 Dépôts à terme reçus de 0 à 6 mois au plus des SFD (p.66)
        - 161117 Dépôts à terme reçus de 0 à 6 mois au plus des autres institutions financières (p.66)
      - 16112 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus (p.66)
        - 161121 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus de l’organe financier (p.66)
        - 161122 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus du Trésor Public (p.66)
        - 161123 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus des CCP (p.66)
        - 161124 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus des banques et correspondants (p.66)
        - 161125 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus des établissements financiers (p.66)
        - 161126 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus des SFD (p.66)
        - 161127 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus des autres institutions financières (p.66)
      - 16113 Dépôts à terme reçus de plus d’1 an à 2 ans au plus (p.67)
        - 161131 Dépôts à terme reçus de plus d’1 an à 2 ans au plus de l’organe financier (p.67)
        - 161132 Dépôts à terme reçus de plus d’1 an à 2 ans au plus du Trésor Public (p.67)
        - 161133 Dépôts à terme reçus de plus d’1 an à 2 ans au plus des CCP (p.67)
        - 161134 Dépôts à terme reçus de plus d’1 an à 2 ans au plus des banques et correspondants (p.67)
        - 161135 Dépôts à terme reçus de plus d’1 an à 2 ans au plus des établissements financiers (p.67)
        - 161136 Dépôts à terme reçus de plus d’1 an à 2 ans au plus des SFD (p.67)
        - 161137 Dépôts à terme reçus de plus d’1 an à 2 ans au plus des autres institutions financières (p.67)
      - 16114 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus (p.67)
        - 161141 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus de l’organe financier (p.67)
        - 161142 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus du Trésor Public (p.67)
        - 161143 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus des CCP (p.67)
        - 161144 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus des banques et correspondants (p.67)
        - 161145 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus des établissements financiers (p.67)
        - 161146 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus des SFD (p.67)
        - 161147 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus des autres institutions financières (p.67)
      - 16115 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus (p.67)
        - 161151 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus de l’organe financier (p.67)
        - 161152 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus du Trésor Public (p.67)
        - 161153 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus des CCP (p.67)
        - 161154 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus des banques et correspondants (p.67)
        - 161155 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus des établissements financiers (p.67)
        - 161156 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus des SFD (p.67)
        - 161157 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus des autres institutions financières (p.67)
      - 16116 Dépôts à terme reçus de plus de 10 ans (p.67)
        - 161161 Dépôts à terme reçus de plus de 10 ans de l’organe financier (p.67)
        - 161162 Dépôts à terme reçus de plus de 10 ans du Trésor Public (p.67)
        - 161163 Dépôts à terme reçus de plus de 10 ans des CCP (p.67)
        - 161164 Dépôts à terme reçus de plus de 10 ans des banques et correspondants (p.67)
        - 161165 Dépôts à terme reçus de plus de 10 ans des établissements financiers (p.67)
        - 161166 Dépôts à terme reçus de plus de 10 ans des SFD (p.67)
        - 161167 Dépôts à terme reçus de plus de 10 ans des autres institutions financières (p.67)
    - 1616 Dettes rattachées (p.67) **[A]**
  - 162 Dépôts de garantie reçus (p.67) **[A]**
    - 1621 Dépôts de garantie reçus (p.67) **[A]**
      - 16211 Dépôts de garantie reçus de 0 à 6 mois au plus (p.67)
        - 162111 Dépôts de garantie reçus de 0 à 6 mois au plus de l’organe financier (p.68)
        - 162112 Dépôts de garantie reçus de 0 à 6 mois au plus du Trésor Public (p.68)
        - 162113 Dépôts de garantie reçus de 0 à 6 mois au plus des CCP (p.68)
        - 162114 Dépôts de garantie reçus de 0 à 6 mois au plus des banques et correspondants (p.68)
        - 162115 Dépôts de garantie reçus de 0 à 6 mois au plus des établissements financiers (p.68)
        - 162116 Dépôts de garantie reçus de 0 à 6 mois au plus des SFD (p.68)
        - 162117 Dépôts de garantie reçus de 0 à 6 mois au plus des autres institutions financières (p.68)
      - 16212 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus (p.68)
        - 162121 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus de l’organe financier (p.68)
        - 162122 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus du Trésor Public (p.68)
        - 162123 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus des CCP (p.68)
        - 162124 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus des banques et correspondants (p.68)
        - 162125 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus des établissements financiers (p.68)
        - 162126 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus des SFD (p.68)
        - 162127 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus des autres institutions financières (p.68)
      - 16213 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus (p.68)
        - 162131 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus de l’organe financier (p.68)
        - 162132 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus du Trésor Public (p.68)
        - 162133 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus des CCP (p.68)
        - 162134 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus des banques et correspondants (p.68)
        - 162135 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus des établissements financiers (p.68)
        - 162136 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus des SFD (p.68)
        - 162137 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus des autres institutions financières (p.68)
      - 16214 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus (p.68)
        - 162141 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus de l’organe financier (p.68)
        - 162142 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus du Trésor Public (p.68)
        - 162143 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus des CCP (p.68)
        - 162144 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus des banques et correspondants (p.68)
        - 162145 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus des établissements financiers (p.68)
        - 162146 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus des SFD (p.68)
        - 162147 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus des autres institutions financières (p.68)
      - 16215 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus (p.69)
        - 162151 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus de l’organe financier (p.69)
        - 162152 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus du Trésor Public (p.69)
        - 162153 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus des CCP (p.69)
        - 162154 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus des banques et correspondants (p.69)
        - 162155 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus des établissements financiers (p.69)
        - 162156 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus des SFD (p.69)
        - 162157 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus des autres institutions financières (p.69)
      - 16216 Dépôts de garantie reçus de plus de 10 ans (p.69)
        - 162161 Dépôts de garantie reçus de plus de 10 ans de l’organe financier (p.69)
        - 162162 Dépôts de garantie reçus de plus de 10 ans du Trésor Public (p.69)
        - 162163 Dépôts de garantie reçus de plus de 10 ans des CCP (p.69)
        - 162164 Dépôts de garantie reçus de plus de 10 ans des banques et correspondants (p.69)
        - 162165 Dépôts de garantie reçus de plus de 10 ans des établissements financiers (p.69)
        - 162166 Dépôts de garantie reçus de plus de 10 ans des SFD (p.69)
        - 162167 Dépôts de garantie reçus de plus de 10 ans des autres institutions financières (p.69)
    - 1626 Dettes rattachées (p.69) **[A]**
  - 165 Autres dépôts reçus (p.69) **[A]**
    - 1651 Autres dépôts reçus (p.69) **[A]**
    - 1656 Dettes rattachées (p.69) **[A]**
- 17 COMPTES D'EMPRUNTS ET AUTRES SOMMES DUES AUX INSTITUTIONS FINANCIERES (p.69) **[A]**
  - 175 Emprunts à moins d’un an (p.69) **[A]**
    - 1751 Emprunts à moins d’un an (p.69) **[A]**
      - 17511 Emprunts à moins d’un an auprès de l’Organe Financier/Caisse Centrale (p.69)
        - 175111 Emprunts à moins d’un an auprès de l’Organe Financier (p.69)
        - 175112 Emprunts à moins d’un an auprès de la Caisse Centrale (p.69)
      - 17512 Emprunts à moins d’un an auprès des banques et correspondants (p.69)
      - 17513 Emprunts à moins d’un an auprès des SFD (p.69)
      - 17514 Emprunts à moins d’un an auprès d’autres institutions financières (p.69)
    - 1756 Dettes rattachées (p.69) **[A]**
  - 178 Emprunts à terme (p.69) **[A]**
    - 1781 Emprunts à terme (p.69) **[A]**
      - 17811 Emprunts à terme auprès de l’Organe Financier/Caisse Centrale (p.69)
        - 178111 Emprunts à terme auprès de l’Organe Financier (p.69)
        - 178112 Emprunts à terme auprès de la Caisse Centrale (p.69)
      - 17812 Emprunts à terme auprès des banques et correspondants (p.69)
      - 17813 Emprunts à terme auprès des SFD (p.69)
      - 17814 Emprunts à terme auprès d’autres institutions financières (p.69)
    - 1786 Dettes rattachées (p.69) **[A]**
  - 179 Autres sommes dues aux institutions financières (p.69) **[A]**
- 18 RESSOURCES AFFECTEES (p.70) **[A]**
  - 181 Ressources affectées à court terme (p.70) **[A]**
  - 182 Ressources affectées à moyen terme (p.70) **[A]**
  - 183 Ressources affectées à long terme (p.70) **[A]**
  - 184 Intérêts capitalisés (p.70) **[A]**
- 19 COMPTES DE PRETS EN SOUFFRANCE ET IMMOBILISES (p.70) **[A]**
  - 191 Prêts immobilisés (p.70) **[A]**
  - 192 Prêts en souffrance de 6 mois au plus (p.70) **[A]**
    - 1921 Prêts en souffrance de 0 à 3 mois au plus (p.70) **[A]**
    - 1922 Prêts en souffrance de plus de 3 mois à 6 mois au plus (p.70) **[A]**
  - 193 Prêts en souffrance de plus de 6 mois à 12 mois au plus (p.70) **[A]**
  - 194 Prêts en souffrance de plus de 12 mois à 24 mois au plus (p.70) **[A]**
  - 199 Provisions sur prêts en souffrance (p.70) **[A]**
    - 1991 Provisions sur prêts en souffrance de 6 mois au plus (p.70) **[A]**
      - 19911 Provisions sur prêts en souffrance de 0 à 3 mois au plus (p.70)
      - 19912 Provisions sur prêts en souffrance de plus 3 mois à 6 mois au plus (p.70)
    - 1992 Provisions sur prêts en souffrance de plus de 6 mois à 12 mois au plus (p.70) **[A]**
    - 1993 Provisions sur prêts en souffrance de plus de 12 mois à 24 mois au plus (p.70) **[A]**

#### Classe 2 OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS (p.71)

- 20 CREDITS AUX MEMBRES, BENEFICIAIRES OU CLIENTS (p.71) **[A]**
  - 202 Crédits à court terme (p.71) **[A]**
    - 2022 Crédits ordinaires (p.71) **[A]**
      - 20221 Crédits ordinaires (p.71)
        - 202211 Crédits à court terme de 0 à 6 mois au plus (p.71)
        - 202212 Crédits à court terme de plus de 6 mois à 12 mois au plus (p.71)
      - 20227 Créances rattachées (p.71) **[A]**
    - 2023 Découverts (p.71) **[A]**
      - 20231 Découverts (p.71)
      - 20237 Créances rattachées (p.71)
  - 203 Crédits à moyen terme (p.71) **[A]**
    - 2031 Crédits à moyen terme (p.71) **[A]**
      - 20311 Crédits à moyen terme de plus d’1 an à 2 ans au plus (p.71)
      - 20312 Crédits à moyen terme de plus de 2 ans à 3 ans au plus (p.71)
    - 2037 Créances rattachées (p.71) **[A]**
  - 204 Crédits à long terme (p.71)
    - 2041 Crédits à long terme (p.71)
      - 20411 Crédits à long terme de plus de 3 ans à 10 ans au plus (p.71)
      - 20412 Crédits à long terme de plus de 10 ans (p.71)
    - 2047 Créances rattachées (p.71)
- 25 COMPTES DES MEMBRES, BENEFICIAIRES OU CLIENTS (p.71) **[A]**
  - 251 Comptes ordinaires (p.71) **[A]**
    - 2511 Comptes ordinaires (p.71) **[A]**
      - 25111 Comptes ordinaires (p.71)
      - 25116 Dettes rattachées (p.71) **[A]**
      - 25117 Créances rattachées (p.71) **[A]**
    - 2512 Comptes ordinaires sur livret (p.71) **[A]**
      - 25121 Comptes ordinaires (p.71)
      - 25126 Dettes rattachées (p.71) **[A]**
  - 252 Dépôts à terme reçus (p.71) **[A]**
    - 2521 Dépôts à terme reçus (p.71) **[A]**
      - 25211 Dépôts à terme reçus de 0 à 6 mois au plus (p.71)
      - 25212 Dépôts à terme reçus de plus de 6 mois à 12 mois au plus (p.71)
      - 25213 Dépôts à terme reçus de plus d’1 an à 2 ans au plus (p.71)
      - 25214 Dépôts à terme reçus de plus de 2 ans à 3 ans au plus (p.71)
      - 25215 Dépôts à terme reçus de plus de 3 ans à 10 ans au plus (p.71)
      - 25216 Dépôts à terme reçus de plus de 10 ans (p.71)
    - 2526 Dettes rattachées (p.71) **[A]**
  - 253 Comptes d'épargne à régime spécial (p.71) **[A]**
    - 2531 Livrets d'épargne (p.71) **[A]**
      - 25311 Livrets d'épargne (p.71)
      - 25316 Dettes rattachées (p.71) **[A]**
    - 2532 Comptes d'épargne-logement (p.71)
      - 25321 Comptes d'épargne-logement (p.72)
      - 25326 Dettes rattachées (p.72)
    - 2533 Plans d'épargne-logement (p.72)
      - 25331 Plans d'épargne-logement (p.72)
      - 25336 Dettes rattachées (p.72)
    - 2539 Autres comptes d'épargne à régime spécial (p.72)
      - 25391 Autres comptes d'épargne à régime spécial (p.72)
      - 25396 Dettes rattachées (p.72)
  - 254 Dépôts de garantie reçus (p.72) **[A]**
    - 2545 Dépôts de garantie reçus (p.72) **[A]**
      - 25451 Dépôts de garantie reçus de 0 à 6 mois au plus (p.72)
      - 25452 Dépôts de garantie reçus de plus de 6 mois à 12 mois au plus (p.72)
      - 25453 Dépôts de garantie reçus de plus d’1 an à 2 ans au plus (p.72)
      - 25454 Dépôts de garantie reçus de plus de 2 ans à 3 ans au plus (p.72)
      - 25455 Dépôts de garantie reçus de plus de 3 ans à 10 ans au plus (p.72)
      - 25456 Dépôts de garantie reçus de plus de 10 ans (p.72)
    - 2546 Dettes rattachées (p.72) **[A]**
  - 255 Autres dépôts reçus (p.72) **[A]**
    - 2551 Autres dépôts reçus (p.72) **[A]**
    - 2556 Dettes rattachées (p.72) **[A]**
- 27 EMPRUNTS ET AUTRES SOMMES DUES AUX MEMBRES, CLIENTS OU BENEFICIAIRES (p.72) **[A]**
  - 271 Emprunts aux membres, clients ou bénéficiaires (p.72) **[A]**
    - 2711 Emprunts (p.72) **[A]**
      - 27111 Emprunts à moins d’un an (p.72)
      - 27112 Emprunts à terme (p.72)
    - 2716 Dettes rattachées (p.72) **[A]**
  - 272 Autres sommes dues aux membres, clients ou bénéficiaires (p.72) **[A]**
    - 2721 Dispositions à payer (p.72) **[A]**
    - 2722 Provisions pour chèques certifiés (p.72) **[A]**
    - 2725 Divers (p.72) **[A]**
    - 2726 Dettes rattachées (p.72) **[A]**
- 29 COMPTES DE CREDITS EN SOUFFRANCE (p.72) **[A]**
  - 291 Crédits immobilisés (p.72) **[A]**
  - 292 Crédits en souffrance de 6 mois au plus (p.72) **[A]**
    - 2921 Crédits en souffrance de 0 à 3 mois au plus (p.72)
    - 2922 Crédits en souffrance de plus de 3 mois à 6 mois au plus (p.72)
  - 293 Crédits en souffrance de plus de 6 mois à 12 mois au plus (p.72) **[A]**
  - 294 Crédits en souffrance de plus de 12 mois à 24 mois au plus (p.72) **[A]**
  - 299 Provisions sur crédits en souffrance (p.72) **[A]**
    - 2991 Provisions sur crédits en souffrance de 6 mois au plus (p.72) **[A]**
      - 29911 Provisions sur crédits en souffrance de 0 à 3 mois au plus (p.72)
      - 29912 Provisions sur crédits en souffrance de plus de 3 mois à 6 mois au plus (p.72)
    - 2992 Provisions sur crédits en souffrance de plus de 6 mois à 12 mois au plus (p.72) **[A]**
    - 2993 Provisions sur crédits en souffrance de plus de 12 mois à 24 mois au plus (p.72) **[A]**

#### Classe 3 OPERATIONS SUR TITRES ET OPERATIONS DIVERSES (p.73)

- 30 TITRES DE PLACEMENT (p.73) **[A]**
  - 301 Obligations (p.73)
  - 302 Autres titres à revenu fixe (p.73)
  - 303 Actions (p.73)
  - 304 Autres titres à revenu variable (p.73)
  - 305 Versements restant à effectuer (p.73) **[A]**
  - 307 Créances rattachées (p.73) **[A]**
  - 309 Provisions pour dépréciation (p.73) **[A]**
- 32 COMPTES DE STOCKS ET EMPLOIS DIVERS (p.73) **[A]**
  - 321 Stocks de biens meubles (p.73) **[A]**
    - 3211 Stocks de biens meubles (p.73) **[A]**
    - 3219 Provisions pour dépréciation (p.73) **[A]**
  - 322 Stocks de marchandises (p.73) **[A]**
    - 3221 Stocks de marchandises (p.73) **[A]**
    - 3229 Provisions pour dépréciation (p.73) **[A]**
  - 323 Stocks de fournitures (p.73) **[A]**
    - 3231 Stocks de fournitures (p.73) **[A]**
    - 3239 Provisions pour dépréciation (p.73) **[A]**
  - 324 Autres stocks et assimilés (p.73)
    - 3241 Autres stocks et assimilés (p.73)
    - 3249 Provisions pour dépréciation (p.73)
- 33 DEBITEURS ET CREDITEURS DIVERS (p.73) **[A]**
  - 331 Débiteurs divers (p.73) **[A]**
    - 3311 Fournisseurs débiteurs (p.73)
    - 3312 Personnel, avances et acomptes (p.73)
    - 3313 Organismes sociaux, créances diverses (p.73)
    - 3314 Etat, créances diverses (p.73)
      - 33141 Avances et acomptes versés sur impôts et taxes directs (p.73)
      - 33142 Avances et acomptes versés sur impôts et taxes indirects (p.73)
      - 33143 Autres créances diverses (p.73)
    - 3315 Organismes internationaux, créances diverses (p.73)
    - 3316 Autres débiteurs divers (p.73)
    - 3319 Autres créances en souffrance (p.73) **[A]**
      - 33191 Autres créances en souffrance (p.73)
      - 33199 Provisions pour dépréciation (p.73)
  - 332 Créditeurs divers (p.73) **[A]**
    - 3321 Fournisseurs (p.73)
      - 33211 Fournisseurs d’exploitation (p.73)
      - 33212 Fournisseurs d’investissement (p.73)
      - 33213 Fournisseurs – factures non parvenues (p.73)
      - 33214 Fournisseurs – Avances et acomptes versés (p.73)
    - 3322 Personnel (p.73)
    - 3323 Organismes sociaux (p.73)
    - 3324 Etat et collectivités publiques (p.74)
      - 33241 Impôts et taxes directs (p.74)
      - 33242 Impôts et taxes indirects (p.74)
      - 33243 Autres impôts et taxes (p.74)
    - 3325 Organismes internationaux (p.74)
    - 3326 Dividendes à payer (p.74)
    - 3327 Autres créditeurs divers (p.74)
- 37 COMPTES TRANSITOIRES ET D'ATTENTE (p.74) **[A]**
  - 371 Comptes d'encaissement (p.74)
    - 3711 Valeurs à l'encaissement avec crédit immédiat (p.74)
      - 37111 reçues des membres, bénéficiaires ou clients (p.74)
      - 37112 reçues des correspondants (p.74)
    - 3712 Comptes de valeurs à imputer (p.74)
    - 3713 Valeurs à rejeter (p.74)
  - 372 Comptes de recouvrement (p.74)
  - 373 Comptes de contrepartie des comptes de recouvrement (p.74)
  - 374 Comptes de différences de conversion (p.74)
    - 3741 Comptes d'ajustement (p.74)
      - 37411 Comptes d'ajustement devises (p.74)
    - 3742 Comptes d'écarts-actif (p.74)
      - 37421 Comptes d'écarts sur devises garantis (p.74)
      - 37429 Autres comptes d'écarts sur devises (p.74)
    - 3743 Comptes d'écarts-passif (p.74)
      - 37431 Comptes d'écarts sur devises garantis (p.74)
      - 37439 Autres comptes d'écarts sur devises (p.74)
  - 375 Comptes de réévaluation des opérations de change (p.74)
    - 3757 Comptes de position de change (p.74)
    - 3758 Comptes de contre-valeur de position de change (p.74)
  - 376 Comptes d'opérations sur crédits consortiaux (p.74)
    - 3761 Comptes d'appels de fonds sur crédits consortiaux (p.74)
    - 3762 Comptes de contrepartie de comptes d'appels de fonds sur crédits consortiaux (p.74)
  - 378 Autres comptes transitoires (p.74) **[A]**
  - 379 Comptes d'attente (p.74) **[A]**
    - 3791 Comptes d'attente - actif (p.74) **[A]**
    - 3792 Comptes d'attente - passif (p.74) **[A]**
- 38 COMPTES DE REGULARISATION (p.74) **[A]**
  - 381 Comptes de régularisation - actif (p.74) **[A]**
    - 3811 Charges à répartir sur plusieurs exercices (p.74) **[A]**
    - 3812 Charges constatées d'avance (p.74) **[A]**
    - 3814 Comptes d'abonnement de produits (p.74) **[A]**
    - 3815 Produits à recevoir (p.74) **[A]**
  - 382 Comptes de régularisation - passif (p.74) **[A]**
    - 3822 Produits constatés d'avance (p.74) **[A]**
    - 3824 Comptes d'abonnement de charges (p.74) **[A]**
    - 3825 Charges à payer (p.74) **[A]**
- 39 COMPTES DE LIAISON (p.74)

#### Classe 4 VALEURS IMMOBILISEES (p.75)

- 41 IMMOBILISATIONS FINANCIERES (p.75) **[A]**
  - 410 Prêts et titres subordonnés (p.75)
    - 4101 Prêts et titres subordonnés à terme (p.75)
      - 41012 Prêts subordonnés à terme (p.75)
      - 41014 Titres subordonnés à terme (p.75)
    - 4102 Prêts et titres subordonnés à durée indéterminée (p.75)
      - 41022 Prêts subordonnés à durée indéterminée (p.75)
      - 41024 Titres subordonnés à durée indéterminée (p.75)
    - 4107 Créances rattachées (p.75)
  - 412 Titres de participation (p.75) **[A]**
    - 4121 Titres de participation des banques et correspondants et des établissements financiers (p.75)
    - 4122 Titres de participation de SFD (p.75)
    - 4123 Titres de participation d'autres entreprises à caractère financier (p.75)
    - 4124 Titres de participation de sociétés immobilières (p.75)
      - 41241 Titres de participation de sociétés immobilières d'exploitation (p.75)
      - 41242 Titres de participation de sociétés immobilières hors exploitation (p.75)
    - 4125 Titres de participation d'autres entreprises à caractère non financier (p.75)
    - 4126 Versements restant à effectuer (p.75) **[A]**
    - 4127 Créances rattachées (p.75) **[A]**
    - 4129 Provisions pour dépréciation (p.75) **[A]**
  - 414 Titres d'investissement (p.75)
    - 4141 Obligations (p.75)
    - 4142 Autres titres à revenu fixe (p.75)
    - 4147 Créances rattachées (p.75)
    - 4149 Provisions pour dépréciation (p.75)
- 42 DEPOTS ET CAUTIONNEMENTS (p.75) **[A]**
  - 421 Cautions sur loyers (p.75) **[A]**
  - 422 Dépôts pour l’électricité (p.75)
  - 423 Dépôts pour l’eau (p.75)
  - 424 Dépôts pour le gaz (p.75)
  - 425 Dépôts pour le téléphone, le télex, la télécopie (p.75)
  - 426 Cautionnements sur marchés publics (p.75)
  - 427 Créances rattachées (p.75) **[A]**
  - 428 Autres dépôts et cautionnements sur autres opérations (p.75)
  - 429 Provisions pour dépréciation des dépôts et cautionnements (p.75) **[A]**
- 43 IMMOBILISATIONS EN COURS (p.75) **[A]**
  - 431 Immobilisations incorporelles en cours (p.75) **[A]**
    - 4311 Immobilisations incorporelles en cours (p.75) **[A]**
    - 4319 Provisions pour dépréciation (p.75) **[A]**
  - 432 Immobilisations corporelles en cours (p.75) **[A]**
    - 4321 Immobilisations corporelles en cours (p.75) **[A]**
      - 43211 Aménagements de terrain en cours (p.75)
      - 43212 Bâtiments et installations en cours (p.76)
      - 43213 Matériels en cours (p.76)
        - 432131 Matériel et outillage industriel et commercial en cours (p.76)
        - 432132 Matériel et outillage agricole en cours (p.76)
        - 432133 Matériel d’emballage récupérable et identifiable en cours (p.76)
        - 432134 Matériel et mobilier de bureau en cours (p.76)
        - 432135 Matériel de transport en cours (p.76)
        - 432136 Immobilisations animales et agricoles en cours (p.76)
        - 432137 Agencements et aménagements du matériel en cours (p.76)
        - 432138 Autres matériels en cours (p.76)
    - 4329 Provisions pour dépréciation (p.76) **[A]**
      - 43291 Provisions pour dépréciation des immobilisations corporelles en cours (p.76)
        - 432911 Provisions pour dépréciation des aménagements de terrains en cours (p.76)
        - 432912 Provisions pour dépréciation des bâtiments et installations en cours (p.76)
        - 432913 Provisions pour dépréciation de matériels en cours (p.76)
- 44 IMMOBILISATIONS D'EXPLOITATION (p.76) **[A]**
  - 441 Immobilisations incorporelles (p.76) **[A]**
    - 4411 Fonds commercial (p.76)
      - 44111 Droit au bail (p.76)
      - 44112 Autres éléments du fonds commercial (p.76)
    - 4412 Frais d'établissement (p.76)
      - 44121 Frais de constitution (p.76)
      - 44122 Frais de modification du capital (p.76)
      - 44123 Frais de fonctionnement antérieurs au démarrage (p.76)
      - 44124 Frais divers d’établissement (p.76)
    - 4413 Autres immobilisations incorporelles (p.76)
    - 4418 Amortissements (p.76) **[A]**
    - 4419 Provisions pour dépréciation (p.76) **[A]**
  - 442 Immobilisations corporelles (p.76) **[A]**
    - 4421 Immobilisations corporelles (p.76)
      - 44211 Terrains (p.76)
        - 442111 Terrains agricoles et forestiers (p.76)
        - 442112 Terrains nus (p.76)
        - 442113 Terrains bâtis (p.76)
        - 442114 Travaux de mise en valeur des terrains (p.76)
        - 442115 Terrains de gisement (p.76)
        - 442116 Terrains aménagés (p.76)
        - 442117 Terrains mis en concession (p.76)
        - 442118 Autres terrains (p.76)
      - 44212 Bâtiments, installations techniques et agencements (p.76)
        - 442121 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.76)
        - 442122 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.76)
        - 442123 Ouvrages d’infrastructure (p.76)
        - 442124 Installations techniques (p.76)
        - 442125 Aménagements de bureaux (p.76)
        - 442126 Bâtiments industriels, agricoles et commerciaux mis en concession (p.76)
        - 442127 Autres installations et agencements (p.76)
      - 44213 Matériel (p.77)
        - 442131 Matériel et outillage industriel et commercial (p.77)
        - 442132 Matériel et outillage agricole (p.77)
        - 442133 Matériel d’emballage récupérable et identifiable (p.77)
        - 442134 Matériel et mobilier de bureau (p.77)
        - 442135 Matériel de transport (p.77)
        - 442136 Immobilisations animales et agricoles (p.77)
        - 442137 Agencements et aménagements du matériel (p.77)
        - 442138 Autres matériels (p.77)
    - 4428 Amortissements (p.77) **[A]**
      - 44281 Amortissements des terrains (p.77)
        - 442811 Amortissements des terrains agricoles et forestiers (p.77)
        - 442814 Amortissements des travaux de mise en valeur des terrains (p.77)
        - 442815 Amortissements des terrains de gisement (p.77)
      - 44282 Amortissements des bâtiments, installations techniques et agencements (p.77)
        - 442821 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.77)
        - 442822 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.77)
        - 442823 Amortissements des ouvrages d’infrastructure (p.77)
        - 442824 Amortissements des installations techniques (p.77)
        - 442825 Amortissements des aménagements de bureaux (p.77)
        - 442826 Amortissements des bâtiments industriels, agricoles et commerciaux mis en concession (p.77)
        - 442827 Amortissements des autres installations et agencements (p.77)
      - 44283 Amortissements des matériels (p.77)
        - 442831 Amortissements du matériel et outillage industriel et commercial (p.77)
        - 442832 Amortissements du matériel et outillage agricole (p.77)
        - 442833 Amortissements du matériel d’emballage récupérable et identifiable (p.77)
        - 442834 Amortissements du matériel et mobilier de bureau (p.77)
        - 442835 Amortissements du matériel de transport (p.77)
        - 442836 Amortissements des immobilisations animales et agricoles (p.77)
        - 442837 Amortissements des agencements et aménagements du matériel (p.77)
        - 442838 Amortissements des autres matériels (p.77)
    - 4429 Provisions pour dépréciation (p.77) **[A]**
      - 44291 Provisions des terrains (p.77)
        - 442911 Provisions des terrains agricoles et forestiers (p.77)
        - 442912 Provisions des terrains nus (p.77)
        - 442913 Provisions des terrains bâtis (p.77)
        - 442914 Provisions des travaux de mise en valeur des terrains (p.77)
        - 442915 Provisions des terrains de gisement (p.77)
        - 442916 Provisions des terrains aménagés (p.77)
        - 442917 Provisions des terrains mis en concession (p.77)
        - 442918 Provisions des autres terrains (p.77)
      - 44292 Provisions des bâtiments, installations techniques et agencements (p.77)
        - 442921 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.77)
        - 442922 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.78)
        - 442923 Provisions des ouvrages d’infrastructure (p.78)
        - 442924 Provisions des installations techniques (p.78)
        - 442925 Provisions des aménagements de bureaux (p.78)
        - 442926 Provisions des bâtiments industriels, agricoles et commerciaux mis en concession (p.78)
        - 442927 Provisions des autres installations et agencements (p.78)
      - 44293 Provisions des matériels (p.78)
        - 442931 Provisions du matériel et outillage industriel et commercial (p.78)
        - 442932 Provisions du matériel et outillage agricole (p.78)
        - 442933 Provisions du matériel d’emballage récupérable et identifiable (p.78)
        - 442934 Provisions du matériel et mobilier de bureau (p.78)
        - 442935 Provisions du matériel de transport (p.78)
        - 442936 Provisions des immobilisations animales et agricoles (p.78)
        - 442937 Provisions des agencements et aménagements du matériel (p.78)
        - 442938 Provisions des autres matériels (p.78)
- 45 IMMOBILISATIONS HORS EXPLOITATION (p.78)
  - 451 Immobilisations incorporelles (p.78)
    - 4511 Fonds commercial (p.78)
      - 45111 Droit au bail (p.78)
      - 45112 Autres éléments du fonds commercial (p.78)
    - 4513 Autres immobilisations incorporelles (p.78)
    - 4518 Amortissements (p.78)
    - 4519 Provisions pour dépréciation (p.78)
  - 452 Immobilisations corporelles (p.78)
    - 4521 Immobilisations corporelles (p.78)
      - 45211 Terrains (p.78)
        - 452111 Terrains agricoles et forestiers (p.78)
        - 452112 Terrains nus (p.78)
        - 452113 Terrains bâtis (p.78)
        - 452114 Travaux de mise en valeur des terrains (p.78)
        - 452115 Terrains de gisement (p.78)
        - 452116 Terrains aménagés (p.78)
        - 452117 Terrains mis en concession (p.78)
        - 452118 Autres terrains (p.78)
      - 45212 Bâtiments, installations techniques et agencements (p.78)
        - 452121 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.78)
        - 452122 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.78)
        - 452123 Ouvrages d’infrastructure (p.78)
        - 452124 Installations techniques (p.78)
        - 452125 Aménagements de bureaux (p.78)
        - 452126 Bâtiments industriels, agricoles et commerciaux mis en concession (p.78)
        - 452127 Autres installations et agencements (p.78)
      - 45213 Matériel (p.78)
        - 452131 Matériel et outillage industriel et commercial (p.78)
        - 452132 Matériel et outillage agricole (p.78)
        - 452133 Matériel d’emballage récupérable et identifiable (p.79)
        - 452134 Matériel et mobilier de bureau (p.79)
        - 452135 Matériel de transport (p.79)
        - 452136 Immobilisations animales et agricoles (p.79)
        - 452137 Agencements et aménagements du matériel (p.79)
        - 452138 Autres matériels (p.79)
    - 4528 Amortissements (p.79)
      - 45281 Amortissements des terrains (p.79)
        - 452811 Amortissements des terrains agricoles et forestiers (p.79)
        - 452814 Amortissements des travaux de mise en valeur des terrains (p.79)
        - 452815 Amortissements des terrains de gisement (p.79)
      - 45282 Amortissements des bâtiments, installations techniques et agencements (p.79)
        - 452821 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.79)
        - 452822 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.79)
        - 452823 Amortissements des ouvrages d’infrastructure (p.79)
        - 452824 Amortissements des installations techniques (p.79)
        - 452825 Amortissements des aménagements de bureaux (p.79)
        - 452826 Amortissements des bâtiments industriels, agricoles et commerciaux mis en concession (p.79)
        - 452827 Amortissements des autres installations et agencements (p.79)
      - 45283 Amortissements des matériels (p.79)
        - 452831 Amortissements du matériel et outillage industriel et commercial (p.79)
        - 452832 Amortissements du matériel et outillage agricole (p.79)
        - 452833 Amortissements du matériel d’emballage récupérable et identifiable (p.79)
        - 452834 Amortissements du matériel et mobilier de bureau (p.79)
        - 452835 Amortissements du matériel de transport (p.79)
        - 452836 Amortissements des immobilisations animales et agricoles (p.79)
        - 452837 Amortissements des agencements et aménagements du matériel (p.79)
        - 452838 Amortissements des autres matériels (p.79)
    - 4529 Provisions pour dépréciation (p.79)
      - 45291 Provisions des terrains (p.79)
        - 452911 Provisions des terrains agricoles et forestiers (p.79)
        - 452912 Provisions des terrains nus (p.79)
        - 452913 Provisions des terrains bâtis (p.79)
        - 452914 Provisions des travaux de mise en valeur des terrains (p.79)
        - 452915 Provisions des terrains de gisement (p.79)
        - 452916 Provisions des terrains aménagés (p.79)
        - 452917 Provisions des terrains mis en concession (p.79)
        - 452918 Provisions des autres terrains (p.79)
      - 45292 Provisions des bâtiments, installations techniques et agencements (p.79)
        - 452921 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.79)
        - 452922 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.79)
        - 452923 Provisions des ouvrages d’infrastructure (p.79)
        - 452924 Provisions des installations techniques (p.79)
        - 452925 Provisions des aménagements de bureaux (p.80)
        - 452926 Provisions des bâtiments industriels, agricoles et commerciaux mis en concession (p.80)
        - 452927 Provisions des autres installations et agencements (p.80)
      - 45293 Provisions des matériels (p.80)
        - 452931 Provisions du matériel et outillage industriel et commercial (p.80)
        - 452932 Provisions du matériel et outillage agricole (p.80)
        - 452933 Provisions du matériel d’emballage récupérable et identifiable (p.80)
        - 452934 Provisions du matériel et mobilier de bureau (p.80)
        - 452935 Provisions du matériel de transport (p.80)
        - 452936 Provisions des immobilisations animales et agricoles (p.80)
        - 452937 Provisions des agencements et aménagements du matériel (p.80)
        - 452938 Provisions des autres matériels (p.80)
  - 453 Immobilisations incorporelles acquises par réalisation de garantie (p.80)
    - 4531 Immobilisations incorporelles acquises par réalisation de garantie (p.80)
    - 4538 Amortissements (p.80)
    - 4539 Provisions pour dépréciation (p.80)
  - 454 Immobilisations corporelles acquises par réalisation de garantie (p.80)
    - 4541 Immobilisations corporelles acquises par réalisation de garantie (p.80)
      - 45411 Terrains (p.80)
        - 454111 Terrains agricoles et forestiers (p.80)
        - 454112 Terrains nus (p.80)
        - 454113 Terrains bâtis (p.80)
        - 454114 Travaux de mise en valeur des terrains (p.80)
        - 454115 Terrains de gisement (p.80)
        - 454116 Terrains aménagés (p.80)
        - 454117 Terrains mis en concession (p.80)
        - 454118 Autres terrains (p.80)
      - 45412 Bâtiments, installations techniques et agencements (p.80)
        - 454121 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.80)
        - 454122 Bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.80)
        - 454123 Ouvrages d’infrastructure (p.80)
        - 454124 Installations techniques (p.80)
        - 454125 Aménagements de bureaux (p.80)
        - 454126 Bâtiments industriels, agricoles et commerciaux mis en concession (p.80)
        - 454127 Autres installations et agencements (p.80)
      - 45413 Matériel (p.80)
        - 454131 Matériel et outillage industriel et commercial (p.80)
        - 454132 Matériel et outillage agricole (p.80)
        - 454133 Matériel d’emballage récupérable et identifiable (p.80)
        - 454134 Matériel et mobilier de bureau (p.80)
        - 454135 Matériel de transport (p.80)
        - 454136 Immobilisations animales et agricoles (p.80)
        - 454137 Agencements et aménagements du matériel (p.80)
        - 454138 Autres matériels (p.80)
    - 4548 Amortissements (p.80)
      - 45481 Amortissements des terrains (p.80)
        - 454811 Amortissements des terrains agricoles et forestiers (p.80)
        - 454814 Amortissements des travaux de mise en valeur des terrains (p.81)
        - 454815 Amortissements des terrains de gisement (p.81)
      - 45482 Amortissements des bâtiments, installations techniques et agencements (p.81)
        - 454821 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.81)
        - 454822 Amortissements des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.81)
        - 454823 Amortissements des ouvrages d’infrastructure (p.81)
        - 454824 Amortissements des installations techniques (p.81)
        - 454825 Amortissements des aménagements de bureaux (p.81)
        - 454826 Amortissements des bâtiments industriels, agricoles et commerciaux mis en concession (p.81)
        - 454827 Amortissements des autres installations et agencements (p.81)
      - 45483 Amortissements des matériels (p.81)
        - 454831 Amortissements du matériel et outillage industriel et commercial (p.81)
        - 454832 Amortissements du matériel et outillage agricole (p.81)
        - 454833 Amortissements du matériel d’emballage récupérable et identifiable (p.81)
        - 454834 Amortissements du matériel et mobilier de bureau (p.81)
        - 454835 Amortissements du matériel de transport (p.81)
        - 454836 Amortissements des immobilisations animales et agricoles (p.81)
        - 454837 Amortissements des agencements et aménagements du matériel (p.81)
        - 454838 Amortissements des autres matériels (p.81)
    - 4549 Provisions pour dépréciation (p.81)
      - 45491 Provisions des terrains (p.81)
        - 454911 Provisions des terrains agricoles et forestiers (p.81)
        - 454912 Provisions des terrains nus (p.81)
        - 454913 Provisions des terrains bâtis (p.81)
        - 454914 Provisions des travaux de mise en valeur des terrains (p.81)
        - 454915 Provisions des terrains de gisement (p.81)
        - 454916 Provisions des terrains aménagés (p.81)
        - 454917 Provisions des terrains mis en concession (p.81)
        - 454918 Provisions des autres terrains (p.81)
      - 45492 Provisions des bâtiments, installations techniques et agencements (p.81)
        - 454921 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol propre (p.81)
        - 454922 Provisions des bâtiments industriels, agricoles, administratifs et commerciaux sur sol d’autrui (p.81)
        - 454923 Provisions des ouvrages d’infrastructure (p.81)
        - 454924 Provisions des installations techniques (p.81)
        - 454925 Provisions des aménagements de bureaux (p.81)
        - 454926 Provisions des bâtiments industriels, agricoles et commerciaux mis en concession (p.81)
        - 454927 Provisions des autres installations et agencements (p.81)
      - 45493 Provisions des matériels (p.81)
        - 454931 Provisions du matériel et outillage industriel et commercial (p.81)
        - 454932 Provisions du matériel et outillage agricole (p.81)
        - 454933 Provisions du matériel d’emballage récupérable et identifiable (p.81)
        - 454934 Provisions du matériel et mobilier de bureau (p.81)
        - 454935 Provisions du matériel de transport (p.82)
        - 454936 Provisions des immobilisations animales et agricoles (p.82)
        - 454937 Provisions des agencements et aménagements du matériel (p.82)
        - 454938 Provisions des autres matériels (p.82)
- 46 OPERATIONS DE CREDIT-BAIL ET DE LOCATION AVEC OPTION D'ACHAT (p.82)
  - 461 Crédit-bail (p.82)
    - 4611 Immobilisations en cours (p.82)
    - 4612 Crédit-bail mobilier (p.82)
    - 4613 Crédit-bail immobilier (p.82)
    - 4614 Crédit-bail sur actifs incorporels (p.82)
  - 462 Location avec option d'achat (p.82)
    - 4621 Immobilisations en cours (p.82)
    - 4622 Location avec option d'achat mobilier (p.82)
  - 463 Immobilisations en location simple (p.82)
  - 464 Immobilisations non louées (p.82)
  - 467 Créances rattachées (p.82)
  - 468 Amortissements des immobilisations en crédit-bail et en location avec option d’achat (p.82)
  - 469 Provisions pour dépréciation des immobilisations en crédit-bail et en location avec option d’achat (p.82)
- 47 OPERATIONS DE LOCATION-VENTE (p.82)
  - 471 Immobilisations en cours (p.82)
  - 472 Location-vente (p.82)
  - 473 Immobilisations en location simple (p.82)
  - 474 Immobilisations non louées (p.82)
  - 477 Créances rattachées (p.82)
  - 478 Amortissements des immobilisations en location-vente (p.82)
  - 479 Provisions pour dépréciation des immobilisations en location-vente (p.82)
- 49 COMPTES DE CREANCES EN SOUFFRANCE (p.82)
  - 491 Créances en souffrance de 6 mois au plus (p.82)
    - 4916 Créances en souffrance de 6 mois au plus sur opérations de crédit-bail et de location avec option d'achat (p.82)
      - 49161 Créances en souffrance de 6 mois au plus sur opérations de crédit-bail (p.82)
        - 491611 Créances en souffrance de 0 à 3 mois au plus sur opérations de crédit-bail (p.82)
        - 491612 Créances en souffrance de plus de 3 mois à 6 mois au plus sur opérations de crédit-bail (p.82)
      - 49162 Créances en souffrance de 6 mois au plus sur opérations de location avec option d'achat (p.82)
        - 491621 Créances en souffrance de 0 à 3 mois au plus sur opérations de location avec option d'achat (p.82)
        - 491622 Créances en souffrance de plus de 3 mois à 6 mois au plus sur opérations de location avec option d'achat (p.82)
    - 4917 Créances en souffrance de 6 mois au plus sur opérations de location-vente (p.82)
        - 491711 Créances en souffrance de 0 à 3 mois au plus sur opérations de location-vente (p.82)
        - 491712 Créances en souffrance de plus de 3 mois à 6 mois au plus sur opérations de location-vente (p.82)
  - 492 Créances en souffrance de plus de 6 mois à 12 mois au plus (p.83)
    - 4926 Créances en souffrance de plus de 6 mois à 12 mois au plus sur opérations de crédit-bail et de location avec option d'achat (p.83)
      - 49261 Créances en souffrance de plus de 6 mois à 12 mois au plus sur opérations de crédit-bail (p.83)
      - 49262 Créances en souffrance de plus de 6 mois à 12 mois au plus sur opérations de location avec option d'achat (p.83)
    - 4927 Créances en souffrance de plus de 6 mois à 12 mois au plus sur opérations de location-vente (p.83)
  - 493 Créances en souffrance de plus de 12 mois à 24 mois au plus (p.83)
    - 4936 Créances en souffrance de plus de 12 mois à 24 mois au plus sur opérations de crédit-bail et de location avec option d'achat (p.83)
      - 49361 Créances en souffrance de plus de 12 mois à 24 mois au plus sur opérations de crédit-bail (p.83)
      - 49362 Créances en souffrance de plus de 12 mois à 24 mois au plus sur opérations de location avec option d'achat (p.83)
    - 4937 Créances en souffrance de plus de 12 mois à 24 mois au plus sur opérations de location-vente (p.83)
  - 499 Provisions sur créances en souffrance (p.83)
    - 4996 Provisions sur créances en souffrance sur opérations de crédit-bail et de location avec option d'achat (p.83)
      - 49961 Provisions sur créances en souffrance de 6 mois au plus (p.83)
        - 499611 Provisions sur créances en souffrance de 0 à 3 mois au plus (p.83)
        - 499612 Provisions sur créances en souffrance de plus de 3 mois à 6 mois au plus (p.83)
      - 49962 Provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus (p.83)
      - 49963 Provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus (p.83)
    - 4997 Provisions sur créances en souffrance sur opérations de location-vente (p.83)
      - 49971 Provisions sur créances en souffrance de 6 mois au plus (p.83)
        - 499711 Provisions sur créances en souffrance de 0 à 3 mois au plus (p.83)
        - 499712 Provisions sur créances en souffrance de plus de 3 mois à 6 mois au plus (p.83)
      - 49972 Provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus (p.83)
      - 49973 Provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus (p.83)

#### Classe 5 PROVISIONS, FONDS PROPRES ET ASSIMILES (p.84)

- 50 SUBVENTIONS ET AUTRES FONDS RECUS (p.84) **[A]**
  - 501 Subventions d'investissement (p.84) **[A]**
    - 5011 Subventions d'investissement (p.84) **[A]**
      - 50111 Subventions d'investissement reçues de l’Etat (p.84)
      - 50112 Subventions d'investissement reçues d’Organismes internationaux (p.84)
      - 50113 Autres subventions d'investissement (p.84)
    - 5012 Subventions d'investissement virées au compte de résultat (p.84) **[A]**
  - 502 Fonds affectés (p.84) **[A]**
    - 5021 Fonds de garantie (p.84)
    - 5022 Fonds d'assurance (p.84)
    - 5023 Fonds de bonification (p.84)
    - 5024 Fonds de sécurité (p.84)
    - 5029 Autres fonds affectés (p.84)
  - 503 Fonds de crédit (p.84) **[A]**
- 51 PROVISIONS POUR RISQUES ET CHARGES (p.84) **[A]**
  - 511 Provisions pour charges de retraite (p.84) **[A]**
  - 512 Provisions pour risque d’exécution d’engagement par signature (p.84)
  - 519 Autres provisions pour risques et charges (p.84) **[A]**
- 52 PROVISIONS REGLEMENTEES (p.84) **[A]**
  - 521 Provisions pour risques afférents aux opérations de crédits à moyen et long termes (p.84) **[A]**
  - 522 Provision spéciale de réévaluation (p.84)
- 53 EMPRUNTS ET TITRES EMIS SUBORDONNES (p.84) **[A]**
  - 532 Emprunts et titres émis subordonnés (p.84) **[A]**
    - 5321 Emprunts et titres émis subordonnés à terme (p.84)
      - 53212 Emprunts émis subordonnés à terme (p.84)
      - 53214 Titres émis subordonnés à terme (p.84)
    - 5322 Emprunts et titres émis subordonnés à durée indéterminée (p.84)
      - 53222 Emprunts émis subordonnés à durée indéterminée (p.84)
      - 53224 Titres émis subordonnés à durée indéterminée (p.84)
  - 536 Dettes rattachées (p.84) **[A]**
- 54 FONDS POUR RISQUES FINANCIERS GENERAUX (p.84) **[A]**
- 55 PRIMES LIEES AU CAPITAL ET RESERVES (p.84) **[A]**
  - 551 Primes liées au capital (p.84) **[A]**
  - 552 Réserves (p.84) **[A]**
    - 5521 Réserve générale (p.84) **[A]**
    - 5522 Réserves facultatives (p.84) **[A]**
    - 5523 Autres réserves (p.84) **[A]**
      - 55231 Réserves statutaires (p.84)
      - 55232 Autres réserves (p.84)
  - 553 Ecart de réévaluation des immobilisations (p.84)
- 56 FONDS DE DOTATION (p.85) **[A]**
- 57 CAPITAL SOCIAL (p.85) **[A]**
  - 571 Capital (p.85) **[A]**
    - 5711 Capital souscrit appelé (p.85) **[A]**
      - 57111 capital souscrit appelé versé (p.85) **[A]**
      - 57112 capital appelé souscrit non versé (p.85) **[A]**
    - 5712 Capital souscrit non appelé (p.85) **[A]**
  - 573 Actionnaires, associés ou membres (p.85) **[A]**
    - 5731 Actionnaires, associés ou membres, capital souscrit non appelé (p.85) **[A]**
    - 5732 Actionnaires, associés ou membres, capital souscrit appelé non versé (p.85) **[A]**
- 58 REPORT A NOUVEAU (p.85) **[A]**
- 59 RESULTAT (p.85) **[A]**
  - 591 Excédent ou déficit en instance d'approbation (p.85) **[A]**
  - 592 Excédent ou déficit de l'exercice (p.85) **[A]**
  - 593 Marge (p.85) **[A]**
    - 5931 Marge d’intérêts (p.85)
    - 5932 Marge commerciale (p.85)
  - 594 Produit financier net ou charge financière nette (p.85) **[A]**
  - 595 Excédent ou déficit d’exploitation (p.85) **[A]**
  - 596 Excédent ou déficit exceptionnel (p.85) **[A]**

#### Classe 6 COMPTES DE CHARGES (p.86)

- 60 CHARGES D'EXPLOITATION FINANCIERE (p.86) **[A]**
  - 601 Charges sur opérations avec les institutions financières (p.86) **[A]**
    - 6011 Intérêts sur comptes ordinaires chez les institutions financières (p.86) **[A]**
      - 60111 Intérêts sur comptes ordinaires chez l’organe financier (p.86)
      - 60112 Intérêts sur comptes ordinaires chez la Caisse Centrale (p.86)
      - 60113 Intérêts sur comptes ordinaires chez les CCP (p.86)
      - 60114 Intérêts sur comptes ordinaires chez les banques et correspondants (p.86)
      - 60115 Intérêts sur comptes ordinaires chez les établissements financiers (p.86)
      - 60116 Intérêts sur comptes ordinaires chez les SFD (p.86)
      - 60117 Intérêts sur comptes ordinaires chez les autres institutions financières (p.86)
    - 6015 Intérêts sur comptes ordinaires des institutions financières (p.86) **[A]**
      - 60151 Intérêts sur comptes ordinaires de l’organe financier (p.86)
      - 60152 Intérêts sur comptes ordinaires du Trésor Public (p.86)
      - 60153 Intérêts sur comptes ordinaires des CCP (p.86)
      - 60154 Intérêts sur comptes ordinaires des banques et correspondants (p.86)
      - 60155 Intérêts sur comptes ordinaires des établissements financiers (p.86)
      - 60156 Intérêts sur comptes ordinaires des SFD (p.86)
      - 60157 Intérêts sur comptes ordinaires d’autres institutions financières (p.86)
    - 6016 Intérêts sur autres comptes de dépôts des institutions financières (p.86) **[A]**
      - 60161 Intérêts sur dépôts à terme reçus (p.86)
      - 60162 Intérêts sur dépôts de garantie reçus (p.86)
      - 60165 Intérêts sur autres dépôts reçus (p.86)
    - 6017 Intérêts sur comptes d'emprunts (p.86) **[A]**
      - 60175 Intérêts sur emprunts à moins d’un an (p.86)
      - 60178 Intérêts sur emprunts à terme (p.86)
    - 6018 Autres intérêts (p.86) **[A]**
      - 60189 Divers intérêts (p.86)
    - 6019 Commissions (p.86) **[A]**
      - 60191 Cotisations (p.86)
      - 60193 Autres commissions (p.86)
  - 602 Charges sur opérations avec les membres, bénéficiaires ou clients (p.86) **[A]**
    - 6025 Intérêts sur comptes des membres, bénéficiaires ou clients (p.86) **[A]**
      - 60251 Intérêts sur comptes ordinaires créditeurs (p.86) **[A]**
        - 602511 Intérêts sur comptes ordinaires créditeurs (p.86) **[A]**
        - 602512 Intérêts sur comptes ordinaires sur livrets créditeurs (p.86) **[A]**
      - 60252 Intérêts sur dépôts à terme reçus (p.86) **[A]**
      - 60253 Intérêts sur comptes d’épargne à régime spécial (p.86) **[A]**
      - 60254 Intérêts sur dépôts de garantie reçus (p.86) **[A]**
      - 60255 Intérêts sur autres dépôts reçus (p.86) **[A]**
    - 6027 Intérêts sur emprunts et autres sommes dues aux membres, bénéficiaires ou clients (p.86) **[A]**
    - 6028 Autres intérêts (p.86) **[A]**
    - 6029 Commissions (p.86) **[A]**
      - 60291 Cotisations (p.86)
      - 60293 Autres commissions (p.86)
  - 603 Charges sur opérations sur titres et sur opérations diverses (p.87) **[A]**
    - 6031 Charges et pertes sur titres de placement (p.87) **[A]**
    - 6038 Charges sur opérations diverses (p.87) **[A]**
    - 6039 Commissions (p.87) **[A]**
  - 604 Charges sur valeurs immobilisées (p.87) **[A]**
    - 6041 Charges sur immobilisations financières (p.87) **[A]**
      - 60411 Frais d'acquisition (p.87)
      - 60412 Etalement de la prime (p.87)
    - 6046 Charges sur opérations de crédit-bail et de location avec option d'achat (p.87)
      - 60461 Charges sur crédit-bail (p.87)
        - 604611 Dotations aux amortissements (p.87)
        - 604612 Dotations aux provisions (p.87)
        - 604613 Moins-values de cession (p.87)
        - 604619 Autres charges (p.87)
      - 60462 Charges sur location avec option d'achat (p.87)
        - 604621 Dotations aux amortissements (p.87)
        - 604622 Dotations aux provisions (p.87)
        - 604623 Moins-values de cession (p.87)
        - 604629 Autres charges (p.87)
      - 60463 Charges sur opérations de location simple (p.87)
        - 604631 Dotations aux amortissements (p.87)
        - 604632 Dotations aux provisions (p.87)
        - 604633 Moins-values de cession (p.87)
        - 604639 Autres charges (p.87)
      - 60464 Charges sur immobilisations non louées (p.87)
        - 604641 Dotations aux amortissements (p.87)
        - 604642 Dotations aux provisions (p.87)
        - 604643 Moins-values de cession (p.87)
        - 604649 Autres charges (p.87)
    - 6047 Charges sur opérations de location-vente (p.87)
      - 60471 Charges sur immobilisations en cours (p.87)
        - 604712 Dotations aux provisions (p.87)
        - 604713 Moins-values de cession (p.87)
        - 604719 Autres charges (p.87)
      - 60472 Charges sur location-vente (p.87)
        - 604721 Dotations aux amortissements (p.87)
        - 604722 Dotations aux provisions (p.87)
        - 604723 Moins-values de cession (p.87)
        - 604729 Autres charges (p.87)
      - 60473 Charges sur opérations de location simple (p.87)
        - 604731 Dotations aux amortissements (p.87)
        - 604732 Dotations aux provisions (p.87)
        - 604733 Moins-values de cession (p.87)
        - 604739 Autres charges (p.87)
      - 60474 Charges sur immobilisations non louées (p.87)
        - 604741 Dotations aux amortissements (p.87)
        - 604742 Dotations aux provisions (p.87)
        - 604743 Moins-values de cession (p.87)
        - 604749 Autres charges (p.88)
  - 605 Charges sur fonds propres et assimilés (p.88) **[A]**
    - 6053 Charges sur emprunts et titres émis subordonnés (p.88) **[A]**
      - 60532 Charges sur emprunts et titres émis subordonnés (p.88)
        - 605321 Charges sur emprunts et titres émis subordonnés à terme (p.88)
        - 605322 Charges sur emprunts et titres émis subordonnés à durée indéterminée (p.88)
  - 606 Charges sur opérations de change (p.88)
    - 6061 Pertes sur opérations de change (p.88)
    - 6069 Commissions (p.88)
  - 607 Charges sur opérations de hors bilan (p.88)
    - 6071 Charges sur engagements de financement reçus (p.88)
      - 60712 Charges sur engagements de financement reçus des institutions financières (p.88)
      - 60714 Charges sur engagements de financement reçus des membres, clients ou bénéficiaires (p.88)
    - 6072 Charges sur engagements de garantie reçus (p.88)
      - 60722 Charges sur engagements de garantie reçus des institutions financières (p.88)
      - 60724 Charges sur engagements de garantie reçus des membres, bénéficiaires ou clients (p.88)
    - 6073 Charges sur engagements sur titres (p.88)
    - 6075 Charges sur autres engagements reçus (p.88)
  - 608 Charges sur prestations de services financiers (p.88) **[A]**
    - 6081 Charges sur les moyens de paiement (p.88)
    - 6089 Autres charges sur prestations de services financiers (p.88)
  - 609 Autres charges d'exploitation financière (p.88) **[A]**
    - 6091 Moins-values sur cession d'éléments d'actif (p.88) **[A]**
    - 6098 Transferts de produits d'exploitation financière (p.88) **[A]**
    - 6099 Diverses charges d'exploitation financière (p.88) **[A]**
- 61 ACHATS ET VARIATIONS DE STOCKS (p.88) **[A]**
  - 611 Achats (p.88) **[A]**
    - 6112 Stocks vendus (p.88) **[A]**
    - 6116 Achats non stockés de matières et fournitures (p.88) **[A]**
      - 61161 Carburant et lubrifiants (p.88)
      - 61162 Autres matières et fournitures (p.88)
        - 611621 Fournitures non stockables - Eau (p.88)
        - 611622 Fournitures non stockables - Electricité (p.88)
        - 611623 Fournitures non stockables - Autres énergies (p.88)
    - 6117 Achats de marchandises (p.88) **[A]**
    - 6118 Frais accessoires d'achat (p.88) **[A]**
    - 6119 Rabais, remises et ristournes obtenus sur achats de marchandises (p.88) **[A]**
  - 612 Variations de stocks (p.88) **[A]**
- 62 AUTRES CHARGES EXTERNES ET CHARGES DIVERSES D'EXPLOITATION (p.88) **[A]**
  - 621 Services extérieurs (p.88) **[A]**
    - 6211 Redevances de crédit-bail (p.88) **[A]**
    - 6212 Loyers (p.88) **[A]**
    - 6213 Charges locatives et de co-propriété (p.88) **[A]**
    - 6214 Entretien et réparations (p.88) **[A]**
    - 6215 Primes d'assurance (p.88) **[A]**
    - 6216 Etudes et recherches (p.89) **[A]**
    - 6217 Frais de formation (p.89) **[A]**
      - 62171 Frais de formation du personnel (p.89)
      - 62172 Frais de formation des membres (p.89)
      - 62173 Frais de formation des élus (p.89)
    - 6218 Divers (p.89) **[A]**
    - 6219 Rabais, remises et ristournes obtenus sur services extérieurs (p.89) **[A]**
  - 622 Autres services extérieurs (p.89) **[A]**
    - 6221 Personnel extérieur à l'institution (p.89) **[A]**
    - 6222 Rémunérations d'intermédiaires et honoraires (p.89) **[A]**
    - 6223 Publicité, publications et relations publiques (p.89) **[A]**
    - 6224 Transports de biens (p.89) **[A]**
    - 6225 Transports collectifs du personnel (p.89) **[A]**
    - 6226 Déplacements, missions et réceptions (p.89) **[A]**
      - 62261 Déplacements (p.89)
      - 62262 Missions (p.89)
      - 62263 Réceptions (p.89)
    - 6227 Frais postaux et frais de communication (p.89) **[A]**
    - 6228 Divers (p.89) **[A]**
    - 6229 Rabais, remises et ristournes obtenus sur autres services extérieurs (p.89) **[A]**
  - 623 Charges diverses d'exploitation (p.89) **[A]**
    - 6231 Redevances pour concessions, brevets, licences, procédés, droits et valeurs similaires (p.89) **[A]**
    - 6232 Indemnités de fonction versées (p.89) **[A]**
    - 6233 Frais de tenue des réunions des organes et des assemblées (p.89) **[A]**
      - 62331 Perdiem (p.89)
      - 62332 Transport (p.89)
      - 62333 Hébergement (p.89)
      - 62334 Téléphone (p.89)
      - 62335 Carburant (p.89)
      - 62339 Autres (p.89)
    - 6235 Moins-values de cession sur immobilisations (p.89) **[A]**
      - 62351 sur immobilisations corporelles et incorporelles (p.89)
      - 62352 sur immobilisations financières (p.89)
    - 6238 Transferts de produits d'exploitation non financière (p.89) **[A]**
      - 62381 Produits rétrocédés (p.89)
      - 62389 Autres transferts de produits (p.89)
    - 6239 Autres charges diverses d'exploitation non financière (p.89) **[A]**
      - 62391 Dons (p.89)
      - 62392 Autres charges diverses d’exploitation (p.89)
- 63 IMPOTS, TAXES ET VERSEMENTS ASSIMILES (p.89) **[A]**
  - 631 Impôts, taxes et versements assimilés sur rémunérations (p.89) **[A]**
    - 6311 Impôts et taxes versés à l'Administration des impôts (p.89)
    - 6312 Impôts et taxes versés aux autres organismes (p.89)
  - 632 Autres impôts, taxes et prélèvements assimilés versés à l'Administration des impôts (p.89) **[A]**
    - 6321 Impôts directs (p.89)
    - 6323 Impôts indirects (p.89)
    - 6324 Droits d'enregistrement et de timbre (p.89)
    - 6329 Impôts et taxes divers (p.90)
  - 633 Autres impôts, taxes et prélèvements assimilés versés aux autres organismes (p.90) **[A]**
- 64 CHARGES DE PERSONNEL (p.90) **[A]**
  - 641 Salaires et traitements (p.90) **[A]**
  - 642 Charges sociales (p.90) **[A]**
  - 643 Rémunérations versées aux stagiaires (p.90) **[A]**
- 65 DOTATION AU FONDS POUR RISQUES FINANCIERS GENERAUX (p.90) **[A]**
- 66 DOTATIONS AUX AMORTISSEMENTS, AUX PROVISIONS ET PERTES SUR CREANCES IRRECOUVRABLES (p.90) **[A]**
  - 661 Dotations aux amortissements des immobilisations (p.90) **[A]**
    - 6611 Dotations aux amortissements des immobilisations d'exploitation (p.90)
      - 66111 Dotations aux amortissements des immobilisations incorporelles d'exploitation (p.90)
      - 66112 Dotations aux amortissements des immobilisations corporelles d'exploitation (p.90)
    - 6612 Dotations aux amortissements des immobilisations hors exploitation (p.90)
      - 66121 Dotations aux amortissements des immobilisations incorporelles hors exploitation (p.90)
      - 66122 Dotations aux amortissements des immobilisations corporelles hors exploitation (p.90)
  - 662 Dotations aux amortissements des charges à répartir (p.90) **[A]**
  - 663 Dotations aux provisions pour dépréciation des immobilisations (p.90) **[A]**
    - 6631 Dotations aux provisions pour dépréciation des immobilisations en cours (p.90)
      - 66311 Dotations aux provisions pour dépréciation des immobilisations incorporelles en cours (p.90)
      - 66312 Dotations aux provisions pour dépréciation des immobilisations corporelles en cours (p.90)
    - 6632 Dotations aux provisions pour dépréciation des immobilisations d'exploitation (p.90)
      - 66321 Dotations aux provisions pour dépréciation des immobilisations incorporelles d'exploitation (p.90)
      - 66322 Dotations aux provisions pour dépréciation des immobilisations corporelles d'exploitation (p.90)
    - 6633 Dotations aux provisions pour dépréciation des immobilisations hors exploitation (p.90)
      - 66331 Dotations aux provisions pour dépréciation des immobilisations incorporelles hors exploitation (p.90)
      - 66332 Dotations aux provisions pour dépréciation des immobilisations corporelles hors exploitation (p.90)
  - 664 Dotations aux provisions sur créances en souffrance (p.90) **[A]**
    - 6641 Dotations aux provisions sur créances en souffrance de 6 mois au plus (p.90) **[A]**
      - 66411 Dotations aux provisions sur créances en souffrance de 0 à 3 mois au plus (p.90) **[A]**
      - 66412 Dotations aux provisions sur créances en souffrance de plus de 3 mois à 6 mois au plus (p.90) **[A]**
    - 6642 Dotations aux provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus (p.90) **[A]**
    - 6643 Dotations aux provisions sur créances en souffrance de plus 12 mois à 24 mois au plus (p.90) **[A]**
  - 666 Dotations aux provisions pour dépréciation des autres éléments d'actif (p.90) **[A]**
  - 667 Dotations aux provisions pour risques et charges (p.90) **[A]**
  - 668 Dotations aux provisions réglementées (p.90) **[A]**
  - 669 Pertes sur créances irrécouvrables (p.90) **[A]**
    - 6691 Pertes sur créances irrécouvrables couvertes par des provisions (p.90)
    - 6692 Pertes sur créances irrécouvrables non couvertes par des provisions (p.90)
- 67 CHARGES EXCEPTIONNELLES ET PERTES SUR EXERCICES ANTERIEURS (p.91) **[A]**
  - 671 Charges exceptionnelles (p.91) **[A]**
    - 6711 Pertes causées par un cataclysme (p.91)
    - 6712 Charges de restructuration (p.91)
    - 6713 Pénalités et amendes fiscales et pénales (p.91)
    - 6714 Rappels d'impôts autres que l'impôt sur les excédents (p.91)
    - 6715 Pertes résultant d'un changement de méthode (p.91)
    - 6716 Pertes résultant des écarts sur caisse (p.91)
    - 6717 Pertes résultant des écarts sur dépôts (p.91)
    - 6718 Pertes résultant des écarts sur crédits (p.91)
    - 6719 Autres charges exceptionnelles (p.91)
  - 672 Pertes sur exercices antérieurs (p.91) **[A]**
    - 6721 Pertes d'exploitation financière (p.91)
    - 6722 Pertes d'exploitation non financière (p.91)
    - 6723 Pertes exceptionnelles (p.91)
- 69 IMPOTS SUR LES EXCEDENTS (p.91) **[A]**
  - 691 Impôts sur les excédents liés à l’activité d’épargne et de crédit (p.91) **[A]**
  - 692 Impôts sur les excédents liés aux activités autres que l’épargne et le crédit (p.91) **[A]**

#### Classe 7 COMPTES DE PRODUITS (p.92)

- 70 PRODUITS D'EXPLOITATION FINANCIERE (p.92) **[A]**
  - 701 Produits sur opérations avec les institutions financières (p.92) **[A]**
    - 7011 Intérêts sur comptes ordinaires chez les institutions financières (p.92) **[A]**
      - 70111 Intérêts sur comptes ordinaires chez l’organe financier (p.92)
      - 70112 Intérêts sur comptes ordinaires chez la caisse centrale (p.92)
      - 70113 Intérêts sur comptes ordinaires chez les CCP (p.92)
      - 70114 Intérêts sur comptes ordinaires chez les banques et correspondants (p.92)
      - 70115 Intérêts sur comptes ordinaires chez les établissements financiers (p.92)
      - 70116 Intérêts sur comptes ordinaires chez les SFD (p.92)
      - 70117 Intérêts sur comptes ordinaires chez les autres institutions financières (p.92)
    - 7012 Intérêts sur autres comptes de dépôts chez les institutions financières (p.92) **[A]**
      - 70126 Intérêts sur dépôts à terme constitués (p.92)
      - 70127 Intérêts sur dépôts de garantie constitués (p.92)
      - 70128 Intérêts sur autres dépôts constitués (p.92)
    - 7013 Intérêts sur comptes de prêts aux institutions financières (p.92) **[A]**
      - 70131 Intérêts sur prêts à moins d’un an (p.92)
      - 70133 Intérêts sur prêts à terme (p.92)
    - 7015 Intérêts sur comptes ordinaires des institutions financières (p.92) **[A]**
      - 70151 Intérêts sur comptes ordinaires de l’organe financier (p.92)
      - 70152 Intérêts sur comptes ordinaires du Trésor public (p.92)
      - 70153 Intérêts sur comptes ordinaires du Centre des Chèques Postaux (p.92)
      - 70154 Intérêts sur comptes ordinaires des banques et correspondants (p.92)
      - 70155 Intérêts sur comptes ordinaires des établissements financiers (p.92)
      - 70156 Intérêts sur comptes ordinaires des SFD (p.92)
      - 70157 Intérêts sur comptes ordinaires d’autres institutions financières (p.92)
    - 7018 Autres intérêts (p.92) **[A]**
      - 70189 Divers intérêts (p.92)
    - 7019 Commissions (p.92) **[A]**
      - 70191 Cotisations et droits d’adhésion (p.92)
      - 70192 Commissions sur transfert d’argent (p.92)
      - 70193 Autres commissions (p.92)
  - 702 Produits sur opérations avec les membres, bénéficiaires ou clients (p.92) **[A]**
    - 7021 Intérêts sur crédits aux membres, bénéficiaires ou clients (p.92) **[A]**
      - 70212 intérêts sur crédits à court terme (p.92)
      - 70213 Intérêts sur crédits à moyen terme (p.92)
      - 70214 Intérêts sur crédits à long terme (p.92)
    - 7025 Intérêts sur comptes des membres, bénéficiaires ou clients (p.92) **[A]**
      - 70251 Intérêts sur comptes ordinaires (p.92)
        - 702511 Intérêts sur comptes ordinaires (p.92)
    - 7028 Autres intérêts (p.92) **[A]**
      - 70289 Divers intérêts (p.92)
    - 7029 Commissions (p.92) **[A]**
      - 70291 Cotisations et droits d’adhésion (p.92)
      - 70292 Commissions sur transfert d’argent (p.92)
      - 70293 Autres commissions (p.93)
  - 703 Produits sur opérations sur titres et sur opérations diverses (p.93) **[A]**
    - 7031 Produits et profits sur titres de placement (p.93)
    - 7038 Produits sur opérations diverses (p.93) **[A]**
    - 7039 Commissions (p.93) **[A]**
  - 704 Produits sur valeurs immobilisées (p.93) **[A]**
    - 7041 Produits sur les immobilisations financières (p.93)
      - 70410 Produits et profits sur prêts et titres subordonnés (p.93)
        - 704101 Produits et profits sur prêts et titres subordonnés à terme (p.93)
        - 704102 Produits et profits sur prêts et titres subordonnés à durée indéterminée (p.93)
      - 70412 Dividendes et produits assimilés sur titres de participation (p.93)
      - 70414 Produits et profits sur titres d'investissement (p.93)
    - 7046 Produits sur opérations de crédit-bail et de location avec option d'achat (p.93)
      - 70461 Produits sur crédit-bail (p.93)
        - 704611 Loyers (p.93)
        - 704612 Reprises de provisions (p.93)
        - 704613 Plus-values de cession (p.93)
        - 704619 Autres produits (p.93)
      - 70462 Produits sur location avec option d'achat (p.93)
        - 704621 Loyers (p.93)
        - 704622 Reprises de provisions (p.93)
        - 704623 Plus-values de cession (p.93)
        - 704629 Autres produits (p.93)
      - 70463 Produits sur location simple (p.93)
        - 704631 Loyers (p.93)
        - 704632 Reprises de provisions (p.93)
        - 704633 Plus-values de cession (p.93)
        - 704639 Autres produits (p.93)
      - 70464 Produits sur immobilisations non louées (p.93)
        - 704642 Reprises de provisions (p.93)
        - 704643 Plus-values de cession (p.93)
        - 704649 Autres produits (p.93)
    - 7047 Produits sur opérations de location-vente (p.93)
      - 70472 Produits sur location-vente (p.93)
        - 704721 Loyers (p.93)
        - 704722 Reprises de provisions (p.93)
        - 704723 Plus-values de cession (p.93)
        - 704729 Autres produits (p.93)
      - 70473 Produits sur location simple (p.93)
        - 704731 Loyers (p.93)
        - 704732 Reprises de provisions (p.93)
        - 704733 Plus-values de cession (p.93)
        - 704739 Autres produits (p.93)
      - 70474 Produits sur immobilisations non louées (p.93)
        - 704742 Reprises de provisions (p.93)
        - 704743 Plus-values de cession (p.93)
        - 704749 Autres produits (p.93)
  - 706 Produits sur opérations de change (p.94)
    - 7061 Gains sur opérations de change (p.94)
    - 7069 Commissions (p.94)
  - 707 Produits sur opérations de hors bilan (p.94)
    - 7071 Produits sur engagements de financement donnés (p.94)
      - 70711 Produits sur engagements de financement donnés aux institutions financières (p.94)
      - 70713 Produits sur engagements de financement donnés aux membres, bénéficiaires ou clients (p.94)
    - 7072 Produits sur engagements de garantie donnés (p.94)
      - 70721 Produits sur engagements de garantie donnés aux institutions financières (p.94)
      - 70723 Produits sur engagements de garantie donnés aux membres, bénéficiaires ou clients (p.94)
    - 7073 Produits sur engagements sur titres (p.94)
    - 7075 Produits sur autres engagements donnés (p.94)
    - 7076 Produits sur opérations effectuées pour le compte de tiers (p.94)
  - 708 Produits sur prestations de services financiers (p.94) **[A]**
    - 7081 Produits sur les moyens de paiement (p.94)
    - 7089 Autres produits sur prestations de services financiers (p.94)
  - 709 Autres produits d'exploitation financière (p.94) **[A]**
    - 7091 Plus - values sur cession d'éléments d'actif (p.94) **[A]**
    - 7098 Transferts de charges d'exploitation (p.94) **[A]**
    - 7099 Divers produits d'exploitation (p.94) **[A]**
- 71 VENTES (p.94) **[A]**
  - 711 Ventes (p.94) **[A]**
    - 7111 Ventes de marchandises (p.94) **[A]**
    - 7118 Produits accessoires d'achat (p.94) **[A]**
    - 7119 Rabais, remises et ristournes accordés sur ventes de marchandises (p.94) **[A]**
- 72 PRODUITS DIVERS D'EXPLOITATION (p.94) **[A]**
  - 721 Redevances sur concessions, brevets, licences, procédés, droits et valeurs similaires (p.94)
  - 722 Indemnités de fonction et rémunérations d'administrateurs, gérants reçues (p.94) **[A]**
  - 725 Plus-values de cession (p.94) **[A]**
    - 7251 sur immobilisations incorporelles et corporelles (p.94) **[A]**
    - 7252 sur immobilisations financières (p.94) **[A]**
  - 727 Revenus des immeubles hors exploitation (p.94)
  - 728 Transferts de charges d'exploitation non financière (p.94) **[A]**
    - 7281 Charges refacturées (p.94) **[A]**
    - 7282 Charges à répartir sur plusieurs exercices (p.94) **[A]**
    - 7289 Autres transferts de charges (p.94) **[A]**
  - 729 Autres produits divers d'exploitation (p.94) **[A]**
- 73 PRODUCTION IMMOBILISEE (p.94)
  - 731 Immobilisations incorporelles (p.94)
  - 732 Immobilisations corporelles (p.94)
- 74 SUBVENTIONS D'EXPLOITATION (p.94) **[A]**
- 75 REPRISES DU FONDS POUR RISQUES FINANCIERS GENERAUX (p.94) **[A]**
- 76 REPRISES D'AMORTISSEMENTS, DE PROVISIONS ET RECUPERATIONS SUR CREANCES IRRECOUVRABLES (p.95) **[A]**
  - 761 Reprises d'amortissements des immobilisations (p.95) **[A]**
  - 763 Reprises de provisions sur immobilisations (p.95) **[A]**
    - 7631 Reprises de provisions sur immobilisations en cours (p.95)
      - 76311 Reprises de provisions sur immobilisations incorporelles en cours (p.95)
      - 76312 Reprises de provisions sur immobilisations corporelles en cours (p.95)
    - 7632 Reprises de provisions sur immobilisations d'exploitation (p.95)
      - 76321 Reprises de provisions sur immobilisations incorporelles d'exploitation (p.95)
      - 76322 Reprises de provisions sur immobilisations corporelles d'exploitation (p.95)
    - 7633 Reprises de provisions sur immobilisations hors exploitation (p.95)
      - 76331 Reprises de provisions sur immobilisations incorporelles hors exploitation (p.95)
      - 76332 Reprises de provisions sur immobilisations corporelles hors exploitation (p.95)
  - 764 Reprises de provisions sur créances en souffrance (p.95) **[A]**
    - 7641 Reprises de provisions sur créances en souffrance de 6 mois au plus (p.95)
      - 76411 Reprises de provisions sur créances en souffrance de 0 à 3 mois au plus (p.95)
      - 76412 Reprises de provisions sur créances en souffrance de plus de 3 mois à 6 mois au plus (p.95)
    - 7642 Reprises de provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus (p.95)
    - 7643 Reprises de provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus (p.95)
  - 766 Reprises de provisions pour dépréciation des autres éléments d'actif (p.95) **[A]**
  - 767 Reprises de provisions pour risques et charges (p.95) **[A]**
  - 768 Reprises de provisions réglementées (p.95) **[A]**
  - 769 Récupération sur créances amorties (p.95) **[A]**
- 77 PRODUITS EXCEPTIONNELS ET PROFITS SUR EXERCICES ANTERIEURS (p.95) **[A]**
  - 771 Produits exceptionnels (p.95) **[A]**
    - 7711 Dédits, pénalités et libéralités perçus (p.95)
    - 7712 Subventions d'équilibre (p.95)
    - 7713 Dégrèvement d'impôts autres que l’impôt sur les excédents (p.95)
    - 7714 Quote-part des subventions d'investissement virée au résultat de l'exercice (p.95)
    - 7715 Produits résultant d'un changement de méthode d'évaluation (p.95)
    - 7716 Produits résultant des écarts sur caisse (p.95)
    - 7717 Produits résultant des écarts sur dépôts (p.95)
    - 7718 Produits résultant des écarts sur crédits (p.95)
    - 7719 Autres produits exceptionnels (p.95)
  - 772 Profits sur exercices antérieurs (p.95) **[A]**
    - 7721 Profits d'exploitation financière (p.95)
    - 7722 Profits d'exploitation non financière (p.95)
    - 7723 Profits exceptionnels (p.95)

#### Classe 9 COMPTES D’ENGAGEMENTS HORS BILAN (p.96)

- 90 ENGAGEMENTS DE FINANCEMENT (p.96)
  - 901 Engagements de financement donnés en faveur des institutions financières (p.96)
  - 902 Engagements de financement reçus des institutions financières (p.96)
  - 903 Engagements de financement donnés en faveur des membres, bénéficiaires ou clients (p.96)
  - 904 Engagements de financement reçus des membres, bénéficiaires ou clients (p.96)
- 91 ENGAGEMENTS DE GARANTIE (p.96)
  - 911 Cautions, avals et autres garanties d'ordre des institutions financières (p.96)
    - 9112 Confirmations d'ouverture de crédits documentaires (p.96)
    - 9113 Acceptations à payer (p.96)
    - 9119 Autres garanties données (p.96)
  - 912 Cautions, avals et autres garanties reçus des institutions financières (p.96)
    - 9121 Cautions et avals reçus (p.96)
    - 9122 Contre-garanties reçues sur les crédits distribués (p.96)
    - 9123 Contre-garanties reçues des engagements par signature donnés (p.96)
    - 9124 Autres garanties irrévocables et inconditionnelles reçues (p.96)
  - 913 Garanties d'ordre des membres, bénéficiaires ou clients (p.96)
    - 9132 Obligations cautionnées (p.96)
    - 9133 Cautions, avals et autres garanties donnés (p.96)
    - 9134 Garanties de remboursement de crédits (p.96)
    - 9139 Autres garanties données (p.96)
  - 914 Garanties reçues des membres, bénéficiaires ou clients (p.96)
    - 9141 Garanties reçues de l'Etat et des organismes assimilés (p.96)
    - 9142 Garanties reçues des entreprises d'assurance et de capitalisation (p.96)
    - 9149 Autres garanties reçues (p.96)
- 92 ENGAGEMENTS SUR TITRES (p.96)
  - 921 Titres à livrer (p.96)
    - 9211 Interventions à l'émission (p.96)
    - 9212 Marché gris (p.96)
    - 9219 Autres titres à livrer (p.96)
  - 922 Titres à recevoir (p.96)
    - 9221 Interventions à l'émission (p.96)
    - 9222 Marché gris (p.96)
    - 9229 Autres titres à recevoir (p.96)
- 93 ENGAGEMENTS SUR OPERATIONS EN DEVISES (p.96)
  - 931 Opérations de change au comptant (p.96)
    - 9311 Francs CFA achetés non encore reçus (p.96)
    - 9312 Devises achetées non encore reçues (p.96)
    - 9313 Francs CFA vendus non encore livrés (p.96)
    - 9314 Devises vendues non encore livrées (p.96)
  - 932 Opérations de change à terme (p.97)
    - 9321 Francs CFA à recevoir contre devises à livrer (p.97)
    - 9322 Devises à recevoir contre francs CFA à livrer (p.97)
    - 9323 Devises à recevoir contre devises à livrer (p.97)
    - 9324 Devises à livrer contre devises à recevoir (p.97)
  - 933 Opérations de prêts ou d'emprunts en devises (p.97)
    - 9331 Devises prêtées non encore livrées (p.97)
    - 9332 Devises empruntées non encore reçues (p.97)
  - 934 Report/déport non couru (p.97)
    - 9341 Report/déport à recevoir (p.97)
    - 9342 Report/déport à payer (p.97)
  - 935 Intérêts non courus en devises couverts (p.97)
    - 9351 Intérêts non courus en devises couverts à recevoir (p.97)
    - 9352 Intérêts non courus en devises couverts à payer (p.97)
  - 936 Comptes d'ajustement de devises hors bilan (p.97)
  - 937 Comptes de position de change hors bilan (p.97)
  - 938 Comptes de contre-valeur de position de change hors bilan (p.97)
- 95 AUTRES ENGAGEMENTS (p.97)
  - 951 Autres engagements donnés (p.97)
    - 9513 Loyers à payer (p.97)
    - 9519 Engagements divers donnés (p.97)
  - 952 Autres engagements reçus (p.97)
    - 9522 Valeurs reçues en garantie (p.97)
    - 9523 Loyers à percevoir (p.97)
    - 9529 Engagements divers reçus (p.97)
- 96 OPERATIONS EFFECTUEES POUR LE COMPTE DE TIERS (p.97)
  - 961 Opérations d'encaissement (p.97)
    - 9611 Valeurs à l'encaissement reçues des membres, bénéficiaires ou clients et non disponibles (p.97)
    - 9612 Comptes des membres, bénéficiaires ou clients exigibles après encaissement (p.97)
    - 9613 Valeurs à l'encaissement reçues des correspondants et non disponibles (p.97)
    - 9614 Comptes des correspondants exigibles après encaissement (p.97)
  - 962 Comptes de suivi des engagements consortiaux de financement donnés (p.97)
    - 9621 Engagements de financement (p.97)
    - 9622 Part de chef de file (p.97)
    - 9623 Parts des co-participants (p.97)
  - 963 Comptes de suivi des engagements consortiaux de garantie donnés (p.97)
    - 9631 Engagements de garantie donnés (p.97)
    - 9632 Part de chef de file (p.97)
    - 9633 Parts des co-participants (p.97)
  - 965 Comptes de suivi des crédits consortiaux distribués (p.97)
    - 9651 Crédits consortiaux (p.97)
    - 9652 Part de chef de file (p.97)
    - 9653 Parts des co-participants (p.97)
    - 9659 Echéances impayées (p.97)
  - 966 Comptes de suivi des crédits distribués pour le compte de tiers (p.97)
    - 9661 Crédits distribués pour le compte de tiers (p.97)
    - 9662 Ressources affectées aux crédits distribués pour le compte de tiers (p.97)
- 99 ENGAGEMENTS DOUTEUX (p.97)

## (e) Versions des textes : en vigueur, remplacé, nouvelle loi

| Texte | Objet | Statut au 2026-10-25 | Source |
|---|---|---|---|
| Loi uniforme SFD (CM UMOA du 6/04/2007) et décret | cadre SFD | **remplacée** par la loi uniforme microfinance (décision n° 019/CM/UMOA du 21/12/2023) dans chaque État qui l'a transposée : SN loi 2025-04 du 19/02/2025 (abroge la loi 2008-47, art. 173) ; TG adoptée par l'AN en mars 2026 et CI projet du 29/04/2026 **[NON VÉRIFIÉ, une seule source]** ; BF loi 037-2023/ALT (contenu non lu) | E §1 ; n02 p.55 |
| Loi uniforme microfinance 2023 | IMF (« SFD » → « institution de microfinance »), 2 formes juridiques, proportionnalité, Titre V dispositions comptables et prudentielles | **en vigueur** là où elle est transposée. Aucun ratio ni seuil chiffré : tout renvoie à la BCEAO. Art. 60 comptabilité selon la Banque centrale ; art. 61 états individuels et, le cas échéant, **combinés ou consolidés** ; art. 64 proportionnalité ; art. 65 fonds propres ; art. 66 liquidité minimale, coussins, **plan de financement d'urgence** ; art. 67 parties liées (dont actionnaires ≥ 10 % des droits de vote), plafond en % des fonds propres effectifs ; art. 69 normes sur base individuelle et/ou consolidée. **Art. 171 : les instructions, avis et décisions de la BCEAO et les circulaires de la CB pris sous l'ancienne loi restent applicables s'ils ne lui sont pas contraires, jusqu'à leur abrogation.** Art. 172 : textes d'application annoncés, aucun daté. Art. 68, 70 et pages paires : **non lus** | n02 p.25, 27, 53, 55 ; E §4 |
| Instr. 025-02-2009 (RCSFD), 026-02-2009 (plan), 030-02-2009 (états) | référentiel comptable | en vigueur (art. 171) ; 030 complétée par 001-02-2018 pour les points contraires (inférence) | d20 p.34-36 ; d02 p.3 |
| RCSFD 1re édition (2008/2009) | plan, modèles DIMF | en vigueur ; aucune révision trouvée (version en ligne cb-umoa déposée en 2022-05 = édition 2009) | E §2 |
| Instr. 010-08-2010 | 9 ratios prudentiels | en vigueur (art. 171) ; abroge les textes antérieurs de même objet | d06 p.2 ; E §2 |
| Instr. 016-12-2010 | ratio X immobilisations et participations | en vigueur (art. 171) ; pas de clause d'abrogation | d07 p.2 |
| Instr. 017, 018, 019-12-2010 | contrôle interne, rapport annuel, fonds de sécurité | en vigueur (art. 171) | d20 ; E §2 |
| Instr. 020-12-2010 | indicateurs périodiques | en vigueur (art. 171) ; abroge les textes antérieurs | d11 p.2 |
| Instr. 021-12-2010 | version allégée | en vigueur (art. 171) | d12 |
| Instr. 007-06-2010 | seuil de l'article 44 (2 Md FCFA) | en vigueur sous l'ancienne loi ; seuil de supervision sous la loi 2023 **[NON VÉRIFIÉ]** | d16 p.3-4 |
| Instr. 001-02-2018 | états financiers et publication (SFD art. 44) | en vigueur (art. 171) | d02 ; E §2 |
| Instr. 033-11-2016 | consolidation | en vigueur pour les **établissements de crédit** ; **hors champ SFD** ; aucun remplaçant trouvé | d19 p.1, 12 ; E §2 |
| Avis 008-04-2020 | mesures Covid-19 | mesure temporaire (3 mois renouvelable une fois) ; pas de dérogation prudentielle | d01 p.1 |
| Instr. 003-07-2019 | organismes externes d'évaluation du crédit | établissements de crédit ; **aucun impact** sur les états SFD | n03 p.2-3, 9 |
| Instr. 001-03-2025 | LCB-FT, contrôle interne des institutions financières | en vigueur ; hors reporting prudentiel (1 source) | E §3 |
| Nouveau dispositif prudentiel ou nouveaux états DIMF pour les IMF | — | **NON TROUVÉ** | E §2 |

Conséquence : jusqu'à la publication des instructions d'application de la loi 2023, la base du reporting SFD reste **010-08-2010, 016-12-2010, 020-12-2010, 001-02-2018 et le RCSFD**. À adapter quand elles paraîtront : libellé SFD → IMF, ratios de liquidité et de fonds propres, seuil des parties liées, états combinés.
