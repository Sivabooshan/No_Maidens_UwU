#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/core.sh"

REPO="https://github.com/Sivabooshan/No_Maidens_UwU.git"
DIR="$HOME/No_Maidens_UwU"

backup() {
  local b="$HOME/.config/backup-$(date +%s)"
  mkdir -p "$b"

  [[ -e ~/.zshrc ]] && cp ~/.zshrc "$b/"
  [[ -e ~/.tmux.conf ]] && cp ~/.tmux.conf "$b/"

  victory "Backup created"
}

clone() {
  [[ -d "$DIR" ]] && {
    warn "already exists"
    return
  }

  dry git clone "$REPO" "$DIR" && victory "cloned"
}

stow_apply() {
  cd "$DIR" || return

  if [[ "$FORCE_MODE" == "true" ]]; then
    dry stow --adopt . && victory "stow applied (force)"
  else
    dry stow . && victory "stow applied" || warn "stow conflict skipped"
  fi
}

run_dotfiles() {
  checkpoint "Dotfiles setup"
  backup
  clone
  stow_apply
  echo
}
