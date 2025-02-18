#!/bin/env zsh

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

    dpkg-query -W --showformat='${Status}\n' "$name" >/dev/null | grep "install ok installed" >/dev/null
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

    # check if $filename is a directory
    if [[ "$filename" == *.tar.gz ]]; then
        tar -xf "$filename" && log "success" "$filename extracted." || return 1
        filename=$(basename "$filename" ".tar.gz")
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
    sudo dpkg -i "$filename" >/dev/null && log "success" "$name installed." || return 1
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
            sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 "$pkg" && log "success" "$pkg installed."
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

install_luarocks() {
    log "info" "Installing luarocks..."

    __install_package_apt lua5.1
    __install_package_apt liblua5.1-dev

    wget -nv -q https://luarocks.org/releases/luarocks-3.11.1.tar.gz &&
        tar zxpf luarocks-3.11.1.tar.gz &&
        cd luarocks-3.11.1 &&
        ./configure && make && sudo make install

}

install_fonts_for_windows() {
    log "info" "Installing fonts for Windows"

    fonts=$(find "$HOME/.fonts" -type f -name "*.ttf" -o -name "*.otf")

    for font in $fonts; do
        log "info" "Installing $font..."
        font_name=$(basename "$font")
        # cp "$font" "/mnt/c/Users/$(__get_windows_user)/AppData/Local/Microsoft/Windows/Fonts/$font_name" || log "info" "Font $font_name already installed."
        cp "$font" "/mnt/c/Windows/Fonts/$font_name" || log "info" "Font $font_name already installed."
    done

    log "success" "Fonts installed."
}

install_starship() {
    print_step "Installing Starship"

    if curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y >/dev/null; then
        log "success" "starship installed."
    else
        log "error" "starship not installed."
    fi
}

install_fzf() {
    print_step "Installing Fzf"

    if [ -d "$HOME/.fzf/" ]; then
        cd ~/.fzf || return 0
        git pull --quiet
        if yes | ./install; then
            log "success" "fzf updated."
        else
            log "error" "fzf not updated."
        fi
        return 0
    fi

    log "info" "Cloning fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null

    log "info" "Installing fzf..."
    yes | ~/.fzf/install >/dev/null
}

install_viu() {
    print_step "Installing Viu"

    local version
    version=$(__get_latest_release "atanunq/viu")

    log "download" "Installing viu $version ..."

    __install_package_release "https://github.com/atanunq/viu/releases/latest/download/viu-x86_64-unknown-linux-musl" viu
}

install_lazygit() {
    print_step "Installing Lazygit"

    LAZYGIT_VERSION=$(__get_latest_release "jesseduffield/lazygit")
    LAZYGIT_VERSION="${LAZYGIT_VERSION:1}"

    log "download" "Installing lazygit ${LAZYGIT_VERSION} ..."

    if [ -f "/usr/local/bin/lazygit" ]; then
        log "info" "Removing old lazygit symlink."
        sudo rm "/usr/local/bin/lazygit"
    fi
    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit
}

install_lazydocker() {
    print_step "Installing Lazydocker"

    LAZYDOCKER_VERSION=$(__get_latest_release "jesseduffield/lazydocker")
    LAZYDOCKER_VERSION="${LAZYDOCKER_VERSION:1}"

    log "download" "Installing lazydocker ${LAZYDOCKER_VERSION} ..."

    if [ -f "/usr/local/bin/lazydocker" ]; then
        log "info" "Removing old lazydocker symlink."
        sudo rm "/usr/local/bin/lazydocker"
    fi

    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" lazydocker
	log "info" "lazydocker installed."
}

install_zoxide() {
    print_step "Installing Zoxide"

    log "info" "Installing zoxide..."

    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null

    log "success" "zoxide installed."
}

install_tmux() {
    print_step "Installing Tmux"
    TMUX_VERSION=$(__get_latest_release "tmux/tmux")

    log "info" "Installing dependencies"
    __install_package_apt libevent-dev ncurses-dev build-essential bison pkg-config

    cd /tmp || exit 1
    wget -nv -q "https://github.com/tmux/tmux/releases/latest/download/tmux-${TMUX_VERSION}.tar.gz" -O tmux.tar.gz
    tar -xzvf tmux.tar.gz >/dev/null
    cd "tmux-$TMUX_VERSION" || exit

    log "info" "Compiling tmux"
    ./configure --enable-sixel >/dev/null

    log "info" "Installing tmux"
    make >/dev/null && sudo make install >/dev/null

    log "info" "Installing tmux plugins manager"
    if ! [ -d "$HOME"/.config/tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm
    fi

    log "info" "Installing tmux plugins"
    "$HOME"/.config/tmux/plugins/tpm/bin/install_plugins

    log "success" "Tmux installation completed"
}

install_bat() {
    print_step "Installing Bat"

    cd /tmp || exit

    local bat_version
    bat_version=$(__get_latest_release "sharkdp/bat")

    log "download" "Installing bat ${bat_version} ..."
    __download_install_deb "https://github.com/sharkdp/bat/releases/download/$bat_version/bat_${bat_version:1}_amd64.deb" "bat"

    if ! [ -d "$(bat --config-dir)" ]; then
        log "info" "Installing bat themes..."
        mkdir -p "$(bat --config-dir)/themes"
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

        log "success" "bat themes installed."
        bat cache --build
    fi
}

install_packages() {
    print_step "Installing Base Packages"

    if [ "$TERM" = "wezterm" ]; then
        print_step "Setting up wezterm terminfo"
        tempfile=$(mktemp) &&
            curl -sS -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo &&
            tic -x -o "$HOME/.terminfo" "$tempfile" &&
            rm "$tempfile"
    elif [ "$TERM" = "ghostty" ] || [ "$TERM" = "xterm-ghostty" ]; then
        print_step "Setting up ghostty terminfo"
        tempfile=$(mktemp) &&
            curl -sS -o "$tempfile" https://raw.githubusercontent.com/rachartier/dotfiles/refs/heads/main/.config/ghostty/terminfo/ghostty.terminfo &&
            tic -x -o  "$HOME/.terminfo"  "$tempfile" &&
            rm "$tempfile"
    fi

    print_step "Installing system packages"
    __install_package_apt pkg-config
    __install_package_apt build-essential

    __install_package_apt wget
    __install_package_apt libfuse2

    __install_package_apt python3-venv
    __install_package_apt python3-pip
    __install_package_apt npm
    __install_package_apt unzip

    __install_package_apt ripgrep
    __install_package_apt xsel


    if [ -z "$DOTFILES_MINIMAL" ]; then
        __install_package_apt chafa
        __install_package_apt tty-clock
        __install_package_apt grc
    fi

    print_step "Installing Node.js LTS"
    # install nodejs...
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s lts >/dev/null

    if [ -f "$HOME/.local/bin/fd" ]; then
        log "info" "Removing old fd symlink."
        rm "$HOME/.local/bin/fd"
    fi

    ln -s $(which fdfind) ~/.local/bin/fd

}

install_git_tools() {
    log "info" "Installing git-delta..."

    local git_delta_version
    git_delta_version=$(__get_latest_release "dandavison/delta")

    __download_install_deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${git_delta_version}_amd64.deb" "delta"

    local git_graph_version
    git_graph_version=$(__get_latest_release "mlange-42/git-graph")
    log "info" "Installing git-graph ${git_graph_version}..."

    __install_package_release "https://github.com/mlange-42/git-graph/releases/latest/download/git-graph-$git_graph_version-linux-amd64.tar.gz" git-graph
}

install_fd_find() {
    log "info" "Installing fd-find..."

    local fd_version
    fd_version=$(__get_latest_release "sharkdp/fd")

    __install_package_release "https://github.com/sharkdp/fd/releases/latest/download/fd-${fd_version}-x86_64-unknown-linux-gnu.tar.gz" fd
}

install_github_gh() {
    log "info" "Installing gh"

    local gh_version
    gh_version=$(__get_latest_release "cli/cli")
    gh_version="${gh_version:1}"

    # vériier si la version actuelle est la même que la version à installer, si seulement la version actuelle est installée
    if gh --version | grep -q "gh version $gh_version"; then
        log "info" "gh already installed."
    else
        __download_install_deb "https://github.com/cli/cli/releases/latest/download/gh_${gh_version}_linux_amd64.deb" "gh"
    fi

    gh auth status >/dev/null
    if [ "$?" -eq 0 ]; then
        log "info" "gh already authenticated."
    else
        log "info" "Please authenticate with gh."
        gh auth login
    fi

    if gh extension list | grep -q "gh-copilot"; then
        gh extension upgrade gh-copilot
    else
        gh extension install github/gh-copilot
    fi
}

# install_zsh_plugins() {
# 	__install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions.git"
# 	__install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git"
# 	__install_zsh_plugin "https://github.com/b4b4r07/enhancd.git"
# 	__install_zsh_plugin "https://github.com/zsh-users/zsh-history-substring-search.git"
#
#     if [ -z "$DOTFILES_MINIMAL" ]; then
#         __install_zsh_plugin "https://github.com/darvid/zsh-poetry.git"
#     fi
# }

install_nvim() {
    print_step "Installing Neovim"
    local version=${1:-"nightly"}

    log "info" "Removing existing Neovim installation"
    sudo apt-get autoremove neovim -y >/dev/null

    if [ -f "$HOME/.local/bin/nvim" ]; then
        rm "$HOME/.local/bin/nvim"
    fi

    log "download" "Downloading Neovim $version"
    cd /tmp || exit 1
    local url="https://github.com/neovim/neovim/releases/download/$version/nvim-linux-x86_64.tar.gz"
    wget -q "$url" -O nvim-linux64.tar.gz >/dev/null

    log "info" "Installing Neovim"
    sudo rm -rf /opt/nvim-linux-x86_64/
    sudo tar -C /opt -xzf nvim-linux64.tar.gz

    # __install_package_apt python3-pynvim

    if [ ! -f "$HOME/.local/share/nvim/site/spell/fr.utf-8.spl" ]; then
        mkdir -p ~/.local/share/nvim/site/spell
        wget https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl \
            -O ~/.local/share/nvim/site/spell/fr.utf-8.spl
    fi

    log "info" "Installing luarocks"
    install_luarocks >/dev/null

    log "info" "Updating plugins"
    /opt/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" "+qall" >/dev/null

    log "success" "Neovim installation completed"
}

install_eza() {
    print_step "Installing eza"

    local version
    version=$(__get_latest_release "eza-community/eza")

    log "download" "Downloading $version"
    __install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_glow() {
    print_step "Installing Glow"

    local glow_version
    glow_version=$(__get_latest_release "charmbracelet/glow")

    log "download" "Installing glow..."
    __install_package_release "https://github.com/charmbracelet/glow/latest/download/${glow_version}/glow_Linux_x86_64.tar.gz" glow
}

install_direnv() {
    print_step "Installing direnv"

    curl -sfL https://direnv.net/install.sh | bash

    log "success" "direnv installed."
}

install_essentials() {
    install_packages

	install_fd_find
    install_tmux
    install_nvim

    install_eza
    install_glow

    install_fzf
    install_viu
    install_lazygit
    install_lazydocker
    install_starship
    install_zoxide
    install_bat

    install_git_tools
    # install_github_gh

    git config --global include.path "~/.config/git/gitconfig"

    install_copilot_cli
    install_direnv
}

install_minimal() {
    log "info" "Exporting DOTFILES_MINIMAL=1 to $HOME/.profile"
    echo "export DOTFILES_MINIMAL=1" >>"$HOME/.profile"
    export DOTFILES_MINIMAL=1

    install_packages
    install_nvim

    install_eza
    install_fzf
    install_viu
    install_zoxide
    install_starship
    # install_ohmyposh
}

install_docker() {
    log "info" "Exporting DOTFILES_DOCKER=1 to $HOME/.profile"
    echo "export DOTFILES_DOCKER=1" >>"$HOME/.profile"
    export DOTFILES_DOCKER=1

    install_minimal
}

install_copilot_cli() {
    log "info" "Installing copilot-cli..."

    # local copilot_cli_version
    # copilot_cli_version=$(__get_latest_release "rachartier/copilot-cli")
    # echo "copilot-cli version: $copilot_cli_version"
    #
    # __install_package_release "https://github.com/charmbracelet/glow/latest/download/${copilot_cli_version}/glow_Linux_x86_64.tar.gz" glow

    if [ -f "$HOME/.local/bin/copilot-cli" ]; then
        log "info" "Removing old copilot-cli symlink."
        rm "$HOME/.local/bin/copilot-cli"
    fi

    __install_package_release "https://github.com/rachartier/copilot-cli/releases/latest/download/copilot-cli.tar.gz" copilot-cli
    #
    # ln -s "$HOME/.config/scripts/copilot-cli.sh" "$HOME/.local/bin/copilot-cli" &&
    #     log "success" "copilot-cli symlink created." ||
    #     log "error" "copilot-cli symlink not created."
    #
    # chmod +x "$HOME/.local/bin/copilot-cli"
    #
    # if [ ! -d ".venv" ]; then
    #     log "info" "Creating virtual environment..."
    #     python3 -m venv .venv
    #     source .venv/bin/activate
    #     pip install -r requirements.txt
    #     deactivate
    # fi
}

do_reinstall_all() {
    if [ -n "$DOTFILES_MINIMAL" ]; then
        install_minimal
    elif [ -n "$DOTFILES_DOCKER" ]; then
        install_docker
    else
        install_essentials
    fi
}

do_reinstall() {
    case "$1" in
    "all") do_reinstall_all ;;
    "bat") install_bat ;;
    "docker") install_docker ;;
    "git-tools") install_git_tools ;;
    "eza") install_eza ;;
    "fd") install_fd_find ;;
    "fzf") install_fzf ;;
    "glow") install_glow ;;
    "zoxide") install_zoxide ;;
    "lazydocker") install_lazydocker ;;
    "lazygit") install_lazygit ;;
    "minimal") install_minimal ;;
    "nvim") install_nvim "$2" ;;
    "ohmyposh") install_ohmyposh ;;
    "packages") install_packages ;;
    "starship") install_starship ;;
    "tmux") install_tmux ;;
    "viu") install_viu ;;
    "gh") install_github_gh ;;
    "copilot-cli") install_copilot_cli ;;
    "direnv") install_direnv ;;
    "fonts") install_fonts_for_windows ;;
    *) log "error" "'$1' unknown." ;;
    esac
}

use_tool_dotnet() {
    if [ ! -f "$HOME/.dotnet" ]; then
        log "info" "Creating $HOME/.dotnet directory."
        mkdir -p "$HOME/.dotnet"
    fi

    local script_path="$HOME/.config/scripts/dotnet-install.sh"
    if [ ! -f "$script_path" ]; then
        log "info" "Downloading dotnet-install.sh script."
        wget -q "https://dot.net/v1/dotnet-install.sh" -O "$script_path"
        chmod +x "$script_path"
    fi

    log "info" "Running dotnet-install.sh script."
    bash "$script_path" "$@"
}

update_all() {
    log "info" "Updating neovim plugins..."
    "/opt/nvim-linux-x86_64/bin/nvim" --headless "+Lazy! sync" "+qall"

    log "info" "Updating tmux plugins..."
    "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all

    . "$HOME/.antidote/antidote.zsh"
    log "info" "Updating antidote plugins..."
    antidote update
}

do_tool() {
    local tool_name="$1"

    case "$tool_name" in
    "dotnet")
        shift
        use_tool_dotnet "$@"
        ;;
    *) log "error" "'$tool_name' unknown." ;;
    esac
}

do_command() {
    case "$1" in
    "init") install_essentials ;;
    "update") update_all ;;
    "minimal") install_minimal ;;
    "docker") install_docker ;;
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
