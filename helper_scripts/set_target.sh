#!/bin/bash

# Check if tmux is running
if [ -z "$TMUX" ] && ! tmux ls > /dev/null 2>&1; then
    echo "Error: tmux is not running."
    exit 1
fi

# Get parameters or prompt for input
if [ "$#" -ge 1 ]; then
    TARGET_IP=$1
else
    read -p "Enter Target IP: " TARGET_IP
fi

if [ "$#" -ge 2 ]; then
    TARGET_SUBNET=$2
else
    read -p "Enter Target Subnet: " TARGET_SUBNET
fi

# Default to N/A if empty
TARGET_IP=${TARGET_IP:-"N/A"}
TARGET_SUBNET=${TARGET_SUBNET:-"N/A"}

# Set global environment variables in tmux
tmux set-environment -g TARGET_IP "$TARGET_IP"
tmux set-environment -g TARGET_SUBNET "$TARGET_SUBNET"

# Refresh the status bar for all clients
tmux refresh-client -S

echo "Tmux Target Updated:"
echo "  IP:     $TARGET_IP"
echo "  Subnet: $TARGET_SUBNET"
