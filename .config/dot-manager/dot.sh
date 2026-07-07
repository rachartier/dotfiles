#!/bin/bash

###
### Programs to install by default
###
DOT_MANAGER_COMPLETE_PROGRAMS=(
	"fd_find"
	"tmux"
	"nvim"
	"eza"
	"glow"
	"fzf"
	"lazygit"
	"lazydocker"
	"starship"
	"zoxide"
	"bat"
	"git_tools"
	"copilot_cli"
	"direnv"
	"win32yank"
	"uv"
)

###
### Programs to install for a "lightwheight" configuration
###
DOT_MANAGER_MINIMAL_PROGRAMS=(
	"fd_find"
	"nvim"
	"eza"
	"fzf"
	"zoxide"
	"starship"
	"copilot_cli"
	"git_tools"
)

###
### Programs to install for a docker configuration
###
DOT_MANAGER_DOCKER_PROGRAMS=(
	"fd_find"
	"nvim"
	"eza"
	"fzf"
	"zoxide"
	"starship"
	"git_tools"
	"bat"
)

# ---------------------------------------------------------------------------
DOT_MANAGER_DIR="$HOME/.config/dot-manager"
DOT_MANAGER_CACHE_DIR="$HOME/.cache/dot-manager"
source "$DOT_MANAGER_DIR/helper.sh"

mkdir -p "$DOT_MANAGER_CACHE_DIR"
: >"$DOT_MANAGER_LOG"

__install_program() {
	local program_name="$1"
	local install_script="$DOT_MANAGER_DIR/install/programs/ubuntu/$program_name.sh"

	if [ -f "$install_script" ]; then
		shift
		if ! source "$install_script" "$@"; then
			log "error" "Failed to source '$program_name' script. (details: $DOT_MANAGER_LOG)"
			return 1
		fi
	else
		log "error" "'$program_name' unknown. Run 'dot list' to see available programs."
		return 1
	fi
}

__install_program_list() {
	local failed=()
	local total=$#
	local i=0

	sudo -v
	SECONDS=0

	for program in "$@"; do
		i=$((i + 1))
		DOT_STEP_PREFIX="[$i/$total]"
		__install_program "$program" || failed+=("$program")
	done
	unset DOT_STEP_PREFIX

	log "success" "$((total - ${#failed[@]}))/$total programs installed in $((SECONDS / 60))m$((SECONDS % 60))s"

	if [ ${#failed[@]} -gt 0 ]; then
		log "error" "Failed: ${failed[*]} (rerun with: dot reinstall <name>, details: $DOT_MANAGER_LOG)"
		return 1
	fi
}

install_packages() {
	print_step "Installing Base Packages"
	sudo -v

	local terminfo_url=""
	case "$TERM" in
	"wezterm") terminfo_url="https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo" ;;
	"ghostty" | "xterm-ghostty") terminfo_url="https://raw.githubusercontent.com/rachartier/dotfiles/refs/heads/main/.config/ghostty/terminfo/ghostty.terminfo" ;;
	esac

	if [ -n "$terminfo_url" ]; then
		print_step "Setting up $TERM terminfo"
		tempfile=$(mktemp) &&
			curl -sS -o "$tempfile" "$terminfo_url" &&
			tic -x -o "$HOME/.terminfo" "$tempfile" &&
			rm "$tempfile"
	fi

	print_step "Installing system packages"
	local base_packages=(
		pkg-config build-essential wget libfuse2
		python3-venv python3-pip npm unzip
		ripgrep xsel
	)

	if [ -z "$DOTFILES_MINIMAL" ]; then
		base_packages+=(tty-clock grc)
	fi

	__install_package "${base_packages[@]}"
}

install_complete() {
	print_step "Installing Complete Configuration"
	install_packages

	__install_program_list "${DOT_MANAGER_COMPLETE_PROGRAMS[@]}"

	git config --global include.path "~/.config/git/gitconfig"
	sudo ldconfig
}

install_minimal() {
	print_step "Installing Minimal Configuration"
	log "info" "Exporting DOTFILES_MINIMAL=1 to $HOME/.profile"
	echo "export DOTFILES_MINIMAL=1" >>"$HOME/.profile"
	export DOTFILES_MINIMAL=1

	__install_program_list "${DOT_MANAGER_MINIMAL_PROGRAMS[@]}"
	sudo ldconfig
}

install_docker() {
	print_step "Installing Docker Configuration"
	log "info" "Exporting DOTFILES_DOCKER=1 to $HOME/.profile"
	echo "export DOTFILES_DOCKER=1" >>"$HOME/.profile"
	export DOTFILES_DOCKER=1

	__install_program_list "${DOT_MANAGER_DOCKER_PROGRAMS[@]}"
	sudo ldconfig
}

do_reinstall_all() {
	if [ -n "$DOTFILES_MINIMAL" ]; then
		install_minimal
	elif [ -n "$DOTFILES_DOCKER" ]; then
		install_docker
	else
		install_complete
	fi
}

do_reinstall() {
	local tool_name="$1"

	if [ -z "$tool_name" ] && command -v fzf >/dev/null; then
		tool_name=$(basename -s .sh "$DOT_MANAGER_DIR"/install/programs/ubuntu/*.sh | fzf --prompt='reinstall> ')
		[ -z "$tool_name" ] && return 0
		__install_program "$tool_name"
		return
	fi

	if [ -z "$tool_name" ]; then
		log "error" "No tool name provided."
		return 1
	fi

	if [ "$tool_name" = "all" ]; then
		do_reinstall_all
		return 0
	fi

	shift
	__install_program "$tool_name" "$@"
}

update_all() {
	log "info" "Updating neovim plugins..."
	"/opt/nvim-linux-x86_64/bin/nvim" --headless "+lua vim.pack.update({}, {force = true})" "+qall"

	log "info" "Updating tmux plugins..."
	"$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all

	log "info" "Updating antidote plugins..."
	zsh -c ". \"$HOME/.antidote/antidote.zsh\" &&  antidote update"
}

show_programs_list() {
	echo "Available programs:"
	for script in "$DOT_MANAGER_DIR"/install/programs/ubuntu/*.sh; do
		echo "  - $(basename "$script" .sh)"
	done
}

show_help() {
	cat <<EOF
Usage: dot <command> [args]

Commands:
  list                     List installable programs
  init                     Install the complete configuration
  minimal                  Install the minimal configuration
  docker                   Install the docker configuration
  update                   Update nvim, tmux and antidote plugins
  reinstall <name|all>     Reinstall a program (or everything)
  terminal install <name>  Install a terminal (wezterm, kitty, ghostty)
  fonts update             Install Nerd Fonts
  tool <name>              Run a tool script (e.g. dotnet)
  help                     Show this help

Any other command is passed to git on the dotfiles repository.
EOF
}

do_tool() {
	local tool_name="$1"
	local tool_path="$DOT_MANAGER_DIR/install/tools/$tool_name.sh"

	if [ ! -f "$tool_path" ]; then
		log "error" "'$tool_name' unknown."
		return 1
	fi

	shift
	source "$tool_path"
}

do_command() {
	case "$1" in
	"help" | "-h" | "--help") show_help ;;
	"list") show_programs_list ;;
	"init") install_complete ;;
	"update") update_all ;;
	"minimal") install_minimal ;;
	"docker") install_docker ;;
	"terminal")
		shift
		source "$DOT_MANAGER_DIR/install/terminal.sh" "$@"
		;;
	"fonts")
		shift
		source "$DOT_MANAGER_DIR/install/fonts.sh" "$@"
		;;
	"reinstall")
		shift
		do_reinstall "$@"
		;;
	"tool")
		shift
		do_tool "$@"
		;;
	*) __git_dot "$@" ;;
	esac
}

if [ $# -eq 0 ]; then
	__git_dot "$@"
else
	do_command "$@"
fi
