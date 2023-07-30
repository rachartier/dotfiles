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

sudo apt install python3.10-venv
sudo apt install nodejs npm
sudo apt install unzip

# ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
sudo apt install xsel

cd /tmp
git clone https://github.com/facebook/PathPicker.git

cd PathPicker/debian
./package.sh
sudo cp -r usr/* /usr

# WSLTTY
## Emojis
sudo apt install subversion
svn export https://github.com/googlefonts/noto-emoji/trunk/png/128 /tmp/noto
cd /mnt/c && cmd.exe /c echo %appdata% > /tmp/appdata_tmp && cd - >& /dev/null
appdata=$(wslpath -u $(cat /tmp/appdata_tmp) | tr -d "\r")
cp -r /tmp/noto $appdata/wsltty/emojis/noto
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
CursorColour=202,201,245
Black=24,25,38
BoldBlack=98,104,128
Red=237,135,150
BoldRed=237,135,150
Green=166,218,149
BoldGreen=166,218,149
Yellow=238,212,159
BoldYellow=238,212,159
Blue=138,173,244
BoldBlue=138,173,244
Magenta=198,160,246
BoldMagenta=198,160,246
Cyan=139,213,202
BoldCyan=139,213,202
White=202,211,245
BoldWhite=202,211,245
```
