#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────
ENV_FILE="$HOME/.config/environment.d/ime.conf"

# Required environment variables
IME_VARS=(
  "GTK_IM_MODULE=fcitx"
  "QT_IM_MODULE=fcitx"
  "XMODIFIERS=@im=fcitx"
  "SDL_IM_MODULE=fcitx"
  "GLFW_IM_MODULE=ibus"
)

# ─────────────────────────────────────────────
# Write environment variables safely
# ─────────────────────────────────────────────
setup_env() {
  log_info "Configuring IME environment variables"

  mkdir -p "$(dirname "$ENV_FILE")"

  # Create temp file
  tmp=$(mktemp)

  # Preserve unrelated lines if file exists
  if [[ -f "$ENV_FILE" ]]; then
    grep -v -E '^(GTK_IM_MODULE|QT_IM_MODULE|XMODIFIERS|SDL_IM_MODULE|GLFW_IM_MODULE)=' "$ENV_FILE" > "$tmp"
  fi

  # Add our variables
  for var in "${IME_VARS[@]}"; do
    echo "$var" >> "$tmp"
  done

  if dry mv "$tmp" "$ENV_FILE" >>"$LOG_FILE" 2>&1; then
    log_ok "Environment variables configured"
  else
    log_error "Failed to write environment file"
    record_fail "ime:env"
  fi
}

# ─────────────────────────────────────────────
# Start fcitx5 daemon
# ─────────────────────────────────────────────
start_fcitx() {
  log_info "Starting fcitx5 daemon"

  if pgrep -x fcitx5 &>/dev/null; then
    log_ok "fcitx5 already running"
    return 0
  fi

  if dry fcitx5 -d >>"$LOG_FILE" 2>&1; then
    log_ok "fcitx5 started"
  else
    log_warn "Failed to start fcitx5 (may require relogin)"
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_ime() {
  log_info "Diagnosing IME setup..."

  # Check env file
  if [[ -f "$ENV_FILE" ]]; then
    log_ok "Environment file exists"
  else
    log_warn "Environment file missing"
  fi

  # Check fcitx5 running
  if pgrep -x fcitx5 &>/dev/null; then
    log_ok "fcitx5 is running"
  else
    log_warn "fcitx5 not running"
  fi

  # Check fcitx5 installed
  if command -v fcitx5 &>/dev/null; then
    log_ok "fcitx5 installed"
  else
    log_warn "fcitx5 missing"
  fi

  echo
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

  # Ensure required packages exist (light safety)
  check_and_install fcitx5 fcitx5

  setup_env
  start_fcitx

  echo
  log_ok "IME setup complete"
}