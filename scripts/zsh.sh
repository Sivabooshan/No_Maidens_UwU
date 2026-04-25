#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core.sh"

# ─────────────────────────────────────────────
# Summon Oh My Zsh magic (installation)
# ─────────────────────────────────────────────
summon_oh_my_zsh() {
  announce_quest "Summoning the ancient Oh My Zsh magic..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would summon Oh My Zsh magic"
    return 0
  fi

  # Verify zsh is installed before proceeding
  if ! command -v zsh &>/dev/null; then
    cry_of_despair "Zsh must be installed before Oh My Zsh can be summoned"
    exit 1
  fi

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    whisper_warning "The Oh My Zsh magic is already bound to thy shell, proceeding..."
    return 0
  fi

  # Summon Oh My Zsh without mortal interaction
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    cry_of_despair "The Oh My Zsh summoning ritual has failed"
    exit 1
  }

  celebrate_victory "Oh My Zsh magic successfully bound to thy shell"
}

# ─────────────────────────────────────────────
# Bind Zsh plugins to enhance the shell powers
# ─────────────────────────────────────────────
bind_mystical_plugins() {
  announce_quest "Binding mystical Zsh plugins to enhance thy shell powers..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would bind mystical plugins"
    return 0
  fi

  local plugin_artifacts=(
    "https://github.com/zsh-users/zsh-autosuggestions.git|zsh-autosuggestions|The Suggestion Whisperer"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git|zsh-syntax-highlighting|The Syntax Illuminator"
    "https://github.com/marlonrichert/zsh-autocomplete.git|zsh-autocomplete|The Completion Oracle"
    "https://github.com/MichaelAquilina/zsh-you-should-use.git|you-should-use|The Alias Reminder Spirit"
  )

  local plugin_sanctuary="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  for plugin_info in "${plugin_artifacts[@]}"; do
    IFS='|' read -r url name title <<<"$plugin_info"
    local plugin_home="$plugin_sanctuary/$name"

    if [[ ! -d "$plugin_home" ]]; then
      git clone "$url" "$plugin_home" || {
        whisper_warning "Failed to bind plugin: $title"
        continue
      }
      celebrate_victory "Successfully bound: $title"
    else
      whisper_warning "$title already bound to thy shell, skipping..."
    fi
  done
}

# ─────────────────────────────────────────────
# Setup Zsh environment and invoke necessary functions
# ─────────────────────────────────────────────
setup_zsh() {
  log_info "Setting up Zsh shell environment"

  # Ensure Zsh is installed
  check_and_install zsh zsh

  # Summon Oh My Zsh and plugins
  summon_oh_my_zsh
  bind_mystical_plugins

  # Set Zsh as the default shell
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    log_info "Changing default shell to Zsh"
    dry chsh -s "$(which zsh)"
    log_ok "Default shell changed to Zsh"
  else
    log_ok "Zsh is already the default shell"
  fi

  log_ok "Zsh setup complete"
}

# ─────────────────────────────────────────────
# Main runner (this will be called)
# ─────────────────────────────────────────────
run_zsh_setup() {
  setup_zsh
}