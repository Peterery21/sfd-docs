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

Non vérifié dans l'app client (non bloquant, à couvrir) : inscription, OTP, mot de passe oublié, relevé PDF, documents, simulation.

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
9. Branding « SFD Portail Client » non migré vers EDIP dans l'app client ; « Connexion sécurisée SSL » affiché en HTTP ; icône de l'app agent sans libellé.
10. Comptes DAT/planifiée affectables à un collecteur mais non collectables dans l'app.
11. Flows Maestro (appId corrigé) supposent l'écran de connexion : à rendre autonomes (`launchApp`, `clearState`).
12. Données de démo : aucune journée ouverte sur certaines agences, aucun dossier crédit en retard lié à un DAV approvisionné.
