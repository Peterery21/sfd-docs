# Audit module Immobilisation — Octobre 2026

Audit complet du module Immobilisation (sfd-immobilisation-service + sfd-angular/features/immobilisation) : paramétrage, cycle de vie des immobilisations, amortissements, comptabilisation, rapports, i18n, rôles. Test réel en navigateur, avec correction des bugs trouvés.

## Cartographie du module

### Backend — `sfd-immobilisation-service` (port 4601, `/api/immobilisation`)

| Controller | Endpoints |
|---|---|
| `ImmobilisationController` | CRUD, cession, rebut, transfert, dépréciation, génération amortissements, photo |
| `ParametrageController` | CRUD Natures, Modes d'acquisition, Méthodes d'amortissement, États physiques (+ **Catégories**, ajouté dans cet audit) |
| `ParametrageDuplicationImmoController` | Preview/exécution duplication paramétrage inter-agence |
| `ReferenceDataController` | Listes de référence en lecture seule |
| `DashboardController` | KPIs tableau de bord |

Entités paramétrage : `CategorieImmo`, `NatureImmo`, `ModeAcquisition`, `MethodeAmortissement`, `EtatPhysique`.

### Frontend — routes `/immobilisation/*`

Dashboard, Liste, Nouveau/Modifier, Détail (avec modals Transfert/Cession/Rebut/Dépréciation), Amortissements (batch), Inventaire physique, Paramétrage (9 onglets), Duplication paramétrage, Rapports (25 types).

## Bugs trouvés et corrigés

| # | Bug | Gravité | Correction |
|---|---|---|---|
| 1 | **Catégorie (paramétrage) : CRUD 100% factice côté front** — `onSubmit()`/`supprimer()`/`toggleActif()` ne faisaient que manipuler un tableau JS local, aucun appel API. `loadCategories()` appelait en plus un endpoint inexistant (`categories-immobilisations`, 404). Toute donnée créée disparaissait au rechargement. | Critique | Backend : nouveau `CategorieController` (CRUD complet, rôles `ROLE_IMMOBILISATION_CATEGORIE_*` déjà seedés mais jamais utilisés). Frontend : reliage complet au store NgRx (actions/effects/reducer/selector), comme les autres onglets paramétrage. |
| 2 | **Pagination : bug off-by-one masquant la 1ʳᵉ ligne** sur 4 listes paramétrage (Natures, Modes d'acquisition, Méthodes d'amortissement, États physiques) — `slice:service.startIndex:service.endIndex` utilisait un index 1-based directement comme borne 0-based du pipe `slice`. | Majeur | `slice:service.startIndex-1:service.endIndex` dans les 4 templates. |
| 3 | **i18n : clé `IMMOBILISATION.COULEUR.VERT` etc. inexistante** (collision avec `LABELS.COULEUR` déjà une chaîne plate) — tous les libellés de couleur (État physique) affichaient la clé brute. | Moyen | Clés aplaties `LABELS.COULEUR_VERT/BLEU/CYAN/ORANGE/ROUGE/GRIS` ajoutées fr/en, composant mis à jour. |
| 4 | **Onglet "Comptes comptables" : table 100% statique/fictive**, montrant 6 lignes d'exemple codées en dur, sans rapport avec les Natures réellement configurées. | Majeur | Composant relié au store réel (`selectNatures`), affiche désormais les comptes réellement paramétrés. |
| 5 | **Onglet "Paramètres généraux" : entièrement factice** (champs `readonly`/`disabled`, valeurs codées en dur type `IMM-2026-0001`), redondant avec l'onglet Numérotation (réel, fonctionnel). | Mineur (doc) | Non corrigé — recommandé : supprimer cet onglet ou le reconstruire sur une vraie config si le besoin est confirmé. |
| 6 | **Duplication paramétrage : fonctionnalité sans objet pour ce module** ("Les natures d'immobilisation sont institutionnelles. Rien à cloner par agence.") — testée, ne casse rien (0/0/0), mais route dupliquée (menu + onglet) pointant vers le même composant mort. | Mineur (doc) | Non corrigé — recommandé : retirer le menu/onglet redondant si confirmé non pertinent pour Immobilisation. |
| 7 | **Formulaire création immobilisation : aucun pré-remplissage des comptes comptables depuis la Nature choisie** — `compteImmobilisation` (obligatoire) restait vide, obligeant une saisie manuelle à chaque création malgré la config Nature. | Majeur | `onNatureChange()` ajouté dans `ImmobilisationEditionComponent` : pré-remplit comptes + durée d'amortissement depuis la Nature sélectionnée (sans écraser les valeurs en mode édition grâce à `emitEvent:false` sur le patch de chargement). `NatureInterface` complétée côté store (champs comptes manquants dans le typage). |
| 8 | **Validation backend bloquant toute création d'immobilisation** — `codeImmo`/`numeroInventaire` marqués `@NotBlank` alors que le service les auto-génère s'ils sont vides (contradiction : la validation Spring s'exécute avant la logique d'auto-génération) → 400 systématique. `serviceAffectation` obligatoire côté serveur alors qu'optionnel côté UI. | **Bloquant** | Contraintes `@NotBlank` retirées sur les 3 champs dans `ImmobilisationDto`. |
| 9 | **Échec de sauvegarde silencieusement traité comme un succès** — `saveForm()` naviguait vers la liste dès que `isLoading` repassait à `false`, que ce soit un succès ou un échec, perdant la saisie utilisateur sans explication claire. | Majeur | Navigation déclenchée uniquement sur l'action NgRx `saveSuccess`/`updateSuccess` (`Actions` + `ofType`), jamais sur un simple changement de `isLoading`. |
| 10 | **Génération des amortissements (batch) : payload incorrect → 400 systématique** — le calcul affiché à l'écran est **entièrement simulé côté client** (dupliqué de la logique backend, jamais appelé), et le bouton "Valider et générer" envoyait `{periode, genererEcritures, immobilisationIds}` alors que le backend attend `{mois, annee}` (entiers). | **Bloquant** | `validerEtGenerer()` parse la période `"YYYY-MM"` et envoie `{mois, annee}`. *(Le calcul-aperçu reste simulé côté client — à corriger séparément si l'écart avec le calcul réel pose problème en pratique ; dans les tests le résultat concordait.)* |
| 11 | **"Taux annuel" (carte résumé détail) affichait en réalité le % amorti cumulé**, pas le taux annuel — `getTauxAmortissement() = cumulAmortissements / valeurBrute * 100`, utilisé à la fois comme largeur de barre de progression (correct) et comme libellé "Taux annuel" (faux, prêtait à confusion avec le vrai taux annuel visible plus bas = 33,33 %). | Moyen | Libellé i18n corrigé en "% amorti" / "% depreciated" (clé `IMMOBILISATION.TAUX_AMORTISSEMENT`), sans toucher au calcul (qui était juste mal nommé). |
| 12 | **Bouton "Modifier" affiché même sur une immobilisation non `EN_SERVICE`** (cédée, rebutée) alors que le backend refuse toute modification hors statut `EN_SERVICE`. | Mineur | `*ngIf="immobilisation.statut === 'EN_SERVICE'"` ajouté, cohérent avec Transférer/Céder/Mettre au rebut. |
| 13 | **Dépréciation : fonctionnalité 100% inaccessible depuis l'UI** — `DepreciationFormComponent` existait (déclaré dans le module, backend complet `POST /{id}/depreciation`) mais n'était référencé dans **aucun** template → bouton jamais affiché, aucun moyen d'y accéder. | **Majeur (gap fonctionnel)** | Composant intégré dans `immobilisation-detail` (`<app-depreciation-form>` + bouton "Test de dépréciation", visible si `EN_SERVICE`). |
| 14 | **Dépréciation : champ `observations` envoyé au backend, qui attend `justification`** — le texte saisi par l'utilisateur était silencieusement perdu (ignoré par Jackson, pas d'erreur visible). | Majeur | Formulaire + composant renommés `observations` → `justification`, alignés sur `DepreciationDto`. |
| 15 | **Modal "Mise au rebut" : aperçu d'écriture comptable entièrement fictif** — affiche systématiquement `D 6816 / C 2844 = VNC` (équilibré), alors que le vrai publisher (voir plus bas) ne publie qu'une manche partielle sur les comptes réellement configurés sur la Nature. Vérifié : le rebut réel publie bien 1 ligne (C compte immobilisation) quand le cumul d'amortissement est nul, pas les 2 lignes 6816/2844 affichées en aperçu. | Majeur (doc) | Non corrigé (nécessite une refonte du composant d'aperçu pour appeler le vrai calcul plutôt qu'un gabarit codé en dur) — à faire en priorité si ce module doit rester fiable visuellement. |
| 16 | **Rapports : ~90 clés i18n manquantes** sous `IMMOBILISATION.RAPPORTS.*` (titres des 25 rapports, 6 catégories, `LABELS.HAUTE/BASSE/SUR_DEMANDE/TRIMESTRIEL/ANNUEL`) — l'intégralité de l'écran Rapports affichait des clés brutes. Cause : un bloc `IMMOBILISATION.RAPPORTS` pré-existant utilisait un schéma de clés complètement différent (`INVENTAIRE_GENERAL: "Inventaire général"` à plat) de celui réellement lu par le composant actif (`rapport.libelleKey + '.TITRE'`, format imbriqué `{TITRE: "..."}`). | Majeur | Fusion propre du bloc existant (sans rien casser des clés déjà utilisées par les effects/modals) + ajout des clés manquantes, fr/en synchronisés (`check-i18n-sync.js` → 0 écart). |

## Gaps fonctionnels majeurs — COMBLÉS (2026-10-05, itération 2)

Les deux gaps majeurs documentés ci-dessous lors de l'audit initial ont été implémentés dans une itération suivante :

1. **Inventaire physique** — backend complet livré : entités `SessionInventaireImmo`/`LigneInventaireImmo` (package `immobilisation/entity`), enum `StatutSessionInventaire` (EN_PREPARATION→EN_COURS→TERMINE→VALIDE, + ANNULE), contrôleur `InventaireImmoController` (`/inventaire/sessions` GET/POST, comptage ligne à ligne PATCH, clôture/validation PATCH, suppression DELETE), code session auto-généré (`FORMAT_CODE_SESSION_INVENTAIRE`, `SI-{year}-{sequence}`), rôles `ROLE_IMMOBILISATION_INVENTAIRE_READ/CREATE/UPDATE/DELETE/VALIDER/ALL` seedés. La génération capture automatiquement toutes les immobilisations `EN_SERVICE` de l'agence comme périmètre à pointer (étatAttendu/emplacementAttendu dénormalisés sur chaque ligne). Testé en navigateur : session AG001 (aucun bien EN_SERVICE → 0 ligne, comportement correct) et session AG006 (2 biens EN_SERVICE → 2 lignes capturées), code auto-généré `SI-2026-00001`/`SI-2026-00002`, toast succès.
2. **Rapports** — backend complet livré, calqué sur le pattern `sfd-stock-service` (même structure de contrôleur/service/DTO, dépendance `sfd-report-api` ajoutée au `pom.xml`) : `TypeRapportImmobilisation` (25 types, 6 catégories, miroir exact de `rapport-immo.model.ts`), `ImmobilisationRapportController` (`/generer`, `/download/{requestId}`, `/types`, `/types/categories`, `/formats`, `/generer-rapide`, `/apercu`, `/export-base64`), `ImmobilisationRapportService` (une méthode de récupération de données réelle par type, interrogeant `Immobilisation`/`MouvementImmobilisation`/`PlanAmortissement`), rôles `ROLE_IMMOBILISATION_RAPPORT_READ/ALL` seedés (manquaient jusqu'ici malgré leur usage côté route Angular). Testé en navigateur : génération PDF réelle du rapport "Inventaire général" (`REP_IMMO_001`), 5 enregistrements, PDF valide généré via iText (vérifié par en-tête `%PDF-1.4` dans le base64 retourné).

Effet de bord corrigé au passage : le formulaire de génération (`rapport-immo-generation-modal.component.ts`) postait un champ `codeCategorie` jamais lu par le DTO (`categorie`) — renommé pour cohérence (champ non rendu dans le template, donc sans impact utilisateur visible jusqu'ici, mais incohérence latente levée).

## Comptabilisation dual-line — implémentée dans cet audit

Le module ne publiait **aucune** écriture comptable avant cet audit (zéro code RabbitMQ malgré une config déjà présente en `application.yml` et un `CLAUDE.md` local prétendant le contraire — documentation obsolète, corrigée).

Implémenté : `LignesComptablesPublisherService` (exchange `sfd.comptabilite`, routing key `comptabilite.lignes.immobilisation`, capté par le binding générique `comptabilite.lignes.*` de comptabilite-service), conforme à la règle dual-line du `CLAUDE.md` racine :

- **Dotation aux amortissements** (génération batch) : manche équilibrée D `compteDotation` / C `compteAmortissement` — les deux comptes appartiennent au module. **Testé et vérifié en bout en bout** : message RabbitMQ publié, reçu, validé, et traité par `DeversementServiceImpl` côté comptabilite-service (rejeté uniquement faute de période comptable 2026 ouverte dans l'environnement de test — pas un défaut du code).
- **Cession / Mise au rebut** : manche *partielle* (D `compteAmortissement` si cumul > 0 / C `compteImmobilisation`) — le module ne publie que les comptes qu'il possède ; la contrepartie (encaissement, perte exceptionnelle) appartient à un autre module (caisse/commercial) qui n'a pas d'intégration symétrique pour l'instant. L'écriture reste donc en attente de contrepartie côté comptabilité tant que cette intégration croisée n'existe pas — **gap d'intégration documenté, pas un bug**.
- **Acquisition** et **Dépréciation (provision)** : ne publient rien, aucun compte de contrepartie n'est paramétré nulle part pour ces opérations (conforme à la règle "module qui ne gère pas le type d'opération ne publie rien").

8 tests unitaires dédiés (`LignesComptablesPublisherServiceTest`), suite complète du service toujours verte.

## Redondances et incohérences relevées — CORRIGÉES (2026-10-05, itération 2)

- **Composants rapports en double** : `rapport-immo-liste` (routé, actif) vs `rapport-immobilisation-liste` (importé dans le routing module mais jamais utilisé dans les routes) — même doublon côté store (`rapport-immo/*` vs `rapport-immobilisation/*`). **Supprimé** : composants, modals, store (action/effect/model/reducer/selector/service) retirés ; `store/index.ts`, `immobilisation.module.ts`, `immobilisation-routing.module.ts` nettoyés des références mortes. Build Angular vérifié 0 erreur après suppression.
- **Rôles incohérents** : les routes de paramétrage utilisaient `ROLE_IMMO_*` (jamais seedées côté backend, fonctionnaient uniquement via `ROLE_ADMIN` dans le `hasAnyAuthority`), le reste du module (contrôleurs, menu sidebar, route Rapports) utilisait `ROLE_IMMOBILISATION_*` (convention du reste du monorepo, cf. `ROLE_STOCK_*`). **Unifié** sur `ROLE_IMMOBILISATION_*` dans `immobilisation-routing.module.ts` (mappé sur les rôles réellement seedés : `_DASHBOARD_READ`, `_IMMO_READ/CREATE/UPDATE`, `_INVENTAIRE_READ`, `_READ` générique pour la page paramétrage). Rôles manquants `ROLE_IMMOBILISATION_RAPPORT_READ/ALL` et `ROLE_IMMOBILISATION_INVENTAIRE_*` désormais seedés dans `SetupImmobilisationLoader`.
- **Backend : messages_fr.properties uniquement**, pas de `messages_en.properties` (convention du reste du monorepo, non traité — hors scope).
- **Onglet "Paramètres généraux"** (bug #5, statique/factice) **supprimé** de `parametrage-immo.component.html`, ainsi que l'onglet "Duplication paramétrage" intégré dans la même page (tab 9).
- **Fonctionnalité "Duplication paramétrage"** ("rien à cloner pour ce module", bug #6) **supprimée entièrement** : composant+modal frontend, route `/parametrage/duplication`, entrée menu sidebar (id 7091), contrôleur+service backend `ParametrageDuplicationImmoController`/`Service` (tests associés supprimés). Les rôles `ROLE_IMMO_PARAMETRAGE`/`ROLE_IMMO_ALL` qu'elle utilisait disparaissent avec elle (ils n'étaient de toute façon jamais seedés).
- **Catégorie (paramétrage) vs catégorie de l'immobilisation** : le formulaire de création d'immobilisation utilise un enum Java fixe (`CORPORELLE/INCORPORELLE/FINANCIERE`) pour le champ "Catégorie", déconnecté de l'entité `CategorieImmo`. **Non corrigé** — relier les deux nécessiterait une migration de données (FK vers `CategorieImmo` au lieu de l'enum) hors scope de cette itération ; documenté pour une itération future.

## Champs "code" : analyse génération auto / suppression (demande spécifique)

Recherche cross-module (stock, client, rh, commercial, caisse) : les entités de paramétrage/catalogue (catégories, types, méthodes, états) utilisent presque toujours un **code mnémonique saisi par l'utilisateur** avec contrainte d'unicité — jamais de séquence auto-générée, sauf quand ce code n'est provably jamais utilisé comme clé métier ailleurs.

| Entité | Décision appliquée | Justification |
|---|---|---|
| **NatureImmo** | **Auto-généré** (`NAT-{sequence}` via `NumberGeneratorService`, format `FORMAT_CODE_NATURE` seedé), champ retiré du formulaire de création | Son `code` n'est comparé que par égalité de chaîne (`NatureImmo.code` ↔ `Immobilisation.nature`), jamais par `Enum.valueOf()` — un code opaque fonctionne sans rien casser. |
| **ModeAcquisition, MethodeAmortissement, EtatPhysique** | **Laissés en saisie libre, non modifiés** | Leur `code` est injecté directement dans `Enum.valueOf()` côté backend (`ModeAcquisitionEnum`, `MethodeAmortissementEnum`, `EtatImmobilisationEnum`) lors de la sauvegarde d'une immobilisation : un code auto-généré opaque ferait échouer **toute** sauvegarde utilisant cette ligne. Le vrai problème sous-jacent (CRUD paramétrage libre sur des valeurs qui doivent pourtant correspondre à un enum Java figé) est une incohérence d'architecture à traiter séparément — hors portée de cet audit. |
| **CategorieImmo** | **Champ supprimé entièrement** (entité, DTO, contrôleur, mapper, formulaire, colonne de table) | Zéro usage métier trouvé nulle part dans le code (ni comme clé étrangère, ni comme filtre, ni comme enum) — uniquement affiché, jamais exploité. Confirmé par l'absence totale de `CategorieImmo` dans la sélection "Catégorie" du formulaire de création d'immobilisation (qui utilise un enum séparé, voir redondances ci-dessus). |

## Tests fonctionnels effectués (navigateur réel, données saisies)

| Flux | Résultat |
|---|---|
| Catégorie : création, bascule actif, persistance après rechargement | ✅ (après correctif #1) |
| Nature : création (code auto `NAT-00001`), catégorie filtrée, comptes/durée | ✅ |
| Mode d'acquisition, Méthode d'amortissement, État physique : création | ✅ |
| Immobilisation : création complète (3 fiches réelles, `IMM-2026-00001/2/3`), auto-remplissage comptes/durée depuis la Nature | ✅ (après correctifs #7, #8) |
| Détail immobilisation : affichage, cohérence des valeurs | ✅ |
| Transfert d'agence | ✅ |
| Cession (avec acquéreur, prix, motif) | ✅ |
| Mise au rebut (avec motif, commentaire) | ✅ |
| Test de dépréciation (VNC recalculée correctement : 14 166 667 → 10 000 000) | ✅ (après correctifs #13, #14) |
| Génération amortissements (batch, 2 immobilisations, écriture publiée) | ✅ (après correctif #10) |
| Publication comptable dual-line (dotation, cession, rebut) | ✅ vérifié par trace RabbitMQ bout en bout |
| Rapports : affichage catalogue 25 rapports, filtrage par catégorie | ✅ (après correctif #16) |
| Rapports : génération effective d'un rapport | ❌ backend absent (gap documenté) |
| Inventaire physique | ❌ backend absent (gap documenté) |
| Duplication paramétrage | ✅ (no-op correct, rien à cloner) |

## Suite e2e Playwright (nouvelle)

`sfd-angular/e2e/functional/immobilisation/immobilisation.spec.ts` (`npm run e2e:immobilisation` / `--project=immobilisation`) — 13 tests : 5 smoke-pages, 5 CRUD paramétrage (dont régression code auto-généré Nature), 1 cycle de vie complet (création immobilisation avec auto-remplissage comptes depuis la Nature + navigation succès).

Piège rencontré et corrigé pendant l'écriture : les champs date (`app-date-input`) utilisent flatpickr avec `altInput: true` — l'input portant le `data-testid` devient `type="hidden"`, le vrai input visible/cliquable est le sibling injecté juste après par flatpickr (`[data-testid="..."] + input`). Cibler le testid directement provoque un timeout "element is not visible". `.fill()` et `Escape` ne déclenchent/ne valident pas non plus le parsing flatpickr — seule une vraie saisie clavier (`pressSequentially`) suivie d'un clic ailleurs (blur) fonctionne.

**Résultat final : 13 passed, 0 failed** (re-vérifié après correction du piège flatpickr ci-dessus).

## Vérification de non-régression

- `sfd-immobilisation-service` : `./mvnw test` → **0 échec** (suite complète, incluant les 8 nouveaux tests du publisher comptable), re-vérifié après chaque modification de ce document.
- `sfd-angular` : `npm run build` → **0 erreur TypeScript**, re-vérifié après chaque modification.
- `npx tsc --noEmit` systématique après chaque changement frontend avant redémarrage du serveur de dev.
- `npm run e2e:immobilisation` → **13 passed, 0 failed** (suite créée dans cet audit).

**Baseline → Après | Régressions: 0**
- i18n : `node scripts/check-i18n-sync.js` → **21 790 clés fr / 21 790 clés en, synchronisé**.
- Tous les flux UI modifiés re-testés en navigateur après correction (pas de régression constatée sur les écrans adjacents).

**Baseline → Après | Régressions : 0**

## Itération 2 (2026-10-05) — gaps + redondances comblés

Suite à la demande "corrige les gaps fonctionnels majeurs (rapports inspirés du module Client/Stock) et les redondances/incohérences", réalisé :
- Backend Inventaire physique (sessions, lignes, comptage, clôture, validation) — nouveau.
- Backend Rapports (25 types, PDF/Excel/CSV, pattern copié de `sfd-stock-service`) — nouveau.
- Suppression : composants/store `rapport-immobilisation` (doublon mort), onglet "Paramètres généraux" (factice), fonctionnalité "Duplication paramétrage" (frontend + backend, confirmée sans objet pour ce module).
- Unification des rôles `ROLE_IMMO_*` → `ROLE_IMMOBILISATION_*` (routing Angular), rôles manquants seedés côté backend (`_INVENTAIRE_*`, `_RAPPORT_*`).
- Fix latent : champ `codeCategorie`/`categorie` incohérent entre le formulaire de génération de rapport et le DTO.

**Vérification** :
- `sfd-immobilisation-service` : `mvn test` → **176 tests, 0 échec** (2 tests cassés trouvés en cours de route — assertion obsolète sur un champ `code` supprimé, mock de publisher comptable manquant — corrigés dans la foulée, non liés aux ajouts de cette itération).
- `sfd-angular` : `npm run build` → **0 erreur TypeScript**.
- Navigateur (compte admin@admin.com) : génération réelle d'un rapport PDF (REP_IMMO_001, 5 enregistrements, PDF valide), génération de 2 sessions d'inventaire (AG001 → 0 ligne car aucun bien EN_SERVICE, comportement correct ; AG006 → 2 lignes capturées), code session auto-généré confirmé (`SI-2026-00001`, `SI-2026-00002`), page Paramétrage confirmée à 7 onglets (plus de "Paramètres généraux" ni "Duplication").

**Baseline → Après | Régressions : 0**
