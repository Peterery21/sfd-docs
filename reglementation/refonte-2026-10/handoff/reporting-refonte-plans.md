# S1 — plans comptables vs paquets (lot 1bis) — handoff

Branche compta : `feature/reporting-refonte-plans` (sfd-comptabilite-service, depuis `feature/reporting-refonte` 67d4029).
Scripts (repo erp-sfd, branche `claude/cool-wilbur-0ec16a`, dossier `scripts/reporting/`) :
- `diff-plans-paquets.py <localisation> <accounting-norms> [--json]` : comptes cités (`comptes` + `comptesAllegee`, préfixes, `-`, `dr/cr`) absents du plan (préfixe couvert si un compte du plan commence par lui).
- `parse_pcemf.py <pcemf.txt>` : code→libellé de la liste des comptes PCEMF (texte du PDF via PyMuPDF).
- `gen_adds_pcemf.py`, `add_comptes.py` : calcul des ajouts (préfixe + descendants listés + ancêtres manquants) et insertion YAML en position triée, sans toucher l'existant. Attributs (classe, nature, sens, mandataire, analytique) hérités du compte existant le plus proche (plus long préfixe commun, puis proximité numérique).
Commande : `python3 -I scripts/reporting/diff-plans-paquets.py <wt-reporting>/src/main/resources/localisation sfd-comptabilite-service/src/main/resources/config/accounting-norms`

## Résultat par zone
| Zone | Avant | Ajoutés | Restants |
|---|---|---|---|
| CEMAC (PCEMF janv. 2010) | 109 préfixes manquants | 218 comptes (164x, 30*/31* crédits LT/MT, 442-449, 45100-45209, 477, 5xx réseau/hors réseau, 6xx/7xx réseau) | 5 non trouvés : 389, 4651, 5818, 634, 7140 |
| RDC (PCCI) | 3 (2510, 255, 373) | 3 | 0 |
| UEMOA (RCSFD développé) | 333 | **0** | 333 : **BLOQUÉ** |

## UEMOA : bloqué (source inaccessible)
Le RCSSFD (microfinance.tresor.gouv.ci/.../RCSSFD.pdf) refuse la connexion depuis cette machine (curl, WebFetch, navigateur : ECONNREFUSED / 000). Le recueil BCEAO (edenpub.bceao.int) ne contient pas le plan. Aucun doc local de `sfd-docs/reglementation` ne donne les libellés des comptes manquants (seulement des numéros dans les lignes d'états). Règle « rien inventer » : aucun compte UEMOA ajouté.
Pour débloquer : fournir le PDF en local (ou un accès réseau), puis réutiliser `add_comptes.py` avec un parseur du plan p.29-40 (même méthode que PCEMF). Les 333 préfixes manquants sont ceux de `diff-plans-paquets.py` (essentiellement le détail développé : 1101…, 3311x, 4101-4149, 60111…, 7xxxx, 9xxx hors-bilan).

## CEMAC : détails
- Source : PCEMF janv. 2010, `beac.int/.../Plan-comptable-des-établissements-de-microfinance-PCEMF-janvier-2010.pdf` (liste des comptes + fonctionnement). Libellés repris tels que dans le PDF (abréviations « LT/MT », « morat. ou consol. » conservées).
- Le plan EDIP **n'avait aucun compte 30*/31***. Ajoutés : 30 Crédits à long terme, 31 Crédits à moyen terme, avec toute leur arborescence (301-309 / 311-319 + 4e/5e niveaux). Aucune contradiction de classe : 32 CT, 33 souffrance, 37, 39 existaient avec les libellés PCEMF. Les 1028 libellés existants sont tous conformes au PCEMF (comparés), hors 4 coupures corrigées.
- 5 libellés **existants** tronqués complétés (même code) d’après le PCEMF : 460, 6807, 6914, 9907, 9909. Sans cela le test d'intégrité (étendu à cemac/cobac) échoue.
- Non trouvés dans le PCEMF (cités par les paquets) : **389** (dernier compte 38 du PCEMF = 388), **4651**, **5818**, **634**, **7140**. À reporter à l'orchestrateur : probable erreur de transcription dans `paquet-draft` CEMAC ou compte hors PCEMF 2010 ; ne pas les créer.
- Attribut `mandataire`/`sens` hérités par proximité, pas lus dans le PCEMF : à valider pour 30/31 (hérités de 32).

## RDC
- 2510 : « Participations à plus d'un an dans d'autres établissements de crédit ou institutions financières » (Instr. BCC 002 art. 8). Source : instruction (le PCCI de l'ouvrage ne le liste pas).
- 255 : « Créances subordonnées dans d'autres établissements de crédit ou institutions financières » (Instr. 002 art. 9 et 34). Le plan GCEC l'appelle « Prêts subordonnés ».
- 373 : « Autres suspens créditeur non imputés » = libellé de la liste **GCEC** de l'ouvrage ; absent de la liste PCCI (verification/rdc-verification.md RDC-CPT-010) mais cité par Instr. 002 art. 24. Décision métier à confirmer (ajouté car cité par l'instruction).
- Sens : 2510/255 DEBITEUR, 373 CREDITEUR (hérités de 251 / 372).

## Tests / loaders
- Lecteur : `YamlAccountingNormLoader` (+ `SetupComptabiliteLoader`, wizard setup). Tests : `PlanComptableIntegriteTest` (étendu à `cemac/cobac` : doublons, parent existant, libellé complet, sens), `YamlAccountingNormLoaderTest`, `DemoPlanComptableCoverageTest`.
- `roles-comptables.yml` : non modifié.
- Régression : suite complète sfd-comptabilite-service 1547 tests, 0 échec (3 ignorés préexistants). Baseline non mesurée avant (1er run partiel : seul échec = test cobac étendu, corrigé par les libellés).
- Note : machine saturée, UEMOA non traité.
- Aucun doublon de code introduit ; aucun compte renuméroté ou supprimé.
