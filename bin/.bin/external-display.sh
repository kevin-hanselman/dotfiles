#!/bin/bash

set -euo pipefail

prog=$(basename "$0")

fatal() {
    echo "$prog: $1" >&2
    exit 1
}

active_displays=$(xrandr | grep -P '\d+x\d+\+\d+\+' | awk '{print $1}' | sort)

[ "$(echo "$active_displays" | wc -l)" -eq 1 ] || fatal 'more than one active display'

connected_displays=$(xrandr | grep -P '\bconnected\b' | awk '{print $1}' | sort)
inactive_displays=$(comm -23 <(echo "$connected_displays") <(echo "$active_displays"))

[ "$(echo "$inactive_displays" | wc -l)" -eq 1 ] || fatal 'more than one inactive display'

case "$1" in
    above|up)
        position='--above'
        ;;
    below|down)
        position='--below'
        ;;
    right)
        position='--right-of'
        ;;
    left)
        position='--left-of'
        ;;
    mirror)
        position='--same-as'
        ;;
    *)
        fatal 'argument must be one of {left, right, mirror}'
        ;;
esac

set -x
xrandr --output "$inactive_displays" --auto "$position" "$active_displays"
