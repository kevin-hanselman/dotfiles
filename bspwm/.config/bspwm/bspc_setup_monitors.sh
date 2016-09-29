#!/bin/bash

[ -f ~/.fehbg ] && source ~/.fehbg
xrandr > /tmp/xrandr.txt

top_left_mon=$(grep '\s*connected' /tmp/xrandr.txt | grep '+0+0' | awk '{print $1}')
bspc config top_padding 0
bspc config -m "$top_left_mon" top_padding 20

for monitor in $(bspc query -M); do
    bspc monitor "$monitor" -d {1,2,3,4,5}
done
