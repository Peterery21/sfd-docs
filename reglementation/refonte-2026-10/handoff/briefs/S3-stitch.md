# S3 : design Stitch des écrans du reporting réglementaire (lot 4), modèle sonnet

Lire d'abord `COMMUN.md` (même dossier). Utiliser le skill `stitch-kit:stitch-orchestrator`. Aucun build ni service n'est nécessaire.

## But
Produire les maquettes des nouveaux écrans du module Reporting réglementaire, cohérentes avec le thème EDIP existant.

## Entrées
- Thème : `/Users/pierreadopre/Projects/erp-sfd/.stitch/DESIGN.md` (Velzon « institutional banking », slate #475569, Open Sans, rayon 6 px, lignes de tableau de 44 px, badges doux). Le lire, ne pas le régénérer. Maquettes existantes pour le style : `/Users/pierreadopre/Projects/erp-sfd/.stitch/designs/`.
- Contenu fonctionnel : le contrat (DTO), le menu et les écrans décrits dans le plan, section « Lot 5 », de `/Users/pierreadopre/.claude/plans/pasted-content-id-c093-j-aimerais-faire-mossy-zephyr.md`.

## Écrans (desktop 1440 px, en français, données réalistes UEMOA / Togo, montants en FCFA)
1. **Éditer les rapports** :
   - à gauche, la liste des rapports de la zone, groupés par périodicité, avec statut et échéance (en retard en rouge doux) ;
   - à droite, l'en-tête du rapport (source réglementaire, badge de confiance), le sélecteur de période, Générer, le tableau de résultat (code, libellé, N, N-1, variation, norme, conformité), le panneau des contrôles de cohérence, puis Valider / Clôturer / Soumettre / Exporter.
2. **Formules de calcul**, pour un utilisateur non technique :
   - à gauche, la liste des rapports avec recherche ; à droite, le tableau lisible, libellé métier en premier et code en second, avec les badges d'origine paquet / personnalisée / ajoutée ;
   - panneau latéral d'édition avec constructeur visuel : bloc « Solde des comptes » (sélecteur multiple de comptes, sens débit/crédit), bloc « Indicateur » (lignes par libellé), opérateurs en boutons ;
   - expression en langage clair, aperçu de la valeur en direct avec les comptes contributeurs, erreurs claires, norme « doit être ≥ / ≤ / = » ;
   - « valeur d'origine contre la vôtre », Réinitialiser, historique.
3. **États financiers** : onglets Bilan / Compte de résultat / TFT / Notes ; colonnes Brut / Amort.-Prov. / Net N / Net N-1 ; indicateur « équilibré ».
4. **Export groupé (ZIP)** : choix de la période, cases à cocher des rapports avec leur statut, formats PDF/XLSX, « générer les manquants », bouton Télécharger.
5. **Données importées** (mode standalone) : assistant en 4 étapes (télécharger le modèle, déposer le fichier, contrôler l'équilibre, les comptes inconnus et les annexes manquantes, confirmer), puis la liste des imports.
6. **Paramètres** : zone et pays en lecture seule (« UEMOA · BCEAO — Togo »), version du paquet, mode source (Intégré / Standalone, avec une explication), en-tête, signataires.
7. **Tableau de bord** : indicateurs clés (rapports à faire ou en retard, conformité des ratios), échéances à venir, dernières éditions.
8. **Historique des éditions** : liste filtrable, avec statut et score de qualité.

## Sortie
- `sfd-docs` sur la branche `feature/reporting-refonte-stitch` (worktree du sous-dépôt sfd-docs, créé depuis `feature/reporting-refonte`).
- Dossier `design/reporting/` : un fichier `<ecran>.html` et un `<ecran>.png` par écran, plus un `README.md` qui liste les écrans, les composants partagés EDIP à utiliser pour chaque bloc (`app-modal-shell`, `app-confirm-modal`, `app-compte-selector`, `app-exercice-selector`, `app-busy-area`, `nav-tabs-custom`) et les tokens CSS.
- Si le MCP Stitch expire (cas déjà rencontré) : maquettes en HTML et Tailwind selon DESIGN.md, captures avec Playwright.

## Périmètre
- Modifiable : `sfd-docs/design/reporting/**`.
- Exclus : `.stitch/` du checkout principal (lecture seule) et tout code applicatif.

## Terminé quand
- Les 8 écrans sont produits (html et png), le README est écrit, et le tout est commité sur `feature/reporting-refonte-stitch`.
