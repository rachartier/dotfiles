# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/pure.toml)"
# eval "$(starship init zsh)"
source "$HOME/.profile"
source "$HOME/.dotfile_profile"

[ ! -d $HOME/.antidote ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
source $HOME/.antidote/antidote.zsh

#Plugins if minimal is set
if [ -n "$DOTFILES_MINIMAL" ]; then
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins_minimal.txt
else
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
fi

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[sudo]=none

setopt always_to_end          # cursor moved to the end in full completion
setopt autocd
setopt automenu
setopt complete_in_word       # allow completion from within a word/phrase
setopt hash_list_all          # hash everything before completion
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt list_ambiguous         # complete as much of a completion until it gets ambiguous.
setopt listpacked
setopt nocorrect              # spelling correction for commands
setopt nolisttypes
setopt interactivecomments    # allow comments in interactive shells
setopt long_list_jobs
setopt COMPLETE_ALIASES
unsetopt correct_all
unsetopt BEEP

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt appendhistory
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_save_no_dups      # do not save duplicated commands history list
setopt hist_find_no_dups      # do not display duplicated commands history list
setopt hist_reduce_blanks     # remove superfluous blanks from history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down
# bindkey '^[' send-break

if ! [ -f "/tmp/tmux-theme.cache" ]; then
    echo "catppuccin_macchiato.conf" > /tmp/tmux-theme.cache
fi

source $HOME/.aliases
source $HOME/.zsh/transient_prompt.zsh
source $HOME/.zsh/style.zsh

eval "$(starship init zsh)"


function ghcs() {
    if [ -z "$DOT_GITHUB_COPILOT_LOADED" ]; then
        eval "$(gh copilot alias -- zsh)"
        export DOT_GITHUB_COPILOT_LOADED=1
    fi

    ghcs $@
}

function pyenv() {
    if [ -z "$DOT_PYENV_LOADED" ]; then
        eval "$(pyenv init -)"
        export DOT_PYENV_LOADED=1
    fi

    pyenv $@
}

function cd() {
    if [ -z "$DOT_ZOXIDE_LOADED" ]; then
        eval "$(zoxide init zsh --cmd cd)"
        export DOT_ZOXIDE_LOADED=1
    fi

    cd $@
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
