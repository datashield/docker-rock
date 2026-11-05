#!/usr/bin/env bash
#
# connect-opal.sh - make a running grove Rock container reachable from an
# already-running Opal, without touching Opal's compose file or environment.
#
# It attaches the grove container to Opal's Docker network under a stable DNS
# alias (default: rock-grove), so that in Opal you can register the Rock server
# as   rock-grove:8085   (Administration > Apps > Discovery).
#
# Works when Opal and grove run as Docker containers on the SAME Docker host,
# however Opal was deployed (compose, swarm-less docker run, ...).
# If Opal runs elsewhere, you do not need this script: register
# http://<grove-host>:<published-port> instead (see README).
#
# Usage:
#   scripts/connect-opal.sh [options]
#
# Options (all optional - auto-detected when omitted):
#   --grove  NAME   grove container name   (env GROVE_CONTAINER)
#   --opal   NAME   Opal container name     (env OPAL_CONTAINER)
#   --network NAME  Opal's Docker network   (env OPAL_NETWORK)
#   --alias  NAME   DNS alias for grove     (env GROVE_ALIAS, default rock-grove)
#   --remove        detach grove from the network again
#   --no-verify     skip the connectivity check from inside Opal
#   -h, --help      show this help
#
# Safe to re-run: it does nothing if grove is already attached with the alias.

set -euo pipefail

ALIAS="${GROVE_ALIAS:-rock-grove}"
GROVE="${GROVE_CONTAINER:-}"
OPAL="${OPAL_CONTAINER:-}"
NETWORK="${OPAL_NETWORK:-}"
ROCK_PORT=8085          # Rock's port INSIDE the container (not the published one)
REMOVE=false
VERIFY=true

die()  { echo "error: $*" >&2; exit 1; }
info() { echo "==> $*"; }
warn() { echo "warning: $*" >&2; }

usage() { sed -n '2,/^set -euo/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
  case "$1" in
    --grove)     GROVE="${2:?--grove needs a value}"; shift 2 ;;
    --opal)      OPAL="${2:?--opal needs a value}"; shift 2 ;;
    --network)   NETWORK="${2:?--network needs a value}"; shift 2 ;;
    --alias)     ALIAS="${2:?--alias needs a value}"; shift 2 ;;
    --remove)    REMOVE=true; shift ;;
    --no-verify) VERIFY=false; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)           die "unknown option: $1 (try --help)" ;;
  esac
done

command -v docker >/dev/null 2>&1 || die "docker not found in PATH"
docker info >/dev/null 2>&1      || die "cannot talk to the Docker daemon"

# Print names of running containers whose image matches an extended regex.
find_by_image() {
  docker ps --format '{{.Names}}\t{{.Image}}' | awk -F'\t' -v p="$1" '$2 ~ p { print $1 }'
}

# Resolve exactly one container, or explain what to pass.
pick_container() { # label, regex, flag
  local label="$1" regex="$2" flag="$3" found count
  found="$(find_by_image "$regex")"
  count="$(printf '%s\n' "$found" | grep -c . || true)"
  if [ "$count" -eq 0 ]; then
    die "no running $label container found. Start it, or pass $flag NAME."
  elif [ "$count" -gt 1 ]; then
    echo "error: several running $label containers found:" >&2
    printf '  %s\n' $found >&2
    die "pass $flag NAME to choose one."
  fi
  printf '%s' "$found"
}

[ -n "$GROVE" ] || GROVE="$(pick_container grove 'rock-grove' --grove)"
[ -n "$OPAL" ]  || OPAL="$(pick_container Opal '(^|/)opal(:|@|$)' --opal)"

docker inspect "$GROVE" >/dev/null 2>&1 || die "container '$GROVE' does not exist"
docker inspect "$OPAL"  >/dev/null 2>&1 || die "container '$OPAL' does not exist"

# Opal's network: the only user-defined one, unless told otherwise.
if [ -z "$NETWORK" ]; then
  nets="$(docker inspect -f '{{range $k, $_ := .NetworkSettings.Networks}}{{println $k}}{{end}}' "$OPAL" \
          | grep -v -x -E 'host|none|bridge' || true)"
  count="$(printf '%s\n' "$nets" | grep -c . || true)"
  if [ "$count" -eq 0 ]; then
    die "'$OPAL' is only on the default bridge/host network, which has no DNS aliases. Put Opal on a user-defined network (docker compose does this by default), or register grove by host address instead (see README)."
  elif [ "$count" -gt 1 ]; then
    echo "error: '$OPAL' is attached to several networks:" >&2
    printf '  %s\n' $nets >&2
    die "pass --network NAME to choose one."
  fi
  NETWORK="$nets"
fi
docker network inspect "$NETWORK" >/dev/null 2>&1 || die "network '$NETWORK' does not exist"

info "grove container : $GROVE"
info "Opal container  : $OPAL"
info "Opal network    : $NETWORK"
info "alias           : $ALIAS"

# Is grove already attached to that network, and does it already have the alias?
attached="$(docker inspect -f "{{if index .NetworkSettings.Networks \"$NETWORK\"}}yes{{end}}" "$GROVE")"
has_alias="$(docker inspect -f "{{with index .NetworkSettings.Networks \"$NETWORK\"}}{{range .Aliases}}{{println .}}{{end}}{{end}}" "$GROVE" \
             | grep -c -x -- "$ALIAS" || true)"

if $REMOVE; then
  if [ "$attached" = "yes" ]; then
    docker network disconnect "$NETWORK" "$GROVE"
    info "grove detached from $NETWORK"
  else
    info "grove was not attached to $NETWORK, nothing to do"
  fi
  exit 0
fi

if [ "$attached" = "yes" ] && [ "$has_alias" -ge 1 ]; then
  info "already attached with alias '$ALIAS', nothing to change"
else
  if [ "$attached" = "yes" ]; then
    info "attached without the alias; re-attaching"
    docker network disconnect "$NETWORK" "$GROVE"
  fi
  docker network connect --alias "$ALIAS" "$NETWORK" "$GROVE"
  info "grove attached to $NETWORK as '$ALIAS'"
fi

# Check from inside Opal, which is the only vantage point that matters.
verify() {
  local url="http://${ALIAS}:${ROCK_PORT}/" tries=30 i
  local tool=""
  if   docker exec "$OPAL" sh -c 'command -v curl' >/dev/null 2>&1; then tool=curl
  elif docker exec "$OPAL" sh -c 'command -v wget' >/dev/null 2>&1; then tool=wget
  elif docker exec "$OPAL" bash -c ':' >/dev/null 2>&1;            then tool=bash
  else warn "no curl, wget or bash in the Opal container; skipping the check"; return 0
  fi
  info "checking $url from inside '$OPAL' (Rock can take a minute to start)"
  for i in $(seq 1 "$tries"); do
    case "$tool" in
      curl) out="$(docker exec "$OPAL" curl -fsS --max-time 5 "$url" 2>/dev/null)" && { echo "$out"; return 0; } ;;
      wget) out="$(docker exec "$OPAL" wget -qO- -T 5 "$url" 2>/dev/null)"        && { echo "$out"; return 0; } ;;
      bash) docker exec "$OPAL" bash -c "exec 3<>/dev/tcp/${ALIAS}/${ROCK_PORT}" 2>/dev/null \
              && { echo "TCP connection to ${ALIAS}:${ROCK_PORT} succeeded"; return 0; } ;;
    esac
    sleep 2
  done
  return 1
}

if $VERIFY; then
  if verify; then
    info "Opal can reach grove."
  else
    die "Opal cannot reach ${ALIAS}:${ROCK_PORT}. Check 'docker logs $GROVE' and that grove is running."
  fi
fi

cat <<MSG

Next, in Opal (as administrator):
  1. Administration > Apps > Discovery: add   ${ALIAS}:${ROCK_PORT}   and refresh the registry.
  2. Administration > DataSHIELD > Add Profile: choose the grove cluster, then initialise and enable it.

Note: this attachment is lost if the grove container is re-created. Re-run this
script after 'docker compose up --force-recreate', or use the declarative
variant:  make up-opal  (see README).
MSG
