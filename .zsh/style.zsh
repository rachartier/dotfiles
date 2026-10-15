#!/usr/bin/env zsh

FZF_PREVIEW_COMMAND="$HOME/.fzf/bin/fzf-preview.sh \$realpath"

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags '--height=50%' '--border=rounded' '--preview-window=right:60%:wrap'
zstyle ':fzf-tab:*' prefix ''
zstyle ":fzf-tab:complete:*:*" fzf-preview $FZF_PREVIEW_COMMAND
zstyle ":fzf-tab:complete:*:*" fzf-min-height 32

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

zstyle ':fzf-tab:complete:git:*' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:ls:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $word'

zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $realpath'

zstyle ':completion:*:git-checkout:*'             sort false
zstyle ':completion:*'                            completer _extensions _expand _complete _ignored _approximate
zstyle ':completion:*'                            menu no # fzf-tab needs this to capture the unambiguous prefix
zstyle ':completion:*'                            use-cache on
zstyle ':completion:*'                            cache-path "$HOME/.zcompcache"
zstyle ':completion:*'                            accept-exact '*(N)'
zstyle ':completion:*'                            special-dirs true # Include . and .. in completion
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:*:*:*:processes'            command 'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':completion:*'                            list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:expand:*'                   tag-order all-expansions
zstyle ':completion:*:manuals'                    separate-sections true
zstyle ':completion:*:manuals.*'                  insert-sections true
zstyle ':completion:*:messages'                   format ' %F{purple} %d %f'
zstyle ':completion:*:warnings'                   format '%F{red}No matches for:%f %d'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*' # Hide completer functions from function-name completion
zstyle ':completion:complete:*:options'           sort false
zstyle ':completion:*'                            matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # Smart case-insensitive completion
zstyle ':completion:*'                            group-name ''
zstyle ':completion:*'                            verbose yes
