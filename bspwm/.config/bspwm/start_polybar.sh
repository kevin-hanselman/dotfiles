#!/bin/bash

process_not_running() {
    test "$(pgrep -cx "$1")" -eq 0
}

run_detached() {
    cmd_name="$1"
    if process_not_running "$cmd_name"; then
        echo "Starting command '$*'"
        nohup "$@" 2>&1 >/dev/null </dev/null &
    fi
}

MONITOR=$(xrandr | grep primary | awk '{print $1}') run_detached polybar top
