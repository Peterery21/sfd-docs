# Migration de données EDIP — guide opérateur

Itération 1 : socle (lots, verrou, réinitialisation) et classeur `01-Parametrage` (module commun : devises, agences, utilisateurs). Les classeurs des autres modules (compta, épargne, crédit, caisse, stock, RH, paie…) arrivent aux itérations suivantes sur les mêmes interfaces.

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
| `ANNULATION_EN_COURS` | Purge en cours | Attendre |
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
- Lot chargé (`IMPORTE`, `SUSPENDU`, `ECHEC`) : purge dans chaque module, ordre inverse du chargement, sous verrou d'annulation, puis `ANNULE`. Seules les lignes **créées par le lot** sont supprimées (l'id créé est mémorisé) ; les éléments « déjà existants » ne sont jamais touchés.
- **Purge refusée si une donnée est référencée** hors du lot : agence avec utilisateurs rattachés, clients ou agences enfants non issues du lot ; devise utilisée par des agences ; utilisateur ayant déjà une connexion (jeton, session active) ou des rôles directs. Le lot passe en `ECHEC` avec le message ; supprimer ou déplacer les données référencées puis relancer l'annulation.
- Un motif est obligatoire.
- Un lot passé à `ANNULE` voit son dossier de fichiers (`IMPORT_DOSSIER_STOCKAGE/<code du lot>`) supprimé du disque.

## 8. Réinitialisation de la base

Écran `Migration > Réinitialisation`. Désactivée tant que `IMPORT_REINITIALISATION_ENABLED` n'est pas `true`.

**Garde-fous (tous requis)** : fonction activée ; code de l'institution exact ; mot de confirmation `REINITIALISER` ; jeton à usage unique (5 min, lié à l'utilisateur) ; aucun verrou actif ni réinitialisation en cours ; tous les modules cibles joignables ; aucun lot en cours de traitement (analyse, validation, import, annulation) ; files RabbitMQ surveillées vides (si `IMPORT_REINIT_FILES` est renseigné) ; le verrou est posé pendant l'exécution.

**Supprimé** : toutes les données métier de chaque module (clients, épargne, crédit, caisse, compta, stock, RH, paie…), les utilisateurs et leurs jetons/sessions, notifications, fichiers, journaux d'audit, séquences, planifications, fournisseurs e-mail/SMS. Les tables de la migration elles-mêmes sont vidées (lots, fichiers, journal d'import, erreurs, tables de transit) à l'exception du verrou et du journal des réinitialisations, et les fichiers déposés (`IMPORT_DOSSIER_STOCKAGE`) sont supprimés : l'historique des lots est perdu, l'ancien lot ne peut plus être annulé. Les compteurs d'identité sont remis à 1. Le module commun passe en dernier ; l'opération est journalisée (dernière réinitialisation affichée).

**Conservé** : rôles et profils (`role`, `user_group`, `group_role`), formats de numérotation, paramètres système, devises, pays, types d'agence et de zone géographique (chargés au démarrage), modèles de notification.

**Limites connues**
- La limite multipart (`IMPORT_MAX_FILE_SIZE` 1 Go / `IMPORT_MAX_REQUEST_SIZE` 2 Go) s'applique à tout le service commun, pas seulement au dépôt de fichiers de lot (compromis assumé, itération 5) ; le monolithe garde 50 Mo : au-delà, utiliser le dossier de dépôt serveur.
- En microservices, les modules chat, agora, commercial… ne sont pas encore réinitialisés (seuls les modules déclarés dans `IMPORT_<MODULE>_URL` le sont).
- La configuration conservée peut être périmée si la norme comptable ou les codes d'agence changent : revérifier devises et types d'agence avant d'importer.
- Après réinitialisation, les utilisateurs étant supprimés, se reconnecter avec le compte recréé (relancer `/setup` si l'administrateur a disparu).

## 9. Dépannage

| Symptôme | Cause / action |
|---|---|
| Lot `SUSPENDU` après redémarrage | Normal : import interrompu. Utiliser « Reprendre » (reprise à la dernière ligne chargée). |
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

## 10. Test automatisé

`sfd-angular` : `npm run e2e:migration` (spec `e2e/functional/migration/migration-lot.spec.ts`) rejoue le parcours complet sur la feuille Agences : doublon + type inconnu, correction, import, vérification en API, annulation. À lancer sur une base jetable (`scripts/edip-env/edip-env.sh up <nom>`), avec `BASE_URL` (Angular), `MONOLITH_URL` (API) si monolithe, et `E2E_EMAIL` / `E2E_PASSWORD` (rôle `ROLE_ADMIN` ou `ROLE_MIGRATION`).
