# S2b : complétion des paquets de localisation (données réglementaires). Modèle sonnet, avec revue opus du diff

Commence par lire `COMMUN.md` (même dossier), puis la section « Lacunes des paquets et des modules » de `<WT>/sfd-docs/reglementation/REPORTING_POINTS_A_VALIDER.md`, puis le handoff de S4 `<WT>/.claude/handoff/reporting-refonte-moteur.md`, section « Lacunes de paquet constatées ».

## But
Rendre calculables les lignes des paquets qui sont aujourd'hui en ERREUR « formule non définie », **sans rien inventer**. Chaque formule ajoutée doit citer sa source. La priorité absolue est de rendre calculables les ratios prudentiels UEMOA.

## Branche
`sfd-reporting-service` : `feature/reporting-refonte-paquets`, créée depuis `feature/reporting-refonte` (84ca433, S4 fusionnée). Tu ne modifies que `src/main/resources/localisation/**` et `sfd-docs/reglementation/outils/convert_paquets.py` (si tu fais évoluer le format, ajoute le champ `parent`).

## Sources disponibles
- RCSFD **allégé** (PDF officiel cb-umoa, extrait en texte) : `/private/tmp/claude-501/-Users-pierreadopre-Projects-erp-sfd--claude-worktrees-reporting-reglementaire-refonte-7f5c77/23b2e092-2639-43ce-b369-d6ec1b43ed80/scratchpad/rcsfd-dl/rcsfd.txt` (PDF dans le même dossier). Si le dossier a disparu, télécharge-le de nouveau, dans un dossier vide de ton scratchpad, depuis https://cb-umoa.org/sites/default/files/2022-05/R%C3%A9f%C3%A9rentiel%20comptable%20sp%C3%A9cifique%20des%20SFD_1.pdf
- Recherche du Lot 0 : `<WT>/sfd-docs/reglementation/<zone>/reporting.md` (sources et URL des instructions 010-08-2010, 016-12-2010, 020-12-2010, PCEMF, Instr. BCC).
- Tu peux faire des recherches web pour lire les textes primaires (pas de seconde main).

## Travail, par priorité
1. **UEMOA, ratios prudentiels** :
   - DIMF-2000-BIL B2N, F1A et G10 : formule ou comptes, d'après le modèle de bilan du RCSFD.
   - I11_AUTRES_OPS, I12_MAX et I13_TOTAL (états DIMF-2011, 2012 et 2013) : ce sont des données de sous-journal crédit, à passer en `sourceDonnees: CROSS_SERVICE` avec une clé explicite.
   - Résultat attendu : R1, R3 à R6 et R8 à R10 calculables, ou en ERREUR seulement à cause d'une donnée CROSS_SERVICE non branchée.
2. **Hiérarchie** : ajoute le champ `parent` aux lignes, à partir des modèles officiels. Les totaux sans formule, pour lesquels la règle « parent = somme des filles » s'applique, deviennent `expression: somme des filles` écrite explicitement. On n'utilise pas de règle implicite dans le moteur : la formule est générée dans le paquet. Cela vaut pour UEMOA DIMF-2006 à 2018, 2011-1, IND-FIN et IND-NF.
3. **UEMOA allégée** : D1E, D1L et D32 à D35 portent `comptesAllegee: NON_TROUVE`. Cherche-les dans le RCSFD allégé (concordance des postes).
4. **Classe 9 hors-bilan UEMOA** : les 40 lignes `planEdipIncomplet` sont concernées. Prépare la liste des comptes de classe 9 du RCSFD allégé (numéro et libellé) dans un fichier `sfd-docs/reglementation/uemoa-bceao/plan-classe9-allege.yml` : l'orchestrateur l'ajoutera au plan compta. Ne touche pas au service compta.
5. **RDC** : dans RDC-REP-001, les comptes 46 et 47 sont mal signés entre actif et passif. Utilise les suffixes `dr` à l'actif et `cr` au passif. Complète P_EMPRUNTS_TRESO et les autres lignes sans formule si la source le permet.
6. **CEMAC** : dans XG07 (62), qui recouvre XG06 (624), il y a un double comptage dans XG01. Corrige-le, par exemple avec 62 − 624 si la source le confirme.
7. **OHADA** : les lignes N34-* ont des comptes sans `sens`. Ajoute le sens selon le Guide SYSCOHADA (voir etats-financiers.md). Traite aussi les 133 lignes sans formule, en commençant par EBNL-SMT.

## Règles
- Aucun compte ni formule sans source. Si tu ne trouves rien, la ligne reste en ERREUR et va dans le handoff avec la mention « non trouvé ».
- Chaque ligne modifiée reçoit `source:` et `confiance:` (HAUTE uniquement si le texte primaire a été lu).
- Après chaque zone, relance le moteur sur les paquets : le script d'exploration de S4 (voir son handoff) ou un test qui charge `LocalisationRegistry` et compte les lignes calculables. Donne les chiffres avant et après dans le rapport (UEMOA 429/602, CEMAC 397/467, RDC 70/98, OHADA 290/452 au départ).

## Fini quand
- `scripts/claude/regress.sh sfd-reporting-service` : 0 échec.
- Chiffres de lignes calculables avant et après, par zone.
- Handoff `reporting-refonte-paquets.md` à jour : lignes complétées avec leur source, lignes encore en erreur et pourquoi, points à valider par un comptable.
