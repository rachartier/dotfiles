source $HOME/.profile
setopt promptsubst

export ZSH="$HOME/.oh-my-zsh"

ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export DISABLE_AUTO_TITLE='true'

[ ! -d $HOME/.antidote ] && git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
source $HOME/.antidote/antidote.zsh

#Plugins if minimal is set
if [ -n "$DOTFILES_MINIMAL" ]; then
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins_minimal.txt
else
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
fi

# Plugins if minimal is set
# if [ -n "$DOTFILES_MINIMAL" ]; then
#     plugins=(
#         enhancd
#         command-not-found
#         zsh-autosuggestions
#         zsh-syntax-highlighting
#         zsh-history-substring-search
# 	)
# else
#     plugins=(
#         enhancd
#         tmux
#         zsh-poetry
#         command-not-found
#         zsh-autosuggestions
#         zsh-syntax-highlighting
#         zsh-history-substring-search
# 	)
# fi
#
# source $ZSH/oh-my-zsh.sh
#
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_AUTOCONNECT=true
# ZSH_TMUX_CONFIG=$HOME/.config/tmux/tmux.conf

zstyle ':completion:*:git-checkout:*'               sort false
zstyle ':completion:*'                              completer _extensions _expand _complete _ignored _approximate
zstyle ':completion:*'                              list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*'                              menu select=2
zstyle ':completion:*'                              select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes'              command 'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':completion:*:correct:*'                    insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'                    original true                       #
zstyle ':completion:*:corrections'                  format $'%F{red}%d (errors: %e)%f' #
zstyle ':completion:*:default'                      list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions'                 format $'%F{blue}Completing %B%d%b%%f'  # format on completion
zstyle ':completion:*:expand:*'                     tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:man:*'                        menu yes select
zstyle ':completion:*:manuals'                      separate-sections true
zstyle ':completion:*:manuals.*'                    insert-sections   true
zstyle ':completion:*:messages'                     format ' %F{purple} %d %f'
zstyle ':completion:*:urls'                         local 'www' '/var/www/' 'public_html'
zstyle ':completion:*:warnings'                     format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion::(^approximate*):*:functions'   ignored-patterns '_*'    # Ignore completion functions for commands you don't have:
zstyle ':completion:complete:*:options'             sort false
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

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
unsetopt correct_all
unsetopt BEEP


## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

source $HOME/.aliases

# fpath+=($HOME/.zsh/pure)
# autoload -U promptinit; promptinit
# prompt pure
#

if  command -v starship > /dev/null ; then
    eval "$(starship init zsh)"
fi

# if  command -v gh > /dev/null ; then
    # eval "$(gh completion -s zsh)"
    # eval "$(gh copilot alias -- zsh)"
# fi

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
