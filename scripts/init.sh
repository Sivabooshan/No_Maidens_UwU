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
    *) echo "⚠️ Unknown flag: $1" ;;
  esac
  shift
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE AUTO_DEPENDENCY

# ─────────────────────────────────────────────
# Core loader
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# 🧠 Auto dependency bootstrap (pacman-first hybrid hook)
# ─────────────────────────────────────────────
ensure_system_tools() {
  log_info "Checking base system tools..."

  local pkgs=("git" "base-devel")

  for pkg in "${pkgs[@]}"; do
    if ! command -v "$pkg" &>/dev/null && ! pacman -Q "$pkg" &>/dev/null; then
      log_warn "Missing $pkg → installing"
      sudo pacman -S --needed --noconfirm "$pkg" || true
    fi
  done
}

ensure_system_tools

# ─────────────────────────────────────────────
# 🧠 Bootstrap system (multilib safe)
# ─────────────────────────────────────────────
bootstrap_system() {
  log_info "Checking multilib repo..."

  if grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_info "multilib already enabled"
  else
    log_warn "Enabling multilib repo..."
    sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf || true
  fi

  log_info "Syncing package database..."
  sudo pacman -Syu --noconfirm
}

bootstrap_system

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 No_Maidens_UwU Installer Initializing..."
echo "⚙️ Dry run: $DRY_RUN_MODE"
echo "🧠 Auto deps: $AUTO_DEPENDENCY"

# ─────────────────────────────────────────────
# Modules
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
    log_error "Missing module: $module"
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
  run_services
}

run_all

echo
log_ok "🎉 All installation tasks completed"