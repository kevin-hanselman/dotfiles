#!/bin/bash

# cache xrandr output for faster access
xrandr > /tmp/xrandr.txt

if [ $(cat /tmp/xrandr.txt | grep DP-1 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found Display Port(s)'
    xrandr --output LVDS-1 --mode 1920x1080 \
           --output DP-1 --auto --right-of LVDS-1 --primary --rotate left \
           --output DP-3 --auto --right-of DP-1 --rotate normal \
           --output VGA-1 --off
elif [ $(cat /tmp/xrandr.txt | grep VGA-1 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found VGA'
    xrandr --output VGA-1 --auto \
           --output LVDS-1 --same-as VGA-1 --primary \
           --output DP-1 --off \
           --output DP-3 --off
elif [ $(cat /tmp/xrandr.txt | grep DP-3 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found HDMI'
    xrandr --output DP-3 --auto \
           --output LVDS-1 --same-as DP-3 --primary \
           --output DP-1 --off \
           --output VGA-1 --off
else
    echo 'No external displays found'
    # explicitly turn off other outputs in case we're switching from multi-display
    xrandr --output LVDS-1 --mode 1920x1080 --primary \
           --output DP-1 --off \
           --output DP-3 --off \
           --output VGA-1 --off
fi

# cache changes to xrandr
xrandr > /tmp/xrandr.txt

[ -f ~/.fehbg ] && source ~/.fehbg

