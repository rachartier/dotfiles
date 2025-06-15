#!/usr/bin/env zsh

FZF_PREVIEW_COMMAND="$HOME/.fzf/bin/fzf-preview.sh $realpath"

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' switch-group ',' '.'  # Easily switch groups with , and .
zstyle ':fzf-tab:*' fzf-flags '--height=50%' '--layout=reverse' '--border=rounded' '--preview-window=right:60%:wrap'
zstyle ':fzf-tab:*' prefix ''  # No prefix for cleaner display
zstyle ":fzf-tab:complete:*:*" fzf-preview $FZF_PREVIEW_COMMAND
zstyle ":fzf-tab:complete:*:*" fzf-min-height 32

# Command/parameter preview configuration
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# Process preview configuration
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# Git-related preview configurations with proper color handling
zstyle ':fzf-tab:complete:git:*' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'

zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word ;;
	esac'

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
    "modified file") git diff --color=always $word ;;
    "recent commit object name") git show --color=always $word ;;
	*) git log --color=always $word ;;
	esac'

# File and directory preview configurations
zstyle ':fzf-tab:complete:ls:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $word'

zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level 1 --group-directories-first --color=always --icons $realpath'

# General completion configurations - enhanced for better visual appeal and faster performance
zstyle ':completion:*:git-checkout:*'             sort false
zstyle ':completion:*'                            completer _extensions _expand _complete _ignored _approximate
zstyle ':completion:*'                            menu select # Use a menu selector for nicer selection
zstyle ':completion:*'                            use-cache on # Enable caching for faster completion
zstyle ':completion:*'                            cache-path "$HOME/.zcompcache" # Cache path
zstyle ':completion:*'                            accept-exact '*(N)'
zstyle ':completion:*'                            special-dirs true # Include . and .. in completion
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:*:*:*:processes'            command 'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':completion:*:correct:*'                  insert-unambiguous true # Start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'                  original true
zstyle ':completion:*:default'                    list-colors ${(s.:.)LS_COLORS} # Activate color-completion
zstyle ':completion:*'                            list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:expand:*'                   tag-order all-expansions # Insert all expansions for expand completer
zstyle ':completion:*:man:*'                      menu yes select
zstyle ':completion:*:manuals'                    separate-sections true
zstyle ':completion:*:manuals.*'                  insert-sections true
zstyle ':completion:*:messages'                   format ' %F{purple} %d %f'b
zstyle ':completion:*:urls'                       local 'www' '/var/www/' 'public_html'
zstyle ':completion:*:warnings'                   format '%F{red}No matches for:%f %d' # Set format for warnings
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*' # Ignore completion functions for commands you don't have
zstyle ':completion:complete:*:options'           sort false
zstyle ':completion:*'                            matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # Smart case-insensitive completion
zstyle ':completion:*'                            group-name '' # Group results by categories
zstyle ':completion:*'                            verbose yes # Verbose completion info
zstyle ':fzf-tab:*' switch-group '<' '>'

