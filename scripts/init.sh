#!/bin/bash
set -euo pipefail

INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────
# Defaults
# ─────────────────────────────────────────────
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false
AUTO_DEPENDENCY=true
FULL_UPGRADE=false

# ─────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────
show_help() {
  cat <<EOF
Usage: ./init.sh [options]

Options:
  --dry-run         Simulate actions (no changes)
  --force           Force overwrite where applicable
  --verbose         Enable debug output
  --skip-aur        Skip AUR packages
  --diagnose        Run checks only (no installs)
  --no-auto-deps    Skip dependency resolver
  --full-upgrade    Run full system upgrade (pacman -Syu)
  --help            Show this help
EOF
}

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
    --help) show_help; exit 0 ;;
    *) echo "⚠️ Unknown flag: $1" ;;
  esac
  shift
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE AUTO_DEPENDENCY FULL_UPGRADE

# Verbose mode
if [[ "$VERBOSE_MODE" == "true" ]]; then
  set -x
fi

# ─────────────────────────────────────────────
# Core
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# Dependency resolver (optional)
# ─────────────────────────────────────────────
if [[ "$AUTO_DEPENDENCY" == "true" ]]; then
  resolve_dependencies
else
  log_warn "Skipping dependency resolver"
fi

# ─────────────────────────────────────────────
# Base system tools
# ─────────────────────────────────────────────
ensure_system_tools() {
  log_info "Checking base system tools..."

  local pkgs=("git" "base-devel")

  for pkg in "${pkgs[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      log_warn "Missing $pkg → installing"
      dry sudo pacman -S --needed --noconfirm "$pkg" || record_fail "bootstrap:$pkg"
    fi
  done
}

# ─────────────────────────────────────────────
# Paru bootstrap
# ─────────────────────────────────────────────
install_paru() {
  [[ "$SKIP_AUR" == "true" ]] && return

  if command -v paru &>/dev/null; then
    log_ok "paru already installed"
    return
  fi

  log_warn "Installing paru..."

  tmp=$(mktemp -d)

  if dry git clone https://aur.archlinux.org/paru.git "$tmp/paru"; then
    (
      cd "$tmp/paru" || exit 1
      dry makepkg -si --noconfirm
    ) || record_fail "paru build"
  else
    record_fail "paru clone"
  fi

  rm -rf "$tmp"
}

# ─────────────────────────────────────────────
# System bootstrap
# ─────────────────────────────────────────────
bootstrap_system() {
  log_info "Checking multilib repo..."

  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_warn "Enabling multilib repo..."
    dry sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
  fi

  if [[ "$FULL_UPGRADE" == "true" ]]; then
    log_info "Full upgrade"
    dry sudo pacman -Syu --noconfirm
  else
    log_info "Refreshing package database"
    dry sudo pacman -Sy --noconfirm
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
run_diagnose() {
  log_info "Running diagnostics..."

  for cmd in git pacman paru; do
    if command -v "$cmd" &>/dev/null; then
      log_ok "$cmd found"
    else
      log_warn "$cmd missing"
    fi
  done

  log_ok "Diagnostics complete"
}

# ─────────────────────────────────────────────
# Bootstrap stage
# ─────────────────────────────────────────────
ensure_system_tools
install_paru
bootstrap_system

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 Installer starting..."
echo "⚙️ Dry run: $DRY_RUN_MODE | Verbose: $VERBOSE_MODE | Diagnose: $DIAGNOSE_MODE"

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
  source "$INIT_DIR/$module" || record_fail "module:$module"
done

# ─────────────────────────────────────────────
# Execution
# ─────────────────────────────────────────────
if [[ "$DIAGNOSE_MODE" == "true" ]]; then
  run_diagnose
else
  run_pacman

  [[ "$SKIP_AUR" != "true" ]] && run_aur

  run_dotfiles
  run_ime_setup
  run_gnomeext
  run_services
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────
echo
if (( ${#FAILED_ITEMS[@]} > 0 )); then
  log_warn "Failures:"
  for f in "${FAILED_ITEMS[@]}"; do
    echo "  - $f"
  done
else
  log_ok "All tasks successful"
fi

echo
log_ok "🎉 Done"