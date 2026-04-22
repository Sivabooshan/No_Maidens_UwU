#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# IME / Japanese Input Setup (Fcitx)
# ─────────────────────────────────────────────────────────────

# Assumes these helper functions exist from core.sh:
# checkpoint, celebrate_victory

checkpoint "IME setup"

PAM_FILE="$HOME/.pam_environment"
touch "$PAM_FILE"

updated=false

# GTK IME
if ! grep -q '^GTK_IM_MODULE' "$PAM_FILE"; then
  echo 'GTK_IM_MODULE=fcitx' >>"$PAM_FILE"
  updated=true
fi

# QT IME
if ! grep -q '^QT_IM_MODULE' "$PAM_FILE"; then
  echo 'QT_IM_MODULE=fcitx' >>"$PAM_FILE"
  updated=true
fi

# X11 IME
if ! grep -q '^XMODIFIERS' "$PAM_FILE"; then
  echo 'XMODIFIERS=@im=fcitx' >>"$PAM_FILE"
  updated=true
fi

# SDL IME (games / emulators support)
if ! grep -q '^SDL_IM_MODULE' "$PAM_FILE"; then
  echo 'SDL_IM_MODULE=fcitx' >>"$PAM_FILE"
  updated=true
fi

if [[ "$updated" == true ]]; then
  celebrate_victory "IME configured"
else
  echo "✓ IME already configured"
fi
