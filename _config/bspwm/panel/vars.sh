#!/bin/bash

# panel setup
PANEL_GAP=9
PANEL_HEIGHT=$((PANEL_GAP * 2))
FONT_ONE='Envy Code R-8'

[ -f /tmp/xrandr.txt ] || xrandr > /tmp/xrandr.txt

MON_DIMENSIONS=$(cat /tmp/xrandr.txt | grep primary | awk '{ print $4 }')
MON_OFFSET=$(echo "$MON_DIMENSIONS" | cut -d+ -f2)
MON_WIDTH=$(echo "$MON_DIMENSIONS" | cut -dx -f1)

PANEL_GEOMETRY="$((MON_WIDTH - PANEL_HEIGHT))x${PANEL_HEIGHT}+$((MON_OFFSET + PANEL_GAP))+$PANEL_GAP"
#PANEL_GEOMETRY=$(echo $MON_DIMENSIONS | sed 's/x[0-9]\+/x'$PANEL_HEIGHT'/')

PANEL_FIFO=/tmp/panel-fifo

# colors
COLOR_FG="$(grep -m1 '\*foreground:' ~/.Xresources | awk '{ print $2 }')"
COLOR_BG="$(grep -m1 '\*background:' ~/.Xresources | awk '{ print $2 }')"
COLOR_UNFOC="$(grep -m1 '\*color7:' ~/.Xresources  | awk '{ print $2 }')"
COLOR_URG="$(grep -m1 '\*color1:' ~/.Xresources    | awk '{ print $2 }')"

C_FG="#FF${COLOR_FG/\#}"
C_BG="#FF${COLOR_BG/\#}"
C_UNFOC="#FF${COLOR_UNFOC/\#}"
C_URG="#FF${COLOR_URG/\#}"

