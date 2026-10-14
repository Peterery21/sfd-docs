# RDC / BCC — Table rôle -> compte PCCI (pour le produit EDIP)

Zone : RDC (BCC) · Norme : PCCI · Rédigé le 2026-10-13 · Rédacteur : agent de recherche réglementaire (Claude)

Règles : (1) comptes et libellés copiés tels quels du plan PCCI (ouvrage Nzoimbengene, Éd. BNL PACAI, MOYENNE — annexe officielle de l'Instruction 006 non trouvée) ; (2) aucun compte RCSFD, PCEMF ou GCEC ; (3) « NON DÉFINI PAR LE TEXTE » = ni texte BCC ni plan ne nomme un compte pour ce rôle ; (4) « AMBIGU » = le plan offre plusieurs candidats sans règle de choix ; (5) le produit résout les rôles par paramétrage (principe 1 du référentiel interne) : le numéro ci-dessous est une valeur par défaut de seed pour la norme PCCI, jamais une constante de code ; (6) l'ouverture d'un sous-compte hors plan exige l'autorisation de la BCC (RDC-CPT-003).

| Rôle | Numéro PCCI | Libellé exact (PCCI) | Id(s) de règle | Statut |
|---|---|---|---|---|
| CAISSE | 570 | Monnaies nationale et étrangère | RDC-CPT-008, RDC-CPT-009 | plan ; caisse multi-devises : le plan n'a qu'un sous-compte, suivi par devise exigé ailleurs |
| BANQUE | 5601 (sous 560 « Comptes NOSTRI disponible ») | Banque et autres intermédiaires financiers | RDC-CPT-008 | plan |
| MOBILE_MONEY | NON DÉFINI PAR LE TEXTE | — (aucun compte « monnaie électronique / opérateur mobile » dans le plan ; 4605/4616 « Messageries financières » existent en classe 4, rapprochement non prescrit) | RDC-CPT-008 | silence |
| VIREMENT_INTERNE (caisse/banque) | 590 / 591 / 592 | Virements caisse à caisse / caisse à banque / banque à banque | RDC-CPT-008 | plan |
| COMPTE_VUE | 331 | Comptes ordinaires | RDC-EPA-001, RDC-EPA-010 | plan ; classé « dépôt à vue » par Instr. 002 art. 18 |
| EPARGNE_LIVRET | 332 | Comptes sur livrets | RDC-EPA-001, RDC-EPA-010 | plan ; classé « dépôt à vue » par Instr. 002 art. 18 |
| EPARGNE (générique) | 330 | Epargnes | RDC-EPA-001, RDC-EPA-010 | plan |
| DEPOT_A_TERME | 340 | Dépôts à terme | RDC-EPA-002 | plan |
| DEPOT_GARANTIE | 334 | Epargnes obligatoires | RDC-CRE-022, RDC-EPA-017 | plan + équivalence « épargne obligatoire = dépôt garantie » (Instr. 38 art. 9) ; schéma D/C non défini |
| AUTRES_DEPOTS_MEMBRES (tontine, planifiée) | NON DÉFINI PAR LE TEXTE | — (candidats de plan non prescrits : 356 « Autres comptes d'épargne à régime spécial », 362 « Autres sommes dues à la clientèle ») | RDC-EPA (tontine) | silence |
| EPARGNE_REGIME_SPECIAL | 352 / 353 / 354 / 356 | Epargne - logement / Epargne - retraite / Epargne - scolaire / Autres comptes d'épargne à régime spécial | RDC-EPA-003 | plan |
| DETTE_RATTACHEE_DEPOTS | 341 | Dettes rattachées (intérêts sur dépôts) | RDC-EPA-002 | plan |
| CREDIT_COURT_TERME | 32 (320 à 326) | Crédits à court terme (ex. 320 Crédits de trésorerie, 322 Crédits à la consommation, 324 Crédits des activités génératrices des revenus (AGR)) | RDC-CRE-014 | plan ; seuil de durée court/moyen/long : NON TROUVÉ |
| CREDIT_MOYEN_TERME | 31 (310 à 316) | Crédits à moyen terme (313 Crédits rééchelonnés ou moratoires) | RDC-CRE-014 | plan |
| CREDIT_LONG_TERME | 30 (300 à 306) | Crédits à long terme | RDC-CRE-014 | plan |
| CREANCE_SOUFFRANCE | 390 (3900 à 3904) | Crédits en retard (De 1 à 30 jours ... De 181 jours et plus) ; 391 Créances consolidées (immobilisées) | RDC-CRE-013, RDC-CRE-014, RDC-CRE-005 à RDC-CRE-008 | plan ; tranches alignées sur Instr. 003 art. 12 |
| PROVISION_CREANCE | 380 (3800 à 3804) | Provisions sur créances en retard | RDC-CRE-010, RDC-CRE-013 | taux imposés par texte (HAUTE), compte = plan (MOYENNE) |
| DOTATION_PROVISION | AMBIGU (6900 / 6902 ...) | 6902 « Dotations aux provisions pour dépréciation des autres comptes de la clientèle » est le plus proche du crédit, mais le libellé dit « autres comptes » | RDC-CPT-015 | silence : à trancher avec l'annexe officielle |
| REPRISE_PROVISION | 7902 | Reprises sur prov. pour dépr. des comptes de la clientèle | RDC-CPT-015 | plan |
| PERTE_CREANCE | 6910 / 6911 | Pertes sur crédits irrécouvrables couvertes par des provisions / non couvert par de provisions | RDC-CRE-008, RDC-CPT-015 | plan ; passation en perte au 31/12 imposée |
| PRODUIT_INTERET_CREDIT | 712 / 711 / 710 | Intérêts sur crédits à court terme / à moyen terme / à long terme (7120 trésorerie, 7121 campagne, 7122 consommation, 7124 AGR) | RDC-CPT-012, RDC-CRE-018 | plan |
| PRODUIT_COMMISSION | 715 (7152 court terme) ; 720 ; 727 | Commissions sur opérations avec la clientèle ou les membres ; Commissions de tenue des comptes ; Autres Commissions | RDC-CPT-012, RDC-CPT-013 | plan ; frais de dossier : compte NON DÉFINI PAR LE TEXTE |
| PRODUIT_PENALITE | NON DÉFINI PAR LE TEXTE | — (717 « Intérêts et commission sur crédits en retard » = rapprochement de libellé non prescrit) | RDC-CRE-009, RDC-CRE-017 | silence |
| CHARGE_INTERET_MEMBRES | 610 / 611 / 612 / 613 | Intérêts sur épargne et comptes ordinaires / sur comptes sur livrets / sur dépôts à terme / sur dépôts à régime spécial | RDC-EPA-005 | plan |
| CAPITAL_PARTS_VERSE | 103 (1030, 1031, 1032) | Parts sociales (« personnes physiques effectives », « groupements solidaires effectifs », « personnes morales effectives ») ; 1000 Capital souscrit et libéré | RDC-PSO-012 | plan ; parts non libérées : aucun compte (parts intégralement libérées exigées, RDC-PSO-002) |
| DROIT_ADHESION | NON DÉFINI PAR LE TEXTE | — | RDC-PSO-004 | silence |
| RESERVE_GENERALE | AMBIGU (1110 « Réserve légale » candidat) | Réserve légale | RDC-PSO-008 | la loi dit « réserve générale », le plan dit « Réserve légale » : correspondance non écrite |
| RISTOURNE | NON DÉFINI PAR LE TEXTE | — | RDC-PSO-007 | silence |
| RESULTAT_EXERCICE | 87 (bilan : 130 / 131) | Résultat net de l'exercice ; Bénéfice net ou excédent ; Perte nette ou déficit | RDC-CLO-010 | plan |
| GAIN_CHANGE | 723 | Profits de change | RDC-CPT-014 | plan, existence confirmée par Instr. 002 art. 39 |
| PERTE_CHANGE | 621 | Pertes de change | RDC-CPT-014 | plan seulement |
| POSITION_CHANGE | 472 / 473 | Position de change / Contre-valeur position de change | RDC-CPT-014, RDC-PRU-012 | plan |
| ATTENTE_ACTIF | 475 (actif ou passif) ; 371 | Comptes d'attente à régulariser (Actif ou Passif) ; Suspens débiteurs | RDC-CPT-010 | plan |
| ATTENTE_PASSIF | 475 (actif ou passif) ; 372 | Comptes d'attente à régulariser (Actif ou Passif) ; Suspens créditeurs | RDC-CPT-010 | plan |
| ECART_CAISSE | 671 (manquant) ; 7790 (excédent) | Déficits de caisse non récupérés ; Excédents de caisse | RDC-CPT-013 | plan |
| LIAISON_AGENCES | 451 | Comptes de liaison inter agences | RDC-CPT-010 | plan |
