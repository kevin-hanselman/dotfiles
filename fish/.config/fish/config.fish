#!/usr/bin/fish

set fish_greeting '' # No greeting

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

if test -d /opt/homebrew
    # Homebrew recommends putting its bin dirs at the front of the path so they
    # override system binaries.
    fish_add_path --prepend /opt/hombrew/bin /opt/homebrew/sbin
end
if test -d ~/.rd/bin
    fish_add_path --append ~/.rd/bin
end
fish_add_path --append ~/go/bin ~/.local/bin

if test -d ~/.kube/conf.d
    set -x KUBECONFIG (
        find ~/.kube/conf.d -type f -maxdepth 1 -name '*.y?ml' \
        | tr '\n' ':' \
        | sed 's/:$//'
    )
end

set -x EDITOR hx
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
