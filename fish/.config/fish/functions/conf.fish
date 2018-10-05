function conf --description 'edit common config files'
    if test -z $argv
        cat (status --current-filename)
        return 1
    end
    switch $argv
        case 'conf'
            eval $EDITOR (status --current-filename)
        case 'vim'
            eval $EDITOR ~/.vimrc
        case 'plug*'
            eval $EDITOR ~/.vimrc.plugins
        case 'X*'
            eval $EDITOR ~/.Xresources
        case 'tmux'
            eval $EDITOR ~/.tmux.conf
        case 'sxh*'
            eval $EDITOR ~/.config/sxhkd/sxhkdrc
        case 'bspwm'
            eval $EDITOR ~/.config/bspwm/bspwmrc
        case 'poly*'
            eval $EDITOR ~/.config/polybar/config
        case 'super*'
            eval $EDITOR ~/.config/bspwm/supervisord.conf
        case 'compton'
            eval $EDITOR ~/.config/compton.conf
        case 'fish'
            eval $EDITOR ~/.config/fish/config.fish
        case '*bind*'
            eval $EDITOR ~/.config/fish/functions/fish_user_key_bindings.fish
        case 'git*'
            eval $EDITOR ~/.gitconfig
        case '*'
            cat (status --current-filename)
            return 1
    end
end
