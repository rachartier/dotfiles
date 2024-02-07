#!/bin/bash

hosts=$(grep -iw 'host' <"$HOME/.ssh/config" | cut -d ' ' -f 2)
session=$(echo "$hosts" | "$HOME/.fzf/bin/fzf" --reverse --height 100% --preview '')

tmux new-window -n "$session" -n "SSH \"$session\"" -d ssh "$session"
