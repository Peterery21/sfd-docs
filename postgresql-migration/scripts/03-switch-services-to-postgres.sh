#!/bin/bash
# Bascule des services *-dev sur PostgreSQL SANS reconstruire les images: chaque conteneur est recréé avec la même
# configuration + le fichier d'environnement PostgreSQL (DATABASE_URL/USER/PASSWORD/DRIVER). SQL Server n'est PAS arrêté.
# Pré-requis: 01 (sauvegarde) et 02 (PostgreSQL prêt) exécutés. Simulation par défaut; --apply pour agir.
# Arrêt au premier échec (le service fautif reste sur PostgreSQL pour diagnostic; 99-rollback.sh pour revenir).
set -euo pipefail
cd "$(dirname "$0")"; . ./lib.sh
. "${ENV_FILE:-./env.local}" 2>/dev/null || true
: "${BACKUP_ROOT:=/opt/sfd/backups/pre-pg}" "${PG_ENV_FILE:=/opt/sfd/env/sfd-pg-dev.env}"
APPLY=0; [ "${1:-}" = "--apply" ] && APPLY=1
[ -f "$PG_ENV_FILE" ] || { echo "fichier $PG_ENV_FILE absent: exécuter 02 --apply"; exit 1; }
[ -f "$BACKUP_ROOT/LATEST" ] || { echo "aucune sauvegarde SQL Server enregistrée: exécuter 01"; exit 1; }
CFG="$BACKUP_ROOT/$(basename "$(cat "$BACKUP_ROOT/LATEST")")/containers"
for s in "${SERVICES[@]}"; do
  IFS='|' read -r n port ctx <<<"$s"
  if ! docker inspect "$n" >/dev/null 2>&1; then echo "absent: $n (ignoré)"; continue; fi
  if [ $APPLY -eq 0 ]; then echo "[simulation] sauvegarde config + recréation de $n avec $PG_ENV_FILE, attente santé $port$ctx"; continue; fi
  [ -f "$CFG/$n.args" ] || save_container "$n" "$CFG"
  recreate_container "$n" "$CFG" "$PG_ENV_FILE"
  wait_started "$n" "$port" "$ctx" 300 && discard_old "$n"
done
echo "terminé. Vérifier: ./04-verify.sh"
