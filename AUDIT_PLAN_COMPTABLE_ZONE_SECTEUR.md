# Audit — Plan comptable zone × secteur

> Date : 2026-07-30  
> Scope : UEMOA + CEMAC · SFD vs entreprise · hors assurances/asso

## Verdict

Nexora ne chargeait **pas** le référentiel BCEAO SFD (RCSFD). Le YAML `uemoa/sycebnl/` était un échantillon hybride (libellé microfinance) incompatible avec :

1. le **RCSFD** (Instruction BCEAO 025/026-02-2009) — classe 25 = comptes membres  
2. le vrai **SYCEBNL OHADA** (associations) — hors scope  
3. le **SYSCOHADA** (entreprise / stock / commercial)

## Trois normes distinctes

| Code | Usage | Zone |
|------|-------|------|
| `SYSCOHADA` | Compta / stock / commercial | UEMOA + CEMAC |
| `RCS_SFD` | SFD / microfinance | **UEMOA** (BCEAO) |
| `COBAC` | SFD CEMAC (seed provisoire) | **CEMAC** |
| `SYCEBNL` | Associations (stub, hors scope) | — |

## Matrice cible

| Zone | Secteur | Norme |
|------|---------|-------|
| UEMOA | `SFD` | `RCS_SFD` |
| UEMOA | `ENTREPRISE` | `SYSCOHADA` |
| CEMAC | `SFD` | `COBAC` (provisoire) |
| CEMAC | `ENTREPRISE` | `SYSCOHADA` |
| * | Assurance / Association | Hors scope (désactivé wizard) |

## Écarts classe 25 (échantillon)

| Source | Compte | Contenu |
|--------|--------|---------|
| RCSFD officiel | **25** | COMPTES DES MEMBRES, BENEFICIAIRES OU CLIENTS |
| RCSFD | **254 / 2545** | Dépôts de garantie reçus |
| Ancien YAML `sycebnl` | **250** | Dépréciations immobilisations (**faux**) |
| SYSCOHADA | Classe 2 / 28-29 | Immob. / amort. / dépréciations |

## Inventaire extraction PDF

- PDF : `~/Downloads/Référentiel comptable spécifique des SFD_1.pdf`
- Inventaire : [refs/RCSFD_PLAN_COMPTES_INVENTAIRE.md](refs/RCSFD_PLAN_COMPTES_INVENTAIRE.md)
- Seed YAML : `sfd-comptabilite-service/.../accounting-norms/uemoa/rcs_sfd/` (~363 comptes)

## Wizard

Champ explicite **`secteurActivite`** (`SFD` | `ENTREPRISE`) + `zoneCode` → dérive `organisation` + `normeComptable`.  
Pas de migration BD (base vidée / re-seed).

## CEMAC note

Seed `cemac/cobac/` = provisoire (base SYSCOHADA CEMAC + metadata COBAC). Remplacer dès référentiel officiel COBAC SFD disponible — **ne pas** réutiliser le PDF BCEAO.

Wizard `CEMAC-BEAC` × `SFD` → `organisation=CEMAC` + `normeComptable=COBAC` ; × `ENTREPRISE` → `SYSCOHADA` (XAF).
