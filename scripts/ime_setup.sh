#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# Config
# ─────────────────────────────────────────────
ENV_FILE="$HOME/.config/environment.d/im.conf"

# ─────────────────────────────────────────────
# Set environment variables
# ─────────────────────────────────────────────
setup_env() {
  log_info "Configuring IME environment variables..."

  mkdir -p "$(dirname "$ENV_FILE")"

  if [[ -f "$ENV_FILE" && "$FORCE_MODE" != "true" ]]; then
    log_warn "Environment file exists (use --force to overwrite)"
    return 0
  fi

  if dry tee "$ENV_FILE" >/dev/null <<EOF
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
INPUT_METHOD=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
EOF
  then
    log_ok "Environment configured"
  else
    log_error "Failed to write environment config"
    record_fail "ime:env"
  fi
}

# ─────────────────────────────────────────────
# Setup fcitx5 config directory
# ─────────────────────────────────────────────
setup_fcitx_config() {
  log_info "Setting up fcitx5 configuration..."

  local conf_dir="$HOME/.config/fcitx5"

  if [[ -f "$conf_dir/profile" && "$FORCE_MODE" != "true" ]]; then
    log_warn "fcitx5 config exists (use --force to overwrite)"
    return 0
  fi

  dry mkdir -p "$conf_dir"

  # Minimal profile (Mozc + keyboard)
  if dry tee "$conf_dir/profile" >/dev/null <<EOF
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=mozc

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=mozc
Layout=
EOF
  then
    log_ok "fcitx5 profile configured"
  else
    log_error "Failed to configure fcitx5 profile"
    record_fail "ime:fcitx-profile"
  fi
}

# ─────────────────────────────────────────────
# Restart fcitx (optional)
# ─────────────────────────────────────────────
restart_fcitx() {
  log_info "Restarting fcitx5..."

  if ! command -v fcitx5 &>/dev/null; then
    log_warn "fcitx5 not installed"
    return
  fi

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    log_warn "[DRY RUN] Would restart fcitx5"
    return
  fi

  pkill fcitx5 &>/dev/null || true
  fcitx5 -d &>/dev/null &

  log_ok "fcitx5 restarted"
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_ime() {
  log_info "Diagnosing IME setup..."

  if command -v fcitx5 &>/dev/null; then
    log_ok "fcitx5 installed"
  else
    log_warn "fcitx5 missing"
  fi

  if [[ -f "$ENV_FILE" ]]; then
    log_ok "Environment file exists"
  else
    log_warn "Environment file missing"
  fi

  if [[ -d "$HOME/.config/fcitx5" ]]; then
    log_ok "fcitx5 config directory exists"
  else
    log_warn "fcitx5 config missing"
  fi

  log_ok "IME diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_ime_setup() {

  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_ime
    return
  fi

  log_info "IME setup started"

  setup_env
  setup_fcitx_config
  restart_fcitx

  echo
}