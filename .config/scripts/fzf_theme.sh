#!/bin/bash

all-panes() {
	all-panes-bg_ "$1" &
}

# The actual implementation of `all-panes` that runs in a background process.
# This prevents the function from being suspended when we press ^z in each pane.
all-panes-bg_() {
	# Assign the argument to something readable
	local COMMAND=$1

	# Remember which window/pane we were originally at
	local ORIG_WINDOW_INDEX=$(tmux display-message -p '#I')
	local ORIG_PANE_INDEX=$(tmux display-message -p '#P')

	# Loop through the windows
	for WINDOW in $(tmux list-windows -F '#I'); do
		# Select the window
		tmux select-window -t $WINDOW

		# Remember the window's current pane sync setting
		local ORIG_PANE_SYNC=$(tmux show-window-options | grep '^synchronize-panes' | awk '{ print $2 }')

		# Send keystrokes to all panes within the current window simultaneously
		tmux set-window-option synchronize-panes on

		# Send the escape key in case we are in a vim-like program.  This is
		# repeated because the send-key command is not waiting for vim to complete
		# its action...  And sending a `sleep 1` command seems to screw up the loop.
		for i in {1..25}; do tmux send-keys 'C-['; done

		# Temporarily suspend any GUI that's running
		tmux send-keys C-z

		# If no GUI was running, kill any input the user may have typed on the
		# command line to avoid A) concatenating our command with theirs, and
		# B) accidentally running a command the user didn't want to run
		# (e.g., rm -rf ~).
		tmux send-keys C-c

		# Run the command and switch back to the GUI if there was any
		tmux send-keys "$COMMAND; fg 2>/dev/null; echo -n" C-m

		# Restore the window's original pane sync setting
		if [[ -n "$ORIG_PANE_SYNC" ]]; then
			tmux set-window-option synchronize-panes "$ORIG_PANE_SYNC"
		else
			tmux set-window-option -u synchronize-panes
		fi
	done

	# Select the original window and pane
	tmux select-window -t "$ORIG_WINDOW_INDEX"
	tmux select-pane -t "$ORIG_PANE_INDEX"
}

. "$HOME/.dotfile_profile"

themes=$(ls "$HOME/.config/tmux/conf/themes/")
theme=$(echo "$themes" | "$HOME/.fzf/bin/fzf" --preview '')

windows_user=$(powershell.exe -command "echo \$env:USERNAME" | tr -d '\r\n')

echo -n "$theme" >"/mnt/c/Users/$windows_user/AppData/Local/Temp/windows-tmux-theme.cache"
echo -n "$theme" >"/tmp/tmux-theme.cache"

tmux setenv TMUX_THEME "$theme"
all-panes " export TMUX_THEME=$theme && source ~/.dotfile_profile"

tmux source-file "$HOME/.config/tmux/tmux.conf"
