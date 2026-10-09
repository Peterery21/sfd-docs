# Initialiser une base locale : wizard avec mode démo

Une base vide se prépare **par le wizard de démarrage** (`/setup` dans l'application). Il remplace les anciens
`app.demo-data.enabled` / `DEMO_DATA_ENABLED` propres à chaque module.

## Parcours

1. Base vide (PostgreSQL ou SQL Server), démarrer `sfd-commun-service` puis les modules voulus.
2. Ouvrir l'application : elle redirige vers `/setup`.
3. Étape « Institution » :
   - **Coche Mode démonstration** : charge des données cohérentes pour tous les modules.
   - **Pays** : fixe la zone réglementaire (UEMOA, CEMAC ou RDC), la devise et les jeux de données (noms, villes,
     agences, banques, opérateurs mobile money, téléphones, e-mails).
   - **Secteur** (SFD ou Entreprise) : avec la zone, fixe la norme et donc le **plan comptable**
     (UEMOA SFD → RCS_SFD, CEMAC SFD → COBAC, RDC SFD → PCCI, entreprise → SYSCOHADA).
4. En démo, l'agence siège et l'administrateur sont **générés** : l'écran final affiche l'e-mail et un mot de passe
   aléatoire **une seule fois**, puis la progression du chargement module par module.
5. « Aller à la connexion » quand le statut est terminé.

Sans coche démo, le wizard garde ses 4 étapes (agence et administrateur saisis).

## Fonctionnement

- Contrat : `DemoSeeder` (module `sfd-integration-api`, package `integration.demo`). Chaque module expose un ou
  plusieurs beans ; ils ne se déclenchent **que** par le wizard.
- Chaque module publie `POST /internal/demo/seed` et `GET /internal/demo/status` (en-tête `X-Setup-Secret`, secret
  `app.setup.secret` / `SETUP_SECRET`).
- L'orchestrateur est dans `sfd-commun-service` (`DemoSeedOrchestrator`) : seeders locaux d'abord, puis les modules
  de `app.demo.modules` dans l'ordre de dépendance (URLs `DEMO_<MODULE>_URL`). Un module injoignable est **ignoré**
  (rapporté `SKIPPED`), un module en erreur est rapporté `FAILED` et les suivants continuent.
- Progression : `GET /api/preference/setup/demo/status`.
- Relance : chaque seeder est idempotent (rien n'est dupliqué).
- Monolithe : même interface, appel en processus, aucune URL à configurer.
- Données par pays : `sfd-demo-data` (8 pays UEMOA, RD Congo, Cameroun) + `DemoLocale` (devise, indicatif,
  capitale, domaine).

## Limites connues

- Paie : cotisations et barèmes existent seulement pour TG, CI, SN ; rien n'est inventé pour CD et CM.
- Les montants de démonstration ne sont pas convertis en CDF ou XAF.
- Le seed de comptabilité génère ~2200 comptes auxiliaires par agence : c'est la partie la plus longue.
