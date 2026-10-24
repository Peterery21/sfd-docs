# Règles communes à toutes les sessions de la refonte reporting (S1 à S8)

`<WT>` = `/Users/pierreadopre/Projects/erp-sfd/.claude/worktrees/reporting-reglementaire-refonte-7f5c77` (worktree de l'orchestrateur, en lecture seule pour vous).

À lire avant de commencer :
- le handoff `<WT>/.claude/handoff/reporting-refonte.md` ;
- le contrat d'API et le format des paquets `<WT>/sfd-docs/reglementation/REPORTING_API_CONTRAT.md` (v1.1). Ce contrat est obligatoire : on ne s'en écarte pas sans demander à l'orchestrateur.

## Git
- Vous travaillez dans votre propre worktree d'erp-sfd. Les dossiers `sfd-*` y sont vides, car ce sont des dépôts séparés. Créez le worktree du sous-dépôt dont vous avez besoin :
  `git -C /Users/pierreadopre/Projects/erp-sfd/<repo> worktree add <votre-wt>/<repo> -b feature/reporting-refonte-<flux> feature/reporting-refonte`
  (si la branche existe déjà, retirez `-b`).
- Commits locaux sur `feature/reporting-refonte-<flux>` uniquement. **Ne poussez jamais**, ne fusionnez pas, ne touchez pas `develop`. L'orchestrateur fusionne.
- Ne touchez qu'au périmètre de fichiers de votre brief. Si un fichier hors périmètre doit changer, signalez-le dans votre rapport au lieu de le modifier.

## Machine (ressources limitées)
- Toute commande lourde (`./mvnw`, `scripts/claude/regress.sh`, `npm run build`, `npx playwright`, `./dev.sh start`) se lance sous le verrou :
  `L=/tmp/edip-heavy.lock; until mkdir $L 2>/dev/null; do p=$(cat $L/pid 2>/dev/null); [ -n "$p" ] && ! kill -0 $p 2>/dev/null && rm -rf $L; sleep 60; done; echo $$ > $L/pid; trap 'rm -rf /tmp/edip-heavy.lock' EXIT; <commande>; rm -rf $L; trap - EXIT`
  Le PID du détenteur est écrit dans le verrou : si ce processus est mort (verrou orphelin), un attendant le libère tout seul. Ne tenir le verrou que pendant la commande lourde ; le libérer entre deux services.
  Au-delà de 20 min d'attente, arrêtez et signalez-le.
- Lancez d'abord les tests ciblés (`scripts/claude/regress.sh <service> -Dtest=…`), puis la suite complète, une seule fois, avant de rendre.
- Ne démarrez un service que pour un test dont vous avez besoin, et arrêtez-le ensuite (`./dev.sh stop`).

## Qualité (CLAUDE.md racine)
- Contrôle de régression obligatoire. Notez la baseline de la suite avant votre premier changement, puis celle d'après. Un test qui était vert doit rester vert. Ne désactivez et n'affaiblissez jamais un test.
- Réutilisez les patterns existants du service (nommage, couches, tests).
- Aucun secret ni identifiant dans le dépôt ou dans les messages.
- Angular : composants partagés `sfd-angular/src/app/shared/` obligatoires (`app-modal-shell`, `app-confirm-modal`, jamais `Swal.fire` ni `confirm()` ; sélecteurs compte, agence, exercice ; `ProcessingService` et `app-busy-area`). Lisez `sfd-angular/CLAUDE.md`.
- Comptabilité : lisez `/Users/pierreadopre/Projects/erp-sfd/.claude/docs/compta-dual-line.md` avant de toucher aux comptes. Aucun compte inventé ou déduit par analogie : un compte doit avoir sa source dans `sfd-docs/reglementation/`.

## Rapport final (≤ 400 caractères, format fixe, une ligne)
`ST:done|wip|block FAIT:<1 ligne> FICHIERS:<chemins> BRANCHE:refs/heads/feature/reporting-refonte-<flux> SHA:<court> TESTS:<avant→après> SUIVANT:<1 ligne> BLOQUÉ:<cause>`
Mettez le détail utile (écarts, décisions, lacunes) dans `<votre-wt>/.claude/handoff/reporting-refonte-<flux>.md`, sans le recopier dans le message.
- Ajoutez dans votre handoff une section « Points à valider par un comptable / ambiguïtés » (question, choix provisoire, source).
