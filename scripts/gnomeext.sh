#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
FAILED_EXTENSIONS=()

mkdir -p "$EXT_DIR"

# ─────────────────────────────────────────────
# Environment check
# ─────────────────────────────────────────────
is_gnome_session() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]]
}

# ─────────────────────────────────────────────
# Compile schemas (important for GNOME)
# ─────────────────────────────────────────────
compile_schemas() {
  if command -v glib-compile-schemas &>/dev/null; then
    glib-compile-schemas "$EXT_DIR" 2>/dev/null || true
  fi
}

# ─────────────────────────────────────────────
# Enable extension safely
# ─────────────────────────────────────────────
enable_extension() {
  local uuid="$1"

  if ! command -v gnome-extensions &>/dev/null; then
    log_warn "gnome-extensions not available"
    return
  fi

  if ! is_gnome_session; then
    log_warn "Not in GNOME session → cannot enable $uuid"
    return
  fi

  # Wait briefly for GNOME to register extension
  sleep 1

  if gnome-extensions list | grep -q "$uuid"; then
    if dry gnome-extensions enable "$uuid"; then
      log_ok "Enabled $uuid"
    else
      log_warn "Failed to enable $uuid"
    fi
  else
    log_warn "$uuid not found (not registered yet)"
  fi
}

# ─────────────────────────────────────────────
# Install extension wrapper
# ─────────────────────────────────────────────
install_ext() {
  local name="$1"
  local script="$2"
  local uuid="$3"

  log_info "Installing $name"

  if dry bash -c "set -euo pipefail; $script"; then
    log_ok "$name installed"

    compile_schemas

    if [[ -n "$uuid" ]]; then
      enable_extension "$uuid"
    fi
  else
    log_error "$name failed"
    FAILED_EXTENSIONS+=("$name")
    record_fail "gnomeext:$name"
  fi
}

# ─────────────────────────────────────────────
# Enable all installed extensions (fallback)
# ─────────────────────────────────────────────
auto_enable_all() {
  log_info "Auto-enabling extensions..."

  if ! command -v gnome-extensions &>/dev/null; then
    log_warn "gnome-extensions not found"
    return
  fi

  if ! is_gnome_session; then
    log_warn "Not in GNOME session → skipping auto-enable"
    return
  fi

  sleep 2

  while read -r ext; do
    dry gnome-extensions enable "$ext" &>/dev/null || true
  done < <(gnome-extensions list 2>/dev/null)

  log_ok "Extensions enabled"
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

  if is_gnome_session; then
    log_ok "Running inside GNOME session"
  else
    log_warn "Not running inside GNOME session"
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
    check_and_install git git
    check_and_install make base-devel

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/aunetx/blur-my-shell "$tmp"
    cd "$tmp"
    make install SHELL_VERSION_OVERRIDE=""
    rm -rf "$tmp"
  ' "blur-my-shell@aunetx"

  # ───────────── Clipboard Indicator ─────────────
  install_ext "Clipboard Indicator" '
    check_and_install git git

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp"

    ext_dir="$HOME/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com"
    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"
    cp -r "$tmp"/* "$ext_dir"/

    rm -rf "$tmp"
  ' "clipboard-indicator@tudmotu.com"

  # ───────────── AppIndicator ─────────────
  install_ext "AppIndicator" '
    check_and_install git git
    check_and_install meson meson
    check_and_install ninja ninja

    tmp=$(mktemp -d)
    build=$(mktemp -d)

    git clone --depth=1 https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp"

    cd "$tmp"
    meson setup "$build" --prefix="$HOME/.local"
    ninja -C "$build"
    ninja -C "$build" install

    rm -rf "$tmp" "$build"
  ' "appindicatorsupport@rgcjonas.gmail.com"

  # ───────────── Internet Speed Meter ─────────────
  install_ext "Internet Speed Meter" '
    check_and_install git git

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/AlShakib/InternetSpeedMeter.git "$tmp"

    bash "$tmp/install.sh"
    rm -rf "$tmp"
  ' "InternetSpeedMeter@alshakib"

  # ───────────── Weekly Commits ─────────────
  install_ext "Weekly Commits" '
    check_and_install git git

    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/funinkina/weekly-commits.git "$tmp"

    ext_src=$(find "$tmp" -type f -name "metadata.json" -print -quit | xargs dirname)

    ext_dir="$HOME/.local/share/gnome-shell/extensions/weekly-commits@funinkina.is-a.dev"
    rm -rf "$ext_dir"
    mkdir -p "$ext_dir"

    cp -r "$ext_src"/* "$ext_dir"/

    rm -rf "$tmp"
  ' "weekly-commits@funinkina.is-a.dev"

  # ───────────── Kimpanel ─────────────
  install_ext "Kimpanel" '
    check_and_install git git
    check_and_install cmake cmake
    check_and_install zip zip

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
  ' "kimpanel@kde.org"

  echo

  # Final fallback enable
  auto_enable_all

  # Summary
  if (( ${#FAILED_EXTENSIONS[@]} > 0 )); then
    log_warn "Some GNOME extensions failed:"
    for f in "${FAILED_EXTENSIONS[@]}"; do
      echo "  - $f"
    done
  else
    log_ok "All GNOME extensions installed and enabled"
  fi
}