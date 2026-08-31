#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

require_command flutter

log "Checking source file length (maximum 800 lines)"
oversized=$(find "$ROOT_DIR/apps" -type f \( -name '*.java' -o -name '*.dart' \) -exec awk \
  'FNR == 801 { print FILENAME }' {} +)
if [ -n "$oversized" ]; then
  printf 'Source files over 800 lines:\n%s\n' "$oversized" >&2
  exit 1
fi

log "Analyzing Flutter"
(cd "$ROOT_DIR/apps/flutter_client" && flutter analyze --fatal-infos --fatal-warnings)

log "Checking Java style"
(cd "$ROOT_DIR/apps/api" && ./mvnw -B -DskipTests validate)

if command -v shellcheck >/dev/null 2>&1; then
  log "Checking shell scripts"
  find "$ROOT_DIR" -maxdepth 2 -name '*.sh' -print0 | xargs -0 shellcheck
else
  log "shellcheck is not installed; checking shell syntax"
  find "$ROOT_DIR" -maxdepth 2 -name '*.sh' -exec sh -n {} \;
fi