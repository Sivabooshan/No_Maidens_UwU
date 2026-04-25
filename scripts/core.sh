#!/bin/bash

# Prevent multiple sourcing
if [[ "${CORE_SH_LOADED:-}" == "1" ]]; then
  return 0
fi
CORE_SH_LOADED=1

# ─────────────────────────────────────────────
# Colors (auto-disable if not TTY)
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
# GLOBAL FLAGS (defaults if not set)
# ─────────────────────────────────────────────
: "${DRY_RUN_MODE:=false}"
: "${FORCE_MODE:=false}"
: "${VERBOSE_MODE:=false}"
: "${SKIP_AUR:=false}"
: "${DIAGNOSE_MODE:=false}"
: "${AUTO_DEPENDENCY:=true}"
: "${FULL_UPGRADE:=false}"

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
# Compatibility aliases
# ─────────────────────────────────────────────
info() { log_info "$1"; }
warn() { log_warn "$1"; }
error() { log_error "$1"; }
ok() { log_ok "$1"; }

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

# Dry-run wrapper
dry() {
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    log_warn "[DRY RUN] $*"
    return 0
  fi
  "$@"
}

# Package check
is_pkg_installed() {
  pacman -Q "$1" &>/dev/null
}

# Command check
is_cmd_installed() {
  command -v "$1" &>/dev/null
}

# Retry wrapper (FIXED)
with_retry() {
  local n=1 max=3 delay=2

  while (( n <= max )); do
    if eval "$*"; then
      return 0
    fi

    log_warn "Retry $n/$max: $*"
    sleep "$delay"
    ((n++))
  done

  log_error "Command failed after $max attempts: $*"
  return 1
}

# Progress display
show_progress() {
  local cur=$1 total=$2 name=$3
  local pct=$((cur * 100 / total))
  printf "\r[%3d%%] %s (%d/%d)" "$pct" "$name" "$cur" "$total"
}

# ─────────────────────────────────────────────
# Dependency resolver (BOOTSTRAP ONLY)
# ─────────────────────────────────────────────
resolve_dependencies() {
  log_info "Running dependency resolver..."

  # Essential build + git tools
  check_and_install git git
  check_and_install base-devel base-devel

  # Network tools
  check_and_install curl curl
  check_and_install wget wget

  log_ok "Dependency resolution complete"
}

# ─────────────────────────────────────────────
# Install dependency helper
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

# Check and install command
check_and_install() {
  local cmd="$1"
  local pkg="$2"

  if is_cmd_installed "$cmd"; then
    log_ok "$cmd already installed"
    return 0
  fi

  log_warn "$cmd missing → installing ($pkg)"
  install_dep "$pkg"
}

# ─────────────────────────────────────────────
# AUR HELPER INSTALL (paru)
# ─────────────────────────────────────────────
install_paru() {

  if [[ "$SKIP_AUR" == "true" ]]; then
    log_warn "Skipping paru installation (--skip-aur)"
    return 0
  fi

  if command -v paru &>/dev/null; then
    log_ok "paru already installed"
    return 0
  fi

  log_warn "Installing paru..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    log_warn "[DRY RUN] Would install paru from AUR"
    return 0
  fi

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
    log_error "Failed to clone paru"
    record_fail "paru clone"
  fi

  rm -rf "$tmp"
}