# R1 : branchement du reporting sur les endpoints de collecte (vague 3)

Branches (rien poussé) : `feature/reporting-refonte-branchement` dans `sfd-reporting-service` et `sfd-angular`, depuis `feature/reporting-refonte`.
Tests (baseline → après, 0 échec) : reporting 421 → 471 (après revue opus) ; Angular BUILD OK (25 warnings, = baseline), unit reporting 23 → 25, `check-i18n-sync` vert.
Runtime de bout en bout (monolithe reconstruit, navigateur) : NON fait, réservé au Lot 6.

## Mécanique ajoutée au moteur
- `ErreurFormule.Type.DONNEE_NON_RENSEIGNEE` : saisie métier manquante dans le module source (le message du module dit laquelle). `DONNEE_INDISPONIBLE` garde la panne, désormais avec la cause (`motifAnnexe`).
- `JeuDonnees` : `motifAnnexe(cle)`, `annexeNonRenseignee(cle)`, `instantane(cle)`, `annexe(cle, ligneDuRapport)` (valeur d'une ligne du même rapport, pour le seuil FPN). Toutes par défaut, donc `ImportProvider` inchangé.
- `ResultatLigne.aLaDateDuJour`. `RapportLigne` : colonnes `type_erreur`, `instantane` (Hibernate update, nullables). `RapportLigneDto` : `typeErreur`, `instantane`.
- Contrat v1.2 étendu : `typeErreur` nouvelle valeur `DONNEE_NON_RENSEIGNEE` ; champs `typeErreur`, `instantane` sur les lignes d'édition.
- Config : `app.services.transfert-url` (env `TRANSFERT_SERVICE_URL`, défaut `http://localhost:4605/api/transfert`), bean `transfertWebClient`. Nouveau `CaisseReportingConnector` (bean `caisseWebClient` existant), `TransfertReportingConnector`. `reporting.collecte.classes-hors-bilan-risque.<ZONE>` (CEMAC-COBAC : 90,92,942, source : note de CEMAC-REP-010).
- Connecteur épargne : `encours-bceao` reçoit aussi `dateDebut`/`dateFin` (le module lit ces clés ; les dates étaient ignorées).

## Table clé → source → champ (clé = `RAPPORT.LIGNE`)
| Clé | Source | Calcul / champ | Instantané |
|---|---|---|---|
| CEMAC-REP-019.CS02 | C1 `GET /reporting/provisions-cobac` | `totalProvisionRequise` (remplace `/rapports/provisions`) | oui |
| CEMAC-REP-006.JT18, 007.KL19, 009.VL08 | idem | max(0, `totalProvisionRequise` − `provisionsConstituees`) | oui |
| CEMAC-REP-010.DA02, 011.DB02 | C1 `risques/top` (n=500) + T1 `hors-bilan/beneficiaires` (classes de la config de zone) + C1 `encours/clients` pour un client qui n'a que du hors-bilan | max sur les clients de encours + hors-bilan | oui |
| CEMAC-REP-010.DA04, 011.DB04 | idem + K1 `groupes-risque` + ligne DA01/DB01 (@FPN) | somme des risques des bénéficiaires > 10 % FPN (strict) ; groupe = somme de ses membres, groupes à membre commun fusionnés, client sans groupe = bénéficiaire ; erreur si le classement est tronqué (500) au-dessus du seuil | oui |
| DIMF-2012.I12_MAX | C1 `risques/top` n=1 | `clients[0].encours`, sans hors-bilan | oui |
| DIMF-2013.I13_TOTAL | K1 `inities` + C1 `encours/clients` | `encoursCumule` de l'union dédoublonnée des 4 catégories | oui |
| RDC-REP-029.RISQUE_CLIENT_IMF_MONTANT | C1 top | plus gros risque, tous types de client | oui |
| RDC-REP-029.RISQUE_MEMBRE_COOPEC_MONTANT | C1 top + client `GET /clients/numero/{n}` | plus gros risque d'un client de type MEMBRE, PARTICULIER ou PROFESSIONNEL | oui |
| RDC-REP-030.CRD_EN_RETARD | C1 `retards/tranches` | `crdTotalEnRetard` | oui |
| RDC-REP-030.EMPR_PAR_AGENT | C1 `emprunteurs-par-gestionnaire` | Σ `emprunteursActifs` des gestionnaires rattachés / leur nombre | oui |
| CEMAC-REP-020.ST08A/ST08B (ex ST08) | E1 `taux-depots` | max / min de `tauxMax` / `tauxMin` du DAT et de l'épargne qui ont des données | non (période) |
| CEMAC-REP-020.ST09A/ST09B (ex ST09) | C1 `taux` | **TEG** max / min (décision D3), dossiers sans TEG exclus et comptés dans le message | non (période) |
| CEMAC-REP-020.ST05N | E1 `encours-bceao` | `nombreComptesVue` + `Terme` + `Epargne` | oui |
| CEMAC-REP-020.ST07A..D (ex ST07, ST07 = somme) | T1 `tresorerie/contreparties` | solde BANQUE / EMF / FAITIERE ; `caisses` | non (date d'arrêté) |
| CEMAC-REP-018.PA02M + PA02 = PA02M/@FPN*100 | T1 `participations` | max `solde` des auxiliaires PARTICIPATION | non |
| DIMF-2011.I11_AUTRES_OPS_CALC ; I11_AUTRES_OPS = CALC + SAISIE | A1 transfert `operations` + caisse `operations-change` | `totalEmis.montantEnvoi` + `totalPayes.montantEnvoi` + Σ `contreValeurLocale` | non (période) |
| DIMF-2011.I11_AUTRES_OPS_SAISIE | SAISIE | assurance et mobile money (D2) | — |
Clés déjà branchées par S10 (CS01, ST02H/F, ST03-ST06B) : inchangées, CS01, ST02H/F, ST05, ST06A/B signalées instantanées.

## Erreurs : non renseignée ou indisponible
- DONNEE_NON_RENSEIGNEE : hors-bilan sans auxiliaire ou auxiliaire sans client (DA02, DA04, DB02, DB04) ; aucun initié renseigné (I13) ; aucun gestionnaire rattaché (EMPR_PAR_AGENT) ; trésorerie non ventilable (NON_RENSEIGNE / NON_VENTILE ≠ 0) ou rôle CAISSE absent ; participations sans entité émettrice ; type de client absent (RDC membre).
- DONNEE_INDISPONIBLE (avec la cause) : module en panne ; RH injoignable côté K1 (`personnelRhIndisponible`) ; FPN nul ou en erreur (dépendance) ; aucun dépôt ou aucun TEG sur la période ; nombre de comptes absent (module sans E1).

## Recomptage (`PaquetsCompletudeTest`, mesure synthétique, annexes = 1, saisies = 0)
| Zone | Avant (S10) | Après |
|---|---|---|
| UEMOA allégée | 497/603 (saisies à 0) | 499/605 avec annexes ; 489/605 sans (I12, I13 passent de SAISIE à CROSS_SERVICE : indisponibles sans module) ; développée 497/605 |
| CEMAC | 414/473 ; 455/473 avec annexes | 405/480 sans ; **462/480** avec annexes (+7 lignes : PA02M, ST07A..D, ST08A/B, ST09A/B moins ST07/ST08/ST09 recomposées) ; 18 restantes : 10 FORMULE_NON_DEFINIE, 8 dépendances |
| RDC | 85/100 | 85/100 avec annexes ; 78/100 sans |
| OHADA | 328/452 | 328/452 |
Planchers de test relevés : UEMOA ≥ 499, CEMAC ≥ 462, RDC ≥ 85 (avec annexes).
Lignes encore en SAISIE après R1 : seulement `DIMF-2011.I11_AUTRES_OPS_SAISIE` (D2). STANDALONE : le modèle Excel liste toutes les clés CROSS_SERVICE du paquet (`CrossServiceCles`), donc les nouvelles clés y sont ; `BranchementPaquetsTest` vérifie que chaque clé CROSS_SERVICE d'UEMOA, CEMAC, RDC est branchée.

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| « membre » vs « client » (RDC) : quel type de client | membre = MEMBRE, PARTICULIER, PROFESSIONNEL ; client = tous types ; la règle n'est pas dans le brief ni le paquet | Instr. BCC 002 art. 29 ; TypeClient du service client |
| Hors-bilan dans le plus gros risque | CEMAC seulement (classes 90, 92, 942 en configuration) ; UEMOA et RDC : crédits seuls (DIMF 2012 « encours de crédits », BCC « sous-journal crédit ») ; contredit la formulation du brief (hors-bilan partout) : à trancher | notes de CEMAC-REP-010/011 ; RCSFD 4.9 |
| Titres et engagements sur correspondants dans DA02/DB02 | non inclus (la note du paquet les cite) | CEMAC-REP-010 |
| Classes hors-bilan par norme | `reporting.collecte.classes-hors-bilan-risque.<ZONE>.<NORME>` (norme = 1er mot du plan : PCEMF, RCSFD-UMOA, PCCI ; SYSCOHADA/SYCEBNL en OHADA) ; norme absente = erreur explicite, jamais les comptes d'une autre norme ; 90,92,942 seulement pour PCEMF | note de CEMAC-REP-010 |
| Classes 90, 92, 942 sur la norme CEMAC | non vérifié contre le plan CEMAC : T1 renvoie 400 si le plan n'a pas de comptes HORS_BILAN avec ce préfixe (la ligne sort alors en indisponible) ; S10 n'a ajouté la classe 9 qu'à UEMOA | T1 |
| DA02 : plus gros risque d'un client, pas d'un groupe | client seul ; DA04 utilise les groupes | brief |
| Top 500 de C1 | si 500 clients sont retournés et que le plus petit dépasse le seuil, DA04 sort en erreur plutôt que sous-évalué | choix technique |
| ST09 : TEG ou nominal | TEG (D3), dossiers décaissés dans la période, hors dossiers sans TEG | brief ; REPORTING_PLAN_COLLECTE D3 |
| ST08 : DAT dérogatoires | taux contractuel du DAT (`tauxAnnuel`) | handoff E1 |
| ST07 : contrepartie AUTRE | exclue du total ST07 ; un type sans compte vaut 0 | libellé de la ligne |
| EMPR_PAR_AGENT | emprunteurs des gestionnaires rattachés / nombre de gestionnaires rattachés ; non rattachés exclus ; un client suivi par deux gestionnaires compte deux fois | handoff C1 |
| Autres opérations (I11) | montant d'envoi des transferts émis + entrants (TRF_IN) payés (sans frais ; payés des autres types exclus pour éviter le double compte : choix à valider) + contre-valeur locale du change ; assurance et mobile money saisis à part | brief, handoff A1 |
| Provisions : date de déclassement estimée (reprise) | `nbClientsDateEstimee` non remonté à l'écran | handoff C1 |
| Provisions constituées (JT18…) | `provisionsConstituees` de C1 = provisions des dossiers retenus, pas le compte 39 du grand livre | handoff C1 |
| PLAFOND_CLIENT (package CEMAC `normesComplementaires`) | non calculé : pas une ligne du moteur ; le seuil de 10 % FPN de DA04/DB04 est le même mécanisme | S10 |
| Valeurs instantanées | une ligne dérivée (ratio) d'une ligne instantanée n'est pas marquée ; l'alerte est portée par les lignes sources et le bandeau d'édition | choix technique |

## Fichiers hors périmètre touchés / à noter
- `application.yml` du reporting (config) ; `WebClientConfig`. Aucun autre service.
- Angular : écran d'édition seulement (`edition-rapport.component.*`, modèle, util, i18n fr/en/ln ; ln = français, convention S5).
- Variable d'environnement à prévoir au déploiement : `TRANSFERT_SERVICE_URL`.

## Non vérifié
- Aucun appel HTTP réel aux endpoints C1/E1/A1/T1/K1 (connecteurs testés en mocks, DTO miroirs écrits d'après les handoffs : à confirmer au Lot 6 sur Jackson réel, notamment les dates de T1 qui sortent en tableaux et que les DTO miroirs ignorent).
- Écran d'édition dans le navigateur (badge et bandeau) : build, unit et i18n seulement.

## Corrections de la revue opus R1
1. Monolithe (`sfd-erp-monolith`, branche `feature/reporting-refonte-branchement` depuis `feature/reporting-refonte`) : `app.services.transfert-url` et bloc `reporting.collecte` dans `application.yml` ; `@Value` de `transfert-url` avec défaut. Vérifié : compilation du monolithe seulement (le test de contexte demande une base : non lancé ; le monolithe compile contre le jar reporting déjà installé, pas contre ce commit).
2. `POST /reporting/encours/clients` : `codeAgence` en paramètre d'URL (test WireMock sur l'URI et sur le corps).
3. Période N-1 (`PeriodeCalcul.precedente`) : les clés instantanées renvoient vide avec le motif « Pas d'historique », sans appel aux modules.
4. Troncature DA04 : seuil comparé au plus petit encours du classement C1 ; RDC membre : classement tronqué sans client du type = erreur, pas 0.
5. Classes hors-bilan par zone et norme (voir points à valider).
6. I11 : payés = TRF_IN seulement (DTO transfert : `emis[]`, `payes[]` par type).
7. Ligne corrigée à la main : `typeErreur` et `instantane` remis à zéro (saisie manuelle et fusion) ; Angular : `instantane && !modifieManuellement`.
8. Appels aux modules mémorisés en succès comme en échec (un module en panne n'est appelé qu'une fois par édition) ; timeouts des nouveaux appels à 15 s.
