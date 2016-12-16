#!/bin/bash

format="$1"

packages=$(packer --quickcheck)
num_updates=$(echo "$packages" | wc -l)

if [ "$num_updates" -eq 0 ]; then
    color=$(xrdb -query | grep 'color8' | awk '{ print $2 }')

elif echo "$packages" | qrep -qi '^linux\b' ; then
    color=$(xrdb -query | grep 'color3' | awk '{ print $2 }')

else
    color=$(xrdb -query | grep 'foreground' | awk '{ print $2 }')
fi

if [ "${format,,}" == pango ]; then
    echo "<txt><span color=\"$color\">${num_updates}</span></txt>"
else
    # default to lemonbar
    echo "%{F$color}${num_updates}%{F-}"
fi
