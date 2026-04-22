#!/bin/bash

source "$(dirname "$0")/core.sh"

EXT_DIR="$HOME/.local/share/gnome-shell/extensions"

install_blur_my_shell() {
  local tmp=$(mktemp -d)

  git clone https://github.com/aunetx/blur-my-shell "$tmp" || return 1
  cd "$tmp"

  make install SHELL_VERSION_OVERRIDE="" || return 1

  rm -rf "$tmp"
  ok "Blur My Shell installed"
}

install_clipboard_indicator() {
  local dest="$EXT_DIR/clipboard-indicator@tudmotu.com"
  rm -rf "$dest"

  local tmp=$(mktemp -d)
  git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git "$tmp" || return 1

  mv "$tmp" "$dest"
  rm -rf "$tmp"

  ok "Clipboard Indicator installed"
}

install_appindicator() {
  local tmp=$(mktemp -d)

  git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git "$tmp" || return 1
  cd "$tmp"

  meson build /tmp/g-s-appindicators-build
  ninja -C /tmp/g-s-appindicators-build install

  rm -rf "$tmp" /tmp/g-s-appindicators-build

  ok "AppIndicator installed"
}

install_internet_speed_meter() {
  local tmp=$(mktemp -d)

  git clone https://github.com/AlShakib/InternetSpeedMeter.git "$tmp" || return 1
  cd "$tmp/InternetSpeedMeter"

  ./install.sh || return 1

  rm -rf "$tmp"
  ok "Internet Speed Meter installed"
}

install_weekly_commits() {
  local dest="$EXT_DIR/weekly-commits@funinkina.is-a.dev"
  rm -rf "$dest"

  local tmp=$(mktemp -d)
  git clone https://github.com/funinkina/weekly-commits.git "$tmp" || return 1

  mv "$tmp/weekly-commits" "$dest"
  rm -rf "$tmp"

  ok "Weekly Commits installed"
}

install_kimpanel() {
  local tmp=$(mktemp -d)

  git clone https://github.com/wengxt/gnome-shell-extension-kimpanel.git "$tmp" || return 1
  cd "$tmp/gnome-shell-extension-kimpanel"

  ./install.sh || return 1

  rm -rf "$tmp"
  ok "Kimpanel installed"
}

run_gnomeext() {
  info "Installing GNOME Extensions"

  install_blur_my_shell
  install_clipboard_indicator
  install_appindicator
  install_internet_speed_meter
  install_weekly_commits
  install_kimpanel

  echo
}
