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
  "Entr|entr"
  "WL Clipboard|wl-clipboard"

  # ───────── GNOME / SYSTEM ─────────
  "Extension Manager|extension-manager"
  "GNU Stow|stow"
  "Tree|tree"
  "Flatpak|flatpak"
  "UFW Firewall|ufw"

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

# ─────────────────────────────────────────────
# Install a single entry (only missing pkgs)
# ─────────────────────────────────────────────
install_pkg() {
  local name="$1"
  local pkgs="$2"

  PACMAN_CURRENT=$((PACMAN_CURRENT + 1))
  show_progress "$PACMAN_CURRENT" "$PACMAN_TOTAL" "$name"
  printf "\n"

  # Convert to array safely
  read -r -a pkg_array <<< "$pkgs"

  # Find missing packages
  local missing_pkgs=()
  for p in "${pkg_array[@]}"; do
    if ! pacman -Q "$p" &>/dev/null; then
      missing_pkgs+=("$p")
    fi
  done

  # Skip if everything is already installed
  if (( ${#missing_pkgs[@]} == 0 )); then
    log_ok "$name already installed"
    return 0
  fi

  log_info "Installing $name"

  # Install only missing packages with retry + logging
  if with_retry dry sudo pacman -S --needed --noconfirm "${missing_pkgs[@]}" >>"$LOG_FILE" 2>&1; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    record_fail "$name (pacman)"
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_pacman() {
  log_info "Diagnosing pacman packages..."

  for entry in "${PACMAN_PKGS[@]}"; do
    local name="${entry%%|*}"
    local pkgs="${entry##*|}"

    read -r -a pkg_array <<< "$pkgs"

    local all_installed=true
    for p in "${pkg_array[@]}"; do
      if ! pacman -Q "$p" &>/dev/null; then
        all_installed=false
        break
      fi
    done

    if $all_installed; then
      log_ok "$name installed"
    else
      log_warn "$name missing"
    fi
  done

  echo
  log_ok "Pacman diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_pacman() {

  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_pacman
    return
  fi

  log_info "Pacman install started"

  for entry in "${PACMAN_PKGS[@]}"; do
    install_pkg "${entry%%|*}" "${entry##*|}"
  done

  echo
}