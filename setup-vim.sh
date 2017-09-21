#!/bin/bash

set -euo pipefail

./dotfiles.sh vim

curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

VIM=vim
if type -q nvim; then
    VIM=nvim
fi
$VIM -c 'PlugInstall' -c 'qa!'
