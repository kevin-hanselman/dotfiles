#! /bin/bash

set -euo pipefail

while read -r line ; do
    xfce4-panel --plugin-event=genmon-3:refresh:bool:true
done < <(bspc subscribe)
