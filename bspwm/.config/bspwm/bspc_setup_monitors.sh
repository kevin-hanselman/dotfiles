#!/bin/bash

# reset padding in case we've changed primary monitors
bspc config top_padding 0
bspc config -m primary top_padding 20

[ -f ~/.fehbg ] && source ~/.fehbg

for monitor in $(bspc query -M); do
    bspc monitor "$monitor" -d {1,2,3,4,5}
done
