#!/bin/bash

# panel setup
PANEL_HEIGHT=18
FONT_ONE='Envy Code R-8'

[ -f /tmp/xrandr.txt ] || xrandr > /tmp/xrandr.txt

MON_DIMENSIONS=$(cat /tmp/xrandr.txt | grep primary | awk '{ print $4 }')
MON_OFFSET=$(echo "$MON_DIMENSIONS" | cut -d+ -f2)
MON_WIDTH=$(echo "$MON_DIMENSIONS" | cut -dx -f1)

PANEL_GEOMETRY="$((MON_WIDTH - 18))x${PANEL_HEIGHT}+$((MON_OFFSET + 9))+9"
#PANEL_GEOMETRY=$(echo $MON_DIMENSIONS | sed 's/x[0-9]\+/x'$PANEL_HEIGHT'/')

PANEL_FIFO=/tmp/panel-fifo

# colors
C_FG="#FF$(grep -m1 '*foreground:' ~/.Xresources | cut -d'#' -f2)"
C_BG="#FF$(grep -m1 '*background:' ~/.Xresources | cut -d'#' -f2)"
C_UNFOC="#FF$(grep -m1 '*color7:' ~/.Xresources | cut -d'#' -f2)"
C_URG="#FF$(grep -m1 '*color1:' ~/.Xresources | cut -d'#' -f2)"

