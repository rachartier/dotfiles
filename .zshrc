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

plugins=(
    enhancd
    ripgrep
    fd
    git
    tmux
    command-not-found
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh


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

# zstyle ':completion:*:descriptions' format '[%d]'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:complete:_zlua:*'                  query-string input
# zstyle ':fzf-tab:complete:kill:argument-rest'       extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # remember to use single quote here!!!
# zstyle ':fzf-tab:*' switch-group ',' '.'
#
#     zstyle ':fzf-tab:complete:-parameter-:*' fzf-preview 'echo ${(P)word}'
#     zstyle ':fzf-tab:complete:((-parameter-|unset):|(export|typeset|declare|local):argument-rest)' fzf-preview 'echo ${(P)word}'
#     #
#      zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
#         '(out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'


# zstyle ':prompt:pure:git:branch' color red
# zstyle ':prompt:pure:git:stash'  show yes

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt always_to_end          # cursor moved to the end in full completion
setopt hash_list_all          # hash everything before completion
setopt always_to_end          # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word       # allow completion from within a word/phrase
setopt nocorrect              # spelling correction for commands
setopt list_ambiguous         # complete as much of a completion until it gets ambiguous.
setopt nolisttypes
setopt listpacked
setopt automenu
setopt autocd
unsetopt correct_all
unsetopt BEEP

alias config='/usr/bin/git --git-dir=/home/rachartier/.cfg/ --work-tree=/home/rachartier'
alias f="fzf"
alias l="eza --tree --level 1 --group-directories-first --color always --icons"
alias ls='eza -G --group-directories-first --color always --icons'

local dot_script_path="$HOME/.config/scripts/dot.sh"
local dot_script_link="$HOME/.local/bin/dot"

if [ ! -L "$dot_script_link" ] || [ ! -e "$dot_script_link" ]; then
    ln -s "$dot_script_path" "$dot_script_link"
fi

if [ command tmuxp &> /dev/null ]; then
    alias tl='tmuxp load'
    for s in $(tmuxp ls); do alias "$s"="tmuxp load -y $s"; done
fi

# fpath+=($HOME/.zsh/pure)
# autoload -U promptinit; promptinit
# prompt pure
#
eval "$(starship init zsh)"

bindkey "^[[1;5A" history-substring-search-up
bindkey "^[[1;5B" history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
