# dotfiles
```
echo 'source "$HOME/.dotfile_profile"' >> $HOME/.profile

sudo apt install zsh --yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ".cfg" >> $HOME/.gitignore
mkdir $HOME/.cfg
git clone --bare git@github.com:rachartier/dotfiles.git $HOME/.cfg
/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout

sudo -E ~/.config/scripts/dot.sh init

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
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

# Windows Terminal

```
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema-preview",
    "actions": [],
    "alwaysShowTabs": true,
    "centerOnLaunch": true,
    "confirmCloseAllTabs": false,
    "copyFormatting": "none",
    "copyOnSelect": true,
    "defaultProfile": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "experimental.rendering.forceFullRepaint": false,
    "experimental.rendering.software": false,
    "newTabMenu": [
        {
            "type": "remainingProfiles"
        }
    ],
    "profiles": {
        "defaults": {
            "adjustIndistinguishableColors": "never",
            "antialiasingMode": "cleartype",
            "bellStyle": "taskbar",
            "colorScheme": "Catppuccin Macchiato",
            "cursorShape": "filledBox",
            "experimental.retroTerminalEffect": false,
            "font": {
                "face": "CaskaydiaCove Nerd Font",
                "features": {
                    "calt": 1,
                    "liga": 1,
                    "ss01": 1
                },
                "size": 13.0
            },
            "intenseTextStyle": "all",
            "opacity": 75,
            "padding": "13",
            "startingDirectory": ".",
            "useAcrylic": true
        },
        "list": [
            {
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
                "hidden": false,
                "intenseTextStyle": "all",
                "name": "Ubuntu",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory": "\\\\wsl.localhost\\Ubuntu\\home\\rachartier"
            },
            {
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "%SystemRoot%\\System32\\cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Invite de commandes"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                "hidden": false,
                "name": "PowerShell",
                "source": "Windows.Terminal.PowershellCore"
            },
            {
                "guid": "{62b7e789-a3ee-500b-b754-a14ed3d5ccd0}",
                "hidden": false,
                "name": "Developer Command Prompt for VS 2022",
                "source": "Windows.Terminal.VisualStudio"
            },
            {
                "guid": "{80d1ecca-f96f-57f5-895b-d81cb0c21c06}",
                "hidden": false,
                "name": "Developer PowerShell for VS 2022",
                "source": "Windows.Terminal.VisualStudio"
            }
        ]
    },
    "schemes": [
        {
            "background": "#0C0C0C",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#012456",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell Powershell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#303446",
            "black": "#51576D",
            "blue": "#8CAAEE",
            "brightBlack": "#626880",
            "brightBlue": "#8CAAEE",
            "brightCyan": "#81C8BE",
            "brightGreen": "#A6D189",
            "brightPurple": "#F4B8E4",
            "brightRed": "#E78284",
            "brightWhite": "#A5ADCE",
            "brightYellow": "#E5C890",
            "cursorColor": "#F2D5CF",
            "cyan": "#81C8BE",
            "foreground": "#C6D0F5",
            "green": "#A6D189",
            "name": "Catppuccin Frapp\u00e9",
            "purple": "#F4B8E4",
            "red": "#E78284",
            "selectionBackground": "#626880",
            "white": "#B5BFE2",
            "yellow": "#E5C890"
        },
        {
            "background": "#24273A",
            "black": "#494D64",
            "blue": "#8AADF4",
            "brightBlack": "#5B6078",
            "brightBlue": "#8AADF4",
            "brightCyan": "#8BD5CA",
            "brightGreen": "#A6DA95",
            "brightPurple": "#F5BDE6",
            "brightRed": "#ED8796",
            "brightWhite": "#A5ADCB",
            "brightYellow": "#EED49F",
            "cursorColor": "#F4DBD6",
            "cyan": "#8BD5CA",
            "foreground": "#CAD3F5",
            "green": "#A6DA95",
            "name": "Catppuccin Macchiato",
            "purple": "#F5BDE6",
            "red": "#ED8796",
            "selectionBackground": "#5B6078",
            "white": "#B8C0E0",
            "yellow": "#EED49F"
        },
        {
            "background": "#282C34",
            "black": "#282C34",
            "blue": "#61AFEF",
            "brightBlack": "#5A6374",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B6C2",
            "brightGreen": "#98C379",
            "brightPurple": "#C678DD",
            "brightRed": "#E06C75",
            "brightWhite": "#DCDFE4",
            "brightYellow": "#E5C07B",
            "cursorColor": "#FFFFFF",
            "cyan": "#56B6C2",
            "foreground": "#DCDFE4",
            "green": "#98C379",
            "name": "One Half Dark",
            "purple": "#C678DD",
            "red": "#E06C75",
            "selectionBackground": "#FFFFFF",
            "white": "#DCDFE4",
            "yellow": "#E5C07B"
        },
        {
            "background": "#FAFAFA",
            "black": "#383A42",
            "blue": "#0184BC",
            "brightBlack": "#4F525D",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B5C1",
            "brightGreen": "#98C379",
            "brightPurple": "#C577DD",
            "brightRed": "#DF6C75",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#E4C07A",
            "cursorColor": "#4F525D",
            "cyan": "#0997B3",
            "foreground": "#383A42",
            "green": "#50A14F",
            "name": "One Half Light",
            "purple": "#A626A4",
            "red": "#E45649",
            "selectionBackground": "#4F525D",
            "white": "#FAFAFA",
            "yellow": "#C18301"
        },
        {
            "background": "#002B36",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#FFFFFF",
            "cyan": "#2AA198",
            "foreground": "#839496",
            "green": "#859900",
            "name": "Solarized Dark",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#FFFFFF",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#FDF6E3",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#002B36",
            "cyan": "#2AA198",
            "foreground": "#657B83",
            "green": "#859900",
            "name": "Solarized Light",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#073642",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#FFFFFF",
            "cyan": "#06989A",
            "foreground": "#D3D7CF",
            "green": "#4E9A06",
            "name": "Tango Dark",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#FFFFFF",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#FFFFFF",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#000000",
            "cyan": "#06989A",
            "foreground": "#555753",
            "green": "#4E9A06",
            "name": "Tango Light",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#555753",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#000080",
            "brightBlack": "#808080",
            "brightBlue": "#0000FF",
            "brightCyan": "#00FFFF",
            "brightGreen": "#00FF00",
            "brightPurple": "#FF00FF",
            "brightRed": "#FF0000",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFF00",
            "cursorColor": "#FFFFFF",
            "cyan": "#008080",
            "foreground": "#C0C0C0",
            "green": "#008000",
            "name": "Vintage",
            "purple": "#800080",
            "red": "#800000",
            "selectionBackground": "#FFFFFF",
            "white": "#C0C0C0",
            "yellow": "#808000"
        }
    ],
    "showTabsInTitlebar": true,
    "snapToGridOnResize": false,
    "tabWidthMode": "equal",
    "theme": "Catppuccin Macchiato",
    "themes": [
        {
            "name": "Catppuccin Frappe",
            "tab": {
                "background": "#414559FF",
                "iconStyle": "default",
                "showCloseButton": "always",
                "unfocusedBackground": null
            },
            "tabRow": {
                "background": "#002FFF00",
                "unfocusedBackground": "#292C3CFF"
            },
            "window": {
                "applicationTheme": "dark",
                "experimental.rainbowFrame": false,
                "frame": null,
                "unfocusedFrame": null,
                "useMica": true
            }
        },
        {
            "name": "Catppuccin Macchiato",
            "tab": {
                "background": "#1e2030aa",
                "unfocusedBackground": "#363a4f00",
                "showCloseButton": "hover"
            },
            "window": {
                "applicationTheme": "dark",
                "experimental.rainbowFrame": false,
                "frame": "terminalBackground",
                "unfocusedFrame": null,
                "useMica": true
            }
        },
        {
            "name": "Mica",
            "tab": {
                "background": null,
                "iconStyle": "default",
                "showCloseButton": "always",
                "unfocusedBackground": null
            },
            "tabRow": {
                "background": "#00000000",
                "unfocusedBackground": null
            },
            "window": {
                "applicationTheme": "system",
                "experimental.rainbowFrame": false,
                "frame": null,
                "unfocusedFrame": null,
                "useMica": true
            }
        }
    ],
    "useAcrylicInTabRow": true
}
```
