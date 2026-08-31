#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

require_command docker
require_command flutter

cleanup() {
  docker compose -f "$ROOT_DIR/docker-compose.test.yml" down --volumes --remove-orphans
}
trap cleanup EXIT INT TERM

log "Starting isolated MySQL and MongoDB containers"
docker compose -f "$ROOT_DIR/docker-compose.test.yml" up -d --wait

log "Running backend unit and real-database integration tests"
(
  export MYSQL_HOST=localhost MYSQL_PORT=13306 MYSQL_DATABASE=campus_meow_test
  export MYSQL_USER=test_user MYSQL_PASSWORD=test_password
  export MONGO_HOST=localhost MONGO_PORT=27018 MONGO_DATABASE=campus_meow_test
  export MONGO_USER=test_user MONGO_PASSWORD=test_password
  export JWT_SECRET=integration-test-secret-at-least-32-characters
  cd "$ROOT_DIR/apps/api"
  ./mvnw -B test
)

log "Running Flutter tests"
(cd "$ROOT_DIR/apps/flutter_client" && flutter test)