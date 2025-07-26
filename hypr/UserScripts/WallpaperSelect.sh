#!/bin/bash
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
FPS=60
TYPE="any"
DURATION=1.5
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

if pidof swaybg > /dev/null; then
  pkill swaybg
fi

mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")

    printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
  done
}

apply_colors_to_terminals() {

  for pid in $(pidof ${TERM:-xterm}); do
    cat ~/.cache/wal/sequences > /proc/$pid/fd/0 2>/dev/null
  done
}

apply_wallpaper_and_colors() {
  local image="$1"
  echo "Setting wallpaper: $image"

  swww img -o "$focused_monitor" "$image" $SWWW_PARAMS || { echo "swww failed"; exit 1; }
  echo "Generating colorscheme with wal"
  source "$HOME/envname/bin/activate"
  wal -i "$image" --cols16 -n --vte || { echo "wal failed for $image"; exit 1; }

  echo "Updating Xava"
  sh "$HOME/.config/hypr/UserScripts/ReloadXava.sh" || { echo "ReloadXava.sh failed"; exit 1; }

  if pgrep "xava" > /dev/null; then
  echo "Xava is already running. Reloading configuration..."
  killall xava
  sleep 1
  xava &>/dev/null &
else
  echo "Xava is not running. Starting a new instance..."
fi
  echo "Applying colors to terminals"
  apply_colors_to_terminals
}

swww query || swww-daemon --format xrgb

main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    apply_wallpaper_and_colors "$RANDOM_PIC"
  else
    pic_index=-1
    for i in "${!PICS[@]}"; do
      filename=$(basename "${PICS[$i]}")
      filename_without_ext=$(echo "$filename" | cut -d. -f1)
      
      if [[ "$filename_without_ext" == "$choice" ]]; then
        pic_index=$i
        break
      fi
    done

    if [[ $pic_index -ne -1 ]]; then
      apply_wallpaper_and_colors "${PICS[$pic_index]}"
    else
      echo "Image not found: $choice"
      exit 1
    fi
  fi

  sleep 1.5
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 0.5
  "$SCRIPTSDIR/Refresh.sh"
}

if pidof rofi > /dev/null; then
  pkill rofi
  sleep 1
fi

main