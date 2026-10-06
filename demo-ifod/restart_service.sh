#!/bin/bash
# Redémarre un service Java local : ./restart_service.sh sfd-rh-service
# Verrou par service : deux agents ne relancent pas le même service en même temps (le 2e attend puis relance une fois le 1er UP).
set -uo pipefail
S="${1:?service ex: sfd-rh-service}"
LOCK="/tmp/sfd-restart-${S}.lock"
for i in $(seq 1 120); do mkdir "$LOCK" 2>/dev/null && break; sleep 5; done
trap 'rmdir "$LOCK" 2>/dev/null' EXIT
pkill -f "$S" 2>/dev/null; sleep 4
ONLY="$S" /Users/pierreadopre/Projects/erp-sfd/sfd-docs/demo-ifod/01_start_stack.sh reste
