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
