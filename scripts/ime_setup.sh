#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# IME / Japanese Input Setup (Fcitx5 + Wayland-safe)
# Uses: ~/.config/environment.d (systemd user env)
# ─────────────────────────────────────────────────────────────

checkpoint "IME setup (Fcitx5 environment.d)"

ENV_DIR="$HOME/.config/environment.d"
ENV_FILE="$ENV_DIR/99-ime.conf"

mkdir -p "$ENV_DIR"

updated=false

add_var() {
  local key="$1"
  local value="$2"

  if ! grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    echo "${key}=${value}" >>"$ENV_FILE"
    updated=true
  fi
}

# GTK apps
add_var "GTK_IM_MODULE" "fcitx5"

# Qt apps
add_var "QT_IM_MODULE" "fcitx5"

# X11 compatibility
add_var "XMODIFIERS" "@im=fcitx5"

# SDL apps (games/emulators)
add_var "SDL_IM_MODULE" "fcitx5"

# Optional but recommended for Wayland apps
add_var "INPUT_METHOD" "fcitx5"
add_var "XMODIFIER" "@im=fcitx5"

if [[ "$updated" == true ]]; then
  celebrate_victory "Fcitx5 environment.d configured"

  echo
  echo "⚠️  Important:"
  echo "   You must log out and log back in for changes to apply."
else
  echo "✓ Fcitx5 IME already configured (environment.d)"
fi
