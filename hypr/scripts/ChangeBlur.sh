#!/bin/bash
STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "2" ]; then
	hyprctl keyword decoration:blur:size 2
	hyprctl keyword decoration:blur:passes 1
else
	hyprctl keyword decoration:blur:size 3
	hyprctl keyword decoration:blur:passes 2
fi
