#!/bin/bash

set -euo pipefail

prog=$(basename "$0")

usage() {
    echo "usage: $prog [options] [file ... ]"
    echo
    echo "Configuration file manager | github.com/kevlar1818/dotfiles"
    echo
    echo "Copyright 2015 Kevin Hanselman (See LICENSE or source)"
    echo
    echo "Arguments:"
    echo "  file(s)         attempts to link only the glob/file(s)"
    echo "                  (defaults to all files matching the glob '_*')"
    echo
    echo "Options:"
    echo "  -h              show this help text and exit"
    echo "  -r              remove symlinks and restore backups if present"
    echo "  -x              act on all files excluding '[file] ...'"
    echo "  -q              quiet mode/suppress output"
}

error() {
    echo -e "$prog: $1" >&2
    exit 1
}

link_file() {
    # NOTE: source_file must be passed-in as a path relative to this script's directory
    source_file="$1"
    [ -e "$source_file" ] || error "File '$source_file' does not exist."

    target_file="${HOME}/${source_file/_/.}"

    mkdir -p "$(dirname "$target_file")"

    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        [ -n "$verbose" ] && echo ":: Backing up $target_file"
        mv "$verbose" "$target_file" "$target_file.df.bak"
    fi

    ln "$verbose" -sf "$(readlink -e "$source_file")" "$target_file"
}

unlink_file() {
    target_file="${HOME}/${1/_/.}"

    if [ -L "$target_file" ]; then
        rm "$verbose" "$target_file"
        if [ -e "$target_file.df.bak" ]; then
            [ -n "$verbose" ] && echo ":: Restoring from '$target_file.df.bak'"
            mv "$verbose" "$target_file.df.bak" "$target_file"
        fi
    fi
}

# cd to this script's directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

verbose='-v'
exclude=
restore=
while getopts ":h :x :r :q" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        x)
            exclude=yes
            ;;
        r)
            restore=yes
            ;;
        q)
            verbose=
            ;;
        \?)
            usage
            error "Invalid option: -$OPTARG"
            ;;
        :)
            usage
            error "Option -$OPTARG requires an argument.\n"
            ;;
    esac
done

shift $((OPTIND-1))

files="_*"
if [ -n "$*" ] && [ -z "$exclude" ]; then # if we passed args to this script
    files=$*
fi

for path in $files; do
    if [ -n "$exclude" ] && [[ "$*" == *"$path"* ]]; then
        [ -n "$verbose" ] && echo "skipping '$path'"
        continue
    fi
    if [ -d "$path" ]; then
        find "$path" -type f | while read -r file; do
            if [ -n "$restore" ]; then
                unlink_file "$file"
            else
                link_file "$file"
            fi
        done
    elif [ -f "$path" ]; then
        if [ -n "$restore" ]; then
            unlink_file "$path"
        else
            link_file "$path"
        fi
    fi
done

