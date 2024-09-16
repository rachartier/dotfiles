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

eza_command='$HOME/.config/scripts/preview_fzf.sh $realpath'

# zstyle ':fzf-tab:*' popup-min-size 38 0
# zstyle ':fzf-tab:*' fzf-flags --preview=''
zstyle ':fzf-tab:*' fzf-flags --height=40%
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ":fzf-tab:complete:*:*" fzf-preview $eza_command

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:git:*' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word'

zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'

zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'

zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
    "modified file") git diff $word ;;
    "recent commit object name") git show --color=always $word ;;
	*) git log --color=always $word ;;
	esac'


zsh-defer zstyle ':fzf-tab:complete:ls:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $word'

zsh-defer zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $word'


zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':completion:*:git-checkout:*'               sort false
zstyle ':completion:*'                              completer _extensions _expand _complete _ignored _approximate
zstyle ':completion:*'                              menu no
# zstyle ':completion:*'                              select-prompt '%3NScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes'              command 'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':completion:*:correct:*'                    insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'                    original true                       #
# zstyle ':completion:*:corrections'                  format $'%F{red}%d (errors: %e)%f' #
zstyle ':completion:*:default'                      list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*' 								list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:descriptions'                 format $'%F{blue}Completing %B%d%b%%f'  # format on completion
zstyle ':completion:*:expand:*'                     tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:man:*'                        menu yes select
zstyle ':completion:*:manuals'                      separate-sections true
zstyle ':completion:*:manuals.*'                    insert-sections   true
# zstyle ':completion:*:messages'                     format ' %F{purple} %d %f'
zstyle ':completion:*:urls'                         local 'www' '/var/www/' 'public_html'
zstyle ':completion:*:warnings'                     format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion::(^approximate*):*:functions'   ignored-patterns '_*'    # Ignore completion functions for commands you don't have:
zstyle ':completion:complete:*:options'             sort false
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

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

function _set_theme() {
    if ! [ -f "/tmp/tmux-theme.cache" ]; then
        echo "catppuccin_macchiato.conf" > /tmp/tmux-theme.cache
    fi
}

function _init_tools() {
    [ -f ~/.fzf.zsh ] && zsh-defer source ~/.fzf.zsh

    if command -v pyenv &> /dev/null; then
        zsh-defer eval "$(pyenv init -)"
    fi

    if command -v gh &> /dev/null; then
        eval "$(gh copilot alias -- zsh)"
    fi
}


zsh-defer source $HOME/.aliases

zsh-defer _set_theme
zsh-defer _init_tools

zsh-defer eval "$(zoxide init zsh --cmd cd)"

eval "$(starship init zsh)"

precmd_functions=(zvm_init "${(@)precmd_functions:#zvm_init}")
precmd_functions+=(set-long-prompt)
zvm_after_init_commands+=("zle -N zle-line-finish; zle-line-finish() { set-short-prompt }")

set-long-prompt() {
    PROMPT=$(starship prompt)
    RPROMPT=""
}

# export COLUMNS=$(($COLUMNS + ($COLUMNS*0.1)))
set-short-prompt() {
    # setting this doesn't seem to actually work
    PROMPT="$(STARSHIP_KEYMAP=${KEYMAP:-viins} starship module character)"
    # RPROMPT=$'%{\e[999C%}\e[8D%F{8}%*%f ' # remove if you don't want right prompt
    zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
}

zle-keymap-select() {
    set-short-prompt
}
zle -N zle-keymap-select

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt; return 130' INT

# try to fix vi mode indication (not working 100%)
zvm_after_init_commands+=('
  function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
       [[ $1 = "block" ]]; then
      echo -ne "\e[1 q"
      STARSHIP_KEYMAP=vicmd
    elif [[ ${KEYMAP} == main ]] ||
         [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = "" ]] ||
         [[ $1 = "beam" ]]; then
      echo -ne "\e[5 q"
      STARSHIP_KEYMAP=viins
    fi
    zle reset-prompt
  }
  zle -N zle-keymap-select

  # Ensure vi mode is set
  zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
  }
  zle -N zle-line-init
')

