#!/usr/bin/env bash

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
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ ! -e "${source}" ]; then
        echo "File '${source}' not found." >&2
        exit 1
    fi

    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        mv -v $target $target.df.bak
    fi

    ln -sfnv ${source} ${target}
}

unlink_file() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"
    
    if [ -L "${target}" ]; then
        rm -v ${target}
        if [ -e "${target}.df.bak" ]; then
            mv -v $target.df.bak $target
        fi
    fi
}

usage() {
    echo -e "usage: dotfiles.sh [options] [file] ...\n"
    echo -e "Author: Kevin Hanselman | www.github.com/kevlar1818/dotfiles\n"
    echo -e "Positional Arguments:"
    echo -e "  file(s)\tattempts to link only the glob/file(s)"
    echo -e "\nOptions:"
    echo -e "  -h\t\tshow this help text and exit"
    echo -e "  -y\t\tdon't ask for confirmation"
    exit 0
}

#
# Parse arguments
#
ASK=true
while getopts ":h :y" opt; do
    case $opt in
        h)
            usage
            ;;
        y)
            ASK=false
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

BRANCH=`basename \`git symbolic-ref HEAD\``
echo "Using the '$BRANCH' configuration."
if $ASK ; then
    CONFIRM=`confirm`
else
    CONFIRM=true
fi
if [ "$CONFIRM" != "true" ]; then
	echo "Use 'git checkout' to switch branches/configurations."
	exit 0
fi

shift $(($OPTIND-1))

if [ "$1" = "restore" ]; then
    for i in _*; do
        unlink_file $i
    done
    exit
elif [ "$*" ]; then
    for i in $@; do
        link_file $i
    done
else
    for i in _*; do
        link_file $i
    done
fi

