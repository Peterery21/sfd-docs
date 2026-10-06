#!/bin/bash
# Reset complet LOCAL pour la démo IFOD (autorisé par l'utilisateur pour la base locale uniquement).
# Usage : CONFIRM_RESET=yes ./00_reset_bootstrap.sh
# Étapes : 1) sauvegarde 2) arrêt des services Java 3) drop/create `sfd` 4) purge files RabbitMQ /sfd 5) purge uploads.
set -euo pipefail
[[ "${CONFIRM_RESET:-}" == "yes" ]] || { echo "Refus : exporter CONFIRM_RESET=yes"; exit 1; }
BASE_DIR="/Users/pierreadopre/Projects/erp-sfd"
SQL_CONTAINER="${SQL_CONTAINER:-sql-server-dev}"
SA_PWD="${SA_PWD:-Motdepasse@2024}"
RMQ_CONTAINER="${RMQ_CONTAINER:-rabbitmq-local}"
TS=$(date +%Y%m%d_%H%M%S)
sql() { docker exec -i "$SQL_CONTAINER" /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PWD" -I -b "$@"; }
echo "1/5 Sauvegarde"
docker exec "$SQL_CONTAINER" mkdir -p /var/opt/mssql/backup
sql -Q "BACKUP DATABASE sfd TO DISK = N'/var/opt/mssql/backup/sfd_pre_ifod_${TS}.bak' WITH COMPRESSION, INIT"
echo "2/5 Arrêt des services Java (Angular laissé)"
pkill -f 'sfd-.*-service' 2>/dev/null || true
pkill -f 'spring-boot:run' 2>/dev/null || true
sleep 5
echo "3/5 Drop + create sfd"
sql -i /dev/stdin < "$BASE_DIR/sfd-docs/demo-ifod/00_reset.sql"
echo "4/5 Purge des files RabbitMQ (vhost /sfd)"
for q in $(docker exec "$RMQ_CONTAINER" rabbitmqctl list_queues -p /sfd name -q 2>/dev/null | awk '{print $1}'); do
  docker exec "$RMQ_CONTAINER" rabbitmqctl purge_queue -p /sfd "$q" >/dev/null 2>&1 || true
done
echo "5/5 Purge des uploads"
for d in "$BASE_DIR"/sfd-*-service/upload; do
  [[ -d "$d" ]] && find "$d" -mindepth 1 -delete && echo "  vidé : $d"
done
echo "OK. Lancer ensuite 01_start_stack.sh"
