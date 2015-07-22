#!/bin/bash

# Note: to get the mouse coordinates in variables X and Y:
# eval $(xdotool getmouselocation --shell)

pkill -x dmenu

file="${1}.conkyrc"
class="conky_$1"

if [ $(pgrep -cf "$file") -gt 0 ]; then
    if [ -n "$(xdotool search --onlyvisible --class $class)" ]; then
        xdotool search --class conky windowunmap %@
    else
        xdotool search --class conky windowunmap %@
        xdotool search --class $class windowmap %1 windowraise
    fi
else
    xdotool search --class conky windowunmap %@
    if [ "$1" == 'weather' ]; then
        google-chrome-stable 'https://www.google.com/#q=weather' &
    else
        conky -c ~/.config/bspwm/panel/conky/$file
    fi
fi
