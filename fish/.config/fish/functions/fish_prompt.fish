function fish_prompt
    set -g last_status $status

    printf "%s" (set_color blue)(whoami)(set_color normal)
    printf " @ "
    printf "%s " (set_color purple)(prompt_hostname)(set_color normal)
    echo (set_color blue)(prompt_pwd)(set_color normal)
    if test $last_status -ne 0
        printf "%s" (set_color $fish_color_error)
    end
    echo '$ '(set_color normal)
end

function vi_mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold red
                echo '[N]'
            case insert
                set_color --bold green
                echo '[I]'
            case replace_one
                set_color --bold cyan
                echo '[R]'
            case visual
                set_color --bold magenta
                echo '[V]'
        end
        set_color normal
        echo -n ' '
    end
end

function git_status
    if not command -s git >/dev/null
        return 1
    end
    set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
    if test -z $branch
        return
    end

    set -l git_status (git status --porcelain ^/dev/null | \
                       cut -c1-2 | \
                       sort | uniq -c | sed 's/^\s*//')
    set -l gs
    for line in $git_status
        set -l count (echo $line | cut -d' ' -f1)
        set -l symbol (echo $line | cut -d' ' -f2-)

        set gs "$gs $count"
        switch $symbol
            case '\?\?'
                set gs "$gs"(set_color cyan)'?'
            case 'U*' '*U' 'DD' 'AA'
                set gs "$gs"(set_color red)'!'
            case '*'
                if echo $symbol | grep -q '^[AMRCD]'
                    set gs $gs(set_color green)
                else
                    set gs $gs(set_color yellow)
                end
                set gs "$gs"(echo $symbol | sed 's/\s*//g')
        end
        set gs "$gs"(set_color normal)
    end
    printf "%s %s " $gs $branch
end

function last_error
    if test $last_status -ne 0
        printf "%s%s%s " (set_color $fish_color_error) $last_status (set_color normal)
    end
end

function fish_right_prompt
    last_error
    git_status
    vi_mode
end

