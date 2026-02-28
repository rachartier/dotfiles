#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fzf() {
	print_step "Installing fzf"

	if [ -d "$HOME/.fzf/" ]; then
		cd ~/.fzf || return 0
		git pull --quiet
		if yes | ./install --no-zsh >/dev/null 2>&1; then
			log "success" "fzf updated"
		else
			log "error" "fzf update failed"
		fi
		return 0
	fi

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null 2>&1
	if yes | ~/.fzf/install --no-zsh >/dev/null 2>&1; then
		log "success" "fzf installed in ~/.fzf/"
	else
		log "error" "fzf installation failed"
		return 1
	fi
}

install_fzf "$@"
