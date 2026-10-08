#!/bin/bash
# Vérification en lecture seule: santé de chaque service et moteur réellement utilisé (via les journaux de démarrage Hibernate).
cd "$(dirname "$0")"; . ./lib.sh
ko=0
for s in "${SERVICES[@]}"; do
  IFS='|' read -r n port ctx <<<"$s"
  docker inspect "$n" >/dev/null 2>&1 || { echo "absent  $n"; continue; }
  st=$(curl -fsS -m 8 "http://localhost:$port$ctx/actuator/health" 2>/dev/null | grep -o '"status":"[A-Z_]*"' | head -1)
  eng=$(docker logs "$n" 2>&1 | grep -o -m1 "Database version: [^ ]* *[0-9.]*\|PostgreSQL\|Microsoft SQL Server" | head -1)
  printf '%-28s %-18s %s\n' "$n" "${st:-no-response}" "${eng:-moteur?}"
  [ "$st" = '"status":"UP"' ] || ko=$((ko+1))
done
echo "services non UP: $ko"; [ $ko -eq 0 ]
