# S4 : moteur de formules, sources de données, import, contrôles (lot 2). Modèle sonnet, revue opus du diff

Lire d'abord `COMMUN.md` (même dossier), puis le contrat v1.1 en entier (`<WT>/sfd-docs/reglementation/REPORTING_API_CONTRAT.md`), en particulier la section 1 « Syntaxe des expressions » et la section 3 (Éditions, Données importées).
Socle déjà fusionné par S2 (registre, paramètres, cloisonnement) : lire `<WT>/.claude/handoff/reporting-refonte-localisation.md`.

## Branche
`sfd-reporting-service` : `feature/reporting-refonte-moteur`, créée depuis `feature/reporting-refonte` (070ad1b).

## But
Les éditions calculent **des chiffres justes, ou une erreur explicite**, à partir des paquets de localisation. Les données viennent soit des modules EDIP (mode INTEGRE), soit d'une balance et de données annexes importées (mode STANDALONE). Le mode est choisi par `ReportingParametre.modeSource` ; l'utilisateur ne le choisit jamais à l'édition.

## Travail
1. **Moteur** (`FormulaEngineService`, à réécrire ; SpEL n'est plus utilisé pour la substitution textuelle) :
   - Tokenisation par plus long code connu. Gère les références locales, `RAPPORT.LIGNE`, `@ALIAS` (résolu par `package.alias` selon `categorieAssujetti`), le suffixe `[N-1]`, `MIN`/`MAX`, `+ - * / ( )` et les constantes.
   - Ordre de calcul topologique entre lignes et entre rapports. Un cycle est détecté et reporté.
   - Une référence inconnue, une formule absente ou une division par zéro donnent `conformite: ERREUR` avec un message clair. Jamais 0 silencieux.
   - Les comptes effectifs viennent de `FormuleLocalisationSupport.comptesEffectifs(formule, variante)`. Gère les préfixes, le `-` qui soustrait, les suffixes `dr`/`cr` (solde débiteur ou créditeur uniquement) et le `sens` D/C/SOLDE.
   - Natures : DOCUMENT et EXTERNE ne sont pas calculées (statut « à joindre » ou « format externe »).
2. **Endpoints** `/formules/valider` et `/formules/apercu` (aujourd'hui en 501) : erreurs typées, `libelleClair` (« Encours sains ÷ Total actif × 100 »), valeur et comptes contributeurs.
3. **Édition** (`RapportEditionServiceImpl`, `DataCollectorService`, `ReglementaireRapportCodeResolver`) :
   - Recoder sur les codes des paquets. Les anciens codes BIL, CR et IND, ainsi que REG-BCEAO-xxx, disparaissent. Garder une correspondance pour les éditions historiques si la base en contient.
   - Conformité réelle (norme et `normesParCategorie`), N-1 et variation, `hashIntegrite` SHA-256, régulateur et référence du texte lus dans le paquet (plus de « BCEAO » en dur dans les exports), statut SOUMIS (`POST /editions/{id}/soumettre`), `GET /editions/tableau-periode`.
   - Le chargeur de démo (`ReportingDemoDataLoader`) produit des éditions visibles dans la zone de l'institution démo. Ses éditions BCEAO/BEAC sont aujourd'hui invisibles après le cloisonnement.
4. **Sources** : interface `SourceDonneesProvider`.
   - `ModulesProvider` reprend les connecteurs existants (compta : soldes de comptes ; crédit, épargne, client, RH, préférence : clés `CROSS_SERVICE:<clé>`). Liste les clés CROSS_SERVICE des paquets et branche chacune sur un connecteur existant. Une clé non branchée donne ERREUR « donnée non disponible », jamais 0.
   - `ImportProvider` lit les données importées.
5. **Données importées** (mode STANDALONE) : entités `BalanceImportee` et `DonneeAnnexeImportee`, endpoints `/donnees-importees/*` du contrat, modèle Excel généré depuis le paquet (onglet Balance plus un onglet par donnée annexe CROSS_SERVICE). Contrôles : équilibre, comptes inconnus du plan, période. L'ancien `BalanceImportServiceImpl.confirm`, cassé, est remplacé.
6. **Contrôles de cohérence** (`ControleCoherenceService`, `GET /editions/{id}/controles`) :
   - bilan équilibré, résultat du compte de résultat égal au résultat du bilan, contrôles `controle:` des lignes ;
   - en mode INTEGRE : encours crédit du rapport = encours du module Crédit, dépôts = module Épargne, balance = Comptabilité ;
   - un contrôle CRITIQUE bloque la validation (409 avec message).

## Périmètre
- Modifiables : `sfd-reporting-service` (moteur, édition, collecte, sources, import, contrôles, démo, exports pour l'en-tête du régulateur, avec leurs tests).
- Lecture seule : les autres services, dont tu lis les endpoints de reporting existants.
- Si un module doit exposer une donnée qui manque, ne le modifie pas : liste-le dans ton handoff, l'orchestrateur décidera.
- Exclus : l'Angular, et le ZIP et les états financiers (lot S6).

## Exactitude (obligatoire)
Écris un test d'intégration par zone (UEMOA, CEMAC, RDC) avec une balance de test **dont chaque total est calculé à la main** dans le test. Exemple : bilan UEMOA DIMF-2000-BIL, avec Caisse sur le compte 10, et non sur 52/57. Vérifie au moins le bilan, le compte de résultat et un ratio prudentiel par zone. Un écart est un bug à corriger, pas un test à ajuster.

## Terminé quand
- `scripts/claude/regress.sh sfd-reporting-service` donne 0 échec, avec baseline (487) → après.
- Le service démarre sans profil sur une base démo jetable. La génération d'un rapport UEMOA renvoie des valeurs ou des erreurs explicites, et aucune ligne n'est à 0 « silencieux ».
- Le handoff `reporting-refonte-moteur.md` contient la liste des clés CROSS_SERVICE et leur branchement, les données manquantes dans les modules, et les points à valider par un comptable.
