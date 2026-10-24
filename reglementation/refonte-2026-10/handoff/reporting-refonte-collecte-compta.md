# T1 collecte compta et commun — handoff pour R1

Branches (rien de poussé), toutes `feature/reporting-refonte-collecte-compta` à partir de `feature/reporting-refonte` :
- `sfd-comptabilite-service` : 44f343f, cd7fa0e, 2252b10
- `sfd-commun-service` : 81371d4
- `sfd-angular` : voir `git log` (commit « type de contrepartie des banques et écran des participations »)

Tests (baseline → après) : compta 1573 → 1579 (0 échec) ; commun 461 → 464 (0 échec) ; Angular `BUILD OK` (pas de baseline : node_modules absent du worktree, build refait avec un lien vers ceux du dépôt principal).
Vérification HTTP sur base démo jetable (clone r17, services lancés sans profil, base supprimée ensuite) : les trois endpoints rendent la valeur attendue, recoupée par SQL sur `ligne_ecriture`.
Navigateur : écran Banques (liste + création FAITIERE) et écran Participations (liste + création + compte sélectionné) OK.

## Endpoints compta (`/api/comptabilite/reporting/...`, droits COMPTABILITE_READ/ALL, REPORTING_READ, ADMIN ; consolidé = REPORTING_READ/ADMIN seulement)
Dates ISO en paramètre ; **les `LocalDate` des réponses sortent en tableau `[2026,10,31]`** (comme `/reporting/balance`). Soldes = sens normal du compte (débiteur : D − C), pièces COMPTABILISEE seulement, `dateArrete` incluse.

1. `GET /hors-bilan/beneficiaires?dateArrete=&codeAgence=&classes=903,913` (classes = préfixes, obligatoire, aucun défaut en dur)
   `{dateArrete, codeAgence|null, classes[], beneficiaires:[{codeClient, nomClient, classe, solde}], totalBeneficiaires, montantSansAuxiliaire, montantAuxiliaireSansClient, alertes[]}`
   Trié par solde décroissant ; une ligne par (client, classe demandée). `montantSansAuxiliaire`/`montantAuxiliaireSansClient` ≠ 0 → « donnée non renseignée » côté R1.
2. `GET /tresorerie/contreparties?dateArrete=&codeAgence=`
   `{dateArrete, codeAgence|null, contreparties:[{typeContrepartie, solde, nbComptes}], caisses|null, total, alertes[]}`
   `typeContrepartie` : BANQUE, EMF, FAITIERE, AUTRE, + `NON_RENSEIGNE` (banque absente du commun) et `NON_VENTILE` (un même compte comptable partagé par des banques de types différents). `caisses` = solde des comptes commençant par le compte du rôle CAISSE ; `null` + alerte si le rôle n'est pas défini.
3. `GET /participations?dateArrete=`
   `{dateArrete, participations:[{codeAuxiliaire, entiteEmettrice, pourcentageDetenu, compteCollectif, solde}], total, soldeSansAuxiliaire, alertes[]}`
   Plus forte participation / fonds nets : à calculer dans R1 (`max(solde) / @FPN`).

## Commun
`Banque.typeContrepartie` (enum `TypeContrepartie` BANQUE, EMF, FAITIERE, AUTRE ; défaut BANQUE, colonne `type_contrepartie varchar(20) default 'BANQUE'`, créée par `ddl-auto: update` : ni commun ni compta n'ont Liquibase, d'où pas de changelog). Présent dans `BanqueDto`, absent à la modification = inchangé. Écran Paramétrage commun › Banques : colonne + sélecteur.

## Compta : auxiliaire PARTICIPATION
`TypeAuxiliaire.PARTICIPATION`, colonnes `entite_emettrice` (150) et `pourcentage_detenu` (5,2, 0–100) sur `CompteAuxiliaire` et son DTO. Création/modification refusées si `compteCollectif` est absent du plan (pas de compte inventé). Format de numéro `AUX_PARTICIPATION` (préfixe PART) ajouté à `SetupComptabiliteLoader`. Écran Comptabilité › Paramétrage › Participations (nouveau : il n'existait AUCUN écran de gestion des auxiliaires, seulement la génération des COMPTABLE).

## Choix de conception (pas de compte en dur)
- Hors-bilan : les classes viennent de l'appelant. L'écriture/l'API d'écriture acceptait déjà `codeAuxiliaire` sur la classe 9 (aucune restriction), rien à changer.
- Participations : le compte = le `compteCollectif` de chaque auxiliaire PARTICIPATION (validé contre le plan de la norme : 412 UEMOA, 26x CEMAC, 251/252 RDC selon ce que l'institution choisit). Aucun rôle comptable ajouté (le `RoleComptable` est dans sfd-integration-api, hors périmètre).
- Banques : pas de client « banque » dans sfd-integration-api ; `BanqueCommunClient` (compta) réutilise le `RestClient` `preferenceHttpClient` (chemin `/preference/banques`, jeton propagé). Le jeton appelant doit avoir `ROLE_PREFERENCE_BANQUE_READ` ou ADMIN (jeton de service du reporting = ADMIN).
- Commun injoignable → 503 explicite.

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| Sens de lecture des soldes 903/913 : D − C (comptes DEBITEUR posés par S10, règle RCSFD p. 262-278) | solde dans le sens du compte du plan | plan-classe9-hors-bilan.yml (sens « regle » / « défaut à valider ») |
| Comptes bancaires partageant un même compte comptable (baseline démo : tous sur 114100) | solde non ventilable → `NON_VENTILE` + alerte ; un compte comptable distinct par type de contrepartie est requis | contrainte du lot (pas d'analytique par banque dans le grand livre) |
| Caisses = tous les comptes commençant par le compte du rôle CAISSE (101 → 101xxx) | préfixe du rôle | roles-comptables.yml RCS_SFD (101) ; CEMAC/RDC : rôle absent → `caisses` null + alerte |
| Compte de participation par auxiliaire (412 UEMOA, 26x CEMAC, 251/252 RDC) | choisi par l'utilisateur à la création, validé contre le plan | REPORTING_PLAN_COLLECTE.md lot T1 |
| Création manuelle d'un compte de classe 9 refusée (motif `^[1-8]` dans `PlanComptableDto`/`PlanComptableServiceImpl`, et deux tests l'imposent) | non modifié (hors brief, tests existants) : classe 9 vient du plan de la norme | à décider (S10) |

## Hors périmètre / suites
- Instances existantes : la colonne `type_contrepartie` se remplit à 'BANQUE' ; les banques EMF/faîtière doivent être reclassées par l'utilisateur (D1).
- `AUX_PARTICIPATION` n'existe que si `createNumberFormats` s'exécute ; vérifié sur la baseline r17 (code `PART-202610-000001` généré).
- Pas d'e2e Playwright ajouté pour les deux écrans.

## Corrections après revue opus (2026-10-23)
Commits : compta b4df6a5, commun e2fb0ab, angular 07c7586c. Tests : compta 1591 (0 échec), commun 466 (0 échec), Angular BUILD OK.
- Participations : `comptesParticipation` dans le `metadata.yml` de chaque norme (UEMOA rcs_sfd 412 ; CEMAC cobac/syscohada/sycebnl 26 ; RDC gcec et pcci 251+252, rdc/syscohada 26 car 251/252 y sont des avances ; uemoa syscohada/sycebnl 26). `ComptesParticipationNorme` lit ces racines ; création/modification d'un auxiliaire PARTICIPATION refusée hors racines ; `soldeSansAuxiliaire` calculé sur toutes les racines (aussi celles sans auxiliaire) et auxiliaires hors norme signalés en alerte. Tests chiffrés (6500 / 200).
- Hors-bilan : toute ligne de classe 9 avec auxiliaire exige un auxiliaire existant dont le collectif est en classe 9 (`EcritureServiceImpl`), sinon `ecriture.classe9.auxiliaire.collectif.invalide`. Test de non-régression : l'auxiliaire client (collectif 251) est refusé et rien n'est écrit. Limite : seul le chemin de saisie/API d'écriture est gardé, pas les lignes publiées par les consumers de modules (ils ne publient pas en classe 9).
- Paramètre `classes` : `^\d+$` + au moins un compte HORS_BILAN du plan commençant par ce préfixe, sinon 400.
- Commun : défaut BANQUE en PostLoad/PreUpdate/PrePersist ; `BanqueTypeContrepartieRepriseRunner` (UPDATE ... WHERE NULL, idempotent, au démarrage).
- `BanqueCommunClient` : `getIfAvailable()`, 503 si client absent/injoignable/erreur commun, 403 explicite si 401/403.
- Trésorerie : comptes inactifs lus, ignorés si solde nul ; soldes par une requête `IN ... GROUP BY` (`findSoldesParComptes`).
- Fixture xlsx restaurée depuis `feature/reporting-refonte` (les tests la régénèrent : refaire `git checkout feature/reporting-refonte -- <fichier>` avant commit si besoin).
- Angular : toast de succès `COMPTABILITE.PARAMETRAGE.PARTICIPATION.ENREGISTRE` (fr, en, ln).
Non rejoué en HTTP après corrections (couvert par les contextes Spring des tests) ; la vérification HTTP/navigateur ci-dessus date d'avant.
