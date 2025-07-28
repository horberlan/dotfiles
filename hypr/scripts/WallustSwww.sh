#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# WAL Colors for current wallpaper

# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get a list of monitor outputs
monitor_outputs=($(ls "$cache_dir"))

# Initialize a flag to determine if the ln command was executed
ln_success=false

# Get current focused monitor
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
echo "Current monitor: $current_monitor"

# Construct the full path to the cache file
cache_file="$cache_dir$current_monitor"
echo "Cache file: $cache_file"

# Check if the cache file exists for the current monitor output
if [ -f "$cache_file" ]; then
    # Get the wallpaper path from the cache file
    wallpaper_path=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)
    echo "Wallpaper path: $wallpaper_path"
    
    # Check if wallpaper file actually exists
    if [ ! -f "$wallpaper_path" ]; then
        echo "Error: Wallpaper file not found: $wallpaper_path"
        exit 1
    fi
    
    # Create directories if they don't exist
    mkdir -p "$HOME/.config/rofi"
    mkdir -p "$HOME/.config/hypr/wallpaper_effects"
    
    # symlink the wallpaper to the location Rofi can access
    if ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"; then
        ln_success=true  # Set the flag to true upon successful execution
        echo "Symlink created successfully"
    else
        echo "Error: Failed to create symlink"
    fi
    
    # copy the wallpaper for wallpaper effects
    if cp "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"; then
        echo "Wallpaper copied successfully"
    else
        echo "Error: Failed to copy wallpaper"
    fi
else
    echo "Error: Cache file not found for monitor $current_monitor"
    exit 1
fi

# Check the flag before executing further commands
if [ "$ln_success" = true ]; then
    echo "About to execute wal"
    # Execute wal with proper options
    # -i: image input
    # -q: quiet mode  
    # -n: skip setting wallpaper (since swww is handling it)
    # -s: skip reloading applications
    # -t: skip setting terminal colors (avoids remote control issues)
    # --backend colorz: use colorz backend for better compatibility
    wal -i "$wallpaper_path" -n -q -s -t --backend colorz 2>/dev/null || {
        echo "Warning: wal failed with colorz backend, trying with wal backend"
        wal -i "$wallpaper_path" -n -q -s -t --backend wal 2>/dev/null || {
            echo "Warning: wal failed with wal backend, trying minimal options"
            wal -i "$wallpaper_path" -n -q 2>/dev/null || {
                echo "Error: All wal execution attempts failed"
                exit 1
            }
        }
    }
    
    echo "WAL execution completed successfully"
else
    echo "Error: Symlink creation failed, skipping wal execution"
    exit 1
fi
