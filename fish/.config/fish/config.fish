fish_vi_key_bindings

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

append_to_path ~/.bin/ ~/go/bin/ ~/.local/bin/

if status --is-login
    if test -n $DISPLAY; and test $XDG_VTNR -eq 1
        exec startx
    end
end

if test -e /usr/share/autojump/autojump.fish
    source /usr/share/autojump/autojump.fish
end

alias vim nvim
alias pg="ps -ef | grep -v 'grep' | grep -i"
alias ff="find . -type f -iname"
alias time="time -p"
set -x EDITOR nvim
