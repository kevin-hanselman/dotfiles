function conf --description 'edit common config files'
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
        case 'compton'
            eval $EDITOR ~/.config/compton.conf
        case 'fish'
            eval $EDITOR ~/.config/fish/config.fish
        case '*'
            grep -B1 '$EDITOR' (status --current-filename)
    end
end
