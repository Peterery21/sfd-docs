# CEMAC — Règles vers produit : rôle comptable → compte PCEMF

- Zone : CEMAC / COBAC. Norme : PCEMF (janvier 2010). Date : 2026-10-13. Rédacteur : agent de recherche Claude.
- Usage : alimenter `config/accounting-norms/cemac/cobac/roles-comptables.yml` (gabarit décrit dans `sfd-docs` RCSFD §7). Aucun numéro RCSFD ni PCCI ne doit être repris. Chaque compte ci-dessous doit exister dans le plan `plan-comptable.yml` de la norme COBAC avant chargement : ATTENTION, l'inventaire local `PCEMF_PLAN_COMPTES_INVENTAIRE.md` omet 30, 31, 164, 443, 444, 477 ; ces comptes viennent du PDF PCEMF lu.
- Libellés recopiés du PCEMF. « Statut » : IMPOSÉ = le compte nommé est celui du plan pour cette nature d'opération ; CHOIX = le plan offre plusieurs comptes ou aucun mapping de produit ; NON DÉFINI PAR LE TEXTE = muet.
- Règles : identifiants des fichiers thème (CEMAC-CPT, EPA, CRD, PAR, CLO).

| RÔLE | compte PCEMF | libellé exact | règle(s) | statut / remarque |
|---|---|---|---|---|
| CAISSE | 5710 (sous 571) | « Caisse FCFA » (571 « Billets et Monnaies ») ; devises : 5711 « Caisse devises » | CEMAC-CPT-008 | IMPOSÉ (compte) ; une caisse par session/agence = CHOIX (sous-compte) |
| BANQUE | 560 (par type de correspondant : 5602 / 5603 / 5609) | « Comptes à vue nostri » (5602 « Banques associées », 5603 « Banques non associées », 5609 « EMF ») | CEMAC-CPT-009 | IMPOSÉ (classe 56) ; sous-compte selon la banque = CHOIX |
| MOBILE_MONEY | — | NON DÉFINI PAR LE TEXTE | — | Aucun compte spécifique dans le PCEMF ; Règl. 04/18 (services de paiement) non lu |
| COMPTE_VUE | 3711 / 3712 | « Comptes courants sociétaires » / « Comptes courants clients » (371 « Comptes courants ») ; alt. 372 « Comptes de chèques » | CEMAC-EPA-007 | IMPOSÉ (classe 37) ; 3711 vs 3712 selon que le titulaire est sociétaire ou client |
| EPARGNE_LIVRET | 373 | « Comptes sur livrets » | CEMAC-EPA-007 | IMPOSÉ ; pas de sous-compte sociétaire/client dans le plan |
| DEPOT_A_TERME | 361 | « Dépôts à terme » (369 « Dettes rattachées ») | CEMAC-EPA-004 | IMPOSÉ |
| DEPOT_GARANTIE | 3741 / 3742 | « Dépôts de garantie sociétaires » / « Dépôts de garantie clients » (374 « Dépôts de garantie ») | CEMAC-EPA-009 | IMPOSÉ pour les dépôts de garantie de clientèle |
| AUTRES_DEPOTS_MEMBRES | 355 (candidat) | « Autres comptes d'épargne à régime spécial » | CEMAC-EPA-010 | NON DÉFINI PAR LE TEXTE pour tontine / épargne planifiée ; 355 = CHOIX (conventions particulières) |
| BONS_DE_CAISSE (si offert) | 351 | « Bons de caisse » | CEMAC-EPA-010 | IMPOSÉ |
| AVANCE_SUR_DAT | 3751 / 3752 | « Avances sur DAT aux sociétaires » / « Avances sur DAT aux clients » (375 « Avances sur dépôts à terme ») | CEMAC-EPA-006 | IMPOSÉ (crédit, ne se déduit pas de 361) |
| COMPTE_BLOQUE | 382 | « Comptes bloqués » | CEMAC-EPA-013 | IMPOSÉ |
| AVOIRS_PRESCRIPTION | 383 | « Avoirs en cours de prescription » | CEMAC-DOR-011 | IMPOSÉ (libellé) ; fonctionnement non décrit |
| CREDIT_LONG_TERME | 30 (3011 clients, 3031…) | « Crédits à long terme » (ex. 3031 « Crédits LT/MT à l'équipement aux clients ») | CEMAC-CRD-002, 005 | IMPOSÉ pour durée initiale > 2 ans ; nature = CHOIX |
| CREDIT_MOYEN_TERME | 31 (3131 …) | « Crédits à moyen terme » (ex. 3131 « Crédits LT/MT à l'équipement aux clients », 3181 « Autres crédits LT/MT aux clients ») | CEMAC-CRD-002, 005 | IMPOSÉ pour durée > 1 an et ≤ 2 ans (incohérence PCEMF signalée) |
| CREDIT_COURT_TERME | 3221 / 3222 (trésorerie), 3231 / 3232 (équipement), 3261 (consommation), 3282 | « Crédits de trésorerie aux sociétaires / aux clients », « Crédits à l'équipement aux sociétaires / aux clients », « Crédits à la consommation aux clients », « Autres crédits à CT aux clients » | CEMAC-CRD-002, 005 | IMPOSÉ pour durée ≤ 1 an ; nature (322, 323, 325, 326, 328) = CHOIX de produit |
| CREANCES_RATTACHEES_CREDIT | 329 (CT), 309 / 319 (LT/MT) | « Créances rattachées aux crédits à CT » ; « Créances rattachées aux crédits à LT/MT » | CEMAC-CRD-006 | IMPOSÉ |
| CREANCE_SOUFFRANCE | 331 impayées ; 335 / 3351-3352 autres douteuses ; 334 sûretés réelles ; 333 garantie État | « Créances impayées » ; « Autres créances douteuses » ; « Créances douteuses couvertes par des sûretés réelles » ; « Créances douteuses couvertes par la garantie de l'Etat » (33 « Créances en souffrance ») | CEMAC-CRD-009, 010 | IMPOSÉ (plan) ; seuils de passage sous R-2017/07 non lus |
| PROVISION_CREANCE | 393 (3931 / 3932 / 3933), 392 (3921-3924), 391 | « Provisions sur autres créances douteuses » (depuis moins d'un an / 1 à 2 ans / plus de 2 ans) ; « Provisions sur créances douteuses couvertes par des sûretés réelles » ; « … par la garantie de l'Etat » | CEMAC-CRD-012 | IMPOSÉ (plan) ; taux sous R-2017/07 non lus |
| DOTATION_PROVISION | 6913 | « Dotations aux provisions pour dépréciation des comptes de clientèle » | CEMAC-CPT-017 | IMPOSÉ ; reprise : 7913 « Reprises de provisions pour dépréciation des comptes de clientèle » |
| PERTE_CREANCE | 6921 / 6922 | « Pertes sur créances irrécouvrables couvertes par des provisions » / « … non couvertes par des provisions » | CEMAC-CPT-018, CRD-014 | IMPOSÉ |
| PRODUIT_INTERET_CREDIT | 711 / 712 / 713 | « Intérêts sur les crédits à long terme » / « … moyen terme » / « … court terme » | CEMAC-CRD-006 | IMPOSÉ selon la durée du crédit |
| INTERETS_HORS_BILAN | 9841 | « Intérêts sur créances en souffrance » | CEMAC-CRD-011 | IMPOSÉ (hors-bilan) |
| PRODUIT_COMMISSION | 715 (7151 / 7152 / 7153) | « Commissions sur opérations avec la clientèle » (« Commissions sur crédits à long terme / moyen terme / court terme ») | CEMAC-CRD-007 | CHOIX pour frais de dossier / assurance (non nommés par le plan) ; 720 « Commissions de tenue de compte » pour les frais de compte |
| PRODUIT_PENALITE | — | NON DÉFINI PAR LE TEXTE | CEMAC-CRD-007 | Aucun compte de pénalités dans le PCEMF |
| CHARGE_INTERET_MEMBRES | 612 / 613 / 614 | « Intérêts sur dépôts à terme » / « Intérêts sur comptes sur livrets » / « Intérêts sur autres comptes à vue » (611 régime spécial, 619 autres) | CEMAC-EPA-011 | IMPOSÉ selon le type de dépôt |
| DETTES_RATTACHEES_DEPOTS | 369 (DAT), 359 (régime spécial), 378 (vue/livret) | « Dettes rattachées » ; « Créances ou dettes rattachées » | CEMAC-EPA-011 | IMPOSÉ (378 libellé groupé créances/dettes) |
| CAPITAL_PARTS_VERSE | 1000 (1re et 3e catégories) ; 1013 (2e catégorie) | « Parts sociales souscrites appelées versées » ; « Capital souscrit appelé versé non amorti » | CEMAC-PAR-002 | IMPOSÉ selon forme juridique |
| CAPITAL_PARTS_NON_VERSE | 1001 ; contrepartie 4411 / 4413 | « Parts sociales souscrites appelées non versées » ; « Sociétaires, apports en numéraire » | CEMAC-PAR-003 | IMPOSÉ (comptes), mécanique d'appel à confirmer |
| FRAIS_ADHESION | 7551 | « Droits d'adhésion des sociétaires » | CEMAC-PAR-005 | IMPOSÉ (produit, pas du capital) |
| RESERVE_LEGALE | 111 | « Réserves légales » | CEMAC-PAR-006 | IMPOSÉ |
| RESERVE_OBLIGATOIRE | 112 | « Réserves obligatoires et réglementaires » | CEMAC-PAR-007 | IMPOSÉ |
| FONDS_SOLIDARITE | 160 | « Fonds de solidarité réglementaire » | CEMAC-PAR-008 | IMPOSÉ (1re catégorie) |
| DIVIDENDES_A_PAYER | 443 | « Actionnaires, dividendes à payer » | CEMAC-PAR-011 | IMPOSÉ |
| RISTOURNES_A_VERSER | 444 | « Sociétaires, ristournes à verser » | CEMAC-PAR-011 | IMPOSÉ (compte) ; règle de calcul NON TROUVÉE |
| REPORT_A_NOUVEAU | 121 / 122 | « Report à nouveau créditeur » / « Report à nouveau débiteur » | CEMAC-PAR-012 | IMPOSÉ |
| RESULTAT_EXERCICE | 131 / 132 (compte 13) | « Bénéfice de l'exercice » / « Perte de l'exercice » (13 « Résultat net de l'exercice ») ; avant clôture : 87 « Résultat net avant certification » | CEMAC-CLO-009, CPT-022 | IMPOSÉ |
| GAIN_CHANGE | 723 (principal) ; 7411 (accessoire) | « Commissions et profits sur opérations de change effectuées à titre principal » ; « Produits sur opérations de change » | CEMAC-CPT-013 | IMPOSÉ ; principal vs accessoire = dépend de l'agrément/opérations (01/17 non lu) |
| PERTE_CHANGE | 623 (principal) ; 6411 (accessoire) | « Commissions, frais et pertes sur opération de change effectuées à titre principal » ; « Charges sur opérations de change » | CEMAC-CPT-013 | IMPOSÉ ; idem |
| POSITION_CHANGE | 475 / 476 / 477 | « Position de change » ; « Contre valeur de la position de change » ; « Compte d'ajustement devises » | CEMAC-CPT-012 | IMPOSÉ |
| LIAISON_AGENCES | 451 / 452 / 459 | « Siège et agences locales/organe faîtier et EMF affiliés » ; « Comptes de liaison entre agences ou entre EMF affiliés » ; « Mouvements de fonds et autres virements internes » | CEMAC-CPT-008, 011 | IMPOSÉ ; 459 solde nul en fin de journée |
| ECART_CAISSE_MANQUANT | 4631 puis 6795 | « Erreurs (manquants) » ; « Déficits de caisse non récupérés » | CEMAC-CPT-010 | IMPOSÉ |
| ECART_CAISSE_EXCEDENT | 4632 puis 7786 | « Erreurs (excédents) » ; « Excédents de caisse » | CEMAC-CPT-010 | IMPOSÉ (ne pas virer en produits d'exploitation d'emblée) |
| ATTENTE_ACTIF | — (candidats : 387 ; 468) | « Valeurs non imputées » ; « Autres débiteurs et créditeurs » | CEMAC-CPT-011 | NON DÉFINI PAR LE TEXTE (rôle générique « attente actif ») ; 387 a un usage précis (effets déplacés) |
| ATTENTE_PASSIF | — (candidats : 384 / 3841 ; 381) | « Autres sommes dues à la clientèle » / « Autres sommes dues » ; « Dispositions à payer » | CEMAC-CPT-011 | NON DÉFINI PAR LE TEXTE (rôle générique « attente passif ») |
| REGULARISATION_ACTIF / PASSIF | 4711, 4712 / 4721, 4722 | « Charges payées ou comptabilisées d'avance » ; « Produits à recevoir » / « Charges à payer » ; « Produits perçus ou comptabilisés d'avance » | CEMAC-CPT-019 | IMPOSÉ |

## Choix de produit (hors réglementation)

- Toute ligne « CHOIX » ou « NON DÉFINI PAR LE TEXTE » doit être arbitrée par l'institution ou validée par la COBAC avant seed ; en l'absence de validation, la norme COBAC ne doit pas être activée pour ces rôles (principe RCSFD §7 : refuser plutôt que remplir avec un compte d'une autre norme).
- Les sous-comptes à 5 positions (hors réseau « 0 », réseau « 9 ») existent pour les comptes de réseau ; une institution hors réseau n'utilise que les comptes à 3-4 chiffres du plan.

## Lacunes / à confirmer

- Classification et provisionnement (CREANCE_SOUFFRANCE, PROVISION_CREANCE) : à revérifier sur R-2017/07.
- Comptes de mobile money, tontine, pénalités, frais de dossier : aucune source.
- Version du PCEMF postérieure à janvier 2010 : non trouvée.
