#!/bin/bash
# Redémarre uniquement le ng serve du port 4200 (kill par PID du port, jamais de pkill global esbuild). Verrou pour éviter 2 relances simultanées.
set -uo pipefail
LOCK=/tmp/sfd-restart-angular.lock
for i in $(seq 1 60); do mkdir "$LOCK" 2>/dev/null && break; sleep 5; done
trap 'rmdir "$LOCK" 2>/dev/null' EXIT
LOG=/Users/pierreadopre/Projects/erp-sfd/.logs/angular-ifod.log
PIDS=$(lsof -ti tcp:4200 -sTCP:LISTEN 2>/dev/null)
for p in $PIDS; do kill "$p" 2>/dev/null; done
for p in $(/bin/ps -ax -o pid,command | /usr/bin/grep -E "sfd-angular.*(ng serve|@esbuild)|npm exec ng serve" | /usr/bin/grep -v grep | awk '{print $1}'); do kill "$p" 2>/dev/null; done
sleep 3
cd /Users/pierreadopre/Projects/erp-sfd/sfd-angular && (NODE_OPTIONS="--max_old_space_size=4096" nohup npx ng serve --configuration=development > "$LOG" 2>&1 &)
for i in $(seq 1 120); do
  if /usr/bin/grep -q "Local:" "$LOG" 2>/dev/null; then echo "Angular UP"; exit 0; fi
  if /usr/bin/grep -qE "Application bundle generation failed|\[ERROR\]" "$LOG" 2>/dev/null; then echo "Angular ERREUR de compilation :"; /usr/bin/grep -E "\[ERROR\]|TS[0-9]+|NG[0-9]+" "$LOG" | head -10; exit 1; fi
  sleep 5
done
echo "timeout"; exit 1
