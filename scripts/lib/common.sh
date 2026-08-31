#!/usr/bin/env sh
set -eu

# All public harness scripts live in the repository root. When this file is
# sourced, POSIX sh keeps $0 pointing at the calling script, so its directory is
# the repository root.
ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

log() {
  printf '\n[%s] %s\n' "campus-meow" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$1" >&2
    exit 1
  fi
}
