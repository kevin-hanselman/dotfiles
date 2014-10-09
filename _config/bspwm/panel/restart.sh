#!/bin/bash

pkill -x panel
pkill -f conky_
~/.config/bspwm/panel/panel &
~/.config/bspwm/startup.sh
