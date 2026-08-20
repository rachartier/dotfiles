#!/usr/bin/env bash
# fzf-pick a git project under ~/dev, open it as a herdr workspace.
set -uo pipefail

repo_list=$(fd -u -t d -H "^\.git$" "$HOME/dev" -j 8 -x dirname {} |
    xargs -P "$(nproc)" -I{} bash -c '
    repo="$1"
    name=$(basename "$repo")
    date=$(git -C "$repo" log --max-count=1 --format="%cd" --date=format:"%Y-%m-%d" 2>/dev/null)
    if [ -z "$date" ]; then
        echo "0|No commits|$repo|$name"
    else
        echo "1|$date|$repo|$name"
    fi
' -- {} |
    sort -t"|" -k1,1r -k2,2r |
    awk -F"|" '{print $3" :: \033[38;5;4m["$2"]\033[0m "$4}')

if [ -z "$repo_list" ]; then
    echo "No projects found" >&2
    exit 1
fi

selection=$(echo -e "$repo_list" | fzf --ansi --with-nth 3,4,5 \
    --prompt='herdr workspace> ' \
    --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {1}")

[ -z "$selection" ] && exit 2

project=$(echo "$selection" | awk -F" :: " '{print $1}')
name=$(basename "$project" | tr . _)

# Reuse an existing workspace with the same label instead of duplicating it.
existing=$(herdr workspace list | jq -r --arg n "$name" \
    '.result.workspaces[] | select(.label == $n) | .workspace_id' | head -1)

if [ -n "$existing" ]; then
    herdr workspace focus "$existing" >/dev/null
else
    herdr workspace create --cwd "$project" --label "$name" --focus >/dev/null
fi
