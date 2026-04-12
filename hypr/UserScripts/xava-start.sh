#!/bin/bash

hyprctl monitors | grep -q "eDP-1" && xava -p ~/.config/xava/config-edp1 &
hyprctl monitors | grep -q "HDMI-A-1" && xava -p ~/.config/xava/config &
