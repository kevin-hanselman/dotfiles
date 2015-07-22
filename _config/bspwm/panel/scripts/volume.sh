#! /bin/bash

set -euo pipefail

vol=$(amixer sget Master,0 | grep -Po '\d+%|\b(?:on|off)\b' | tr -d '\n')
n=$(echo $vol | cut -d% -f1)
stat=$(echo $vol | cut -d% -f2)

if [ "$stat" == 'off' ]; then
    echo ''
elif [ "$n" -gt 70 ]; then
    echo ''
elif [ "$n" -gt 20 ]; then
    echo ''
else
    echo ''
fi
