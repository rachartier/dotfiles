#!/bin/env bash

if [ -n "$__HELPER_ALREADY_LOADED" ]; then
	return 0
fi

DOT_MANAGER_LOG="${DOT_MANAGER_CACHE_DIR:-$HOME/.cache/dot-manager}/last-run.log"
mkdir -p "$(dirname "$DOT_MANAGER_LOG")"

print_step() {
	local message="$1"
	echo
	echo -e "${COLORS[blue]}${ICON_GEAR}${DOT_STEP_PREFIX:+$DOT_STEP_PREFIX }${COLORS[bold]}$message${COLORS[reset]}"
}

declare -A COLORS=(
	["reset"]="\033[0m"
	["bold"]="\033[1m"
	["dim"]="\033[2m"

	["red"]="\033[31m"
	["green"]="\033[32m"
	["yellow"]="\033[33m"
	["blue"]="\033[34m"
	["magenta"]="\033[35m"
)

ICON_SUCCESS="✓"
ICON_ERROR="✗"
ICON_WARNING="⚠"
ICON_DOWNLOAD="↓"
ICON_GEAR="⚙ "

if [ ! -t 1 ]; then
	for k in "${!COLORS[@]}"; do COLORS[$k]=""; done
fi

log() {
	local level="$1"
	local message="$2"
	local icon=""
	local color=""
	local timestamp
	timestamp=$(date "+%H:%M:%S")

	case "$level" in
	"success")
		icon="${ICON_SUCCESS}"
		color="${COLORS[green]}"
		;;
	"warning")
		icon="${ICON_WARNING}"
		color="${COLORS[yellow]}"
		;;
	"error")
		icon="${ICON_ERROR}"
		color="${COLORS[red]}"
		;;
	"info")
		icon="•"
		color="${COLORS[blue]}"
		;;
	"download")
		icon="${ICON_DOWNLOAD}"
		color="${COLORS[magenta]}"
		;;
	*)
		icon=" "
		color="${COLORS[reset]}"
		;;
	esac

	echo -e "$color$icon${COLORS[reset]} ${COLORS[dim]}[$timestamp]${COLORS[reset]} $message"
}

__get_latest_release() {
	# ponytail: redirect follow instead of api.github.com, avoids the 60 req/hr unauthenticated limit
	basename "$(curl -sI -o /dev/null -w '%{redirect_url}' "https://github.com/$1/releases/latest")"
}

__is_pkg_installed() {
	dpkg-query -W --showformat='${Status}\n' "$1" 2>/dev/null | grep -q "install ok installed"
}

__install_package_release() {
	local url=$1
	local name=$2
	local filename

	filename=$(basename "$url")

	log "download" "Downloading $name..."
	cd /tmp || exit 1

	[ -d "/tmp/$name" ] && rm -rf "/tmp/$name"
	[ -f "/tmp/$filename" ] && rm "/tmp/$filename"

	if ! wget -nv "$url" >>"$DOT_MANAGER_LOG" 2>&1; then
		log "error" "Failed to download $filename"
		return 1
	fi

	if [[ "$filename" == *.tar.gz ]]; then
		tar -xf "$filename" || {
			log "error" "Failed to extract $filename"
			return 1
		}
		filename=$(basename "$filename" ".tar.gz")
		[ -d "/tmp/$filename" ] && cd "/tmp/$filename"
	elif [[ "$filename" == *.zip ]]; then
		unzip -oq "$filename" || {
			log "error" "Failed to extract $filename"
			return 1
		}
		filename=$(basename "$filename" ".zip")
		[ -d "/tmp/$filename" ] && cd "/tmp/$filename"
	elif [[ "$filename" == *.gz ]]; then
		gunzip -f "$filename" || {
			log "error" "Failed to extract $filename"
			return 1
		}
		filename=$(basename "$filename" ".gz")
		mv "$filename" "$name"
	else
		mv "$filename" "$name"
	fi

	chmod +x "$name"
	if ! mv "$name" "$HOME/.local/bin/$name"; then
		log "error" "Failed to install $name to ~/.local/bin/"
		return 1
	fi

	log "success" "$name installed in ~/.local/bin/"
}

__download_install_deb() {
	local url=$1
	local name=$2
	local filename

	filename=$(basename "$url")

	log "download" "Downloading $name..."
	cd /tmp || exit 1

	if ! wget -nv "$url" >>"$DOT_MANAGER_LOG" 2>&1; then
		log "error" "Failed to download $filename"
		return 1
	fi

	if ! sudo dpkg -i "$filename" >>"$DOT_MANAGER_LOG" 2>&1; then
		log "error" "Failed to install $name"
		return 1
	fi

	log "success" "$name installed (dpkg)"
}

__install_package() {
	local to_install=()
	local skipped=0

	for pkg in "$@"; do
		if __is_pkg_installed "$pkg"; then
			skipped=$((skipped + 1))
		else
			to_install+=("$pkg")
		fi
	done

	if [ ${#to_install[@]} -eq 0 ]; then
		log "info" "All $# packages already installed"
		return 0
	fi

	if ! sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 "${to_install[@]}" >>"$DOT_MANAGER_LOG" 2>&1; then
		log "error" "Failed to install: ${to_install[*]}"
		return 1
	fi

	if [ $skipped -gt 0 ]; then
		log "success" "Installed ${#to_install[@]} packages via apt ($skipped already present)"
	else
		log "success" "Installed ${#to_install[@]} packages via apt"
	fi
}

__git_dot() {
	/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}

__HELPER_ALREADY_LOADED=1
