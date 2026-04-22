#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────
# Root directory detection
# ─────────────────────────────────────────────
INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─────────────────────────────────────────────
# Core loader (singleton-safe)
# ─────────────────────────────────────────────
source "$INIT_DIR/core.sh"

# ─────────────────────────────────────────────
# Global flags (default values)
# ─────────────────────────────────────────────
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false

# ─────────────────────────────────────────────
# CLI argument parser
# ─────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN_MODE=true
    shift
    ;;
  --force)
    FORCE_MODE=true
    shift
    ;;
  --verbose)
    VERBOSE_MODE=true
    shift
    ;;
  --skip-aur)
    SKIP_AUR=true
    shift
    ;;
  --diagnose)
    DIAGNOSE_MODE=true
    shift
    ;;
  *)
    warn "Unknown flag: $1"
    shift
    ;;
  esac
done

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo "🔥 No_Maidens_UwU Installer Initializing..."
echo "⚙️  Dry run: $DRY_RUN_MODE"

# ─────────────────────────────────────────────
# Module loader (order matters)
# ─────────────────────────────────────────────
MODULES=(
  "pacman.sh"
  "aur.sh"
  "dotfiles.sh"
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
  run_gnomeext
}

run_all

echo
ok "🎉 All installation tasks completed"
