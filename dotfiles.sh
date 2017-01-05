#!/bin/bash

set -euo pipefail

prog=$(basename "$0")

usage() {
    echo "usage: $prog [options] [subdirectory ... ]"
    echo
    echo "Configuration file manager | github.com/kevlar1818/dotfiles"
    echo
    echo "Copyright 2014-2016 Kevin Hanselman (See LICENSE or source)"
    echo
    echo "Arguments:"
    echo "  subdirectory    symlinks all files in the given subdirectory"
    echo "                  (defaults to all subdirectories)"
    echo
    echo "Options:"
    echo "  -r              remove symlinks and restore backups if present"
    echo "  -n              show what would be done, but take no other action"
    echo "  -h              show this help text and exit"
}

warn() {
    echo "$prog: $1" >&2
}

error() {
    warn "$1"
    exit 1
}

link_file() {
    # subdir is the sub-directory where the config files are stored
    local subdir="$1"
    [ -d "$subdir" ] || error "Directory '$subdir' does not exist."

    # relpath_source_file is a relative path starting inside a dotfiles sub-dir
    local relpath_source_file="$2"
    local fullpath_source_file
    fullpath_source_file=$(readlink -m "${subdir}/${relpath_source_file}")

    [ -f "$fullpath_source_file" ] || error "File '$fullpath_source_file' does not exist."

    # trim duplicate forward slashes
    local target_file="${HOME%/}/${relpath_source_file}"

    local backup_file="${target_file}.df.bak"

    mkdir -p "$(dirname "$target_file")"

    if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "backup '$target_file' to '$backup_file'"
        [ -n "$noaction" ] || cp "$target_file" "$backup_file"
    fi

    echo "symlink '$fullpath_source_file' to '$target_file'"
    [ -n "$noaction" ] || ln -sf "$fullpath_source_file" "$target_file"
}

unlink_file() {
    # subdir is the sub-directory where the config files are stored
    local subdir="$1"
    [ -d "$subdir" ] || error "Directory '$subdir' does not exist."

    # relpath_source_file is a relative path starting inside a dotfiles sub-dir
    local relpath_source_file="$2"

    # trim duplicate forward slashes
    local target_file="${HOME%/}/${relpath_source_file}"

    [ -f "$target_file" ] || { warn "File '$target_file' does not exist."; return; }
    [ -L "$target_file" ] || { warn "File '$target_file' is not a link."; return; }

    local backup_file="${target_file}.df.bak"

    if [ -f "$backup_file" ]; then
        echo "restore backup of '$target_file' from '$backup_file'"
        [ -n "$noaction" ] || mv "$backup_file" "$target_file"
    else
        echo "remove '$target_file'"
        [ -n "$noaction" ] || rm "$target_file"
    fi
}

# cd to this script's directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

restore=
noaction=
while getopts ":h :r :n" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        r) restore=yes ;;
        n) noaction=yes ;;
        \?)
            usage
            error "Invalid option: -$OPTARG"
            ;;
        :)
            usage
            error "Option -$OPTARG requires an argument."
            ;;
    esac
done
if [ -n "$noaction" ]; then
    echo '===> Dry-run only: not modifying filesystem <==='
fi

shift $((OPTIND-1))

if [ -n "$*" ]; then
    files=$*
else
    # act on all directories which are siblings to this script
    files=$(find . -maxdepth 1 -type d -not -path './.git' -not -path '.' -printf '%P\n')
fi

for path in $files; do
    [ -d "$path" ] || error "'$path' is not a directory."
    find "$path" -type f -printf '%P\n' | while read -r file; do
        if [ -n "$restore" ]; then
            unlink_file "$path" "$file"
        else
            link_file "$path" "$file"
        fi
    done
done

