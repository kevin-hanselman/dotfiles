function conf --description 'edit common config files'
    if test -z $argv
        cat (status --current-filename)
        return 1
    end
    switch $argv
        case 'conf'
            command $EDITOR (status --current-filename)
        case 'vim'
            command $EDITOR ~/.vimrc
        case 'plug*'
            command $EDITOR ~/.vimrc.plugins
        case 'X*'
            command $EDITOR ~/.Xresources
        case 'xini*'
            command $EDITOR ~/.xinitrc
        case 'xpro*'
            command $EDITOR ~/.xprofile
        case 'tmux'
            command $EDITOR ~/.tmux.conf
        case 'sxh*'
            command $EDITOR ~/.config/sxhkd/sxhkdrc
        case 'bspwm'
            command $EDITOR ~/.config/bspwm/bspwmrc
        case 'poly*'
            command $EDITOR ~/.config/polybar/config
        case 'super*'
            command $EDITOR ~/.config/bspwm/supervisord.conf
        case 'compton'
            command $EDITOR ~/.config/picom.conf
        case 'picom'
            command $EDITOR ~/.config/picom.conf
        case 'fish'
            command $EDITOR ~/.config/fish/config.fish
        case '*bind*'
            command $EDITOR ~/.config/fish/functions/fish_user_key_bindings.fish
        case 'git*'
            command $EDITOR ~/.gitconfig
        case 'ala*'
            command $EDITOR ~/.config/alacritty/alacritty.yml
        case 'kit*'
            command $EDITOR ~/.config/kitty/kitty.conf
        case '*'
            cat (status --current-filename)
            return 1
    end
end
