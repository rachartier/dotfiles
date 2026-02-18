skip_global_compinit=1

source "$HOME/.profile"
source "$HOME/.dotfile_profile"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

ANTIDOTE_DIR="$HOME/.antidote"
[ ! -d $ANTIDOTE_DIR ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_DIR
source $ANTIDOTE_DIR/antidote.zsh

zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins${DOTFILES_MINIMAL:+_minimal}
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

fpath=($ANTIDOTE_DIR/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

source ${zsh_plugins}.zsh

function zsh_core_setup() {
    source $HOME/.aliases
    source $HOME/.zsh/style.zsh
    # source $HOME/.zsh/transient_prompt.zsh

    if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh --cmd cd)"
    fi

    if command -v direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
    fi

    if command -v fzf &> /dev/null; then
        source <(fzf --zsh)
    fi
}

zsh-defer zsh_core_setup

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[sudo]=none

setopt autocd                 # change directory just by typing its name
setopt auto_pushd             # make cd push old directory onto directory stack
setopt pushd_ignore_dups      # don't push duplicate directories onto the stack
setopt pushd_minus            # exchange meanings of '+' and '-' for directory stack
setopt pushd_silent           # do not print the directory stack after pushd or popd

setopt always_to_end          # cursor moved to the end in full completion
setopt auto_menu              # show completion menu on successive tab press
setopt auto_param_slash       # add trailing slash for completed directories
setopt complete_in_word       # allow completion from within a word/phrase
setopt hash_list_all          # hash everything before completion
setopt list_ambiguous         # complete as much as possible, then show menu
setopt listpacked             # make completion lists more densely packed
setopt nolisttypes            # disable showing completion types
setopt glob_dots              # include dotfiles in tab completion without leading dot

setopt extended_glob          # use extended globbing syntax
setopt no_case_glob           # case-insensitive globbing
setopt path_dirs              # perform path search even on commands with slashes
setopt interactivecomments    # allow comments in interactive shells

setopt long_list_jobs         # display PID when suspending processes
setopt notify                 # report background job status immediately

unsetopt correct correct_all
setopt rm_star_wait           # 10-second pause before executing rm *

unsetopt BEEP                 # disable beep on error
unsetopt flow_control         # disable start/stop characters in shell editor

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 50000 ] && SAVEHIST=50000

setopt hist_ignore_all_dups   # ignore duplicated commands in history list
setopt hist_save_no_dups      # do not save duplicated commands
setopt hist_find_no_dups      # do not display duplicates when searching history
setopt hist_reduce_blanks     # remove superfluous blanks from history
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion before running it
setopt share_history          # share command history across sessions

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down

function tmuxp() {
    if [ -z "$DOT_TMUXP_LOADED" ]; then
        for s in $($HOME/.local/bin/tmuxp ls 2>/dev/null); do
            alias "$s"="$HOME/.local/bin/tmuxp load -y $s"
        done
        DOT_TMUXP_LOADED=1
    fi

    command "$HOME/.local/bin/tmuxp" "$@"
}

function uv() {
    if [ -z "$DOT_UV_LOADED" ]; then
        eval "$($HOME/.local/bin/uv generate-shell-completion zsh)"
        DOT_UV_LOADED=1
    fi

    command "$HOME/.local/bin/uv" "$@"
}

