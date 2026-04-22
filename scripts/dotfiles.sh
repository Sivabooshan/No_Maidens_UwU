#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# Config
# ─────────────────────────────────────────────
REPO="https://github.com/Sivabooshan/No_Maidens_UwU.git"
DIR="$HOME/No_Maidens_UwU"

# ─────────────────────────────────────────────
# Backup existing configs
# ─────────────────────────────────────────────
backup_dotfiles() {
  log_info "Creating backup..."

  local backup_dir="$HOME/.config/backup-$(date +%s)"
  mkdir -p "$backup_dir"

  [[ -e "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_dir/"
  [[ -e "$HOME/.tmux.conf" ]] && cp "$HOME/.tmux.conf" "$backup_dir/"

  log_ok "Backup created at $backup_dir"
}

# ─────────────────────────────────────────────
# Clone repo
# ─────────────────────────────────────────────
clone_repo() {
  if [[ -d "$DIR" ]]; then
    log_warn "Dotfiles repo already exists"

    if [[ "$FORCE_MODE" == "true" ]]; then
      log_warn "Force enabled → recloning"
      dry rm -rf "$DIR"
    else
      return 0
    fi
  fi

  log_info "Cloning dotfiles repo..."

  if dry git clone "$REPO" "$DIR"; then
    log_ok "Repository cloned"
  else
    log_error "Clone failed"
    record_fail "dotfiles clone"
  fi
}

# ─────────────────────────────────────────────
# Apply with stow
# ─────────────────────────────────────────────
apply_stow() {
  log_info "Applying dotfiles with stow..."

  if [[ ! -d "$DIR" ]]; then
    log_error "Dotfiles directory missing"
    record_fail "dotfiles missing"
    return 1
  fi

  cd "$DIR" || {
    log_error "Failed to enter $DIR"
    record_fail "dotfiles cd"
    return 1
  }

  if [[ "$FORCE_MODE" == "true" ]]; then
    if dry stow --adopt .; then
      log_ok "Stow applied (force)"
    else
      log_error "Stow failed"
      record_fail "stow force"
    fi
  else
    if dry stow .; then
      log_ok "Stow applied"
    else
      log_warn "Stow conflict (skipped)"
      record_fail "stow conflict"
    fi
  fi
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_dotfiles() {
  log_info "Diagnosing dotfiles..."

  if [[ -d "$DIR" ]]; then
    log_ok "Repo exists: $DIR"
  else
    log_warn "Repo missing"
  fi

  if command -v stow &>/dev/null; then
    log_ok "stow installed"
  else
    log_warn "stow missing"
  fi

  log_ok "Dotfiles diagnostics complete"
}

# ─────────────────────────────────────────────
# Main runner
# ─────────────────────────────────────────────
run_dotfiles() {
  if [[ "$DIAGNOSE_MODE" == "true" ]]; then
    diagnose_dotfiles
    return
  fi

  log_info "Dotfiles setup started"

  backup_dotfiles
  clone_repo
  apply_stow

  echo
}