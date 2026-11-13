#!/usr/bin/env bash
# tmux-resurrect post-save hook: snapshots the agents still running in their
# pane, keyed by session:window.pane as resurrect saved them.
set -euo pipefail

state=${XDG_STATE_HOME:-$HOME/.local/state}/tmux-agents
mkdir -p "$state/live"
server=$(tmux display -p '#{pid}')

declare -A command_of target_of
while IFS=$'\t' read -r pane_id command target; do
	command_of[$pane_id]=$command
	target_of[$pane_id]=$target
done < <(tmux list-panes -a -F $'#{pane_id}\t#{pane_current_command}\t#{session_name}:#{window_index}.#{pane_index}')

tmp=$(mktemp "$state/saved.XXXXXX")
trap 'rm -f "$tmp"' EXIT
for record in "$state/live"/*.json; do
	[[ -e $record ]] || continue
	pane_id=$(basename "$record" .json)
	IFS=$'\t' read -r tool record_server < <(jq -r '[.tool, .server] | @tsv' "$record")
	# Pane ids restart with each tmux server, so older records point at other panes.
	if [[ $record_server == "$server" && ${command_of[$pane_id]:-} == "$tool" ]]; then
		jq -c --arg target "${target_of[$pane_id]}" '. + {target: $target}' "$record" >>"$tmp"
	else
		rm "$record"
	fi
done
mv "$tmp" "$state/saved.jsonl"
