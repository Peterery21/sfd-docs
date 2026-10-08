#!/bin/bash
# Retour arrière: recrée chaque conteneur depuis la configuration sauvegardée AVANT la bascule (SQL Server).
# SQL Server n'a jamais été arrêté ni modifié: aucune restauration de données n'est nécessaire (la base 'sfd' PostgreSQL
# reste en place pour analyse). Simulation par défaut; --apply pour agir.
set -euo pipefail
cd "$(dirname "$0")"; . ./lib.sh
. "${ENV_FILE:-./env.local}" 2>/dev/null || true
: "${BACKUP_ROOT:=/opt/sfd/backups/pre-pg}"
APPLY=0; [ "${1:-}" = "--apply" ] && APPLY=1
CFG="$BACKUP_ROOT/$(basename "$(cat "$BACKUP_ROOT/LATEST")")/containers"
for s in "${SERVICES[@]}"; do
  IFS='|' read -r n port ctx <<<"$s"
  [ -f "$CFG/$n.args" ] || { echo "pas de configuration sauvegardée pour $n (ignoré)"; continue; }
  if [ $APPLY -eq 0 ]; then echo "[simulation] recréation de $n avec sa configuration d'origine"; continue; fi
  recreate_container "$n" "$CFG"
  wait_started "$n" "$port" "$ctx" 300 && discard_old "$n" || true
done
