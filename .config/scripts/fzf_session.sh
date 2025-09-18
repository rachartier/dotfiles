#!/usr/bin/env bash
set -euo pipefail

in_tmux=${TMUX-}

mapfile -t sessions < <(tmux list-sessions -F '#S' 2>/dev/null || true)

session_exists() {
  tmux has-session -t "=${1}" 2>/dev/null
}

pick_session() {
  if [[ $# -gt 0 && -n ${1:-} ]]; then
    echo "$1"
    return 0
  fi

  out=$(printf '%s\n' "${sessions[@]}" | fzf \
    --prompt='tmux session> ' \
    --print-query \
    --height=40% \
    --min-height=10 \
    --reverse \
    --bind='tab:down,btab:up' \
    --history="$HOME/.cache/fzf_tmux_session_history" \
    --history-size=200 \
    --no-multi \
    --ansi || true)

  [[ -z $out ]] && return 1

  query=$(printf '%s' "$out" | sed -n '1p')
  selection=$(printf '%s' "$out" | sed -n '2p')

  # Prefer a newly typed non-existing name
  if [[ -n $query ]] && ! printf '%s\n' "${sessions[@]}" | grep -Fxq -- "$query"; then
    echo "$query"
    return 0
  fi

  if [[ -n $selection ]]; then
    echo "$selection"
    return 0
  fi

  # Fallback (user typed exact existing name and pressed enter)
  echo "$query"
}

session_name=$(pick_session "$@" || true)

if [[ -z ${session_name:-} ]]; then
  echo "Aborted." >&2
  exit 1
fi

if session_exists "$session_name"; then
  if [[ -n $in_tmux ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach -t "$session_name"
  fi
else
  if [[ -n $in_tmux ]]; then
    tmux new-session -ds "$session_name"
    tmux switch-client -t "$session_name"
  else
    tmux new-session -s "$session_name"
  fi
fi
