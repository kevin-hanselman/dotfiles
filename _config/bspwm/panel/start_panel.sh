#! /bin/sh

prog=$(basename "$0")

if [ $(pgrep -cx "$prog") -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

cd $(dirname $0)
source ./vars.sh

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# make space for BAR on only the primary monitor
#bspc config -m "$(bspc query -M | head -n 1)" top_padding $PANEL_HEIGHT
bspc config -m "$(bspc query -M | head -n 1)" top_padding $((PANEL_HEIGHT * 3 / 2))
bspc control --subscribe > "$PANEL_FIFO" &
conky -c ./time_date.conkyrc > "$PANEL_FIFO" &
conky -c ./panel.conkyrc > "$PANEL_FIFO" &

cat "$PANEL_FIFO"           |   \
    ./fifo_parser.sh        |   \
    lemonbar                    \
        -g "$PANEL_GEOMETRY"    \
        -f "$FONT_ONE"          \
        -f "$FONT_TWO"          \
        -f "$FONT_THREE"        \
        -F "$C_FG"              \
        -B "$C_BG"              \
        -u 1 |                  \
while read line; do
    ~/.config/bspwm/panel/scripts/toggle_conky.sh "$line"
done &

wait
