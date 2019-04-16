#!/usr/bin/fish

if not status is-interactive
    exit
end

fish_vi_key_bindings

set fish_greeting ''  # No greeting

function fish_default_mode_prompt
    # Display mode using fish_right_prompt instead
end

function append_to_path
    for dir in $argv
        if test -d $dir
            set -x PATH $PATH $dir
        end
    end
end

function on_tty
    test -n $DISPLAY; and test $XDG_VTNR -eq $argv[1]
end

append_to_path ~/.bin/ ~/go/bin/ ~/.local/bin/

if status is-login; and on_tty 1
    exec startx
    exit
end

if test -e /usr/share/autojump/autojump.fish
    source /usr/share/autojump/autojump.fish
end

alias vim nvim
set -x EDITOR nvim
alias pg="ps -ef | grep -v 'grep' | grep -i"
alias ff="find . -type f -iname"
alias time="time -p"
alias kc="kubectl"
alias kccc="kubectl config current-context"
alias kctx="kubectx"

if command -sq tmux; and not set -q TMUX; and on_tty 1
    exec tmux
end
