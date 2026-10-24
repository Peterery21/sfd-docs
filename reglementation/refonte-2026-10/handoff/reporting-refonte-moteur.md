# S4 moteur / sources / import / contrôles — handoff (2026-10-23)

Branche locale (rien poussé) : `refs/heads/feature/reporting-refonte-moteur` dans `sfd-reporting-service`, depuis 070ad1b. Une branche intermédiaire `feature/reporting-refonte-moteur-import` (sous-agent sonnet, import STANDALONE, bf45314) est déjà fusionnée dedans.
Tests : baseline 487/0 → 482/0 après corrections de revue (454 avant) (`scripts/claude/regress.sh sfd-reporting-service`, 0 échec, 0 régression ; voir « Tests retirés » : −84 anciens tests d'un code supprimé, +51 nouveaux en moteur, import, exactitude, contrôles).

## Livré
- **Moteur** `reporting/moteur/` : `Expression` (analyseur : plus long code connu à la position d'un opérande, `-` opérateur seulement entre deux opérandes, `RAPPORT.LIGNE`, `@ALIAS` selon `categorieAssujetti`, `[N-1]`, `MIN`/`MAX`, constantes), `MoteurCalcul` (session paresseuse = ordre topologique entre lignes et rapports, cycle détecté et reporté avec le chemin, mémoïsation), `Balance`, `JeuDonnees`, `Catalogue`, `LigneCalculable`, `ResultatLigne`, `ErreurFormule` (types SYNTAXE, REFERENCE_INCONNUE, CYCLE, DIVISION_ZERO_POSSIBLE, COMPTE_INCONNU + DONNEE_INDISPONIBLE, FORMULE_NON_DEFINIE, DEPENDANCE_EN_ERREUR). L'ancien `FormulaEngineService` (SpEL) et `DataCollectorService` sont supprimés.
- Une ligne sans formule, une référence inconnue, une division par zéro, une donnée indisponible, une dépendance en erreur : `conformite: ERREUR`, `valeur: null`, message dans `erreur`. Jamais 0.
- `CalculRapportService` : catalogue des formules actives du périmètre (base = paquet + personnalisations) avec la variante de comptes en vigueur, N-1 (même date −1 an), variation en %, conformité (norme générale ou `normesParCategorie[categorieAssujetti]`).
- **Sources** `reporting/source/` : `SourceDonneesProvider`, `ModulesProvider` (INTEGRE), `ImportProvider` (STANDALONE), `SourcesService` (mode = `ReportingParametre.modeSource`, le champ client est ignoré), `CrossServiceCles`, `PlanReference`.
- **Import** `reporting/importation/` : entités `ImportLot`, `BalanceImportee`, `DonneeAnnexeImportee`, `ImportationService` (implémente `DonneesImporteesLecture`), endpoints `/donnees-importees/*` du contrat. Un nouvel import pour la même `periodeFin` remplace le lot. Supprimés : `/balance-import/*`, `POST /editions/import-excel`, `BalanceImportService*`, `ExcelImportService*`.
- **Éditions** : codes des paquets (anciens `BIL`, `CR`, `REG-BCEAO-003/005/002` mappés vers `DIMF-2000-BIL` / `DIMF-2080` pour régénérer les éditions historiques, `ReglementaireRapportCodeResolver`), `hashIntegrite` SHA-256 (zone, rapport, période, agence, source, lignes triées), régulateur et référence du texte lus dans le paquet (`RapportEdition.regulateur`, `referenceTexte`, utilisés par l'en-tête de `ReglementaireExportService`), nature DOCUMENT/EXTERNE non calculée (`statutDocument` A_JOINDRE / FORMAT_EXTERNE), `POST /editions/{id}/soumettre` (VALIDE ou CLOTURE → SOUMIS, sinon 409), `GET /editions/tableau-periode`, `GET /editions/{id}/controles`.
- `RapportLigne` : + `erreur`, `brut`, `amortProv`, `normeOperateur`, `confiance`, `section` ; `Conformite` : + `SANS_NORME`, `ERREUR`. DTO de ligne et d'édition alignés. Source d'une ligne : BALANCE | EXPRESSION | CROSS_SERVICE | SAISIE | NON_DEFINIE.
- `/formules/valider` et `/formules/apercu` (étaient 501) : erreurs typées, `libelleClair`, valeur, conformité, comptes contributeurs.
- **Contrôles** `ControleCoherenceService` : balance équilibrée (CRITIQUE), `controle.egal` du paquet (CRITIQUE par défaut), `controle.module` en INTEGRE (ALERTE ; INFO si le module est indisponible), lignes en erreur (ALERTE), lignes à 0 de comptes absents du plan EDIP (ALERTE). Un CRITIQUE en échec : `valider` renvoie 409 avec les libellés et les écarts. `ValidationServiceImpl` traduit les contrôles en `RapportValidation`.
- Démo : `ReportingDemoDataLoader` rattache les éditions à la zone des paquets de l'institution (visibles). Contenu inchangé (lignes IND/RAT historiques, codes `REG-<REG>-00x`) : il n'est pas recalculé par le moteur (voir « Reste »).
- Paquets enrichis (propriété de S2, modifiés ici car indispensables) : `controle` (egal / module + niveau) sur 8 lignes (UEMOA L90, B01, G01 ; RDC TOTAL_ACTIF, P_RESULTAT ; CEMAC EG99, EP99 ; OHADA BZ, CJ), références `B2N`, `F1A`, `G10` qualifiées `DIMF-2000-BIL.` dans UEMOA-REP-PRU-01/05/06. `LignePaquet` + `soldeRetenu`, `signe`, `exclut`, `amortProv`, `controle` ; `normesParCategorie` en liste (forme UEMOA) lue.

## Règles de lecture des comptes (à faire valider)
Solde d'un compte = débit − crédit. Valeur lue dans le sens de la ligne : `D` et `SOLDE` = débit − crédit, `C` = crédit − débit. Chaque compte est compté une fois même si plusieurs préfixes le couvrent. `dr` / `cr` (suffixe) et `soldeRetenu` : compte par compte. Préfixe `-` : déduit −|solde lu dans le sens de la ligne| (une provision créditrice réduit une ligne D) ; un compte visé par un `-` n'est jamais compté en plus (cas `11,-119`). `exclut` : préfixes retirés ; `A à B` (5 chiffres) = sous-comptes de réseau (5e chiffre 9) dans la plage. `amortProv` : la valeur de la ligne est le net = brut − amortissements/provisions, `brut` et `amortProv` sont gardés ; `(sauf …)` = préfixes exclus de la colonne. `signe` multiplie le résultat. Ligne à comptes sans `sens` : ERREUR. Comptes `NON_TROUVE` : ERREUR « formule non définie ».
La balance est un cumul à `periodeFin` (INTEGRE : `GET /comptabilite/consultation/balance?exercice=&periode=` = soldes de clôture de l'exercice jusqu'au mois de `periodeFin` ; fin d'exercice si le 31/12). `periodeDebut` ne sert qu'aux indicateurs de flux des modules.

## Clés CROSS_SERVICE et branchement
Les paquets ne portent pas de clé (`sourceDonnees: CROSS_SERVICE` nu) : la clé canonique est `RAPPORT.LIGNE`. 18 clés, toutes CEMAC (`CrossServiceCles.cles()`) :
| Clé | Libellé | Branchement INTEGRE |
|---|---|---|
| CEMAC-REP-006.JT18 | Provisions complémentaires à constituer | non branchée |
| CEMAC-REP-007.KL19 | Provisions complémentaires | non branchée |
| CEMAC-REP-009.VL08 | Provisions complémentaires à constituer | non branchée |
| CEMAC-REP-010.DA02 / DA04 | Plus gros risque par bénéficiaire ; total des risques > 10 % | non branchée |
| CEMAC-REP-011.DB02 / DB04 | idem (cat. 2/3) | non branchée |
| CEMAC-REP-018.PA02 | Plus forte participation / fonds nets | non branchée |
| CEMAC-REP-019.CS01 | Encours des créances en souffrance | **Crédit** : `creancesEnSouffrance` (`CreditReportingConnector.getEncoursStrict`) |
| CEMAC-REP-019.CS02 | Provisions à constituer (15/45/75/100 %) | non branchée |
| CEMAC-REP-020.ST01 | Capital social souscrit et libéré | non branchée |
| CEMAC-REP-020.ST02 | Nombre de membres (hommes/femmes) | non branchée (valeur double) |
| CEMAC-REP-020.ST03 | Nombre de salariés | **RH** : `effectifTotal` |
| CEMAC-REP-020.ST04 | Nombre d'agences et lieux | **Préférences** : `nombrePointsService` |
| CEMAC-REP-020.ST05 à ST09 | encours dépôts / nb comptes, crédits bruts/provisions/nets, trésorerie, taux de rémunération | non branchées (valeurs composites) |
Une clé non branchée, ou un module qui répond en erreur, donne ERREUR « Donnée non disponible : <clé> ». Les connecteurs existants renvoient des DTO à 0 en cas d'échec : j'ai ajouté des variantes `*Strict` (Crédit, Épargne, RH, Préférences) qui laissent remonter l'échec. En STANDALONE, la clé = onglet du modèle Excel.
Deux lignes UEMOA sont en `SAISIE` (`UEMOA-REP-PRU-FP.FP_DED_PROV`, `FP_DED_PART`) : ERREUR « Saisie manuelle requise » jusqu'à `PATCH /editions/{id}/lignes/{ligneId}` ; une édition régénérée garde les saisies.

## Données manquantes dans les modules (non modifié, à décider)
1. **Comptabilité** : pas d'endpoint de balance **sans agence** ni **à une date** : `/consultation/balance` exige `X-Agence-Code` (exercice par agence) et renvoie la balance globale de l'exercice jusqu'à une période. En consolidé sans en-tête dans la requête entrante, la balance est indisponible (ERREUR explicite). Souhaitable : `GET /reporting/balance?dateFin=&codeAgence=` renvoyant débit/crédit par compte, agence facultative.
2. Compta : `getBalance` fait un calcul compte par compte (N+1) ; timeout de 60 s côté reporting, appelé 2 fois par édition (N et N-1).
3. Crédit : encours par échéance résiduelle (≤ 3 mois, > 12 mois…) pour R2, R5 ; plus gros risque par bénéficiaire, risques > 10 % des fonds nets, parties liées (DA02, DA04, DB02, DB04, `UEMOA-REP-PRU-04`) ; provisionnement par ancienneté (CS02, JT18, KL19, VL08).
4. Client / Préférences : capital souscrit et libéré (ST01), membres hommes/femmes (ST02), participations (PA02).
5. Épargne : encours et nombre de comptes de dépôts (ST05), taux de rémunération max/min dépôts et crédits (ST08, ST09), trésorerie par catégorie (ST07).
6. `GET /reporting/*` des modules ne portent pas de notion de « période précédente » : N-1 se recalcule avec les mêmes appels sur la période décalée d'un an.

## Lacunes de paquet constatées (S2 / orchestrateur) — rien inventé
Résultat de l'exploration du moteur sur les paquets réels (balance minimale) : UEMOA 429 lignes calculables / 173 en erreur (139 sans formule, 6 `NON_TROUVE`, 8 références inconnues, 18 dépendances) ; CEMAC 397 / 70 ; RDC 70 / 28 ; OHADA 290 / 162 (133 sans formule).
- UEMOA `DIMF-2000-BIL` : B2N, F1A, G10 sans formule (aucune ligne fille) ; tous les ratios prudentiels UEMOA R1, R3 à R6, R8 à R10 dépendent de ces lignes ou des lignes absentes `I11_AUTRES_OPS`, `I12_MAX`, `I13_TOTAL` (références inconnues). **Aucun ratio prudentiel UEMOA n'est calculable aujourd'hui** (R1 est testé en ERREUR explicite) ; R7 (réserve générale) est calculable et testé.
- UEMOA `D1E`, `D1L`, `D32` à `D35` : `comptesAllegee: NON_TROUVE` en variante allégée → ERREUR ; `R2` en dépend.
- UEMOA `UEMOA-REP-IND-NF` (135 lignes) et `IND-FIN` (F02, F03, F08…) sans formule ; DIMF-2006 à 2018, 2011-1, 2011/12/13 : lignes de totaux sans formule. « Parent = somme des filles » n'a pas été appliqué : la hiérarchie des lignes n'est pas dans le paquet (pas de champ parent) ; à fournir.
- CEMAC : `XG07` (62) recouvre `XG06` (624) → double comptage dans le total `XG01` ; `exclut` « 30139 à 30939 », « 31139 à 31939 », « 32019 à 32949 », « 37139 à 37539 » interprétés en plage de sous-comptes de réseau (voir règles).
- RDC : `RDC-REP-001` P_CREDITEURS (46) et P_REGUL (47) sont lus en C alors que A_DEBITEURS / A_REGUL lisent les mêmes comptes en D : un solde débiteur apparaît négatif au passif (et inversement) ; `P_EMPRUNTS_TRESO`, risques, change, ROE/ROA… sans formule.
- OHADA : lignes `N34-*` à comptes sans `sens` → ERREUR ; 133 lignes sans formule (EBNL-SMT-BILAN…).

## Points à valider par un comptable / ambiguïtés
1. **Préfixe `-`** (provisions, amortissements) : déduit −|solde| côté sens de la ligne. Si un compte `-` a un solde de même sens que la ligne (anomalie), il est quand même déduit. Source : conventions des `package.yml` ; choix S4.
2. **Compte couvert par `+` et `-`** (ex. `11,-119`) : compté une fois, comme déduction. Question : l'intention du paquet est-elle bien celle-là ? Choix provisoire : oui.
3. **Plages `exclut` « A à B »** : sous-comptes de réseau = comptes de 5 chiffres ou plus dont le 5e chiffre est 9 et dont les 5 premiers chiffres sont dans [A, B]. Le texte dit « comptes réseau, 5e chiffre 9 » seulement pour la première plage. Source : `cemac-beac/reporting.md`.
4. **Solde cumulé à la date** (pas le mouvement de la période) pour toutes les lignes, y compris le compte de résultat : en infra-annuel on obtient le cumul depuis l'ouverture de l'exercice. Question : le compte de résultat infra-annuel doit-il être cumulé ou de la période ? Choix provisoire : cumul.
5. **Variation** = (N − N-1) / |N-1| × 100, absente si N-1 est indisponible ou nul. À confirmer (certains états demandent une variation absolue).
6. **Contrôles** : tolérance 0,01 ; niveaux CRITIQUE (bilan équilibré, balance équilibrée), ALERTE (résultat bilan = résultat compte de résultat RDC et OHADA, encours crédits / dépôts du module, lignes en erreur). Question : « encours crédit du rapport = encours du module Crédit » compare UEMOA B01 (net de provisions, compte ordinaires débiteurs inclus) à `encoursCreditTotal` (brut) ; l'écart est attendu, d'où ALERTE. Quels postes comparer exactement ?
7. **Échéance du tableau de période** = fin de période + `delaiJours` du paquet (ISO), à défaut le texte du paquet ; `enRetard` si l'échéance est passée et l'édition ni SOUMIS ni CLOTURE.
8. **Norme par catégorie** : clé de `normesParCategorie` comparée à `categorieAssujetti` (insensible à la casse). Les catégories UEMOA du paquet (`MUTUALISTE_AFFILIEE`…) ne coïncident pas avec les valeurs de `categorieAssujetti` (ART44, IMF…) : la norme générale s'applique tant que les deux listes ne sont pas alignées.
9. **Lignes à comptes sans `sens`** (OHADA N34, UEMOA D1E_HORS_PART) : ERREUR plutôt que d'inférer le sens.

## Tests retirés (code supprimé) et remplacements
Supprimés avec leur code : `DataCollectorServiceTest` (21), `FormulaEngineServiceTest` (11), `BalanceImportServiceImplTest` (8), `ExcelImportServiceImplTest` (11), `BalanceImportControllerTest` (1), l'ancien `ReglementaireRapportCodeResolverTest` (15), l'ancien `ValidationServiceImplTest` (17 : règles COH-/CONC- sur les codes IND/RAT disparus), 21 tests de génération de `RapportEditionServiceImplTest` couplés à l'ancien collecteur/moteur, l'ancien test 501 de `FormuleControllerTest`, le test `import-excel` de `EditionControllerTest`. Remplacés par : `MoteurCalculTest` (26), `ControleCoherenceServiceTest` (9), nouveau `ValidationServiceImplTest` (1), `ImportationServiceTest` (16) + `ImportationControllerTest` (5), `ExactitudeCalculsTest` (18, H2 + contexte complet), tests de contrôleur et de service (soumission, 409, valider/apercu, tableau de période, résolveur).

## Exactitude prouvée (ExactitudeCalculsTest, valeurs calculées à la main)
UEMOA : Caisse A10 = 1050 sur le compte 10 (le compte 52 à 9999 est ignoré), A11 = 800 (allégée, compte 1011) puis 1050 en ART44 (développée), compte de résultat R1A/R1C/R1D = 200/120/80, règle R7 = (1000 − 150) × 15 % = 127,5, R1 en ERREUR explicite, bilan déséquilibré → 409. CEMAC : EG03 brut 500 / amortissements 150 / net 350, EG07 brut 400 (25109 exclu) / amort 40 (29519 exclu) / net 360, EG01 = 710, XG02/XG03/XG01 = 100/40/140, norme HS05 = 25 % < 40 % NON_CONFORME, CS01 en ERREUR. RDC : TOTAL_ACTIF = TOTAL_PASSIF = 3240, N-1 et variation (+100 %), RBE/RAI, liquidité 1,6667 CONFORME, validation puis soumission, balance importée absente → toutes les lignes en erreur.

## Reste / à faire par l'orchestrateur
- **Service vérifié sur base PostgreSQL jetable** (`sfd_demo_s4reporting`, supprimée, service arrêté), sans profil : démarrage UP, 4 paquets chargés, 602 formules et 54 définitions UEMOA après `/setup/init` (TG), tables d'import créées. Par HTTP (jeton de service local, utilisateur de test créé dans la base jetable) : import d'une balance UEMOA par `/donnees-importees` (preview puis confirm), génération de DIMF-2000-BIL (A10 = 1050, A11 = 800, A01 = 800), DIMF-2080 (R1A/R1C/R1D = 200/120/80), UEMOA-REP-PRU-07 (R7 = 127,5), UEMOA-REP-PRU-01 (R1 en ERREUR « Dépend de DIMF-2000-BIL.B2N en erreur : Formule non définie »), contrôles, `valider` → 409 (L90 ≠ E90), tableau de période. Dans DIMF-2000-BIL : 145 lignes dont 9 en erreur explicite ; aucune ligne sans valeur et sans erreur. Les lignes à 0 sont des lignes à comptes sans mouvement dans la balance fournie (zéro calculé, pas un repli). Non vérifié : mode INTEGRE contre une vraie comptabilité (aucun module lancé), navigateur (aucun écran modifié ici).
- Monolithe : les nouvelles entités et services sont sous `com.synapsesit.sfd.reporting` / `.importation` (scan du monolithe non vérifié, comme pour S2).
- Angular (S5/S7) : endpoints supprimés `/balance-import/*` et `/editions/import-excel` ; nouveaux champs de ligne (`erreur`, `brut`, `amortProv`, `normeOperateur`, `confiance`, `section`, conformité `SANS_NORME` / `ERREUR`) et d'édition (`natureRapport`, `statutDocument`, `regulateur`, `referenceTexte`) ; `ApercuFormuleDto.conformite` vaut `ERREUR` quand le calcul échoue.
- Démo : reconstruire les éditions de démo avec le moteur (balance de démo) ; elles sont aujourd'hui visibles mais pas recalculables (codes `REG-*`).
- Exports PDF/Excel/ZIP et états financiers : S6 (seul l'en-tête du régulateur est lu dans le paquet ici ; les layouts sont toujours choisis par les anciens codes `REG-BCEAO-xxx` dans `ReglementaireExportService`).
- Les liens `CROSS_SERVICE` non branchés dépendent de décisions sur les modules (section ci-dessus).

## Corrections de revue opus (SHA 84ca433)
1. **Consolidé / multi-agences** : plus de repli sur l'en-tête `X-Agence-Code`. Agence null (consolidé) en INTEGRE → ERREUR « balance consolidée indisponible » (aucune balance toutes agences côté Comptabilité). MULTI-N → refusé explicitement (la liste n'est pas conservée) ; plus aucun appel module avec « MULTI-N » (annexes vides, contrôle module en INFO). `PeriodeCalcul.multiAgences`.
2. **Éditions figées** : `saisieManuelle` et `regenerer` refusés (409) hors BROUILLON / EN_COURS (donc VALIDE, SOUMIS, REJETE) ; CLOTURE garde son message existant. Choix : refus, pas de réouverture automatique (il faut régénérer une édition). `soumettre` depuis CLOTURE testé.
3. **Import** : lots filtrés par zone + pays (lister, supprimer → 404 hors périmètre, lecture moteur, remplacement de lot). Le lot n'a pas d'agence : en STANDALONE seules les éditions **consolidées** sont acceptées (`generer` → erreur, `ImportProvider` → ERREUR). L'Angular doit envoyer `consolider: true` en STANDALONE.
4. **Sous-totaux** : un compte préfixe d'un autre compte importé est rejeté à l'import (erreur claire, confirm refusé).
5. **amortProv** : les préfixes de la colonne amortissements/provisions sont retirés du brut (exemple chiffré : 202 D 500, 2021 C 30, 280 C 120 → brut 500, amort 150, net 350).
6. **Compte en formule** : valeur en cache lue ; formule sans valeur exploitable, cellule en erreur ou numéro non numérique → erreur d'import.
7. **Code de ligne numérique** : un code connu l'emporte sur la constante de même écriture (`770` = la ligne ; écrire `770.0` pour la constante).
8. `ROLE_REPORTING_IMPORT` retiré (écriture : `ROLE_REPORTING_ALL`, `ROLE_ADMIN`).
9. **Balance figée** : totaux débit/crédit de la balance de la génération stockés dans l'édition (`balanceTotalDebit/Credit`), contrôlés à la validation (plus de relecture).
10. **Tests** : `ModulesProviderTest` (getBalance, 31/12, mois, EX, consolidé, multi, connecteurs stricts), résolution d'agence dans `generer`, alias et `normesParCategorie` (`CalculRapportServiceTest`), verrouillage des éditions, import réel non mocké (`ExactitudeImportReelTest`, xlsx → import → bilan RDC 3240 et liquidité), sous-totaux, périmètre d'import.
