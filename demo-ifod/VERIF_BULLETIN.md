# Vérification chaîne BULLETIN — SMF IFOD SA (2026-10-06)

Méthode : navigateur intégré (admin@admin.com) + API + PDF réels. Aucun SQL. Rien commité.

## Synthèse OK / KO
| # | Point | Résultat |
|---|---|---|
| 1 | Liste / détail bulletins, lignes, cotisations CNSS 5/5, AF 6,5, RP 1,5, INPP 3, ONEM 0,5, IPR + réduction charges | OK après correctifs UI (voir D1-D6) |
| 1b | Recalcul à la main de 3 bulletins | OK (voir ci-dessous) |
| 2 | Édition avant validation (prime, retenue, avance, recalcul) | KO au départ (PUT 400 systématique, éléments ignorés) -> corrigé, OK |
| 2b | Droits après validation | OK en code + tests (PUT refusé VALIDE/COMPTABILISE/PAYE/ANNULE, bouton Modifier masqué) ; non rejoué au navigateur pour garder octobre 2026 ouvert |
| 3 | PDF bulletin | KO au départ (pas de devise, nombres sans séparateur, agence « — », statuts bruts) -> corrigé, OK |
| 4 | Envoi en lot (simulation), statut, journal | OK : 24 bulletins sept. SIMULE ; journal désormais visible (onglet Historique) |
| 5 | Comptabilisation + paiement | OK : 4 pièces PA « Paie septembre » équilibrées par agence (débit 67 543 205 = brut 57 977 000 + charges patronales 9 566 205), IPR crédité 431000 = 8 769 023 = somme bulletins ; virements : 421000/560100 (épargne interne), 560400 (mobile), 331000 (banque) ; mouvement VIREMENT_SALAIRE visible sur DAV-2026-000002 |
| 6 | Rapports REP_PAIE_001/006/007/009/011/012/013 + export virement | OK après correctifs (007 sans pension, 011 « 2 026 ») ; export CSV virements OK |
| 7 | Tableau de bord paie | KO au départ (sommait toutes les périodes, évolution 2,5 % en dur, graphes factices) -> corrigé, OK |
Console/réseau : aucune erreur 4xx/5xx sur les écrans paie sauf `/api/chat/me` 500 (chat-service arrêté, hors périmètre) et sondes `actuator/health` des modules non démarrés.

## Recalcul manuel (IPR LF 19/005 : barème annuel x12, réduction 2 % par enfant)
- IFOD-0013 (6 enfants, base 650 000) : brut 650 000+13 000 (2 % anc.)+90 000+60 000 = 813 000 ; CNSS 5 % = 40 650 ; net imposable = 663 000-40 650 = 622 350 ; annuel 7 468 200 -> 58 320+(5 524 200 x 15 %)=886 950 ; /12 = 73 912,5 x (1-12 %) = 65 043 ; net 707 307 ; charges patronales 16,5 % = 134 145 ; coût 947 145. OK.
- IFOD-0022 (0 enfant, base 500 000) : brut 640 000 ; CNSS 32 000 ; NI 468 000 ; IPR 609 120/12 = 50 760 ; net 557 240. OK.
- IFOD-0001 (5 enfants, base 8 000 000) : brut 10 060 000 ; CNSS 503 000 ; NI 7 657 000 ; annuel 91 884 000 -> 28 960 320/12 = 2 413 360 x 90 % = 2 172 024 ; net 7 384 976. OK.
- Avec prime de risque 50 000 sur IFOD-0013 (édition) : brut 863 000, CNSS 43 150, NI 669 850, IPR 71 313, net 748 537 ; puis avance 20 000 : net 728 537. OK (éléments annulés ensuite, octobre remis à 813 000 / 707 307).

## Défauts corrigés (code + test)
sfd-angular
- D1 `bulletin-paie-detail` : total « Retenues » faux (65 043 au lieu de 105 693 : cotisation salariale non comptée) et lignes à 0 (CNSS_AF, RP, INPP, ONEM côté salarié) affichées en retenues/cotisations -> total corrigé, lignes à 0 masquées.
- D2 détail : boutons de workflow incohérents avec le moteur (VALIDE -> COMPTABILISE -> PAYE) : « Comptabiliser » proposé sur un bulletin déjà PAYE, « Payer » sur VALIDE (refusé par le serveur), « Modifier » absent sur CALCULE, « Annuler » proposé sur COMPTABILISE. Aligné sur `TransitionsBulletin`.
- D3 détail : onglet Historique « Fonctionnalité à venir » -> jalons calcul/validation/paiement/annulation + journal d'envoi réel.
- D4 détail : libellé « IRPP » en dur (IPR en RDC, sigle lu sur la rubrique), « 30 jours » en dur (jours de la période), ligne « Éléments non imposables » ajoutée (brut - cotisations ≠ net imposable sans elle), statut COMPTABILISE avec badge.
- D5 `bulletin-paie-edition` : l'édition n'offrait que mode/référence -> carte « Éléments variables du mois » (ajout prime/retenue/avance, annulation, bouton Recalculer, lien personnalisations), recalcul immédiat.
- D6 génération : encadré d'information en dur « CNSS 4 % + 16 % / quotient familial / plafonné » (faux RDC) -> texte neutre.
- D7 dashboard paie : données factices du donut (40/25/20/15) retirées ; graphes et IPR alimentés par l'API ; variation d'effectif absolue.
sfd-paie-service
- B1 `PUT /bulletins/{id}` renvoyait 400 pour tout appel de l'écran d'édition (`@Valid` exigeait employeId/periodePaieId/salaireBase). Test `BulletinPaieControllerIT.update_partialPayload_returns200`.
- B2 `ElementVariablePaieService.create` : élément créé avec `actif=false` (boolean primitif absent du JSON) donc ignoré silencieusement par le calcul (écran Éléments variables inclus). Test `elementCreateSansActifReste_actif`.
- B3 `update` : le recalcul réinitialisait le mode de paiement saisi (ESPECES depuis la fiche employé) -> saisie réappliquée. Test ajouté dans `BulletinPaieServiceTest.update_recalcule`.
- B4 PDF (`BulletinPaieDocumentBuilder`, `BulletinPaieServiceImpl`) : devise (CDF) en sous-titre + mention légale (n° bulletin, conservation, devise, profil), séparateur de milliers insécable fr (l'U+202F n'était pas rendu : « 650000,00 »), agence = libellé sinon code, statut/mode de paiement en français, date de paiement, décimales fr (congés 1,67 ; parts). Tests `BulletinPaieDocumentBuilderTest` (+2).
- B5 `RhPaieDonneesClient` : RH injoignable/500 -> bulletin calculé en silence SANS indemnités logement/transport ni heures sup (octobre 2026 a été généré ainsi : brut 663 000 au lieu de 813 000). Contrat, grille et heures sup sont maintenant lus en mode strict (calcul interrompu `paie.rh.indisponible`). Tests `RhPaieDonneesClientStrictTest`.
- B6 `PortailBulletinController` : n'expose plus `contexteCalcul` ni `detailCalcul` à l'employé. Test ajouté.
- B7 `DashboardController` : sommait TOUS les bulletins de toutes les périodes (masse 746 M au lieu de 58,8 M), `evolutionMasseSalariale` codée 2,5, période courante = première ligne. Maintenant : période ouverte, hors annulés, évolution vs période précédente, répartition par département, évolution 12 mois, IPR, charges salariales. Tests `DashboardControllerIT`.
- B8 rapport REP-PAIE-007 : la pension CNSS (typée RETRAITE) manquait du récapitulatif CNSS ; incluse (même organisme) ; titre « CNSS / CAFAT » (CAFAT = Nouvelle-Calédonie) -> « Récapitulatif CNSS ». Rapport 011 : année « 2 026 » -> « 2026 ». Test `repPaie007_includesPensionOfSameOrganisme`.
- B9 nouvel endpoint `GET /bulletins/{id}/envois` (journal d'envoi, simulation comprise).

## Tests
- `sfd-paie-service` : suite complète 0 échec, 0 erreur (copie isolée du module, `mvn -o test`, 464 tests ; l'exécution dans le répertoire du service tue le RH/paie en cours d'exécution).
- `sfd-angular` : `npx ngc --noEmit -p tsconfig.app.json` EXIT 0.
- Navigateur : détail (Retenues 105 693, Cotisations, Historique), édition (prime puis avance, recalcul, mode), dashboard.
- Non rejoué au navigateur : validation/comptabilisation/paiement d'octobre 2026 (laissé ouvert pour la démo), lot d'envoi (spec 79 déjà passant), version anglaise.

## Reste ouvert (voir DEFECTS_LOG.md)
- `sfd-report-api` `RapportContext.getPeriodeFormatee` : période « Du 2026-09-01 au 2026-09-30 » (ISO) sur tous les PDF de rapport ; nom de fichier avec double point (`..pdf`). Lib partagée, non modifiée ici.
- Bulletin PDF sur 2 pages (mentions fiscales + mention légale passent en page 2 dès qu'il y a un solde de congés).
- PDF via le portail : solde congés indisponible (401 RH avec jeton portail).
- IPR non arrondi (ex. 1 443 148,8 ; total 8 769 022,85) : à décider (arrondi au franc ?).
- Bulletins déjà générés avant correctifs (jan.-sept. 2026) n'ont pas le département renseigné (RH n'était pas servi au calcul) ; se corrigent au recalcul.
- Liste des bulletins : KPI « Validés / Payés 0 / 206 » compte uniquement VALIDE (pas PAYE).
- Génération : message « Aucune période ouverte disponible » affiché brièvement avant chargement.
- Environnement : `mvn test`/`compile` dans le répertoire d'un service lancé via `spring-boot:run` casse le service (NoClassDefFoundError) ; Docker Desktop s'est arrêté pendant la session (SQL Server/RabbitMQ relancés).
