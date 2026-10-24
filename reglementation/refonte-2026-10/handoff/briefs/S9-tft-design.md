# S9 : refonte du design du tableau des flux de trésorerie (TFT). Modèle sonnet

Lire d'abord `COMMUN.md` (même dossier) et `sfd-angular/CLAUDE.md`. Demande de l'utilisateur : l'écran actuel du TFT a un design « pas très intéressant » et doit être revu.

## Écran actuel
`sfd-angular/src/app/features/comptabilite/view/etats-financiers/tableau-flux.component.{html,ts}` (route `/comptabilite/tableau-flux`) : un formulaire et un tableau plat.
Le backend compta du TFT vient d'être corrigé par S6 (flux signés selon le Guide SYSCOHADA, variations N − N-1). Il est sur `sfd-comptabilite-service` `feature/reporting-refonte` après fusion de S6 ; regarde le DTO renvoyé.

## 1. Design dans Stitch (MCP `mcp__stitch__*`, skill `stitch-kit:stitch-orchestrator`)
- Projet existant `770809064070056787`, design system `assets/016cc0a5f4f347fbb040973be5ff767d` (thème `/Users/pierreadopre/Projects/erp-sfd/.stitch/DESIGN.md`).
- Écran desktop 1440 px « Tableau des flux de trésorerie — SYSCOHADA », avec :
  - **En-tête** : exercice N comparé à N-1, choix agence ou consolidé, export PDF/Excel.
  - **5 cartes KPI** : ZA ouverture, ZB opérationnel, ZC investissement, ZF financement, ZH clôture avec la variation par rapport à N-1.
  - **Graphique en cascade** de ZA à ZH.
  - **Badge de contrôle** « ZH = trésorerie nette du bilan ».
  - **Tableau en sections repliables** : A opérationnel FA-FE/ZB, B investissement FF-FJ/ZC, C capitaux propres FK-FN/ZD, D capitaux étrangers FO-FQ/ZE, puis ZF, ZG et ZH. Colonnes N, N-1 et variation ; négatifs entre parenthèses en rouge.
  - **Panneau latéral de détail** des comptes d'une ligne.
- Prompt détaillé déjà rédigé : reprends la structure ci-dessus avec couleurs et tailles. Si `generate_screen_from_text` expire ou répond « succès » sans écran dans `list_screens`/`get_project`, réessaie une fois avec un prompt plus court. Si ça échoue encore, fais une maquette HTML/CSS selon DESIGN.md, et signale-le dans le rapport.
- Exporte le HTML et le PNG dans `sfd-docs/design/reporting/stitch/tft.{html,png}`, sur la branche sfd-docs `feature/reporting-refonte-tft`. Ajoute une ligne au README.

## 2. Implémentation Angular
Branche `sfd-angular` `feature/reporting-refonte-tft`, depuis `feature/reporting-refonte` (35b8898f).
- Composant **partagé** `shared/components/tableau-flux-tresorerie/`, en entrée : lignes (code, libellé, section, N, N-1, note, comptes contributeurs). Il comprend les KPI, la cascade (ApexCharts, déjà utilisé dans le projet), l'accordéon et le panneau de détail. Il doit pouvoir être réutilisé tel quel par S7 dans l'onglet TFT de la page États financiers du reporting.
- L'écran compta `tableau-flux.component` utilise ce composant. Conserve `app-exercice-selector` et `app-agence-select`, `ProcessingService`/`app-busy-area`, et les `data-testid` existants (`compta-tft-btn-generer`, etc.), sinon l'e2e existant casse.
- i18n fr/en/ln synchronisés.

## Périmètre
- **Modifiables** : `sfd-angular/src/app/shared/components/tableau-flux-tresorerie/**`, `features/comptabilite/view/etats-financiers/tableau-flux.component.*`, `assets/i18n/*` (clés `COMPTABILITE.TFT.*` et `SHARED.TFT.*`), `sfd-docs/design/reporting/stitch/tft.*` et le README.
- **Exclus** : le backend et les pages du reporting (S7).

## Fini quand
- `scripts/claude/regress.sh sfd-angular` affiche BUILD OK.
- Vérification dans le navigateur intégré sur une base démo jetable (compta, commun, Angular ; sous verrou, après `resources.sh 2048`) : le TFT s'affiche avec ses KPI, sa cascade et son accordéon, et les chiffres sont identiques à ceux de l'écran précédent.
- L'e2e compta qui couvre le TFT reste vert (le trouver par grep sur `compta-tft`).
- Les deux branches sont commitées, rien n'est poussé. Envoie le rapport au format fixe à l'orchestrateur.
