#!/bin/bash

# bspwm startup programs

[ $(pgrep -cx compton) -eq 0 ] && compton -b

[ $(pgrep -cx sxhkd) -eq 0 ] && sxhkd &

xsetroot -cursor_name left_ptr

[ $(pgrep -cx panel) -eq 0 ] && ~/.config/bspwm/panel/panel &

[ $(pgrep -cx xautolock) -eq 0 ] && xautolock -time 3 -locker slimlock -detectsleep &

[ $(pgrep -cf xfce4-power-manager) -eq 0 ] && xfce4-power-manager

[ $(pgrep -cf xfce4-volumed) -eq 0 ] && xfce4-volumed

dropbox start

