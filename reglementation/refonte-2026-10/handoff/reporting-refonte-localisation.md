# S2 localisation — handoff (2026-10-23)

Branches locales (rien poussé) : `refs/heads/feature/reporting-refonte-localisation` dans sfd-reporting-service (f1418b0, sur 94652f2 puis 313a0e9) et sfd-commun-service (133eb44).
Tests : reporting 475 → 464 (0 échec ; -11 = anciens tests des YAML/zones supprimés, + nouveaux), commun 459 → 461 (0 échec).
Service testé sur PG jetable (base supprimée) : /actuator/health UP, 4 zones chargées (UEMOA 54 rapports/602 lignes, CEMAC 38/467, RDC 35/98, OHADA 22/452), /setup/init TG → 54 définitions UEMOA seulement, CI → +6.
GET /localisation exige un jeton OAuth (401 sans) : la lecture TG/CI est couverte par `LocalisationCloisonnementTest` (H2, contexte complet).

## Livré (sfd-reporting-service)
- `reporting/localisation/LocalisationRegistry` + `PaquetLocalisation` : parse unique, checksum SHA-256 (rapport = en-tête hors lignes ; ligne = map brute fusionnée), surcharge pays (modifier rapport+lignes, ajouter, désactiver ; entrées texte libre ignorées), variantes, alias.
- Entités : `ReportingParametre` (singleton id=1), `RapportDefinition`, `RapportFormuleHistorique`, `RapportFormule` étendue (paysCode, origine, checksumPaquet, versionPaquet, section, comptesAllegee, sourceDonnees, sens, normesParCategorie, confiance, sourceReference, aConfirmerArt44, planEdipIncomplet, modifiePar/Le), tout nullable. Mapping contrat : codeLigne=codeIndicateur, libelle=libelleIndicateur, comptes=comptesComptables, note=notesCalcul. `TypeValeur` + MONTANT/NOMBRE/RATIO.
- `FormuleSyncService` réécrit (synchro MISSING au démarrage et sur /setup/init), `ReportingParametreService` (mapping zone wizard, repli institution), `LocalisationService`, `RapportFormuleServiceImpl` (cloisonné), `FormuleLocalisationSupport` (libellé en clair).
- Endpoints : GET/PUT /parametres, GET /localisation, GET/POST /rapports/{code}/formules, GET /rapports/{code}/references, POST /rapports/{code}/formules/reinitialiser, GET/PUT/DELETE /formules/{id}, POST /formules/{id}/reinitialiser, POST /formules/reinitialiser-tout, GET /formules/{id}/historique ; /formules/valider et /apercu = 501 (S4).
- Cloisonnement : repository `findDansPerimetre(zone, pays, …)` ; hors périmètre = 404 (test de régression `LocalisationCloisonnementTest#formuleAutreZone_parId_404`).
- `/setup/init` : params `zone` (alias `zoneCode`), `paysCode`, `secteur` (ENTREPRISE/ASSOCIATION → OHADA).
- Catalogue (`ReglementaireCatalogueService`) lit `rapport_definition` borné zone+pays ; REP-* des modules conservés (zone = celle de l'institution).
- Supprimés : zones/*.yml (main et test), ActiveZoneRegistry, YamlZoneLoader, ZoneReportingConfig, ZoneReportingLoader, ZoneTemplateService, DTO Zone*/Layout/Sync*, FormuleSyncMode, `spring.config.import` zones.
- Endpoints retirés EN PLUS des 4 demandés (dépendaient des YAML de zones) : `GET /formules` (liste paginée), `/formules/metadata`, `POST /formules/reset`, `GET /formules/{id}/yaml-default`, `GET /formules/zones/active/layout`, `POST /formules` (remplacé par POST /rapports/{code}/formules). L'Angular actuel les appelle (`formule.service.ts`, `zone-layout.service.ts`) : S5 les remplace.
- CEMAC : les 5 comptes (4651 RP29 CEMAC-REP-001D, 389 HK05 CEMAC-REP-015, 7140 YG09 CEMAC-REP-002B, 634 ZP06 CEMAC-REP-002C, 5818dr EG44 CEMAC-REP-001A) figurent tels quels dans `cemac-beac/reporting.md` : pas d'erreur de transcription, donc pas de correction ; lignes marquées `confiance: BASSE` + note « absent du PCEMF EDIP, à confirmer avec le texte original ».

## Livré (sfd-commun-service)
`WizardInitOrchestrator.initializeExternalServices(zone, paysCode, secteur, institutionId, modules, longueur)` (ancienne signature conservée) ; `SetupInitContext` +paysCode/secteur ; `NexoraSetupModuleRegistry` ajoute `&paysCode=&secteur=` à l'URL reporting ; `SetupInitializationService` passe `request.getPaysCode()` et le secteur de l'institution. Hors périmètre strict mais indispensable. Tests ajoutés dans `WizardInitOrchestratorTest`.

## Impacts / à faire par l'orchestrateur ou S4/S5
1. **Monolithe** : `sfd-erp-monolith/.../MonolithAppConfig.java` lignes 46, 94-96 référencent `ZoneReportingConfig`, `ActiveZoneRegistry`, `YamlZoneLoader`, `ZoneReportingLoader` (supprimées) → à retirer ; `ZoneReglementaireMigration` reste (plus de @EventListener, appelée par `SetupReportingLoader`). Les nouveaux beans (LocalisationRegistry, ReportingParametreService, etc.) sont sous `com.synapsesit.sfd.reporting` : à vérifier si le scan du monolithe les prend (non vérifié, monolithe non compilé ici).
2. **Moteur (S4)** : `ReglementaireRapportCodeResolver` (mapping REG-BCEAO-xxx → BIL/CR…) et `dependentYamlCodes`/`DataCollectorService` visent d'anciens codes (`BIL`, `CR`, `RCSFD-BIL`…) qui n'existent plus ; les codes de paquet (DIMF-2000-BIL…) traversent `resolveFormuleCode` inchangés. `RapportEditionServiceImpl`/`ValidationServiceImpl` lisent `findByCodeRapportAndZoneReglementaire…` : OK avec la zone du paramétrage (`ZoneParametrageService.getActiveZoneCode()` conservé). Les zones SYCEBNL (`UEMOA-BCEAO-SYCEBNL`) n'ont plus de formules : le paquet OHADA les remplace.
3. Lignes sans `code` dans le paquet UEMOA (DIMF-2006/2007/2008/2009/2010/2011-1/2014/2018) : le registre leur donne le code technique `LIGNE_<ordre>` ; elles restent sans formule (ERREUR au calcul, S4).
4. `periodicite` libre du paquet normalisée (premier mot ; sinon `A_CONFIRMER`) ; `sens` DEC/ENC conservés tels quels ; `typeValeur` = POURCENTAGE si `norme.unite` contient %, sinon MONTANT.
5. PUT /formules/{id} = remplacement des champs libres (comptes, comptesAllegee, expression, sourceDonnees, section, norme, note) : un champ omis est vidé. L'UI doit renvoyer la formule complète.
6. Au premier démarrage sur une base existante : lignes héritées des anciens YAML (origine null, non personnalisées, codes absents du paquet) supprimées ; les personnalisées gardées (origine figée PERSONNALISEE) mais invisibles faute de rapport correspondant. `BCEAO`→`UEMOA-BCEAO` et `CEMAC-BEAC`→`CEMAC-COBAC` migrés (formules et éditions).
7. Base : colonnes ajoutées nullables via `ddl-auto: update` ; non testé sur SQL Server/MySQL (seulement H2 et PostgreSQL).

## Points à valider par un comptable / ambiguïtés
Aucun compte d'un paquet n'a été changé par S2 (seulement `confiance` et `note` sur 5 lignes CEMAC).

1. **5 comptes CEMAC absents du PCEMF EDIP** — 4651 (RP29, CEMAC-REP-001D), 389 (HK05, CEMAC-REP-015), 7140 (YG09, CEMAC-REP-002B), 634 (ZP06, CEMAC-REP-002C), 5818dr (EG44, CEMAC-REP-001A).
   - Question : ces comptes existent-ils dans le texte COBAC original et faut-il les ajouter au plan PCEMF, ou sont-ils une erreur du référentiel ?
   - Choix provisoire : compte conservé, ligne en `confiance: BASSE` avec note « absent du plan PCEMF EDIP, à confirmer ».
   - Source : `sfd-docs/reglementation/cemac-beac/reporting.md` (lignes RP29, HK05, YG09, ZP06, EG44, identiques au paquet) ; plan : `sfd-comptabilite-service` `feature/reporting-refonte` (05a8c5a).
2. **ZP06 CEMAC-REP-002C** — le paquet porte déjà « cat. 2/3 : 624 ; écart source à clarifier » : 634 ou 624 selon la catégorie ? Choix provisoire : 634 pour toutes les catégories. Source : reporting.md ligne ZP06.
3. **Mapping des zones du wizard** — UEMOA-BCEAO→UEMOA-BCEAO, CEMAC-BEAC→CEMAC-COBAC, RDC-BCC→RDC-BCC ; secteur ENTREPRISE ou ASSOCIATION→OHADA quel que soit le pays. Questions : une association/ONG en zone UEMOA relève-t-elle bien d'OHADA (SYCEBNL) et non d'un paquet SFD ? Les secteurs ASSURANCE sont-ils hors périmètre ? Choix provisoire : ASSURANCE suit la zone (pas de paquet dédié). Source : brief S2 (mapping imposé) ; ASSURANCE = décision S2, non sourcée.
4. **Variante UEMOA** — allégée par défaut, développée pour la catégorie ART44 ; la catégorie d'assujetti est saisie dans les paramètres (`categorieAssujetti`), pas déduite des encours. Question : l'application des seuils (encours ≥ 2 Md FCFA sur 2 exercices → développée ; < 50 M → allégée) doit-elle être automatique ? Choix provisoire : manuel. Source : `package.yml` UEMOA (`variantes`), Instr. BCEAO 021-12-2010.
5. **Lignes de paquet sans code** (UEMOA DIMF-2006, 2007, 2008, 2009, 2010, 2011-1, 2014, 2018) — code technique `LIGNE_<ordre>` attribué, aucune formule. Question : codes officiels et formules de ces lignes ? Choix provisoire : lignes affichées, calcul en ERREUR (S4). Source : paquets UEMOA.
6. **Périodicité libre du paquet** — normalisée sur le premier mot (ANNUELLE, SEMESTRIELLE…), sinon `A_CONFIRMER` (ex. « NON TROUVÉ », « A_CONFIRMER »). Question : périodicité réelle des rapports concernés ? Source : champ `periodicite` des paquets.
7. **Type de valeur** — POURCENTAGE si `norme.unite` contient « % », sinon MONTANT, quand le paquet ne précise pas `typeValeur`. À contrôler sur les ratios (RATIO/NOMBRE jamais déduits). Source : règle S2.
8. **Sens `DEC`/`ENC`** (17 lignes) conservés tels quels, sans signification comptable vérifiée. Source : paquets.
9. **Rapports ajoutés par pays (CI-PAYS-001 à 006, SN, BJ)** — rapports sans ligne ; entrées BJ/SN en texte libre ignorées par le registre. Question : contenu à définir par pays. Source : `pays/*.yml`.

## Corrections de revue (opus) — 2e passe
- Monolithe (`feature/reporting-refonte-localisation`, depuis feature/reporting-refonte) : 4 références supprimées retirées de `MonolithAppConfig`, `SetupReportingLoader` importé dans `MonolithModuleSetupConfig`, EXCLUS vidé et test d'import ajouté dans `MonolithSetupLoadersTest`. Vérifié contre un clone du dépôt Maven local (/tmp/m2-s2) contenant le jar reporting de cette branche (le `.m2` partagé n'est pas modifié).
- Repli institution : rien d'enregistré si `inst == null` ou `inst.id() == null` ; pas de nouvel essai automatique (appel HTTP de 10 s à chaque accès jugé trop coûteux) : prochain démarrage ou prochain `/setup/init`.
- Éditions : `RapportEditionServiceImpl`, `RapportAnnuelNarratifService`, `RatiosPrudentielController`, tableau de bord filtrés sur la zone (`ReportingNotFoundException` → 404). `BalanceImportServiceImpl` rattache l'édition importée à la zone de l'institution. Les éditions de démo (`ReportingDemoDataLoader`, zones « BCEAO »/« BEAC », codes REG-*) deviennent invisibles : à revoir avec S4.
- Formules : `RapportEditionServiceImpl.loadFormules` et `DataCollectorService` passent par `findDansPerimetre` (actives uniquement).
- Variante : `FormuleDto.comptesEffectifs` (lecture seule) ; moteur S4 : `FormuleLocalisationSupport.comptesEffectifs(formule, variante)` + `ReportingParametreService.variante()`.
- `differeDuPaquet` compare la note ; checksum du rapport inclut `actif` et `paysCode`.
- Tests : synchro (AJOUTEE/PERSONNALISEE intactes, version seule, orpheline désactivée, définition mise à jour), `SetupReportingLoader`, `ZoneReglementaireMigration`, `resolveZoneCode`, 404 d'édition hors zone, ALLEGEE/ART44, note seule. Tests existants des éditions/collecte/narratif/import adaptés aux nouveaux appels de repository (stubs), sans assertion supprimée.
