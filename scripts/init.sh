#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────
# Root directory
# ─────────────────────────────────────────────
INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────
# Global flags (defaults)
# ─────────────────────────────────────────────
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false
AUTO_DEPENDENCY=true
FULL_UPGRADE=false

# ─────────────────────────────────────────────
# CLI parser
# ─────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN_MODE=true ;;
    --force) FORCE_MODE=true ;;
    --verbose) VERBOSE_MODE=true ;;
    --skip-aur) SKIP_AUR=true ;;
    --diagnose) DIAGNOSE_MODE=true ;;
    --no-auto-deps) AUTO_DEPENDENCY=false ;;
    --full-upgrade) FULL_UPGRADE=true ;;
    --help)
      echo "Usage: ./init.sh [options]"
      echo
      echo "Options:"
      echo "  --dry-run         Simulate actions (no changes)"
      echo "  --force           Force overwrite where applicable"
      echo "  --verbose         Enable debug output"
      echo "  --skip-aur        Skip AUR packages"
      echo "  --diagnose        Run checks only (no installs)"
      echo "  --no-auto-deps    Skip dependency resolver"
      echo "  --full-upgrade    Run full system upgrade (pacman -Syu)"
      echo "  --help            Show this help"
      exit 0
      ;;
    *)
      echo "⚠️ Unknown flag: $1"
      ;;
  esac
  shift
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE AUTO_DEPENDENCY FULL_UPGRADE

# ─────────────────────────────────────────────
# Load core
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# Base system tools
# ─────────────────────────────────────────────
ensure_system_tools() {
  log_info "Checking base system tools..."

  local pkgs=("git" "base-devel")

  for pkg in "${pkgs[@]}"; do
    if ! command -v "$pkg" &>/dev/null && ! pacman -Q "$pkg" &>/dev/null; then
      log_warn "Missing $pkg → installing"
      dry sudo pacman -S --needed --noconfirm "$pkg" || true
    fi
  done
}

# ─────────────────────────────────────────────
# Bootstrap system
# ─────────────────────────────────────────────
bootstrap_system() {
  log_info "Checking multilib repo..."

  if grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_info "multilib already enabled"
  else
    log_warn "Enabling multilib repo..."
    sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf || true
  fi

  if [[ "$FULL_UPGRADE" == "true" ]]; then
    log_info "Running full system upgrade..."
    dry sudo pacman -Syu --noconfirm
  else
    log_info "Refreshing package database..."
    dry sudo pacman -Sy --noconfirm
  fi
}

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 No_Maidens_UwU Installer Starting..."
echo "⚙️ Dry run: $DRY_RUN_MODE | Verbose: $VERBOSE_MODE | Diagnose: $DIAGNOSE_MODE"

# ─────────────────────────────────────────────
# Pre-flight setup
# ─────────────────────────────────────────────
ensure_system_tools

if [[ "$AUTO_DEPENDENCY" == "true" ]]; then
  resolve_dependencies
else
  log_warn "Skipping dependency resolver (--no-auto-deps)"
fi

# Install paru BEFORE AUR usage
install_paru

bootstrap_system

# ─────────────────────────────────────────────
# Load modules
# ─────────────────────────────────────────────
MODULES=(
  "pacman.sh"
  "aur.sh"
  "dotfiles.sh"
  "ime_setup.sh"
  "gnomeext.sh"
  "services.sh"
)

for module in "${MODULES[@]}"; do
  path="$INIT_DIR/$module"

  if [[ -f "$path" ]]; then
    source "$path"
    log_info "Loaded module: $module"
  else
    log_warn "Skipping missing module: $module"
  fi
done

# ─────────────────────────────────────────────
# Execution pipeline
# ─────────────────────────────────────────────
run_all() {
  run_pacman
  run_aur
  run_dotfiles
  run_ime_setup
  run_gnomeext
  # run_services
}

run_all

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────
echo

if (( ${#FAILED_ITEMS[@]} > 0 )); then
  log_warn "Some tasks failed:"
  for f in "${FAILED_ITEMS[@]}"; do
    echo "  - $f"
  done
else
  log_ok "All tasks completed successfully"
fi

echo
log_ok "🎉 All installation tasks completed"