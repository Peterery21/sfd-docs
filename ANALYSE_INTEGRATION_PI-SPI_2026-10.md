# Analyse d'intégration PI-SPI (BCEAO) dans l'ERP SFD

Date : 2026-10-05 · Statut : analyse / proposition (aucune implémentation)

## 1. Qu'est-ce que PI-SPI

**PI-SPI** = Plateforme Interopérable du Système de Paiement Instantané de l'UEMOA. Infrastructure conçue, développée et opérée par la BCEAO (pas un produit tiers). Lancée officiellement le 30 septembre 2025 après une phase pilote en conditions réelles depuis le 5 juin 2025.

| Caractéristique | Valeur |
|---|---|
| Périmètre | 8 pays UEMOA, FCFA uniquement |
| Participants | Banques, établissements de monnaie électronique (EME), établissements de paiement, SFD agréés (supervisés par la Commission Bancaire) |
| Disponibilité | 24/7/365 |
| Délai d'exécution | < 10 s (max 20 s), crédit immédiat et irrévocable du bénéficiaire |
| Plafond | 5 000 000 FCFA par transaction |
| Messagerie | ISO 20022 (pacs.008 / pacs.002 paiements, camt trésorerie, RACALIAS gestion alias) |
| Sécurité | mTLS + VPN, certificats, chiffrement bout en bout, supervision 24/7 |
| Identifiants | Alias = numéro de téléphone ou adresse de paiement générée ; 1 alias par compte ; vérification du nom + pays du bénéficiaire avant confirmation ; annuaire central d'alias |
| Paiement marchand | QR code standardisé (logo octogonal), accepté par toutes les apps participantes, en présence physique |
| Services grand public | Transfert compte-à-compte, compte ↔ mobile money, paiement marchand QR |
| API Business | Homologuées depuis sept. 2026 (24 API sur 104 participants) : émission/réception de paiements, règlements de masse, automatisation, suivi temps réel. Sandbox : `developer.pispi.bceao.int` |

### Tarification (communiqué BCEAO du 2 oct. 2026, applicable au 2 nov. 2026)

| Opération | Tarif |
|---|---|
| Envoi national ≤ 8 000 FCFA cumulés / jour / usager / participant | Gratuit, sans limite d'opérations (75 % des transactions ME de l'Union) |
| Envoi national > 8 000 FCFA | 0 à 0,8 % HT, fixé par le participant |
| Réception particulier | Gratuite sans limite (ancienne règle : 30 réceptions/mois puis ≤ 1 %) |
| Réception marchand | Librement fixée par le participant |
| Transfrontalier | Mêmes conditions à partir du 1er juin 2027 |

### Calendrier réglementaire

| Échéance | Obligation |
|---|---|
| 30 juin 2026 | Date limite initiale de préparation technique/administrative pour tous les assujettis |
| 30 sept. 2026 | Ouverture effective des services pour banques, EME, établissements de paiement |
| 2 nov. 2026 | **Toute transaction de monnaie électronique interopérable passe obligatoirement par PI-SPI** |
| 30 juin 2027 | **Ouverture effective des services pour les SFD** supervisés par la Commission Bancaire (sanctions ensuite) |

### Adoption

| Date | Participants connectés | dont SFD |
|---|---|---|
| 31 juil. 2025 (pilote) | 86 | 10 (Baobab, Cofina, UM-ACEP, UM-PAMECAS…) |
| 2 avr. 2026 | 80 (59 banques, 9 EME, 11 SFD, 1 EP) | 11 |
| 2 oct. 2026 | 175 autorisés | n.c. |

**Constat clé pour notre marché** : au 2 avril 2026, seuls 11 SFD sur ~20 millions de clients du secteur étaient connectés ; zéro SFD connecté au Togo, Bénin, Niger, Guinée-Bissau. Freins identifiés : SI core banking non prêts, procédures LBC/FT et KYC non formalisées, gouvernance et reporting prudentiel non conformes, coût d'intégration. Conséquence de non-connexion : exclusion des partenariats mobile money, refinancement bancaire conditionné, marché de la diaspora fermé.

→ **Un ERP SFD « PI-SPI ready » est un argument commercial direct** : la connexion devient obligatoire pour les grands SFD d'ici juin 2027 et la majorité du marché n'a pas de solution.

### Périmètre géographique : UEMOA uniquement

PI-SPI ne couvre que les 8 pays de l'UEMOA et ne traite que le franc CFA BCEAO (XOF). Une institution installée hors UEMOA (RDC, zone CEMAC, autre) ne peut ni s'y connecter ni l'utiliser : **la fonctionnalité doit lui être totalement invisible** (menus, écrans, options de mode de paiement, paramétrage, rapports) et refusée côté serveur.

Critère d'éligibilité retenu, déjà présent dans l'ERP : zone monétaire du **pays siège de l'institution principale** (`Institution.paysSiege` → `Pays.zoneMonetaire == UEMOA`, exposé par `PreferenceRestClient.findInstitutionPrincipale()` puis `findPaysByCode()` dans `sfd-integration-api`). La devise seule ne suffit pas comme critère (une institution UEMOA peut tenir des comptes en EUR/USD ; un pays CEMAC utilise XAF).

## 2. État actuel de l'ERP (scan du dépôt, 2026-10-05)

**Constat : aucun rail monétaire externe réel.** Ni client HTTP vers un opérateur mobile money, une banque ou la BCEAO, ni webhook entrant de paiement. « Mobile money » et « virement » n'existent que comme *modes de paiement comptables*.

| Brique | Existant | Fichiers clés |
|---|---|---|
| Modes de paiement | `MOBILE_MONEY`, `VIREMENT`, `VIREMENT_EXTERNE` dans caisse, épargne, crédit, client, commercial, RH | `*/enums/ModePaiement.java`, `credit/.../ModeDecaissement.java`, `epargne/.../ModeOperation.java` |
| Compte mobile money SFD | Entité float opérateur (ORANGE, MTN, MOOV, WAVE, AIRTEL), journal `MOB`, résolution par agence | `sfd-comptabilite-service/.../CompteMobileMoney.java`, `CompteMobileMoneyIntegrationController` |
| Contrepartie trésorerie | Publie `LignesComptablesEvent` pour MOBILE_MONEY / VIREMENT / CHEQUE | `ContrepartieTresorerieServiceImpl`, `TresorerieIntegrationController` |
| Opérations bancaires | `OperationBancaire` (VIREMENT_EMIS/RECU, PRELEVEMENT…), `CompteBancaire` (codeBanque, numeroCompte, iban) | `sfd-comptabilite-service` |
| Rapprochement bancaire | Import CSV/OFX, lettrage auto ; MT940 & CAMT.053 proposés par l'UI mais rejetés backend | `RapprochementBancaireServiceImpl.importerReleve` |
| Transferts | `sfd-transfert-service` interne (TRF_INT/AGC/NAT/UEM) ; pas de publication RabbitMQ effective | `TypeTransfertEnum` |
| Portail client | Virement **interne** compte→compte, retrait mobile money = **stub** (référence `RMM-…` + `SUCCESS`, aucun débit) ; `/rib` renvoie `RIB_NOT_FOUND` | `PortailRetraitMobileService` (24 lignes), `PortailVirementService` |
| Appli agent mobile | `modePaiement` = String libre, idempotence `clientRequestId` | `MobileDepotRequest`, `EpargneConnector` |
| Bus d'événements | `OperationEvent` CloudEvents (correlationId, modePaiement, `TresorerieInfo`, `BancaireInfo`), saga `SagaOperation`, dédup `OperationEventLog` (caisse, client seulement), **pas d'outbox** transactionnel | `sfd-integration-api/.../events/` |
| Identité | Client : `numeroClient`, `telephonePrincipal` ; comptes `DAV-YYYY-NNNNNN` ; **aucune clé RIB/IBAN générée** | `Client.java`, `SetupEpargneLoader` |
| Plan comptable | RCSFD classe 1 (114 Banques, 116 SFD, 117 autres IF) — **aucun compte EME / PI-SPI** ; extension SYSCOHADA 5521/5522 | `accounting-norms/uemoa/rcs_sfd/plan-comptable.yml` |
| Banques | Référentiel `Banque` (codeBanque, codeBIC) | `sfd-commun-service/.../Banque.java` |

**Verdict** : l'ERP a la *sémantique* (modes, événements, saga, contrepartie trésorerie, rapprochement) mais aucune *exécution* externe. PI-SPI serait le premier rail réel ; il remplace avantageusement N intégrations opérateur par opérateur (Orange, MTN, Moov, Wave…) par une seule connexion normalisée ISO 20022.

## 3. Modèles de connexion possibles

| Modèle | Description | Pour qui | Effort ERP |
|---|---|---|---|
| **A. Participant direct** | Le SFD est participant PI-SPI : compte de règlement, certification BCEAO, mTLS/VPN, ISO 20022 complet, alias, QR, supervision 24/7 | Grands SFD (Art. 44, supervisés Commission Bancaire) — obligation au 30 juin 2027 | Élevé : connecteur ISO 20022 + exigences opérationnelles (HA, 24/7, réconciliation) |
| **B. Participant indirect / sponsorisé** | Connexion via une banque participante qui porte le règlement ; le SFD expose ses comptes via l'API de la banque | SFD moyens non assujettis ou en attente d'agrément | Moyen : connecteur par banque sponsor (spécifique), moins de contraintes BCEAO |
| **C. Client API Business** | Le SFD agit comme *entreprise* cliente d'une banque homologuée (24 API Business au 17/09/2026) : émission/réception de paiements, règlements de masse, suivi | Petits SFD, démarrage rapide | Faible : REST JSON, pas de certification BCEAO ; mais pas d'alias/QR au nom du SFD, règlement sur compte bancaire du SFD |

**Recommandation** : architecture ERP unique avec un **port « rail de paiement instantané »** et trois adaptateurs (A direct ISO 20022, B sponsor, C API Business). Démarrer par C (valeur immédiate, faible risque), bâtir A pour les SFD assujettis.

## 4. Architecture d'intégration proposée

### 4.1 Nouveau service `sfd-paiement-instantane-service` (ou module « rail »)

Responsabilités, isolées des modules métier :

1. **Gateway PI-SPI** : mTLS, certificats, VPN, signature ; mapping ISO 20022 ⇄ DTO interne (pacs.008 émission, pacs.002 statut, camt.054/053 notifications et relevés, RACALIAS alias).
2. **Annuaire & alias** : enregistrement/résolution alias (téléphone ou adresse de paiement) ↔ compte épargne `DAV-…` ; 1 alias par compte ; vérification nom bénéficiaire avant confirmation.
3. **Ordres sortants** : `OrdrePaiementInstantane` (statut INITIE → ENVOYE → ACCEPTE/REJETE → IRREVOCABLE), idempotence par `clientRequestId` + `endToEndId`, **outbox transactionnel** (absent aujourd'hui dans les modules financiers — prérequis pour un rail irrévocable).
4. **Crédits entrants** : réception pacs.008, contrôle alias/compte actif/plafond, crédit immédiat du compte épargne via épargne, accusé pacs.002 < 10 s.
5. **Règlement & réconciliation** : position de règlement BCEAO, rapprochement automatique des mouvements PI-SPI avec les lignes comptables (étend `RapprochementBancaire` : ajouter format CAMT.053 déjà proposé par l'UI).
6. **Tarification** : grille 0–0,8 % au-delà de 8 000 FCFA/jour cumulés, réception gratuite, marchand libre ; calcul cumul journalier par usager et participant.
7. **Supervision** : métriques temps de réponse (SLA 10 s), taux de rejet, file de retry, alertes.

### 4.1 bis Garde de zone (UEMOA)

Trois niveaux, pour qu'une institution RDC ou CEMAC ne voie ni n'appelle jamais PI-SPI :

| Niveau | Mécanisme | Effet hors UEMOA |
|---|---|---|
| Activation du module | `ModuleRegistryService` (Angular) calcule aujourd'hui *licence ∩ santé du service* ; ajouter une 3ᵉ condition *éligibilité de zone* déclarée dans `nexora-module.registry.ts` (`zonesEligibles: ['UEMOA']`) et évaluée sur la zone de l'institution chargée au démarrage | Module absent du menu, routes bloquées par `ModuleGuard`, aucune sonde de santé lancée |
| Options dans les autres modules | Feature flag dérivé `pispiActif` (= module activé) lu par les écrans épargne (retrait PI-SPI), crédit (mode `MOBILE_MONEY`/`VIREMENT_EXTERNE` chaîné), paie (canal `PI_SPI`), commercial, portail client Angular et Flutter (retrait vers wallet, virement par alias, RIB/QR PI-SPI) | Options masquées ; les flux existants (espèces, virement interne, export CSV paie) restent seuls proposés |
| Serveur (source de vérité) | `PiSpiZoneGuard` dans le service rail : refuse toute création de participant, ordre, alias, demande de paiement et tout webhook si l'institution n'est pas UEMOA (HTTP 403, code `PISPI_HORS_ZONE`) ; épargne/crédit/paie/portail refusent de même le mode `PI_SPI`. Résultat mis en cache, invalidé à la modification de l'institution ou du pays | Aucun appel possible même en forçant l'API ; le service rail peut ne pas être déployé du tout chez un client RDC |

Conséquences :
- Déploiement RDC/CEMAC : le service `sfd-paiement-instantane-service` n'est ni licencié ni démarré ; le monolithe le charge mais la garde le neutralise.
- Plan comptable : les comptes et le journal `PIS` ne sont ajoutés qu'aux normes UEMOA (`accounting-norms/uemoa/*`), jamais aux normes `cemac` ni `rdc`.
- Wizard de setup : l'étape de paramétrage PI-SPI n'apparaît que si le pays siège choisi est UEMOA.
- Changement de pays siège d'une institution (cas rare) : désactive le module ; les ordres non terminés doivent être soldés avant.
- Extension future : la même garde, paramétrée par zone, servira à un autre rail régional (ex. système de paiement instantané BEAC en zone CEMAC) sans toucher aux modules métier.

### 4.2 Flux métier via le bus existant

Réutilise `OperationEvent` (`modePaiement`, `TresorerieInfo`, `correlationId`) et la règle de comptabilisation dual-line.

**Règle de routage** : toute opération *client* (décaissement, remboursement, dépôt, retrait, cotisation) transite **obligatoirement par le compte épargne** du client ; PI-SPI ne touche jamais directement un dossier de crédit. Seules les opérations *institutionnelles* (paie, fournisseurs, trésorerie inter-agences) partent **directement du compte bancaire / de règlement** du SFD, sans compte épargne.

| Flux | Chemin | Modules émetteurs des manches | Compte trésorerie |
|---|---|---|---|
| Dépôt externe → compte épargne | PI-SPI entrant → crédit `DAV-…` | Rail (manche trésorerie) + Épargne (manche compte client) | Compte de règlement PI-SPI « 11x » (RCSFD) / 52x (SYSCOHADA) |
| Retrait compte épargne → wallet/banque externe | Débit `DAV-…` → PI-SPI sortant | Épargne (manche compte + frais) + Rail (manche trésorerie) | idem |
| **Décaissement crédit** | 1) Crédit → compte épargne (flux existant : crédit envoie manche dossier, épargne manche compte, aucune manche rail). 2) Le client retire ensuite vers son wallet = flux « retrait » ci-dessus, déclenché automatiquement si `ModeDecaissement = MOBILE_MONEY / VIREMENT_EXTERNE` | Étape 1 : Crédit + Épargne. Étape 2 : Épargne + Rail | Étape 1 : aucun. Étape 2 : règlement PI-SPI |
| **Remboursement crédit** | 1) PI-SPI entrant → compte épargne = flux « dépôt » ci-dessus. 2) Prélèvement de l'échéance sur le compte épargne (flux existant `ModeRemboursement = PRL`, crédit + épargne) ; request-to-pay PI-SPI (`demande_paiement.write`) sert uniquement à provoquer l'étape 1 | Étape 1 : Rail + Épargne. Étape 2 : Épargne + Crédit | Étape 1 : règlement PI-SPI. Étape 2 : aucun |
| Cotisation tontine / frais adhésion / règlement commercial client | PI-SPI entrant → compte épargne, puis prélèvement interne par le module métier | Rail + Épargne, puis Épargne + module | règlement PI-SPI puis aucun |
| **Paie / RH** | Compte bancaire du SFD → bénéficiaires (bulk `paiement_groupe.write`), **sans compte épargne** ; si l'employé est aussi client, l'alias peut cibler son `DAV-…` mais le flux reste institutionnel | Rail (manche trésorerie) + Paie (manche charge/tiers 42x) | Compte bancaire SFD (114) ou règlement PI-SPI |
| Fournisseurs (achats commercial) | Compte bancaire SFD → fournisseur, unitaire ou bulk | Rail + Commercial (manche tiers) | idem Paie |
| Trésorerie inter-agences / refinancement | Compte bancaire ↔ banque | Rail + Comptabilité | idem Paie |

Conséquences :
- `ModeDecaissement.MOBILE_MONEY / VIREMENT_EXTERNE` et `ModeRemboursement.MOB / VIR` ne désignent plus un paiement direct mais un **retrait/dépôt épargne chaîné** ; le dossier de crédit ne porte jamais d'identifiant PI-SPI (`endToEndId` vit sur `OperationEpargne`).
- Le compte épargne garde la trace unique et le relevé client reste complet (argument réglementaire : traçabilité, LBC/FT, plafonds par client).
- Les flux institutionnels (paie, fournisseurs) ont un compte trésorerie distinct : `TypeCompteBancaire.COURANT` du SFD, pas le compte de règlement client. Deux positions à rapprocher séparément.
- La caisse n'intervient dans aucun flux (règle existante : la caisse ne publie que si espèces).

### 4.3 Modifications dans les modules existants

| Module | Changement |
|---|---|
| Comptabilité | Compte(s) de règlement PI-SPI dans `plan-comptable.yml` RCSFD + SYSCOHADA ; journal `PIS` ; `TypeOperationBancaire.PAIEMENT_INSTANTANE_EMIS/RECU` ; import CAMT.053 ; `CodeOperateurMobile` → référentiel participants PI-SPI (BIC/identifiant participant) |
| Épargne | Endpoint crédit/débit atomique pour le rail (réutiliser dépôt/retrait `ModeOperation.VIREMENT` avec `clientRequestId`), table alias par compte, `/portail/comptes/{n}/rib` réel (clé RIB manquante) |
| Crédit | `DecaissementRequest` : alias/IBAN/BIC (collectés par l'UI mais absents du backend) transmis à l'épargne pour le retrait chaîné après décaissement sur compte épargne ; aucun appel direct au rail. Remboursement : réception sur compte épargne puis prélèvement `PRL` existant |
| Portail client (web + Flutter) | Remplacer le stub `PortailRetraitMobileService` par un ordre PI-SPI ; virement externe par alias ; QR de réception ; corriger le chemin Flutter `virements` vs `/virements/executer` |
| Agent mobile | Collecte terrain : `modePaiement` typé, option « le client paie par PI-SPI » (request-to-pay si BCEAO l'ouvre) |
| Transfert | `TRF_NAT`/`TRF_UEM` s'exécutent sur PI-SPI (plafond 5 M, transfrontalier à partir du 01/06/2027) |
| Intégration-api | `OperationEvent.TresorerieInfo` : ajouter `endToEndId`, `participantId`, `alias` ; outbox partagé |
| KYC / LBC-FT | Pré-requis réglementaire PI-SPI : KYC formalisé, seuils, reporting CENTIF ; vérifier ce que couvre le module Client (frein n°1 des SFD selon Financial Afrik) |

## 5. Domaines d'utilisation pour un SFD

| Domaine | Usage PI-SPI | Impact |
|---|---|---|
| Épargne | Dépôt depuis mobile money / banque vers le compte épargne par alias ; retrait vers wallet 24/7 | Fin du stub retrait mobile ; collecte sans passage en agence |
| Crédit | Décaissement sur compte épargne puis retrait chaîné vers wallet/banque ; remboursement par dépôt sur compte épargne (alias ou request-to-pay) puis prélèvement d'échéance | Réduction cash, délai décaissement de jours à secondes, PAR amélioré, traçabilité complète sur le relevé épargne |
| Collecte terrain / tontine | Le client verse via PI-SPI sur le compte de collecte ; l'agent ne manipule plus d'espèces | Risque de fraude et de perte réduit |
| Transfert d'argent | Transferts nationaux puis UEMOA (2027) sans partenaire tiers | Revenus de transfert, diaspora |
| Paiement marchand | QR standardisé pour commerçants clients du SFD | Nouveau produit « compte marchand » |
| Paie / RH / fournisseurs | Règlement de masse des salaires et achats **directement depuis le compte bancaire du SFD**, sans compte épargne | Suppression des chèques et des virements manuels |
| Trésorerie | Virements inter-agences et vers banques de refinancement en temps réel | Pilotage de liquidité intraday |
| G2P / institutionnel | Réception d'aides sociales, paiement de taxes pour le compte des clients | Positionnement auprès des États |

## 6. Bénéfices et risques

### Bénéfices pour l'ERP (produit)

- **Conformité obligatoire** : SFD supervisés tenus d'ouvrir le service au 30 juin 2027 ; au 2 avril 2026, 11 SFD connectés seulement. Un ERP « PI-SPI ready » répond à une obligation que la majorité du marché n'a pas couverte.
- **Une intégration au lieu de N** : remplace les connecteurs par opérateur (Orange, MTN, Moov, Wave, T-Money) et les formats bancaires propriétaires par un standard unique ISO 20022, à coût BCEAO nul pour le participant.
- **Première exécution réelle** des modes `MOBILE_MONEY`/`VIREMENT_EXTERNE` déjà présents partout dans le code : valeur immédiate sans refonte des écrans.
- **Cohérence comptable** : s'insère dans la dual-line, la contrepartie trésorerie et le rapprochement existants.
- **Différenciation commerciale** : argument de vente face aux concurrents (cf. comparatifs `docs/comparatif-erp-sfd-*.pdf`).

### Bénéfices pour le SFD (client)

- Coûts de transaction de 5–10 % (agrégateurs) à 0–0,8 %, réception gratuite.
- Disponibilité 24/7, irrévocabilité < 10 s, plafond 5 M FCFA.
- Accès aux partenariats mobile money, au refinancement bancaire et au marché de la diaspora (conditionnés à la connexion).
- Baisse du cash en agence : sécurité, coûts de caisse, clôture journalière simplifiée.

### Risques et contraintes

| Risque | Mitigation |
|---|---|
| Exigences opérationnelles participant direct (24/7, HA, supervision, compte de règlement, certification) hors périmètre d'un ERP seul | Proposer le modèle B/C en premier ; le modèle A avec hébergement managé (Kubernetes multi-site) |
| Irrévocabilité + absence d'outbox transactionnel dans les modules financiers → risque de double crédit / perte d'ordre | Outbox + idempotence `endToEndId` avant tout flux sortant |
| Pas de clé RIB/IBAN, pas d'annuaire alias | Livrer le référentiel alias et le RIB réel dès le lot 1 |
| Plan comptable RCSFD sans compte EME/PI-SPI | Ajout de comptes + validation auditeur BCEAO |
| KYC/LBC-FT non formalisé chez beaucoup de SFD (frein principal) | Checklist conformité intégrée au module Client |
| Fraude (alias usurpé, ingénierie sociale) | Affichage nom bénéficiaire, OTP portail existant, plafonds par client, détection vélocité |
| Spécifications techniques BCEAO non publiques (sandbox API Business sur demande ; FAQ/alias inaccessibles depuis ce poste) | Demander l'accès sandbox `developer.pispi.bceao.int` et le kit participant avant le PLAN détaillé |
| Évolution tarifaire (grille revue au 02/10/2026) | Grille paramétrable, pas codée en dur |
| Fonction visible ou appelable par une institution hors UEMOA (RDC, CEMAC) | Garde de zone à 3 niveaux (§4.1 bis), tests e2e sur une base démo RDC qui vérifient l'absence totale du module et des options |

## 7. Feuille de route proposée

| Lot | Contenu | Prérequis | Durée indicative |
|---|---|---|---|
| 0. Cadrage | Accès sandbox API Business + kit participant BCEAO ; choix modèle A/B/C par SFD cible ; comptes PCSFD | Contact BCEAO / banque sponsor | 2–3 sem. |
| 1. Fondations | Outbox transactionnel, `endToEndId`, référentiel participants, alias ↔ compte, RIB réel, comptes et journal PI-SPI, import CAMT.053 | Lot 0 | 4 sem. |
| 2. Rail API Business (modèle C) | Service rail + adaptateur REST banque homologuée ; crédit entrant → épargne ; retrait portail → wallet (remplace stub) ; décaissement crédit externe | Lot 1 | 6 sem. |
| 3. Flux métier | Remboursement crédit, règlement commercial, paie bulk, transfert national ; rapprochement auto ; rapports PI-SPI | Lot 2 | 4 sem. |
| 4. Participant direct (modèle A) | Adaptateur ISO 20022 (pacs/camt/RACALIAS), mTLS/VPN, QR marchand, supervision, qualification BCEAO | SFD assujetti + hébergement HA | 8–12 sem. + certification |
| 5. Transfrontalier | Activation TRF_UEM sur PI-SPI | 01/06/2027 | 2 sem. |

Dette existante à traiter dans le même périmètre : stub `PortailRetraitMobileService`, `RIB_NOT_FOUND`, chemin Flutter `virements`, IBAN/BIC ignorés par `DecaissementRequest`, MT940/CAMT.053 rejetés, `sfd-transfert-service` sans publication RabbitMQ.

## Sources

- BCEAO, lancement officiel PI-SPI : https://www.bceao.int/fr/content/lancement-officiel-de-la-plateforme-interoperable-du-systeme-de-paiement-instantane-pi-spi
- BCEAO, connexion à PI-SPI (échéances) : https://www.bceao.int/fr/communique-presse/connexion-la-plateforme-interoperable-du-systeme-de-paiement-instantane-pi-spi-de
- BCEAO, communiqué du 1er août 2025 + liste pilote (10 SFD) : https://www.bceao.int/sites/default/files/2025-08/Communique+Annexe-Lancement_du_Syste%CC%80me_de_paiement_instantane%CC%81_31_Juillet_2025.pdf
- Sandbox API Business : https://developer.pispi.bceao.int/guides/vue-ensemble
- Nouvelles dispositions oct. 2026 (obligation 2 nov., tarifs) : https://fr.allafrica.com/stories/202610040114.html ; https://www.financialafrik.com/2026/10/04/la-bceao-rend-pi-spi-obligatoire-revoit-ses-tarifs-et-pose-enfin-la-question-de-nouveaux-services-financiers-adosses-a-la-plateforme/
- API Business homologuées : https://notreafrik.com/pi-spi-bceao-api-business-homologuees/
- Pourquoi les SFD restent à quai : https://www.financialafrik.com/2026/04/15/pi-spi-uemoa-pourquoi-les-sfd-restent-a-quai/
- Participants avril 2026 : https://financesao.com/bceao-pi-spi-participants-autorises-avril-2026/
- Fiche fonctionnelle (alias, QR, plafonds, sécurité) : https://mondedesbanques.com/culture-generale/pi-spi-tout-ce-quil-faut-savoir/
- Architecture technique (ISO 20022, mTLS, phases) : https://gracelab.io/pi-spi
- Enjeux : https://lemarche.finance/pi-spi-de-la-bceao-enjeux-et-potentiels-impacts-dun-projet-ambitieux/

## 8. Démarches : sandbox et kit participant (vérifié le 2026-10-05 sur le portail BCEAO)

### 8.1 Sandbox API Business (modèle C) — libre-service, gratuit

Portail : https://developer.pispi.bceao.int (inscription : https://developer.pispi.bceao.int/sign-in → « Créer un compte », email professionnel, accès immédiat).

Parcours officiel affiché par le portail :
1. Créer le compte (email pro).
2. Se connecter à un **participant simulateur** → génération automatique `clientId`, `clientSecret`, clé API, compte **PICERT**.
3. Se connecter à PICERT (autorité de certification BCEAO) → générer le certificat client mTLS (validité 365 j).
4. Choisir un cas d'usage (point de vente QR, e-commerce, salaires groupés, facturation / demandes de paiement) et suivre le tutoriel.
5. Intégrer et tester : playground, simulateurs clients, SDKs, webhooks signés avec retry.
6. Production : **contacter un participant homologué** de la liste officielle (la BCEAO ne distribue pas l'API aux entreprises ; c'est la banque/EME homologuée qui fournit credentials + certificats de prod).

Faits techniques (guide « Sécurité ») : OAuth 2.0 `client_credentials` sur `https://api.pispi.bceao.int/oauth/token`, token lié au certificat mTLS (certificate-bound), en-tête `X-API-Key` ; scopes `compte.*`, `alias.*`, `paiement.*`, `paiement_groupe.*`, `demande_paiement*.*` (request-to-pay unitaire et en masse), `retour_fonds.write`, `demande_annulation*.write`, `webhook.*` ; rate limit sandbox 100 req/min – 10 000/jour, prod 1 000/min – 100 000/jour (négociable) ; spécification OpenAPI homologuée. Guides disponibles : vue d'ensemble, sécurité, gestion des certificats, permissions, alias, QR code, paiements, demandes de paiement, retours & annulations, webhooks, gestion des comptes, simulateurs.

Contact sandbox : `pisfn-sandbox@bceao.int` (lien « Contact » du portail) ; support détaillé via « Centre d'aide → Nous contacter » après connexion.

### 8.2 Kit participant direct (modèle A) — pas en libre-service

Aucun kit public : la participation directe est une démarche institutionnelle du SFD (pas de l'éditeur) auprès de la BCEAO.

1. **Le SFD** (agréé, supervisé Commission Bancaire) adresse une demande d'adhésion à la **Direction Nationale BCEAO de son pays** (service systèmes et moyens de paiement), qui transmet au Siège (Dakar, Département des Systèmes et Moyens de Paiement). Courrier officiel signé DG, mentionnant l'agrément et le SI utilisé.
2. La BCEAO remet le dossier participant : règles de fonctionnement PI-SPI, spécifications techniques ISO 20022 (pacs/camt/RACALIAS), exigences sécurité (mTLS, VPN, PICERT), convention de participation, compte de règlement, plan de tests et de qualification.
3. Phases : intégration & connexion (sandbox participant) → tests & validation fonctionnelle → qualification BCEAO → mise en production + inscription sur la liste officielle des participants autorisés (https://www.bceao.int/fr/communique-presse/liste-des-participants-autorises-ouvrir-les-services-de-pi-spi-au-public).
4. Pré-requis non techniques exigés dans les faits : procédures LBC/FT et KYC formalisées, responsable conformité, reporting CENTIF, gouvernance et ratios prudentiels conformes (frein n°1 des SFD selon Financial Afrik, avr. 2026).

Pour l'éditeur ERP : s'appuyer sur un SFD client pilote déjà engagé (ou un SFD de la liste pilote : Baobab, Cofina, UM-ACEP, UM-PAMECAS) pour obtenir le kit via sa demande, ou solliciter directement la Direction Nationale au titre de **fournisseur de SI** d'un SFD candidat. Alternative sans kit : modèle B (banque sponsor) ou C (API Business) décrits en §3.

### 8.3 Actions immédiates

| # | Action | Qui | Résultat attendu |
|---|---|---|---|
| 1 | Créer le compte sandbox (email pro) sur developer.pispi.bceao.int | Éditeur | Credentials simulateur + certificat PICERT + OpenAPI |
| 2 | Exporter la spec OpenAPI et les guides (paiements, RTP, webhooks, alias) dans `sfd-docs/refs/pispi/` | Éditeur | Base du PLAN lot 1–2 |
| 3 | Écrire à `pisfn-sandbox@bceao.int` : demande d'accès participant/kit au titre de fournisseur SI pour SFD | Éditeur | Orientation vers la Direction Nationale compétente |
| 4 | Courrier d'adhésion du SFD pilote à la Direction Nationale BCEAO | SFD client | Dossier participant, convention, calendrier de qualification |
| 5 | Identifier une banque homologuée API Business (Ecobank présent dans les 8 pays) pour le modèle C en production | Éditeur + SFD | Accès production sans certification BCEAO directe |
