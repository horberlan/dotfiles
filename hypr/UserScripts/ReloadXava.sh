#!/bin/bash
# Sets colors from pywal16 to Xava dynamically
# Copies pywal16-generated Xava config and reloads or starts Xava

# Ensure the pywal16-generated Xava config exists
if [[ ! -f ~/.cache/wal/xava-cava.conf ]]; then
  echo "Error: Xava config not found at ~/.cache/wal/xava-cava.conf"
  exit 1
fi

# Copy the config to Xava's config directory
cp ~/.cache/wal/xava-cava.conf ~/.config/xava/config || { echo "Error: Failed to copy Xava config"; exit 1; }

# Check if pgrep is available
if ! command -v pgrep &> /dev/null; then
    echo "Error: pgrep command not found. Please install it (e.g., 'sudo apt install procps' on Debian/Ubuntu)."
    exit 1
fi