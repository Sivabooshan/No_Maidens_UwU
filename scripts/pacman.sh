#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# PACMAN PACKAGE LIST
# ─────────────────────────────────────────────
PACMAN_PKGS=(
  "Meson|meson"
  "Ninja|ninja"
  "CMake|cmake"
  "Zip|zip"
  "JQ|jq"

  # ───────── NVIDIA STACK ─────────
  "NVIDIA Driver|nvidia nvidia-utils"
  "NVIDIA 32-bit libs|lib32-nvidia-utils"

  # ───────── VULKAN STACK ─────────
  "Vulkan Loader|vulkan-icd-loader"
  "Vulkan 32-bit Loader|lib32-vulkan-icd-loader"
  "Vulkan Tools|vulkan-tools"

  # ───────── GAMING ─────────
  "Gamemode|gamemode"
  "Gamemode 32-bit|lib32-gamemode"

  # ───────── GNOME / SYSTEM ─────────
  "Extension Manager|extension-manager"
  "GNU Stow|stow"
  "Flatpak|flatpak"

  # ───────── APPS ─────────
  "Tor Browser|torbrowser-launcher"
  "Discord|discord"
  "Telegram|telegram-desktop"
  "Strawberry|strawberry"
  "VLC|vlc"
  "mpv|mpv"
  "EasyEffects|easyeffects"

  # ───────── AUDIO STACK ─────────
  "PipeWire|pipewire"
  "PipeWire Pulse|pipewire-pulse"
  "WirePlumber|wireplumber"

  # ───────── OFFICE / MEDIA ─────────
  "LibreOffice|libreoffice-still"
  "Calibre|calibre"
  "Okular|okular"
  "KDE Connect|kdeconnect"
  "Timeshift|timeshift"
  "qBittorrent|qbittorrent"

  # ───────── SHELL / TOOLS ─────────
  "Zsh|zsh"
  "Ghostty|ghostty"
  "Starship|starship"
  "tmux|tmux"
  "gThumb|gthumb"

  # ───────── INPUT METHOD ─────────
  "Fcitx5 Core|fcitx5"
  "Fcitx5 GTK|fcitx5-gtk"
  "Fcitx5 Config|fcitx5-configtool"
  "Mozc IME|fcitx5-mozc"

  # ───────── FONTS / DEV ─────────
  "Noto Fonts|noto-fonts-cjk"
  "Neovim|neovim"
  "Fastfetch|fastfetch"
)

PACMAN_TOTAL=${#PACMAN_PKGS[@]}
PACMAN_CURRENT=0

install_pkg() {
  local name="$1"
  local pkgs="$2"

  PACMAN_CURRENT=$((PACMAN_CURRENT + 1))
  show_progress "$PACMAN_CURRENT" "$PACMAN_TOTAL" "$name"
  printf "\n"

  # Check ALL packages
  local all_installed=true
  for p in $pkgs; do
    if ! pacman -Q "$p" &>/dev/null; then
      all_installed=false
      break
    fi
  done

  if $all_installed; then
    log_ok "$name already installed"
    return
  fi

  if dry sudo pacman -S --needed --noconfirm $pkgs; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    record_fail "$name (pacman)"
  fi
}

run_pacman() {
  log_info "Pacman install started"

  for entry in "${PACMAN_PKGS[@]}"; do
    install_pkg "${entry%%|*}" "${entry##*|}"
  done

  echo
}