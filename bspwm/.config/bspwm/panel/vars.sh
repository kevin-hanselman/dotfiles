#!/bin/bash

# panel setup
PANEL_GAP=9
PANEL_HEIGHT=$((PANEL_GAP * 2))
FONT_ONE='Envy Code R-8'

[ -f /tmp/xrandr.txt ] || xrandr > /tmp/xrandr.txt

MON_DIMENSIONS=$(grep primary /tmp/xrandr.txt | awk '{ print $4 }')
MON_OFFSET=$(echo "$MON_DIMENSIONS" | cut -d+ -f2)
MON_WIDTH=$(echo "$MON_DIMENSIONS" | cut -dx -f1)

PANEL_GEOMETRY="$((MON_WIDTH - PANEL_HEIGHT))x${PANEL_HEIGHT}+$((MON_OFFSET + PANEL_GAP))+$PANEL_GAP"

PANEL_FIFO=/tmp/panel-fifo

# colors
COLOR_FG="$(xrdb -query | grep foreground | awk '{ print $2 }')"
COLOR_BG="$(xrdb -query | grep background | awk '{ print $2 }')"
COLOR_UNFOC="$(xrdb -query | grep color8 | awk '{ print $2 }')"
COLOR_URG="$(xrdb -query | grep color14 | awk '{ print $2 }')"

C_FG="#FF${COLOR_FG/\#}"
C_BG="#FF${COLOR_BG/\#}"
C_UNFOC="#FF${COLOR_UNFOC/\#}"
C_URG="#FF${COLOR_URG/\#}"

