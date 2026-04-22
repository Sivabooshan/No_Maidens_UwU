#!/usr/bin/env bash
set -euo pipefail

run_ime_setup() {
  info "IME setup (Fcitx5 environment.d)"

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

  add_var "GTK_IM_MODULE" "fcitx5"
  add_var "QT_IM_MODULE" "fcitx5"
  add_var "XMODIFIERS" "@im=fcitx5"
  add_var "SDL_IM_MODULE" "fcitx5"
  add_var "INPUT_METHOD" "fcitx5"

  if [[ "$updated" == true ]]; then
    ok "Fcitx5 environment.d configured"
    echo "⚠️ Log out and log in required"
  else
    ok "Fcitx5 IME already configured (environment.d)"
  fi
}