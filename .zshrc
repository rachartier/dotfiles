skip_global_compinit=1

source "$HOME/.profile"
source "$HOME/.dotfile_profile"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

[ ! -d $HOME/.antidote ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
source $HOME/.antidote/antidote.zsh

#Plugins if minimal is set
if [ -n "$DOTFILES_MINIMAL" ]; then
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins_minimal.txt
else
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
fi

function zsh_core_setup()  {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    source $HOME/.aliases
    source $HOME/.zsh/style.zsh
    # source $HOME/.zsh/transient_prompt.zsh

    eval "$(zoxide init zsh --cmd cd)"

    if command -v pyenv &> /dev/null; then
        eval "$(pyenv init -)"
    fi

    if command -v direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
    fi
}

zsh-defer zsh_core_setup


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

function ghcs() {
    if [ -z "$DOT_GITHUB_COPILOT_LOADED" ]; then
        eval "$(gh copilot alias -- zsh)"
        DOT_GITHUB_COPILOT_LOADED=1
    fi

    ghcs $@
}

function tmuxp() {
    if [ -z "$DOT_TMUXP_LOADED" ]; then
        for s in $($HOME/.local/bin/tmuxp ls); do alias "$s"="tmuxp load -y $s"; done
        DOT_TMUXP_LOADED=1
    fi

    "$HOME/.local/bin/tmuxp" $@
}

