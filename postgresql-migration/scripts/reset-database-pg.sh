#!/bin/bash
# Remise à zéro de la base PostgreSQL 'sfd' (équivalent de demo-ifod/00_reset.sql pour SQL Server).
# Sauvegarde pg_dump d'abord, puis DROP/CREATE DATABASE. Simulation par défaut; --apply pour agir.
set -euo pipefail
. "${ENV_FILE:-$(dirname "$0")/env.local}" 2>/dev/null || true
: "${PG_CONTAINER:=pg_container}" "${PG_ADMIN_USER:=root}" "${PG_DATABASE:=sfd}" "${PG_APP_USER:=sfd_app}" "${BACKUP_ROOT:=/opt/sfd/backups/pg-reset}"
: "${PG_ADMIN_PASSWORD:?exporter PG_ADMIN_PASSWORD (saisie interactive)}"
APPLY=0; [ "${1:-}" = "--apply" ] && APPLY=1
TS=$(date +%Y%m%d-%H%M%S)
psqlc() { docker exec -e PGPASSWORD="$PG_ADMIN_PASSWORD" "$PG_CONTAINER" psql -v ON_ERROR_STOP=1 -U "$PG_ADMIN_USER" -d postgres -Atc "$1"; }
if [ $APPLY -eq 0 ]; then echo "[simulation] pg_dump de $PG_DATABASE vers $BACKUP_ROOT/$TS puis DROP/CREATE DATABASE $PG_DATABASE (propriétaire $PG_APP_USER)"; exit 0; fi
mkdir -p "$BACKUP_ROOT/$TS"; chmod 700 "$BACKUP_ROOT" "$BACKUP_ROOT/$TS"
docker exec -e PGPASSWORD="$PG_ADMIN_PASSWORD" "$PG_CONTAINER" pg_dump -U "$PG_ADMIN_USER" -Fc "$PG_DATABASE" > "$BACKUP_ROOT/$TS/$PG_DATABASE.dump"
( cd "$BACKUP_ROOT/$TS" && sha256sum ./*.dump > SHA256SUMS )
psqlc "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$PG_DATABASE' AND pid <> pg_backend_pid()" >/dev/null
psqlc "DROP DATABASE IF EXISTS $PG_DATABASE"
psqlc "CREATE DATABASE $PG_DATABASE OWNER $PG_APP_USER ENCODING 'UTF8' TEMPLATE template0"
echo "base $PG_DATABASE recréée (sauvegarde: $BACKUP_ROOT/$TS). Redémarrer les services pour recréer le schéma (commun d'abord)."
