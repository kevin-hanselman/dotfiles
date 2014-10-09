#!/bin/bash

[ $(pgrep -cf compton) -eq 0 ] && compton -b

[ $(pgrep -cf panel) -eq 0 ] && ~/.config/bspwm/panel/panel &

dropbox start

[ $(pgrep -cf xautolock) -eq 0 ] && xautolock -time 3 -locker slimlock -detectsleep &

[ $(pgrep -cf xfce4-power-manager) -eq 0 ] && xfce4-power-manager

[ $(pgrep -cf xfce4-volumed) -eq 0 ] && xfce4-volumed

