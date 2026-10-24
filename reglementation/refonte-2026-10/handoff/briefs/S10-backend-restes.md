# S10 — Restes backend du reporting (nettoyage legacy, données inter-modules, rôles, test TFT). Modèle sonnet

Lire d'abord `COMMUN.md` (même dossier), puis le contrat v1.2 (`<WT>/sfd-docs/reglementation/REPORTING_API_CONTRAT.md`) et les handoffs `<WT>/.claude/handoff/reporting-refonte-moteur.md` (S4) et `reporting-refonte-zip-ef.md` (S6). `<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77`.

## Branches
- `sfd-reporting-service` : `feature/reporting-refonte-restes`, créée depuis `feature/reporting-refonte` (6a9ee6c ou plus récent).
- `sfd-comptabilite-service` : `feature/reporting-refonte-restes`, créée depuis `feature/reporting-refonte` (5becf1d), uniquement pour le point 3.
- Autres services (crédit, épargne, client), uniquement si le point 2 exige un nouvel endpoint. La branche porte le même nom et part de la branche par défaut du dépôt. Signale-le dans le rapport.

## Travail
1. **Nettoyage legacy** (reporting).
   - Retirer les anciens rapports `REG-BCEAO-008` à `014`, le controller et les services SYCEBNL devenus alias, `narratif`, l'enum `TypeRapport` et `CONFORMITE_BCEAO` s'ils ne servent plus. Le paquet de localisation les remplace.
   - **Avant toute suppression**, faire un grep dans tous les dépôts `sfd-*`, y compris `sfd-angular` sur `feature/reporting-refonte` (`git grep` sur la branche) et `sfd-erp-monolith`. Ne supprimer que ce que plus personne n'appelle. Lister ce qui est gardé, avec la raison.
   - Ajouter une migration Liquibase si des tables ou des données deviennent orphelines. Ne jamais supprimer de données utilisateur : renommer ou marquer obsolète, et le signaler.
2. **Données CROSS_SERVICE non branchées.** Il y en a 3 en UEMOA et 15 en CEMAC : provisions complémentaires, plus gros risques, participations, capital libéré, membres H/F, encours de dépôts, taux…
   - L'orchestrateur t'enverra la table de correspondance « clé → module/endpoint ou comptes ».
   - Brancher dans `ModulesProvider`/`IntegrationClient` celles qui ont un endpoint existant.
   - Pour les clés calculables depuis la balance, passer par une formule du paquet, avec les comptes du plan et jamais un compte par analogie.
   - Les autres deviennent des lignes `SAISIE`, avec une note `aConfirmer` et une entrée dans le registre des points à valider.
   - En mode STANDALONE, ces clés viennent des données annexes importées : vérifier que le modèle Excel les contient.
3. **Test TFT cessions FI/FJ** (compta).
   - Ajouter dans `sfd-comptabilite-service` un test chiffré de FI et FJ : cessions d'immobilisations (821, 822, 754 ; 826), nettes de 485 et 414, conformément aux corrections S6 et au Guide SYSCOHADA.
   - Corriger le calcul si le test révèle un écart, et citer la source.
4. **Rôle `ROLE_REPORTING_WRITE`.**
   - Les endpoints de modification des formules et des paramètres l'exigent, mais il n'est pas créé dans les données initiales.
   - Repérer où les rôles du reporting sont créés (Liquibase du service, ou sfd-commun/preference pour les permissions du wizard) et l'ajouter de la même façon, avec un test.

## Périmètre
- **Modifiables** : `sfd-reporting-service` (hors `src/main/resources/localisation/**`, sauf les lignes CROSS_SERVICE du point 2), le test et le calcul TFT de `sfd-comptabilite-service`, et le seed du rôle.
- **Exclus** : `sfd-angular` (S7 y travaille en parallèle). Si une suppression du point 1 casse un appel Angular, ne supprime pas et signale-le.

## Fini quand
- `scripts/claude/regress.sh` donne 0 échec, pour sfd-reporting-service et pour sfd-comptabilite-service (baseline → après).
- Le service reporting démarre sans profil sur une base démo jetable : `/actuator/health` UP, et une édition CEMAC consolidée en INTEGRE montre les clés branchées avec une valeur, sans ERREUR. Ensuite, arrête le service et supprime la base.
- Handoff `reporting-refonte-restes.md` : ce qui est supprimé, gardé ou branché, et la section « Points à valider ». Les branches sont commitées, rien n'est poussé. Rapport au format fixe envoyé à l'orchestrateur.

## Table de correspondance CROSS_SERVICE (orchestrateur, 2026-10-23)
`ModulesProvider.lire()` ne gère aujourd'hui que 3 clés CEMAC (019.CS01, 020.ST03, 020.ST04). `GET /comptabilite/reporting/balance` existe bien sur compta `feature/reporting-refonte` (`ReportingController.java:68`, S6).

**(a) Endpoint existant, à brancher**
- 020.ST06 : crédit `POST /reporting/bceao/encours`, champs `encoursCreditTotal` et `provisionsConstituees`. Le net est obtenu par soustraction. La ligne ST06 est à découper en 3 sous-clés (brut, provisions, net).
- 020.ST05 : épargne `POST /reporting/encours-bceao`, champs total, vue, terme et `clientsActifs`. Le nombre de comptes est absent : le noter dans les points à valider.
- 020.ST02 : client `GET /reporting/bceao/stats`, hommes et femmes. Les « actionnaires » ne sont pas couverts, seuls les clients le sont : le noter.
- 019.CS02, 006.JT18, 007.KL19, 009.VL08 (provisions) : crédit `GET /rapports/provisions`, `provisionRequise` par classe. Le barème 2002/18 n'est pas confirmé : garder `aConfirmer` et inscrire ces lignes au registre.

**(b) Depuis la balance (comptes du paquet uniquement)**
- 020.ST01 capital : 101,102 (REP-001B), ou 100,102 moins 1001 (REP-001D), selon la catégorie de l'EMF. Formule SOLDE() du paquet.

**(c) Lignes SAISIE `aConfirmer`, inscrites au registre comme « endpoint à créer »**
- Côté crédit :
  - plus gros risques : 010.DA02, DA04, 011.DB02, DB04, `credit.plusGrosEncoursMembre`, et en RDC `credit.plusGrosRisqueClient` et `credit.plusGrosRisqueMembre` ;
  - taux : 020.ST08 et ST09 (`/dat/statistiques` ne donne que le taux moyen DAT) ;
  - `credit.encoursDirigeantsPersonnelPersonnesLiees` ;
  - en RDC, `credit.crdEnRetard` (seuil « ≥ 1 retard » non exposé) et `credit.emprunteursParAgentCredit`.
- Autres :
  - 018.PA02 (détail des participations par tiers) ;
  - 020.ST07 (découpage de la trésorerie non défini) ;
  - `institution.montantAutresOperations` ;
  - PLAFOND_CLIENT.
- **Ne crée pas ces nouveaux endpoints dans S10** : ils relèvent du module crédit et feront l'objet d'un lot dédié. Toutes ces lignes doivent par ailleurs sortir comme SAISIE ou ERREUR explicite, jamais à 0.

## 5. Classe 9 hors-bilan au plan UEMOA (compta) — décision utilisateur 2026-10-23 : l'ajouter, le comptable corrigera
- Source : `<WT>/sfd-docs/reglementation/uemoa-bceao/plan-classe9-hors-bilan.yml` sur sfd-docs `feature/reporting-refonte`. Il contient 87 comptes de 90 à 99, les contreparties 980 à 985 et la règle de sens. Confiance HAUTE sur les comptes et les libellés : le RCSFD p. 96-98 et le guide d'audit 2010 concordent.
- Ajouter ces comptes au plan RCSFD de `sfd-comptabilite-service/src/main/resources/config/accounting-norms/uemoa/**`, avec le même format et le même chargement que les classes existantes (S1). Ajouter aussi 980 à 985 et 937/938. Chaque compte porte une note de source et `aValider: true` si le format le permet ; sinon, le préciser dans le handoff.
- Vérifier que le chargement du plan ne casse pas les plans existants des bases déjà initialisées : ajout seulement, sans écrasement.
- Côté reporting, retirer `planEdipIncomplet` des lignes du paquet UEMOA dont les comptes sont désormais présents. Recompter les lignes calculables, sachant qu'avant on avait 488/603 en allégé et 496/603 en développé.
- Tests : chargement du plan (présence de 901, 9611, 99 et 985), test du registre de localisation, `regress.sh` sur les deux services.
