# Audit — Plan comptable zone × secteur

> Date : 2026-07-30 (MAJ RDC / BCC)  
> Scope : UEMOA + CEMAC + **RDC** · SFD vs entreprise · hors assurances/asso

## Verdict

Nexora charge :

| Zone | SFD | Entreprise |
|------|-----|------------|
| **UEMOA** | `RCS_SFD` (RCSFD BCEAO) | `SYSCOHADA` |
| **CEMAC** | `COBAC` (PCEMF COBAC/BEAC) | `SYSCOHADA` |
| **RDC** | `PCCI` (COOPEC/IMF — BCC) | `SYSCOHADA` (OHADA, CDF) |

Banques RDC : plan **GCEC** seedé (`rdc/gcec/`) — non sélectionné au wizard v1 (pas de secteur banque).

## Normes

| Code | Libellé | Zone |
|------|---------|------|
| `SYSCOHADA` | OHADA général | UEMOA / CEMAC / RDC entreprise |
| `RCS_SFD` | RCSFD BCEAO | UEMOA SFD |
| `COBAC` | PCEMF | CEMAC SFD |
| `PCCI` | Plan COOPEC/IMF | **RDC SFD** |
| `GCEC` | Guide établissements de crédit | RDC banques (seed) |
| `SYCEBNL` | Asso OHADA | stub hors scope |

## Écarts structurels (classe 25 / clientèle)

| Référentiel | Clientèle / dépôts | Compte 25 |
|-------------|-------------------|-----------|
| RCSFD BCEAO | Classe **2** (25 = membres) | Membres / bénéficiaires |
| PCEMF COBAC | Classe **3** | Dépôts/cautionnements versés (immo.) |
| PCCI RDC | Classe **3** (crédits 30–32, épargne 33–35) | Titres de participation |

## Inventaires PDF

- RCSFD : [refs/RCSFD_PLAN_COMPTES_INVENTAIRE.md](refs/RCSFD_PLAN_COMPTES_INVENTAIRE.md)  
- PCEMF : [refs/PCEMF_PLAN_COMPTES_INVENTAIRE.md](refs/PCEMF_PLAN_COMPTES_INVENTAIRE.md)  
- PCCI RDC : [refs/PCCI_RDC_PLAN_COMPTES_INVENTAIRE.md](refs/PCCI_RDC_PLAN_COMPTES_INVENTAIRE.md) (~598)  
- GCEC RDC : [refs/GCEC_RDC_PLAN_COMPTES_INVENTAIRE.md](refs/GCEC_RDC_PLAN_COMPTES_INVENTAIRE.md) (~923)  
  - Source : `PLAN-COMPTABLE-BANQUES-ET-IMF.pdf`

## Seeds YAML

- `uemoa/rcs_sfd/` · `cemac/cobac/` · `rdc/pcci/` · `rdc/gcec/` · `rdc/syscohada/`

## Wizard

Zones : `UEMOA-BCEAO` | `CEMAC-BEAC` | **`RDC-BCC`** | CUSTOM  
`secteurActivite` × zone → `organisation` + `normeComptable` + devise (`XOF` / `XAF` / **`CDF`**).
