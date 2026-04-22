#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

EXT="$HOME/.local/share/gnome-shell/extensions"

FAILED_EXTENSIONS=()

need_cmd() {
  command -v "$1" &>/dev/null || {
    log_warn "$1 missing (installing may fail)"
    return 1
  }
}

install_ext() {
  local name="$1"
  local func="$2"

  log_info "Installing $name"

  if dry "$func"; then
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
    tmp=$(mktemp -d)
    git clone https://github.com/aunetx/blur-my-shell "$tmp"
    make -C "$tmp" install SHELL_VERSION_OVERRIDE="" >/dev/null 2>&1
    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Clipboard Indicator (FIXED PATH)
  # ─────────────────────────────
  install_ext "Clipboard Indicator" '
    tmp=$(mktemp -d)
    git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp"

    ext_dir="$HOME/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com"

    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    mv "$tmp"/* "$ext_dir"/
    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # AppIndicator (FIXED deps check)
  # ─────────────────────────────
  install_ext "AppIndicator" '
    need_cmd meson || exit 1
    need_cmd ninja || exit 1

    tmp=$(mktemp -d)
    build=$(mktemp -d)

    git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp"
    cd "$tmp"

    meson setup "$build" >/dev/null 2>&1
    ninja -C "$build" install >/dev/null 2>&1

    rm -rf "$tmp" "$build"
  '

  # ─────────────────────────────
  # Internet Speed Meter
  # ─────────────────────────────
  install_ext "Internet Speed Meter" '
    tmp=$(mktemp -d)
    git clone https://github.com/AlShakib/InternetSpeedMeter.git "$tmp"
    bash "$tmp/install.sh"
    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Weekly Commits (FIXED structure)
  # ─────────────────────────────
  install_ext "Weekly Commits" '
    tmp=$(mktemp -d)
    git clone https://github.com/funinkina/weekly-commits.git "$tmp"

    ext_src=$(find "$tmp" -maxdepth 2 -type d -name "*weekly*" | head -n 1)
    ext_dir="$HOME/.local/share/gnome-shell/extensions/weekly-commits@funinkina.is-a.dev"

    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    mv "$ext_src"/* "$ext_dir"/
    rm -rf "$tmp"
  '

  # ─────────────────────────────
  # Kimpanel (FIXED deps check)
  # ─────────────────────────────
  install_ext "Kimpanel" '
    need_cmd cmake || exit 1

    tmp=$(mktemp -d)
    git clone https://github.com/wengxt/gnome-shell-extension-kimpanel.git "$tmp"

    bash "$tmp/install.sh"
    rm -rf "$tmp"
  '

  echo

  # ─────────────────────────────
  # FINAL FAILURE REPORT
  # ─────────────────────────────
  if (( ${#FAILED_EXTENSIONS[@]} > 0 )); then
    log_warn "Some GNOME extensions failed:"
    for f in "${FAILED_EXTENSIONS[@]}"; do
      echo "  - $f"
    done
  else
    log_ok "All GNOME extensions installed successfully"
  fi
}

# ─────────────────────────────
# Standalone execution support
# ─────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_gnomeext
fi