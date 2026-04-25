#!/bin/bash

# Function to backup waydroid
backup_waydroid() {
    set -e
    
    BACKUP_DIR="$HOME/waydroid_backup"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    ARCHIVE="$BACKUP_DIR/waydroid_backup_$TIMESTAMP.tar.gz"
    
    echo "[*] Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
    
    echo "[*] Stopping Waydroid..."
    sudo systemctl stop waydroid-container || true
    
    echo "[*] Creating archive..."
    sudo tar --numeric-owner -czvf "$ARCHIVE" \
        /var/lib/waydroid \
        "$HOME/.local/share/waydroid"
    
    echo "[*] Backup complete: $ARCHIVE"
}

# Function to restore waydroid
restore_waydroid() {
    set -e

    if [ -z "$1" ]; then
        echo "Usage: $0 <backup_file.tar.gz>"
        exit 1
    fi

    BACKUP_FILE="$1"

    if [ ! -f "$BACKUP_FILE" ]; then
        echo "[!] Backup file not found!"
        exit 1
    fi

    echo "[*] Stopping Waydroid (if running)..."
    sudo systemctl stop waydroid-container || true

    echo "[*] Removing old Waydroid data..."
    sudo rm -rf /var/lib/waydroid
    rm -rf "$HOME/.local/share/waydroid"

    echo "[*] Initializing Waydroid with GApps..."
    sudo waydroid init -s GAPPS

    echo "[*] Enabling Waydroid service..."
    sudo systemctl enable waydroid-container

    echo "[*] Restoring backup..."
    sudo tar --numeric-owner -xzvf "$BACKUP_FILE" -C /

    echo "[*] Fixing permissions..."
    sudo chown -R root:root /var/lib/waydroid
    chown -R "$USER:$USER" "$HOME/.local/share/waydroid"

    echo "[*] Starting Waydroid..."
    sudo systemctl start waydroid-container

    echo "[*] Restore complete!"
}

# Main script logic
if [ "$1" == "backup" ]; then
    backup_waydroid
elif [ "$1" == "restore" ]; then
    restore_waydroid "$2"
else
    echo "Usage: $0 {backup|restore <backup_file.tar.gz>}"
    exit 1
fi