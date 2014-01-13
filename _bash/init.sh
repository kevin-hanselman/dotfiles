#! /bin/bash
# init.sh: executed by ~/.bashrc
clear; ls

p=`shparproc` # start tmux if it's not started already, or if remote
[[ "$p" != 'tmux' ]] && [[ "$p" != 'ssh' ]] && cmd-exists 'tmux' && tmux -2

