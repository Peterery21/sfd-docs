# OHADA (hors SFD) — Rôles du produit → comptes SYSCOHADA révisé

Zone : OHADA | Thème : correspondance produit | Rédigé le 2026-10-13 | Rédacteur : agent IA (Claude)
Libellés lus sur le PCG révisé reproduit par plan-comptable-ohada.com (secondaire). « NON DÉFINI PAR LE TEXTE » = l'Acte et le PCG lus ne fixent pas de compte pour ce rôle. Applicable aux entités non SFD (hors établissements de microfinance, OHADA-GEN-004). Aucune règle sans source ; les règles référencées sont dans comptabilite.md et questions-ouvertes.md.

| RÔLE | compte SYSCOHADA | libellé exact | id de règle | confiance |
|----|----|----|----|----|
| CAISSE | 571 (5711 en monnaie légale, 5712 en devises) | « CAISSE SIEGE SOCIAL » (classe 57 « Caisse ») | OHADA-CPT-030 | MOYENNE |
| BANQUE | 521 (5211) | « BANQUES LOCALES » (classe 52 « Banques ») | OHADA-CPT-031 | MOYENNE |
| MOBILE_MONEY | 552 | « MONNAIE ELECTRONIQUE- TELEPHONE PORTABLE » (classe 55 « Instruments de monnaie électronique ») — le texte ne cite pas « mobile money » | OHADA-CPT-032 | BASSE |
| CLIENTS | 411 (4111) | « CLIENTS » | OHADA-CPT-038 | MOYENNE |
| FOURNISSEURS | 401 | « FOURNISSEURS, DETTES EN COMPTE » | OHADA-CPT-037 | MOYENNE |
| CAPITAL | 101 (1013) | « Capital social » (1013 « Capital souscrit, appelé, versé, non amorti ») | OHADA-CPT-033 | MOYENNE |
| RESULTAT_EXERCICE | 13 : 131 bénéfice / 139 perte (130 en instance d'affectation) | « Résultat net de l'exercice » ; « RESULTAT NET : BENEFICE » ; « RESULTAT NET : PERTE » | OHADA-CPT-036 | MOYENNE |
| GAIN_CHANGE | 776 | « GAINS DE CHANGE » (traitement imposé : produits financiers) | OHADA-QO-001 | HAUTE (traitement) / MOYENNE (numéro) |
| PERTE_CHANGE | 676 | « PERTES DE CHANGE » (traitement imposé : charges financières) | OHADA-QO-001 | HAUTE (traitement) / MOYENNE (numéro) |
| DOTATION_PROVISION | 691 (exploitation) ; 697 (financières) ; 659 (risques à court terme d'exploitation) ; 681 pour amortissements | « DOTATIONS AUX PROVISIONS ET AUX DEPRECIATIONS D'EXPLOITATION » ; « DOTATIONS AUX PROVISIONS ET AUX DEPRECIATIONS FINANCIERES » ; « Charges pour dépréciations et provisions pour risques a court terme d'exploitation » — NON DÉFINI PAR LE TEXTE pour un seul compte « dotation » générique | OHADA-QO-007, OHADA-CPT-047, OHADA-CPT-048 | MOYENNE |
| PRODUIT_VENTE | 701 marchandises / 702 produits finis / 706 services vendus | « VENTES DE MARCHANDISES » ; « VENTES DE PRODUITS FINIS » ; « SERVICES VENDUS » — dépend de la nature de l'activité (NON DÉFINI PAR LE TEXTE pour un compte unique) | OHADA-CPT-045 | MOYENNE |
| TVA_COLLECTEE | 443 (4431 ventes, 4432 prestations de services) | « ETAT, T.V.A. FACTUREE » | OHADA-CPT-039 | MOYENNE |
| TVA_DEDUCTIBLE | 445 (4452 achats, 4451 immobilisations) | « ETAT, T.V.A. RECUPERABLE » | OHADA-CPT-040 | MOYENNE |
| ATTENTE_ACTIF | NON DÉFINI PAR LE TEXTE (aucun compte d'attente prescrit ; le plus proche : 4711) | 4711 « Débiteurs divers » (471 « DEBITEURS ET CREDITEURS DIVERS ») ; 475/4751 « Compte actif » réservé à la révision SYSCOHADA | OHADA-QO-009, OHADA-CPT-041, OHADA-CPT-042 | BASSE |
| ATTENTE_PASSIF | NON DÉFINI PAR LE TEXTE (plus proche : 4712) | 4712 « Créditeurs divers » ; 475/4752 « Compte passif » réservé à la révision | OHADA-QO-009, OHADA-CPT-041, OHADA-CPT-042 | BASSE |

Rôles complémentaires (voir questions-ouvertes.md) : écart de conversion actif 478 « ECARTS DE CONVERSION-ACTIF », passif 479 « ECARTS DE CONVERSION- PASSIF » (OHADA-QO-003) ; provision pour pertes de change 194 « PROVISIONS POUR PERTES DE CHANGE » (OHADA-QO-004, OHADA-CPT-049) ; réserve légale 111 « RESERVE LEGALE » (OHADA-PAR-007, OHADA-CPT-034).

## Choix de produit (hors réglementation)

- Choix entre 571/5711 et un sous-compte par caisse ; 552 ou 521-sous-compte pour le mobile money ; 4711/4712 pour l'attente : décisions produit.
- Rôle DOTATION_PROVISION : le produit doit distinguer au minimum exploitation / financier / HAO (classe 85 non lue).

## Lacunes / à confirmer

- Vérification de tous les libellés sur le PCG officiel annexé (non lu).
- Entités SFD : ce tableau ne leur est pas applicable ; voir les dossiers UEMOA/CEMAC/RDC.
