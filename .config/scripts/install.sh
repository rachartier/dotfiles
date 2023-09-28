__echo_success() {
    echo "[SUCCESS] $(tput setaf 2)$@"
    tput sgr 0
}


__echo_warning() {
    echo "[WARN] $(tput setaf 3)$@"
    tput sgr 0
}


__echo_info() {
    echo "[INFO] $(tput setaf 6)$@"
    tput sgr 0
}

__echo_failure() {
    echo >&2 "[FAILURE] $(tput setaf 1)$@"
    tput sgr 0
}

__is_pkg_installed() {
    local name="$1"

    dpkg-query -W --showformat='${Status}\n' $name  2> /dev/null | grep "install ok installed" > /dev/null
}

__install_appimage() {
    local url=$1
    local name=$2
    local filename=$(echo "$url" | sed 's#.*/##')

    cd /tmp
    wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
    chmod +x $filename
    mv "$filename" /usr/bin/$name && __echo_success "'$name' moved in /usr/bin." || return 1
}


__install_package_release() {
    local url=$1
    local name=$2
    local filename=$(echo "$url" | sed 's#.*/##')

    cd /tmp
    wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
    tar -xf $filename && __echo_success "$filename extracted." || return 1
    chmod +x $name
    mv "$name" /usr/bin/$name && __echo_success "'$name' moved in /usr/bin." || return 1
}

__install_zsh_plugin() {
    local url=$1
    local folder=$(echo "$url" | sed -r 's|.*/(.*)\.git$|\1|')
    local installation_folder="$HOME/.oh-my-zsh/custom/plugins/$folder"
    echo $installation_folder

    [ -d $install_folder ] && rm -rf $installation_folder

    git clone "$url" $installation_folder && __echo_success "$folder installed." || return 1
}

__install_package_apt() {
    local pkg="$1"


    __is_pkg_installed $pkg && __echo_info "$pkg already installed." || (apt install -qq $pkg && __echo_success "$pkg installed.")
}

__make_symlink() {
    local path="$1"
    local oldname="$2"

    [ -f "$path" ] && rm -f "$path"
    ln -s $(which "$oldname") "$path"
}

install_fzf() {
    if [ -d "$HOME/.fzf/" ]; then
        cd ~/.fzf
        git pull
        yes | ./install && __echo_success "fzf updated." || __echo_error "fzf not updated."
        return 0
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_eza() {
    mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    apt update -qq
    apt install -qq -y eza
}

install_essentials() {
     __install_appimage "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" nvim

     __install_zsh_plugin "https://github.com/sindresorhus/pure.git"
     __install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions.git"
     __install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git"
     __install_zsh_plugin "https://github.com/b4b4r07/enhancd.git"

     __install_package_apt tmux

     __install_package_apt python3.10-venv
     __install_package_apt nodejs
     __install_package_apt npm
     __install_package_apt unzip

     __install_package_apt ripgrep
     __install_package_apt fd-find
     __install_package_apt xsel
     __install_package_apt bat

     __make_symlink "/usr/bin/fd" fdfind
     __make_symlink "/usr/bin/bat" batcat

    install_eza
    install_fzf
}

install_essentials
