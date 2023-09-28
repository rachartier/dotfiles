source $HOME/.profile
setopt promptsubst

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export DISABLE_AUTO_TITLE='true'
alias config='/usr/bin/git --git-dir=/home/rachartier/.cfg/ --work-tree=/home/rachartier'
alias f="fzf"
alias l="eza --tree --level 1 --group-directories-first --color always --icons"
alias ls='ls --color=auto'

alias tl='tmuxp load'
for s in $(tmuxp ls); do alias "$s"="tmuxp load -y $s"; done

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit snippet OMZP::tmux
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

zstyle ":completion:*:git-checkout:*"               sort false
zstyle ':completion:*'                              completer _extensions _expand _complete _ignored _approximate
zstyle ':completion:*'                              list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*'                              matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*'                              menu select=2
zstyle ':completion:*'                              select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes'              command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':completion:*:correct:*'                    insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'                    original true                       #
zstyle ':completion:*:corrections'                  format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:default'                      list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'                 format $'%{\e[0;31m%}Completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:expand:*'                     tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:man:*'                        menu yes select
zstyle ':completion:*:manuals'                      separate-sections true
zstyle ':completion:*:manuals.*'                    insert-sections   true
zstyle ':completion:*:messages'                     format ' %F{purple} -- %d --%f'
zstyle ':completion:*:urls'                         local 'www' '/var/www/' 'public_html'
zstyle ':completion:*:warnings'                     format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion::(^approximate*):*:functions'   ignored-patterns '_*'    # Ignore completion functions for commands you don't have:
zstyle ':completion:complete:*:options'             sort false
zstyle ':fzf-tab:complete:_zlua:*'                  query-string input
zstyle ':fzf-tab:complete:kill:argument-rest'       extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags  "--height 100%"
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

 zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
  ¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview

zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

zinit ice wait="0b" lucid
zinit light b4b4r07/enhancd

zinit ice wait="0b" lucid atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down"
zinit light zsh-users/zsh-history-substring-search

zinit ice from="gh-r" as="program" bpick="*linux64.tar.gz" ver="nightly" pick="nvim-linux64/bin/nvim"
zinit light neovim/neovim

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

zinit wait"1" lucid from"gh-r" as"null" for \
     sbin"fzf"              junegunn/fzf \
     sbin"**/fd"            @sharkdp/fd \
     sbin"**/bat"           @sharkdp/bat \
     sbin"eza"              eza-community/eza \
     sbin"**/rg"            BurntSushi/ripgrep \
     sbin"lazygit"          jesseduffield/lazygit \
     sbin"glow"             charmbracelet/glow

zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=$HISTSIZE

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
setopt correct_all
unsetopt BEEP

# bindkey '^[[A' up-line-or-history
# bindkey '^[[B' down-line-or-history
#
# bindkey "^[^[OA" up-line-or-beginning-search
# bindkey "^[^[OB" down-line-or-beginning-search
# bindkey "^[^[OC" forward-char
# bindkey "^[^[OD" backward-char
