#!/bin/bash

pkill -x start_panel.sh
pkill -f conky_
pkill -x nm-applet
pkill -x stalonetray
~/.config/bspwm/panel/start_panel.sh &

