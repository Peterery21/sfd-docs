# Campagne de tests — applications mobiles et portails (17-18/10/2026)

Périmètre : application **EDIP Agent** (Flutter, simulateur iOS), écrans d'administration ERP **Agent mobile** (`/agent-mobile/*`),
application **Portail client** (Flutter, simulateur iOS), **portail client web** (Angular) et administration **Portail** de l'ERP.
Environnement : base de démo jetable `sfd_mobtest` (baseline `mob1018` = données r14 + jars et front de `develop`), monolithe `:8101`,
front ERP `:4301`, portail web `ng serve :4400`. Toutes les corrections sont sur les branches `test/mob-portail-1018` (non poussées).

## 1. Résultat par surface

| Surface | Fonctionnalités vérifiées | État |
|---|---|---|
| Admin agent mobile (ERP) | tableau de bord, agents (création, édition, collecteur lié, statut, PIN), profils et menus, produits mobiles, paramétrage (dont inactivité), opérations, QR | OK après corrections |
| App agent | config serveur, connexion, mauvais PIN, PIN réinitialisé imposé (y compris à la relance), changement de PIN, menus du profil, synchro, collecte DAV + reçu, collecte hors ligne puis resynchro, historique par journée, nouveau client (GPS), ouverture de compte (+ dépôt initial), dépôt, demande de crédit, prospect, tournée (stops crédit, refus sans compte lié), profil, déconnexion, inactivité, thèmes clair/sombre | OK après corrections |
| Admin portail (ERP) | statistiques, audit, paramétrage, utilisateurs (bloquer/débloquer/réinitialiser), sessions, publicités, inscriptions | OK après corrections |
| Portail web | connexion, tableau de bord, comptes, DAT, crédits + échéancier, demande de crédit, virements, versement tontine, Mobile Money, notifications, profil | OK après corrections |
| App client | connexion, tableau de bord, épargne/DAT/tontines, détail DAT, détail tontine, versement tontine, demande de crédit, Mes crédits, Mobile Money, virement, notifications, profil, déconnexion, thème sombre | OK après corrections |

Non vérifié dans l'app client (non bloquant, à couvrir) : inscription, OTP, mot de passe oublié, relevé PDF, documents, simulation. **Couvert le 18/10 (soir), voir section 5.**

## 2. Défauts corrigés

### Sécurité
- Routes terrain `/mobile/**` sans contrôle du jeton : n'importe quel jeton + code agent suffisait → filtre `MobileAgentTokenFilter` (401 / 403, PIN à changer bloquant).
- PIN transmis dans l'URL (réinitialisation admin et changement par l'agent) → corps JSON (ancien contrat toléré en transition).
- Route `/clients/internal/portail-info` ouverte, protégée par une clé écrite dans le code → supprimée, appel par jeton de service.
- Codes OTP du portail écrits dans les journaux au lieu d'être envoyés → envoi SMS, plus de journalisation.
- Mot de passe de réinitialisation admin devinable (`Temp@timestamp`) → aléatoire, sessions fermées.
- PIN réinitialisé contournable en relançant l'app → imposé à la reprise de session.

### Monolithe / intégration
- Jeton du portail refusé sur les routes ERP, routes portail des modules en 404, collisions de classes portail, CORS, périmètre agence crédit, journée de l'échéancier.
- Jeton mobile (UUID) propagé tel quel aux modules → 401 : remplacé par un jeton de service ; l'agence et l'agent **vérifiés** par le filtre sont propagés (la journée crédit était introuvable sans agence).

### Agent mobile
- Paramétrage en chargement infini (indicateur affiché en permanence), mauvais nom de champ, durée d'inactivité absente.
- `menusAutorises` reçu au login mais jamais appliqué : retirer un menu dans Config. Profils n'avait aucun effet.
- Agents démo non rattachés à leur collecteur : synchro sans comptes ni journée.
- Collecte datée à l'heure système au lieu de la journée comptable : historique et tableau de bord vides dès que la journée ouverte n'est pas la date du jour.
- « Collecte du jour » marquée pour toute la tournée après un seul passage ; jamais pour les DAV.
- Demande de crédit refusée (montants décimaux) sans que l'agent le voie dans le journal ; journal « N/A », « en attente » pour des opérations déjà exécutées, sans référence.
- Prospect créé sans agent ni intérêt ; motif d'un remboursement refusé affiché en JSON brut.
- App : « Ouvrir un compte » après création client sans effet (TODO), recherche client écrasée par une réponse périmée, solde du dépôt à 0, historique sans choix du jour sur liste vide, tournée inaccessible après la première collecte, cartes et textes illisibles en thème sombre, bascule clair/sombre à chaud partielle, pluriel, libellés du profil.

### Portail client
- Web : demande de crédit sans code produit, crédits et échéancier illisibles, versement tontine depuis un compte non DAV, refus non affichés, Mobile Money annoncé disponible alors qu'aucun opérateur n'est raccordé.
- Serveur : solde de tontine jamais renseigné (épargne l'expose en `soldeComptable`), erreurs non traduites, frais de virement sans jeton.
- App : mêmes défauts que le web (crédits « 0 XOF / 0.0 % », Mobile Money, versement), liste tontines (« Mise » affichant le solde, « 40/10 versements »), total tontines différent de l'accueil, détail non rechargé après versement, montant non multiple de la mise refusé sans explication, numéro du dossier remplacé par son identifiant, textes noirs en thème sombre.

## 3. Régression (Baseline → Après)

| Dépôt | Baseline | Après | Régressions |
|---|---|---|---|
| sfd-agent-mobile-service | 252 tests | 275 tests, 0 échec | 0 |
| sfd-portail-client-service | 26 | 35, 0 échec | 0 |
| sfd-epargne-service | — | 2 359 cas, 0 échec | 0 |
| sfd-credit-service | — | 644, 0 échec (14 ignorés) | 0 |
| sfd-client-service | — | 1 347, 0 échec | 0 |
| sfd-integration-api | — | 814, 0 échec | 0 |
| sfd-erp-monolith | — | 106, 0 échec | 0 |
| App agent (Flutter) | 44 | 50, 0 échec | 0 |
| App client (Flutter) | 12 | 15, 0 échec | 0 |
| sfd_shared | 43 | 43 | 0 |
| sfd-angular | build OK | build OK ; Karma agent-mobile 10/10, portail 3/3 | 0 |
| Portail web | 85 tests, 5 échecs (thème, existants sur develop) | build OK ; 86 tests, mêmes 5 échecs | 0 |
| E2E `mobile` | placeholders sans assertion | 6 scénarios réels (agent E2E, menus, jeton, PIN, écrans) : verts | 0 |

## 4. Écarts fonctionnels constatés (non corrigés, à arbitrer)

1. Schéma comptable `COLLECTE_TERRAIN_MOBILE` présent seulement en UEMOA/SYSCOHADA : en RCS_SFD (démo Togo) la collecte crédite le compte sans écriture comptable.
2. Lien agent ↔ gestionnaires crédit : API présente, aucun écran ERP.
3. Menus du profil appliqués côté application seulement (pas de contrôle serveur par route).
4. Profil d'agent = énumération figée : les profils personnalisés ne sont pas attribuables.
5. Paramétrage du portail en mémoire, 4 réglages sur 5 sans effet.
6. Demandes de documents du portail sans traitement côté ERP ; RIB non implémenté.
7. Virements limités à deux DAV du même client ; Mobile Money non raccordé à un opérateur.
8. Session du portail perdue au redémarrage du serveur.
9. ~~Branding « SFD Portail Client » non migré vers EDIP dans l'app client ; « Connexion sécurisée SSL » affiché en HTTP~~ (corrigé, section 5) ; icône de l'app agent sans libellé.
10. Comptes DAT/planifiée affectables à un collecteur mais non collectables dans l'app.
11. ~~Flows Maestro supposent l'écran de connexion~~ (autonomes et verts, section 5).
12. Données de démo : aucune journée ouverte sur certaines agences, aucun dossier crédit en retard lié à un DAV approvisionné.

## 5. Compléments du 18/10 (soir) — app client, portail web, Maestro

Environnement : base jetable `sfd_cli1018` (baseline `mob1018`, `edip-env.sh up cli1018 --port 8102 --front-port 4302`), monolithe
reconstruit avec les correctifs, portail web `ng serve --configuration local` (:4400, proxy vers :8102), app client et app agent
en build debug sur simulateur iPhone 16. Parcours exécutés à la main, au navigateur intégré et par Maestro.

### Parcours vérifiés

| Parcours | Web | App client | Résultat |
|---|---|---|---|
| Inscription → validation dans l'ERP (Portail › Inscriptions) → première connexion | ✓ (CLI006) | ✓ (CLI009, `inscription.yaml`) | OK après corrections |
| OTP de connexion (`app.portail.otp-login-enabled=true`) avec renvoi du code | ✓ | ✓ (`otp-connexion.yaml` + `otp-saisir.yaml`) | OK après corrections |
| Mot de passe oublié : code SMS → nouveau mot de passe → connexion | ✓ | ✓ (`mot-de-passe-oublie*.yaml`) | OK après corrections |
| Relevé PDF (mois, 3 mois, tout) | ✓ (PDF serveur : mouvements + synthèse) | ✓ (feuille d'impression iOS, `releve.yaml`) | OK |
| Demande de document | ✓ | ✓ (`documents.yaml`) | OK après corrections |
| Simulation de crédit par produit | ✓ | ✓ (taux 18 % du produit) | OK après corrections |
| Flows Maestro de l'app agent depuis un état vierge (login, login-pin, comptes, collecte DAV) | — | 4/4 verts, collecte enregistrée (`operation_mobile` SYNCHRONISE) | OK après corrections |

### Défauts corrigés

**Sécurité**
- Inscription acceptée pour n'importe quel code client (constaté avec `ZZZ999`) et téléphone libre : le code SMS partait au numéro saisi
  par le demandeur. Le client doit exister et le téléphone correspondre à sa fiche (8 derniers chiffres, principal ou secondaire) ;
  un client déjà inscrit ou une demande en cours est refusé. La validation n'accepte que les demandes en attente, sans doublon.
- Code OTP brute-forçable : aucune limite de tentatives. Limite à 5 essais (code brûlé ensuite). Le premier correctif ne tenait pas en
  réel : l'appelant lève `OTP_INVALIDE`, ce qui annulait le compteur par rollback. `verify` tourne maintenant dans sa propre transaction.
  Vérifié sur la base de démo : 5 codes faux, puis le bon code est refusé.
- Journal réseau des builds debug (`LogInterceptor`) : mots de passe, PIN, codes OTP et jetons en clair dans les logs de l'appareil → masqués.
- Jeton de session JWT committé dans `sfd-portail-client-angular/e2e/.test-data.json` → fichier retiré du suivi et ignoré
  (le jeton reste dans l'historique git ; il visait le VPS de dev et a expiré).

**Portail web**
- Intercepteur d'erreurs : toute erreur HTTP convertie en texte et page rechargée sur 401. Mauvais mot de passe ou code OTP faux sans
  message (l'e2e 01d enregistrait déjà « message visible : false »), message serveur remplacé par un texte générique.
- Simulation : produit saisi en texte libre et ignoré, taux fixe de 12 %. Choix du produit, taux et bornes appliqués par le serveur, erreurs affichées.
- Données inventées : « Évolution 30 jours » (courbe synthétique, +5 % du solde) sur Mes comptes, « Objectif d'épargne » de 500 000 XOF
  codé en dur sur le tableau de bord → retirés.
- Tableau de bord : une demande en instruction comptée « 1 crédit actif, encours 0 » ; encours ignorant les crédits en retard → seuls
  les crédits décaissés non soldés comptent (correctif serveur, commun à l'app).
- Documents : types et statuts en codes bruts, sans date, agence saisissable → libellés, date, agence du profil en lecture seule.
- « Coût total » affichait le total à rembourser → libellé corrigé (web et app). Étapes d'inscription décrivant une vérification SMS
  inexistante, sous-titre du mot de passe oublié erroné, aucune confirmation après réinitialisation, « Connexion sécurisée SSL 256 bits » en HTTP.

**App client**
- « Mot de passe oublié ? » sans effet (`onTap: () {}`) → écran code SMS + nouveau mot de passe.
- Documents : l'écran affichait le mot « Documents » au lieu de la liste, aucune demande possible → liste et demande.
- « Renvoyer le code » OTP : compte à rebours seulement, aucun code renvoyé → nouveau code réellement envoyé.
- Sélecteur de produit de la simulation en débordement (« RIGHT OVERFLOWED BY 31 PIXELS ») sur iPhone ; code produit envoyé au serveur.
- Échec du relevé silencieux ; erreur réseau à l'inscription affichée « Erreur lors de l'inscription » (texte en dur).
- Branding : « SFD Portail Client » / « Portail Client SFD » / « SFD Client » → EDIP Client ; textes de l'accueil et de la connexion
  traduits ; mention SSL seulement en HTTPS.

**Outillage de test**
- Portail web : `npm run e2e:portail` + `playwright.local.config.ts` (`BASE_URL`, `MONOLITH_URL`, compte `E2E_PORTAIL_*` de la baseline),
  configuration Angular `local` avec proxy. Les specs ne sont plus skippées quand la session est refusée (elles échouent). Nouvelle spec
  `06-parcours` (inscription refusée, mot de passe oublié, documents, simulation). `uat-08` (squelettes sans assertion) exclu.
- Maestro agent : un `env:` d'en-tête masque les valeurs passées par `-e` (Maestro 2.10), donc `AGENT_CODE` et `AGENT_PIN` étaient vides.
  `hideKeyboard` ouvrait le scanner QR. Cartes de compte au libellé fusionné. Les quatre flows passent.
- Maestro client : 8 flows (tableau ci-dessus, `.maestro/README.md`).

### Régression (Baseline → Après)

| Dépôt | Baseline | Après | Régressions |
|---|---|---|---|
| sfd-portail-client-service | 35 | 57, 0 échec | 0 |
| sfd-client-service | 1 416 | 1 417, 0 échec | 0 |
| sfd-erp-monolith | 106 | 106, 0 échec (jars portail et client à jour) | 0 |
| App client (Flutter) | 15 | 25, 0 échec ; analyse : 9 infos/avertissements existants | 0 |
| sfd_shared | 43 | 47 | 0 |
| App agent (Flutter) | 50 | 50 (identifiants Semantics) | 0 |
| Portail web Karma | 86 (5 échecs existants : thème) | 95, mêmes 5 échecs | 0 |
| Portail web e2e local | non exécutable (cible VPS, skips) | 35/35 | 0 |
| Portail web build production | OK | OK | 0 |

### Commits (branches `test/mob-portail-1018`, non poussés)

- sfd-client-service `2a49703` ; sfd-portail-client-service `b95267a`, `f489f07`, `edd3e3d`
- sfd-portail-client-angular `7e2b4f9d`, `7c2ad905`, `a08a0156`, `4c661bd1`
- sfd_portail_client `d64e2d6`, `8f7e775` ; sfd_shared `0560427` ; sfd-agent-mobile-flutter `2378ba3`, `a9ba96b`
- Ordre de push inchangé : client → portail-client → monolithe → portail web → sfd_shared → apps Flutter.

### Écarts restants (non corrigés)

1. Identifiants de la baseline `mob1018` (`creds.env`) différents des mots de passe de son dump : la baseline a été figée avant les
   réinitialisations de la campagne ; mots de passe réalignés à la main dans la base jetable.
2. Données démo : agents mobiles sans `code_collecteur`, collecteur 1 sans compte DAV affecté (affectés à la main pour les flows).
3. Demandes de documents sans traitement côté ERP ; RIB non implémenté (déjà noté).
4. Montants des messages serveur non formatés (« entre 50000 et 2000000 ») ; client-service injoignable ⇒ inscription refusée
   avec « client introuvable ».
5. Textes en dur (français) dans l'écran de connexion de l'app agent ; validation d'une inscription dans l'ERP sans confirmation.
6. Arbre d'accessibilité iOS de l'app client lent à se construire après réinstallation (Maestro voit un écran vide quelques secondes).

