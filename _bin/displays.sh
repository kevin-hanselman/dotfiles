#!/bin/bash

# cache xrandr output for faster access
xrandr > /tmp/xrandr.txt
xrandr --dpi 96

if [ $(cat /tmp/xrandr.txt | grep DP-5 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found Display Port(s)'
    xrandr --output LVDS-0 --mode 1920x1080 \
           --output DP-5 --mode 2560x1440 --primary --left-of LVDS-0 \
           --output VGA-0 --off \
           --output DP-0 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-3 --off \
           --output DP-4 --off

elif [ $(cat /tmp/xrandr.txt | grep VGA-0 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found VGA'
    #xrandr --output VGA-0 --auto \
    #       --output LVDS-0 --right-of VGA-0 --primary \
    xrandr --output VGA-0 --auto \
           --output LVDS-0 --same-as VGA-0 --primary \
           --output DP-0 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-3 --off \
           --output DP-4 --off \
           --output DP-5 --off

elif [ $(cat /tmp/xrandr.txt | grep DP-3 | awk '{ print $2 }') == 'connected' ]; then
    echo 'Found HDMI'
    xrandr --output DP-3 --auto \
           --output LVDS-0 --same-as DP-3 --primary \
           --output DP-0 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-4 --off \
           --output DP-5 --off \
           --output VGA-0 --off

else
    echo 'No external displays found'
    # explicitly turn off other outputs in case we're switching from multi-display
    xrandr --output LVDS-0 --mode 1920x1080 --primary \
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

[ -f ~/.fehbg ] && source ~/.fehbg

