#!/bin/bash

packages=$(packer --quickcheck)
num_updates=$(echo "$packages" | wc -l)

if [ "$num_updates" -eq 0 ]; then
    color=$(xrdb -query | grep 'color8' | awk '{ print $2 }')

elif echo "$packages" | qrep -qi '^linux\b' ; then
    color=$(xrdb -query | grep 'color3' | awk '{ print $2 }')

else
    color=$(xrdb -query | grep 'color6' | awk '{ print $2 }')
fi

echo "<txt><span color=\"$color\">${num_updates}</span></txt>"
