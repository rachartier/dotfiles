#!/bin/bash

fd -u -t d -H "^\.git$" "$HOME/dev" -j 8 -x dirname {} |
    xargs -P "$(nproc)" -I{} bash -c '
    repo="$1"
    name=$(basename "$repo")
    if [ -d "$repo/.git" ]; then
        # Use --max-count=1 instead of -1 and only get the date we need
        date=$(git -C "$repo" log --max-count=1 --format="%cd" --date=format:"%Y-%m-%d" 2>/dev/null)
        if [ -z "$date" ]; then
            # Use a special prefix for sorting that will appear last
            echo "0|No commits|$repo|$name"
        else
            echo "1|$date|$repo|$name"
        fi
    else
        # Use a special prefix for sorting that will appear last
        echo "0|Not a git repo|$repo|$name"
    fi
' -- {} |
    sort -t"|" -k1,1r -k2,2r |
    awk -F"|" '{print $3" :: \033[38;5;4m["$2"]\033[0m "$4}' |
    fzf --ansi --with-nth 3,4,5 --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {1}" |
    {
        # Extract project path from selection format "path :: [date] name"
        project=$(echo "$REPLY" | awk -F" :: " '{print $1}')
        name=$(echo "$REPLY" | awk '{print $NF}')

        if [ -n "$project" ]; then
            # Convert dots to underscores for tmux session name
            session_name=$(echo "$name" | tr . _)
            tmux new -s "$session_name" -d -c "$project" -n "$session_name"
            tmux switch-client -t "$session_name"
        fi
    }
