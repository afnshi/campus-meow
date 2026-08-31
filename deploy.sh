#!/usr/bin/env sh
set -eu
. "$(dirname "$0")/scripts/lib/common.sh"

log "Server deployment is intentionally disabled during local implementation."
printf '%s\n' "Add an approved production compose file and target only this project's containers before enabling it."
exit 2

