#!/bin/bash

projects="$(tmuxp ls)"
echo "$projects" | fzf --reverse --height 100% --preview '' --preview-window down:50% --bind 'enter:execute(tmuxp load {} -y)+abort'
