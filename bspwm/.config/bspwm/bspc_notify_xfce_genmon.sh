#! /bin/bash

while read -r line ; do
    xfce4-panel --plugin-event=genmon-9:refresh:bool:true
done < <(bspc subscribe)
