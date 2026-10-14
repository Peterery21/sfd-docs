# Réglementation et référentiel fonctionnel — EDIP (microfinance / SFD)

Constitué le 2026-10-13 (branche `docs/reglementation`). Index machine : [index.json](index.json) (id, zone, thème, source, URL, confiance, statut de vérification, fichier). Régénération : `python3 outils/build_index.py [--apply]`. Format des fichiers : [FORMAT.md](FORMAT.md). Glossaire : [GLOSSAIRE.md](GLOSSAIRE.md). **Réponses aux 6 questions du référentiel interne : [REPONSES-6-QUESTIONS.md](REPONSES-6-QUESTIONS.md).** Rôle → compte par norme : [regles-vers-produit/](regles-vers-produit/README.md).

## 1. Zones supportées par le produit (traitées)

| Zone / norme produit | Dossier | Règles sourcées | HAUTE / MOY. / BASSE | Vérification ✔ / ◐ / ✘ / ? | Statut |
|---|---|---|---|---|---|
| UEMOA-BCEAO — `RCS_SFD` | [uemoa-bceao/](uemoa-bceao/README.md) | 144 | 124 / 17 / 3 | 92 / 52 / 0 / 0 | traité, vérifié |
| CEMAC-BEAC — `COBAC` (PCEMF) | [cemac-beac/](cemac-beac/README.md) | 144 | 135 / 7 / 2 | 25 / 117 / 1 / 1 | traité, vérifié |
| RDC-BCC — `PCCI` (GCEC non utilisé SFD) | [rdc-bcc/](rdc-bcc/README.md) | 128 | 49 / 74 / 5 | 70 / 51 / 7 / 0 | traité, vérifié |
| OHADA — `SYSCOHADA` / `SYCEBNL` (entités non SFD) | [syscohada-sycebnl/](syscohada-sycebnl/README.md) | 109 | 63 / 41 / 5 | 45 / 63 / 1 / 0 | traité, vérifié (SYCEBNL : plan complet non lu) |
| CUSTOM (wizard) | — | — | — | — | sans réglementation propre : voir lacunes |
| **Total** | | **525** | | **232 / 283 / 9 / 1** | |

Les 9 ✘ ont été corrigés dans les fichiers après vérification (références d'articles de la loi RDC 002/2002 ; libellé du compte 373 PCCI ; date du Règl. CEMAC 04/19 ; art. AUDCIF 72). Ils restent marqués ✘ (champ `corrige_apres_verif` dans `index.json`) tant qu'ils n'ont pas été re-vérifiés. Les listes d'écarts restantes sont dans [verification/](verification/).

Textes fondateurs inventoriés (README de chaque zone) : UEMOA ≈ 35 entrées (18 lues au moins en partie : loi uniforme SFD 2007, Instr. 025/026/030-02-2009, 007/005/006-06-2010, 010-08-2010, 021/020-12-2010, comptes dormants 2012 et 005-06-2014, LBC/FT Décision 26/2015 et Instr. 007-09-2017, usure Décision 19 du 29/12/2025) ; CEMAC ≈ 25 (PCEMF 2010, Règl. 01/02, 01/17, COBAC EMF 2002/…, Règl. 04/19 TEG, Règl. 01/03 LBC, Règl. 02/25 comptes inactifs) ; RDC ≈ 13 (lois 002/2002, 003/2002, 11/020 ; Instr. BCC 002-006, 009-011, 15/15 bis, 37, 38, 40 ; loi LBC 22/068 non lue) ; OHADA 5 (AUDCIF 2017, AUSCGIE 2014, SYCEBNL 2022/2024, guide SYCEBNL, PCG révisé). Les chiffres exacts figurent dans chaque README.

## 2. Index par thème

| Thème | UEMOA | CEMAC | RDC | OHADA |
|---|---|---|---|---|
| Comptabilité / plan et enregistrement | [lien](uemoa-bceao/comptabilite.md) | [lien](cemac-beac/comptabilite.md) | [lien](rdc-bcc/comptabilite.md) | [lien](syscohada-sycebnl/comptabilite.md) |
| Épargne / dépôts des membres | [lien](uemoa-bceao/epargne.md) | [lien](cemac-beac/epargne.md) | [lien](rdc-bcc/epargne.md) | n/a |
| Crédit (classification, provisions, intérêts) | [lien](uemoa-bceao/credit.md) | [lien](cemac-beac/credit.md) | [lien](rdc-bcc/credit.md) | n/a |
| Parts sociales, dividendes, ristournes | [lien](uemoa-bceao/parts-sociales.md) | [lien](cemac-beac/parts-sociales.md) | [lien](rdc-bcc/parts-sociales.md) | [lien](syscohada-sycebnl/parts-sociales.md) |
| Clôtures | [lien](uemoa-bceao/clotures.md) | [lien](cemac-beac/clotures.md) | [lien](rdc-bcc/clotures.md) | [lien](syscohada-sycebnl/clotures.md) |
| Prudentiel / reporting | [lien](uemoa-bceao/prudentiel.md) | [lien](cemac-beac/prudentiel.md) | [lien](rdc-bcc/prudentiel.md) | n/a |
| LBC/FT, KYC | [lien](uemoa-bceao/lbc-ft.md) | [lien](cemac-beac/lbc-ft.md) | [lien](rdc-bcc/lbc-ft.md) | n/a |
| Taux d'intérêt / usure | [lien](uemoa-bceao/taux-usure.md) | [lien](cemac-beac/taux-usure.md) | [lien](rdc-bcc/taux-usure.md) | n/a |
| Comptes dormants, conservation | [lien](uemoa-bceao/dormants-conservation.md) | [lien](cemac-beac/dormants-conservation.md) | [lien](rdc-bcc/dormants-conservation.md) | [lien](syscohada-sycebnl/conservation.md) |
| Questions ouvertes (zone) | [lien](uemoa-bceao/questions-ouvertes.md) | [lien](cemac-beac/questions-ouvertes.md) | [lien](rdc-bcc/questions-ouvertes.md) | [lien](syscohada-sycebnl/questions-ouvertes.md) |
| Rôle → compte (copie de zone) | [lien](uemoa-bceao/regles-vers-produit-uemoa.md) | [lien](cemac-beac/regles-vers-produit-cemac.md) | [lien](rdc-bcc/regles-vers-produit-rdc.md) | [lien](syscohada-sycebnl/regles-vers-produit-ohada.md) |

SYCEBNL : [syscohada-sycebnl/sycebnl.md](syscohada-sycebnl/sycebnl.md).

## 3. Autres zones pertinentes (proposées, NON traitées)

| Zone | Autorité / texte pivot à étudier | Statut |
|---|---|---|
| Transpositions nationales UEMOA (BJ, BF, CI, GW, ML, NE, SN, TG) | lois/décrets nationaux SFD, autorités de tutelle (ministères des finances) | à faire |
| Nouvelle loi uniforme SFD UMOA (CM du 21/12/2023) | introuvable à ce jour | à faire (veille) |
| Règlements COBAC EMF R-2017/01 à 09 | non ouverts | à faire |
| Guinée (hors UEMOA) | BCRG, loi microfinance | à faire |
| Madagascar | CSBF, loi 2005-016 microfinance | à faire |
| Burundi, Rwanda | BRB ; BNR (loi 40/2008 microfinance) | à faire |
| Comores, Djibouti, Mauritanie | banques centrales respectives | à faire |
| Ghana, Nigeria, Kenya, Tanzanie, Ouganda (anglophones) | BoG ; CBN (Microfinance Policy) ; CBK (Microfinance Act 2006) ; BoT ; BoU (Tier 4 Act 2016) | à faire |
| GCEC RDC (banques) | plan seedé, hors périmètre SFD | à faire (hors périmètre) |
| Mobile money / monnaie électronique (UEMOA, CEMAC, RDC) | instructions BCEAO/COBAC/BCC monnaie électronique | à faire — impacte le rôle `MOBILE_MONEY`, NON DÉFINI dans 3 normes sur 4 |

## 4. Légende vérification
✔ confirmé par ≥ 2 sources indépendantes · ◐ 1 source (pas un doute, une seule source) · ✘ infirmé puis corrigé · ? non retrouvé. Vérification faite par des agents indépendants (un par zone, non informés des conclusions) ; « ✔ » n'est pas « vrai à vie » : les textes OCRisés (loi RDC 002/2002 et 003/2002, instructions UEMOA 010-08-2010, durées dormants) ont des numéros d'articles à recontrôler sur l'original.
