#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

log "Running complete quality gate"
"$ROOT_DIR/lint.sh"
"$ROOT_DIR/test.sh"
"$ROOT_DIR/build.sh"

