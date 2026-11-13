# Comparatif détaillé EDIP vs Odoo

Date : 2026-11-13 (première version : 2026-10-12).

**Sources et fiabilité**
- **EDIP** : scan statique des ~40 dépôts au 2026-11-13 (entités, contrôleurs, enums, poms, tests, historique git depuis le 2026-10-12). Les nombres d'endpoints sont approximatifs (comptage des annotations de mapping). Rien n'a été exécuté. Ce qui n'a pas été confirmé dans le code est marqué *(à vérifier)*.
- **Odoo** : version 20 (septembre 2026). Sources : [notes de version](https://www.odoo.com/page/release-notes), [blog « Meet Odoo 20 »](https://www.odoo.com/blog/odoo-news-5/meet-odoo-20-2439), [documentation 20.0](https://www.odoo.com/documentation/20.0/), dépôt GitHub `odoo/odoo` branche 20.0. **Non vérifié** : prix officiels en EUR (lus seulement chez des tiers), date exacte de sortie, tarifs Odoo.sh (sources tierces divergentes), détails officiels d'Odoo 20 sur Studio et la comptabilité.
- Ce document compare des **fonctionnalités**, pas des coûts totaux de possession.

---

## 1. Positionnement

| Axe | EDIP | Odoo |
|---|---|---|
| Cible | Institutions de microfinance (SFD), coopératives, tontines, plus gestion interne (RH, paie, stock, commercial) | PME et ETI de tous secteurs |
| Cœur métier | Épargne, crédit, caisse, collecte terrain, comptabilité SFD | Ventes, achats, stock, fabrication, comptabilité générale |
| Zones couvertes | UEMOA (BCEAO), CEMAC (BEAC), RDC ; données de démo pour 10 pays (TG, SN, CI, BJ, BF, ML, NE, GW, CD, CM) | Mondial. En Afrique : 13 modules `l10n_*` en 20.0 (`syscohada`, `sn`, `ci`, `cm`, `bj`, `bf`, `tg`, `cd`, `ml`, `ne`, `ga`, `ma`, `ke`), qui apportent **le plan comptable SYSCOHADA et les taxes seulement**. Paie officielle en Afrique : Égypte, Kenya, Maroc ([doc](https://www.odoo.com/documentation/20.0/applications/hr/payroll/payroll_localizations.html)), **aucune pour UEMOA, CEMAC ou RDC**. Pas d'e-facturation FNE (Côte d'Ivoire) ni Sénégal trouvée |
| Licence | Propriétaire. `sfd-licence-service` : fichier de licence signé (Ed25519), activation par module, plafonds d'agences et d'utilisateurs, mode démo, passage en lecture seule à l'expiration | Community (LGPL) gratuite. Enterprise, par utilisateur et par mois en facturation annuelle : One App Free 0 €, Standard 24,90 €, Custom 44,90 € (Studio, multi-société, API externe, IA agentique) — trois sources tierces concordantes, page officielle non lue en EUR |
| Écosystème | Aucun, tout est interne | Marketplace de milliers d'apps, réseau de partenaires ; aucun vertical microfinance officiel (seul le module OCA `account_loan`, qui gère des emprunts, pas une IMF) |

---

## 2. Architecture technique

| | EDIP | Odoo |
|---|---|---|
| Langage / framework | Java 21, Spring Boot 3.5 | Python, framework Odoo (ORM maison) |
| Style | ~40 dépôts : microservices + `sfd-erp-monolith`, un seul JAR qui embarque aussi licence, paiements, Projets et Support. Image Docker multi-architecture (amd64/arm64), secrets Docker, sauvegarde activée par défaut (`pg_dump`, `mariadb-dump`). Nouveaux depuis octobre : `licence`, `import-api`, `paiement-instantane` (PI-SPI), `paiement-externe`, `support`, `portail-support`, `projets`, `report-api`, `demo-data` | Monolithe modulaire |
| Frontend web | Angular 19, NgRx, ngx-translate (fr/en/lingala), template Velzon ; 32 domaines fonctionnels, 1 353 composants | OWL (JS maison) + QWeb |
| Mobile | App Flutter agent (collecte, adhésion terrain, journal hors-ligne, QR de configuration signé) ; portails client et employé Flutter | App mobile Odoo ; **Odoo 20 : mode hors-ligne complet** (consultation, création, édition, synchronisation au retour du réseau) |
| Base | PostgreSQL ou SQL Server (Hibernate `ddl-auto: update`) ; MySQL annoncé portable *(à vérifier)* | PostgreSQL uniquement |
| Migrations schéma | Liquibase dans 3 services seulement (RH, budget, workflow) ; `ddl-auto: update` ailleurs | Migrations gérées par l'ORM et les scripts de module |
| Authentification | Lib `security-oauth2` + **SSO Keycloak** paramétrable en base (rechargement à chaud, correspondance groupes Keycloak → rôles EDIP) ; pas de 2FA sur le back-office | Utilisateurs Odoo, 2FA TOTP natif, OAuth *(connaissance générale, non revérifié en 20.0)* |
| Messagerie | RabbitMQ, exchanges `sfd.operations`, `sfd.saga`, `sfd.comptabilite`, files + DLQ par service | Appels ORM synchrones, crons ; pas de bus natif |
| Saga / compensation | Oui (`SagaOperation`, queues `.compensations`) | Non (transaction DB unique) |
| Recherche plein texte | Meilisearch (Agora) | Recherche SQL, pas de moteur dédié |
| Stockage fichiers | MinIO dans la stack Docker | Filestore disque / attachments |
| API | REST par service, Swagger/OpenAPI (springdoc) ; lib `sfd-integration-api` (clients REST) ; pas d'API publique à clés | JSON-RPC / XML-RPC, API externe en Custom ; Odoo 20 : accès externe pour outils IA respectant les droits (« serveur MCP natif » selon [un tiers](https://muchconsulting.com/blog/odoo-2/odoo-20-186)) |
| Webhooks | Sortants signés dans PI-SPI ; webhook entrant de notifications client ; pas de mécanisme générique | Actions automatisées / webhooks (Studio, Enterprise) |
| CI/CD | Jenkins (shared library java + angular), Sonar, Docker, VPS ; installeur par scripts | Odoo.sh (Enterprise) ou pipeline libre |
| Qualité | ~2 000 classes de test (compta 228, épargne 200, RH 200, crédit 177, client 153), 412 specs Playwright | Tests par module, qualité variable selon les apps tierces |
| IA | Aucune | Odoo 20 : agents IA décrits en langage naturel, assistant comptable qui audite les rapprochements, OCR des factures fournisseurs (crédits IAP) ([blog officiel](https://www.odoo.com/blog/odoo-news-5/meet-odoo-20-2439)) |

**Lecture** : EDIP est taillé pour la charge transactionnelle financière (saga, files, multi-SGBD) et s'est industrialisé en un mois (licence, installeur, sauvegarde, image multi-arch). Odoo est taillé pour la rapidité de livraison et l'intégration native ; avec la version 20, il prend de l'avance sur l'IA et le hors-ligne.

---

## 3. Domaine par domaine

### 3.1 Clients / membres

| Fonction | EDIP | Odoo |
|---|---|---|
| Fiche client | `Client` : types PARTICULIER, PROFESSIONNEL, GROUPE, INSTITUTIONNEL, MEMBRE ; segments, niveau de risque | `res.partner` (contact/société) |
| Cycle de vie | PROSPECT, EN_COURS_ADHESION, EN_ATTENTE_PAIEMENT, ACTIF, DORMANT, SUSPENDU, PARTI, RADIE, DECEDE | Pas de cycle de membre ; étapes CRM seulement |
| KYC | Statuts VALIDE, EN_ATTENTE, EXPIRE, REJETE, INCOMPLET ; vérification d'identité, config de validation | Absent (modules tiers) |
| Groupes | TONTINE, GIE, COOPERATIVE, ASSOCIATION, GIC ; rôles de membre | Contacts liés, sans notion de groupe financier |
| Bénéficiaires, procurations | Oui (client et épargne) | Non |
| Parts sociales et dividendes | Souscription, augmentation, retrait, distribution de dividendes | Non (ou développement spécifique) |
| Frais d'adhésion | Types, configuration, paiement avec reçu | Via produits/factures, pas de logique d'adhésion |
| Liste noire | Oui | Non natif |
| Départ, décès, transfert d'agence | Dossiers dédiés | Non |
| Cartes client | Oui | Non |
| Alertes qualité de données | Oui | Non natif |
| Notifications abonnées avec frais | Oui (e-mail, SMS, push, in-app) | Non |
| Rapports / PDF | `ClientRapportController`, fiche client PDF, reçus PDF, Jasper | Rapports QWeb, tableaux croisés |
| Billetage | Parts sociales et frais d'adhésion envoyés à la caisse avec le détail des coupures (obligatoire ou non selon la caisse) | Non |
| Charges et crédits externes | Saisis sur la fiche client | Non |

Volume EDIP : ~351 endpoints, 153 classes de test. Nouveau depuis octobre : option « Validation KYC requise » (l'approbation n'active le client que si les frais d'ouverture sont payés), parts sociales obligatoires et blocage.

### 3.2 Épargne

| Fonction | EDIP | Odoo |
|---|---|---|
| Produits | DAV (vue), DAT (terme), PLANIFIEE, TONTINE, CAUTION | Aucun équivalent |
| DAT | Renouvellement, avenant, retrait anticipé, capitalisation, échéancier d'intérêts, historique | Non |
| Intérêts | Taux progressifs par tranches, calcul unitaire et batch, simulateur | Non |
| Frais de tenue de compte | Oui, tranches de frais | Non |
| Dormance | Config avec actions AUCUNE, NOTIFIER, SUSPENDRE, BLOQUER, GELER | Non |
| Blocage | Partiel ou complet | Non |
| Seuils et limites | Par type d'opération | Non |
| Niveaux de validation | CAISSIER, SUPERVISEUR, DIRECTEUR_AGENCE… | Règles d'approbation génériques (Enterprise) |
| Ordres permanents, versements planifiés | Oui | Non |
| Tontine | Comptes, cycles, participants, opérations, alertes, échéancier de cycle | Non |
| Collecte terrain | Agents, tournées, carnets de reçus, fiche de collecte journalière, dépôt/répartition collecteur, commissions, primes, rémunération | Non |
| Découvert | **Livré** : autorisation de découvert, plafond, contrôle des limites du produit | Non |
| Tontine (nouveau) | Frais PAR_TOUR avec payeur paramétrable, endpoint de cagnotte nette | Non |
| Opérations | ~33 types (dépôt, retrait, virements, intérêts, DAT, tontine, crédit…) | Non |
| Relevé de compte | Jasper `releve-compte.jrxml`, reçus, documents DAT | Non |

Volume EDIP : ~517 endpoints, 200 classes de test (module le plus gros). Les frais sont désormais portés dans la pièce comptable de l'opération ; le billetage part vers la caisse selon le paramètre de la caisse.

### 3.3 Crédit

| Fonction | EDIP | Odoo |
|---|---|---|
| Statuts de dossier | 16 : DEMANDE, EN_INSTRUCTION, EN_ATTENTE_COMITE, APPROUVE, REFUSE, DECAISSE, EN_COURS, EN_RETARD, IMMOBILISE, DOUTEUX, CONTENTIEUX, RESTRUCTURE, SOLDE, PASSE_EN_PERTE, ANNULE, CONSOLIDE | Pas de module prêt natif |
| Simulation | Simulateur Angular et API | Non |
| Instruction | Analyse dossier, vérification de documents, visite terrain | Non |
| Scoring | Grilles, catégories, critères, barèmes, détail de score | Non |
| Comité | Décisions APPROUVE, APPROUVE_AVEC_CONDITIONS, CONTRE_PROPOSITION, AJOURNE, REFUSE | Non |
| Intérêts | DEGRESSIF, CONSTANT, IN_FINE | Non |
| Garanties | Types, évaluations, liaison produit | Non |
| Décaissement | Mode configurable ; virement sur compte épargne | Non |
| Échéancier, paiements | Oui, ordre de remboursement configurable | Échéanciers de paiement de facture seulement |
| Remboursement anticipé | Types et modes de recalcul | Non |
| Pénalités | Types, configuration par produit | Non |
| Restructuration, consolidation | Oui, avec documents | Non |
| Classification du risque | SAIN, SENSIBLE, DOUTEUX, LITIGIEUX, COMPROMIS ; **provisions réglementaires G1 à G6** par norme (catégories de garanties, calculateur, dotation, transfert entre classes, endpoint de reporting) | Non |
| Décaissement externe (nouveau) | Via **PI-SPI** : mobile money ou virement externe ; demandes de paiement des échéances à J-3 | Non |
| Retenue sur salaire (nouveau) | Intégration avec la paie | Non |
| Recouvrement | Relances, dossier contentieux, étapes | Relances client (facturation) seulement |
| Prélèvement automatique | Rapport journalier et lignes | Prélèvement SEPA (Enterprise), logique différente |
| Bailleurs / sources de financement | Oui | Non |
| Validation | Processus `CREDIT_DEMANDE` via le moteur de workflow | Approbations génériques |
| Schéma comptable | `schema-comptable-systeme.yml` | Non applicable |

Volume EDIP : ~321 endpoints, 177 classes de test. Nouveau : remboursement par prélèvement depuis le portail, critères de scoring système, contrôle KYC et parts sociales à la demande de crédit (RG-CR-001). Côté Odoo, seul le module OCA `account_loan` gère des emprunts de l'entreprise, pas un portefeuille de crédits clients.

### 3.4 Caisse et collecte mobile

| Fonction | EDIP | Odoo |
|---|---|---|
| Types de caisse | COF (coffre), CPR, GUI (guichet), MOB, DAB, CPT | POS : caisses de point de vente |
| Sessions | OUVERTE, EN_CLOTURE, CLOTUREE, VALIDEE, SUSPENDUE, ANNULEE | Sessions POS (ouverte/fermée) |
| Billetage | Coupures, détail par session ; **obligatoire par caisse** sur toutes les opérations (épargne, client, commercial, immobilisations) ; coupures XOF, XAF, CDF, EUR, USD | Comptage de caisse basique (POS) |
| Multi-devises | Comptes devise par caisse, taux, opérations de change | Multi-devises comptable ; POS multi-devises limité |
| Opérations | 18 types : approvisionnement, délestage, change, versements/retraits banque, dépôt, retrait, salaires, parts sociales, dividendes… | Encaissements de vente |
| Seuils et zones réglementaires | Oui | Non |
| Brouillard de caisse, reçus PDF | Oui | Ticket POS |
| Outils d'admin | Contrôleur d'admin des DLQ RabbitMQ | Non applicable |
| App terrain | Backend mobile : profils COLLECTEUR_TONTINE, AGENT_EPARGNE, AGENT_CREDIT, AGENT_COMPLET ; opérations COLLECTE, DEPOT, RETRAIT, OUVERTURE_COMPTE, NOUVEAU_CLIENT, DEMANDE_CREDIT, REMBOURSEMENT_CREDIT ; **synchronisation offline** | Pas d'équivalent terrain financier ; POS offline possible |

Volume EDIP : caisse ~164 endpoints ; mobile ~66 endpoints, 56 classes de test. Nouveau côté terrain : adhésion avec frais et pièces obligatoires, renouvellement et clôture de tontine, rapport d'opérations PDF/Excel/CSV, QR de configuration signé. Une seule app agent : le dépôt `sfd-agent-mobile-flutter`. Le dossier `sfd-mobile/sfd-agent-mobile` est un ancien clone local du même dépôt GitHub (même historique, 13 commits de retard), pas une seconde application.

### 3.5 Transferts d'argent

| Fonction | EDIP | Odoo |
|---|---|---|
| Types | TRF_INT, TRF_AGC, TRF_NAT, TRF_UEM, TRF_OUT, TRF_IN | Aucun |
| Statuts | EN_ATTENTE, PAYE, ANNULE, EXPIRE, REMBOURSE, EN_LITIGE | — |
| Tarification | Grilles à tranches, plafonds, promotions par catégorie de client | — |
| Conformité | Seuils et alertes de conformité (LCB-FT), écran dédié | — |
| Exécution | TRF_NAT et TRF_UEM **exécutés via PI-SPI** ; reçu PDF ; validation préalable par workflow | — |
| Limite | Messages en français uniquement | — |

Volume EDIP : ~74 endpoints, 41 classes de test.

### 3.6 Portails

| | EDIP | Odoo |
|---|---|---|
| Portail client | Auth OTP **envoyé par SMS**, profil, comptes, DAT, tontine, crédit, virements, retrait mobile, **mobile money** (envoi, recharge, historique), RIB en QR, accès PI-SPI conditionné, demandes de documents, notifications ; Angular + Flutter | Portail client (factures, commandes, tickets), pas de compte financier |
| Portail employé | Pointage, bulletins PDF, congés, profil 360, demandes, validations managers, push FCM ; **« Mon départ »** (dossier de sortie avec documents), personnes à charge, thème par institution | Self-service employé (congés, notes de frais, présence) |
| Portail support (nouveau) | Public, sans compte EDIP : inscription avec captcha et consentement, vérification e-mail, demandes, export et suppression RGPD | Portail Helpdesk |

Les écrans mobile money du portail client s'appuient sur `sfd-paiement-externe-service` (code sur `develop`, voir §3.18). Limite EDIP : le portail client contient encore des modules de démonstration du gabarit Velzon dans `store/` (Crypto, Ecommerce, Jobs, APIKey…).

### 3.7 Comptabilité

| Fonction | EDIP | Odoo |
|---|---|---|
| Plan comptable | Par norme : CEMAC (COBAC, SYCEBNL, SYSCOHADA), RDC (GCEC, PCCI, SYSCOHADA), UEMOA (RCS-SFD, SYCEBNL, SYSCOHADA) ; import Excel | Localisations comptables (OHADA disponible) ; pas de plan SFD natif |
| Journaux, pièces | Oui, cycle brouillon → validé → comptabilisé, rejet, annulation, contrepassation | Cycle brouillon → comptabilisé, annulation |
| Alimentation automatique | Consumers RabbitMQ, mécanisme **dual-line** (chaque module publie ses lignes, la pièce naît quand débit = crédit) | Écritures générées par chaque app dans la même transaction |
| Écritures en échec | Liste avec rejeu | Non applicable |
| Lettrage | Automatique, manuel, statistiques | Lettrage, réconciliation automatique (Enterprise : IA) |
| Rapprochement bancaire | Auto + manuel, validation ; import CSV, OFX et **CAMT.053** ; **solde bancaire calculé par compte, distinct du solde comptable**, sous-compte par compte bancaire | Synchronisation bancaire (Enterprise), imports CSV/OFX/CAMT/QIF ; Odoo 20 : assistant IA qui audite les rapprochements |
| Clôtures | Mensuelle et **annuelle en assistant pas à pas**, contrôles, régularisations, à-nouveaux, journée comptable, **réouverture de période** | Verrouillage de période, clôture annuelle |
| Saisie (nouveau) | Saisie guidée, import XLSX, pièces jointes aux pièces (types configurables), montants en numeric(22,4) | Saisie de pièces, OCR des factures fournisseurs (IA) |
| Écart de change et réévaluation | Oui | Oui (gains/pertes de change) |
| Fonds dédiés, mobile money | Oui | Non |
| États financiers | Bilan, bilan SYCEBNL, compte de résultat, ratios prudentiels, liasse SYSCOHADA, **TER SYCEBNL implémenté** (deux commentaires TODO obsolètes restent dans le code) | Bilan, résultat, balance âgée ; liasse OHADA via localisation |
| Balances, grand livre | Générale, par classe, auxiliaire, âgée ; export Excel | Oui |
| TVA | **Toujours aucun moteur** : taux saisi librement sur les lignes commerciales, pas de taxe, position fiscale ni déclaration | Moteur de taxes complet ; taxes SYSCOHADA fournies par les `l10n_*` africains |
| E-facturation | Absente | Aucune pour la Côte d'Ivoire (FNE) ni le Sénégal ; seulement Égypte et Kenya en Afrique *(absence inférée de la liste des modules)* |
| Analytique | **Absente** (aucun axe sur les lignes d'écriture) | Comptabilité analytique + budgets |
| Droits | `ROLE_COMPTABILITE_*` granulaires, rôles de trésorerie avec comptes COBAC et PCCI | Groupes de sécurité |

Volume EDIP : ~302 endpoints, 228 classes de test (module le mieux testé).

### 3.8 Budget, immobilisations, reporting réglementaire

| Fonction | EDIP | Odoo |
|---|---|---|
| Budget | Exercices, lignes, rubriques, centres de responsabilité, engagements avec vérification de disponibilité, virements de crédit, décisions modificatives, alertes de seuil, planification mensuelle M01-M12, scénarios, drivers, import Excel, consolidation, 14 rapports | Budgets analytiques (Community limité, Enterprise plus complet) |
| Immobilisations | Catégories, natures, plans d'amortissement linéaire/dégressif, cession, rebut, vol, sinistre, dépréciation, transfert, photos, sessions d'inventaire physique | Actifs (Enterprise) : linéaire, dégressif, manuel ; pas d'inventaire physique natif |
| Reporting réglementaire | Éditions de rapports BCEAO/BEAC/SYCEBNL (~193 codes par zone UEMOA et CEMAC), moteur de formules, validation, clôture d'édition, PDF et Excel ; **19 indicateurs financiers UEMOA (F01-F15)** par variables nommées, durées résiduelles R2-R5, « ratio sans objet » si dénominateur nul, connecteurs crédit/épargne/RH à la date d'arrêté avec un vrai N-1, provisions UEMOA et RDC selon la norme active | Aucun (états réglementaires SFD absents) |

Budget : nomenclature paramétrée par norme (plus de comptes en dur), fiche d'engagement et consolidation en PDF, vote du budget et alerte de dépassement par workflow. Immobilisations : billetage sur cessions et rebuts, workflow d'acquisition, import du classeur 08.

L'écart sur le reporting réglementaire de banque et microfinance reste le plus fort différenciateur d'EDIP face à Odoo.

### 3.9 Commercial (ventes et achats)

| Fonction | EDIP | Odoo |
|---|---|---|
| Tiers | Catégories, conditions commerciales, contacts, documents | Contacts, listes de prix |
| Ventes | Devis, commande, bon de livraison, facture, avoir, règlement, vente comptoir | Idem, avec abonnements, e-signature, configurateur |
| Achats | Devis fournisseur, commande, facture, avoir, règlement | Demandes de prix, commandes, factures, 3-way matching |
| Prix | Listes de prix, grilles tarifaires ; pas de moteur de règles avancé | Pricelists avec règles, remises, formules |
| Remises | Remise globale, plafond par ligne, workflow d'approbation | Remises, approbations (Enterprise) |
| Acomptes | Facture d'acompte et imputation | Acomptes (down payments) |
| TVA | Montant TVA porté et publié en comptabilité ; moteur fiscal non confirmé | Moteur de taxes complet |
| CRM | Prospects, opportunités (étapes), activités, objectifs, portefeuille, e-mails, dashboard | CRM complet : pipeline, scoring prédictif, automatisation, marketing |
| Balance âgée | Oui | Oui |
| Rapports | 17 codes `REP-COM` | Analyse de ventes, pivot, dashboards |
| Plafond de crédit client | Événement `PLAFOND_DEPASSE` | Limite de crédit (Enterprise) |
| E-commerce, abonnements, location | Non | Natifs |
| Lien ventes → stock | Oui (bon de livraison et vente comptoir créent un bon de sortie) ; **défaut** : la sortie est typée consommation et non vente (`typeSortie` absent de `BonSortieRequest`), donc publiée sur le mauvais compte | Natif (flux de livraison) |
| Règlement fournisseur (nouveau) | Via **PI-SPI** | Paiements par lots SEPA/ISO 20022 selon pays |
| Comptoir (nouveau) | Billetage, ticket 80 mm, remboursement | POS |

Volume EDIP : ~230 endpoints, 85 classes de test. Nouveau : workflow achats (commande, facture fournisseur, avoir de vente), alertes de factures de vente échues.

### 3.10 Stock

| Fonction | EDIP | Odoo |
|---|---|---|
| Référentiels | Articles, familles, catégories, unités, magasins, emplacements | Produits, catégories, unités, entrepôts, emplacements |
| Mouvements | 11 types (entrées achat/retour/transfert/inventaire, sorties conso/vente/transfert/perte/affectation, régularisations) | Mouvements par règles de routage (push/pull) |
| Documents | Bons de réception et de sortie, transferts, inventaire physique | Réceptions, livraisons, transferts internes, inventaires |
| Valorisation | **CUMP seul** : FIFO, LIFO et prix standard sont refusés par le code | Standard, FIFO, coût moyen, avec valorisation comptable automatique |
| Lots / séries | Lots avec statuts, **consommation FIFO des lots** à la sortie, date de péremption ; **pas de numéro de série** | Lots, numéros de série, dates de péremption natifs |
| Affectation au personnel | Dotations, consommation courante, renouvellement, quotas, matériel | Non natif (module tiers) |
| Alertes | Seuils min/max, gravité ; génération automatique | Règles de réapprovisionnement |
| Rapports | 22 codes `REP_STOCK` + 3 tableaux de bord | Rapports de stock, valorisation |
| Compta | RECEPTION_STOCK, SORTIE_STOCK, ECART_INVENTAIRE | Valorisation en temps réel |
| Écart d'inventaire | Calcul réel dans `InventaireServiceImpl` ; la méthode `calculerEcart` d'une implémentation parallèle reste un stub (non appelée par l'API) | Natif |
| Workflows (nouveau) | Sortie, inventaire, transfert, affectation ; PDF unitaires (BR, BS, inventaire, lot, transfert) | Approbations |
| WMS (vagues, colisage, putaway), codes-barres, transporteurs | Non | Natifs ou Enterprise |

Volume EDIP : ~191 endpoints, 80 classes de test. Odoo reste nettement supérieur sur la logistique.

### 3.11 RH

| Fonction | EDIP | Odoo |
|---|---|---|
| Dossier employé, contrats | Employé, contrat avec période d'essai, grille salariale, catégories, postes, départements, organigramme | Employés, contrats, départements, organigramme |
| Congés, absences | Types, soldes, `ImpactPaie` | Congés et absences, allocations |
| Temps | Pointage, planning, créneaux, heures supplémentaires avec taux | Présences, feuilles de temps, planning (Enterprise) |
| Recrutement | Offres, candidatures, étapes, notes | Recrutement (Community), job boards, e-sign |
| Évaluation | Campagnes, critères, objectifs, entretiens, **feedback 360** | Appraisals (Enterprise) |
| Compétences | Matrice, exigences par poste, recommandations de formation | Compétences (limité) |
| Formation | Formations, domaines, inscriptions | e-Learning (autre périmètre), formation RH limitée |
| Carrière | Plans, événements, mutations, promotions | Non |
| Discipline | Sanctions et types | Non |
| Missions | Ordres de mission, frais, barèmes d'indemnité, documents de voyage | Notes de frais |
| Annuaire, portail | Oui | Oui |
| Rapports | 25 codes (effectifs, pyramide des âges, turnover, absentéisme, contrats, formation…) | Rapports standards, pivot |
| Compta RH | `FRAIS_MISSION` défini ; publication comptable non confirmée | Notes de frais comptabilisées |
| Personnalisation (nouveau) | **Champs personnalisés** et **designer de rapports** ; rapports Excel/CSV | Studio (Custom) |

Volume EDIP : ~425 endpoints, 200 classes de test. Nouveau : employé lié à son compte EDIP, jours de congé calculés côté serveur (week-ends, fériés), modèle d'heures supplémentaires Togo, API objectifs pour Projets. Le périmètre RH d'EDIP est plus large qu'Odoo en gestion de carrière, discipline et missions.

### 3.12 Paie

| Fonction | EDIP | Odoo |
|---|---|---|
| Bulletin | Lignes, rubriques personnalisées, personnalisation du bulletin | Fiches de paie, règles salariales |
| Cotisations, barèmes | Cotisations, barèmes à lignes, tranches IRPP, paramètres par pays, allocations familiales par pays. **Données fausses** : le barème IRPP du Togo semé à l'installation (`PaieParametrageSystemInitializer`, 5 tranches 7/15/25/35 %) ne correspond pas à l'art. 74 du CGI (8 tranches 0/3/10/15/20/25/30/35 %) ; l'ITS 2024 de Côte d'Ivoire et le barème du Sénégal relevés en octobre ne sont pas intégrés | **Paie par pays** : en Afrique, Égypte, Kenya, Maroc seulement ; aucune localisation UEMOA, CEMAC ou RDC. Odoo 20 : paie remaniée (tableau de bord, simulation avant validation) |
| Sortie du salarié (nouveau) | Solde de tout compte : valider, comptabiliser, payer, retenue envoyée au crédit ; provision retraite par profil pays | Non natif *(à vérifier)* |
| Moteur | Modes de calcul, assiettes, agrégats, regroupements | Règles Python par structure salariale |
| Éléments variables, avances | Oui | Oui |
| Simulation | Endpoint de simulation | Simulation de salaire dans le contrat |
| Prorata absences | Variables de paie alimentées par les pointages et congés validés de la RH | Via les règles |
| Comptabilisation | `PAIE_PERIODE`, `PAIE_MANCHE`, contrepassation, `VIREMENT_SALAIRE` | Écritures de paie par règle |
| Déclarations | CNSS, CAFAT, IRPP/DIPE, retenues, déclaration sociale | Selon localisation |
| Rapports | 23 codes dont masse salariale (globale, par département, 12 mois, N vs N-1, budget vs réalisé) | Rapports de paie |

Volume EDIP : ~144 endpoints, 97 classes de test. Bulletin sur une page en PDF.

### 3.13 Suivi-évaluation de projets

| Fonction | EDIP | Odoo |
|---|---|---|
| Cadre logique, indicateurs, cibles, collectes | Oui | Non |
| Programmes, projets, composantes, activités | Oui | Projets et tâches (autre logique) |
| Planification | S'appuie désormais sur le cœur EDIP Projets : Gantt avec planification par glisser-déposer | Projet (Gantt Enterprise) |
| Budget bailleurs | PTBA, conventions bailleur avec tranches, décaissements projet | Non |
| Bénéficiaires | Visites, carte QR, zones/cartographie | Non |
| Rapports | PDF via report-api : carte bénéficiaire, avancement, rapport financier bailleur, rapport d'achèvement | — |
| Compta | Écriture de décaissement publiée | — |

Volume EDIP : ~138 endpoints, 88 classes de test.

### 3.14 Ce qu'Odoo propose et qu'EDIP n'a pas

Fabrication (nomenclatures, ordres de fabrication, planification), e-commerce et site web, point de vente retail complet, marketing automation (campagnes de masse ; EDIP n'a que des comptages de segments), signature électronique, abonnements récurrents, flotte, maintenance, qualité, PLM, GED avec OCR, studio no-code complet (EDIP : champs personnalisés et designer de rapports seulement), rapports en tableaux croisés dynamiques, moteur de taxes multi-pays, comptabilité analytique, multi-société, intégrations transporteurs, **agents IA et OCR (Odoo 20)**, **mode hors-ligne complet du web (Odoo 20)**, accès externe pour outils IA.

Retirés de cette liste depuis octobre : helpdesk (EDIP Support livré, §3.17) et import générique (moteur `sfd-import-api`, §3.19).

### 3.15 Ce qu'EDIP propose et qu'Odoo n'a pas

Cœur SFD complet (épargne, crédit, tontine, collecte terrain, parts sociales, découvert), classification du risque et **provisions réglementaires G1-G6**, reporting réglementaire BCEAO/BEAC avec **indicateurs UEMOA F01-F15**, comptabilité dual-line avec saga et compensation, plan comptable SFD (RCS-SFD, COBAC, GCEC, PCCI), **paiement instantané PI-SPI de la BCEAO**, billetage obligatoire de bout en bout, conformité sur les transferts, cadre logique et suivi de bailleurs, app terrain avec synchronisation hors-ligne, portail financier client, paie pour la zone (à fiabiliser, §3.12), licence par module et par agence.

### 3.16 Projets (nouveau module EDIP)

| Fonction | EDIP | Odoo |
|---|---|---|
| Planification | Projets, tâches, jalons, dépendances, **chemin critique**, Gantt agrégé | Project, Gantt (Enterprise) |
| Portefeuilles et objectifs | Portefeuilles, objectifs (liés à la RH) | Partiel |
| Charge | Plan de charge et calcul de capacité | Planning (Enterprise) |
| Collaboration | Mentions, boîte de réception, champs personnalisés | Chatter, activités |
| Intégration | Synchronisation RH, support, licence, calendrier ; cœur réutilisé par Suivi-évaluation | Natif avec feuilles de temps et facturation |

Volume EDIP : 99 endpoints, 38 classes de test, contrat OpenAPI. Pas de publication comptable (pas de coût de projet en comptabilité).

### 3.17 Support / helpdesk (nouveau module EDIP)

| Fonction | EDIP | Odoo |
|---|---|---|
| Tickets | Machine d'états, catégories, matrice impact × urgence, champs personnalisés | Helpdesk (Enterprise) |
| Niveaux et SLA | Groupes N1 à N3, SLA avec pause, escalade et clôture automatiques | SLA, équipes |
| Satisfaction, RGPD | Enquête de satisfaction, anonymisation | Notation client |
| Portail | Portail public sans compte EDIP (captcha hCaptcha/Turnstile, vérification e-mail, export/suppression RGPD) | Portail client |

Volume EDIP : 44 + 21 endpoints, 25 classes de test. Module récent (11 et 5 commits).

### 3.18 Paiements

| Fonction | EDIP | Odoo |
|---|---|---|
| Paiement instantané BCEAO (PI-SPI) | `sfd-paiement-instantane-service` : activation du participant, CSR de certificat, alias, ordres unitaires et groupés, webhooks signés, estimation de frais, rapprochement, plafonds journaliers, garde de zone UEMOA. Utilisé par épargne (dépôt/retrait), crédit (décaissement, échéances), transferts, commercial (fournisseurs), paie | **Aucun** |
| Mobile money | `sfd-paiement-externe-service` (86 classes Java sur `develop`, dernier commit le 2026-11-10) : agrégateurs PayGate et CinetPay (bac à sable de démo, canaux T-Money au Togo), tableau de bord transactionnel, arrondis à la devise, secrets montés en fichiers, actuator restreint ; écrans d'envoi, recharge et historique dans le portail client ; opérateurs de démo Orange, MTN, Moov, Wave, T-Money, Flooz, Airtel | Fournisseurs officiels Flutterwave, DPO, Paymob (e-commerce/portail) ; rien d'officiel pour Orange Money, MTN MoMo ou Wave ([doc](https://www.odoo.com/documentation/20.0/applications/finance/payment_providers.html)) |

Volume EDIP PI-SPI : 42 endpoints, 32 classes de test.

### 3.19 Import et migration de données

| Fonction | EDIP | Odoo |
|---|---|---|
| Moteur | `sfd-import-api` : lecture Excel/CSV en flux, zone de transit, validation, finalisation SQL par phases, verrou de migration | Import CSV/Excel générique sur tout objet |
| Gabarits | Générés avec feuille d'instructions ; classeurs par module (06-Caisse, 07-Stock, 08-Immobilisation…) | Modèles d'import |
| Réinitialisation | Remise à zéro d'un module, purge des files RabbitMQ | Non |
| Interface | Assistant de lots dans `features/migration` | Assistant d'import |

### 3.20 Licence, installation, sauvegarde

| Fonction | EDIP | Odoo |
|---|---|---|
| Licence | Fichier signé, modules, plafonds, horloge anti-recul, états ACTIVE → ALERTE → GRACE → LECTURE_SEULE | Abonnement Odoo en ligne |
| Installation | Scripts d'installation, image multi-arch, secrets Docker, endpoint de version (écran « À propos »), serveur de mise à jour (désactivé par défaut) | Odoo Online / Odoo.sh / sur site |
| Sauvegarde | Activée par défaut, planification par cron dans l'interface, téléchargement | Sauvegardes gérées (Online, Odoo.sh) |

---

## 4. Transverse

| Axe | EDIP | Odoo |
|---|---|---|
| Moteur de workflow | Service dédié : définitions **versionnées** avec diff, étapes, approbations, **délégation** (dont automatique), **escalade et SLA**, approbateurs dynamiques et pools, étapes conditionnelles, formulaires dynamiques, déclencheurs mail/web/planifiés, notifications multi-canal, pièces jointes, catalogue d'événements. Désormais **branché sur la plupart des modules** (commercial, stock, budget, immobilisations, transferts, Agora, suivi-évaluation). 130 classes de test | Approbations simples + Studio (Enterprise) ; Odoo 20 : agents IA pour automatiser un processus |
| Personnalisation | Cœur générique de champs personnalisés (integration-api), **designer de rapports** déployé sur ~12 modules | Studio complet (Custom) |
| Collaboration | **Agora** : espaces, membres, dossiers avec droits, documents versionnés, articles/posts, tâches, sondages, commentaires, liens publics, journal d'audit, recherche Meilisearch | Discuss, Documents (Enterprise), Knowledge (Enterprise), Notes |
| Chat | Service mince (identité, aperçu de liens) ; stockage des messages non confirmé | Discuss complet, canaux, appels |
| i18n | 3 langues (fr, en, lingala), `fr.json` ≈ 29 000 lignes ; transfert en FR seulement côté backend | Dizaines de langues, traduction communautaire |
| UI / thème | Shell Velzon : vertical, horizontal, deux colonnes, thème sombre ; 1 353 composants, 32 domaines fonctionnels | Interface unifiée OWL, mode sombre, vues kanban/liste/pivot/graphe/calendrier |
| PWA / hors-ligne web | Non (pas de service worker ni manifest) ; hors-ligne seulement dans l'app agent Flutter | **Odoo 20 : mode hors-ligne complet** |
| Rôles | Directive `*appHasRole`, `@PreAuthorize` par module ; lib `security-oauth2` ; SSO Keycloak avec correspondance de groupes ; pas d'écran de matrice des permissions | Groupes, droits d'accès, règles d'enregistrement |
| Multi-agence | Hiérarchie d'agences, filtre d'agence en en-tête, **garde d'agence centrale** (integration-api), fuseau horaire par agence | Multi-société, multi-entrepôt |
| Pays et zones | Pays, zones, jours fériés ; paquets par pays dans le reporting (UEMOA) ; données de démo pour 10 pays | Localisations par pays |
| Audit trail | Starter d'audit automatique (avant/après) par service ; écran d'audit dans gestion-acces (filtre libre par module) | Chatter et logs |
| Setup initial | Wizard `/setup` (institution, agence, admin, plan comptable, journaux, paie) + wizard démo | Assistant de création de base |
| Aide | Aide refondue (recherche ⌘K, thèmes clair et sombre) ; guide utilisateur : 8 chapitres (préférence, client, caisse, épargne, stock, RH, paie, projets) | Documentation officielle, e-learning |
| Veille concurrentielle | Comparatifs PDF existants vs SmartMiFin et SMICO | — |

---

## 5. Maturité et risques côté EDIP

**Suivi des 22 écarts relevés le 2026-10-12** (état au 2026-11-13) : 5 faits, 10 partiels, 7 absents.

| Écart | État | Détail |
|---|---|---|
| Découvert épargne | Fait | Autorisation, plafond, limites produit |
| Import CAMT.053 | Fait | Parseur branché avec CSV et OFX ; détection de doublons non vérifiée |
| Helpdesk | Fait | Support + portail support |
| OTP des portails | Fait | Envoi par SMS (journalisé seulement si le service SMS est indisponible) |
| TER SYCEBNL | Partiel | Implémenté ; deux TODO obsolètes à retirer |
| Paquets de localisation | Partiel | Paquets pays dans le reporting ; ni taxes ni paie déclaratives |
| Audit | Partiel | Écran présent, filtre libre par module ; sécurisation de `/audit/search` (fourni par le starter) à vérifier |
| Webhooks / API publique | Partiel | Webhooks PI-SPI et notifications ; pas de clés d'API |
| Migrations | Partiel | Liquibase dans 3 services sur ~25 |
| Stock lots | Partiel | FIFO de lots et péremption ; CUMP seul, pas de série |
| No-code | Partiel | Champs personnalisés, designer de rapports ; pas de constructeur de formulaires |
| Import générique | Partiel | Moteur et assistant de migration ; couverture de tous les modules non confirmée |
| Campagnes marketing | Partiel | Comptages de segments ; pas d'envoi de masse |
| Paiements | Fait | PI-SPI et mobile money (PayGate, CinetPay) livrés sur `develop` |
| Sauvegarde, installeur, licence | Partiel | Livrés ; application effective de la licence non vérifiée |
| Moteur de TVA | Absent | — |
| Stock `typeSortie` / `calculerEcart` | Absent | Ventes enregistrées en consommation |
| 2FA back-office | Absent | — |
| PWA | Absent | — |
| Analytique | Absent | — |
| Multi-société | Absent | — |
| E-signature / e-facturation | Absent | — |

**Autres risques**

| Sujet | État |
|---|---|
| Barèmes de paie | **Barème IRPP Togo faux semé en installation réelle** ; ITS Côte d'Ivoire 2024 et barème Sénégal non intégrés (valeurs officielles relevées le 2026-10-12) |
| Clones locaux en retard | La branche `develop` locale de `sfd-paiement-externe-service` est restée au commit initial (le code est sur `origin/develop`) ; `sfd-mobile/sfd-agent-mobile` est un ancien clone de `sfd-agent-mobile-flutter`. Sans incidence produit, mais trompeur pour les scans et les builds locaux |
| Portail client | Modules de démonstration Velzon encore présents dans `store/` ; README de gabarit |
| Configuration | `client-id` OAuth écrits en clair dans `sfd-commun-service/src/main/resources/application.yml` (les secrets, eux, sont en variables) |
| Hétérogénéité des versions | Angular Material 16 / CDK 18 / Angular 19 |
| Qualité Sonar | Quality gate à revérifier dépôt par dépôt |

---

## 6. Score indicatif (jugement, pas une mesure)

Échelle 0-5 (5 = référence du marché). Notation subjective à partir des éléments ci-dessus. Colonne « Oct. » = note du 2026-10-12.

| Domaine | EDIP | Oct. | Odoo |
|---|---|---|---|
| Épargne / tontine | 5 | 4 | 0 |
| Crédit | 5 | 4 | 0 |
| Caisse + terrain | 4 | 4 | 1 |
| Reporting réglementaire SFD | 5 | 4 | 0 |
| Comptabilité SFD | 5 | 4 | 2 |
| Comptabilité générale | 4 | 4 | 5 |
| Fiscalité (TVA, déclarations) | 1 | 1 | 4 |
| Paiements locaux (PI-SPI, mobile money) | 5 | — | 1 |
| Ventes / achats | 3 | 3 | 5 |
| CRM | 2 | 2 | 5 |
| Stock / logistique | 3 | 3 | 5 |
| Fabrication | 0 | 0 | 5 |
| RH | 4 | 4 | 4 |
| Paie zone UEMOA/CEMAC/RDC | 2 (4 après correction des barèmes) | 3 | 1 |
| Projets | 4 | — | 4 |
| Helpdesk | 3 | — | 5 |
| Workflow | 5 | 5 | 3 |
| Personnalisation sans code | 2 | 1 | 5 |
| IA | 0 | — | 4 |
| Écosystème / intégrations | 1 | 1 | 5 |
| Facilité de déploiement | 3 | 2 | 4 |

La paie baisse de 3 à 2 : les barèmes erronés sont désormais semés en installation réelle, pas seulement en démo.

---

## 7. Recommandations

Le positionnement d'octobre tient : EDIP est une plateforme sectorielle (IMF, coopératives, tontines) avec une gestion interne complète, pas un concurrent d'Odoo sur le générique. Depuis, l'écart s'est creusé en faveur d'EDIP sur le métier (PI-SPI, provisions, indicateurs UEMOA), et en faveur d'Odoo sur l'IA et le hors-ligne. Odoo n'a toujours ni microfinance, ni paie, ni e-facturation pour la zone.

**P0 — avant toute démo ou mise en production**
1. **Corriger les barèmes de paie.** Le barème IRPP du Togo semé par `PaieParametrageSystemInitializer` (5 tranches 7/15/25/35 %) ne correspond pas à l'art. 74 du CGI (8 tranches 0/3/10/15/20/25/30/35 %), et il part désormais en installation réelle. Intégrer aussi l'ITS 2024 de Côte d'Ivoire (6 tranches, RICF, plafond CNPS 3 375 000) et le barème du Sénégal (art. 173.1, quotient familial, TRIMF, CFCE). Un bulletin faux engage l'institution cliente.
2. **Mettre à jour les clones locaux** : la branche `develop` locale de `sfd-paiement-externe-service` (code sur `origin/develop`), et retirer l'ancien clone `sfd-mobile/sfd-agent-mobile` au profit de `sfd-agent-mobile-flutter`.
3. **Nettoyer le portail client** : retirer les modules de démonstration Velzon de `store/` (surface d'attaque, poids du bundle) et remplacer les README de gabarit.

**P1 — conformité et sécurité (ce que régulateurs et auditeurs demanderont)**
4. **2FA du back-office via Keycloak.** Le SSO Keycloak existe déjà : activer sa politique OTP/TOTP pour les rôles sensibles coûte bien moins qu'un développement dans `security-oauth2`.
5. **Moteur de TVA**, puis **e-facturation FNE pour la Côte d'Ivoire** : Odoo ne la propose pas, c'est un argument commercial à prendre.
6. **Correctifs stock rapides** : ajouter `typeSortie` à `BonSortieRequest` (les ventes passent aujourd'hui en consommation, sur le mauvais compte) et supprimer ou implémenter `calculerEcart`.
7. **Trancher les migrations** : Liquibase n'existe que dans 3 services alors que la règle est « pas de versionnement avant la production ». Retirer, ou prévoir une baseline unique pour tous au passage en production.

**P2 — différenciation**
8. **Comptabilité analytique** : avec Projets, Suivi-évaluation et Budget déjà en place, des axes analytiques sur les lignes d'écriture relieraient coûts, bailleurs et projets — un argument fort pour les IMF et ONG financées par des bailleurs.
9. **API publique et webhooks génériques**, en étendant le modèle PI-SPI (signature, rejeu) à tous les modules. C'est aussi la voie pour un pont avec Odoo (fabrication, e-commerce) plutôt que de les développer.
10. **Paquets de localisation déclaratifs** (taxes et paie par pays, démo pilotée par paquet), condition pour vendre au-delà des 10 pays actuels.
11. **Guichet hors-ligne ciblé** (caisse et agence) plutôt qu'une PWA générale : Odoo 20 met le hors-ligne en avant, et la connectivité des agences est un vrai problème terrain.

**P3 — à surveiller**
12. **IA** : commencer petit et mesurable (suggestion de rapprochement bancaire, pré-scoring crédit expliqué) plutôt qu'un assistant générique pour répondre aux agents d'Odoo 20.
13. **Prix** : Odoo Custom ≈ 44,90 €/utilisateur/mois sans microfinance ni paie locale. EDIP peut se vendre par agence et par module grâce au service de licence, avec le cœur SFD, la paie de la zone et PI-SPI inclus.
