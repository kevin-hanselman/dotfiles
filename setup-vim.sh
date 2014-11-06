#!/bin/bash

mkdir -p ~/.vim/undo
mkdir ~/.vim/backup
mkdir ~/.vim/tmp
mkdir ~/.vim/plugins

./dotfiles.sh -y _vimrc*

mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c "PlugInstall" -c "qa!"
