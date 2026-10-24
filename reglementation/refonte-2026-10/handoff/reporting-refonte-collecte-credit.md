# Handoff C1 : collecte crédit (reporting réglementaire)

Branches : `feature/reporting-refonte-collecte-credit` dans `sfd-credit-service` (71905d9) et `sfd-angular` (3386ac46). Rien de poussé.
Base : `/api/credit/reporting/...`. Tous les endpoints : `codeAgence` facultatif (sans lui, consolidé), `dateArrete` facultatif (aujourd'hui). `aLaDateDuJour: true` = instantané du jour (la base ne garde pas l'historique des encours). Aucun `@PreAuthorize` (le contrôleur existant n'en porte pas ; l'accès est géré en amont comme `/reporting/bceao/*`).
Statuts d'encours retenus : DECAISSE, EN_COURS, EN_RETARD, IMMOBILISE, DOUTEUX, CONTENTIEUX, RESTRUCTURE. Montants = `capitalRestantDu`.

## DTO (record `ReportingCreditDtos`, `reporting/dto/ReportingCreditDtos.java`)
1. `GET /reporting/risques/top?n=10` → `{aLaDateDuJour, dateArrete, codeAgence, n, encoursTotal, clients:[{codeClient, encours, nbDossiers}]}` trié par encours décroissant (n borné à 500). Pas de type de client : R1 le demande au service client.
2. `POST /reporting/encours/clients` body `{codesClient:[...]}` → `{aLaDateDuJour, dateArrete, codeAgence, encoursCumule, clients:[{codeClient, encours, nbDossiers, dossiers:[{numeroDossier, statut, classeRisque, encours}]}], codesSansEncours:[...]}`.
3. `GET /reporting/taux?periodeDebut=&periodeFin=` → `{aLaDateDuJour(true), periodeDebut, periodeFin, codeAgence, tauxNominal:{min,max,moyennePonderee,nbDossiers}, teg:{min,max,moyennePonderee,nbDossiers}, nbSansTeg}`. Dossiers retenus : `dateDecaissement` dans la période. Pondération : montant accordé. Taux nominal = taux d'origine (`tauxInteretAnnuelInitial`, sinon `tauxInteretAnnuel`). Période par défaut : 1er du mois à aujourd'hui.
4. `GET /reporting/retards/tranches` → `{aLaDateDuJour, dateArrete, codeAgence, tranches:[{tranche:"1-30"|"31-90"|"91-180"|"181+", joursMin, joursMax(null pour 181+), crd, nbDossiers}], crdTotalEnRetard, nbDossiersTotalEnRetard}`.
5. `GET /reporting/emprunteurs-par-gestionnaire` → `{aLaDateDuJour, dateArrete, codeAgence, gestionnaires:[{gestionnaireCreditId, code, nom, emprunteursActifs, encours, nbDossiers}], nonRattache:{code:"NON_RATTACHE",...}|null, agentsNonRapproches:[{agentCredit, nbDossiers}]}`.
6. `GET /reporting/provisions-cobac?dateArrete=` → `{aLaDateDuJour, dateArrete, codeAgence, reglement, totalEncoursDouteux, totalPartG1G2, totalPartG3G5, totalPartNonCouverte, totalProvisionRequise, provisionsConstituees, provisionsComplementaires, nbClientsDateEstimee, clients:[{codeClient, encours, partG1G2, partG3G5, partNonCouverte, anneeDeclassement, tauxG3G5, provisionRequise, dateDeclassementEstimee}]}`. `provisionsConstituees` = somme de `DossierCredit.provisionConstituee` des encours (même source que `provisionsConstituees` de `POST /reporting/bceao/encours`). `provisionsComplementaires` = max(0, requis − constituées).
   Calcul pur et testé : `reporting/calcul/ProvisionCobacCalculator` (7 tests chiffrés : 3 ans G3-G5 = 75 %, sans garantie = 100 %, couverture partielle, plafonnement, contagion, 4 ans = 100 %, date absente).

## Modèle et reprise (pas de Liquibase dans ce service : schéma Hibernate `ddl-auto: update`)
Nouvelles colonnes : `dossier_credit.teg`, `taux_interet_annuel_initial`, `gestionnaire_credit_id`, `date_declassement_douteux` ; `produit_garantie.categorie_cobac` (nullable, null lu NON_ELIGIBLE). Pas de DDL manuel nécessaire.
Reprise de données au démarrage, idempotente : `ReportingCreditBackfill` (gestionnaires rapprochés sur `code` insensible à la casse ; taux initial = taux courant ; date de déclassement des dossiers déjà douteux = première entrée DOUTEUX/CONTENTIEUX de `historique_statut_credit`, sinon date du jour, comptée dans `nbClientsDateEstimee`).
- TEG : `TaegActuariel.calculer` (extrait de `SimulationServiceImpl`, qui l'appelle encore) ; enregistré dans `DossierCreditServiceImpl.enregistrerTegEtTauxInitial` quand l'échéancier est généré (décaissement complet), figé ensuite ; remis à null si l'annulation d'une tranche supprime l'échéancier. Net reçu = montant accordé − frais/assurance prélevés ; flux = capital+intérêts+assurance+frais de chaque échéance.
- Taux d'origine : posé au décaissement, et avant l'écrasement par `RestructurationServiceImpl`. Un dossier de consolidation reçoit son taux comme taux initial et n'a pas de TEG (comptés dans `nbSansTeg`).
- Gestionnaire : `agentCredit` conservé ; `gestionnaireCreditId` posé à la création et aux deux mises à jour de dossier.
- Date de déclassement : posée par `ClassificationService` au premier passage DOUTEUX/CONTENTIEUX, jamais écrasée, remise à null au retour EN_COURS/EN_RETARD.
- Angular : champ « Catégorie COBAC » dans la modale de garantie du produit (`produit-garanties-section`), colonne dans le tableau, i18n fr/en/ln (`CREDIT.PRODUIT_GARANTIE.*COBAC*`).

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| Définition de « douteux » | statut DOUTEUX ou CONTENTIEUX (pas IMMOBILISE ni EN_RETARD) ; le seuil 45 j de l'art. 8 n'est pas appliqué, on suit la classification existante | R-2017/07 art. 8-9 ; `ClassificationService` |
| Rang de l'année | 3 ans écoulés = 3e année = 75 % ; année entamée comptée (ceil), plafond 4 ans = 100 % | brief C1, art. 17-2b |
| Date d'ancienneté d'un client | déclassement le plus ancien de ses dossiers (contagion) | art. 9 |
| Couverture | plafonnée dossier par dossier (G1-G2 puis G3-G5), garanties actives seulement, valeur retenue ; catégorie via `ProduitGarantie` du couple produit+type ; garantie sans paramétrage = non éligible | art. 17-2 |
| Reprise : date de déclassement manquante | date du jour si pas d'historique (1re année, 25 %) : à corriger si besoin | — |
| Taux nominal des dossiers déjà restructurés avant cette livraison | taux courant (l'origine est perdue) | — |
| TEG antérieurs à D3 | non calculés rétroactivement, comptés dans `nbSansTeg` | D3 |
| Frais récurrents dans le TEG | pris dans les échéances (`montantFrais`) | simulation existante |
| `emprunteursActifs` du NON_RATTACHE | somme par groupe : un client à la fois rattaché et non rattaché est compté deux fois | — |

## Vérifications (2026-10-23)
- `regress.sh sfd-credit-service` : 694 tests, 0 échec, 0 erreur, 14 ignorés (déjà ignorés, non touchés). Pas de baseline avant changement.
- `regress.sh sfd-angular` : BUILD OK (25 warnings).
- NON FAIT : démarrage sur base démo jetable, appels HTTP des 6 endpoints (recoupement encours/classe de risque), vérification navigateur de l'écran garantie. `edip-env.sh` passe par le monolithe : il faut reconstruire le jar monolithe avec la branche crédit et `build-front` avec la branche Angular, trop lourd sur une machine saturée (charge 32/8 cœurs).

## Corrections de la revue opus (même jour)
- Toutes les réponses : calcul à la date du jour, `aLaDateDuJour=true`, champ `dateCalcul` (remplace `dateArrete`) ; une `dateArrete` en paramètre est acceptée et ignorée.
- Contagion : `dossiersDouteux()` sans filtre d'agence (clients + date de déclassement la plus ancienne + indicateur d'estimation) ; l'agence ne filtre que l'encours (test douteux A / sain B).
- `@PreAuthorize("hasAnyAuthority('ROLE_CREDIT_RAPPORT','ROLE_CREDIT_ALL','ROLE_ADMIN')")` sur les 6 endpoints ; reporting s'authentifie par JWT de service `ROLE_ADMIN` (`WebClientConfig` de sfd-reporting-service), donc passe. Test 403 + test ADMIN. Le rôle `ROLE_CREDIT_RAPPORT` n'est pas créé par `SetupCreditLoader` (qui crée `_RAPPORT_READ/_EXPORT/_ALL`) : même rôle que `RapportCreditController`, à aligner si besoin.
- Nouvelle colonne `date_declassement_douteux_estimee` ; `ProvisionClient.dateDeclassementEstimee` et `nbClientsDateEstimee` réels.
- Taux initial : posé sans condition au décaissement complet tant que le TEG n'est pas enregistré ; la reprise ne le pose que pour les dossiers décaissés.
- Reprise : première entrée douteuse postérieure au dernier retour en sain ; `findByCodeIgnoreCase` ; frais via `DecaissementCredit.getTotalFrais` ; `passerEnContentieux` pose la date de déclassement (date de passage) ; `provisionsConstituees` = provisions des dossiers retenus ; cellule COBAC traduite (`COBAC_COURT_*`).
- Tests : crédit 700 (699 verts au dernier run complet + le test de sécurité corrigé relancé seul, 2/2), Angular BUILD OK. Runtime reporté au Lot 6.
