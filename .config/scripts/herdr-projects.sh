#!/usr/bin/env bash
# fzf-pick a git project under ~/dev, open it as a herdr workspace.
set -uo pipefail

cache="${XDG_CACHE_HOME:-$HOME/.cache}/herdr-projects.tsv"

# Repo date is the newest mtime of .git and .git/logs/HEAD: it tracks fetch and
# checkout as well as commit, but costs two processes instead of one git log per repo.
build_list() {
    fd -u -t d -H --prune '^\.git$' "$HOME/dev" -0 |
        awk 'BEGIN { RS = ORS = "\0" } { sub(/\/$/, ""); print; print $0 "/logs/HEAD" }' |
        xargs -0 stat -c '%y|%n' 2>/dev/null |
        awk -F'|' '{
            path = $2
            sub(/\/logs\/HEAD$/, "", path)
            sub(/\/\.git$/, "", path)
            stamp = substr($1, 1, 19)
            if (stamp > newest[path]) newest[path] = stamp
        }
        END {
            for (repo in newest) {
                name = repo
                sub(/.*\//, "", name)
                print newest[repo] "|" substr(newest[repo], 1, 10) "|" repo "|" name
            }
        }' |
        sort -t'|' -k1,1r |
        awk -F'|' '{ print $3 " :: \033[38;5;4m[" $2 "]\033[0m " $4 }'
}

pick() {
    fzf --ansi --with-nth 3,4,5 \
        --prompt='herdr workspace> ' \
        --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {1}"
}

mkdir -p "$(dirname "$cache")"

if [ "${1:-}" = "--refresh" ] || [ ! -s "$cache" ]; then
    build_list >"$cache.$$"
    if [ ! -s "$cache.$$" ]; then
        rm -f "$cache.$$"
        echo "No projects found" >&2
        exit 1
    fi
    mv "$cache.$$" "$cache"
    selection=$(pick <"$cache")
else
    selection=$(pick <"$cache")
    (build_list >"$cache.$$" && mv "$cache.$$" "$cache" || rm -f "$cache.$$") >/dev/null 2>&1 &
    disown
fi

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
