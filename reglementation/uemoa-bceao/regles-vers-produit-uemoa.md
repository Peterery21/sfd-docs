# UEMOA / BCEAO — Table rôle comptable vers compte RCSFD

- Zone : UEMOA — norme comptable produit : RCS_SFD (Référentiel Comptable Spécifique des SFD de l'UMOA, version allégée, 1re éd., ISBN 978-2-916140-11-7 ; instauré par Instr. BCEAO n°025-02-2009)
- Date de rédaction : 2026-10-13 — Rédacteur : Claude (agent de rédaction UEMOA/BCEAO)
- Usage : alimenter `roles-comptables.yml` de la norme RCS_SFD. Aucun compte déduit par analogie : « NON DÉFINI PAR LE TEXTE » quand le RCSFD est muet. Pagination = imprimée du RCSFD (page PDF = imprimée + 2). Les libellés sont ceux du plan (p.29-40) ou du contenu des comptes (p.43-113).
- Rappel : les SFD peuvent subdiviser les comptes généraux et codifier librement les auxiliaires (Instr. 026-02-2009 art. 3 et 6) ; le numéro à retenir pour un rôle est donc le compte général, le sous-compte exact étant un choix du SFD tant que le solde correspond.
- Colonne « statut » : TEXTE (compte nommé pour ce rôle), CHOIX (plusieurs comptes possibles, le texte ne tranche pas), NON DÉFINI.

| rôle comptable | numéro RCSFD | libellé exact RCSFD | statut | règle id / page |
|----|----|----|----|----|
| CAISSE | 101 (1011) | « Billets et monnaies » (1011 « Billets et monnaies émis par la BCEAO ») ; rubrique 10 « Valeurs en caisse » | TEXTE | UEMOA-CPT-011, p.44 |
| BANQUE | 1141 | « Banques et correspondants » (114) ; autres : 1131 « Centre des Chèques postaux », 1151 « Établissements financiers » (contenu p.45), 1161 « Systèmes Financiers Décentralisés » | TEXTE | UEMOA-CPT-012, p.45-46 |
| MOBILE_MONEY | NON DÉFINI PAR LE TEXTE | Aucun compte « monnaie électronique / mobile money ». Renvoi générique p.43 : opérations de classe 1 non classables par nature d'agent → 1171 « Autres institutions financières » (117) | NON DÉFINI (repli 1171 à valider) | UEMOA-CPT-013, p.43, p.47 |
| COMPTE_VUE | 2511 | « Comptes ordinaires » (251) | TEXTE | UEMOA-EPA-005, p.59 |
| EPARGNE_LIVRET | 2512 ou 2531 | 2512 « Comptes ordinaires sur livret » ; 2531 « Compte d'épargne sur livret » (253 « Comptes d'épargne à régime spécial ») | CHOIX | UEMOA-EPA-006, -008, p.59, p.61 |
| DEPOT_A_TERME | 2521 | « Dépôts à terme reçus » (252) | TEXTE | UEMOA-EPA-007, p.60 |
| DEPOT_GARANTIE | 2545 | « Dépôts de garantie reçus » (254) | TEXTE | UEMOA-EPA-009, p.61 |
| AUTRES_DEPOTS_MEMBRES | 2551 | « Autres dépôts reçus » (255) — réservé, selon le texte, aux institutions non autorisées à recevoir des dépôts à vue (dépôts affectés) | TEXTE conditionnel | UEMOA-EPA-010, p.61 |
| FONDS_NON_IMPUTES_MEMBRES (complément) | 2725 | « Divers » (272 « Autres sommes dues aux membres, bénéficiaires ou clients ») | TEXTE | UEMOA-CPT-017, p.63 |
| TONTINE_COTISATIONS / CAGNOTTE | NON DÉFINI PAR LE TEXTE | — (voir questions-ouvertes.md Q5) | NON DÉFINI | — |
| EPARGNE_PLANIFIEE | NON DÉFINI PAR LE TEXTE | — (candidats 253 / 2512 / 2551 non tranchés) | NON DÉFINI | questions-ouvertes.md Q5 |
| CREDIT_COURT_TERME | 2022 | « Crédits ordinaires » (202 « Crédits à court terme » : durée initiale <= 12 mois) ; 2023 « Découverts » (agents salariés) | TEXTE | UEMOA-CRE-002, p.58 |
| CREDIT_MOYEN_TERME | 2031 (203) | « Crédits à moyen terme » (203 : > 12 mois et <= 36 mois) | TEXTE | UEMOA-CRE-002, p.58 |
| CREDIT_LONG_TERME | NON DÉFINI PAR LE TEXTE | Pas de compte > 36 mois dans la version allégée (7021 et les ratios citent le long terme) | NON DÉFINI | UEMOA-CRE-002 |
| CREANCE_RATTACHEE_CREDIT | 20227 / 2037 | « Créances rattachées » | TEXTE | UEMOA-CRE-005, p.58 |
| CREANCE_SOUFFRANCE | 291, 292, 293, 294 | 291 « Crédits immobilisés » ; 292 « Crédits en souffrance de 6 mois au plus » ; 293 « … de plus de 6 mois à 12 mois au plus » ; 294 « … de plus de 12 mois à 24 mois au plus » (rubrique 29 « Comptes de crédits en souffrance ») | TEXTE | UEMOA-CRE-009, p.64-65 |
| PROVISION_CREANCE | 2991, 2992, 2993 | « Provisions sur crédits en souffrance de 6 mois au plus » (40 %) ; « … de plus de 6 mois à 12 mois au plus » (80 %) ; « … de plus de 12 mois à 24 mois au plus » (100 %) (299 « Provisions sur crédits en souffrance ») | TEXTE | UEMOA-CRE-013, -014, p.65-66 |
| DOTATION_PROVISION | 664 | « Dotations aux provisions sur créances en souffrance » : 6641 (66411 de 0 à 3 mois, 66412 de plus de 3 à 6 mois), 6642 (plus de 6 à 12 mois), 6643 (plus de 12 à 24 mois) | TEXTE | UEMOA-CRE-014, p.103 ; plan p.37-38 |
| REPRISE_PROVISION | 764 | « Reprises de provisions sur créances en souffrance » | TEXTE | UEMOA-CRE-014, p.113 |
| PERTE_CREANCE_IRRECOUVRABLE | 669 | « Pertes sur créances irrécouvrables » | TEXTE | UEMOA-CRE-015, p.103 |
| RECUPERATION_CREANCE_AMORTIE | 769 | « Récupération sur créances amorties » | TEXTE | UEMOA-CRE-015, p.113 |
| PRODUIT_INTERET_CREDIT | 7021 | « Intérêts sur crédits aux membres, bénéficiaires ou clients » (702 « Produits sur opérations avec les membres, bénéficiaires ou clients ») | TEXTE | UEMOA-CRE-005, p.107 |
| PRODUIT_COMMISSION | 7029 | « Commissions (Cotisations et droits d'adhésion, commissions) » | TEXTE | UEMOA-CPT-023, p.108 |
| PRODUIT_FRAIS_DOSSIER | 7029 | idem (« notamment les frais de gestion des dossiers de crédit ») | TEXTE | UEMOA-CRE-007, p.108 |
| PRODUIT_PENALITE | 7028 | « Autres intérêts » (intérêts de retard et moratoires avec les membres) ; pénalité forfaitaire : NON DÉFINI PAR LE TEXTE | TEXTE (prorata temporis) / NON DÉFINI (forfaitaire) | UEMOA-CRE-006, p.107 |
| PRODUIT_INTERET_COMPTE_DEBITEUR | 7025 | « Intérêts sur comptes des membres, bénéficiaires ou clients » (créances rattachées 25117) | TEXTE | UEMOA-EPA-012, p.107 |
| CHARGE_INTERET_MEMBRES | 6025 | « Intérêts sur comptes des membres, bénéficiaires ou clients » : 60251 « Intérêts sur comptes ordinaires créditeurs » (602511 comptes de chèques, 602512 sur livrets) ; 60252 « Intérêts sur dépôts à terme reçus » ; 60253 « Intérêts sur comptes d'épargne à régime spécial » ; 60254 « Intérêts sur dépôts de garantie reçus » ; 60255 « Intérêts sur autres dépôts reçus » | TEXTE | UEMOA-CPT-024, p.93 ; plan p.36 |
| DETTE_RATTACHEE_MEMBRES | 25116, 25126, 2526, 25316, 2546, 2556 | « Dettes rattachées » de 2511, 2512, 2521, 2531, 2545, 2551 | TEXTE | UEMOA-EPA-012, p.59-62 |
| CHARGE_COMMISSION_MEMBRES | 6029 | « Commissions » (602) | TEXTE | UEMOA-CPT-024, p.93 |
| CAPITAL_PARTS_VERSE | 57111 | « Capital souscrit appelé versé » (5711 « Capital souscrit appelé » ; 571 « Capital ») | TEXTE | UEMOA-PAR-006, p.88 |
| CAPITAL_APPELE_NON_VERSE | 57112 | « Capital souscrit appelé non versé » | TEXTE | UEMOA-PAR-006, p.88 |
| CAPITAL_NON_APPELE | 5712 (et 5731 côté membres) | « Capital non appelé » (plan) / « Capital souscrit non appelé » (contenu) ; 5731 « Actionnaires, associés ou membres, capital souscrit non appelé » ; 5732 « … capital souscrit appelé non versé » | TEXTE | UEMOA-PAR-006, -008, p.88 |
| RESERVE_GENERALE | 5521 | « Réserve générale » (contenu : « Réserves générales ») | TEXTE | UEMOA-PAR-010, p.86 |
| REPORT_A_NOUVEAU | 58 | « Report à nouveau » | TEXTE | UEMOA-PAR-010, p.89 |
| RESULTAT_EXERCICE | 592 | « Excédent ou déficit de l'exercice » (après approbation) ; 591 « Excédent ou déficit en instance d'approbation » (compte de clôture des classes 6 et 7) | TEXTE | UEMOA-CPT-025, p.89 |
| DIVIDENDES_RISTOURNES_A_PAYER | NON DÉFINI PAR LE TEXTE | Distribution par crédit des comptes de membres (réserves distribuées ; report à nouveau mis en distribution) ; pas de compte « à payer » nommé | NON DÉFINI | UEMOA-PAR-011, p.87, p.89 |
| GAIN_CHANGE | NON DÉFINI PAR LE TEXTE | Opérations en devises non autorisées dans la version lue (p.44) | NON DÉFINI | UEMOA-CPT-010 |
| PERTE_CHANGE | NON DÉFINI PAR LE TEXTE | Seule mention : provision 519 « Autres provisions pour risques et charges » (pertes de change sur devises à marché peu liquide) | NON DÉFINI | UEMOA-CPT-027, p.84 |
| ATTENTE_ACTIF | 3791 | « Comptes d'attente - actif » (379 « Comptes d'attente ») — hors opérations avec membres et institutions financières | TEXTE | UEMOA-CPT-016, p.72 |
| ATTENTE_PASSIF | 3792 | « Comptes d'attente - passif » | TEXTE | UEMOA-CPT-016, p.72 |
| ECART_CAISSE_EXCEDENT / MANQUANT | 3791 / 3792 jusqu'à décision ; excédents définitifs : 771 « Produits exceptionnels » | manquants : compte de charge définitif NON DÉFINI | TEXTE (transit et excédent) / NON DÉFINI (manquant) | UEMOA-CPT-018, p.21, p.72, p.113 |
| PRODUIT_EXCEPTIONNEL / CHARGE_EXCEPTIONNELLE | 771 / 671 | « Produits exceptionnels » ; « Charges exceptionnelles » | TEXTE | p.113, p.104 |
| FRAIS_TENUE_COMPTE | NON DÉFINI PAR LE TEXTE (7029 « autres opérations » possible, non nommé) | — | NON DÉFINI | questions-ouvertes.md Q3 |
| PENALITE_RETRAIT_ANTICIPE_DAT | NON DÉFINI PAR LE TEXTE | — | NON DÉFINI | questions-ouvertes.md Q3 |
| PRIME_ASSURANCE_CREDIT (collectée) | NON DÉFINI PAR LE TEXTE | 6215 « Primes d'assurance » est une charge d'exploitation du SFD, pas la prime collectée auprès des membres | NON DÉFINI | UEMOA-CRE-018 |
| AVOIRS_DORMANTS_TRANSFERES_BCEAO | NON DÉFINI PAR LE TEXTE | — | NON DÉFINI | dormants-conservation.md |

## Écarts à signaler au référentiel interne

- 6871 / 4912 (dotation / dépréciation OHADA) : absents du RCSFD ; remplacés par 664 / 299.
- 165xxx, 161xxx : dépôts d'**institutions financières** (classe 1), pas des membres.
- 773, 7713, 6741, 776000, 676000 : NON TROUVÉS dans le RCSFD.
- Le RCSFD allégé lu ne donne pas les sous-comptes à 6 chiffres du plan interne (ex. 251100) ; le niveau de détail local relève de la subdivision libre (Instr. 026-02-2009 art. 3).
