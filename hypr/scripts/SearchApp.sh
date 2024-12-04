
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi
rofi_config="$HOME/.config/rofi/config-search.rasi"

# Open rofi with a dmenu and pass the selected item to xdg-open for Google search
# echo "" | rofi -show run
echo "" | rofi -dmenu -config "$rofi_config" -p "Search:" | xargs -I{} xdg-open "https://www.google.com/search?q={}"
