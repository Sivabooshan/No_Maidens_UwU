#!/bin/bash

# Prevent multiple sourcing
if [[ "${CORE_SH_LOADED:-}" == "1" ]]; then
  return 0
fi
CORE_SH_LOADED=1

# ─────────────────────────────────────────────
# Core shared engine (FIXED)
# ─────────────────────────────────────────────

# Colors
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
# GLOBAL FLAGS (DO NOT redefine in other files)
# ─────────────────────────────────────────────
: "${DRY_RUN_MODE:=false}"
: "${FORCE_MODE:=false}"
: "${VERBOSE_MODE:=false}"
: "${SKIP_AUR:=false}"
: "${DIAGNOSE_MODE:=false}"

# ─────────────────────────────────────────────
# Logging
# ─────────────────────────────────────────────
if [[ -z "${LOG_FILE:-}" ]]; then
  LOG_FILE="$HOME/.local/log/no-maidens-$(date +%Y%m%d-%H%M%S).log"
  mkdir -p "$(dirname "$LOG_FILE")"
fi

log() {
  echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log_info()  { echo -e "${BLUE}::${NC} $1"; }
log_warn()  { echo -e "${YELLOW}!${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }
log_ok()    { echo -e "${GREEN}✓${NC} $1"; }

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

dry() {
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    warning "[DRY RUN] $*"
    return 0
  fi
  "$@"
}

is_installed() {
  pacman -Q "$1" &>/dev/null
}

with_retry() {
  local n=1 max=3
  local out

  while ((n <= max)); do
    if out="$("$@" 2>&1)"; then
      echo "$out"
      return 0
    fi
    warning "Retry $n/$max..."
    sleep 2
    ((n++))
  done

  echo "$out"
  return 1
}

show_progress() {
  local cur=$1 total=$2 name=$3
  local pct=$((cur * 100 / total))
  printf "\r[%3d%%] %s (%d/%d)" "$pct" "$name" "$cur" "$total"
}

# ─────────────────────────────────────────────
# REQUIRED: main entry stub (prevents errors)
# ─────────────────────────────────────────────
begin_sacred_ritual() {
  error "begin_sacred_ritual not implemented in core.sh (must be in main.sh)"
  return 1
}
