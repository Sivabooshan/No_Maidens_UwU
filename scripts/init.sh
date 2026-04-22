#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────
# Root directory
# ─────────────────────────────────────────────
INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────
# Global flags (DEFAULTS FIRST)
# ─────────────────────────────────────────────
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false

# ─────────────────────────────────────────────
# CLI parser (must come BEFORE modules load)
# ─────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run) DRY_RUN_MODE=true ;;
  --force) FORCE_MODE=true ;;
  --verbose) VERBOSE_MODE=true ;;
  --skip-aur) SKIP_AUR=true ;;
  --diagnose) DIAGNOSE_MODE=true ;;
  *) echo "⚠️ Unknown flag: $1" ;;
  esac
  shift
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE

# ─────────────────────────────────────────────
# Core loader
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# 🧠 Bootstrap system (idempotent multilib)
# ─────────────────────────────────────────────
bootstrap_system() {
  info "Checking multilib repo..."

  if grep -q "^\[multilib\]" /etc/pacman.conf; then
    info "multilib already enabled"
  else
    warn "Enabling multilib repo..."
    sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
  fi

  info "Syncing system..."
  sudo pacman -Syu
}

bootstrap_system

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 No_Maidens_UwU Installer Initializing..."
echo "⚙️ Dry run: $DRY_RUN_MODE"

# ─────────────────────────────────────────────
# Modules (ORDER MATTERS)
# ─────────────────────────────────────────────
MODULES=(
  "pacman.sh"
  "aur.sh"
  "dotfiles.sh"
  "ime_setup.sh"
  "gnomeext.sh"
)

for module in "${MODULES[@]}"; do
  path="$INIT_DIR/$module"

  if [[ -f "$path" ]]; then
    source "$path"
    info "Loaded module: $module"
  else
    error "Missing module: $module"
  fi
done

# ─────────────────────────────────────────────
# Execution pipeline
# ─────────────────────────────────────────────
run_all() {
  run_pacman
  [[ "$SKIP_AUR" == false ]] && run_aur
  run_dotfiles
  run_ime_setup
  run_gnomeext
}

run_all

echo
ok "🎉 All installation tasks completed"
