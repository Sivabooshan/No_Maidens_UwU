#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# AUR PACKAGE LIST
# ─────────────────────────────────────────────
AUR_PKGS=(
  "Zen Browser|zen-browser-bin"
  "ProtonUp-Qt|protonup-qt"
  "Proton VPN|proton-vpn-gtk-app"
  "LocalSend|localsend-bin"
  "Stacher7|stacher7"
  "Pomodoro|gnome-shell-pomodoro"
  "ZapZap|zapzap-git"
  "Music Presence|music-presence-bin"
  "Memento|memento"
  "Telegram Downloader|tdl"
  "Minecraft|sklauncher"
  "VS Code|visual-studio-code-bin"
  "Steam|steam"
  "Waydroid|waydroid"
  "Waydroid Gapps|waydroid-image-gapps"
  "Jackett|jackett"
)

AUR_TOTAL=${#AUR_PKGS[@]}
AUR_CURRENT=0

# ─────────────────────────────────────────────
# Install single AUR package
# ─────────────────────────────────────────────
install_aur_pkg() {
  local name="$1"
  local pkg="$2"

  AUR_CURRENT=$((AUR_CURRENT + 1))
  show_progress "$AUR_CURRENT" "$AUR_TOTAL" "$name"
  printf "\n"

  # Check if already installed
  if pacman -Q "$pkg" &>/dev/null; then
    log_ok "$name already installed"
    return 0
  fi

  log_info "Installing $name (AUR)"

  # Install with retry + logging
  if with_retry paru -S --needed --noconfirm "$pkg" >>"$LOG_FILE" 2>&1; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    record_fail "$name (aur)"
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode (no installs)
# ─────────────────────────────────────────────
diagnose_aur() {
  log_info "Diagnosing AUR packages..."

  for entry in "${AUR_PKGS[@]}"; do
    local name="${entry%%|*}"
    local pkg="${entry##*|}"

    if pacman -Q "$pkg" &>/dev/null; then
      log_ok "$name installed"
    else
      log_warn "$name missing"
    fi
  done

  echo
  log_ok "AUR diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_aur() {

  # Respect global skip flag
  if [[ "$SKIP_AUR" == "true" ]]; then
    log_warn "Skipping AUR (flag enabled)"
    return
  fi

  # Ensure paru exists
  if ! command -v paru &>/dev/null; then
    log_error "paru not found (bootstrap failed?)"
    record_fail "paru missing"
    return
  fi

  # Diagnose mode
  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_aur
    return
  fi

  log_info "AUR install started"

  for entry in "${AUR_PKGS[@]}"; do
    install_aur_pkg "${entry%%|*}" "${entry##*|}"
  done

  echo
}