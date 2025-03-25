#!/bin/bash

get_last_modified() {
    local repo="$1"
    if [ -d "$repo/.git" ]; then
        # Get the latest commit date in YYYY-MM-DD format
        git -C "$repo" log -1 --format="%cd" --date=short 2>/dev/null || echo "No commits"
    else
        echo "Not a git repo"
    fi
}

repos_raw=$(fd -u -t d -H "^\.git$" "$HOME/dev" -x dirname {})
repos=""
while IFS= read -r repo; do
    last_modified=$(get_last_modified "$repo")
    name=$(basename "$repo")
    repos="${repos}${repo} :: [${last_modified}] ${name}"$'\n'
done <<<"$repos_raw"

repos=$(echo "$repos" | sort -k 3 -r)

if [ -z "$repos" ]; then
    echo "No projects found"
    exit 1
fi

selection=$(echo -e "$repos" | fzf --ansi --with-nth 3,4,5 --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {1}")

if [ -z "$selection" ]; then
    exit 2
fi

project=$(echo "$selection" | awk -F" :: " '{print $1}')

name=$(echo "$selection" | awk -F" :: " '{print $2}' | cut -d' ' -f2-)
name=$(echo "$name" | tr . _)

if [ -z "$project" ]; then
    exit 3
fi

tmux new -s "$name" -d -c "$project" -n "$name"
tmux switch-client -t "$name"
