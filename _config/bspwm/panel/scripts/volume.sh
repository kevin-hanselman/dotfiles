#! /bin/bash

set -eo pipefail
simple=
if [ "$1" == 'simple' ]; then
    simple='yes'
fi
set -u

vol=$(amixer sget Master,0 | grep -Po '\d+%|\b(?:on|off)\b' | tr -d '\n')
percent=$(echo "$vol" | cut -d% -f1)
stat=$(echo "$vol" | cut -d% -f2)

if [ -n "$simple" ]; then
    if [ "$stat" == 'off' ]; then
        echo 'off'
    else
        echo "${percent}%"
    fi
elif [ "$stat" == 'off' ]; then
    echo ''
elif [ "$percent" -gt 70 ]; then
    echo ''
elif [ "$percent" -gt 20 ]; then
    echo ''
else
    echo ''
fi
