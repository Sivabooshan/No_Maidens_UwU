#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

PACMAN_PKGS=(
  "Meson:meson"
  "Ninja:ninja"
  "Cmake:cmake"
  "Zip:zip"
  "JQ:jq"
  "NVIDIA driver:nvidia nvidia-utils"
  "NVIDIA utils:lib32-nvidia-utils"
  "Vulken loader:vulkan-icd-loader"
  "Vulken loader(32-bit libraries): lib32-vulkan-icd-loader"
  "Vulken Tools:vulkan-tools"
  "Gamemode:gamemode"
  "Gamemode(32-bit libraries):lib32-gamemode"
  "Extension Manager:extension-manager"
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
  "Mozc IME:fcitx5-mozc"
  "Noto Fonts:noto-fonts-cjk"
  "Neovim:neovim"
  "Fastfetch:fastfetch"
  "Flatpak:flatpak"
)

PACMAN_TOTAL=${#PACMAN_PKGS[@]}
PACMAN_CURRENT=0

install_pkg() {
  local name="$1"
  local pkg="$2"

  PACMAN_CURRENT=$((PACMAN_CURRENT + 1))
  show_progress "$PACMAN_CURRENT" "$PACMAN_TOTAL" "$name"
  printf "\r"

  if is_installed "$pkg"; then
    log_ok "$name already installed"
    return
  fi

  if dry sudo pacman -S --needed --noconfirm "$pkg"; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    record_fail "$name (pacman)"
  fi
}

run_pacman() {
  log_info "Pacman install started"

  for entry in "${PACMAN_PKGS[@]}"; do
    install_pkg "${entry%%:*}" "${entry##*:}"
  done

  echo
}
