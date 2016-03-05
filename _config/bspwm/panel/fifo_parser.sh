#! /bin/bash

set -euo pipefail

cd "$(dirname "$0")"
source ./vars.sh

title=
sys_infos=
active_mon=
num_mon=$(bspc query -M | wc -l)

while read -r line ; do
    case "$line" in
        S*)
            # conky output
            sys_infos="${line#?} "
            ;;
        T*)
            # conky date/time output
            title="${line#?}"
            ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=
            sorted=$(echo "${line#?}" | \
                     grep -io 'm[a-ln-z\:0-9\/]\+' | \
                     sed -e 's/:$//g' | \
                     sort -f | \
                     tr '\n' ':' | \
                     sed -e 's/:$//')
            IFS=':'
            # shellcheck disable=SC2086
            set -- $sorted
            while [ $# -gt 0 ] ; do
                item=$1
                #name=${item#?}
                name=${item#?[0-9]?}
                # e.g.
                # WM2:O1:o2:f3:f4:f5:LT:m1:F1:f2:f3:f4:f5:LT:m3:O1:f2:f3:f4:f5:LT
                case "$item" in
                    M*)
                        # active monitor
                        if [ "$num_mon" -gt 1 ] ; then
                            [ -n "$wm_infos" ] && wm_infos="$wm_infos    "
                            active_mon=$name
                        fi
                        ;;
                    m*)
                        # inactive monitor
                        if [ "$num_mon" -gt 1 ] ; then
                            [ -n "$wm_infos" ] && wm_infos="$wm_infos    "
                            active_mon=
                        fi
                        ;;
                    O*|F*|U*)
                        # focused occupied desktop
                        if [ -n "$active_mon" ]; then
                            wm_infos="${wm_infos}%{+u} ${name} %{-u}"
                        else
                            wm_infos="${wm_infos} ${name} "
                        fi
                        ;;
                    o*)
                        # occupied desktop
                        if [ -n "$active_mon" ]; then
                            wm_infos="${wm_infos}%{F$C_UNFOC}%{+u} ${name} %{-u}%{F-}"
                        else
                            wm_infos="${wm_infos}%{F$C_UNFOC} ${name} %{F-}"
                        fi
                        ;;
                    f*)
                        # free desktop
                        # exclude from bar
                        ;;
                    u*)
                        # urgent desktop
                        if [ -n "$active_mon" ]; then
                            wm_infos="${wm_infos}%{F$C_BG}%{B$C_URG}%{+u} ${name} %{-u}%{B-}%{F-}"
                        else
                            wm_infos="${wm_infos}%{F$C_BG}%{B$C_URG} ${name} %{B-}%{F-}"
                        fi
                        ;;
                    L*)
                        # layout (Tiling/Monocle)
                        ;;
                esac
                shift
            done
            ;;
    esac
    space_for_sys_tray='           '
    printf "%s\n" "%{l}${wm_infos}%{c}${title}%{r}${sys_infos}${space_for_sys_tray}"
done
