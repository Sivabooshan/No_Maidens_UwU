#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/Sivabooshan/No_Maidens_UwU.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Stow packages (folders inside repo)
STOW_PKGS=(
  "zsh"
  "nvim"
  "tmux"
  "git"
)

# ─────────────────────────────────────────────
# Clone or update repo
# ─────────────────────────────────────────────
setup_dotfiles_repo() {

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log_info "Updating dotfiles repository"

    if with_retry git -C "$DOTFILES_DIR" pull >>"$LOG_FILE" 2>&1; then
      log_ok "Dotfiles updated"
    else
      log_error "Failed to update dotfiles"
      record_fail "dotfiles:update"
    fi

  else
    log_info "Cloning dotfiles repository"

    if with_retry git clone "$DOTFILES_REPO" "$DOTFILES_DIR" >>"$LOG_FILE" 2>&1; then
      log_ok "Dotfiles cloned"
    else
      log_error "Failed to clone dotfiles"
      record_fail "dotfiles:clone"
      return 1
    fi
  fi
}

# ─────────────────────────────────────────────
# Apply dotfiles using stow
# ─────────────────────────────────────────────
apply_dotfiles() {

  # Ensure stow exists
  check_and_install stow stow

  log_info "Applying dotfiles with stow"

  for pkg in "${STOW_PKGS[@]}"; do

    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      log_warn "Skipping $pkg (not found in repo)"
      continue
    fi

    log_info "Stowing $pkg"

    if dry stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg" >>"$LOG_FILE" 2>&1; then
      log_ok "$pkg applied"
    else
      log_error "$pkg failed"
      record_fail "dotfiles:$pkg"
    fi
  done
}

# ─────────────────────────────────────────────
# Diagnose mode
# ─────────────────────────────────────────────
diagnose_dotfiles() {
  log_info "Diagnosing dotfiles..."

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log_ok "Dotfiles repo exists"
  else
    log_warn "Dotfiles repo missing"
  fi

  for pkg in "${STOW_PKGS[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      log_ok "$pkg available"
    else
      log_warn "$pkg missing"
    fi
  done

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

  setup_dotfiles_repo || return
  apply_dotfiles

  echo
  log_ok "Dotfiles setup complete"
}