#!/bin/bash
# Contrôles en LECTURE SEULE avant la bascule. Ne modifie rien, n'affiche aucun secret.
set -u
. "${ENV_FILE:-$(dirname "$0")/env.local}" 2>/dev/null || true
: "${SQLSERVER_CONTAINER:=sql-server-dev}" "${PG_CONTAINER:=pg_container}" "${DEV_NETWORK:=dev-network}" "${BACKUP_ROOT:=/opt/sfd/backups/pre-pg}"
ok=0; ko=0
check() { if eval "$2" >/dev/null 2>&1; then echo "OK   $1"; ok=$((ok+1)); else echo "FAIL $1"; ko=$((ko+1)); fi; }
check "docker disponible" "docker version"
check "conteneur SQL Server en marche ($SQLSERVER_CONTAINER)" "docker inspect -f '{{.State.Running}}' $SQLSERVER_CONTAINER | grep -q true"
check "conteneur PostgreSQL en marche ($PG_CONTAINER)" "docker inspect -f '{{.State.Running}}' $PG_CONTAINER | grep -q true"
check "réseau $DEV_NETWORK présent" "docker network inspect $DEV_NETWORK"
check "espace disque libre >= 20 Go sur $(dirname "$BACKUP_ROOT")" "[ \$(df -BG --output=avail \$(dirname $BACKUP_ROOT) | tail -1 | tr -dc 0-9) -ge 20 ]"
echo "--- conteneurs sfd-*-dev (sauvegarde de leur configuration = étape 03) :"
docker ps --format '{{.Names}}' | grep -E '^sfd-.*-dev$' | sort
echo "--- PostgreSQL réseaux actuels de $PG_CONTAINER :"
docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}' "$PG_CONTAINER"
echo "RÉSULTAT: $ok OK, $ko FAIL"; [ "$ko" -eq 0 ]
