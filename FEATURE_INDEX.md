# ERP-SFD — Feature Index (routing agent)

> Routing "par cas d'usage" → service + instructions + specs.  
> Usage agent : identifier le(s) fichier(s) à charger pour une tâche donnée.

---

## Comment utiliser

1. Trouver cas d'usage ci-dessous → lire service CLAUDE.md (quick-ref)
2. Si implémentation complexe → charger le fichier instructions indiqué
3. Si specs fonctionnelles requises → charger fichier analyse indiqué

---

## Crédit

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Dossier crédit (création, instruction, décision) | [sfd-credit-service](../sfd-credit-service/CLAUDE.md) | [credit-module.instructions](../analyse/.github/instructions/credit-module.instructions.md) | [analyse/backend/credit/](../analyse/backend/credit/) |
| Déblocage fonds | sfd-credit-service | credit-module.instructions | analyse/backend/credit/ |
| Remboursement (échéance, anticipé, partiel) | sfd-credit-service | credit-module.instructions | analyse/backend/credit/ |
| Garanties (nantissement, caution, hypothèque) | sfd-credit-service | credit-module.instructions | — |
| Gestion impayés / provisions | sfd-credit-service | credit-module.instructions | — |

## Épargne

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Compte épargne (ouverture, clôture) | [sfd-epargne-service](../sfd-epargne-service/CLAUDE.md) | [epargne-module.instructions](../analyse/.github/instructions/epargne-module.instructions.md) | [analyse/backend/epargne/](../analyse/backend/epargne/) |
| Dépôt / retrait épargne | sfd-epargne-service | epargne-module.instructions | analyse/backend/epargne/ |
| DAT (dépôt à terme) | sfd-epargne-service | epargne-module.instructions | — |
| Tontine / groupe | sfd-epargne-service | epargne-module.instructions | — |

## Client / KYC

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Création / mise à jour client | [sfd-client-service](../sfd-client-service/CLAUDE.md) | [client-module.instructions](../analyse/.github/instructions/client-module.instructions.md) | [analyse/backend/client/](../analyse/backend/client/) |
| KYC / LBC-FT | sfd-client-service | client-module.instructions | analyse/backend/client/ |
| Bénéficiaires / procurations | sfd-client-service | client-module.instructions | — |

## Caisse

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Saisie opération caisse (dépôt/retrait) | [sfd-caisse-service](../sfd-caisse-service/CLAUDE.md) | [caisse-module.instructions](../analyse/.github/instructions/caisse-module.instructions.md) | — |
| Clôture journée caisse | sfd-caisse-service | caisse-module.instructions | — |
| Chèques / effets | sfd-caisse-service | caisse-module.instructions | — |

## Comptabilité

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Écritures comptables / journal | [sfd-comptabilite-service](../sfd-comptabilite-service/CLAUDE.md) | [comptabilite-module.instructions](../analyse/.github/instructions/comptabilite-module.instructions.md) | [analyse/backend/comptabilite/](../analyse/backend/comptabilite/) |
| Journée comptable (ouverture/clôture) | sfd-comptabilite-service | comptabilite-module.instructions | analyse/backend/comptabilite/ |
| Plan comptable SYSCOHADA | sfd-comptabilite-service | comptabilite-module.instructions | — |
| Clôture mensuelle / annuelle | sfd-comptabilite-service | comptabilite-module.instructions | — |

## RH / Paie

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Gestion employés | [sfd-rh-service](../sfd-rh-service/CLAUDE.md) | [rh-module.instructions](../analyse/.github/instructions/rh-module.instructions.md) | — |
| Bulletins de paie | [sfd-paie-service](../sfd-paie-service/CLAUDE.md) | [paie-module.instructions](../analyse/.github/instructions/paie-module.instructions.md) | — |
| Congés / absences | sfd-rh-service | rh-module.instructions | — |

## Budget / Stock / Immobilisations

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Budget prévisionnel / suivi | [sfd-budget-service](../sfd-budget-service/CLAUDE.md) | [budget-module.instructions](../analyse/.github/instructions/budget-module.instructions.md) | — |
| Gestion stock / inventaire | [sfd-stock-service](../sfd-stock-service/CLAUDE.md) | [stock-module.instructions](../analyse/.github/instructions/stock-module.instructions.md) | — |
| Immobilisations / amortissements | [sfd-immobilisation-service](../sfd-immobilisation-service/CLAUDE.md) | [immobilisation-module.instructions](../analyse/.github/instructions/immobilisation-module.instructions.md) | — |

## Transferts / Commercial

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Transferts d'argent | [sfd-transfert-service](../sfd-transfert-service/CLAUDE.md) | [transfert-module.instructions](../analyse/.github/instructions/transfert-module.instructions.md) | — |
| Commercial / prospects | [sfd-commercial-service](../sfd-commercial-service/CLAUDE.md) | [commercial-module.instructions](../analyse/.github/instructions/commercial-module.instructions.md) | — |
| Reporting réglementaire BCEAO | [sfd-reporting-service](../sfd-reporting-service/CLAUDE.md) | [reporting-module.instructions](../analyse/.github/instructions/reporting-module.instructions.md) | — |
| Suivi & évaluation | [sfd-suivi-evaluation-service](../sfd-suivi-evaluation-service/CLAUDE.md) | [suivi-evaluation-module.instructions](../analyse/.github/instructions/suivi-evaluation-module.instructions.md) | — |

## Paramétrage / Référentiel

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Agences, devises, pays, paramètres | [sfd-commun-service](../sfd-commun-service/CLAUDE.md) | [preference-module.instructions](../analyse/.github/instructions/preference-module.instructions.md) | [analyse/backend/preference/](../analyse/backend/preference/) |
| Rôles / droits utilisateurs | sfd-commun-service | preference-module.instructions | — |
| Jours fériés | sfd-commun-service | preference-module.instructions | — |

## Rapports PDF/Excel/CSV

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Générer rapport PDF | [sfd-report-api](../sfd-report-api/CLAUDE.md) | [rapport-module.instructions](../analyse/.github/instructions/rapport-module.instructions.md) | — |
| Générer rapport Excel | sfd-report-api | rapport-module.instructions | — |
| Templates JasperReports | sfd-report-api | rapport-module.instructions | — |

## Portail client / Mobile

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| API portail client | [sfd-portail-client-service](../sfd-portail-client-service/CLAUDE.md) | [portail-client-module.instructions](../analyse/.github/instructions/portail-client-module.instructions.md) | — |
| App mobile agent | [sfd-agent-mobile-service](../sfd-agent-mobile-service/CLAUDE.md) | [agent-mobile-module.instructions](../analyse/.github/instructions/agent-mobile-module.instructions.md) | — |
| Flutter mobile | [sfd-agent-mobile-flutter](../sfd-agent-mobile-flutter/CLAUDE.md) | — | — |

## Frontend Angular

| Cas d'usage | Service | Instructions | Specs |
|-------------|---------|-------------|-------|
| Écran / composant Angular NgRx | [sfd-angular](../sfd-angular/CLAUDE.md) | [angular-frontend.instructions](../analyse/.github/instructions/angular-frontend.instructions.md) | — |
| State management NgRx (store/effects) | sfd-angular | angular-frontend.instructions | — |
| E2E Playwright | sfd-angular | angular-frontend.instructions | [analyse/ANALYSE_E2E_*.md](../analyse/) |
| i18n (fr/en) | sfd-angular | angular-frontend.instructions | — |

## Données démo

| Cas d'usage | Service | Instructions |
|-------------|---------|-------------|
| Setup données initiales UEMOA | [sfd-demo-data](../sfd-demo-data/CLAUDE.md) | [demo-data-library.instructions](../analyse/.github/instructions/demo-data-library.instructions.md) |
| Pays/devises/agences demo | sfd-demo-data | demo-data-library.instructions |

## Inter-services (libs partagées)

| Besoin | Fichier |
|--------|---------|
| Clients REST inter-services | [sfd-integration-api/CLAUDE.md](../sfd-integration-api/CLAUDE.md) |
| JWT, rôles, `@PreAuthorize` | [docs/EXTERNAL_LIBS.md](EXTERNAL_LIBS.md) → security-oauth2 |
| Numérotation séquentielle | docs/EXTERNAL_LIBS.md → number-generator-api |
| Upload fichiers | docs/EXTERNAL_LIBS.md → fileupload-api |
| Notifications (email/SMS) | docs/EXTERNAL_LIBS.md → notification-api |
| Audit trail | docs/EXTERNAL_LIBS.md → activity-tracking-starter |

---

## Création nouveau module

[analyse/backend/nouveau_module/GUIDE_CREATION_MODULE_SFD.md](../analyse/backend/nouveau_module/GUIDE_CREATION_MODULE_SFD.md)

---

*Maintenu avec [INDEX.md](../INDEX.md)*
