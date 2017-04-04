#!/bin/bash

format="$1"

packages=$(checkupdates | awk '{print $1}')
num_updates=$(echo "$packages" | wc -w)

if [ "$num_updates" -eq 0 ]; then
    color=$(xrdb -query | grep -m1 'color8' | awk '{ print $2 }')

elif echo "$packages" | grep -qi '^linux$' ; then
    color=$(xrdb -query | grep -m1 'color3' | awk '{ print $2 }')

else
    color=$(xrdb -query | grep -m1 'foreground' | awk '{ print $2 }')
fi

if [ "${format,,}" == pango ]; then
    echo "<txt><span color=\"$color\">${num_updates}</span></txt>"
else
    # default to lemonbar
    echo "%{F$color}${num_updates}%{F-}"
fi
