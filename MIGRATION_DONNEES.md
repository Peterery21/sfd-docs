# Migration de données EDIP — guide opérateur

Itération 1 : socle (lots, verrou, réinitialisation) et classeur `01-Parametrage` (module commun : devises, agences, utilisateurs). Itération 2 : classeurs `02-Comptabilite` (plan comptable, journaux, balance d'ouverture, exercices générés) et `03-Clients` (gestionnaires, clients, groupes, membres, bénéficiaires, parts sociales). Les classeurs des autres modules (épargne, crédit, caisse, stock, RH, paie…) arrivent aux itérations suivantes sur les mêmes interfaces.

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

Parcours type de l'assistant : 1 Paramètres (libellé, date de bascule, agences) → 2 Gabarits → 3 Fichiers → 4 Validation → 5 Import. L'import exige de **saisir le code du lot** dans la fenêtre de confirmation, et d'avoir pris connaissance des avertissements éventuels.

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
- **Exercices générés, pas de feuille dédiée.** Pour chaque agence du lot (aucune sélection = toutes les agences, y compris celles du même lot), l'import crée l'exercice de l'année de **J = date de bascule + 1 jour** (code = année, du 1er janvier au 31 décembre, `OUVERT`, exercice courant), les périodes mensuelles de janvier au mois de J (les mois antérieurs `CLOTUREE`, celui de J `OUVERTE`) et la journée comptable J `OUVERTE`. Une agence qui a déjà un exercice pour cette année n'est pas touchée (avertissement `exercice_existant`). Option du lot `exercicesAuto` = `false` : rien n'est généré.
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

## 5. Formats de nombres, dates, booléens

- **Dates** : `dd/MM/yyyy` (jours et mois sur 1 ou 2 chiffres), ISO `yyyy-MM-dd`, ou cellule Excel de type date / numéro de série.
- **Entiers** : chiffres avec signe éventuel, espaces (normaux ou insécables) tolérés comme séparateurs de milliers.
- **Décimaux** : le dernier séparateur (`,` ou `.`) est la marque décimale, l'autre sépare les milliers. Règle `decimal_ambigu` : un séparateur unique suivi d'exactement 3 chiffres avec 1 à 3 chiffres entiers (`1,500`, `12.345`) est rejeté car décimal ou milliers indécidable. Lever l'ambiguïté : `1500`, `1500,000` ou `1 500`. Piège Excel : une cellule numérique formatée `#,##0.000` affiche `1,500` pour 1,5 et est signalée ; passer la colonne en texte ou en format Standard.
- **Booléens** : `oui`/`non`, `o`/`n`, `true`/`false`, `vrai`/`faux`, `1`/`0`, `yes`/`no` (sans tenir compte de la casse).
- **Texte** : espaces de début/fin supprimés ; cellule vide = non renseigné.

## 6. Verrou de migration

Pendant `IMPORT_EN_COURS`, `SUSPENDU` (import non terminé), `ANNULATION_EN_COURS` et une réinitialisation, un verrou global `imp_verrou` est posé (motif, référence du lot, utilisateur, depuis quand). Effets :

- Les jobs planifiés des modules **client, épargne, crédit** ne s'exécutent pas : ils journalisent « ignoré : migration en cours » (`migration.en_cours`).
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

Options : `--date-bascule` (2026-09-30), `--longueur-compte` (6, égale au paramétrage comptable), `--prefixe-agence` (VOL), `--type-agence` (AGENCE, doit exister), `--pays` (CI), `--erreurs` (injecte un doublon d'ancien numéro entre deux agences, une agence déséquilibrée, une pièce dupliquée, un montant non entier ; liste dans `erreurs-injectees.txt`). Toujours générer **hors du dépôt**. Ordre de dépôt : `01-Parametrage.xlsx`, `02-Comptabilite.xlsx`, `Gestionnaires.csv`, `Clients_<AG>.csv`, `Groupes.csv`, `MembresGroupe.csv`, `PartsSociales.csv` (CSV UTF-8, séparateur `;`, dates `dd/MM/yyyy`).

## 11. Test automatisé

`sfd-angular` : `npm run e2e:migration` rejoue deux parcours complets. `migration-lot.spec.ts` : feuille Agences, doublon + type inconnu, correction, import, vérification en API, annulation. `migration-compta-clients.spec.ts` : 1 agence, plan de 3 comptes, 1 journal, balance déséquilibrée puis corrigée, 2 clients dont un doublon d'ancien numéro puis corrigé, import, vérification en API (comptes, client au numéro `CLI-…` retrouvé par son ancien numéro, exercice de l'agence), annulation et données retirées. Les deux specs se partagent un verrou de fichier (un seul lot actif à la fois). À lancer sur une base jetable (`scripts/edip-env/edip-env.sh up <nom>`), avec `BASE_URL` (Angular), `MONOLITH_URL` (API) si monolithe, et `E2E_EMAIL` / `E2E_PASSWORD` (rôle `ROLE_ADMIN` ou `ROLE_MIGRATION`).
