# Migration de données EDIP — guide opérateur

Itération 1 : socle (lots, verrou, réinitialisation) et classeur `01-Parametrage` (module commun : devises, agences, utilisateurs). Itération 2 : classeurs `02-Comptabilite` (plan comptable, journaux, balance d'ouverture, exercices générés) et `03-Clients` (gestionnaires, clients, groupes, membres, bénéficiaires, parts sociales). Itération 3 : classeur `04-Epargne` (produits, comptes, DAT, blocages, tontines) et pièces d'à-nouveaux. Avenant du 2026-10-19 : migration sur **base vide** et paramétrages des modules commun, comptabilité, client et épargne (profils, banques, rôles comptables, comptes bancaires, frais, seuils, dormance : §2 bis et §4 quinquies). Itération 4 : classeurs `06-Caisse` (caisses et soldes de bascule, §4 sexies) et `05-Credit` (paramétrages et encours, §4 septies), étape 6 « Contrôles post-import » avec rapport et clôture du lot (§4 octies). Itération 4 bis : classeurs `07-Stock` (articles, magasins, stock d'ouverture, §4 septies bis) et `08-Immobilisation` (catégories, natures, immobilisations avec plan d'amortissement reconstitué, §4 septies ter). Itération 4 ter : classeurs `09-RH` (organisation, employés, contrats, soldes de congés, §4 septies quater) et `10-Paie` (rubriques, périodes, cumuls de l'année, avances, §4 septies quinquies), compte de reprise (§4 septies sexies). Les classeurs des autres modules arrivent aux itérations suivantes sur les mêmes interfaces.

## 1. Objet

Charger dans une instance EDIP les données d'une institution (reprise d'un ancien système) via des classeurs Excel (`.xlsx`) ou CSV, avec contrôle avant écriture, journal d'erreurs, import suivi en direct et annulation propre. Une réinitialisation contrôlée de la base permet de repartir de zéro sur un environnement de migration ou de démonstration.

Écrans : menu `Migration` (`/migration/lots`, `/migration/lots/nouveau`, `/migration/lots/:id`, `/migration/reinitialisation`).

## 2. Prérequis

| Prérequis | Détail |
|---|---|
| Rôle | `ROLE_MIGRATION` ou `ROLE_ADMIN` (toute l'API `/api/preference/migration/**` est refusée sinon). `ROLE_MIGRATION` ne s'attribue pas par un classeur. |
| Wizard `/setup` | Déjà exécuté : institution, agence, administrateur, plan comptable, journaux. Les référentiels (types d'agence, pays, devises, profils) viennent de là. |
| `INTERNAL_SERVICE_KEY` | Identique sur le service commun et sur chaque module cible (appels internes `/internal/import/**`). |
| `IMPORT_REINITIALISATION_ENABLED` | `false` par défaut. À `true` uniquement sur un environnement de migration ou de démo, jamais en production. |
| `SCHEDULING_ENABLED=false` | Recommandé pendant la migration (évite tout traitement planifié concurrent). Le verrou fait déjà ignorer les jobs des modules client, épargne et crédit. |
| URLs des modules | `IMPORT_<MODULE>_URL` (comptabilite, client, epargne, credit, caisse, stock, immobilisation, rh, paie) en microservices ; en monolithe, rien à régler. |
| Dossiers | `IMPORT_DOSSIER_DEPOT` (fichiers déposés sur le serveur), `IMPORT_DOSSIER_STOCKAGE` (copies des fichiers d'un lot). Taille max : `IMPORT_MAX_FILE_SIZE` (1 Go), `IMPORT_MAX_REQUEST_SIZE` (2 Go). |
| Files RabbitMQ | `IMPORT_REINIT_FILES` : files qui doivent être vides avant une réinitialisation (liste séparée par des virgules). **Vide par défaut : aucun contrôle n'est alors effectué** et l'écran Réinitialisation affiche « contrôle des files RabbitMQ non configuré ». Renseigner les files métier (ex. écritures comptables) sur tout environnement où des messages peuvent être en attente. |

## 2 bis. Migration sur base vide

Cas visé : l'institution part d'une installation neuve, sans données de démonstration. Tout ce que la démo seedait (frais, seuils, banques, profils…) doit être fourni par les classeurs.

**Prérequis**
1. Installation neuve : wizard `/setup` exécuté **sans** la case « données de démonstration » (institution, agence siège, administrateur, devise principale, plan comptable et journaux de la norme). Attendre la fin de l'initialisation asynchrone des modules (statut `COMPLETED` et services initialisés : comptabilité, crédit, reporting) avant de déposer un lot ; en cas de doute, `scripts/edip-env/edip-env.sh baseline-create --vide` sonde cet état.
2. Modules cibles démarrés, `INTERNAL_SERVICE_KEY` identique partout, `ROLE_MIGRATION` ou `ROLE_ADMIN` pour l'opérateur (§2). Les caisses (avec leur solde de bascule) et le crédit se chargent par les classeurs `06-Caisse` et `05-Credit` ; sans caisse, aucun dépôt espèces n'est possible après la migration.

**Ce que le setup pose déjà (inutile de le fournir)** : institution, agence siège, administrateur et profil « Administrateurs » (`ROLE_ADMIN`), devise principale, 6 devises, pays, types d'agence, types de zone, rôles applicatifs de chaque module, formats de numérotation, modèles de notification, plan comptable et journaux de la norme, rôles comptables de la norme `uemoa/rcs_sfd`, paramétrage comptable, configuration KYC, schémas comptables du client, types d'opération de caisse et coupures.

**Ce qui n'est pas posé et doit être fourni (si utile)**

| Module | Paramétrage | Feuille | Si absent |
|---|---|---|---|
| Commun | profils d'accès, banques | `Profils`, `Banques` | `Utilisateurs` refusés (profil inconnu) ; pas de référence de banque pour les comptes bancaires |
| Comptabilité | rôles comptables à surcharger, comptes bancaires, comptes mobile money | `RolesComptables`, `ComptesBancaires`, `ComptesMobileMoney` | virements/chèques refusés ; rôles `null` en `rcs_sfd` (ex. pénalité de retrait anticipé de DAT) non résolus |
| Client | types et barèmes de frais d'adhésion, frais de notification, parts sociales, dormance | `TypesFraisAdhesion`, `BaremesFraisAdhesion`, `TranchesFraisAdhesion`, `FraisNotification`, `ConfigPartsSociales`, `ConfigDormance` | aucun frais d'adhésion ; prélèvement des notifications en échec ; valeurs par défaut du code pour parts et dormance |
| Épargne | frais d'opération, seuils et limites, dormance, commissions de collecte | `FraisOperations`, `TranchesFraisOperation`, `SeuilsLimites`, `ParametrageDormance`, `CommissionsCollecte` | frais nuls en silence, aucune limite, job de dormance sans effet, pas de commission |

**Jours fériés** : générés automatiquement en fin de chargement du module commun (étape après chargement) pour le pays du siège, années de la date de bascule + 1 jour et suivante ; idempotent.

**Schémas comptables de l'épargne** : sur base vide, la table `schema_comptable_operation` n'est chargée qu'au redémarrage du service si l'institution existait au démarrage. Le lot la recharge **automatiquement** avant le chargement (même méthode que le démarrage) lorsqu'elle est vide. Si elle reste vide (institution sans organisation ou sans norme comptable, ou préférence indisponible), `import.erreur.schemas_comptables_absents` (bloquante) est posée sur la première ligne de `ProduitsEpargne` et de `ComptesEpargne` : configurer l'institution puis relancer la validation.

**Exercice comptable** : sur une installation neuve sans démo, le setup ne crée **pas** d'exercice : l'utilisateur l'ouvre lui-même en comptabilité. Exceptions : le wizard démo, et la migration (option `exercicesAuto`, §4 quater) qui génère l'exercice, les périodes et la journée de chaque agence à la date de bascule.

**Schémas comptables système** : chargés par le setup (`/setup/init` des modules épargne et caisse). Si la table est vide au moment du lot, le chargement épargne et caisse la recharge automatiquement avant d'écrire.

**Administrateurs** : les utilisateurs `ROLE_ADMIN` sont rattachés automatiquement à chaque agence créée par le lot (hors agence principale), pour pouvoir y travailler sans réaffectation manuelle.

**Dates de reprise** : toutes les lignes créées par le chargement (journée ouverte, pièces `A_NOUVEAU`, opérations de reprise, dossiers et échéances repris…) sont datées du **lendemain de la date de bascule** ; les dates métier du fichier (ouverture, décaissement, échéances) sont conservées. Les rôles comptables caisse/crédit restent ceux de la norme.

**Ordre de dépôt** (un classeur par module ; le moteur ordonne les feuilles selon leurs dépendances) :
1. `01-Parametrage` : `Devises` (si besoin), `Agences`, `Profils`, `Utilisateurs`, `Banques`
2. `02-Comptabilite` : `PlanComptable`, `RolesComptables`, `Journaux`, `ComptesBancaires`, `ComptesMobileMoney`, `BalanceOuverture`
3. `03-Clients` : paramétrages (`TypesFraisAdhesion`, `BaremesFraisAdhesion`, `TranchesFraisAdhesion`, `FraisNotification`, `ConfigPartsSociales`, `ConfigDormance`) puis `Gestionnaires`, `Clients`, `Groupes`, `MembresGroupe`, `Beneficiaires`, `PartsSociales`
4. `04-Epargne` : `ProduitsEpargne`, `ComptesGenerauxProduit`, `FraisOperations`, `TranchesFraisOperation`, `SeuilsLimites`, `ParametrageDormance`, `CommissionsCollecte`, puis `ComptesEpargne`, `Dat`, `Blocages`, `Tontines`, `ParticipantsTontine`
5. `06-Caisse` : `Caisses`, `ComptesDevise`, `Coupures`, `SeuilsOperation`, `TauxChangeCaisse`
6. `05-Credit` : paramétrages (`PRODUITS_CREDIT` … `PARAMETRAGE_COMPTABLE_CREDIT`) puis `DOSSIERS`, `ECHEANCES`, `GARANTIES`

Option de lot `compteReprise` (§4 quater) : compte d'attente de classe 47 du plan, absent de la balance (`471000` dans le jeu de test).

**Annulation** : la purge supprime les lignes créées par le lot et restaure les singletons (`ConfigPartsSociales`, `ConfigDormance`) et les rôles comptables modifiés à leur valeur d'origine (ou les supprime s'ils n'existaient pas). Les éléments déjà en base avant le lot (avertissement `existe_deja`) ne sont jamais modifiés ni purgés. Après annulation complète, la base revient à l'état post-wizard.

## 3. Cycle de vie d'un lot

Un lot a un code généré, un libellé, une date de bascule (date du dernier jour de l'ancien système) et les agences concernées (aucune sélection = toutes les agences). Un seul lot est actif à la fois (verrou global).

| Statut | Signification | Actions possibles |
|---|---|---|
| `CREE` | Lot créé, aucun fichier | Déposer des fichiers, annuler |
| `FICHIERS_RECUS` | Fichiers déposés | Déposer/supprimer, analyser, annuler |
| `ANALYSE_EN_COURS` | Lecture des fichiers vers le staging | Attendre |
| `ANALYSE` | Fichiers lus (types, longueurs, formats contrôlés) | Valider, retour aux fichiers, annuler |
| `VALIDATION_EN_COURS` | Règles métier en cours | Attendre |
| `VALIDE` | Aucune erreur bloquante | Importer, retour aux fichiers, annuler |
| `EN_ERREUR` | Au moins une erreur bloquante | Corriger les fichiers, revalider, annuler |
| `IMPORT_EN_COURS` | Chargement dans les modules (verrou posé) | Suspendre |
| `SUSPENDU` | Suspendu par l'opérateur, ou import interrompu par un arrêt du service | Reprendre (à la dernière ligne chargée), annuler |
| `IMPORTE` | Chargement terminé, verrou levé | Annuler (purge), clôturer |
| `ECHEC` | Échec technique (module injoignable, traitement interrompu) | Reprendre, retour aux fichiers, annuler |
| `ANNULATION_EN_COURS` | Contrôle puis purge en cours | Attendre (refus : retour au statut d'avant) |
| `ANNULE` / `CLOTURE` | Terminaux | Aucune |

Parcours type de l'assistant : 1 Paramètres (libellé, date de bascule, agences) → 2 Gabarits → 3 Fichiers → 4 Validation → 5 Import → 6 Contrôles post-import (réconciliation, rapport `.xlsx`, clôture du lot, §4 octies). L'import exige de **saisir le code du lot** dans la fenêtre de confirmation, et d'avoir pris connaissance des avertissements éventuels.

Au redémarrage du service : `IMPORT_EN_COURS` devient `SUSPENDU` (verrou conservé, reprise possible) ; `ANALYSE_EN_COURS`, `VALIDATION_EN_COURS`, `ANNULATION_EN_COURS` deviennent `ECHEC`.

## 4. Classeur `01-Parametrage`

Télécharger le gabarit à l'étape 2 (feuilles : `Instructions`, `Devises`, `Agences`, `Utilisateurs`, `Référentiels` avec listes déroulantes). Ligne 1 = en-têtes ; un `*` final, la casse, les accents, espaces, `_` et `-` sont ignorés dans les en-têtes. Colonnes inconnues ignorées (note), colonne obligatoire absente = erreur bloquante. Feuilles inconnues ignorées ; un classeur sans aucune feuille reconnue est rejeté.

**CSV** : nom `<Feuille>[_<CodeAgence>].csv` (ex. `Agences.csv`, `Utilisateurs_AG002.csv`), UTF-8, séparateur détecté (`;` par défaut, `,` ou tabulation).

### Devises (`Devises`, dépend de rien)
| Colonne | Oblig. | Règle |
|---|---|---|
| code | oui | 3 lettres majuscules (ISO 4217) |
| libelle | oui | 100 car. max |
| symbole | non | 10 car. (code si vide) |
| nombreDecimales | non | entier (0 si vide) |
| principale | non | booléen ; une seule devise principale, base comprise |

### Agences (`Agences`, après Devises)
| Colonne | Oblig. | Règle |
|---|---|---|
| code | oui | 20 car., unique |
| libelle | oui | 100 car. |
| typeAgence | oui | code d'un type d'agence existant (feuille Référentiels) |
| codeParent | non | agence parente, du classeur ou déjà en base ; rattachée après le chargement |
| codePays | oui | ISO alpha-2 majuscules, pays existant |
| dateOuverture | non | pas postérieure à la date de bascule |
| adresse, telephone, email | non | 255 / 30 / 100 car. ; e-mail au format valide |

Le sigle de l'agence reçoit son code (affiché « libellé (code) » dans Paramétrage commun).

### Utilisateurs (`Utilisateurs`, après Agences)
| Colonne | Oblig. | Règle |
|---|---|---|
| email | oui | identifiant de connexion, unique (insensible à la casse) |
| nom | oui | 100 car. |
| prenom, telephone | non | |
| profil | oui | nom d'un profil (groupe) existant. Les profils portant `ROLE_ADMIN` ou `ROLE_MIGRATION` sont refusés : attribuer ces droits ensuite dans Gestion des accès |
| agences | oui | codes séparés par des virgules |
| agencePrincipale | oui | doit figurer dans `agences` |

Rattachements : l'utilisateur créé reçoit exactement le profil et les agences du fichier ; toute ligne d'agence, de groupe ou de rôle laissée en base sur le même identifiant (ancien utilisateur supprimé) est effacée avant. Mot de passe : aléatoire, inconnu de tous. Une invitation par e-mail n'est envoyée que si l'option du lot `envoyerInvitations` vaut `true` ; sinon l'administrateur déclenche une réinitialisation de mot de passe.

### Codes d'erreur (affichés traduits dans la grille)
| Code | Gravité | Cause |
|---|---|---|
| `import.erreur.obligatoire` | bloquante | valeur obligatoire vide |
| `import.erreur.longueur` / `format` | bloquante | trop long / expression non respectée (code devise, pays, e-mail) |
| `import.erreur.type_entier` / `type_decimal` / `type_date` / `type_booleen` | bloquante | valeur non convertible |
| `import.erreur.decimal_ambigu` | bloquante | ex. `1,500` ou `12.345` (voir §5) |
| `import.erreur.enum` | bloquante | valeur hors liste |
| `import.erreur.entete_manquant` | bloquante | colonne obligatoire absente |
| `import.erreur.doublon` | bloquante | même clé plusieurs fois dans le lot (la 1re ligne est conservée) |
| `import.erreur.reference_inconnue` | bloquante | type d'agence, pays, parent, profil ou agence principale introuvable |
| `import.erreur.date_future` | bloquante | date postérieure à la date de bascule |
| `import.erreur.cycle_parente` | bloquante | agence parente d'elle-même |
| `import.erreur.devise_principale_multiple` | bloquante | plus d'une devise principale |
| `import.erreur.profil_interdit` | bloquante | profil d'administration/migration |
| `import.erreur.dataset_manquant` | avertissement | jeu de données dont dépend une feuille absent du lot (ex. `Devises` pour `Agences`) : les références sont vérifiées dans la base |
| `import.erreur.existe_deja` | avertissement | code ou e-mail déjà en base : ligne ignorée, jamais écrasée, jamais purgée |
| `import.erreur.chargement` | bloquante | échec à l'écriture (détail sous le message) |

Une erreur bloquante interdit « Passer à l'import ». Les avertissements doivent être acceptés (case à cocher). Export xlsx des erreurs depuis la grille (filtres appliqués : sévérité, dataset, fichier, ligne, colonne, code, valeur).

## 4 bis. Classeur `02-Comptabilite`

Ordre de dépôt : `01-Parametrage` (agences) d'abord, puis `02-Comptabilite`, puis `03-Clients`. Feuilles du gabarit : `Instructions`, `PlanComptable`, `Journaux`, `BalanceOuverture`, `Référentiels` (listes déroulantes). Mêmes règles d'en-têtes et de CSV que le §4 (`PlanComptable.csv`, `Journaux.csv`, `BalanceOuverture.csv`).

### Décisions de cadrage (rappel pour l'opérateur)
- **Numéros de comptes à la longueur du paramétrage** (`parametrage_comptabilite.longueur_compte_general`, 6 dans la démo Togo), chiffres seulement. Aucun complément de zéros n'est fait à l'import : un compte de 4 chiffres est refusé (`compte_longueur`). Compléter les numéros dans Excel avant le dépôt.
- **Exercices générés, pas de feuille dédiée.** Pour chaque agence du lot (aucune sélection = toutes les agences, y compris celles du même lot), l'import crée l'exercice de l'année de **J = date de bascule + 1 jour** (code = année, du 1er janvier au 31 décembre, `OUVERT`, exercice courant), les périodes mensuelles de janvier au mois de J (les mois antérieurs `CLOTUREE`, celui de J `OUVERTE`) et la journée comptable J `OUVERTE`. Une agence qui a déjà un exercice couvrant cette année, quel que soit son code (ex. `EX2026`), n'est pas touchée : son exercice courant reste courant (avertissement `exercice_existant`). Option du lot `exercicesAuto` = `false` : rien n'est généré.
- **Balance d'ouverture : validée mais non comptabilisée.** À cette itération, la balance est contrôlée (équilibre par agence, comptes mouvementables) et conservée en transit, mais **aucune pièce comptable n'est créée** : les soldes d'ouverture ne s'affichent donc pas encore en comptabilité. Les pièces d'à-nouveau seront générées à l'itération 3, après l'épargne, le crédit, le stock et les immobilisations.

### PlanComptable (aucune dépendance)
| Colonne | Oblig. | Règle |
|---|---|---|
| numeroCompte | oui | chiffres seulement, longueur du paramétrage comptable (15 max) |
| libelle | oui | 150 car. |
| classe | oui | `C1` à `C9` (ou le chiffre seul) ; doit être le 1er chiffre du numéro |
| nature | oui | `BILAN`, `GESTION`, `HORS_BILAN` |
| sens | oui | `DEBITEUR`, `CREDITEUR`, `MIXTE` |
| typeCompte | non | `RACINE`, `PRINCIPAL`, `DETAILLE`, `COLLECTIF`, `AUXILIAIRE` ; si vide, déduit des zéros de droite (1-2 chiffres significatifs = racine, 3-4 = principal, plus = détaillé) |
| compteParent | non | numéro du compte parent (classeur ou base) ; sinon le plus long préfixe existant |
| lettrable | non | défaut : oui pour les classes 2, 3, 4 hors racine |
| rapprochable | non | défaut : oui pour les préfixes 11 et 52 hors racine |
| actif | non | défaut : oui |

Un numéro déjà en base est ignoré (avertissement), jamais écrasé ni purgé. Le parent est rattaché après le chargement.

### Journaux (après PlanComptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeJournal | oui | majuscules, chiffres, `_` ; 5 car. max ; unique |
| libelle | oui | 50 car. |
| typeJournal | oui | `ACHAT`, `VENTE`, `TRESORERIE`, `BANQUE`, `CAISSE`, `OD`, `AN`, `A_NOUVEAUX`, `CLOTURE`, `OPERATIONS`, `INTEGRATION`, `EPARGNE`, `CREDIT`, `PAIE`… (liste du gabarit) |
| compteContrepartie | non | numéro du plan ou nom de rôle (ex. `CAISSE_SESSION`) ; **obligatoire pour une trésorerie** (banque, caisse, trésorerie) |
| prefixePiece | non | préfixe des numéros de pièces, unique entre journaux (code du journal si vide) |
| numerotation | non | mode de numérotation, défaut par période |
| devise | non | code d'une devise existante (devise principale si vide) |
| actif | non | défaut : oui |

Un format de numéro de pièce est créé pour chaque journal chargé. Un code déjà en base est ignoré (avertissement).

### BalanceOuverture (après PlanComptable et Agences)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeAgence | oui | agence du classeur 01 ou déjà en base |
| numeroCompte | oui | compte **mouvementable** (ni racine ni principal) |
| debit / credit | non | entiers positifs ; un seul des deux par ligne |
| libelle | non | 150 car. |

La balance doit être **équilibrée par agence** (somme des débits = somme des crédits). Une ligne à 0 est signalée (sans effet). Un compte ne figure qu'une fois par agence.

### Codes d'erreur propres au classeur 02
| Code | Gravité | Cause |
|---|---|---|
| `import.erreur.compte_longueur` | bloquante | numéro de longueur différente du paramétrage |
| `import.erreur.classe_incoherente` | bloquante | classe différente du 1er chiffre du numéro |
| `import.erreur.cycle_parente` | bloquante | compte parent cyclique ou égal au compte |
| `import.erreur.reference_inconnue` | bloquante | parent, agence, compte de contrepartie, compte de balance ou devise introuvable |
| `import.erreur.doublon` | bloquante | numéro de compte, code de journal ou compte de balance répété |
| `import.erreur.existe_deja` | avertissement | compte ou journal déjà en base : ligne ignorée |
| `import.erreur.prefixe_doublon` | bloquante | préfixe de pièce déjà pris par un autre journal |
| `import.erreur.contrepartie_obligatoire` | bloquante | journal de trésorerie sans compte de contrepartie |
| `import.erreur.compte_non_mouvementable` | bloquante | balance sur un compte racine ou principal |
| `import.erreur.montant_negatif` / `montant_non_entier` | bloquante | montant < 0 ou avec décimales |
| `import.erreur.debit_et_credit` | bloquante | débit et crédit sur la même ligne |
| `import.erreur.balance_desequilibree` | bloquante | écart débit − crédit non nul pour l'agence (affiché sur la 1re ligne de l'agence) |
| `import.erreur.montant_nul` | avertissement | ligne de balance à 0 |
| `import.erreur.exercice_existant` | avertissement | l'agence a déjà son exercice de l'année de bascule : aucun exercice créé |

### Annulation
Les comptes, journaux (et leurs formats de pièces) créés par le lot sont supprimés, ainsi que les exercices, périodes et la journée générés. **Refus** (voir section 7 : rien n'est supprimé, le lot revient à son statut d'avant) si un compte créé porte des écritures, a des comptes enfants hors lot, est utilisé par un journal, un compte auxiliaire ou un rôle comptable hors lot, si un journal créé porte des pièces, si une pièce ou une journée hors lot repose sur un exercice ou une période générés, si une clôture (journalière, mensuelle, annuelle) porte sur l'exercice, une période ou la journée générés, ou si un exercice suivant a pour exercice précédent un exercice généré.

## 4 ter. Classeur `03-Clients`

Feuilles du gabarit : `Instructions`, `Gestionnaires`, `Clients`, `Groupes`, `MembresGroupe`, `Beneficiaires`, `PartsSociales`, `Référentiels`. CSV : `Clients_<CodeAgence>.csv` (un fichier par agence pour les gros volumes), `Groupes.csv`, `MembresGroupe.csv`, etc.

### Décisions de cadrage
- **Numéros de clients générés par EDIP.** Le numéro EDIP (`CLI-…`, groupes `GRP-<année>-…`, comptes de parts `PS…`) suit le format de numérotation configuré et est attribué au chargement, par blocs, dans l'ordre des lignes. Formats supportés : `{prefix}`, `{year}`, `{month}`, `{day}`, `{sequence}` ; tout autre jeton arrête l'import avant écriture (`format_numero_non_supporte`).
- **L'ancien numéro est conservé** (`ancienNumeroClient` → champ numéro externe) et **sert à la recherche** : la fiche et la recherche client retrouvent un client par son ancien numéro.
- **KYC par défaut `VALIDE`** (clients déjà adhérents) ; niveau de risque `FAIBLE`, segment `STANDARD`, PEP non, si les colonnes sont vides.
- **Unicités** : ancien numéro unique dans le lot (clients et groupes confondus) et en base (bloquant) ; pièce d'identité (type + numéro) unique dans le lot et en base (bloquant) ; téléphone principal et e-mail en double : avertissement seulement.
- **Parts sociales sans historique de mouvements** : une ligne `ACTIVE` par client avec montants calculés (nominal × nombre de parts…) ; aucun mouvement ni écriture comptable n'est créé (l'historique des mouvements sera vide à l'écran).
- Aucun événement n'est émis (pas de notification, pas de création de compte), et aucun appel au service de création : chargement ensembliste.

### Gestionnaires (après Agences)
`code*` (20, conservé tel quel), `nom*`, `prenom*`, `codeAgence*`, `telephone`, `email`. Code en double dans le lot : bloquant ; déjà en base : avertissement (conservé, jamais purgé).

### Clients (après Agences)
| Colonne | Oblig. | Règle |
|---|---|---|
| ancienNumeroClient | oui | 50 car., unique (lot + base, groupes compris) |
| codeAgence | oui | agence du classeur 01 ou déjà en base |
| typeClient | oui | `PARTICULIER`, `PROFESSIONNEL`, `INSTITUTIONNEL`, `MEMBRE` (les groupes sont dans la feuille Groupes) |
| etatClient | oui | un des 9 états client (liste du gabarit), ex. `ACTIF` |
| nom | oui | 100 car. |
| prenom, nomJeuneFille | non | 100 car. |
| civilite, sexe, situationMatrimoniale | non | listes du gabarit |
| dateNaissance | non | antérieure à la date de bascule |
| typePiece, numeroPiece, dateEmissionPiece, dateExpirationPiece | non | (type, numéro) unique |
| adresse, quartier, ville, pays, lieuNaissance, nationalite, profession, employeur | non | longueurs du gabarit |
| telephonePrincipal, telephoneSecondaire, email | non | e-mail au format valide |
| revenuMensuel | non | décimal |
| raisonSociale, sigle, formeJuridique, numeroRccm, numeroIfu | non | `raisonSociale` obligatoire pour professionnel et institutionnel |
| dateAdhesion | non | au plus la date de bascule |
| codeGestionnaire | non | gestionnaire du classeur ou de la base (inconnu : avertissement) |
| statutKyc, niveauRisque, segmentClient, pep | non | défauts ci-dessus |

### Groupes (après Agences)
`ancienNumeroGroupe*` (unique, aussi parmi les clients), `codeAgence*`, `nomGroupe*`, `typeGroupe*`, `etatClient*`, `dateCreationGroupe`, `montantCotisation`, `periodiciteCotisation`, `objectif`, `dateAdhesion` (au plus la date de bascule). Un groupe est enregistré comme client de type `GROUPE` avec un numéro au format groupe.

### MembresGroupe (après Clients et Groupes)
`ancienNumeroGroupe*`, `ancienNumeroClient*`, `role*` (un seul président, un seul trésorier, un seul secrétaire par groupe, base comprise), `dateAdhesion*`, `numeroOrdre`, `montantCotisationSpecifique`. Un client ne peut être membre qu'une fois du même groupe. Un membre d'une autre agence que le groupe : avertissement. Après chargement, le nombre de membres et le bureau (président, trésorier, secrétaire) du groupe sont recalculés.

### Beneficiaires (après Clients)
`ancienNumeroClient*`, `nomBeneficiaire*`, `prenomBeneficiaire`, `lienParente*`, `pourcentageAttribution*` (> 0 et ≤ 100 ; le total par client devrait faire 100, sinon avertissement), `numeroPiece*`, `typePiece`, `dateNaissance`, `telephone`, `adresse`.

### PartsSociales (après Clients et Groupes)
`ancienNumeroClient*` (un seul compte de parts par client), `valeurNominale*` (entier > 0), `nombreParts*` (> 0), `nombrePartsBloquees` (≤ nombreParts, défaut 0), `dateSouscription*` (au plus la date de bascule).

### Codes d'erreur propres au classeur 03
| Code | Gravité | Cause |
|---|---|---|
| `import.erreur.doublon` | bloquante | ancien numéro répété (clients, groupes), membre ou part répétés |
| `import.erreur.existe_deja` | bloquante (avertissement pour les gestionnaires) | ancien numéro, membre ou compte de parts déjà en base |
| `import.erreur.reference_inconnue` | bloquante (avertissement pour un gestionnaire inconnu) | agence, groupe, client introuvable |
| `import.erreur.raison_sociale_obligatoire` | bloquante | professionnel/institutionnel sans raison sociale |
| `import.erreur.piece_doublon` | bloquante | (type, numéro) de pièce déjà utilisé |
| `import.erreur.telephone_doublon` / `email_doublon` | avertissement | téléphone principal ou e-mail déjà utilisé |
| `import.erreur.date_future` | bloquante | adhésion ou souscription après la date de bascule |
| `import.erreur.date_naissance_invalide` | bloquante | naissance à la date de bascule ou après |
| `import.erreur.montant_hors_limite` / `montant_non_entier` | bloquante | montant démesuré ou avec décimales |
| `import.erreur.role_unique` | bloquante | rôle de bureau déjà attribué dans le groupe |
| `import.erreur.membre_hors_agence` | avertissement | membre d'une autre agence que le groupe |
| `import.erreur.pourcentage_invalide` | bloquante | pourcentage ≤ 0 ou > 100 |
| `import.erreur.pourcentage_total` | avertissement | total des bénéficiaires d'un client différent de 100 |
| `import.erreur.nombre_parts_invalide` / `parts_bloquees_superieures` | bloquante | nombre de parts ≤ 0 ; parts bloquées au-delà du total |
| `import.erreur.format_numero_absent` / `format_numero_non_supporte` | bloquante | format de numérotation absent ou avec un jeton non géré (arrêt avant écriture) |

### Annulation
Les clients, groupes, membres, bénéficiaires, parts sociales et gestionnaires créés par le lot sont supprimés (les compteurs de numérotation ne sont pas remis en arrière). **Refus** (voir section 7 : rien n'est supprimé) si un client ou groupe du lot est référencé hors du lot (les membres, bénéficiaires et parts créés par le lot lui-même ne comptent pas) : comptes d'épargne, dossiers de crédit, comptes de tontine, cartes, procurations, documents, historiques d'état, vérifications d'identité, frais d'adhésion, alertes, transferts, départs, décès, dividendes, ou mouvements de parts sociales ; un gestionnaire créé par le lot n'est pas supprimable s'il est affecté à un client hors lot.

## 4 quater. Classeur `04-Epargne` et pièces d'à-nouveaux

Ordre de dépôt : `01-Parametrage`, `02-Comptabilite`, `03-Clients`, puis `04-Epargne`. Feuilles du gabarit : `ProduitsEpargne`, `ComptesGenerauxProduit`, `ComptesEpargne`, `Dat`, `Blocages`, `Tontines`, `ParticipantsTontine` (CSV du même nom acceptés ; `ComptesEpargne_<AG>.csv`, un fichier par agence, pour les gros volumes). Mêmes règles d'en-têtes qu'au §4.

### Décisions de cadrage
- **Montants et taux en nombres bruts** : `200000`, `2` pour 2 %. Les pourcentages Excel (cellule au format %) sont lus en valeur brute : une cellule affichant 15 % vaut `0,15`, pas `15`. Saisir le taux en nombre ordinaire (`15`) ou passer la colonne en format Standard. Montants entiers (pas de décimales, `decimal(18,0)`).
- **Numéros de compte, de DAT et de tontine : 30 caractères au plus** (25 pour `numeroDat`). `codeAgence` : 10 caractères ; `codeProduit` : 20 (10 pour la feuille `Tontines`).
- **Client** d'un compte, d'une tontine ou d'un participant : référencé par `ancienNumeroClient` (client ou groupe du lot, sinon client déjà en base par son ancien numéro). Client radié : refus sauf compte clôturé ; client non actif : avertissement.
- **Compte général** résolu par `ComptesGenerauxProduit` (produit + type de client, sinon produit seul). Types de client : `PARTICULIER`, `PROFESSIONNEL`, `GROUPE`, `INSTITUTIONNEL` ; `MEMBRE` est traité comme `PARTICULIER`. Aucun numéro de compte n'est en dur.
- **Solde stocké, jamais rejoué** : le solde d'ouverture est repris tel quel ; aucune opération de dépôt n'est simulée.

### ProduitsEpargne (aucune dépendance)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeProduit | oui | 20 car., unique |
| libelle | oui | 100 car. |
| typeProduit | oui | `DAV`, `DAT`, `PLANIFIEE`, `TONTINE`, `CAUTION` |
| devise | oui | devise en base ou dans le lot |
| typeTaux | non | `FIXE` seulement (défaut) ; `PALIER` / `PROGRESSIF` refusés |
| tauxInteret, periodiciteInterets, baseCalcul | non | défauts : 0, `ANNUEL`, 360 |
| dureeMinJours, dureeMaxJours | DAT, PLANIFIEE | cohérentes (min ≤ max) |
| montantMinimum, montantMaximum | non | min ≤ max |
| autoriserDecouvert, plafondDecouvert, tauxInteretsDebiteurs | non | ignorés pour `CAUTION` |
| validationRequise, renouvellementAutomatique | non | booléens |
| tontineMiseMin/Max, tontineParticipantsMin/Max | tontine | bornes contrôlées sur les tontines |

Un produit déjà en base : avertissement `existe_deja`, ligne ignorée. Les listes de modes/fréquences autorisés d'un produit `TONTINE` ne sont pas importées : à compléter dans le produit avant toute ouverture de tontine en ligne.

### ComptesGenerauxProduit (après ProduitsEpargne)
`codeProduit` (oui), `typeClient` (non, vide = tous), `numeroCompteGeneral` (oui, compte du plan en base ou du lot, 64 car.), `libelle` (oui, 150 car.). Ce compte devient le **compte collectif** des auxiliaires du produit.

### ComptesEpargne (après Clients, ProduitsEpargne, ComptesGenerauxProduit, Agences)
Produits `DAV`, `CAUTION` et `PLANIFIEE` (le plan de versement d'une épargne planifiée n'est pas repris : avertissement `plan_versement_non_repris`). Les produits `DAT` et `TONTINE` passent par leurs feuilles.
| Colonne | Oblig. | Règle |
|---|---|---|
| numeroCompte | oui | 30 car., unique (lot, comptes, DAT, tontines, auxiliaires déjà en base) |
| ancienNumeroClient | oui | client résolu comme ci-dessus |
| codeProduit | oui | produit actif de type DAV/CAUTION/PLANIFIEE |
| codeAgence | non | défaut : agence du client |
| statut | non | `ACTIF` (défaut), `SUSPENDU`, `BLOQUE`, `CLOTURE` |
| dateOuverture | oui | pas après la date de bascule |
| soldeOuverture | oui | entier ; négatif limité au découvert ; 0 si `CLOTURE` |
| decouvertAutorise, plafondDecouvert | non | défauts : ceux du produit |
| libelleCompte | non | 100 car. |
| dateDerniereOperation | non | défaut : date de bascule |
| dateCloture | non | `CLOTURE` seulement, défaut : date de bascule |

### Dat (après ComptesEpargne et ProduitsEpargne)
Colonnes : `numeroDat` (oui, 25 car.), `numeroCompte` (oui, compte source actif du lot ou de la base), `codeProduit` (oui, produit `DAT`), `montant` (oui, dans les bornes du produit), `tauxAnnuel` (non, défaut : taux du produit ; entre 0 et 100), `dateConstitution` (oui), `dureeJours` (oui, dans les bornes du produit), `capitalisation`, `renouvellement` (non). Le DAT est chargé `ACTIF`, son **échéancier** est généré par le service d'épargne (même calcul qu'en ligne) ; les **périodes déjà passées à la date de bascule sont marquées versées**.

### Blocages (après ComptesEpargne)
`numeroCompte` (oui), `typeBlocage` (oui : `PARTIEL` ou `COMPLET`), `montantBloque` (obligatoire et > 0 si `PARTIEL`, interdit si `COMPLET`), `motif` (oui, 500 car.), `reference`, `dateDebut` (oui), `dateFinPrevue`. Le solde bloqué n'est pas une colonne du compte : il découle des blocages.

### Tontines (après ProduitsEpargne, ComptesGenerauxProduit, Clients, Agences)
`numeroCompte`, `codeProduit` (produit `TONTINE`), `ancienNumeroClient` (client ou groupe principal), `modeTontine` (`COLLECTIF` : 2 à 30 participants principal compris ; `INDIVIDUEL` : aucun participant), `montantMise` (dans les bornes du produit), `frequenceMise`, `dateOuverture`, `soldeOuverture` (≥ 0) obligatoires ; `codeAgence`, `statut` facultatifs. Chargement : solde stocké, **cycle n°1** commençant au lendemain de la bascule ; **tontine clôturée ⇒ cycle n°1 clôturé** (fin = lendemain de la bascule). Aucune opération de tontine n'est créée.

### ParticipantsTontine (après Tontines et Clients)
`numeroCompte` (tontine du lot, mode `COLLECTIF`), `ancienNumeroClient`, `numeroOrdre` (oui, ≥ 1, contigus : au plus le nombre de participants secondaires), `montantTotalVerse` (non, ≥ 0), `aRecuCagnotte` (non). Le client principal n'est pas listé (ordre 0). Un client n'apparaît qu'une fois par tontine.

### Options du lot
Étape 1 de l'assistant (« Options ») ; exposées aux règles et au chargement.
| Option | Défaut | Effet |
|---|---|---|
| `compteReprise` | vide | Compte du plan (15 car. max) qui équilibre les pièces d'à-nouveaux. **Obligatoire dès que le lot contient des comptes, DAT ou tontines** (`compte_reprise_requis`), doit exister (`compte_reprise_inconnu`), détaillé et mouvementable, et **ne pas figurer dans la balance d'ouverture** (s'il y figure, son solde est absorbé par la ligne d'équilibre). |
| `ecartAuxiliairesBloquant` | non | `balance_ecart_auxiliaires` : si la somme des soldes des comptes du lot ≠ solde du collectif dans la balance, **avertissement** par défaut ; **erreur bloquante** si la case est cochée. |
| `exercicesAuto` | oui | Génère l'exercice et les périodes de l'agence si besoin. Si décoché, une période ouverte contenant le lendemain de la bascule est exigée (`periode_ouverte_absente`). |

### Pièces d'à-nouveaux (`A_NOUVEAU`)
Générées à la fin du chargement (phase finale « Génération des pièces d'à-nouveaux », idempotente : un rejeu après incident ne duplique rien), par agence ayant une balance d'ouverture.
- Date de pièce = **lendemain de la date de bascule**, dans la période ouverte de l'agence ; journal de type `AN` existant, sinon journal `AN` « A nouveaux » créé (retiré à l'annulation s'il a été créé par le lot) ; statut `COMPTABILISEE`, module source `MIGRATION`.
- **Une pièce par agence** (`AN<id du lot>-<agence>-1`) tant que ses lignes tiennent dans une tranche (`app.import.taille-tranche`) ; au-delà, pièce 1 = comptes non collectifs de la balance, puis **une pièce par tranche d'auxiliaires** (`-2`, `-3`…).
- Le compte **collectif** n'est pas repris depuis la balance : ses lignes sont celles des **comptes auxiliaires** (un par compte d'épargne, DAT ou tontine, code auxiliaire = numéro, crédit si solde > 0, débit si < 0 ; solde nul = auxiliaire créé sans ligne).
- Chaque pièce non équilibrée reçoit une **ligne de reprise** sur `compteReprise`. Si les soldes concordent avec la balance (Σ auxiliaires = collectif), le compte de reprise est **soldé** (somme nulle sur l'agence) ; sinon il porte exactement l'écart accepté, à solder par OD manuelle.
- Les soldes débit/crédit des auxiliaires sont recalculés depuis ces pièces.
- **Opération `REPRISE_SOLDE`** : pour chaque compte de solde ≠ 0, une opération validée et comptabilisée (type `REPRISE_SOLDE`, `REP-<code du lot>-<id>`, sens crédit si solde > 0, débit sinon, mode compensation, date = date de bascule) est créée et rattachée à la pièce `A_NOUVEAU` portant l'auxiliaire. Elle ne génère aucun message comptable. Le solde du compte est la somme de ses opérations validées (donc = solde d'ouverture).
- Les séquences de numérotation (comptes, DAT, tontines) sont recalées sur les numéros importés au format EDIP.

### Codes d'erreur propres au classeur 04
| Code | Gravité | Cause |
|---|---|---|
| `doublon` / `existe_deja` | bloquante | numéro répété dans le lot ou déjà en base (comptes, DAT, tontines, auxiliaires) ; participant, ordre répété |
| `reference_inconnue` | bloquante | client, produit, agence, compte source ou tontine introuvable |
| `client_radie` / `client_non_actif` | bloquante / avertissement | client radié (sauf compte clôturé) / non actif |
| `produit_inactif`, `produit_non_dat`, `produit_non_tontine` | bloquante | produit inactif ou de mauvais type |
| `valeur_non_supportee` | bloquante | produit à paliers/progressif, ou produit DAT/TONTINE sur la feuille ComptesEpargne |
| `plan_versement_non_repris` | avertissement | produit `PLANIFIEE` : plan de versement à saisir après import |
| `compte_general_introuvable` | bloquante | aucun compte général pour (produit, type de client) |
| `agence_invalide` | bloquante | agence effective inconnue ou de plus de 10 caractères |
| `date_future` | bloquante | ouverture, constitution après la date de bascule |
| `montant_non_entier`, `montant_negatif`, `montant_hors_bornes`, `solde_negatif` | bloquante | montants avec décimales, négatifs, hors bornes du produit |
| `decouvert_depasse` | bloquante | solde négatif au-delà du découvert/plafond |
| `cloture_solde_non_nul` | bloquante | compte ou tontine clôturé avec solde ≠ 0 |
| `compte_non_actif`, `dat_echu`, `duree_hors_bornes`, `taux_hors_bornes` | bloquante | DAT : compte source inactif, déjà échu à la bascule (non repris), durée ou taux hors bornes |
| `blocage_montant_incoherent` | bloquante | montant manquant (partiel) ou présent (complet) |
| `blocage_depasse_solde` | avertissement | blocages partiels supérieurs au solde |
| `mise_hors_bornes`, `participants_hors_bornes`, `tontine_individuelle`, `ordre_hors_plage` | bloquante | mise, nombre de participants, participants sur tontine individuelle, ordre hors plage |
| `balance_ecart_auxiliaires` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | Σ soldes des comptes du lot ≠ collectif de la balance |
| `compte_reprise_requis` / `compte_reprise_inconnu` | bloquante | option `compteReprise` absente ou inconnue |
| `periode_ouverte_absente` | bloquante | pas de période ouverte au lendemain de la bascule (`exercicesAuto` décoché) |
| `code_agence_trop_long` | bloquante | code agence ou numéro de pièce trop long pour la pièce `AN` |

### Annulation
Supprimés : comptes, opérations de reprise, historiques, DAT et échéanciers, blocages, tontines (cycles, participants), comptes auxiliaires créés par le lot, pièces `A_NOUVEAU` et journal `AN` créé par le lot. **Refus** (rien n'est supprimé, voir §7) dès qu'une donnée hors lot repose sur un compte importé : opération (par exemple un dépôt en caisse), procuration, bénéficiaire, garantie, affectation d'agent, blocage ou historique d'un autre opérateur, DAT hors lot, opération/collecte/cycle suivant/participant ajouté sur une tontine, ligne de pièce hors lot, rapprochée ou régularisée sur un auxiliaire importé. Contre-passer ou supprimer ces données puis relancer l'annulation. Les compteurs de numérotation ne sont pas remis en arrière.

### Limites connues
- **DAT échus** à la date de bascule et **produits à paliers/progressifs** refusés : à saisir après import.
- **Plan de versement** d'une épargne planifiée non repris.
- Participant principal d'une tontine sans total versé : le total du cycle n°1 ignore ses mises.
- Pas de colonne de solde bloqué ; liste des modes/fréquences d'un produit tontine à compléter.

## 4 quinquies. Paramétrages des modules (commun, comptabilité, client, épargne)

Règles communes à toutes les feuilles de cette section (patron des itérations 2-3) :
- Une ligne dont le code/clé existe **déjà en base** est signalée par l'avertissement `import.erreur.existe_deja`, **n'est pas chargée** et n'est jamais purgée (la base existante n'est pas écrasée). Exceptions : les singletons (`ConfigPartsSociales`, `ConfigDormance`) et `RolesComptables` **remplacent** la valeur existante ; l'ancienne valeur est conservée et restaurée à l'annulation.
- Un doublon dans le lot est une erreur bloquante (`import.erreur.doublon`, la 1re ligne est conservée).
- Valeurs fermées (colonne `enum` du gabarit) : `import.erreur.enum` si la valeur est hors liste. Booléens `oui`/`non` (défaut indiqué). Montants **entiers** ≥ 0 (`montant_non_entier`, `montant_hors_limite`). Dates `dd/MM/yyyy`.
- **Aucun numéro de compte n'est en dur** : toute colonne de compte désigne un compte **mouvementable** (type `DETAILLE`) du plan, présent dans le lot ou déjà en base (`reference_inconnue`, `compte_non_mouvementable`). Un nom de rôle comptable n'est pas accepté à la place d'un numéro.
- Les références (agence, produit, journal, banque, type de frais) sont cherchées dans le lot puis en base.

### Profils (`Profils`, classeur 01, avant Utilisateurs)
| Colonne | Oblig. | Règle |
|---|---|---|
| nom | oui | nom du profil (groupe d'accès), unique, 100 car. |
| libelle | non | description, 255 car. (nom si vide) |
| roles | oui | rôles existants séparés par `;` (liste « Référentiels ») |

Restrictions : sont refusés, avant toute création, les rôles privilégiés `ROLE_ADMIN` et `ROLE_MIGRATION` (`import.erreur.profil_interdit`) et tous les rôles de gestion des accès (préfixes `ROLE_USER`, `ROLE_ROLE`, `ROLE_GROUPROLE`, `ROLE_PREFERENCE_UTILISATEURAGENCE`) ; un rôle inconnu est refusé (`reference_inconnue`). Les droits d'administration s'attribuent ensuite dans Gestion des accès. `Utilisateurs.profil` accepte les profils du lot ou de la base. Purge : un profil du lot encore utilisé par un utilisateur hors lot bloque l'annulation.

### Banques (`Banques`, classeur 01)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeBanque | oui | 20 car., unique |
| libelle | oui | 150 car. |
| codePays | non | ISO alpha-2, pays existant (`reference_inconnue`) |
| swift | non | 8 ou 11 caractères `A-Z0-9` |

Purge : une banque du lot référencée par un compte bancaire hors lot bloque l'annulation.

### RolesComptables (classeur 02, après PlanComptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| role | oui | rôle comptable connu (enum `RoleComptable` : CAISSE, BANQUE, MOBILE_MONEY, COMPTE_VUE, DEPOT_A_TERME, PENALITE_RETRAIT_ANTICIPE_DAT, GAIN_CHANGE…) |
| numeroCompte | oui | compte mouvementable du plan |

Met à jour la ligne existante de la norme de l'institution (ou l'insère), source `ADMIN`. À utiliser pour les rôles laissés à `null` par la norme `rcs_sfd` quand le plan a un compte adapté. Si la norme de l'institution est introuvable : `import.erreur.norme_indisponible`. Purge : restauration exacte de la valeur d'origine ; bloquée si le rôle a été modifié depuis l'import.

### ComptesBancaires (classeur 02, après PlanComptable, Journaux, Agences, Banques)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeBanque | oui | banque du lot ou de la base |
| libelleCompte | oui | 200 car. |
| numeroCompte | oui | 50 car., unique |
| iban | non | 34 car. |
| codeAgence | oui | agence du lot ou de la base |
| deviseCode | non | devise principale si vide |
| compteComptable | oui | compte mouvementable du plan |
| codeJournal | oui | journal de trésorerie du lot ou de la base |
| typeCompte | non | `COURANT` (défaut), `EPARGNE`, `DEPOT_A_TERME`, `PLACEMENT` |
| actif | non | oui |

Purge : bloquée si une opération bancaire ou un rapprochement hors lot référence le compte.

### ComptesMobileMoney (classeur 02)
Mêmes règles, colonnes : `codeOperateur` (oui ; `ORANGE`, `MTN`, `MOOV`, `WAVE`, `AIRTEL`, `MPESA`, `AUTRE`), `libelleCompte` (oui), `numeroCompte` (oui, unique), `codeAgence` (oui), `deviseCode`, `compteComptable` (oui), `codeJournal` (oui), `actif`. Pas de colonne banque.

### TypesFraisAdhesion (classeur 03, avant Clients)
| Colonne | Oblig. | Règle |
|---|---|---|
| code | oui | 30 car., unique |
| libelle | oui | 100 car. |
| description | non | 500 car. |
| categorie | oui | `DROIT_ADHESION`, `PART_SOCIALE`, `FRAIS_DOSSIER`, `CARNET_EPARGNE`, `CARTE_MEMBRE`, `TIMBRE_FISCAL`, `COTISATION_ANNUELLE`, `AUTRE` |
| remboursable, obligatoire, paiementFractionneAutorise | non | défauts non, oui, non |
| compteComptableDebit, compteComptableCredit | non | comptes mouvementables du plan (encaissement ; produit ou capital) |
| codeJournal | non | journal du lot ou de la base |
| ordre | non | entier, défaut 0 |
| actif | non | oui |

### BaremesFraisAdhesion (après TypesFraisAdhesion)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeBareme | oui | code libre, **unique dans le classeur** : relie les tranches |
| codeTypeFrais | oui | type du lot ou de la base |
| codeAgence | non | vide = toutes les agences |
| typeClient | non | `TypeClient` hors `GROUPE` ; vide = tous |
| segmentClient | non | `STANDARD`, `SILVER`, `GOLD`, `PLATINUM`, `GROUPE`, `INSTITUTIONNEL` ; vide = tous |
| modeCalcul | oui | `FIXE` (montantFixe obligatoire), `POURCENTAGE` (pourcentage dans ]0 ; 100] obligatoire, montantMinimum/montantMaximum facultatifs), `PALIER` (tranches obligatoires) |
| montantFixe, pourcentage, montantMinimum, montantMaximum | selon le mode | entiers sauf pourcentage |
| montantReference | non | `NONE` (défaut), `REVENU_MENSUEL`, `CAPITAL_SOCIAL` : base du pourcentage ou des tranches |
| nombrePartsMinimum, nombrePartsMaximum, valeurNominalePart | non | catégorie `PART_SOCIALE` (min défaut 1, max 0 = illimité) |
| dateDebut | oui | début de validité |
| dateFin | non | pas antérieure à dateDebut (`periode_invalide`) |
| compteComptableCredit, codeJournal | non | surchargent ceux du type de frais |
| actif | non | oui |

Deux barèmes de même portée (type, agence, typeClient, segment, dateDebut) dans le lot : `doublon` ; portée déjà en base : `existe_deja` (non chargé). Mode incohérent avec les valeurs : `import.erreur.mode_calcul_incoherent`.

### TranchesFraisAdhesion (feuille fille, après BaremesFraisAdhesion)
**Une ligne par tranche** : `codeBareme` (oui, barème PALIER de la feuille précédente), `montantMin` (oui, borne basse incluse), `montantMax` (non, borne haute incluse ; **vide = sans limite**, réservé à la dernière tranche), `montant` (oui, frais de la tranche). Les tranches d'un même barème ne se chevauchent pas et ont `montantMax ≥ montantMin` ; sinon `import.erreur.tranches_incoherentes`. Un barème PALIER sans tranche valide n'est pas créé (même code d'erreur) ; une tranche n'est chargée que si son barème l'est. Les tranches sont écrites dans le barème au chargement (pas de table propre : la purge du barème les emporte).

### FraisNotification (classeur 03)
| Colonne | Oblig. | Règle |
|---|---|---|
| canal | oui | `SMS`, `EMAIL`, `PUSH` |
| codeAgence | non | vide = tarif par défaut de toutes les agences ; (canal, agence) unique |
| montantFrais | oui | entier ≥ 0, frais mensuel |
| codeDevise | non | devise principale si vide |
| description | non | 255 car. |
| compteProduit | oui | compte de produit mouvementable (pas de repli : sans lui le prélèvement échoue) |
| codeJournal | oui | journal du lot ou de la base |
| actif | non | oui |

Purge : bloquée si des souscriptions de ce canal/agence ont déjà été prélevées.

### ConfigPartsSociales et ConfigDormance (singletons, classeur 03, **une seule ligne**)
`ConfigPartsSociales` : `valeurNominale` (> 0), `nombreMinimum` (≥ 1), `nombreMaximum` (≥ nombreMinimum), `plafondTotal`, `tauxRemunerationMax` (0 à 100), `periodeRemboursement` (jours, > 0) toutes obligatoires ; `actif`. Incohérence : `nombre_parts_invalide`, `montant_hors_limite`, `valeur_hors_bornes`. La valeur nominale doit être cohérente avec `PartsSociales.valeurNominale`.
`ConfigDormance` : `seuilJours` (oui, > 0, `valeur_hors_bornes` sinon), `notifierClient` (non, défaut non).
Chaque ligne remplace la configuration existante, restaurée (ou supprimée si elle n'existait pas) à l'annulation. Deux lignes : `doublon`.

### FraisOperations (classeur 04, après ProduitsEpargne et PlanComptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| code | oui | 50 car., unique ; l'identifiant technique est généré (préfixe `MF`) |
| libelle | oui | 100 car. |
| codeProduit | oui | produit du lot ou de la base |
| codeTypeOperation | oui | `TypeOperationEpargne` : OUVERTURE, DEPOT, RETRAIT, VIREMENT_ENTRANT, VIREMENT_SORTANT, VIREMENT, INTERET_CREDIT, INTERET_DEBIT, FRAIS_GESTION, TENUE_COMPTE, ADMINISTRATIF, FRAIS_NOTIFICATION, CLOTURE, RETRAIT_ANTICIPE, REPRISE_SOLDE, REGULARISATION, VERSEMENT_PLANIFIE |
| typeClient | non | `PARTICULIER`, `PROFESSIONNEL`, `GROUPE`, `INSTITUTIONNEL` ; vide = tous |
| codeAgence | non | vide = toutes |
| modeCalcul | oui | `FIXE` (montantFixe), `POURCENTAGE` (pourcentage dans ]0 ; 100], montantMinimum/montantMaximum facultatifs), `PALIER` (tranches) |
| compteComptableCredit | non | compte de produit mouvementable ; vide = compte du schéma comptable du module |
| dateDebut | non | défaut : date de bascule |
| dateFin | non | `periode_invalide` si antérieure à dateDebut |
| actif | non | oui |

### TranchesFraisOperation (feuille fille)
`codeFrais` (oui, frais PALIER), `montantMin` (oui), `montantMax` (non ; vide = sans limite, dernière tranche), `frais` (oui). Mêmes règles de tranches que `TranchesFraisAdhesion` (`tranches_incoherentes`, rien n'est créé pour un frais PALIER sans tranche valide). Pas de contrôle de purge : les opérations ne mémorisent pas le frais appliqué.

### SeuilsLimites (classeur 04)
| Colonne | Oblig. | Règle |
|---|---|---|
| code, libelle | oui | 50 / 100 car. ; code unique (id technique préfixe `MS`) |
| codeProduit | oui | produit du lot ou de la base |
| typeOperation | oui | `TypeSeuilOperation` : SOLDE_MINIMUM, SOLDE_MAXIMUM, DEPOT_MINIMUM/MAXIMUM, RETRAIT_MINIMUM/MAXIMUM, VIREMENT_MINIMUM/MAXIMUM, DEPOT_JOURNALIER, RETRAIT_JOURNALIER… (liste complète dans le gabarit) |
| typeClient, codeAgence | non | vide = tous / toutes |
| montantMinimum, montantMaximum, montantJournalier, montantMensuel | non | entiers ≥ 0 ; `montants_incoherents` si minimum > maximum |
| niveauValidationRequis | non | `CAISSIER`, `SUPERVISEUR`, `DIRECTEUR_AGENCE` |
| montantSeuilValidation | non | entier |
| description | non | 500 car. |
| alerte, bloquant | non | défauts non, non |
| dateDebut / dateFin | non | défaut bascule / vide ; `periode_invalide` |
| actif | non | oui |

### ParametrageDormance (classeur 04)
Toutes colonnes facultatives : `codeProduit` (10 car., vide = tous les produits), `codeAgence` (10 car.), `delaiAlerteMois` (6), `delaiDormantMois` (12), `delaiDesherenceMois` (120), `delaiDesactivationMois`, `actionDesactivation` (`SUSPENDRE`, `BLOQUER`, `CLOTURER`), `actionDormant` (`AUCUNE`, `NOTIFIER`, `SUSPENDRE` défaut, `BLOQUER`, `GELER`), `notifierClient` (oui), `delaiNotificationJours` (30), `appliquerFrais` (non), `fraisMensuel` (0), `soldeMinimumFrais` (0), `reactivationAuto` (oui), `fraisReactivation` (0), `actif`, `description`. Délais strictement positifs et croissants (alerte ≤ dormant ≤ déshérence) sinon `valeur_hors_bornes`. Une portée (produit, agence) déjà en base : `existe_deja`.

### CommissionsCollecte (classeur 04, optionnel)
`code` (oui, 20 car.), `libelle` (oui), `typeCommission` (oui : `POURCENTAGE_MONTANT`, `FORFAIT_PAR_COLLECTE`, `MIXTE` ; les paliers ne sont pas repris, à saisir dans l'écran), `typeOperation` (oui), `tauxPourcentage` (**fraction** : `0.02` = 2 %, dans ]0 ; 1], obligatoire pour POURCENTAGE_MONTANT et MIXTE), `montantForfait` (FORFAIT_PAR_COLLECTE et MIXTE), `commissionMin`, `commissionMax`, `plafondMensuel`, `codeAgence`, `dateDebut`, `dateFin`, `actif`. Incohérence de type : `mode_calcul_incoherent`.

### Codes d'erreur propres aux paramétrages
| Code | Gravité | Cause |
|---|---|---|
| `import.erreur.mode_calcul_incoherent` | bloquante | FIXE sans montant, POURCENTAGE sans pourcentage valide, type de commission sans taux/forfait |
| `import.erreur.tranches_incoherentes` | bloquante | barème/frais PALIER sans tranche valide, bornes inversées, chevauchement ; avertissement si la tranche vise un barème qui n'est pas PALIER |
| `import.erreur.periode_invalide` | bloquante | dateFin antérieure à dateDebut |
| `import.erreur.valeur_hors_bornes` | bloquante | délai, seuil ou taux hors des bornes admises (dormance, parts sociales) |
| `import.erreur.montant_hors_limite` / `montant_non_entier` | bloquante | montant négatif ou non entier |
| `import.erreur.norme_indisponible` | bloquante | norme comptable de l'institution introuvable pour `RolesComptables` |
| `import.erreur.schemas_comptables_absents` | bloquante | schémas comptables de l'épargne vides et non rechargeables (institution incomplète) |
| `import.erreur.reference_inconnue` / `compte_non_mouvementable` | bloquante | agence, produit, journal, banque, type de frais, compte ou rôle introuvable / compte de regroupement |
| `import.erreur.profil_interdit` | bloquante | profil contenant `ROLE_ADMIN`, `ROLE_MIGRATION` ou un rôle de gestion des accès |
| `import.erreur.existe_deja` | avertissement | clé déjà en base : ligne ignorée, jamais écrasée ni purgée |

Limites : les paramétrages du crédit et de la caisse sont dans leurs classeurs (§4 sexies, §4 septies) ; les règles SQL du client, de l'épargne et de la comptabilité lisent les tables `plan_comptable`, `journal`, `agence`, `institution` (monolithe ou base partagée).

## 4 sexies. Classeur `06-Caisse` (module caisse, ordre 500)

Ordre de dépôt : après `01-Parametrage` et `02-Comptabilite` (agences, devises, utilisateurs, plan comptable, balance). Feuilles du gabarit, dans l'ordre de chargement : `Caisses`, `ComptesDevise`, `Coupures`, `SeuilsOperation`, `TauxChangeCaisse`. Mêmes règles d'en-têtes qu'au §4 : `CODE_CAISSE` et `codeCaisse` désignent la même colonne (le gabarit écrit la forme camelCase).

### Décisions de cadrage
- **Caisses seules, aucune session** : le chargement ne crée ni session, ni opération, ni mouvement de caisse. L'encaisse à la bascule est portée par la colonne `soldeBascule`.
- **Solde de bascule = solde hors session** de la caisse. À la première ouverture de session après la migration, les guichets sont pré-remplis avec ce solde (comme une caisse fermée la veille), puis le billetage habituel s'applique.
- **Compte auxiliaire par caisse** : le code de la caisse devient le code du compte auxiliaire, rattaché au collectif `compteComptable` (57x). Les pièces `A_NOUVEAU` portent l'encaisse sur cet auxiliaire (§4 quater).
- **Devise** : un solde de bascule n'est accepté que dans la devise principale de l'institution.
- Aucune ligne n'émet de message comptable ; les lignes chargées portent `created_by = MIGRATION:<code du lot>`.

### Caisses (après Agences, Devises, Utilisateurs, PlanComptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| codeCaisse | oui | 30 car., unique dans le lot (`CAISSE_DOUBLON`), absent de la base caisse et des codes auxiliaires (`CAISSE_EXISTE_DEJA`) |
| libelle | oui | 100 car. |
| typeCaisse | oui | `COF` (coffre), `CPR` (caisse principale), `GUI` (guichet) ; `MOB`, `DAB`, `CPT` acceptés |
| codeAgence | oui | agence en base ou du lot 01 (`CAISSE_AGENCE_INCONNUE`) |
| compteComptable | oui | collectif du plan (57x), 15 chiffres max, en base ou lot 02 (`CAISSE_COMPTE_INCONNU`) |
| devise | oui | devise en base ou du lot 01 (`CAISSE_DEVISE_INCONNUE`) |
| billetageObligatoire | non | booléen, défaut non |
| loginResponsable | non | e-mail d'un utilisateur en base ou du lot 01 (`CAISSE_RESPONSABLE_INCONNU`) ; vide = aucun responsable |
| soldeBascule | non | entier ≥ 0 ; vide = pas de solde ; refusé hors devise principale (`CAISSE_SOLDE_DEVISE_ETRANGERE`) |
| codeCaisseParent | non | caisse du lot ou en base (`reference_inconnue`) |
| compteLiaison, compteAnnulation | non | compte du plan (`CAISSE_COMPTE_INCONNU`) |
| plafondEncaisse, seuilAlerteHaut, seuilAlerteBas, plafondOperation | non | décimaux ≥ 0 |
| actif | non | booléen, défaut oui |

### ComptesDevise (après Caisses)
`codeAgence` (oui), `codeCaisse` (non, vide = compte par défaut de l'agence), `devise` (oui), `numeroCompte` (oui, compte du plan en base ou du lot, ou auxiliaire existant), `libelle`, `actif`. Doublon (agence, caisse, devise) : bloquant ; déjà en base : avertissement, ligne conservée telle quelle.

### Coupures
`devise`, `valeurFaciale` (> 0), `typeCoupure` (`BILLET` / `PIECE`), `libelle` (50 car.), `ordreAffichage` (entier) obligatoires ; `actif`. Coupure déjà présente (dont les coupures XOF posées au démarrage) : avertissement, conservée.

### SeuilsOperation
`typeOperation` (oui, code d'un type d'opération de caisse), `codeAgence` (vide = toutes), `devise` (oui), `seuilBilletage`, `seuilDoubleValidation`, `montantMinimum`, `montantMaximum`, `seuilDeclarationCentif`, `seuilCumulJournalierClient`, `plafondJournalierCaissier`, `plafondJournalierClient` (décimaux ≥ 0, vide = pas de contrôle), `description` (500 car.), `actif`. Existant (type, agence, devise) : avertissement, conservé.

### TauxChangeCaisse
`deviseSource`, `deviseCible`, `taux` (> 0) obligatoires ; `tauxAchat`, `tauxVente`, `tauxMoyen`, `dateApplication` (défaut : date de bascule), `dateFinValidite`, `actif`. Un taux à exactement 3 décimales est ambigu (`decimal_ambigu`, §5) : écrire `655.9570`. Existant (couple, date) : avertissement, conservé.

### Cohérence avec la balance
- Contrôle `BALANCE_ECART_AUXILIAIRES` : par (agence, `compteComptable`), Σ soldes de bascule des caisses ≠ solde débiteur du compte dans `BalanceOuverture` → **avertissement**, **bloquant** si l'option `ecartAuxiliairesBloquant` est cochée. Un groupe sans aucun solde renseigné n'est pas contrôlé.
- Projection auxiliaire : une ligne par caisse chargée (`module=CAISSE`, `dataset=CAISSES`, collectif = `compteComptable`, code = `codeCaisse`, solde = −`soldeBascule`, débiteur). Pour un jeu cohérent : solde du 57x de l'agence dans la balance = Σ `soldeBascule` des caisses de ce collectif, au débit.

### Codes d'erreur propres au classeur 06
| Code | Gravité | Cause |
|---|---|---|
| `CAISSE_DOUBLON` | bloquante | code caisse répété dans le lot |
| `CAISSE_EXISTE_DEJA` | bloquante | code déjà utilisé par une caisse ou un compte auxiliaire en base |
| `CAISSE_AGENCE_INCONNUE` | bloquante | agence absente de la base et du lot |
| `CAISSE_COMPTE_INCONNU` | bloquante | compte comptable, de liaison ou d'annulation absent du plan |
| `CAISSE_RESPONSABLE_INCONNU` | bloquante | e-mail du responsable sans utilisateur |
| `CAISSE_DEVISE_INCONNUE` | bloquante | devise absente |
| `CAISSE_SOLDE_DEVISE_ETRANGERE` | bloquante | solde de bascule sur une caisse hors devise principale |
| `balance_ecart_auxiliaires` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | Σ soldes des caisses ≠ 57x de la balance |

### Annulation
Supprimés : caisses et paramétrages (comptes par devise, coupures, seuils, taux) créés par le lot, comptes auxiliaires des caisses ; les éléments déjà en base ne sont pas touchés. **Refus** si une opération de caisse postérieure référence une caisse du lot (par exemple un premier dépôt) : le motif s'affiche sur l'écran du lot (§7) ; contre-passer ou supprimer l'opération, puis relancer.

## 4 septies. Classeur `05-Credit` (module crédit, ordre 600)

Ordre de dépôt : après `03-Clients` et `04-Epargne` (clients, comptes de prélèvement, comptes de caution). Feuilles, dans l'ordre de chargement : paramétrages `PRODUITS_CREDIT`, `COMPTES_TERME_PRODUIT`, `COMPTES_CLASSE_PRODUIT`, `TYPES_GARANTIE`, `CONFIG_COMPTES_GARANTIE`, `PRODUITS_GARANTIES`, `BAILLEURS`, `SOURCES_FINANCEMENT`, `FRAIS_CREDIT`, `PENALITES_PRODUIT`, `GRILLE_SCORING`, `PARAMETRE_COMITE`, `ORDRE_REMBOURSEMENT`, `PARAMETRAGE_COMPTABLE_CREDIT`, puis l'encours `DOSSIERS`, `ECHEANCES`, `GARANTIES`. Nom de feuille = code du dataset ; en-têtes en MAJUSCULES_SNAKE (casse, accents, `_` et `*` final ignorés). Référence complète des colonnes : `sfd-credit-service/src/main/resources/import/credit/COLONNES.md`.

### Décisions de cadrage
- **Encours seul** à la date de bascule : dossier, compte crédit (`AUXCR-…`), échéances **non soldées**, garanties actives, provision. **Aucun historique de remboursement** n'est repris ; une échéance `PAYEE` est ignorée (avertissement).
- **Σ échéances = capital restant dû** : Σ capital des échéances `PREVUE` + `IMPAYEE` + reste des `PARTIELLE` (capital − max(0, montant payé − intérêt)) doit égaler `CAPITAL_RESTANT_DU` du dossier (`ECHEANCES_SOMME_CRD`, bloquante).
- **Cautions financières** : le compte de caution est un compte d'épargne du classeur 04 (ou de la base) d'un produit caution ; le montant bloqué est repris tel quel (pas de nouvelle constitution), dans la limite du solde du compte.
- **Codes** : un type de garantie est désigné par son **libellé** ; un bailleur par son nom. Un produit, type, bailleur ou paramétrage déjà présent est réutilisé (avertissement), jamais modifié.
- **Comptes** : aucun compte en dur ; le compte de créance d'un dossier est `COMPTE_CREANCE_SOUFFRANCE` du terme si `SOUFFRANCE_COMPTABLE` = oui, sinon `COMPTE_CREANCE_SAIN` (feuille `COMPTES_TERME_PRODUIT`).
- Aucun message comptable émis ; lignes chargées marquées `MIGRATION:<code du lot>` (`cree_par`).

### Paramétrages (feuilles 1 à 14)
| Feuille | Clé | Contenu | Dépend de |
|---|---|---|---|
| `PRODUITS_CREDIT` | `CODE_PRODUIT` | libellé, terme (`TYPE_CREDIT`), bornes montant/durée, taux annuel, méthode d'intérêts, périodicité, type de taux, frais, assurance, pénalités, épargne préalable, seuil comité, plafond de délégation, groupe solidaire, comptes principal/intérêts/frais (défaut : comptes du terme) | — |
| `COMPTES_TERME_PRODUIT` | produit + terme | créance saine, créance en souffrance, intérêts (obligatoires), intérêts courus, pénalités, perte | produits, plan |
| `COMPTES_CLASSE_PRODUIT` | produit + classe | comptes principal, provision, dotation, reprise et taux de provision par classe (`SAIN` … `COMPROMIS`) | produits, plan |
| `TYPES_GARANTIE` | libellé | catégorie (`PERSONNELLE`, `MOBILIERE`, `IMMOBILIERE`, `FINANCIERE`), décote, expertise, documents, validité | — |
| `CONFIG_COMPTES_GARANTIE` | type + type de client | compte comptable des garanties financières (type de client vide = défaut) | types, plan |
| `PRODUITS_GARANTIES` | produit + type | garanties acceptées, obligatoire, couverture minimale, produit d'épargne des cautions | produits, types, produits épargne |
| `BAILLEURS` / `SOURCES_FINANCEMENT` | nom / libellé | bailleurs et lignes de financement | — / bailleurs |
| `FRAIS_CREDIT` | `CODE` | type de frais, mode de calcul, moment de prélèvement, produit (vide = commun), compte de produits | produits, plan |
| `PENALITES_PRODUIT` | libellé + type | modèle de pénalité (une ligne par produit rattaché) | produits, plan |
| `GRILLE_SCORING` | grille / catégorie / critère | une ligne par barème | — |
| `PARAMETRE_COMITE` | singleton | quorum, validité des décisions (ignoré si déjà paramétré) | — |
| `ORDRE_REMBOURSEMENT` | portée (+ produit) | ordre d'imputation pénalités / intérêts / capital | produits |
| `PARAMETRAGE_COMPTABLE_CREDIT` | type d'opération | journal et mode de comptabilisation (`DECAISSEMENT`, `PAIEMENT`, `PROVISION`, `PAIEMENT_FRAIS`) | journaux |

### DOSSIERS (après Clients, Agences, PRODUITS_CREDIT, COMPTES_TERME_PRODUIT)
| Colonne | Oblig. | Règle |
|---|---|---|
| NUMERO_DOSSIER | oui | 20 car., conservé, unique (`DOSSIER_DOUBLON`, `DOSSIER_EXISTE_DEJA`) |
| ANCIEN_NUMERO_CLIENT | oui | client du lot ou en base (`DOSSIER_CLIENT_INCONNU`) |
| CODE_PRODUIT | oui | produit du lot ou en base (`DOSSIER_PRODUIT_INCONNU`) |
| CODE_AGENCE | non | défaut : agence du client |
| MONTANT_ACCORDE, TAUX, DUREE_MOIS | oui | montant décaissé, taux annuel en %, durée en mois |
| DATE_DECAISSEMENT | oui | au plus tard la date de bascule |
| STATUT | oui | `DECAISSE`, `EN_COURS`, `EN_RETARD`, `IMMOBILISE`, `DOUTEUX`, `CONTENTIEUX`, `RESTRUCTURE`, `SOLDE` (`DOSSIER_STATUT_INVALIDE`) ; `SOLDE` exige un reste dû nul (`DOSSIER_SOLDE_RESTE_DU`) |
| CAPITAL_RESTANT_DU | oui | = Σ capital restant des échéances |
| TERME | non | défaut : terme du produit |
| CAPITAL_REMBOURSE, INTERETS_PAYES, MONTANT_IMPAYES, NB_ECHEANCES_IMPAYEES, JOURS_RETARD | non | défauts : accordé − restant dû, puis 0 |
| CLASSE_RISQUE | non | `SAIN` (défaut), `SENSIBLE`, `DOUTEUX`, `LITIGIEUX`, `COMPROMIS` |
| PROVISION | non | provision constituée à la bascule (portée par la balance) |
| SOUFFRANCE_COMPTABLE | non | oui = encours au compte de créances en souffrance |
| NUMERO_COMPTE_EPARGNE | non | compte de prélèvement (classeur 04 ou base) |
| PERIODICITE, METHODE_INTERET | non | défauts : ceux du produit |
| OBJET_CREDIT, DATE_PREMIERE_ECHEANCE, DATE_DERNIERE_ECHEANCE | non | défauts des dates : première / dernière échéance restante |

### ECHEANCES (après DOSSIERS)
`NUMERO_DOSSIER`, `NUMERO_ECHEANCE` (rang dans le tableau d'amortissement), `DATE_ECHEANCE`, `CAPITAL`, `INTERET`, `STATUT` obligatoires ; `MONTANT_PAYE` (échéance `PARTIELLE` : déjà payé, imputé d'abord sur les intérêts). Statuts : `PREVUE`, `PARTIELLE`, `IMPAYEE` ; `PAYEE` ignorée (`ECHEANCE_PAYEE_IGNOREE`, avertissement).

### GARANTIES (après DOSSIERS, TYPES_GARANTIE, PRODUITS_GARANTIES, CONFIG_COMPTES_GARANTIE, ComptesEpargne)
`NUMERO_DOSSIER`, `CODE_TYPE_GARANTIE` (libellé paramétré dans les garanties du produit) obligatoires ; `VALEUR` (défaut : montant bloqué), `NUMERO_COMPTE_CAUTION` et `MONTANT_BLOQUE` (catégorie `FINANCIERE` : compte d'épargne de caution du classeur 04 ou de la base, montant ≤ solde du compte), `DESCRIPTION`.

### Cohérence avec la balance et projection auxiliaire
- Encours : Σ `CAPITAL_RESTANT_DU` par (agence, compte de créance) = solde **débiteur** de ce compte dans `BalanceOuverture` ; écart → `balance_ecart_auxiliaires` (avertissement, bloquant si `ecartAuxiliairesBloquant`).
- `imp_solde_auxiliaire` : `DOSSIERS` (type `COMPTE_CREDIT`, code `AUXCR-nnnnnn`, solde −CRD) et `GARANTIES` (type `GARANTIE_FINANCIERE`, code `AUXGA-nnnnnn`, solde +montant bloqué, sur le compte de `CONFIG_COMPTES_GARANTIE`). Les pièces `A_NOUVEAU` reprennent ces auxiliaires (§4 quater).

### Codes d'erreur propres au classeur 05
| Code | Gravité | Cause |
|---|---|---|
| `DOSSIER_DOUBLON` / `DOSSIER_EXISTE_DEJA` | bloquante | numéro répété dans le lot / déjà en base |
| `DOSSIER_CLIENT_INCONNU` / `DOSSIER_PRODUIT_INCONNU` | bloquante | client ou produit introuvable |
| `DOSSIER_STATUT_INVALIDE` | bloquante | statut hors liste |
| `DOSSIER_SOLDE_RESTE_DU` | bloquante | dossier `SOLDE` avec un capital restant dû |
| `ECHEANCES_SOMME_CRD` | bloquante | Σ capital restant des échéances ≠ `CAPITAL_RESTANT_DU` |
| `ECHEANCE_PAYEE_IGNOREE` | avertissement | échéance `PAYEE` : non reprise |
| `TYPE_GARANTIE_NON_PARAMETRE` | bloquante | type absent des garanties du produit (`PRODUITS_GARANTIES`) |
| `GARANTIE_COMPTE_NON_PARAMETRE` | bloquante | garantie financière sans compte dans `CONFIG_COMPTES_GARANTIE` |
| `GARANTIE_CAUTION_INCONNUE` | bloquante | compte de caution introuvable |
| `GARANTIE_CAUTION_INSUFFISANTE` | bloquante | montant bloqué > solde du compte de caution |
| `balance_ecart_auxiliaires` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | encours ≠ compte de créance de la balance |

### Dates des lignes créées
**Lendemain de la date de bascule** (jour des pièces `A_NOUVEAU` et de la journée ouverte) pour la création des dossiers, comptes crédit, échéances, garanties, la dernière classification et le déclassement en souffrance, la clôture d'un dossier `SOLDE`, l'historique de statut et l'évaluation des garanties. Les dates métier du fichier (décaissement, échéances, première / dernière échéance) sont reprises telles quelles.

### Annulation
Supprimés : dossiers, comptes crédit, échéances, garanties, provisions, historiques et paramétrages créés par le lot ; les séquences de numérotation du crédit sont remises comme avant le lot. **Refus** dès qu'une donnée postérieure, hors lot, repose sur l'encours (remboursement, pénalité, nouvelle provision, ligne de toute table liée au dossier) : le motif s'affiche sur l'écran du lot (§7).

### Limite connue — provision de bascule
La provision du fichier est enregistrée à la période (`aaaa-mm`) et à la date de la bascule, comptabilisée, dotation 0. La dotation de la période suivante se calcule par différence avec ce montant. Un calcul de provisions lancé **dans le mois de la bascule** (bascule en cours de mois) retrouve cette ligne comme période courante et la recalcule à partir de zéro (dotation de la totalité) : **lancer le premier calcul au mois suivant la bascule**.

## 4 septies bis. Classeur `07-Stock` (module stock, ordre 700)

Ordre de dépôt : après `01-Parametrage` et `02-Comptabilite` (agences, plan comptable, **balance d'ouverture**). Feuilles, dans l'ordre de chargement : `UNITES_MESURE`, `CATEGORIES`, `FAMILLES`, `MAGASINS`, `ARTICLES`, `STOCKS_INITIAUX`. Nom de feuille = code du dataset (la forme `UnitesMesure`, `StocksInitiaux` est aussi acceptée) ; en-têtes en MAJUSCULES_SNAKE (casse, accents, `_` et `*` final ignorés ; camelCase accepté). Référence complète des colonnes : `sfd-stock-service/src/main/resources/import/stock/COLONNES.md`.

### Décisions de cadrage
- **Stock d'ouverture seulement** : un mouvement `INVENTAIRE_INITIAL` par ligne de `STOCKS_INITIAUX`, validé, daté du **lendemain de la date de bascule** à 00:00, numéroté `MIG-<lot>-<n° de ligne>`. Aucun historique d'entrées / sorties n'est repris.
- **Aucune écriture comptable** : ni message comptable, ni solde auxiliaire. La valeur du stock est portée par la **balance d'ouverture** du classeur 02 (comptes de stock) ; le chargement du stock ne fait que la rapprocher (voir « Cohérence »).
- **Valorisation au CUMP uniquement** : FIFO, LIFO et prix standard sont refusés (`ARTICLE_VALORISATION_NON_SUPPORTEE`). La quantité compte au plus 3 décimales.
- **Un stock par (article, magasin)** : plusieurs lignes d'un même couple sont possibles seulement avec des numéros de lot différents ; le stock de l'article est la somme des lots, son CUMP = valeur totale / quantité totale.
- **Codes** : un code déjà présent en base (unité, catégorie, famille, magasin, article) est refusé (`…_EXISTE_DEJA`), jamais modifié. Les numéros de lot sont libres.
- **Responsable de magasin** : `CODE_RESPONSABLE` est un texte libre, non relié aux employés (le RH est chargé plus tard).
- Lignes chargées marquées `MIGRATION:<code du lot>` (`cree_par`).

### Paramétrages (feuilles 1 à 4)
| Feuille | Clé | Colonnes (* = obligatoire) | Dépend de |
|---|---|---|---|
| `UNITES_MESURE` | `CODE_UNITE` | `CODE_UNITE`* (10 car.), `LIBELLE`* (50), `SYMBOLE`, `CODE_UNITE_BASE` (unité du lot ou de la base, pas elle-même), `COEFFICIENT_CONVERSION` (> 0, défaut 1) | — |
| `CATEGORIES` | `CODE_CATEGORIE` | `CODE_CATEGORIE`* (20), `LIBELLE`* (100), `CODE_CATEGORIE_PARENT` (sans cycle, 6 niveaux au plus), `DESCRIPTION` | — |
| `FAMILLES` | `CODE_FAMILLE` | `CODE_FAMILLE`* (20), `LIBELLE`* (100), `CODE_CATEGORIE`, `COMPTE_STOCK_DEFAUT`, `COMPTE_ACHAT_DEFAUT`, `COMPTE_VARIATION_STOCK_DEFAUT` (comptes du plan, en base ou lot 02) | `CATEGORIES`, plan comptable |
| `MAGASINS` | `CODE_MAGASIN` | `CODE_MAGASIN`* (20), `LIBELLE`* (100), `CODE_AGENCE`* (agence en base ou lot 01 : agence des écritures de stock), `TYPE_MAGASIN` (`PRINCIPAL` défaut, `SECONDAIRE`, `TRANSIT`, `RESERVE`), `ADRESSE`, `VILLE`, `TELEPHONE`, `EMAIL`, `CODE_RESPONSABLE` | Agences |

### ARTICLES (après UNITES_MESURE, CATEGORIES, FAMILLES, plan comptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| CODE_ARTICLE | oui | 30 car., unique (`ARTICLE_DOUBLON`, `ARTICLE_EXISTE_DEJA`) |
| DESIGNATION | oui | 200 car. |
| CODE_UNITE | oui | unité du lot ou de la base (`ARTICLE_UNITE_INCONNUE`) |
| TYPE_ARTICLE | non | `STOCKABLE` (défaut), `CONSOMMABLE`, `SERVICE`, `COMPOSE` |
| CODE_CATEGORIE, CODE_FAMILLE | non | du lot ou de la base (`ARTICLE_CATEGORIE_INCONNUE`, `ARTICLE_FAMILLE_INCONNUE`) |
| PRIX_ACHAT_HT, PRIX_VENTE_HT | non | ≥ 0, défaut 0 (`ARTICLE_VALEUR_INVALIDE`) |
| TAUX_TVA | non | 0 à 100, défaut 18 |
| METHODE_VALORISATION | non | `CUMP` seul |
| STOCK_MINIMUM, STOCK_SECURITE, STOCK_MAXIMUM | non | ≥ 0 |
| GESTION_LOT, PERISSABLE | non | oui / non, défaut non |
| CODE_BARRE, REFERENCE_FOURNISSEUR | non | 50 car. |
| COMPTE_STOCK, COMPTE_ACHAT, COMPTE_VARIATION_STOCK | non | compte du plan (`ARTICLE_COMPTE_INCONNU`) ; vide = compte de la famille |

Un article `STOCKABLE` ou `CONSOMMABLE` doit avoir un compte de stock **et** un compte de variation de stock, sur l'article ou à défaut sur sa famille (`ARTICLE_COMPTES_MANQUANTS`).

### STOCKS_INITIAUX (après ARTICLES, MAGASINS et BalanceOuverture)
| Colonne | Oblig. | Règle |
|---|---|---|
| CODE_ARTICLE | oui | article du lot ou de la base, `STOCKABLE` ou `CONSOMMABLE` (`STOCK_INITIAL_ARTICLE_INCONNU`, `STOCK_INITIAL_ARTICLE_NON_STOCKABLE`) |
| CODE_MAGASIN | oui | magasin du lot ou de la base (`STOCK_INITIAL_MAGASIN_INCONNU`) |
| NUMERO_LOT | selon article | **obligatoire** si l'article est géré par lot (`STOCK_INITIAL_LOT_OBLIGATOIRE`), **interdit** sinon (`STOCK_INITIAL_LOT_INTERDIT`) |
| DATE_PEREMPTION | non | avec un lot uniquement |
| QUANTITE | oui | > 0, 3 décimales au plus (`STOCK_INITIAL_QUANTITE_INVALIDE`, `STOCK_INITIAL_QUANTITE_PRECISION`) ; **0 = ligne ignorée** (avertissement `STOCK_INITIAL_QUANTITE_NULLE`) |
| CUMP | oui | coût unitaire moyen pondéré > 0 (`STOCK_INITIAL_CUMP_INVALIDE`) |
| VALEUR | non | contrôle : doit égaler quantité × CUMP arrondi à 2 décimales, à 1 unité près (`STOCK_INITIAL_VALEUR_INCOHERENTE`) |

Clé de la ligne : (article, magasin, lot) — doublon bloquant `STOCK_INITIAL_DOUBLON`. Un couple (article, magasin) qui porte déjà un stock en base est refusé (`STOCK_INITIAL_EXISTE_DEJA`).

### Cohérence avec la balance
Pour chaque (agence du magasin, compte de stock de l'article, ou à défaut de sa famille) : Σ (quantité × CUMP arrondi à 2 décimales) doit égaler le solde **débiteur** de ce compte dans `BalanceOuverture`. Écart → `STOCKS_INITIAUX_ECART_BALANCE` : **avertissement**, **bloquant** si l'option `ecartAuxiliairesBloquant` est cochée. Pour un jeu cohérent, la balance 02 doit donc porter au débit les comptes de stock, agence par agence, pour la valeur exacte du stock chargé.

### Codes d'erreur propres au classeur 07
| Code | Gravité | Cause |
|---|---|---|
| `UNITE_DOUBLON` / `UNITE_EXISTE_DEJA` | bloquante | code unité répété dans le lot / déjà en base |
| `UNITE_BASE_INCONNUE` | bloquante | unité de base absente, ou égale à l'unité elle-même |
| `UNITE_COEFFICIENT_INVALIDE` | bloquante | coefficient ≤ 0 |
| `CATEGORIE_DOUBLON` / `CATEGORIE_EXISTE_DEJA` | bloquante | code catégorie répété / déjà en base |
| `CATEGORIE_PARENT_INCONNUE` / `CATEGORIE_CYCLE` | bloquante | parent introuvable / hiérarchie circulaire |
| `FAMILLE_DOUBLON` / `FAMILLE_EXISTE_DEJA` | bloquante | code famille répété / déjà en base |
| `FAMILLE_CATEGORIE_INCONNUE` / `FAMILLE_COMPTE_INCONNU` | bloquante | catégorie ou compte absent |
| `MAGASIN_DOUBLON` / `MAGASIN_EXISTE_DEJA` | bloquante | code magasin répété / déjà en base |
| `MAGASIN_AGENCE_INCONNUE` | bloquante | agence absente de la base et du lot |
| `ARTICLE_DOUBLON` / `ARTICLE_EXISTE_DEJA` | bloquante | code article répété / déjà en base |
| `ARTICLE_UNITE_INCONNUE`, `ARTICLE_CATEGORIE_INCONNUE`, `ARTICLE_FAMILLE_INCONNUE`, `ARTICLE_COMPTE_INCONNU` | bloquante | référence introuvable |
| `ARTICLE_VALEUR_INVALIDE` | bloquante | prix, TVA ou seuils hors bornes |
| `ARTICLE_VALORISATION_NON_SUPPORTEE` | bloquante | méthode autre que `CUMP` |
| `ARTICLE_COMPTES_MANQUANTS` | bloquante | pas de compte de stock ou de variation (article puis famille) |
| `STOCK_INITIAL_ARTICLE_INCONNU` / `_ARTICLE_NON_STOCKABLE` | bloquante | article introuvable / de type service ou composé |
| `STOCK_INITIAL_MAGASIN_INCONNU` | bloquante | magasin introuvable |
| `STOCK_INITIAL_LOT_OBLIGATOIRE` / `_LOT_INTERDIT` | bloquante | lot manquant pour un article géré par lot / lot sur un article non géré par lot |
| `STOCK_INITIAL_QUANTITE_INVALIDE` / `_QUANTITE_PRECISION` | bloquante | quantité négative / plus de 3 décimales |
| `STOCK_INITIAL_QUANTITE_NULLE` | avertissement | quantité 0 : ligne ignorée |
| `STOCK_INITIAL_CUMP_INVALIDE` | bloquante | CUMP ≤ 0 |
| `STOCK_INITIAL_VALEUR_INCOHERENTE` | bloquante | `VALEUR` ≠ quantité × CUMP |
| `STOCK_INITIAL_DOUBLON` / `STOCK_INITIAL_EXISTE_DEJA` | bloquante | (article, magasin, lot) répété / couple déjà en stock |
| `stocks_initiaux_ecart_balance` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | Σ valeur du stock ≠ compte de stock de la balance |

### Annulation
Supprimés : mouvements d'inventaire initial, lots, stocks, puis articles, magasins, familles, catégories et unités créés par le lot ; les séquences de numérotation (articles, magasins, familles, catégories, unités) sont ramenées comme avant le lot. **Refus** dès qu'une donnée postérieure, hors lot, repose sur les éléments chargés : mouvement de stock (sortie, réception, inventaire), bon de réception ou de sortie, inventaire physique, affectation, quota, composition d'article, transfert, emplacement, ou famille / catégorie / unité référencée par un élément hors lot. Le motif et la table concernée s'affichent sur l'écran du lot (§7) ; supprimer ou contre-passer l'opération, puis relancer. Le lien avec un article commercial n'est contrôlé que dans le monolithe.

## 4 septies ter. Classeur `08-Immobilisation` (module immobilisation, ordre 900)

Ordre de dépôt : après `01-Parametrage` et `02-Comptabilite` (agences, plan comptable, **balance d'ouverture**). Feuilles, dans l'ordre de chargement : `MODES_ACQUISITION`, `METHODES`, `ETATS_PHYSIQUES` (facultatives), `CATEGORIES_IMMO`, `NATURES`, `IMMOBILISATIONS`. Nom de feuille = code du dataset ; en-têtes en MAJUSCULES_SNAKE. Référence complète : `sfd-immobilisation-service/src/main/resources/import/immobilisation/COLONNES.md`.

### Décisions de cadrage
- **Immobilisations en service uniquement** : seules les immobilisations `EN_SERVICE` à la date de bascule sont reprises, y compris celles **totalement amorties** (VNC = 0). Aucune immobilisation cédée, mise au rebut ou sortie ; aucun historique de sorties.
- **Cumul et VNC repris du fichier** : `CUMUL_AMORTISSEMENTS` (arrêté à la date de bascule) et `VNC` sont repris tels quels. Valeur brute = valeur d'origine + TVA immobilisée + frais accessoires ; VNC = brute − cumul (**contrôle toujours bloquant**, `IMMOBILISATION_VNC_INCOHERENTE`). Le cumul ne dépasse pas la base amortissable (brute − valeur résiduelle).
- **Plan d'amortissement reconstitué** : le système recalcule, mois par mois, de la mise en service jusqu'au **dernier mois clos** (mois de la bascule si elle tombe le dernier jour du mois, sinon le mois précédent). Ces lignes sont marquées comptabilisées (pièce `MIG-<lot>`), **sans nouvelle écriture comptable**. La dernière ligne est ajustée pour que le cumul du plan égale exactement le cumul du fichier ; l'ajustement est signalé par l'avertissement `IMMOBILISATIONS_CUMUL_ECART_PLAN`. *Recommandation : basculer en fin de mois.* Le mois de bascule, si elle tombe en cours de mois, n'est pas inclus dans le cumul et sera doté entier après l'import.
- **Dotation suivante sur la VNC importée** : la génération des amortissements du mois suivant part du cumul importé. Linéaire : base amortissable ÷ durée ; dégressif : coefficient × VNC de début d'exercice ÷ 12.
- **Méthodes** : `LINEAIRE` et `DEGRESSIF` seuls ; `UNITE_OEUVRE` est refusée (`CATEGORIE_IMMO_METHODE_NON_SUPPORTEE`).
- **Catégories sans code** : la clé d'une catégorie est son **libellé** (unique sans tenir compte de la casse). Les catégories et natures ne sont pas semées au démarrage : elles viennent de ce classeur.
- **Comptes** : seule vérification, leur présence au plan comptable (base ou lot 02) ; aucun préfixe imposé (SYSCOHADA, plan SFD, COBAC…). Résolution : ligne de l'immobilisation, sinon nature, sinon catégorie.
- Mouvement `ACQUISITION` créé pour chaque immobilisation, daté du lendemain de la bascule, sans publication comptable ; lignes marquées `MIGRATION:<code du lot>`. Responsable, service et emplacement sont des textes libres, non reliés au RH.

### Feuilles facultatives de libellés
`MODES_ACQUISITION` (`ACHAT`, `DON`, `APPORT`, `CREATION_INTERNE`, `LOCATION_FINANCEMENT`), `METHODES` (`LINEAIRE`, `DEGRESSIF`, `UNITE_OEUVRE`, avec `COEFFICIENT_FISCAL`) et `ETATS_PHYSIQUES` (`NEUF`, `BON`, `USE`, `HORS_SERVICE`, avec `COULEUR`) : colonnes `CODE`*, `LIBELLE`*, `DESCRIPTION`, `ORDRE`. Elles **renomment** les lignes système existantes (codes fixes) ; elles n'en créent ni n'en suppriment. Code inconnu : `MODE_ACQUISITION_CODE_INCONNU`, `METHODE_CODE_INCONNU` ou `ETAT_PHYSIQUE_CODE_INCONNU`. Les libellés modifiés **ne sont pas restaurés** à l'annulation.

### CATEGORIES_IMMO (après PlanComptable)
| Colonne | Oblig. | Règle |
|---|---|---|
| LIBELLE | oui | 255 car., clé unique (`CATEGORIE_IMMO_DOUBLON`, `CATEGORIE_IMMO_EXISTE_DEJA`) |
| TYPE | non | `INCORPORELLE`, `CORPORELLE` (défaut), `FINANCIERE` |
| COMPTE_IMMOBILISATION | oui | compte du plan (`CATEGORIE_IMMO_COMPTE_INCONNU`) |
| COMPTE_AMORTISSEMENT, COMPTE_DOTATION | si amortissable | comptes du plan ; obligatoires pour une catégorie amortissable (`CATEGORIE_IMMO_COMPTES_MANQUANTS`) |
| COMPTE_PLUS_VALUE_CESSION, COMPTE_MOINS_VALUE_CESSION | non | comptes du plan |
| DUREE_AMORTISSEMENT_MOIS | oui | entier > 0 (`CATEGORIE_IMMO_DUREE_INVALIDE`) |
| METHODE_AMORTISSEMENT | oui | `LINEAIRE` ou `DEGRESSIF` |
| TAUX_DEFAUT, SEUIL_IMMOBILISATION | non | décimaux |
| AMORTISSABLE | non | oui (défaut) / non |

### NATURES (après CATEGORIES_IMMO)
`CODE_NATURE`* (30 car., unique : `NATURE_DOUBLON`, `NATURE_EXISTE_DEJA`), `LIBELLE`*, `LIBELLE_CATEGORIE`* (catégorie du lot ou de la base : `NATURE_CATEGORIE_INCONNUE`) ; facultatifs : `COMPTE_IMMOBILISATION`, `COMPTE_AMORTISSEMENT`, `COMPTE_DOTATION` (vide = ceux de la catégorie ; `NATURE_COMPTE_INCONNU`), `DUREE_DEFAUT_MOIS`, `TAUX_DEFAUT`, `DESCRIPTION`.

### IMMOBILISATIONS (après CATEGORIES_IMMO, NATURES, Agences, PlanComptable, BalanceOuverture)
| Colonne | Oblig. | Règle |
|---|---|---|
| CODE_IMMO | oui | 50 car., unique (`IMMOBILISATION_DOUBLON`, `IMMOBILISATION_EXISTE_DEJA`) |
| NUMERO_INVENTAIRE | non | unique s'il est renseigné (`IMMOBILISATION_INVENTAIRE_DOUBLON`, lot ou base) |
| LIBELLE | oui | 255 car. |
| LIBELLE_CATEGORIE | oui | catégorie du lot ou de la base (`IMMOBILISATION_CATEGORIE_INCONNUE`) |
| CODE_NATURE | non | nature de la **même** catégorie (`IMMOBILISATION_NATURE_INCONNUE`, `IMMOBILISATION_NATURE_CATEGORIE_DIFFERENTE`) |
| CODE_AGENCE | oui | agence du lot ou de la base (`IMMOBILISATION_AGENCE_INCONNUE`) |
| DATE_ACQUISITION, DATE_MISE_SERVICE | oui | acquisition ≤ mise en service ≤ date de bascule (`IMMOBILISATION_DATES_INVALIDES`) ; la mise en service est le départ de l'amortissement |
| MODE_ACQUISITION | non | `ACHAT` (défaut), `DON`, `APPORT`, `CREATION_INTERNE`, `LOCATION_FINANCEMENT` |
| VALEUR_ORIGINE | oui | HT, > 0 |
| TVA_IMMOBILISEE, FRAIS_ACCESSOIRES, VALEUR_RESIDUELLE | non | ≥ 0, défaut 0 ; résiduelle ≤ brute (`IMMOBILISATION_VALEUR_INVALIDE`) |
| DUREE_AMORTISSEMENT_MOIS | non | vide = nature, sinon catégorie (`IMMOBILISATION_DUREE_INVALIDE`) |
| METHODE_AMORTISSEMENT | non | `LINEAIRE` ou `DEGRESSIF` ; vide = catégorie |
| COEFFICIENT_DEGRESSIF | non | dégressif seulement ; vide = barème selon la durée |
| CUMUL_AMORTISSEMENTS | oui | 0 ≤ cumul ≤ base amortissable (`IMMOBILISATION_CUMUL_INVALIDE`) |
| VNC | oui | = brute − cumul (`IMMOBILISATION_VNC_INCOHERENTE`, toujours bloquant) |
| ETAT | non | `NEUF`, `BON` (défaut), `USE`, `HORS_SERVICE` |
| FOURNISSEUR_NOM, NUMERO_FACTURE, NUMERO_SERIE, CODE_BARRE, SERVICE_AFFECTATION, EMPLACEMENT, RESPONSABLE_NOM | non | textes libres |
| COMPTE_IMMOBILISATION, COMPTE_AMORTISSEMENT, COMPTE_DOTATION | non | comptes du plan ; vide = nature, sinon catégorie (`IMMOBILISATION_COMPTE_INCONNU`, `IMMOBILISATION_COMPTES_MANQUANTS`) |

### Cohérence avec la balance
Par (agence, compte résolu) : Σ **valeur brute** = solde **débiteur** du compte d'immobilisation dans `BalanceOuverture` (`IMMOBILISATIONS_ECART_BALANCE_VALEUR`) ; Σ **cumul d'amortissements** = solde **créditeur** du compte d'amortissement (`IMMOBILISATIONS_ECART_BALANCE_AMORT`). Écart : **avertissement**, **bloquant** si l'option `ecartAuxiliairesBloquant` est cochée.

### Codes d'erreur propres au classeur 08
| Code | Gravité | Cause |
|---|---|---|
| `CATEGORIE_IMMO_DOUBLON` / `_EXISTE_DEJA` | bloquante | libellé de catégorie répété / déjà en base |
| `CATEGORIE_IMMO_COMPTE_INCONNU` / `_COMPTES_MANQUANTS` | bloquante | compte absent du plan / comptes d'amortissement ou de dotation manquants |
| `CATEGORIE_IMMO_METHODE_NON_SUPPORTEE` / `_DUREE_INVALIDE` | bloquante | unité d'œuvre / durée ≤ 0 |
| `NATURE_DOUBLON` / `NATURE_EXISTE_DEJA` | bloquante | code nature répété / déjà en base |
| `NATURE_CATEGORIE_INCONNUE` / `NATURE_COMPTE_INCONNU` | bloquante | catégorie ou compte absent |
| `IMMOBILISATION_DOUBLON` / `_EXISTE_DEJA` / `_INVENTAIRE_DOUBLON` | bloquante | code ou numéro d'inventaire répété ou déjà en base |
| `IMMOBILISATION_CATEGORIE_INCONNUE`, `_NATURE_INCONNUE`, `_NATURE_CATEGORIE_DIFFERENTE`, `_AGENCE_INCONNUE` | bloquante | référence introuvable ou nature d'une autre catégorie |
| `IMMOBILISATION_COMPTE_INCONNU` / `_COMPTES_MANQUANTS` | bloquante | compte absent du plan / aucun compte résolu |
| `IMMOBILISATION_DATES_INVALIDES` | bloquante | dates incohérentes ou postérieures à la bascule |
| `IMMOBILISATION_VALEUR_INVALIDE` / `_CUMUL_INVALIDE` / `_DUREE_INVALIDE` | bloquante | montants, cumul ou durée hors bornes |
| `IMMOBILISATION_VNC_INCOHERENTE` | bloquante (toujours) | VNC ≠ brute − cumul |
| `immobilisations_ecart_balance_valeur` / `_amort` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | Σ brute ou Σ cumul ≠ balance |
| `immobilisations_cumul_ecart_plan` | avertissement | le plan reconstitué diffère du cumul du fichier ; dernière ligne ajustée |

### Annulation
Supprimés : plans d'amortissement, mouvements d'acquisition, immobilisations, natures et catégories créés par le lot ; les séquences (code immobilisation, numéro d'inventaire, code nature) sont ramenées. **Refus** si une immobilisation du lot a une dotation, un mouvement (cession, transfert, rebut) ou une ligne d'inventaire postérieurs, si elle n'est plus `EN_SERVICE`, ou si une immobilisation ou une nature hors lot référence une catégorie ou une nature du lot : le motif s'affiche sur l'écran du lot (§7). Les feuilles facultatives de libellés ne sont pas annulées (voir plus haut).

## 4 septies quater. Classeur `09-RH` (module RH, ordre 1000)

Ordre de dépôt : après `01-Parametrage`, `02-Comptabilite` (agences, banques, plan) et `04-Epargne` (comptes de salaire internes). Feuilles, dans l'ordre de chargement : `DEPARTEMENTS`, `CATEGORIES_EMPLOI`, `POSTES`, `TYPES_CONTRAT`, `GRILLES_SALARIALES` (facultative), `EMPLOYES`, `CONTRATS`, `AFFECTATIONS` (facultative), `SOLDES_CONGES`. Nom de feuille = code du dataset ; en-têtes en MAJUSCULES_SNAKE (casse, accents, `_` et `*` final ignorés). Référence complète : `sfd-rh-service/src/main/resources/import/rh/COLONNES.md`.

### Décisions de cadrage
- **Employés à la date de bascule** avec leur contrat en cours ; pas de bulletins détaillés, de congés pris, d'absences ni de formations (seuls les soldes de congés sont repris).
- **Matricule conservé tel quel** (clé de rattachement avec la paie). Si les matricules suivent le format `EMP-<année>-<5 chiffres>`, la numérotation automatique est recalée sur le plus grand ; elle est ramenée à l'annulation.
- **Le contrat fait foi** : salaire de base, poste, nature du contrat, fin de contrat, catégorie et échelon de la grille de l'employé sont **recopiés du contrat `ACTIF`** (ce ne sont pas des colonnes de `EMPLOYES`). Un employé `ACTIF` a **exactement un** contrat `ACTIF` ; `SUSPENDU` : un contrat `ACTIF` ou `SUSPENDU` ; `SORTI` : aucun contrat `ACTIF` (en général un CDD `TERMINE`). `EN_COURS` est refusé : seul `ACTIF` désigne le contrat en cours.
- **Affectation initiale** créée automatiquement (active, origine `EMBAUCHE`, date d'effet = embauche) pour tout employé non sorti sans affectation active dans la feuille `AFFECTATIONS`, ainsi qu'un événement de carrière « Entrée » par employé.
- **Soldes de congés** : repris sous la forme d'un congé annuel de reprise de **0 jour**, daté du dernier jour du dernier mois de paie clos `Mc` (voir ci-dessous), portant le solde. Le solde du fichier est celui **arrêté avec la dernière paie close, acquis de `Mc` inclus**. Les congés pris entre le 1er du mois suivant et la bascule se saisissent dans EDIP.
- **Aucun rattachement** employé ↔ utilisateur EDIP ; responsables et supérieurs sont reliés par matricule, sans lien avec les utilisateurs.
- **Types de contrat** : CDI, CDD et stage sont semés au démarrage ; un code déjà présent est ignoré (avertissement). Aucune période d'essai importée. Étapes de recrutement, domaines de formation et critères d'évaluation ne sont pas semés : ils restent propres à l'institution.
- Lignes chargées marquées `MIGRATION:<code du lot>`.

### Dernier mois de paie clos `Mc`
`Mc` est le **mois de la date de bascule si celle-ci tombe le dernier jour du mois, sinon le mois précédent**. Il sert d'ancre à la paie (§4 septies quinquies) et aux soldes de congés. Exemple : bascule au 15/10 → `Mc` = septembre, et la paie d'octobre est calculée entièrement dans EDIP. **Recommandation : basculer en fin de mois.**

### Paramétrages (feuilles 1 à 5)
| Feuille | Clé | Colonnes (* = obligatoire) | Dépend de |
|---|---|---|---|
| `DEPARTEMENTS` | `CODE_DEPARTEMENT` | `CODE_DEPARTEMENT`* (30), `LIBELLE`* (150), `CODE_DEPARTEMENT_PARENT` (différent de lui-même), `CODE_AGENCE` (vide = siège), `CENTRE_COUT`, `EFFECTIF_CIBLE` (≥ 0), `MATRICULE_RESPONSABLE` (posé après le chargement des employés) | Agences |
| `CATEGORIES_EMPLOI` | `CODE_CATEGORIE` | `CODE_CATEGORIE`* (20), `LIBELLE`* (150), `NIVEAU_HIERARCHIQUE`, `COEFFICIENT_MIN` ≤ `COEFFICIENT_MAX`, `SALAIRE_MIN_LEGAL` | — |
| `POSTES` | `CODE_POSTE` | `CODE_POSTE`* (30), `INTITULE`* (150), `CODE_DEPARTEMENT`*, `CODE_CATEGORIE`, `ECHELON_MIN`, `ECHELON_MAX`, `SALAIRE_MIN` ≤ `SALAIRE_MAX`, `CODE_POSTE_RESPONSABLE` (poste supérieur) | Départements, catégories |
| `TYPES_CONTRAT` | `CODE_TYPE_CONTRAT` | `CODE_TYPE_CONTRAT`* (20), `LIBELLE`*, `NATURE`* (`CDI`, `CDD`, `STAGE`, `INTERIM`, `APPRENTISSAGE`, `SAISONNIER`), `DUREE_MIN_MOIS` ≤ `DUREE_MAX_MOIS`, `RENOUVELABLE`, `NB_RENOUVELLEMENTS` | — |
| `GRILLES_SALARIALES` | `CODE_GRILLE` | `CODE_GRILLE`* (30), `LIBELLE`*, `CODE_CATEGORIE`*, `ECHELON`*, `SALAIRE_BASE`* (> 0), `DEVISE`*, `SALAIRE_MIN`, `SALAIRE_MAX`, `PRIME_ANCIENNETE`, `INDEMNITE_LOGEMENT`, `INDEMNITE_TRANSPORT`, `AUTRES_AVANTAGES`, `DATE_EFFET`, `DATE_FIN` | Catégories, devises |

Un département, une catégorie, un poste ou un type de contrat déjà en base est **ignoré avec avertissement** (jamais modifié) ; une grille déjà en base est une erreur.

### EMPLOYES (après AGENCES, DEPARTEMENTS, POSTES, CATEGORIES_EMPLOI, COMPTES_EPARGNE, BANQUES)
| Colonne | Oblig. | Règle |
|---|---|---|
| MATRICULE | oui | 30 car., conservé, unique (`EMPLOYE_DOUBLON`, `EMPLOYE_EXISTE_DEJA`) |
| NOM, PRENOM | oui | 100 car. |
| SEXE | non | `MASCULIN`, `FEMININ` (`M` et `F` acceptés) |
| DATE_NAISSANCE, LIEU_NAISSANCE, NATIONALITE | non | naissance antérieure à l'embauche (`EMPLOYE_DATES_INCOHERENTES`) |
| SITUATION_MATRIMONIALE | non | `CELIBATAIRE`, `MARIE`, `DIVORCE`, `VEUF` |
| NOMBRE_ENFANTS | non | entier ≥ 0, défaut 0 (`EMPLOYE_ENFANTS_INVALIDE`) |
| TYPE_PIECE, NUMERO_PIECE | non | `CNI`, `PASSEPORT`, `CARTE_SEJOUR` ; numéro unique sans tenir compte de la casse (`EMPLOYE_PIECE_DOUBLON`) |
| NUMERO_CNSS | non | unique, lot et base (`EMPLOYE_CNSS_DOUBLON`) |
| NUMERO_FISCAL, REGIME_FISCAL, TELEPHONE, ADRESSE, VILLE | non | textes |
| EMAIL, EMAIL_PERSONNEL | non | uniques, lot et base (`EMPLOYE_EMAIL_DOUBLON`) |
| CODE_AGENCE | oui | agence en base ou lot 01 (`EMPLOYE_AGENCE_INCONNUE`) |
| CODE_DEPARTEMENT, CODE_POSTE | oui | du lot ou de la base ; le poste appartient au département (`EMPLOYE_DEPARTEMENT_INCONNU`, `EMPLOYE_POSTE_INCONNU`, `EMPLOYE_POSTE_HORS_DEPARTEMENT`) |
| CODE_CATEGORIE, ECHELON, INDICE | non | catégorie connue (`EMPLOYE_CATEGORIE_INCONNUE`) ; échelon et catégorie écrasés par la grille du contrat actif |
| DATE_EMBAUCHE | oui | au plus la date de bascule (`EMPLOYE_EMBAUCHE_POSTERIEURE`) |
| DATE_ANCIENNETE | non | vide = embauche |
| STATUT | oui | `ACTIF`, `SUSPENDU`, `SORTI` |
| DATE_SORTIE, MOTIF_SORTIE | si `SORTI` | **obligatoires** si `SORTI`, **interdites** sinon (`EMPLOYE_SORTIE_INCOHERENTE`) ; motifs : `DEMISSION`, `LICENCIEMENT`, `FIN_CONTRAT`, `RETRAITE`, `DECES`, `RUPTURE_CONVENTIONNELLE`, `AUTRE` |
| DOMICILIATION_SALAIRE | non | `INTERNE`, `BANQUE`, `MOBILE_MONEY`, `ESPECES` ; informations manquantes : `EMPLOYE_DOMICILIATION_INCOMPLETE` |
| MODE_PAIEMENT | non | `VIREMENT`, `CHEQUE`, `ESPECES`, `MOBILE_MONEY` ; vide = déduit de la domiciliation |
| NUMERO_COMPTE_EPARGNE | si `INTERNE` | compte épargne en base ou lot 04 (`EMPLOYE_COMPTE_EPARGNE_INCONNU`) |
| CODE_BANQUE, NUMERO_COMPTE, IBAN | si `BANQUE` | banque en base ou lot 01 (`EMPLOYE_BANQUE_INCONNUE`) |
| COMPTE_MOBILE_MONEY | si `MOBILE_MONEY` | numéro mobile money |
| MATRICULE_SUPERIEUR | non | employé du lot ou de la base ; sinon avertissement `EMPLOYE_SUPERIEUR_INCONNU` et champ laissé vide |

### CONTRATS (après EMPLOYES, TYPES_CONTRAT, POSTES, GRILLES_SALARIALES)
`MATRICULE`*, `CODE_TYPE_CONTRAT`*, `DATE_DEBUT`*, `SALAIRE_CONTRACTUEL`* (> 0), `STATUT`* (`ACTIF`, `SUSPENDU`, `TERMINE`, `RESILIE`, `ROMPU`) obligatoires ; `DATE_FIN` (obligatoire hors CDI sauf contrat `TERMINE` : `CONTRAT_DATE_FIN_OBLIGATOIRE`), `DUREE_MOIS`, `PERIODE_ESSAI_MOIS`, `DATE_FIN_ESSAI`, `CODE_POSTE` (vide = poste de l'employé), `CODE_GRILLE`, `MOTIF_CDD`, `DATE_SIGNATURE`, `AVANTAGES`, `CLAUSES_PARTICULIERES`. Règles : au plus un contrat `ACTIF` par matricule, lot et base confondus (`CONTRAT_ACTIF_MULTIPLE`) ; doublon (matricule, date de début) bloquant (`CONTRAT_DOUBLON`) ; `EN_COURS` refusé (`CONTRAT_STATUT_INVALIDE`) ; salaire hors bornes de la grille : avertissement `CONTRAT_SALAIRE_HORS_GRILLE` ; contrat `ACTIF` déjà échu à la bascule : avertissement `CONTRAT_ACTIF_ECHU`.

### AFFECTATIONS (facultative, après EMPLOYES, AGENCES, DEPARTEMENTS, POSTES)
`MATRICULE`*, `CODE_AGENCE`*, `CODE_DEPARTEMENT`*, `CODE_POSTE`*, `DATE_EFFET`* (au plus bascule + 1), `STATUT`* (`ACTIVE` ou `TERMINEE` ; `PLANIFIEE` et `ANNULEE` refusées) ; `DATE_FIN`, `ORIGINE` (`EMBAUCHE`, `DIRECTE` défaut, `MUTATION`, `PROMOTION`), `MOTIF`. Au plus une affectation `ACTIVE` par matricule, identique à l'agence / département / poste de l'employé ; aucune `ACTIVE` pour un employé `SORTI` ; chevauchement de périodes : avertissement.

### SOLDES_CONGES (après EMPLOYES)
`MATRICULE`*, `SOLDE_JOURS`* (décimal ; négatif : avertissement `SOLDE_NEGATIF`, ligne chargée), `DATE_SOLDE` (**laisser vide** = dernier jour de `Mc` ; toute autre date est refusée : `SOLDE_DATE_INVALIDE`). Employé sorti : ligne ignorée (avertissement). Un seul solde par matricule (`SOLDE_DOUBLON`).

### Codes d'erreur propres au classeur 09
| Code | Gravité | Cause |
|---|---|---|
| `DEPARTEMENT_DOUBLON`, `CATEGORIE_DOUBLON`, `POSTE_DOUBLON`, `TYPE_CONTRAT_DOUBLON`, `GRILLE_DOUBLON`, `EMPLOYE_DOUBLON`, `CONTRAT_DOUBLON`, `SOLDE_DOUBLON` | bloquante | clé répétée dans le lot |
| `DEPARTEMENT_EXISTE_DEJA`, `CATEGORIE_EXISTE_DEJA`, `POSTE_EXISTE_DEJA`, `TYPE_CONTRAT_EXISTE_DEJA` | avertissement | déjà en base : ligne ignorée |
| `GRILLE_EXISTE_DEJA`, `EMPLOYE_EXISTE_DEJA` | bloquante | déjà en base |
| `DEPARTEMENT_PARENT_INCONNU` / `_PARENT_CYCLE` / `_AGENCE_INCONNUE` / `_EFFECTIF_INVALIDE` | bloquante | parent introuvable ou égal au département, agence absente, effectif négatif |
| `DEPARTEMENT_RESPONSABLE_INCONNU`, `EMPLOYE_SUPERIEUR_INCONNU` | avertissement | matricule introuvable : laissé vide |
| `CATEGORIE_BORNES_INVALIDES`, `POSTE_SALAIRE_BORNES`, `GRILLE_SALAIRE_INVALIDE`, `TYPE_CONTRAT_DUREE_INVALIDE` | bloquante | bornes min > max ou valeur invalide |
| `POSTE_DEPARTEMENT_INCONNU`, `POSTE_CATEGORIE_INCONNUE`, `POSTE_RESPONSABLE_INCONNU`, `GRILLE_CATEGORIE_INCONNUE`, `GRILLE_DEVISE_INCONNUE` | bloquante (`POSTE_RESPONSABLE_INCONNU` : avertissement) | référence introuvable |
| `EMPLOYE_AGENCE_INCONNUE`, `_DEPARTEMENT_INCONNU`, `_POSTE_INCONNU`, `_POSTE_HORS_DEPARTEMENT`, `_CATEGORIE_INCONNUE`, `_COMPTE_EPARGNE_INCONNU`, `_BANQUE_INCONNUE` | bloquante | référence introuvable |
| `EMPLOYE_DATES_INCOHERENTES`, `_EMBAUCHE_POSTERIEURE`, `_SORTIE_INCOHERENTE`, `_ENFANTS_INVALIDE`, `_DOMICILIATION_INCOMPLETE` | bloquante | dates, sortie, enfants ou domiciliation incohérents |
| `EMPLOYE_PIECE_DOUBLON`, `_CNSS_DOUBLON`, `_EMAIL_DOUBLON` | bloquante | pièce, CNSS ou e-mail déjà utilisé (lot ou base) |
| `EMPLOYE_SANS_CONTRAT_ACTIF`, `EMPLOYE_SORTI_CONTRAT_ACTIF` | bloquante | employé actif sans contrat actif / employé sorti avec un contrat actif |
| `CONTRAT_EMPLOYE_INCONNU`, `_TYPE_INCONNU`, `_POSTE_INCONNU`, `_GRILLE_INCONNUE` | bloquante | référence introuvable |
| `CONTRAT_STATUT_INVALIDE`, `_ACTIF_MULTIPLE`, `_DATES_INCOHERENTES`, `_DATE_FIN_OBLIGATOIRE`, `_SALAIRE_INVALIDE` | bloquante | statut, doublon d'actif, dates ou salaire |
| `CONTRAT_DEBUT_POSTERIEUR`, `CONTRAT_ACTIF_ECHU`, `CONTRAT_SALAIRE_HORS_GRILLE` | avertissement | début après la bascule, contrat échu, salaire hors grille |
| `AFFECTATION_EMPLOYE_INCONNU`, `_AGENCE_INCONNUE`, `_DEPARTEMENT_INCONNU`, `_POSTE_INCONNU`, `_POSTE_HORS_DEPARTEMENT`, `_STATUT_INVALIDE`, `_ACTIVE_MULTIPLE`, `_INCOHERENTE_EMPLOYE`, `_EMPLOYE_SORTI`, `_DATE_POSTERIEURE` | bloquante | référence ou règle d'affectation |
| `AFFECTATION_CHEVAUCHEMENT` | avertissement | périodes qui se chevauchent |
| `SOLDE_EMPLOYE_INCONNU`, `SOLDE_DATE_INVALIDE`, `SOLDE_CONGE_POSTERIEUR` | bloquante | employé introuvable, date autre que celle de `Mc`, congé annuel déjà posé après cette date |
| `SOLDE_NEGATIF`, `SOLDE_EMPLOYE_SORTI` | avertissement | solde négatif chargé / employé sorti ignoré |

### Annulation
Supprimés (ordre inverse) : congés de reprise, événements de carrière, affectations, contrats, employés, grilles, types de contrat, postes, catégories et départements créés par le lot ; les liens vers des employés du lot (responsables, supérieurs) sont d'abord vidés ; la numérotation des matricules est ramenée. Les éléments déjà en base ne sont pas touchés. **Refus** si une donnée hors lot repose sur ce qui a été chargé : congé, absence, mission, pointage, heures supplémentaires, sanction, évaluation, promotion, mutation, formation, contrat ou affectation hors lot sur un employé du lot ; bulletin, élément variable, avance ou personnalisation de paie ; employés, contrats, affectations ou postes hors lot référençant un département, poste, catégorie, type ou grille du lot ; un congé annuel hors lot créé après l'import (`SOLDES_CONGES`). Le motif s'affiche sur l'écran du lot (§7). Le classeur 10 s'annule **avant** le classeur 09.

## 4 septies quinquies. Classeur `10-Paie` (module paie, ordre 1100)

Ordre de dépôt : après `09-RH` (les employés sont lus par leur matricule), `02-Comptabilite` (plan, journaux, balance d'ouverture) et `01-Parametrage`. Feuilles, dans l'ordre de chargement : `RUBRIQUES_PAIE`, `SCHEMA_COMPTABLE_PAIE` (facultative), `PERIODES_PAIE`, `ELEMENTS_FIXES`, `CUMULS_PAIE`, `AVANCES_EN_COURS`. En-têtes en MAJUSCULES_SNAKE ; mois au format `AAAA-MM`. Référence complète : `sfd-paie-service/src/main/resources/import/paie/COLONNES.md`.

### Décisions de cadrage
- **Ancrage sur `Mc`** (dernier mois de paie clos, voir §4 septies quater) : périodes jusqu'à `Mc` clôturées, période `Mc` + 1 ouverte et calculée dans EDIP.
- **Historique = cumuls de l'année de `Mc` seulement** : pas de bulletins détaillés. Chaque employé reçoit **un bulletin de reprise** (numéro `MIG-<lot>-<matricule>`, statut payé, période `Mc`), **masqué** des listes, de l'historique de l'employé et du portail ; ses montants sont **comptés dans les cumuls annuels** du bulletin PDF (le bulletin de reprise n'est pas compté dans « nombre de bulletins »). Les cumuls servent à l'**affichage** (cadre « cumuls annuels ») ; ils n'influencent pas le calcul des profils semés.
- **Salaire de base = contrat RH** (09) ; la feuille `ELEMENTS_FIXES` ne porte que les primes et retenues récurrentes en plus.
- **Aucune écriture comptable** : ni bulletin de reprise, ni période clôturée, ni avance ne publie de pièce ; le solde d'avances est porté par la balance (classeur 02).
- **Profil de paie** : seul le profil du pays de l'institution est semé au démarrage (paramètres pays, cotisations, barème IRPP, rubriques système dont `AVANCE_SALAIRE`, schéma comptable). Pays sans profil complet : « profil de paie à paramétrer » (voir « Jeu de test Côte d'Ivoire »).
- **Schéma comptable** : les comptes viennent de la norme ; une ligne n'est créée que si le compte existe au plan (compte manquant = message, aucune ligne). Le journal de paie est celui de type `PAIE` du setup comptable (`PA` ou `SA` selon la norme).
- Lignes chargées marquées `MIGRATION:<code du lot>`.

### RUBRIQUES_PAIE
Rubriques propres à l'institution (celles du setup, déjà en base, sont signalées et conservées : `RUBRIQUE_EXISTE_DEJA`, avertissement). Obligatoires : `CODE_RUBRIQUE` (30 car.), `LIBELLE`, `TYPE` (`GAIN`, `RETENUE`, `COTISATION`, `IMPOT`, `INFORMATION`), `MODE_CALCUL` (`MONTANT_FIXE`, `TAUX_BRUT`, `TAUX_BASE`, `FORMULE`, `BAREME`, `SAISIE_VARIABLE`, `REF_GRILLE` ; `TRANCHE` accepté = `BAREME`). Facultatives : `CATEGORIE`, `MONTANT_FIXE`, `TAUX`, `PLAFOND`, `PLANCHER`, `FORMULE`, `CONDITION`, `BASE_EXPRESSION`, `TAUX_EXPRESSION`, `QUANTITE_EXPRESSION`, `CODE_BAREME`, `REGROUPEMENT`, `AGREGATS` (liste parmi `BRUT`, `COTISABLE`, `IMPOSABLE`, `NET_PLUS`, `NET_MOINS`, ou `AUCUN`), `SOUMIS_IRPP`, `SOUMIS_COTISATION`, `IMPRIMABLE` (défaut oui), `OBLIGATOIRE`, `ORDRE`, `CODE_PAYS` (vide = tous). Cohérence (`RUBRIQUE_MODE_INCOHERENT`) : montant fixe sans montant, mode à taux sans taux, formule sans formule, barème sans barème. La syntaxe d'une formule n'est vérifiée qu'au premier calcul.

### SCHEMA_COMPTABLE_PAIE (facultative, après PlanComptable)
Surcharge des comptes semés. `TYPE_LIGNE`* (`REMUNERATION`, `CHARGE_PATRONALE`, `NET_A_PAYER`, `IPR`, `COTISATION_SALARIALE`, `COTISATION_PATRONALE`, `RETENUE`, `AVANCE`), `CLE` (regroupement, rubrique, cotisation ou organisme ; vide = défaut du type), `COMPTE_DEBIT`, `COMPTE_CREDIT` (au moins un, au plan : `SCHEMA_COMPTE_INCONNU`), `LIBELLE`, `CODE_PAYS` (vide = profil actif). La ligne active de même (pays, type, clé) est désactivée ; elle est réactivée à l'annulation.

### PERIODES_PAIE
`ANNEE`*, `MOIS`*, `STATUT`* ; facultatives : `CODE` (vide = `AAAA-MM`), `LIBELLE`, `DATE_DEBUT`, `DATE_FIN` (vides = bornes du mois), `DATE_PAIEMENT`. **Mois ≤ `Mc` : `CLOTUREE` ; mois `Mc` + 1 : `OUVERTE` ; au-delà refusé** (`PERIODE_STATUT_INVALIDE`). Les périodes clôturées sont marquées comptabilisées.

### ELEMENTS_FIXES (après EMPLOYES, RUBRIQUES_PAIE)
`MATRICULE`*, `CODE_RUBRIQUE`*, `TYPE`* (`GAIN` / `RETENUE`) ; **exactement un** de `MONTANT_FIXE` ou `TAUX` (`ELEMENT_MONTANT_OU_TAUX`), `BASE` (`BRUT`, `BASE`, `NET_IMPOSABLE`, obligatoire avec un taux), `PLAFOND`, `PLANCHER`, `DATE_DEBUT` (vide = **lendemain de la bascule**), `DATE_FIN`, `MOTIF`. Le salaire de base est refusé ici (`ELEMENT_SALAIRE_BASE`) ; employé ayant déjà une personnalisation de bulletin en base : `ELEMENT_PERSONNALISATION_EXISTANTE` ; employé sorti : avertissement, ligne ignorée.

### CUMULS_PAIE (après EMPLOYES, RUBRIQUES_PAIE, PERIODES_PAIE)
Une ligne par (employé, cumul) : `MATRICULE`*, `CODE_CUMUL`*, `MONTANT`*. Codes réservés : `BRUT`, `NET_IMPOSABLE`, `IRPP`, `COTIS_SAL`, `COTIS_PAT`, `NET_A_PAYER`, `AVANTAGES_NATURE`, `DEDUCTIONS` ; ou code d'une rubrique en base ou du lot. Montants = cumul **du 1er janvier à la fin de `Mc`**. Règles : `BRUT`, `NET_IMPOSABLE`, `IRPP` et `COTIS_SAL` obligatoires pour chaque matricule (`CUMUL_TOTAUX_MANQUANTS`) ; période `Mc` absente ou non clôturée (`CUMUL_PERIODE_CLOSE_ABSENTE`) ; employé ayant déjà un bulletin en base sur la période (`CUMUL_BULLETIN_EXISTANT`, double comptage) ; avertissements : montant négatif, `NET_IMPOSABLE` > `BRUT`, `Mc` = décembre (l'affichage de l'année suivante repart à zéro : `CUMUL_SANS_EFFET`).

### AVANCES_EN_COURS (après EMPLOYES)
Avances sur salaire en cours de retenue. L'échéancier d'origine continue : mensualité = montant ÷ échéances, la dernière prend le reste.
| Colonne | Oblig. | Règle |
|---|---|---|
| REFERENCE | oui | ancien numéro, unique (`AVANCE_DOUBLON`, `AVANCE_EXISTE_DEJA`) |
| MATRICULE | oui | employé connu et **non sorti** (`AVANCE_EMPLOYE_INCONNU`, `AVANCE_EMPLOYE_SORTI`) |
| MONTANT | oui | montant d'origine > 0 |
| MONTANT_RETENU | oui | déjà retenu jusqu'à la paie de `Mc` incluse ; reste = montant − retenu, **strictement positif et ≤ montant** (`AVANCE_RESTE_INVALIDE`) ; reste nul : avance ignorée (avertissement `AVANCE_SOLDEE`) |
| NB_ECHEANCES | oui | ≥ 1 (`AVANCE_ECHEANCES_INVALIDES`) |
| MOIS_DEBUT_RETENUE | oui | mois de la première retenue d'origine, `AAAA-MM` ; retenu incohérent avec l'échéancier : avertissement `AVANCE_RETENU_INCOHERENT` |
| DATE_DECAISSEMENT | oui | au plus la date de bascule (`AVANCE_DECAISSEMENT_POSTERIEUR`) |
| MOTIF, MODE_DECAISSEMENT | non | textes |

### Cohérence avec la balance
Σ des restes d'avances (montant − retenu) doit égaler le solde **débiteur** du compte d'avance du schéma comptable paie dans `BalanceOuverture` (écart : avertissement, **bloquant** si l'option `ecartAuxiliairesBloquant` est cochée). Aucun compte auxiliaire n'est créé pour la paie.

### Codes d'erreur propres au classeur 10
| Code | Gravité | Cause |
|---|---|---|
| `RUBRIQUE_DOUBLON` | bloquante | code répété dans le lot |
| `RUBRIQUE_EXISTE_DEJA` | avertissement | rubrique déjà en base : conservée |
| `RUBRIQUE_MODE_INCOHERENT`, `RUBRIQUE_BAREME_INCONNU`, `RUBRIQUE_AGREGAT_INVALIDE` | bloquante | mode de calcul incomplet, barème absent, agrégat inconnu |
| `SCHEMA_DOUBLON`, `SCHEMA_COMPTE_INCONNU` | bloquante | ligne répétée / compte absent du plan |
| `PERIODE_DOUBLON`, `PERIODE_EXISTE_DEJA`, `PERIODE_STATUT_INVALIDE` | bloquante | période répétée, déjà en base, statut incompatible avec `Mc` |
| `ELEMENT_EMPLOYE_INCONNU`, `ELEMENT_RUBRIQUE_INCONNUE`, `ELEMENT_MONTANT_OU_TAUX`, `ELEMENT_DOUBLON`, `ELEMENT_SALAIRE_BASE`, `ELEMENT_PERSONNALISATION_EXISTANTE` | bloquante | référence, montant / taux, doublon, salaire de base, personnalisation existante |
| `ELEMENT_EMPLOYE_SORTI` | avertissement | employé sorti : ligne ignorée |
| `CUMUL_EMPLOYE_INCONNU`, `CUMUL_CODE_INCONNU`, `CUMUL_DOUBLON`, `CUMUL_TOTAUX_MANQUANTS`, `CUMUL_PERIODE_CLOSE_ABSENTE`, `CUMUL_BULLETIN_EXISTANT` | bloquante | référence, doublon, totaux manquants, période absente, bulletin existant |
| `CUMUL_NEGATIF`, `CUMUL_INCOHERENT`, `CUMUL_SANS_EFFET` | avertissement | montant négatif, net imposable > brut, `Mc` = décembre |
| `AVANCE_DOUBLON`, `AVANCE_EXISTE_DEJA`, `AVANCE_EMPLOYE_INCONNU`, `AVANCE_EMPLOYE_SORTI`, `AVANCE_RESTE_INVALIDE`, `AVANCE_ECHEANCES_INVALIDES`, `AVANCE_DECAISSEMENT_POSTERIEUR` | bloquante | référence, reste, échéances, date |
| `AVANCE_SOLDEE`, `AVANCE_RETENU_INCOHERENT` | avertissement | avance soldée ignorée / retenu incohérent |
| `ecart_avances_balance` | avertissement (bloquante si `ecartAuxiliairesBloquant`) | Σ restes ≠ compte d'avance de la balance |

### Après l'import : paie de `Mc` + 1
La première paie calculée dans EDIP est celle de `Mc` + 1 : salaire de base du contrat RH, retenue d'avance = mensualité d'origine (le reste à la dernière échéance), solde de congé = solde importé + acquis du mois, cadre « cumuls annuels » du PDF = cumuls importés + mois courant. Une période contenant un bulletin de reprise **ne peut être ni rouverte, ni recalculée, ni comptabilisée** (messages « période migrée »). Pendant le chargement, le calcul, la validation, la comptabilisation, le paiement, la réouverture et le décaissement d'avance sont refusés (« migration en cours », §6), de même que la création de congés et d'affectations.

### Annulation
Supprimés : bulletins de reprise et leurs lignes, personnalisations et rubriques personnalisées, avances, périodes, rubriques et lignes de schéma créés par le lot (les lignes de schéma désactivées sont réactivées). **Refus** si une donnée postérieure repose sur ces éléments : bulletin hors lot, élément variable (dont la retenue d'avance de `Mc` + 1), publication comptable sur une période du lot, ligne de bulletin ou rubrique personnalisée utilisant une rubrique du lot, avance dont le montant retenu a changé depuis l'import. Les paramétrages semés au démarrage restent intacts. Annuler le classeur 10 **avant** le 09.

## 4 septies sexies. Compte de reprise

Le **compte de reprise** (option de lot `compteReprise`, §4 quater) est le compte d'attente qui reçoit la ligne de contrepartie des pièces `A_NOUVEAU` non équilibrées. Dans l'assistant, il est **pré-rempli avec le compte d'attente de la norme comptable de l'institution** (par exemple `3792` en RCS_SFD) ; il reste modifiable.
- Il doit exister au plan comptable (base ou classeur 02) et **ne pas figurer dans la balance d'ouverture**.
- Lot sans compte de reprise : la validation échoue (`compte_reprise_requis`) et signale en cascade de nombreuses erreurs de pièces ; renseigner le compte puis recréer le lot.
- Une fois les soldes concordants avec la balance, le compte de reprise est soldé (somme nulle par agence) ; sinon il porte exactement l'écart accepté, à solder par une opération diverse manuelle (§4 quater).
- Jeux de test : `471000` (plan à 6 chiffres), compte d'attente de classe 47 ajouté par le générateur.

## 4 octies. Étape 6 — contrôles post-import et clôture du lot

Après l'import (`IMPORTE`), l'assistant ouvre l'étape 6 « Contrôles post-import » : réconciliation **par agence** entre les fichiers du lot (staging, balance d'ouverture, projection auxiliaire) et les données chargées, en lecture directe de la base. Un module sans donnée pour le lot n'apparaît pas.

| Contrôle | Comparaison | Écart |
|---|---|---|
| `CLIENTS`, `GROUPES`, `COMPTES_EPARGNE` | lignes du fichier (hors rejetées) / lignes créées | vert si égal ; orange si l'écart = lignes non chargées (erreurs, déjà existantes) ; rouge sinon |
| `SOLDES_EPARGNE` | balance (crédit − débit) des collectifs épargne / Σ auxiliaires épargne | rouge si `ecartAuxiliairesBloquant`, orange sinon |
| `ENCOURS_CREDIT` | balance (débit − crédit) des collectifs crédit / Σ capital restant dû des dossiers (garanties exclues) | rouge si `ecartAuxiliairesBloquant`, orange sinon |
| `DOSSIERS_CREDIT` | auxiliaires crédit du lot / dossiers créés, détail par statut | orange |
| `CAISSES` | balance (débit − crédit) des comptes 57 / Σ soldes des caisses du lot | orange |
| `STOCK_VALEUR_BALANCE` | par compte de stock (agence du magasin) : balance (débit − crédit) / Σ valeur des stocks chargés par le lot | orange ; rouge si `ecartAuxiliairesBloquant` |
| `IMMO_VALEUR_BALANCE` | par compte d'immobilisation : balance (débit − crédit) / Σ valeur brute des immobilisations du lot | orange ; rouge si `ecartAuxiliairesBloquant` |
| `IMMO_AMORT_BALANCE` | par compte d'amortissement : balance (crédit − débit) / Σ cumul d'amortissements du lot | orange ; rouge si `ecartAuxiliairesBloquant` |
| `EMPLOYES`, `CONTRATS_ACTIFS` | lignes du fichier (hors rejetées) / employés et contrats `ACTIF` créés, par agence | vert si égal ; orange si l'écart = lignes non chargées ; rouge sinon |
| `MASSE_SALARIALE_CUMULEE` | Σ `BRUT` du fichier `CUMULS_PAIE` / Σ salaire brut des bulletins de reprise, par agence | rouge |
| `AVANCES_SALAIRE` | Σ restes d'avances du fichier / Σ restes des avances créées, par agence | rouge |
| `ECART_AVANCES_BALANCE` | Σ restes d'avances / solde débiteur du compte d'avance de la balance | orange ; rouge si `ecartAuxiliairesBloquant` |
| `PARTS_SOCIALES` | Σ (valeur nominale × nombre) du fichier / Σ montants créés | rouge |

- Les contrôles `STOCK_VALEUR_BALANCE`, `IMMO_VALEUR_BALANCE` et `IMMO_AMORT_BALANCE` ne portent que sur les comptes utilisés par les données chargées du lot ; un compte de stock ou d'immobilisation présent en balance mais utilisé par aucune ligne chargée n'est pas contrôlé. Module sans donnée pour le lot : contrôle absent.
- **Rapport de migration** : bouton « Rapport » → classeur `rapport-<code du lot>-<horodatage>.xlsx` (feuilles Synthèse, Datasets, Erreurs, Séquences, Réconciliation) à archiver avec le procès-verbal de bascule.
- **Clôturer le lot** : passe le lot en `CLOTURE` après confirmation. Un lot clôturé **ne peut plus être annulé** ; clôturer seulement après validation des contrôles et du rapport.

## 5. Formats de nombres, dates, booléens

- **Dates** : `dd/MM/yyyy` (jours et mois sur 1 ou 2 chiffres), ISO `yyyy-MM-dd`, ou cellule Excel de type date / numéro de série.
- **Entiers** : chiffres avec signe éventuel, espaces (normaux ou insécables) tolérés comme séparateurs de milliers.
- **Décimaux** : le dernier séparateur (`,` ou `.`) est la marque décimale, l'autre sépare les milliers. Règle `decimal_ambigu` : un séparateur unique suivi d'exactement 3 chiffres avec 1 à 3 chiffres entiers (`1,500`, `12.345`) est rejeté car décimal ou milliers indécidable. Lever l'ambiguïté : `1500`, `1500,000` ou `1 500`. Piège Excel : une cellule numérique formatée `#,##0.000` affiche `1,500` pour 1,5 et est signalée ; passer la colonne en texte ou en format Standard.
- **Booléens** : `oui`/`non`, `o`/`n`, `true`/`false`, `vrai`/`faux`, `1`/`0`, `yes`/`no` (sans tenir compte de la casse).
- **Texte** : espaces de début/fin supprimés ; cellule vide = non renseigné.

## 6. Verrou de migration

Pendant `IMPORT_EN_COURS`, `SUSPENDU` (import non terminé), `ANNULATION_EN_COURS` et une réinitialisation, un verrou global `imp_verrou` est posé (motif, référence du lot, utilisateur, depuis quand). Effets :

- Les jobs planifiés des modules **client, épargne, crédit** ne s'exécutent pas : ils journalisent « ignoré : migration en cours » (`migration.en_cours`). Il en va de même des jobs d'écritures en attente de la comptabilité.
- Les **déclencheurs manuels** sont refusés avec l'erreur HTTP 423 `migration.verrou.actif` : calcul des intérêts, frais de tenue de compte, traitement des échéances DAT, comptabilisation de l'épargne, ouverture et réouverture de journée comptable.
- Un **bandeau « migration en cours »** (motif et code du lot) s'affiche en bas de toutes les pages tant que le verrou est actif (relevé toutes les 30 s).
- Un second lot, une réinitialisation ou une autre phase ne peut pas démarrer (409).
- Lecture fail-closed : si la lecture du verrou échoue (hors table absente), il est considéré actif.
- Le verrou est levé à `IMPORTE` et `ANNULE`. Un lot `SUSPENDU` ou `ECHEC` le conserve.

## 7. Annulation et purge

- Lot jamais chargé (`CREE`…`EN_ERREUR`) : suppression du staging, statut `ANNULE`.
- Lot chargé (`IMPORTE`, `SUSPENDU`, `ECHEC`) : annulation **en deux temps**, sous verrou d'annulation. Seules les lignes **créées par le lot** sont supprimées (l'id créé est mémorisé) ; les éléments « déjà existants » ne sont jamais touchés.
  1. **Contrôle** (phase `CONTROLER_PURGE`, sans aucune suppression) : chaque module exécute tous ses contrôles d'annulation. Les références créées par le lot lui-même (ses clients, membres, parts, journaux, exercices générés, rattachements de ses utilisateurs) ne comptent pas.
  2. **Refus** si un module trouve au moins une référence hors lot, ou ne répond pas (module injoignable, version antérieure qui ne connaît pas le contrôle) : **rien n'est supprimé**, le lot revient à son statut d'avant l'annulation (`IMPORTE`, `SUSPENDU` ou `ECHEC`) avec son verrou d'avant (verrou d'import rétabli pour un lot suspendu). L'écran du lot affiche « Annulation refusée » et une ligne par référence bloquante : jeu de données, table qui référence, nombre de lignes. Traiter ou supprimer ces données, puis relancer l'annulation.
  3. Sinon **purge** module par module (ordre inverse du chargement), chaque module dans une seule transaction (suppressions et recalculs) : une erreur annule toute la purge du module. Une contrainte de base apparue entre le contrôle et la purge est signalée « Annulation interrompue » avec la table concernée (lot en `ECHEC`, verrou d'annulation conservé) ; relancer l'annulation après l'avoir traitée.
- **Références qui refusent l'annulation** (commun) : agence avec des utilisateurs hors lot rattachés, clients, exercices, journées ou pièces hors lot, agences enfants non issues du lot, ou opérations d'un module métier (caisse, épargne, crédit, stock, immobilisations, RH, paie…) ; devise utilisée par des agences hors lot ou par des taux de change ; utilisateur ayant déjà une connexion (jeton, session active) ou des rôles directs.
- **Données de session supprimées avec le lot** (pas de refus) : l'agence de travail sélectionnée par un utilisateur (`utilisateur_agence_connectee`) sur une agence du lot, et celle des utilisateurs du lot.
- **Opérations postérieures** : toute opération saisie après l'import sur une donnée du lot (dépôt en caisse sur un compte importé, remboursement d'un dossier repris, opération sur une caisse migrée…) fait refuser l'annulation ; le motif (dernier refus, avec ses paramètres) reste affiché sur l'écran du lot et lisible dans l'API du lot.
- **Remise en état** : les séquences de numérotation des clients et du crédit sont remises comme avant le lot ; les profils de messagerie (`chat_user`) créés pour les utilisateurs du lot sont supprimés avec eux.
- Un lot `CLOTURE` (étape 6) ne peut plus être annulé.
- Un lot passé à `ANNULE` voit son dossier de fichiers (`IMPORT_DOSSIER_STOCKAGE/<code du lot>`) supprimé du disque.

## 8. Réinitialisation de la base

Écran `Migration > Réinitialisation`. Désactivée tant que `IMPORT_REINITIALISATION_ENABLED` n'est pas `true`.

**Garde-fous (tous requis)** : fonction activée ; code de l'institution exact ; mot de confirmation `REINITIALISER` ; jeton à usage unique (5 min, lié à l'utilisateur) ; aucun verrou actif ni réinitialisation en cours ; tous les modules cibles joignables ; aucun lot en cours de traitement (analyse, validation, import, annulation) ; files RabbitMQ surveillées vides (si `IMPORT_REINIT_FILES` est renseigné) ; le verrou est posé pendant l'exécution.

**Supprimé** : toutes les données métier de chaque module (clients, épargne, crédit, caisse, compta, stock, RH, paie…), les utilisateurs et leurs jetons/sessions, notifications, fichiers, journaux d'audit, séquences, planifications, fournisseurs e-mail/SMS. Les tables de la migration elles-mêmes sont vidées (lots, fichiers, journal d'import, erreurs, tables de transit) à l'exception du verrou et du journal des réinitialisations, et les fichiers déposés (`IMPORT_DOSSIER_STOCKAGE`) sont supprimés : l'historique des lots est perdu, l'ancien lot ne peut plus être annulé. Les compteurs d'identité sont remis à 1. Le module commun passe en dernier ; l'opération est journalisée (dernière réinitialisation affichée).

**Conservé** : rôles et profils (`role`, `user_group`, `group_role`), formats de numérotation, paramètres système, devises, pays, types d'agence et de zone géographique (chargés au démarrage), modèles de notification.

**Limites connues**
- La limite multipart (`IMPORT_MAX_FILE_SIZE` 1 Go / `IMPORT_MAX_REQUEST_SIZE` 2 Go) s'applique à tout le service commun et à tout le monolithe (mêmes variables), pas seulement au dépôt de fichiers de lot (compromis assumé, itération 5). Un reverse proxy devant l'application (nginx `client_max_body_size`) doit être relevé d'autant ; au-delà, utiliser le dossier de dépôt serveur.
- En microservices, les modules chat, agora, commercial… ne sont pas encore réinitialisés (seuls les modules déclarés dans `IMPORT_<MODULE>_URL` le sont).
- La configuration conservée peut être périmée si la norme comptable ou les codes d'agence changent : revérifier devises et types d'agence avant d'importer.
- Après réinitialisation, les utilisateurs étant supprimés, se reconnecter avec le compte recréé (relancer `/setup` si l'administrateur a disparu).

## 9. Dépannage

| Symptôme | Cause / action |
|---|---|
| Lot `SUSPENDU` après redémarrage | Normal : import interrompu. Utiliser « Reprendre » (reprise à la dernière ligne chargée). |
| « Annulation refusée » (lot revenu à `IMPORTE` / `SUSPENDU`) | Une donnée hors lot repose sur le lot : chaque ligne du message donne le jeu, la table et le nombre de lignes. Rien n'a été supprimé. Traiter ces données (ex. supprimer la pièce saisie dans la période générée, annuler la clôture) puis relancer l'annulation. |
| Lot `ECHEC` « traitement interrompu » | Arrêt pendant analyse/validation/annulation. Retour aux fichiers puis réanalyser, ou relancer l'annulation. |
| « Ce lot détient encore le verrou » / jobs ignorés alors qu'aucun import ne tourne | Verrou resté au nom d'un lot suspendu ou en échec : reprendre puis terminer, ou annuler le lot. Le verrou d'une réinitialisation interrompue (motif `RESET`) est levé automatiquement au démarrage et journalisé. |
| « Un traitement est déjà en cours pour ce lot » | Attendre ; si l'écran est figé, bouton « Actualiser » (polling interrompu). |
| « Le module X est injoignable / n'a pas répondu / réponse incohérente » | Vérifier `IMPORT_<X>_URL`, `INTERNAL_SERVICE_KEY` identique, santé `/actuator/health` du module ; relancer l'étape (statut `ECHEC`). |
| « Un lot est en cours de traitement » (réinitialisation refusée) | Attendre la fin de l'analyse, de la validation, de l'import ou de l'annulation du lot indiqué, puis recommencer (nouveau jeton). |
| Fichier rejeté « champ trop long » | Un champ CSV dépasse 1 Mio, typiquement un guillemet jamais refermé : corriger le fichier. |
| « Des messages sont en attente dans les files » | Laisser consommer ou purger les files listées dans `IMPORT_REINIT_FILES`, puis recommencer (nouveau jeton). |
| « Jeton invalide ou expiré » | Le jeton dure 5 minutes et est à usage unique : refaire la demande. |
| « Table de transit absente » | Le module n'a pas créé ses tables `imp_*` : redémarrer le service (Hibernate `ddl-auto: update`). |
| Fichier rejeté « feuille inconnue » | Nom de feuille ou de CSV ne correspondant à aucun dataset ; repartir du gabarit. |
| Compte de reprise non soldé après import | Normal si l'écart entre comptes et balance a été accepté (avertissement `balance_ecart_auxiliaires`) : le compte porte l'écart ; le solder par une OD manuelle. |
| `compte_reprise_requis` | Renseigner l'option « Compte de reprise » à l'étape 1 (un compte détaillé du plan, absent de la balance). |
| Annulation refusée après un dépôt sur un compte importé | Contre-passer ou supprimer l'opération hors lot, puis relancer l'annulation. |
| Provision du mois de bascule entièrement redotée | Calcul de provisions lancé dans le mois de la bascule : il recalcule la période depuis zéro. Lancer le premier calcul au mois suivant (§4 septies). |
| Guichet ouvert avec un solde inattendu | La première session reprend le solde de bascule de la caisse (`soldeBascule`) ; vérifier la feuille `Caisses` et le contrôle `CAISSES` de l'étape 6. |
| Doute sur une ligne chargée | Journal d'import (écran étape 5) et export des erreurs ; les lignes chargées gardent l'id créé pour la purge. |

## 10. Volumes mesurés et jeu de test

Mesure du 2026-10-18 (monolithe, PostgreSQL 15 local, jeu `--agences 5 --clients-par-agence 200000` : 278 Mo, 1 000 000 clients, 20 000 groupes, 100 000 membres, 300 000 parts sociales, plan + balance) :

| Étape | Durée |
|---|---|
| Dépôt des 11 fichiers | 4 s |
| Analyse (1 420 112 lignes) | 64 s |
| Validation (tous datasets) | 153 s |
| Chargement CLIENTS (1 000 000, numérotation comprise) | 173 s |
| Chargement GROUPES / MEMBRES_GROUPE / PARTS_SOCIALES | 175 s / 184 s / 215 s (chevauchement : import total 411 s) |
| Annulation (purge) du lot complet | 169 s |

Objectif « 1 M de clients : analyse + validation + chargement < 10 min » tenu (environ 6,5 min). Contrôles : numéros EDIP tous distincts, séquences de numérotation alignées sur le plus grand numéro attribué, balance équilibrée pour les 5 agences, exercice de l'année de bascule `OUVERT` par agence, 0 pièce comptable, 0 donnée résiduelle après annulation.

Générateur de jeux de test (`scripts/migration-fixtures/`, Python 3 + `openpyxl`, graine fixe 42, sortie en flux) :

```bash
python3 scripts/migration-fixtures/generer_iter2.py --agences 5 --clients-par-agence 200000 --sortie <DIR>   # 1 M clients
python3 scripts/migration-fixtures/generer_iter2.py --agences 2 --clients-par-agence 500 --sortie <DIR>      # taille navigateur
python3 scripts/migration-fixtures/generer_iter2.py --verifier-entetes .                                       # en-têtes vs descripteurs Java
```

Options : `--date-bascule` (2026-09-30), `--longueur-compte` (6, égale au paramétrage comptable), `--prefixe-agence` (VOL), `--type-agence` (AGENCE, doit exister), `--pays` (CI), `--erreurs` (injecte un doublon d'ancien numéro entre deux agences, une agence déséquilibrée, une pièce dupliquée, un montant non entier ; liste dans `erreurs-injectees.txt`). Toujours générer **hors du dépôt**.

Jeu de test avec paramétrages (base vide) : `generer_iter3.py` réutilise `generer_iter2.py` et ajoute l'épargne **et**, par défaut, toutes les feuilles de la section 4 quinquies (2 profils sans rôle privilégié, 2 utilisateurs, 2 banques, rôle `PENALITE_RETRAIT_ANTICIPE_DAT`, 2 comptes bancaires + 1 mobile money, comptes de trésorerie et journaux VOLCA/VOLBQ/VOLMM ajoutés au plan, type de frais d'adhésion + barème FIXE + barème PALIER à 2 tranches, frais de notification SMS, parts sociales, dormance, frais d'opération TENUE_COMPTE FIXE et RETRAIT PALIER à 2 tranches, seuils SOLDE_MINIMUM et RETRAIT_JOURNALIER, paramétrage de dormance du compte à vue). Écrit aussi `03-Clients.xlsx` (feuilles de paramétrage).

```bash
python3 -I scripts/migration-fixtures/generer_iter3.py --agences 2 --clients-par-agence 20 --sortie <DIR>    # petit lot de preuve
python3 -I scripts/migration-fixtures/generer_iter3.py --sans-parametrage --agences 5 --clients-par-agence 200000 --sortie <DIR>   # ancien jeu (base déjà paramétrée)
python3 -I scripts/migration-fixtures/generer_iter3.py --verifier <DIR>          # cohérences (comptes du plan, tranches, profils…)
python3 -I scripts/migration-fixtures/generer_iter3.py --verifier-entetes .      # 17 feuilles de paramétrage vs descripteurs Java
```

Option de lot à saisir pour ce jeu : `compteReprise` = `471000` (6 chiffres). Ordre de dépôt : `01-Parametrage.xlsx`, `02-Comptabilite.xlsx`, `Gestionnaires.csv`, `Clients_<AG>.csv`, `Groupes.csv`, `MembresGroupe.csv`, `PartsSociales.csv` (CSV UTF-8, séparateur `;`, dates `dd/MM/yyyy`).

### Jeu de test Côte d'Ivoire (paie : IRPP = 0)
Le jeu de test d'une institution **ivoirienne** (zone UEMOA, norme RCS_SFD, agences `CI01` à `CI03`) se charge sans erreur : validation 0 erreur, import, étape 6 sans écart (relever dans le rapport les contrôles « à vérifier » éventuels). Pour la **paie**, le profil Côte d'Ivoire ne contient **pas de barème IRPP** : les bulletins calculés dans EDIP après l'import (paie de `Mc` + 1) ont donc **IRPP = 0**, et leur net à payer n'est pas comparable à celui de l'ancien système. Ce n'est pas une anomalie du chargement :
- les cumuls importés (`CUMULS_PAIE`) sont repris tels que fournis, IRPP compris ;
- pour une démonstration ou une recette avec impôt, utiliser le **profil Togo** (paramètres, cotisations et barème IRPP complets), qui est celui sur lequel la paie est prouvée ; ou paramétrer le barème ivoirien avant de calculer la première paie ;
- le jeu de fichiers 09 / 10 est généré par défaut pour le Togo (`--bascule-mi-mois` pour couvrir une bascule en cours de mois).
Le compte de reprise du jeu de test est `471000` (§4 septies sexies).

## 11. Test automatisé

`sfd-angular` : `npm run e2e:migration` rejoue trois parcours complets. `migration-lot.spec.ts` : feuille Agences, doublon + type inconnu, correction, import, vérification en API, annulation. `migration-compta-clients.spec.ts` : 1 agence, plan de 3 comptes, 1 journal, balance déséquilibrée puis corrigée, 2 clients dont un doublon d'ancien numéro puis corrigé, import, vérification en API (comptes, client au numéro `CLI-…` retrouvé par son ancien numéro, exercice de l'agence), annulation et données retirées. `lot-epargne.spec.ts` : lot 01-04 (1 agence, plan avec collectif d'épargne et compte de reprise, 2 clients, 1 produit, 2 comptes) avec un écart volontaire de 10 000 accepté (case de prise de connaissance), import, pièces `A_NOUVEAU` de l'agence équilibrées avec ligne de reprise de 10 000, solde des comptes et des auxiliaires égal au solde d'ouverture, bandeau « migration en cours » relevé si capturé, annulation (lot `ANNULE`, comptes, auxiliaires et pièces retirés). Les specs se partagent un verrou de fichier (un seul lot actif à la fois). À lancer sur une base jetable (`scripts/edip-env/edip-env.sh up <nom>`), avec `BASE_URL` (Angular), `MONOLITH_URL` (API) si monolithe, et `E2E_EMAIL` / `E2E_PASSWORD` (rôle `ROLE_ADMIN` ou `ROLE_MIGRATION`).
