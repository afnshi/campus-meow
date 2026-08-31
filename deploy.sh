#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

require_command docker

PROJECT=campusmeow-zyf2045
COMPOSE_FILE="$ROOT_DIR/docker-compose.prod.yml"
ENV_FILE="$ROOT_DIR/.env"
EDGE_NETWORK=zyf2045-edge
ACTION=${1:-up}

if [ ! -f "$ENV_FILE" ]; then
  printf 'Missing %s; copy .env.production.example and replace every placeholder.\n' "$ENV_FILE" >&2
  exit 1
fi

if grep -Eq 'replace-with|change-me' "$ENV_FILE"; then
  printf '%s\n' 'Refusing deployment because .env still contains placeholder secrets.' >&2
  exit 1
fi

compose() {
  docker compose --env-file "$ENV_FILE" -p "$PROJECT" -f "$COMPOSE_FILE" "$@"
}

case "$ACTION" in
  up)
    if ! docker network inspect "$EDGE_NETWORK" >/dev/null 2>&1; then
      log "Creating isolated edge network $EDGE_NETWORK"
      docker network create "$EDGE_NETWORK" >/dev/null
    fi
    log "Building and starting only the $PROJECT services"
    compose up -d --build --wait
    compose ps
    ;;
  status)
    compose ps
    ;;
  logs)
    compose logs --tail=200 api
    ;;
  down)
    log "Stopping only the $PROJECT services; database volumes are preserved"
    compose down
    ;;
  *)
    printf 'Usage: %s {up|status|logs|down}\n' "$0" >&2
    exit 2
    ;;
esac
