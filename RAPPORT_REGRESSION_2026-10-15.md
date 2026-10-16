# Rapport de régression — corrections monolithe / Épargne / Crédit (15-16 octobre 2026)

Environnement de test : base jetable `sfd_regr` (clone de la baseline démo r12, Togo), monolithe rebuild (`r13`), front monolithe statique, vhost RabbitMQ `regr` dédié, journée comptable ouverte 14/10/2026, session caisse AG001 ouverte. Identifiants dans `~/.edip-baselines/r13/creds.env`, jamais dans le dépôt.

## 1. Cause racine principale : listeners RabbitMQ désactivés dans le monolithe

| Constat | Preuve |
|---|---|
| `spring.rabbitmq.listener.{simple,direct}.auto-startup` valait `${RABBITMQ_LISTENER_AUTO_STARTUP:false}` dans `application.yml` et `application-prod.yml` du monolithe ; aucun lanceur (`start-monolith.sh`, Jenkinsfile, docker-compose) ne positionnait la variable. | VPS, vhost `/sfd_monolith` : 11 messages bloqués sur `q.comptabilite.lignes`, `q.epargne.operations`, `q.caisse.operations`, 0 consommateur. Local, vhost `/` : 6 messages bloqués, 0 consommateur. |
| En monolithe les flux restent asynchrones (aucun pont in-process) : solde caisse + brouillard + manche caisse = consommateur caisse ; crédit du DAV au décaissement = consommateur épargne ; pièce comptable = consommateur comptabilité. | Avant correctif : ouverture de compte / dépôt espèces sans mouvement caisse, décaissement sans écriture. |
| Vhosts incohérents : monolithe dev `/`, prod `/sfd`, Jenkins `/sfd_monolith`, microservices `/sfd`. | Lecture des `application*.yml`. |

Correctif (`sfd-erp-monolith`) : listeners actifs par défaut (`:true`), vhost par défaut `/sfd`, Jenkinsfile `RABBITMQ_LISTENER_AUTO_STARTUP: 'true'` (vhost `/sfd_monolith` conservé), `start-monolith.sh` exporte les deux variables, `server.forward-headers-strategy: framework`. Garde-fous : indicateur de santé `rabbitListeners` (DOWN si un conteneur est arrêté alors que les listeners sont activés) et rapport ERROR au démarrage ; convertisseur JSON sur la fabrique de listeners par défaut (les listeners chat recevaient des octets bruts : 4 rejets fatals au premier démarrage, 0 après correctif).

Preuve live après rebuild : `/actuator/health` → `rabbitListeners: UP, containers: 20` ; 2 consommateurs sur chaque file métier du vhost `regr` ; files vides après chaque opération.

**Action VPS restante (à faire au déploiement)** : purger les 11 messages périmés du vhost `/sfd_monolith` (et `/` en local) avant/après mise en service, sinon ils seront rejoués au premier démarrage avec listeners.

## 2. Résultats par point signalé

| # | Point signalé | Cause racine | Correctif | Tests unitaires | E2E / navigateur |
|---|---|---|---|---|---|
| 1 | Ouverture de compte (versement initial espèces) ne touche pas la caisse | Listeners monolithe (§1). Épargne publie `operation.depot` après commit ; échec de publication seulement journalisé. | §1 + garde-fous épargne : échec de publication après commit → saga ECHEC + opération non aboutie (`PublicationEchecService`) ; ESPECES sans session caisse résolue → `caisse.session.introuvable` au lieu d'un WARN | épargne 2299 → 2322 ; caisse 1599 → 1602 (3 tests dual-line ESPECES) | Navigateur : ouverture DAV-2026-000008, 25 000 espèces → solde session 1 340 000 → 1 365 000, ligne 5 au brouillard, pièce `CA-202610-000001` déversée (25 000 / 25 000). Spec `epargne-ouverture-depot-caisse.spec.ts` (ouverture + dépôt) vert. |
| 2 | Dépôt sur compte absent du brouillard et de la compta | Idem | Idem | Idem | Navigateur : dépôt 10 000 → 1 375 000, ligne 6 brouillard, pièce `CA-202610-000002`. |
| 3 | DAT échu non reversé (date du jour vs journée comptable) | Aucun job d'échéance n'existait ; `LocalDate.now()` partout (`DepotATerme`, `DatService`, ouverture DAT, Angular). | Job `DAT_ECHEANCES` (quotidien 02:30, `DatEcheanceService`), endpoint manuel `POST /dat/echeances/traiter?codeAgence=`, date = `resolveDateJourneePourBatch(agence)` ; flag produit `reversementAutoEcheance` (défaut vrai) ; jours restants Angular calculés sur la journée comptable. | épargne +9 (`DatEcheanceServiceTest`, `DatServiceTest`, route) | API : DAT échéance 14/10 (journée comptable) et DAT déjà A_ECHEANCE → `{examines:2, passesAEcheance:1, rembourses:2}` ; comptes 5 000 000 → 6 505 813 et 200 000 → 705 625 ; pièces `OD-…001..004` (capital + intérêts). DAT-006 ajouté à `05-dat-tontine-integration.spec.ts`. |
| 4 | Affectation collecte : plusieurs comptes, pas de doublon | `save` terminait silencieusement l'affectation existante du même agent (TRANSFERT) ; un seul compte par saisie. | `POST /tontine/collecte/affectations/lot` transactionnel ; doublon même agent/compte → `affectation.compte.deja.affectee.agent` (API et lot) ; écran : liste de comptes (chips), refus doublon dans la liste et déjà affecté. | épargne (+2 service, +1 contrôleur) | Navigateur : 2 comptes en un enregistrement (12 → 14 affectations), message « Ce compte est déjà dans la liste de sélection », API 400 sur doublon. Spec `collecte-affectation-multi.spec.ts` vert. |
| 5 | Frais de crédit : tous les comptes du système listés | `compte-epargne-search-input` interrogeait les comptes tontine sans filtre client. | Entrées `clientOnly` + `typeProduit` ; la modale frais liste uniquement les DAV actifs du client ; numéro saisi d'un autre client rejeté. | — (backend déjà bloquant `COMPTE_EPARGNE_CLIENT_INVALIDE`) | Spec `credit-paiement-frais.spec.ts` (skip si aucun frais à payer dans la démo). |
| 6 | Remboursement : cocher les échéances dues, compte DAV présélectionné | Sélection pilotée par le montant (cases désactivées), compte en texte libre. | Mode `modeSelection=ECHEANCES` (préfixe chronologique obligatoire, montant calculé serveur, `ECHEANCES_INVALIDES` / `MONTANT_INCOHERENT`), `GET /paiements/remboursements/echeances-dues`, `compteVersement` exposé ; cases cochables, montant = somme, `<select>` des DAV du client présélectionné (`compteEpargneLinke ?? numeroCompteEpargne ?? compteVersement`). | crédit +6 (`PaiementServiceImplTest`) | Navigateur : CR-2026-000005, case échéance 6 → 131 333 calculé, mode espèces → échéance payée, caisse +131 333 (op. 7), pièce `RM-202610-000001`. Spec remboursement étendu. |
| 7 | `CREDIT.GARANTIE.null` | `garantieRequise` nul (jamais saisi) + clés manquantes. | Règle « garantie requise » du produit supprimée (voir §3) ; la demande liste les lignes de l'onglet Garanties ; clés i18n des types ajoutées. | crédit (`ProduitGarantieRegleServiceTest`) | Navigateur : « Garanties requises : Nantissement compte épargne — 10 % — Obligatoire — Caution auto EP08 » ; produit sans ligne → « Aucune garantie ». |
| 8 | Caution : produit caution, compte caution, prélèvement DAV, libération au solde | Fonction absente. | Ligne de l'onglet Garanties de catégorie FINANCIÈRE avec `codeProduitEpargneCaution` ; au décaissement : compte caution ouvert/réutilisé, virement DAV → caution (`CAU-<dossier>-<ligne>`), garantie du dossier créée (`numeroCompteCaution`, `montantBloque`) ; mainlevée (manuelle ou automatique au SOLDE) → virement retour (`LIB-CAU-<garantie>`). Comité : ligne caution ignorée pour l'obligation, contrôle du solde DAV (`CAUTION_SOLDE_INSUFFISANT`). | crédit 1416 → 1421 (`CautionCreditServiceImplTest` réécrit, `GarantieServiceImplTest`, `ProduitGarantieRegleServiceTest`) | Spec `credit-cycle-caution.spec.ts` : décaissement 100 000 sur CT-TRESO (10 %) → compte `CAU-2026-000001` = 10 000, DAV = avant + 100 000 − 10 000 − frais, pièce `corr-decaissement-DEC-202610-000002` équilibrée, garantie `Nantissement compte épargne` 10 000 bloqués ; mainlevée API → caution 0, DAV +10 000, garantie LIBEREE, `montantCaution` 0, pièce `OD-202610-000002`. Restitution au SOLDE non rejouée (échéances non échues dans la démo). |
| 9 | Décaissement : compte crédit + DAV en contrepartie, aucune écriture | Compte crédit déjà créé (`synchroniserCompteCredit`) ; crédit du DAV et pièce dépendaient des listeners (§1) ; compte destination nul accepté puis ignoré silencieusement par l'épargne. | §1 + `COMPTE_DESTINATION_OBLIGATOIRE` / `COMPTE_DESTINATION_INVALIDE` / `EPARGNE_INDISPONIBLE` ; côté épargne, événement sans compte → non aboutie + DLQ. | crédit +5 (`DossierCreditServiceImplTest`), épargne +3 | Décaissement du cycle caution : 3 lignes (manche dossier + manche épargne), pièce `DB-202610-000002`. |
| 10 | Monolithe : URL serveur non automatique | `app.host.url` figé à `http://localhost:8080`, renvoyé tel quel par `/public/config/server-info`. | L'URL est dérivée de la requête (X-Forwarded-* honorés) quand la valeur configurée est vide ou `localhost` ; appels internes sur `${server.port}`. | commun 902 (4 tests `ConfigControllerTest`) | API : `X-Forwarded-Host: edip.example.org` → `https://edip.example.org` ; écran QR Code Mobile pré-rempli avec l'URL réelle (`http://localhost:8100` dans l'env de test au lieu de 8080). |
| 11 | Flutter agent mobile : 401 | `MonolithSecurityConfig.PUBLIC_ENDPOINTS` sans `/api/agent-mobile/auth/mobile/**` ; configs de sécurité des services exclues du scan ; chaîne `X-Service-Key` absente. | Chemins publics ajoutés + chaîne interne `MonolithAgentMobileInternalSecurityConfig` (épargne, crédit, client, comptabilité). | monolithe 74 → 75 (`MonolithSecurityChainsTest`, `MonolithAgentMobileInternalChainTest`) | `POST /api/agent-mobile/auth/mobile/login` → erreur métier « Agent non trouvé » (plus de 401). Non testé avec l'application Flutter réelle. |
| 12 | WARN audit `ByteBuddyInterceptor` | ObjectMapper par défaut du monolithe sans `Hibernate6Module`, `FAIL_ON_EMPTY_BEANS` actif (configs Jackson des services exclues). | `MonolithJacksonConfig` (Hibernate6Module) + `fail-on-empty-beans: false`. | monolithe (`MonolithJacksonConfigTest`) | 0 occurrence du WARN dans le journal de l'env rebuild (décaissements et frais audités). |
| 13 | Vhost RabbitMQ du monolithe | Voir §1 (défauts `/` vs `/sfd` vs `/sfd_monolith`, listeners off). | §1 | `MonolithRabbitDefaultsTest` (3), `MonolithRabbitListenersConfigTest` (9) | Live : consommateurs présents, files vides. |

## 3. Décision de modèle : garanties du produit

Validé avec l'utilisateur : l'onglet **Garanties** du produit (`ProduitGarantie`) est la seule source de règles. Supprimés : `ProduitCredit.garantieRequise`, `ratioGarantie` et la règle comité `verifierGarantieRequiseProduit` (le loader démo crée une ligne obligatoire par produit avec `tauxCouvertureMin = ancien ratio`), ainsi que les champs produit `codeProduitCaution` / `tauxCautionPct` introduits la veille. La caution est une ligne FINANCIÈRE de l'onglet (`codeProduitEpargneCaution`, taux = taux de couverture). `TypeGarantieEnum` supprimé. Colonnes orphelines conservées en base (`ddl-auto: update` ne supprime pas).

Prérequis de paramétrage pour une caution : le type de garantie FINANCIÈRE doit avoir un compte comptable par type de client (`TypeGarantieCompteConfiguration`), sinon `GARANTIE_COMPTE_NON_PARAMETRE` bloque le décaissement avant tout mouvement de fonds. La démo Togo n'en a aucun : le spec e2e complète la configuration (compte 165).

## 4. Synthèse des suites (sorties fraîches de cette campagne)

| Dépôt | Baseline → Après | Régressions |
|---|---|---|
| sfd-epargne-service | 2299 → 2322, 0 échec | 0 |
| sfd-caisse-service | 1599 → 1602, 0 échec | 0 |
| sfd-credit-service | 1416 → 1421, 0 échec (6 erreurs de contexte en baseline, absentes après) | 0 |
| sfd-commun-service | 902, 0 échec | 0 |
| sfd-integration-api | tests unitaires `EpargneRestClientTest` verts (+4) ; `CaisseRestClientIT` failsafe préexistant non lié | 0 |
| sfd-erp-monolith | 74 → 75, 0 échec | 0 |
| sfd-angular | `npm run build` 0 erreur ; e2e projet `credit` sur l'env rebuild : 44 réussis / 5 ignorés / 0 échec ; nouveaux specs épargne (`epargne-ouverture-depot-caisse`, `collecte-affectation-multi`) : 3/3 verts ; projet `epargne` (1er passage, env précédent) : 69 réussis, 3 échecs dont 2 tontine préexistants (voir §5), 12 non exécutés | 0 |

## 5. Points non vérifiés / restes

- E2E épargne : la chaîne UAT tontine (`epargne-tontine-uat.spec.ts`, 16 cas) et sa vidéo récap échouent aussi sur la **baseline r12 avec le jar d'avant la campagne** (`FCT-TON-008 attribuer cagnotte` : `toBeTruthy` faux, puis `FCT-TON-011` sur le jar rebuild) → défaut préexistant / dépendant des données démo, hors périmètre de cette campagne. Le 3e échec du premier passage (`collecte-affectation-multi`) est corrigé (vert).
- Spec `credit-cycle-caution` : la restitution au passage SOLDE n'est pas rejouée (échéances non échues) ; restitution vérifiée par mainlevée API. Spec `credit-paiement-frais` ignoré faute de frais à payer dans la démo.
- Application Flutter réelle non exercée (contrôle API seulement).
- Rejeu VPS : build Jenkins, Sonar, santé conteneur et purge des files `/sfd_monolith` à faire après push.
- Pas de migration SQL de suppression des colonnes orphelines (`garantie_requise`, `ratio_garantie`, `code_produit_caution`, `taux_caution_pct`).

## 6. Complément (16/10) : contrepartie du décaissement et comptes du client

Demande : la contrepartie du décaissement doit être le compte crédit du dossier, visible avec son solde dans les comptes auxiliaires du client ; le compte caution doit apparaître dans les comptes épargne du client ; regrouper les comptes épargne entre eux et les auxiliaires entre eux.

| Constat | Correctif | Preuve |
|---|---|---|
| La ligne débit du décaissement portait le compte général 13xx dans `numeroCompte` ; le n° du compte crédit (auxiliaire `AUXCR-…`) n'était sur aucune ligne. | Crédit : lignes sur le compte créance (décaissement D, remboursement capital C, passage en perte C) portent `numeroCompte` = n° du compte crédit, `compteGeneral` = 13xx inchangé ; `normaliser` ne réécrit plus `numeroCompte`. | crédit 1421 → 1425, 0 régression |
| Les soldes `compte_auxiliaire` n'étaient alimentés par rien (projection forcée à 0, déversement sans mise à jour, recalcul sur un code jamais égal) : l'onglet « Comptes auxiliaires » du client affichait 0 partout. | Comptabilité : au déversement de chaque pièce, pour toute ligne dont `numeroCompte` = `codeAuxiliaire` d'un auxiliaire, incrément débit/crédit (UPDATE atomique) et `LigneEcriture.codeAuxiliaire` = n° de compte ; recalcul par auxiliaire aligné (`codeAuxiliaire OU numeroCompte`) ; nouveau `POST /comptes-auxiliaires/recalculer-soldes` (rattrapage des bases existantes). Les balances auxiliaires s'appuient sur `codeAuxiliaire` : les comptes épargne/crédit y apparaissent désormais. | compta 1664 → 1670 (1 échec préexistant `NoHardcodedCompteGeneralTest`, qui scanne un autre dépôt). Live après cycle caution : `AUXCR-000001` D 100 000 ; `CAU-2026-000001` C 10 000 ; DAV D 10 000 / C 95 000 ; recalcul global 9 251 traités, 0 modifié. |
| Onglet « Comptes épargne » du client filtré sur DAV : la caution (`CAU-…`) invisible. | Onglet regroupé par type (DAV, Caution, DAT, Planifié, Tontine…) ; onglet « Auxiliaire » regroupé par module (Épargne / Crédit) et par type avec solde net et totaux. | Navigateur CLI001 : sections Compte à vue (610 000 dispo), Caution (10 000), Planifiée ; auxiliaires : groupe Épargne net 95 000 (DAV 85 000 + caution 10 000), groupe Crédit net 100 000 (`AUXCR-000001`), garantie `AUXGA-000001`. Spec `client-comptes-caution.spec.ts` vert (3/3). |

Limites : les soldes auxiliaires ne couvrent que les pièces déversées (les données de démo seedées hors déversement restent à 0 côté compta, le solde épargne réel reste dans l'onglet épargne) ; la ligne GARANTIE_FINANCIÈRE de la caution reste une ligne distincte (engagement comptable), référence de garantie affichée.

## 7. Complément (16/10) : onglet « Comptes » du détail client réorganisé

Décision (option A validée) : 2 sous-onglets au lieu de 5.
- **Comptes épargne** : bandeau de synthèse (total épargne, bloqué = caution + DAT actifs, disponible), puis sections avec leurs colonnes et actions propres : à vue, caution (dossier crédit lié), dépôts à terme (taux, échéance, jours restants), épargne planifiée (progression), tontines (mise, fréquence, tour). Les sources dédiées (DAT, plans, tontines) alimentent leurs sections ; pas de doublon avec la liste épargne.
- **Comptabilité** (ex-« Auxiliaire ») : image comptable groupée Épargne / Crédit / Garanties, soldes débit-crédit-net et totaux.
- Sous-onglets DAT, Plans, Tontines supprimés ; clés i18n correspondantes retirées.

Preuves : spec du composant 14/14 ; e2e projet `client` sur l'env rebuild : 52 réussis, 3 ignorés (données démo), 4 échecs **identiques sur la baseline r12 avant la campagne** (`client-detail` nom de jeune fille ×2, `client-rapports` sélection rapport, `perf-appels-api` seuil 15 appels) → préexistants, hors périmètre. Navigateur CLI001 : synthèse 3 675 000 / bloqué 2 500 000 / disponible 525 000, sections À vue (1), DAT (2), Planifiée (1), Tontine (3) ; sous-onglet Comptabilité avec hint et groupes.

## 8. Déploiement (16/10)

Poussé sur `develop` dans l'ordre de dépendance, chaque dépôt validé avant push (package, suite complète, démarrage sans profil + santé UP), puis vérifié (Jenkins, Sonar, VPS).

| Dépôt | Commit(s) | Tests | Jenkins | Sonar |
|---|---|---|---|---|
| sfd-integration-api | `619fe58` | 813 | SUCCESS | OK |
| sfd-commun-service | `3971500` | 173 | SUCCESS | OK |
| sfd-epargne-service | `74af4e5` | 805 | SUCCESS | OK |
| sfd-caisse-service | `4d04bdc` | 187 | SUCCESS | OK |
| sfd-comptabilite-service | `3e53a46`, `5c98232` | 1407 (1 échec préexistant `NoHardcodedCompteGeneralTest`, scanne `sfd-budget-service`) | SUCCESS | OK |
| sfd-credit-service | `3e2c161` | 547 | SUCCESS | OK |
| sfd-erp-monolith | `d91817e`, `4bf4975` | 75 | UNSTABLE (seule condition : 2 hotspots CSRF à revoir) | 3 violations corrigées |
| sfd-angular | `2a20684`, `e8532ee` | build 0 erreur TS ; e2e crud client/épargne/crédit 582 OK ; projet `credit` 44 OK | en cours au moment de la rédaction | — |

Correctifs ajoutés pendant le déploiement :
- **Remboursement crédit** (demande utilisateur) : la saisie du montant est rétablie à côté de la sélection des échéances. Montant saisi = mode `MONTANT` (répartition simulée, anticipation, montant non alloué) ; cocher une échéance échue = mode `ECHEANCES` (total recopié dans le montant). Toutes les échéances non payées sont listées, seules les échues sont cochables. Vérifié en navigateur sur base jetable : remboursement par échéance (461 111) et par montant (100 000) enregistrés avec reçu.
- **Recalcul des soldes auxiliaires** : une requête agrégée au lieu d'une requête + sauvegarde + audit par compte (9 250 comptes en base démo : plusieurs minutes auparavant) ; écriture et audit seulement si le solde change.
- **Monolithe** : violations Sonar du nouveau code (principal agent-mobile sans secret littéral, nullité redondante, assertions chaînées).

VPS (`sfd-erp-monolith-dev`, image 33) : santé UP, `rabbitListeners` UP (20 conteneurs), 2 consommateurs sur `q.comptabilite.lignes`, `q.epargne.operations`, `q.caisse.operations`, `q.client.operations`.

Messages périmés du vhost `/sfd_monolith` (91 : 11 lignes comptables, 20 × 4 opérations) : le conteneur de l'image 31 a démarré à 05:08 UTC et les a consommés à 05:09, **avant** la purge, exécutée ensuite sur des files déjà vides. Effets appliqués : soldes de session caisse SES-202612-020, répartitions collecteur et crédit d'un DAV au décaissement côté épargne, 33 lots de lignes comptables reçus. Ce sont des opérations réellement saisies pendant que les listeners étaient éteints.

Recalcul `POST /api/comptabilite/comptes-auxiliaires/recalculer-soldes` exécuté sur le VPS (session admin) : 992 comptes traités, 1 modifié, 253 ms.

Restes :
- Revue des 2 hotspots CSRF du monolithe dans SonarQube (`MonolithSecurityConfig`, `MonolithAgentMobileInternalSecurityConfig`).
- `q.sfd.operations` n'a volontairement aucun consommateur en monolithe (chaque module lit `q.<module>.operations`) ; si elle reste liée à l'échange `sfd.operations`, elle accumule des messages.
- Échecs e2e préexistants (identiques sur la baseline r12) : `client-cdc-extensions` ×4, `client-compte-ouverture-validation`, `credit-parcours-crud` RBT-CRE-003 et SVC-CRE-003.
