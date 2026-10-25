# Refonte reporting réglementaire : points à faire valider par un comptable, et points ambigus

Ce registre se remplit au fil de l'implémentation et sera remis en fin de projet. Chaque point indique sa zone, la question précise, ce qui a été retenu provisoirement dans le produit, et sa source.


## Synthèse : les 10 décisions à trancher en priorité (2026-10-24)
| Rang | Décision | Réf. | Effet sur les chiffres |
|---|---|---|---|
| 1 | Caisse UEMOA allégée : compte 101 ou « 1011 » | U13 | Retenu : 101. Avant correction, la base démo sortait 16,2 M de caisse du bilan (actif ≠ passif), ce qui faussait IND-F17 à F19. |
| 2 | Barème COBAC R-2017/07 : seuil du douteux (45 j ou statut du module), rang d'année, couverture par les garanties | C7, C10, C11, C12 | Fixe les provisions requises (CS02). |
| 3 | Provisions complémentaires JT18/KL19/VL08 : « constituées » = provisions des dossiers ou solde du compte 39 ; contagion | C8, C9 | Fixe requis − constitué, puis les fonds propres nets et le coefficient VL10. |
| 4 | Classe 9 hors-bilan : sens des 41 comptes par défaut, postes DIMF-HB, lignes restées en SOLDE | U12, U18, C16 | Tous les postes de hors-bilan. |
| 5 | Plus gros risque et risques > 10 % des FPN : hors-bilan inclus ou non, client ou groupe, apparentés | C15, C17, U17, U19, R6 | DA02, DA04, DB02, DB04, I12, I13, RDC-029. |
| 6 | Variantes UEMOA allégée et développée (lignes art. 44, racines du plan EDIP ajoutées en développée) | U1, U11, U14 | Bilan et compte de résultat. |
| 7 | Ratios prudentiels UEMOA : G30 exclu de R1_DEN, déductions de fonds propres saisies à la main | U15, U22 | R1 à R10. |
| 8 | Rôles comptables CEMAC/RDC : sociétaire ou client, provisions par ancienneté, dotations, perte irrécouvrable | section « Rôles comptables CEMAC/RDC » | Toute la comptabilisation CEMAC et RDC. |
| 9 | TFT/CAFG : cessions FI/FJ, acquisitions FF-FH, regroupement des sections | E5, E6 | Flux d'investissement et trésorerie nette. |
| 10 | Encours des dépôts ST05 (DAT inclus), trésorerie par contrepartie ST07, source module ou compta | C19, C21, M12 | CEMAC-REP-020. |

## UEMOA (BCEAO, RCSFD)
| # | Point | Retenu provisoirement | Source / lieu |
|---|---|---|---|
| U1 | Plan EDIP = RCSFD allégé. Il manque 333 comptes du RCSFD développé, nécessaires aux SFD art. 44. | Variante allégée par défaut. 189 lignes prennent le compte parent présent dans le plan et sont marquées « à confirmer art. 44 ». | paquet UEMOA, lignes `aConfirmerArt44` ; décision utilisateur du 2026-10-23 |
| U2 | Hors-bilan : la classe 9 est absente du plan EDIP UEMOA (comptes 901 à 99). | Résolu le 2026-10-24 : classe 9 ajoutée au plan UEMOA et `planEdipIncomplet` retiré des 40 lignes (voir U12, U18). | paquet UEMOA ; RCSFD allégé (cb-umoa) |
| U3 | SIG et totaux du bilan E90/L90 : aucune formule n'est publiée. | Formules déduites de la structure du modèle. | uemoa-bceao/reporting.md, T31-T32 |
| U4 | Concordances allégées illisibles : D1E, D1L, V3G (le 7025 allégé est suspect). | Version développée retenue, allégée à confirmer. | T29-T30 |
| U5 | Lignes sans formule : DIMF-2000-BIL B2N, F1A, G10 ; totaux DIMF-2011, 2012 et 2013. | Le moteur les affiche « formule non définie » (jamais 0). | contrat v1.1 |
| U6 | Loi uniforme de 2023 : les instructions d'application (états, capital minimum, canevas) sont introuvables. | Régime transitoire, avec les Instr. 010 et 020 et le RCSFD (art. 171). | T01-T13 |
| U8 | Variante de compte : le passage de l'allégée à la développée doit-il être automatique (encours ≥ 2 Md FCFA sur 2 exercices), ou rester une saisie ? | Saisie manuelle de `categorieAssujetti` dans Paramètres. | Instr. 007-06-2010 / 021-12-2010 ; S2 |
| U9 | Lignes sans code officiel : DIMF-2006 à 2010, 2011-1, 2014, 2018. | Code technique `LIGNE_<ordre>`, calcul en ERREUR. | S2 |
| U10 | Surcharges pays : rapports nationaux CI-PAYS-001 à 006 sans lignes ; BJ et SN décrits en texte libre. | Rapports affichés, sans calcul. | pays/*.yml ; S2 |
| U11 | La variante allégée ne contient pas certains postes de la développée (149 lignes `allegee:false`). Valeur proposée : 0 explicite, avec un avertissement « absent du plan allégé ». | à valider | S2b, revue |
| U12 | Classe 9 (hors-bilan) : 87 comptes (90-99) et contreparties 980-985 relus dans le RCSFD 1re édition p. 96-98 et 262-278, concordant avec le guide d'audit SFD UEMOA 2010 (annexe 2). Ajoutés au plan EDIP UEMOA par décision utilisateur du 2026-10-23 ; le comptable corrige après. À valider : (1) classe 9 réservée au développé ? (2) postes DIMF-HB détaillés ; (3) comptes miroir 98x en partie double ; (4) coquille S1 sur 902 ; (5) instruction BCEAO de référence. | comptes HAUTE, version et postes MOYENNE | `uemoa-bceao/plan-classe9-hors-bilan.yml` |
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
| C7 | Barème de provisionnement EMF CEMAC : le règlement COBAC EMF R-2017/07 remplace le R-2002/18, abrogé par son art. 30. Douteux à plus de 45 jours (90 pour l'immobilier). Provision à 100 % sous 1 an sans garantie éligible, 25/50/75/100 % cumulés sur 4 ans avec des garanties 3-5, 0 % avec des garanties 1-2. Appliqué dans les formules par décision de l'utilisateur du 2026-10-23 ; le comptable corrigera ensuite. À valider : (1) date d'entrée en vigueur et transition de 24 mois ; (2) erreur de renvoi entre les art. 17 et 18 ; (3) définition des « provisions complémentaires » dans l'instruction COBAC sur l'état des engagements ; (4) traitement de la part couverte d'une créance partiellement garantie ; (5) sort des provisions existantes au compte 39. | taux HAUTE, provisions complémentaires MOYENNE | `cemac-beac/reporting.md`, complément du 2026-10-23 |

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

## États financiers et exports (S6)
- E1 : il existe deux TFT/CAFG. La liasse compta (écran compta SYSCOHADA) et `SYSN-TFT` du paquet (états réglementaires) peuvent diverger. Pour le régulateur, c'est le paquet qui fait foi ; la liasse compta reste un outil de gestion.
- E2 : en balance consolidée, les comptes de liaison inter-agences ne sont pas éliminés. Les soldes sont justes, mais les totaux débit et crédit sont gonflés.
- E3 : la pièce « Détermination du résultat » (clôture) est exclue de la balance de reporting au 31/12, pour garder les classes 6 et 7 ; à-nouveaux et régularisations conservés.
- E4 : TFT compta, acquisitions FF à FH. Elles sont estimées par la hausse du solde brut des immobilisations, alors que le Guide SYSCOHADA les calcule à partir des nets, plus les dotations 681 et 81 (VNC cédée). L'écart apparaît s'il y a eu des cessions dans l'exercice.

## Transverse
- T1 Mapping des secteurs du wizard : ENTREPRISE et ASSOCIATION → paquet OHADA (SYSCOHADA ou SYCEBNL), quel que soit le pays ; ASSURANCE → suit la zone, sans paquet dédié (décision S2, non sourcée).
- T2 Périodicités libres (« NON TROUVÉ ») normalisées en `A_CONFIRMER`.
- T3 Type de valeur déduit : POURCENTAGE si la norme est en %, sinon MONTANT ; à contrôler sur les ratios.
- T4 Sens `DEC`/`ENC` (17 lignes, flux) conservés tels quels, sans signification comptable vérifiée.
- Tout ce qui est marqué `confiance: MOYENNE` ou `BASSE` dans les paquets affiche un badge « à valider » dans l'UI.
- (à compléter à chaque lot : décisions du moteur, contrôles de cohérence, écarts trouvés lors de la vérification de l'exactitude contre les modules)

| T5 | Sécurité : les endpoints `/reporting/*` du service épargne (existants et nouveau `/reporting/taux-depots`) n'ont pas de `@PreAuthorize`, contrairement au transfert et à la caisse. Prévoir un lot de durcissement. | technique | E1A1 |
| T6 | Taux d'épargne (`HistoriqueInteretCompte.tauxApplique`) testé uniquement en H2, faute d'historique d'intérêts dans la baseline. À valider sur PostgreSQL avec des données réelles. | technique | E1A1 |
| C8 | Provisions COBAC (C1) : la contagion de l'art. 9 s'applique à tout l'encours du client. `provisionsConstituees` additionne donc les provisions de tous les dossiers d'un client douteux, sains compris, et les provisions complémentaires valent requis − constituées sur ce même périmètre. À valider par le comptable. | MOYENNE | C1 |
| T7 | Les données crédit (risques, retards, provisions) sont des instantanés au jour du calcul (`aLaDateDuJour`, `dateCalcul`). Une édition sur une période passée affiche la situation du jour, avec un avertissement. Exception : `/reporting/taux` porte sur les décaissements de la période. | technique | C1 |

## Complément du 2026-10-24 : plan de collecte, Lot 6 et corrections finales

### UEMOA (BCEAO, RCSFD)
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| U13 | Caisse du bilan allégé : le paquet citait « 1011 » (RCSFD annexe 1.1 : « 101/1011 »), alors que le plan EDIP comptabilise la caisse en 101000. | `comptesAllegee: 101` sur A01 et A11. Bilan équilibré vérifié sur la base démo. | Lot 6 et L6b |
| U14 | Variante développée : B01, G01… ne visaient que des sous-comptes (20221, 25111…) absents des écritures EDIP, si bien que crédits et dépôts étaient sous-évalués. | Racines du plan EDIP (2022, 2511, 2512…) ajoutées en développée, sans double compte. Le test vérifie que le bilan développé égale le bilan allégé. | L6b |
| U15 | R1_DEN (PRU-01) exclut G30 (dépôts de garantie reçus). | Exclu ; à confirmer par l'instruction prudentielle. | Lot 6 |
| U16 | IND-F03 (taux de perte) et IND-F16 : T6K/T6L = pertes sur créances irrécouvrables (669), et non les dotations 664. | Définition RCSFD inchangée : une dotation 664 n'entre pas dans le taux de perte. | L6b |
| U17 | « Plus gros encours » DIMF-2012 (I12_MAX) : crédits seuls ou avec le hors-bilan ? | Crédits seuls, d'après le libellé « encours de crédits » (RCSFD 4.9). | R1 |
| U18 | Classe 9 : 41 comptes en DEBITEUR par défaut de classe (en-têtes, 936-938, 96x, 99, 98x). 8 lignes HB restent en SOLDE (P1V, Q1C, Q1F, Q1J-Q1M, N90). 15 lignes en `C`, 17 en `D`. | Sens appliqué selon la règle RCSFD p. 262-278 ; à valider compte par compte. | S10 |
| U19 | I13 (initiés) : apparenté = tout lien client actif avec un dirigeant ou un administrateur, sans transitivité. Union dédoublonnée des catégories ; un dirigeant n'est pas recompté comme apparenté. | Ce périmètre. | K1, R1 |
| U20 | Personnel : un employé sorti est compté jusqu'à `dateSortie` incluse, un employé SUSPENDU est compté, un lien sans date est actif. | Ces règles de datation. | K1 |
| U21 | I11 (autres opérations) = transferts émis (hors annulés et remboursés, frais exclus) + entrants payés TRF_IN + contre-valeur locale des changes. Assurance et mobile money en saisie. | Ce périmètre (décision D2). | R1, A1 |
| U22 | FP_DED_PROV et FP_DED_PART (déductions de fonds propres) en saisie manuelle : R8_NUM est en ERREUR tant qu'elles ne sont pas saisies. Quel module doit les fournir ? | Saisie. | Lot 6 |
| U23 | Participations RCS_SFD : racine 412. | 412. | T1 |

### CEMAC (COBAC, PCEMF)
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| C9 | Provisions « constituées » (JT18/KL19/VL08) = provisions des dossiers du module Crédit, et non le solde du compte 39. | Provisions des dossiers. Un écart avec le grand livre fausserait le complément. | C1, R1 |
| C10 | Douteux (R-2017/07 art. 8-9) = statut DOUTEUX ou CONTENTIEUX du module, sans recontrôle du seuil 45/90 j. IMMOBILISE et EN_RETARD exclus. | Statut du module. | C1 |
| C11 | Rang de l'année : toute année entamée compte (3 ans → 75 %, plafond 4 ans → 100 %). L'ancienneté d'un client est son déclassement le plus ancien (contagion). | Cette règle. | C1 |
| C12 | Couverture : plafonnée par dossier (G1-G2 puis G3-G5), garanties actives seulement. Une garantie non paramétrée est non éligible (100 %). | Cette règle. | C1 |
| C13 | Reprise des données : une date de déclassement absente devient la date du jour (25 %, signalée par `nbClientsDateEstimee`). Dossiers déjà restructurés : taux initial = taux courant. Les TEG antérieurs ne sont pas recalculés. | Reprise à corriger au besoin. | C1 |
| C14 | ST01 capital : `101,102` (catégories 2/3) ou `100,102,-1001` (catégorie 1). Les deux lignes ST01A et ST01B s'affichent. | Les deux lignes sont gardées. | S10 |
| C15 | Plus gros risque DA02/DB02 : hors-bilan inclus (classes 90/92/942 par norme, auxiliaire client) ; titres et engagements sur correspondants exclus. Le plus gros risque est celui d'un client, pas d'un groupe. | Ce périmètre. | R1 |
| C16 | Classes 90/92/942 du hors-bilan COBAC à vérifier dans le plan COBAC EDIP. Seule l'UEMOA a reçu sa classe 9. Sans compte, la ligne sort en ERREUR explicite. | ERREUR explicite. | R1, Lot 6 |
| C17 | DA04/DB04 : somme des bénéficiaires dont le risque dépasse strictement 10 % des FPN. Un groupe = somme de ses membres ; les groupes ayant un membre commun sont fusionnés. | Cette règle de cumul. | R1, K1 |
| C18 | ST02 : seuls les clients sont comptés (pas les actionnaires). | Clients. | S10 |
| C19 | ST05 encours des dépôts = comptes d'épargne (hors comptes legacy de type DAT) + DAT ACTIF et A_ECHEANCE. | DAT inclus, y compris les échus non remboursés. | L6b |
| C20 | ST05N = comptes à vue + à terme + épargne planifiée ; TONTINE et CAUTION exclus. | Ce décompte. | E1, R1 |
| C21 | ST07 trésorerie par contrepartie : BANQUE, EMF, FAITIERE, caisses via le rôle CAISSE ; AUTRE est exclue. Les banques qui partagent un même compte ne sont pas ventilables (alerte NON_VENTILE). Les banques existantes sont classées « BANQUE » par défaut. | Reclasser les banques et ouvrir un compte par type de contrepartie. | T1, R1 |
| C22 | ST09 = TEG (décision D3) des décaissements de la période, hors dossiers sans TEG. ST08 = taux contractuel des DAT (dérogatoires inclus) ; épargne pondérée par le solde moyen. | Ces choix. | C1, E1, R1 |
| C23 | PA02 : racine 26x choisie sur l'auxiliaire PARTICIPATION (COBAC, SYSCOHADA, SYCEBNL). | 26x. | T1 |
| C24 | ZP06 : 634 → 624 (même libellé « transfert de fonds » dans le plan COBAC EDIP). ZP07 exclut 624. | 624 ; le référentiel cite 634. | L6b |
| C25 | 389, 4651, 5818 et 7140 sont absents du plan : la ligne est calculée sur les autres comptes, avec l'avertissement « absent du plan EDIP de référence : valeur partielle », propagé aux totaux. | Avertissement ; indiquer les comptes à utiliser. | L6b |
| C26 | Environ 200 comptes de formule sont plus fins que les comptes feuilles du plan COBAC EDIP (65213/6521…). | Mettre la formule au niveau du plan, ou compléter le plan. | L6b |
| C27 | RG34/RG35 (001B), EG34/EG35/EG48 (001A) : la source est « NON TROUVÉ ». Lignes en SAISIE, ce qui rend calculables RG99 et EG99. RG45 reprend le résultat du compte de résultat de la période, ou passe en SAISIE. | Saisie ; indiquer les comptes. | L6b |
| C28 | Exclusions : RG17 exclut 35109, YG21 exclut 792. | Conforme au paquet ; à confirmer. | Lot 6 |
| C29 | PLAFOND_CLIENT (package CEMAC) : il n'est pas calculé comme une ligne, mais suit le même mécanisme que DA04/DB04. | Quelle valeur de plafond ? | S10, R1 |

### RDC (BCC, PCCI)
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| R5 | RDC-REP-029 : membre = MEMBRE, PARTICULIER ou PROFESSIONNEL ; client = tous les types. | Cette règle ; voir Instr. BCC 002 art. 29. | R1 |
| R6 | Plus gros risque 029 : crédits seuls (sous-journal crédit BCC). | Crédits seuls. | R1 |
| R7 | PARTICIPATIONS 029 = `SOLDE("25", D) / FPP` (norme 0,25). | Ratio sur FPP. | L6b |
| R8 | CRD_EN_RETARD = CRD avec au moins 1 jour de retard. EMPR_PAR_AGENT = emprunteurs des gestionnaires rattachés ÷ nombre de gestionnaires ; les non-rattachés sont exclus. | Ces définitions. | C1, R1 |
| R9 | Participations PCCI : racines 251 et 252 ; RDC SYSCOHADA : racine 26. | Ces racines. | T1 |

### OHADA
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| O5 | Participations SYSCOHADA/SYCEBNL : racine 26. | 26. | T1 |

### Moteur de calcul
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| M9 | Variation TFT : (N − N-1) / \|N-1\| ; affichée « — » si N ou N-1 manque. | Ce calcul. | S9 |
| M10 | Début d'une édition périodique = fin − durée de la périodicité, en mois civils (ZIP inclus). | Ce calcul. | S7 |
| M11 | Tableau de bord : « à faire » = rapports ni SOUMIS ni CLÔTURÉ ; taux de ratios conformes = CONFORME / (total hors SANS_NORME). | Ces définitions. | S7 |
| M12 | Source qui fait foi : les états DIMF lisent la compta, CEMAC-REP-020 lit les modules. Sur la démo, crédit 15,68 M (module) contre 13 M (compte 202200). | Garder les deux sources, avec contrôle de cohérence en ALERTE. Quelle tolérance retenir ? | Lot 6 |

### États financiers
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| E5 | TFT FI = 821 + 822 + 754 − 485 − 414 ; FJ = 826 (Guide SYSCOHADA §4.2.3.3 c). | Ces formules. | S6, S10 |
| E6 | Sections du TFT : A = FA-FE (ZB), B = FF-FJ (ZC), C = FK-FN (ZD), D = FO-FQ (ZE), puis ZF, ZG, ZH. Les lignes non classées vont dans « Autres ». | Ce regroupement. | S9 |

### Transverse (technique)
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| T8 | Une base existante ne reçoit la classe 9 que par `POST /setup/init` (chemin additif). La saisie manuelle d'un compte de classe 9 reste refusée. | À décider. | S10 |
| T9 | Le compte de regroupement 98 n'est pas créé : normalisé, il coïncide avec 980. | 980-985 sans parent. | S10 |
| T10 | Les modules Crédit et Épargne renvoient 0 sur erreur de requête (`safe()`, `safeQuery`). | Lot à part pour remonter l'erreur. | S10 |
| T11 | `ROLE_CREDIT_RAPPORT` n'est pas créé par `SetupCreditLoader`. Les endpoints acceptent `ROLE_CREDIT_RAPPORT_READ`. | Aligner. | C1 |
| T12 | Lignes `RA-NAR-*` et anciens codes REG-BCEAO-008 à 014 orphelins en base. | Purge à décider. | S10 |
| T13 | La purge d'un lot d'import est refusée si des initiés, liens ou groupes de risque y sont rattachés. | Purge en cascade possible. | Lot 6 |
| T14 | TFT compta : pas de paramètre agence (pas de consolidé), pas d'export PDF, pas de comptes contributeurs. | Excel seul. | S9 |
| T15 | Plans de base COBAC et PCCI : environ 50 et 106 codes se confondent une fois normalisés à 6 chiffres (57/570, 103/1030…). Seule la première occurrence est chargée. | Lot à part ; aucun rôle comptable n'est touché. | rôles comptables |

## Rôles comptables CEMAC/RDC (branche `feature/roles-comptables-cemac-rdc`, compta)
Chaque rôle `A_CONFIRMER` a une valeur par défaut que le texte ne prescrit pas. Elle se modifie dans Comptabilité › Paramétrage › Rôles comptables. Le plan COBAC est « indicatif ». Pour le PCCI, la BCC doit autoriser chaque sous-compte ouvert hors du plan. Détail complet : `docs/roles-comptables-cemac-rdc-a-valider.md` sur cette branche.

### CEMAC (COBAC, PCEMF)
| Sujet | Rôles | Compte retenu | Question |
|---|---|---|---|
| Sociétaires ou clients | crédits, COMPTE_VUE, DEPOT_GARANTIE | branche « clients » (3222, 3712, 3742, 3292, 3031, 3131, 3191) | Un membre relève-t-il des sociétaires ou des clients ? |
| Nature du crédit | CT / MT / LT | 3222 / 3131 / 3031 | Quelle nature pour chaque produit ? |
| Souffrance | CREDIT_SOUFFRANCE, _6_12M, _PLUS_12M | 3312 ; 3352 (partagé) | Le plan n'a pas de tranches d'ancienneté. |
| Provisions | PROVISION_CREANCE_6M/_12M/_PLUS_12M | 3931 / 3932 / 3933 | Tranches du plan (< 1 an, 1-2 ans, > 2 ans) ≠ tranches des rôles. |
| Dotations | DOTATION_PROVISION_* | 6913 | Un seul compte au plan. |
| Perte irrécouvrable | PERTE_IRRECOUVRABLE | 6921 | 6921 (créances couvertes) ou 6922 (non couvertes) ? |
| Immobilisé | CREDIT_IMMOBILISE | 3322 | Le PCEMF réserve ce terme aux créances sur l'État. |
| Découvert | DECOUVERT | 37121 (sous-compte SFD) | Ou 3282 ? |
| Trésorerie | MOBILE_MONEY, BANQUE, CAISSE, SFD_CORRESPONDANT | 5608, 5603, 57101, 56091 | Le PCEMF est muet sur ces rôles ; sous-comptes ouverts hors du plan. |
| Attente | ATTENTE_ACTIF, ATTENTE_PASSIF | 468, 387 | À apurer rapidement. |
| Fonds propres | RESERVE_GENERALE, RESULTAT_EXERCICE, RESULTAT_INSTANCE_AFFECTATION, CAPITAL_PARTS_VERSE | 111, 131, 121, 10001 | Réserve générale ou légale ? |
| Produits et charges | intérêts, commissions, pénalités, frais bancaires, change, charge exceptionnelle | 713, 715, 7284, 719, 619, 626, 606, 605, 705, 723, 623, 6798 | Rapprochements de libellés. |

### RDC (BCC, PCCI)
| Sujet | Rôles | Compte retenu | Question |
|---|---|---|---|
| Crédits | CT / MT / LT / DECOUVERT | 3201 / 316 / 306 / 326 | Seuils CT/MT/LT non trouvés ; pas de compte de découvert. |
| Souffrance et provisions | CREDIT_SOUFFRANCE…, PROVISION_CREANCE… | 3903, 3904 ; 3803, 3804 | Tranches du plan en jours (1-30… 181+). |
| Dotations, perte | DOTATION_PROVISION_*, PERTE_IRRECOUVRABLE | 6902 ; 69101 | Libellés ambigus. |
| Dépôts | DEPOT_GARANTIE, AUTRES_DEPOTS_MEMBRES, EPARGNE_PLANIFIEE | 334, 356, 332 | L'épargne obligatoire compte-t-elle comme garantie ? |
| Attente | ATTENTE_ACTIF, ATTENTE_PASSIF | 371, 372 | Ou 475 ? |
| Capital | CAPITAL_PARTS_VERSE et _NON_VERSE | 10301 (partagé) | Le PCCI n'a pas de compte de capital non versé. |
| Sens corrigé | 39, 390, 3900-3904, 391-393, 371 | DEBITEUR | Les bases PCCI déjà chargées gardent l'ancien sens : correction manuelle. |
| Sous-comptes ouverts hors du plan | caisse, CT, DAT, capital, réserves, résultats, produits, charges | 5701, 3201, 3401, 10301, 11101, 1301, 1201, 71201, 71501, 7281, 71701, 6101, 70401, 77901, 69101 | Autorisation de la BCC requise (RDC-CPT-003). |

### Ajouts du 2026-10-24 (corrections de la revue finale)
| # | Point | Retenu provisoirement | Source |
|---|---|---|---|
| R10 | FPP_BASE RDC (029) : 25101 « Participations à plus d'un an dans d'autres établissements de crédit ou IF » (ex-2510, renuméroté pour éviter une collision) est déduit des fonds propres de base. 251000 (titres de participation) n'est pas déduit. | Ce mapping. La note d'origine disait « capital non libéré » : à confirmer. | L6b |
| T16 | Clôture : `ClotureServiceImpl.calculerANouveaux` ne somme que l'exercice N-1. Si N-2 n'a jamais été clôturé, les à-nouveaux de N oublient ses soldes, et le reporting, qui part des à-nouveaux, les perd sans le signaler. | À traiter dans le module de clôture : refuser la génération ou borner le cumul. | revue rf-compta |
| T17 | Clôture : `contrepasser` rattache la pièce contrepassée à l'exercice de la pièce d'origine, alors qu'elle est datée de la journée en cours. | Le reporting borne désormais par la date de la pièce. Le rattachement est à corriger dans le module de clôture. | revue rf-compta |
| T18 | Données importées : l'écran masque la prévisualisation aux lecteurs, alors que le backend l'autorise (READ). | Plus strict, voulu. | L6b |
| T19 | Balance de reporting tant que N-1 n'est pas clôturé : les classes 1-5 sont cumulées depuis l'origine et les classes 6-7 depuis N. Le résultat de N-1 manque donc et le bilan est déséquilibré de ce montant. La compta l'expose (`resultatAnterieurNonAffecte`, `clotureAnterieureManquante`). Faut-il afficher une ligne « résultat en instance » au bilan, ou seulement une alerte ? | Exposé côté compta ; l'affichage au bilan est à décider (lot de suivi côté reporting). | revue rf-compta |

## Lot H (2026-10-25) : indicateurs financiers UEMOA IND-F01 à IND-F19

Les 19 indicateurs de `UEMOA-REP-IND-FIN` sont calculés par des **variables nommées** (lignes `VAR_*` du même rapport, section « Variables de calcul »), chacune avec sa source documentée. Une donnée absente donne « Donnée indisponible : <variable> » (jamais 0, jamais « Formule non définie »).

| # | Point | Retenu provisoirement | À valider |
|---|---|---|---|
| H1 | **Moyenne de période** (IND-F09 à F13) : le texte demande l'encours, les fonds propres et l'actif « moyens ». | (clôture N-1 + date de calcul) / 2, sur la balance d'ouverture (31/12 N-1) ; sans balance d'ouverture, « Donnée indisponible » (jamais la moitié de la clôture). | Moyenne sur 2 points suffisante, ou moyenne mensuelle ? |
| H2 | **Annualisation** : en cours d'année (mensuel, trimestriel), CE, FG et RE sont cumulés depuis le 1er janvier alors que les normes F09 à F13 (et F03) sont annuelles. | Aucun prorata : le ratio est celui de la période cumulée. | Faut-il annualiser (× 12 / mois écoulés) ? |
| H3 | **PE et CE** : PE = comptes 70, 71, 72, 73, 75, 76 ; CE = 60 à 66 ; subventions (74), 67, 69 et 77 exclus (note « À CONFIRMER » du paquet). | Comptes du paquet, lus signés (contre-comptes 6119, 6219, 7119 en déduction). | Périmètre exact de PE et CE (67, 69, 77 ?). |
| H4 | **Encours brut** (F03, F09 à F11, base de F01 côté comptabilité) : B2D + B2N + B30 + B40 + crédits en souffrance bruts (291 à 294). B70 est net de provisions, le texte parle de « brut ». IND-F03 passe sur ce brut (avant : B70 net, donc sous-estimé du montant des provisions). | Brut = B70 + provisions 2991 à 2993. B2N (comptes ordinaires débiteurs) reste dans la somme comme dans le texte « B2D à B70 ». | Confirmer B2N dans le portefeuille de prêts. |
| H5 | **Provisions sur créances en souffrance** (F02) : 2991, 2992, 2993 seulement (ce que B70 déduit) ; 2994 et suivants non repris. | Comptes 2991 à 2993 / comptes 291 à 294. | Autres comptes de provisions à inclure ? |
| H6 | **PAR (IND-F01)** : le paquet donne 3 normes (30 j < 5 %, 90 j < 3 %, 180 j < 2 %) pour une seule ligne. La ligne affiche le PAR 30 jours et la première norme. Les CRD de plus de 90 et 180 jours sont disponibles (`VAR_CRD_RETARD_90/180`) mais non comparés à leur norme. | PAR 30 j = CRD des tranches de retard de plus de 30 jours / encours brut (module Crédit, situation du jour). | Une ligne par seuil (F01-30, F01-90, F01-180) ? |
| H7 | **Nombre d'épargnants** (F05) : le module Épargne compte les épargnants des comptes d'épargne ; l'encours de dépôts (numérateur) inclut aussi comptes à terme et tontine. | Rapport encours total / épargnants actifs (confiance BASSE). | Élargir le comptage aux comptes à terme. |
| H8 | **Clients actifs** (F08, « au moins un dépôt ou un crédit en cours ») : le module Client ne le fournit pas (`etatClient = ACTIF` est un statut administratif, pas une activité). Il faut l'union des clients ayant un dépôt ou un crédit en cours (Crédit ∪ Épargne), sans double compte. | **Non branché** : F08 sort « Donnée indisponible : Nombre de clients actifs ». | Endpoint de codes clients actifs dans Crédit et Épargne, union côté reporting. |
| H9 | **Décaissements de la période** (F04) : le texte donne « mouvements au débit des comptes de crédit », que la balance cumulée ne permet pas d'isoler (reclassements inclus). | **Non branché** (flux Crédit : `GET /reporting/decaissements`, à créer). F04 sort « Donnée indisponible : Montant des crédits décaissés ». | Source : décaissements validés du module Crédit. |
| H10 | **Valeurs du jour** : effectif, emprunteurs, épargnants, encours Crédit/Épargne et tranches de retard sont la situation du jour (pas d'historique) : les ratios concernés sont marqués « à la date du jour » et n'ont pas de valeur N-1. | Marquage existant. | Historiser les compteurs côté modules. |
| H11 | **Productivité du personnel et des agents** (F07, F08) : F07 = emprunteurs actifs / gestionnaires de crédit ayant au moins un emprunteur (pas tous les agents de crédit du module RH). | Clé existante `RDC-REP-030.EMPR_PAR_AGENT`. | Dénominateur = agents de crédit déclarés dans RH ? |
| H12 | **Contrainte CHECK `type_valeur`** (SQL Server) : l'enum `TypeValeur` a gagné des valeurs (MONTANT, NOMBRE, RATIO) ; la contrainte figée à la création de la table les refusait. | `@SansCheckEnum` sur `RapportFormule.typeValeur` (suppression de la contrainte au démarrage) ; la synchro des formules isole désormais chaque ligne (une ligne refusée n'abandonne plus le chargement). | — |
