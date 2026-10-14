# Réponses aux 6 questions ouvertes du référentiel interne (§6)

Rédigé le 2026-10-13. Chaque réponse renvoie aux règles sourcées (ids) de chaque zone ; le détail et les pages/articles sont dans `<zone>/questions-ouvertes.md`. Légende : **TEXTE** = imposé par un texte lu ; **SILENCE** = aucun texte lu ne tranche ; **CHOIX** = décision de produit. Les statuts de vérification sont dans `index.json` / `INDEX.md`.

## Q1 — Comptes des membres : classe 25 (RCSFD) au lieu de 165100 / 161100 ?

**Oui pour l'UEMOA (TEXTE).** RCSFD classe 2, rubrique 25 « Comptes des membres, bénéficiaires ou clients » : à vue **2511** « Comptes ordinaires » ; livret **2512** « Comptes ordinaires sur livret » *ou* **2531** « Compte d'épargne sur livret » (253 « Comptes d'épargne à régime spécial ») ; DAT **2521** ; dépôt de garantie **2545** ; autres dépôts **2551**. Les 16x/165100/161100 sont des dépôts d'**institutions financières** (classe 1), pas des membres (`UEMOA-EPA-004/005/006/007/008/009/010`).
- Les numéros à 6 chiffres du référentiel interne (`251100`, `252100`, `253100`, `254500`, `255100`) sont des codifications **internes** : le texte ne donne que le compte général ; le SFD peut subdiviser librement (Instr. 026-02-2009 art. 3 et 6) (`UEMOA-CPT-002/004`).
- **CHOIX** : lequel de 2512 ou 2531 pour un « livret » ; le texte ne tranche pas.
- **Migration des produits déjà seedés** : décision de produit/exploitation (pas une question de réglementation) — mais tant que les produits portent 165100/161100 la comptabilité est non conforme au RCSFD.
- Autres normes (ne jamais transposer 25) : **CEMAC/PCEMF** classe 3 : à vue 3711/3712 (ou 372), livret 373, DAT 361, garantie 3741/3742, régime spécial 351-355 (`CEMAC-EPA-004…`, `CEMAC-CPT-007`). **RDC/PCCI** : 331 (ordinaires), 332 (livrets), 340 (DAT), 334 (épargnes obligatoires ~ garantie, rapprochement de libellé), 352-356 ; comptes **MOYENNE** (source secondaire, annexe officielle de l'Instr. 006 non obtenue) (`RDC-EPA-001…004`). **OHADA** : n/a (SFD exclus du SYSCOHADA, AUDCIF art. 5, `OHADA-GEN-*`).

## Q2 — Compte de la caisse de la session

**TEXTE** : le RCSFD n'a qu'un compte **101/1011** « Billets et monnaies » ; la subdivision en sous-comptes/auxiliaires est libre à condition que le solde corresponde au compte du plan (Instr. 026-02-2009 art. 3 et 6). Une caisse de session = sous-compte/auxiliaire de 101 : cohérent avec la proposition interne ; 101 ne doit pas être en dur dans les schémas (`UEMOA-CPT-002/004/011`). CEMAC : 571 (5710 caisse FCFA, 5711 devises) ; la notion de caisse de session n'existe pas dans le PCEMF (**SILENCE/CHOIX**) (`CEMAC-CPT-008`). RDC : 570 (`RDC` regles-vers-produit).

## Q3 — Comptes pour pénalités, retrait anticipé de DAT, intérêts de crédit, change, dotations

| Sujet | UEMOA / RCSFD | CEMAC / PCEMF | RDC / PCCI | OHADA (non-SFD) |
|---|---|---|---|---|
| Intérêts de crédit | **7021** (TEXTE) | **711/712/713** (TEXTE, plan) | 710/711/712 (plan, MOYENNE) | n/a |
| Pénalité de retard (prorata temporis) | **7028** « Autres intérêts » : cite les intérêts de retard/moratoires (TEXTE) | NON TROUVÉ (SILENCE ; CHOIX) | 717 « Intérêts et commission sur crédits en retard » (rapprochement de libellé, SILENCE) ; à ne constater en produit qu'à l'encaissement (Instr. 003 art. 11) | n/a |
| Pénalité forfaitaire (montant fixe) | NON TROUVÉ (SILENCE ; 7029 ou 7028 = CHOIX à valider ; compte hors plan = autorisation BCEAO, Instr. 026 art. 4) | NON TROUVÉ | NON TROUVÉ | n/a |
| Frais de dossier | **7029** « Commissions » (cite expressément les frais de gestion des dossiers de crédit) (TEXTE) | NON TROUVÉ (candidat 715, CHOIX) | 715/720/727 (rapprochement) | n/a |
| Retrait anticipé de DAT (pénalité) | **NON TROUVÉ** (le RCSFD ne traite que du DAT non renouvelé) | Autorisé « dans les conditions » du contrat ; aucun compte (SILENCE) | NON TROUVÉ | n/a |
| Gain / perte de change | **NON TROUVÉ** : la version allégée du RCSFD lue n'a aucun compte de change et dit les opérations en devises non autorisées (état 2009). **776000/676000 (OHADA) ne sont pas des comptes RCSFD** | **723 / 623** (change à titre principal) ; **7411 / 6411** (accessoire) ; positions 475-477 (TEXTE, plan) | **723 / 621** ; position 472/473 ; provision 1822 (plan) ; cours de réévaluation NON TROUVÉ | 776 / 676 ; écarts de conversion 478/479 ; traitement imposé par AUDCIF art. 53-58, numéros non cités par l'Acte |
| Dotation aux provisions sur créances | **664** (6641/66411/66412, 6642, 6643) ; contrepartie 2991-2993 ; reprise 764 ; perte 669 (TEXTE). 6871/4912 du code sont OHADA : inexistants au RCSFD | **6913** (contrepartie 39x) ; reprise 7913 ; pertes 6921/6922 (plan). Taux 15/45/75/100 % = ancien Règl. 2002/18, remplacé par R-2017/07 non lu | Taux 5/25/50/75/100 % TEXTE ; compte de charge **AMBIGU** (6900-6904) | 691 / 697 / 659 selon nature ; 681 amortissements |
| Résultat de l'exercice | **592** (« Excédent ou déficit de l'exercice ») | 131/132 (compte 13) | 87 / 130-131 | 131 / 139 |

Sources : `UEMOA-CRE-005/006/007/014/015`, `UEMOA-CPT-010/020-027`, `CEMAC-CPT-012/013/017`, `CEMAC-CRD-006/012/013`, `RDC-CRE-008/010/013/019`, `OHADA-QO-001…011`. **Où paramétrer** (réponse produit, pas réglementaire) : les textes ne parlent que de comptes du plan ; schéma par type d'opération + paramètres de clôture/change, par norme (cf. `regles-vers-produit/`).

## Q4 — Supprimer la complétion par zéros ?

**TEXTE/cohérent** : aucun texte (RCSFD, Instr. 025/026-2009) ne prévoit de complétion ; le plan interne ne contient que les comptes généraux du RCSFD (art. 2) ; une opération sans compte approprié exige l'**autorisation préalable de la BCEAO** (art. 4) → rejet explicite d'un compte absent = conforme (`UEMOA-CPT-002/003`). CEMAC : plan à 2-5 chiffres, « indicatif », texte muet sur la complétion (`CEMAC-CPT-002/006`, **SILENCE/CHOIX**). La suppression est un **CHOIX de produit** conforme à l'esprit des textes.

## Q5 — Tontine et épargne planifiée

**Aucune zone n'impose de compte (SILENCE) :** les mots « tontine » et « épargne planifiée » n'apparaissent ni dans le RCSFD allégé, ni dans le PCEMF, ni dans le PCCI, ni dans les instructions lues. UEMOA : la loi exclut des « dépôts » les cotisations et contributions obligatoires (art. 4, sans définir la tontine). Candidats **non prescrits** : UEMOA 2531 / 2512 / 2551 (réservé aux institutions non autorisées à recevoir des dépôts à vue) / 2721 ; CEMAC 355 ou 373 ; RDC 356, 362 ou 334. **Décision utilisateur requise** (et, pour l'UEMOA, un compte hors définition peut exiger l'autorisation BCEAO — Instr. 026 art. 4) (`UEMOA` Q5, `CEMAC-EPA-001/010`, `RDC` Q1/Q7).

## Q6 — Document fonctionnel de référence prioritaire

Réglementairement : **UEMOA** RCSFD (Instr. BCEAO 025-02-2009, obligatoire pour tous les SFD) + Instr. 026-02-2009 + loi uniforme SFD (2007) ; **CEMAC** PCEMF (BEAC, janv. 2010 — la page de titre porte « PROJET ») + Règl. COBAC EMF ; **RDC** Instr. BCC 006 (institue le PCCI) + loi 002/2002 + loi 11/020. Document **interne** (cahier des charges comptable de l'éditeur, ex. `Coneption de Logiciel SFD _ Module Epargne Tontine v2` dans ~/Downloads) : hors périmètre réglementaire, c'est à l'utilisateur de dire s'il prime.
