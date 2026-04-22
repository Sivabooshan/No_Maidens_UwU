#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# USER SERVICES MANAGEMENT
# ─────────────────────────────────────────────

enable_user_service() {
  local service="$1"

  if systemctl --user is-enabled "$service" &>/dev/null; then
    log_ok "$service already enabled"
  else
    dry systemctl --user enable "$service"
    log_ok "$service enabled"
  fi

  dry systemctl --user start "$service"
}

restart_user_service() {
  local service="$1"
  log_info "Restarting $service"
  dry systemctl --user restart "$service"
}

# ─────────────────────────────────────────────
# SYSTEM SERVICES (sudo required)
# ─────────────────────────────────────────────

enable_system_service() {
  local service="$1"

  if systemctl is-enabled "$service" &>/dev/null; then
    log_ok "$service already enabled"
  else
    dry sudo systemctl enable "$service"
    log_ok "$service enabled"
  fi

  dry sudo systemctl start "$service"
}

# ─────────────────────────────────────────────
# PIPEWIRE STACK (IMPORTANT)
# ─────────────────────────────────────────────

setup_pipewire() {
  log_info "Configuring PipeWire stack"

  enable_user_service pipewire.service
  enable_user_service pipewire-pulse.service
  enable_user_service wireplumber.service

  restart_user_service pipewire
  restart_user_service wireplumber

  log_ok "PipeWire stack ready"
}

# ─────────────────────────────────────────────
# GAMING SERVICES
# ─────────────────────────────────────────────

setup_gaming() {
  log_info "Configuring gaming services"

  enable_user_service gamemoded.service 2>/dev/null || true

  log_ok "Gaming services ready"
}

# ─────────────────────────────────────────────
# NVIDIA OPTIMIZATION (optional service hooks)
# ─────────────────────────────────────────────

setup_nvidia() {
  log_info "Checking NVIDIA runtime"

  if command -v nvidia-smi &>/dev/null; then
    log_ok "NVIDIA detected"
  else
    log_warn "NVIDIA not detected"
  fi
}

# ─────────────────────────────────────────────
# MAIN RUNNER
# ─────────────────────────────────────────────

run_services() {
  setup_pipewire
  setup_gaming
  setup_nvidia
}

# ─────────────────────────────────────────────
# ENTRYPOINT
# ─────────────────────────────────────────────

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_services
fi