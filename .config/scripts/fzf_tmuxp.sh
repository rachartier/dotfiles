#!/bin/bash

projects="$(tmuxp ls)"
selected_project=$(echo "$projects" | fzf --reverse --height 100% --preview '')

[[ -z "$selected_project" ]] && exit

tmuxp load "$selected_project" -y
