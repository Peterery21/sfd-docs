# S7 — Pages Angular du reporting : édition, états financiers, ratios, ZIP, données importées, historique, tableau de bord (lot 5b) — modèle sonnet

Lire d'abord `COMMUN.md` (même dossier), le contrat v1.2 (`<WT>/sfd-docs/reglementation/REPORTING_API_CONTRAT.md`, sections 3 « Éditions », « Données importées », « États financiers »), `sfd-angular/CLAUDE.md`, puis les handoffs `<WT>/.claude/handoff/reporting-refonte-angular-socle.md` (S5 : store, menu, composants) et `reporting-refonte-zip-ef.md` (S6 : DTO réels des exports, du ZIP, des états financiers et des ratios).
Maquettes de référence : `<WT>/sfd-docs/design/reporting/stitch/*.png|html` et le `README.md` (« seule la zone de contenu fait foi »). Thème : `/Users/pierreadopre/Projects/erp-sfd/.stitch/DESIGN.md`.

## Branche
`sfd-angular` : `feature/reporting-refonte-angular-edition`, créée depuis `feature/reporting-refonte` (35b8898f, qui contient S5).
Backend déjà fusionné : `sfd-reporting-service` `feature/reporting-refonte` (029ea57) et `sfd-comptabilite-service` (5becf1d). Pour vérifier dans le navigateur, crée des worktrees **détachés** de ces deux dépôts.

## Pages (remplacer les composants « en construction » posés par S5)
1. **Éditer les rapports** (`/edition`), maquette `edition` :
   - à gauche, les rapports de la zone groupés par périodicité, avec statut et échéance (`GET /editions/tableau-periode`), en retard en rouge ;
   - à droite :
     - en-tête : source, badge de confiance, régulateur ;
     - période, agence ou consolidé (`app-agence-select`, `app-exercice-selector`), bouton Générer ;
     - tableau : code, libellé, N, N-1, variation, norme, conformité ; ligne en `ERREUR` → message affiché, jamais 0 ;
     - onglets Résultat, Saisie manuelle (`PATCH` lignes `SAISIE`) et Éditions précédentes ;
     - panneau Contrôles de cohérence (`GET /editions/{id}/controles`) : un CRITIQUE bloque Valider (409 → message) ;
     - actions Valider, Clôturer, Soumettre au régulateur, Export PDF/Excel. Natures DOCUMENT et EXTERNE : écran « document à joindre » ou « format externe ».
   - En mode STANDALONE, la génération est consolidée seulement (le backend refuse le reste).
2. **États financiers** (`/etats-financiers`), maquette `etats-financiers` :
   - onglets Bilan, Compte de résultat, TFT, Notes (`GET /etats-financiers?type=&periodeFin=`) ;
   - colonnes Brut, Amort.-Prov., Net N, Net N-1 ; badge « équilibré » ; ligne avec `erreur` → message ; export PDF/XLSX ;
   - **Onglet TFT** : la session S9 produit un composant partagé `shared/components/tableau-flux-tresorerie/`. S'il n'est pas encore fusionné quand tu arrives à cet onglet, affiche un tableau simple et laisse un `TODO-S9` **dans le handoff uniquement** (pas dans le code) ; l'orchestrateur branchera le composant.
3. **Ratios prudentiels** (`/ratios-prudentiels`), maquette `ratios-prudentiels` :
   - liste des ratios de la zone : valeur, norme, conformité, N-1, détail numérateur/dénominateur ;
   - **corriger l'appel existant**, qui envoie encore `exerciceId` : il faut `periodeFin`. Modèle `RatiosPrudentielsInterface` à aligner sur le DTO de S6 (`valeurPrecedente`, `conformite`, `erreur`, `statutFeu` incluant `ERREUR`, `valeurCalculee` nullable).
4. **Export groupé (ZIP)** (`/export-zip`), maquette `export-zip` : période, cases à cocher des rapports avec statut, formats PDF/XLSX, « générer les manquants » ; téléchargement du blob ; affichage du manifest (erreurs par rapport) ; plafond dépassé → message clair.
5. **Données importées** (`/donnees-importees`, visible seulement en STANDALONE), maquette `donnees-importees` :
   - assistant en 4 étapes : télécharger le modèle (`/donnees-importees/modele`), déposer le fichier, contrôle (`/preview` : équilibre, comptes inconnus, sous-totaux rejetés, annexes manquantes), confirmer ;
   - puis la liste des lots, avec suppression (`app-confirm-modal`).
6. **Historique des éditions** (`/historique`), maquette `historique` : liste filtrable (`app-server-pagination`, `listState$`), statut, score qualité, actions voir et exporter.
7. **Tableau de bord** (`/dashboard`), maquette `dashboard` : KPI (à faire, en retard, ratios conformes), échéances à venir, dernières éditions.
8. Retirer les anciens composants devenus inutiles (`editions-liste`, `edition-detail`, `catalogue`, anciennes pages SYCEBNL…), **après un grep** des routes et des imports. Mettre à jour le routing.

## Règles
- Composants partagés obligatoires : `app-modal-shell`, `app-confirm-modal` (jamais `Swal` ni `confirm()`), sélecteurs, `ProcessingService` + `app-busy-area` (rapports en `local`, écritures en `blocking`), `listState$`/`app-list-state`, `appBusy`.
- i18n fr/en/ln synchronisés (`scripts/check-i18n-sync.js`).
- Pas d'endpoint hors contrat. Si tu rencontres un écart, signale-le dans le handoff ; ne modifie pas le backend.

## Fin
- `scripts/claude/regress.sh sfd-angular` → BUILD OK.
- e2e `e2e/functional/reporting-reglementaire/` complété : générer un rapport UEMOA (ligne en erreur visible), validation bloquée par un contrôle critique, ZIP téléchargé, import STANDALONE en 4 étapes, ratios affichés avec norme. Lancer tout le projet e2e reporting → 0 échec.
- Navigateur intégré sur base démo jetable (sous verrou, après `resources.sh 2048`) : parcourir chaque page comme un utilisateur et vérifier qu'Accueil et Formules ne régressent pas.
- Handoff `reporting-refonte-angular-edition.md` : clés i18n, écarts maquette/contrat, points à valider.
