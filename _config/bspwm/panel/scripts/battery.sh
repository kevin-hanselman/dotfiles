#!/bin/bash

set -euo pipefail

BAT=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g')
STATUS=$(acpi -b | awk '{gsub(/,/,""); print $3}')

# Set Icon
if [ "$STATUS" != "Discharging" ]; then
    icon=''
elif [ "$BAT" -gt 75 ]; then
    icon=''
elif [ "$BAT" -gt 50 ]; then
    icon=''
elif [ "$BAT" -gt 25 ]; then
    icon=''
else
    icon=''
fi

s="«"
bar=""
case "$BAT" in
    100)
        bar=""
        ;;
    [0-5])
        bar="\f8$s$s$s$s$s$s$s$s$s"
        #icon="%{U#FFFF0000}%{+u}$icon"
        ;;
    [5-9])
        bar="\f3$s\f8$s$s$s$s$s$s$s$s"
        #icon="%{U#FFFFD300}%{+u}$icon"
        ;;
    [1-2]*)
        bar="$s$s\f8$s$s$s$s$s$s$s"
        ;;
    3*)
        bar="$s$s$s\f8$s$s$s$s$s$s"
        ;;
    4*)
        bar="$s$s$s$s\f8$s$s$s$s$s"
        ;;
    5*)
        bar="$s$s$s$s$s\f8$s$s$s$s"
        ;;
    6*)
        bar="$s$s$s$s$s$s\f8$s$s$s"
        ;;
    7*)
        bar="$s$s$s$s$s$s$s\f8$s$s"
        ;;
    8*)
        bar="$s$s$s$s$s$s$s$s\f8$s"
        ;;
    *)
        bar="$s$s$s$s$s$s$s$s$s"
        ;;
esac

# Create Bar
echo "$icon"
