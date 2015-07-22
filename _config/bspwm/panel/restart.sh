#!/bin/bash

pkill -f start_panel.sh
pkill -f conky_
~/.config/bspwm/panel/start_panel.sh &
~/.config/bspwm/startup.sh
