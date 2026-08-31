#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

require_command flutter
mkdir -p "$ROOT_DIR/dist/jar" "$ROOT_DIR/dist/apk"

log "Building Spring Boot JAR"
(cd "$ROOT_DIR/apps/api" && ./mvnw -B -DskipTests package)
cp "$ROOT_DIR"/apps/api/target/campus-meow-api-*.jar "$ROOT_DIR/dist/jar/"

log "Building Flutter APK"
(cd "$ROOT_DIR/apps/flutter_client" && flutter build apk --release)
cp "$ROOT_DIR/apps/flutter_client/build/app/outputs/flutter-apk/app-release.apk" \
  "$ROOT_DIR/dist/apk/campus-meow.apk"

log "Build artifacts are in $ROOT_DIR/dist"