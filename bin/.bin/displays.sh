#!/bin/bash
xrandr --dpi 96

# explicitly turn off other outputs in case we're switching from multi-display
if [ "$(xrandr | grep DP-3 | awk '{ print $2 }')" == 'connected' ]; then
    echo 'Found Display Port(s)'
    xrandr --output LVDS-0 --auto \
           --output DP-3 --mode 2560x1440 --primary --right-of LVDS-0 \
           --output DP-5 --auto --right-of DP-3 --rotate left \
           --output VGA-0 --off \
           --output DP-0 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-4 --off

else
    echo 'No external displays found'
    xrandr --output LVDS-0 --auto --primary \
           --output DP-0 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-3 --off \
           --output DP-4 --off \
           --output DP-5 --off \
           --output VGA-0 --off
fi

# cache changes to xrandr
xrandr > /tmp/xrandr.txt
