#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

EXT="$HOME/.local/share/gnome-shell/extensions"

install_ext() {
  local name="$1"
  local cmd="$2"

  checkpoint "Installing $name"

  dry bash -c "$cmd" &&
    victory "$name installed" ||
    error "$name failed"
}

run_gnomeext() {
  mkdir -p "$EXT"

  install_ext "Blur My Shell" '
    tmp=$(mktemp -d)
    git clone https://github.com/aunetx/blur-my-shell "$tmp"
    make -C "$tmp" install SHELL_VERSION_OVERRIDE=""
    rm -rf "$tmp"
  '

  install_ext "Clipboard Indicator" '
    tmp=$(mktemp -d)
    git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp"

    ext_dir="$EXT/clipboard-indicator@tudmotu.com"
    rm -rf "$ext_dir"
    mv "$tmp" "$ext_dir"
  '

  install_ext "AppIndicator" '
    tmp=$(mktemp -d)
    build=$(mktemp -d)

    git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp"
    cd "$tmp"

    meson setup "$build"
    ninja -C "$build" install

    rm -rf "$tmp" "$build"
  '

  install_ext "Internet Speed Meter" '
    tmp=$(mktemp -d)
    git clone https://github.com/AlShakib/InternetSpeedMeter.git "$tmp"
    bash "$tmp/install.sh"
    rm -rf "$tmp"
  '

  install_ext "Weekly Commits" '
    tmp=$(mktemp -d)
    git clone https://github.com/funinkina/weekly-commits.git "$tmp"

    ext_dir="$EXT/weekly-commits@funinkina.is-a.dev"
    rm -rf "$ext_dir"
    mv "$tmp/weekly-commits" "$ext_dir"
  '

  install_ext "Kimpanel" '
    tmp=$(mktemp -d)
    git clone https://github.com/wengxt/gnome-shell-extension-kimpanel.git "$tmp"
    bash "$tmp/install.sh"
    rm -rf "$tmp"
  '

  echo
}

# ─────────────────────────────
# Standalone execution support
# ─────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_gnomeext
fi
