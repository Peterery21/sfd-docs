#!/bin/bash
# Sauvegarde complète de la base SQL Server AVANT bascule, copiée hors conteneur, avec somme de contrôle.
# Mot de passe SA: variable SQLSERVER_SA_PASSWORD (jamais écrite dans un fichier, jamais affichée).
set -euo pipefail
. "${ENV_FILE:-$(dirname "$0")/env.local}" 2>/dev/null || true
: "${SQLSERVER_CONTAINER:=sql-server-dev}" "${SQLSERVER_DATABASE:=sfd}" "${BACKUP_ROOT:=/opt/sfd/backups/pre-pg}"
: "${SQLSERVER_SA_PASSWORD:?exporter SQLSERVER_SA_PASSWORD (saisie interactive)}"
TS=$(date +%Y%m%d-%H%M%S); DEST="$BACKUP_ROOT/$TS"; BAK="/var/opt/mssql/backup/${SQLSERVER_DATABASE}-pre-pg-$TS.bak"
mkdir -p "$DEST"; chmod 700 "$BACKUP_ROOT" "$DEST"
SQLCMD=$(docker exec "$SQLSERVER_CONTAINER" sh -c 'ls /opt/mssql-tools*/bin/sqlcmd | head -1')
docker exec "$SQLSERVER_CONTAINER" mkdir -p /var/opt/mssql/backup
docker exec -e SQLCMDPASSWORD="$SQLSERVER_SA_PASSWORD" "$SQLSERVER_CONTAINER" "$SQLCMD" -S localhost -U sa -C -b \
  -Q "BACKUP DATABASE [$SQLSERVER_DATABASE] TO DISK = N'$BAK' WITH COMPRESSION, CHECKSUM, INIT"
docker exec -e SQLCMDPASSWORD="$SQLSERVER_SA_PASSWORD" "$SQLSERVER_CONTAINER" "$SQLCMD" -S localhost -U sa -C -b \
  -Q "RESTORE VERIFYONLY FROM DISK = N'$BAK' WITH CHECKSUM"
docker cp "$SQLSERVER_CONTAINER:$BAK" "$DEST/"
( cd "$DEST" && sha256sum ./*.bak > SHA256SUMS && cat SHA256SUMS )
echo "Sauvegarde OK: $DEST (à conserver tant que le rollback est possible)"
echo "$DEST" > "$BACKUP_ROOT/LATEST"
