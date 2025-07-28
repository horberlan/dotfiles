#!/bin/bash

wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
FPS=60
TYPE="any"
DURATION=1.5
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

[[ $(pidof swaybg) ]] && pkill swaybg

mapfile -d '' PICS < <(find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"
rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Detectar o wallpaper atual antes de abrir o rofi
cache_file="$HOME/.cache/swww/$focused_monitor"
if [[ -s "$cache_file" ]]; then
    current_wallpaper=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)
    if [[ ! -f "$current_wallpaper" ]]; then
        current_wallpaper="$RANDOM_PIC"
    fi
else
    current_wallpaper="$RANDOM_PIC"
fi
mkdir -p "$HOME/.config/rofi"
ln -sf "$current_wallpaper" "$HOME/.config/rofi/.current_wallpaper"

menu() {
    IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
    # Usar a mesma RANDOM_PIC para visualização e aplicação
    printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"
    for pic_path in "${sorted_options[@]}"; do
        pic_name=$(basename "$pic_path")
        if [[ "$pic_path" == "$current_wallpaper" ]]; then
            printf "[current] %s\x00icon\x1f%s\n" "${pic_name%.*}" "$pic_path"
        else
            printf "%s\x00icon\x1f%s\n" "${pic_name%.*}" "$pic_path"
        fi
    done
}

apply_colors_to_terminals() {
    for pid in $(pidof "${TERM:-xterm}"); do
        cat ~/.cache/wal/sequences > "/proc/$pid/fd/0" 2>/dev/null
    done
}

apply_wallpaper_and_colors() {
    local image="$1"
    swww img -o "$focused_monitor" "$image" $SWWW_PARAMS || exit 1

    source "$HOME/envname/bin/activate"
    wal -i "$image" --cols16 -n --vte || exit 1

    sh "$HOME/.config/hypr/UserScripts/ReloadXava.sh"

    if pgrep "xava" >/dev/null; then
        killall xava
        sleep 1
    fi
    xava &>/dev/null &

    eval "$(oh-my-posh init zsh --config "$HOME/.cache/wal/oh-my-posh-pywal.omp.json")"
    apply_colors_to_terminals
}

create_wallpaper_symlink() {
    local image="$1"
    mkdir -p "$HOME/.config/rofi"
    ln -sf "$image" "$HOME/.config/rofi/.current_wallpaper"
}

swww query || swww-daemon --format xrgb

main() {
    [[ $(pidof rofi) ]] && pkill rofi && sleep 1

    choice=$(menu | $rofi_command)
    choice=$(echo "$choice" | xargs)

    [[ -z "$choice" ]] && exit 0

    local image=""
    if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
        image="$RANDOM_PIC"  # Usar a mesma imagem pré-gerada
    else
        for i in "${!PICS[@]}"; do
            filename=$(basename "${PICS[$i]}")
            [[ "${filename%.*}" == "$choice" || "[current] ${filename%.*}" == "$choice" ]] && image="${PICS[$i]}" && break
        done
        [[ -z "$image" ]] && echo "Image not found: $choice" && exit 1
    fi

    apply_wallpaper_and_colors "$image"
    sleep 1.5
    create_wallpaper_symlink "$image"

    "$SCRIPTSDIR/Refresh.sh" &
    wait
}

main