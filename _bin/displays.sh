#!/bin/bash

xrandr="$(xrandr)"

if [ $(echo "$xrandr" | grep DP-1 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found Display Port(s)'
    xrandr --output LVDS-1 --mode 1920x1080 \
        --output DP-1 --auto --right-of LVDS-1 --primary --rotate left \
        --output DP-3 --auto --right-of DP-1 --rotate normal
elif [ $(echo "$xrandr" | grep VGA-1 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found VGA'
    xrandr --output LVDS-1 --auto --primary \
        --output VGA-1 --auto --same-as LVDS-1
else
    echo 'No external displays found'
    xrandr --output LVDS-1 --mode 1920x1080 --primary \
        --output DP-1 --off \
        --output DP-3 --off \
        --output VGA-1 --off
fi

[ -f ~/.fehbg ] && source ~/.fehbg
