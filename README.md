# dotfiles
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME' >> $HOME/.zshrc
echo ".cfg" >> .gitignore
git clone --bare git@github.com:rachartier/dotfiles.git $HOME/.cfg

# NVIM
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

sudo apt install -y python3.10-venv
sudo apt install -y nodejs npm
sudo apt install -y unzip

# ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo apt install -y autojump
pip install thefuck

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
sudo apt install -y xsel

cd /tmp
git clone https://github.com/facebook/PathPicker.git

cd PathPicker/debian
./package.sh
sudo cp -r usr/* /usr

# WSLTTY
## Emojis
sudo apt install -y subversion
svn export https://github.com/googlefonts/noto-emoji/trunk/png/128 /tmp/noto
cd /mnt/c && cmd.exe /c echo %appdata% > /tmp/appdata_tmp && cd - >& /dev/null
appdata=$(wslpath -u $(cat /tmp/appdata_tmp) | tr -d "\r")
cp -r /tmp/noto $appdata/wsltty/emojis/noto
```

# WEZTERM

Symbolic Link WSL2 <-> Windows (Powershell Admin)
```
New-Item -ItemType SymbolicLink -Path "C:\Program Files\WezTerm\wezterm.lua" -Target "\\wsl.localhost\Ubuntu\home\rachartier\.config\wezterm\wezterm.lua"
```

# WSLTTY config
```
Term=xterm-256color
Charwidth=unicode
EmojiPlacement=full
Emojis=noto
Scrollbar=none
CtrlShiftShortcuts=yes
ClicksPlaceCursor=no
Font=CaskaydiaCove NF
FontHeight=13
ThemeFile=macchiato.minttyrc
```

# WSLTTY theme
macchiato.minttyrc
```
ForegroundColour=202,201,245
BackgroundColour=22,22,29
CursorColour=205,214,244
Black=24,25,38
BoldBlack=98,104,128
Red=243,139,168
BoldRed=243,139,168
Green=166,227,161
BoldGreen=166,227,161
Yellow=249,226,175
BoldYellow=249,226,175
Blue=137,180,250
BoldBlue=137,180,250
Magenta=203,166,247
BoldMagenta=203,166,247
Cyan=116,199,236
BoldCyan=116,199,236
White=205,214,244
BoldWhite=205,214,244
```
