skip_global_compinit=1

source "$HOME/.profile"
source "$HOME/.dotfile_profile"


export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

ANTIDOTE_DIR="$HOME/.antidote"
[ ! -d $ANTIDOTE_DIR ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_DIR
source $ANTIDOTE_DIR/antidote.zsh

# Set plugins file based on minimal mode
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins${DOTFILES_MINIMAL:+_minimal}
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

fpath=($ANTIDOTE_DIR/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source generated plugins
source ${zsh_plugins}.zsh

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
setopt autocd                 # change directory just by typing its name
setopt automenu               # show completion menu on tab press
setopt auto_menu              # show completion menu on successive tab press
setopt auto_param_slash       # add a trailing slash for completed directories
setopt auto_pushd             # make cd push old directory onto directory stack
setopt complete_in_word       # allow completion from within a word/phrase
setopt extended_glob          # use extended globbing syntax
setopt hash_list_all          # hash everything before completion
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt list_ambiguous         # complete as much of a completion until it gets ambiguous
setopt listpacked             # make completion lists more densely packed
setopt menu_complete          # autoselect the first completion entry
setopt nocorrect              # disable spelling correction for commands
setopt nolisttypes            # disable showing completion types
setopt interactivecomments    # allow comments in interactive shells
setopt long_list_jobs         # display PID when suspending processes
setopt path_dirs              # perform path search even on command names with slashes
setopt pushd_ignore_dups      # don't push multiple copies of the same directory onto the stack
setopt pushd_minus            # exchanges the meanings of '+' and '-' when used with a number to specify a directory
setopt pushd_silent           # do not print the directory stack after pushd or popd
setopt COMPLETE_ALIASES       # complete aliases
unsetopt correct_all          # disable spelling correction for arguments
unsetopt BEEP                 # disable beep on error
unsetopt flow_control         # disable start/stop characters in shell editor

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

    command gh copilot suggest "$@"
}

function tmuxp() {
    if [ -z "$DOT_TMUXP_LOADED" ]; then
        for s in $($HOME/.local/bin/tmuxp ls 2>/dev/null); do
            alias "$s"="$HOME/.local/bin/tmuxp load -y $s"
        done
        DOT_TMUXP_LOADED=1
    fi

    command "$HOME/.local/bin/tmuxp" "$@"
}
