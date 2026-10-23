# OHADA — États financiers : SYSCOHADA révisé (système normal, SMT) et SYCEBNL

Zone : OHADA | Thème : états financiers (bilan, compte de résultat, TFT, notes annexes) | Rédigé le 2026-10-19 | Rédacteur : agent IA (Claude) — vérification : `?`

Objectif : pouvoir générer exactement les états depuis la balance. Companion machine-lisible : `paquet-draft.yml` (même dossier).

## Sources lues pour ce fichier

| id | source | ce qui a été lu | URL | confiance |
|----|----|----|----|----|
| S1 | Acte uniforme SYCEBNL, JO OHADA numéro spécial du 22/02/2023 (adopté Niamey 22/12/2022), 438 p. | **lu par OCR** : art. 1-28 (pp. 15-25), plan des comptes détaillé (pp. 75-105), Partie 4 « Présentation des états financiers » (pp. 339-437 : modèles Bilan, CR, TFT, TER, TEB, TRT, SMT, listes de notes) | https://www.ohada.com/uploads/actualite/6692/SYSCEBNL.pdf | HAUTE |
| S2 | AUDCIF 26/01/2017 (PDF droit-afrique, copie vie-publique.sn, 38 p.) | **lu par OCR** : art. 1-34 (art. 2, 5, 8-13, 21, 23-34) | https://www.vie-publique.sn/documents/11026/acte-uniforme-droit-comptable-information-financiere-ohada-2017 | HAUTE |
| S3 | Liasse « Système normal » SYSCOHADA révisé 2019 de la SODECI (formulaire DGI Côte d'Ivoire, 57 p., déposée à la BRVM) | refs, libellés, notes (fiche R4), TFT, note 34 CAFG ; formulaire rempli, donc source secondaire de la maquette officielle | https://www.brvm.org/sites/default/files/sodeci_liasse_syscohada_revise_2019.pdf | MOYENNE |
| S4 | `sfd-comptabilite-service/.../config/accounting-norms/syscohada/etats-financiers.json` (existant produit, modèle liasse RDC volet 1) | postes → comptes SYSCOHADA système normal | (dépôt) | MOYENNE (comptes) |
| S5 | `.../accounting-norms/{uemoa,cemac}/sycebnl/plan-comptable.yml`, `.../uemoa/syscohada/plan-comptable.yml` | existence de comptes (219, 239, 249, 477, 899, 776, 676, 848) | (dépôt) | MOYENNE |

NON LU : le PCG OHADA officiel annexé à l'AUDCIF (2 tomes) et son modèle d'états du système normal ; l'Acte SYCEBNL Partie 2 chap. 3 (contenu et fonctionnement des comptes, pp. 106-308) et Partie 3. Le texte AUDCIF cite les états mais renvoie leur tracé au SYSCOHADA annexé (art. 25).

## a) Inventaire des états

Légende format : BILAN_BICOLONNE / CR_VERTICAL / TFT_VERTICAL / NOTES / GENERIC (cf. `uemoa-bceao-sycebnl.yml`). Vérification : ✔ confirmé par 2e lecture / ◐ partiel / ? non vérifié (toujours `?` à la rédaction).

| code | intitulé | texte source (article) | URL | périodicité | délai | assujettis | format | confiance | ✔/◐/? |
|---|---|---|---|---|---|---|---|---|---|
| SYSN-BILAN-ACTIF / -PASSIF | Bilan (système normal), colonnes Brut / Amort.-Dépréc. / Net N et Net N-1 à l'actif, Net N et N-1 au passif | AUDCIF art. 8, 26, 29, 30 | S2, S3 | annuelle (exercice = année civile, art. 7) | arrêté ≤ 4 mois après clôture (art. 23) | toute entité hors SFD/établissements de crédit/assurances/EBNL (art. 5 al. 3) non éligible au SMT | BILAN_BICOLONNE | HAUTE (structure), MOYENNE (refs/comptes) | ? |
| SYSN-RESULTAT | Compte de résultat (liste, soldes en cascade XA..XI, activités ordinaires + HAO) | AUDCIF art. 8, 26, 29, 31 | S2, S3 | annuelle | 4 mois | idem | CR_VERTICAL | HAUTE / MOYENNE | ? |
| SYSN-TFT | Tableau des flux de trésorerie (ZA..ZH ; méthode indirecte pour l'opérationnel) | AUDCIF art. 8, 26, 29, 32 | S2, S3 | annuelle | 4 mois | idem | TFT_VERTICAL | HAUTE / MOYENNE | ? |
| SYSN-NOTES | Notes annexes : notes 1 à 36 du modèle (S4 : 45 rubriques avec sous-notes 3A-3E, 8A, 15A-B, 16A-C, 27A-B) ; la liasse DGI-CI ajoute 37 (impôt sur résultat), 38 (événements postérieurs), 39 (changements de méthodes), 3C bis, 8B, 8C | AUDCIF art. 8, 26, 33 | S2, S3, S4 | annuelle | 4 mois | idem | NOTES | HAUTE (principe), MOYENNE (liste) | ? |
| SYSN-NOTE34-CAFG | Note 34 « Fiche de synthèse » : SIG, CAFG, autofinancement, FR/BFR/trésorerie (alimente TFT.FA) | modèle de liasse | S3, S4 | annuelle | 4 mois | idem | GENERIC | MOYENNE | ? |
| SMT-SYSCOHADA | Système minimal de trésorerie : Bilan, Compte de résultat, Notes, tenus en comptabilité de trésorerie (stocks/créances/dettes pris en compte si significatifs) | AUDCIF art. 13, 21, 28 | S2 | annuelle | 4 mois | entités CA HT annuel < 60 M FCFA (négoce), < 40 M (artisanat et assimilés), < 30 M (services) ; option possible ; seuil strictement inférieur | GENERIC | HAUTE (règle), NON TROUVÉ (modèle des postes) | ? |
| SYSN-IFRS | États IFRS en sus des états SYSCOHADA (exclusivement pour marchés financiers) | AUDCIF art. 8 al. 3-4 | S2 | annuelle | — | entités cotées en bourse ou faisant appel public à l'épargne | hors paquet | HAUTE | ? |
| SYSN-CONSO | Comptes consolidés et combinés (dispositif annexé) | AUDCIF art. 5 al. 1 ; entrée en vigueur 01/01/2019 | S2 + OHADA-GEN-003 | annuelle | NON TROUVÉ | groupes | hors paquet | MOYENNE | ? |
| SYSN-DSF | DSF / liasse fiscale : états + états complémentaires fiscaux (variante par pays) | droit fiscal interne ; liasse CI : fiches R1-R4, états COMP/SUPPL | S3 ; Togo OTR (liasse avril 2020) et DGI Cameroun (DSF) signalés, non lus | annuelle | NON TROUVÉ (délai fiscal national) | selon fiscalité de chaque État | GENERIC | BASSE | ? |
| EBNL-A-BILAN-ACTIF / -PASSIF | SYCEBNL associations et ordres : Bilan (refs AA..BZ / CA..DZ) | SYCEBNL art. 4 1°, 7, 8 ; Partie 4 ch. 2 s. 1 p. 346 | S1 | annuelle | 4 mois (AUDCIF art. 23 rendu applicable par SYCEBNL art. 3) | associations, ordres professionnels (art. 2 1°), système normal | BILAN_BICOLONNE | HAUTE (refs/libellés), MOYENNE (comptes) | ? |
| EBNL-A-RESULTAT | Compte de résultat (RA..RH, XA, TA..TL, XB, XC, TM, TN, XD, XE) | art. 7, 9 ; p. 347 | S1 | annuelle | 4 mois | idem | CR_VERTICAL | HAUTE / MOYENNE | ? |
| EBNL-A-TFT | Tableau des flux de trésorerie, méthode **directe** pour l'opérationnel (ZA, FA..FH, ZB, FI..FL, ZC, FM..FO, ZD, FP..FQ, ZE, ZF, ZG) | art. 10 ; p. 342-343, 348 | S1 | annuelle | 4 mois | idem | TFT_VERTICAL | HAUTE / MOYENNE | ? |
| EBNL-A-NOTES | Notes annexes : 35 notes (1-4, 5A-5H, 6-16, 17A-B, 18A-B, 19-28, 29A-B, 30-35) | art. 15 ; p. 349-396 | S1 | annuelle | 4 mois | idem | NOTES | HAUTE | ? |
| EBNL-P-TER | Tableau emplois-ressources (projets de développement) | art. 4 2°, 11 ; p. 398 | S1 | annuelle | 4 mois | entités de gestion de projets de développement (art. 2 2°) | GENERIC | HAUTE (structure), MOYENNE/BASSE (comptes) | ? |
| EBNL-P-TEB | Tableau d'exécution budgétaire | art. 12 ; p. 399 | S1 | annuelle | 4 mois | idem | GENERIC | HAUTE | ? |
| EBNL-P-TRT | Tableau de réconciliation de trésorerie | art. 13 ; p. 400 | S1 | annuelle | 4 mois | idem | GENERIC | HAUTE/MOYENNE | ? |
| EBNL-P-BILAN-ACTIF / -PASSIF | Bilan des projets (refs AA..BZ / CA..DZ) | art. 8 ; p. 401 | S1 | annuelle | 4 mois | idem | BILAN_BICOLONNE | HAUTE / MOYENNE | ? |
| EBNL-P-EXPLOITATION | Compte d'exploitation (solde nul) | art. 9 ; p. 402 | S1 | annuelle | 4 mois | idem | CR_VERTICAL | HAUTE / MOYENNE | ? |
| EBNL-P-NOTES | Notes annexes projets : 24 notes | art. 15 ; p. 403 | S1 | annuelle | 4 mois | idem | NOTES | HAUTE | ? |
| EBNL-SMT-BILAN / -RESULTAT / -NOTES | SMT SYCEBNL : Bilan (GA..HZ), Compte de résultat (KA..KZC), 5 notes | art. 5-6 ; Partie 4 ch. 4 p. 433-437 | S1 | annuelle | 4 mois | chaque catégorie de ressources ≤ 30 M FCFA (subventions ; cotisations et autres revenus ; dons/legs ; ressources de projet ; autres) ; bascule normal si une ressource > 30 M ou cumul sur 2 exercices > 30 M | BILAN / CR / NOTES | HAUTE | ? |
| EBNL-AUTRES | Rapport d'activité (art. 16 3°), registre des donateurs (art. 17-18), livre d'inventaire (art. 14), audit si bilan > 100 M, ressources > 200 M ou effectif > 20 (art. 19 : un seul critère) ; états remis à l'auditeur ≥ 45 j avant l'AG | art. 14, 16-19, 24 | S1 | annuelle | 45 j avant AG (auditeur) | EBNL | hors paquet | HAUTE | ? |

Règles transverses (HAUTE, lues) :

| id | règle | source | URL | confiance | vérif. |
|----|----|----|----|----|----|
| OHADA-EFI-001 | Jeu complet SYSCOHADA : Bilan, Compte de résultat, TFT et Notes annexes ; formant un tout indissociable. | AUDCIF art. 8 al. 1-2 | S2 | HAUTE | ? |
| OHADA-EFI-002 | États arrêtés au plus tard 4 mois après la date de clôture ; la date d'arrêté figure dans toute transmission. | AUDCIF art. 23 | S2 | HAUTE | ? |
| OHADA-EFI-003 | Les entités à but non lucratif et les EMF/établissements de crédit ne sont pas assujettis au SYSCOHADA. | AUDCIF art. 5 al. 3 | S2 | HAUTE | ? |
| OHADA-EFI-004 | Seuils SMT SYSCOHADA : CA HT < 60 M FCFA négoce, < 40 M artisanat et assimilés, < 30 M services (art. 13). | AUDCIF art. 13 | S2 | HAUTE | ? |
| OHADA-EFI-005 | SYCEBNL : jeu complet associations = Bilan, CR, TFT, Notes ; projets = TER, TEB, TRT, Bilan, Compte d'exploitation, Notes. | SYCEBNL art. 4 | S1 | HAUTE | ? |
| OHADA-EFI-006 | SYCEBNL : SMT si ressources annuelles de chaque catégorie ≤ 30 M FCFA ; sinon normal (même cumul sur 2 exercices > 30 M). | SYCEBNL art. 6 | S1 | HAUTE | ? |
| OHADA-EFI-007 | SYCEBNL art. 3 rend applicables les articles de l'AUDCIF hors 5, 8, 10, 13, 17 al. 7-8, 18, 19 4e tiret, 21, 25-34, 49, 69-71, 73-113 : **art. 23 (4 mois) et art. 24 (conservation 10 ans) s'appliquent donc aux EBNL**. | SYCEBNL art. 3 ; AUDCIF art. 23, 24 | S1, S2 | HAUTE | ? |
| OHADA-EFI-008 | Dépôt des états : régime soumis à la législation interne de chaque État (SYCEBNL art. 5 al. 3) ; première année d'application : seule la colonne N-1 du bilan est obligatoire (art. 16, dernier al.). | SYCEBNL art. 5, 16 | S1 | HAUTE | ? |
| OHADA-EFI-009 | SYCEBNL en vigueur au 01/01/2024 ; publié au JO OHADA numéro spécial du 22/02/2023 (lève la lacune « date de publication » de `sycebnl.md`). | SYCEBNL art. 28 ; couverture JO | S1 | HAUTE | ? |
| OHADA-EFI-010 | Chaque poste mentionne le chiffre de l'exercice précédent ; pas de compensation actif/passif ni charges/produits ; présentation identique d'un exercice à l'autre. | AUDCIF art. 34 ; SYCEBNL art. 16 5°-7° ; Partie 4 §1.4 | S1, S2 | HAUTE | ? |

## b) Détail par état

Légende : solde D/C = seuls les soldes débiteurs / créditeurs sont retenus (vide = quel que soit le sens) ; conf. H/M/B ; ⚠ = écart/ambiguïté (voir en fin de section).

### b.1 SYSCOHADA — Système normal

Le détail des 5 états vient du JSON existant (S4), refs et libellés recoupés avec la liasse S3 (identiques sur Bilan, CR, TFT). Colonnes Bilan Actif : Brut, Amort./Dépréc., Net N, Net N-1 ; Passif : Net N, Net N-1 ; CR et TFT : N, N-1. Les comptes déduits (28, 29, 39, 49, 59) sont retenus quel que soit leur sens. Avertissement : les corrections proposées (219, 239, 249, 477, 899) sont ajoutées dans le YAML par rapport à S4.

#### Bilan Actif

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| AD | IMMOBILISATIONS INCORPORELLES | 3 |  |  | AE+AF+AG+AH | M |
| AE | Frais de développement et de prospection | 3 | 211,-28211,-29211 |  |  | M |
| AF | Brevets, licences, logiciels et droits similaires | 3 | 212,213,214,-28212,-28213,-28214,-29212,-29213,-29214 |  |  | M |
| AG | Fonds commercial et droit au bail | 3 | 215,216,-28215,-28216,-29215,-29216 |  |  | M |
| AH | Autres immobilisations incorporelles ⚠ | 3 | 217,218,-28217,-28218,-29217,-29218,219,-2919 |  |  | M |
| AI | IMMOBILISATIONS CORPORELLES | 3 |  |  | AJ+AK+AL+AM+AN | M |
| AJ | Terrains | 3 | 22,-2822,-2922 |  |  | M |
| AK | Bâtiments ⚠ | 3 | 231,232,233,237,-2831,-2832,-2833,-2837,-2931,-2932,-2933,239,-2939 |  |  | M |
| AL | Aménagements, agencements et installations | 3 | 234,235,238,-2834,-2835,-2838 |  |  | M |
| AM | Matériel, mobilier et actifs biologiques ⚠ | 3 | 241,242,243,244,246,247,248,-2841,-2842,-2843,-2844,-2846,-2847,-2848,-2941,-2944,249,-2949 |  |  | M |
| AN | Matériel de transport | 3 | 245,-2845,-2945 |  |  | M |
| AP | Avances et acomptes versés sur immobilisations | 3 | 251,252,-2951,-2952 |  |  | M |
| AQ | IMMOBILISATIONS FINANCIERES | 4 |  |  | AR+AS | M |
| AR | Titres de participation | 4 | 26,-296 |  |  | M |
| AS | Autres immobilisations financières | 4 | 27,-297 |  |  | M |
| AZ | TOTAL ACTIF IMMOBILISE |  |  |  | AD+AI+AP+AQ | M |
| BA | ACTIF CIRCULANT HAO | 5 | 485,488,-498 | D |  | M |
| BB | STOCKS ET ENCOURS | 6 | 31,32,33,34,35,36,37,38,-39 |  |  | M |
| BG | CREANCES ET EMPLOIS ASSIMILES |  |  |  | BH+BI+BJ | M |
| BH | Fournisseurs avances versées | 17 | 409,-4909 | D |  | M |
| BI | Clients | 7 | 411,412,413,414,415,416,418,-491 | D |  | M |
| BJ | Autres créances | 8 | 42,43,44,45,46,471,472,473,474,475,476,-492,-493,-494,-495,-496,-497 | D |  | M |
| BK | TOTAL ACTIF CIRCULANT |  |  |  | BA+BB+BG | M |
| BQ | Titres de placement | 9 | 50,-590 |  |  | M |
| BR | Valeurs à encaisser | 10 | 51,-591 |  |  | M |
| BS | Banques, Chèques postaux, Caisse et assimilés | 11 | 52,53,54,55,57,58,-592,-593,-594 | D |  | M |
| BT | TOTAL TRESORERIE - ACTIF |  |  |  | BQ+BR+BS | M |
| BU | Ecarts de conversion-Actif | 12 | 478 | D |  | M |
| BZ | TOTAL GENERAL |  |  |  | AZ+BK+BT+BU | M |

#### Bilan Passif

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| CA | Capital social ⚠ | 13 | 101,102,103,104 | C |  | M |
| CB | Apporteurs capital non appelé | 13 | 109 |  |  | M |
| CD | Primes liées au capital social | 14 | 105 | C |  | M |
| CE | Ecarts de réévaluation | 3E | 106 | C |  | M |
| CF | Réserves indisponibles | 14 | 111,112,113 | C |  | M |
| CG | Réserves libres | 14 | 118 | C |  | M |
| CH | Report à nouveau ( + ou - ) | 14 | 121,129 |  |  | M |
| CJ | Résultat de l'exercice ( bénéfice ou perte ) |  | 130,131,139 |  |  | M |
| CL | Subventions d'investissement | 15 | 14 | C |  | M |
| CM | Provisions réglementées | 15 | 15 | C |  | M |
| CP | TOTAL CAPITAUX PROPRES ET RESSOURCES ASSIMILEES |  |  |  | CA+CB+CD+CE+CF+CG+CH+CJ+CL+CM | M |
| DA | Emprunts et dettes financières diverses | 16 | 161,162,163,164,165,166,167,168,181,182,183,184 | C |  | M |
| DB | Dettes de location acquisition | 16 | 17 | C |  | M |
| DC | Provisions financières pour risques et charges | 16 | 19 | C |  | M |
| DD | TOTAL DETTES FINANCIERES ET RESSOURCES ASSIMILEES |  |  |  | DA+DB+DC | M |
| DF | TOTAL RESSOURCES STABLES |  |  |  | CP+DD | M |
| DH | Dettes circulantes H.A.O. | 5 | 481,482,484,488 | C |  | M |
| DI | Clients avances reçues | 7 | 419 | C |  | M |
| DJ | Fournisseurs d'exploitation | 17 | 401,402,408 | C |  | M |
| DK | Dettes fiscales et sociales | 18 | 42,43,44 | C |  | M |
| DM | Autres dettes ⚠ | 19 | 45,46,471,472,473,474,475,476,477 | C |  | M |
| DN | Provisions pour risques à court terme | 19 | 499,599 | C |  | M |
| DP | TOTAL PASSIF CIRCULANT |  |  |  | DH+DI+DJ+DK+DM+DN | M |
| DQ | Banques, crédits d'escompte | 20 | 564,565 | C |  | M |
| DR | Banques, établissements financiers et crédits de trésorerie | 20 | 52,561,566 | C |  | M |
| DT | TOTAL TRESORERIE - PASSIF |  |  |  | DQ+DR | M |
| DU | Ecarts de conversion - Passif | 12 | 479 | C |  | M |
| DZ | TOTAL GENERAL |  |  |  | DF+DP+DT+DU | M |

#### Compte de résultat

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| TA | Ventes de marchandises | 21 | 701 | C |  | M |
| RA | Achats de marchandises | 22 | 601 | D |  | M |
| RB | Variation de stocks de marchandises | 6 | 6031 |  |  | M |
| XA | MARGE COMMERCIALE (Somme TA à RB) |  |  |  | TA-RA-RB | M |
| TB | Ventes de produits fabriqués | 21 | 702,703,704 | C |  | M |
| TC | Travaux, services vendus | 21 | 705,706 | C |  | M |
| TD | Produits accessoires | 21 | 707 | C |  | M |
| XB | CHIFFRE D'AFFAIRES (A + B + C + D) |  |  |  | TA+TB+TC+TD | M |
| TE | Production stockée (ou déstockage) | 6 | 734,735,736,737 |  |  | M |
| TF | Production immobilisée | 21 | 72 | C |  | M |
| TG | Subventions d'exploitation | 21 | 71 | C |  | M |
| TH | Autres produits | 21 | 75 | C |  | M |
| TI | Transferts de charges d'exploitation | 12 | 781 | C |  | M |
| RC | Achats de matières premières et fournitures liées | 22 | 602 | D |  | M |
| RD | Variation de stocks de matières premières et fournitures liées | 6 | 6032 |  |  | M |
| RE | Autres achats | 22 | 604,605,608 | D |  | M |
| RF | Variation de stocks d'autres approvisionnements | 6 | 6033 |  |  | M |
| RG | Transports | 23 | 61 | D |  | M |
| RH | Services extérieurs | 24 | 62,63 | D |  | M |
| RI | Impôts et taxes | 25 | 64 | D |  | M |
| RJ | Autres charges | 26 | 65 | D |  | M |
| XC | VALEUR AJOUTEE |  |  |  | XB-RA-RB+TE+TF+TG+TH+TI-RC-RD-RE-RF-RG-RH-RI-RJ | M |
| RK | Charges de personnel | 27 | 66 | D |  | M |
| XD | EXCEDENT BRUT D'EXPLOITATION |  |  |  | XC-RK | M |
| TJ | Reprises d'amortissements, provisions et dépréciations | 28 | 791,798,799 | C |  | M |
| RL | Dotations aux amortissements, aux provisions et aux dépréciations | 3C&28 | 681,691 | D |  | M |
| XE | RESULTAT D'EXPLOITATION |  |  |  | XD+TJ-RL | M |
| TK | Revenus financiers et assimilés | 29 | 77 | C |  | M |
| TL | Reprises de provisions et dépréciations financières | 28 | 797 | C |  | M |
| TM | Transferts de charges financières | 12 | 787 | C |  | M |
| RM | Frais financiers et charges assimilées | 29 | 67 | D |  | M |
| RN | Dotations aux provisions et aux dépréciations financières | 3C&28 | 687,697 | D |  | M |
| XF | RESULTAT FINANCIER |  |  |  | TK+TL+TM-RM-RN | M |
| XG | RESULTAT DES ACTIVITES ORDINAIRES |  |  |  | XE+XF | M |
| TN | Produits des cessions d'immobilisations | 3D | 82 | C |  | M |
| TO | Autres Produits HAO | 30 | 84,86,88 | C |  | M |
| RO | Valeurs comptables des cessions d'immobilisations | 3D | 81 | D |  | M |
| RP | Autres Charges HAO | 30 | 83,85 | D |  | M |
| XH | RESULTAT HORS ACTIVITES ORDINAIRES |  |  |  | TN+TO-RO-RP | M |
| RQ | Participation des travailleurs | 30 | 87 | D |  | M |
| RS | Impôts sur le résultat ⚠ |  | 891,892,895,899 | D |  | M |
| XI | RESULTAT NET |  |  |  | XG+XH-RQ-RS | M |

Vérifications d'équilibre : BZ = DZ ; XI (compte de résultat) = CJ (bilan passif) avant affectation.

#### TFT — ligne par ligne avec formule

Notation : Δ(X) = solde net de X à N moins solde net à N-1 ; flux brut = mouvements de la période. Les signes suivent la convention du modèle (lignes préfixées « - » stockées négatives).

| ref | libellé | formule / alimentation | comptes (S4) | note |
|---|---|---|---|---|
| ZA | Trésorerie nette au 1er janvier | BILAN_ACTIF.BT[N-1] − BILAN_PASSIF.DT[N-1] | — | A |
| FA | Capacité d'autofinancement globale (CAFG) | note 34 : EBE + 654 − 754 + 77 (gains de change 776) + 787 + produits HAO (84, 86, 88 ; transferts 848) − 67 (pertes de change 676) − charges HAO (83, 85) − 87 − 89 | voir SYSN-NOTE34-CAFG | 34 |
| FB | − Actif circulant HAO | −Δ(BA net) | 485, 488 (D), −498 | 5 |
| FC | − Variation des stocks | −Δ(BB net) | 31-38 | 6 |
| FD | − Variation des créances | −Δ(BH+BI+BJ net) | 41-47 (D) | 7, 8 |
| FE | + Variation du passif circulant | +Δ(DI+DJ+DK+DM+DN) | 401, 402, 408, 42-47 (C) | 17-19 |
| ZB | Flux des activités opérationnelles | FA+FB+FC+FD+FE | — | B |
| FF | − Acquisitions d'immobilisations incorporelles | −(mouvements débit 21, ajustés fournisseurs d'immobilisations 481) | 21 | 3A |
| FG | − Acquisitions d'immobilisations corporelles | −(mouvements débit 22, 23, 24) | 22, 23, 24 | 3A |
| FH | − Acquisitions d'immobilisations financières | −(mouvements débit 26, 27) | 26, 27 | 3A, 4 |
| FI | + Cessions incorporelles et corporelles | prix de cession (82 : 821, 822) ± Δ 485 | 82 (S4 : 82 entier) ⚠ | 3D |
| FJ | + Cessions financières | prix de cession (826) | 82 (S4 : 82 entier) ⚠ | 3D |
| ZC | Flux d'investissement | FF+FG+FH+FI+FJ | — | C |
| FK | + Augmentation de capital par apports nouveaux | mouvements crédit 101-104 (+109) | 101-104, 109 ⚠ | 13 |
| FL | + Subventions d'investissement reçues | mouvements crédit 14 | 14 | 15 |
| FM | − Prélèvements sur le capital | mouvements débit 101-104 | 101-104 ⚠ | 13 |
| FN | − Dividendes versés | dividendes payés = débit 465 (ou 465 N-1 + dividendes votés − 465 N) | 465 | 31 |
| ZD | Flux capitaux propres | FK+FL+FM+FN | — | D |
| FO | + Emprunts | mouvements crédit 161-165, 167, 168 | 161-165, 167, 168 | 16 |
| FP | + Autres dettes financières | mouvements crédit 17, 181-184 | 17, 181-184 | 16 |
| FQ | − Remboursements des emprunts et autres dettes financières | mouvements débit 16, 17 | 16, 17 | 16 |
| ZE | Flux capitaux étrangers | FO+FP+FQ | — | E |
| ZF | Flux des activités de financement (D+E) | ZD+ZE | — | F |
| ZG | VARIATION DE LA TRÉSORERIE NETTE DE LA PÉRIODE (B+C+F) | ZB+ZC+ZF | — | G |
| ZH | Trésorerie nette au 31 décembre (G+A) | ZG+ZA ; contrôle = BILAN_ACTIF.BT − BILAN_PASSIF.DT | — | H |

Remarque : « Trésorerie nette » = trésorerie-actif (BT) − trésorerie-passif (DT) d'après le libellé de ZA (S3) ; le contrôle exact ZH = BT − DT est une égalité que le calculateur doit tester.

#### Écarts/ambiguïtés SYSCOHADA (voir YAML, champ `ecart`)

- `SYSN-BILAN-ACTIF.AH` : 219 'Immobilisations incorporelles en cours' absent du JSON existant (217,218 seulement)
- `SYSN-BILAN-ACTIF.AK` : 239 'Bâtiments... en cours' absent du JSON existant
- `SYSN-BILAN-ACTIF.AM` : 249 'Matériels et actifs biologiques en cours' absent du JSON existant
- `SYSN-BILAN-PASSIF.CA` : compte 108 'Compte de l'exploitant' non mappé (entreprise individuelle) : à vérifier sur le PCG officiel
- `SYSN-BILAN-PASSIF.DM` : 477 'Produits constatés d'avance' (solde créditeur) absent du JSON existant (ni BJ ni DM) : bilan déséquilibré si 477 mouvementé
- `SYSN-RESULTAT.RS` : 899 'Dégrèvements... impôts sur résultats antérieurs' absent du JSON existant (891,892,895)
- `SYSN-TFT.FI` : FI et FJ sont tous deux alimentés par 82 dans le JSON existant : risque de double compte ; scinder 821,822 (corporelles/incorporelles) vs 826 (financières)
- `SYSN-TFT.FJ` : voir FI : utiliser 826 (financières) ; plan produit uemoa/syscohada : 821,822,826 existent
- `SYSN-TFT.FK` : FK et FM utilisent les mêmes comptes 101-104 (+109) : règle à expliciter (FK = mouvements crédit, FM = mouvements débit)
- `SYSN-TFT.FM` : voir FK
- `SYSN-NOTE34-CAFG.N34-77` : JSON existant : 77 entier (inclut 776) ET 676 soustrait séparément alors que 67 (inclut 676) est aussi soustrait => double compte des pertes de change ; le modèle liasse liste gains de change financiers et pertes de change financières à part
- `SYSN-NOTE34-CAFG.N34-848` : ligne du modèle liasse absente du JSON existant (848 est inclus dans 84 : éviter le double compte)
- `SYSN-NOTE34-CAFG.N34-83` : ligne 'Charges HAO' du modèle liasse absente du JSON existant

- `SYSN-TFT` : le JSON existant n'alimente pas FE avec 419 (clients, avances reçues), ni FD avec 409 (fournisseurs, avances versées), ni avec les dettes circulantes HAO (481, 484, 488) : la variation de BFR de FB-FE ne bouclera pas avec ZH = BT − DT si ces comptes bougent. La note (1) du modèle (« Actif circulant HAO (1) » / « Variation du passif circulant (1) ») n'a pas été lue : NON TROUVÉ.

#### Notes annexes SYSCOHADA (S3/S4)

Notes du modèle : 1 Dettes garanties par des sûretés réelles ; 2 Informations obligatoires ; 3A Immobilisations brutes ; 3B Biens pris en location-acquisition ; 3C Amortissements ; 3D Plus/moins-values de cession ; 3E Réévaluations ; 4 Immobilisations financières ; 5 Actif et dettes circulants HAO ; 6 Stocks et encours ; 7 Clients ; 8 Autres créances ; 8A Étalement des charges immobilisées ; 9 Titres de placement ; 10 Valeurs à encaisser ; 11 Banques, chèques postaux, caisse ; 12 Écarts de conversion et transferts de charges ; 13 Capital ; 14 Primes et réserves ; 15A Subventions et provisions réglementées ; 15B Autres fonds propres ; 16A Dettes financières et ressources assimilées ; 16B/16B bis Engagements de retraite ; 16C Actifs et passifs éventuels ; 17 Fournisseurs d'exploitation ; 18 Dettes fiscales et sociales ; 19 Autres dettes et provisions pour risques à court terme ; 20 Banques, crédit d'escompte et de trésorerie ; 21 Chiffre d'affaires et autres produits ; 22 Achats ; 23 Transports ; 24 Services extérieurs ; 25 Impôts et taxes ; 26 Autres charges ; 27A Charges de personnel ; 27B Effectifs, masse salariale ; 28 Provisions et dépréciations ; 29 Charges et revenus financiers ; 30 Autres charges et produits HAO ; 31 Répartition du résultat et éléments des 5 derniers exercices ; 32 Production de l'exercice ; 33 Achats destinés à la production ; 34 Fiche de synthèse des principaux indicateurs financiers ; 35 Informations sociales, environnementales et sociétales ; 36 Table des codes. Avertissement : la liasse DGI-CI (S3) numérote 3C/3C bis, 8A/8B/8C, 11 « Disponibilités », 37, 38, 39 : variante pays.

### b.2 SYCEBNL — associations et ordres professionnels

Refs/libellés lus sur les modèles officiels (S1). Comptes : le texte lu ne contient pas de table poste → compte ; ils sont **déduits** du plan SYCEBNL officiel (S1 pp. 75-105, numéros et libellés exacts) et des intitulés des postes : confiance MOYENNE (B = hypothèse de rattachement). Particularités : bilan avec colonnes Brut / Amort. / Net N / Net N-1 à l'actif ; fonds propres distincts (CK), fonds affectés et reportés (CY) ; `BT` = total actif circulant, `BX` = total trésorerie-actif.

#### Bilan Actif

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| AA | IMMOBILISATIONS DESTINEES A LA VENTE PROVENANT DE DONS ET LEGS NON ENCORE RECUS ET USUFRUIT TEMPORAIRE | 5 |  |  | AB+AC | H |
| AB | Immobilisations incorporelles ⚠ | 5 | 201,-280,-290 |  |  | M |
| AC | Immobilisations corporelles et financières | 5 | 202,203,204,205 |  |  | M |
| AD | IMMOBILISATIONS INCORPORELLES | 5 |  |  | AE+AF+AG | H |
| AE | Brevets, licences, logiciels et droits similaires |  | 212,213,214,-2812,-2813,-2814,-2912,-2913,-2914 |  |  | M |
| AF | Autres immobilisations incorporelles |  | 218,219,-2817,-2818,-2918,-2919 |  |  | M |
| AG | Avances et acomptes versés sur immobilisations incorporelles |  | 251,-2951 |  |  | M |
| AH | IMMOBILISATIONS CORPORELLES | 5 |  |  | AI+AJ+AK+AL+AM+AN | H |
| AI | Terrains |  | 22,-282,-292 |  |  | M |
| AJ | Bâtiments |  | 231,232,233,-2831,-2832,-2833,-2931,-2932,-2933 |  |  | M |
| AK | Aménagements, agencements et installations |  | 234,235,238,239,-2834,-2835,-2838,-2934,-2935,-2938,-2939 |  |  | M |
| AL | Matériel, mobilier et actifs biologiques ⚠ |  | 241,242,243,244,246,247,248,249,-2841,-2842,-2843,-2844,-2846,-2847,-2848,-2941,-2942,-2943,-2944,-2946,-2947,-2948,-2949 |  |  | M |
| AM | Matériel de transport |  | 245,-2845,-2945 |  |  | M |
| AN | Avances et acomptes versés sur immobilisations corporelles |  | 252,-2952 |  |  | M |
| AO | IMMOBILISATIONS FINANCIERES | 6 |  |  | AX+AY | H |
| AX | Titres de participation |  | 26,-296 |  |  | M |
| AY | Autres immobilisations financières |  | 27,-297 |  |  | M |
| AZ | TOTAL ACTIF IMMOBILISE |  |  |  | AA+AD+AH+AO | H |
| BA | Actif circulant HAO ⚠ | 7 | 485,486,488,-498 | D |  | M |
| BB | Stocks et encours | 8 | 31,32,33,34,35,36,37,-39 |  |  | M |
| BC | Fournisseurs débiteurs | 19 | 409,-490 | D |  | M |
| BD | Adhérents, Clients-usagers | 9 | 41,-491 | D |  | M |
| BE | Autres créances | 10 | 42,43,44,45,46,471,472,473,474,475,476,-492,-493,-494,-497 | D |  | M |
| BT | TOTAL ACTIF CIRCULANT |  |  |  | BA+BB+BC+BD+BE | H |
| BU | Titres de placement | 11 | 50,-590 |  |  | M |
| BV | Valeurs à encaisser | 12 | 51,-591 |  |  | M |
| BW | Banques, établissements financiers, caisses et assimilés ⚠ | 13 | 52,53,55,57,-592,-593,-595 | D |  | M |
| BX | TOTAL TRESORERIE-ACTIF |  |  |  | BU+BV+BW | H |
| BY | Ecart de conversion-Actif | 14 | 478 | D |  | M |
| BZ | TOTAL GENERAL |  |  |  | AZ+BT+BX+BY | H |

#### Bilan Passif

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| CA | Dotation non consomptible sans droit de reprise | 15 | 101 | C |  | M |
| CB | Dotation non consomptible avec droit de reprise | 15 | 102 | C |  | M |
| CC | Droit d'entrée | 15 | 103 | C |  | M |
| CD | Dotation consomptible ⚠ | 15 | 104 | C |  | M |
| CE | Ecarts de réévaluation | 5F | 106 | C |  | M |
| CF | Réserves | 16 | 11 | C |  | M |
| CG | Report à nouveau (+ ou -) ⚠ | 16 | 12 |  |  | M |
| CH | Résultat net de l'exercice (excédent + ou déficit -) ⚠ |  | 13 |  |  | M |
| CI | Subventions d'investissement | 17A | 14 | C |  | M |
| CJ | Provisions réglementées | 17A | 15 | C |  | M |
| CK | TOTAL FONDS PROPRES ET ASSIMILES |  |  |  | CA+CB+CC+CD+CE+CF+CG+CH+CI+CJ | H |
| CW | Fonds affectés et provenant de dons et legs d'immobilisations | 17B | 16 | C |  | M |
| CX | Fonds reportés | 17B | 17 | C |  | M |
| CY | TOTAL FONDS AFFECTES ET REPORTES |  |  |  | CW+CX | H |
| CZ | TOTAL RESSOURCES PROPRES ET ASSIMILEES |  |  |  | CK+CY | H |
| DA | Emprunts et dettes financières | 18A | 181,182,183,185,186,188 | C |  | M |
| DB | Dettes de location-acquisition | 18A | 187 | C |  | M |
| DC | Provisions pour risques et charges | 18A | 19 | C |  | M |
| DD | TOTAL DETTES FINANCIERES ET RESSOURCES ASSIMILEES |  |  |  | DA+DB+DC | H |
| DE | TOTAL RESSOURCES STABLES |  |  |  | CZ+DD | H |
| DF | Dettes circulantes HAO | 7 | 481,484,486,488 | C |  | M |
| DG | Adhérents, clients-usagers créditeurs | 9 | 419 | C |  | M |
| DH | Fournisseurs | 19 | 401,402,408 | C |  | M |
| DI | Autres dettes | 20 & 21 | 42,43,44,45,46,471,472,473,474,475,476,477,499,599 | C |  | M |
| DV | TOTAL PASSIF CIRCULANT |  |  |  | DF+DG+DH+DI | H |
| DW | Banques, établissements financiers et crédits de trésorerie | 22 | 52,56 | C |  | M |
| DX | TOTAL TRESORERIE-PASSIF |  |  |  | DW | H |
| DY | Ecart de conversion-Passif | 14 | 479 | C |  | M |
| DZ | TOTAL GENERAL |  |  |  | DE+DV+DX+DY | H |

#### Compte de résultat

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| RA | Cotisations | 23 | 701 |  |  | M |
| RB | Dotations consomptibles transférées au compte de résultat | 23 | 703 |  |  | M |
| RC | Revenus liés à la générosité | 23 | 704 |  |  | M |
| RD | Ventes de marchandises | 23 | 7051 |  |  | M |
| RE | Ventes de services et produits finis | 23 | 7052,7053,7054,7055 |  |  | M |
| RF | Subventions d'exploitation | 23 | 71 |  |  | M |
| RG | Autres produits et transferts de charges ⚠ | 23 | 72,73,75,781,706,707,708,77 |  |  | B |
| RH | Reprises de provisions, dépréciations, subventions et autres reprises | 5D&30 | 79 |  |  | M |
| XA | REVENUS DES ACTIVITES ORDINAIRES ⚠ |  |  |  | RA+RB+RC+RD+RE+RF+RG+RH | H |
| TA | Achats de biens et services liés à l'activité | 24 | 601 |  |  | M |
| TB | Variation de stocks des achats de biens et services liés à l'activité | 8 | 6031 |  |  | M |
| TC | Achats de marchandises et matières premières | 24 | 602 |  |  | M |
| TD | Autres achats | 24 | 604,605,606,608 |  |  | M |
| TE | Variation de stocks de marchandises, de matières premières et autres | 8 | 6032,6033,6034,6035 |  |  | M |
| TF | Transports | 25 | 61 |  |  | M |
| TG | Services extérieurs | 26 | 62,63 |  |  | M |
| TH | Impôts et taxes | 27 | 64 |  |  | M |
| TI | Autres charges | 28 | 65 |  |  | M |
| TJ | Charges de personnel | 29 | 66 |  |  | M |
| TK | Frais financiers et charges assimilées | 31 | 67 |  |  | M |
| TL | Dotations aux amortissements, aux provisions, aux dépréciations et autres | 5D&30 | 68,69 |  |  | M |
| XB | CHARGES DES ACTIVITES ORDINAIRES |  |  |  | TA+TB+TC+TD+TE+TF+TG+TH+TI+TJ+TK+TL | H |
| XC | RESULTAT DES ACTIVITES ORDINAIRES |  |  |  | XA-XB | H |
| TM | Produits H.A.O. ⚠ | 32 | 82,84,86,88 |  |  | B |
| TN | Charges H.A.O. | 32 | 81,83,85 |  |  | B |
| XD | RESULTAT H.A.O. |  |  |  | TM-TN | H |
| XE | RESULTAT NET DE L'EXERCICE (excédent + / déficit -) |  |  |  | XC+XD | H |

#### Tableau des flux de trésorerie (méthode directe)

Formule de principe (S1 p. 343) : encaissements N = revenus N + créances N-1 − créances N ; décaissements N = achats N + dettes N-1 − dettes N. Contrôles : trésorerie nette fin = début + variation ; = trésorerie actif N − trésorerie passif N.

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| ZA | Trésorerie nette au 1er janvier |  |  |  | BX[N-1]-DX[N-1] | H |
| FA | + Encaissement des cotisations ⚠ |  | 701 |  |  | M |
| FB | + Encaissement des subventions d'exploitation et d'équilibre |  | 71,88 |  |  | M |
| FC | + Encaissement des revenus liés à la générosité |  | 704 |  |  | M |
| FD | + Encaissement des revenus des manifestations |  | 706 |  |  | M |
| FE | + Encaissement des autres revenus |  | 705,707,708,75,77 |  |  | B |
| FF | - Décaissement des sommes versées aux fournisseurs (hors fournisseurs d'investissements) ⚠ |  | 60,61,62,63 |  |  | B |
| FG | - Décaissement des sommes versées au personnel |  | 66 |  |  | B |
| FH | - Autres décaissements |  | 64,65,67 |  |  | B |
| ZB | Flux de trésorerie provenant des activités opérationnelles (somme FA à FH) ⚠ | B |  |  | FA+FB+FC+FD+FE+FF+FG+FH | H |
| FI | - Décaissements liés aux acquisitions d'immobilisations incorporelles et corporelles |  | 21,22,23,24,25 |  |  | M |
| FJ | - Décaissements liés aux acquisitions d'immobilisations financières |  | 26,27 |  |  | M |
| FK | + Encaissements liés aux cessions d'immobilisations incorporelles et corporelles |  | 821,822,828 |  |  | M |
| FL | + Encaissements liés aux cessions d'immobilisations financières |  | 826 |  |  | M |
| ZC | Flux de trésorerie provenant des activités d'investissement (somme FI à FL) | C |  |  | FI+FJ+FK+FL | H |
| FM | + Encaissement des dotations et autres fonds propres |  | 101,102,103,104,-1049 |  |  | B |
| FN | + Subventions d'investissement reçues |  | 14 |  |  | B |
| FO | - Décaissement des dotations et autres fonds propres |  | 101,102,103,104,-1049 |  |  | B |
| ZD | Flux de trésorerie provenant des fonds propres (somme FM à FO) | D |  |  | FM+FN+FO | H |
| FP | + Encaissement provenant des emprunts et des autres dettes financières |  | 18 |  |  | M |
| FQ | - Remboursements des emprunts et autres dettes financières |  | 18 |  |  | M |
| ZE | Trésorerie provenant des fonds étrangers (somme FP à FQ) | E |  |  | FP+FQ | H |
| ZF | VARIATION DE LA TRESORERIE NETTE DE LA PERIODE (B+C+D+E) | G |  |  | ZB+ZC+ZD+ZE | H |
| ZG | Trésorerie nette au 31 décembre (G+A) ⚠ | H |  |  | ZF+ZA | H |

#### Écarts/ambiguïtés SYCEBNL associations

- `EBNL-A-BILAN-ACTIF.AB` : amortissements/dépréciations de 20 : 280 (usufruit temporaire) et 290 ; ventilation AB/AC par sous-compte non documentée (2011 usufruit... 202-205)
- `EBNL-A-BILAN-ACTIF.AL` : 242 déduit de 2842/2942 'outillage agricole' (la ligne 242 n'a pas été lue à l'OCR)
- `EBNL-A-BILAN-ACTIF.BA` : 38 'Dons en nature H.A.O.' (stock) non rattaché : rubrique à confirmer ; 486 'dettes et créances des legs et dons d'immobilisations' sens variable
- `EBNL-A-BILAN-ACTIF.BW` : 58 virements internes : doit être soldé en fin de période
- `EBNL-A-BILAN-PASSIF.CD` : 1049 (inscrite au compte de résultat) est la contrepartie de 703 : à neutraliser dans CD selon guide d'application
- `EBNL-A-BILAN-PASSIF.CG` : 12 inclut 128 'résultat net en instance d'affectation'
- `EBNL-A-BILAN-PASSIF.CH` : si l'exercice n'est pas clôturé : XE du compte de résultat (RESULTAT.XE)
- `EBNL-A-RESULTAT.RG` : 706 (manifestations) et 708 (autres revenus) sont des revenus (classe 70) mais le modèle n'a pas de ligne dédiée : rattachement RG = hypothèse ; 77 et 787 : rattachement non documenté
- `EBNL-A-RESULTAT.XA` : le libellé officiel dit 'Somme RA à RG' alors que RH figure au-dessus de XA : coquille probable, RH retenu
- `EBNL-A-RESULTAT.TM` : le modèle n'a ni ligne 'cessions' ni 'subventions d'équilibre' : 82 (produits de cessions) et 88 (subventions d'équilibre) rattachés à TM par hypothèse ; 87 (variations de stocks de dons en nature HAO) non rattaché
- `EBNL-A-TFT.FA` : méthode directe : encaissements = revenus N + créances N-1 - créances N (Partie 4, § 1.2 section 3)
- `EBNL-A-TFT.FF` : décaissements = achats N + dettes N-1 - dettes N ; périmètre exact des comptes de charges non documenté dans le texte lu
- `EBNL-A-TFT.ZB` : le modèle écrit 'somme FA à FH' ; FF-FH sont stockés négatifs
- `EBNL-A-TFT.ZG` : contrôle : BX - DX ; dernière ref = ZG (ZH en système normal SYSCOHADA)

#### Notes annexes (35)

N1 Dettes garanties par des sûretés réelles, engagements financiers et contributions volontaires en nature ; N2 Informations obligatoires ; N3 Evénements postérieurs à la clôture de l'exercice ; N4 Changements de méthodes comptables, d'estimations et corrections d'erreurs ; N5A Dons et legs d'immobilisations non reçus destinés à la vente et usufruit temporaire ; N5B Immobilisations brutes ; N5C Biens pris en location-acquisition ; N5D Dons et legs d'immobilisations non reçus destinés à la vente et usufruit temporaire (amortissements et dépréciations) ; N5E Immobilisations : amortissements ; N5F Immobilisations : dépréciations ; N5G Immobilisations : plus-values et moins-values de cession ; N5H Informations sur les réévaluations effectuées par l'entité ; N6 Immobilisations financières ; N7 Actif circulant et dettes circulantes HAO ; N8 Stocks et encours ; N9 Adhérents, clients-usagers ; N10 Autres créances ; N11 Titres de placement ; N12 Valeurs à encaisser ; N13 Disponibilités ; N14 Ecarts de conversion ; N15 Dotation ; N16 Réserves ; N17A Subventions et provisions réglementées ; N17B Fonds affectés et reportés ; N18A Dettes financières et ressources assimilées ; N18B Actifs et passifs éventuels ; N19 Fournisseurs d'exploitation ; N20 Dettes fiscales et sociales ; N21 Autres dettes et provisions pour risques et charges à court terme ; N22 Banques, crédit d'escompte et de trésorerie ; N23 Revenus et autres produits ; N24 Achats ; N25 Transports ; N26 Services extérieurs ; N27 Impôts et taxes ; N28 Autres charges ; N29A Charges de personnel ; N29B Effectifs, masse salariale et personnel extérieur ; N30 Dotations et charges pour provisions et dépréciations ; N31 Charges et revenus financiers ; N32 Autres charges et produits HAO ; N33 Fiche de synthèse des principaux indicateurs financiers ; N34 Liste des informations sociales, environnementales et sociétales ; N35 Tableau d'exécution budgétaire


### b.3 SYCEBNL — projets de développement et assimilés

Six états (art. 4 2°) ; incohérence interne : Partie 4 §1.2 liste « Bilan, Compte de résultat, État des dépenses et des ressources, Notes » alors que l'art. 4 et le chapitre 3 donnent TER, TEB, TRT, Bilan, Compte d'exploitation, Notes. Le paquet suit l'art. 4 et les modèles du chapitre 3. Comptes : MOYENNE/BASSE (même méthode).

#### Tableau emplois-ressources (p. 398)

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| FA | Fonds reçus, Bailleurs .... ⚠ |  | 162,462 |  |  | B |
| FB | Fonds reçus, Bailleurs .... |  | 162,462 |  |  | B |
| FC | Fonds contrepartie Etat |  | 163,463 |  |  | B |
| FD | Autres fonds reçus |  | 164,464 |  |  | B |
| GR | I. RESSOURCES |  |  |  | FA+FB+FC+FD | H |
| FE | Immobilisations incorporelles |  | 21 |  |  | B |
| FF | Terrains |  | 22 |  |  | B |
| FG | Bâtiments |  | 231,232,233 |  |  | B |
| FH | Aménagements, agencements et installations |  | 234,235,238,239 |  |  | B |
| FI | Matériel, mobilier et actifs biologiques |  | 24,-245 |  |  | B |
| FJ | Matériel de transport |  | 245 |  |  | B |
| FK | Avances et acomptes sur immobilisations |  | 25 |  |  | B |
| FL | Immobilisations financières |  | 26,27 |  |  | B |
| GS | A- TOTAL DES IMMOBILISATIONS |  |  |  | FE+FF+FG+FH+FI+FJ+FK+FL | H |
| FM | Achats de biens et services |  | 60 |  |  | B |
| FN | Transports |  | 61 |  |  | B |
| FO | Services extérieurs |  | 62,63 |  |  | B |
| FP | Impôts et taxes |  | 64 |  |  | B |
| FQ | Autres charges |  | 65 |  |  | B |
| FR | Charges de personnel |  | 66 |  |  | B |
| FS | Charges financières |  | 67 |  |  | B |
| FT | Avances sur charges (à justifier) ⚠ |  | 161 |  |  | B |
| GT | B- TOTAL DES CHARGES DE FONCTIONNEMENT |  |  |  | FM+FN+FO+FP+FQ+FR+FS+FT | H |
| GU | II. EMPLOIS (A+B) |  |  |  | GS+GT | H |
| GV | III. EXCEDENT/DEFICIT DES FONDS RECUS SUR LES EMPLOIS (I-II) |  |  |  | GR-GU | H |
| FU | Fonds Bailleur en début exercice N |  |  |  | FX[N-1] | H |
| FV | Fonds de contrepartie Etat en début exercice N |  |  |  | FY[N-1] | H |
| FW | Autres fonds en début exercice N |  |  |  | FZ[N-1] | H |
| GW | IV. FONDS DISPONIBLE EN DEBUT EXERCICE |  |  |  | FU+FV+FW | H |
| GX | V. MONTANT NET DE L'ENCAISSE DISPONIBLE (III+IV) |  |  |  | GV+GW | H |
| FX | Fonds Bailleur en fin exercice N |  |  |  |  | B |
| FY | Fonds de contrepartie Etat en fin exercice N |  |  |  |  | B |
| FZ | Autres fonds en fin exercice N |  |  |  |  | B |
| GY | VI. FONDS DISPONIBLE EN FIN EXERCICE |  |  |  | FX+FY+FZ | H |
| GZ | VII. CONTROLE : TOTAL V = TOTAL VI |  |  |  | GX-GY | H |

#### Tableau de réconciliation de trésorerie (p. 400)

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| A | TRESORERIE EN DEBUT D'EXERCICE |  |  |  | BX[N-1]-DX[N-1] | B |
| B | FONDS RECUS DES BAILLEURS AU COURS DE L'EXERCICE N |  | 162,462 |  |  | B |
| C | INTERETS RECUS AU COURS DE L'EXERCICE N |  | 774 |  |  | B |
| D | AUTRES FONDS RECUS AU COURS DE L'EXERCICE N |  | 164,464 |  |  | B |
| E | VIREMENTS SUR COMPTES OPERATIONNELS |  | 58 |  |  | B |
| F | DEPENSES DE L'EXERCICE N |  |  |  | EBNL-P-TER.GU | B |
| G | TRESORERIE FIN D'EXERCICE (A+B+C+D-E-F ... à valider) |  |  |  | A+B+C+D-F | B |
| H | PAIEMENTS EN INSTANCE |  | 481,484 |  |  | B |
| I | TRESORERIE NETTE DES PAIEMENTS EN INSTANCE (G-H) |  |  |  | G-H | B |

#### Bilan Actif (p. 401)

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| AA | Immobilisations incorporelles | 2 | 21,-281,-291 |  |  | M |
| AB | Terrains et bâtiments | 2 | 22,231,232,233,-282,-283,-292,-293 |  |  | M |
| AC | Aménagements, agencements et installations | 2 | 234,235,238,239 |  |  | M |
| AD | Matériel, mobilier et actifs biologiques | 2 | 24,-245 |  |  | M |
| AE | Matériel de transport | 2 | 245,-2845,-2945 |  |  | M |
| AF | Avances et acomptes versés sur immobilisations | 2 | 25,-295 |  |  | M |
| AG | Dépôts et cautionnements | 2 | 275 |  |  | M |
| AH | Autres immobilisations corporelles et financières | 2 | 26,27,-275 |  |  | M |
| AZ | TOTAL ACTIF IMMOBILISE |  |  |  | AA+AB+AC+AD+AE+AF+AG+AH | H |
| BA | Actif circulant HAO | 3 | 485,486,488 | D |  | M |
| BB | Stocks et encours | 4 | 31,32,33,34,35,36,37,-39 |  |  | M |
| BC | Fournisseurs débiteurs | 5 | 409,-490 | D |  | M |
| BD | Clients-usagers | 5 | 41,-491 | D |  | M |
| BE | Autres créances | 5 | 42,43,44,45,46,47,-492,-493,-494,-497 | D |  | M |
| BF | TOTAL ACTIF CIRCULANT |  |  |  | BA+BB+BC+BD+BE | H |
| BV | Valeurs à encaisser | 6 | 51,-591 |  |  | M |
| BW | Banques, établissements financiers, caisses et assimilés | 6 | 52,53,55,57,-592,-593,-595 | D |  | M |
| BX | TOTAL TRESORERIE ACTIF |  |  |  | BV+BW | H |
| BY | Ecart de conversion-Actif | 7 | 478 | D |  | M |
| BZ | TOTAL GENERAL |  |  |  | AZ+BF+BX+BY | H |

#### Bilan Passif (p. 401)

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| CA | Fonds affectés aux investissements | 8 | 162,163,164 | C |  | M |
| CB | Report à nouveau (+ ou -) |  | 12 |  |  | M |
| CC | Solde des opérations de l'exercice |  | 13 |  |  | M |
| CD | Subventions d'investissement | 9 | 14 | C |  | M |
| CZ | TOTAL RESSOURCES PROPRES ET ASSIMILEES |  |  |  | CA+CB+CC+CD | H |
| DA | Emprunts et dettes assimilées | 10 | 18 | C |  | M |
| DB | Provisions pour risques et charges | 10 | 19 | C |  | M |
| DC | TOTAL DETTES FINANCIERES ET RESSOURCES ASSIMILEES |  |  |  | DA+DB | H |
| DD | TOTAL RESSOURCES STABLES |  |  |  | CZ+DC | H |
| DE | Dettes circulantes HAO | 3 | 481,484,486,488 | C |  | M |
| DF | Fonds d'administration | 8 | 462,463,464 | C |  | M |
| DG | Fournisseurs | 11 | 401,402,408 | C |  | M |
| DH | Autres dettes | 11 | 42,43,44,45,471,472,473,474,475,476,477 | C |  | M |
| DI | Provisions pour risques et charges à court terme | 20 | 499,599 | C |  | M |
| DJ | TOTAL PASSIF CIRCULANT |  |  |  | DE+DF+DG+DH+DI | H |
| DW | Banques, établissements financiers et crédits de trésorerie | 12 | 52,56 | C |  | M |
| DX | TOTAL TRESORERIE PASSIF |  |  |  | DW | H |
| DY | Ecart de conversion-Passif | 7 | 479 | C |  | M |
| DZ | TOTAL GENERAL |  |  |  | DD+DJ+DX+DY | H |

#### Compte d'exploitation (p. 402)

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| RA | Fonds d'administration consommés | 8 | 702 |  |  | M |
| RB | Ventes de marchandises, produits finis et prestations de services | 13 | 705 |  |  | M |
| RD | Autres produits et transferts de charges | 13 | 72,73,75,781 |  |  | B |
| RE | Reprises de provisions | 21 | 79 |  |  | M |
| XA | REVENUS |  |  |  | RA+RB+RD+RE | H |
| TA | Achats de biens, marchandises, matières premières et fournitures liées | 14 | 601,602 |  |  | M |
| TB | Autres achats | 14 | 604,605,606,608 |  |  | M |
| TC | Variation de stocks de biens, marchandises, matières et fournitures et autres | 4 | 603 |  |  | M |
| TD | Transports | 15 | 61 |  |  | M |
| TG | Services extérieurs | 16 | 62,63 |  |  | M |
| TH | Impôts et taxes | 17 | 64 |  |  | M |
| TI | Autres charges | 18 | 65 |  |  | M |
| TJ | Charges de personnel | 19 | 66 |  |  | M |
| TK | Frais financiers et charges assimilées | 20 | 67 |  |  | M |
| TJ2 | Dotations aux provisions ⚠ | 21 | 69 |  |  | M |
| TK2 | Produits H.A.O. | 22 | 82,84,86,88 |  |  | B |
| TL | Charges H.A.O. | 22 | 81,83,85 |  |  | B |
| XB | CHARGES DE FONCTIONNEMENT |  |  |  | TA+TB+TC+TD+TG+TH+TI+TJ+TK+TJ2+TL | H |
| XC | SOLDE DES OPERATIONS DE L'EXERCICE (XA-XB) ⚠ |  |  |  | XA-XB | H |

#### Notes annexes (24)

N1 Informations obligatoires ; N2 Notes sur le TER, le tableau d'exécution budgétaire et le tableau de réconciliation de trésorerie ; N3A Immobilisations brutes ; N3B Biens pris en location-acquisition ; N4 Actif circulant et dettes circulantes HAO ; N5 Stocks et encours ; N6 Clients-usagers et autres créances ; N7 Disponibilités ; N8 Ecarts de conversion ; N9 Fonds du bailleur ; N10 Subventions ; N11 Dettes financières et ressources assimilées ; N12 Dettes fournisseurs et assimilées, dettes fiscales et sociales ; N13 Banques, crédit d'escompte et de trésorerie ; N14 Revenus et autres produits ; N15 Achats ; N16 Transports ; N17 Services extérieurs ; N18 Impôts et taxes ; N19 Autres charges ; N20A Charges de personnel ; N20B Effectifs, masse salariale et personnel extérieur ; N21 Charges et revenus financiers ; N22 Dotations et charges pour provisions ; N23 Autres charges et produits HAO ; N24 Tableau d'exécution budgétaire

Tableau d'exécution budgétaire (p. 399) : colonnes budget de l'exercice, décaissements, engagements non payés, réalisations, crédit disponible, % d'exécution, par ligne de la nomenclature budgétaire du projet (hors balance).


#### Écarts/ambiguïtés projets

- `EBNL-P-TER.FA` : intitulés FA/FB identiques ('Fonds reçus, Bailleurs ....') : à personnaliser par bailleur ; comptes : flux des 162/462
- `EBNL-P-TER.FT` : 161 'Fonds projet de développement - avances de fonds à justifier' : rapprochement présumé
- `EBNL-P-EXPLOITATION.TJ2` : le modèle officiel répète le code TJ (charges de personnel puis dotations) et TK (frais financiers puis produits HAO) : codes dédoublés ici en TJ2/TK2/TL
- `EBNL-P-EXPLOITATION.XC` : doit être nul pour un projet (art. 8-9 : quotité de ressources équivalant aux charges)

### b.4 SYCEBNL — Système minimal de trésorerie

États : Bilan (GA..HZ), Compte de résultat (KA..KZC), 5 notes (1 Tableau d'acquisition et de suivi du matériel, du mobilier et des cautions ; 2 État des stocks ; 3 État des créances et des dettes non échues ; 4 Journal unique de trésorerie ; 5 Dotations). Comptabilité de trésorerie : fait générateur = encaissement/décaissement (Partie 4 §1.3) ; tableau des dettes et créances extra-comptable en fin d'exercice. Le calculateur ne peut pas les produire depuis une balance en droits constatés : il faut un journal unique de trésorerie.

#### Bilan SMT

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| GA | Immobilisations (à faire figurer si significatives) ⚠ | 1 |  |  |  | H |
| GB | Stocks | 2 |  |  |  | H |
| GC | Adhérents, clients-usagers et autres débiteurs | 3 |  |  |  | H |
| GD | Caisse | 4 |  |  |  | H |
| GE | Banque (en + ou en -) | 4 |  |  |  | H |
| GZ | Total actif |  |  |  | GA+GB+GC+GD+GE | H |
| HA | Dotations | 5 |  |  |  | H |
| HB | Résultat net de l'exercice (en + ou en -) |  |  |  |  | H |
| HC | Autres fonds propres |  |  |  |  | H |
| HD | Fournisseurs et autres créditeurs | 3 |  |  |  | H |
| HZ | Total passif |  |  |  | HA+HB+HC+HD | H |

#### Compte de résultat SMT

| ref | libellé officiel | note | comptes (préfixes ; `-` = déduit) | solde | formule | conf. |
|---|---|---|---|---|---|---|
| KA | Revenus encaissés | 4 |  |  |  | H |
| KB | Autres recettes sur activités | 4 |  |  |  | H |
| KX | TOTAL DES REVENUS ENCAISSES (A) |  |  |  | KA+KB | H |
| JA | Dépenses sur achats | 4 |  |  |  | H |
| JB | Dépenses sur loyers | 4 |  |  |  | H |
| JC | Dépenses sur salaires | 4 |  |  |  | H |
| JD | Dépenses sur impôts et taxes | 4 |  |  |  | H |
| JE | Charges d'intérêts | 4 |  |  |  | H |
| JF | Autres dépenses sur activités | 4 |  |  |  | H |
| JX | TOTAL DEPENSES SUR CHARGES (B) |  |  |  | JA+JB+JC+JD+JE+JF | H |
| KZ | SOLDE : Excédent (+) ou insuffisance (-) de recettes (C=A-B) |  |  |  | KX-JX | H |
| VA | + Variations des stocks sur les achats [N-(N-1)] |  |  |  |  | H |
| VB | + Variation des créances [N-(N-1)] |  |  |  |  | H |
| VC | - Variation des dettes d'exploitation [N-(N-1)] |  |  |  |  | H |
| JG | DOTATIONS AUX AMORTISSEMENTS |  |  |  |  | H |
| KZC | RESULTAT NET DE L'EXERCICE ⚠ |  |  |  | KZ+VA+VB-VC-JG | H |

### b.5 Plan de comptes SYCEBNL (différences avec SYSCOHADA, S1 pp. 75-105)

Classes : 1 ressources durables (10 dotation, 11 réserves, 12 report à nouveau, 13 résultat, 14 subventions d'investissement, 15 provisions réglementées et fonds assimilés, **16 fonds affectés** et provenant de dons ou legs d'immobilisations, **17 fonds reportés**, 18 emprunts et dettes assimilées, 19 provisions) ; 2 actif immobilisé (20 immobilisations destinées à la vente provenant de dons et legs non encore reçus et usufruit temporaire … 29) ; 3 stocks (31 biens liés à l'activité, 34 dons en nature, 38 dons en nature HAO) ; 4 tiers (41 adhérents, clients-usagers ; 45 fondateurs, apporteurs ; **46 bailleurs, fonds d'administration** ; 473 subventions à recevoir ; 475 générosités financières à recevoir) ; 5 trésorerie (pas de 54) ; 6 charges ; 7 produits (701 cotisations, 702 quote-part de fonds d'administration transférés, 703 quote-part de dotation consomptible transférée, 704 revenus liés à la générosité, 705 ventes, 706 revenus des manifestations, 71 subventions d'exploitation, 792 reprises de fonds affectés, 796 reprises des fonds reportés) ; 8 autres charges et produits HAO (88 subventions d'équilibre) ; 9 contributions volontaires en nature (90/91) puis comptabilité analytique (92-99). Il n'y a **pas** de compte « fonds dédiés » : le terme est celui du plan associatif français, non SYCEBNL.

## c) Articulation avec les plans SFD

| id | règle | source | URL | confiance | vérif. |
|----|----|----|----|----|----|
| OHADA-ART-001 | Les établissements de microfinance et établissements de crédit ne sont pas assujettis au SYSCOHADA : un SFD ne produit pas le jeu d'états SYSCOHADA comme états réglementaires. Il relève de son référentiel sectoriel (UEMOA : RCSFD, instruction BCEAO n°025-02-2009 ; CEMAC : PCEMF ; RDC : PCCI, instr. 006). | AUDCIF art. 5 al. 3 ; dossiers `uemoa-bceao`, `cemac-beac`, `rdc-bcc` du dépôt | S2 | HAUTE (exclusion) / MOYENNE (renvois sectoriels, non relus ici) | ? |
| OHADA-ART-002 | Une association ou entité à but non lucratif soumise à un système de comptabilité à régime particulier est hors SYCEBNL : un SFD associatif (IMF constituée en association) tenu par le RCSFD/PCEMF/PCCI n'applique donc pas le SYCEBNL. | SYCEBNL art. 2 al. 3 | S1 | HAUTE (texte) ; application aux SFD = lecture du rédacteur (BASSE) | ? |
| OHADA-ART-003 | Une entité commerciale ou une entité non financière cliente d'EDIP (société, GIE, coopérative non financière, association, projet de développement) relève du SYSCOHADA (système normal ou SMT) ou du SYCEBNL selon sa nature et ses ressources. Les sociétés coopératives sont dans le champ de comptabilité financière (AUDCIF art. 2). | AUDCIF art. 2, 5 ; SYCEBNL art. 1-2 | S1, S2 | HAUTE | ? |
| OHADA-ART-004 | Un SFD qui exerce aussi une activité non financière hors agrément (rare) ou dont un texte national l'imposerait pourrait devoir produire des états OHADA complémentaires, ainsi que la DSF fiscale : NON TROUVÉ (aucun texte lu). | — | — | BASSE | ? |

Conséquence produit : SFD → paquets UEMOA/CEMAC/RDC existants ; entreprises → `SYSN-*` ; associations/ONG/projets → `EBNL-*` selon l'option système normal / SMT. L'existant `uemoa-bceao-sycebnl.yml` applique le SYCEBNL à des « IMF à but non lucratif » : voir d).

## d) Écart vs l'existant

### d.1 `sfd-reporting-service/.../zones/uemoa-bceao-sycebnl.yml` (REG-BCEAO-008 à 012)

| point | existant | texte OHADA | action suggérée |
|---|---|---|---|
| Base légale | commentaire « Instruction BCEAO IMF SYCEBNL » | aucun texte BCEAO lu ; SYCEBNL art. 2 exclut les entités à régime comptable particulier ; AUDCIF art. 5 exclut les EMF | NON TROUVÉ : source à produire ou zone à renommer (OHADA-SYCEBNL) |
| REG-BCEAO-008 « Bilan SYCEBNL » | postes SYB-A99 / SYB-P99 (totaux seulement) | refs officielles AA..BZ, CA..DZ (bilan associations) ; AA..BZ / CA..DZ distincts pour les projets | remplacer par les 59 postes `EBNL-A-BILAN-*` |
| REG-BCEAO-009 « Compte excédent/déficit » | SYCR-099 seul | RA..RH, XA, TA..TL, XB, XC, TM, TN, XD, XE (excédent/déficit = XE) | remplacer par `EBNL-A-RESULTAT` |
| REG-BCEAO-010 « TER » | présenté comme état de toute EBNL, postes SYTER-E99/R99 | le TER n'existe que pour les projets de développement (art. 4 2°, 11) ; les associations ont un **TFT** | remplacer par `EBNL-A-TFT` (associations) et `EBNL-P-TER` (projets) |
| REG-BCEAO-011 « Fonds dédiés classe 17 » | compte 17 | 17 = **fonds reportés** ; fonds affectés = 16 ; « fonds dédiés » n'existe pas dans le plan SYCEBNL | CW (16) et CX (17) du bilan passif + Note 17B |
| REG-BCEAO-012 « État des subventions » | 14 et 71 | pas d'état officiel ; Note 17A (subventions d'investissement 14), RF (71) ; projets : Note 10 | supprimer comme état, garder en note |
| États manquants | — | TFT, notes (35/24), TEB, TRT, Compte d'exploitation, SMT (bilan/CR/5 notes) | ajouter (paquet-draft.yml) |

### d.2 `sfd-comptabilite-service` (états financiers)

| point | existant | écart / risque |
|---|---|---|
| `etats-financiers.json` | un seul référentiel SYSCOHADA système normal (pays CD, devise CDF), 4 états + 45 notes ; chargé par `SyscohadaLiasseReferentiel` | pas de référentiel SYCEBNL ni SMT dans le moteur de liasse |
| `/etats-financiers/bilan/{id}/sycebnl` et `/ter-sycebnl/{id}` | `genererTerSycebnl` ré-étiquette le bilan (emplois = actif, ressources = passif) ; TODO « TER SYCEBNL future implementation » | ce n'est pas le TER officiel (FA..GZ) et ne correspond à aucun état des associations ; bilan SYCEBNL absent des refs officielles |
| Plan SYCEBNL (`uemoa|cemac/sycebnl/plan-comptable.yml`, 3 723 lignes) | numéros et libellés alignés sur le plan officiel (16, 17, 101, 165, 658, 701, 703, 792, 796, 81-88, 91…) | RAS ; comptes utilisables tels quels pour les mappings |
| 477 (produits constatés d'avance) | absent de BJ et DM | à ajouter à DM (créditeur) |
| 219, 239, 249 (en cours) | absents de AH, AK, AM | à ajouter (avec dépréciations 2919, 2939, 2949) |
| 899 | absent de RS | à ajouter |
| TFT FI/FJ | les deux sur 82 | double compte possible ; 821, 822 / 826 |
| TFT FK/FM | mêmes comptes 101-104 | règle crédit/débit à expliciter |
| TFT FD/FE | 409, 419, 481/484/488 non couverts | contrôle ZH = BT − DT peut échouer |
| Note 34 CAFG | 676 soustrait deux fois (67 inclut 676) ; 776 non isolé ; lignes « Transferts de charges HAO » et « Charges HAO » absentes | recalculer selon `SYSN-NOTE34-CAFG` |
| Notes | pas de notes 37, 38, 39, 3C bis, 8B, 8C (variante DGI-CI) | optionnel selon pays |

## e) Lacunes / à confirmer

- PCG OHADA officiel annexé à l'AUDCIF et son modèle de liasse du système normal : NON LU ; refs et libellés SYSCOHADA recoupés seulement sur une liasse remplie DGI Côte d'Ivoire (S3, MOYENNE) et le JSON existant.
- Modèle officiel des états du **SMT SYSCOHADA** (postes) : NON TROUVÉ ; seuls les seuils et la structure (art. 13, 21, 28) sont connus.
- SYCEBNL : table poste → comptes officielle (Partie 2 chap. 3, pp. 106-308) non lue ; les comptes du paquet sont déduits du plan + intitulés ; les attributions BASSE (RG, TM/TN, FE-FH, TER, TRT) sont à valider avec la Partie 2 chap. 3 et la Partie 3.
- SYCEBNL : refs GR..GZ du TER et lettrage du TRT lus à faible contraste ; l'OCR du TRT est partiel.
- Footnote (1) du TFT SYSCOHADA (FB, FE) et formules officielles de FF-FQ (acquisitions brutes issues de la note 3A) : non lues.
- Délai de dépôt fiscal (DSF) par pays et variantes (CI, Togo, Cameroun, RDC, autres) : NON TROUVÉ ; Togo OTR et Cameroun DGI seulement signalés.
- Date de première application du SYCEBNL aux comptes : 01/01/2024 (art. 28) ; modalités de transition (bilan d'ouverture) : non lues.
- Obligations d'un SFD associatif au titre du SYCEBNL ou de la DSF : NON TROUVÉ (OHADA-ART-004).
- Audit : pas de seuil SMT SYCEBNL pour l'auditeur (art. 19 s'applique aux EBNL en général, trois critères alternatifs).
- Conservation 10 ans (AUDCIF art. 24, rendu applicable par SYCEBNL art. 3) : voir `conservation.md` ; confiance revue à la hausse (texte lu).

## Choix de produit (hors réglementation)

- Codes de rapports (`SYSN-*`, `EBNL-*`, `SMT-*`), colonnes techniques (`brut_n`, `net_n1`…), extensions YAML (`soldeRetenu`, `flux`, `variationCreances`…) : conventions internes.
- Choix d'un état par type de client (entreprise → SYSN ; association → EBNL-A ; projet → EBNL-P ; petite entité → SMT) ; sélecteur système normal / SMT piloté par les seuils (CA HT ou ressources) avec option.
- Mapping BASSE/MOYENNE des comptes SYCEBNL : décision produit provisoire tant que la Partie 2 chap. 3 n'est pas lue.

## f) Complément Tavily (2026-10-19)

Sources lues : Guide d'application SYSCOHADA (G, intégral), Guide d'application SYCEBNL (G-EBNL), transcription page à page du JO OHADA 22/02/2023 (JO-EBNL, OCR bruité → MOYENNE, à relire visuellement p. 395-396 et 430-431 sur https://www.ohada.com/uploads/actualite/6692/SYSCEBNL.pdf). Table PCGO Titre IX ch. 7 (SYSCOHADA poste → comptes) **non lue** : bilan SYSCOHADA reste MOYENNE.

| id | règle | source | URL | confiance | vérif |
|---|---|---|---|---|---|
| OHADA-ETF-101 | Contenu de chaque poste exprimé en numéros de compte dans les tableaux Postes/Comptes (PCGO Titre IX ch. 7), non reproduits par le Guide. | G §1 b | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-102 | CAFG = EBE (XD) + débit 654 − crédit 754 + résultat financier (XF) + autres produits HAO (TO) + autres charges HAO (RP) + participation (RQ) + impôts (RS). | G §4.2.3.2 a | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-103 | Variation du BFR : BA hors 485 ; BB ; BG hors 414, 467, 458, 4494, 4751 ; DP hors 404, 481, 482, 467, 4752, 472 ; après annulation de la correction d'écart de conversion. | G §4.2.3.2 b | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-104 | Acquisitions = variation immobilisations nettes AD, AI, AN + dotations + VNC cédée, moins réévaluation (106, 154), démantèlement, location-acquisition, 2714 ; décaissement net des dettes 481, 482, 404 et avances du compte 25. | G §4.2.3.3 a-b | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-105 | Encaissement de cession = crédit 82 ou 754 − débit 485 et 414 ; FI = 821, 822, 754 ; FJ = 826. | G §4.2.3.3 c | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-106 | Augmentation de capital = variation classe 10 hors 106, 109 + 467, 4581 ; subventions = variation 14, 4582, 4494 ; dividendes = débit 465. | G §4.2.3.4 | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-107 | Capitaux étrangers = variation 16 et 18 hors intérêts courus ; 17 : remboursement seulement ; trésorerie finale corrigée de 472. | G §4.2.3.5-6 | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-108 | CR : TA 701 ; RA 601 ; RB 6031 ; CA = 70 ; TE..TI = 73, 72, 71, 75, 781 ; RK 66 ; RL 681, 691 ; TJ 791, 798, 799 ; revenus financiers 77, 797, 787 ; frais financiers 67, 697 ; produits HAO 82, 84, 86, 88 ; charges HAO 81, 83, 85 ; RQ 87 ; RS 89 (net). | G §3.2 | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | HAUTE | ? |
| OHADA-ETF-109 | 36 modèles de notes (pas 35) ; numéros certains : 1, 2, 3A, 3C-3E, 4-8, 11-14, 17-19, 21-26, 28-34 ; note 2 = déclaration de conformité. | G §5 | https://www.ohada.com/uploads/actualite/3504/Guide-d-application-du-SYSCOHADA.pdf | MOYENNE | ? |
| OHADA-ETF-110 | SYCEBNL association, bilan actif : AB 201/280, 2901 ; AC 202-205/2902 ; AE 212-214, 2193 ; AF 218, 2198 ; AG 251 ; AI 22 ; AJ 231-233, 2391-2393, 2396 ; AK 234, 235, 238, 2394, 2395, 2398 ; AL 24 hors 245/2495 ; AM 245, 2495 ; AN 252 ; AX 26 ; AY 27. | JO-EBNL p.395 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-395.html | MOYENNE | ? |
| OHADA-ETF-111 | SYCEBNL association, circulant et passif : BA 485, 4865 ; BB 31-34, 36-38 ; BC 409 ; BD 41 hors 419 ; BE soldes débiteurs 42-45, 47 hors 478 ; BU 50 ; BV 51 ; BW 52, 53, 55, 57 ; BY 478 ; CA 101 … CJ 15 ; CW 16 ; CX 17 ; DA 181-183, 185, 186, 188 ; DB 187 ; DC 19 ; DF 481, 484, 4861, 488, 4998 ; DG 419 ; DH 40 hors 409 ; DI créditeurs 42-45, 47 hors 479, 499, 599 ; DW 56 + créditeurs 52, 53 ; DY 479. | JO-EBNL p.395 | idem | MOYENNE | ? |
| OHADA-ETF-112 | SYCEBNL association, CR : RA 701 ; RB 703 ; RC 704 ; RD 7051 ; RE 7052, 7053 ; RF 71 ; RG 706-708, 72, 73, 75, 77, 78 ; RH 79 ; TA 601 … TL 68, 69 ; TM 82, 84, 86, 88 ; TN 81, 83, 85, 87. | JO-EBNL p.396 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-396.html | MOYENNE | ? |
| OHADA-ETF-113 | TFT association : refs FA..FQ, ZA..ZG ; aucune table poste → comptes → FE-FH = choix produit. | JO-EBNL p.348 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-348.html | MOYENNE | ? |
| OHADA-ETF-114 | SYCEBNL projets, bilan : AA 21 ; AB 22, 231-233, 2391-2393, 2396 ; AC 234, 235, 238, 2394, 2395, 2398 ; AD 24 hors 245/2495 ; AE 245, 2495 ; AF 25 ; AG 275 ; AH 26, 27 hors 275 ; BA 485 ; DE 481, 484, 4998 ; DF 46 ; DG 40 hors 409 ; CA 16 ; CD 14 ; DA 18. | JO-EBNL p.430 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-430.html | MOYENNE | ? |
| OHADA-ETF-115 | SYCEBNL projets, compte d'exploitation : RA 702 ; RB 705 ; RC 71 ; RD 707, 72, 73, 75, 77, 78 ; RE 79 ; TA 601, 602 ; TB 604-606, 608 ; TC 603 ; TD 61 ; TG 62, 63 ; TH 64 ; TI 65 ; TJ 66 ; TK 67 ; HAO 81-88 (TJ/TK répétés à l'OCR). | JO-EBNL p.431 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-431.html | MOYENNE | ? |
| OHADA-ETF-116 | TER officiel (mouvements de balance) : FA, FB 161, 162, 462 ; FC 163, 463 ; FD 164, 464, 707, 77 ; FE 21 … FS 67 ; FT débiteur 4091, 4093 ; fonds début/fin = débiteurs 51, 52, 53, 55, 57 ; retraitements variations 481 (hors 4813), 401, 44, 42, 43, crédit 166. | G-EBNL ch. 7 | https://www.ohada.org/wp-content/uploads/2023/04/SYCEBNL-GUIDE-D-APPLICATION.pdf | HAUTE | ? |
| OHADA-ETF-117 | SMT SYCEBNL : chaque ressource ≤ 30 M FCFA ; au-delà ou cumul > 30 M sur 2 exercices → système normal. | SYCEBNL art. 6 | https://plan-comptable-ohada.com/sycebnl/acte-uniforme.html | MOYENNE | ? |
| OHADA-ETF-118 | Modèle SMT SYCEBNL : bilan GA-GE/GZ, HA-HD/HZ ; CR KA, KB, KX, JA-JF, JX, KZ, VA-VC, JG, KZC ; notes 1-5 (note 4 = journal unique de trésorerie). | JO-EBNL p.434-438 | https://plan-comptable-ohada.com/sycebnl/etats-financiers/page-435.html | MOYENNE | ? |
| OHADA-ETF-119 | SYCEBNL inapplicable aux entités « soumises à un régime particulier » → SFD (RCSFD) hors SYCEBNL. | SYCEBNL art. 2 al. 3 | idem | MOYENNE | ? |
| OHADA-ETF-120 | AUDCIF art. 5 : établissements de microfinance non assujettis au SYSCOHADA → pas de double reporting OHADA, sauf fiscal (DSF). | AUDCIF 2017 art. 5 | https://www.nanan.ai/textes/acte-uniforme-relatif-au-droit-comptable-et-a-l-information-financiere/articles/article-5 | MOYENNE | ? |
| OHADA-ETF-121 | Cameroun : DSF au 15 mars (DGE), 15 avril (CIME, CSI), 15 mai (CDI), dépôt électronique impots.cm. | DGI Cameroun | https://www.impots.cm/fr/declarations-statistiques-et-fiscalesdsf | HAUTE | ? |
| OHADA-ETF-122 | Togo : dépôt avant le 30 avril sur GUDEF (OTR), prorogations annuelles. | OTR | https://www.otr.tg | HAUTE | ? |
| OHADA-ETF-123 | Côte d'Ivoire : 30 mai, ou 30 juin si CAC ; télétransmission DGE/DME. | DGI-CI calendrier | https://www.dgi.gouv.ci/assets/documents/CALENDRIER.pdf | HAUTE | ? |
| OHADA-ETF-124 | Sénégal : 30 avril, SEN-ETAFI, CAC 31 juillet ; RDC : 30 avril, DGI/CPCC, certification ONEC. | DGID ; Wayma | https://www.dgid.sn | MOYENNE / BASSE | ? |

Traitement des points de mapping EDIP signalés : 477 = passif circulant (dans DP) ; 219/239/249 à éclater (SYCEBNL) ; RS = 89 net (899 déduit) ; FI 821+822+754 / FJ 826 ; 409 dans FD, 419 dans FE, 488 retiré de DH ; 676/776 inclus une fois dans 67/77 ; 848 déjà dans 84 (double compte supprimé) ; 797/697 exclus de la CAFG (MOYENNE).

Patches appliqués à `paquet-draft.yml` : EBNL-A-BILAN-ACTIF (AB-AN), EBNL-A-RESULTAT (RE, RG, TN), EBNL-P-TER (FA-FZ, HAUTE), SYSN-TFT (FD, FE, FI, FJ, HAUTE), SYSN-NOTE34-CAFG (fusion 77/67, 89 net, 848 retiré), EBNL-P-BILAN-ACTIF (AF-AH), seuil SMT, calendrier DSF par pays, 36 notes, applicabilité SFD.

### Lacunes restantes après Tavily
- Table PCGO Titre IX ch. 7 (bilan/CR SYSCOHADA poste → comptes) : à obtenir (JO 15/02/2017 intégral).
- Modèle SMT SYSCOHADA (Titre X) : NON TROUVÉ.
- Titres des notes 9, 10, 15, 16, 20, 27, 35, 36 et contenu minimal.
- TFT association FE-FH et TRT : choix produit (aucune table officielle).
- DSF BJ, BF, ML (sources primaires), RDC (texte légal).
