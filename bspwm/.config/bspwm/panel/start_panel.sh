#!/bin/bash

set -euo pipefail

prog=$(basename "$0")

if [ "$(pgrep -cx "$prog")" -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

cd "$(dirname "$0")"
source ./vars.sh

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# make space for BAR on only the primary monitor
#bspc config -m "$(bspc query -M | head -n 1)" top_padding $PANEL_HEIGHT
bspc config -m primary top_padding $((PANEL_GAP * 3))
bspc subscribe report > "$PANEL_FIFO" &
conky -c ./time_date.conkyrc > "$PANEL_FIFO" &
conky -c ./panel.conkyrc > "$PANEL_FIFO" &

nm-applet &

./fifo_parser.sh < "$PANEL_FIFO" |  \
    lemonbar                        \
        -g "$PANEL_GEOMETRY"        \
        -f "$FONT_ONE"              \
        -F "$C_FG"                  \
        -B "$C_BG"                  \
        -u 1 |                      \
while read -r line; do
    ~/.config/bspwm/panel/scripts/toggle_conky.sh "$line"
done &

# sleep to prevent stalonetray starting faster and ending up getting drawn behind lemonbar
sleep 1
geometry="1x1+$((MON_WIDTH + MON_OFFSET - PANEL_GAP * 3))+$((PANEL_GAP + 1))"
stalonetray \
    --geometry "$geometry" \
    --max-geometry '4x1' \
    --grow-gravity 'NE' --icon-gravity 'NE' \
    --icon-size 16 \
    --background "$COLOR_BG" &

wait
