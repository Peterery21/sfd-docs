# Audit fonctionnel complet — Module Comptabilité

**Date** : 2026-10-04 · **Portée** : paramétrage, écritures, journées, clôtures, trésorerie, lettrage, états financiers, rapports, intégrations dual-line avec caisse/épargne/crédit/commercial, i18n.

> **Mise à jour** : les 2 bugs majeurs initialement listés en §3 comme non corrigés ont été résolus dans une session de suivi (réécriture complète du Rapprochement Bancaire + chirurgie SQL sur les exercices dupliqués). Voir §0 ci-dessous. Un 3e bug (dashboard "période en cours" incohérente) a été découvert et corrigé pendant cette seconde passe.
>
> **Mise à jour 2 (session Clôtures + reste de l'audit)** : wizard de Clôture mensuelle réparé et mené à VALIDEE en navigateur (6 bugs backend/frontend dont une boucle infinie sur l'étape Validation) ; parcours de clôture réorganisé pour que l'écran Clôtures soit le point d'entrée unique (journalière/mensuelle/annuelle), avec redirection depuis les anciens boutons de Paramétrage Exercice/Période plutôt que suppression ; ~25 clés i18n "Titre"/"Description" placeholder corrigées sur les étapes de clôture ; lettrage automatique réparé (2 bugs) ; bug d'affichage de date (epoch 1970) sur Écritures en attente corrigé ; 30/34 rapports échantillonnés en aperçu (tous OK, 2 gaps de fonctionnalité confirmés en stub) ; écart de change audité (fonctionnel mais bugué, jamais branché au frontend) ; import de relevé bancaire audité (OFX en stub, CSV bloqué par donnée de seed incohérente) ; action de rejet d'écriture testée et validée de bout en bout ; un bug de comptage sur le dashboard (+ un crash de date sur Opérations échouées) découverts et corrigés. Détail en §0bis. Suite e2e complète re-exécutée : 169/170 (régression 0).

## 0. Corrections de suivi (post-rapport initial)

### Rapprochement Bancaire — réécriture complète
Le contrat frontend/backend a été entièrement réaligné (model, service, actions, reducer, selectors, 3 composants + templates). En testant bout en bout (création → ligne manuelle → pointage → rapprochement auto → validation), **4 bugs backend distincts** ont été mis au jour et corrigés :
1. `RapprochementBancaireServiceImpl` interrogeait le Plan Comptable et les lignes d'écriture avec `CompteBancaire.numeroCompte` (le numéro de compte physique à la banque) au lieu de `compteComptable` (le compte GL associé) — la création échouait pour tout compte bancaire existant.
2. `create()` ne renseignait jamais `codeAgence` sur l'entité créée → rapprochement invisible dans la liste (filtrée par agence), alors qu'il existait bien en base.
3. La requête de génération de séquence (`SUBSTRING(code_rapprochement, 5)`) prenait un mauvais offset → échec SQL dès le 2ᵉ rapprochement du même mois. La fonctionnalité n'avait donc jamais pu produire plus d'un rapprochement par mois.
4. `ajouterLigneReleve` levait une NullPointerException sur l'incrément d'un compteur jamais initialisé (MapStruct écrasait le défaut de l'entité avec le `null` du DTO de création).

Également ajouté : un nouvel endpoint/DTO backend (`EcritureNonRapprocheeDto`) pour permettre au frontend d'afficher réellement les écritures à pointer (la colonne "Écritures comptables" était un placeholder vide jusque-là) ; déplacement de l'import de relevé vers l'écran liste (le backend crée toujours un nouveau rapprochement à l'import, jamais attaché à un rapprochement existant — l'UI reflète maintenant ce comportement).

**Vérifié** : cycle complet testé en navigateur (création, ajout ligne manuelle, rapprochement automatique, annulation), suite backend complète 0 échec, `npm run build` 0 erreur, e2e:crud:compta 168-169/170 (1 flaky préexistant sans rapport).

### Exercices 2026 dupliqués — chirurgie SQL (autorisation explicite donnée par l'utilisateur sur la BD locale de test)
Analyse préalable des FK : l'exercice dupliqué (`EX2026`) n'avait qu'1 seule pièce réelle (une pièce de démo) et aucune référence ailleurs (clôtures, journées comptables, rapports, budget). Exécuté :
- Réaffectation de la pièce orpheline vers le vrai exercice/période.
- Suppression des 9 périodes vides du doublon.
- Suppression de l'exercice doublon.

Résultat : un seul exercice `EX-2026`, 167 pièces correctement réparties, plus aucun doublon dans les sélecteurs.

### Dashboard — "Période en cours" incohérente (bug découvert après la correction ci-dessus)
Causé par une recherche de période basée sur la date système réelle plutôt que sur la période réellement ouverte de l'exercice. Corrigé et vérifié : le dashboard affiche désormais une période cohérente avec son statut.

## 0bis. Session Clôtures + reste de l'audit (détail)

### Wizard de Clôture mensuelle — réparé de bout en bout
6 bugs trouvés et corrigés en menant une clôture réelle jusqu'à VALIDEE en navigateur :
1. `validerEtape()` backend ne faisait jamais avancer `cloture.etapeActuelle` (seul `executerEtape()` le faisait) — la validation manuelle d'une étape via l'UI ne faisait jamais progresser le wizard.
2. `ClotureDto` n'exposait pas `etapeActuelle`/`nombreEtapes` (champs présents sur l'entité mais jamais mappés) — le frontend ne pouvait pas savoir où en était le wizard.
3. `validerCloture()` ne déclenchait jamais la clôture réelle de la période/exercice (`ExerciceService.cloturerPeriode()`/`cloturerExercice()`, méthodes déjà existantes et testées, jamais appelées) — une clôture passait VALIDEE sans que la période/exercice sous-jacent ne se ferme.
4. `ajouterRegularisation()` : `id` de la régularisation créée toujours `null` dans la réponse (entité `IDENTITY` lue avant flush) — corrigé avec `saveAndFlush`.
5. **Boucle infinie critique** sur l'étape 4 (Validation) : un flag `isLoading` partagé était modifié par un fetch d'un composant enfant sans rapport (historique), ce qui détruisait/recréait le router-outlet du wizard en boucle (~130 req/s). Isolé dans un flag dédié `isLoadingHistorique`.
6. Contrat frontend/backend `ClotureInterface` largement désaligné (champs `reference`, `periodeDebut`, `mois`, `annee`… jamais fournis tels quels par le backend) — ajout de mappers `mapClotureFromApi()`/`mapEtapeFromApi()`/`parsePeriodeLibelle()` ; champs agrégés réellement absents du backend (`totalDebit`, `totalCredit`, `ecartDetecte`, `anomaliesCount`) rendus optionnels plutôt que simulés à zéro.

**Vérifié** : clôture mensuelle réelle menée de PRE_CLOTURE à VALIDEE en navigateur, période correctement clôturée en base à la fin. Suite backend 1145+ tests verts (2 tests ajoutés), build Angular 0 erreur.

### Réorganisation du parcours de clôture (déjà en place avant cette session) — complétée
- Action de clôture retirée de la page Journées Comptables ; la clôture journalière se fait désormais depuis la page Clôtures (type "Journalière" ajouté au modal "Nouvelle clôture", avec carte journée courante + bouton clôturer dédié).
- Boutons de clôture de Paramétrage > Exercice/Période : **conservés** mais redirigent désormais vers `/comptabilite/clotures` au lieu d'ouvrir une modale de clôture directe (décision explicite : rediriger plutôt que supprimer).
- ~25 clés i18n placeholder ("Titre"/"Description" litéral) corrigées sur les étapes de clôture (Pré-clôture, Régularisations, Contrôles, Validation, et tout le bloc Clôture Annuelle > Inventaire/Résultat).

### Clôture annuelle — bug trouvé et corrigé, wizard non terminé (mis en pause sur demande)
En testant le début du wizard annuel, la régularisation `id:null` (bug #4 ci-dessus) a été découverte et corrigée. Le reste du wizard annuel (étapes Résultat, À-nouveaux, États financiers) n'a pas été exercé — mise en pause explicite pour revenir au reste de l'audit, à reprendre ultérieurement.

### Lettrage automatique — 2 bugs corrigés
1. `lettrerAutomatique()` bornait la recherche à `LocalDate.now()` — excluait silencieusement toute écriture datée dans le futur (l'environnement de test simule 2027 alors que l'horloge système est 2026), rendant la fonctionnalité inopérante en pratique. Borne haute passée à une date lointaine.
2. Une fois le premier bug levé, un second est apparu : la requête de génération de séquence de code de lettrage (`SUBSTRING(l.codeLettrage, 5)`) prenait un offset fixe incorrect, cassant dès le 2ᵉ lettrage du mois (ex. `LET-2610-000001` → extrait `"2610-000001"`, non castable en entier). Offset rendu dynamique via `LENGTH(:prefix)`.

**Vérifié** : lettrage automatique testé de bout en bout en navigateur avec données réelles, suite backend verte.

### Écritures en attente — bug d'affichage de date (epoch 1970)
`EcritureEnAttenteContrepartieDto` sérialisait 3 champs `Instant` en nombre brut de secondes epoch (ex. `1791087525.982433000`), que `DatePipe` d'Angular interprétait à tort comme des millisecondes → affichage "21/01/1970". Corrigé avec `@JsonFormat(shape = STRING)`.

### Rapports — 30/34 échantillonnés en aperçu
Toutes les catégories couvertes (Exercices & Périodes, Journée Comptable, Lettrage & Rapprochement, Analytique & Ratios, Audit & Contrôle, Tableaux de Bord) : rendu PDF correct, aucune erreur bloquante. Deux gaps de fonctionnalité confirmés par lecture du code :
- **Suivi budgétaire (REP-CPT-028)** et **Cohérence inter-modules (REP-CPT-035)** sont des rapports **stub** : `AnalytiqueRapportProvider.controleCoherence()` retourne une seule ligne codée en dur (`module="CREDIT"`, aucun champ encours/écart/anomalies renseigné) ; `COHERENCE_INTER_MODULES` tombe dans un `default -> List.of()` (zéro ligne). Le commentaire du code ("données opérationnelles via integration-api") confirme que l'intégration avec les modules opérationnels (Crédit, Épargne) pour comparer encours applicatif vs encours comptable n'a jamais été câblée.
- Note cosmétique mineure : Tableau de bord clôtures affiche "Avancement : 1 en cours" en même temps que "Statut : VALIDÉE" (libellé contradictoire, pas un bug de données).

### Écart de change / réévaluation devise — audité, jamais branché au frontend
`EcartChangeServiceImpl` est une implémentation réelle (calcul + génération de pièce OD de régularisation), mais :
- Ne gère qu'un seul compte/devise par pièce (`findFirst()` sur les lignes en devise) — un écart sur une pièce multi-compte ou multi-devise serait mal réparti.
- Comptes de contrepartie (776000 gain / 676000 perte) et code journal "OD" codés en dur, non paramétrables.
- Aucune garde d'idempotence (rien n'empêche de régénérer deux fois l'écart pour la même pièce/date), aucune vérification du statut de la pièce avant traitement.
- **Aucun écran Angular n'appelle cette fonctionnalité** — recherche exhaustive sans résultat. Fonctionnalité orpheline côté backend uniquement.

### Import de relevé bancaire — OFX en stub, CSV bloqué par une donnée de seed incohérente
- `parseOFX()` est un stub qui logue un avertissement et retourne une liste vide — seul le CSV fonctionne réellement.
- Format CSV réel (non documenté dans l'UI) : séparateur `;`, colonnes `dateOperation;libelle;montantDebit;montantCredit;reference(optionnel)`, date stricte `dd/MM/yyyy`, première ligne ignorée sans validation.
- Test d'import CSV bien formé échoué avec `plancomptable.numero.notfound` : le `CompteBancaire` testé (id=2, AG001) référence `compteComptable="5212"`, mais aucune ligne `PlanComptable` avec ce numéro n'existe dans la base de dev — incohérence de données de seed entre `CompteBancaire` et `PlanComptable`, **pas un bug de code** (la requête de recherche est un simple `existsByNumeroCompte` sans filtre erroné). À corriger en alignant les données de seed, ou en ajoutant une validation au démarrage/à la création d'un compte bancaire qui vérifie l'existence du compte comptable lié.

### Rejet d'écriture — testé et validé de bout en bout
`POST /ecritures/numero/{numero}/rejeter?motifRejet=...` : autorisé depuis n'importe quel statut sauf `COMPTABILISEE` (y compris directement depuis BROUILLON), passe la pièce en `REJETEE` de façon définitive (pas de retour automatique en BROUILLON, pas de déblocage pour édition). Motif de rejet correctement persisté et affiché dans l'historique du détail d'écriture. Fonctionne comme attendu. Point mineur : aucun bouton "Rejeter" n'est exposé depuis l'écran de détail d'une écriture en BROUILLON (action accessible uniquement par API) — cohérent avec le fait que le rejet vise normalement des écritures soumises, mais à clarifier si le produit veut l'exposer davantage dans l'UI.

### Bugs découverts et corrigés en fin de session
- **Dashboard "Écritures à valider" comptait le mauvais statut** : `DashboardComptabiliteService.buildStats()` sommait `BROUILLON + VALIDEE` au lieu de `A_VALIDER + EN_VALIDATION`. Résultat : le widget affichait "1" alors que la liste filtrée par statut "À valider" était réellement vide, et inversement une vraie pièce "à valider" n'était pas comptée. Corrigé, tests unitaires et d'intégration mis à jour (un test d'intégration avait lui-même figé le bug dans son assertion). Vérifié en navigateur après redémarrage du service : le widget affiche désormais la valeur correcte.
- **Crash de date sur Opérations échouées** : `PieceEchecDto.dateRejet` sérialisé en tableau brut par Jackson, provoquant `NG02100 InvalidPipeArgument` sur `DatePipe` et un écran planté (détecté par la suite e2e, pas en navigation manuelle). Corrigé avec `@JsonFormat(shape = STRING)`, même pattern que les fixes de date précédents. Vérifié par re-exécution du test e2e ciblé (passe) et en navigateur.

**Régression finale** : suite backend complète verte (aucune régression), `npm run build` 0 erreur TS, `npm run e2e:crud:compta` → 169/170 (seul échec restant : `app-compte-auxiliaire-generation`, flaky déjà documenté en §2, sans rapport avec cette session).

## 1. Finding systémique prioritaire : résidus SYSCOHADA dans un plan comptable PCSFD

Le plan comptable réel de cette instance est en nomenclature **PCSFD 6 chiffres** (100000, 101000, 101100…, 490 comptes). Plusieurs zones de paramétrage ont été seedées ou configurées selon la convention **SYSCOHADA 3-4 chiffres** (401, 411, 521, 571, 661, 706…), qui ne correspond à **aucun compte existant** :

- **Types d'Opérations Comptables** (paramétrage) : les 5 types seedés (Règlement Fournisseur, Virement Salaire, etc.) référencent des comptes `4011`/`5211` — confirmé inexistants dans le Plan Comptable (recherche = "Aucun compte trouvé" sur 490 comptes). Ces types sont **inutilisables tels quels**.
- **Comptes bancaires existants** (9 comptes CB-AG...) : compte comptable lié = `5212`, également inexistant.
- **Comptes mobile money existants** : même pattern (`5522`).
- Déjà identifié indépendamment par un audit précédent ([[commercial-audit-2026-10-progress]]) sur le module Commercial.

**Nuance importante** : les écrans de *création* (Plan Comptable, Compte bancaire, Écriture manuelle) utilisent correctement un sélecteur lié au vrai Plan Comptable — ce n'est donc pas une faille de validation vivante, mais un résidu de données de démo/paramétrage initial jamais migré vers la nomenclature PCSFD. Le module **Commercial**, lui, a déjà une migration automatique (`SetupCommercialLoader.migrerSchemasHeritesSyscohada()`) qui corrige ce travers à chaque démarrage — **bon modèle à répliquer** pour la comptabilité (types d'opération) et pour les comptes bancaires/mobile money legacy.

**Conséquence concrète observée** : les écrans "Bilan"/"Compte de Résultat" directs (liasse SYSCOHADA officielle) sont **indisponibles** pour cette norme comptable (404 backend) — à la différence de la version sous Rapports (`REP-CPT-001`), qui fonctionne et affiche correctement les vrais comptes PCSFD groupés par nature.

**Recommandation** : écrire un loader de migration pour la comptabilité (sur le modèle du commercial) qui corrige les Types d'Opérations Comptables et les comptes bancaires/mobile money existants ; décider si la liasse SYSCOHADA officielle doit être abandonnée au profit du rapport `REP-CPT-001` (déjà fonctionnel) ou reconfigurée pour PCSFD.

## 2. Bugs corrigés dans cette session (vérifiés, 0 régression)

| # | Bug | Fichier(s) | Vérification |
|---|---|---|---|
| 1 | **ErrorInterceptor global détruisait le statut HTTP** de toute erreur non-401 (remplacé par une simple string) — empêchait TOUT composant de l'app de distinguer 404/409/etc. Cause racine du Bilan qui échouait silencieusement sans message. | `sfd-angular/core/helpers/error.interceptor.ts` | Bilan affiche désormais "Liasse SYSCOHADA officielle indisponible…" au lieu d'un écran vide. Build 0 erreur. |
| 2 | **Journées Comptables → onglet Écritures cassé** : `EcritureService.getAll()` mal typé, composant appelait `.sort()` sur un objet `Page` → `TypeError`, onglet bloqué en spinner infini, compteur "Nombre d'écritures" toujours à 0. | `sfd-angular/.../journee-detail.component.ts` | Les 108 écritures s'affichent, compteurs cohérents. |
| 3 | **Création de Compte bancaire impossible** : `codeAgence` jamais envoyé par le formulaire (control existant mais jamais peuplé) → 400 backend systématique. Bonus : les 9 messages de validation de `CompteBancaireDto` n'avaient aucune clé i18n (fr/en) — fuite du message brut `{comptebancaire.codeagence.notblank}`. | `sfd-angular/.../compte-bancaire-liste.component.ts`, `messages_fr/en.properties` | Création réussie en navigateur. Tests backend verts. |
| 4 | **Exercices comptables — validation manquante** : aucune règle n'empêchait un exercice de dépasser 12 mois ni une période d'être hors bornes de l'exercice. | `ExerciceServiceImpl.java` (validateBusinessRules + ajouterPeriode) | `ExerciceServiceTest`+3 autres classes verts. |
| 5 | **Gate d'architecture CA3 cassée** (préexistant, détecté en lançant la suite complète) : `"571"` en dur dans `sfd-epargne-service/.../LignesComptablesPublisherService.java`. Rendu configurable (`@Value`). | `LignesComptablesPublisherService.java` (épargne) | Gate + 682 tests épargne verts. |
| 6 | **i18n** : ~65 clés `MENUITEMS.COMPTABILITE.*` en anglais dans `fr.json` (copier-coller depuis `en.json`) — Écritures, Journée, Résultat, etc. | `fr.json` | `check-i18n-sync.js` : 21701 clés fr = 21701 clés en. |
| 7 | **Nettoyage** : routes `sycebnl/*` mortes (redirects résiduels confirmés, migrés vers `reporting-reglementaire`). | `comptabilite-routing.module.ts` | Aucune référence restante, build OK. |

Suite e2e module (`npm run e2e:crud:compta`) : **169-170/170** selon exécution ; l'unique échec intermittent porte sur `app-compte-auxiliaire-generation` (composant non touché par cette session), flaky préexistant.

## 3. ~~Bug majeur~~ — CORRIGÉ (voir §0) : Rapprochement Bancaire

~~Contrat frontend/backend totalement incompatible~~ → réécrit entièrement, 4 bugs backend additionnels trouvés et corrigés en testant bout en bout. Détail en §0.

## 4. ~~Anomalie de données majeure~~ — CORRIGÉE PAR CHIRURGIE SQL (voir §0)

~~Deux exercices "Exercice 2026" chevauchants~~ → analysés (une seule pièce réelle dans le doublon, zéro autre référence), fusionnés et dédupliqués. Un seul exercice `EX-2026` subsiste, toutes les pièces correctement rattachées. Détail en §0.

## 5. Redondances et incohérences signalées (non modifiées, décision architecturale à prendre)

- **Bilan/Compte de Résultat/Tableau des flux** : deux implémentations parallèles (`comptabilite/bilan` liasse SYSCOHADA directe, indisponible — vs `comptabilite/rapports/etats-financiers/bilan` REP-CPT-001, fonctionnel). Source de confusion ; recommandation : unifier ou clarifier l'usage de chacune.
- **Menu "Duplication paramétrage"** dupliqué avec l'entrée "Duplication" du sidebar Paramétrage (même écran, deux points d'accès).
- **Bug UI mineur** (Plan Comptable, Journaux) : après toggle de statut ou suppression d'une ligne, le filtre de recherche texte reste affiché mais la liste se réinitialise (affiche tout au lieu de rester filtrée).
- **Clôtures** : la liste ne se rafraîchit pas automatiquement après création (reload manuel nécessaire pour voir la nouvelle clôture) ; le libellé/référence/période de la clôture n'apparaissent pas dans le header du wizard (affiche "-").

## 6. Ce qui fonctionne correctement (validé par tests réels en navigateur)

- Plan Comptable : CRUD complet (création avec validation stricte classe/numéro, édition, toggle, suppression).
- Journaux comptables : CRUD complet.
- Paramètres généraux, Génération des comptes auxiliaires (testé : 486 analysés, 10 créés).
- Duplication paramétrage (aperçu copy/skip/block correct).
- Écritures : saisie manuelle, équilibrage temps réel, validation — écriture test créée et validée avec succès.
- Journées Comptables : dashboard, détail, statistiques (après fix §2.2).
- Trésorerie : Comptes bancaires (après fix §2.3), Comptes mobile money, Opérations bancaires — CRUD testés avec succès. Annulation des opérations : logique de restriction à la journée ouverte correcte.
- Clôtures : wizard mensuel démarre correctement, logique de garde (étape bloquée tant que brouillons/en attente existent) fonctionne.
- Rapports : 34 rapports disponibles, génération PDF testée (Bilan REP-CPT-001) avec données réelles cohérentes ; empty-states corrects quand pas de données.
- i18n : synchronisation fr/en complète après correction.
- Rapprochement Bancaire (après réécriture + fix §0) : création, ligne manuelle, rapprochement automatique, annulation — cycle complet testé en navigateur.
- Dashboard comptable (après fix §0 et §0bis) : exercice/période en cours cohérents, mouvements calculés sur les vraies bornes de période, compteur "Écritures à valider" désormais exact.
- Clôture mensuelle (après fix §0bis) : wizard complet PRE_CLOTURE → VALIDEE testé en navigateur, clôture réelle de la période déclenchée en base.
- Lettrage automatique (après fix §0bis) : exécution réelle testée en navigateur avec données de test.
- Rejet d'écriture : testé via API, transition de statut et motif persistés/affichés correctement.
- Opérations échouées (après fix §0bis) : écran fonctionnel, plus de crash sur les dates.

## 7. Non testé exhaustivement (contrainte de temps/données)

- Clôture annuelle : wizard testé jusqu'au début de l'étape Régularisations (bug régularisation trouvé et corrigé au passage) ; étapes Résultat, À-nouveaux et États financiers non exercées — mise en pause explicite, à reprendre.
- Import de relevé bancaire : CSV testé mais bloqué par une incohérence de données de seed (compte comptable référencé par `CompteBancaire` absent du Plan Comptable, voir §0bis) — logique de parsing non validée de bout en bout avec une insertion réelle. OFX confirmé non implémenté (stub).
- Écart de change : audité par lecture de code uniquement (implémentation réelle mais buguée, jamais appelée depuis le frontend) — pas de test fonctionnel en navigateur possible sans écran dédié.
- Les 4 rapports restants sur 34 n'ont pas été échantillonnés (30/34 couverts cette session, voir §0bis).

---
*Rapport généré après session d'audit exhaustif avec saisies réelles via navigateur intégré. Mémoire de session : `compta-audit-2026-10-progress.md`.*
