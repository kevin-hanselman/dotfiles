#!/bin/sh
MONITOR=$(xrandr -q | grep primary | awk '{print $1}') polybar top
