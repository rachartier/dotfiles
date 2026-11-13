#!/usr/bin/env bash
# tmux-resurrect post-restore hook: resumes each saved agent session in its pane.
set -euo pipefail

saved=${XDG_STATE_HOME:-$HOME/.local/state}/tmux-agents/saved.jsonl
[[ -f $saved ]] || exit 0
shell=$(tmux show -gv default-shell)

while IFS=$'\t' read -r target tool session_id cwd; do
	current=$(tmux display -p -t "$target" '#{pane_current_command}' 2>/dev/null) || continue
	[[ $current == "$(basename "$shell")" ]] || continue
	case $tool in
	claude) cmd="claude --resume $session_id" ;;
	copilot) cmd="copilot --resume=$session_id" ;;
	esac
	# Respawning instead of typing avoids racing the shell's startup; the
	# interactive shell loads the user's PATH and stays once the agent exits.
	tmux respawn-pane -k -t "$target" -c "$cwd" "$shell -ic '$cmd; exec $shell'"
	# Copilot only fires its hook on the first prompt, so record the pane now.
	jq -n --arg session_id "$session_id" --arg cwd "$cwd" '{session_id: $session_id, cwd: $cwd}' |
		TMUX_PANE=$(tmux display -p -t "$target" '#{pane_id}') "$(dirname "$0")/track.sh" "$tool"
done < <(jq -r '[.target, .tool, .session_id, .cwd] | @tsv' "$saved")
