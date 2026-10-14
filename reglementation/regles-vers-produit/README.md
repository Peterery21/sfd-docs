# Règles → produit : rôle comptable → compte, par norme

Matière première du futur `roles-comptables.yml` de chaque norme (aucun compte en dur dans le code ; voir §7 du référentiel interne `docs/test-utilisateur-2026-10-13/REFERENTIEL-COMPTABLE-RCSFD.md`).

| Norme produit | Fichier | Plan source | Remarque |
|---|---|---|---|
| `RCS_SFD` (UEMOA) | [RCS_SFD.md](RCS_SFD.md) | RCSFD, Instr. BCEAO 025-02-2009 | complet pour la collecte/crédit ; change, tontine, planifiée, mobile money, pénalité forfaitaire, DAT anticipé : NON DÉFINI |
| `COBAC` (CEMAC) | [COBAC_PCEMF.md](COBAC_PCEMF.md) | PCEMF BEAC 2010 | clientèle en classe 3 ; pénalités, tontine, mobile money NON DÉFINI |
| `PCCI` (RDC) | [PCCI.md](PCCI.md) | PCCI (Instr. BCC 006, liste via ouvrage secondaire) | comptes MOYENNE ; dotation crédit AMBIGUË |
| `SYSCOHADA` (non-SFD) | [SYSCOHADA.md](SYSCOHADA.md) | PCG OHADA révisé | numéros issus d'une source secondaire (MOYENNE) |
| `GCEC` (banques RDC) | — | à faire (hors périmètre SFD) | |
| `SYCEBNL` | voir `../syscohada-sycebnl/sycebnl.md` | | plan complet non lu |

Règle d'usage : un rôle « NON DÉFINI PAR LE TEXTE » n'a **pas** de valeur par défaut ; il doit être décidé par l'utilisateur (ou autorisé par l'autorité), et le seed du pays doit être refusé tant qu'il manque. Les originaux par zone restent dans `<zone>/regles-vers-produit-*.md` (copies ici ; en cas d'écart, la copie de zone fait foi).
