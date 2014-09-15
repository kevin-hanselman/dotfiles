#!/bin/bash

mkdir -p ~/.vim/undo
mkdir ~/.vim/backup
mkdir ~/.vim/tmp
mkdir ~/.vim/bundle

./dotfiles.sh -y _vimrc*

cd ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git

vim -c "PluginInstall"
