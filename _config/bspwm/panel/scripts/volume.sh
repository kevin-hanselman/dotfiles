#! /bin/bash

vol=$(amixer sget Master,0 | grep -Po '\d+%|\b(?:on|off)\b' | tr -d '\n') || exit 1
n=$(echo $vol | cut -d% -f1) || exit 1
stat=$(echo $vol | cut -d% -f2) || exit 1

if [ "$stat" == 'off' ]; then
    echo ''
elif [ "$n" -gt 70 ]; then
    echo ''
elif [ "$n" -gt 20 ]; then
    echo ''
else
    echo ''
fi
