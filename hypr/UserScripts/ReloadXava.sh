#!/bin/bash
# Sets colors from pywal16 to Xava dynamically

if [[ ! -f ~/.cache/wal/xava-cava.conf ]]; then
  echo "Error: Xava config not found at ~/.cache/wal/xava-cava.conf"
  exit 1
fi

inject_monitor() {
    local config="$1"
    local monitor="$2"
    local width="$3"

    cp ~/.cache/wal/xava-cava.conf "$config" || { echo "Error: Failed to copy Xava config to $config"; exit 1; }

    # Fix width for the monitor
    sed -i "s/^width = .*/width = $width/" "$config"

    # Remove any existing monitor_name and inject the correct one
    sed -i '/^monitor_name/d' "$config"
    sed -i "/^background_layer = true/a monitor_name = $monitor" "$config"
}

inject_monitor ~/.config/xava/config-edp1 "eDP-1" "1920"
inject_monitor ~/.config/xava/config "HDMI-A-1" "1360"
