#!/usr/bin/env zsh

eza_command='$HOME/.config/scripts/preview_fzf.sh $realpath'

zstyle ':fzf-tab:*' use-fzf-default-opts yes
# zstyle ':fzf-tab:*' popup-min-size 38 0
# zstyle ':fzf-tab:*' fzf-flags --preview=''
# zstyle ':fzf-tab:*' fzf-flags --height=40%
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ":fzf-tab:complete:*:*" fzf-preview $eza_command

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
