#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Define directories and files
waybar_styles="$HOME/.config/waybar/style"
waybar_style="$HOME/.config/waybar/style.css"
waybar_config="$HOME/.config/waybar/config.jsonc"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
rofi_config="$HOME/.config/rofi/config-waybar-style.rasi"

# Function to display menu options
menu() {
    options=()
    while IFS= read -r dir; do
        if [ -d "$waybar_styles/$dir" ] && [ -f "$waybar_styles/$dir/style.css" ] && [ -f "$waybar_styles/$dir/config.jsonc" ]; then
            options+=("$dir")
        fi
    done < <(find "$waybar_styles" -maxdepth 1 -type d -not -path "$waybar_styles" -exec basename {} \; | sort)
    
    # Include .css files in the root directory for backward compatibility
    while IFS= read -r file; do
        if [ -f "$waybar_styles/$file" ]; then
            options+=("$(basename "$file" .css)")
        fi
    done < <(find "$waybar_styles" -maxdepth 1 -type f -name '*.css' -exec basename {} \; | sort)
    
    printf '%s\n' "${options[@]}"
}

# Apply selected style
apply_style() {
    if [ -d "$waybar_styles/$1" ]; then
        # Subdirectory with style.css and config.jsonc
        ln -sf "$waybar_styles/$1/style.css" "$waybar_style"
        ln -sf "$waybar_styles/$1/config.jsonc" "$waybar_config"
    else
        # Root-level .css file
        ln -sf "$waybar_styles/$1.css" "$waybar_style"
    fi
    "${SCRIPTSDIR}/Refresh.sh" &
}

# Main function
main() {
    choice=$(menu | rofi -i -dmenu -config "$rofi_config")

    if [[ -z "$choice" ]]; then
        echo "No option selected. Exiting."
        exit 0
    fi

    apply_style "$choice"
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

main