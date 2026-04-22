#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  CYAN='\033[0;36m'
  PURPLE='\033[0;35m'
  WHITE='\033[1;37m'
  BOLD='\033[1m'
  DIM='\033[2m'
  NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' CYAN='' PURPLE='' WHITE='' BOLD='' DIM='' NC=''
fi

# ─────────────────────────────────────────────
# Flags (GLOBAL STATE)
# ─────────────────────────────────────────────
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false

# ─────────────────────────────────────────────
# Logging
# ─────────────────────────────────────────────
SACRED_SCROLLS="$HOME/.local/log/dotfiles-ritual-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$(dirname "$SACRED_SCROLLS")"

inscribe_scroll() {
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] $1" | tee -a "$SACRED_SCROLLS"
}

info() { echo -e "${BLUE}::${NC} $1"; }
warn() {
  echo -e "${YELLOW}!${NC} $1"
  inscribe_scroll "WARN: $1"
}
error() {
  echo -e "${RED}✗${NC} $1" >&2
  inscribe_scroll "ERROR: $1"
}
ok() {
  echo -e "${GREEN}✓${NC} $1"
  inscribe_scroll "OK: $1"
}

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
dry() {
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    warn "DRY RUN: $*"
    return 0
  fi
  "$@"
}

is_installed() {
  pacman -Q "$1" &>/dev/null
}

with_retry() {
  local attempt=1
  local max=3
  local delay=3
  local output

  while [ $attempt -le $max ]; do
    if output="$("$@" 2>&1)"; then
      echo "$output"
      return 0
    fi

    warn "Retry $attempt/$max..."
    sleep $delay
    attempt=$((attempt + 1))
  done

  echo "$output"
  return 1
}

# ─────────────────────────────────────────────
# Progress
# ─────────────────────────────────────────────
show_progress() {
  local cur=$1 total=$2 name=$3
  local pct=$((cur * 100 / total))
  printf "\r[%s] %d%% (%d/%d) %s" "████████" "$pct" "$cur" "$total" "$name"
}
