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

log_info()  { echo -e "${BLUE}::${NC} $1"; }
log_warn()  { echo -e "${YELLOW}!${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }
log_ok()    { echo -e "${GREEN}✓${NC} $1"; }

log_debug() {
  [[ "$VERBOSE_MODE" == "true" ]] && echo -e "${DIM}[DEBUG] $*${NC}"
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

# Package check (reliable)
is_pkg_installed() {
  pacman -Q "$1" &>/dev/null
}

# Command check
is_cmd_installed() {
  command -v "$1" &>/dev/null
}

# Retry wrapper
with_retry() {
  local n=1 max=3
  local out

  while ((n <= max)); do
    if out="$("$@" 2>&1)"; then
      echo "$out"
      return 0
    fi

    log_warn "Retry $n/$max: $*"
    sleep 2
    ((n++))
  done

  echo "$out"
  return 1
}

# Progress display
show_progress() {
  local cur=$1 total=$2 name=$3
  local pct=$((cur * 100 / total))
  printf "\r[%3d%%] %s (%d/%d)" "$pct" "$name" "$cur" "$total"
}

# ─────────────────────────────────────────────
# Dependency resolver (optional stage)
# ─────────────────────────────────────────────

detect_pkg_manager() {
  if command -v paru &>/dev/null; then
    echo "paru"
  elif command -v yay &>/dev/null; then
    echo "yay"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v apt &>/dev/null; then
    echo "apt"
  else
    echo "unknown"
  fi
}

install_dep() {
  local pkg="$1"
  local manager
  manager=$(detect_pkg_manager)

  log_info "Installing dependency: $pkg"

  case "$manager" in
    paru) paru -S --needed --noconfirm "$pkg" ;;
    yay) yay -S --needed --noconfirm "$pkg" ;;
    pacman) sudo pacman -S --needed --noconfirm "$pkg" ;;
    apt)
      sudo apt update -y
      sudo apt install -y "$pkg"
      ;;
    *)
      log_error "No supported package manager"
      return 1
      ;;
  esac
}

check_and_install() {
  local cmd="$1"
  local pkg="${2:-$1}"

  if is_cmd_installed "$cmd"; then
    log_ok "$cmd already installed"
    return 0
  fi

  log_warn "$cmd missing → installing ($pkg)"
  install_dep "$pkg" || {
    log_error "Failed to install $pkg"
    record_fail "dep:$pkg"
    return 1
  }
}

resolve_dependencies() {
  log_info "Running dependency resolver..."

  # Core tools
  check_and_install git
  check_and_install make
  check_and_install cmake
  check_and_install meson
  check_and_install ninja
  check_and_install jq
  check_and_install zip
  check_and_install unzip

  # GNOME tools
  check_and_install gnome-extensions gnome-shell
  check_and_install gnome-shell-extension-tool gnome-shell

  # utilities
  check_and_install curl
  check_and_install wget

  log_ok "Dependency resolution complete"
}