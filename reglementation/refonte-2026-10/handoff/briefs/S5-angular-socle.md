# S5 : socle Angular du reporting réglementaire (lot 5a), modèle sonnet

Lire d'abord `COMMUN.md` (même dossier), le contrat v1.1 (`<WT>/sfd-docs/reglementation/REPORTING_API_CONTRAT.md`, sections 2 et 3 : paramètres, localisation, formules), puis `sfd-angular/CLAUDE.md`.
Maquettes à suivre : `<WT>/sfd-docs/design/reporting/` (`README.md`, `formules.png/html`, `parametres.png/html`, `dashboard.png`). Thème : `/Users/pierreadopre/Projects/erp-sfd/.stitch/DESIGN.md`.

## Branche
`sfd-angular` : `feature/reporting-refonte-angular-socle`, créée depuis `feature/reporting-refonte` (eb0e97ef = develop à jour).

## But
Mettre en place le nouveau menu du module, le store, la page Paramètres et la page **Formules de calcul**. Cette page est pensée pour un utilisateur non technique. Le backend est déjà en place pour les paramètres, la localisation et le CRUD/réinitialisation des formules. `/formules/valider` et `/formules/apercu` répondent 501 jusqu'à la fusion de S4 : il faut gérer ce cas proprement, avec le message « aperçu bientôt disponible » et sans casser la page.

## Travail
1. **Menu** (`layouts/shared-menu/menu.ts` l. 1014-1080 et `layouts/horizontal-topbar/menu.ts`) : le module garde son id et sa `moduleKey`. Sous-menu, dans l'ordre :
   - Tableau de bord ;
   - Éditer les rapports ;
   - États financiers ;
   - Ratios prudentiels ;
   - Export groupé (ZIP) ;
   - Historique des éditions ;
   - Données importées (visible seulement si `modeSource = STANDALONE`) ;
   - Configuration : Formules de calcul, Paramètres.

   On retire Catalogue, Import et le lien TFT vers la compta. Les routes des pages qui ne sont pas encore livrées par S7 (édition, états financiers, ZIP, données importées, historique) pointent sur un composant « en construction » partagé, à créer une seule fois et simplement. Le titre du module affiche la zone (« UEMOA · BCEAO — Togo »).
2. **Store NgRx** : nouvelles slices `parametre` (GET/PUT `/parametres`) et `localisation` (GET `/localisation`).
   - Supprimer la slice `zoneLayout`, le sélecteur de zone et les appels aux endpoints retirés (`zone-layout.service.ts` en entier ; dans `formule.service.ts`, les appels `formules`, `metadata`, `sync`, `reset` et `vider`).
   - Le modèle `organisation` de l'institution doit accepter RDC.
3. **Paramètres** (maquette `parametres`) :
   - zone et pays en lecture seule ;
   - version du paquet ;
   - mode source Intégré / Standalone, avec une explication ;
   - catégorie d'assujetti (pilote la variante allégée ou développée en UEMOA) ;
   - en-tête et signataires.
4. **Formules de calcul** (maquette `formules`) :
   - Colonne gauche : la liste des rapports de la zone, avec une recherche. Colonne droite : un tableau lisible, avec le libellé métier d'abord et le code ensuite, plus les badges d'origine (paquet, personnalisée, ajoutée) et de confiance (« à valider » si MOYENNE ou BASSE, « à confirmer art. 44 », « plan EDIP incomplet »).
   - Panneau latéral d'édition, avec un **constructeur visuel** :
     - un bloc « Solde des comptes » avec `app-compte-selector` en sélection multiple et un sens D/C/solde ;
     - un bloc « Indicateur », qui liste les lignes via `GET /rapports/{code}/references` ;
     - des opérateurs en boutons ;
     - une expression en langage clair ;
     - un mode avancé texte (optionnel).
   - Validation en direct (`/formules/valider`), aperçu de la valeur sur une période (`/formules/apercu`, avec `app-exercice-selector` et une date), norme « doit être ≥ / ≤ / = ».
   - « Valeur d'origine contre la vôtre », Réinitialiser (formule, rapport ou tout, via `app-confirm-modal` : **supprimer les `confirm()` natifs** de `formules-liste`), Historique.
5. Composants partagés obligatoires : `app-modal-shell`, `app-confirm-modal`, les sélecteurs, `ProcessingService` avec `app-busy-area`, `listState$` avec `app-list-state`. Jamais de `Swal.fire` ni de spinner à la main.
6. **i18n** : ajouter les clés de tes pages dans `assets/i18n/fr.json`, `en.json` et `ln.json` (en `ln`, reprendre le français si tu ne peux pas traduire). `scripts/check-i18n-sync.js` doit rester vert.
7. **e2e** : `e2e/functional/reporting/` sur le modèle des specs existantes (`requireServices`). Parcours à couvrir : ouvrir Formules, modifier une formule, vérifier le badge « personnalisée », la réinitialiser, vérifier le retour à « paquet ». Paramètres : changer le mode source, puis vérifier que le menu Données importées apparaît.

## Périmètre
- Modifiables : `sfd-angular/src/app/features/reporting-reglementaire/**`, `layouts/shared-menu/menu.ts`, `layouts/horizontal-topbar/menu.ts`, `assets/i18n/{fr,en,ln}.json` (clés `REPORTING_REG.*` et `MENUITEMS.REPORTING_REGLEMENTAIRE.*` uniquement), `e2e/functional/reporting/**`, et le modèle d'institution pour RDC.
- Exclus : les autres features, et les pages d'édition, d'états financiers, de ZIP et d'import (S7).

## Vérification
- `scripts/claude/regress.sh sfd-angular` : BUILD OK.
- Navigateur intégré, sur une base démo jetable (`scripts/edip-env/edip-env.sh up rep-s5 --baseline <rN>`, identifiants dans `creds.env`, jamais affichés) avec `./dev.sh start reporting` sous verrou : dérouler le parcours Formules et Paramètres comme un utilisateur, et vérifier que les écrans qui partagent ces données ne régressent pas.
- `npm run e2e:reporting` (ou le projet Playwright du module) : 0 échec. Arrêter les services et supprimer la base jetable à la fin.
- Handoff `reporting-refonte-angular-socle.md` : clés i18n ajoutées, écarts avec la maquette, points à valider.
