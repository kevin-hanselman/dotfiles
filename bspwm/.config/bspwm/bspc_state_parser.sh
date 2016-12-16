#! /bin/bash

format="$1"

set -euo pipefail

fgcolor=$(xrdb -query | grep 'foreground' | awk '{ print $2 }')
dimcolor=$(xrdb -query | grep 'color8' | awk '{ print $2 }')
bgcolor=$(xrdb -query | grep 'background' | awk '{ print $2 }')

start_active_mon="<span fgcolor='$fgcolor'>(</span>"
end_active_mon="<span fgcolor='$fgcolor'>)</span>"

num_mon=$(bspc query -M | wc -l)
active_mon=
output=

IFS=':'
# shellcheck disable=SC2046
set -- $(bspc wm -g)
# e.g. bspc wm -g/bspc subscribe report
# WMeDP-1:O1:o2:f3:f4:f5:LT:TT:G

while [ $# -gt 0 ] ; do
    item="${1/W}" # strip the leading W from the start of the line
    value="${item/?}" # strip the leading character from the item
    append=
    #echo "item = $item, value = $value"
    case "$item" in
        M*) # active monitor
            if [ "$num_mon" -gt 1 ] ; then
                if [ -n "$output" ]; then
                    append="${append}   "
                fi
                active_mon="$value"
                append="${append}${start_active_mon}${value}:"
            fi
            ;;
        m*) # inactive monitor
            if [ "$num_mon" -gt 1 ] ; then
                if [ -n "$active_mon" ]; then
                    active_mon=
                    append="${append}${end_active_mon}"
                fi
                if [ -n "$output" ]; then
                    append="${append}   "
                fi
                append="${append}${value}:"
            fi
            ;;
        O*|F*) # focused occupied desktop
            append="${append}<span weight='Bold'> ${value}</span>"
            ;;
        o*) # occupied desktop
            append="${append}<span fgcolor='$dimcolor'> ${value}</span>"
            ;;
        f*) # free desktop
            # exclude from bar
            ;;
        u*|U*) # urgent desktop
            append="${append}<span fgcolor='Red'> ${value}</span>"
            ;;
        L*) # layout (Tiling/Monocle)
            ;;
    esac
    output="${output}${append}"
    shift
done
if [ -n "$active_mon" ]; then
    output="${output}${end_active_mon}"
fi

if [ -n "$format" ]; then
    echo "<txt><span fgcolor='$fgcolor'>$output</span></txt>"
else
    echo "<span fgcolor='$fgcolor'>$output</span>"
fi
