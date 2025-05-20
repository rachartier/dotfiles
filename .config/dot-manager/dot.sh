#!/bin/env bash

DOT_MANAGER_VERSION="2"

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
    "viu"
    "lazygit"
    "lazydocker"
    "starship"
    "zoxide"
    "bat"
    "chafa"
    "git_tools"
    "copilot_cli"
    "direnv"
    "win32yank"
    "gping"
)

###
### Programs to install for a "lightwheight" configuration
###
DOT_MANAGER_MINIMAL_PROGRAMS=(
    "fd_find"
    "nvim"
    "eza"
    "fzf"
    "viu"
    "zoxide"
    "starship"
    "copilot_cli"
    "chafa"
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
)

# ---------------------------------------------------------------------------
DOT_MANAGER_DIR="$HOME/.config/dot-manager"
DOT_MANAGER_CACHE_DIR="$HOME/.cache/dot-manager"
source "$DOT_MANAGER_DIR/helper.sh"

if [ ! -d "$DOT_MANAGER_CACHE_DIR" ]; then
    mkdir -p "$DOT_MANAGER_CACHE_DIR"
fi

__install_program() {
    local program_name="$1"
    local install_script="$DOT_MANAGER_DIR/install/programs/$program_name.sh"

    if [ -f "$install_script" ]; then
        shift
        if ! source "$install_script" "$@"; then
            log "error" "Failed to source '$program_name' script."
            return 1
        fi
    else
        log "error" "'$program_name' unknown."
        return 1
    fi
}

__install_program_list() {
    local program_list=("$@")

    for program in "${program_list[@]}"; do
        __install_program "$program" || return 1
    done
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
            tic -x -o "$HOME/.terminfo" "$tempfile" &&
            rm "$tempfile"
    fi

    print_step "Installing system packages"
    __install_package_apt pkg-config \
        build-essential \
        wget \
        libfuse2 \
        python3-venv \
        python3-pip \
        npm \
        unzip \
        ripgrep \
        xsel \
        freetype2-devel \
        libglib2.0-dev

    if [ -z "$DOTFILES_MINIMAL" ]; then
        __install_package_apt tty-clock
        __install_package_apt grc
    fi

    if [ -f "$HOME/.local/bin/fd" ]; then
        log "info" "Removing old fd symlink."
        rm "$HOME/.local/bin/fd"
    fi

    ln -s $(which fdfind) ~/.local/bin/fd

}

install_complete() {
    print_header "Installing Complete Configuration"
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
    "/opt/nvim-linux-x86_64/bin/nvim" --headless "+Lazy! sync" "+qall"

    log "info" "Updating tmux plugins..."
    "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all

    log "info" "Updating antidote plugins..."
    zsh -c ". \"$HOME/.antidote/antidote.zsh\" &&  antidote update"
}

show_programs_list() {
    echo "Available programs:"
    for program in "${DOT_MANAGER_COMPLETE_PROGRAMS[@]}"; do
        echo "  - $program"
    done
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
    "list") show_programs_list ;;
    "init") install_complete ;;
    "update") update_all ;;
    "minimal") install_minimal ;;
    "docker") install_docker ;;
    "terminal")
        shift
        source "$DOT_MANAGER_DIR/install/terminal.sh" "$@"
        ;;
    "reinstall")
        shift
        do_reinstall "$@"
        ;;
    "tool")
        shift
        do_tool "$@"
        ;;
    "migrate")
        shift
        source "$DOT_MANAGER_DIR/migrate.sh" "$@"
        ;;
    *) __git_dot "$@" ;;
    esac
}

if [ $# -eq 0 ]; then
    __git_dot "$@"
else
    do_command "$@"
fi
