#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# 🏴‍☠️ Main Orchestrator - No Maidens UwU
# ─────────────────────────────────────────────

echo "🔥 MAIN.SH STARTED"

# ─────────────────────────────────────────────
# Load modules
# ─────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/core.sh"
source "$SCRIPT_DIR/pacman.sh"
source "$SCRIPT_DIR/aur.sh"
source "$SCRIPT_DIR/dotfiles.sh"
source "$SCRIPT_DIR/gnomeext.sh"

# ─────────────────────────────────────────────
# Flags
# ─────────────────────────────────────────────

DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false
DIAGNOSE_MODE=false

process_flags() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --dry-run)
      DRY_RUN_MODE=true
      ;;
    --force)
      FORCE_MODE=true
      ;;
    --verbose)
      VERBOSE_MODE=true
      ;;
    --skip-aur)
      SKIP_AUR=true
      ;;
    --diagnose)
      DIAGNOSE_MODE=true
      ;;
    -h | --help)
      echo "Usage: $0 [--dry-run] [--force] [--verbose] [--skip-aur] [--diagnose]"
      exit 0
      ;;
    *)
      echo "Unknown flag: $1"
      exit 1
      ;;
    esac
    shift
  done
}

process_flags "$@"

export DRY_RUN_MODE FORCE_MODE VERBOSE_MODE SKIP_AUR DIAGNOSE_MODE

# ─────────────────────────────────────────────
# Sanity check
# ─────────────────────────────────────────────

echo "📦 Modules loaded"
echo "⚙️  Dry run: $DRY_RUN_MODE"
echo "⚙️  Force: $FORCE_MODE"

# ─────────────────────────────────────────────
# Run diagnostics if requested
# ─────────────────────────────────────────────

if [[ "$DIAGNOSE_MODE" == "true" ]]; then
  run_sacred_diagnostics
  exit 0
fi

# ─────────────────────────────────────────────
# Ensure main function exists
# ─────────────────────────────────────────────

if ! declare -F begin_sacred_ritual >/dev/null; then
  echo "❌ ERROR: begin_sacred_ritual not found (core.sh not loaded correctly)"
  exit 1
fi

# ─────────────────────────────────────────────
# EXECUTION
# ─────────────────────────────────────────────

begin_sacred_ritual "$@"
