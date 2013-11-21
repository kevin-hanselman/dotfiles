#!/usr/bin/env bash

# http://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias
confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo true
            ;;
        *)
            echo false
            ;;
    esac
}

function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        mv $target $target.df.bak
    fi

    ln -sf ${source} ${target}
}

function unlink_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}.df.bak" ] && [ -L "${target}" ]; then
        unlink ${target}
        mv $target.df.bak $target
    fi
}

BRANCH=`git symbolic-ref --short HEAD`

CONFIRM=`confirm "You are using the '$BRANCH' configuration. Continue? [y/N] "`
echo "$CONFIRM"
if [ "$CONFIRM" == "false" ]; then
	echo "Use 'git checkout' to switch branches/configurations."
	exit 0
fi
exit 0
if [ "$1" = "vim" ]; then
    for i in _vim*
    do
       link_file $i
    done
elif [ "$1" = "restore" ]; then
    for i in _*
    do
        unlink_file $i
    done
    exit
else
    for i in _*
    do
        link_file $i
    done
fi

unset link_file
unset unlink_file
unset confirm

