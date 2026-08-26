#!/usr/bin/env bash
# fzf-pick a git project under ~/dev, open it as a tmux session or a herdr workspace.
# Backend: --tmux / --herdr, else tmux when inside tmux, else herdr when available.
set -uo pipefail

cache="${XDG_CACHE_HOME:-$HOME/.cache}/dev-projects.tsv"
backend=""
refresh=""

for arg in "$@"; do
    case "$arg" in
        --tmux) backend=tmux ;;
        --herdr) backend=herdr ;;
        --refresh) refresh=1 ;;
        *) echo "usage: ${0##*/} [--tmux|--herdr] [--refresh]" >&2; exit 64 ;;
    esac
done

if [ -z "$backend" ]; then
    if [ -n "${TMUX:-}" ] || ! command -v herdr >/dev/null 2>&1; then
        backend=tmux
    else
        backend=herdr
    fi
fi

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
        --prompt="$backend workspace> " \
        --preview "eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions {1}"
}

open_tmux() {
    local project=$1 name=$2
    if ! tmux has-session -t "=$name" 2>/dev/null; then
        tmux new-session -ds "$name" -c "$project" -n "$name"
    fi
    if [ -n "${TMUX:-}" ]; then
        tmux switch-client -t "$name"
    else
        tmux attach -t "$name"
    fi
}

open_herdr() {
    local project=$1 name=$2 existing
    # Reuse an existing workspace with the same label instead of duplicating it.
    existing=$(herdr workspace list | jq -r --arg n "$name" \
        '.result.workspaces[] | select(.label == $n) | .workspace_id' | head -1)

    if [ -n "$existing" ]; then
        herdr workspace focus "$existing" >/dev/null
    else
        herdr workspace create --cwd "$project" --label "$name" --focus >/dev/null
    fi
}

mkdir -p "$(dirname "$cache")"

if [ -n "$refresh" ] || [ ! -s "$cache" ]; then
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

"open_$backend" "$project" "$name"
