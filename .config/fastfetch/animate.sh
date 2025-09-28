#!/bin/zsh

FRAMES_DIR=~/.config/fastfetch/logos/animated
FPS=10
SLEEP_TIME=$(awk "BEGIN {print 1/$FPS}")

# Clear screen and scrollback buffer
printf '\033[3J\033[H\033[2J'

# Hide cursor
tput civis

# Restore cursor on exit
trap 'tput cnorm; exit' INT TERM EXIT

# Clear screen on window resize
trap 'printf "\033[2J\033[H"' WINCH

while true; do
  for frame in $FRAMES_DIR/frame*.txt; do
    # Move cursor to top-left using tput
    tput cup 0 0

    # Display frame using fastfetch
    fastfetch --logo-type file --logo "$frame" --pipe false

    # Read with timeout to allow exit on key press
    read -t $SLEEP_TIME -n 1 key && { tput cnorm; exit; }
  done
done
