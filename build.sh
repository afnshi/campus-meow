#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

TARGET=${1:-all}
API_BASE_URL=${API_BASE_URL:-}
case "$TARGET" in
  all|jar|apk|web) ;;
  *) printf 'Usage: %s {all|jar|apk|web}\n' "$0" >&2; exit 2 ;;
esac

if [ "$TARGET" != jar ]; then
  require_command flutter
fi
if [ "$TARGET" = all ] || [ "$TARGET" = jar ]; then
  mkdir -p "$ROOT_DIR/dist/jar"
  log "Building Spring Boot JAR"
  (cd "$ROOT_DIR/apps/api" && ./mvnw -B -DskipTests package)
  cp "$ROOT_DIR"/apps/api/target/campus-meow-api-*.jar "$ROOT_DIR/dist/jar/"
fi
if [ "$TARGET" = all ] || [ "$TARGET" = apk ]; then
  mkdir -p "$ROOT_DIR/dist/apk"
  log "Building Flutter APK"
  (cd "$ROOT_DIR/apps/flutter_client" && flutter build apk --release \
    --dart-define="API_BASE_URL=$API_BASE_URL")
  cp "$ROOT_DIR/apps/flutter_client/build/app/outputs/flutter-apk/app-release.apk" \
    "$ROOT_DIR/dist/apk/campus-meow.apk"
fi
if [ "$TARGET" = all ] || [ "$TARGET" = web ]; then
  log "Building Flutter Web"
  (cd "$ROOT_DIR/apps/flutter_client" && flutter build web --release \
    --dart-define="API_BASE_URL=$API_BASE_URL")
  # Replace only the generated Web output to avoid stale assets.
  rm -rf "$ROOT_DIR/dist/web"
  mkdir -p "$ROOT_DIR/dist/web"
  cp -R "$ROOT_DIR/apps/flutter_client/build/web/." "$ROOT_DIR/dist/web/"
fi
log "Build artifacts are in $ROOT_DIR/dist"
