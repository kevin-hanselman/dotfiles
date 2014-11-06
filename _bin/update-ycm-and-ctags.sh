#!/bin/bash

prog=$(basename $0)

error () {
    echo "$prog: $1" >&2
    exit 1
}

usage () {
    echo "usage:  $prog <base directory>"
}

if [ -z "$1" ]; then
    usage
    error "requires argument"
fi

basepath="$(realpath $1 2> /dev/null || echo $1)"

if [ ! -d "$basepath" ]; then
    usage
    error "invalid argument: '$basepath'"
fi

tmpfile=$basepath/tmp_includes
ycmconf=$basepath/.ycm_extra_conf.py
tags=$basepath/.tags

if [ ! -f $ycmconf ]; then
    echo "YCM extra config file not found. Downloading YCM's boilerplate..."
    curl -fLo "$ycmconf" \
        https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py
fi

find $basepath -type f -iname '*.h' -printf "'-I%h',\n" | uniq > $tmpfile

# delete the .pyc cache file, since we're overwriting the original
[ -f "${ycmconf}c" ] && rm "${ycmconf}c"

# if the backup is more than a day old, create a new one
if [ ! -f "${ycmconf}.bak" ] || [ -n "$(find $basepath -name $(basename ${ycmconf}).bak -mtime +1)" ]; then
    cp -v $ycmconf "${ycmconf}.bak"
fi

lead="^'c++'"
trail='^]'
sed -i "/$lead/,/$trail/{ /$lead/{p; r $tmpfile
        }; /$trail/p; d }" $ycmconf
[ $? -eq 0 ] && rm $tmpfile

ctags --help 2> /dev/null | grep -i 'exuberant' &> /dev/null || error 'Exuberant Ctags not found. Skipping tag file.'
ctags -R -f $tags $basepath
