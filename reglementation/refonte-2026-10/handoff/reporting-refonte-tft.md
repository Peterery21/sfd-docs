# S9 — refonte design TFT

## Livré
- sfd-docs `feature/reporting-refonte-tft` ff3750c : maquette `design/reporting/stitch/tft.{html,png}` + ligne README. Stitch (`generate_screen_from_text`) a expiré 2 fois (prompt long puis court), aucun écran créé : repli HTML/CSS selon DESIGN.md.
- sfd-angular `feature/reporting-refonte-tft` : composant partagé `shared/components/tableau-flux-tresorerie/` (selector `app-tableau-flux-tresorerie`, déclaré/exporté par SharedModule, NgApexchartsModule ajouté à SharedModule) ; écran `tableau-flux.component` migré ; clés `SHARED.TFT.*` fr/en/ln.
- API composant : `[lignes]: TftLigne[]` (code, libelle, note, n, n1, incomplet, comptes?), `[exerciceN]`, `[exerciceN1]`, `[controleOk]: boolean|null`, `[testIdPrefix]`. Helper `tftLignesFromEtat(etat: EtatLiasse)` dans `tableau-flux-tresorerie.model.ts` pour S7 (onglet TFT).
- data-testid : `<prefix>-root|kpis|kpi-ZA..|cascade|controle|table|section-A..D|ligne-<code>|ouvrir|fermer|detail|detail-fermer` ; écran compta prefix `compta-tft` ; boutons `compta-tft-btn-generer`, `compta-tft-btn-export-excel`.

## Vérifications
- `regress.sh sfd-angular` : BUILD OK (le premier build avait échoué sur un import ApexAxisChartSeries manquant, corrigé). Pas de baseline relevée avant changement.
- Navigateur (Playwright headless, base jetable `sfd_tft9` clonée de r17, monolithe :8101, front monolith construit depuis ce worktree) : KPI ZA/ZB/ZC/ZF/ZH identiques au JSON de l'API ; accordéon, panneau de détail et cascade OK. Seul 404 : `/api/reporting/parametres` (layout, hors TFT). Base et processus supprimés ensuite.
- Pour tester : institution.norme_comptable passée à SYSCOHADA dans la base jetable (la démo est RCS_SFD, d'où 404 « norme indisponible » sinon) + redémarrage monolithe.
- E2E `crud/comptabilite-crud.spec.ts` « rapport flux tresorerie loads » : NON exécuté (il exige `.auth/test-ids.json` du projet `setup`). Équivalent manuel : chargement de l'écran sans erreur API TFT.
- Données démo quasi vides (ZH 32 330 000, flux A/B/D à 0, contrôle COHERENCE_TRESORERIE en échec) : les montants négatifs en rouge/parenthèses et la cascade avec baisses n'ont pas été vus sur données réelles.

## Écarts / lacunes
- Agence/consolidé : non branché, l'API liasse n'a pas de paramètre agence.
- Export PDF : absent (Excel conservé).
- Comptes contributeurs : le DTO n'en fournit pas ; le panneau affiche un message. Entrée `comptes` prête si le backend les ajoute.
- L'écran n'utilisait ni `app-exercice-selector` ni `app-busy-area` avant : introduits ; exercice choisi par id.
- Capture .png : maquette HTML, pas un rendu Stitch.

## Points à valider par un comptable / ambiguïtés
- Regroupement des sections : A=FA–FE (ZB), B=FF–FJ (ZC), C=FK–FN (ZD), D=FO–FQ (ZE), puis ZF, ZG, ZH. Source : `etats-financiers.json` (état TFT), libellés des sections issus du brief. Choix provisoire : sections déduites du code, pas d'un champ du DTO.
- Variation affichée en % vs N-1 : montant N − N-1 divisé par |N-1| (absolu si N-1 = 0). Choix provisoire, à confirmer.
- Agence/consolidé, export PDF, comptes contributeurs : non exposés par le backend (liasse sans paramètre agence, pas de PDF, DTO sans comptes). Hors périmètre S9 ; choix provisoire : filtre agence absent, Excel seul, panneau de détail sans comptes. Source : `EtatsFinanciersController` (feature/reporting-refonte).

## Suite revue opus (8 points corrigés, commit sfd-angular voir rapport)
- ZA en ligne d'ouverture ; lignes non classées → groupe « Autres lignes » (jamais supprimées).
- variation = null si N ou N-1 absent ; montant absent affiché « — » (composant seulement).
- `incomplet` propagé via `TFT_DEPENDANCES` (modèle) : section, ZB…ZH, KPI, lignes de total, cascade (barres éclaircies, libellé « * », note, tooltip).
- Formateur `shared/utils/montant-format.ts` (shared ne dépend plus d'une feature) ; adaptateur `features/comptabilite/view/etats-financiers/tft-adapter.ts` (S7 écrit le sien). `formatLiasseMontant` non modifié (export Excel).
- Détail via NgbOffcanvas (Échap OK) ; libellés cascade recalculés sur onLangChange ; ancien résultat visible sous busy-area (min-height 320 px).
- Vérif : BUILD OK, navigateur sur base jetable : ZA visible, partiel FA→ZB/ZG/ZH + KPI ZB/ZH + note cascade, Échap ferme, KPI = API.
