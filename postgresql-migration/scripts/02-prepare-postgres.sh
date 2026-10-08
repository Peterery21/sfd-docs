#!/bin/bash
# Prépare PostgreSQL pour les services: rattache pg_container à dev-network, crée le rôle applicatif et la base 'sfd',
# génère le fichier d'environnement (chmod 600, hors dépôt). Idempotent. Mode simulation par défaut: --apply pour exécuter.
set -euo pipefail
. "${ENV_FILE:-$(dirname "$0")/env.local}" 2>/dev/null || true
: "${PG_CONTAINER:=pg_container}" "${PG_ADMIN_USER:=root}" "${PG_DATABASE:=sfd}" "${PG_APP_USER:=sfd_app}" \
  "${PG_ENV_FILE:=/opt/sfd/env/sfd-pg-dev.env}" "${DEV_NETWORK:=dev-network}"
: "${PG_ADMIN_PASSWORD:?exporter PG_ADMIN_PASSWORD (saisie interactive)}"
APPLY=0; [ "${1:-}" = "--apply" ] && APPLY=1
run() { if [ $APPLY -eq 1 ]; then "$@"; else echo "[simulation] $*" | sed 's/PGPASSWORD=[^ ]*/PGPASSWORD=***/'; fi; }
psqlc() { docker exec -e PGPASSWORD="$PG_ADMIN_PASSWORD" "$PG_CONTAINER" psql -v ON_ERROR_STOP=1 -U "$PG_ADMIN_USER" -d postgres -Atc "$1"; }

# 1. réseau (sans toucher à la connexion existante de pg_container)
if docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}' "$PG_CONTAINER" | grep -qw "$DEV_NETWORK"; then
  echo "réseau $DEV_NETWORK: déjà rattaché"
else run docker network connect "$DEV_NETWORK" "$PG_CONTAINER"; fi

# 2. mot de passe applicatif: réutilisé s'il existe déjà, sinon généré
if [ -f "$PG_ENV_FILE" ]; then APP_PW=$(grep '^DATABASE_PASSWORD=' "$PG_ENV_FILE" | cut -d= -f2-)
else APP_PW=$(head -c 24 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32); fi

# 3. rôle + base
if [ $APPLY -eq 1 ]; then
  psqlc "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='$PG_APP_USER') THEN CREATE ROLE $PG_APP_USER LOGIN PASSWORD '$APP_PW'; ELSE ALTER ROLE $PG_APP_USER PASSWORD '$APP_PW'; END IF; END \$\$;"
  [ "$(psqlc "SELECT 1 FROM pg_database WHERE datname='$PG_DATABASE'")" = "1" ] || psqlc "CREATE DATABASE $PG_DATABASE OWNER $PG_APP_USER ENCODING 'UTF8' TEMPLATE template0"
  psqlc "GRANT ALL PRIVILEGES ON DATABASE $PG_DATABASE TO $PG_APP_USER"
  install -d -m 700 "$(dirname "$PG_ENV_FILE")"
  umask 177
  cat > "$PG_ENV_FILE" <<ENV
DATABASE_URL=jdbc:postgresql://$PG_CONTAINER:5432/$PG_DATABASE
DATABASE_USER=$PG_APP_USER
DATABASE_PASSWORD=$APP_PW
DATABASE_DRIVER=org.postgresql.Driver
ENV
  chmod 600 "$PG_ENV_FILE"; echo "fichier d'environnement écrit: $PG_ENV_FILE (600) — contenu non affiché"
else echo "[simulation] rôle $PG_APP_USER + base $PG_DATABASE + $PG_ENV_FILE"; fi
