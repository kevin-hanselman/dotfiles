#!/bin/bash

# bspwm startup programs

# TODO: if these doesn't make sxhkd faster, put sxhkd and compton at the end?
[ "$(pgrep -cx sxhkd)" -eq 0 ] && sxhkd &

[ "$(pgrep -cx compton)" -eq 0 ] && compton &

[ "$(pgrep -cx start_panel.sh)" -eq 0 ] && ~/.config/bspwm/panel/start_panel.sh &

#if [ "$(pgrep -cf gnome-keyring-daemon)" -eq 0 ]; then
    #eval $(gnome-keyring-daemon --start)
    #export SSH_AUTH_SOCK
#fi

if [ "$(pgrep -cx xautolock)" -eq 0 ]; then
    xautolock -time 3 \
        -locker "sxlock -f '-*-envy code r-medium-r-*-*-*-*-*-*-*-*-*-*'" \
        -corners -000 &
fi

[ "$(pgrep -cf xfce4-power-manager)" -eq 0 ] && xfce4-power-manager

[ "$(pgrep -cf xfce4-volumed)" -eq 0 ] && xfce4-volumed

[ "$(pgrep -cx dropbox)" -eq 0 ] && dropbox
