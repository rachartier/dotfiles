#!/bin/bash

themes=$(ls "$HOME/.config/tmux/conf/themes/")
theme=$(echo "$themes" | "$HOME/.fzf/bin/fzf" --preview '')

windows_user=$(powershell.exe -command "echo \$env:USERNAME" | tr -d '\r\n')

echo -n "$theme" >"/mnt/c/Users/$windows_user/AppData/Local/Temp/windows-tmux-theme.cache"
echo -n "$theme" >"/tmp/tmux-theme.cache"

tmux setenv TMUX_THEME "$theme"
tmux source-file "$HOME/.config/tmux/tmux.conf"
