# Refonte reporting réglementaire : points à faire valider par un comptable, et points ambigus

Ce registre se remplit au fil de l'implémentation et sera remis en fin de projet. Chaque point indique sa zone, la question précise, ce qui a été retenu provisoirement dans le produit, et sa source.

## UEMOA (BCEAO, RCSFD)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| U1 | Plan EDIP = RCSFD allégé. Il manque 333 comptes du RCSFD développé, nécessaires aux SFD art. 44. | Variante allégée par défaut. 189 lignes prennent le compte parent présent dans le plan et sont marquées « à confirmer art. 44 ». | paquet UEMOA, lignes `aConfirmerArt44` ; décision utilisateur du 2026-10-23 |
| U2 | Hors-bilan : la classe 9 est absente du plan EDIP UEMOA (comptes 901 à 99). | Comptes conservés, 40 lignes marquées `planEdipIncomplet` (valeur 0 tant que les comptes ne sont pas ajoutés au plan). | paquet UEMOA ; RCSFD allégé (cb-umoa) |
| U3 | SIG et totaux du bilan E90/L90 : aucune formule n'est publiée. | Formules déduites de la structure du modèle. | uemoa-bceao/reporting.md, T31-T32 |
| U4 | Concordances allégées illisibles : D1E, D1L, V3G (le 7025 allégé est suspect). | Version développée retenue, allégée à confirmer. | T29-T30 |
| U5 | Lignes sans formule : DIMF-2000-BIL B2N, F1A, G10 ; totaux DIMF-2011, 2012 et 2013. | Le moteur les affiche « formule non définie » (jamais 0). | contrat v1.1 |
| U6 | Loi uniforme de 2023 : les instructions d'application (états, capital minimum, canevas) sont introuvables. | Régime transitoire, avec les Instr. 010 et 020 et le RCSFD (art. 171). | T01-T13 |
| U7 | FGDR : taux de 0,29 % et plafond de 300 000 FCFA (décision de 2017). Une révision postérieure n'est pas exclue. | Valeurs de 2017. | T08-T10 |

## CEMAC (COBAC, PCEMF)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| C1 | Modèles d'états : seule l'annexe PCEMF marquée « PROJET » est disponible. Le recueil définitif est à obtenir auprès de la COBAC. | Annexe PROJET. Quand elle diverge des règlements, ce sont les règlements qui s'appliquent. | cemac-beac/reporting.md |
| C2 | Norme 70 %/65 % (Règl. 2002/12) : plafond ou plancher ? L'art. 1 parle de « rapport minimum ». | Plafond (≤). | RPT-116/117 |
| C3 | R-2017/07 : les seuils de jours et les taux de provisionnement n'ont pas été lus. | Provisions complémentaires (JT18, KL19, VL08) non calculées. | RPT-107 |
| C4 | Plafonds de crédit de 2002/10 et de R-2017/08 : coexistence ou abrogation ? | Les deux sont testés. | RPT-106 |
| C5 | 5 comptes cités par le paquet sont introuvables dans le PCEMF : 389, 4651, 5818, 634, 7140. | Correction ou confiance BASSE (S2). | handoff S1 |
| C6 | 218 comptes PCEMF ajoutés au plan EDIP, d'après le PCEMF de janvier 2010. Contradictions éventuelles avec le plan existant à revoir. | Ajouts seulement, sans aucune suppression. | `.claude/handoff/reporting-refonte-plans.md` |

## RDC (BCC, PCCI)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| R1 | Gabarit FinA non publié : la structure des états 003 à 016 est proposée à partir du PCCI. | Structures proposées. | rdc-bcc/reporting.md |
| R2 | Annexe du PCCI non obtenue. Comptes inconnus : impôt, charges du personnel, amortissements, subventions, emprunts faîtière, compte 46. | Lignes marquées NON TROUVÉ. | idem |
| R3 | Devise de présentation (CDF ou USD) et taux de conversion : aucun texte. | Devise configurable ; taux indicatif BCC (choix produit). | RPT-114 |
| R4 | Ratio de capitalisation : aucune formule. | Non calculé. | RPT-107 |

## OHADA (SYSCOHADA, SYCEBNL)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| O1 | Table officielle poste → comptes du SYSCOHADA (PCGO Titre IX ch. 7) non lue. | Bilan SYSCOHADA en confiance MOYENNE. | syscohada-sycebnl/etats-financiers.md |
| O2 | CAFG : 797/697 inclus ou exclus ? Écart entre le Guide §3.2 et la Note 34. | Exclus. | ETF-108 |
| O3 | TFT association SYCEBNL (FE-FH) et TRT : aucune table officielle. | Choix produit. | ETF-113 |
| O4 | Un SFD associatif doit-il aussi produire des états OHADA ? | Non (AUDCIF art. 5, SYCEBNL art. 2), sauf DSF fiscale. | ETF-119/120 |

## Transverse
- Tout ce qui est marqué `confiance: MOYENNE` ou `BASSE` dans les paquets affiche un badge « à valider » dans l'UI.
- (à compléter à chaque lot : décisions du moteur, contrôles de cohérence, écarts trouvés lors de la vérification de l'exactitude contre les modules)
