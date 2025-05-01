#!/bin/env bash

show_spinner() {
    local pid=$1
    local message=$2
    local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local delay=0.1

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        for frame in $(echo $frames | grep -o .); do
            echo -ne "\r${COLORS[cyan]}$frame${COLORS[reset]} $message"
            sleep $delay
        done
    done
    echo -ne "\r${COLORS[green]}${ICON_SUCCESS}${COLORS[reset]} $message\n"
}

print_step() {
    local message="$1"
    echo
    echo -e "${COLORS[blue]}${ICON_GEAR} ${COLORS[bold]}$message${COLORS[reset]}"
}

print_separator() {
    line=$(printf ─%.0s $(seq 1 60))
    echo -e "\n${COLORS[dim]}${line}${COLORS[reset]}\n"
}

print_header() {
    local title="$1"
    local width=60
    local title_length=${#title}

    # Calculate padding for centering
    local padding_left=$(((width - title_length) / 2))
    local padding_right=$((width - title_length - padding_left))

    # Create the repeated characters
    local horizontal_line=$(printf '─%.0s' $(seq 1 $width))
    local padding_spaces_left=$(printf ' %.0s' $(seq 1 $padding_left))
    local padding_spaces_right=$(printf ' %.0s' $(seq 1 $padding_right))

    # Build the box
    local top_border="${COLORS[cyan]}╭${horizontal_line}╮${COLORS[reset]}"
    local middle_line="${COLORS[cyan]}│${COLORS[reset]}${padding_spaces_left}${COLORS[bold]}${title}${COLORS[reset]}${padding_spaces_right}${COLORS[cyan]}│${COLORS[reset]}"
    local bottom_border="${COLORS[cyan]}╰${horizontal_line}╯${COLORS[reset]}"

    # Print the header box
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

readonly ICON_SUCCESS="✓"
readonly ICON_ERROR="✗"
readonly ICON_WARNING="⚠"
readonly ICON_INFO=""
readonly ICON_PACKAGE=""
readonly ICON_DOWNLOAD="↓"
readonly ICON_GEAR="⚙ "
readonly ICON_ROCKET="🚀"

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

__need_sudo() {
    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        log "error" "Please run as root: sudo -E dot"
        exit
    fi
    eval $@
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
    local name="$1"

    if [ -f "/etc/arch-release" ]; then
        pacman -Q "$name" &>/dev/null
    else
        dpkg-query -W --showformat='${Status}\n' "$name" >/dev/null | grep "install ok installed" >/dev/null
    fi
}

__install_appimage() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url" ".tar.gz")

    cd /tmp || exit 1
    wget -nv -q "$url" && log "success" "'$filename' downloaded." >/dev/null || return 1
    chmod +x "$filename"
    mv "$filename" "$HOME/.local/bin/$name" && log "success" "'$name' moved in $HOME/.local/bin/" || return 1
}

__install_package_release() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url")

    log "info" "Downloading $filename"
    cd /tmp || exit 1

    if [ -d "/tmp/$name" ]; then
        log "info" "Removing old $name directory."
        rm -rf "/tmp/$name"
    fi

    if [ -f "/tmp/$filename" ]; then
        log "info" "Removing old $filename file."
        rm "/tmp/$filename"
    fi

    wget -nv -q "$url" >/dev/null && log "success" "'$filename' downloaded." || return 1

    if [[ "$filename" == *.tar.gz ]]; then
        tar -xf "$filename" && log "success" "$filename extracted." || return 1
        filename=$(basename "$filename" ".tar.gz")
        if [ -d "/tmp/$filename" ]; then
            cd "/tmp/$filename"
        fi
    elif [[ "$filename" == *.zip ]]; then
        unzip "$filename" && log "success" "$filename extracted." || return 1
        filename=$(basename "$filename" ".zip")
        if [ -d "/tmp/$filename" ]; then
            cd "/tmp/$filename"
        fi
    else
        mv "$filename" "$name"
    fi

    chmod +x "$name"
    mv "$name" "$HOME/.local/bin/$name" && log "success" "'$name' moved in $HOME/.local/bin/" || return 1
}

__download_install_deb() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url")

    log "info" "Downloading $filename"
    cd /tmp || exit 1
    wget -nv -q "$url" >/dev/null && log "success" "'$filename' downloaded." || return 1

    if [ -f "/etc/arch-release" ]; then
        # For Arch Linux, convert deb to pkg.tar.zst and install
        sudo pacman -S --noconfirm --needed debtap >/dev/null 2>&1
        sudo debtap -u >/dev/null 2>&1
        sudo debtap -q "$filename" >/dev/null 2>&1
        pkg_filename=$(ls *.pkg.tar.zst)
        sudo pacman -U --noconfirm "$pkg_filename" >/dev/null 2>&1 && log "success" "$name installed." || return 1
    else
        sudo dpkg -i "$filename" >/dev/null && log "success" "$name installed." || return 1
    fi
}

__install_zsh_plugin() {
    local url=$1
    local folder
    folder=$(echo "$url" | sed -r 's|.*/(.*)\.git$|\1|')

    local installation_folder="$HOME/.oh-my-zsh/custom/plugins/$folder"

    [ -d "$installation_folder" ] && rm -rf "$installation_folder"

    git clone "$url" "$installation_folder" && log "success" "$folder installed." || return 1
}

__install_package_apt() {
    for pkg in "$@"; do
        if __is_pkg_installed "$pkg"; then
            log "info" "$pkg already installed."
        else
            if [ -f "/etc/arch-release" ]; then
                sudo pacman -S --noconfirm --needed "$pkg" && log "success" "$pkg installed."
            else
                sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 "$pkg" && log "success" "$pkg installed."
            fi
        fi
    done
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
