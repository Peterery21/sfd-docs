# Analyse fonctionnelle : localisation Odoo et fonctionnalités manquantes dans EDIP

Date : 2026-10-12. Complète [COMPARATIF_EDIP_ODOO.md](COMPARATIF_EDIP_ODOO.md).

**Fiabilité**
- **EDIP** : vérifié dans le code (grep et lecture des enums). Nouveaux constats de cette session : les canaux e-mail, SMS, push et in-app **existent** (`CanalNotification`, lib `notification-api`, `ClientNotificationSenderService`, `WorkflowNotificationGateway`, `AgoraNotifier`). La comptabilité générale est complète (40 types de rapports, grand livre, balances, lettrage, clôtures). Non vérifié : le fournisseur SMS réellement branché en production.
- **Odoo** : connaissance générale des versions 17/18, sans vérification en ligne. La liste exacte des modules `l10n_*` par pays, leur édition (Community ou Enterprise) et les fonctions de e-facturation sont à recontrôler sur la documentation officielle.

---

## 1. La fonctionnalité « Localisation » d'Odoo

### 1.1 Définition

Une **localisation** (modules préfixés `l10n_<pays>`) adapte Odoo aux règles légales, fiscales et administratives d'un pays. Odoo l'applique à la création de la société : à la première installation de la comptabilité, le pays choisi déclenche l'installation du « paquet fiscal » correspondant. Une même base peut avoir plusieurs sociétés avec des localisations différentes.

### 1.2 Contenu d'un paquet de localisation

| Composant | Rôle | Exemple |
|---|---|---|
| **Plan comptable modèle** | Comptes pré-créés selon le référentiel national, avec types de compte et groupes | OHADA/SYSCOHADA, PCG français |
| **Taxes** | Taux de TVA et autres taxes, base de calcul, compte de collecte et de déduction, taxe incluse ou non dans le prix | TVA 18 %, retenue à la source |
| **Positions fiscales** | Règles qui remplacent taxes et comptes selon le client ou fournisseur (export, intracommunautaire, exonéré) | Client hors zone → TVA 0 % |
| **Rapports fiscaux** | Déclaration de TVA pré-remplie à partir des écritures (cases du formulaire officiel) | Déclaration mensuelle de TVA |
| **Journaux et conditions de paiement** | Journaux par défaut, délais de règlement usuels | 30 jours fin de mois |
| **États légaux** | Bilan, compte de résultat, liasse, fichiers d'audit normalisés | FEC (France), SAF-T (Norvège, Portugal…), DATEV (Allemagne) |
| **Facturation électronique** | Génération et transmission de factures aux formats exigés | UBL / Peppol, Factur-X, CFDI (Mexique), SDI (Italie), ZATCA (Arabie saoudite) |
| **Données partenaires** | Validation des identifiants fiscaux, formats d'adresse, villes et régions, banques du pays | Vérification du n° de TVA (VIES), codes postaux |
| **Formats de paiement** | Fichiers bancaires normalisés | SEPA, ISO 20022 |
| **Devise et calendrier** | Devise par défaut, jours fériés, exercice fiscal | — |
| **Paie** (Enterprise) | Structures salariales, cotisations, barèmes, déclarations sociales, fiches de paie | France (DSN), Belgique, Inde… |
| **Point de vente** | Conformité des tickets, imprimantes fiscales dans certains pays | — |

### 1.3 Mécanique technique

1. Le paquet est un module (`l10n_xx`) qui déclare un **modèle de plan comptable** (`account.chart.template`) chargé depuis des fichiers de données (CSV/XML).
2. À la création de la société, Odoo **instancie** ce modèle : comptes, taxes, positions fiscales, journaux.
3. Les modules additionnels (`l10n_xx_reports`, `l10n_xx_edi`, `l10n_xx_hr_payroll`) ajoutent rapports, e-facturation et paie. Beaucoup sont **Enterprise**.
4. L'utilisateur peut ensuite modifier ce qui a été instancié (la localisation n'est pas verrouillée).

### 1.4 Couverture de la zone d'EDIP (à vérifier)

- Odoo propose une base **OHADA/SYSCOHADA** et, selon la version, des modules pour certains pays de la zone (Cameroun, Côte d'Ivoire, Sénégal, etc.).
- Il n'a **pas de plan comptable SFD** (RCS-SFD, COBAC, GCEC, PCCI) ni de rapports réglementaires BCEAO/BEAC.
- Je n'ai pas de certitude sur l'existence d'une **paie** standard pour ces pays : à confirmer avant d'en faire un argument.

### 1.5 Équivalent actuel dans EDIP

| Élément de localisation | Ce qu'EDIP a déjà | Écart |
|---|---|---|
| Plan comptable par norme | YAML par zone : CEMAC (COBAC, SYCEBNL, SYSCOHADA), RDC (GCEC, PCCI, SYSCOHADA), UEMOA (RCS-SFD, SYCEBNL, SYSCOHADA) ; import Excel ; `AccountingNormMatrix` zone → norme | Pas de modèle « instanciable » modifiable par pays dans l'interface |
| Setup par pays | 7 configurations (Togo, Sénégal, Mali, Burkina, Côte d'Ivoire, Cameroun, RDC) dans `sfd-commun-service/resources/setup-configs` | Pas de gestion de version du paquet |
| États légaux | Bilan, résultat, liasse SYSCOHADA, ratios prudentiels, rapports BCEAO/BEAC (~193 codes par zone) | **Plus complet qu'Odoo sur le secteur financier** ; TER SYCEBNL en TODO |
| Taxes | Taux de TVA porté sur les lignes commerciales (champ `tauxTva`, 64 occurrences) | **Pas de moteur fiscal** : pas de table de taxes, positions fiscales, déclaration |
| Paie par pays | Entité `ParamPaysPaie`, barèmes, cotisations (CNSS, CAFAT), IRPP, tranches | Paramétrage par pays à valider au-delà de ceux déjà testés |
| Jours fériés, devises, pays, zones | `JourFerie`, `Devise`, `TauxChange`, `Pays`, `ZoneGeographique`, `calendriers-feries.json` | OK |
| Validation d'identifiants fiscaux | Non vu | Manque |
| E-facturation (factures normalisées) | Non vu | Manque |
| Formats bancaires normalisés | OFX partiel | Manque (CAMT, ISO 20022) |

---

## 2. Fonctionnalités manquantes dans EDIP

**Légende**
- **Priorité** : P1 = bloque une vente ou une conformité ; P2 = renforce l'offre ; P3 = optionnel ou hors cœur de métier.
- **Effort** : S = quelques jours ; M = 1 à 3 semaines ; L = plus d'un mois.
- **Statut** : Absent (rien trouvé dans le code), Partiel (une base existe).
- Les points marqués *(à vérifier)* n'ont pas été confirmés dans le code.

### 2.1 Fiscalité et comptabilité

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| F1 | **Moteur de TVA et taxes** | Table de taxes (taux, base, comptes de collecte et de déduction, taxe incluse ou hors prix), prise en compte automatique sur ventes, achats et frais, calcul de la TVA à décaisser | Partiel : taux porté sur les lignes commerciales, pas de moteur ni de table de taxes | P1 | L |
| F2 | **Positions fiscales** | Substitution automatique de taxes et de comptes selon le tiers (exonéré, export, régime spécial) | Absent | P1 | M |
| F3 | **Déclaration fiscale** | Rapport de TVA pré-rempli selon le formulaire du pays, avec détail des écritures et verrouillage de période | Absent | P1 | M |
| F4 | **Retenues à la source et autres impôts** | Retenue sur prestations, acomptes d'impôt, taxes assimilées | Absent *(à vérifier)* | P2 | M |
| F5 | **Comptabilité analytique** | Plans et axes analytiques, répartition des charges par centre ou projet, rapports analytiques | Partiel : drapeau `analytiqueObligatoire` sur les comptes, catégorie de rapport « analytique » (ratios et analyses de charges/produits), centres de responsabilité côté budget ; **pas d'axes analytiques sur les lignes d'écriture** | P2 | L |
| F6 | **Import de relevés bancaires complet** | Parseurs OFX, CAMT.053, CSV mappable, anti-doublons, création automatique des lignes de rapprochement | Partiel : OFX incomplet, CAMT non trouvé | P2 | M |
| F7 | **Synchronisation bancaire** | Récupération automatique des relevés par agrégateur ou API de banque | Absent | P3 | L |
| F8 | **Règles de rapprochement apprises** | Propositions de rapprochement apprises des choix passés | Partiel (rapprochement automatique par règles) | P3 | M |
| F9 | **Paiements en lot** | Génération de fichiers de virements (SEPA/ISO 20022 ou formats locaux) pour régler plusieurs factures | Absent | P2 | M |
| F10 | **Facturation électronique normalisée** | Facture à numérotation fiscale, signature, transmission à l'administration quand le pays l'exige | Absent | P2 | L |
| F11 | **Validation des identifiants fiscaux** | Contrôle de format et d'existence du NIF/IFU/TVA du tiers | Absent *(à vérifier)* | P3 | S |
| F12 | **Consolidation multi-sociétés** | Consolidation de plusieurs entités juridiques avec éliminations intra-groupe | Absent (multi-agence, pas multi-société) | P2 | L |
| F13 | **Immobilisations : crédit-bail, composants** | Amortissement par composant, location-financement, réévaluation | Absent *(à vérifier)* | P3 | M |

### 2.2 Ventes, achats, relation client

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| V1 | **Règles de prix avancées** | Remises par quantité, par période, par client, formules sur coût, promotions | Partiel : listes de prix et grilles tarifaires | P2 | M |
| V2 | **Abonnements et facturation récurrente** | Contrats, renouvellement, facturation périodique, revenus récurrents | Absent | P2 | L |
| V3 | **Signature électronique** | Devis, contrats et documents RH signés en ligne avec piste d'audit | Absent | P3 | M |
| V4 | **Rapprochement 3 voies** | Commande, réception, facture fournisseur comparées avant paiement | Absent *(à vérifier)* | P2 | M |
| V5 | **Demandes de prix comparatives** | Mise en concurrence de fournisseurs, choix et conversion en commande | Partiel (devis fournisseur) | P3 | S |
| V6 | **Pipeline CRM prédictif** | Scoring de prospects, relances automatiques, prévisions de chiffre d'affaires | Partiel (opportunités, activités, objectifs) | P3 | M |
| V7 | **Marketing de masse** | Campagnes e-mail et SMS à des segments, modèles, suivi d'ouverture et de clics, désabonnement. *Le transactionnel e-mail/SMS/push existe ; ce point couvre uniquement l'envoi en masse piloté par l'utilisateur* | Partiel : canaux et modèles de notification présents, pas de moteur de campagnes ni de segments | P2 | M |
| V8 | **E-commerce et site web** | Catalogue en ligne, panier, paiement, livraison | Absent (le portail client n'est pas une boutique) | P3 | L |
| V9 | **Helpdesk et SLA clients** | Tickets, files d'attente, base de connaissances publique, satisfaction | Absent (Agora et chat ne couvrent pas ce flux) | P2 | M |
| V10 | **Passerelles de paiement en ligne** | Encaissement carte et mobile money sur factures et portail | **Fait (mise à jour 2026-11-13)** : `sfd-paiement-externe-service` sur `develop` (agrégateurs PayGate et CinetPay, écrans mobile money du portail client) et PI-SPI BCEAO (`sfd-paiement-instantane-service`) | P2 | M |

### 2.3 Stock et logistique

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| S1 | **Lots, séries, péremption** | Traçabilité unitaire, dates limites, rappel produit | Partiel : entité `Lot` avec statut, séries et péremption non confirmées | P2 | M |
| S2 | **Valorisation FIFO/LIFO effective** | Couches de coût, valorisation comptable en temps réel | Partiel : enum FIFO/LIFO, seul le CUMP est confirmé | P2 | M |
| S3 | **Réapprovisionnement automatique** | Règles min/max qui génèrent des demandes d'achat ou de transfert | Partiel : alertes de stock, pas de génération de commande | P2 | M |
| S4 | **Codes-barres et scan** | Lecture de codes (réception, picking, inventaire) sur mobile ou lecteur | Absent | P2 | M |
| S5 | **WMS** | Vagues, emplacements, putaway, picking par lot, colisage | Absent | P3 | L |
| S6 | **Transporteurs et expéditions** | Tarifs, étiquettes, suivi de colis | Absent | P3 | M |
| S7 | **Frais d'approche** | Répartition des coûts de transport et douane sur le prix de revient | Absent *(à vérifier)* | P3 | M |
| S8 | **Lien ventes → stock** | Livraison de vente qui décrémente le stock | Non confirmé | P1 | S |
| S9 | **Calcul des écarts d'inventaire** | `calculerEcart` est un stub | Partiel (stub) | P1 | S |

### 2.4 Fabrication, maintenance, qualité

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| M1 | **Nomenclatures et ordres de fabrication** | Composition, gammes, consommation et production, coût de revient | Absent (une composition d'article existe en stock) | P3 | L |
| M2 | **Planification de production** | Charge, ordonnancement, ateliers | Absent | P3 | L |
| M3 | **Maintenance d'équipements** | Préventif, correctif, calendrier, ordres de travail | Absent | P3 | M |
| M4 | **Contrôle qualité** | Points de contrôle, non-conformités | Absent | P3 | M |

### 2.5 RH et paie

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| R1 | **Paie de tous les pays visés** | Paramétrage complet et testé par pays (barèmes, cotisations, déclarations) | Partiel : base `ParamPaysPaie`, validation par pays à confirmer | P1 | L |
| R2 | **Télédéclarations sociales** | Génération des fichiers de déclaration aux organismes | Partiel (rapports CNSS/CAFAT/DIPE) ; transmission électronique non vue | P2 | M |
| R3 | **Prorata et 13e mois** | Calcul automatique à l'entrée, sortie, absence non payée, mois supplémentaire | Partiel : les notes de session indiquent un prorata livré, le scan code n'en trouve que 4 mentions | P2 | M |
| R4 | **Notes de frais** | Saisie mobile des justificatifs, workflow, remboursement | Partiel : frais de mission ; pas de flux général | P2 | M |
| R5 | **Temps facturable** | Feuilles de temps par projet, facturation au temps passé | Absent | P3 | M |
| R6 | **Planning de ressources / shifts** | Affectation de créneaux, remplacement | Partiel (planning RH) | P3 | S |

### 2.6 Plateforme et transverse

| # | Fonctionnalité | Description | Statut EDIP | Priorité | Effort |
|---|---|---|---|---|---|
| P1 | **Webhooks et API publique documentée** | Abonnements à des événements, clés d'API par client, quotas, versionnage | Absent (REST interne + Swagger) | P1 | M |
| P2 | **Personnalisation sans code** | Champs personnalisés, vues et formulaires modifiables, automatismes, états ad hoc | Absent (partiel via formulaires dynamiques du workflow) | P1 | L |
| P3 | **Import/export générique** | Assistant d'import CSV/Excel avec correspondance de colonnes, sur tout objet | Partiel (imports ciblés : plan comptable, budget, balance) | P2 | M |
| P4 | **Vues génériques et tableaux croisés** | Kanban, pivot, graphique, calendrier, Gantt sur tout objet | Absent (écrans sur mesure) | P2 | L |
| P5 | **Tableaux de bord personnalisables** | L'utilisateur compose ses indicateurs | Absent (dashboards fixes) | P2 | M |
| P6 | **GED / Documents** | Espace documentaire, tags, OCR, règles de classement | Partiel : Agora (dossiers, versions, droits, recherche) ; OCR absent | P2 | M |
| P7 | **PWA / mobile web** | Installation, mode hors ligne, notifications web | Absent (Angular sans service worker) ; l'app terrain Flutter couvre le hors ligne côté collecteurs | P2 | M |
| P8 | **Audit trail central** | Historique de toute modification (qui, quoi, quand, avant/après) interrogeable | Partiel : `AuditHelper` par module, lib `audit-api` ; vue centrale non vue | P1 | M |
| P9 | **Gestion des rôles dans l'interface** | Éditeur de rôles/permissions, héritage, simulation d'accès | Non vu dans le dépôt (logique dans la lib externe `security-oauth2`) | P1 | M |
| P10 | **Authentification renforcée** | 2FA, SSO d'entreprise, politique de mot de passe | Partiel : OTP sur les portails, OAuth2 client *(à vérifier côté back-office)* | P1 | M |
| P11 | **Migrations versionnées** | Liquibase/Flyway, rollback, scripts par version | Absent (`ddl-auto: update`) | P1 | M |
| P12 | **Multi-société** | Plusieurs entités légales dans une instance avec comptes et droits distincts | Absent (multi-agence) | P2 | L |
| P13 | **Messagerie interne enrichie** | Canaux, appels, partage de fichiers, mentions | Partiel : service chat mince, stockage des messages non confirmé | P3 | M |
| P14 | **Langues supplémentaires et traduction collaborative** | Traduction des écrans par la communauté, davantage de langues | Partiel : fr, en, lingala | P3 | S |
| P15 | **Sauvegarde/restauration d'instance** | Outil d'export de base, duplication d'environnement, anonymisation | Absent *(à vérifier)* | P2 | M |
| P16 | **Marketplace / extensions** | Catalogue de modules tiers installables | Absent | P3 | L |

### 2.7 Fonctions présentes mais à ne pas confondre avec un manque

À ne pas relister comme absentes : notifications e-mail/SMS/push/in-app, comptabilité générale (journaux, pièces, lettrage, rapprochement, clôtures, états, balances, grand livre), multi-devises, workflow versionné avec SLA et délégation, collaboration Agora, sondages, recherche plein texte, portails client et employé, app terrain hors ligne.

---

## 3. Définition d'une analyse fonctionnelle

### 3.1 Définition

Une **analyse fonctionnelle** décrit **ce que le système doit faire** du point de vue métier, sans fixer comment le coder. Elle traduit un besoin en exigences vérifiables, comprises à la fois par les utilisateurs, le produit et les développeurs. Elle précède la conception technique et sert de base aux tests d'acceptation.

### 3.2 Contenu standard

1. **Contexte et objectifs** : problème, enjeu, résultat attendu.
2. **Périmètre** : ce qui est inclus, ce qui est exclu, hypothèses.
3. **Acteurs et rôles** : qui utilise, avec quels droits.
4. **Cartographie fonctionnelle** : domaines, sous-domaines, fonctions.
5. **Cas d'usage ou user stories** : scénarios, préconditions, déroulement, alternatives, résultat.
6. **Règles de gestion** : calculs, contrôles, états et transitions, formules.
7. **Données** : objets métier, champs, contraintes.
8. **Interfaces** : écrans, rapports, échanges avec d'autres modules ou systèmes.
9. **Exigences non fonctionnelles** : performance, sécurité, audit, disponibilité, traçabilité.
10. **Critères d'acceptation** : conditions vérifiables par test.
11. **Dépendances, risques, priorités** (MoSCoW).
12. **Traçabilité** : lien entre exigence, test et livraison.

### 3.3 Méthode appliquée ici

1. **Inventaire** de l'existant par lecture du code (4 explorations parallèles).
2. **Référentiel de comparaison** : les fonctions d'Odoo (connaissance générale).
3. **Matrice de couverture** : chaque fonction est classée Présent, Partiel ou Absent.
4. **Priorisation** : impact commercial et réglementaire d'abord (P1), puis différenciation (P2), puis le reste (P3).
5. **Spécification** des fonctions P1 ci-dessous, au format utilisable par l'équipe.

---

## 4. Analyse fonctionnelle des fonctions prioritaires

### 4.0 Acteurs communs

| Acteur | Rôle |
|---|---|
| Administrateur institution | Paramètre pays, taxes, comptes, droits |
| Comptable | Saisit, contrôle, déclare |
| Responsable financier | Valide les déclarations, clôtures |
| Gestionnaire commercial / stock | Émet documents, gère articles |
| Intégrateur / partenaire | Utilise l'API et les webhooks |
| Auditeur | Consulte l'historique, ne modifie pas |

### 4.1 Moteur de TVA et déclaration (F1, F2, F3)

**Objectif** : calculer, comptabiliser et déclarer la TVA et les taxes assimilées sans saisie manuelle.

**Périmètre** : modules commercial (ventes et achats), caisse (vente comptoir), comptabilité, immobilisation (achat d'immobilisation), RH (frais). Hors périmètre : e-facturation d'État.

**Données**
- `Taxe` : code, libellé, taux, type (TVA, retenue, autre), sens (collectée / déductible), base (HT ou TTC), compte de collecte, compte de déduction, compte de régularisation, actif, pays.
- `PositionFiscale` : nom, critères (pays, type de tiers, statut fiscal), correspondances `taxe source → taxe cible`, `compte source → compte cible`.
- `RegimeTva` : débits ou encaissements, périodicité de déclaration.
- `DeclarationTva` : période, état (brouillon, validée, déposée), montants par case, écriture de liquidation liée.

**Règles de gestion**
- RG1 : chaque ligne de document reprend les taxes de l'article, après substitution par la position fiscale du tiers.
- RG2 : le montant de TVA se calcule par ligne, arrondi par ligne ou par total selon paramètre.
- RG3 : une taxe sans compte de collecte ou de déduction **bloque** la comptabilisation (cohérent avec la règle EDIP « compte manquant = message, manche non envoyée »).
- RG4 : en régime encaissements, la TVA devient exigible au règlement et non à la facture.
- RG5 : la déclaration regroupe les écritures comptabilisées de la période ; une période déclarée est verrouillée.
- RG6 : la liquidation génère une écriture : TVA collectée − TVA déductible → TVA à payer ou crédit de TVA.
- RG7 : cohérence dual-line : le commercial publie la manche tiers + produit + TVA, la caisse seulement l'encaissement ; la compta pose la pièce quand débit = crédit.

**Cas d'usage principal** : *Déclarer la TVA du mois*
1. Le comptable ouvre « Déclaration TVA » et choisit la période.
2. Le système agrège les écritures et remplit les cases.
3. Le comptable contrôle le détail par case (drill-down vers les pièces).
4. Il valide ; le système génère l'écriture de liquidation et verrouille la période.
5. Il exporte le formulaire (PDF/Excel) pour dépôt.

**Alternatives** : écriture manuelle de régularisation ; déclaration rectificative ; crédit de TVA reporté.

**Critères d'acceptation**
- CA1 : facture de 100 000 HT à 18 % → pièce avec 118 000 client, 100 000 produit, 18 000 TVA collectée.
- CA2 : client exonéré → aucune TVA, compte de produit conforme à la position fiscale.
- CA3 : avoir partiel → TVA proportionnelle, case de déclaration réduite.
- CA4 : période déclarée → toute écriture datée dans cette période est refusée (message explicite).
- CA5 : TVA collectée − déductible = montant de l'écriture de liquidation, au centime.
- CA6 : anti-régression : les tests actuels du commercial restent verts et aucune pièce existante ne change.

**Dépendances** : plan comptable (comptes de TVA), schémas comptables commerciaux, clôtures.
**Risque** : migration des factures existantes qui portent déjà `tauxTva` ; prévoir un script de reprise.

### 4.2 Webhooks et API publique (P1)

**Objectif** : permettre à un système tiers de réagir aux événements d'EDIP et de l'interroger de façon sécurisée.

**Données** : `ClientApi` (nom, clé hachée, périmètres, quotas, actif), `AbonnementWebhook` (URL, événements, secret, actif), `LivraisonWebhook` (événement, charge utile, statut, tentatives, réponse).

**Règles de gestion**
- RG1 : un événement métier (ex. `credit.decaisse`, `facture.validee`) est publié au bus puis transmis aux abonnés.
- RG2 : chaque envoi est signé (HMAC) avec le secret de l'abonné.
- RG3 : échec → nouvelles tentatives à délai croissant, puis file morte consultable et rejouable.
- RG4 : un client d'API ne voit que les agences et modules autorisés (même modèle de droits que l'interface).
- RG5 : quotas par clé ; dépassement → réponse 429.
- RG6 : tout appel est journalisé.

**Cas d'usage** : *Un partenaire reçoit chaque décaissement de crédit*
1. L'administrateur crée une clé d'API et un abonnement `credit.decaisse`.
2. Au décaissement, EDIP envoie la charge utile signée.
3. Le partenaire répond 2xx ; sinon EDIP réessaie.

**Critères d'acceptation**
- CA1 : événement publié → livraison reçue en moins de 5 s en conditions normales.
- CA2 : signature invalide côté récepteur détectable avec le secret.
- CA3 : 3 échecs consécutifs → entrée en file morte, visible et rejouable.
- CA4 : clé révoquée → appels refusés immédiatement.

### 4.3 Audit trail central et gestion des rôles (P8, P9)

**Objectif** : répondre à une question d'auditeur : « qui a fait quoi, quand, avec quel avant/après », et gérer les droits sans passer par la base.

**Règles de gestion**
- RG1 : les opérations de création, modification, suppression, validation, annulation et changement de statut sont journalisées avec utilisateur, agence, horodatage, objet, valeurs avant/après.
- RG2 : le journal est en ajout seul (non modifiable).
- RG3 : consultation filtrable par module, objet, utilisateur, période, avec export.
- RG4 : un rôle regroupe des permissions par module et par action (lecture, écriture, validation, administration) ; il est affecté à un utilisateur par agence.
- RG5 : modification d'un rôle ou d'une affectation → entrée d'audit obligatoire.

**Critères d'acceptation**
- CA1 : modification d'un taux de produit → une entrée avec ancien et nouveau taux.
- CA2 : un auditeur sans droit d'écriture ne peut ni modifier ni supprimer une entrée.
- CA3 : retrait d'un rôle → l'accès disparaît à la prochaine requête.

**Point de départ** : réutiliser `audit-api` et les `AuditHelper` des modules plutôt que créer un nouveau mécanisme.

### 4.4 Migrations versionnées (P11)

**Objectif** : rendre les montées de version prévisibles et réversibles en production.

**Règles de gestion**
- RG1 : tout changement de schéma passe par un script versionné (Liquibase ou Flyway) ; `ddl-auto` passe à `validate` en production.
- RG2 : un script ne s'édite pas après livraison ; on ajoute une nouvelle version.
- RG3 : chaque script est testé sur les trois moteurs visés (PostgreSQL, SQL Server, éventuellement MySQL), conformément à la contrainte « dialecte portable, sans CHECK ».
- RG4 : un script de retour arrière est fourni quand le changement est réversible.

**Critères d'acceptation**
- CA1 : démarrage sur base vide → schéma identique à celui produit par Hibernate aujourd'hui.
- CA2 : démarrage sur une base existante → baseline appliquée sans perte de données.
- CA3 : le test existant de schéma SQL Server (`MssqlSchemaTest`) passe.

**Risque** : la contrainte « Build passing ≠ service starts » (Liquibase absent du pom ignore silencieusement les migrations) est précisément ce que ce chantier doit éliminer.

### 4.5 Complétude stock : lien ventes → stock, écarts d'inventaire (S8, S9)

**Objectif** : fiabiliser les quantités et leur valeur.

**Règles de gestion**
- RG1 : la validation d'un bon de livraison de vente crée un mouvement `SORTIE_VENTE` sur le magasin concerné.
- RG2 : stock insuffisant → blocage ou alerte selon le paramètre de l'article.
- RG3 : écart d'inventaire = quantité comptée − quantité théorique ; l'écart positif génère `REGULARISATION_POSITIVE`, négatif `REGULARISATION_NEGATIVE`, valorisés au coût en vigueur.
- RG4 : l'écart au-dessus d'un seuil passe par le workflow d'approbation avant comptabilisation (`ECART_INVENTAIRE`).

**Critères d'acceptation**
- CA1 : livrer 5 unités sur 20 → stock à 15, mouvement tracé avec document source.
- CA2 : inventaire de 18 pour 20 attendus → écart −2, valorisé, soumis à approbation si au-dessus du seuil.
- CA3 : après approbation, une écriture comptable est publiée (manche stock), jamais avant.

### 4.6 Marketing de masse (V7)

**Objectif** : permettre à une institution d'envoyer un message à un segment de clients (rappel d'échéance, nouveau produit, campagne de collecte) sans développement.

**Données** : `Segment` (critères sur client, épargne, crédit), `Campagne` (canal, modèle, segment, planification, état), `EnvoiCampagne` (destinataire, statut, date, erreur).

**Règles de gestion**
- RG1 : un client sans consentement ou désabonné est exclu.
- RG2 : le coût SMS est estimé avant lancement ; dépassement d'un plafond → validation.
- RG3 : variables de modèle limitées à des champs autorisés ; aucune donnée sensible (solde complet) sans paramètre explicite.
- RG4 : envoi par lots avec reprise sur échec ; statut par destinataire.

**Critères d'acceptation**
- CA1 : segment « crédits en retard de plus de 7 jours » → liste exacte, vérifiable.
- CA2 : désabonné jamais contacté.
- CA3 : rapport d'envoi : envoyés / échoués / désabonnés.

**Dépendance** : réutiliser `notification-api` et `CanalNotification` (déjà en place).

---

## 5. Plan de comblement proposé

| Lot | Contenu | Pourquoi d'abord |
|---|---|---|
| **L1 Conformité** | F1-F3 (TVA, positions fiscales, déclaration), P11 (migrations), P8-P9 (audit et rôles) | Bloquants pour une vente hors secteur financier et pour la production |
| **L2 Fiabilité métier** | S8-S9 (stock), R1 (paie par pays), F6 (import bancaire), P10 (2FA / SSO) | Corrige des stubs et risques connus |
| **L3 Ouverture** | P1 (webhooks, API), P3 (import générique), V10 (paiements en ligne) | Permet l'intégration avec Odoo ou d'autres outils |
| **L4 Différenciation** | F5 (analytique), V7 (campagnes), P7 (PWA), P5 (tableaux de bord), V9 (helpdesk) | Renforce l'offre |
| **L5 Extension** | Fabrication, WMS, e-commerce, abonnements, consolidation | Seulement si un client le demande ; sinon passer par l'intégration |

**Contrôle de régression pour chaque lot** (règle projet) : tests de la classe touchée, suite complète du service, build Angular, tests E2E du module, passage dans le navigateur interne ; rapport `Baseline → Après | Régressions: 0`.

---

## 6. Questions ouvertes pour validation

1. Quels pays sont visés à court terme ? Cela fixe le périmètre de F1-F3 et R1.
2. ~~Les clients cibles hors SFD (commerce, stock) sont-ils un objectif commercial, ou EDIP reste-t-il sectoriel ?~~ **Tranché le 2026-11-14** : EDIP s'adresse à toute entreprise ; la verticale finance de proximité (IMF, coopératives, tontines) est un ensemble de modules en plus. Les manques de gestion générique (TVA, analytique, CRM, stock) sont donc prioritaires au même titre que le métier SFD.
3. Le fournisseur SMS en production est-il en place ? (non confirmé dans le code)
4. L'e-facturation d'État est-elle exigée dans les pays visés ?
5. Le découvert épargne est-il livré ? (non trouvé par le scan, mentionné dans l'historique git)
