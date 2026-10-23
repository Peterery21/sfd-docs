# Maquettes du reporting réglementaire EDIP (lot 4)

Desktop 1440 px, français, données UEMOA / Togo en FCFA. Thème : `.stitch/DESIGN.md` (Velzon « institutional banking »).
Les maquettes sont des HTML autonomes (CSS inline, Open Sans, RemixIcon) régénérables ; captures Playwright en `.png`.
Elles sont produites en repli HTML/CSS, sans passer par le MCP Stitch. Contrat d'API : `sfd-docs/reglementation/REPORTING_API_CONTRAT.md` (v1.1).

| Écran | Fichiers | Route Angular | DTO principaux |
|---|---|---|---|
| Tableau de bord | `dashboard` | `/dashboard` | `StatutRapportPeriodeDto[]`, éditions récentes |
| Éditer les rapports | `edition` | `/edition` | `StatutRapportPeriodeDto`, `RapportEditionDto`, `ControleCoherenceDto` |
| Formules de calcul | `formules` | `/configuration/formules` | `FormuleDto`, `ValidationFormuleDto`, `ApercuFormuleDto`, `HistoriqueFormuleDto` |
| États financiers | `etats-financiers` | `/etats-financiers` | `EtatFinancierDto` |
| Export groupé (ZIP) | `export-zip` | `/export-zip` | `ExportZipRequest` |
| Données importées | `donnees-importees` | `/donnees-importees` (mode STANDALONE) | `ImportPreviewDto`, `ImportLotDto` |
| Paramètres | `parametres` | `/configuration/parametres` | `ReportingParametreDto` |
| Historique des éditions | `historique` | `/historique` | `RapportEditionDto` (score de qualité) |

## Composants partagés EDIP à utiliser (`sfd-angular/src/app/shared/`)
| Bloc | Composant |
|---|---|
| Réinitialiser formule / rapport / tout, supprimer une ligne ou un import, valider / clôturer / soumettre | `app-confirm-modal` (jamais `Swal.fire` ni `confirm()`) |
| Panneau d'édition de formule, aperçu d'une édition, ajout de signataire | `app-modal-shell` |
| Sélecteur multiple de comptes (bloc « Solde des comptes ») | `app-compte-selector` |
| Exercice, période, agence (édition, états financiers, ZIP, historique) | `app-exercice-selector`, `app-agence-select` |
| Génération, import, export, chargement des tableaux | `ProcessingService` + `app-busy-area` |
| Onglets Résultat / Saisie / Éditions ; Bilan / CR / TFT / Notes | `nav-tabs-custom` |

## Tokens CSS (repris de DESIGN.md)
| Token | Valeur | Usage |
|---|---|---|
| `--primary` / `--primary-dark` | `#475569` / `#334155` | boutons, onglet actif, titres |
| `--secondary` | `#64748b` | texte atténué |
| `--page` / `--card` / `--border` | `#f3f6f9` / `#fff` / `#e9ebec` | fond, cartes |
| succès | `#047857` sur `#d1fae5` | validé, conforme, équilibré |
| info | `#0369a1` sur `#e0f2fe` | information, validé, ajoutée |
| alerte | `#b45309` sur `#fef3c7` | brouillon, personnalisée, avertissement |
| danger | `#b91c1c` sur `#fee2e2` | en retard, non conforme, critique |
| rayon / ombre | `6px` / `0 1px 2px rgba(56,65,74,.15)` | cartes, boutons |
| tableaux | lignes 44 px, en-tête `#f3f6f9`, nombres à droite (tabular-nums) | |

Les textes de badge utilisent toujours la teinte foncée (WCAG AA).

## Règles d'interface décrites par les maquettes
- Bandeau supérieur : zone et pays en lecture seule (« UEMOA · BCEAO — Togo »), version du paquet, mode source. Aucun sélecteur de zone.
- Statuts d'une édition : A_FAIRE (gris), BROUILLON / EN_COURS (alerte), VALIDE (info), SOUMIS / CLOTURE (succès), REJETE (danger). Échéance dépassée : texte rouge doux.
- Validation bloquée tant qu'un contrôle de cohérence de niveau CRITIQUE est en échec (voir `edition`).
- Formules : libellé métier en premier, code en second ; origine = badge PAQUET (gris) / PERSONNALISEE (alerte) / AJOUTEE (info) ; « En clair » = `libelleClair` ; aperçu en direct = `ApercuFormuleDto`.
- Menu « Données importées » visible seulement en mode STANDALONE.

## Designs Stitch (MCP `mcp__stitch__*`)
Projet Stitch « EDIP — Reporting réglementaire » : `projects/770809064070056787` ([ouvrir](https://stitch.withgoogle.com/projects/770809064070056787)).
Design system (créé depuis `.stitch/DESIGN.md`, desktop) : `assets/016cc0a5f4f347fbb040973be5ff767d`.
Fichiers : `stitch/<ecran>.html` + `stitch/<ecran>.png` (2560 px de large = rendu desktop Stitch ; modèle Gemini 3.5 Flash-Lite, le modèle par défaut expire).

| Écran | Fichiers `stitch/` | ID écran Stitch |
|---|---|---|
| Tableau de bord | `dashboard` | `b0d5deb4a7f944fa960c2a3fdbd77890` |
| Éditer les rapports | `edition` | `fc7b4735ad234b039db71d4cdaa2fa60` |
| Formules de calcul | `formules` | `0a3185b529994f389e747f1caed1d96a` |
| États financiers | `etats-financiers` | `5799a6f1efea437681b3b91fac3c3e76` |
| Export groupé (ZIP) | `export-zip` | `825e3909a4694b7dab7eecea1f3ea7d8` |
| Données importées | `donnees-importees` | `425724baec514b99b4ec8a142a1fe8f6` |
| Paramètres | `parametres` | `bf45df92567a4808bab758f47ee317a8` |
| Historique des éditions | `historique` | `21545dcda90547e0a80d4791696feb56` |
| Ratios prudentiels (nouveau) | `ratios-prudentiels` | `c09195d7effb43f5974ed3ebde15b0c4` |
| Tableau des flux de trésorerie (TFT, S9) | `tft` | — maquette HTML/CSS (repli : `generate_screen_from_text` a expiré 2 fois) ; données de démonstration |

Lien d'un écran : `https://stitch.withgoogle.com/projects/770809064070056787?node-id=<ID>`.

Chaque `edit_screens` de Stitch crée en général une nouvelle version d'écran (nouvel id) : les ids ci-dessus sont les versions finales (v2 corrigée après revue de contenu). Les anciennes versions restent dans le projet.

Corrections de fond appliquées (revue orchestrateur) : menu et bandeau du module, normes UEMOA exactes (Instr. 010-08-2010 et 016-12-2010, codes `UEMOA-REP-PRU-01…10`), lignes `R5_NUM/R5_DEN/R5_COEF`, comptes RCSFD (10 Valeurs en caisse, 11 Banques, 25 Comptes des membres), statuts du contrat (À faire, Brouillon, En cours, Validé, Soumis, Clôturé, Rejeté), exports PDF/Excel uniquement, plus de XBRL, de « synchronisé » ni d'agrément.

Limites : les valeurs chiffrées, les noms de signataires et les dates sont des **données de démonstration** ; la page est à lire comme une maquette de structure. `edition` : le tableau ne montre que le rapport sélectionné (PRU-05). Écarts possibles restants : certains libellés de contrôle (« Évolution des créances en souffrance ») et le bloc « Indicateurs UEMOA clés » du tableau de bord sont de remplissage Stitch, non issus du contrat. Les anciennes maquettes S3 (`../*.html`) restent la référence de contenu.

## Règles de lecture des designs Stitch
- **Seule la zone de contenu fait foi.** Barre latérale, barre du haut, nom de l'application et chip de zone des écrans Stitch sont ignorés : dans l'Angular, le contenu s'insère dans le layout EDIP existant.
- **Paramètres et Formules de calcul** : la référence reste la version déjà implémentée (maquettes S3 en HTML, puis S5 Angular). Les écrans Stitch correspondants ne servent que d'**inspiration visuelle**.
- Contenu corrigé sur Ratios prudentiels, Éditer les rapports, Tableau de bord, États financiers (RCSFD, DIMF-2000-BIL), Export ZIP, Données importées et Historique (normes UEMOA 010-08-2010 / 016-12-2010, codes `UEMOA-REP-PRU-01…10`, comptes RCSFD, statuts du contrat, pas de XBRL).
