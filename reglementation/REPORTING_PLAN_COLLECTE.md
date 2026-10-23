# Plan de collecte des données réglementaires sans source (proposition du 2026-10-23)

Objectif : toutes les lignes CROSS_SERVICE des paquets doivent être alimentées par un module EDIP. Celles qui sont aujourd'hui sans source passent en saisie manuelle « à confirmer » en attendant.
La base est l'analyse des modèles des services crédit, client, épargne, compta, RH, transfert et caisse (branche `develop`). Le règlement de provisionnement de la CEMAC est le COBAC EMF R-2017/07.

## Principe
1. **Agrégat sur une donnée existante** : nouvel endpoint `/reporting/...` dans le module propriétaire, branché dans `ModulesProvider`. Aucune nouvelle saisie.
2. **Donnée absente du modèle** : nouveau champ ou nouvelle entité dans le module métier, écran de saisie Angular, puis agrégat. L'institution doit renseigner la donnée. Tant qu'elle ne l'a pas fait, la ligne sort en ERREUR « donnée non renseignée », jamais à 0.
3. **Mode STANDALONE** : chaque clé figure dans l'onglet « données annexes » du modèle Excel d'import.
4. **Pas de rétroactif** : les retards, les encours et les taux des modules sont des instantanés. L'édition fige les valeurs à sa génération, et une génération sur une date passée affiche l'avertissement « valeur à la date du jour ».

## Lots

| Lot | Module | Données (clés) | Ce qui existe | À faire | Type |
|---|---|---|---|---|---|
| **C1** | crédit | Plus gros risques : CEMAC DA02/DB02, UEMOA `plusGrosEncoursMembre` (DIMF-2012), RDC `plusGrosRisqueClient`/`Membre` | `DossierCredit.codeClient` et `capitalRestantDu`, `getEncoursByClient` | Endpoint top N des encours par client (filtre de statut, agence ou consolidé). Le type de client vient du service client. | 1 |
| C1 | crédit | Taux crédits min/max (CEMAC ST09) | `tauxInteretAnnuel` du dossier | Endpoint min/max/moyenne pondérée sur les décaissements de la période. **Décision D3** : TEG ou taux nominal. | 1 |
| C1 | crédit | RDC `crdEnRetard` (CRD avec 1 retard ou plus), `emprunteursParAgentCredit` | `joursRetard`, `getEncoursPAR(0)` ; `agentCredit`, `GestionnaireCredit` | Endpoint CRD par tranche de retard (1-30, 31-90, 91-180, 181 et plus). Endpoint emprunteurs actifs par gestionnaire, après normalisation de `agentCredit` en `gestionnaireCreditId`. | 1 (+ petite migration) |
| C1 | crédit | Provisions R-2017/07 : CEMAC CS02, JT18, KL19, VL08 | `Garantie`, `ProduitGarantie`, classe de risque, `souffranceComptable` | Ajouter : la catégorie de garantie COBAC (1-2 ou 3-5) sur le produit de garantie, et la date de déclassement en douteux sur le dossier (vérifier ce qui existe déjà). Puis endpoint de provision requise par contrepartie : 100 % non couvert, 25/50/75/100 % cumulés selon l'année pour les garanties 3-5, 0 % pour les garanties 1-2. Les provisions complémentaires valent la provision requise moins le compte 39, avec un plancher à 0. | 2 |
| **E1** | épargne | Taux dépôts min/max (CEMAC ST08), nombre de comptes (ST05) | `DepotATerme.tauxAnnuel`, `HistoriqueInteretCompte.tauxApplique`, encours BCEAO | Endpoint min/max des taux DAT et épargne sur la période. Ajouter le nombre de comptes actifs par type à l'endpoint encours. | 1 |
| **K1** | client + RH + crédit | Encours des dirigeants, administrateurs, personnel et apparentés (UEMOA DIMF-2013) | `Employe.codeClient` (RH) ; `Beneficiaire.lienParente` (texte libre, pas un client) | **Client** : champ `categorieInitie` (DIRIGEANT, ADMINISTRATEUR, PERSONNEL, APPARENTE), avec les dates de début et de fin de mandat, et une table `LienClient` (client A ↔ client B, type de lien). **RH** : endpoint « employés actifs → codeClient » pour alimenter PERSONNEL automatiquement. **Crédit** : endpoint d'encours pour une liste de clients. Écran de saisie dans la fiche client. | 2 |
| K1 | client + crédit | Risques au-delà de 10 % des fonds propres nets, cumul par groupe de bénéficiaires liés (CEMAC DA04/DB04, plafond client) | `MembreGroupe` (groupe solidaire seulement) | **Client** : entité `GroupeRisque` et ses membres (bénéficiaire effectif, lien capitalistique), avec un écran. **Crédit** : encours cumulé par groupe de risque. **Reporting** : comparaison avec @FPN. | 2 |
| **T1** | compta + commun | Engagements par signature (hors-bilan) dans les plus gros risques | Classe 9 ajoutée par S10 ; `CompteAuxiliaire.codeClient` | Comptabiliser les engagements donnés en classe 9 avec un auxiliaire client. Endpoint de solde de classe 9 par `codeClient`, ajouté au top N du lot C1. Pas de nouveau module. | 2 (léger) |
| T1 | commun + compta | Trésorerie par contrepartie : banques, autres EMF, faîtière, caisses (CEMAC ST07) | `CompteBancaire.codeBanque` → `Banque` (pas de type) ; `CompteMobileMoney` | Champ `typeContrepartie` (BANQUE, EMF, FAITIERE, AUTRE) sur `Banque` (commun), avec l'écran de paramétrage. Endpoint de solde comptable par type de contrepartie, avec les caisses via les comptes 57. | 2 (léger) |
| T1 | compta | Participations par entité (CEMAC PA02) | Comptes 26x/412/251 sans tiers | Type d'auxiliaire `PARTICIPATION` (entité émettrice, % détenu). Endpoint de solde par entité, et calcul de la plus forte participation rapportée aux fonds nets. | 2 (léger) |
| **A1** | transfert + caisse | Autres opérations (UEMOA DIMF-2011) | `Transfert` (montants, types, dates) ; `TypeOperationCaisse.CHANGE` | Endpoint de cumul des transferts émis et payés par type sur la période. Vérifier la persistance des opérations de change en caisse et les ajouter. **Assurance et mobile money** : aucun module, ils restent en SAISIE (décision D2). | 1 |
| **R1** | reporting + Angular | Branchement de toutes les clés | `ModulesProvider` (3 clés CEMAC aujourd'hui) | Brancher chaque endpoint. Ajouter les clés à l'onglet « données annexes » du modèle STANDALONE. Ligne en ERREUR explicite si la donnée n'est pas renseignée. Badge « donnée non renseignée » dans l'écran d'édition. | — |

## Ordonnancement
- **Vague 1**, en parallèle, une session par dépôt, selon `resources.sh` :
  - C1 (crédit) ;
  - E1 (épargne) ;
  - A1 (transfert et caisse) ;
  - T1 (compta et commun), après la fusion de S10, qui ajoute la classe 9.
- **Vague 2** : K1 (client, RH et crédit, avec écrans), car le lot C1 doit d'abord exposer l'endpoint d'encours par liste de clients.
- **Vague 3** : R1, le branchement dans reporting, puis l'e2e et le contrôle d'exactitude dans le navigateur sur les bases de démo UEMOA, CEMAC et RDC.
- Chaque lot passe par une revue opus du diff, les tests, puis la fusion dans `feature/reporting-refonte` du dépôt concerné. Rien n'est poussé sans accord.

## Décisions demandées
- **D1** : accepter les nouvelles saisies métier. L'institution devra renseigner :
  - la catégorie d'initié et les liens entre clients ;
  - les groupes de risque ;
  - le type de contrepartie bancaire ;
  - les participations ;
  - la catégorie COBAC des garanties.
  Sans ces saisies, les lignes concernées sortent en ERREUR.
- **D2** : assurance et mobile money restent en saisie manuelle dans l'édition (pas de nouveau module).
- **D3** : taux des crédits. Soit le taux nominal tout de suite, soit l'enregistrement du TEG au décaissement (nouvelle colonne, recommandé pour la CEMAC ST09).
