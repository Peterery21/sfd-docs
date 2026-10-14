# Vérification indépendante — réglementation CEMAC/BEAC/COBAC

Date : 2026-10-13. Vérificateur indépendant (n'a pas modifié `cemac-beac/`).
Légende : ✔ = ≥2 sources indépendantes (ou texte primaire + plan) ; ◐ = 1 source ; ✘ = infirmé ; ? = non retrouvé.

## Méthode et sources relues par le vérificateur
- PCEMF (PDF BEAC, 1 Mo, texte natif) : libellés, n° de comptes et commentaires vérifiés par grep sur le texte extrait. Les n° de page imprimés n'ont pas été recontrôlés.
- Règl. 01/17 : PDF sgg.cg (scan 21 Mo, lu hors dépôt) https://www.sgg.cg/txts-droit-reg/cemac-reglement-2017-01-exercice-controle-microfinance.pdf. Le README le déclare « NON lu » : il est lisible.
- Règl. 01/02, 01/03, R-2005/01, 04/19, 02/25, EMF 2002/04-10-12-14 : PDF BEAC/APECCAM, OCR local (scans).
- Secondaires : présentation Promote 2019, droitmediasfinance.com (02/25), Instruction BEAC 004/2021 https://www.beac.int/wp-content/uploads/2021/12/Instruction-du-Gouverneur-N°004-2021_compressed.pdf (04/19).
- Un seul texte primaire lu par règle = ◐ même quand le texte est exact. Une ligne ◐ dont la formulation est exacte est donc « fiable, non recoupée ».

## Constats prioritaires
1. **✘ Règl. 04/19 : date d'entrée en vigueur.** `README`/TUS-014 donnent « 20 déc. 2019 (en vigueur à la signature) ». Le texte (OCR) indique seulement la session du Comité ministériel du 20 déc. 2019 à Douala ; la date de signature est manuscrite et illisible. L'Instruction BEAC 004/2021 (primaire) cite trois fois « Règlement N° 04/19/CEMAC/UMAC/CM du **10 août 2020** » (le résultat de recherche DMF concorde). Numéro, titre, champ (art. 2 : EMF inclus), art. 4-19, 22-24, 26-28, 32-33, 40 : exacts. À corriger : adoption 20/12/2019, signature et vigueur 10/08/2020.
2. **Règl. 02/25 « comptes inactifs »** : numéro 02/25/CEMAC/UMAC/CM/COBAC confirmé (droitmediasfinance https://droitmediasfinance.com/index.php/actualites/droit-bancaire/1050-cemac-quest-ce-qui-change-avec-les-deux-nouveaux-reglements-sur-les-comptes-inactifs-les-avoirs-en-desherence-et-la-supervision-des-caisses-de-depots-et-consignations), adopté le 12 juillet 2025 à Malabo (OCR). Seuils 12 / 36 mois et 10 ans exacts. Vigueur : art. 30 OCR « 1er septembre ?02? » ; la lecture « 2028 » du rédacteur est du bruit OCR ; le 1er sept. 2025 est donné par kalieu-elongo (via recherche) mais DMF le rattache au règlement jumeau 01/25. Reste ◐. Art. 24-26 (transitoire) : l'OCR saute de l'art. 23 à l'art. 27.
3. **01/02 vs 01/17** : 01/17 = 27 sept. 2017 (Douala), vigueur 1er janv. 2018, art. 113 abroge expressément le 01/02 du 13 avril 2002. Exact. Précision : art. 43 et 46 du 01/17 renvoient le capital minimum (2e, 3e cat.) à un règlement COBAC, pas de chiffre dans 01/17 (les 300 / 150 M viennent de R-2017/03 ; voir PAR-009, PRU-002). Les art. 01/02 8, 9, 11, 45, 46, 48, 56 ont un équivalent 01/17 : art. 19, 20-23, 103, 6, 17.
4. **PCEMF = « PROJET »** : la page de titre du PDF porte « PROJET DU PLAN COMPTABLE… Edition : janvier 2010 ». Le texte d'adoption (règl. COBAC EMF-2010/01, session du 1er avril 2009 à Bata) est bien dans le PDF. Statut « projet » à signaler dans le README.
5. **CRD-013 (R-2017/07)** : Promote 2019 dit « non-prise en compte de la notion de créance sensible » ; un résumé Lextenso (recherche) dit que R-2017/07 classe en saines/sensibles/douteuses. Sources contradictoires, texte R-2017/07 toujours non lu.
6. **CRD-019** : le PCEMF (p. 110) attribue à l'art. 45 du 01/02 l'interdiction d'escompter des valeurs sur l'extérieur ; le texte de l'art. 45 (et de l'art. 103 du 01/17) interdit seulement toute « opération financière avec l'extérieur en qualité d'intermédiaire ». La glose est celle du PCEMF, pas du règlement.
7. **TUS-007** : art. 10 (TEG dépassé) = intérêts au taux directeur BEAC ; l'art. 21 (prêt usuraire) prévoit des « intérêts légaux ». Le fichier ne cite que l'art. 10.

## Table des règles
| id | verdict | commentaire |
|----|---------|-------------|
| CEMAC-CPT-001 | ◐ | Convention 16/10/1990 art. 9 et art. 46 du 01/02 cités par le PCEMF : exacts (art. 46 relu dans le 01/02). EMF-2010/01 : numéro uniquement dans le PCEMF (session 01/04/2009, Bata) ; cf. constat 4. |
| CEMAC-CPT-002 | ◐ | PCEMF préambule : s'inspire du PCEC, OHADA, « indicatif » (l. 156). Exact. |
| CEMAC-CPT-003 | ◐ | Art. 1.2.1-1.2.6 présents ; exception « perception effective » confirmée. |
| CEMAC-CPT-004 | ◐ | Art. 1.3.3 non-compensation présent. |
| CEMAC-CPT-005 | ◐ | Renvoi à EMF-2010/02 confirmé (l. 353) ; texte 2010/02 non lu. |
| CEMAC-CPT-006 | ◐ | Art. 4.1 ; exemple 18519 « Emprunt LT réseau » confirmé ; 5e chiffre 9 cohérent (34109, 47129). |
| CEMAC-CPT-007 | ◐ | Comptes 30-33, 35-39 confirmés dans la table. |
| CEMAC-CPT-008 | ◐ | 5710/5711, 459 « solde nul en fin de journée » (commentaire du 57) confirmés. |
| CEMAC-CPT-009 | ◐ | 5600, 5602, 561 confirmés. |
| CEMAC-CPT-010 | ◐ | 4631-4635, 6795, 7786 et commentaire 463 (« excédents… pas virés en produits ») confirmés. |
| CEMAC-CPT-011 | ◐ | Comptes 45/38/387 présents ; commentaires non relus ligne à ligne. |
| CEMAC-CPT-012 | ◐ | 475, 476, 477 présents. |
| CEMAC-CPT-013 | ◐ | 723, 623, 7411, 6411 libellés exacts. |
| CEMAC-CPT-014 | ◐ | 711, 714, 715, 7151 exacts. |
| CEMAC-CPT-015 | ◐ | 611-614, 619 exacts. |
| CEMAC-CPT-016 | ◐ | 720, 721, 724, 755, 7551 exacts. |
| CEMAC-CPT-017 | ◐ | 6911, 6913, 6917, 6921/6922, 7913, 792 exacts. |
| CEMAC-CPT-018 | ◐ | Libellés 6921/6922/791 exacts ; commentaire d'abandon non relu. |
| CEMAC-CPT-019 | ◐ | 4711, 4712, 4722 exacts. |
| CEMAC-CPT-020 | ◐ | 931-934, 9841 exacts ; incohérences classe 9 non recontrôlées. |
| CEMAC-CPT-021 | ◐ | Incohérence confirmée : préambule 341/342 (l. 617-619) vs table 340/341. |
| CEMAC-CPT-022 | ◐ | Classe 8 (80-87), 131/132 confirmés. |
| CEMAC-CPT-023 | ◐ | 350 exact. |
| CEMAC-EPA-001 | ✔ | 01/17 art. 21 (épargne) et art. 30 (1re cat.) + 01/02 art. 9 + PCEMF. |
| CEMAC-EPA-002 | ✔ | 01/02 art. 5 ; 01/17 art. 30, 41, 44 (liste d'exclusions 3e cat.). |
| CEMAC-EPA-003 | ◐ | PCEMF classe 3 intro. |
| CEMAC-EPA-004 | ◐ | 361/369 présents. |
| CEMAC-EPA-005 | ◐ | PCEMF seul. |
| CEMAC-EPA-006 | ◐ | 375, 3751-3752 exacts. |
| CEMAC-EPA-007 | ◐ | 371-373, 3711/3712 exacts. |
| CEMAC-EPA-008 | ◐ | PCEMF seul. |
| CEMAC-EPA-009 | ◐ | 374, 3741 exacts. |
| CEMAC-EPA-010 | ◐ | 351, 353, 355, 359 exacts. |
| CEMAC-EPA-011 | ◐ | 611-614 exacts. |
| CEMAC-EPA-012 | ◐ | 720 exact. |
| CEMAC-EPA-013 | ◐ | 382, 383 exacts. |
| CEMAC-EPA-014 | ◐ | 182 exact ; compte 44 non relu en détail. |
| CEMAC-EPA-015 | ◐ | PCEMF seul. |
| CEMAC-EPA-016 | ✔ | 01/02 art. 8 et 45 relus ; 01/17 art. 19 et 103 ; PCEMF. |
| CEMAC-EPA-017 | ✔ | 01/02 art. 11 relu ; 01/17 art. 20 (moyens de paiement et transferts d'argent à titre principal) et art. 23 le confirment : la réserve « aurait » peut être levée. |
| CEMAC-EPA-018 | ◐ | 04/19 art. 22-24 exacts. |
| CEMAC-EPA-019 | ✔ | 02/25 art. 4, 2-j (OCR) + DMF (12/36 mois). |
| CEMAC-EPA-020 | ✔ | 01/17 art. 36-37 (20 % au moins) relus ; 2002/12 art. 3 relu (dépôts statutaires déduits) ; Promote. |
| CEMAC-CRD-001 | ✔ | 01/17 art. 22 (définition du crédit) ; 01/02 art. 9 ; PCEMF. |
| CEMAC-CRD-002 | ◐ | PCEMF l. 4911-4913 : CT ≤1 an, MT 1-2 ans, LT >2 ans exact. |
| CEMAC-CRD-003 | ◐ | PCEMF seul. |
| CEMAC-CRD-004 | ◐ | 331 exact. |
| CEMAC-CRD-005 | ◐ | 301-308 (couples LT/MT) exacts. |
| CEMAC-CRD-006 | ◐ | 711-713, 309/319/329 non tous recontrôlés. |
| CEMAC-CRD-007 | ◐ | « frais de dossier » absent du PCEMF (grep) ; « assurance » seulement 461 et 163. |
| CEMAC-CRD-008 | ◐ | 04/19 art. 5-6 exacts. |
| CEMAC-CRD-009 | ◐ | HISTORIQUE. 45 j / 90 j campagne, 3 mois / 6 mois immobiliers confirmés dans le PCEMF. |
| CEMAC-CRD-010 | ◐ | HISTORIQUE. 333/334/335 exacts. |
| CEMAC-CRD-011 | ◐ | 9841 exact. |
| CEMAC-CRD-012 | ◐ | HISTORIQUE. 15/45/75/100 % sur 4 ans et 100 % en 1 an confirmés (l. 5693-5700) ; 391-393, 3921, 3933 exacts. |
| CEMAC-CRD-013 | ◐ | Promote 2019 (l. 404-435) : 45 jours, 3 ans exacts. Contradiction sur « créance sensible » : voir constat 5. |
| CEMAC-CRD-014 | ◐ | PCEMF seul. |
| CEMAC-CRD-015 | ◐ | 304/314, 321, 47223 exacts. |
| CEMAC-CRD-016 | ◐ | 6791 exact. |
| CEMAC-CRD-017 | ◐ | 740 exact ; 421 non recontrôlé. |
| CEMAC-CRD-018 | ◐ | 2002/10 art. 2 relu (20 %, 30 %) ; R-2017/08 (10 % du capital libéré, 50 M FCFA) uniquement via Promote 2019 (l. 349-354) ; texte R-2017/08 non retrouvé. |
| CEMAC-CRD-019 | ◐ | Glose du PCEMF exacte, mais plus large que l'art. 45 : constat 6. |
| CEMAC-CRD-020 | ◐ | PCEMF seul. |
| CEMAC-CRD-021 | ◐ | 04/19 art. 9, 11, 19 exacts. |
| CEMAC-PAR-001 | ◐ | PCEMF classe 1 intro. |
| CEMAC-PAR-002 | ◐ | 100, 1000, 1001, 101, 1014 exacts. |
| CEMAC-PAR-003 | ◐ | 441, 4411 exacts. |
| CEMAC-PAR-004 | ◐ | 4416 « Actionnaires, versements anticipés », 4417 exacts. |
| CEMAC-PAR-005 | ◐ | 7551 exact. |
| CEMAC-PAR-006 | ◐ | 10 % / 20 % du capital confirmés (PCEMF l. 3499-3511). |
| CEMAC-PAR-007 | ✔ | EMF 2002/06 art. 1-2 relu (20 % / 15 %) + PCEMF l. 3519. Maintien en vigueur non prouvé. |
| CEMAC-PAR-008 | ✔ | EMF 2002/05 art. 1-3 relu (40 %) + PCEMF l. 3887. |
| CEMAC-PAR-009 | ◐ | Promote 2019 relu : 300/150 M, paliers 2018-2021, 30 vers 100 sociétaires, SA 2e/3e. R-2017/01-03 non ouverts ; 01/17 art. 43/46 renvoient à un règlement COBAC. |
| CEMAC-PAR-010 | ✔ | 20 % : 01/17 art. 37 relu + Promote. Plafond de parts par membre : non trouvé (déjà dit). |
| CEMAC-PAR-011 | ◐ | 443, 444 exacts. |
| CEMAC-PAR-012 | ◐ | 121, 122, 131, 132 exacts. |
| CEMAC-PAR-013 | ◐ | 163 exact. |
| CEMAC-CLO-001 | ◐ | PCEMF seul. |
| CEMAC-CLO-002 | ◐ | PCEMF seul. |
| CEMAC-CLO-003 | ◐ | PCEMF seul. |
| CEMAC-CLO-004 | ◐ | Renvoi ; instruction non lue. |
| CEMAC-CLO-005 | ◐ | EMF-2010/02 cité, non lu. |
| CEMAC-CLO-006 | ◐ | 4711/4712/4721/4722 exacts. |
| CEMAC-CLO-007 | ◐ | 459 solde nul confirmé. |
| CEMAC-CLO-008 | ◐ | PCEMF seul. |
| CEMAC-CLO-009 | ◐ | 80-87, 131/132, 443/444 exacts. |
| CEMAC-CLO-010 | ◐ | 623/723, 477 exacts. |
| CEMAC-CLO-011 | ◐ | Mention incidente ; non recontrôlé. |
| CEMAC-CLO-012 | ◐ | Promote : art. 75-81 R-2017/06 et 30 juin confirmés ; commissaires aux comptes : 01/17 art. 12 (certification au moins annuelle). R-2017/06 non lu. |
| CEMAC-CLO-013 | ◐ | 02/25 art. 11 (31 mars) et art. 14 (état mensuel) relus. |
| CEMAC-CLO-014 | ✔ | 01/02 art. 48 relu ; équivalent 01/17 art. 6 (« liste, teneur, modèles, périodicité »). |
| CEMAC-PRU-001 | ✔ | 01/02 art. 5 ; 01/17 art. 27, 30, 33, 41, 44 ; Promote (SA/coopérative). |
| CEMAC-PRU-002 | ✔ | 01/02 art. 7 relu (50 M / 25 M ; 20 % organe faîtier) ; Promote (300 / 150 M). 01/17 : chiffres renvoyés à R-2017/03. |
| CEMAC-PRU-003 | ◐ | 2002/07 relu : 10 %, art. 1-5 exacts. Statut actuel non prouvé. |
| CEMAC-PRU-004 | ◐ | 2002/14 relu : 100 %, 75 %, 50 % exacts. |
| CEMAC-PRU-005 | ◐ | 2002/08 art. 5-6 relus : 15 % / 25 % / 10 % et « octuple » exacts. |
| CEMAC-PRU-006 | ◐ | 2002/09 art. 4-5 relus (100 %, 50 %). |
| CEMAC-PRU-007 | ◐ | 2002/12 art. 4 relu (70 % / 65 %). |
| CEMAC-PRU-008 | ◐ | 2002/10 art. 2 et 5 relus ; R-2017/08 via Promote. |
| CEMAC-PRU-009 | ◐ | 2002/04 art. 1-2 relus (liste de base conforme). |
| CEMAC-PRU-010 | ✔ | 2002/06 + 2002/05 relus + PCEMF. |
| CEMAC-PRU-011 | ◐ | Art. 54 et 57 du 01/02 relus ; « 5 ans » conforme aux art. de vigueur des 2002/xx (art. 6/7/8). |
| CEMAC-PRU-012 | ◐ | Promote : 1er juillet 2018, 24 mois, 4 ans (2021) confirmés. |
| CEMAC-PRU-013 | ✔ | 01/02 art. 56 ; 01/17 art. 17 (secret non opposable) ; PCEMF. |
| CEMAC-LBC-001 | ✔ | R-2005/01 art. 2 (EMF visés) ; 01/03 art. 6 (« établissements de micro finance »). |
| CEMAC-LBC-002 | ✔ | 01/03 art. 9 relu (document officiel avec photographie, copie) ; R-2005/01 art. 4-5. |
| CEMAC-LBC-003 | ✔ | 01/03 art. 9 : seuil fixé par le Comité ministériel ; valeur absente : exact. |
| CEMAC-LBC-004 | ◐ | 01/03 art. 10 « ayant droit économique » ; art. 11 non relu. |
| CEMAC-LBC-005 | ◐ | R-2005/01 art. 8 relu (PPE, 3 mesures). |
| CEMAC-LBC-006 | ◐ | R-2005/01 art. 12 et 14 relus. |
| CEMAC-LBC-007 | ✔ | 01/03 art. 12 relu (seuils fixés par le Comité ministériel, rapport, espèces déclarées à l'ANIF) ; R-2005/01 art. 17-19. |
| CEMAC-LBC-008 | ✔ | 01/03 art. 18 ; R-2005/01 art. 26-27 (déclaration à l'ANIF, opérations déjà exécutées). |
| CEMAC-LBC-009 | ✔ | 01/03 art. 13 (5 ans) ; R-2005/01 art. 36 et 39. |
| CEMAC-LBC-010 | ◐ | R-2005/01 art. 41, 45 présents ; contenu non relu. |
| CEMAC-LBC-011 | ◐ | 02/25 art. 9 al. 2 relu. |
| CEMAC-LBC-012 | ✔ | 02/25 préambule : règlement n°02/CEMAC/UMAC/CM du 20 déc. 2024 (LBC/FT/prolifération) ; 01/17 préambule : règlement n°01/CEMAC/UMAC/CM du 11 avril 2016. |
| CEMAC-TUS-001 | ◐ | 04/19 art. 2-3 relus. |
| CEMAC-TUS-002 | ◐ | Art. 4 : exact. |
| CEMAC-TUS-003 | ◐ | Art. 5 : exact. |
| CEMAC-TUS-004 | ◐ | Art. 6 : exact. |
| CEMAC-TUS-005 | ◐ | Art. 7 : exact. |
| CEMAC-TUS-006 | ◐ | Art. 9-10 : exact (72 h). |
| CEMAC-TUS-007 | ◐ | Art. 10 exact ; omet l'art. 21 : constat 7. |
| CEMAC-TUS-008 | ◐ | Art. 11-14 : exact. |
| CEMAC-TUS-009 | ◐ | Art. 15-16 : exact. |
| CEMAC-TUS-010 | ◐ | Art. 17-18 : exact. |
| CEMAC-TUS-011 | ◐ | Art. 19 : exact. |
| CEMAC-TUS-012 | ◐ | Art. 22-24 : exact. |
| CEMAC-TUS-013 | ◐ | Art. 28 (3 M FCFA), 32 (1-6 mois ; 100 000 - 100 M FCFA), 33 (barème, récidive doublée) : exacts. |
| CEMAC-TUS-014 | ✘ | Abrogation des règl. 01 et 02 du 2 oct. 2012 : exacte (art. 40). « Vigueur à la signature (20 déc. 2019) » : faux, signature/vigueur 10 août 2020 selon l'Instruction BEAC 004/2021 ; 20/12/2019 = session d'adoption. Constat 1. |
| CEMAC-DOR-001 | ✔ | 02/25 art. 1, 2-j, 4 (OCR) ; DMF : 12 mois courants/paiement, 36 mois épargne. |
| CEMAC-DOR-002 | ◐ | Art. 2-l/m, 4 relus. |
| CEMAC-DOR-003 | ◐ | Art. 4-5, 9 relus. |
| CEMAC-DOR-004 | ◐ | Art. 6 relu (9 ans / 7 ans). |
| CEMAC-DOR-005 | ✔ | Art. 2-a, 12-15 (10 ans, CDC ou BEAC, clôture d'office sans frais) ; DMF : 10 ans, transfert sous un mois. |
| CEMAC-DOR-006 | ◐ | Art. 13-15 relus. |
| CEMAC-DOR-007 | ◐ | Art. 10 relu. |
| CEMAC-DOR-008 | ◐ | Art. 8 et 16 relus (10 ans). |
| CEMAC-DOR-009 | ◐ | Art. 9, 11 (31 mars), 28 relus. |
| CEMAC-DOR-010 | ◐ | Art. 17-23 relus (1 mois, 2 mois, 30 jours). |
| CEMAC-DOR-011 | ◐ | 383 exact. |
| CEMAC-DOR-012 | ✔ | 01/03 art. 13 et R-2005/01 art. 36 et 39 (5 ans) + 02/25 art. 16 (10 ans). |
| CEMAC-DOR-013 | ◐ | « 10 ans » confirmé par résumé secondaire ; article de l'AUDCIF non retrouvé (cf. BASSE du rédacteur). |
| CEMAC-DOR-014 | ? | Article transitoire non retrouvé ; DMF ne traite pas des art. 24-26 ; OCR 02/25 saute de l'art. 23 à l'art. 27. |

## Résumé chiffré
- Règles vérifiées : 144 (CPT 23, EPA 20, CRD 21, PAR 13, CLO 14, PRU 13, LBC 12, TUS 14, DOR 14).
- ✔ : 25 (EPA 6, CRD 1, PAR 3, CLO 1, PRU 4, LBC 7, DOR 3).
- ◐ : 117.
- ✘ : 1 (TUS-014, date du 04/19).
- ? : 1 (DOR-014).
- Aucune erreur de numéro, d'article, de seuil ni de compte relevée sur les ◐ lues. Écarts : constats 1 (date 04/19), 4 (PCEMF « projet »), 5 (R-2017/07), 6 (art. 45), 7 (art. 21).
- Non couvert : R-2017/01-09 (texte), 01/20, 04/18, instruction BEAC sur le TEG, EMF-2010/01-02. Les chiffres de ces textes restent ◐ ou non vérifiés.
