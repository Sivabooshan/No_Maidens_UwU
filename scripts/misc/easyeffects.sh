#!/bin/bash

# Function to backup EasyEffects
backup_easyeffects() {
    set -e

    BACKUP_DIR="$HOME/easyeffects_backup"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    ARCHIVE="$BACKUP_DIR/easyeffects_backup_$TIMESTAMP.tar.gz"

    echo "[*] Creating backup directory..."
    mkdir -p "$BACKUP_DIR"

    echo "[*] Stopping EasyEffects..."
    pkill -x easyeffects || true

    echo "[*] Creating archive..."
    tar --numeric-owner -czvf "$ARCHIVE" \
        "$HOME/.config/easyeffects" \
        "$HOME/.local/share/easyeffects"

    echo "[*] Backup complete: $ARCHIVE"
}

# Function to restore EasyEffects
restore_easyeffects() {
    set -e

    if [ -z "$1" ]; then
        echo "Usage: $0 restore <backup_file.tar.gz>"
        exit 1
    fi

    BACKUP_FILE="$1"

    if [ ! -f "$BACKUP_FILE" ]; then
        echo "[!] Backup file not found!"
        exit 1
    fi

    echo "[*] Stopping EasyEffects..."
    pkill -x easyeffects || true

    echo "[*] Removing old EasyEffects data..."
    rm -rf "$HOME/.config/easyeffects"
    rm -rf "$HOME/.local/share/easyeffects"

    echo "[*] Restoring backup..."
    tar --numeric-owner -xzvf "$BACKUP_FILE" -C /

    echo "[*] Fixing permissions..."
    chown -R "$USER:$USER" "$HOME/.config/easyeffects"
    chown -R "$USER:$USER" "$HOME/.local/share/easyeffects"

    echo "[*] Starting EasyEffects..."
    easyeffects &

    echo "[*] Restore complete!"
}

# Main script logic
if [ "$1" == "backup" ]; then
    backup_easyeffects
elif [ "$1" == "restore" ]; then
    restore_easyeffects "$2"
else
    echo "Usage: $0 {backup|restore <backup_file.tar.gz>}"
    exit 1
fi