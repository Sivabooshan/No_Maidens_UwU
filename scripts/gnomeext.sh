#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

EXT="$HOME/.local/share/gnome-shell/extensions"

FAILED_EXTENSIONS=()

install_ext() {
  local name="$1"
  local func="$2"

  log_info "Installing $name"

  if dry bash -c "set -euo pipefail; $func"; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    FAILED_EXTENSIONS+=("$name")
  fi
}

run_gnomeext() {

  mkdir -p "$EXT"

  # ─────────────────────────────
  # Blur My Shell
  # ─────────────────────────────
  install_ext "Blur My Shell" '
    command -v git >/dev/null || exit 1
    command -v make >/dev/null || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/aunetx/blur-my-shell "$tmp"

    make -C "$tmp" install SHELL_VERSION_OVERRIDE=""

    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Clipboard Indicator
  # ─────────────────────────────
  install_ext "Clipboard Indicator" '
    command -v git >/dev/null || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp"

    ext_dir="$HOME/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com"

    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    cp -r "$tmp"/. "$ext_dir"/
    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # AppIndicator (DEBUG ENABLED)
  # ─────────────────────────────
  install_ext "AppIndicator" '
    command -v git >/dev/null || exit 1
    command -v meson >/dev/null || exit 1
    command -v ninja >/dev/null || exit 1

    tmp=$(mktemp -d)
    build=$(mktemp -d)

    git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp"
    cd "$tmp"

    meson setup "$build" --prefix="$HOME/.local"
    ninja -C "$build"
    ninja -C "$build" install

    rm -rf "$tmp" "$build"
  '

  # ─────────────────────────────
  # Internet Speed Meter
  # ─────────────────────────────
  install_ext "Internet Speed Meter" '
    command -v git >/dev/null || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/AlShakib/InternetSpeedMeter.git "$tmp"

    bash "$tmp/install.sh"

    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Weekly Commits (SAFE)
  # ─────────────────────────────
  install_ext "Weekly Commits" '
    command -v git >/dev/null || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/funinkina/weekly-commits.git "$tmp"

    ext_src=$(find "$tmp" -name "metadata.json" -exec dirname {} \; | head -n 1)

    if [[ -z "$ext_src" || ! -d "$ext_src" ]]; then
      echo "Failed to locate Weekly Commits extension directory"
      exit 1
    fi

    ext_dir="$HOME/.local/share/gnome-shell/extensions/weekly-commits@funinkina.is-a.dev"

    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    cp -r "$ext_src"/. "$ext_dir"/

    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Kimpanel (FIXED WORKDIR)
  # ─────────────────────────────
  install_ext "Kimpanel" '
    command -v git >/dev/null || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/wengxt/gnome-shell-extension-kimpanel.git "$tmp"

    cd "$tmp"

    bash install.sh

    rm -rf "$tmp"
  '

  echo

  # ─────────────────────────────
  # FINAL REPORT
  # ─────────────────────────────
  if ((${#FAILED_EXTENSIONS[@]} > 0)); then
    log_warn "Some GNOME extensions failed:"
    for f in "${FAILED_EXTENSIONS[@]}"; do
      echo "  - $f"
    done
  else
    log_ok "All GNOME extensions installed successfully"
  fi
}

# ─────────────────────────────
# Standalone execution
# ─────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_gnomeext
fi