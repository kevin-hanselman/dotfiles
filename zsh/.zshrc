#
# Executes commands at the start of an interactive session.
#

# Source Prezto.
if [ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt HIST_IGNORE_SPACE

[ -f ~/.bash_env ] && source ~/.bash_env
[ -f /etc/profile.d/autojump.zsh ] && source /etc/profile.d/autojump.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR=nvim
alias vim=nvim

# lower timeout between keystrokes to 0.1
# useful in vi-mode when switching to and from normal mode
export KEYTIMEOUT=1

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-builder/output/shell/base16-solarflare.dark.sh"
[[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"
