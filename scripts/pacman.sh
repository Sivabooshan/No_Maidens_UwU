#!/bin/bash

source "$(dirname "$0")/core.sh"

PACMAN_PKGS=(
  "GNU Stow:stow"
  "Tor Browser:torbrowser-launcher"
  "Discord:discord"
  "Telegram:telegram-desktop"
  "Strawberry:strawberry"
  "VLC:vlc"
  "mpv:mpv"
  "LibreOffice:libreoffice-still"
  "Calibre:calibre"
  "Okular:okular"
  "KDE Connect:kdeconnect"
  "Timeshift:timeshift"
  "qBittorrent:qbittorrent"
  "Zsh:zsh"
  "Ghostty:ghostty"
  "Starship:starship"
  "tmux:tmux"
  "gThumb:gthumb"
  "Fcitx5 Core:fcitx5"
  "Fcitx5 GTK:fcitx5-gtk"
  "Fcitx5 Config:fcitx5-configtool"
  "Mozc Japanese IME:fcitx5-mozc"
  "Japanese Fonts:noto-fonts-cjk"
  "MKVToolNix GUI:mkvtoolnix-gui"
  "Hyprland Portal (Hyprland):xdg-desktop-portal-hyprland"
  "Hyprland Portal (GTK):xdg-desktop-portal-gtk"
  "Neovim:neovim"
  "Fastfetch:fastfetch"
  "Entr:entr"
  "Hyprland:hyprland"
  "Flatpak:flatpak"
  "Build Essentials:base-devel"
  "CMake:cmake"
  "jq:jq"
  "Zip:zip"
  "Gettext:gettext"
  "Flameshot:flameshot"
)

PACMAN_TOTAL=${#PACMAN_PKGS[@]}
PACMAN_CURRENT=0

install_pacman() {
  local name="$1"
  local pkg="$2"

  if is_installed "$pkg"; then
    ok "$name already installed"
    return
  fi

  PACMAN_CURRENT=$((PACMAN_CURRENT + 1))
  show_progress "$PACMAN_CURRENT" "$PACMAN_TOTAL" "$name"

  if dry sudo pacman -S --needed --noconfirm "$pkg"; then
    ok "$name installed"
  else
    error "$name failed"
  fi
}

run_pacman() {
  info "Installing Pacman packages"

  for entry in "${PACMAN_PKGS[@]}"; do
    name="${entry%%:*}"
    pkg="${entry##*:}"

    install_pacman "$name" "$pkg"
  done

  echo
}
