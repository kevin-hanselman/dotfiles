#!/usr/bin/env bash

usage() {
    echo -e "usage: `basename $0` [options] [file ... ]\n"
    echo -e "Configuration file manager | www.github.com/kevlar1818/dotfiles"
    echo -e "\nCopyright 2013 Kevin Hanselman (See LICENSE or source)"
    echo -e "\nArguments:"
    echo -e "  file(s)\tattempts to link only the glob/file(s)"
    echo -e "  \t\t (defaults to all files matching the glob '_*')"
    echo -e "\nOptions:"
    echo -e "  -h\t\tshow this help text and exit"
    echo -e "  -r\t\tremove symlinks and restore backups if present"
    echo -e "  -x\t\tact on all files excluding '[file] ...'"
    echo -e "  -y\t\tdon't ask for confirmation"
    echo -e "  -q\t\tquiet mode/suppress output"
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Continue? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            echo true
            ;;
        *)
            echo false
            ;;
    esac
}

link_file() {
    source_file="${1}"
    link_file="${HOME}/$(echo "${source_file}" | sed 's/^_/./')"
    link_dir="$(dirname "${link_file}")"

    if [[ ! -d "${link_dir}" ]]; then
        mkdir -p "${link_dir}"
    fi

    if [ ! -e "$source_file" ]; then
        echo "File '$source_file' not found." >&2
        exit 1
    fi

    if [ -e "${link_file}" ] && [ ! -L "${link_file}" ]; then
        [ -n "$2" ] && echo "Backing up ${link_file}"
        mv "${link_file}" "${link_file}.df.bak"
    fi

    ln -sf "$(readlink -e "${source_file}")" "${link_file}"
}

unlink_file() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -L "$target" ]; then
        rm $2 $target
        if [ -e "$target.df.bak" ]; then
            [ -n "$2" ] && echo "Restoring from '$target.df.bak'."
            mv $target.df.bak $target
        fi
    fi
}

# get path to this script and cd quietly
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$dir" > /dev/null

verbose="-v"
while getopts ":h :y :x :r :q" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        y)
            ask=false
            ;;
        x)
            exclude=true
            ;;
        r)
            restore=true
            ;;
        q)
            verbose=
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG\n" >&2
            usage
            exit 1
            ;;
        :)
            echo -e "Option -$OPTARG requires an argument.\n" >&2
            usage
            exit 1
            ;;
    esac
done

branch=$( basename "$(git symbolic-ref HEAD)" )
echo "Using the '$branch' configuration."
if [ -z "$ask" ]; then
    confirm=`confirm`
else
    confirm=true
fi
if [ "$confirm" != "true" ]; then
    echo "Use 'git checkout' to switch branches/configurations."
    exit 0
fi

shift $(($OPTIND-1))

if [ -n "$*" ] && [ -z "$exclude" ]; then # if we passed args to this script
    files=$@
else # default to all files matching glob _*
    files=_*
fi
for i in $files; do
    if [ -n "$exclude" ] && [[ "$*" == *"$i"* ]]; then
        [ -n "$verbose" ] && echo "skipping '$i'"
        continue
    fi
    if [[ -d "${i}" ]]; then
        dir_files=$(find "${i}" -type f)
        for f in ${dir_files} ; do
            if [[ -n "$restore" ]]; then
                unlink_file "${f}" "$verbose"
            else
                link_file "${f}" "$verbose"
            fi
        done
    elif [[ -f "${i}" ]]; then
        if [[ -n "$restore" ]]; then
            unlink_file "${i}" "$verbose"
        else
            link_file "${i}" "$verbose"
        fi
    fi
done
popd > /dev/null

