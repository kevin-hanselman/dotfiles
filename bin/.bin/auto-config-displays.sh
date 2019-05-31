#!/bin/bash
set -euo pipefail

# Run the machine-specific default layout if one exists.
if [ -x ~/.screenlayout/default.sh ]; then
    ~/.screenlayout/default.sh
    exit 0
fi

connected_displays=$(xrandr | grep -E '\bconnected\b')
# If we're only connected to one monitor, make that our primary monitor (for polybar, etc.)
if [ "$(echo "$connected_displays" | wc -l)" -eq 1 ]; then
    display=$(echo "$connected_displays" | awk '{print $1}')
    xrandr --output "$display" --auto --primary
fi
