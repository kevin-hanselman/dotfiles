#!/bin/bash

prog=$(basename "$0")

error () {
    echo "$prog: $1" >&2
    exit 1
}

usage () {
    echo "usage: $prog <base directory>"
}

if [ -z "$1" ]; then
    usage
    error "requires argument"
fi

basepath="$(realpath "$1" 2> /dev/null || echo "$1")"

if [ ! -d "$basepath" ]; then
    usage
    error "invalid directory: '$basepath'"
fi

ycm_conf_file="$basepath/.ycm_extra_conf.py"
ctags_file="$basepath/.tags"

cp -v --backup -S '.bak' ~/.vim/ycm_extra_conf.py "$ycm_conf_file"

ctags --help 2> /dev/null | grep -i 'exuberant' &> /dev/null \
    || error 'Exuberant Ctags not found. Skipping tag file.'

ctags --fields=+l -R -f "$ctags_file" "$basepath"
