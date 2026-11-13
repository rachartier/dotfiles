#!/usr/bin/env bash
# Records which agent session runs in the current tmux pane. Called by the
# Claude Code and Copilot CLI session-start hooks, and by restore.sh.
# Usage: track.sh <claude|copilot>, with {session_id|sessionId, cwd} JSON on stdin.
set -euo pipefail

tool=$1
input=$(cat)
[[ -n ${TMUX_PANE:-} ]] || exit 0
session_id=$(jq -er '.session_id // .sessionId' <<<"$input")
cwd=$(jq -er '.cwd' <<<"$input")
server=$(tmux display -p '#{pid}')

live=${XDG_STATE_HOME:-$HOME/.local/state}/tmux-agents/live
mkdir -p "$live"
jq -n --arg tool "$tool" --arg session_id "$session_id" --arg cwd "$cwd" \
	--arg server "$server" \
	'{tool: $tool, session_id: $session_id, cwd: $cwd, server: $server}' \
	>"$live/$TMUX_PANE.json"
