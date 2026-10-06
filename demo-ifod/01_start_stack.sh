#!/bin/bash
# Démarrage ordonné de la pile locale pour la démo IFOD (base vide) — NON destructif. Compatible bash 3.2 (macOS).
# 1) commun/préférence seul (crée les tables d'auth partagées) 2) les autres services, DEMO_DATA_ENABLED=false.
# Usage : ./01_start_stack.sh [phase]   phase = commun | reste | tout (défaut)
set -uo pipefail
BASE_DIR="/Users/pierreadopre/Projects/erp-sfd"
LOG_DIR="$BASE_DIR/.logs"; mkdir -p "$LOG_DIR"
JVM_OPTS="-Xms64m -Xmx384m -XX:+UseSerialGC -XX:TieredStopAtLevel=1 -Dspring.jmx.enabled=false"
export DEMO_DATA_ENABLED=false
# comptes du portail employé (8 employés + 3 managers) provisionnés au démarrage de sfd-portail-employe-service
source "$(dirname "$0")/portail_comptes_env.sh"
# Meilisearch local (conteneur sfd-meilisearch-local) pour la recherche Agora
export MEILISEARCH_HOST=http://localhost:7700
export MEILISEARCH_API_KEY="$(docker inspect sfd-meilisearch-local --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null | sed -n 's/^MEILI_MASTER_KEY=//p')"
port() { case "$1" in
  sfd-commun-service) echo 4597;; sfd-comptabilite-service) echo 4595;; sfd-client-service) echo 4598;; sfd-epargne-service) echo 4596;;
  sfd-caisse-service) echo 4599;; sfd-rh-service) echo 4602;; sfd-paie-service) echo 4603;; sfd-workflow-service) echo 4632;;
  sfd-agora-service) echo 4614;; sfd-chat-service) echo 4613;; sfd-portail-employe-service) echo 4612;; esac; }
ctx() { case "$1" in
  sfd-commun-service) echo /api/preference;; sfd-comptabilite-service) echo /api/comptabilite;; sfd-client-service) echo /api/client;;
  sfd-epargne-service) echo /api/epargne;; sfd-caisse-service) echo /api/caisse;; sfd-rh-service) echo /api/rh;; sfd-paie-service) echo /api/paie;;
  sfd-workflow-service) echo /api/workflow;; sfd-agora-service) echo /api/agora;; sfd-chat-service) echo /api/chat;;
  sfd-portail-employe-service) echo /api/portail-employe;; esac; }
start() { local s=$1; echo "▶ $s :$(port $s)"; (cd "$BASE_DIR/$s" && nohup mvn -o -q spring-boot:run -Dmaven.test.skip=true -Dspring-boot.run.jvmArguments="$JVM_OPTS" > "$LOG_DIR/$s.log" 2>&1 &) ; }
wait_up() { local s=$1 n=0; until curl -sf "http://localhost:$(port $s)$(ctx $s)/actuator/health" >/dev/null 2>&1; do n=$((n+1)); [[ $n -gt 48 ]] && { echo "  ✗ $s non UP après 240 s → tail $LOG_DIR/$s.log"; return 1; }; sleep 5; done; echo "  ✓ $s UP"; }
REST="sfd-comptabilite-service sfd-workflow-service sfd-client-service sfd-epargne-service sfd-caisse-service sfd-rh-service sfd-paie-service sfd-agora-service sfd-chat-service sfd-portail-employe-service"
phase="${1:-tout}"
if [[ "$phase" == commun || "$phase" == tout ]]; then start sfd-commun-service; wait_up sfd-commun-service || exit 1; fi
if [[ "$phase" == reste || "$phase" == tout ]]; then
  for s in ${ONLY:-$REST}; do start "$s"; sleep 8; done
  for s in ${ONLY:-$REST}; do wait_up "$s"; done
fi
