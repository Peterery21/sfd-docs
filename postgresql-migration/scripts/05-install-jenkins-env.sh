#!/bin/bash
# OBSOLETE (2026-10-09): les builds tournent sur vps-agent (hôte), le fichier doit être /opt/sfd/env/sfd-pg-dev.env (voir RUNBOOK §5). Ne pas utiliser.
# Rend le fichier d'environnement PostgreSQL visible du conteneur Jenkins (docker run --env-file est lu côté client, donc DANS
# le conteneur Jenkins, qui ne voit pas /opt/sfd). Copie en 600 dans jenkins_home. À lancer APRÈS 02 et avant de pousser le blueprint.
# Simulation par défaut; --apply pour agir. Ne jamais afficher le contenu.
set -euo pipefail
SRC=/opt/sfd/env/sfd-pg-dev.env; DST=/home/ubuntu/pierre/jenkins/data/jenkins_home/sfd-pg-dev.env
[ -f "$SRC" ] || { echo "$SRC absent: exécuter 02 --apply"; exit 1; }
if [ "${1:-}" != "--apply" ]; then echo "[simulation] copie 600 $SRC -> $DST (visible: /var/jenkins_home/sfd-pg-dev.env dans le conteneur jenkins)"; exit 0; fi
sudo install -m 600 -o root -g root "$SRC" "$DST"
ls -l "$DST" | awk '{print $1, $3, $5, $9}'
