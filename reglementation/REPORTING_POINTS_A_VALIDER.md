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
| U8 | Variante de compte : le passage de l'allégée à la développée doit-il être automatique (encours ≥ 2 Md FCFA sur 2 exercices), ou rester une saisie ? | Saisie manuelle de `categorieAssujetti` dans Paramètres. | Instr. 007-06-2010 / 021-12-2010 ; S2 |
| U9 | Lignes sans code officiel : DIMF-2006 à 2010, 2011-1, 2014, 2018. | Code technique `LIGNE_<ordre>`, calcul en ERREUR. | S2 |
| U10 | Surcharges pays : rapports nationaux CI-PAYS-001 à 006 sans lignes ; BJ et SN décrits en texte libre. | Rapports affichés, sans calcul. | pays/*.yml ; S2 |
| U7 | FGDR : taux de 0,29 % et plafond de 300 000 FCFA (décision de 2017). Une révision postérieure n'est pas exclue. | Valeurs de 2017. | T08-T10 |

## CEMAC (COBAC, PCEMF)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| C1 | Modèles d'états : seule l'annexe PCEMF marquée « PROJET » est disponible. Le recueil définitif est à obtenir auprès de la COBAC. | Annexe PROJET. Quand elle diverge des règlements, ce sont les règlements qui s'appliquent. | cemac-beac/reporting.md |
| C2 | Norme 70 %/65 % (Règl. 2002/12) : plafond ou plancher ? L'art. 1 parle de « rapport minimum ». | Plafond (≤). | RPT-116/117 |
| C3 | R-2017/07 : les seuils de jours et les taux de provisionnement n'ont pas été lus. | Provisions complémentaires (JT18, KL19, VL08) non calculées. | RPT-107 |
| C4 | Plafonds de crédit de 2002/10 et de R-2017/08 : coexistence ou abrogation ? | Les deux sont testés. | RPT-106 |
| C5 | 5 comptes cités par le paquet sont introuvables dans le PCEMF : 389, 4651, 5818, 634, 7140. | Correction ou confiance BASSE (S2). | handoff S1 |
| C5b | Ligne ZP06 (CEMAC-REP-002C) : compte 634 ou 624 selon la catégorie (2/3) ? | 634 pour toutes les catégories. | reporting.md ZP06 ; S2 |
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

## Moteur de calcul (S4) : règles à valider
| # | Point | Retenu provisoirement |
|---|---|---|
| M1 | Solde d'un compte = débit − crédit, lu selon le sens de la ligne (D/SOLDE : débit − crédit ; C : crédit − débit). | Règle appliquée partout. |
| M2 | Préfixe `-` (provisions, amortissements) : on déduit −\|solde\| ; un compte couvert à la fois par `+` et `-` (ex. `11,-119`) est compté une seule fois, en déduction. | Oui. |
| M3 | Compte de résultat infra-annuel : solde cumulé depuis l'ouverture de l'exercice, ou mouvement de la seule période ? | Cumul. |
| M4 | Variation = (N − N-1) / \|N-1\| × 100 ; certains états demandent-ils une variation absolue ? | Relative. |
| M5 | Contrôle « encours crédit du rapport = module Crédit » : quels postes comparer (net ou brut, comptes ordinaires débiteurs) ? | ALERTE, pas CRITIQUE ; tolérance 0,01. |
| M6 | Catégories d'assujetti : celles du paquet UEMOA (`MUTUALISTE_AFFILIEE`…) ne coïncident pas avec `categorieAssujetti` (ART44, IMF…). | La norme générale s'applique tant que les listes ne sont pas alignées. |
| M7 | Plages `exclut` CEMAC « A à B » lues comme les sous-comptes de réseau dont le 5e chiffre est 9. | Oui. |
| M8 | Lignes avec des comptes mais sans `sens` (OHADA N34, UEMOA D1E_HORS_PART). | ERREUR, aucune inférence. |

## Lacunes des paquets et des modules constatées par le moteur
- **Aucun ratio prudentiel UEMOA n'est calculable** (R1, R3 à R6, R8 à R10). Ils dépendent de DIMF-2000-BIL B2N, F1A et G10, lignes sans formule, et des totaux absents I11, I12 et I13. Seul R7 se calcule. Il faut fournir ces lignes et leur hiérarchie parent/filles.
- Lignes calculables : UEMOA 429 sur 602, CEMAC 397 sur 467, RDC 70 sur 98, OHADA 290 sur 452. Le reste est sans formule ou dépend d'une ligne sans formule.
- UEMOA allégée : D1E, D1L, D32 à D35 portent `NON_TROUVE` ; R2 en dépend.
- CEMAC : XG07 (62) recouvre XG06 (624), d'où un double comptage dans XG01.
- RDC : 46 et 47 sont lus en C au passif et en D à l'actif ; un solde débiteur apparaît donc négatif au passif. Il faut des suffixes dr/cr.
- 18 données CROSS_SERVICE CEMAC, dont 15 ne sont pas branchées : provisions complémentaires, plus gros risques, participations, capital libéré, membres H/F, encours de dépôts, taux. Il faut décider quel module les fournit.
- Comptabilité : pas de balance consolidée sans agence ni à une date donnée, et appel N+1 lent (timeout 60 s).

## Transverse
- T1 Mapping des secteurs du wizard : ENTREPRISE et ASSOCIATION → paquet OHADA (SYSCOHADA ou SYCEBNL), quel que soit le pays ; ASSURANCE → suit la zone, sans paquet dédié (décision S2, non sourcée).
- T2 Périodicités libres (« NON TROUVÉ ») normalisées en `A_CONFIRMER`.
- T3 Type de valeur déduit : POURCENTAGE si la norme est en %, sinon MONTANT ; à contrôler sur les ratios.
- T4 Sens `DEC`/`ENC` (17 lignes, flux) conservés tels quels, sans signification comptable vérifiée.
- Tout ce qui est marqué `confiance: MOYENNE` ou `BASSE` dans les paquets affiche un badge « à valider » dans l'UI.
- (à compléter à chaque lot : décisions du moteur, contrôles de cohérence, écarts trouvés lors de la vérification de l'exactitude contre les modules)
