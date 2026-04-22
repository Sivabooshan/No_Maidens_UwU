#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/core.sh"

REPO="https://github.com/Sivabooshan/No_Maidens_UwU.git"
DIR="$HOME/No_Maidens_UwU"

backup() {
  local b="$HOME/.config/backup-$(date +%s)"
  mkdir -p "$b"

  [[ -e ~/.zshrc ]] && cp ~/.zshrc "$b/"
  [[ -e ~/.tmux.conf ]] && cp ~/.tmux.conf "$b/"

  ok "Backup created"
}

clone() {
  [[ -d "$DIR" ]] && {
    warn "already exists"
    return
  }

  dry git clone "$REPO" "$DIR" && ok "cloned"
}

stow_apply() {
  cd "$DIR" || return

  if [[ "$FORCE_MODE" == "true" ]]; then
    dry stow --adopt . && ok "stow applied (force)"
  else
    dry stow . && ok "stow applied" || warn "stow conflict skipped"
  fi
}

run_dotfiles() {
  info "Dotfiles setup"
  backup
  clone
  stow_apply
  echo
}
