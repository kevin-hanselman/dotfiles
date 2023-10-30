#!/usr/bin/fish

set fish_greeting ''  # No greeting

if not status is-interactive
    exit
end

function on_tty
    not set -q DISPLAY; and set -q XDG_VTNR; and test $XDG_VTNR -eq $argv[1]
end

if command -q startx; and status is-login; and on_tty 1; and test -z (pgrep -x startx)
    exec startx
    exit
end

fish_vi_key_bindings

function fish_default_mode_prompt
    # Display mode using fish_right_prompt instead
end

function append_to_path
    for dir in $argv
        # Ensure dir is a directory and that it's not already added to PATH.
        # Because fish starts tmux which starts fish, this last condition
        # prevents duplicate PATH values.
        if test -d $dir; and not contains $dir $PATH
            set -x PATH $PATH $dir
        end
    end
end

append_to_path ~/.bin/ ~/go/bin/ ~/.local/bin/ /opt/homebrew/bin ~/.rd/bin

if test -d ~/.kube/conf.d
    set -x KUBECONFIG (
        find ~/.kube/conf.d -type f -maxdepth 1 -name '*.y?ml' \
        | tr '\n' ':' \
        | sed 's/:$//'
    )
end

set -x EDITOR nvim
alias vim=hx
alias pg="ps -ef | grep -v 'grep' | grep -i"
alias ff="find . -type f -iname"
alias kc="kubectl"
alias kcx="kubectx"
alias knx="kubens"
alias diff="git diff --no-index"
alias dc="docker-compose"

if command -q tmux; and not set -q TMUX
    exec tmux
end
