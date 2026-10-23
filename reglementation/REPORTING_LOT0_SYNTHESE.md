# Refonte reporting réglementaire — Lot 0 : synthèse de la recherche (2026-10-19)

Recherche web sur sources primaires, 4 zones en parallèle, format `FORMAT.md`. Rien n'est commité (branche sfd-docs `feature/reporting-refonte`).

## Livrables

| Zone | Inventaire | Paquet brouillon | États | Confiance HAUTE | Rapports / lignes YAML |
|---|---|---|---|---|---|
| UEMOA · BCEAO (RCSFD) | `uemoa-bceao/reporting.md` | `uemoa-bceao/paquet-draft.yml` | 54 | 87 % | 53 / 602 |
| CEMAC · COBAC (PCEMF) | `cemac-beac/reporting.md` | `cemac-beac/paquet-draft.yml` | 36 | 83 % (existence, périodicité) ; comptes MOYENNE | 25 / 467 |
| RDC · BCC (PCCI) | `rdc-bcc/reporting.md` | `rdc-bcc/paquet-draft.yml` | 33 | 91 % | 32 / 95 |
| OHADA (SYSCOHADA, SYCEBNL) | `syscohada-sycebnl/etats-financiers.md` | `syscohada-sycebnl/paquet-draft.yml` | 22 | 35 % des postes (SYCEBNL 50 %) | 22 / 455 |

Sources principales :
- UEMOA : RCSFD version développée (copie du Trésor CI, 2009), Instr. 020-12-2010 (indicateurs), 010-08-2010 (prudentiel), 005-05-2015 (BIC, J+10), Décision 021/2023 (CENTIF, 15 M FCFA).
- CEMAC : Instr. COBAC I-EMF-2010/03 (états semestriels 30/06 et 31/12 sous 45 j, annuels au 31 mai, astreinte 10 000 à 30 000 FCFA/j), Règl. 01/17, annexe PCEMF « PROJET » de la BEAC.
- RDC : Instr. BCC 009 (2012, états mensuels J+15), 002 (prudentiel), 003 (provisions), 004 (indicateurs).
- OHADA : JO OHADA du 22/02/2023 (SYCEBNL), AUDCIF 2017 (art. 23 : 4 mois ; seuils SMT).

## Approfondissement Tavily (2026-10-19, 2e passe)

Chaque `reporting.md` / `etats-financiers.md` a une nouvelle section « Complément Tavily » ; les patches sont appliqués aux `paquet-draft.yml`.

| Zone | Règles ajoutées | Avancées clés | Brouillon après patch |
|---|---|---|---|
| UEMOA | 33 (T01-T33) | **Texte officiel de la loi uniforme microfinance lu** (art. 171 : RCSFD, Instr. 010 et 020 restent applicables) ; FGDR 0,29 %, plafond 300 000 FCFA, déclaration au 15 juillet ; périodicités des ratios corrigées (`prudentiel.md`) ; 6 incohérences RCSFD tranchées (A70, D70, L01+503, S2A-C, V3G, D1E) ; autorités et lois des pays | 54 rapports |
| CEMAC | 19 (RPT-101-119) | Classes PCEMF confirmées (30-33 = crédits) ; norme 70/65 % = **plafond** (opérateur corrigé) ; SPECTRA/SESAME 4.0 obligatoire depuis fin 2025 ; bureau d'information sur le crédit mensuel ; FOGADAC non applicable aux EMF ; astreintes R-2024/01 ; comptes inactifs 2025 | 25 rapports + 13 non modélisés |
| RDC | 14 (RPT-101-114) | Risque par membre COOPEC = 10 % des FPP (ambiguïté tranchée) ; barème d'astreintes ; rapport trimestriel des plaintes ; états consolidés des faîtières ; centrale des risques non applicable aux IMF ; aucune plateforme de dépôt | 35 rapports |
| OHADA | 24 (ETF-101-124) | TFT, CAFG et compte de résultat SYSCOHADA en HAUTE (Guide officiel) ; TER SYCEBNL en HAUTE ; 6 erreurs du module compta tranchées (848 en double, 409/419, FI/FJ, 89 net…) ; 36 notes ; calendrier DSF par pays ; SFD hors SYSCOHADA/SYCEBNL | 22 rapports |

Restent introuvables en ligne (à demander aux régulateurs ou à un praticien) :
- les instructions d'application 2024-2026 de la loi UEMOA ;
- le recueil définitif des modèles PCEMF et le schéma SESAME 4.0 ;
- R-2017/07 (seuils de provisionnement CEMAC) ;
- le gabarit FinA et l'annexe PCCI ;
- la table poste → comptes du SYSCOHADA (PCGO Titre IX ch. 7) ;
- les canevas des déclarations (BIC, dormants, CENTIF, réclamations).

## Constat critique : les paquets actuels produisent des chiffres faux

Vérifié contre le plan RCSFD d'EDIP (`sfd-comptabilite-service/.../uemoa/rcs_sfd/plan-comptable.yml`) :
- `uemoa-bceao.yml` : la ligne « Caisse et avoirs en banques » utilise les comptes `52, 57`. Dans le RCSFD, 52 = provisions réglementées et 57 = capital social ; la caisse est en 10. Les crédits sont mappés sur 25 (comptes des membres = dépôts), les dépôts sur 37, les capitaux propres sur les classes 10 à 13 (classe 1 = trésorerie) et le compte de résultat sur 64/66/69 (numérotation SYSCOHADA). → **Tous les états UEMOA générés aujourd'hui sont faux.**
- `cemac-beac.yml` est une copie de la structure UEMOA : les comptes ne sont pas ceux du PCEMF, il n'y a qu'un modèle de bilan (la COBAC en a 3), les 9 normes prudentielles COBAC ne sont pas calculées, et les fonds propres nets sont absents.
- « 23 indicateurs » (Instr. 020) : l'annexe officielle a 19 ratios et 7 tableaux non financiers. Le PAR actuel est inventé (le PAR officiel compte les jours d'impayé, normes 5/3/2 %).
- États sans base réglementaire : `CI`, `FS` (UEMOA et CEMAC), « Instruction BCEAO SYCEBNL » (introuvable ; le SYCEBNL et l'AUDCIF excluent les SFD).
- Le TER SYCEBNL ne concerne que les projets de développement ; les associations produisent un TFT méthode directe.
- RDC : aucun paquet aujourd'hui.

Contrôle croisé des nouveaux brouillons (comptes cités comparés aux plans EDIP) :
- RDC : 2 comptes absents du plan EDIP (2510, 255).
- UEMOA : environ 230 sous-comptes du RCSFD développé sont absents du plan EDIP, qui compte 392 codes, plus proche de la version allégée.
- CEMAC : environ 150 comptes PCEMF sont absents du plan EDIP (ex. 30 et 31, les crédits), à arbitrer entre le plan EDIP et l'annexe PROJET.
- → **Le plan comptable EDIP doit être complété ou rapproché avant les formules, sinon les états seront faux.**

## Ce que le moteur (lot 2) doit gérer en plus du format prévu
- Références entre rapports (ex. ratios RDC qui utilisent les postes du bilan) et ordre topologique.
- Variantes de comptes allégée/développée (UEMOA art. 44), normes par catégorie (COBAC 1/2/3, COOPEC/IMF), suffixes `dr`/`cr` (solde débiteur ou créditeur seulement), fonction `MIN()` (plafonds de fonds propres), base « moyenne de période ».
- Colonnes Brut / Amort.-Prov. / Net N / Net N-1 ; plusieurs modèles par catégorie d'assujetti.
- Délai par type d'assujetti (RDC : COOPEC 6 mois, IMF 4 mois) ; périodicités décadaire à annuelle et événementielle.
- États « DOCUMENT » (rapport de contrôle interne, PV d'AG, rapport annuel) : modèle à remplir et pièce jointe, sans calcul.

## Lacunes à arbitrer (bloquantes pour la fiabilité)
1. **Plan comptable EDIP incomplet** par rapport aux paquets (UEMOA développé, CEMAC PCEMF).
2. CEMAC : recueil officiel des modèles COBAC introuvable (seulement l'annexe PROJET) ; format SPECTRA / SESAME 4.0 (obligatoire depuis fin 2025) inconnu.
3. UEMOA : texte de la nouvelle loi uniforme microfinance (21/12/2023) et instructions d'application introuvables. Surcharges pays documentées seulement pour la CI et le SN.
4. RDC : gabarit FinA non publié, structures des annexes 003 à 016 proposées à partir du PCCI.
5. OHADA : PCG officiel et modèle SMT non lus ; liasses DSF par pays non couvertes.
6. Partout : formats de déclaration CENTIF/ANIF/CENAREF, centrales des risques et canevas des comptes dormants non trouvés.

## Recommandation pour la suite
- Lots 1 et 2 sur la base de ces brouillons. Chaque ligne garde `confiance` et `source` ; l'UI affiche « à valider » pour MOYENNE/BASSE.
- Ajouter un lot 1bis : rapprocher les plans comptables EDIP (RCSFD développé, PCEMF) des paquets.
- Faire valider par un praticien de chaque zone (expert-comptable SFD) les lignes MOYENNE/BASSE avant mise en production.
