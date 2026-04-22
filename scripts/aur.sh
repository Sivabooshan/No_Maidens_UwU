#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

AUR_PKGS=(
  "Zen Browser:zen-browser-bin"
  "ProtonUp-Qt:protonup-qt"
  "Proton VPN:proton-vpn-gtk-app"
  "LocalSend:localsend-bin"
  "Stacher7:stacher7"
  "Pomodoro:gnome-shell-pomodoro"
  "ZapZap:zapzap"
  "Music Presence:music-presence-bin"
  "Memento:memento"
  "Telegram Downloader:tdl"
  "Minecraft:sklauncher"
)

AUR_TOTAL=${#AUR_PKGS[@]}
AUR_CURRENT=0

install_aur_pkg() {
  local name="$1"
  local pkg="$2"

  if is_installed "$pkg"; then
    log_ok "$name already installed"
    return
  fi

  AUR_CURRENT=$((AUR_CURRENT + 1))
  show_progress "$AUR_CURRENT" "$AUR_TOTAL" "$name"

  dry paru -S --needed --noconfirm "$pkg" && log_ok "$name installed" || log_error "$name failed"
}

run_aur() {
  command -v paru &>/dev/null || {
    log_warn "paru not found - skipping AUR"
    return
  }

  log_info "AUR install started"

  for entry in "${AUR_PKGS[@]}"; do
    install_aur_pkg "${entry%%:*}" "${entry##*:}"
  done

  echo
}
