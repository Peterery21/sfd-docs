# S6 : export ZIP, exports régulateur, états financiers, balance consolidée compta (lot 3). Modèle sonnet

Commence par lire `COMMUN.md` (même dossier), puis le contrat v1.1, section 3 (« Éditions » : export-zip ; « États financiers »). Lis aussi les handoffs `<WT>/.claude/handoff/reporting-refonte-moteur.md` (S4) et `reporting-refonte-localisation.md` (S2).

## Branches
- `sfd-reporting-service` : `feature/reporting-refonte-zip-ef`, à partir de `feature/reporting-refonte` (84ca433).
- `sfd-comptabilite-service` : `feature/reporting-refonte-zip-ef`, à partir de `feature/reporting-refonte` (05a8c5a).

## Travail
1. **Balance consolidée, compta.** Aujourd'hui `/consultation/balance` exige `X-Agence-Code`, et le calcul se fait compte par compte (N+1, timeout de 60 s). En mode INTEGRE, une édition consolidée sort donc en ERREUR.
   - Ajouter `GET /reporting/balance?dateFin=&codeAgence=` (agence facultative, consolidé si absente). Il renvoie débit et crédit cumulés par compte à la date, en **une seule requête agrégée** (SQL GROUP BY, portable PG, MSSQL et MySQL), avec `@PreAuthorize` sur les rôles de service ou de reporting existants.
   - Côté reporting, `ModulesProvider` l'utilise pour CONSOLIDE et pour l'agence. Garde le refus MULTI ou implémente-le par somme.
   - Tests : un test d'intégration compta qui vérifie qu'une balance consolidée de deux agences est égale à la somme des deux, et les tests reporting.
2. **Corrections compta issues du Lot 0** (`sfd-docs/reglementation/syscohada-sycebnl/etats-financiers.md`, section f) : TFT et CAFG dans `EtatsFinanciersController` et le JSON `etats-financiers.json`.
   - 848 est compté deux fois.
   - 409 manque dans FD, 419 manque dans FE, et 488 doit être retiré de DH.
   - FI = 821, 822, 754 et FJ = 826, nets de 485 et 414.
   - RS doit être 89 en net (899 déduit).
   - 477 va au passif circulant.
   - 219, 239 et 249 sont à éclater.
   Pour chaque correction : sa source, et un test chiffré.
3. **Export ZIP** : `POST /editions/export-zip`, avec `ExportZipRequest` comme dans le contrat.
   - Filtrer par zone et pays.
   - Si `genererManquants` est vrai, générer les éditions manquantes de la période.
   - Écrire le ZIP en streaming (`StreamingResponseBody`), avec un fichier par rapport et par format, plus `manifest.json` (code, période, statut, hashIntegrite, nombre de lignes en erreur).
   - Limiter la mémoire : ne jamais charger tous les PDF en mémoire.
4. **Exports régulateur.** `ReglementaireExportService` choisit encore son layout d'après les anciens codes `REG-BCEAO-xxx`. Le choix doit passer par `layout` et `nature` du paquet (BILAN_BICOLONNE, CR_VERTICAL, RATIOS, ANNEXE, GENERIC ; DOCUMENT et EXTERNE produisent une page de garde « document à joindre » ou « format externe »). L'en-tête (régulateur, référence du texte, institution, signataires) vient du paquet et de `ReportingParametre`. Les lignes en ERREUR apparaissent avec leur message, jamais à 0.
5. **États financiers** : `GET /etats-financiers?type=BILAN|CR|TFT|NOTES&periodeFin=` et `/etats-financiers/export`, conformes au contrat.
   - Référentiel déterminé par la zone : RCSFD, PCEMF, PCCI ou SYSCOHADA/SYCEBNL (OHADA).
   - En mode INTEGRE : endpoints compta existants, corrigés au point 2.
   - En mode STANDALONE : rapports EF du paquet de la zone (bilan et compte de résultat existants) appliqués à la balance importée, via le moteur S4.
   - Remplit `equilibre` et `netN1`.
   - Les anciens endpoints `/sycebnl/*` du reporting deviennent des alias, ou sont supprimés si plus personne ne les appelle (grep dans l'Angular, sans modifier l'Angular).

## Périmètre
- **Modifiable** :
  - dans `sfd-reporting-service` : export, ZIP, états financiers, `ModulesProvider` (branchement de la balance), avec les tests ;
  - dans `sfd-comptabilite-service` : un nouvel endpoint de balance de reporting et les corrections TFT/CAFG, avec les tests.
- **Exclus** : `src/main/resources/localisation/**` (S2b y travaille en parallèle), l'Angular, et le moteur (`moteur/`), sauf correctif minimal à signaler.

## Terminé quand
- `scripts/claude/regress.sh` donne 0 échec pour sfd-reporting-service et pour sfd-comptabilite-service (baseline → après).
- Les deux services démarrent sans profil sur une base démo jetable. Tu as vérifié par HTTP :
  - une édition UEMOA consolidée en INTEGRE donne des valeurs, et non ERREUR ;
  - le ZIP d'une période contient le manifest et des PDF lisibles ;
  - le bilan des états financiers est équilibré.
  Ensuite, arrête les services et supprime la base.
- Handoff `reporting-refonte-zip-ef.md` avec les points à valider par un comptable.

## Compléments v1.2 (contrat, 2026-10-23) : à faire aussi dans S6, sur `sfd-reporting-service`
Cette section l'emporte sur l'exclusion « moteur » ci-dessus, et seulement pour le point 1.
1. Moteur : ajouter la fonction `SOLDE("<comptes>", D|C|SOLDE)` dans les expressions (même lecture des comptes et même variante que `comptes`). Elle est aussi acceptée par `/formules/valider` et `/formules/apercu`, avec un `libelleClair` du type « Solde des comptes 10, 11, 12 (débit) ». Ajouter des tests chiffrés.
2. `FormuleDto` : exposer `aConfirmerArt44`, `planEdipIncomplet` et `comptesEffectifs` (si ce n'est pas déjà fait).
3. `ReportingParametreDto.paysLibelle` (libellé du pays, via IntegrationClient ou le paquet) et `LocalisationDto.categoriesAssujetti` (issu de `typesAssujettis` du package.yml, avec libellé).
