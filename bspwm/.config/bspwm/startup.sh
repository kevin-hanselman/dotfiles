#!/bin/bash

# bspwm startup programs

process_not_running() {
    test "$(pgrep -cf "$1")" -eq 0
}

run_detached() {
    cmd_name="$1"
    if process_not_running "$cmd_name"; then
        echo "Starting command '$*'"
        nohup "$@" 2>&1 >/dev/null </dev/null &
    fi
}

run_daemon() {
    cmd_name="$1"
    if process_not_running "$cmd_name"; then
        echo "Starting daemon '$*'"
        "$@"
    fi
}

run_detached sxhkd
run_detached compton

run_detached xautolock -time 3 \
    -locker "sxlock -f '-*-terminus-medium-r-*-*-17-*-*-*-*-*-*-*'" \
    -corners -000

run_daemon xfce4-power-manager

run_detached orage

~/.config/bspwm/start_polybar.sh

run_detached nm-applet

run_daemon dropbox

run_detached ~/.config/bspwm/bspc_monitor_event_listener.sh
