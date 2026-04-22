#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# Services list (SAFE MINIMAL SET)
# Only system services that are NOT auto-managed
# ─────────────────────────────────────────────
SERVICES=(
  "Bluetooth|bluetooth|system"
  "CUPS Printing|cups|system"
)

# ─────────────────────────────────────────────
# Check if service is enabled
# ─────────────────────────────────────────────
is_enabled() {
  local svc="$1"
  systemctl is-enabled "$svc" &>/dev/null
}

# ─────────────────────────────────────────────
# Enable service
# ─────────────────────────────────────────────
enable_service() {
  local name="$1"
  local svc="$2"

  log_info "Processing $name"

  if is_enabled "$svc"; then
    log_ok "$name already enabled"
    return 0
  fi

  if dry sudo systemctl enable --now "$svc"; then
    log_ok "$name enabled"
  else
    log_error "$name failed"
    record_fail "service:$svc"
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_services() {
  log_info "Diagnosing services..."

  for entry in "${SERVICES[@]}"; do
    local name="${entry%%|*}"
    local svc="${entry##*|}"

    if systemctl is-enabled "$svc" &>/dev/null; then
      log_ok "$name enabled"
    else
      log_warn "$name disabled"
    fi
  done

  echo
  log_ok "Service diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_services() {

  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_services
    return
  fi

  log_info "Service setup started"

  for entry in "${SERVICES[@]}"; do
    local name="${entry%%|*}"
    local svc="${entry##*|}"

    enable_service "$name" "$svc"
  done

  echo
}