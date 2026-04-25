#!/bin/bash

# Prevent multiple sourcing
if [[ "${CORE_SH_LOADED:-}" == "1" ]]; then
  return 0
fi
CORE_SH_LOADED=1

# ─────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  DIM='\033[2m'
  NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' DIM='' NC=''
fi

# ─────────────────────────────────────────────
# GLOBAL FLAGS
# ─────────────────────────────────────────────
: "${DRY_RUN_MODE:=false}"
: "${FORCE_MODE:=false}"
: "${VERBOSE_MODE:=false}"
: "${SKIP_AUR:=false}"
: "${DIAGNOSE_MODE:=false}"
: "${AUTO_DEPENDENCY:=true}"
: "${FULL_UPGRADE:=false}"

# ─────────────────────────────────────────────
# Logging (FIXED: prevent disk explosion)
# ─────────────────────────────────────────────
if [[ -z "${LOG_FILE:-}" ]]; then
  LOG_FILE="$HOME/.local/log/no-maidens.log"
  mkdir -p "$(dirname "$LOG_FILE")"
fi

# Limit log size (5MB max)
rotate_logs() {
  if [[ -f "$LOG_FILE" ]] && [[ $(stat -c%s "$LOG_FILE") -gt 5242880 ]]; then
    mv "$LOG_FILE" "${LOG_FILE}.old"
  fi
}

log() {
  rotate_logs

  # Print to terminal
  echo -e "[$(date '+%H:%M:%S')] $*"

  # Write minimal logs (no spam)
  echo "[$(date '+%H:%M:%S')] $(echo -e "$*" | sed 's/\x1b\[[0-9;]*m//g')" >>"$LOG_FILE"
}

log_info()  { log "${BLUE}::${NC} $1"; }
log_warn()  { log "${YELLOW}!${NC} $1"; }
log_error() { log "${RED}✗${NC} $1"; }
log_ok()    { log "${GREEN}✓${NC} $1"; }

log_debug() {
  [[ "$VERBOSE_MODE" == "true" ]] && log "${DIM}[DEBUG] $*${NC}"
}

# ─────────────────────────────────────────────
# Failure tracking
# ─────────────────────────────────────────────
FAILED_ITEMS=()

record_fail() {
  FAILED_ITEMS+=("$1")
}

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

dry() {
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    log_warn "[DRY RUN] $*"
    return 0
  fi
  "$@"
}

is_pkg_installed() {
  pacman -Q "$1" &>/dev/null
}

is_cmd_installed() {
  command -v "$1" &>/dev/null
}

# Safe retry (NO eval)
with_retry() {
  local attempts=3 delay=2 count=1

  while (( count <= attempts )); do
    "$@" && return 0

    log_warn "Retry $count/$attempts: $*"
    sleep "$delay"
    ((count++))
  done

  log_error "Command failed after $attempts attempts: $*"
  return 1
}

show_progress() {
  local cur=$1 total=$2 name=$3
  local pct=$((cur * 100 / total))
  printf "\r[%3d%%] %s (%d/%d)" "$pct" "$name" "$cur" "$total"
}

# ─────────────────────────────────────────────
# Dependency resolver (FIXED: no duplicates)
# ─────────────────────────────────────────────
resolve_dependencies() {
  log_info "Running dependency resolver..."

  local deps=(git base-devel curl wget)

  for pkg in "${deps[@]}"; do
    if is_pkg_installed "$pkg"; then
      log_ok "$pkg already installed"
    else
      log_warn "$pkg missing → installing"
      install_dep "$pkg"
    fi
  done

  log_ok "Dependency resolution complete"
}

# ─────────────────────────────────────────────
# Install dependency
# ─────────────────────────────────────────────
install_dep() {
  local pkg="$1"

  log_info "Installing dependency: $pkg"

  if dry sudo pacman -S --needed --noconfirm "$pkg" >>"$LOG_FILE" 2>&1; then
    log_ok "$pkg installed"
  else
    log_error "Failed to install $pkg"
    record_fail "dep:$pkg"
    return 1
  fi
}

check_and_install() {
  local cmd="$1"
  local pkg="$2"

  if is_cmd_installed "$cmd" || is_pkg_installed "$pkg"; then
    log_ok "$pkg already installed"
    return 0
  fi

  log_warn "$pkg missing → installing"
  install_dep "$pkg"
}

# ─────────────────────────────────────────────
# Install paru (FIXED reliability)
# ─────────────────────────────────────────────
install_paru() {

  [[ "$SKIP_AUR" == "true" ]] && {
    log_warn "Skipping paru (--skip-aur)"
    return 0
  }

  if command -v paru &>/dev/null; then
    log_ok "paru already installed"
    return 0
  fi

  log_warn "Installing paru..."

  [[ "$DRY_RUN_MODE" == "true" ]] && {
    log_warn "[DRY RUN] Would install paru"
    return 0
  }

  local tmp
  tmp=$(mktemp -d)

  if with_retry git clone https://aur.archlinux.org/paru.git "$tmp/paru" >>"$LOG_FILE" 2>&1; then
    (
      cd "$tmp/paru" || exit 1
      makepkg -si --noconfirm >>"$LOG_FILE" 2>&1
    ) || {
      log_error "paru build failed"
      record_fail "paru build"
    }
  else
    log_error "paru clone failed"
    record_fail "paru clone"
  fi

  rm -rf "$tmp"
}

# ─────────────────────────────────────────────
# CLEANUP (FIXED: actually frees space)
# ─────────────────────────────────────────────
cleanup_system() {

  log_info "Starting system cleanup..."

  # Aggressive pacman cleanup (IMPORTANT)
  log_info "Cleaning pacman cache (FULL)"
  dry sudo pacman -Scc --noconfirm >>"$LOG_FILE" 2>&1 \
    && log_ok "Pacman cache cleaned" \
    || log_warn "Pacman cleanup failed"

  # AUR cleanup
  if command -v paru &>/dev/null; then
    log_info "Cleaning AUR cache"
    dry paru -Scc --noconfirm >>"$LOG_FILE" 2>&1 \
      && log_ok "AUR cache cleaned" \
      || log_warn "AUR cleanup failed"
  fi

  # Remove orphan packages (BIG win)
  log_info "Removing orphan packages"
  if orphans=$(pacman -Qtdq 2>/dev/null); then
    [[ -n "$orphans" ]] && dry sudo pacman -Rns --noconfirm $orphans
  fi

  log_ok "System cleanup complete"
}