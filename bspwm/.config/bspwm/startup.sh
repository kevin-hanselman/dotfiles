#!/bin/bash

# bspwm startup programs

[ "$(pgrep -cx sxhkd)" -eq 0 ] && sxhkd &

[ "$(pgrep -cx compton)" -eq 0 ] && compton &

[ "$(pgrep -cx xfce4-panel)" -eq 0 ] && xfce4-panel -d &

[ "$(pgrep -cx nm-applet)" -eq 0 ] && nm-applet &

if [ "$(pgrep -cx xautolock)" -eq 0 ]; then
    xautolock -time 3 \
        -locker "sxlock -f '-*-envy code r-medium-r-*-*-*-*-*-*-*-*-*-*'" \
        -corners -000 &
fi

[ "$(pgrep -cf xfce4-power-manager)" -eq 0 ] && xfce4-power-manager

[ "$(pgrep -cf xfce4-volumed)" -eq 0 ] && xfce4-volumed

[ "$(pgrep -cx dropbox)" -eq 0 ] && dropbox

