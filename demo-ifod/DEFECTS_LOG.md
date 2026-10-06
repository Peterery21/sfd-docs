# Journal des défauts trouvés pendant la démo IFOD (vérification navigateur)

Légende : [OPEN] à corriger, [FIXED] corrigé (avec fichier), [WONTFIX] décision.

## Constatés au 1er boot (corrigés)
- [FIXED] Commun : insertion `pays` avec UUID alors que `id` est BIGINT identity → échec au démarrage sur base vide (`sfd-commun-service/.../config/PaysSetupService.java`).
- [FIXED] Portail employé : JPQL `SessionPortail` au lieu du nom d'entité `PortailEmployeSession` → contexte Spring KO (`SessionPortailRepository`).
- [FIXED] Ordre de démarrage : le workflow doit être UP avant rh/paie (sinon les 9 types RH ne s'enregistrent pas après 8 essais) → `01_start_stack.sh`.
- [FIXED] Institution : l'enregistrement du formulaire écrasait `organisation` (RDC → UEMOA) et `secteur_activite` (SFD → NULL) (`InstitutionMapper`, `InstitutionDto`, par l'agent compta/épargne).

## Constatés dans le navigateur intégré (2026-10-05)
- [OPEN] `/preference/institution` : texte d'aide « Montant du capital social en XOF » en dur alors que la devise est CDF.
- [OPEN] `/preference/institution` : sous-titre de page « Description » (clé de traduction non finalisée) sous le titre « Institutions ».
- [OPEN] `/rh/parametrage/grilles-salariales` : le fil d'Ariane affiche « Ressources Humaines > Titre > Grilles salariales » (« Titre » = clé de traduction placeholder) ; la colonne « Catégorie d'emploi » est vide sur les premières lignes (à revérifier quand la saisie sera finie : liaison grille ↔ catégorie).
- [OPEN] Sélecteur d'agence en en-tête : l'agence connectée par défaut est « Agence Goma » au lieu du siège AG001 (à vérifier : défaut = agence principale/siège après wizard).
- [FIXED] Wizard : fuseau horaire et référentiel de reporting laissés à Africa/Lome et BCEAO_STANDARD pour une institution RDC ; devise XOF restait « principale » (`SetupInitializationService`, `AccountingNormMatrix`).
- [FIXED] Compta : `journaux.yml` utilise `typeJournal: GENERAL` inconnu de l'enum → journaux OD/INT ignorés (`SetupComptabiliteLoader`, GENERAL→OD).
- [FIXED] `devise-code.pipe` pur figé sur XOF (`devise-code.pipe.ts` → impur).
- [OPEN] Journaux système créés au 1er boot avec devise XOF alors que l'institution est en CDF (confié à l'agent compta).
- [UX] Champ « date d'agrément » : format mm/dd/yyyy en anglais, dd/mm/yyyy en français (saisie silencieusement fausse possible).
- [OPEN] AG001 (créée par le wizard) sans ville ni devise.

- Jours fériés: commun source unique (RH stack supprimé, table rh_jour_ferie orpheline, congés comptés en jours calendaires). Pays: zoneMonetaire enum + GET /pays/zones-monetaires.

## RH paramétrage (demo-rh-param) — ouverts
- Modales param se ferment avant réponse serveur (saisie perdue sur doublon)
- 2 toasts sur une erreur (sanctions); messages champ requis incohérents; bouton Enregistrer désactivé sans message (grilles, pointage, taux HS)
- Étapes recrutement: delete via confirm() natif
- Types de contrat: pas de période d'essai; Postes: catégories A-D seulement (pas lien table catégories)
- salaireMinLegal=0 non validé vs SMIG; layout double header page grilles; HS tranche2 défaut 35%
- rh_jour_ferie: 11 lignes orphelines (table plus utilisée)

## Institution/devise
- Fixed: clé i18n PREFERENCE.INSTITUTION.DESCRIPTION_LABEL manquante (fr/en)
- Ouverts: XOF codé en dur caisse (billetage, coupures, session, clôture), épargne depot-edition/compte-ouverture, défauts compta/suivi-eval; REP-PRF-023 conforme = XOF/XAF seulement; pas de garde changement devise principale si écritures; npm run build non vérifié (ngc ok)

## Compta/épargne (demo-compta-epargne) — ouverts
- PDF rapports préférence: logo+nom IFOD absents (sfd-report-api RapportContextService hardcode XOF/FCFA/Africa/Dakar; commun n'alimente pas logo)
- REP-PRF-019 → 400 (enum absent); REP-PRF-009/015-018 idem probable
- Schémas comptables épargne: comptes 4 chiffres (7011, 6721, 471, 773) hors PCCI 6 chiffres; lignes caisse "undefined"; "Remboursement crédit" mode vide
- NG0100 liste journées comptables; code exercice hint vs EX-2026; bouton Ajouter période seulement si exercice ouvert; wizard clôture libellés FR en UI EN; champ Banque texte libre; dashboard compta 400 au 1er appel; date agrément dépend locale
- Produit épargne code EP-FEMME (max 14 car.)

## Paie paramétrage IFOD_RDC (spec 20-paie-parametrage.spec.ts, 2026-10-05)
- [FIXED] Paramètres pays/profil : `codePays` = liste déroulante des pays ISO2 seulement → profil `IFOD_RDC` impossible à saisir ; devient ng-select à saisie libre (`param-pays-liste.component.html`).
- [FIXED] Paramètres pays/profil : création impossible (formulaire invalide) — `dateEffet` obligatoire remise à null à l'ouverture et sans champ à l'écran ; champ ajouté + valeur par défaut. Champ `plafondSecuriteSociale` absent de l'écran : ajouté (i18n fr/en).
- [FIXED] Paramètres pays/profil : devise (lecture seule, obligatoire) vide car lue à la construction du composant avant chargement du référentiel : lue à l'ouverture de la modale (`CurrencyService.getDefaultCode()`).
- [FIXED] Paramètres pays, Cotisations, Tranches IRPP : liste des pays jamais chargée (aucun `PaysActions.invokeFetchAll`) → select vide ; dispatch ajouté. Cotisations : option « Tous pays » affichait la clé brute `LABELS.TOUS_PAYS` (pipe translate manquant).
- [FIXED] Simulation (employé fictif) : indemnités de logement/transport (rubriques REF_GRILLE) impossibles à fournir sans contrat/grille ; un élément variable de même code surcharge désormais le montant de grille (`PayrollEngine`, test `refGrilleSurchargeParElementVariable`).
- [FIXED] Simulation : « Employé null null » pour un employé fictif sans nom (`PayrollEngine.nomComplet`, template simulation ; test `employeFictifSansNom`).
- [OPEN] POST `/rubriques` avec un code en doublon répond HTTP 500 (attendu 400/409 avec message) — vu quand la spec a rejoué des créations.
- [OPEN] Regroupements de bulletin figés « Heures supp. 25 % / 50 % » alors que RDC = 30 % / 60 % (HS_30 → HEURES_SUPP_25, HS_60 → HEURES_SUPP_50) : libellé trompeur sur le bulletin.
- [OPEN] Nombres de l'écran Simulation formatés à l'anglaise (1,200,000 / 88,886.4) alors que l'interface est en français.
- [OPEN] Plan comptable : 650100/650200 = « cadres conventionnés / agents de catégories » et 651100/651200 idem ; le schéma de paie est indexé par rubrique/regroupement/organisme (pas par catégorie d'employé) : mapping retenu 650000 salaire de base, 650100 primes et indemnités, 650200 heures supp. ; 651000 CNSS, 651100 INPP, 651200 ONEM. À valider avec la compta IFOD. AVANCE → 420000 (hors spec, à confirmer) ; RETENUE_ABSENCE crédite 650000.
- [OPEN] Comptes banque 560100 / mobile money 560400 : existent au plan comptable mais ne sont pas un champ du paramétrage paie (contrepartie trésorerie résolue côté comptabilité selon la domiciliation) ; journaux PAIE_PERIODE et VIREMENT_SALAIRE = PA.
- [A CONFIRMER IFOD] `ALLOC_FAM_PAR_ENFANT` saisi à 0 (ligne ALLOC_FAM omise) ; paliers PRIME_ANC 0/5/10/15 ans = 0/2/4/6 % provisoires ; SMIG 559 000.
- [UX] Listes NgRx : « Aucune donnée » affiché avant la réponse du serveur (la spec attend la fin du chargement).

## RH employés / contrats / carrière (angular-rh, 2026-10-05)
- [FIXED] Fiche/création employé : aucun champ département/poste/agence/supérieur dans le formulaire (le backend crée l'affectation initiale si les 3 sont fournis) → ajoutés en création (`employe-edition.component.*`) ; `superieurId` avait un contrôle sans champ → `app-employe-search-input valueField=id`.
- [FIXED] `EmployeSearchInput` en mode `valueField='id'` : `writeValue` cherchait l'id comme matricule (toast « non trouvé », valeur effacée) → `getById` (`employe-search-input.component.ts`, `employe-selector.service.ts`).
- [FIXED] Contrat (modal) : pas de champ « Date de début » ni « Date de fin » alors que requis (CDD/Stage impossibles à créer, début = date d'embauche implicite) → champs ajoutés (`contrat-edition.component.html`).
- [FIXED] NG0100 intermittent sur la fiche employé / liste : `invokeFetchPostes`/`invokeFetchDepartements` basculaient `isLoading` (page parente) pendant l'ouverture d'un modal, et la fiche disparaissait le temps du chargement → `isLoadingPostes` (`employe.reducer.ts`) ; le modal d'édition employé ne relance plus `invokeGetOneById` si la fiche est déjà chargée.
- [FIXED] Fiche employé : sexe toujours « Féminin » (l'API renvoie MASCULIN/FEMININ, le template testait 'M') ; supérieur hiérarchique toujours « - » (l'API ne renvoie que superieurId) → résolution du nom.
- [FIXED] Promotion : champ `nouvelleCategorieEmploi` inexistant dans le FormGroup (NG « Cannot find control », onglet Nouvelle situation cassé) → `nouvelleCategorie`.
- [FIXED] Mutation/Sanction/Formation : POST avec `id: 0` → 500 (StaleObjectState) car `create` ne remettait pas l'id à null (Promotion/Objectif le faisaient) ; test de non-régression `MutationServiceImplTest`.
- [FIXED] Mutation/Sanction : `(employeSelected)` non branché → matricule/nom employé vides en base et en liste (la mutation et la sanction n'affichaient aucun employé) ; handlers typés `EmployeSelectorItem` (build Angular cassé sinon).
- [FIXED] Grilles salariales : date d'effet par défaut = aujourd'hui → aucune grille « active » à la date d'embauche (2018…) dans le contrat ; saisie via UI de la date d'effet 01/01/2018 sur les 14 grilles (spec 30) et `dateEffet` ajouté à `rh-parametrage.json`.
- [OPEN] Employé : nationalité par défaut « Sénégalaise » (devrait suivre le pays de l'institution).
- [OPEN] Formulaires carrière (promotion/mutation/sanction) : `id: 0` envoyé à la création (corrigé côté backend pour mutation/sanction/formation ; à nettoyer côté front) ; mutation : `ancienneAgenceId` toujours null (agence de départ non renseignée).
- [OPEN] Sanction : le formulaire utilise des enums figés (Avertissement/Blâme/…) et non les « types de sanction » paramétrés (RH > Paramétrage).
- [OPEN] Sessions : tout redémarrage de preference ou connexion admin concurrente révoque la session (rafale de 401 sur /preference/users/currentUser…) ; les specs se reconnectent (`helpers/rh-page.ts`).
- [OPEN] Domiciliation INTERNE : 13 employés créés sans domiciliation en attente de clients + comptes épargne (aucun créé à ce jour par l'agent compta/épargne) — IFOD-0005,6,7,8,10,11,12,16,17,19,21,22,24.
- [UX] Liste mutations : suppression d'un brouillon sans confirmation.

## Clients + épargne (demo-clients-epargne) — corrigés
- [FIXED] Client wizard : nationalité « Togo (TG) » et pays « Togo » figés par défaut → défaut = pays du siège de l'institution (`client-edition.component.ts`, `applyInstitutionCountryDefaults`).
- [FIXED] Épargne `GET /comptes-generaux-produits/recherche` : 404 + « aucun compte général » quand seul le compte par défaut du produit (sans type client) existe → repli sur le compte par défaut (`CompteGeneralProduitService`, +test).
- [FIXED] Ouverture de compte : « KYC non validé (EN_ATTENTE) » alors que le KYC vient d'être validé (fiche client en cache 60 min dans sfd-integration-api) → statut KYC relu sans cache (`ClientService.validerPourOuvertureCompte`, +test). Lib à réinstaller (`mvn install`) + redémarrer les services consommateurs.
- [FIXED] sfd-integration-api `PreferenceRestClient.findDeviseByCode` appelait `/devises/{code}` (traité comme id → 400) au lieu de `/devises/code/{code}` → toute devise ≠ XOF « invalide ou inactive » (génération comptes auxiliaires CDF, etc.). Test IT corrigé.
- [FIXED] Épargne ouverture de compte : billetage figé sur XOF (`[devise]="'XOF'"`, `deviseCode:'XOF'`) → devise principale ; DTO billetage porte la devise du billetage.
- [FIXED] Caisse coupures : `GET /coupures` sans taille de page → Spring tronque à 20 éléments ; les coupures CDF au-delà (ex. 50 CDF) disparaissaient de la liste et du billetage → `size=1000` (`coupure.service.ts`, +spec). (Backend ignore toujours le param `devise`.)
- [FIXED] NG0100 sur `app-agence-select` (valeur du formulaire écrite pendant la détection de changements) → reconstruction des options différée/regroupée ; page génération comptes auxiliaires : défauts différés ; ouverture de session caisse : `isLoading` différé (NG0100 sur `[disabled]`).
- [FIXED] Compta : génération des comptes auxiliaires jamais lancée pour les agences (sélecteur de compte auxiliaire de la caisse vide) → lancée par l'UI (1924 comptes, 4 agences, CDF).

## Clients + épargne — ouverts
- Bandeau « CASH BALANCE » du header affiche « 150 000 F CFA » en session CDF (symbole XOF codé en dur ; composant du bandeau session caisse).
- Dashboard épargne : libellés d'opération « … - 150 000 XOF » (montant suffixé XOF dans le libellé de l'opération DEPOT) alors que la devise est CDF ; événement « Type inconnu » (SYSTEM) en doublon du dépôt dans « Recent Activity » ; horodatage « 22h ago » pour une opération de 1 min.
- `epargne/collecte/depot-edition` : billetage encore codé XOF (`[devise]="'XOF'"`, `deviseCode:'XOF'`).
- Page `/epargne/comptes/ouverture` : après « Account opened successfully » le formulaire reste affiché (pas de redirection vers la fiche du compte).
- Backend coupure : message « existe déjà » pour la même valeur dans la même devise mais liste UI incapable de la montrer (voir fix size).
- Recherche client (liste) : ne couvre ni e-mail ni numéro de pièce (seulement nom/prénom/téléphone/code).
- Une seule session utilisateur active : tout login d'un autre agent invalide la session (401 « Session invalidée ») — les specs doivent être relancées (setup + retry).

## Audit log roles (lib activity-tracking, Java/commons)
- audit_log.roles varchar(255) → 500 sur écritures auditées pour users avec nombreux groupes WF. Local: ALTER NVARCHAR(MAX) (autorisé user). Code: @Column(length=4000) ajouté dans AuditLog.java (lib NON republiée/commitée; à builder+installer et pousser avant VPS, sinon roles tronqué/erreur sur VPS reset: la colonne sera créée à 4000 après rebuild des services).
- [FIXED] Absence : POST sans statut → NPE (500) dans `AbsenceServiceImpl.soumettreAuWorkflowSiNecessaire` ; durée toujours 0 jour (jamais calculée) ; libellé du type affiché en clé i18n brute (`RH.TYPE_ABSENCE_CONGE_SS`) → statut par défaut EN_ATTENTE + durée calendaire inclusive côté service (+2 tests), libellé résolu depuis les types paramétrés (`absence-liste`).
- [FIXED] Pointage : l'anomalie « RETARD » posée par une valeur intermédiaire de la saisie d'heure n'était jamais levée → pointage à 08:00 marqué ANOMALIE (`pointage-edition.component.ts`).
- [FIXED] Workflow-service : NoClassDefFoundError `WorkflowCallerContext` après reconstruction de la lib sfd-integration-api sans redémarrage → toute soumission de congé 400 ; résolu par redémarrage (restart_service.sh).
- [OPEN] Congé/absence/offre soumis via workflow : le champ « Employé » est vide dans les données de la demande (« — ») ; admin ne peut pas valider ses propres demandes (règle), approbations à faire par les comptes approbateurs (demo-workflow).
- [OPEN] Congé (liste) : `validateurId: 1` et motif de refus « Refusé » codés en dur ; type absence/formation/sanction sans lien avec les référentiels paramétrés (domaine formation = liste figée).
- [OPEN] Évaluation (liste) : nom de l'employé non affiché (seul le matricule) ; offre d'emploi : publication par `confirm()` natif.
- [OPEN] Liste « Pointage » : vue par date uniquement (pas de vue mensuelle), « Pointages du jour » ne conserve pas l'agence/le mois.

## Agora (spec 50-agora.spec.ts, 2026-10-05)
- [FIXED] Article : date de publication saisie (`yyyy-MM-dd`) envoyée telle quelle à un `LocalDateTime` -> POST /agora-articles 400 ; conversion ajoutée (`core/date-publication.util.ts` + spec karma) et relecture en édition.
- [FIXED] Groupes Agora : liste non rafraîchie après création/suppression/ajout de membre (compteur de membres à 0, nouveau groupe invisible) ; `appliquerFiltreGroupes()` rappelé.
- [FIXED] Groupes Agora > Dossiers accessibles : getter `dossiersDisponibles` renvoyait un nouveau tableau à chaque détection de changements -> ng-select réinitialisé, clic sur une option sans effet ; tableau mémorisé.
- [FIXED] Téléversement GED : fichiers envoyés en parallèle -> deadlock SQL Server (HTTP 500) dès 2 fichiers dans un dossier ; envoi séquentiel (`document-upload-modal`).
- [FIXED] Aucun rôle `ROLE_AGORA_*` enregistré dans la table des rôles : impossible de donner accès à Agora à un non-admin (Gestion des accès). `SetupAgoraLoader` (+ test) enregistre les 43 rôles au démarrage.
- [FIXED, hors code] `audit_log.roles` varchar(255) : 500 sur toute écriture d'un utilisateur à nombreux rôles (groupes WF-*). Colonne passée en NVARCHAR(MAX) en local (autorisé) ; `@Column(length=4000)` ajouté dans activity-tracking-starter-full (non publié : agora consomme 1.0.0-SNAPSHOT) ; à reporter sur le VPS.
- [OPEN] Création utilisateur / groupe de sécurité : le modal reste ouvert et se réinitialise après enregistrement ; « Actif ? » décoché par défaut (utilisateur créé INACTIF).
- [OPEN] Route `pages/unauthorized` inexistante (NG04002) : page blanche pour un utilisateur sans droit sur une route.
- [OPEN] Tableau de bord d'accueil et widget session de caisse appellent des API 403 pour un utilisateur sans droit (comptabilité, caisse, épargne, client).
- [OPEN] Sélecteur de rôles : l'apostrophe disparaît des descriptions (« lintranet »).
- [OPEN] Date de publication d'un article remplacée par la date de validation (comportement serveur à confirmer).
- [OPEN] Chat : repli SockJS `/api/chat/ws/iframe.html` en 404 (+ X-Frame-Options deny) en console.
- [OPEN] Meilisearch absent en local (hôte `sfd-meilisearch-dev` injoignable) : indexation et recherche Agora KO ; RabbitMQ : exchange `agora.events` absent du vhost `/sfd`.
- [OPEN] Lordicon charge ses JSON sur un CDN externe (erreur console hors ligne).
- [UX] Initiales de rubrique « D/ » pour « Digital / IFODCASH ».

## Workflow (spec 60-workflow.spec.ts, 2026-10-05)
- [FIXED] Sélecteurs de rôles/groupes (modales Accès) : un rechargement du store remettait la liste non filtrée malgré la recherche saisie (`role-selector`, `groupe-selector`) ; ces modales partageaient le `PaginationService` racine avec la page appelante → NG0100 sur « Rôles du groupe » (providers locaux + `observeOn(async)` dans `groupe-role`).
- [FIXED] Formulaire de démarrage (`workflow-dynamic-form`) : `options(field)` retournait un nouveau tableau à chaque détection → toute liste `select` (ex. type de mutation) perdait sa sélection, formulaire impossible à soumettre. Options mémorisées.
- [FIXED] Éditeur d'étape, onglet Notifications : les règles fournies par les modules (`evenement`, `destinataireType`, `canal[]`) s'affichaient vides ; normalisées à l'affichage (une règle par canal) + libellés des événements natifs (fr/en).
- [FIXED] Définition de processus : aucune saisie de `settings.portail` (visible/catégorie/icône/listes) dans l'UI → carte « Publication au portail employé » ajoutée (fr/en).
- [OPEN] Résolution des approbateurs par GROUPE inopérante : `PreferenceRestClient.doFindUserByUsername` (sfd-integration-api) attend une `List<UserAccountResponse>` et filtre sur `username`, or `GET /users?search=` renvoie une page `{content:[…]}` sans `username` (email) → groupes toujours vides, étapes à `groupesValideurs` inaccessibles. Contournement démo : approbateurs nominatifs (`utilisateursValideurs`).
- [OPEN] Une ré-inscription des modules (redémarrage de sfd-rh-service) remet TOUTES les définitions RH à leur modèle d'origine (SLA, approbateurs, escalade, notifications perdus ; version +1). Après chaque redémarrage RH : rejouer `npx playwright test -c playwright.demo.config.ts 60-workflow -g "définition"`.
- [OPEN] Écran Instance (approbateur sans `ROLE_WORKFLOW_DEFINITION_READ`) : `GET /definitions/{id}` → 403 et « Données de la demande » vide ; contournement : rôle ajouté aux groupes WF-*. Le backend devrait autoriser les participants (ou l'instance embarquer le schéma).
- [OPEN] Tableau de bord d'accueil : requêtes compta/client/épargne/crédit/caisse non filtrées par rôle → 403/500 pour un approbateur (bruit console, toast « Une erreur est survenue »).
- [OPEN] Éditeur de processus : le lien « matrice des pouvoirs » (`/workflow/matrices-pouvoirs`) n'a aucune route/écran (service Angular seul) ; l'étape MATRICE_POUVOIRS est donc inconfigurable par l'UI. Seuils par montant faits avec le type MONTANT (utilisateurs par tranche, champ `budgetPrevisionnel`) ; le modèle d'origine utilisait `montant` (champ absent du formulaire mission).
- [OPEN] Modèle d'origine des étapes : rôles `ROLE_ADMIN` pour DGA/DG/direction, `ROLE_RH_EMPLOYE_ALL` pour le manager d'avance, mutation/promotion en HIERARCHIE (N+1 ≠ RRH) ; reconfigurés par l'UI.
- [OPEN] Instance dont l'objet source a été supprimé (WF-2026-00008) : annulation vetoée par RH (409 « introuvable ») — corrigé côté RH (WorkflowLinkSupport), annulée après redémarrage ; journal d'audit affiche la valeur brute `WORKFLOW.ACTION.VETOEDMESSAGE`.
- [OPEN] SLA minimum 1 h : un dépassement de SLA ne peut être démontré qu'après attente (WF-2026-00018 « Validation express », échéance 1 h après 19:08) ; kanban : liste déroulante par défaut sur la 1re définition (avance, vide).
- [UX] Création d'un groupe : la modale reste ouverte et se vide (enchaînement) ; la lib lordicon (modale de suppression) déclenche un « Failed to fetch » en console.
- [NOTE] Aucune définition PAIE enregistrée tant que sfd-paie-service n'a pas envoyé son battement (cartes « Indisponible » au catalogue) ; comptabilisation/validation paie : pas de champ montant → pas de seuil DG possible.

## Agora (demo-agora) — résumé
- Saisie OK: 12 users ERP, 5 rubriques, 8 articles, 4 groupes, GED 9 PDF (Paie RESTREINT), 3 espaces, 24 posts, ~50 réactions, ~20 commentaires. Spec 50-agora 12 passed/1 skipped.
- Ouverts: Meilisearch absent en local (recherche non testée, ne pas installer sans accord); exchange RabbitMQ agora.events absent (vhost /sfd); modales user/groupe restent ouvertes; "Actif ?" décoché par défaut (user INACTIF); route pages/unauthorized absente; widgets accueil 403; apostrophe perdue descriptions rôles; validation article écrase date publication; bruit chat SockJS/Lordicon; initiales rubrique "D/"; 401 sporadiques /api/preference (token admin invalidé quand autres agents se loggent).
- VPS: ALTER audit_log.roles requis + lib activity-tracking rebuild; agora utilise 1.0.0-SNAPSHOT.

## Passe de correction 2026-10-05 (soir) — état
- [FIXED] PDF préférence : en-tête logo/nom/devise/fuseau depuis l'institution (`PreferenceRapportIntegrationProvider`, `RapportContextService`) ; REP-PRF-009/015/019 ajoutés à l'enum ; 023 conforme par zone (UEMOA/CEMAC/RDC) ; horaires envoie REP_PRF_006. Vérifié par PDF réel (IFOD, CDF, sans XOF/Dakar).
- [FIXED] Schémas épargne/client/caisse RDC/PCCI : comptes 6 chiffres du plan, plus de DEMO-SCH, mode MANUELLE affiché ; test `PcciSchemasComptablesModulesTest`.
- [FIXED] Workflow : approbateurs par groupe (`PreferenceRestClient`), définitions éditées non écrasées (`declared_signature`), GET /definitions/{id} pour participants, montant PAIE, annulation d'instance à la suppression RH, `StatutConstraintFixer`, matrice des pouvoirs (route lecture seule), dashboard filtré par rôle, route unauthorized, modales groupe/utilisateur.
- [FIXED] Paie : doublon rubrique 409, libellés HS neutres, nombres fr, flashs « Aucune donnée », XOF résiduel.
- [FIXED] UI RH/compta/XOF en dur (caisse, épargne, suivi-éval) : voir rapport de session.
- [FIXED] sfd-paie-service redémarré, 3 types PAIE disponibles ; lib activity-tracking 1.0.2 réinstallée localement (non publiée).
- [OPEN] Garde changement devise principale (écritures existantes) ; SMIG vs salaireMinLegal ; double toast sanctions ; dashboard compta 400 1er appel ; apostrophe sélecteur de rôles (serveur sécurité) ; page rapport « Hiérarchie des agences » sans rapport backend ; DEMO-SCH-* restent dans caisse UEMOA/CEMAC/SYSCOHADA ; matrice des pouvoirs : édition non faite ; suppression frais de mission n'annule pas l'instance ; définitions workflow en version >1 figées vs modèles modules (reset manuel).
- [FIXED + VERIFIED 2026-10-06] Workflow : ré-inscription d'un module n'écrase plus une définition éditée (`declared_signature`, `WorkflowDefinitionServiceImpl`, tests `WorkflowDefinitionRegisterTest`). Preuve : étape 1 de RH_DEMANDE_ABSENCE renommée par PUT, `restart_service.sh sfd-rh-service`, registrar rejoué (23:59:20), édition conservée, version inchangée ; libellé restauré ensuite.

## Vérif portail/WF 2026-10-06
- [FIXED] Portail : photo employé cassée (relais /media), clé i18n SEXE_FEMININ brute.
- [FIXED] Workflow : KPI « tâches en retard » ignorait le SLA ; notification de rejet sans nom d'étape.
- [FIXED] Agora : documents d'un dossier RESTREINT lisibles/téléchargeables par tout authentifié (ACL dossier ignorée si document PUBLIC) ; 500 → 404 sur ressource absente.
- [FIXED] Page Institution : sous-titre « Description ».
- [OPEN] PDF bulletin de paie : pas de devise, montants non formatés, agence « — » (sfd-paie-service).
- [OPEN] Portail : si RH est indisponible, profil/dashboard renvoient des champs vides sans erreur (RhRestClient avale l'exception) ; l'API bulletin expose `contexteCalcul` et `detailCalcul` (détails internes de calcul) à l'employé.
- [OPEN] Notifications workflow en double (même événement REJET affiché 2 fois pour admin) ; notifications non lues = 92 (accumulation).
- [OPEN] Dashboard ERP : 500 console pour les health-checks des modules non démarrés en local (bruit).
- [OPEN] Une session portail est invalidée quand le même compte se reconnecte ailleurs (observé pendant les tests concurrents) ; les agents concurrents sur le même navigateur se déconnectent mutuellement.
- [NOTE] Non vérifié faute de capture (volet navigateur masqué) : responsive mobile, nouvelle demande/annulation/complétion/approbation via UI, escalade SLA.

## Session suite 2026-10-05/06 (saisie par l'UI, corrections)
- [FIXED] RH : doublon d'employé accepté (même pièce / CNSS / e-mails) → contrôle d'unicité create/update (`EmployeServiceImpl`, 4 requêtes `existsBy…IdNot`), test.
- [FIXED] RH : « Appliquer » une promotion/mutation ne changeait que le statut → report salaire/poste/département/catégorie/échelon (promotion) et poste/département/agence via Préférence (mutation) sur le dossier ; statut VALIDEE exigé ; demandes appliquées à vide avant correctif (promo IFOD-0011/0014, mutations IFOD-0011/0012) réparées par UPDATE SQL ciblés avec l'accord de l'utilisateur (2026-10-06).
- [FIXED] Angular promotion-edition : employé hors liste du store non retrouvé (ancien salaire 0, matricule vide) → lecture par id (`EmployeService.getById`).
- [FIXED] RH : libellés département/agence vides sur les dossiers créés par l'UI (portail « Département — ») → `EmployeLibelleCompleter` + reprise au démarrage.
- [FIXED] RH : corps JSON invalide (enum inconnue) → 500 ; maintenant 400 (`RhExceptionHandler`).
- [FIXED] Angular évaluations : type 360° envoyait `360` au lieu de `EVALUATION_360` (500 à la création).
- [FIXED] RH : collecte 360° créait des évaluateurs sans nom/prénom/poste ni source → noms renseignés, source MANAGER (supérieur) sinon PAIR.
- [FIXED] Paie : filtre année des périodes (string vs nombre → liste vide), libellé « 10 2025 » (mois non numérique).
- [FIXED] Paie : bulletins générés pour des employés embauchés après la période (backend ignore + UI n'envoie plus) ; compteur « Erreurs » faussé.
- [FIXED] Paie : barème/cotisations avec date d'effet 01/01/2026 → périodes 2025 sans cotisation (« paie.bareme.notfound ») ; saisie IFOD_RDC avec effet 01/01/2025.
- [FIXED] Intégration (sfd-integration-api) : `AgenceHeaderInterceptor` écrasait l'en-tête agence explicite par celui de la requête entrante → paiements des salaires des agences ≠ agence connectée refusés (« journée non ouverte ») ; jar réinstallé, test.
- [FIXED] Paie portail : liste des bulletins en 500 (LazyInitializationException) et bulletins non publiés visibles → transaction + statuts publiés (VALIDE/COMPTABILISE/PAYE) seulement.
- [FIXED] Workflow/portail : tri `sort=` + méthode `OrderBy…` = colonne dupliquée sous SQL Server (mes-demandes, notifications) → tri retiré du Pageable.
- [FIXED] Portail : profil affichait des données fictives (« Koffi Adodo ») quand le 360° RH n'avait que `nomComplet` → fusion profil + 360°, plus jamais de données de démo ; dates d'embauche décalées d'un jour (UTC) ; champ « Employé » unique présélectionné.
- [FIXED] Éditeur de processus workflow : « Listes de valeurs autorisées » (portail) affichait des options vides → `bindLabel/bindValue` ; portail.lookups `employes` par défaut pour congé/absence/mission/heures sup (403 sur le sélecteur sinon).
- [FIXED] Agora : contenu existant jamais indexé dans Meilisearch → réindexation au démarrage (`MeilisearchReindexRunner`) ; recherche validée (8/6/6 résultats).
- [FIXED] Specs : cookie `lang` perdu après purge de session (UI en anglais) ; moniteur ignore `chat/me`.
- [OPEN] Portail : aucun écran/endpoint d'administration des accès employés (ni inscription) → comptes provisionnés par variables d'environnement (`portail_comptes_env.sh`).
- [OPEN] Paie : paiement en ESPÈCES non supporté (IFOD-0013 passé en mobile money) ; champ legacy `mode_paiement` non resynchronisé quand la domiciliation change.
- [OPEN] Paie : un seul compte mobile money ACTIF par agence autorisé (sinon « aucun compte ») : Orange Money conservé, M-Pesa/Airtel désactivés ; l'opérateur de l'employé n'est pas pris en compte.
- [OPEN] Paie : historique recalculé sur le salaire courant (promotions appliquées visibles sur les mois passés) ; pas de prorata du premier mois pour une embauche en cours de mois.
- [OPEN] Évaluation 360° : aucun écran évaluateur pour saisir son retour (statut EN_COURS atteignable mais pas par un compte évaluateur) ; plus d'un lancement de collecte duplique les évaluateurs.
- [OPEN] Workflow : trace d'audit technique impossible (« nesting depth 1001 », cycle `WorkflowInstance.actions` ↔ `WorkflowAction.instance`) ; bruit ERROR « utilisateur introuvable (404) » pour chaque employé du portail (non utilisateur ERP).
- [OPEN] Paie PDF bulletin : solde congés indisponible (401 de RH vers `/conges/solde-bulletin` avec le jeton portail).
- [OPEN] Avatars (photoUrl `public/media?url=…`) cassés dans le portail ; en-tête « Employe » sans accent dans l'éditeur d'évaluation ; agence connectée par défaut = Goma au login admin.
- [OPEN] Une demande portail d'avance/congé dure ~5 à 35 s (appels workflow→module séquentiels) : le bouton reste sans retour visuel.

## Chaîne bulletin (verif-bulletin, 2026-10-06) — détail dans VERIF_BULLETIN.md
- [FIXED] Paie : détail bulletin (total retenues, lignes à 0, boutons workflow, historique, libellé IPR, jours), édition (PUT 400, éléments variables, recalcul, mode écrasé), PDF (devise CDF, séparateurs fr, agence, libellés, mention légale), dashboard (période courante, données réelles), REP-PAIE-007 (pension) / 011 (année), éléments variables créés inactifs, portail sans `contexteCalcul`/`detailCalcul`, RH indisponible = calcul interrompu.
- [OPEN] sfd-report-api : période des PDF de rapport en ISO (« Du 2026-09-01 au 2026-09-30 ») et nom de fichier `..pdf`.
- [OPEN] PDF bulletin : 2 pages quand le solde de congés est présent ; solde congés absent via le portail (401).
- [OPEN] IPR avec décimales (arrondi à définir) ; département vide sur les bulletins antérieurs au correctif RH (recalcul nécessaire) ; KPI « Validés / Payés » de la liste ne compte pas les PAYE dans « validés » ; flash « Aucune période ouverte » à la génération.

## Vérification RH 2026-10-06 (VERIF_RH.md)
- [FIXED] Évaluation 360 : collecte jamais en statut COLLECTE_360, retours impossibles (doublon), note globale/agrégation/anonymat absents, brouillon réinitialisait la collecte, i18n brute ; `EvaluationServiceImpl`, `Feedback360Mapper`, UI feedbacks + tests.
- [FIXED] Candidature/entretien/offre/contrat/congé : validations métier manquantes (offre publiée, doublon, créneau, cohérence contrat, chevauchement congé).
- [FIXED] Solde de congé en dur (30 j/an) -> droit RDC paramétrable ; congés VALIDE_N2 ignorés par rapports/KPI.
- [FIXED] PDF REP_RH_013 et REP_RH_022 : entités JPA dumpées en colonnes brutes.
- [OPEN] 3 invitations 360 héritées (sans nom/source) sur l'évaluation id 6 : suppression non autorisée ici.
- [OPEN] Autres rapports RH à vérifier pour le même défaut (entités brutes) ; erreur console sidebar intermittente `activateParentDropdown`.
- [OPEN] Parcours congé workflow, pointage/retards/heures sup, jours fériés RDC, carrière (Appliquer) non rejoués ce tour.


## Organigramme / compétences / carrière / évaluation / annuaire (2026-10-06)
- [FIXED] Annuaire : 1 employé sur 25 visible (`actif` forcé à false par le DTO à la création/modification) ; filtre sur le statut (≠ SORTI) + rattrapage au démarrage ; photo jamais renvoyée (colonne `photoUrl` vide) → `photo` relative résolue côté Angular.
- [FIXED] Photos absentes des listes (employés, évaluations, congés, absences, missions, heures sup., pointages, tableaux de bord, organigramme, annuaire) : composant `app-employe-avatar` (photo ou initiales) alimenté par l'annuaire ; retour anonyme 360° sans photo.
- [FIXED] Organigramme : membres/responsable absents (nom null → erreur d'affichage), pas de vue hiérarchique réelle (superieurId) → vue « Hiérarchie » + `/organigramme/hierarchie`, membres = employés du département, niveau calculé, responsable saisissable.
- [FIXED] Compétences d'employés : contrat front/back incohérent (niveau, libellés), modal de déclaration jamais branchée → accessible depuis la fiche employé (déclaration + validation RH) ; exigences par poste créées « inactives » donc invisibles + écran inaccessible (lien ajouté dans la liste des postes).
- [FIXED] Plans de carrière : étapes jamais enregistrées, libellés/identité absents, route d'édition inexistante, bouton « Atteint » qui abandonnait le plan, statuts d'étape incohérents.
- [FIXED] Historique de carrière : écran autonome jamais chargé (400 sans matricule), page non lue comme tableau ; événement « Entrée » absent (créé à l'embauche + rattrapage) ; i18n des types.
- [FIXED] Évaluation : objectifs non contrôlés → poids = 100 %, chaque objectif évalué avant soumission/validation ; note pondérée serveur ; résultats reportés sur le référentiel à la validation ; poids cumulé ≤ 100 % par employé/exercice côté objectifs.
- [FIXED] Sidebar : erreur console `activateParentDropdown` (déréférencement null) sur certaines routes ; i18n : `RH.TYPE_EVAL_EVALUATION_360`, `RH.CATEGORIE_OBJ_*`, types de mission/planning/congé/préavis, `LABELS.PHOTO_*`, étapes/statuts de plan.
- [OPEN] Organigramme : pas d'écran pour rattacher explicitement un employé à une unité (membres = employés du département) ; unités d'agence sans employés propres (les employés d'agence dépendent des départements fonctionnels).
- [OPEN] Plan de carrière : pas d'écran pour faire avancer le statut d'une étape ; note globale d'évaluation = moyenne des 4 notes de catégorie (arrondies), non pondérée par les objectifs.

## Compta — rejets de déversement concurrents (VPS, 2026-10-06)
- [OPEN][TODO] `LignesComptablesConsumer` / `DeversementServiceImpl` : plusieurs salaires payés en parallèle rejettent des écritures (`ObjectOptimisticLockingFailureException` sur `EcritureEnAttenteContrepartie`, et `LIGNES_NON_TROUVEES` = course sur le buffer de lignes) ; aucun retry, l'exception publie `ECRITURE_REJETEE`. Contournement dev : `app.rabbitmq.listener.lignes.concurrency/max-concurrency = 1` (application-dev.yml, 2/5 par défaut). **Vrai correctif** : retry sur `ObjectOptimisticLockingFailureException` et sur la course `LIGNES_NON_TROUVEES` (requeue/backoff) dans `DeversementServiceImpl` / `LignesComptablesConsumer`.
- [FIXED] `sfd-agora-service/application.yml` : les blocs `preference` et `notification` étaient sous `meilisearch:` (jamais lus comme `app.preference` / `app.notification`) → remontés sous `app:` ; URLs dev vers `sfd-*-dev`.
