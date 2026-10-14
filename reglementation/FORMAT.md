# Format des fichiers de réglementation (à respecter par tous les rédacteurs)

Chaque fichier thème (`comptabilite.md`, `epargne.md`, `credit.md`, `parts-sociales.md`, `clotures.md`, `prudentiel.md`, `lbc-ft.md`, `taux-usure.md`, `dormants-conservation.md`) d'une zone contient :

1. En-tête : zone, thème, date de rédaction, rédacteur.
2. Une table de règles, une ligne par règle :

| id | règle (résumé fidèle, ≤ 3 phrases) | source (titre, n°, date, article) | URL | confiance | vérification |
|----|----|----|----|----|----|

- `id` : `<ZONE>-<THEME>-NNN` (ex. `UEMOA-CPT-003`). ZONE ∈ UEMOA, CEMAC, RDC, OHADA.
- `confiance` : HAUTE (texte primaire lu par le rédacteur) / MOYENNE (source secondaire reconnue, ou texte primaire non relu en entier) / BASSE (rapporté, à confirmer).
- `vérification` : toujours `?` à la rédaction (rempli par les agents de vérification).
- Règle sans source = INTERDIT. Si rien trouvé : ligne `NON TROUVÉ` dans la section « Lacunes ».
- Citations : ≤ 15 mots, entre guillemets, avec lien. Pas de longs extraits.
3. Section « Choix de produit (hors réglementation) » : ce qui n'est PAS imposé par un texte.
4. Section « Lacunes / à confirmer ».

Aucun compte déduit par analogie : si un compte est cité, il vient d'un plan comptable précis (nom du plan, numéro de compte, libellé).
