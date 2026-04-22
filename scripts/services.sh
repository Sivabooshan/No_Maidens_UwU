#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# Services list
# Format: "Display Name|service-name|type"
# type: system / user
# ─────────────────────────────────────────────
SERVICES=(
  "Bluetooth|bluetooth|system"
  "CUPS Printing|cups|system"
  "Flatpak Portal|xdg-desktop-portal|user"
  "PipeWire|pipewire|user"
  "WirePlumber|wireplumber|user"
)

# ─────────────────────────────────────────────
# Check if service is enabled
# ─────────────────────────────────────────────
is_enabled() {
  local svc="$1"
  local type="$2"

  if [[ "$type" == "user" ]]; then
    systemctl --user is-enabled "$svc" &>/dev/null
  else
    systemctl is-enabled "$svc" &>/dev/null
  fi
}

# ─────────────────────────────────────────────
# Enable service
# ─────────────────────────────────────────────
enable_service() {
  local name="$1"
  local svc="$2"
  local type="$3"

  log_info "Processing $name"

  if is_enabled "$svc" "$type"; then
    log_ok "$name already enabled"
    return 0
  fi

  if [[ "$type" == "user" ]]; then
    if dry systemctl --user enable --now "$svc"; then
      log_ok "$name enabled (user)"
    else
      log_error "$name failed"
      record_fail "service:$svc"
    fi
  else
    if dry sudo systemctl enable --now "$svc"; then
      log_ok "$name enabled (system)"
    else
      log_error "$name failed"
      record_fail "service:$svc"
    fi
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_services() {
  log_info "Diagnosing services..."

  for entry in "${SERVICES[@]}"; do
    local name="${entry%%|*}"
    local rest="${entry#*|}"
    local svc="${rest%%|*}"
    local type="${rest##*|}"

    if is_enabled "$svc" "$type"; then
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
    local rest="${entry#*|}"
    local svc="${rest%%|*}"
    local type="${rest##*|}"

    enable_service "$name" "$svc" "$type"
  done

  echo
}