function fish_user_key_bindings
    functions -q fzf_key_bindings; and fzf_key_bindings

    # Shift-Tab accepts an auto-suggestion (instead of default: complete-and-search)
    bind -M insert -k btab accept-autosuggestion
end
