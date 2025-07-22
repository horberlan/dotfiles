#!/bin/bash

if hyprctl clients | grep -q "class: anny-dock"; then
    hyprctl dispatch focuswindow class:^anny-dock$
else
    anny-dock
fi
