#!/bin/bash

# WALLPAPERS PATH
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
FPS=60
TYPE="any"
DURATION=1.5
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    # CORREÇÃO: Removida a condição que excluía GIFs do preview
    # Agora todos os arquivos (incluindo GIFs) terão preview de ícone
    printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
  done
}

# Apply colors to all running terminals
apply_colors_to_terminals() {
  # Replace 'xterm' with your terminal emulator (e.g., 'alacritty', 'kitty')
  for pid in $(pidof ${TERM:-xterm}); do
    cat ~/.cache/wal/sequences > /proc/$pid/fd/0 2>/dev/null
  done
}

# Apply wallpaper, colorscheme, and update Xava
apply_wallpaper_and_colors() {
  local image="$1"
  # Set wallpaper with swww
  echo "Setting wallpaper: $image"
  swww img -o "$focused_monitor" "$image" "$SWWW_PARAMS" || { echo "swww failed"; exit 1; }
  # Generate colorscheme with wal
  echo "Generating colorscheme with wal"
  source "$HOME/envname/bin/activate"
  wal -i "$image" --cols16 -n --vte || { echo "wal failed for $image"; exit 1; }
  # Update and reload Xava
  echo "Updating Xava"
  sh "$HOME/.config/hypr/UserScripts/ReloadXava.sh" || { echo "ReloadXava.sh failed"; exit 1; }
  # Apply colors to all running terminals
  if pgrep "xava" > /dev/null; then
  echo "Xava is already running. Reloading configuration..."
  # You might need to send a signal to Xava to make it reload its config.
  # Xava doesn't have a built-in reload command. A common way is to kill and restart.
  # However, if it's already running, the user probably wants the new config to apply.
  # For simplicity and to avoid interrupting ongoing audio visualization,
  # we'll just inform the user that it's running.
  # If a full restart is desired, uncomment the lines below.
  killall xava
  sleep 1 # Give Xava a moment to terminate
  xava &>/dev/null &
else
  echo "Xava is not running. Starting a new instance..."
fi
  echo "Applying colors to terminals"
  apply_colors_to_terminals
}

# Initiate swww if not running
swww query || swww-daemon --format xrgb

# Choice of wallpapers
main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  # Random choice case
  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    apply_wallpaper_and_colors "$RANDOM_PIC"
  else
    # Find the index of the selected file
    pic_index=-1
    for i in "${!PICS[@]}"; do
      filename=$(basename "${PICS[$i]}")
      if [[ "$filename" == "$choice"* ]]; then
        pic_index=$i
        break
      fi
    done

    if [[ $pic_index -ne -1 ]]; then
      apply_wallpaper_and_colors "${PICS[$pic_index]}"
    else
      echo "Image not found."
      exit 1
    fi
  fi

  # Run refresh scripts only once after colors are applied
  sleep 1.5
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 0.5
  "$SCRIPTSDIR/Refresh.sh"
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  sleep 1
fi

main