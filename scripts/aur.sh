#!/bin/bash

source "$(dirname "$0")/core.sh"

AUR_PKGS=(
  "Zen Browser:zen-browser-bin"
  "ProtonUp-Qt:protonup-qt"
  "Proton VPN:proton-vpn-gtk-app"
  "LocalSend:localsend-bin"
  "YASP:yasp"
  "Stacher7:stacher7"
  "Pomodoro:gnome-shell-pomodoro"
  "ZapZap:zapzap-git"
  "Music Presence:music-presence-bin"
  "Memento:memento"
  "Telegram Video Downloader:tdl"
  "Minecraft:sklauncher"
)

AUR_TOTAL=${#AUR_PKGS[@]}
AUR_CURRENT=0

install_aur() {
  local name="$1"
  local pkg="$2"

  if is_installed "$pkg"; then
    ok "$name already installed"
    return
  fi

  AUR_CURRENT=$((AUR_CURRENT + 1))
  show_progress "$AUR_CURRENT" "$AUR_TOTAL" "$name"

  if dry paru -S --needed --noconfirm "$pkg"; then
    ok "$name installed"
  else
    error "$name failed"
  fi
}

run_aur() {
  command -v paru &>/dev/null || {
    warn "paru not installed, skipping AUR"
    return
  }

  info "Installing AUR packages"

  for entry in "${AUR_PKGS[@]}"; do
    name="${entry%%:*}"
    pkg="${entry##*:}"

    install_aur "$name" "$pkg"
  done

  echo
}
