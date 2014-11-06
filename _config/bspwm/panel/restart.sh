#!/bin/bash

pkill -f panel
pkill -f conky_
~/.config/bspwm/panel/panel &
~/.config/bspwm/startup.sh
