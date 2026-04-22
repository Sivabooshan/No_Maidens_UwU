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
    *) echo "⚠️ Unknown flag: $1" ;;
  esac
  shift
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE AUTO_DEPENDENCY FULL_UPGRADE

# ─────────────────────────────────────────────
# Core loader
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# 🧠 Base system tools (required for bootstrap)
# ─────────────────────────────────────────────
ensure_system_tools() {
  log_info "Checking base system tools..."

  local pkgs=("git" "base-devel")

  for pkg in "${pkgs[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      log_warn "Missing $pkg → installing"
      sudo pacman -S --needed --noconfirm "$pkg" || {
        log_error "Failed to install $pkg"
        record_fail "bootstrap:$pkg"
      }
    fi
  done
}

# ─────────────────────────────────────────────
# 🧠 Install paru (AUR helper)
# ─────────────────────────────────────────────
install_paru() {
  if [[ "$SKIP_AUR" == "true" ]]; then
    log_warn "Skipping paru install (AUR disabled)"
    return
  fi

  if command -v paru &>/dev/null; then
    log_ok "paru already installed"
    return
  fi

  log_warn "paru not found → installing..."

  tmp=$(mktemp -d)

  if git clone https://aur.archlinux.org/paru.git "$tmp/paru"; then
    (
      cd "$tmp/paru" || exit 1
      makepkg -si --noconfirm
    ) || {
      log_error "paru build failed"
      record_fail "paru bootstrap"
    }
  else
    log_error "paru clone failed"
    record_fail "paru bootstrap"
  fi

  rm -rf "$tmp"

  if command -v paru &>/dev/null; then
    log_ok "paru installed"
  else
    log_error "paru installation failed"
    record_fail "paru bootstrap"
  fi
}

# ─────────────────────────────────────────────
# 🧠 Bootstrap system (multilib + sync)
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
    sudo pacman -Syu --noconfirm
  else
    log_warn "Skipping full upgrade (use --full-upgrade to enable)"
    log_info "Refreshing package database..."
    sudo pacman -Sy --noconfirm
  fi
}

# ─────────────────────────────────────────────
# 🚀 BOOTSTRAP STAGE
# ─────────────────────────────────────────────
ensure_system_tools
install_paru
bootstrap_system

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 No_Maidens_UwU Installer Initializing..."
echo "⚙️ Dry run: $DRY_RUN_MODE"
echo "🧠 Auto deps: $AUTO_DEPENDENCY"
echo "📦 Full upgrade: $FULL_UPGRADE"

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
    record_fail "module:$module"
  fi
done

# ─────────────────────────────────────────────
# Execution pipeline
# ─────────────────────────────────────────────
run_all() {
  run_pacman

  if [[ "$SKIP_AUR" != "true" ]]; then
    run_aur
  else
    log_warn "Skipping AUR stage"
  fi

  run_dotfiles
  run_ime_setup
  run_gnomeext
  run_services
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