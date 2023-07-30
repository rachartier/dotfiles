#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

vim_mode_kirby="#($CURRENT_DIR/scripts/vim_mode_kirby.sh)"
vim_mode_kirby_interpolation="\#{vim_mode_kirby}"

do_interpolation() {
	local input=$1
	local result=""

	result=${input/$vim_mode_kirby_interpolation/$vim_mode_kirby}

	echo $result
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}

main
