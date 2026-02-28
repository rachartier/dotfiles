#!/bin/env bash

__detect_distro() {
	if grep -qi 'ubuntu' /etc/os-release; then
		echo "ubuntu"
	else
		echo "unknown"
	fi
}

if [ -n "$__HELPER_ALREADY_LOADED" ]; then
	return 0
fi

print_step() {
	local message="$1"
	echo
	echo -e "${COLORS[blue]}${ICON_GEAR} ${COLORS[bold]}$message${COLORS[reset]}"
}

print_header() {
	local title="$1"
	local width=60
	local title_length=${#title}

	local padding_left=$(((width - title_length) / 2))
	local padding_right=$((width - title_length - padding_left))

	local horizontal_line=$(printf '─%.0s' $(seq 1 $width))
	local padding_spaces_left=$(printf ' %.0s' $(seq 1 $padding_left))
	local padding_spaces_right=$(printf ' %.0s' $(seq 1 $padding_right))

	local top_border="${COLORS[cyan]}╭${horizontal_line}╮${COLORS[reset]}"
	local middle_line="${COLORS[cyan]}│${COLORS[reset]}${padding_spaces_left}${COLORS[bold]}${title}${COLORS[reset]}${padding_spaces_right}${COLORS[cyan]}│${COLORS[reset]}"
	local bottom_border="${COLORS[cyan]}╰${horizontal_line}╯${COLORS[reset]}"

	echo
	echo -e "$top_border"
	echo -e "$middle_line"
	echo -e "$bottom_border"
	echo
}

declare -A COLORS=(
	["reset"]="\033[0m"
	["bold"]="\033[1m"
	["dim"]="\033[2m"
	["italic"]="\033[3m"
	["underline"]="\033[4m"

	["black"]="\033[30m"
	["red"]="\033[31m"
	["green"]="\033[32m"
	["yellow"]="\033[33m"
	["blue"]="\033[34m"
	["magenta"]="\033[35m"
	["cyan"]="\033[36m"
	["white"]="\033[37m"

	["bg_black"]="\033[40m"
	["bg_red"]="\033[41m"
	["bg_green"]="\033[42m"
	["bg_yellow"]="\033[43m"
	["bg_blue"]="\033[44m"
	["bg_magenta"]="\033[45m"
	["bg_cyan"]="\033[46m"
	["bg_white"]="\033[47m"
)

ICON_SUCCESS="✓"
ICON_ERROR="✗"
ICON_WARNING="⚠"
ICON_INFO=""
ICON_DOWNLOAD="↓"
ICON_GEAR="⚙ "

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
		icon="${ICON_INFO}"
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

__get_windows_user() {
	local windows_user
	windows_user=$(powershell.exe '$env:UserName' | tr -d '\r')
	echo "$windows_user"
}

__get_latest_release() {
	curl -s "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
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

	if ! wget -nv -q "$url" >/dev/null 2>&1; then
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

	if ! wget -nv -q "$url" >/dev/null 2>&1; then
		log "error" "Failed to download $filename"
		return 1
	fi

	if ! sudo dpkg -i "$filename" >/dev/null 2>&1; then
		log "error" "Failed to install $name"
		return 1
	fi

	log "success" "$name installed (dpkg)"
}

__install_zsh_plugin() {
	local url=$1
	local folder
	folder=$(echo "$url" | sed -r 's|.*/(.*)\.git$|\1|')

	local installation_folder="$HOME/.oh-my-zsh/custom/plugins/$folder"

	[ -d "$installation_folder" ] && rm -rf "$installation_folder"

	if ! git clone "$url" "$installation_folder" >/dev/null 2>&1; then
		log "error" "Failed to install $folder"
		return 1
	fi

	log "success" "$folder installed in ~/.oh-my-zsh/custom/plugins/"
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

	if ! sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 "${to_install[@]}" >/dev/null 2>&1; then
		log "error" "Failed to install: ${to_install[*]}"
		return 1
	fi

	if [ $skipped -gt 0 ]; then
		log "success" "Installed ${#to_install[@]} packages via apt ($skipped already present)"
	else
		log "success" "Installed ${#to_install[@]} packages via apt"
	fi
}

__make_symlink() {
	local path="$1"
	local oldname="$2"
	local oldname_path

	[ -f "$path" ] && rm -f "$path"

	oldname_path=$(which "$oldname")

	ln -s "$oldname_path" "$path"
}

__git_dot() {
	/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}

__HELPER_ALREADY_LOADED=1
