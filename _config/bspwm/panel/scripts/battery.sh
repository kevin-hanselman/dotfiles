#!/bin/bash
source $(dirname $0)/../config

BAT=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g')
STATUS=$(acpi -b | awk '{gsub(/,/,""); print $3}')

# Set Icon
icon=""
if [ "$STATUS" != "Discharging" ]; then
    icon=" "
fi
if [ "$STATUS" == "Full" ]; then
    icon="${icon}"
elif [ "$BAT" -gt 70 ]; then
    icon="${icon}"
elif [ "$BAT" -gt 30 ]; then
    icon="${icon}"
elif [ "$BAT" -gt 10 ]; then
    icon="${icon}"
else
    icon="${icon}"
fi

s="«"
bar=""
case $BAT in
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
