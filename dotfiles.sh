#!/usr/bin/env bash

# utility functions
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
    echo -e "usage: `basename $0` [options] [restore | file ... ]\n"
    echo -e "Configuration file manager"
    echo -e "Author: Kevin Hanselman | www.github.com/kevlar1818/dotfiles"
    echo -e "\nArguments:"
    echo -e "  restore\tremove symlinks and restore backups if present"
    echo -e "  file(s)\tattempts to link only the glob/file(s)"
    echo -e "  \t\t (defaults to all files matching the glob '_*')"
    echo -e "\nOptions:"
    echo -e "  -h\t\tshow this help text and exit"
    echo -e "  -y\t\tdon't ask for confirmation"
    echo -e "  -x\t\tsync all, excluding '[file] ...' (ignored if no file args)"
}

# parse arguments
ASK=true
while getopts ":h :y :x" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        y)
            ASK=false
            ;;
        x)
            EXCLUDE=true
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

if [ "$1" == "restore" ]; then
    for i in _*; do
        unlink_file $i
    done
elif [ -n "$*" ]; then
    if [ -n "$EXCLUDE" ]; then
        for i in _*; do
            [[ $* == *"$i"* ]] && continue
            link_file $i
        done
    else
        for i in $@; do
            link_file $i
        done
    fi
else
    for i in _*; do
        link_file $i
    done
fi

