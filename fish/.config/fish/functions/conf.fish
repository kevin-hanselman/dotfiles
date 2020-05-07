function conf --description 'edit common config files'
    if test -z $argv
        cat (status --current-filename)
        return 1
    end
    switch $argv
        case 'conf'
            exec $EDITOR (status --current-filename)
        case 'vim'
            exec $EDITOR ~/.vimrc
        case 'plug*'
            exec $EDITOR ~/.vimrc.plugins
        case 'X*'
            exec $EDITOR ~/.Xresources
        case 'xini*'
            exec $EDITOR ~/.xinitrc
        case 'xpro*'
            exec $EDITOR ~/.xprofile
        case 'tmux'
            exec $EDITOR ~/.tmux.conf
        case 'sxh*'
            exec $EDITOR ~/.config/sxhkd/sxhkdrc
        case 'bspwm'
            exec $EDITOR ~/.config/bspwm/bspwmrc
        case 'poly*'
            exec $EDITOR ~/.config/polybar/config
        case 'super*'
            exec $EDITOR ~/.config/bspwm/supervisord.conf
        case 'compton'
            exec $EDITOR ~/.config/picom.conf
        case 'picom'
            exec $EDITOR ~/.config/picom.conf
        case 'fish'
            exec $EDITOR ~/.config/fish/config.fish
        case '*bind*'
            exec $EDITOR ~/.config/fish/functions/fish_user_key_bindings.fish
        case 'git*'
            exec $EDITOR ~/.gitconfig
        case 'ala*'
            exec $EDITOR ~/.config/alacritty/alacritty.yml
        case 'kit*'
            exec $EDITOR ~/.config/kitty/kitty.conf
        case '*'
            cat (status --current-filename)
            return 1
    end
end
