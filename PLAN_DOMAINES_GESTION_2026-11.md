# Plan de développement : domaines de gestion où EDIP est en retrait sur Odoo

Date : 2026-11-13. Suite du [comparatif EDIP vs Odoo](COMPARATIF_EDIP_ODOO.md) (§6 scores, §7 recommandations).

Domaines couverts : stock et logistique, CRM, commercial, helpdesk, personnalisation sans code, fabrication, comptabilité générale, fiscalité.

**Base des constats** : état GitHub (`origin/develop`) au 2026-11-13, pas les copies locales. Les efforts sont des ordres de grandeur (S = quelques jours, M = 1 à 3 semaines, L = plus d'un mois) à affiner au découpage.

---

## 0. Principes

1. **Ne pas copier Odoo partout.** EDIP sert toute entreprise (PME, commerce, services, ONG, institutions financières) ; la verticale finance de proximité (IMF, coopératives, tontines) est un ensemble de modules en plus. Chaque domaine reçoit une décision : **construire**, **compléter**, ou **intégrer** (passer par une API vers un outil tiers, Odoo compris).
2. **Viser ce que nos clients utilisent** : toute entreprise cliente a besoin d'une comptabilité générale et d'une fiscalité irréprochables, d'un stock de fournitures et de produits, d'un CRM, d'un traitement des réclamations. Les domaines de ce plan sont donc génériques d'abord ; les angles propres aux institutions financières (adhésion, dossier client EDIP) viennent en complément. Un WMS ou un MRP complet reste rare chez nos clients : un industriel passe par l'intégration (FAB-2).
3. **Règles du projet** : tout ce qui concerne un module reste dans ce module (les autres le lisent par l'API d'intégration) ; comptabilisation dual-line sans compte générique de repli ; composants Angular partagés réutilisés ; vérification de non-régression, e2e du module et passage navigateur sur base jetable après chaque lot.
4. **S'appuyer sur l'architecture de localisation** (comparatif §7) pour tout ce qui dépend du pays : taxes, déclarations, formats.

---

## 1. Fiscalité (TVA, déclarations) — **construire**, priorité 1

**Pourquoi d'abord** : c'est le plus gros écart (EDIP 1/5, Odoo 4/5), il bloque toute vente hors secteur financier, et il conditionne le commercial, le stock et la comptabilité générale.

**État vérifié** : aucun référentiel de taxes ; taux saisi librement sur les lignes commerciales (défaut 18) ; un seul compte de TVA par schéma commercial ; aucune déclaration ; aucune e-facturation.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| FIS-1 Référentiel | Entités `Taxe` (code, taux, type TVA/retenue/autre, sens, comptes par norme, dates d'effet) et `RegimeTva` dans la comptabilité ; alimentation par le paquet pays ; écran de paramétrage | M | Paquets de localisation (format) |
| FIS-2 Application | `codeTaxe` sur les lignes commerciales (en plus de `tauxTva`), liste déroulante au lieu de la saisie libre, ventilation de la TVA par taxe, une ligne comptable par compte de taxe ; vente comptoir alignée sur le calculateur commun | M | FIS-1 |
| FIS-3 Positions fiscales | Régime fiscal et NIF sur le tiers ; substitution automatique taxe/compte (exonéré, export, régime spécial) | S | FIS-2 |
| FIS-4 Déclaration de TVA | Agrégation des écritures comptabilisées par case, drill-down vers les pièces, écriture de liquidation, verrou fiscal de la période, export PDF/Excel ; modèle de formulaire par pays dans le paquet | M | FIS-1, comptabilité |
| FIS-5 Retenues à la source | Retenues sur prestations (taux par pays), précompte TVA, état des retenues | S | FIS-1 |
| FIS-6 E-facturation FNE (Côte d'Ivoire) | Facture normalisée transmise à la DGI ; argument commercial, Odoo ne l'a pas | L | FIS-2 ; **vague 0 sourcée** (spécification DGI) avant tout code |

**Critères d'acceptation** : facture de 100 000 HT à 18 % → pièce 118 000 / 100 000 / 18 000 ; tiers exonéré → aucune TVA et bon compte ; avoir partiel → déclaration réduite d'autant ; période déclarée → écriture refusée avec message ; liquidation = collectée − déductible au centime.

---

## 2. Comptabilité générale — **compléter**, priorité 1

**État vérifié** : solide sur l'essentiel (journaux, lettrage, rapprochement, clôtures mensuelle et annuelle en assistant, réouverture, états SYSCOHADA, 40 rapports). Manques : import OFX (stub), détection de doublons à l'import de relevés, analytique, paiements en lot, multi-société, vrai TER SYCEBNL.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| CG-1 Import bancaire fiable | Parseur OFX 1.x/2.x, détection de doublons (compte, référence, date, montant), soldes lus dans le fichier, rapport d'import (importées, doublons, erreurs) | S | — |
| CG-2 Comptabilité analytique | Plans et axes analytiques (projet, bailleur, agence, activité), ventilation sur les lignes d'écriture, règles de répartition, rapports ; reliée à Projets, Suivi-évaluation et Budget | L | — |
| CG-3 Paiements en lot | Règlement groupé des fournisseurs et des salaires en réutilisant les ordres groupés PI-SPI (`PaiementGroupe`) et, hors UEMOA, un fichier de virement | M | — |
| CG-4 TER SYCEBNL réel | Vrai tableau emplois-ressources (variations entre deux exercices), pas une simple présentation du bilan | S | — |
| CG-5 Rapprochement assisté | Propositions de lettrage et de rapprochement apprises des choix passés (premier pas « IA » mesurable) | M | CG-1 |
| CG-6 Multi-société et consolidation | Plusieurs entités juridiques dans une instance, éliminations intra-groupe | L | **Décision produit** : seulement si un client réseau (faîtière, groupe) le demande |

**Critères d'acceptation** : réimporter le même relevé → 0 ligne en double ; une dépense ventilée sur deux projets apparaît au bon montant dans chaque rapport analytique ; un lot de 50 règlements fournisseurs génère un ordre groupé et les écritures correspondantes.

---

## 3. Stock et logistique — **compléter**, priorité 2

**Réponse courte** : EDIP gère bien le stock interne (magasins, mouvements, lots, inventaire, écritures), pas encore une logistique complète. Manquent la réservation, le stock par emplacement, les livraisons suivies, les retours clients et fournisseurs, et le réapprovisionnement automatique.

**Règle** : le stock et le commercial marchent ensemble, mais un client peut prendre le stock seul. Chaque lot ci-dessous doit fonctionner sans le module commercial ; le lien avec le commercial reste optionnel.

**État vérifié (GitHub, 2026-11-14)**

| Fonction | État |
|---|---|
| Référentiels, magasins, mouvements, transferts entre magasins (statuts expédié puis reçu), inventaire, workflows, PDF unitaires | Fait |
| Stock seul, sans commercial | Fait : réception avec fournisseur en texte libre (code, libellé, n° de bon de livraison et de facture), sortie avec bénéficiaire libre, écritures stock/achat paramétrées par type d'opération. Pas de référentiel fournisseur propre au stock ; la dette fournisseur relève du commercial ou de la comptabilité |
| Emplacements | Partiel : référentiel (rayon, étagère, casier, zone) et saisie sur les lignes de bons et les lots, mais le stock est tenu par magasin, pas par emplacement |
| Préparation et livraison | Partiel : statuts « préparé » et « livré » du bon de sortie, quantité livrée enregistrée ; ni adresse, ni transporteur, ni suivi, ni preuve de livraison |
| Réservation | **Absent** : champs « quantité réservée » sur le stock et le lot, jamais alimentés ; le disponible égale donc le stock |
| Retours | Absent pour les clients et fournisseurs : l'entrée « retour » ne sert qu'au matériel rendu par un employé |
| Kits (`ArticleComposition`, décomposés à la sortie) | Fait |
| Lots : consommation FIFO, date de fabrication et de péremption ; articles « gestion par lot » et « périssable » avec durée de vie | Fait |
| Alertes automatiques : **rupture, péremption, seuil minimum** | Fait |
| Paramètres de réapprovisionnement sur l'article (stock minimum, de sécurité, maximum, quantité et délai de réappro) | Fait, **mais rien ne génère de demande d'achat** |
| Numéros de série | Partiel : seulement sur le matériel affecté aux employés, pas sur les lots ni les mouvements |
| Code-barres | Partiel : champ sur l'article et recherche ; l'app Flutter embarque déjà une bibliothèque de scan (utilisée pour le QR de configuration), pas encore pour le stock |
| Type de sortie VENTE depuis le commercial | **Défaut** : le contrat d'intégration ne transmet pas le type, les ventes sont classées en consommation |
| `calculerEcart` | Stub (le calcul réel est ailleurs) |
| Valorisation | CUMP seul : l'énumération prévoit FIFO, LIFO et prix standard, mais le code les refuse |
| Rappel de lot | Absent |

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| ST-1 Correctifs | `typeSortie` dans `BonSortieRequest`, renseigné VENTE par le commercial ; `calculerEcart` implémenté ou supprimé ; test de bout en bout mouvement + écriture, avec et sans module commercial | S | — |
| ST-2 Réapprovisionnement | Exploiter les paramètres déjà présents sur l'article quand le stock passe sous le minimum, en tenant compte du délai. Sans commercial : propositions de réappro dans le stock (transfert entre magasins ou bon de réception préparé). Avec commercial : demande d'achat (lot COM-2) | S | COM-2 seulement pour la demande d'achat |
| ST-3 Traçabilité | Numéros de série sur les lots et mouvements (le modèle existe déjà pour le matériel affecté), rappel de lot (qui a reçu quoi) ; les alertes de péremption existent déjà | M | — |
| ST-4 Valorisation | FIFO effectif (couches de coût) en plus du CUMP, avec écritures correspondantes | M | — |
| ST-5 Scan | Lecture de codes-barres à la réception, la sortie et l'inventaire, en réutilisant la bibliothèque de scan déjà présente dans l'app Flutter et le champ code-barres de l'article ; douchette sur le web | S | — |
| ST-6 WMS lourd | Vagues de préparation, colisage, étiquettes et tarifs des transporteurs par API | — | **Ne pas construire** ; intégrer si besoin |
| ST-7 Réservation et emplacements | Réserver à la demande ou à la validation d'une sortie, libérer à la livraison ou à l'annulation ; disponible = stock − réservé ; stock tenu par emplacement (entrée, sortie, transfert interne entre emplacements, inventaire par emplacement) | M | — |
| ST-8 Livraisons et retours | Bon de livraison avec adresse et contact, référentiel simple de transporteurs, n° de suivi, preuve de livraison (signature ou photo dans l'app Flutter) ; retours client (entrée) et fournisseur (sortie) avec motif et écritures, rattachés au bon d'origine | M | — |

**Critères d'acceptation** : livrer 5 unités → mouvement `SORTIE_VENTE` et écriture sur le compte de vente ; stock sous le minimum → proposition de réappro (demande d'achat si le commercial est actif) ; inventaire 18 sur 20 → écart −2 valorisé et soumis au workflow ; réserver 5 sur 20 → disponible 15 ; retour client de 2 → entrée et écriture rattachées au bon de livraison ; module commercial désactivé par la licence → réception, sortie, inventaire, livraison et écritures fonctionnent.

---

## 4. Commercial (ventes et achats) — **compléter**, priorité 2

**État vérifié** : devis → commande → BL → facture → avoir → règlement, achats complets, comptoir, acomptes, listes de prix, grilles, remises avec workflow, balance âgée, **relances d'impayés**, règlement fournisseur par PI-SPI, 17 rapports. Manques : demandes d'achat et rapprochement à trois voies, règles de prix avancées, abonnements, signature électronique, portail fournisseur.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| COM-1 Fiscalité | Intégration de FIS-2/FIS-3 dans tous les documents | — | FIS-2 |
| COM-2 Achats contrôlés | Demande d'achat → demande de prix comparative → commande ; rapprochement commande / réception / facture avant paiement | M | — |
| COM-3 Prix | Règles de prix (quantité, période, catégorie de client, promotions), prix calculés à partir du coût | M | — |
| COM-4 Abonnements | Contrats et facturation récurrente (cotisations, loyers, services) — utile pour les coopératives | M | FIS-2 |
| COM-5 Signature | Signature électronique des devis et contrats, avec piste d'audit | M | Choix d'un fournisseur (vague 0 sourcée) |
| COM-6 E-commerce, location | — | — | **Ne pas construire** ; intégrer si besoin |

**Critères d'acceptation** : une facture fournisseur dont la quantité dépasse la réception est bloquée ; un client d'une catégorie donnée obtient automatiquement son prix ; un abonnement mensuel génère sa facture et son écriture chaque mois.

---

## 5. CRM — **compléter et orienter vers l'adhésion**, priorité 3

**État vérifié — le pipeline leads/deals existe déjà** :
- **Leads** (`Prospect`) : statuts NOUVEAU → EN_CONTACT → QUALIFIE → PROPOSITION → NEGOCIATION → CONVERTI / PERDU ; source d'acquisition, segment, montant estimé, agent ; conversion en tiers, réaffectation, détection des doublons.
- **Deals** (`OpportuniteCommerciale`) : étapes PROSPECTION → QUALIFICATION → PROPOSITION → NEGOCIATION → GAGNE / PERDU ; montant, probabilité, dates de clôture prévue et réelle.
- **Pipeline Kanban** avec glisser-déposer entre étapes, filtres par agent et montant.
- Activités (appel, rendez-vous, tâche, note, e-mail) en chronologie, envoi d'e-mails, objectifs par agent, portefeuille, vue client 360, tableau de bord, rapport de pipeline.
- Segments de clients (comptages) dans le module client ; notifications e-mail, SMS et push en place.

**Manques par rapport à Odoo** : aucun lien opportunité → devis ; pas de motif de perte ; étapes figées dans le code (pas d'étapes configurables ni de pipelines multiples) ; pas de prévision pondérée (montant × probabilité) ; pas de score de leads, d'automatisation ni de campagnes.

**Angle EDIP** : le CRM sert d'abord toute entreprise (leads, deals, devis, prévision). Pour une institution financière, le « client » à conquérir est en plus un membre : le CRM relie alors prospection terrain, adhésion, ouverture de compte et premier crédit, ce qu'Odoo ne fait pas.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| CRM-0 Pipeline de vente complet | Lien opportunité → devis (création du devis depuis le deal, passage automatique à GAGNE à la commande) ; motif de perte obligatoire et rapport des pertes ; **Kanban plus lisible** : une couleur discrète par étape (liseré ou en-tête légèrement teinté, palette neutre qui progresse vers la clôture, vert pour gagné, rouge atténué ou gris pour perdu), badges de probabilité, montant total et pondéré en tête de colonne, avatar de l'agent sur la carte, mise en évidence douce des deals en retard sur leur date de clôture ; couleurs issues des variables du thème (compatibles mode sombre), sans dégradé ni fond saturé ; étapes configurables (ordre, probabilité par défaut, étape gagnée/perdue) et pipelines multiples (vente, adhésion, partenariats) ; prévision pondérée par période et par agent | M | — |
| CRM-1 Pipeline d'adhésion | Prospect → adhésion (module client) → premier compte → premier crédit, avec taux de conversion par agent et par agence ; prospects saisis depuis l'app terrain | M | Client, agent mobile |
| CRM-2 Campagnes | Envoi de masse e-mail/SMS à un segment (consentement, désabonnement, estimation du coût SMS, rapport d'envoi), en réutilisant les modèles et canaux de notification | M | — |
| CRM-3 Automatisation | Relances programmées (prospect sans activité, échéance de DAT, client dormant), tâches créées automatiquement | S | Déclencheurs du workflow |
| CRM-4 Scoring de prospects | Score simple et explicable (complétude KYC, activité, segment) | S | — |

**Critères d'acceptation** : un devis créé depuis une opportunité la référence, et la commande la passe à GAGNE ; une opportunité perdue sans motif est refusée ; la prévision pondérée d'un agent égale la somme montant × probabilité de ses deals ouverts ; le taux de conversion prospect → membre par agent est vérifiable contre les données ; un désabonné n'est jamais contacté ; une campagne affiche envoyés/échoués/désabonnés.

---

## 6. Helpdesk — **compléter, avec un angle réglementaire**, priorité 3

**État vérifié (GitHub, 2026-11-13)**

| Fonction | État |
|---|---|
| Tickets incident et demande de service, cycle NOUVEAU → QUALIFIE → ASSIGNE → EN_COURS → EN_ATTENTE → RESOLU → FERME | Fait |
| Qualification, assignation, escalade (manuelle et automatique), mise en attente avec pause du SLA, résolution confirmée par le demandeur, réouverture, clôture automatique | Fait |
| Catégories avec champs personnalisés, matrice impact × urgence → priorité, groupes N1-N3 et membres, politiques SLA | Fait |
| Validation (approbation) d'une demande, satisfaction avec commentaire, historique d'événements, anonymisation RGPD | Fait |
| Écrans : mes tickets, file du technicien, tableau de bord, rapports personnalisés, tâches liées (module Projets), paramétrage | Fait |
| Portail public sans compte EDIP (origine EXTERNE) | Fait |
| Création de tickets par e-mail | Absent |
| Base de connaissances | Absent |
| Réponses types, macros | Absent |
| Lien avec le dossier client EDIP (client, compte, crédit) et réclamations | Absent : le demandeur est un utilisateur ou un compte du portail support |
| Tickets depuis le portail client EDIP | Absent |

**Angle EDIP** : les institutions financières doivent tenir un dispositif de traitement des **réclamations clientèle** avec délais et reporting *(exigence BCEAO à sourcer avant de la citer dans la documentation commerciale)*. Le helpdesk peut le couvrir.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| HD-1 Réclamations clients | Type « réclamation » lié au client et au compte/crédit concerné, délais réglementaires, registre et rapport périodique | M | Vague 0 sourcée (texte BCEAO) |
| HD-2 E-mail entrant | Création et mise à jour de tickets depuis une boîte e-mail | M | — |
| HD-3 Base de connaissances | Articles publics et internes, suggestion d'articles à la création d'un ticket | M | — |
| HD-4 Réponses types | Modèles et macros (réponse + changement de statut) | S | — |
| HD-5 Canaux | Tickets depuis le portail client EDIP, puis WhatsApp/SMS | M | HD-1 |

**Critères d'acceptation** : une réclamation dépassant le délai apparaît dans le rapport réglementaire ; un e-mail entrant crée un ticket rattaché au bon client.

---

## 7. Personnalisation sans code — **compléter, sans viser un Studio**, priorité 3

**État vérifié** : cœur générique de champs personnalisés (integration-api) utilisé par 4 services (RH, Projets, Support, Paie) ; designer de rapports dans 14 services ; formulaires dynamiques et déclencheurs du moteur de workflow ; import par classeurs.

| Lot | Contenu | Effort | Dépend de |
|---|---|---|---|
| NC-1 Champs personnalisés partout | Brancher le cœur existant sur client, épargne, crédit, caisse, commercial, stock, avec affichage dans les formulaires, les listes, les rapports et l'import | M | — |
| NC-2 Listes configurables | Colonnes, filtres et tris enregistrés par utilisateur, vues partagées | M | — |
| NC-3 Tableaux de bord personnels | Indicateurs choisis par l'utilisateur à partir des sources du designer de rapports | M | — |
| NC-4 Règles d'automatisation | « Quand X, alors Y » (notifier, créer une tâche, lancer un circuit) sur la base des déclencheurs du workflow | M | — |
| NC-5 Constructeur d'écrans | — | — | **Ne pas construire** (coût élevé, risque de fragilité) |

**Critères d'acceptation** : un champ ajouté sur le client apparaît dans la fiche, la liste, un rapport et le gabarit d'import sans déploiement ; une règle d'automatisation se déclenche et est tracée dans l'audit.

---

## 8. Fabrication — **ne pas construire de MRP**, priorité 4

**État vérifié** : aucun module ; seules les compositions d'articles (kits) existent en stock.

**Décision proposée** : un MRP complet ne correspond pas à la cible. Deux options :

| Lot | Contenu | Effort | Condition |
|---|---|---|---|
| FAB-1 Production légère | Ordre de transformation : consommation de composants (à partir des compositions existantes) → produit fini, avec coût de revient et écritures ; utile aux PME et coopératives qui transforment (agroalimentaire, artisanat) | M | Si un client le demande |
| FAB-2 Intégration | Pont vers un outil de production (Odoo MRP par exemple) via API publique et webhooks sortants | M | Après l'API publique (recommandation 9 du comparatif) |

---

## 9. Séquencement

| Phase | Contenu | Pourquoi |
|---|---|---|
| **A — Fiabilité** (immédiat) | ST-1, CG-1, CG-4 | Correctifs courts sur des défauts confirmés |
| **B — Conformité** | Paquets de localisation (format) → FIS-1 à FIS-5, COM-1 | Plus gros écart, prérequis de la gestion commerciale |
| **C — Pilotage** | CG-2 analytique, CG-3 paiements en lot, NC-1 champs personnalisés partout | Pilotage par projet et par bailleur, socle de personnalisation |
| **D — Relation client** | CRM-0, CRM-1, CRM-2, HD-1, HD-2 | Adhésion et réclamations, angles propres à EDIP |
| **E — Gestion avancée** | COM-2, COM-3, ST-2 à ST-5, ST-7, ST-8, NC-2 à NC-4, HD-3 à HD-5, CRM-3, CRM-4 | Rattrapage fonctionnel |
| **F — Sur demande** | FIS-6 FNE, COM-4, COM-5, CG-5, CG-6, FAB-1, FAB-2 | Selon les clients et les pays visés |

Les lots d'une même phase sur des modules différents se mènent en parallèle (dépôts disjoints).

---

## 10. Effet attendu sur les scores du comparatif

| Domaine | Aujourd'hui | Après phases A-E | Odoo |
|---|---|---|---|
| Fiscalité | 1 | 4 | 4 |
| Comptabilité générale | 4 | 5 | 5 |
| Stock / logistique | 3 | 4 | 5 |
| Ventes / achats | 3 | 4 | 5 |
| CRM | 3 (pipeline leads/deals déjà en place) | 4 | 5 |
| Helpdesk | 3 | 4 | 5 |
| Personnalisation sans code | 2 | 3 | 5 |
| Fabrication | 0 | 0 à 2 selon décision | 5 |

---

## 11. Vérification de chaque lot

- Tests de la classe touchée puis suite complète du service (`scripts/claude/regress.sh`), rapport `Baseline → Après | Régressions: 0`.
- Recherche des effets de bord sur les contrats partagés (énumérations, `@PreAuthorize`, DTO d'intégration, actions NgRx).
- E2E du module (`./dev.sh start <module>`, `npm run e2e:<module>`) et passage dans le navigateur interne sur base de démo jetable (`edip-env`).
- Pour tout lot qui publie des lignes comptables : relecture de la règle dual-line avant le code, et preuve d'une pièce équilibrée.
- Pour toute intégration externe (FNE, signature, e-mail entrant) : vague 0 sourcée, rien tant qu'un point bloquant n'est pas vérifié.
