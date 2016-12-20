#!/bin/bash

[ -f ~/.fehbg ] && source ~/.fehbg

bspc config top_padding 0
bspc config -m primary top_padding 20

for monitor in $(bspc query -M); do
    bspc monitor "$monitor" -d {1,2,3,4,5}
done

killall polybar
MONITOR=$(xrandr | grep primary | awk '{print $1}') polybar top
