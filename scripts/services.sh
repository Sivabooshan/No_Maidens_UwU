#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# SERVICES LIST
# ─────────────────────────────────────────────
SERVICES=(
  "Bluetooth|bluetooth.service"
  "CUPS (Printing)|cups.service"
  "SSH|sshd.service"
  "Avahi (Network Discovery)|avahi-daemon.service"
  "UFW Firewall|ufw.service"
)

SERVICES_TOTAL=${#SERVICES[@]}
SERVICES_CURRENT=0

# ─────────────────────────────────────────────
# UFW Setup (with Waydroid support)
# ─────────────────────────────────────────────
setup_ufw() {
  log_info "Configuring UFW firewall"

  if ! command -v ufw &>/dev/null; then
    log_warn "ufw not installed, skipping"
    return
  fi

  # Check if already enabled
  if sudo ufw status | grep -q "Status: active"; then
    log_ok "UFW already enabled"
    return
  fi

  log_info "Setting default firewall policies"

  dry sudo ufw default deny incoming >>"$LOG_FILE" 2>&1
  dry sudo ufw default allow outgoing >>"$LOG_FILE" 2>&1

  # 🔹 Waydroid requirements
  log_info "Applying Waydroid firewall rules"

  # DNS + DHCP
  dry sudo ufw allow 53 >>"$LOG_FILE" 2>&1
  dry sudo ufw allow 67 >>"$LOG_FILE" 2>&1

  # Packet forwarding (required)
  dry sudo ufw default allow FORWARD >>"$LOG_FILE" 2>&1

  # 🔹 Common desktop allowances
  log_info "Allowing common services"

  # SSH (avoid lockout)
  dry sudo ufw allow OpenSSH >>"$LOG_FILE" 2>&1

  # KDE Connect (you installed it)
  dry sudo ufw allow 1714:1764/udp >>"$LOG_FILE" 2>&1
  dry sudo ufw allow 1714:1764/tcp >>"$LOG_FILE" 2>&1

  # Enable firewall
  log_info "Enabling UFW"

  if with_retry dry sudo ufw --force enable >>"$LOG_FILE" 2>&1; then
    log_ok "UFW enabled"
  else
    log_error "Failed to enable UFW"
    record_fail "ufw"
  fi
}

# ─────────────────────────────────────────────
# Enable + start service
# ─────────────────────────────────────────────
enable_service() {
  local name="$1"
  local svc="$2"

  SERVICES_CURRENT=$((SERVICES_CURRENT + 1))
  show_progress "$SERVICES_CURRENT" "$SERVICES_TOTAL" "$name"
  printf "\n"

  # Check if service exists
  if ! systemctl list-unit-files | grep -q "^$svc"; then
    log_warn "$svc not found, skipping"
    return
  fi

  # Check if already enabled
  if systemctl is-enabled "$svc" &>/dev/null; then
    log_ok "$name already enabled"
    return
  fi

  log_info "Enabling $name"

  if with_retry dry sudo systemctl enable --now "$svc" >>"$LOG_FILE" 2>&1; then
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

  # UFW status
  if command -v ufw &>/dev/null; then
    sudo ufw status | tee -a "$LOG_FILE"
  fi

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

  # 🔥 Setup firewall FIRST (important)
  setup_ufw

  # Enable services
  for entry in "${SERVICES[@]}"; do
    enable_service "${entry%%|*}" "${entry##*|}"
  done

  echo

  # Summary
  if (( ${#FAILED_ITEMS[@]} > 0 )); then
    log_warn "Some services failed:"
    for f in "${FAILED_ITEMS[@]}"; do
      echo "  - $f"
    done
  else
    log_ok "All services enabled successfully"
  fi
}