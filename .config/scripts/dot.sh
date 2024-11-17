#!/bin/env zsh

__echo_success() {
    echo "[SUCCESS] $(tput setaf 2)$1"
    tput sgr 0
}

__echo_warning() {
    echo "[WARN] $(tput setaf 3)$1"
    tput sgr 0
}

__echo_info() {
    echo "[INFO] $(tput setaf 6)$1"
    tput sgr 0
}

__echo_failure() {
    echo >&2 "[FAILURE] $(tput setaf 1)$1"
    tput sgr 0
}

__need_sudo() {
    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        __echo_failure "Please run as root: sudo -E dot"
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

    dpkg-query -W --showformat='${Status}\n' "$name" 2>/dev/null | grep "install ok installed" >/dev/null
}

__install_appimage() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url" ".tar.gz")

    cd /tmp || exit 1
    wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
    chmod +x "$filename"
    mv "$filename" "$HOME/.local/bin/$name" && __echo_success "'$name' moved in $HOME/.local/bin/" || return 1
}

__install_package_release() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url")

    __echo_info "Downloading $filename"
    cd /tmp || exit 1
    wget -q "$url" && __echo_success "'$filename' downloaded." || return 1

    # check if $filename is a directory
    if [[ "$filename" == *.tar.gz ]]; then
        tar -xf "$filename" && __echo_success "$filename extracted." || return 1
    else
        mv "$filename" "$name"
    fi

    chmod +x "$name"
    mv "$name" "$HOME/.local/bin/$name" && __echo_success "'$name' moved in $HOME/.local/bin/" || return 1
}

__download_install_deb() {
    local url=$1
    local name=$2
    local filename

    filename=$(basename "$url")

    __echo_info "Downloading $filename"
    cd /tmp || exit 1
    wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
    sudo dpkg -i "$filename" && __echo_success "$name installed." || return 1
}

__install_zsh_plugin() {
    local url=$1
    local folder
    folder=$(echo "$url" | sed -r 's|.*/(.*)\.git$|\1|')

    local installation_folder="$HOME/.oh-my-zsh/custom/plugins/$folder"

    [ -d "$installation_folder" ] && rm -rf "$installation_folder"

    git clone "$url" "$installation_folder" && __echo_success "$folder installed." || return 1
}

__install_package_apt() {
    for pkg in "$@"; do
        if __is_pkg_installed "$pkg"; then
            __echo_info "$pkg already installed."
        else
            sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 "$pkg" && __echo_success "$pkg installed."
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
    __echo_info "Installing luarocks..."

    __install_package_apt lua5.1
    __install_package_apt liblua5.1-dev

    wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz &&
        tar zxpf luarocks-3.11.1.tar.gz &&
        cd luarocks-3.11.1 &&
        ./configure && make && sudo make install

}

install_fonts_for_windows() {
    __echo_info "Installing fonts for Windows"

    fonts=$(find "$HOME/.fonts" -type f -name "*.ttf" -o -name "*.otf")

    for font in $fonts; do
        __echo_info "Installing $font..."
        font_name=$(basename "$font")
        # cp "$font" "/mnt/c/Users/$(__get_windows_user)/AppData/Local/Microsoft/Windows/Fonts/$font_name" || __echo_info "Font $font_name already installed."
        cp "$font" "/mnt/c/Windows/Fonts/$font_name" || __echo_info "Font $font_name already installed."
    done

    __echo_success "Fonts installed."
}

install_starship() {
    if curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y; then
        __echo_success "starship installed."
    else
        __echo_failure "starship not installed."
    fi
}

install_ohmyposh() {
    if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin"
    fi

    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
    __echo_success "ohmyposh installed."
}

install_fzf() {
    if [ -d "$HOME/.fzf/" ]; then
        cd ~/.fzf || return 0
        git pull --quiet
        if yes | ./install; then
            __echo_success "fzf updated."
        else
            __echo_error "fzf not updated."
        fi
        return 0
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &>/dev/null
    yes | ~/.fzf/install
}

install_viu() {
    __install_package_release "https://github.com/atanunq/viu/releases/latest/download/viu-x86_64-unknown-linux-musl" viu
}

install_lazygit() {
    LAZYGIT_VERSION=$(__get_latest_release "jesseduffield/lazygit")
    LAZYGIT_VERSION="${LAZYGIT_VERSION:1}"

    if [ -f "/usr/local/bin/lazygit" ]; then
        __echo_info "Removing old lazygit symlink."
        sudo rm "/usr/local/bin/lazygit"
    fi
    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit
}

install_lazydocker() {
    LAZYDOCKER_VERSION=$(__get_latest_release "jesseduffield/lazydocker")
    LAZYDOCKER_VERSION="${LAZYDOCKER_VERSION:1}"

    if [ -f "/usr/local/bin/lazydocker" ]; then
        __echo_info "Removing old lazydocker symlink."
        sudo rm "/usr/local/bin/lazydocker"
    fi

    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" lazydocker
}

install_zoxide() {
    __echo_info "Installing zoxide..."

    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    __echo_success "zoxide installed."
}

install_tmux() {
    __echo_info "Installing tmux"
    TMUX_VERSION=$(__get_latest_release "tmux/tmux")

    __install_package_apt libevent-dev ncurses-dev build-essential bison pkg-config
    wget "https://github.com/tmux/tmux/releases/latest/download/tmux-${TMUX_VERSION}.tar.gz" -O /tmp/tmux.tar.gz

    tar -xzvf /tmp/tmux.tar.gz -C /tmp

    cd "/tmp/tmux-$TMUX_VERSION" || exit
    ./configure --enable-sixel
    make && sudo make install

    __echo_info "Installing tmux plugins"

    if ! [ -d "$HOME"/.config/tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm
    fi

    "$HOME"/.config/tmux/plugins/tpm/bin/install_plugins
}

install_bat() {
    __echo_info "Installing bat..."
    cd /tmp || exit

    local bat_version
    bat_version=$(__get_latest_release "sharkdp/bat")

    __download_install_deb "https://github.com/sharkdp/bat/releases/download/$bat_version/bat_${bat_version:1}_amd64.deb" "bat"

    if ! [ -d "$(bat --config-dir)" ]; then
        mkdir -p "$(bat --config-dir)/themes"
        wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
        wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
        wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
        wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
        bat cache --build
    fi
}

install_packages() {
    # install terminfo for wezterm
    tempfile=$(mktemp) &&
        curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
        tic -x -o ~/.terminfo $tempfile &&
        rm $tempfile

    __install_package_apt pkg-config
    __install_package_apt build-essential

    __install_package_apt wget
    __install_package_apt libfuse2

    __install_package_apt python3-venv
    __install_package_apt python3-pip
    __install_package_apt npm
    __install_package_apt unzip

    __install_package_apt ripgrep
    __install_package_apt fd-find
    __install_package_apt xsel

    if [ -z "$DOTFILES_MINIMAL" ]; then
        __install_package_apt chafa
        __install_package_apt tty-clock
        __install_package_apt grc
    fi

    # install nodejs...
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s lts

    install_bat

    __make_symlink "$HOME/.local/bin/fd" fdfind
}

install_git_delta() {
    __echo_info "Installing git-delta..."

    local git_delta_version
    git_delta_version=$(__get_latest_release "dandavison/delta")

    __download_install_deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${git_delta_version}_amd64.deb" "delta"
}

install_github_gh() {
    __echo_info "Installing gh"

    local gh_version
    gh_version=$(__get_latest_release "cli/cli")
    gh_version="${gh_version:1}"

    # vériier si la version actuelle est la même que la version à installer, si seulement la version actuelle est installée
    if gh --version | grep -q "gh version $gh_version"; then
        __echo_info "gh already installed."
    else
        __download_install_deb "https://github.com/cli/cli/releases/latest/download/gh_${gh_version}_linux_amd64.deb" "gh"
    fi

    gh auth status &>/dev/null
    if [ "$?" -eq 0 ]; then
        __echo_info "gh already authenticated."
    else
        __echo_info "Please authenticate with gh."
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
    sudo apt autoremove neovim -y # remove neovim installed by apt

    if [ "$1" = "stable" ]; then
        __install_appimage "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage" nvim
    else
        __install_appimage "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" nvim
    fi

    __install_package_apt python3-pynvim

    if [ ! -f "$HOME/.local/share/nvim/site/spell/fr.utf-8.spl" ]; then
        mkdir -p ~/.local/share/nvim/site/spell
        wget https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl -O ~/.local/share/nvim/site/spell/fr.utf-8.spl
    fi

    # if [ ! -d "/usr/local/lib/lua/5.1" ]; then
    # 	sudo mkdir -p /usr/local/lib/lua/5.1
    # fi

    # if [ ! -f "/usr/local/lib/lua/5.1/tiktoken_core.so" ]; then
    # 	sudo wget https://github.com/gptlang/lua-tiktoken/releases/download/0.2.1/tiktoken_core-linux-lua51.so -O /usr/local/lib/lua/5.1/tiktoken_core.so
    # fi

    install_luarocks

    # Update plugins
    __echo_info "Updating plugins..."
    "$HOME/.local/bin/nvim" --headless "+Lazy! sync" "+qall"

    if [ "$?" -eq 127 ]; then
        __echo_warning "nvim.appimage can't be runned. Exporting APPIMAGE_EXTRACT_AND_RUN=1 and running nvim."
        export APPIMAGE_EXTRACT_AND_RUN=1
        "$HOME/.local/bin/nvim" --headless "+Lazy! sync" "+qall"
    fi

    __echo_success "Plugins updated."
}

install_eza() {
    __install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_glow() {
    echo "Installing glow..."

    local glow_version
    glow_version=$(__get_latest_release "charmbracelet/glow")

    __install_package_release "https://github.com/charmbracelet/glow/latest/download/${glow_version}/glow_Linux_x86_64.tar.gz" glow
}

install_essentials() {
    install_packages

    install_tmux
    install_nvim

    install_eza
    install_glow

    install_fzf
    install_viu
    install_lazygit
    install_lazydocker
    install_starship
    # install_ohmyposh
    install_zoxide

    install_git_delta
    # install_github_gh

    git config --global include.path "~/.config/git/gitconfig"

    install_copilot_cli
}

install_minimal() {
    __echo_info "Exporting DOTFILES_MINIMAL=1 to $HOME/.profile"
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
    __echo_info "Exporting DOTFILES_DOCKER=1 to $HOME/.profile"
    echo "export DOTFILES_DOCKER=1" >>"$HOME/.profile"
    export DOTFILES_DOCKER=1

    install_minimal
}

install_copilot_cli() {
    __echo_info "Installing copilot-cli..."

    # local copilot_cli_version
    # copilot_cli_version=$(__get_latest_release "rachartier/copilot-cli")
    # echo "copilot-cli version: $copilot_cli_version"
    #
    # __install_package_release "https://github.com/charmbracelet/glow/latest/download/${copilot_cli_version}/glow_Linux_x86_64.tar.gz" glow

    if [ -f "$HOME/.local/bin/copilot-cli" ]; then
        __echo_info "Removing old copilot-cli symlink."
        rm "$HOME/.local/bin/copilot-cli"
    fi

    __install_package_release "https://github.com/rachartier/copilot-cli/releases/latest/download/copilot-cli.tar.gz" copilot-cli
    #
    # ln -s "$HOME/.config/scripts/copilot-cli.sh" "$HOME/.local/bin/copilot-cli" &&
    #     __echo_success "copilot-cli symlink created." ||
    #     __echo_failure "copilot-cli symlink not created."
    #
    # chmod +x "$HOME/.local/bin/copilot-cli"
    #
    # if [ ! -d ".venv" ]; then
    #     __echo_info "Creating virtual environment..."
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
    "delta") install_git_delta ;;
    "eza") install_eza ;;
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
    "fonts") install_fonts_for_windows ;;
    *) __echo_failure "'$1' unknown." ;;
    esac
}

use_tool_dotnet() {
    if [ ! -f "$HOME/.dotnet" ]; then
        __echo_info "Creating $HOME/.dotnet directory."
        mkdir -p "$HOME/.dotnet"
    fi

    local script_path="$HOME/.config/scripts/dotnet-install.sh"
    if [ ! -f "$script_path" ]; then
        __echo_info "Downloading dotnet-install.sh script."
        wget -q "https://dot.net/v1/dotnet-install.sh" -O "$script_path"
        chmod +x "$script_path"
    fi

    __echo_info "Running dotnet-install.sh script."
    bash "$script_path" "$@"
}

update_all() {
    __echo_info "Updating neovim plugins..."
    "$HOME/.local/bin/nvim" --headless "+Lazy! sync" "+qall"

    __echo_info "Updating tmux plugins..."
    "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all

    . "$HOME/.antidote/antidote.zsh"
    __echo_info "Updating antidote plugins..."
    antidote update
}

do_tool() {
    local tool_name="$1"

    case "$tool_name" in
    "dotnet")
        shift
        use_tool_dotnet "$@"
        ;;
    *) __echo_failure "'$tool_name' unknown." ;;
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
