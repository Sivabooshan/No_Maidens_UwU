#!/bin/bash
set -uo pipefail

# ─────────────────────────────────────────────
# Root directory
# ─────────────────────────────────────────────
INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────
# Global flags
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
      echo "  --dry-run         Simulate actions"
      echo "  --force           Force overwrite"
      echo "  --verbose         Debug logs"
      echo "  --skip-aur        Skip AUR"
      echo "  --diagnose        Check only"
      echo "  --no-auto-deps    Skip dependency resolver"
      echo "  --full-upgrade    pacman -Syu"
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
# Bootstrap system
# ─────────────────────────────────────────────
bootstrap_system() {
  log_info "Checking multilib repo..."

  if grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_ok "multilib already enabled"

  elif grep -q "^#\[multilib\]" /etc/pacman.conf; then
    log_warn "Enabling multilib repo..."

    dry sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf

    # Skip verification in dry-run
    if [[ "$DRY_RUN_MODE" == "false" ]]; then
      if grep -q "^\[multilib\]" /etc/pacman.conf; then
        log_ok "multilib enabled"
      else
        log_error "failed to enable multilib"
        record_fail "multilib"
      fi
    fi

  else
    log_warn "multilib section not found"
  fi

  # ─────────────────────────────────────────────

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
# Pre-flight
# ─────────────────────────────────────────────
if [[ "$AUTO_DEPENDENCY" == "true" ]]; then
  resolve_dependencies
else
  log_warn "Skipping dependency resolver"
fi

install_paru
bootstrap_system

# ─────────────────────────────────────────────
# Load modules
# ─────────────────────────────────────────────
MODULES=(
  "pacman.sh"
  "aur.sh"
  "services.sh"
  "dotfiles.sh"
  "zsh.sh"
  "ime_setup.sh"
  "gnomeext.sh"
)

for module in "${MODULES[@]}"; do
  path="$INIT_DIR/$module"

  if [[ -f "$path" ]]; then
    source "$path"
    log_info "Loaded module: $module"
  else
    log_warn "Missing module: $module"
  fi
done

# ─────────────────────────────────────────────
# Safe runner wrapper
# ─────────────────────────────────────────────
run_step() {
  local name="$1"
  shift

  if declare -f "$name" >/dev/null; then
    log_info "Running: $name"
    "$name" || {
      log_error "$name failed"
      record_fail "$name"
    }
  else
    log_warn "$name not defined → skipping"
  fi
}

# ─────────────────────────────────────────────
# Execution pipeline
# ─────────────────────────────────────────────
run_all() {
  run_step run_pacman
  run_step run_aur
  run_step run_services
  run_step run_dotfiles
  run_step run_zsh_setup
  run_step run_ime_setup
  run_step run_gnomeext
}

run_all

# ─────────────────────────────────────────────
# Cleanup (IMPORTANT)
# ─────────────────────────────────────────────
cleanup_system

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
log_ok "🎉 Installation complete"