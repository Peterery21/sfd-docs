# S5 — socle Angular reporting réglementaire (lot 5a)

Branche `sfd-angular` : `feature/reporting-refonte-angular-socle`, commits 8bd68a8c puis de2db1f8 (local, rien poussé). Worktree : `<wt>/sfd-angular`.

## Fait
- Menu (shared-menu + horizontal-topbar) : Tableau de bord, Éditer, États financiers, Ratios, Export ZIP, Historique, Données importées (STANDALONE seulement), Configuration > Formules / Paramètres. Catalogue, Import, lien TFT retirés. Titre = « zone — pays ».
- Composant partagé `EnConstructionComponent` pour edition, etats-financiers, export-zip, historique, donnees-importees. Anciennes routes catalogue/import/formules/parametres redirigées.
- Store : slices `parametre` (GET/PUT /parametres) et `localisation` (GET /localisation) ; `zoneLayout` supprimé (edition-detail, ratios lisent `localisation`; `selectRapportLayout` dérive le type de layout du paquet, sections vides = tableau générique). `formule` réécrit sur le contrat v1.1 (liste par rapport, save/update/delete, réinitialiser formule/rapport/tout). Plus d'appel à zones/active, formules/sync|reset|vider|metadata.
- Page Paramètres (zone/pays lecture seule, version paquet, mode source, catégorie, en-tête, signataires via `app-modal-shell`).
- Page Formules de calcul : liste rapports + recherche, tableau libellé/code/« en clair », badges origine et confiance, panneau d'édition avec constructeur visuel (blocs Solde des comptes via `app-compte-selector`, Indicateur via `/rapports/{code}/references`, opérateurs, mode avancé), validation en direct, norme, aperçu (`app-exercice-selector` + date), valeur d'origine vs la vôtre, historique, `app-confirm-modal` x4 (plus de `confirm()`), `listState$`/`app-list-state`, `[appProcessingFlag]`. 501 sur valider/apercu : message « bientôt disponible », page intacte.
- Institution : `organisation` accepte RDC.
- i18n : `REPORTING_REG.FORMULES.*`, `REPORTING_REG.PARAMETRES.*`, `REPORTING_REG.EN_CONSTRUCTION.*`, `MENUITEMS.REPORTING_REGLEMENTAIRE.{EDITER,ETATS_FINANCIERS,EXPORT_ZIP,HISTORIQUE,DONNEES_IMPORTEES,CONFIGURATION,…}` en fr/en/ln (ln = français ; en partiel, reste en français). `check-i18n-sync.js` vert (25199 clés).
- e2e : nouveau `e2e/functional/reporting-reglementaire/reporting-configuration.spec.ts` (formule modifiée → badge personnalisée → réinitialisée → paquet ; mode standalone → entrée Données importées) ; spec existante mise à jour (catalogue retiré, routes paramètres).

## Vérification (faite)
- `scripts/claude/regress.sh sfd-angular` : BUILD OK (25 warnings), deux fois (avant/après v1.2).
- Navigateur intégré sur base démo jetable (baseline r16, monolithe :8100 + reporting 84ca433 en jar sur :4607 + `ng serve` proxifié) : Formules (liste, ouverture, modif norme → « Personnalisée », valeur d'origine vs la vôtre, historique, réinitialisation via confirm-modal → « Paquet »), Paramètres (mode standalone → entrée « Données importées » apparaît, retour intégré → disparaît), éditions, détail édition (tableau générique), ratios : aucune erreur reporting (toutes réponses 200).
- e2e `npx playwright test --project=reporting-reglementaire` : 10 passed (45 s). Base supprimée, services arrêtés, worktrees détachés retirés.
- Bug trouvé et corrigé en navigateur : saisie « Nombre » (type=number) cassait `ajouterNombre`.
- Limites d'environnement : aperçu (`/formules/apercu`) atteint le backend mais la compta du jar monolithe de la baseline n'expose pas `/consultation/balance` → l'écran affiche l'erreur serveur (« Balance comptable indisponible… ») proprement ; valeur d'aperçu non vue. `SOLDE()` : `/formules/valider` répond « Référence inconnue « SOLDE » » (attendu jusqu'à S6) ; l'écran l'affiche et bloque l'enregistrement. Param de la baseline sans zoneLibelle/pays : le titre retombe sur le code de zone.

## Décisions v1.2 appliquées
- Calcul mixte : `SOLDE("10,11", D) / R5_DEN * 100` généré par le constructeur ; un seul bloc de comptes = champ `comptes`. Chaque bloc a son sens.
- DTO optionnels : `paysLibelle` (titre, repli code pays), `categoriesAssujetti` (select, repli dérivé des rapports), `comptesEffectifs`, `aConfirmerArt44`, `planEdipIncomplet`.
- Retour utilisateur : édition de formule en modale large `app-modal-shell` à deux colonnes (construction à gauche ; aperçu, valeur d'origine, historique à droite), qui se ferme à l'enregistrement réussi. Aperçu : sélecteur d'agence ajouté (le backend refuse la balance consolidée) ; statut `ERREUR` géré.

## Écarts avec le contrat / les maquettes / le brief
- Hors périmètre modifiés (minimal) : `core/services/module-registry.service.ts` (+`refreshMenu()`, hooks `condition`/`prepare`), `layouts/shared-menu/menu.model.ts`.
- Spec e2e dans `e2e/functional/reporting-reglementaire/` (projet Playwright existant), pas `functional/reporting/`. Les specs lisent `.auth/user.json` en dur : copier `E2E_AUTH_FILE` vers ce chemin pour les lancer hors CI.
- `import-balance-wizard` et le store `catalogue-reglementaire` gardés hors routes ; S7 les retire.
- Sélecteur de compte mono-valeur : puces alimentées une sélection à la fois.
- `ConformiteApercu` : le backend renvoie `ERREUR` (absent du contrat v1.2 pour `ApercuFormuleDto.conformite`) : à ajouter au contrat.

## Points à valider par un comptable / ambiguïtés
| Question | Choix provisoire | Source |
|---|---|---|
| Calcul mixte comptes + indicateurs | Oui via SOLDE() (décision orchestrateur) | REPORTING_API_CONTRAT.md v1.2 |
| Badge « à valider » pour confiance MOYENNE/BASSE | Affiché sur ligne et rapport | brief S5 |
| Bouton % = « × 100 » | Ajoute `* 100` | maquette formules |

## Corrections de la revue opus (appliquées, SHA c7c0a982)
1. Références qualifiées : table `RAPPORT.LIGNE` + `CODE[N-1]` + `@ALIAS`, plus long code d'abord, jeton inconnu / MIN / MAX => null => mode avancé ; l'édition attend le chargement des références.
2. Mode avancé avec un bloc de comptes : prérempli `SOLDE("<comptes>", <sens>)`, retour au constructeur sans perte.
3. Ligne non touchée : `comptes` / `expression` d'origine rendus tels quels (empreinte du constructeur), donc elle reste PAQUET. Test unitaire `formule-builder.util.spec.ts` (8 cas, relecture et écriture des formes de paquet) vert.
4. Indicateur d'un autre rapport inséré qualifié (objet ng-select, plus de bindValue).
5. `prepare` après contrôle module et rôle ; `menu-state` sans relance après erreur, remis à zéro sans jeton.
6. Menu horizontal : `condition` sur Données importées.
7. Retirés : import Excel des éditions, store et wizard import-balance, store catalogue et page shell `rapports/:code`.
8. Enregistrer en `appBusy` sur `isLoadingEdition$`.
En plus : raison sociale facultative (elle bloquait l'enregistrement du mode sur une base neuve).
Vérifié : unit 8/8, BUILD OK, navigateur (UEMOA-REP-PRU-01 R1_NUM, références `DIMF-2000-BIL.xxx` : ouverture en 31 blocs, enregistrer sans modifier => PAQUET ; SOLDE en mode avancé), e2e reporting-reglementaire 11 passed ; base, services et worktree retirés.

## Re-review (SHA 35b8898f)
- reportingMenuState.reset() branché sur logout$ (account/store/Authentication/authentication.effects.ts, hors périmètre, une ligne) ; tests : authentication.effects.spec (logout), menu-state.spec.
- compilationRetenue() extrait en util ; tests : expression et comptes rendus à l identique pour une ligne non modifiée, recompilation dès modification.
- layouts/horizontal-topbar/menu.ts et menu.model.ts supprimés (aucun import : le topbar lit shared-menu).
- unit 18/18 (reporting + account), BUILD OK.
