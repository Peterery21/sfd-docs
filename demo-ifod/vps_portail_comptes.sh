#!/bin/bash
# À LANCER PAR L'UTILISATEUR (crée les comptes de démo du portail employé sur le VPS).
# 1) Crée /home/ubuntu/pierre/app/dev/sfd-portail-employe/provisioning.properties (monté et importé par le conteneur, y compris lors des déploiements Jenkins) ; 2) recrée sfd-portail-employe-dev avec les variables de provisionnement (comptes + mot de passe de la fixture agora.json).
# Aucune valeur secrète n'est écrite dans ce fichier ; le mot de passe est lu à l'exécution et envoyé via stdin SSH.
set -euo pipefail
cd "$(dirname "$0")"
set -a; . ~/.jenkins-vps.env; set +a
source ./portail_comptes_env.sh >/dev/null            # exporte APP_PORTAIL_PROVISIONING_COMPTES (+ PASSWORD)
export APP_PORTAIL_PROVISIONING_PASSWORD="$(python3 -c "import json;print(json.load(open('../../sfd-angular/e2e/demo-ifod/data/agora.json'))['motDePasseUtilisateurs'])")"
SSH=(ssh -o BatchMode=yes -i "${VPS_SSH_KEY/#\~/$HOME}" "$VPS_SSH_USER@82.180.131.215")
IMAGE="$("${SSH[@]}" "docker inspect sfd-portail-employe-dev --format '{{.Config.Image}}'")"
echo "Image actuelle : $IMAGE"
# Variables transmises via stdin pour ne pas apparaître dans la liste des processus
{ printf 'COMPTES=%q\nPWD_PORTAIL=%q\nIMAGE=%q\n' "$APP_PORTAIL_PROVISIONING_COMPTES" "$APP_PORTAIL_PROVISIONING_PASSWORD" "$IMAGE"; cat <<'REMOTE'
# Fichier monté en lecture seule par Jenkins à chaque déploiement du portail (SPRING_CONFIG_IMPORT) : comptes + mot de passe de démo.
set -e
D=/home/ubuntu/pierre/app/dev/sfd-portail-employe
F="$D/provisioning.properties"
# Le dossier et un éventuel « dossier fantôme » créé par Docker appartiennent à root : sudo.
sudo mkdir -p "$D"
[ -d "$F" ] && sudo rmdir "$F" || true
printf 'app.portail.provisioning.comptes=%s\napp.portail.provisioning.password=%s\n' "$COMPTES" "$PWD_PORTAIL" | sudo tee "$F" >/dev/null
sudo chmod 644 "$F"
[ -f "$F" ] || { echo "ERREUR : $F n'a pas été créé comme fichier" >&2; exit 1; }
echo "Fichier de provisionnement créé : $F"
docker rm -f sfd-portail-employe-dev >/dev/null
docker run -d --name sfd-portail-employe-dev --network dev-network -p 4631:4612 --restart=always --memory=768m --cpus=1 \
  -e SPRING_PROFILES_ACTIVE=dev -e SPRING_ACTIVE_PROFILES=dev -e DEMO_DATA_ENABLED=false \
  -e "JAVA_OPTS=-Xms256m -Xmx512m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC" \
  -e RH_SERVICE_URL=http://sfd-rh-dev:4602/api/rh -e PAIE_SERVICE_URL=http://sfd-paie-dev:4603/api/paie \
  -e WORKFLOW_SERVICE_URL=http://sfd-workflow-dev:4632/api/workflow \
  -e SPRING_CONFIG_IMPORT=optional:file:/config/provisioning.properties -v "$F:/config/provisioning.properties:ro" \
  -v /opt/sfd/logs-dev:/app/logs "$IMAGE" >/dev/null
for i in $(seq 1 24); do sleep 5; curl -s -m 3 localhost:4631/api/portail-employe/actuator/health | grep -q UP && break; done
docker logs sfd-portail-employe-dev 2>&1 | grep -iE "comptes? (cr|prov)|provision" | tail -3
REMOTE
} | "${SSH[@]}" bash -s
echo "Test : un mauvais mot de passe doit donner 401"
curl -s -m 8 -o /dev/null -w "HTTP %{http_code}\n" -X POST http://82.180.131.215:4634/api/portail-employe/auth/login -H 'Content-Type: application/json' -d '{"matricule":"IFOD-0003","motDePasse":"mauvais"}'
