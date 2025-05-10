#!/bin/bash
export PATH="$HOME/go/bin:$PATH"

temps=$(~/.config/waybar/scripts/waybar-wttr.py | jq -r '.hourly[].temp') && \
hours=($(~/.config/waybar/scripts/waybar-wttr.py | jq -r '.hourly[].hour')) && \
echo ""
echo "$temps" | asciigraph \
  -c "🌡️ Temperatura nas próximas horas (°C)" \
  -w 60 \
  -h 15 \
  -p 1 \
  -o 4 \
  -ac cyan \
  -cc yellow \
  -lc green && \
count=${#hours[@]} && spacing=$((60 / count)) && \
printf "%8s" "" && for h in "${hours[@]}"; do printf "%-*s" "$spacing" "$h"; done; echo
