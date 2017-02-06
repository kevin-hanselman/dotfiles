#!/bin/bash

set -euo pipefail

direction="$1"
percent="$2"

cmd_exists() {
    type "$1" &>/dev/null
}

if cmd_exists xbacklight; then
    if [ "$direction" == up ]; then
        xbacklight -inc "$percent"
    elif [ "$direction" == down ]; then
        xbacklight -dec "$percent"
    fi
elif cmd_exists light; then
    if [ "$direction" == up ]; then
        light -p -A "$percent"
    elif [ "$direction" == down ]; then
        light -p -U "$percent"
    fi
fi
