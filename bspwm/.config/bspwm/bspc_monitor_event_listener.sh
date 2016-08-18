#! /bin/bash

while read -r line ; do
    ~/.config/bspwm/bspc_setup_monitors.sh
done < <(bspc subscribe monitor_add monitor_remove monitor_swap)
