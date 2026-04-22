#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
FAILED_EXTENSIONS=()

mkdir -p "$EXT_DIR"

# ─────────────────────────────────────────────
# Enable extension safely
# ─────────────────────────────────────────────
enable_extension() {
  local uuid="$1"

  if command -v gnome-extensions &>/dev/null; then
    dry gnome-extensions enable "$uuid" &>/dev/null && \
      log_ok "Enabled $uuid" || \
      log_warn "Could not enable $uuid"
  fi
}

# ─────────────────────────────────────────────
# Enable all installed extensions
# ─────────────────────────────────────────────
auto_enable_all() {
  log_info "Auto-enabling extensions..."

  if ! command -v gnome-extensions &>/dev/null; then
    log_warn "gnome-extensions not found"
    return
  fi

  while read -r ext; do
    dry gnome-extensions enable "$ext" &>/dev/null || true
  done < <(gnome-extensions list 2>/dev/null)

  log_ok "Extensions enabled"
}

# ─────────────────────────────────────────────
# Install extension wrapper
# ─────────────────────────────────────────────
install_ext() {
  local name="$1"
  local script="$2"

  log_info "Installing $name"

  if dry bash -c "set -euo pipefail; $script"; then
    log_ok "$name installed"
  else
    log_error "$name failed"
    FAILED_EXTENSIONS+=("$name")
    record_fail "gnomeext:$name"
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_gnomeext() {
  log_info "Diagnosing GNOME extensions..."

  if command -v gnome-extensions &>/dev/null; then
    log_ok "gnome-extensions available"
  else
    log_warn "gnome-extensions missing"
  fi

  local count
  count=$(gnome-extensions list 2>/dev/null | wc -l || echo 0)
  log_info "Installed extensions: $count"

  log_ok "GNOME extension diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_gnomeext() {

  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_gnomeext
    return
  fi

  log_info "GNOME extensions setup started"

  # ───────────── Blur My Shell ─────────────
  install_ext "Blur My Shell" '
    command -v git >/dev/null
    command -v make >/dev/null

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/aunetx/blur-my-shell "$tmp"

    cd "$tmp"
    make install SHELL_VERSION_OVERRIDE=""
    rm -rf "$tmp"
  '

  # ───────────── Clipboard Indicator ─────────────
  install_ext "Clipboard Indicator" '
    command -v git >/dev/null

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp"

    ext_dir="$HOME/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com"
    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"
    cp -r "$tmp"/* "$ext_dir"/

    rm -rf "$tmp"
  '

  # ───────────── AppIndicator ─────────────
  install_ext "AppIndicator" '
    command -v git >/dev/null
    command -v meson >/dev/null
    command -v ninja >/dev/null

    tmp=$(mktemp -d)
    build=$(mktemp -d)

    git clone --depth=1 https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp"

    cd "$tmp"
    meson setup "$build" --prefix="$HOME/.local"
    ninja -C "$build"
    ninja -C "$build" install

    rm -rf "$tmp" "$build"
  '

  # ───────────── Internet Speed Meter ─────────────
  install_ext "Internet Speed Meter" '
    command -v git >/dev/null

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/AlShakib/InternetSpeedMeter.git "$tmp"

    bash "$tmp/install.sh"
    rm -rf "$tmp"
  '

  # ───────────── Weekly Commits ─────────────
  install_ext "Weekly Commits" '
    command -v git >/dev/null

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/funinkina/weekly-commits.git "$tmp"

    ext_src=$(find "$tmp" -type f -name "metadata.json" -print -quit | xargs dirname)

    [[ -d "$ext_src" ]]

    ext_dir="$HOME/.local/share/gnome-shell/extensions/weekly-commits@funinkina.is-a.dev"
    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    cp -r "$ext_src"/* "$ext_dir"/

    rm -rf "$tmp"
  '

  # ───────────── Kimpanel ─────────────
  install_ext "Kimpanel" '
    command -v git >/dev/null
    command -v cmake >/dev/null
    command -v zip >/dev/null

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/wengxt/gnome-shell-extension-kimpanel.git "$tmp"

    cd "$tmp"

    if [[ -f install.sh ]]; then
      bash install.sh
    else
      echo "Missing install.sh"
      exit 1
    fi

    rm -rf "$tmp"
  '

  echo

  auto_enable_all

  # ─────────────────────────────
  # Summary
  # ─────────────────────────────
  if (( ${#FAILED_EXTENSIONS[@]} > 0 )); then
    log_warn "Some GNOME extensions failed:"
    for f in "${FAILED_EXTENSIONS[@]}"; do
      echo "  - $f"
    done
  else
    log_ok "All GNOME extensions installed"
  fi
}