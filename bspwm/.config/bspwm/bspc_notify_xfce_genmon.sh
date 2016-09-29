#! /bin/bash

while read -r line ; do
    # The "genmon-N" ID can be retrieved by going to the
    # xfce4-panel "Items" tab and hovering over the
    # GenMon in question.
    xfce4-panel --plugin-event=genmon-9:refresh:bool:true
done < <(bspc subscribe)
