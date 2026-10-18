#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_casquette() {
	print_step "Installing casquette skills"

	local repo="$HOME/dev/casquette"
	local link="$HOME/.agents/skills/casquette"

	if [ -d "$link" ] && [ ! -L "$link" ]; then
		log "error" "$link is a directory, move it away first"
		return 1
	fi

	if [ -d "$repo/.git" ]; then
		if ! git -C "$repo" pull --quiet >>"$DOT_MANAGER_LOG" 2>&1; then
			log "error" "casquette update failed"
			return 1
		fi
	else
		local url="https://github.com/rachartier/casquette.git"
		[ "$GIT_CLONE_METHOD" = "ssh" ] && url="git@github.com:rachartier/casquette.git"

		if ! git clone --quiet "$url" "$repo" >>"$DOT_MANAGER_LOG" 2>&1; then
			log "error" "casquette clone failed"
			return 1
		fi
	fi

	mkdir -p "$(dirname "$link")"
	ln -sfn "$repo/skills" "$link"
	log "success" "casquette skills linked in $link"
}

install_casquette "$@"
