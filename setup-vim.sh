#!/bin/bash

mkdir -p ~/.vim/undo
mkdir ~/.vim/backup
mkdir ~/.vim/tmp
mkdir ~/.vim/plugins

./dotfiles.sh _vim*

mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c 'PlugInstall' -c 'qa!'
