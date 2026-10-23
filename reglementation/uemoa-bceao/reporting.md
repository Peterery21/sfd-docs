# UEMOA / BCEAO — Reporting réglementaire des SFD / IMF : inventaire, structures et formules

- Zone : UEMOA (BCEAO, Commission Bancaire de l'UMOA ; tutelle nationale : Ministre chargé des Finances)
- Thème : états réglementaires à transmettre et formules de calcul
- Date de rédaction : 2026-10-19 — Rédacteur : Claude (agent de recherche reporting réglementaire)
- Norme comptable produit : RCS_SFD (RCSFD, Instr. 025-02-2009) — fichier compagnon : `paquet-draft.yml`
- Statut : brouillon de recherche, aucune règle non sourcée ; « NON TROUVÉ » partout où le texte lu est muet.

## 0. Méthode, légende et périmètre de lecture

- Textes lus au fond (PDF téléchargés puis rendus à l'image quand le texte était illisible) : Recueil SFD (déc. 2011), RCSFD allégée (annexes 1 à 4), RCSFD développée (copie du Trésor CI : annexes 1 à 4, chap. V), Instr. 010-08-2010 (19 p., scan relu), 016-12-2010, 017-12-2010, 018-12-2010 (annexe), 019-12-2010, 020-12-2010 (annexe), 030-02-2009, 001-02-2018, 006-06-2014, BIC (Instr. 005-05-2015), loi uniforme LBC/FT/FP + Décisions 021/2023 et 003/2024 + Instr. 001-03-2025, loi sénégalaise 2025-04 (transposition microfinance).
- Confiance : HAUTE = texte primaire lu par le rédacteur ; MOYENNE = texte primaire non obtenu, lu via une transposition nationale ou un relais de presse d'un communiqué officiel ; BASSE = rapporté, à confirmer.
- Statut : ✔ = postes, formules et délais complets et cohérents ; ◐ = lu mais incomplet, ambigu ou contenant une incohérence du texte (voir §e) ; ? = non transcrit, non trouvé ou transposition en attente.
- Codes d'état : le code officiel est le code DIMF du RCSFD (ex. DIMF-2010). Hors DIMF, le code est proposé : `UEMOA-REP-<famille>-NNN`.
- Les codes de postes (A01, B2D, L80…) sont ceux du RCSFD (annexe 1.1) ; les concordances sont reproduites telles que lues, y compris leurs incohérences internes signalées au §e.
- Notation des concordances : `+` ajoute, `−` retranche, `ex NNNN` = compte « extrait » (le solde est compté à l'actif s'il est débiteur, au passif s'il est créditeur : RCSFD annexe 1.1).

## a) Inventaire des états

**54 états inventoriés** — 47 de confiance HAUTE (87 %), 23 avec statut ✔. Références S1…S16 : table des sources ci-dessous.

| code état | intitulé | texte source (n°, date, article) | réf. | périodicité | délai de transmission | destinataire | assujettis | format | confiance | statut |
|---|---|---|---|---|---|---|---|---|---|---|
| DIMF-2000-BIL | Bilan (version développée ou allégée) — DIMF 2000, codes D : AA0 actif / AB0 passif | Instr. 025-02-2009 ; Instr. 030-02-2009, art. 2-8 ; Instr. 001-02-2018, art. 2-6 ; loi, art. 49-51 ; RCSFD ch. V, annexes 2.1-2.3 | S1 S2 S3 S5 | Annuelle (arrêté 31/12) | 6 mois après clôture (30/06) ; avis de publication notifié sous 7 jours | Ministre des Finances (5 ex.) ; art. 44 : + BCEAO (2 ex.) + Commission Bancaire (2 ex.) | Tous SFD ; développée : art. 44 ; allégée : encours dépôts ou crédit < 50 M FCFA sur 2 exercices (Instr. 021-12-2010) ; base combinée (faîtières) / consolidée | Modèle officiel DIMF 2000 ; colonnes BRUT / AMT-PROV / NET (N) et NET (N-1) ; passif : N et N-1 | HAUTE | ✔ |
| DIMF-2000-HB | Hors-bilan — DIMF 2000, code D : AC0 | RCSFD annexe 2.4 (développée) ; Instr. 001-02-2018, art. 2 | S3 S5 | Annuelle | 6 mois après clôture | idem bilan | Tous SFD (jeu de lignes réduit en allégée, copie CI) ; absent de l'édition allégée cb-umoa | Modèle officiel ; colonnes NETS N / NETS N-1 | HAUTE | ◐ |
| DIMF-2080 | Compte de résultat — DIMF 2080, codes D : RA0 charges / RB0 produits | RCSFD annexes 3.1-3.5 ; Instr. 001-02-2018, art. 2 | S2 S3 S5 | Annuelle | 6 mois après clôture | idem bilan | Tous SFD (allégée/développée) ; consolidé : DIMF 2980 | Charges et produits côte à côte ; colonnes N / N-1 | HAUTE | ✔ |
| DIMF-2080-SIG | Soldes intermédiaires de gestion (marge d'intérêt, produit financier net, excédent/déficit) — inclus dans le modèle DIMF 2080 | RCSFD ch. V ; annexe 3 | S2 S3 | Annuelle | 6 mois après clôture | idem bilan | Tous SFD | Lignes de totaux sans code poste dans le modèle | HAUTE | ◐ |
| DIMF-2005 | Tableau des emplois et des ressources (D : BG0) | RCSFD annexe 4.1 ; Instr. 001-02-2018, art. 2 | S2 S3 S5 | Annuelle | 6 mois | idem bilan | Tous SFD | Modèle ; colonnes Amortissements/Provisions, Montants nets | HAUTE | ✔ |
| DIMF-2006 | État des biens donnés en crédit-bail et opérations assimilées (D : BG0) | RCSFD annexe 4.2 (développée) | S3 | Annuelle | 6 mois | idem bilan | SFD en développée avec crédit-bail | Modèle ; durée, bruts, amortissements/provisions, nets | HAUTE | ◐ |
| DIMF-2007 | État des biens détenus dans le cadre de la concession (D : BG0) | RCSFD annexe 4.3 (développée) | S3 | Annuelle | 6 mois | idem bilan | SFD en développée | Modèle | HAUTE | ◐ |
| DIMF-2008 | État des biens détenus dans le cadre de la clause de réserve de propriété (D : BG0) | RCSFD annexe 4.4 (développée) | S3 | Annuelle | 6 mois | idem bilan | SFD en développée | Modèle | HAUTE | ◐ |
| DIMF-2009 | Détail du compte 6221 — Personnel extérieur à l'institution (D : BG0) | RCSFD annexe 4.5 ; Instr. 001-02-2018, art. 2 | S3 S5 | Annuelle | 6 mois | idem bilan | Tous SFD (cité par l'Instr. 001-02-2018) | Modèle (effectifs par catégorie et origine, facturation) | HAUTE | ◐ |
| DIMF-2010 | État des crédits en souffrance (D : BA0) | RCSFD annexe 4.6 ; Instr. 001-02-2018, art. 2 | S2 S3 S5 | Annuelle | 6 mois | idem bilan | Tous SFD | Modèle ; colonnes A, B, C = A−B, D, E = C−D | HAUTE | ✔ |
| DIMF-2011 | État des informations annexes (D : BB0) | RCSFD annexe 4.7 | S2 S3 | Annuelle | 6 mois | idem bilan | Tous SFD | Modèle ; montant / effectif | HAUTE | ✔ |
| DIMF-2011-1 | État des engagements par signature (D : BC0) | RCSFD annexe 4.8 (développée) ; Instr. 001-02-2018, art. 2 | S3 S5 | Annuelle | 6 mois | idem bilan | Tous SFD (cité par l'Instr. 001-02-2018) | Modèle ; comptes 90, 91, 92, 93, 95, 96, 99 | HAUTE | ◐ |
| DIMF-2012 | État de l'encours des crédits des dix débiteurs les plus importants (D : BF0) | RCSFD annexe 4.9 | S2 S3 | Annuelle (et base du ratio signature unique) | 6 mois | idem bilan | Tous SFD | Modèle ; identité, durées, montants nets | HAUTE | ✔ |
| DIMF-2013 | État de l'encours total des prêts aux dirigeants, au personnel et aux personnes liées (D : BE0) | RCSFD annexe 4.10 | S2 S3 | Annuelle (et base du ratio dirigeants) | 6 mois | idem bilan | Tous SFD | Modèle ; identité, encours bruts | HAUTE | ✔ |
| DIMF-2014 | État des ressources affectées et des crédits consentis sur ressources affectées (D : BF0) | RCSFD annexe 4.11 | S2 S3 | Annuelle | 6 mois | idem bilan | Tous SFD | Modèle ; CT/MT/LT/total | HAUTE | ✔ |
| DIMF-2015 | État des valeurs immobilisées (D : BG0) | RCSFD annexe 4.12 | S2 S3 | Annuelle | 6 mois | idem bilan | Tous SFD | Modèle ; bruts, amortissements/provisions, nets | HAUTE | ✔ |
| DIMF-2016 | État d'affectation du résultat (D : BH0) | RCSFD annexe 4.13/4.14 | S2 S3 | Annuelle | 6 mois (après approbation AG) | idem bilan | Tous SFD | Modèle ; proposition / répartition effective | HAUTE | ✔ |
| DIMF-2018 | État de traitement de la réévaluation | RCSFD annexe 4.14 (développée) | S3 | Annuelle (si réévaluation) | 6 mois | idem bilan | SFD en développée | Modèle | HAUTE | ◐ |
| DIMF-2900 | Bilan et hors-bilan consolidés/combinés (réseaux, faîtières) | Instr. 030-02-2009, art. 5 ; RCSFD annexe 6.1 | S1 S3 | Annuelle | 6 mois | idem bilan | Unions, fédérations, confédérations (base combinée) ; SFD non mutualistes (base consolidée) | Modèle consolidé (codes postes à 3 chiffres 010, 014…) | HAUTE | ? |
| DIMF-2980 | Compte de résultat consolidé/combiné | RCSFD annexe 6.2 | S3 | Annuelle | 6 mois | idem bilan | idem DIMF-2900 | Modèle consolidé | HAUTE | ? |
| UEMOA-REP-FIN-001 | Dossier de transmission : bordereau d'authentification, carte des signatures accréditées, rapports du commissaire aux comptes (général et spécial) et rapport de gestion | RCSFD ch. V B.2.1-2.3 ; Instr. 006-06-2010, annexe ; loi, art. 53 | S1 S3 | Annuelle | avec les états (6 mois) | Ministre ; BCEAO ; Commission Bancaire | Tous ; CAC obligatoire : faîtières et SFD art. 44 | Liste datée et signée, visa du CAC | HAUTE | ◐ |
| UEMOA-REP-FIN-002 | Publication des états financiers (avis : bilan, hors-bilan, compte de résultat) | Loi, art. 54 ; Instr. 001-02-2018, art. 5-6 | S1 S5 | Annuelle | 6 mois après clôture ; références notifiées sous 7 jours au Ministre et à la Direction Nationale BCEAO | Journal officiel ou ≥ 2 journaux locaux (art. 44) ; Ministre / DN BCEAO (notification) | SFD art. 44 (loi 2007) ; toutes IMF (nouvelle loi, art. 63) | Avis de publication | HAUTE | ◐ |
| UEMOA-REP-RAP-001 | Rapport annuel du SFD (partie narrative + annexe de 10 sections de tableaux chiffrés) | Instr. 018-12-2010 ; loi, art. 50-51 | S1 | Annuelle | 6 mois après clôture (loi art. 51 ; l'instruction ne chiffre pas le délai) | Ministre ; art. 44 : BCEAO + Commission Bancaire (support électronique) | Tous SFD ; faîtières sur base combinée ; réseaux : + rapports de chaque entité | Annexe : Tableaux n°1.1 à n°10 (voir b.10) | HAUTE | ◐ |
| UEMOA-REP-PRU-01 | Ratio de limitation des risques (≤ 200 %) | Instr. 010-08-2010, annexe I | S4 | Mensuelle (art. 44) / Trimestrielle (autres) | 1 mois après fin de période | Ministre ; BCEAO ; Commission Bancaire | Tous SFD | Numérateur/dénominateur par codes poste | HAUTE | ✔ |
| UEMOA-REP-PRU-02 | Couverture des emplois MLT par ressources stables (≥ 100 %) | Instr. 010-08-2010, annexe II | S4 | Trimestrielle | 1 mois après le trimestre | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-03 | Limitation des prêts aux dirigeants, personnel, personnes liées (≤ 10 % FP) | Instr. 010-08-2010, annexe III | S4 | Mensuelle (art. 44) / Trimestrielle (autres) | 1 mois | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-04 | Risques sur une seule signature (≤ 10 % FP) | Instr. 010-08-2010, annexe IV | S4 | Mensuelle (art. 44) / Trimestrielle (autres) | 1 mois | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-05 | Coefficient de liquidité (≥ 100 % / 80 % / 60 %) | Instr. 010-08-2010, annexe V | S4 | Mensuelle (art. 44 ; autres SFD collectant des dépôts) / Trimestrielle (autres) | 1 mois | idem | Tous SFD (norme selon catégorie) | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-06 | Limitation des opérations autres que épargne et crédit (≤ 5 %) | Instr. 010-08-2010, annexe VI | S4 | Trimestrielle | 1 mois | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-07 | Constitution de la réserve générale (≥ 15 % des excédents nets) | Instr. 010-08-2010, annexe VII | S4 | Trimestrielle (production) ; dotation annuelle | 1 mois ; annuel : 6 mois | idem | Tous SFD | Base × 15 % | HAUTE | ✔ |
| UEMOA-REP-PRU-08 | Norme de capitalisation (≥ 15 %) | Instr. 010-08-2010, annexe VIII | S4 | Mensuelle (art. 44 et autres) | 1 mois | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-09 | Limitation des prises de participation (≤ 25 % FP) | Instr. 010-08-2010, annexe IX | S4 | Trimestrielle | 1 mois | idem | Tous SFD | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-10 | Financement des immobilisations et participations par les fonds propres (≤ 100 % FP) | Instr. 016-12-2010, art. 3-7 et annexe | S1 | Trimestrielle | 1 mois après le trimestre ; annuel : 6 mois | Ministre ; BCEAO ; Commission Bancaire | Tous SFD (et unions, fédérations, confédérations) | idem | HAUTE | ✔ |
| UEMOA-REP-PRU-ANN | État récapitulatif annuel des ratios prudentiels (annexe aux états financiers, 3 exemplaires) | Instr. 010-08-2010, art. 3-4 ; RCSFD ch. V B.2.1 | S1 S3 S4 | Annuelle (états au 31/12) | 6 mois | Ministre ; BCEAO ; Commission Bancaire (électronique pour art. 44) | Tous SFD | Récapitulatif signé | HAUTE | ◐ |
| UEMOA-REP-IND-FIN | Indicateurs périodiques — I. Indicateurs financiers (19 ratios : qualité du portefeuille, activité, efficacité/productivité, rentabilité, gestion du bilan) | Instr. 020-12-2010, art. 1-6 et annexe I | S1 S15 | Mensuelle (art. 44) / Trimestrielle (autres) | 30 jours calendaires après fin du mois/trimestre | Ministre ; BCEAO ; Commission Bancaire (électronique pour art. 44 ; autres : électronique ou papier signé) | Tous SFD | Tableau : type de ratio, nom, formule, éléments de calcul, code RCSFD, norme | HAUTE | ✔ |
| UEMOA-REP-IND-NF | Indicateurs périodiques — II. Indicateurs non financiers (7 tableaux) | Instr. 020-12-2010, annexe II | S1 S15 | Mensuelle (art. 44) / Trimestrielle (autres) | 30 jours calendaires | idem | Tous SFD (T.7 : faîtières IMCEC / non mutualistes) | Tableaux n°1 à n°7 ; colonnes T-1, T, Variation % | HAUTE | ✔ |
| UEMOA-REP-CI-001 | Rapport annuel de contrôle interne / rapport de contrôle global (description du dispositif, inventaire des contrôles, constats) | Instr. 017-12-2010, art. 3 et annexe II-III | S1 | Annuelle | 6 mois après la fin de l'année civile | Ministre ; BCEAO ; Commission Bancaire (art. 44) | Tous SFD | Rapport narratif (mandat, informations générales, lacunes motivées, délais de régularisation) | HAUTE | ◐ |
| UEMOA-REP-CI-002 | Copie des rapports d'anomalies (vérification/inspection) avec recommandations | Instr. 017-12-2010, art. 3 | S1 | Événementielle | 30 jours après production du rapport | Ministre ; BCEAO ; Commission Bancaire | Tous SFD | Rapport | HAUTE | ◐ |
| UEMOA-REP-CI-003 | Programme annuel indicatif d'inspection de l'année à venir | Instr. 017-12-2010, annexe I | S1 | Annuelle | 15 janvier (support électronique) | Ministre ; BCEAO ; Commission Bancaire | Réseaux (faîtières) | Nombre d'entités, effectif des contrôleurs, thèmes | HAUTE | ◐ |
| UEMOA-REP-CI-004 | Rapport global sur le bilan du programme d'inspection de l'année précédente | Instr. 017-12-2010, annexe I | S1 | Annuelle | 31 janvier (1 ex. chacun) | Ministre ; BCEAO ; Commission Bancaire | Réseaux | Diligences, difficultés, constats, écarts prévisions/réalisations | HAUTE | ◐ |
| UEMOA-REP-FS-001 | Rapport de contrôle de la gestion du fonds de sécurité ou de solidarité (organe de contrôle) et rapport spécifique du commissaire aux comptes | Instr. 019-12-2010, art. 5-8 | S1 | Annuelle | Compte rendu à l'AG de la faîtière ; rapport du CAC transmis aux Autorités (délai non chiffré) ; cotisations reçues au plus tard 6 mois après clôture | Assemblée générale ; Autorités de contrôle (rapport CAC, art. 44) | Réseaux IMCEC (unions, fédérations, confédérations) | Soldes début/fin, dotations, utilisations, remboursements, cotisations | HAUTE | ◐ |
| UEMOA-REP-LBC-001 | Déclaration de soupçon (DOS) à la CENTIF | Loi uniforme LBC/FT/FP, art. 60-61 | S7 | Événementielle (immédiate) | Immédiate ; abstention d'opérer jusqu'à la déclaration | CENTIF nationale | Toutes IMF (institutions financières) | Modèle fixé par arrêté du Ministre des Finances (national) | HAUTE | ◐ |
| UEMOA-REP-LBC-002 | Déclaration des transactions en espèces ≥ 15 000 000 FCFA | Loi uniforme LBC/FT/FP, art. 72 ; Déc. 021/2023/CM/UMOA, art. 8 | S7 S8 | Événementielle | Délai et modèle NON TROUVÉS (arrêté national) | CENTIF nationale | Institutions financières dont IMF | Opération unique ou opérations liées | HAUTE | ◐ |
| UEMOA-REP-LBC-003 | Rapport annuel de mise en œuvre du dispositif LBC/FT/FP | Instr. 001-03-2025, art. 12 | S9 | Annuelle | 2 mois après la fin de l'exercice (31/12 → 28/02) | BCEAO et autorité de contrôle | Institutions financières, dont IMF (art. 3) | 8 rubriques (organisation, formation, contrôles, statistiques DOS, cartographie, audit, perspectives) | HAUTE | ✔ |
| UEMOA-REP-BIC-001 | Déclaration mensuelle des données de crédit au Bureau d'Information sur le Crédit (via la BCEAO) | Instr. 005-05-2015, art. 2-6 ; loi uniforme BIC (Déc. CM/UMOA/007/06/2013) | S6 | Mensuelle | Au plus tard le 10 du mois suivant le mois sous revue | BCEAO (interface) → BIC | Établissements de crédit et SFD | Électronique ; format/protocole du contrat avec le BIC (canevas NON TROUVÉ) | HAUTE | ◐ |
| UEMOA-REP-DOR-001 | Notification de chaque virement d'avoirs dormants et état récapitulatif mensuel des avoirs transférés | Instr. 006-06-2014, art. 2-3 | S10 | Événementielle + mensuelle | Virement ≤ 30 jours après clôture du compte (10 ans sans intervention) ; notification le jour du virement ; état du mois | Agence Principale BCEAO de l'État d'implantation | Organismes dépositaires, dont SFD | Électronique, canevas fourni par la BCEAO (NON TROUVÉ) | HAUTE | ◐ |
| UEMOA-REP-LOI-001 | Données périodiques prudentielles et états périodiques des IMF (nouvelle loi uniforme) | Loi uniforme microfinance (déc. 019/CM/UMOA du 21/12/2023), art. 68 et 80 [lus dans la loi SN 2025-04] | S11 S12 | Fixée par la BCEAO (NON TROUVÉE) | Fixé par la BCEAO (NON TROUVÉ) | Ministre des Finances ; BCEAO ; Commission Bancaire ; public (art. 68) | Toutes les IMF | Instruction d'application NON TROUVÉE | MOYENNE | ? |
| UEMOA-REP-LOI-002 | Rapport annuel de l'IMF et publication des états financiers (toutes IMF, sans distinction de taille) | Loi uniforme microfinance, art. 61-63 [loi SN 2025-04] | S11 S12 | Annuelle | Publication : 6 mois après clôture ; modalités du rapport fixées par la BCEAO | Autorités de supervision ; public | Toutes les IMF | Règles de production : BCEAO + Commission Bancaire | MOYENNE | ? |
| UEMOA-REP-LOI-003 | Rapport annuel sur le traitement des réclamations des clients | Loi uniforme microfinance, art. 94 [loi SN 2025-04] | S11 | Annuelle | NON TROUVÉ | Autorité de supervision et BCEAO | Toutes les IMF | Canevas défini par BCEAO/Commission Bancaire (NON TROUVÉ) | MOYENNE | ? |
| UEMOA-REP-LOI-004 | Plan préventif de redressement (mise à jour et communication) | Loi uniforme microfinance, art. 104 [loi SN 2025-04] | S11 | Périodicité NON TROUVÉE | NON TROUVÉ | Commission Bancaire (ou Ministre sur réquisition) | IMF sous supervision de la Commission Bancaire | Modalités fixées par BCEAO/CB | MOYENNE | ? |
| UEMOA-REP-LOI-005 | Contribution annuelle et informations au Fonds de Garantie des Dépôts et de Résolution dans l'UMOA (FGDR-UMOA) | Loi uniforme microfinance, art. 99-101 [loi SN 2025-04] | S11 | Annuelle (contribution) ; renseignements sur dépôts indemnisables selon délais du Fonds | NON TROUVÉ | FGDR-UMOA | Toutes les IMF adhérentes | Taux/assiette fixés par les textes du Fonds (NON TROUVÉS) | MOYENNE | ? |
| UEMOA-REP-LOI-006 | Notification des modifications statutaires | Loi uniforme microfinance, art. 82 [loi SN 2025-04] | S11 | Événementielle | 6 semaines après l'AGE | Ministre, BCEAO, Commission Bancaire | Toutes les IMF | Notification | MOYENNE | ? |
| UEMOA-REP-DIV-001 | Liste des impayés / incidents de paiement (sur réquisition de la BCEAO) | Loi, art. 57 (SFD) ; loi microfinance art. 81 (liste des impayés) | S1 S11 | Sur réquisition | NON TROUVÉ | BCEAO / Ministre / Commission Bancaire | Tous SFD | NON TROUVÉ | BASSE | ? |
| UEMOA-REP-DIV-002 | Taux de l'usure — pas d'état déclaratif BCEAO trouvé (contrôle du TEG ≤ 24 %) | Décision n°19/2025/CM/UMOA | S14 | — | — | — | Toutes IMF (plafond 24 %) | NON TROUVÉ | HAUTE | ? |

Pénalité en cas de défaut de communication : 5 000 FCFA par jour de retard et par omission pendant 15 jours, puis 10 000 FCFA pendant 15 jours, puis 15 000 FCFA au-delà (loi uniforme SFD 2007, art. 73 ; rappelé par l'Instr. 020-12-2010, art. 3). SFD de l'article 44 : encours de dépôts ou de crédits ≥ 2 milliards de FCFA au terme de deux exercices consécutifs (Instr. 007-06-2010, art. 2).

### Table des sources
| réf. | source | URL |
|---|---|---|
| S1 | Recueil des textes légaux et réglementaires régissant les SFD de l'UMOA, éd. déc. 2011 (loi, décret, Instr. 025/026/030-02-2009, 004 à 007-06-2010, 010-08-2010, 016 à 021-12-2010, Déc. 061-03-2011) | https://cb-umoa.org/sites/default/files/2022-01/RECUEIL%20DES%20TEXTES%20L%C3%89GAUX%20ET%20R%C3%89GLEMENTAIRES%20R%C3%89GISSANT%20LES%20SFD%20DE%20L%27UMOA.pdf |
| S2 | RCSFD version allégée, 1re éd. (ISBN 978-2-916140-11-7), annexes A7-A62 (nomenclature, bilan, compte de résultat, états annexes) | https://cb-umoa.org/sites/default/files/2022-05/R%C3%A9f%C3%A9rentiel%20comptable%20sp%C3%A9cifique%20des%20SFD_1.pdf |
| S3 | RCSFD version développée, 1re éd. (ISBN 978-2-916140-08-7, juillet 2009, 457 p.), copie hébergée par le Trésor de Côte d'Ivoire (texte BCEAO, hébergeur ministériel ; non comparée à une copie cb-umoa) | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf |
| S4 | Instruction BCEAO n°010-08-2010 du 30/08/2010 (scan, relu à l'image) | https://cb-umoa.org/sites/default/files/2022-01/INSTRUCTION%20N%C2%B0010-08-2010%20RELATIVE%20AUX%20R%C3%88GLES%20PRUDENTIELLES%20APPLICABLES%20AUX%20SFD%20DES%20ETATS%20MEMBRES%20DE%20L%27UMOA.pdf |
| S5 | Instruction BCEAO n°001-02-2018 (états financiers et publication des SFD sous contrôle BCEAO/CB-UMOA), 3 p. | https://cb-umoa.org/sites/default/files/2022-01/INSTRUCTION%20N%C2%B0001-02-2018%20RELATIVE%20%C3%80%20L%27%C3%89TABLISSEMENT%20DES%20%C3%89TATS%20FINANCIERS%20ET%20AUX%20MODALIT%C3%89S%20DE%20LEUR%20PUBLICATION%20PAR%20LES%20SFD%20SOUMIS%20AU%20CONTR%C3%94LE%20DE%20LA%20BCEAO%20ET%20DE%20LA%20COMMISSION%20BANCAIRE%20DE%20L%27UMOA.pdf |
| S6 | BCEAO, Recueil, chapitre III (BIC) : Instr. n°005-05-2015 du 08/05/2015 fixant les modalités de transmission des informations sur le crédit aux BIC ; loi uniforme BIC (Déc. CM/UMOA/007/06/2013) | https://www.bceao.int/sites/default/files/2017-11/ch3chapitre_3_-_reglementation_relative_au_systeme_de_partage_d_information_sur_le_credit.pdf |
| S7 | Loi uniforme relative à la LBC/FT/FP dans les États membres de l'UMOA (nouvelle loi, art. 60, 72) | https://cb-umoa.org/sites/default/files/2025-08/Loi-uniforme%20relative%20%C3%A0%20la%20LBCFTFP.pdf |
| S8 | Décision n°021 du 21/12/2023/CM/UMOA fixant les montants des seuils (LBC/FT/FP) — art. 8 : seuil de déclaration des transactions en espèces | https://cb-umoa.org/sites/default/files/2025-08/D%C3%A9cision%20N%C2%B021%20du%2021%20d%C3%A9cembre%202023%20fixant%20les%20montants%20seuils%20pour%20la%20mise%20en%20oeuvre%20de%20la%20loi%20uniforme%20relative%20%C3%A0%20la%20LBCFTFP.pdf |
| S9 | Instruction BCEAO n°001-03-2025 du 18/03/2025 (modalités de mise en œuvre par les institutions financières, dont les IMF, de leurs obligations LBC/FT/FP ; abroge Instr. 007-09-2017) | https://cb-umoa.org/sites/default/files/2025-08/Instruction%20n%C2%B0001-03-2025%20du%2018%20mars%2025%20portant%20modalit%C3%A9s%20de%20mise%20en%20oeuvre%20par%20les%20IF%20de%20leurs%20obligations%20en%20mati%C3%A8re%20de%20lutte%20contre%20le%20blanchiment%20de%20capitaux.pdf |
| S10 | Instruction BCEAO n°006-06-2014 du 30/06/2014 (transfert à la BCEAO des avoirs dormants) | https://cb-umoa.org/sites/default/files/2022-01/INSTRUCTION%20N%C2%B0006-06-2014%20RELATIVE%20AUX%20MODALITES%20DE%20TRANSFERT%20A%20LA%20BCEAO%20DES%20AVOIRS%20DORMANTS%20DANS%20LES%20LIVRES%20DES%20ORGANISMES%20FINANCIERS%20DES%20ETATS%20MEMBRES%20DE%20L%27UNION%20MONETAIRE%20OUEST%20AFRICAINE.pdf |
| S11 | Loi n°2025-04 du 19/02/2025 portant réglementation de la microfinance au Sénégal, JO n°7817 du 25/03/2025 (transposition de la loi uniforme microfinance ; numérotation des articles = loi uniforme) | https://www.vie-publique.sn/documents/743/loi-2025-04-portant-reglementation-de-la-microfinance-au-senegal |
| S12 | ANSSFD (Bénin), « Loi portant réglementation de la microfinance : grandes lignes » (décision n°019/CM/UMOA du 21/12/2023) | https://anssfd.bj/wp-content/uploads/2025/04/Loi_uniforme_2023_microfinance_UMOA_grandes_lignes_ANSSFD.pdf |
| S13 | Abidjan.net, communiqué de la Direction générale du Trésor (CI) du 15/03/2024 : documents obligatoires à communiquer à la tutelle par les SFD | https://news.abidjan.net/articles/729635/cote-divoire-le-tresor-devoile-les-documents-obligatoires-a-communiquer-a-la-tutelle-par-les-systemes-financiers-decentralises |
| S14 | Décision n°19 du 29/12/2025/CM/UMOA fixant le taux de l'usure (14 % banques ; 24 % IMF), en vigueur le 01/06/2026 | https://www.bceao.int/sites/default/files/2026-01/Decision-No19-du-29-12-2025_CMUMOA_fixant_le_taux_de_l-usure.pdf |
| S15 | BCEAO, Recueil 2018, chapitre VII (mêmes textes SFD, mise en page à deux colonnes ; recoupement de l'Instr. 020-12-2010) | https://www.bceao.int/sites/default/files/inline-files/chapitre_7_-_reglementation_specifique_aux_institutions_de_microfinance.pdf |
| S16 | Décision n°003 du 28/03/2024/CM/UMOA (seuils complémentaires LBC/FT/FP) | https://www.bceao.int/fr/reglementations/decision-ndeg003-du-28032024cm-du-conseil-des-ministres-de-lumoa-fixant-les |

## b) Structure, formules et normes par état

### b.0 Règles transversales de calcul
- Version développée obligatoire pour les SFD de l'article 44 (Instr. 030-02-2009, art. 4) ; version allégée autorisée sous 50 M FCFA d'encours de dépôts ou de crédit sur deux exercices consécutifs (Instr. 021-12-2010, art. 2) ; choix de la développée irréversible sauf autorisation (art. 3).
- Les mentions entre crochets ou parenthèses ajoutées après un libellé dans les tableaux sont des annotations du rédacteur (écarts ou précisions), pas des libellés officiels ; les libellés en majuscules sont ceux du modèle (sans accents).
- Les formules des postes sont des concordances sur les soldes de comptes ; les comptes à solde variable (`ex`) sont ventilés actif/passif selon le signe du solde.
- Les ratios de l'Instr. 010-08-2010 et les indicateurs de l'Instr. 020-12-2010 citent des codes de postes RCSFD (A12, B70, L01…) : les calculer à partir des postes du bilan, pas directement des comptes. Les durées « résiduelles » (ratios II et V) exigent un échéancier des encours : non déductible de la balance seule.
- Le poste B70 (crédits en souffrance) est net de provisions (2991 à 2993). Les textes parlent de « montant brut du portefeuille » : pour le brut, rajouter 2991+2992+2993 (à confirmer par la BCEAO).
- Unité : FCFA (monnaie 1) ; les états de l'Instr. 020-12-2010 existent en trimestriel (colonnes T-1, T) ; périodicité RCSFD : D (décadaire), M, T, S, A — les états décadaires : NON TROUVÉ.

### b.1 DIMF 2000 — Bilan (code D : AA0 actif, AB0 passif ; colonnes BRUT, AMT/PROV, NET N, NET N-1)
Actif = A01 + B01 + C01 + D01 + E01 + E05 = E90 ; Passif = F01 + G01 + H01 + K01 + L01 = L90. Les formules des totaux E90/L90 sont déduites de la structure du modèle (non explicites : ◐). Plan : classe 1 trésorerie et institutions financières, 2 membres/bénéficiaires/clients, 3 titres et opérations diverses, 4 valeurs immobilisées, 5 provisions, fonds propres et assimilés (RCSFD annexe 1.1). Le poste L75 / E05 (excédent / déficit) n'est utilisé que dans les états infra-annuels (Instr. 010-08-2010, notes des annexes).

**ACTIF**

| code poste | libellé | comptes — développée | comptes — allégée |
|---|---|---|---|
| A01 | OPERATIONS DE TRESORERIE ET AVEC LES INSTITUTIONS FINANCIERES | 101 + 1101 + 111111 + 111121 + 1121 + 1131 + ex 1141 + ex 1151 + ex 1161 + ex 1171 + 111117 + 111127 + 1137 + 1147 + 1157 + 1167 + 1177 + 1261 + 1271 + 1281 + 1267 + 1277 + 1287 + 1311 + 1331 + ex 1511 + ex 1521 + ex 1531 + ex 1541 + ex 1551 + ex 1561 + ex 1571 + 1317 + 1337 + 1517 + 1527 + 1537 + 1547 + 1557 + 1567 + 1577 + 191 + 192 + 193 + 194 − 199 | 1011 + 1131 + ex 1141 + ex 1161 + ex 1171 + 1261 + 1271 + 1281 + 1311 + 1331 + ex 1541 + ex 1561 + ex 1571 + 1137 + 1147 + 1167 + 1177 + 1267 + 1277 + 1287 + 1317 + 1337 + 1547 + ex 1567 + ex 1577 + 191 + 192 + 193 + 194 − 199 |
| A10 | Valeur en caisse | 10 | idem |
| A11 | Billets et monnaies | 101 | 1011 |
| A12 | Comptes ordinaires débiteurs | 1101 + 1111 + 1121 + 1131 + ex 1141 + ex 1151 + ex 1161 + ex 1171 | 1131 + ex 1141 + ex 1161 + ex 1171 + ex 1541 + ex 1561 + ex 1571 |
| A2A | Autres comptes de dépôts débiteurs | 1261 + 1271 + 1281 | idem |
| A2H | Dépôts à terme constitués | 1261 | idem |
| A2I | Dépôts de garantie constitués | 1271 | idem |
| A2J | Autres dépôts constitués | 1281 | idem |
| A3A | Comptes de prêts | 1311 + 1331 | idem |
| A3B | Prêts à moins d'un an | 1311 | idem |
| A3C | Prêts à terme | 1331 | idem |
| A60 | Créances rattachées | 111117 + 111127 + 1137 + 1147 + 1157 + 1167 + 1177 + 1267 + 1277 + 1287 + 1317 + 1337 + 1517 + 1527 + 1537 + 1547 + 1557 + 1567 + 1577 | 1167 + 1177 + 1267 + 1277 + 1287 + 1317 + 1337 + 1547 + 1567 + 1577 |
| A70 | Prêts en souffrance (prêts immobilisés + souffrance, nets de provisions) | 191 + 192 + 193 + 194 − 1991 − 1992 − 1993 | 191 + 192 + 193 + 194 − 199 |
| A71 | Prêts en souffrance de 6 mois au plus | 192 − 1991 | idem |
| A72 | Prêts en souffrance de plus de 6 mois à 12 mois au plus | 193 − 1992 | idem |
| A73 | Prêts en souffrance de plus de 12 mois à 24 mois au plus | 194 − 1993 | idem |
| B01 | OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | 20221 + 20227 + 2031 + 2041 + ex 2511 + 2037 + 2047 + 291 + 292 + 293 + 294 − 299 | 2022 + 2023 + 20227 + 2031 + ex 2511 + 2037 + 291 + 292 + 293 + 294 − 2991 − 2992 − 2993 |
| B2D | Crédits à court terme | 20221 + 20231 | 2022 + 2023 |
| B2N | Comptes ordinaires (débiteurs) | ex 2511 | idem |
| B30 | Crédits à moyen terme | 2031 | idem |
| B40 | Crédits à long terme | 2041 | — |
| B65 | Créances rattachées | 20227 + 20237 + 2037 + 2047 | 20227 + 2037 |
| B70 | Crédits en souffrance (nets de provisions) | 291 + 292 + 293 + 294 − 2991 − 2992 − 2993 | idem |
| B71 | Crédits en souffrance de 6 mois au plus | 292 − 2991 | idem |
| B72 | Crédits en souffrance de plus de 6 mois à 12 mois au plus | 293 − 2992 | idem |
| B73 | Crédits en souffrance de plus de 12 mois à 24 mois au plus | 294 − 2993 | idem |
| C01 | OPERATIONS SUR TITRES ET OPERATIONS DIVERSES | 301 + 302 + 303 + 304 − 309 + 3211 + 3221 + 3231 + 3241 − 3219 − 3229 − 3239 − 3249 + 3311 + 3711 + 3713 + 3741 + 3742 + 378 + 3791 + 381 + 39 + 33191 − 33199 | 30 − 309 + 3211 + 3221 + 3231 − 3219 − 3229 − 3239 + 331 − 3319 + 378 + 3791 + 381 |
| C10 | Titres de placement | 301 + 302 + 303 + 304 − 309 | 30 − 309 |
| C30 | Comptes de stocks | 3211 + 3221 + 3231 + 3241 − 3219 − 3229 − 3239 − 3249 | 3211 + 3221 + 3231 − 3219 − 3229 − 3239 |
| C31 | Stocks de meubles (allégée) / Stocks de marchandises (développée, libellé du modèle) | 3211 − 3219 | idem |
| C32 | Stocks de marchandises (allégée) | 3221 − 3229 | idem |
| C33 | Stocks de fournitures | 3231 − 3239 | idem |
| C34 | Autres stocks et assimilés | 3241 − 3249 | — |
| C40 | Débiteurs divers | 33111 + 33112 + 33113 + 33114 + 33115 + 33116 + 33191 − 33199 | 331 − 3319 |
| C55 | Créances rattachées | 307 | idem |
| C56 | Valeurs à l'encaissement avec crédit immédiat | 37111 + 37112 | — |
| C59 | Valeurs à rejeter | 3713 | — |
| C6A | Comptes d'ordre et divers (actif) | 3741 + 3742 + 3791 + 378 + 3811 + 3812 + 3814 + 3815 + 39 | 378 + 3791 + 3811 + 3812 + 3814 + 3815 |
| C6B | Comptes de liaison (actif) | 39 | — |
| C6C | Comptes de différence de conversion (actif) | 3741 + 37421 + 37429 | — |
| C6G | Comptes de régularisation actif | 3811 + 3812 + 3814 + 3815 | idem |
| C6N | (poste de regroupement 378+3791, libellé non affiché au modèle) | 378 + 3791 | idem |
| C6Q | Comptes transitoires | 378 | idem |
| C6R | Comptes d'attente - actif | 3791 | idem |
| D01 | VALEURS IMMOBILISEES | 41 + 43 + 44 + 45 + 46 + 47 + 49 | 41 + 43 + 44 |
| D1A | Immobilisations financières | 4101 + 4102 + 4121 + 4122 + 4123 + 4124 + 4125 + 4141 + 4142 − 4129 − 4149 | 412 − 4129 |
| D1E | Titres de participation | 4121 + 4122 + 4123 + 4124 + 4125 − 4129 | NON TROUVÉ |
| D1L | Titres d'investissement | 4141 + 4142 − 4149 | NON TROUVÉ |
| D10 | Prêts et titres subordonnés | 4101 + 4102 | — |
| D1S | Dépôts et cautionnements | 42 − 429 | 421 − 429 |
| D23 | Immobilisations en cours | 4311 − 4319 + 4321 − 4329 | idem |
| D24 | Immobilisations en cours incorporelles | 4311 − 4319 | idem |
| D25 | Immobilisations en cours corporelles | 4321 − 4329 | idem |
| D30 | Immobilisations d'exploitation | 4411 + 4412 + 4413 + 4421 − 4418 − 4419 − 4428 − 4429 | 441 + 442 − 4418 − 4419 − 4428 − 4429 |
| D31 | Immobilisations d'exploitation incorporelles | 4411 + 4412 + 4413 − 4418 − 4419 | 441 − 4418 − 4419 |
| D32 | Droit au bail (état 2015) | 44111 − 4418 − 4419 | NON TROUVÉ |
| D33 | Autres éléments du fonds commercial (état 2015) | 44112 − 4418 − 4419 | NON TROUVÉ |
| D34 | Frais d'établissement (état 2015) | 4412 − 4418 − 4419 | NON TROUVÉ |
| D35 | Autres immobilisations incorporelles (état 2015) | 4413 − 4418 − 4419 | NON TROUVÉ |
| D36 | Immobilisations d'exploitation corporelles | 4421 − 4428 − 4429 | 442 − 4428 − 4429 |
| D40 | Immobilisations hors exploitation | 4511 + 4513 − 4518 − 4519 + 4521 − 4528 − 4529 + 4531 − 4538 − 4539 + 4541 − 4548 − 4549 | — |
| D41 | Immobilisations hors exploitation incorporelles | 4511 + 4513 − 4518 − 4519 | — |
| D45 | Immobilisations hors exploitation corporelles | 4521 − 4528 − 4529 | — |
| D46 | Immobilisations acquises par réalisation de garantie - incorporelles | 4531 − 4538 − 4539 | — |
| D47 | Immobilisations acquises par réalisation de garantie - corporelles | 4541 − 4548 − 4549 | — |
| D50 | Crédit-bail et opérations assimilées | 461 + 462 + 463 + 464 − 468 − 469 + 471 + 472 + 473 + 474 − 478 − 479 | — |
| D51 | Crédit-bail | 461 + 463 + 464 − 468 − 469 | — |
| D52 | L.O.A. | 462 + 463 + 464 − 468 − 469 | — |
| D53 | Location-vente | 471 + 472 + 473 + 474 − 478 − 479 | — |
| D60 | Créances rattachées (immobilisations) | 4107 + 4127 + 4147 + 427 + 467 + 477 | 4127 + 427 |
| D70 | Créances en souffrance (crédit-bail) [formule lue : 491+492-493] | 491 + 492 − 493 | — |
| D71 | Créances en souffrance de 6 mois au plus | 491 − 49961 − 49971 | — |
| D72 | Créances en souffrance de plus de 6 mois à 12 mois au plus | 492 − 49962 − 49972 | — |
| D73 | Créances en souffrance de plus de 12 mois à 24 mois au plus | 493 − 49963 − 49973 | — |
| E01 | ACTIONNAIRES, ASSOCIES OU MEMBRES (capital souscrit non versé) | 5731 + 5732 | idem |
| E02 | Actionnaires, associés ou membres, capital non appelé | 5731 | — |
| E03 | Actionnaires, associés ou membres, capital appelé non versé | 5732 | — |
| E05 | EXCÉDENT DES CHARGES SUR LES PRODUITS (infra-annuel uniquement) | 60 + 61 + 62 + 63 + 64 + 65 + 66 + 67 − 70 − 71 − 72 − 73 − 74 − 75 − 76 − 77 | idem |
| E90 | TOTAL ACTIF (net) | A01+B01+C01+D01+E01+E05 | idem |

**PASSIF**

| code poste | libellé | comptes — développée | comptes — allégée |
|---|---|---|---|
| F01 | OPERATIONS DE TRESORERIE ET AVEC LES INSTITUTIONS FINANCIERES (passif) | ex 111111 + ex 111121 + ex 1141 + ex 1151 + ex 1161 + ex 1171 + ex 1511 + ex 1521 + ex 1531 + ex 1541 + ex 1551 + ex 1561 + ex 1571 + 111116 + 111126 + 1136 + 1146 + 1156 + 1166 + 1176 + 1516 + 1526 + 1536 + 1546 + 1556 + 1566 + 1576 + 1611 + 1621 + 1651 + 1616 + 1626 + 1656 + 1751 + 1781 + 1756 + 1786 + 179 + 18 | ex 1141 + ex 1161 + ex 1171 + 1136 + 1146 + 1166 + 1176 + ex 1541 + ex 1561 + ex 1571 + 1546 + ex 1566 + ex 1576 + 1611 + 1621 + 1651 + 1616 + 1626 + 1656 + 1751 + 1781 + 1756 + 1786 + 179 + 18 |
| F1A | Comptes ordinaires créditeurs | ex 111111 + ex 111121 + ex 1141 + ex 1151 + ex 1161 + ex 1171 + ex 1511 + ex 1521 + ex 1531 + ex 1541 + ex 1551 + ex 1561 + ex 1571 | ex 1141 + ex 1161 + ex 1171 + ex 1541 + ex 1561 + ex 1571 |
| F2A | Autres comptes de dépôts créditeurs | 1611 + 1621 + 1651 | idem |
| F2B | Dépôts à terme reçus | 1611 | idem |
| F2C | Dépôts de garantie reçus | 1621 | idem |
| F2D | Autres dépôts reçus | 1651 | idem |
| F3A | Comptes d'emprunts | 1751 + 1781 | idem |
| F3E | Emprunts à moins d'un an | 1751 | idem |
| F3F | Emprunts à terme | 1781 | idem |
| F50 | Autres sommes dues aux institutions financières | 179 | idem |
| F55 | Ressources affectées | 18 | idem |
| F60 | Dettes rattachées | 111116 + 111126 + 1136 + 1146 + 1156 + 1166 + 1176 + 1516 + 1526 + 1536 + 1546 + 1556 + 1566 + 1576 + 1756 + 1786 + 1616 + 1626 + 1656 | 1136 + 1146 + 1166 + 1176 + 1546 + 1566 + 1576 + 1756 + 1786 + 1616 + 1626 + 1656 |
| G01 | OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS (passif) | ex 25111 + ex 25121 + 2521 + 25311 + 25321 + 25331 + 25391 + 2545 + 2551 + 2711 + 2721 + 2722 + 2725 + 25116 + 25126 + 2526 + 2546 + 2556 + 25316 + 25326 + 25336 + 25396 + 2716 + 2726 | ex 2511 + ex 2512 + 2521 + 2531 + 2545 + 2551 + 2711 + 2721 + 2722 + 2725 + 25116 + 25126 + 2526 + 25316 + 2546 + 2556 + 2716 + 2726 |
| G10 | Comptes ordinaires créditeurs | ex 25111 + ex 25121 | ex 2511 + ex 2512 |
| G15 | Dépôts à terme reçus | 2521 | idem |
| G2A | Comptes d'épargne à régime spécial | 25311 + 25321 + 25331 + 25391 | 2531 |
| G30 | Autres dépôts de garantie reçus | 2545 | idem |
| G35 | Autres dépôts reçus | 2551 | idem |
| G60 | Emprunts | 2711 | idem |
| G70 | Autres sommes dues | 2721 + 2722 + 2725 | idem |
| G90 | Dettes rattachées | 25116 + 25126 + 2526 + 25316 + 25326 + 25336 + 25396 + 2546 + 2556 + 2716 + 2726 | 25116 + 25126 + 2526 + 25316 + 2546 + 2556 + 2716 + 2726 |
| H01 | OPERATIONS SUR TITRES ET OPERATIONS DIVERSES (passif) | 305 + 332 + 3712 + 3741 + 3743 + 3792 + 382 + 39 | 305 + 332 + 3792 + 382 |
| H10 | Versements restant à effectuer | 305 | idem |
| H40 | Créditeurs divers | 332 | idem |
| H6A | Comptes d'ordre et divers (passif) | 3741 + 3743 + 3792 + 3822 + 3824 + 3825 + 39 | 3792 + 3822 + 3824 + 3825 |
| H6B | Comptes de liaison (passif) | 39 | — |
| H6C | Comptes de différences de conversion (passif) | 3741 + 37431 + 37439 | — |
| H6G | Comptes de régularisation - passif | 3822 + 3824 + 3825 | idem |
| H6P | Comptes d'attente - passif | 3792 | idem |
| K01 | VERSEMENTS RESTANT A EFFECTUER SUR IMMOBILISATIONS FINANCIERES | 4126 | idem |
| K20 | Titres de participation (versements restant à effectuer) | 4126 | idem |
| L01 | PROVISIONS, FONDS PROPRES ET ASSIMILES [dev : formule lue sans 503] | 501 + 502 + 51 + 52 + 53 + 54 + 55 + 56 + 57 + 58 + 59 | 501 + 502 + 503 + 51 + 52 + 53 + 54 + 55 + 56 + 57 + 58 + 59 |
| L10 | Subventions d'investissement | 5011 + 5012 | idem |
| L20 | Fonds affectés | 5021 + 5022 + 5023 + 5024 + 5029 | 502 |
| L21 | Fonds de garantie | 5021 | — |
| L22 | Fonds d'assurance | 5022 | — |
| L23 | Fonds de bonification | 5023 | — |
| L24 | Fonds de sécurité | 5024 | — |
| L25 | Autres fonds affectés | 5029 | — |
| L27 | Fonds de crédit | 503 | idem |
| L30 | Provisions pour risques et charges | 511 + 512 + 519 | 511 + 519 |
| L31 | Provisions pour charges de retraite | 511 | idem |
| L32 | Provisions pour risque d'exécution des engagements par signature | 512 | — |
| L33 | Autres provisions pour risques et charges | 519 | idem |
| L35 | Provisions réglementées | 52 | idem |
| L36 | Provisions pour risques afférents aux opérations de crédits à moyen et long termes | 521 | idem |
| L37 | Provision spéciale de réévaluation | 522 | — |
| L41 | Emprunts et titres émis subordonnés | 532 | idem |
| L43 | Dettes rattachées aux emprunts et titres émis subordonnés | 536 | idem |
| L45 | Fonds pour risques financiers généraux | 54 | idem |
| L50 | Primes liées au capital | 551 | idem |
| L55 | Réserves | 5521 + 5522 + 5523 | idem |
| L56 | Réserve générale | 5521 | idem |
| L57 | Réserves facultatives | 5522 | idem |
| L58 | Autres réserves | 5523 | idem |
| L59 | Écart de réévaluation des immobilisations | 553 | — |
| L60 | Capital | 5711 + 5712 | idem |
| L61 | Capital appelé | 5711 | idem |
| L62 | Capital non appelé | 5712 | idem |
| L65 | Fonds de dotation | 56 | idem |
| L70 | Report à nouveau (+ ou -) | 58 | idem |
| L75 | Excédent des produits sur les charges (infra-annuel uniquement) | 70 + 71 + 72 + 73 + 74 + 75 + 76 + 77 − 60 − 61 − 62 − 63 − 64 − 65 − 66 − 67 | idem |
| L80 | Résultat de l'exercice (+ ou -) | 59 | idem |
| L81 | Excédent ou déficit en instance d'approbation | 591 | idem |
| L82 | Excédent ou déficit de l'exercice | 592 | idem |
| L90 | TOTAL PASSIF | F01+G01+H01+K01+L01 | idem |

Postes de ventilation de la nomenclature développée sans libellé au modèle (A13 à A21, B01-B03, C6D à C6F, H6C…) : voir RCSFD annexe 1.1 ; non reproduits (les états ne les affichent pas).

### b.2 DIMF 2000 — Hors-bilan (code D : AC0 ; colonnes NETS N, NETS N-1)

| code poste | libellé | comptes — développée | comptes — allégée |
|---|---|---|---|
| N1A | ENGAGEMENTS DE FINANCEMENT DONNES EN FAVEUR DES INSTITUTIONS FINANCIERES | 901 | idem |
| N1H | ENGAGEMENTS DE FINANCEMENT RECUS DES INSTITUTIONS FINANCIERES | 902 | idem |
| N1J | ENGAGEMENTS DE FINANCEMENT DONNES EN FAVEUR DES MEMBRES, BENEFICIAIRES OU CLIENTS | 903 | idem |
| N1K | ENGAGEMENTS DE FINANCEMENT RECUS DES MEMBRES, BENEFICIAIRES OU CLIENTS | 904 | idem |
| N2A | Engagements de garantie d'ordre des institutions financières | 911 | idem |
| N2H | Engagements de garantie reçus des institutions financières | 912 | idem |
| N2J | Engagements de garantie d'ordre des membres, bénéficiaires ou clients | 913 | idem |
| N2M | Engagements de garantie reçus des membres, bénéficiaires ou clients | 914 | idem |
| N3A | Engagements sur titres : titres à livrer | 9211 + 9212 + 9219 | idem |
| N3B | Intervention à l'émission (titres à livrer) | 9211 | — |
| N3C | Marché gris (titres à livrer) | 9212 | — |
| N3D | Autres titres à livrer | 9219 | — |
| N3E | Engagements sur titres : titres à recevoir | 9221 + 9222 + 9229 | idem |
| NRF | Intervention à l'émission (titres à recevoir) | 9221 | — |
| NRG | Marché gris (titres à recevoir) | 9222 | — |
| N3H | Autres titres à recevoir [libellé du modèle : Autres titres à livrer] | 9229 | — |
| P1A | Francs CFA achetés non encore reçus | 9311 | idem |
| P1B | Devises achetées non encore reçues | 9312 | idem |
| P1C | Francs CFA vendus non encore livres | 9313 | idem |
| P1D | Devises vendues non encore livrées | 9314 | idem |
| P1E | Devises prêtées non encore livrées | 9331 | idem |
| P1F | Devises empruntées non encore reçues | 9332 | idem |
| P1G | Opérations de change à terme francs CFA à recevoir contre devises à livrer | 9321 | idem |
| P1H | Opérations de change à terme devises à recevoir contre FCFA à livrer | 9322 | idem |
| P1J | Opérations de change à terme devises à recevoir contre devises à livrer | 9323 | idem |
| P1K | Opérations de change à terme devises à livrer contre devises à recevoir | 9324 | idem |
| P1L | Report/déport non couru à recevoir | 9341 | idem |
| P1M | Report/déport non couru à payer | 9342 | idem |
| P1R | Intérêts non courus en devises couverts à recevoir | 9351 | idem |
| P1S | Intérêts non courus en devises couverts à payer | 9352 | idem |
| P1V | Ajustements devises hors bilan | 936 | idem |
| Q1A | Autres engagements donnés | 951 | idem |
| Q1B | Autres engagements reçus | 952 | idem |
| Q1C | Valeurs à l'encaissement non disponibles | 9611 + 9613 | idem |
| Q1F | Comptes exigibles après encaissements | 9612 + 9614 | idem |
| Q1J | Comptes de suivi des engagements de financement consortiaux | 9621 | idem |
| Q1K | Comptes de suivi des engagements de garantie consortiaux | 9631 | idem |
| Q1L | Comptes de suivi des crédits consortiaux | 9651 | idem |
| Q1M | Crédits distribués pour le compte de tiers | 9661 | idem |
| N90 | ENGAGEMENTS DOUTEUX | 99 | idem |

Le total N90 « engagements douteux » est une rubrique propre (compte 99). Le jeu allégé de la copie CI conserve N1A à N2M, N3A, N3E, P1*, Q1* et N90.

### b.3 DIMF 2080 — Compte de résultat et SIG (codes D : RA0 charges, RB0 produits ; colonnes N, N-1)
Présentation officielle : charges à gauche, produits à droite. Excédent/déficit : poste L80 (59). Totaux : T84 = 60+61+62+63+64+65+66+67+69+59 ; X84 = 70+71+72+73+74+75+76+77+59. SIG (RCSFD ch. V) : marge d'intérêt (solde net des produits et charges d'intérêt de l'activité principale), autres produits financiers nets (ou charges financières nettes), produit financier (= marge d'intérêt + produit financier net), excédent ou déficit. Ces lignes n'ont pas de code poste ; leur composition exacte n'est pas écrite (position dans le modèle) : À CONFIRMER.

**CHARGES**

| code poste | libellé | comptes — développée | comptes — allégée |
|---|---|---|---|
| R08 | CHARGES SUR OPERATIONS AVEC LES INSTITUTIONS FINANCIERES | 6011 + 6015 + 6016 + 6017 + 6018 + 6019 | idem |
| R1A | Intérêts sur comptes ordinaires créditeurs | 6011 + 6015 | idem |
| R1B | Organe financier | 60111 + 60151 | — |
| R1C | Caisse centrale | 60112 | — |
| R1D | Trésor Public | 60152 | — |
| R1E | CCP | 60113 + 60153 | — |
| R1F | Banques et correspondants | 60114 + 60154 | — |
| R1H | Établissements financiers | 60115 + 60155 | — |
| R1I | SFD | 60116 + 60156 | — |
| R1K | Autres institutions financières | 60117 + 60157 | — |
| R1L | Intérêts sur autres comptes de dépôts créditeurs | 6016 | idem |
| R1N | Dépôts à terme reçus | 60161 | — |
| R1P | Dépôts de garantie reçus | 60162 | — |
| R1Q | Autres dépôts reçus | 60165 | — |
| R2A | Intérêts sur comptes d'emprunts | 6017 | idem |
| R2F | Intérêts sur emprunts à moins d'un an | 60175 | — |
| R2G | Intérêts sur emprunts à terme | 60178 | — |
| R2R | Autres intérêts | 6018 | idem |
| R2T | Divers intérêts | 60189 | — |
| R2Z | Commissions | 6019 | idem |
| R3A | CHARGES SUR OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | 6025 + 6027 + 6028 + 6029 | idem |
| R3C | Intérêts sur comptes des membres, bénéficiaires ou clients | 6025 | idem |
| R3D | Intérêts sur comptes ordinaires créditeurs | 60251 | idem |
| R3F | Intérêts sur dépôts à terme reçus | 60252 | idem |
| R3G | Intérêts sur comptes d'épargne à régime spécial | 60253 | idem |
| R3H | Intérêts sur dépôts de garantie reçus | 60254 | idem |
| R3J | Intérêts sur autres dépôts reçus | 60255 | idem |
| R3N | Intérêts sur emprunts et autres sommes dues | 6027 | idem |
| R3Q | Autres intérêts | 6028 | idem |
| R3T | Commissions | 6029 | idem |
| R4B | CHARGES SUR OPERATIONS SUR TITRES ET OPERATIONS DIVERSES | 6031 + 6038 + 6039 | idem |
| R4C | Charges et pertes sur titres de placement | 6031 | idem |
| R4K | Charges sur opérations diverses | 6038 | idem |
| R4N | Commissions | 6039 | idem |
| R5B | CHARGES SUR IMMOBILISATIONS FINANCIERES | 60411 + 60412 | 6041 |
| R5C | Frais d'acquisition | 60411 | — |
| R5D | Étalement de la prime | 60412 | — |
| R5E | CHARGES SUR CREDIT-BAIL ET OPERATIONS ASSIMILEES | 6046 + 6047 | — |
| R5G | Charges sur opérations de crédit-bail | 60461 + 60463 + 60464 | — |
| R5H | Dotations aux amortissements (crédit-bail) | 604611 + 604631 + 604641 | — |
| R5J | Dotations aux provisions (crédit-bail) | 604612 + 604632 + 604642 | — |
| R5K | Moins-values de cession (crédit-bail) | 604613 + 604633 + 604643 | — |
| R5L | Autres charges (crédit-bail) | 604619 + 604639 + 604649 | — |
| R5M | Charges sur opérations de location avec option d'achat | 60462 + 60463 + 60464 | — |
| R5N | Dotations aux amortissements (LOA) | 604621 + 604631 + 60464 | — |
| R5P | Dotations aux provisions (LOA) | 604622 + 604632 + 604642 | — |
| R5Q | Moins-values de cession (LOA) | 604623 + 604633 + 604643 | — |
| R5R | Autres charges (LOA) | 604629 + 604639 + 604649 | — |
| R5S | Charges sur opérations de location-vente | 60471 + 60472 + 60473 + 60474 | — |
| R5T | Dotations aux amortissements (location-vente) | 604721 + 604731 + 604741 | — |
| R5U | Dotations aux provisions (location-vente) | 604712 + 604722 + 604732 + 604742 | — |
| R5V | Moins-values de cession (location-vente) | 604713 + 604723 + 604733 + 604743 | — |
| R5X | Autres charges (location-vente) | 604719 + 604729 + 604739 + 604749 | — |
| R5Y | Charges sur emprunts et titres émis subordonnés | 60532 | 6053 |
| R6A | CHARGES SUR OPERATIONS DE CHANGE | 6061 + 6069 | — |
| R6B | Pertes sur opérations de change | 6061 | — |
| R6C | Commissions (change) | 6069 | — |
| R6F | CHARGES SUR OPERATIONS HORS BILAN | 6071 + 6072 + 6073 + 6075 | — |
| R6K | Charges sur engagements de financements reçus des institutions financières | 60712 | — |
| R6L | Charges sur engagements de financements reçus des membres, clients ou bénéficiaires | 60714 | — |
| R6M | Charges sur engagements de garantie reçus des institutions financières | 60722 | — |
| R6P | Charges sur engagements de garantie reçus des membres, bénéficiaires ou clients | 60724 | — |
| R6S | Charges sur engagements sur titres | 6073 | — |
| R6T | Charges sur autres engagements reçus | 6075 | — |
| R6V | CHARGES SUR PRESTATIONS DE SERVICES FINANCIERS | 6081 + 6089 | 608 |
| R6W | Charges sur les moyens de paiement | 6081 | — |
| R6X | Autres charges sur prestations de services financiers | 6089 | — |
| R7A | AUTRES CHARGES D'EXPLOITATION FINANCIERE | 6091 + 6098 + 6099 | idem |
| R7B | Moins-values sur cession d'éléments d'actif | 6091 | idem |
| R7C | Transferts de produits d'exploitation financière | 6098 | idem |
| R7D | Diverses charges d'exploitation financière | 6099 | idem |
| R8G | Achats de marchandises | 6117 + 6118 − 6119 | idem |
| R8J | Stocks vendus | 6112 | idem |
| R8L | Variations de stocks de marchandises | 612 | idem |
| S02 | FRAIS DE PERSONNEL | 641 + 642 + 643 | idem |
| S03 | Salaires et traitements | 641 | idem |
| S04 | Charges sociales | 642 | idem |
| S05 | Rémunérations versées aux stagiaires | 643 | idem |
| S1A | IMPOTS ET TAXES | 6311 + 6312 + 6321 + 6323 + 6324 + 6329 + 633 | 631 + 632 + 633 |
| S1B | Impôts, taxes et versements assimilés sur rémunération | 6311 + 6312 | 631 |
| S1C | Autres impôts, taxes et prélèvements assimilés versés à l'Administration des impôts | 6321 + 6323 + 6324 + 6329 | 632 |
| S1D | Impôts directs | 6321 | — |
| S1G | Impôts indirects | 6323 | — |
| S1H | Droits d'enregistrement et de timbre | 6324 | — |
| S1J | Impôts et taxes divers | 6329 | — |
| S1K | Autres impôts, taxes et prélèvements assimilés versés aux autres organismes | 633 | idem |
| S2A | AUTRES CHARGES EXTERNES ET CHARGES DIVERSES D'EXPLOITATION [dev : formule lue sans 6235 6238 6239] | 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6217 + 6218 − 6219 + 6221 + 6222 + 6223 + 6224 + 6225 + 6226 + 6227 + 6228 + 6231 + 6232 − 6229 + 6233 | 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6217 + 6218 − 6219 + 6221 + 6222 + 6223 + 6224 + 6225 + 6226 + 6227 + 6228 + 6231 + 6232 − 6229 + 6233 + 6235 + 6238 + 6239 |
| S2B | Services extérieurs | 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6218 − 6219 | 6211 + 6212 + 6213 + 6214 + 6215 + 6216 + 6217 + 6218 − 6219 |
| S2C | Redevances de crédit-bail | 6211 + 6217 | 6211 |
| S2D | Loyers | 6212 | idem |
| S2F | Charges locatives et de co-propriété | 6213 | idem |
| S2H | Entretien et réparations | 6214 | idem |
| S2J | Primes d'assurance | 6215 | idem |
| S2K | Études et recherches | 6216 | idem |
| S2M | Frais de formation du personnel | 6217 | idem |
| S2L | Divers (services extérieurs) | 6218 − 6219 | idem |
| S3A | Autres services extérieurs | 6221 + 6222 + 6223 + 6224 + 6225 + 6226 + 6227 + 6228 − 6229 + 6116 | idem |
| S3B | Personnel extérieur à l'institution | 6221 | idem |
| S3C | Rémunérations d'intermédiaires et honoraires | 6222 | idem |
| S3E | Publicité, publications et relations publiques | 6223 | idem |
| S3G | Transports de biens | 6224 | idem |
| S3J | Transports collectifs du personnel | 6225 | idem |
| S3L | Déplacements, missions et réceptions | 6226 | idem |
| S3M | Achats non stockés de matières et fournitures | 6116 | idem |
| S3N | Frais postaux et frais de télécommunication | 6227 | idem |
| S3P | Divers (autres services extérieurs) | 6228 − 6229 | idem |
| S4A | Charges diverses d'exploitation | 6231 + 6232 + 6233 + 6235 + 6238 + 6239 | idem |
| S4B | Redevances pour concessions, brevets, licences, procédés, droits et valeurs similaires | 6231 | idem |
| S4D | Indemnités de fonction versées | 6232 | idem |
| S4I | Frais de tenue d'assemblée | 6233 | idem |
| S4K | Moins-values de cession sur immobilisations | 6235 | idem |
| S4L | Moins-values de cession sur immobilisations corporelles et incorporelles | 62351 | — |
| S4M | Moins-values de cession sur immobilisations financières | 62352 | — |
| S4P | Transferts de produits d'exploitation non financière | 6238 | idem |
| S4Q | Produits rétrocédés | 62381 | — |
| S4R | Autres transferts de produits | 62389 | — |
| S4S | Autres charges diverses d'exploitation non financière | 6239 | idem |
| T50 | DOTATIONS AU FONDS POUR RISQUES FINANCIERS GENERAUX | 65 | idem |
| T51 | DOTATIONS AUX AMORTISSEMENTS ET AUX PROVISIONS SUR IMMOBILISATIONS | 661 + 662 + 663 | idem |
| T53 | Dotation aux amortissements de charges à répartir | 662 | idem |
| T54 | Dotations aux amortissements des immobilisations d'exploitation | 6611 | 661 |
| T55 | Dotations aux amortissements des immobilisations hors exploitation | 6612 | — |
| T56 | Dotations aux provisions pour dépréciation des immobilisations en cours | 6631 | 663 |
| T57 | Dotations aux provisions pour dépréciation des immobilisations d'exploitation | 6632 | — |
| T58 | Dotations aux provisions pour dépréciation des immobilisations hors exploitation | 6633 | — |
| T6B | DOTATIONS AUX PROVISIONS ET PERTES SUR CREANCES IRRECOUVRABLES | 6641 + 6642 + 6643 + 666 + 667 + 668 + 669 | 664 + 666 + 667 + 668 + 669 |
| T6C | Dotations aux provisions sur créances en souffrance | 6641 + 6642 + 6643 | idem |
| T6D | Dotations aux provisions sur créances en souffrance de 6 mois au plus | 6641 | idem |
| T6E | Dotations aux provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus | 6642 | idem |
| T6F | Dotations aux provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus | 6643 | idem |
| T6G | Dotations aux provisions pour dépréciation d'autres éléments d'actif | 666 | idem |
| T6H | Dotations aux provisions pour risques et charges | 667 | idem |
| T6J | Dotations aux provisions réglementées | 668 | idem |
| T6K | Pertes sur créances irrécouvrables [dev : couvertes par des provisions] | 6691 | 669 |
| T6L | Pertes sur créances irrécouvrables non couvertes par des provisions | 6692 | — |
| T80 | CHARGES EXCEPTIONNELLES | 671 | idem |
| T81 | PERTES SUR EXERCICES ANTERIEURS | 672 | idem |
| T82 | IMPOTS SUR LES EXCEDENTS | 69 | idem |
| L80C | EXCÉDENT (côté charges ; code poste L80) | 59 | idem |
| T84 | TOTAL CHARGES | 60 + 61 + 62 + 63 + 64 + 65 + 66 + 67 + 69 + 59 | idem |

**PRODUITS**

| code poste | libellé | comptes — développée | comptes — allégée |
|---|---|---|---|
| V08 | PRODUITS SUR OPERATIONS AVEC LES INSTITUTIONS FINANCIERES | 7011 + 7012 + 7013 + 7015 + 7018 + 7019 | idem |
| V1A | Intérêts sur comptes ordinaires débiteurs | 7011 + 7015 | idem |
| V1B | Organe financier | 70111 + 70151 | — |
| V1C | Caisse centrale | 70112 | — |
| V1D | Trésor Public | 70152 | — |
| V1E | CCP | 70113 + 70153 | — |
| V1F | Banques et correspondants | 70114 + 70154 | — |
| V1H | Établissements financiers | 70115 + 70155 | — |
| V1I | SFD | 70116 + 70156 | — |
| V1K | Autres institutions financières | 70117 + 70157 | — |
| V1L | Intérêts sur autres comptes de dépôts débiteurs | 7012 | idem |
| V1Q | Intérêts sur dépôts à terme constitués | 70126 | — |
| V1R | Intérêts sur dépôts de garantie constitués | 70127 | — |
| V1S | Intérêts sur autres dépôts constitués | 70128 | — |
| V2A | Intérêts sur comptes de prêts | 7013 | idem |
| V2C | Intérêts sur prêts à moins d'un an | 70131 | — |
| V2G | Intérêts sur prêts à terme | 70133 | — |
| V2Q | Autres intérêts | 7018 | idem |
| V2S | Divers intérêts | 70189 | — |
| V2T | Commissions | 7019 | idem |
| V3A | PRODUITS SUR OPERATIONS AVEC LES MEMBRES, BENEFICIAIRES OU CLIENTS | 7021 + 7028 + 7029 | 7021 + 7025 + 7028 + 7029 |
| V3B | Intérêts sur crédits aux membres, bénéficiaires ou clients | 7021 | idem |
| V3G | dev : Autres crédits à court terme (70212) ; allégée : intérêts sur comptes des membres (7025) - même code poste, rubriques différentes | 70212 | 7025 |
| V3M | Intérêts sur crédits à moyen terme | 70213 | — |
| V3N | Intérêts sur crédits à long terme | 70214 | — |
| V3R | Autres intérêts | 7028 | idem |
| V3T | Divers intérêts | 70289 | — |
| V3X | Commissions | 7029 | idem |
| V4B | PRODUITS SUR OPERATIONS SUR TITRES ET SUR OPERATIONS DIVERSES | 7031 + 7033 + 7038 + 7039 | 7038 + 7039 |
| V4C | Produits et profits sur titres de placement | 7031 | — |
| V4D | Intérêts sur crédits accordés au personnel non membre | 7033 | — |
| V4E | Produits sur opérations diverses | 7038 | idem |
| V4F | Commissions | 7039 | idem |
| V5B | PRODUITS SUR IMMOBILISATIONS FINANCIERES | 7041 | 704 |
| V5C | Produits sur prêts et titres subordonnés | 70410 | — |
| V5D | Dividendes et produits assimilés sur titres de participation | 70412 | — |
| V5F | Produits et profits sur titres d'investissement | 70414 | — |
| V5G | PRODUITS SUR OPERATIONS DE CREDIT-BAIL ET OPERATIONS ASSIMILEES | 7046 + 7047 | — |
| V5H | Produits sur opérations de crédit-bail | 70461 + 70463 + 70464 | — |
| V5J | Loyers (crédit-bail) | 704611 + 704631 | — |
| V5K | Reprises de provisions (crédit-bail) | 704612 + 704632 + 704642 | — |
| V5L | Plus-values de cession (crédit-bail) | 704613 + 704633 + 704643 | — |
| V5M | Autres produits (crédit-bail) | 704619 + 704639 + 704649 | — |
| V5N | Produits sur opérations de location avec option d'achat | 70462 + 70463 + 70464 | — |
| V5P | Loyers (LOA) | 704621 + 704631 | — |
| V5Q | Reprises de provisions (LOA) | 704622 + 704632 + 704642 | — |
| V5R | Plus-values de cession (LOA) | 704623 + 704633 + 704643 | — |
| V5S | Autres produits (LOA) | 704629 + 704639 + 704649 | — |
| V5T | Produits sur opérations de location-vente | 7047 | — |
| V5V | Loyers (location-vente) | 704721 + 704731 | — |
| V5W | Reprises de provisions (location-vente) | 704722 + 704732 + 704742 | — |
| V5X | Plus-values de cession (location-vente) | 704723 + 704733 + 704743 | — |
| V5Y | Autres produits (location-vente) | 704729 + 704739 + 704749 | — |
| V6A | PRODUITS SUR OPERATIONS DE CHANGE | 7061 + 7069 | — |
| V6B | Gains sur opérations de change | 7061 | — |
| V6C | Commissions (change) | 7069 | — |
| V6F | PRODUITS SUR OPERATIONS HORS BILAN | 7071 + 7072 + 7073 + 7075 + 7076 | — |
| V6K | Produits sur engagements de financement donnés aux institutions financières | 70711 | — |
| V6L | Produits sur engagements de financement donnés aux membres, bénéficiaires ou clients | 70713 | — |
| V6N | Produits sur engagements de garantie donnés aux institutions financières | 70721 | — |
| V6P | Produits sur engagements de garantie donnés aux membres, bénéficiaires ou clients | 70723 | — |
| V6Q | Produits sur engagements sur titres | 7073 | — |
| V6R | Produits sur autres engagements donnés | 7075 | — |
| V6S | Produits sur opérations effectuées pour le compte de tiers | 7076 | — |
| V6U | PRODUITS SUR PRESTATIONS DE SERVICES FINANCIERS | 7081 + 7089 | 708 |
| V6V | Produits sur les moyens de paiement | 7081 | — |
| V6W | Autres produits sur prestations de services financiers | 7089 | — |
| V7A | AUTRES PRODUITS D'EXPLOITATION FINANCIERE | 7091 + 7098 + 7099 | idem |
| V7B | Plus-values sur cession d'éléments d'actif | 7091 | idem |
| V7C | Transferts de charges d'exploitation financière | 7098 | idem |
| V7D | Divers produits d'exploitation financière | 7099 | idem |
| V8B | MARGE COMMERCIALE | 7111 | idem |
| V8C | Ventes de marchandises | 7118 − 7119 | idem |
| W4A | PRODUITS DIVERS D'EXPLOITATION | 721 + 722 + 725 + 727 + 728 + 729 | 722 + 725 + 728 + 729 |
| W4B | Redevances pour concessions, brevets, licences, droits et valeurs similaires | 721 | — |
| W4D | Indemnités de fonction et rémunération d'administrateurs, gérants reçues | 722 | idem |
| W4G | Plus-values de cession | 7251 + 7252 | idem |
| W4H | Plus-values de cession sur immobilisations incorporelles et corporelles | 7251 | idem |
| W4J | Plus-values de cession sur immobilisations financières | 7252 | idem |
| W4K | Revenus des immeubles hors exploitation | 727 | — |
| W4L | Transferts de charges d'exploitation non financière | 7281 + 7282 + 7289 | idem |
| W4M | Charges refacturées | 7281 | idem |
| W4N | Charges à répartir sur plusieurs exercices | 7282 | idem |
| W4P | Autres transferts de charges | 7289 | idem |
| W4Q | Autres produits divers d'exploitation | 729 | idem |
| W50 | PRODUCTION IMMOBILISEE | 731 + 732 | — |
| W51 | Production immobilisée : immobilisations corporelles | 731 | — |
| W52 | Production immobilisée : immobilisations incorporelles | 732 | — |
| W53 | SUBVENTIONS D'EXPLOITATION | 74 | idem |
| X50 | REPRISES DU FONDS POUR RISQUES FINANCIERS GENERAUX | 75 | idem |
| X51 | REPRISES D'AMORTISSEMENTS ET PROVISIONS SUR IMMOBILISATIONS | 761 + 763 | idem |
| X54 | Reprises d'amortissements des immobilisations | 761 | idem |
| X56 | Reprises de provisions sur immobilisations | 763 | idem |
| X6B | REPRISES DE PROVISIONS ET RECUPERATIONS SUR CREANCES AMORTIES | 7641 + 7642 + 7643 + 766 + 767 + 768 + 769 | 764 + 766 + 767 + 768 + 769 |
| X6C | Reprises de provisions sur créances en souffrance | 7641 + 7642 + 7643 | 764 |
| X6D | Reprises de provisions sur créances en souffrance de 6 mois au plus | 7641 | — |
| X6E | Reprises de provisions sur créances en souffrance de plus de 6 mois à 12 mois au plus | 7642 | — |
| X6F | Reprises de provisions sur créances en souffrance de plus de 12 mois à 24 mois au plus | 7643 | — |
| X6G | Reprises de provisions pour dépréciation des autres éléments d'actif | 766 | idem |
| X6H | Reprises de provisions pour risques et charges | 767 | idem |
| X6I | Reprises de provisions réglementées | 768 | idem |
| X6J | Récupération sur créances amorties | 769 | idem |
| X80 | PRODUITS EXCEPTIONNELS | 771 | idem |
| X81 | PROFITS SUR EXERCICES ANTERIEURS | 772 | idem |
| L80P | DEFICIT (côté produits ; code poste L80) | 59 | idem |
| X84 | TOTAL PRODUITS | 70 + 71 + 72 + 73 + 74 + 75 + 76 + 77 + 59 | idem |

**Lignes SIG proposées (composition déduite de la position dans le modèle, À CONFIRMER)**

| code | libellé | expression | note |
|---|---|---|---|
| SIG_TCI | TOTAL CHARGES D'INTERETS | R08+R3A | composition déduite de la position dans le modèle : À CONFIRMER |
| SIG_TPI | TOTAL PRODUITS D'INTERETS | V08+V3A | composition déduite de la position dans le modèle : À CONFIRMER |
| SIG_MI | MARGE D'INTÉRÊT (bénéficiaire si > 0, déficitaire si < 0) | SIG_TPI-SIG_TCI | RCSFD : solde net des produits et des charges d'intérêt |

### b.4 États annexes (structures ; postes et comptes cités)
Chaque état est établi avec les mêmes en-têtes que le modèle (Établissement, date d'arrêté AAAA/MM/JJ, périodicité P:A, code D, N.S., F:XX/NT:XXX, M:1 = FCFA). Le code D (type d'état) est identique pour DIMF 2005, 2006-2009, 2015 et 2018 (BG0) dans le texte lu : À CONFIRMER.

#### DIMF-2005 — Tableau des emplois et des ressources (annexe 4.1 ; code D : BG0)
- Colonnes : Amortissements/Provisions ; Montants nets
- Lignes :
  - `B02` — ACTIF — Créances sur les membres, bénéficiaires ou clients
  - `B2D` — Crédits à court terme
  - `B30` — Crédits à moyen terme
  - `B40` — Crédits à long terme (développée)
  - `B70` — Crédits en souffrance
  - `D50` — Crédit-bail et opérations assimilées (développée)
  - `D51` — Crédit-bail (développée)
  - `D53` — Location-vente (développée)
  - `D70` — Créances en souffrance sur crédit-bail et opérations assimilées (développée)
  - `G02` — PASSIF — Dettes à l'égard des membres, bénéficiaires ou clients
  - `G10` — Comptes ordinaires créditeurs
  - `G15` — Dépôts à terme reçus
  - `G2A` — Comptes d'épargne à régime spécial
  - `G60` — Emprunts
  - `G70` — Autres sommes dues (allégée)
- Note : Dettes et créances rattachées et valeurs non imputées exclues (RCSFD).

#### DIMF-2010 — État des crédits en souffrance (annexe 4.6 ; code D : BA0)
- Colonnes : A : crédits et prêts en souffrance (191, 192, 193 / 291, 292, 293) ; B : dépôts de garantie (162 et 254) ; C = A − B : soldes restant dus ; D : provisions (199 et 299) ; E = C − D : crédits et prêts en souffrance nets
- Lignes :
  - Crédits comportant au moins une échéance impayée ≤ 6 mois
  - Crédits comportant au moins une échéance impayée > 6 mois ≤ 12 mois
  - Crédits comportant au moins une échéance impayée > 12 mois ≤ 24 mois
  - TOTAL
- Note : Texte du RCSFD : lignes par nature (prêts < 1 an, à terme ; crédits CT, MT, LT) et retard (≤ 3 mois, > 3 ≤ 6, > 6 ≤ 12, > 12 ≤ 24) alors que le modèle n'a que 3 tranches. Colonnes A/B citent 191-193 et 291-293 (le poste 294 n'est pas cité). À CONFIRMER.

#### DIMF-2011 — État des informations annexes (annexe 4.7 ; code D : BB0)
- Colonnes : Montant / Effectif
- Lignes :
  - `I11_ENG_CT` — Encours des engagements par signature à court terme (développée)
  - `I11_ENG_MLT` — Encours des engagements par signature à moyen et long termes (développée)
  - `I11_AUTRES_OPS` — Montant total consacré par l'institution aux opérations autres que les activités d'épargne et de crédit
  - `I11_MEMBRES` — Nombre total de membres, bénéficiaires ou clients de l'institution
  - `I11_GROUPEMENTS` — Nombre total de groupements de l'institution ainsi que de leurs membres
  - `I11_HOMMES` — Nombre total de membres, bénéficiaires ou clients de sexe masculin
  - `I11_FEMMES` — Nombre total de membres, bénéficiaires ou clients de sexe féminin
  - `I11_GRP_BENEF` — Nombre total de groupements bénéficiaires
  - `I11_USAGERS` — Nombre total d'usagers bénéficiaires
  - `I11_SOCIETAIRES` — Nombre total de sociétaires bénéficiaires
  - `I11_POP_CIBLE` — Population cible du SFD (ou estimation)
  - `I11_DEP_IF_1AN` — 126-127-128 : Dépôts à plus d'un an du SFD auprès des institutions financières
  - `I11_DAT_1AN` — 252 : Dépôts à terme à plus d'un an des membres, bénéficiaires ou clients
  - `I11_EPARGNE_SPEC` — 253 : Comptes d'épargne à régime spécial
  - `I11_AUTRES_DEP_1AN` — 254-255 : Autres dépôts à plus d'un an des membres, bénéficiaires ou clients
  - `I11_RECOUV_REALISES` — Recouvrements sur prêts intervenus au cours de l'exercice
  - `I11_RECOUV_ATTENDUS` — Recouvrements sur prêts attendus au cours de l'exercice
- Note : Codes de ligne I11_* = codes proposés (le modèle n'en donne pas). Montants en milliers de FCFA selon le texte, « en Francs CFA » selon le modèle : À CONFIRMER.

#### DIMF-2011-1 — État des engagements par signature (développée ; cité par l'Instr. 001-02-2018 pour tous les SFD) (annexe 4.8 ; code D : BC0)
- Colonnes : Montant (comptes 90, 91, 92, 93, 95, 96, 99)
- Lignes :
  - Encours des engagements par signature donnés à court terme
  - Encours des engagements par signature donnés à moyen et long termes
  - TOTAL

#### DIMF-2012 — État de l'encours de crédits des dix débiteurs les plus importants (annexe 4.9 ; code D : BF0 (lu « BFO »))
- Colonnes : Prénoms / noms / n° d'identification ; Durée initiale du crédit ; Durée résiduelle ; Montants nets en FCFA
- Lignes :
  - `I12_LIGNES` — Dix premières lignes (encours les plus importants par membre)
  - `I12_MAX` — Plus gros encours (maximum des lignes, ligne proposée pour le ratio R4)
  - `I12_TOTAL` — TOTAL
- Note : Code D identique à DIMF 2014 dans le texte : À CONFIRMER.

#### DIMF-2013 — État de l'encours total des prêts aux dirigeants, au personnel et aux personnes liées (annexe 4.10 ; code D : BE0)
- Colonnes : Prénoms / noms / n° d'identification ; Encours des prêts (bruts)
- Lignes :
  - `I13_LIGNES` — Une ligne par dirigeant, membre du personnel ou personne liée (prêts et engagements par signature, montant brut)
  - `I13_TOTAL` — TOTAL

#### DIMF-2014 — État des ressources affectées et des crédits consentis sur ressources affectées (annexe 4.11 ; code D : BF0 (lu « BFO »))
- Colonnes : Court terme ; Moyen terme ; Long terme ; Total
- Lignes :
  - RESSOURCES AFFECTÉES (comptes 181, 182, 183 ; total 18)
  - CRÉDITS CONSENTIS SUR RESSOURCES AFFECTÉES
  - dont crédits en souffrance (= crédits consentis − crédits sains consentis sur ces ressources)
  - TOTAL

#### DIMF-2015 — État des valeurs immobilisées (annexe 4.12 ; code D : BG0)
- Colonnes : Montants bruts ; Amortissements/Provisions ; Montants nets
- Lignes :
  - `D1A` — Immobilisations financières
  - `D1E` — Titres de participation
  - `D1L` — Titres d'investissement
  - `D1S` — Dépôts et cautionnements
  - `D23` — Immobilisations en cours
  - `D24` — Incorporelles
  - `D25` — Corporelles
  - `D30` — Immobilisations d'exploitation
  - `D31` — Incorporelles
  - `D32` — Droit au bail
  - `D33` — Autres éléments du fonds commercial
  - `D34` — Frais d'établissement
  - `D35` — Autres immobilisations incorporelles
  - `D36` — Corporelles

#### DIMF-2016 — État d'affectation du résultat (annexe 4.14 (allégée) / 4.13 (texte) ; code D : BH0)
- Colonnes : Proposition de répartition ; Répartition effective
- Lignes :
  - `L80` — Résultat de l'exercice (+/−)
  - `L70` — Report à nouveau (+/−)
  - `770` — RESULTAT À AFFECTER
  - `772` — Réserve générale
  - `773` — Réserves facultatives
  - `774` — Autres réserves
  - `776` — Report à nouveau bénéficiaire
  - `777` — Autres affectations
  - `776b` — Affectation du résultat déficitaire : report à nouveau déficitaire
  - `778` — Prélèvements sur les réserves
  - `779` — Autres
- Note : Codes 77x = codes de ligne de l'état, sans rapport avec les comptes de classe 77. Annexe numérotée 4.13 dans le texte, 4.14 sur le modèle allégé.

#### DIMF-2006 — État des biens donnés en crédit-bail et opérations assimilées (développée) (annexe 4.2 ; code D : BG0)
- Colonnes : Durée ; Montants bruts ; Amortissements/Provisions ; Montants nets
- Lignes :
  - Crédit-bail mobilier ; crédit-bail immobilier ; crédit-bail sur actifs incorporels ; location avec option d'achat ; location-vente ; créances en souffrance sur crédit-bail ; TOTAL

#### DIMF-2007 — État des biens détenus dans le cadre de la concession (développée) (annexe 4.3 ; code D : BG0)
- Colonnes : Durée ; Valeur d'inventaire ou de marché ; Concessionnaire (nom) ; Valeur déclarée dans le cahier des charges
- Lignes :
  - Postes ; TOTAL

#### DIMF-2008 — État des biens détenus dans le cadre de la clause de réserve de propriété (développée) (annexe 4.4 ; code D : BG0)
- Colonnes : Objet de la clause ; Montants bruts ; Date d'inscription ; Durée de jouissance ; Créanciers
- Lignes :
  - Libellés des biens inscrits à l'actif frappés de la clause ; TOTAL

#### DIMF-2009 — Détail du compte 6221 — Personnel extérieur à l'institution (développée ; cité par l'Instr. 001-02-2018 pour tous les SFD) (annexe 4.5 ; code D : BG0)
- Colonnes : Effectif : nationaux, autres États de l'UMOA, hors UMOA ; secteur primaire/secondaire/tertiaire ; total ; Facturation à l'institution
- Lignes :
  - 1. Cadres supérieurs ; 2. Techniciens supérieurs et cadres moyens ; 3. Techniciens, agents de maîtrise ; 4. Employés, manœuvres, ouvriers et apprentis ; permanents ; saisonniers ; TOTAL
- Note : Compte 6221 = S3B.

#### DIMF-2018 — État de traitement de la réévaluation (développée) (annexe 4.14 ; code D : BG0)
- Colonnes : Date de réévaluation ; Nature (libre, légale, indiciaire) ; Méthode (coûts actuels) ; Valeurs avant réévaluation (VNC) (1) ; Valeur réévaluée (2) ; Écart de réévaluation (2)−(1)
- Lignes :
  - Biens réévalués ; TOTAL

### b.5 Règles et normes prudentielles (Instr. 010-08-2010 et 016-12-2010)
Transmission : ratios annuels calculés sur les états arrêtés au 31/12 et transmis en 3 exemplaires au Ministre, à la BCEAO et à la Commission Bancaire dans les 6 mois ; données mensuelles et trimestrielles au plus tard un mois après la période ; support électronique pour les SFD de l'article 44 (Instr. 010-08-2010, art. 3-4). La BCEAO publie une périodicité différente de celle résumée dans `prudentiel.md` (UEMOA-PRU-011) : voir §d.

**Fonds propres réglementaires (dénominateur des annexes III, IV, VIII, IX et de l'Instr. 016)** : `L10+L20+L27+L30+L35+L41+L45+L50+L55+L59+L60-L62+L65+L70+L75+L80-E05-(D24+D31+D41+D46)-FP_DED_PROV-FP_DED_PART`.
Éléments + : L10 L20 L27 L30 L35 L41 L45 L50 L55 L59 L60 L65 L70(+) L75* L80(+). Éléments − : L62, E05*, immobilisations incorporelles nettes (D24+D31+D41+D46), L70(−), L80(−), compléments de provisions exigés par les Autorités (saisie), participations croisées dans SFD/établissements de crédit (saisie). * L75/E05 : états infra-annuels uniquement. L70 et L80 sont pris algébriquement (une seule fois).

| état | périodicité SFD art. 44 | périodicité autres SFD |
|---|---|---|
| UEMOA-REP-PRU-01 — Limitation des risques | MENSUELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-02 — Couverture des emplois à moyen et long terme par des ressources stables | TRIMESTRIELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-03 — Limitation des prêts aux dirigeants, au personnel et aux personnes liées | MENSUELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-04 — Limitation des risques pris sur une seule signature | MENSUELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-05 — Coefficient de liquidité | MENSUELLE | MENSUELLE (SFD collectant des dépôts) / TRIMESTRIELLE (autres) |
| UEMOA-REP-PRU-06 — Limitation des opérations autres que l'épargne et le crédit | TRIMESTRIELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-07 — Constitution de la réserve générale | TRIMESTRIELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-08 — Norme de capitalisation | MENSUELLE | MENSUELLE |
| UEMOA-REP-PRU-09 — Limitation des prises de participation | TRIMESTRIELLE | TRIMESTRIELLE |
| UEMOA-REP-PRU-10 — Financement des immobilisations et des participations par les fonds propres | TRIMESTRIELLE | TRIMESTRIELLE |

#### UEMOA-REP-PRU-01 — Limitation des risques (Instr. 010-08-2010, annexe I (art. 147 loi))
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R1_NUM | Risques portés (montants nets de provisions et de dépôts de garantie) | `A12+A2A+A3A+A70+B2D+B2N+B30+B40+B70+C10+D1E+D1L+N1A+N1J+N3A+Q1A` | Engagements par signature donnés = N1A+N1J+N3A+Q1A (texte). « nets des dépôts de garantie » : déduction non détaillée dans l'annexe (F2C, G30 ?) — À CONFIRMER |
| R1_DEN | Ressources internes et externes | `F1A+F2A+F3A+F50+G2A+G10+G15+G35+G60+G70+L01` |  |
| R1 | Ratio de limitation des risques (%) | `R1_NUM/R1_DEN*100` | norme : 200 % maximum |

Norme : <= 200 %

#### UEMOA-REP-PRU-02 — Couverture des emplois à moyen et long terme par des ressources stables (Instr. 010-08-2010, annexe II)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R2_NUM | Ressources stables (parts à durée résiduelle > 12 mois) | `L01+F2A+F3F+F50+G15+G2A+G30+G35+G60+G70` | Filtre d'échéance résiduelle > 12 mois obligatoire sur F2A, F3F, F50, G15, G2A, G30, G35, G60, G70 (texte : « à moyen et long terme ») |
| R2_DEN | Emplois à moyen et long terme (montants nets, durée résiduelle > 12 mois) | `A2H+A2I+A2J+A3C+A70+B30+B40+B70+D1E+D1L+D10+D1S+D23+D30+D40` | A70, B70 nets de provisions ; D40 = immobilisations hors exploitation (texte : D40) |
| R2 | Ratio de couverture des emplois MLT (%) | `R2_NUM/R2_DEN*100` | norme : 100 % minimum |

Norme : >= 100 %

#### UEMOA-REP-PRU-03 — Limitation des prêts aux dirigeants, au personnel et aux personnes liées (Instr. 010-08-2010, annexe III ; loi art. 35 ; décret art. 20)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R3_NUM | Prêts et engagements par signature aux dirigeants, au personnel et personnes liées (montant brut) | `I13_TOTAL` | Tiré du tableau annexé aux états financiers (DIMF 2013) et vérifié sur l'état détaillé des crédits (texte) |
| R3_DEN | Fonds propres réglementaires | `FP` | Voir ligne FP (fonds propres réglementaires) de UEMOA-REP-PRU-FP |
| R3 | Ratio de limitation des prêts aux dirigeants (%) | `R3_NUM/R3_DEN*100` | norme : 10 % maximum des fonds propres |

Norme : <= 10 %

#### UEMOA-REP-PRU-04 — Limitation des risques pris sur une seule signature (Instr. 010-08-2010, annexe IV)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R4_NUM | Prêts et engagements par signature donnés au plus gros emprunteur / signature (brut) | `I12_MAX` | Plus gros emprunteur issu de l'état DIMF 2012 ; regroupement des personnes liées par contrôle (« une seule signature » défini à l'annexe IV) à appliquer avant le MAX |
| R4_DEN | Fonds propres réglementaires | `FP` | Voir ligne FP (fonds propres réglementaires) de UEMOA-REP-PRU-FP |
| R4 | Ratio risques sur une seule signature (%) | `R4_NUM/R4_DEN*100` | norme : 10 % maximum des fonds propres |

Norme : <= 10 %

#### UEMOA-REP-PRU-05 — Coefficient de liquidité (Instr. 010-08-2010, annexe V)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R5_NUM | Valeurs réalisables et disponibles (montants nets, durée résiduelle ≤ 3 mois) | `A10+A12+A2J+A2A+A3B+B2D+B2N+B30+B40+C10+C30+C40+C56+(A60+B65+C55)+(N1A+N1J+N2A+N2J)` | Filtre échéance résiduelle ≤ 3 mois. Annotation manuscrite « ≤ 3 mois » à côté de B30 sur le scan. A2J est libellé « dépôts à court terme » dans l'annexe alors que le poste A2J = 1281 (autres dépôts constitués) : À CONFIRMER. Engagements donnés au numérateur (texte). |
| R5_DEN | Passif exigible (durée résiduelle ≤ 3 mois) | `F1A+F2A+F3E+F3F+F50+G10+G15+G2A+G30+G35+G60+G70+H10+H40+(F60+G90)+(N1H+N1K+N2H+N2M)` | Engagements de financement et de garantie reçus au dénominateur (texte) |
| R5 | Coefficient de liquidité (%) | `R5_NUM/R5_DEN*100` | norme selon catégorie, voir normesParCategorie |

Normes : MUTUALISTE_NON_AFFILIEE_OU_AUTRE_SFD_COLLECTANT_DEPOTS : >= 100 % ; MUTUALISTE_AFFILIEE : >= 80 % ; SFD_SANS_COLLECTE_DEPOTS : >= 60 %

#### UEMOA-REP-PRU-06 — Limitation des opérations autres que l'épargne et le crédit (Instr. 010-08-2010, annexe VI ; loi art. 36)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R6_NUM | Montant consacré aux opérations autres que l'épargne et le crédit | `I11_AUTRES_OPS` | Ligne « Montant total consacré par l'institution aux opérations autres que les activités d'épargne et de crédit » de l'état DIMF 2011 |
| R6_DEN | Risques portés (montants nets de provisions et dépôts de garantie) | `A12+A3A+A70+B2D+B2N+B30+B40+B70+C10+D1E+D1L+N1A+N1J+N3A+Q1A` | Différence avec l'annexe I : A2A absent du dénominateur (texte) |
| R6 | Ratio opérations autres (%) | `R6_NUM/R6_DEN*100` | norme : 5 % maximum |

Norme : <= 5 %

#### UEMOA-REP-PRU-07 — Constitution de la réserve générale (Instr. 010-08-2010, annexe VII ; loi art. 85 et 124)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R7_BASE | Base de calcul : résultat (L80) + report à nouveau déficitaire (L70) | `L80+MIN(L70,0)` | Fonction MIN hors syntaxe + - * / : à implémenter (L70 négatif seulement). Texte : « Résultat (L80) + Report à nouveau déficitaire (L70) » |
| R7 | Dotation annuelle minimale à la réserve générale (L56) | `R7_BASE*0.15` | Dotation minimale 15 % de la base ; obligatoire quel que soit le cumul |

Norme : >= 15 % (dotation >= 15 % de la base)

#### UEMOA-REP-PRU-08 — Norme de capitalisation (Instr. 010-08-2010, annexe VIII ; loi art. 85 et 123)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R8_NUM | Fonds propres réglementaires de fin de période | `FP` | Voir ligne FP (fonds propres réglementaires) de UEMOA-REP-PRU-FP |
| R8_DEN | Total actif de fin de période, montants nets | `E90` |  |
| R8 | Ratio de capitalisation (%) | `R8_NUM/R8_DEN*100` | norme : 15 % minimum (délai de 2 ans pour les SFD en activité au 30/08/2010) |

Norme : >= 15 %

#### UEMOA-REP-PRU-09 — Limitation des prises de participation (Instr. 010-08-2010, annexe IX ; loi art. 36)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R9_NUM | Titres de participation (D1E) hors participations dans établissements de crédit et SFD | `D1E_HORS_PART` | D1E diminué des participations dans EC et SFD : décomposition à saisir (D1E seul = poste du bilan ; version allégée : concordance D1E NON TROUVÉE) |
| R9_DEN | Fonds propres réglementaires | `FP` | Voir ligne FP (fonds propres réglementaires) de UEMOA-REP-PRU-FP |
| R9 | Ratio de participations (%) | `R9_NUM/R9_DEN*100` | norme : 25 % maximum |

Norme : <= 25 %

#### UEMOA-REP-PRU-10 — Financement des immobilisations et des participations par les fonds propres (Instr. 016-12-2010, art. 3-7 et annexe)
| ligne | libellé | expression sur codes de postes | note |
|---|---|---|---|
| R10_NUM | Immobilisations corporelles et incorporelles + titres de participation (hors frais et valeurs immobilisés incorporels et hors participations dans SFD/EC), nets | `D24+D25+D31+D36+D41+D45+D46+D47+D1E` | D46 et D47 nets des immobilisations acquises par réalisation de garantie depuis moins de 2 ans ; D31 déduction faite des frais et valeurs immobilisés ; D1E hors participations dans SFD/EC (saisie) |
| R10_DEN | Fonds propres réglementaires | `FP` | Voir ligne FP (fonds propres réglementaires) de UEMOA-REP-PRU-FP |
| R10 | Ratio de financement des immobilisations (%) | `R10_NUM/R10_DEN*100` | norme : 100 % maximum des fonds propres ; transmission trimestrielle (1 mois) et annuelle (6 mois) |

Norme : <= 100 %

### b.6 Indicateurs périodiques — I. Indicateurs financiers (Instr. 020-12-2010, annexe I)
Périodicité : mensuelle pour les SFD de l'article 44, trimestrielle pour les autres ; délai : 30 jours calendaires après la fin du mois (ou du trimestre) ; destinataires : Ministre des Finances, BCEAO, Commission Bancaire ; support électronique pour l'article 44, électronique ou papier signé pour les autres (art. 2-4). Moyennes : « moyenne » = moyenne des encours sur la période (méthode de moyenne non précisée : À CONFIRMER). Les « normes » sont celles du tableau (« Tendance haussière » = pas de seuil).

| code | indicateur | numérateur | dénominateur | code RCSFD cité | norme | note |
|---|---|---|---|---|---|---|
| IND-F01 | Portefeuille classé à risque (PAR x jours) | Encours des prêts comportant au moins une échéance impayée depuis plus de x jours (x = 30 ; 90 ; 180) | Montant brut du portefeuille de prêts | (B2D à B70) - B65 | < 5 % (x >= 30 jours) ; < 3 % (x >= 90 jours) ; < 2 % (x >= 180 jours) | Numérateur : calculé sur l'échéancier (non comptable). Dénominateur : B2D+B2N+B30+B40+B70-B65 ; B70 est net de provisions dans la nomenclature, le texte parle de « brut » → ajouter 2991+2992+2993 pour le brut (À CONFIRMER) |
| IND-F02 | Taux de provisions pour créances en souffrance | Montant brut des provisions constituées sur créances en souffrance | Montant brut des créances en souffrance | B70 (2e colonne amortissements et provisions) / B70 (1re colonne montant brut) | >= 40 % | Colonnes brut / provisions du bilan |
| IND-F03 | Taux de perte sur créances | Montant des pertes enregistrées sur les créances au cours de la période | Total des encours bruts de crédits de la période, y compris en souffrance | Numérateur T6K+T6L ; dénominateur (B2D à B70) - B65 | < 2 % |  |
| IND-F04 | Montant moyen des crédits décaissés | Mouvements au débit des comptes de crédits aux membres (CT, MT, LT) au niveau de la balance générale | Nombre total de crédits décaissés au cours de la période | — | tendance haussière (pas de seuil) | Pas de code RCSFD pour le nombre de crédits |
| IND-F05 | Montant moyen de l'épargne par épargnant | Dépôts des membres ou bénéficiaires (fin de période) | Nombre d'épargnants (personnes ayant un ou plusieurs dépôts, y compris épargne obligatoire, comptées une fois) | G10 à G35 | tendance haussière (pas de seuil) |  |
| IND-F06 | Encours moyen des crédits par emprunteur | Crédits sains + crédits en souffrance (fin de période) | Nombre de personnes ayant un encours de crédit (comptées une fois) | (B2D à B70) - B65 | tendance haussière (pas de seuil) |  |
| IND-F07 | Productivité des agents de crédit | Nombre d'emprunteurs actifs | Nombre d'agents de crédit | — | >= 130 (les structures non conformes doivent en donner les raisons) (ratio : emprunteurs ou clients par agent/employé) |  |
| IND-F08 | Productivité du personnel | Nombre de clients actifs (au moins un dépôt ou un crédit en cours) | Nombre d'employés | — | > 115 (ratio : emprunteurs ou clients par agent/employé) |  |
| IND-F09 | Charges d'exploitation rapportées au portefeuille de crédits | Charges d'exploitation (CE) | Montant brut moyen du portefeuille de crédits de la période | (R08 à T6B) / Moyenne [(B2D à B70) - B65] | <= 35 % | CE = comptes 60+61+62+63+64+65+66 |
| IND-F10 | Ratio des frais généraux rapportés au portefeuille de crédits | Frais de personnel + impôts et taxes + autres charges externes et charges diverses d'exploitation + dotations au fonds pour risques financiers généraux | Montant brut moyen du portefeuille de crédits de la période | S02 à T50 / Moyenne [(B2D à B70) - B65] | < 15 % (structures de crédit direct) ; < 20 % (structures d'épargne et de crédit) | S02+S1A+S2A+T50 |
| IND-F11 | Ratio des charges de personnel | Salaires et traitements + charges sociales + rémunérations versées aux stagiaires | Montant brut moyen du portefeuille de crédits de la période | S02 / Moyenne [(B2D à B70) - B65] | < 5 % (structures de crédit direct) ; < 10 % (structures d'épargne et de crédit) |  |
| IND-F12 | Rentabilité des fonds propres | Résultat d'exploitation hors subventions (RE = PE − CE) | Montant moyen des fonds propres pour la période | (V08 à X6B − W53) − (R08 à T6B) / L01 | > 15 % | PE = comptes 70+71+72+73+75+76 ; CE = comptes 60+61+62+63+64+65+66 ; dénominateur = L01 (code cité par le texte) |
| IND-F13 | Rendement sur actif | Résultat d'exploitation hors subventions (RE) | Montant moyen de l'actif pour la période | RE / E90 | > 3 % |  |
| IND-F14 | Autosuffisance opérationnelle | Produits d'exploitation (PE) | Charges d'exploitation (CE) | (V08 à X6B − W53) / (R08 à T6B) | > 130 % |  |
| IND-F15 | Marge bénéficiaire | Résultat d'exploitation (RE) | Produits d'exploitation (PE) | RE / (V08 à X6B − W53) | > 20 % |  |
| IND-F16 | Coefficient d'exploitation | Frais généraux (FG) | Produits financiers nets (PFN) | S02 à T50 / [(V08 à V7A) − (R08 à R7A)] | <= 40 % (structures de crédit direct) ; <= 60 % (structures d'épargne et de crédit) | FG = S02+S1A+S2A+T50 ; PFN = (V08+V3A+V4B+V5B+V6U+V7A) − (R08+R3A+R4B+R5B+R6V+R7A) |
| IND-F17 | Taux de rendement des actifs | Intérêts et commissions perçus (V08 à V7A) | Actifs productifs : opérations avec institutions financières + membres + titres à court terme + immobilisations financières | (A01−A10−A60−A70)+(B01−B65−B70)+(C10+C56)+D1A | > 15 % |  |
| IND-F18 | Ratio de liquidité de l'actif | Encaisses et comptes courants ordinaires + titres à court terme | Total actif du bilan | (A10+A12+A2H+A2J+C10) / E90 | > 2 % (structures de crédit direct) ; > 5 % (structures d'épargne et de crédit) | Le texte imprime « A2H++A2J » (double plus) : À CONFIRMER |
| IND-F19 | Ratio de capitalisation (indicateur) | Fonds propres (L01) | Total actif du bilan (E90) | L01 / E90 | > 15 % | Différent de la norme prudentielle R8 (fonds propres réglementaires retraités) |

Définitions complémentaires (annexe, indicateurs IV) : PE = produits d'exploitation hors subventions d'exploitation et produits exceptionnels ; CE = charges totales sauf charges exceptionnelles, pertes sur exercices antérieurs et impôts sur les excédents ; RE = PE − CE. Lecture comptable proposée : PE = comptes 70+71+72+73+75+76 ; CE = comptes 60+61+62+63+64+65+66 (À CONFIRMER).

### b.7 Indicateurs périodiques — II. Indicateurs non financiers (Instr. 020-12-2010, annexe II)
Colonnes de tous les tableaux : Trimestre (T-1), Trimestre (T), Variation (%) ; pour les SFD de l'article 44 les indicateurs non financiers sont produits sur base mensuelle (note de l'annexe). (*) à renseigner par les structures faîtières d'institutions coopératives ou mutualistes ; (**) institutions non mutualistes.

**IND-N01 — Tableau n°1 : Nombre de membres, bénéficiaires ou clients**
- Nombre total de membres, bénéficiaires ou clients (1)+(2)
- Personnes physiques non-membres d'un groupement (1) = (a)+(b) ; hommes (a) ; femmes (b)
- Personnes morales (groupements de personnes physiques, entreprises, associations…) (2)
- Nombre de groupements de personnes physiques bénéficiaires
- Nombre total des membres des groupements de personnes physiques bénéficiaires (3) = (c)+(d) ; hommes (c) ; femmes (d)

**IND-N02 — Tableau n°2 : Effectif des dirigeants et du personnel employé**
- Nombre de membres du Conseil d'Administration ou de l'organe équivalent
- Nombre de membres du Conseil de Surveillance, s'il y a lieu
- Nombre de membres du Comité de Crédit, s'il y a lieu
- Effectif total des employés = (1)+(2) ; dirigeants exerçant des fonctions de direction ou de gérance (1) ; autres employés (2)
- Agents permanents ; agents contractuels ; personnel expatrié sous contrat à durée déterminée / indéterminée ; agents nationaux ; personnel expatrié

**IND-N03 — Tableau n°3 : Nombre des déposants**
- Nombre total de déposants (1)+(2)
- Personnes physiques non-membres d'un groupement (1) = (a)+(b), hommes (a), femmes (b)
- Personnes morales (groupements, entreprises, associations) (2)

**IND-N04 — Tableau n°4 : Nombre de crédits en cours**
- Nombre de crédits en cours (1)+(2)
- Personnes physiques non-membres d'un groupement (1) = (a)+(b), hommes (a), femmes (b)
- Personnes morales (2)

**IND-N05 — Tableau n°5 : Répartition des crédits selon leur objet (en milliers de FCFA)**
- Crédits immobiliers
- Crédits d'équipement
- Crédits à la consommation
- Crédits de trésorerie
- Autres crédits

**IND-N06 — Tableau n°6 : Nombre de crédits en souffrance**
- Nombre de crédits en souffrance (1)+(2)
- Personnes physiques non-membres d'un groupement (1) = (a)+(b), hommes (a), femmes (b)
- Personnes morales (2)

**IND-N07 — Tableau n°7 : Indicateurs sur la surveillance**
- Nombre d'institutions affiliées *
- Nombre d'institutions affiliées contrôlées *
- Taux de mise en œuvre des recommandations formulées au cours des contrôles *
- Nombre de réunions tenues par le Conseil de Surveillance *
- Nombre d'agences ou de points de services **
- Nombre de rapports de contrôle interne **

### b.8 Rapport annuel (Instr. 018-12-2010) — annexe de tableaux
Contenu obligatoire (art. 3 et annexe) : description de l'historique ; vie de l'institution (environnement socio-économique, pratiques mutualistes, gouvernance, situation financière, prestations offertes, innovations, activités sociales, LBC/FT, changements d'organisation, difficultés, relations avec les Autorités, partenaires, perspectives) ; affiliations et désaffiliations ; liste des autres institutions financières avec lesquelles l'institution place ou emprunte ; états financiers approuvés par l'AG (bilan, compte de résultat, états annexes) ; tableaux ci-dessous. Transmission : électronique pour l'article 44, sinon électronique ou papier signé. Les tableaux 4.8, 4.9 et 5.1 ont été lus sur des pages à faible résolution (◐).

| tableau | contenu |
|---|---|
| I. Données générales — 1.1 | Nombre de membres/clients (unités) : personnes physiques non-membres d'un groupement (a) hommes (b) femmes ; personnes morales ; groupements ; membres de groupements (c) hommes (d) femmes |
| 1.2 | Effectif : membres du CA, du Conseil de Surveillance, du Comité de Crédit ; effectif total ; dirigeants ; autres employés ; permanents, contractuels, expatriés |
| 1.3 | Masse salariale globale en FCFA (personnel dirigeant ; autre personnel) ; frais généraux ; ratio masse salariale / frais généraux ; proportion salaire du DG / frais généraux ; remboursements de frais des dirigeants élus (indemnités des administrateurs non salariés, frais de réunions : perdiem, transport, hébergement, téléphone, carburant, autres) |
| II. T2 | Nombre d'institutions de base ; nombre de guichets ou d'antennes (années n-1, n, variation) |
| III. 3.1 | Montant des dépôts (milliers de FCFA) : personnes physiques (hommes, femmes), personnes morales |
| 3.2 | Décomposition des dépôts par terme : à vue, à terme, autres (montant FCFA et part %) |
| 3.3 | Nombre de déposants (par sexe, personnes morales) ; nombre de comptes inactifs ; montant des soldes des comptes inactifs (page à faible résolution) |
| 3.4 / 3.5 | Évolution du capital social (milliers FCFA) ; répartition du capital entre principaux actionnaires (noms, montant et part du capital détenu années n et n-1) |
| IV. 4.1 | Montant annuel des prêts accordés (milliers FCFA) |
| 4.2 | Nombre de prêts accordés dans l'année ; montant moyen |
| 4.3 | Engagements par signature : financement donnés aux institutions financières et aux membres ; garantie d'ordre |
| 4.4 / 4.5 | Encours de crédits au 31/12 (milliers FCFA) ; nombre de crédits en cours (par sexe, personnes morales) |
| 4.6 | Évolution de l'encours par terme : court terme / moyen et long terme (n, n-1, variations) |
| 4.7 | Encours des crédits des agents relevant des Autorités de contrôle (prénom, nom, encours, structure) |
| 4.8 | Opérations de crédit sur ressources affectées : nombre et montant des crédits accordés, nombre et montant des crédits en cours (page à faible résolution) |
| 4.9 | Gestion du portefeuille de crédit : encours des créances en souffrance ; taux brut des créances en souffrance (note 3 : encours brut des créances en souffrance / encours brut des crédits) ; taux de remboursement (note 4 : échéances remboursées / échéances attendues dans l'année) ; taux de recouvrement (note 5 : créances en souffrance recouvrées / total des créances en souffrance) ; mêmes trois taux sur ressources affectées (notes 6 à 8) ; montant des crédits passés en perte ; taux de perte (note 9 : crédits passés en perte / encours des crédits de la période) |
| V. 5.1 / 5.2 / 5.3 | Transfert rapide d'argent (reçus/émis par zone) ; micro-assurance (primes émises vie/non vie, arriérés, sinistres) ; opérations de change (EUR, USD, CHF, GBP, autres : montants achetés/vendus et contre-valeurs FCFA) |
| VI. 6.1 | Tarification : taux créditeur min/max ; taux débiteur nominal min/max ; taux d'intérêt effectif global |
| 6.2 / 6.3 / 6.4 | Répartition des crédits par objet (immobiliers, équipement, consommation, trésorerie, autres) ; dons et œuvres sociales ; répartition sectorielle (agriculture, industries extractives et manufacturières, bâtiment, électricité-gaz-eau, commerce-restaurants-hôtels, transports-communications, assurances-services aux entreprises, immobilier, services divers) |
| VII. T7 | Opérations avec les autres institutions financières : placements, emprunts, taux moyen des emprunts, ressources affectées, subventions d'exploitation et d'équipement reçues |
| VIII. T8 | (réseaux) institutions affiliées déficitaires/excédentaires : nombre, montants |
| IX. T9 | Nombre de réunions : AG, CA, Conseil de Surveillance, Comité de Crédit, autres comités |
| X. T10 | Marge d'intérêt, produit financier net, résultat net (milliers FCFA), taux de marge nette (résultat net / marge d'intérêt) |

### b.9 Autres états
**Contrôle interne (Instr. 017-12-2010)** — rapport annuel de contrôle global (6 mois après l'année civile ; contenu : organisation et fonctionnement du contrôle interne, moyens, travaux, modifications ; inventaire des contrôles du Conseil de Surveillance, de l'inspection, de la vérification/audit interne avec observations et mesures correctrices ; pour les réseaux, normes de gestion par caisse en annexe ; mandat des contrôleurs, informations générales, lacunes motivées, délai de régularisation et risque) ; copie des rapports d'anomalies sous 30 jours ; copie des manuels de procédures sous 30 jours après l'entrée en vigueur (1er janvier 2011) ; réseaux : programme d'inspection le 15 janvier, bilan du programme le 31 janvier. Aucun modèle chiffré : le « modèle CI » du YAML actuel est sans source.

**Fonds de sécurité ou de solidarité (Instr. 019-12-2010)** — réserve spéciale obligatoire des réseaux IMCEC, compte spécifique ouvert chez la faîtière ; cotisation annuelle non remboursable : 2 % du total de l'actif moyen brut et des engagements par signature la première année, puis 2 % de la variation (art. 5) ; plafond de dotation : 15 % de l'actif total du réseau ; contributions reçues par la faîtière au plus tard 6 mois après la clôture ; interventions sous forme d'emprunt subordonné, au plus 3 fois consécutives pour la même institution ; rapport de contrôle de l'organe de contrôle présenté à l'AG au moins une fois par an (solde début/fin, dotations, utilisations, remboursements, cotisations) ; pour les faîtières de l'article 44, rapport spécifique du commissaire aux comptes transmis aux Autorités ; règlement intérieur transmis dans les 30 jours de son approbation. Aucun compte du RCSFD n'est nommé.

**LBC/FT** — déclaration de soupçon immédiate à la CENTIF, modèle fixé par arrêté du Ministre des Finances (loi uniforme LBC/FT/FP, art. 60) ; déclaration des transactions en espèces ≥ 15 000 000 FCFA (opération unique ou liées) (Décision 021/2023, art. 8, pour l'art. 72) ; identification en cas de transactions multiples en espèces > 9 000 000 FCFA sur une journée (art. 3) ; examen particulier des paiements en espèces ≥ 50 000 000 FCFA et des opérations ≥ 10 000 000 FCFA sans justification (art. 4) ; paiement en espèces d'une créance interdit ≥ 5 000 000 FCFA (Instr. n°233/07/2024, secondaire) ; rapport annuel LBC/FT/FP transmis dans les 2 mois de la fin de l'exercice à la BCEAO et à l'autorité de contrôle (Instr. 001-03-2025, art. 12) avec 8 rubriques.

**BIC** — les SFD communiquent leurs données de crédit à la BCEAO qui les transmet au BIC ; transmission mensuelle, au plus tard le 10 du mois suivant ; support électronique ; format fixé par le contrat de service avec le BIC (Instr. 005-05-2015, art. 2-5).

**Avoirs dormants** — comptes sans intervention depuis 10 ans clôturés le 1er jour ouvré suivant ; virement à l'Agence Principale de la BCEAO ≤ 30 jours après la clôture ; notification le jour du virement avec toutes informations sur les titulaires ; état récapitulatif mensuel ; format électronique selon canevas BCEAO (Instr. 006-06-2014, art. 2-3). Liste des comptes inactifs (8 ans) publiée au moins semestriellement (UEMOA-DOR-008).

**Taux d'usure** — plafond 24 % pour les IMF (Décision 19/2025/CM/UMOA, en vigueur le 01/06/2026) : aucun état déclaratif trouvé ; à contrôler à l'octroi (TEG).

**Nouvelle loi uniforme microfinance (adoptée le 21/12/2023, décision n°019/CM/UMOA)** — structure : 10 titres, 173 articles ; les SFD deviennent IMF ; toutes les IMF publient leurs états financiers sans distinction de taille ; dispositions lues dans la transposition sénégalaise (loi 2025-04) : états financiers individuels/combinés/consolidés et commissaire aux comptes (art. 61, 83) ; rapport annuel au terme de chaque exercice (art. 62) ; publication dans les 6 mois (art. 63) ; reporting prudentiel vers les autorités, la BCEAO et le public (art. 68) ; données périodiques (art. 80) ; liste des impayés (art. 81) ; notification des modifications statutaires sous 6 semaines (art. 82) ; rapport annuel sur les réclamations (art. 94) ; adhésion au FGDR-UMOA, contribution annuelle (art. 99-100) ; plan préventif de redressement (art. 104). Instructions d'application (forme, contenu, délai des états périodiques ; ratios) : NON TROUVÉES.

## c) Surcharges pays

L'« état » de chaque pays n'est connu que pour la Côte d'Ivoire et, sous forme de loi nationale, pour le Sénégal. Les autres pays : NON TROUVÉ (aucune source primaire accessible) — conserver le noyau UEMOA et prévoir une surcharge vide à compléter avec le Ministère des Finances concerné.

| pays | autorité de supervision / destinataire national | états supplémentaires ou différences | source | confiance |
|---|---|---|---|---|
| BJ | ANSSFD — Agence Nationale de Surveillance des SFD (décret n°2015-346 du 15/06/2015) | NON TROUVÉ ; transposition de la loi uniforme microfinance à l'Assemblée nationale (présentation ANSSFD, 2025) | S12 ; sgg.gouv.bj | BASSE |
| BF | Ministère de l'Économie et des Finances (structure NON CONFIRMÉE : DGTCP / direction de la microfinance non retrouvées) | Loi n°001-2025/ALT adoptée le 13/02/2025 (IMF) ; entrée en vigueur signalée en février 2026 ; états : NON TROUVÉ | presse (allAfrica, Sidwaya) | BASSE |
| CI | DRSSFD — Direction de la Réglementation et de la Surveillance des SFD (ex Direction de la Microfinance), Direction générale du Trésor | Ordonnance 2011-367 du 03/11/2011 ; décret 2014-20 du 22/01/2014. Communiqué du 15/03/2024 : programmes annuels de contrôle interne (31/01) ; suivi mensuel de la mise en œuvre des recommandations d'audit (le 5 de chaque mois, 2024) ; rapports d'audit/inspection sous 30 jours ; rapport annuel LBC/FT (28/02 ; l'Instr. 001-03-2025 fixe 2 mois) ; rapports de contrôle global (caisses unitaires et sociétés anonymes 30/06 ; réseaux 31/01) ; états financiers 30/06 ; art. 44 : données périodiques mensuelles (30 jours) ; autres : trimestrielles (30 jours) ; identité des CAC pour sociétés anonymes et art. 44 ; mise à jour des adresses, identifications et points de vente (sans délai) ; pénalités de retard (art. 73) | S13 | MOYENNE |
| GW | NON TROUVÉ (unité de supervision du Ministère des Finances citée pour 2012 ; non confirmée) | NON TROUVÉ | — | BASSE |
| ML | Direction de la microfinance (ex Cellule de contrôle et de surveillance des SFD) | NON TROUVÉ ; nouveau projet de loi en préparation | presse (APA, Ecofin) | BASSE |
| NE | ARSM — Agence de Régulation du Secteur de la Microfinance | NON TROUVÉ ; transposition de la loi uniforme microfinance signalée en cours | S12 | BASSE |
| SN | Ministre chargé des Finances (« DRS » cité par une source secondaire) ; ministère de la Microfinance et de l'ESS (formations 2025) ; Commission Bancaire pour les IMF atteignant le seuil ; Observatoire de la qualité des services financiers | Loi n°2025-04 du 19/02/2025 (JO 7817 du 25/03/2025) : les SFD deviennent IMF, formes SA, SARL, coopérative (associations exclues) ; FGDR-UMOA (art. 99-101) ; rapport réclamations (art. 94) ; plan préventif de redressement (art. 104) ; notification statuts 6 semaines (art. 82) ; commissaire aux comptes mandat 4 ans renouvelable une fois (art. 83) | S11 | MOYENNE |
| TG | Direction de la Microfinance du Ministère de l'Économie et des Finances ; CASIMEC (citée en 2015) ; « ASMFD » : NON CONFIRMÉ | NON TROUVÉ ; projet de loi nationale d'intégration adopté en février 2026 (presse) | allAfrica ; financialafrik | BASSE |

Sigles cités dans la demande : « DRS-SFD » (Sénégal) apparaît dans une source secondaire sans rattachement confirmé ; « CRSFD », « DSF » et « ASMFD » : NON TROUVÉS en source.

## d) Écart vs `sfd-reporting-service/.../zones/uemoa-bceao.yml` (et `uemoa-bceao-sycebnl.yml`)

Constat global : le YAML actuel n'applique pas le plan de comptes RCSFD (classes 1 à 9 du RCSFD : trésorerie, membres, titres/divers, valeurs immobilisées, provisions/fonds propres, charges, produits, hors-bilan) ; il reprend une numérotation de type plan comptable bancaire/OHADA. Toutes les concordances « comptes » du bilan et du compte de résultat sont donc à remplacer.

| # | élément du YAML | constat | correct selon le RCSFD / les instructions |
|---|---|---|---|
| 1 | BIL-A01 « Caisse et avoirs en banques » = 52, 57 | faux : 52 = provisions réglementées, 57 = capital | A10 « Valeur en caisse » = 10 ; A12 comptes ordinaires débiteurs = 1131, ex 1141… (voir b.1) |
| 2 | BIL-A03 « Crédits à la clientèle » = 25 | côté opposé : le 25 regroupe les dépôts des membres (G01) | crédits = B01 (202x, 203x, 204x, 291-294 − 299) |
| 3 | BIL-P01 « Dépôts de la clientèle » = 37 | le 37 = valeurs à l'encaissement/opérations diverses | dépôts = G01 (251 à 255, 271, 272) |
| 4 | BIL-P08 à P11 : capital 10/101000, réserves 11, report 12, résultat 13 | classe 1 = trésorerie | capital L60 (5711+5712), réserves L55 (552), report L70 (58), résultat L80 (59) |
| 5 | CR-001/002/006/007/009/014/015 : intérêts 76-763, personnel 66, provisions 69, impôts 64, exceptionnelles 65 | 76 = reprises, 66 = dotations, 69 = impôts sur excédents, 64 = personnel, 65 = dotation au FRFG | produits d'intérêt V08/V3A (701x, 702x) ; personnel S02 (641-643) ; dotations T51, T6B (661-669) ; impôts T82 (69) ; exceptionnelles T80 (671) |
| 6 | BIL = 23 lignes agrégées, aucun hors-bilan, aucun SIG | modèle officiel : ≈ 110 postes avec codes, colonnes BRUT / AMT-PROV / NET / N-1 | voir b.1 à b.3 |
| 7 | États annexes absents | DIMF 2005, 2010, 2011, 2012, 2013, 2014, 2015, 2016 (+ 2006 à 2009, 2011-1, 2018 en développée) manquent | voir b.4 |
| 8 | IND = « 23 indicateurs (template officiel BCEAO) » en CROSS_SERVICE | l'annexe de l'Instr. 020-12-2010 contient 19 ratios financiers (formules, codes RCSFD, normes) + 7 tableaux non financiers ; les 23 indicateurs du YAML ne correspondent ni à ces ratios ni à ces tableaux | voir b.6, b.7 |
| 9 | SIT / PAR = créances en souffrance / encours ≤ 5 % | aucun état trimestriel « SIT » trouvé dans les textes lus ; le PAR officiel est basé sur les jours d'impayé : < 5 % (x ≥ 30 j), < 3 % (x ≥ 90 j), < 2 % (x ≥ 180 j) | IND-F01 |
| 10 | RAT : 7 ratios dont 6 sans norme ; R1 = (capital+réserves+report+résultat) / actif | l'Instr. 010-08-2010 + 016-12-2010 définissent 10 règles ; fonds propres réglementaires retraités ; manquent risques ≤ 200 %, opérations autres ≤ 5 %, réserve générale 15 %, immobilisations ≤ 100 % ; périodicités par catégorie absentes | b.5 |
| 11 | RAT-005 « R5 liquidité » sans horizon ; R2 sans filtre d'échéance | horizon 3 mois (liquidité) et > 12 mois (couverture MLT) imposés ; normes 100/80/60 % selon catégorie | b.5 |
| 12 | CI « Contrôle Interne » (15 indicateurs) | aucune base légale : l'Instr. 017-12-2010 prescrit des rapports narratifs, un programme d'inspection et un bilan annuel | UEMOA-REP-CI-001 à 004 |
| 13 | FS « Fonds de sécurité et solidarité » : comptes 14, 80 ; taux de couverture fonds / dépôts | comptes sans source ; taux inventé ; l'instruction ne concerne que les réseaux (cotisation 2 %, plafond 15 % de l'actif) | UEMOA-REP-FS-001 |
| 14 | RCSFD-BIL / RCSFD-CR = copies de BIL / CR | pas de distinction allégée/développée (seuil 50 M FCFA ; art. 44) ; libellé « Réseau des Caisses d'Épargne » sans base dans les textes lus | b.0 |
| 15 | Aucune périodicité, délai, destinataire ni assujetti dans les rapports | à porter au paquet (a) ; pénalités art. 73 | a) |
| 16 | `uemoa-bceao-sycebnl.yml` REG-BCEAO-008 à 012 (SYCEBNL : fonds dédiés classe 17, TER, subventions 14 et 71) | aucun texte BCEAO imposant le SYCEBNL aux SFD n'a été trouvé ; les textes lus imposent le RCSFD. SYCEBNL relève du droit OHADA et ne remplace pas les états DIMF | NON TROUVÉ |
| 17 | En-têtes « REG-BCEAO-001 à 007 », « ANALYSE_COMPLETE_REPORTING.md » | références non vérifiables dans les textes officiels | — |

Écarts avec les notes existantes (`prudentiel.md`, `clotures.md`, `README.md`) :
- UEMOA-PRU-011 (périodicité) ne correspond pas à l'annexe de périodicité de l'Instr. 010-08-2010 : pour les SFD de l'article 44 la capitalisation est mensuelle et les prêts aux dirigeants sont mensuels (non trimestriels) ; la réserve générale, les opérations autres, la couverture MLT et les participations sont trimestrielles ; pour les autres SFD la capitalisation est mensuelle, la liquidité mensuelle si collecte de dépôts, le reste trimestriel (b.5).
- Le ratio de financement des immobilisations (Instr. 016-12-2010, ≤ 100 % des fonds propres) est absent de `prudentiel.md` (indiqué « non lu »).
- `lbc-ft.md` : le seuil de déclaration des espèces est désormais connu (15 000 000 FCFA, Décision 021/2023, art. 8) ; l'Instr. 007-09-2017 est abrogée par l'Instr. 001-03-2025.
- `clotures.md` UEMOA-CLO-014 : la loi fixe bien 6 mois (art. 51) pour le rapport annuel ; l'Instr. 018-12-2010 ne répète pas le délai.

## e) Lacunes et points à confirmer

1. RCSFD développée lue sur la copie du Trésor de Côte d'Ivoire (édition de juillet 2009, ISBN 978-2-916140-08-7) et non sur le site de la BCEAO ou de la Commission Bancaire : à comparer avec la version officielle en vigueur ; l'édition allégée cb-umoa (novembre 2009) n'a pas de hors-bilan, la copie CI en a un jeu allégé.
2. Incohérences internes du RCSFD à faire trancher : (a) A70 « 191+192+193+194 − 199 » mais A71 à A73 = 192/193/194 (annexe 1.2 libelle 191 à 193 comme tranches de souffrance) ; (b) L01 développée sans compte 503 alors que L27 = 503 ; (c) D70 lu « 491 + 492 − 493 » alors que D71 à D73 = 491 à 493 moins provisions ; (d) S2A développée sans 6235, 6238, 6239 ; (e) S2C = 6211+6217 en développée alors que S2M = 6217 ; (f) V3G = 7025 en allégée, 70212 en développée ; (g) D1E et D1L : concordance allégée NON TROUVÉE ; (h) allégée F01/A01 contiennent `ex 1567` et `ex 1577` alors que A60/F60 contiennent 1567 et 1577 ; (i) libellés « Autres titres à livrer » répété pour N3H.
3. Formules des totaux du bilan (E90, L90) et composition des SIG non explicites : déduites du modèle.
4. Ratios : « nets des dépôts de garantie » (annexe I) sans liste de comptes ; codes B40/D40/D41/D46 absents de l'édition allégée ; liquidité : annotation manuscrite « ≤ 3 mois » sur le scan ; A2J libellé « dépôts à court terme » alors que A2J = 1281 ; fonction MIN() de la réserve générale ; participations dans SFD/EC à saisir (non comptables).
5. Indicateurs : méthode de « moyenne » (journalière, mensuelle, début/fin) non précisée ; B70 net de provisions vs « brut » ; « A2H++A2J » ; unité de l'état DIMF 2011 (milliers de FCFA dans le texte, FCFA dans le modèle).
6. États décadaires (code D du RCSFD) : aucun état décadaire identifié.
7. Instruction 001-02-2018 : ne contient aucun modèle ; renvoie aux états du RCSFD ; la notification de publication se fait sous 7 jours.
8. Nouvelle loi uniforme microfinance (21/12/2023) : texte uniforme non obtenu ; instructions d'application (états périodiques, plan comptable, ratios prudentiels, capital minimum) NON TROUVÉES ; les textes 2009-2010 sont donc supposés applicables jusqu'à remplacement (non vérifié). L'Instr. 001-03-2025 vise déjà la loi microfinance (preuve d'entrée dans l'ordonnancement).
9. Pays : états spécifiques et structures de supervision de BJ, BF, GW, ML, NE, TG : NON TROUVÉS ; CI : communiqué de presse du 15/03/2024 seulement ; SN : loi lue, arrêtés d'application non lus.
10. CENTIF : modèle de déclaration (arrêté du Ministre) et périodicité des déclarations d'espèces NON TROUVÉS ; seuils d'identification pour les IMF en développé : voir Décision 021/2023.
11. BIC : contenu et format du fichier de données NON LUS ; périodicité mensuelle (le 10) HAUTE ; centrale des risques : aucune instruction applicable aux SFD trouvée (une instruction de 1979 pour les banques).
12. FGDR-UMOA : taux de cotisation, assiette et calendrier NON TROUVÉS ; l'ancien « fonds de garantie des dépôts » du YAML n'a pas de base.
13. Dormants : canevas de la BCEAO NON TROUVÉ ; contenu des Instr. 005 et 007-06-2014 partiellement lu.
14. Avis n°008-04-2020 (COVID-19) et décision 061-03-2011 (refinancement) non lus au fond ; dérogations éventuelles de classification/provisionnement non connues.
15. Pénalités art. 73 reprises de la loi de 2007 ; éventuelle révision par la nouvelle loi (art. 148-161) non lue.

## f) Complément Tavily (2026-10-19)

Tavily (search, extract, crawl) + curl/pdftotext sur PDF officiels. **Texte officiel de la loi uniforme microfinance lu** (https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf). Sigle « loi 2023 » = Décision 019/CM/UMOA du 21/12/2023.

| id | règle | source | URL | confiance | vérif |
|---|---|---|---|---|---|
| UEMOA-REP-T01 | Loi 2023 : 10 titres, 173 articles ; SFD → « institutions de microfinance » (IMF) ; date d'entrée en vigueur absente du texte publié. | Loi 2023 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T02 | Instructions, avis, décisions BCEAO et circulaires CB « demeurent applicables » si non contraires → RCSFD, Instr. 010 et 020 en régime transitoire jusqu'à abrogation. | Loi 2023 art. 171, 173 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T03 | États individuels, combinés ou consolidés, certifiés CAC ; règles fixées par BCEAO/CB ; publication sous 6 mois dont un journal. | Loi 2023 art. 60-63 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T04 | Reporting prudentiel et données périodiques : forme, contenu, délais fixés par la BCEAO ; destinataires MF, BCEAO, CB ; instruction d'application NON TROUVÉE. | Loi 2023 art. 68, 80 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T05 | Supervision CB au-delà du seuil BCEAO (pratique : 2 Md FCFA dépôts ou crédits sur 2 exercices) et confédérations ; autres : Ministère des Finances. | Loi 2023 art. 70 ; Rapport CB 2024 §4.3.1 | https://cb-umoa.org/sites/default/files/2025-08/Rapport%20annuel%202024%20de%20la%20Commission%20Bancaire.pdf | HAUTE / MOYENNE (seuil) | ? |
| UEMOA-REP-T06 | Rapport **annuel** des réclamations à l'autorité de supervision et à la BCEAO ; canevas NON TROUVÉ. | Loi 2023 art. 94 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T07 | Adhésion obligatoire au FGDR-UMOA, contribution annuelle (+ exceptionnelles), informations sur réquisition, données de dépôts indemnisables. | Loi 2023 art. 99-101 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T08 | Contribution SFD 0,29 % des dépôts éligibles ; plafond d'indemnisation 300 000 FCFA par titulaire. | Décision 009/2017/CM/UMOA art. 1-2 | https://www.fgd-umoa.org/wp-content/uploads/2024/10/Decision-du-CM-relative-aux-taux-de-contribution-et-aux-plafonds-d-indemnistation-2-1.pdf | HAUTE | ? |
| UEMOA-REP-T09 | Assiette : dépôts éligibles de l'exercice précédent (vue, terme, livrets, plans, soldes créditeurs, garanties exigibles, en FCFA). | Statuts FGD-UMOA art. 21, 25 | https://www.bceao.int/sites/default/files/2017-11/34statuts_du_fonds_de_garantie_des_depots_dans_l_umoa.pdf | HAUTE | ? |
| UEMOA-REP-T10 | Déclaration annuelle des dépôts au FGDR (formulaires + liste exhaustive) au plus tard le 15 juillet. | Circ. 002/2018/FGDR art. 5/7 (via rapports FGDR) | https://www.fgd-umoa.org/wp-content/uploads/2023/05/rapport-dactivites-2019-fgdr-umoa-vf.pdf | MOYENNE | ? |
| UEMOA-REP-T11 | Plan préventif de redressement (IMF supervisées CB) ; plan de retour à la conformité sur demande ; modalités NON TROUVÉES. | Loi 2023 art. 69, 104, 105 | https://www.cb-umoa.org/sites/default/files/2026-08/Loi%20microfinance%20UMOA.pdf | HAUTE | ? |
| UEMOA-REP-T12 | Mise en conformité 12 mois ; adhésion centrales de crédit et PI-SPI (IMF supervisées CB connectées au plus tard 30/06/2026). | Loi 2023 art. 164-168 ; communiqué BCEAO 02/04/2026 | https://www.bceao.int/fr/communique-presse/connexion-la-plateforme-interoperable-du-systeme-de-paiement-instantane-pi-spi-de | HAUTE / MOYENNE | ? |
| UEMOA-REP-T13 | Capital minimum IMF « à fixer par la BCEAO » : décision NON TROUVÉE. | ANSSFD 03/04/2025 | https://anssfd.bj/wp-content/uploads/2025/04/Etat_preparation_des_IMF_a_la_nouvelle_loi_03_04_2025_ANSSFD.pdf | MOYENNE | ? |
| UEMOA-REP-T14 | Instr. 001-02-2018 : états financiers = bilan, hors-bilan, CR, annexes (conformité RCSFD, méthodes, dérogations, emplois/ressources, crédits en souffrance, engagements par signature, valeurs immobilisées, personnel extérieur) ; notification des références de publication sous 7 jours. | Instr. 001-02-2018 art. 2-6 | https://www.cb-umoa.org/fr/sfd | HAUTE | ? |
| UEMOA-REP-T15 | Instr. 018-12-2010 : rapport annuel (combiné pour réseaux + rapport de chaque membre) ; annexe de 27 tableaux en milliers FCFA, colonnes n-1 / n / variation. | Instr. 018-12-2010 art. 2-6 + annexe | https://www.bceao.int/sites/default/files/2017-11/recueil_texte_sfd.pdf | HAUTE | ? |
| UEMOA-REP-T16 | Indicateurs périodiques : mensuels (art. 44) / trimestriels (autres), sous 30 jours calendaires. | Instr. 020-12-2010 art. 2-4 | https://www.bceao.int/sites/default/files/2017-11/recueil_texte_sfd.pdf | HAUTE | ? |
| UEMOA-REP-T17 | Périodicité des ratios (annexe officielle) : risques M/T ; capitalisation M/M ; prêts dirigeants M/T ; signature unique M/T ; liquidité M / M si collecte sinon T ; opérations autres, réserve, couverture MLT, participations T pour tous ; transmission ≤ 1 mois ; annuels sous 6 mois. | Instr. 010-08-2010 art. 3 + annexe | https://www.bceao.int/sites/default/files/2017-11/recueil_texte_sfd.pdf | HAUTE | ? |
| UEMOA-REP-T18 | Instr. 016-12-2010 : immobilisations + participations (hors frais immobilisés et hors participations SFD/EC) ≤ 100 % des fonds propres ; trimestriel ; numérateur D24, D25, D31, D36, D41, D45, D46, D47, D1E hors SFD/EC. | Instr. 016-12-2010 art. 3-6 + annexe | https://www.bceao.int/sites/default/files/2017-11/recueil_texte_sfd.pdf | HAUTE | ? |
| UEMOA-REP-T19 | Guide des sanctions : confirme T17 ; aucun état décadaire SFD identifié ; pénalité = un jour par jour de dépassement. | Guide des sanctions SFD, BCEAO 11/12/2012 | https://www.bceao.int/sites/default/files/2017-11/guide_des_sanctions_des_sfd-11decembre2012.pdf | MOYENNE | ? |
| UEMOA-REP-T20 | Données de crédit transmises à la BCEAO (pas au BIC) mensuellement au plus tard le 10 ; format dans le contrat BIC (non public). | Instr. 005-05-2015 art. 2-5 | https://www.bceao.int/sites/default/files/2017-12/instruction_no_005-05-2015_fixant_les_modalites_de_transmission_des_informations_sur_le_credit_aux_bic_f%20%282%29.pdf | HAUTE | ? |
| UEMOA-REP-T21 | CENTIF : seuil espèces 15 M FCFA ; modèle de déclaration fixé par chaque Ministre des Finances (BF confirmé, CI formulaire centif.ci) ; autres pays NON TROUVÉ. | Instr. 010-09-2017 ; Loi BF 046-2024/ALT | https://www.bceao.int/sites/default/files/2017-12/instruction_no010-09-2017_fixant_un_montant_seuil_pour_la_declaration_des_transactions_en_especes_a_la_centif_f.pdf | MOYENNE | ? |
| UEMOA-REP-T22 | Avoirs dormants : clôture après 10 ans, transfert BCEAO sous 30 jours, état récapitulatif mensuel électronique (canevas NON TROUVÉ) ; recherche des titulaires à 8 ans (Instr. 005-06-2014). | Instr. 006-06-2014 art. 2-3 | https://www.cb-umoa.org/fr/comptes-dormants | HAUTE | ? |
| UEMOA-REP-T23 | Aucune plateforme BCEAO de dépôt documentée pour les SFD ; SN : masques de saisie DRS-SFD ; Avis 002-03-2026 (déclaration automatisée) vise les EC, couverture IMF non vérifiée. | Instr. 020 art. 4 ; DRS-SFD 2023 | https://drs-sfd.gouv.sn/sitedrs/wp-content/uploads/2024/05/Rapport-dactivite-drs-2023.pdf | MOYENNE / BASSE | ? |
| UEMOA-REP-T24 | Pays : BJ ANSSFD (loi 2025-14) ; BF DSC/SFD (loi 001-2025/ALT) ; CI DRS/SFD (projet de loi 29/04/2026) ; ML CCS/SFD ; NE loi 2014-059 ; SN DRS-SFD (loi 2025-04) ; TG Direction de la Microfinance (loi 2026-005) ; GW NON TROUVÉ. Aucun état national supplémentaire trouvé hors CI. | Textes nationaux | https://cb-umoa.org/fr/liens-utiles | HAUTE / MOYENNE / BASSE | ? |
| UEMOA-REP-T25 | A70 = total (191 + souffrance 192-194 − provisions) ; A71-A73 = ventilation ; pas d'incohérence ; idem B70. | RCSFD développé, annexe 1 | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE | ? |
| UEMOA-REP-T26 | D70 = 491 + 492 + 493 − provisions 4996x/4997x ; « +491+492−493 » imprimé = coquille. | idem | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE | ? |
| UEMOA-REP-T27 | L01 inclut 503 (L27 fonds de crédit) : omission d'impression. | idem + Instr. 016 annexe | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE | ? |
| UEMOA-REP-T28 | S2C = 6211 seul ; S2B = 621 (dont 6217) ; S2A = S2B + S3A + S4A (6211 à 6239). | idem | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE | ? |
| UEMOA-REP-T29 | V3G développée = 70212 ; concordance allégée 7025 suspecte (illisible). | idem | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE / NON TROUVÉ | ? |
| UEMOA-REP-T30 | D1E hors part SFD/EC = 4123 + 4124 + 4125 (4121 EC, 4122 SFD) ; provision 4129 non ventilée. | idem | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | HAUTE / MOYENNE | ? |
| UEMOA-REP-T31 | E90 = A01+B01+C01+D01+E01+E05 ; L90 = F01+G01+H01+K01+L01 (déduit, aucune formule publiée). | idem | https://microfinance.tresor.gouv.ci/micro/wp-content/uploads/2019/11/RCSSFD.pdf | MOYENNE | ? |
| UEMOA-REP-T32 | SIG : aucune composition publiée ; aucun RCSFD révisé après 2009. | cb-umoa.org/fr/sfd | https://www.cb-umoa.org/fr/sfd | MOYENNE | ? |
| UEMOA-REP-T33 | Capitalisation : norme 15 % inchangée en 2025. | Rapport CB 2025 §4.3 | https://www.bceao.int/sites/default/files/2026-08/RAPPORT_ANNUEL_2025_DE_LA_COMMISSION_BANCAIRE.pdf | MOYENNE | ? |

Patches appliqués à `paquet-draft.yml` : A70/B70 (notes), D70, L01 (+503), E90/L90 (notes + contrôle), S2A/S2B/S2C, V3G, D1E_HORS_PART (comptes) et PRU-09/10, PRU-05 (catégories structurées), LOI-001 à 006, RAP-001 (27 tableaux), nouveau UEMOA-REP-EF-ANNEXES, BIC-001, DOR-001, LBC-001, surcharges pays.

### Lacunes restantes après Tavily
1. Instructions d'application 2024-2026 de la loi 2023 (états, plan, ratios, capital minimum, canevas) : introuvables.
2. Date d'entrée en vigueur du texte uniforme ; CI, GW, ML, NE.
3. Circulaire 002/2018/FGDR non lue directement.
4. Canevas BIC, dormants, CENTIF (hors BF/CI), réclamations, plan de redressement.
5. Plateforme de dépôt IMF ; Avis 002-03-2026 non lu.
6. Concordances allégées D1E, D1L, V3G.
7. SIG, E90/L90 : déduits seulement.
8. Édition de RCSSFD.pdf (Trésor CI) non datée vs édition 2009.
9. États nationaux GW, NE.
10. Seuil de supervision CB sous la loi 2023.
