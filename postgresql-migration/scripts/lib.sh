#!/bin/bash
# Fonctions communes aux scripts de bascule. Ne jamais afficher de variables d'environnement de conteneur (secrets).
# nom|port hôte|chemin de contexte (health = http://localhost:<port><contexte>/actuator/health)
# Ordre = ordre de démarrage: commun d'abord (crée les tables de référence), puis métier, puis transverses.
SERVICES=(
  "sfd-commun-dev|4597|/api/preference"
  "sfd-comptabilite-dev|4595|/api/comptabilite"
  "sfd-client-dev|4598|/api/client"
  "sfd-epargne-dev|4596|/api/epargne"
  "sfd-credit-dev|4594|/api/credit"
  "sfd-caisse-dev|4599|/api/caisse"
  "sfd-agent-mobile-dev|4610|/api/agent-mobile"
  "sfd-budget-dev|4604|/api/budget"
  "sfd-transfert-dev|4605|/api/transfert"
  "sfd-stock-dev|4606|/api/stock"
  "sfd-commercial-dev|4609|/api/commercial"
  "sfd-immobilisation-dev|4601|/api/immobilisation"
  "sfd-rh-dev|4602|/api/rh"
  "sfd-paie-dev|4603|/api/paie"
  "sfd-reporting-dev|4607|/api/reporting"
  "sfd-suivi-evaluation-dev|4608|/api/suivi-evaluation"
  "sfd-workflow-dev|4632|/api/workflow"
  "sfd-agora-dev|4614|/api/agora"
  "sfd-chat-dev|4613|/api/chat"
  "sfd-portail-client-dev|4629|/api/portail"
  "sfd-portail-employe-dev|4631|/api/portail-employe"
)

# Sauvegarde la configuration d'exécution d'un conteneur (env en 600) pour pouvoir le recréer à l'identique.
save_container() { # $1 nom  $2 dossier
  local n="$1" d="$2"; mkdir -p "$d"; chmod 700 "$d"
  umask 177
  docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$n" | sed '/^$/d' > "$d/$n.env"
  {
    echo "--name $n"
    echo "--restart=$(docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' "$n")"
    local mem; mem=$(docker inspect -f '{{.HostConfig.Memory}}' "$n")
    if [ "$mem" != "0" ]; then echo "--memory=$mem --memory-swap=$(docker inspect -f '{{.HostConfig.MemorySwap}}' "$n")"; fi
    local cpu; cpu=$(docker inspect -f '{{.HostConfig.NanoCpus}}' "$n")
    if [ "$cpu" != "0" ]; then echo "--cpus=$(awk -v c="$cpu" 'BEGIN{printf "%.2f", c/1000000000}')"; fi
    docker inspect -f '{{range $p,$c := .HostConfig.PortBindings}}{{range $c}}-p {{.HostPort}}:{{$p}}{{println}}{{end}}{{end}}' "$n" | sed '/^$/d'
    docker inspect -f '{{range .HostConfig.Binds}}-v {{.}}{{println}}{{end}}' "$n" | sed '/^$/d'
    echo "--network=$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{end}}' "$n")"
    docker inspect -f '{{.Config.Image}}' "$n"
  } > "$d/$n.args"
  docker inspect "$n" > "$d/$n.inspect.json"
}

# Recrée un conteneur depuis la configuration sauvegardée; $3.. = fichiers d'environnement supplémentaires (le dernier gagne).
recreate_container() { # $1 nom  $2 dossier sauvegarde  $3.. env-files supplémentaires
  local n="$1" d="$2"; shift 2
  # environnement final = environnement d'origine SANS les clés redéfinies, puis fichiers supplémentaires (pas de doublon de clé)
  local merged; merged=$(mktemp); chmod 600 "$merged"
  if [ $# -gt 0 ]; then
    cat "$@" | cut -d= -f1 | sort -u > "$merged.keys"
    grep -v -F -f <(sed 's/$/=/' "$merged.keys") "$d/$n.env" > "$merged" || true
    cat "$@" >> "$merged"; rm -f "$merged.keys"
  else cp "$d/$n.env" "$merged"; fi
  local image; image=$(tail -1 "$d/$n.args")
  local opts; opts=$(sed '$d' "$d/$n.args" | tr '\n' ' ')
  # garde-fou: ne rien arrêter si la configuration sauvegardée est inexploitable
  [ -n "$image" ] && [ -n "$opts" ] && [ -s "$d/$n.env" ] || { echo "configuration sauvegardée inexploitable pour $n: rien n'a été modifié" >&2; return 1; }
  # l'ancien conteneur est arrêté puis renommé (jamais supprimé ici): restauré automatiquement si le nouveau ne se lance pas
  docker rm -f "$n-old" >/dev/null 2>&1 || true   # reste d'une tentative précédente (la configuration d'origine est sauvegardée)
  docker stop "$n" >/dev/null 2>&1 || true
  docker rename "$n" "$n-old" >/dev/null 2>&1 || true
  # shellcheck disable=SC2086
  if ! docker run -d $opts --env-file "$merged" "$image" >/dev/null; then
    echo "échec du lancement de $n: restauration de l'ancien conteneur" >&2
    docker rename "$n-old" "$n" >/dev/null 2>&1 && docker start "$n" >/dev/null 2>&1
    rm -f "$merged"; return 1
  fi
  rm -f "$merged"
}

# À appeler une fois le nouveau conteneur sain: supprime l'ancien (renommé $n-old).
discard_old() { docker rm -f "$1-old" >/dev/null 2>&1 || true; }

wait_started() { # $1 nom  $2 port  $3 contexte  $4 timeout(s)
  local n="$1" port="$2" ctx="$3" t="${4:-300}" i=0
  while [ $i -lt "$t" ]; do
    if curl -fsS -m 5 "http://localhost:$port$ctx/actuator/health" 2>/dev/null | grep -q '"status":"UP"'; then echo "UP   $n"; return 0; fi
    if docker logs --tail 200 "$n" 2>&1 | grep -q "APPLICATION FAILED TO START"; then echo "FAIL $n (échec de démarrage)"; return 1; fi
    sleep 5; i=$((i+5))
  done
  echo "TIMEOUT $n"; return 1
}
