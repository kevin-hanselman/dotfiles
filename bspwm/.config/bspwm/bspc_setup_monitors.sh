#!/bin/bash

[ -x ~/.fehbg ] && ~/.fehbg
[ -x ~/.bin/auto-config-displays.sh ] && ~/.bin/auto-config-displays.sh

bspc config top_padding 0
bspc config -m primary top_padding 28

for monitor in $(bspc query -M); do
    bspc monitor "$monitor" -d {1,2,3,4,5}
done
