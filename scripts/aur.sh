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
  "ZapZap|zapzap"
  "Music Presence|music-presence-bin"
  "Memento|memento"
  "Telegram Downloader|tdl"
  "Minecraft|sklauncher"
  "VS Code|visual-studio-code-bin"
  "Steam|steam"
)

AUR_TOTAL=${#AUR_PKGS[@]}
AUR_CURRENT=0

install_aur_pkg() {
  local name="$1"
  local pkg="$2"

  AUR_CURRENT=$((AUR_CURRENT + 1))
  show_progress "$AUR_CURRENT" "$AUR_TOTAL" "$name"
  printf "\n"

  if pacman -Q "$pkg" &>/dev/null; then
    log_ok "$name already installed"
    return
  fi

  if dry paru -S --needed --noconfirm "$pkg"; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    record_fail "$name (aur)"
  fi
}

run_aur() {
  if [[ "$SKIP_AUR" == "true" ]]; then
    log_warn "Skipping AUR (flag enabled)"
    return
  fi

  if ! command -v paru &>/dev/null; then
    log_warn "paru not found - installing..."

    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
  fi

  log_info "AUR install started"

  for entry in "${AUR_PKGS[@]}"; do
    install_aur_pkg "${entry%%|*}" "${entry##*|}"
  done

  echo
}