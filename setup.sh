#!/bin/bash

LOG_FILE="/tmp/labautomation_setup.log"

# Logging function
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

log "Starting setup.sh script execution."

# Supported OS Check (Ubuntu Only)
OS=$(lsb_release -is 2>/dev/null)
if [[ "$OS" != "Ubuntu" ]]; then
    log "❌ This script only supports Ubuntu 20.04 / 22.04"
    exit 1
fi

# Prevent Recursive Execution
if pgrep -f "setup.sh" | grep -v $$ >/dev/null; then
    log "⚠️ setup.sh is already running! Exiting to prevent loop."
    exit 1
fi

# Cleanup Mode
if [ "$1" == "clean" ]; then
    cd /tmp
    rm -rf labautomation
    log "🧹 Cleanup Succeeded"
    exit 0
fi

# Install Required Packages
log "📦 Updating packages..."
sudo apt update -y && sudo apt install -y git curl || { log "❌ Package installation failed!"; exit 1; }

# Clone or Update Lab Automation Repository
REPO_URL="https://github.com/itsp-technology/autolabsoft.git"
INSTALL_DIR="/tmp/labautomation"

log "🔍 Checking repository..."
if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR"
    git pull &>/dev/null
    if [ $? -ne 0 ]; then
        log "⚠️ Git pull failed! Removing and re-cloning repository."
        cd /tmp
        rm -rf "$INSTALL_DIR"
        git clone "$REPO_URL" "$INSTALL_DIR" &>/dev/null || { log "❌ Failed to clone repository!"; exit 1; }
    fi
else
    log "📥 Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR" &>/dev/null || { log "❌ Failed to clone repository!"; exit 1; }
fi

# Check if Setup Script Exists
if [ ! -f "$INSTALL_DIR/setup.sh" ]; then
    log "⚠️ setup.sh not found! Try using 'sudo labauto clean'"
    exit 1
fi

# Check if Running as Root
if [ "$(id -u)" -ne 0 ]; then
    log "❌ You must run this script as root!"
    exit 1
fi

# Execute Main Setup Script Safely
log "🚀 Running the Main Setup Script..."
exec bash "$INSTALL_DIR/setup.sh" "$@"  # Prevents infinite recursion
