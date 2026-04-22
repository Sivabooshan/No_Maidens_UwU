#!/bin/bash

source "$(dirname "$0")/core.sh"

DOTFILES_REPO="https://github.com/Sivabooshan/No_Maidens_UwU.git"
DOTFILES_DIR="$HOME/No_Maidens_UwU"

backup_dotfiles() {
  local backup="$HOME/.config/backup-$(date +%s)"
  mkdir -p "$backup"

  for f in .zshrc .tmux.conf .config; do
    [[ -e "$HOME/$f" ]] && cp -r "$HOME/$f" "$backup/"
  done

  ok "Backup created"
}

clone_dotfiles() {
  if [[ -d "$DOTFILES_DIR" ]]; then
    warn "Dotfiles exist"
    return
  fi

  dry git clone "$DOTFILES_REPO" "$DOTFILES_DIR" &&
    ok "Dotfiles cloned"
}

stow_dotfiles() {
  cd "$DOTFILES_DIR" || return 1

  dry stow . &&
    ok "stow applied" ||
    error "stow failed"
}

run_dotfiles() {
  info "Dotfiles setup"
  backup_dotfiles
  clone_dotfiles
  stow_dotfiles
  echo
}
